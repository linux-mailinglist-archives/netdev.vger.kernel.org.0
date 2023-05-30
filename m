Return-Path: <netdev+bounces-6551-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 902C3716E38
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 313411C20D43
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CDCA31EE8;
	Tue, 30 May 2023 19:57:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4024E17FE5;
	Tue, 30 May 2023 19:57:23 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A9FE8;
	Tue, 30 May 2023 12:57:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPr6d469x9TyFMAIIxz3Ot57C1ARPIG0jcglZcpIAOtE5al2F84XUha88mLRmuILSL91a0ktgGRo5LILIx7DJyIapW3rlWEBNVHzt7KIUtlzdwg/insZL8PCp4vTg8yTpuQx85VHPd0njrxb+AvhH3RUMAwa2oT3P2ubOuFtI1JWW09dnVSKn9oWRpjEM+g3kgu7u8xY2Tu8+VmXRcFHZvUOF5seWf8vleL4ymCpcVcKPp4fqHfjhUnWHz6iinMKuwjY2wNZXNAcr5cQlezFWoxkeJQtJDAu9ccZ8QLuG2TeHVHg8sMuIc8wc0g0U/KEb00LKig3JPpTA+zPaiD+/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dqjl0lDnTlFvG+HPBFEWc2VkR8nthr5Z1F8d/jdNxC4=;
 b=VTlsE4F9UHNHxzZtygvXzkXI/qtsEXSlrgOuKH0mFM0OxG/o2KQGqu4WUV0RPMVmvwwhycWsR74wkSaS7AaheYnYeZcYi6d0jLpkUDQyepD/ukhsKb4ORc8IrEqo54iWGbiM4FEKfvA0TepqVamFki/woz8EDXAYxGa8zbgpO+7fVr1e5GNZuNsLNKgvqrr5HiJVuqGSysJpTKBqWEYvZZK5Lm63+U7miIS6O48AgLnxHuo8KvXyXVztbJpBbghi/2cZRDXd7ZrelpgPNPaJ8BPa/evpjukc3WwFz4a1qSGZHikmLfarEopL+9hITXWQnSk5RR/M/QdLO8r+m0lnoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dqjl0lDnTlFvG+HPBFEWc2VkR8nthr5Z1F8d/jdNxC4=;
 b=MxGgmZrmfm3ojcs/VxjY5Fi/LF80INde7RqtzpeoDC9jQgeA8CCeSsK51EWMUBDzzD8hCLD5kun0+wi9AnrrJMSEUbstTbGImGGCAy2q209PsVNPMCSBCJ+RFV5zecgXzlN0G8CYsRMDlVhybIF4dBO+wwZupYlFIdlclEkYQss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6335.namprd13.prod.outlook.com (2603:10b6:408:1a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.21; Tue, 30 May
 2023 19:57:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 19:57:19 +0000
Date: Tue, 30 May 2023 21:57:13 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, netdev@vger.kernel.org,
	magnus.karlsson@intel.com, bjorn@kernel.org,
	tirthendu.sarkar@intel.com
Subject: Re: [PATCH v2 bpf-next 13/22] xsk: report ZC multi-buffer capability
 via xdp_features
Message-ID: <ZHZVGUJ3ROybmBJj@corigine.com>
References: <20230529155024.222213-1-maciej.fijalkowski@intel.com>
 <20230529155024.222213-14-maciej.fijalkowski@intel.com>
 <ZHXkQX0uSh8tDFTO@corigine.com>
 <ZHXsmDhfw9hxjUCe@boxer>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHXsmDhfw9hxjUCe@boxer>
X-ClientProxiedBy: AM4PR0202CA0007.eurprd02.prod.outlook.com
 (2603:10a6:200:89::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6335:EE_
X-MS-Office365-Filtering-Correlation-Id: c3978d25-2347-430c-d14f-08db6148136a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ddbSc+8Lb9OzZXyC81Mpw6ZS48qCPucLISGWfCB2oq512Sw9w8qp/37crPPNMdllalRfN63RKwf5AEGWLwmTNT9lg7pvxTylYCDAF+pMdSpaH4RWPDPDJ96FLf5Fnzj2RFH4LEMcMHi1WI26KBzbNHrOhoUyLBNSs0Ax38ub8b8jUe7LZYxRIZ9lCrOeWapEmDOqJYL4sIwdPAqsgwjtvUbWQ31Eq8wx9zixjQkTa62zoJBnT+U4+YLMy7Xjt0XwZbFO0LhSuV6nbjpqNpb0GiMfL8VWj67OP1kV6ap1dGAkIh6Jf97A56EIPlcw99kKaP6htO1zmb/vfHqTsQivO87J/Yfcd0aUKnlkxrzSv6pgPbitXSR067jOnCoFDaEeM2G1Mm7hNbel8Lpo2hdIdNw6WJ4Bty4y0jL30u3kFML+8wyCDprVqTqtt8r7aj+zpz4OAOWXb0ugJ1yTtFNWXiwbdMQ9EtpD4Dm2cMxLTC20vlP+Avwl030smw7+axVDUUfawxUXwQmM2/hahr8q88IDs6kglKHn5y71x8D3yrf3hNCl69RYNom2FMG3cRcRcJUf3ARAKzCvdzFRtpyJiUPxve+gpsoKKwOW7h09geE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(346002)(366004)(136003)(396003)(451199021)(6486002)(41300700001)(6666004)(316002)(83380400001)(86362001)(186003)(36756003)(2906002)(6512007)(6506007)(44832011)(8676002)(5660300002)(8936002)(2616005)(478600001)(38100700002)(6916009)(4326008)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k7zxZV7INlOV6W64S7PBiwA9rRi2rGlMscoKCzxhbLSw2CpoHj1v6i7y27ws?=
 =?us-ascii?Q?NP8X6TvMHBK1wOTmcOWyqlGv/82UHL+OjSSjXEMhYDgnjmnZ5b10KxBD3pKs?=
 =?us-ascii?Q?8kisIUGFzEGRCcMtvDO4awF5vTCgnpoZtVNYlVnWSZP8nQY7EF19Y49jFYyQ?=
 =?us-ascii?Q?vUTFQwWkjNfes4M8RPlG3WyIcq+304gGlZZMl7GvsEPsyfCwZW1uJyvFNext?=
 =?us-ascii?Q?GCMGAn8fjCuh7YX2gh17cgSy9UrOhm02tuLNUrWmxO+pKDw5XN+pkzht6j/P?=
 =?us-ascii?Q?1vPJo5COBSUQteosyBoqkxXZSiY8R+33wXZHNl0ygLhMCx079XOjDW3lqtjG?=
 =?us-ascii?Q?2MgiHKDAh8hNKXhYQ8HkWpuaaL4yTM6UOmGP4OhGYzKat6Kd/Djcyti3sbnY?=
 =?us-ascii?Q?lZ/X8Jdd469z/GKnE2yVLDczCSBTJbD6myEZCpUw73N+TbLKa2rNNfY7aOJ0?=
 =?us-ascii?Q?+uCW16KPgCq8BYYVc64FwTgG4SmjlD/1ZDXm6K+NMVcPrpFjrPCq+j3LShGW?=
 =?us-ascii?Q?Abgdu8rJ0ZWrWYZZIBjy8kF9TdNO+Maczq87x0gJ6aJWFJhAD4lGkuptee1d?=
 =?us-ascii?Q?eJnOh8QdNljrq0eN5ZyXxisNYsc0EnS0J3QcuPBKKWZk59HMwwmRa1fIqeJ/?=
 =?us-ascii?Q?rcT14T+jP8kMI2wdoWO/YqpRRQxyj7D0w6bUCUlgeKA5wQUNg6i2EHQVahre?=
 =?us-ascii?Q?zrBdD8dzWSIpKXyjxGq5ApB5ygDwJM6/yBsWGxwu6q7Qwhc1gqjciWAFqIeu?=
 =?us-ascii?Q?8CQ99v14zwdSYJrPF4G9XUaxXy/WZzxiyGQywr79OKLOGSxC3F0yAyOPQLdd?=
 =?us-ascii?Q?qIjPhsULdnokezzrHVOyFUunSVa3wy48eYbiZI6bFHkUv/tdRCt78/kxubN6?=
 =?us-ascii?Q?YMh6oWoBipuEC/mf0Z0s4MwqezziptpkZb2DzoodaLDhiPJOn5b1LTfd7kdb?=
 =?us-ascii?Q?NpVVaOAY/ijBU075rHlrzipOY7Sywxnzyjr8bOvrf95E1tL1Iabu7S0Yxwgy?=
 =?us-ascii?Q?J1pNgVYoxOwOCcvKczgsMoYkN+uPM+JoXNnJyA+7ORj50m1mQzarThZf2yf1?=
 =?us-ascii?Q?KG1is6NPr2DlVRyiqnm/Mpqon1LDcqL+weszZQfO5xZ4aP2OCgWRB/sELehe?=
 =?us-ascii?Q?niRmtVtEguxnCkX7wTZRz/JOuftKYZRsHTtaEesOe2e6IO20dnNzM/ArpdGU?=
 =?us-ascii?Q?KhXf+K+2oPc0jj5ooyxlhoIEzJLL/w5L8lhpVussBRrVYJ/3WcPU6x167xTx?=
 =?us-ascii?Q?WCvWdVqFY6vCik+aBLHXGQXx3qfaHGgWWMab6ChIc9V60rkH5wPvxRrWOHq+?=
 =?us-ascii?Q?oec9C28vG3UI0ra20ZHoM0puDM8IUBVja5pnsxo8EAS54xnps1oeMp0d4bux?=
 =?us-ascii?Q?2+5Jlr8OFa8neqwKD8Qh4vJMvzyoxB+nsJ2UEjzAX9Mqs+w2hgmyN0ARSFPY?=
 =?us-ascii?Q?G9oYnwNAjFBAXkT7ioxWBRBU83/G58abJraq+0G56zlC7TsSXI/RRuTJVAvV?=
 =?us-ascii?Q?nm9mtDGRb04ZjJqFdIWUexwtOuWFMS/yh8N1n65OgEoVYlBLBBMWCRlGaS1F?=
 =?us-ascii?Q?4uPRM9bqKc2dyvCDk5wfBsbRPRnfAPQbWqqxBFTbGjlN0Z4wHn9wJFNnX0S6?=
 =?us-ascii?Q?GhKlK7o/F4zHrD8CF7JhkNXs0UzMpBMgJX1rrtdn+l8xffNvavhTFoUh2v11?=
 =?us-ascii?Q?6oU9Fw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3978d25-2347-430c-d14f-08db6148136a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 19:57:19.6311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vr6j51PnOWMydt8uvOeLOz+LVZIc7B5XZPCcWqd4fvW2j4iPR79Lc7oCov/Uk93nQvu9PYPcYsGItj0Z6OrmSxQgTaYPsjRWfXN5mx3EL5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6335
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 02:31:20PM +0200, Maciej Fijalkowski wrote:
> On Tue, May 30, 2023 at 01:55:45PM +0200, Simon Horman wrote:
> > On Mon, May 29, 2023 at 05:50:15PM +0200, Maciej Fijalkowski wrote:
> > > Introduce new xdp_feature NETDEV_XDP_ACT_NDO_ZC_SG that will be used to
> > > find out if user space that wants to do ZC multi-buffer will be able to
> > > do so against underlying ZC driver.
> > > 
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > ---
> > >  include/uapi/linux/netdev.h | 4 ++--
> > >  net/xdp/xsk_buff_pool.c     | 6 ++++++
> > >  2 files changed, 8 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> > > index 639524b59930..bfca07224f7b 100644
> > > --- a/include/uapi/linux/netdev.h
> > > +++ b/include/uapi/linux/netdev.h
> > > @@ -33,8 +33,8 @@ enum netdev_xdp_act {
> > >  	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
> > >  	NETDEV_XDP_ACT_RX_SG = 32,
> > >  	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
> > > -
> > > -	NETDEV_XDP_ACT_MASK = 127,
> > > +	NETDEV_XDP_ACT_NDO_ZC_SG = 128,
> > 
> > Hi Maciej,
> > 
> > Please consider adding NETDEV_XDP_ACT_NDO_ZC_SG to the Kernel doc
> > a just above netdev_xdp_act.
> 
> right, my bad. i'll do this in next rev but i'd like to gather more
> feedback from people. thanks once again for spotting an issue.

Thanks, good plan.

