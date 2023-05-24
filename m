Return-Path: <netdev+bounces-4948-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 633A270F547
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:30:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B3CE1C20A3E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC9917755;
	Wed, 24 May 2023 11:30:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC33C8FE
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:30:34 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C2E1B1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:30:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZMErTjmfxzqNNLrjvWr3yHdGmkcgH6R7qIEH9EsyOB4+Lbl+ewlVaRagxCvawJPV8IkU8h/OOlKk/1P870qhfWtw01OS4Lygtl4DS9DjPFR2dRbtrHsANIWbr82fuke7jHgcOzhLxw7w9e9xH+3Vo5udelZUB64WgbTFHwPtAm5RAMTwVAX0RCNkT0wVJLDXBRsGbxdHeZ4Ne9wvxJUA4GdQrveUB+e39GcH4NaCNCCAGpQaxGmUz8h/CgmSPEbT4b+ajuk0d1VZDhwsvgOdzv4I2c679egnCvFPRJYZCg589iDGIhhcii4CdsbeBT8xmtxEI12so/NMSyS7q9a/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ktgRGtUBAncimwJwoHmKf4I+CfyQOQYdKvt2ha3EIT4=;
 b=Qud5EP1KyL+s0k0Kl2leozTYLmg+THKmk9cR29JH2rbHOtiiom0Wibpz/A9dn6XTJe5qAxLnimMGEQP2Ra/0XEqwSG5ahGNlxFqb+1fbu1IStydXuVXDLm1kxXZEXBfsTWY0o2Nycp1zR7Ih07TZ+s/Ip4phsIOyulg8n4myiMsnPPsFDcBjPYEwv6c0AI7/rIvF304rmeARQUjiUeQdQkvCxFRrKaEh63EsPeFsgxmypYgVrRgABZhm+GDpLvMINGX11NILKr540Z7kwMu89XZw17X7l9OHzr3UjR+mRDfphgA671u3uisD6T7rFCnpSq/955uQ4JEtDqzrqgzUsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktgRGtUBAncimwJwoHmKf4I+CfyQOQYdKvt2ha3EIT4=;
 b=hmzs7TQcMfP6DQqDsI+qN/mJUlMDT5P4hCfcAVx8NGiCkGERcTaUdo/Y5GpehX27Tp8lK7zxE2xnWYaG+OAXxeFJwGifjhTVuDMzlif6FXBm8WCeeMuZyJgfL10wmJi5M7jq8RVT3v7R5dFKski1OwUOrhgP4fWqFe2drCql0as=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6296.namprd13.prod.outlook.com (2603:10b6:510:237::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 11:30:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 11:30:11 +0000
Date: Wed, 24 May 2023 13:30:06 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>, Louis Peens <louis.peens@corigine.com>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	oss-drivers@corigine.com, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next] nfp: add L4 RSS hashing on UDP traffic
Message-ID: <ZG31Plb6/UF3XKd3@corigine.com>
References: <20230522141335.22536-1-louis.peens@corigine.com>
 <beea9ce517bf597fb7af13a39a53bb1f47e646d4.camel@redhat.com>
 <20230523142005.3c5cc655@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523142005.3c5cc655@kernel.org>
X-ClientProxiedBy: AM0PR01CA0078.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df64da9-595b-4490-210e-08db5c4a3c91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sN3HvUP30tr9UoSQ8E6EDPS6sd0kJauFjND69fEZ8gq8LGLsTQ3P6PDETILjV0yMjKLMfV015Q50QVK2HI1sfZ52hoeQ7DAuGgKIVx39Y/fjHJR8L67s8lMblTiN/8zimKl7qT4DY8GO+8jyPDEXHKlxcT7s36HuVlwfIlQr/4+fSEKG1ZHsqdUFxNTrwAV+1ung7yWnklKkT2TgEtv4A4sTrzsUAFkpR92IusgcYZqqKdt3GoZao4+gh2GKwWPQ5FxRtHtXtOro4ASTjRAM2ksAVeLEELwT3JvbFEjIBBKM/plQuL/UNh7tdo0Mr+a91R6vgJ9Qwv1oyYxmQ8U3Tr/wCVqe+C0uVhvokuA2LVTocVtxSyQ7UVbu1phIPHHZLGgvs7490EkhfrGquFm7yNYcfVXYy2ZYH4oyiA+YV00ma2g4+RqNhE77BYKDYGe1p9T/vNLMXBK6QbjqDZFC5NNh7+96jYRh6bfNSVlCxuiMKk7KibwVsBDuCUCWwccvhqqxzSClYQKHiWY5gumqrrvgJDhAO0ho0gk+rpQ+DWw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(346002)(376002)(39840400004)(451199021)(966005)(2906002)(2616005)(6666004)(45080400002)(6486002)(83380400001)(478600001)(66556008)(44832011)(66476007)(54906003)(8676002)(36756003)(6506007)(66946007)(6512007)(8936002)(186003)(6916009)(5660300002)(316002)(4326008)(41300700001)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BBpjLzlW79p/TKmdtelNh1gteaRDwf3A95mYBK7fPz7RPpKL6j+z+DpDqlH9?=
 =?us-ascii?Q?wSkdVLMeJDH574Vj5lAibphK1t+FJ5RfyI03I1CSwfEoquM2zOmPCOUGznXu?=
 =?us-ascii?Q?RNXYxg/oelDeb0jjihMTz5XFx4UnJgwfbU2bnvPv4UWfWZ81x+b+OREqvaDc?=
 =?us-ascii?Q?3jtcO29eWEylzgg/0iRbmJB6ico11zfwYhw3b7fB3NSPBAThXpjVJjS+/vvT?=
 =?us-ascii?Q?Jx88Zvu3hTAyDM4ZyL0iHWgp4iUvGjE8GQUIG98KmK3shjFj+W2fOHS9vhTt?=
 =?us-ascii?Q?dF55sF5rVCXoULQYvDgLVxSyEPbNAibQ3A4+Tjz/vmLXPAhB2Vm1vT3xKiru?=
 =?us-ascii?Q?Za2FdegCkhTGbs/2/Et1+1nFFG+q9+gYBMhU0hyE9vxCapGseAGO94OHwaDE?=
 =?us-ascii?Q?nlTfXA983aoLfdviWanROqP93yOti9At4+qGlXDczXLW1KgBx91jl3LM1+n8?=
 =?us-ascii?Q?mXpFcamNT9uSN8cE/WHgdj5JkuAtj1w0Nh0pr2AoT5RfnNwYLhjrdMxrKJFM?=
 =?us-ascii?Q?WUgMVFK8F1gEKENbCT2vhT2R/AJWrF4ldQhrKQlZN4nbAYF7QmvCex/HgcA4?=
 =?us-ascii?Q?UW8HuBZvDRujUoy/IG+iQ7+c0ssnTwpDp1KiUUe0xbCCqE5rDkI0Wp5laN5t?=
 =?us-ascii?Q?0d+96MV/u50pAER+uMlB314+M6c0j6BX75v+ooZtsMt87m2Ko+5IR9e4Jgyf?=
 =?us-ascii?Q?cMhX1tiIWHiIBK2zm0BVSWvH2NpkasPCLoa+lUVxYXvRbuhgthtz2dZZHC+n?=
 =?us-ascii?Q?20PLzS4bNrKU28FrQuxE3MI1l/1zu9dV/rTijp3vbVVKhkVV3U4lnQZ84SWN?=
 =?us-ascii?Q?UR9PPG6xe+zgtHlmcXiATGWbSRXtXmdseNp3OS8m+c10sU4tJiz9enuQ0fYH?=
 =?us-ascii?Q?i6QsYr3fLFRS3rT7BJtXnZQKIZAFuoumtrq/1I5F1WJ0Dzk6hTBuKZfwv35H?=
 =?us-ascii?Q?6TMuODDUt5VeWl+As8qF+hyA4qNDwh7HWmmbG2l15F9ExKKJh+WOO8qv31nk?=
 =?us-ascii?Q?eBbg1IsnEO1p75wkF5KPQpfAjkPtDUKVfirMWSGXHxJF2zIQLo7710x/ioXh?=
 =?us-ascii?Q?djBdyZE0Feyh0tFirAzPaht7USmnRPhJVnWwJj0BaIOc4ahqtiChngcSLnqU?=
 =?us-ascii?Q?g86myiMGkpSV4kfcVUke3mVegKScFoCdRPpLORGMPNWzDcxfl2TwqnJ5Z9X2?=
 =?us-ascii?Q?gUaPemOxZSEF1g40ml/OnMY35xK5yfHr3NfWXPLNuvXP85J7qbORUPTcrVzo?=
 =?us-ascii?Q?spX+0MCxV1Xs/81lql1kzj4dOH+r+gUEIo63WDVELyWtrU2CQkYM3M3C/OyN?=
 =?us-ascii?Q?kPs4ZHgHCuyL7MOSGhKLWjqvPJR7A0fzzNS/04nbctw7meuTsjZbC5MqFs06?=
 =?us-ascii?Q?zjEGfLXOvvsQV8PYugJ68CoRAncSThZ1jJyGl90yo53hS92Mtnmz7o+ZVrMH?=
 =?us-ascii?Q?qqcvYLZphVRlC3F2PSV2J2NDQSJZxfl89V6AEHXoIr3OTdTbMzgSsOJTuI6B?=
 =?us-ascii?Q?GRRyik1oZxK2gX2+Q9Sp3c1oTLEnHD4VSLGB8MdBlJh6eYzIldcIH8uI0Ruz?=
 =?us-ascii?Q?mD4lUpMa2KIPD66F9toCq+27EzyEpzfiym0o+AHHn4Ub+3yAcFazKw6jD+f6?=
 =?us-ascii?Q?EhtYpCeYWYEJGBP0+TTCQRbyiP1Lm2tbuLgsLlpLZXBRuCko92MY96dxYLDT?=
 =?us-ascii?Q?cDAdFg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df64da9-595b-4490-210e-08db5c4a3c91
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 11:30:11.8075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhNMnIwDgzvouMAJXWxoaU3FRZoAaYVZE58cOwMWP9mfFIFz5Fzo0gMfA2zLCS66Ejxuka87nNkcBfzoC291lQaC6V/zknTPWsRKauOgwOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6296
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 02:20:05PM -0700, Jakub Kicinski wrote:
> On Tue, 23 May 2023 12:49:06 +0200 Paolo Abeni wrote:
> > > Previously, since the introduction of the driver, RSS hashing
> > > was only performed on the source and destination IP addresses
> > > of UDP packets thereby limiting UDP traffic to a single queue
> > > for multiple connections on the same IP address. The transport
> > > layer is now included in RSS hashing for UDP traffic, which
> > > was not previously the case. The reason behind the previous
> > > limitation is unclear - either a historic limitation of the
> > > NFP device, or an oversight.  
> > 
> > FTR including the transport header in RSS hash for UDP will damage
> > fragmented traffic, but whoever is relaying on fragments nowadays
> > should have already at least a dedicated setup.
> 
> Yup, that's the exact reason it was disabled by default, FWIW.
> 
> The Microsoft spec is not crystal clear on how to handles this:
> https://learn.microsoft.com/en-us/windows-hardware/drivers/network/rss-hashing-types#ndis_hash_ipv4
> There is a note saying:
> 
>   If a NIC receives a packet that has both IP and TCP headers,
>   NDIS_HASH_TCP_IPV4 should not always be used. In the case of a
>   fragmented IP packet, NDIS_HASH_IPV4 must be used. This includes
>   the first fragment which contains both IP and TCP headers.
> 
> While NDIS_HASH_UDP_IPV4 makes no such distinction and talks only about
> "presence" of the header.
> 
> Maybe we should document that device is expected not to use the UDP
> header if MF is set?

Yes, maybe.

Could you suggest where such documentation should go?

