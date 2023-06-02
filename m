Return-Path: <netdev+bounces-7376-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C56D171FF4F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B1862817DD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADB518AF0;
	Fri,  2 Jun 2023 10:29:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7774B18AE5
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:29:22 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::600])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33DC26AD;
	Fri,  2 Jun 2023 03:29:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5LUgpo8MJ9mMuMOBTZIDaTvW7kshjs4J5twV19adGcIUBzHiR/dcNg5x8cZnBV49aUPM7mAaxjo86CN7YKGP2tKJxDFuWfVt/wcVsHq7V3663AvECJiH+lg2eTn/5TgJYS7UDcyAGM50Stfi2gUjT4ResKPtPMkPOWBjVllRM6N86EPer+go4m97ev/9+HcSut0Wju7w/AV2Eofna5L0aOZGkOpAFPbTWkn9TfMvK7gAzIL1oZLmG+uAwewGSN62LytOeMZ1YKKnpFOQywcQQFqHZh6UzShNf9Ln4JgSTWHggztzflwrNoYAr6zGlJBWqIUFsLOXu3Wa4pHEtb5kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=puJWRlCIEz6i8wuQ7uDcHw2oDmFUKLq4+NyUVEoxc1s=;
 b=EDm3O8nhpfxAxw8KRhqO0ux7dhdpOWnhvej9Ga/t4zHcFscY0kjrrr0OSFleVz1rBl23cUzyUa4F/MHhdGmPCPA6i0xZvWKkmg50Mj/ulI0xQ4CovLVNwfEAd61Xi0b39u3KIQnCZ2a13cq7S0tCwigYaUuV8opv8e/8fs5yhme5HmMDEPFOXg/nr9brkK6TKzlkHrXMZuJd7yJPd20Rx+ZJei6ST/IrRBfxRi6LZ6EFolYJM0JodpOQmxiC953akWdvLKT49iqWMQL0xU4gYo9YWlo4x8Glm07UdF+n7EI8lkKCpanYCHmfN6nuqueHCzMG6nYL3kcDukyyDj0mhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puJWRlCIEz6i8wuQ7uDcHw2oDmFUKLq4+NyUVEoxc1s=;
 b=iGamRLv1e1ctO10N0VKrXYLPTd+P2K6nAHJA4MEnf/Hqf/O1zXAnfWYok8Eu8Svjp2Q9IlSeTAvbeCBSkxuJ8v3q70nI2wSb02OJF0MxRAvCeNOQ7rF/G5wkNbEb/571Jj548CAeBpiGVYOpu4Jd5jNSRnaG/Ml0tGz4w1MtBE0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB9306.eurprd04.prod.outlook.com (2603:10a6:10:36e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 10:27:14 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 10:27:14 +0000
Date: Fri, 2 Jun 2023 13:27:10 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: wei.fang@nxp.com
Cc: claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.or, pabeni@redhat.com, ast@kernel.org,
	daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: enetc: correct the statistics of rx bytes
Message-ID: <20230602102710.vnfh774wkpt7rclg@skbuf>
References: <20230602094659.965523-1-wei.fang@nxp.com>
 <20230602094659.965523-2-wei.fang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602094659.965523-2-wei.fang@nxp.com>
X-ClientProxiedBy: VI1PR0802CA0022.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::32) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB9306:EE_
X-MS-Office365-Filtering-Correlation-Id: b53793d9-5b99-4e16-a2d1-08db6353eec2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m24eJ+E2qrlqfHClFU1YKAcD3PSkZBdT1ZjLTKKM33Ij4IIDnntZGktzysq831BOXJ22RaE+xMJtrIvzi2k2CvIcI5Wp4NudnSeUE7zr/KT8GRhoqcjuiguKHnTzoOx9n7zSrb0t/jUmOioig8cvw6gQ7D+f5yfhiFXd7D1HM8zDvFbwAaVb5rIUayxVTsxmhQjkfEulEXNAsMq9/+dmXcPqHnz7lgyiTPBWZpPM94EfwaivunCrVMyBW9/p9032cCbgoqXLHkKOJIGeIV0jtDqd8DYzbfdFDFlp7+DOap5q6xMnF+2MWNDdkDTkZ8vphqySOqB0E/FK8VvcrUJq0vRziQAOa1XOVgzQFkcNNsLyWE3LUHDArOrDXHhxBkPZQFS8QffQCDzA08nw75eRNcIfXq8gOrh1w9ARYDnDucdg/UsBGST+91ghAstxi7Y4uwVFcoEfekkFiT9Nv/8BT/d67lPd8Jh1M8ewBzEj3RHQ3MrwzH/SWJWYGoK5oGOv1uzo/PeWXBL0SXaaJpAEn2SlOu7L+7qgSFaY7k7ZJ6KHWs9VQYzHagsXt0YLMAj2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199021)(6506007)(9686003)(6512007)(1076003)(86362001)(186003)(66946007)(66556008)(66476007)(6636002)(4326008)(7416002)(5660300002)(8936002)(8676002)(478600001)(83380400001)(34206002)(2906002)(6486002)(38100700002)(44832011)(316002)(33716001)(41300700001)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f8U2XMihDxTQC1CW0cArb0VPY8vcvwdkbgre8XUqglsSyWvwJvNSdifSOQ13?=
 =?us-ascii?Q?zuvu+4zQUfUhf8LEP3E9NmcAJf3NssZlvlEY2cOL8W6vAZR3RM4sKRY3kQ2x?=
 =?us-ascii?Q?VheQzIYdluLPy2uMa2HB7GqbCoOIn9VHQy0eeQiOLb/8ni+Y3fxu01h8wdEo?=
 =?us-ascii?Q?mTTzGanzFWodQ4BsmbF/UAUtNc79yPuiWRpi2XkWQ8mis262wzfY0TX3DOB9?=
 =?us-ascii?Q?1V6FaFFpIkUyf8CgYwjHwHZQ+RHR6lEyFNBnoV0VjbwR90YUQqcnpZzyhIh6?=
 =?us-ascii?Q?6I1LMrfXRIbd3WVKoMl77CWKbZpAWHPZqzVjHg4I/sTsOUWnco68lETdd1Pd?=
 =?us-ascii?Q?lQYl4ub3ZvSO458HulwK4YSx3DSxsBc48Rsu23HtEXZ1arorR4oYWEhiFEJM?=
 =?us-ascii?Q?kNt1u0S+bL9/unWDYgQ74rZ0sc2Zay1YB2yic6nUTgCZUWE+swHPYohCkDWl?=
 =?us-ascii?Q?Y9sktuCEOgJP727JDqLSSZs5xRGSpUN+9h9k78mu2FmXoPXqp7bkqnhrI4TX?=
 =?us-ascii?Q?Qi4sPikOQLnMkwW4e9jr/02R5rX8dGQXJefpGZYEkdClrn6equ6zB1xYuqZN?=
 =?us-ascii?Q?djCmgFHjZdo8fL+Wedp0+mZ97kSeSQfywjInOlgurl/NlB+Ozl2twzzD4j0O?=
 =?us-ascii?Q?DEPJxIk6AHEz4EfQ401bzxS89L75wLlb934rvZCHX4tVQRaqkJPFDnhPgZg1?=
 =?us-ascii?Q?3WZ+ZA4D2V1R1yrcPJ8eiz4I30/2e3NCcLE2BOxrUipcg3KM6Cexsof93Y30?=
 =?us-ascii?Q?iEQEil/AtfLr6tI/69oj4KicTfBTbS1/SQjUVWriR6ksmRK9pxebJYJNvBiR?=
 =?us-ascii?Q?KCTKppAXVZ/BOQP/ieAcIbc/NhjhrI0cVOxZAveJBurQX9kYASQ9cqYAIfzW?=
 =?us-ascii?Q?BOwGaNAJmhBeg5A6MyxLbCilO7RHjW1yoOmAXPRlZmKr5Rp/KyJEn8ysVBoB?=
 =?us-ascii?Q?oXZ8+VVCa3xBN5iCtSMnjqJkn/X2jmXyzLP+frl5bg53w45kXG1ZJs3qoohp?=
 =?us-ascii?Q?Di+h7D2hpLmApDnebSJgYvR1UHExrnIgsWWYAARO0BMLHqlqqPmssdp3A9FX?=
 =?us-ascii?Q?qiU308PvQAxpVWL+NKWDL245dVPX4agBlLSK/rLGqmH4RkTN/afnIulrXdOy?=
 =?us-ascii?Q?3pTE9QTzX++XWsv1lNr9xhKstNFDHQZQH1xN8HixiKpEIJkSBk/B6wR9D/HM?=
 =?us-ascii?Q?T2jXqEO4d4Boj9TjrZqnW+5ZNfpwp1PKbzvg3Wd3RReV6JXvLe+ikx5h08rq?=
 =?us-ascii?Q?RA2VOdACmKssZyAX+9/kvgbueAvbZqlELq4pci/21rNbPuCVDQUJdAci4QQQ?=
 =?us-ascii?Q?vsQx4P+8AjndYYt6YQkLiZ+aRhqjHeZkPrcRlsEu9ICvPXoFReGo+0x/OaX8?=
 =?us-ascii?Q?hMOydqp90uAKqVKFDnMac08uSkDtLz8Bn+Yb3u4UyXzgDIXbc4o2Fac02yHY?=
 =?us-ascii?Q?1HENjbl4UtaB54JQ3fiyNgpnA6KSrVI1E84AM33pfwd43MsIQdCVfH1xj7gr?=
 =?us-ascii?Q?U/yfY6orLzqUZEpn+60ah1Acji7qaJSN5784vjQz9/mbdG8/ljyj+bxl7pyU?=
 =?us-ascii?Q?DXc5OoOc3Us2eV4wy2yeTMQ/8NUzLvu1XC0R8YF074riPNYOLCNCIJoB3J1x?=
 =?us-ascii?Q?Gw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b53793d9-5b99-4e16-a2d1-08db6353eec2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 10:27:14.3553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dMEMxk0QxpKBNl4rUx22b+j5Hjy9wZ651O/WGDrBoUgoFwL5ol3e8TdBmQdRUnaBM7O1M+7MdZnugYH1X2nHGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9306
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Wei,

On Fri, Jun 02, 2023 at 05:46:58PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The rx_bytes of struct net_device_stats should count the length of
> ethernet frames excluding the FCS. However, there are two problems
> with the rx_bytes statistics of the current enetc driver. one is
> that the length of VLAN header is not counted if the VLAN extraction
> feature is enabled. The other is that the length of L2 header is not
> counted, because eth_type_trans() is invoked before updating rx_bytes
> which will subtract the length of L2 header from skb->len.

Thanks for noticing the issue and for sending a patch.

> BTW, the rx_bytes statistics of XDP path also have similar problem,
> I will fix it in another patch.
> 
> Fixes: a800abd3ecb9 ("net: enetc: move skb creation into enetc_build_skb")
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
> index 3c4fa26f0f9b..d6c0f3f46c2a 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -1229,7 +1229,13 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
>  		if (!skb)
>  			break;
>  
> -		rx_byte_cnt += skb->len;
> +		/* When set, the outer VLAN header is extracted and reported
> +		 * in the receive buffer descriptor. So rx_byte_cnt should
> +		 * add the length of the extracted VLAN header.
> +		 */
> +		if (bd_status & ENETC_RXBD_FLAG_VLAN)
> +			rx_byte_cnt += VLAN_HLEN;
> +		rx_byte_cnt += skb->len + ETH_HLEN;

Hmm, to avoid the conditional, have you considered adding an "int *rx_byte_cnt"
argument to enetc_build_skb()? It can be updated with "(*rx_byte_cnt) += size"
from all places where we already have "(*cleaned_cnt)++".

>  		rx_frm_cnt++;
>  
>  		napi_gro_receive(napi, skb);
> -- 
> 2.25.1
>

