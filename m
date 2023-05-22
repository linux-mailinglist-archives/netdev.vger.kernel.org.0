Return-Path: <netdev+bounces-4228-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D123F70BC00
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41551280C04
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58335D2F0;
	Mon, 22 May 2023 11:38:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469AFBE5D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:38:59 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2105.outbound.protection.outlook.com [40.107.100.105])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F8197;
	Mon, 22 May 2023 04:38:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvggH07zSfnYCf8G92cRqxvFFxRUH9IQoTdCg37SLe/oehFtww3zJRvIRI3k6v88pWRYc5dq74QQaTUJ016ZnRkVCF1po/oMJGK9kfw55MgaYAtNe76HDGBjYMgZIJtdw6aUQM06Aq+LQQUgM5YFME0wT2TaruQ0yAWNtm+mTW9dFgh15OimzMc6xj6wg46HaTWr+OVkLCiRqBRVWgYWFQdp21DOgPRzj8snxudAQquRGo485DWx8+KQ/wUY9JvRa4ssPpypqlUsNspSM5Y3woa2I9VjeWap5hDmljU4PKinuyyATtwGE9T+GDhBSFVz9guXjConjBbAVFNDNKU9vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Mv4gAkCh2BbPLoCq7mDqs8B2vR9FDJQKAljyorAxGw=;
 b=WI9+fyFPrmiIt1FmFdpWkyalt5II3PQ8WdXWWbipZnryeFLotPvde6SNJUzs8v9fDyxUr+UNP8+F3Q+GbEayeZyU/LO9d8UBnu6QQ7qpQ4+ExzBZr3hqxCNs1Nw1PiRSiEGN4jouyb4kQ3NmY4PvABnU//udxdzELTKYumOL1it5w5kjpLlQ9jK7RzoUfcWKkaxP4cMPkJEKiatZYi+t26H1z3mBmz4wbtJVRIBJLRn+3FJYSGLtuYfpiHFXodJrBnaLUiEIroRq4rNfDfZVtFEny3DC41/dQk7oC0h5RBjxwxEwl2NrWGPk8MrqPYRMtaPBAzCetPYMIFX5R0mGCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Mv4gAkCh2BbPLoCq7mDqs8B2vR9FDJQKAljyorAxGw=;
 b=hIdtJXMfSKp3Fxyfd3XHkgo+SrHBPUM6MO9iXKnek6zqZuAS1f6m7KwgPf99g8YxyIoWgD3tgB7caY/F6RQxKVsrNWktlWedeDLavJhcm+H6HLgcLYG6cIxEnMt1Ef10anQ8f+UxPV90lbxZ7vX8HHzZCzTuMBc5CYaPxqz0v9Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4700.namprd13.prod.outlook.com (2603:10b6:610:c2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 11:38:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 11:38:53 +0000
Date: Mon, 22 May 2023 13:38:45 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com, justinpopo6@gmail.com,
	f.fainelli@gmail.com, davem@davemloft.net,
	florian.fainelli@broadcom.com, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
	andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	richardcochran@gmail.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com
Subject: Re: [PATCH net-next v3 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <ZGtURVrdqz536ai7@corigine.com>
References: <1684531184-14009-1-git-send-email-justin.chen@broadcom.com>
 <1684531184-14009-4-git-send-email-justin.chen@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684531184-14009-4-git-send-email-justin.chen@broadcom.com>
X-ClientProxiedBy: AM4PR0902CA0016.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4700:EE_
X-MS-Office365-Filtering-Correlation-Id: cebcf2f8-acfe-4b79-2a4f-08db5ab91ee0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OMCpb4LcFoDeC3Mk2wf4N55dbw9ICdlWBZLoj0GBYoD3XtMtcpYcBwpcRjivXfLvmsjnl2/9wX0YRwCmPTMTAHvJS7MKUL1/4YYZPTnyxdtYu1iCZLhWEdFKIanaAXg49+T7FnOarF+0HczS51GcNoKaItE2kxFl5FT0xEgNavux6Sq7UdNggagp7Ze9dfk0aa/u3I3G0U5ZtHvBmFIC3Gvvzt5cAbDTe091fT+vAIvHenDMn8fQZRsxF6pzT+iWhTgMDgC5fToaa4jUAOeGjGmPgVAHgpwUM8woAf8WSxlfTXbDNytIIVsS4TvG4rMPybiXYs4gh8IbuIS4fqYyHvNggBVbEw2y0Qk6XCPZnvfNPqahti9kTQUxe3+vi7ZspynI4/7d3hr0vZqqMoVJJsm79a81iNaIJez82NQT37uZYYEETbfmpP63ZHDyXziYxYXM8TXS46l4SCBvSVLagcHItKAdyFoR/3+XYK60fKoTsM224iSDky6vU6E3sLCxTP5WMmyaPORm+nTX8bime4/yfZNT+nCSI9neu+smAXcSLF3a+HJ/5k7Rbb4ud+UIMZsgmereNEJMr7KttIk51D7YTJDoPvMb92oLa02IhiE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39830400003)(396003)(366004)(346002)(451199021)(2906002)(5660300002)(44832011)(7416002)(8676002)(8936002)(41300700001)(316002)(66476007)(66556008)(66946007)(478600001)(6916009)(4326008)(36756003)(6666004)(6486002)(6506007)(6512007)(38100700002)(86362001)(2616005)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PV4dodSeGbVkN93XpPG8pG4kzgcYRssQIgLgSkuhQDAMqIBxzEPFNKQTA07m?=
 =?us-ascii?Q?J9kT6PznBpTTMxYnG7mNbgvc75zL2g1TMcIziJjnGZaTotCgoR2c+Udk4FRQ?=
 =?us-ascii?Q?C8E0tvWM4aKV0CrGEI5z7w0A6fcclrycZqwtbBTjspG7SKvp4G4ylMM/dEtA?=
 =?us-ascii?Q?XD/PsjsGpKi9SjQYPFCsuTSRZ1YByZWUMFgVN7r0ZaueFa/kH9SqcF9OaofJ?=
 =?us-ascii?Q?lnn5V86RbGPyFzsDCWs+ggAyf3UHMziydbOdPBWclpC5cDUM9J1b+LUR6hYK?=
 =?us-ascii?Q?XwGrNVw+Ka55eg5G96W09WbrzLiujaAOSnSZOriW8Wl7VcBcODWy0ttu41GS?=
 =?us-ascii?Q?1MWTSqSiWzAyE+b9ooLF9Ykh/cl/0cJTt3v9eqymGxhcBYC6Ew1w6kAIOGpo?=
 =?us-ascii?Q?uIGxENf4X3e4i0BdFy9RZsheKMZMTGReSNrwGSgqUYxPu98X5q26tqsyumkE?=
 =?us-ascii?Q?IpEX7v7ifzntk2xiCs8wzLZaQ8nXdd4T6qEKvJiySYjX22RotI/bP08Beft8?=
 =?us-ascii?Q?xA0Rn/FUalGIzw1pOhMTvGvzP/Xa2m+YoIHNNpbGje0PbXVFy2WLauzreJ4Q?=
 =?us-ascii?Q?7aVKS1HVWQn4t5DY3mzPyEtAlNrzjCR3PDE+wNaU3Qx2afpb3rR1DdAGkWaO?=
 =?us-ascii?Q?twK+lOO3fHVIS7K8up12cy0M0VWQVmDqH9z3mBvI9uzsHpBRWEtUDd79fmvW?=
 =?us-ascii?Q?6qist4Hqx/GA8Zp/mKnK9HJiMCdCxNz0/FPTkdYO7QM0bfFWUxFbzRlDLiDu?=
 =?us-ascii?Q?sYMT17R9DHzfk5zfyUejvqOtDcgRIJoQZpwgdKtJC7Vee/EEoC0VURZmWDKg?=
 =?us-ascii?Q?cEDTGWBAymd2VzXj8wyPABTgoTsDT1ACIc3glQ/gYf5WsZab5HQsPNP5lWMs?=
 =?us-ascii?Q?+9lgNNBYUluvDo5rlsB5JQ3/j+XyH8nP/LMNaANxU+m2IfKOkqsmvwl3aq5g?=
 =?us-ascii?Q?BR7lWAKW2rZQATzE6i2vVo1uKw1T/yI4HVl6DcCy42svVS2xn7UIQ2WStyt9?=
 =?us-ascii?Q?r/HJ+eq6ZeKdxgZ1HmU+5nuHwK3ZbBaaoDLS+PVdl68bA3L5Wc9LUdXTjYiP?=
 =?us-ascii?Q?4L7m6VZg3OredY/kj6T0DE6oszuNZpHpCgDAlDqHnmvYyZS9tOPvKFvbn+u3?=
 =?us-ascii?Q?KtZ9l8g6kkztI9zpZezYf1f6l4uLIbrg0X6Kb9dBg/zmGp/+M833uBToj3tR?=
 =?us-ascii?Q?kdtFw+LqFQDfwrD3LMNBxtW7XsqjU6CN0BJe2WN7mkmYNOJWYGFTJbuvaAVn?=
 =?us-ascii?Q?zv7cDs2IggmeSH8sBEFKeNPbOU8/nZ3uC4m6S/Ir8LkMbrdGDI7WJynfAmhw?=
 =?us-ascii?Q?TTKvnysQOJ3w2eoSG7J91crW6+QVdXtwxjY7E4qov06Axu1IKkBB3DVcjv5W?=
 =?us-ascii?Q?nKCVufMcGE0KFE1n04HtCR/HNwyXAeh9iSNOqszGKpSRE9aRCG9odovcp+J+?=
 =?us-ascii?Q?6CM4Y4YSWvOu3gWT8pzB9+et8of/+SfJXI73XU907JpF7V1cRZEI5t3JGb+w?=
 =?us-ascii?Q?7Wbg0zWLQeAtlDdq7Scs9jVMNxeFNEnevVKuW4JMfvlvOm4SU0MBG/CMA0oo?=
 =?us-ascii?Q?ZsWEM7V6YcRsBQ1zRABVgbmqtgX6+lUaIifKQP61cJt85dVN1fx0/VqmbYhn?=
 =?us-ascii?Q?++J4pOtpWvMbmoxMkL2r6KOEuxIAVri0fHxjcRI1JMpxaOMOc3RoOmhvG50K?=
 =?us-ascii?Q?4GsP5A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cebcf2f8-acfe-4b79-2a4f-08db5ab91ee0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 11:38:53.9077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NG+iAL61qcf3MrUlwfeHQzAk3riFhZD2GXbyjX6ov7whkOCFejN6romeE0YFKstOvip3g7yiptkcYMrdAtmr4Q9AWVe9QJnkRzOEwnZ81AM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4700
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:19:41PM -0700, Justin Chen wrote:
> Add support for the Broadcom ASP 2.0 Ethernet controller which is first
> introduced with 72165. This controller features two distinct Ethernet
> ports that can be independently operated.
> 
> This patch supports:
> 
> - Wake-on-LAN using magic packets
> - basic ethtool operations (link, counters, message level)
> - MAC destination address filtering (promiscuous, ALL_MULTI, etc.)
> 
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> Signed-off-by: Justin Chen <justin.chen@broadcom.com>

...

> +static int bcmasp_netfilt_get_reg_offset(struct bcmasp_priv *priv,
> +					 struct bcmasp_net_filter *nfilt,
> +					 enum asp_netfilt_reg_type reg_type,
> +					 u32 offset)
> +{
> +	u32 block_index, filter_sel;
> +
> +	if (offset < 32) {
> +		block_index = ASP_RX_FILTER_NET_L2;
> +		filter_sel = nfilt->hw_index;
> +	} else if (offset < 64) {
> +		block_index = ASP_RX_FILTER_NET_L2;
> +		filter_sel = nfilt->hw_index + 1;
> +	} else if (offset < 96) {
> +		block_index = ASP_RX_FILTER_NET_L3_0;
> +		filter_sel = nfilt->hw_index;
> +	} else if (offset < 128) {
> +		block_index = ASP_RX_FILTER_NET_L3_0;
> +		filter_sel = nfilt->hw_index + 1;
> +	} else if (offset < 160) {
> +		block_index = ASP_RX_FILTER_NET_L3_1;
> +		filter_sel = nfilt->hw_index;
> +	} else if (offset < 192) {
> +		block_index = ASP_RX_FILTER_NET_L3_1;
> +		filter_sel = nfilt->hw_index + 1;
> +	} else if (offset < 224) {
> +		block_index = ASP_RX_FILTER_NET_L4;
> +		filter_sel = nfilt->hw_index;
> +	} else if (offset < 256) {
> +		block_index = ASP_RX_FILTER_NET_L4;
> +		filter_sel = nfilt->hw_index + 1;
> +	}

Hi Justin,

Perhaps it is not possible.
But it seems to me that it would be nice to have:

	else {
		return -EINVAL;
	}

Otherwise, if that case does occur, block_index and filter_sel
will be used uninitialised.

> +
> +	switch (reg_type) {
> +	case ASP_NETFILT_MATCH:
> +		return ASP_RX_FILTER_NET_PAT(filter_sel, block_index,
> +					     (offset % 32));
> +	case ASP_NETFILT_MASK:
> +		return ASP_RX_FILTER_NET_MASK(filter_sel, block_index,
> +					      (offset % 32));
> +	default:
> +		return -EINVAL;
> +	}
> +}

...


