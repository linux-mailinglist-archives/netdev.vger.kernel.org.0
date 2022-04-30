Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB84D5160F1
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 01:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354401AbiD3XRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 19:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355368AbiD3XRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 19:17:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2090.outbound.protection.outlook.com [40.107.93.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A8E51E7E
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 16:14:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fR9Y7oF7dzOMXnrMKXz2Z4nfVu5/VTewpNH4pkF2yNtpUYrjtIyoQ3OyOilXt4BG2DWOWhwqfxqAX3UVUfISw02aluSxm7PWNYP9puhi9i9ztO4QxvQK+hLo1UCJxNGEqN0BC0oJ1EImnXK+amQ7TEcLkloc1n28uJ3VsYU9VoPPGVC2rZuJL2kQTBzbisqzpKbQ9KxUPP3tIPSlZSbtcZl5E40TmJFW0ONCW4FFEUg3Hc00rfUPVY1is9t8KYPfvF/xuzpw95YNCJ6QQypomOhyBzypjsltYS2am0SB5YOV4ctHKORkpvCIaTpMU0watX7SjU9CPgmQ3KpoalSo1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUkx6Opyvged9guz3n/IFx2ZPH+JhOP+sG/Tq8tD0eg=;
 b=BeajceCAWDOx1/jkKxnypalNynmFkXdYyjNOuEbdBgdsLZ45oQ1cVDxseh2GSVHFNbZr+TOmpcrrrEy10kDocUdtPny/dBahtDE+bRq+FVP1cOuZEizm3anZIe56XhXZKa3WBHJfuvuT7YhS5Oj2aYHohvg0qraBrP/O5eAWat44E1yXjhJk3FE24DhpZ0aeUSXXm5J8MSue1pzv3ZshTLJoO+zUdParLGcIVKy8c4A+7E+aUrW+HLDBRPRS+n8/V5iULemgTyZZo+k1u5qL1k1lyWohpGHmQC149O778m5/B/zrNT96QNBr8hnnRRxr1XbIvtJTx1JnD5WiKbNS8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUkx6Opyvged9guz3n/IFx2ZPH+JhOP+sG/Tq8tD0eg=;
 b=ZnVUXt0xwJsRRfyKc/y/EWvoxT+57RaiHNIjc0udpGbjaiT0u6ZGufSV46YOgCn+V3bUT/lJTNq+qMWUsOlOnGSDzBfN9lgbcRPMM2+SyiC6mQu3520aZuH5HoRDHLCwY+/KbNaDqL8tuyaX236ndgD5Bz5pi0zYZjhOp3ROVFU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1191.namprd13.prod.outlook.com (2603:10b6:903:43::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Sat, 30 Apr
 2022 23:14:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Sat, 30 Apr 2022
 23:14:24 +0000
Date:   Sun, 1 May 2022 08:14:17 +0900
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next] nfp: support VxLAN inner TSO with GSO_PARTIAL
 offload
Message-ID: <Ym3Cyeksw3c14yrn@corigine.com>
References: <20220430231150.175270-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220430231150.175270-1-simon.horman@corigine.com>
X-ClientProxiedBy: OS0P286CA0038.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:9e::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62abb6a7-1aac-4f43-64b5-08da2aff2a52
X-MS-TrafficTypeDiagnostic: CY4PR13MB1191:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1191F1019B4144E3225BC7B8E8FF9@CY4PR13MB1191.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DdiNlgDR4jmRVJStnBVKyT/YfJBdtAWJwAkyyYve3hNlJgpoh4gb7Ib7SsSfKbqDGFe8QNJ/+ZzO/Q+JV9SU3rzOTUoKas62+N2kPY8hO4OJC+lczAkMN0BrzKjvlbYzfTAJG96roC14iomWmBJ7XztDKe0I234lmT+G9ukJNf+PeYhjDvXKVqD7CYXTzdmNEiDMC83+2u9VtFMNTLjI8BsqAIr44xZTWQZi9SYr/K3Vu1/V2WP1YX33wCOAbiRoIJktJPIaS5QBVOEDLuYqkkKPXnb0j7ectZjnWmLeFijo/GRNIEqGRWYOXHD0krOUGM6D5YagLwWkJ/KtAPEIKisn/ryUbI+70vzH3iGvD17ZoK9B6GrdPoDTScjEjiPPzieAr/5TrLq55+KfGr2sIKzWdXPW3JLWSGLIHjaNn1sSGCMrpCV9KoDMY3B3V15t7mf7WpLaAzjPA4E8gBWiR4XHsTk7T404NUeT3o2yeaP0CqTh4ErTUROCfeCdm782gS7SgcNdCN/Y3VUKLON/DqovPz/s36SfOaodSlYGOBQQtixmumQ++RMvEA6TJyC83yUHg9UxyWj5SzV3w/kHdw05MKcJllkxSwKmvxW3r4A/neSmSCcxFb0OLHA7JEk5/AuTw3xX3y2WT3iOtg+XYLEQdPupYAvNiMSvMMVMg0PIZDaQj28UvXj8jlY6knwCUl2tgDE3UPNszDKPj+yeZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(366004)(396003)(39830400003)(376002)(346002)(316002)(86362001)(6486002)(2616005)(8676002)(4326008)(508600001)(38100700002)(38350700002)(66556008)(66476007)(66946007)(110136005)(6512007)(83380400001)(26005)(6666004)(44832011)(36756003)(52116002)(6506007)(8936002)(2906002)(107886003)(5660300002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JJ//7ecpP8dV4qOi1wzge3gCdXR9AVs9huEVvXeF2+7lRQDSWyF+cZ9yzTDm?=
 =?us-ascii?Q?C2yliqzScb4JtB75EOBQ8MUjBx3Xyixwj4JJtfGtV0CgiBCyZNhSrOns71wg?=
 =?us-ascii?Q?SahOOT9nN4srWUaMowznKTj7Th4mygf2vkmebXOTuCJayDy5kfNv1Nt6yRiH?=
 =?us-ascii?Q?rauWvfTQ+/QqOr5CZvhBiGJKaFmwuTTPHxgaxrc/Q/lTBz+nrQcs8xb+6qev?=
 =?us-ascii?Q?T747WJsUMLl+YlWnQt6XyyEEASDAULbBVM56Y91niF7V/eVXxRjHusEL/CdE?=
 =?us-ascii?Q?N8Xxye1vDbAQnjV4t+IcWXXDYl/DyhrFkvr9ZegWI9YPRVfgZHAldgTe7INs?=
 =?us-ascii?Q?1a7cvEDO1CRwRn1kCZWq3CeJLuo1LmVOTNEbVm1rI0HI3u/zfim9En9scaZD?=
 =?us-ascii?Q?Q5FbNwzn5bxIQkVduI057u4QZ6U4hJPUmT8bQ7/hkbpu0CBI87jpJFr4NmX/?=
 =?us-ascii?Q?gWw8Gt8ctyPVJGMCc716/ka8JdA6Gj671sPfKhc0iCC+KRf1wkI5fJvwnTJ0?=
 =?us-ascii?Q?fFWzXpjEF5pQdrnwUW+6o7TWsBbcf06gtYH3GvJLdUHFDgkUsH8HvCmG0nbo?=
 =?us-ascii?Q?DoYyRbpeE8emoWcVkEy/trb5s0SCutaViQQAcB2pyaNp6xBD7SMjoLqsK2Xf?=
 =?us-ascii?Q?PKthXspYbJrGpV4/ax5CWN3bXu4wcwzzHEhFbhGNnlZ403YmuK5oYo859OsY?=
 =?us-ascii?Q?AQ62RiSd8MBXBjddvNyMnCBRbuE9TNR12LOFv457uHT4v02nfyz5TmtlurG2?=
 =?us-ascii?Q?30XJ6d1S0oK1LJLIjrKrk8QMUVSy8M8eTESywdndKHWsI1OwuKdYTR6q3Y49?=
 =?us-ascii?Q?DblY42I4lNU9BPGvhJ2AA94G2PQ5pv9EervDuwcyTjYVf16+rcd0qR1Kj15v?=
 =?us-ascii?Q?Zby54n4f/NsIrayscda4WkVXY3f3wp1QeKRKXrAdbrgtDaH1dQ40o4TkkC1o?=
 =?us-ascii?Q?Gt8kKXeAG+gCV2rEmUjHG030zuFFAE3k2W7MfTxnkFFSZBC1wfstzSq2psX+?=
 =?us-ascii?Q?1Cp2cAe8QTWfCNX7XRHNfTs9E/ck7kInr53ClzPigto95jGeZJ4srnz9PENF?=
 =?us-ascii?Q?YUFUaH4CEA8maPbyCdlDWRYduThdN+GO3XlzsIQ39y9BYUukx1ogl7GIdiFA?=
 =?us-ascii?Q?EGzI09ArafDd3vXYdzhm63Mk/Y/+K4WydFQr+REra+h7mOG3Yo7/Ua2Sy93Z?=
 =?us-ascii?Q?/0G5GqLsEkd6U/BcVe0LhzWD9RMyMlS1gkn1QCrJnW0iaQOBOXt3zWxWpl52?=
 =?us-ascii?Q?MKCP1lBUtZKcHy+d1VaGHarmF7Qfve+QuaSSuXohpjUeYnHwztZo4wnbb0qS?=
 =?us-ascii?Q?4st1CiFxdPdCwpg4JG2K9v0R8yOrh4fE88WB0xHUXK+UeQ3EzqNzSCH1L06g?=
 =?us-ascii?Q?gjOcwFXm6CFQLU5MbvVNEOnYDLVXqGVxaOo/43VDLUYYMCOaBj9+fzg7r9B3?=
 =?us-ascii?Q?gXrBSHJjvra9F2VNsrRsYrPfiVjQQaMGIF5YXvEqq4ucpfKOiaKoZfOMr4kn?=
 =?us-ascii?Q?fcSSd4zoAkIOVbb1l+ePClpHwJOCDwjH0ScQgXDNN0cCdbxFv6YedHaUffpl?=
 =?us-ascii?Q?mX0E+7oOETXWcnJfgYShzdov7rq1mlMFcVXJWwIBlgBmUDj7MYLJ17zSr0MX?=
 =?us-ascii?Q?iIfKS2EAlQq+65zJJzxI/Etw7qZ0Tvo7sk6VS1aTzsYTHHrylDUv5uKp3LOD?=
 =?us-ascii?Q?N3NaXZrQGPilwF75l4SbMG6nhQnlKi6f16pjvXEu70MDz56orK5C+Gn7506c?=
 =?us-ascii?Q?UUWwmK/09lusVKtGa5/Xe0A9sSdo+rA=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62abb6a7-1aac-4f43-64b5-08da2aff2a52
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 23:14:24.4072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ml+neb0TYIPe2aUTPyUmtc1ULbzlEsSamo7hSZTKpdb5S0RuFAhsozMUq3bnTqzsCTPMQ4pVsHjMA4/RJuwwBZzsCKXVFO0mNlkCRldVd7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1191
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 01, 2022 at 08:11:50AM +0900, Simon Horman wrote:
> From: Fei Qin <fei.qin@corigine.com>
> 
> VxLAN belongs to UDP-based encapsulation protocol. Inner TSO for VxLAN
> packet with udpcsum requires offloading of outer header csum.
> 
> The device doesn't support outer header csum offload. However, inner TSO
> for VxLAN with udpcsum can still work with GSO_PARTIAL offload, which
> means outer udp csum computed by stack and inner tcp segmentation finished
> by hardware. Thus, the patch enable features "NETIF_F_GSO_UDP_TUNNEL_CSUM"
> and "NETIF_F_GSO_PARTIAL" and set gso_partial_features.
> 
> Signed-off-by: Fei Qin <fei.qin@corigine.com>
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Sorry, missed the annotation in the subject for some reason.
This is targeted at net-next.

> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> index b412670d89b2..5528d12d1f48 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> @@ -2259,8 +2259,12 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
>  	if (nn->cap & NFP_NET_CFG_CTRL_RSS_ANY)
>  		netdev->hw_features |= NETIF_F_RXHASH;
>  	if (nn->cap & NFP_NET_CFG_CTRL_VXLAN) {
> -		if (nn->cap & NFP_NET_CFG_CTRL_LSO)
> -			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
> +		if (nn->cap & NFP_NET_CFG_CTRL_LSO) {
> +			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
> +					       NETIF_F_GSO_UDP_TUNNEL_CSUM |
> +					       NETIF_F_GSO_PARTIAL;
> +			netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
> +		}
>  		netdev->udp_tunnel_nic_info = &nfp_udp_tunnels;
>  		nn->dp.ctrl |= NFP_NET_CFG_CTRL_VXLAN;
>  	}
> -- 
> 2.30.2
> 
