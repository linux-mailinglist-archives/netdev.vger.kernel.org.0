Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698876F4A8B
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjEBToO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 15:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjEBToN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 15:44:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ED811B;
        Tue,  2 May 2023 12:44:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CV2F23//MMB+CFRHs+iw/owuK5TTqPgdpJIJrzzGhz3sVirZx9js/iAg00nrmuq/AK40NOn68WLj4bFtWqGoRUHZAZka+Y4/g6VUu67xxPW9kQaaXV8WQ/RkTUV+M0Xn/iiiVh4BFlRaPIUoUpYF3ko3KVc/V9MJMdyMUV2m1wkvLH6QmtV/+HPazOu82sVC2aq2t53Np/ptJ6dvREFcMZqt3F4WFmegm+t5qV/dSVVasqqFsRjGydyRsatn2MMWxgYcfcSI0ZsuRxrynZpeVddqtf9tMr/0mwWFJeLm0TnEdCWV3qNMZIJH96vpL5OsxkDAMWzkElufts35mBfFmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sevXxeZ4gAj9MHyDC/YwIlzyxau7NQUJkL9r8kXr9+I=;
 b=S0nC0JTSUVPblBnPSmYwrZJ1ZDMLH036I/A0tuj+xfenZqX1zrJ+P9JvnAGXFtVyQnrI2asfYqs+DX6CoKEVBt8TU7E1zYVcCbhQC+WWGXTL/pzSaeUE//FWwSPeIhAQEFTOjVdZ+goAC0aE9P1g7G/1Jb8D3CTUFHLl+zbKJCYz4XPlcJYoa0G55DXge6yNkH62E7qd+0kToQCoKpfrZCswj4v9kl3JgxIkX92uFTrX2JduWTbgJSMgYCmIJPKDiy3lsfnvxUGO1z1P6b4UWLoKR47zKPcmgVjzBV5Ffgkma3up5UYWzi3hOLDk1+q//PjEqfu07KzvQ8qICh+pcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sevXxeZ4gAj9MHyDC/YwIlzyxau7NQUJkL9r8kXr9+I=;
 b=eh5Ey218EDZhgMoULAp5IrGfzyfiNYshTtVbmQMluDFfuE7+VJ0oP7ptKFo+x+x69tIvkhmvkPC+fbORv2wHy0xpQ+XrwTjqNOVXJHpCshHwuJ8F5EoxIOB4xvqUf+s5il7WSXi9a+W76WBS0uMn0Kownb+LE7CXHFdCPL5k4jM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4759.namprd13.prod.outlook.com (2603:10b6:408:120::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 19:44:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 19:44:08 +0000
Date:   Tue, 2 May 2023 21:43:25 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Justin Chen <justinpopo6@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        bcm-kernel-feedback-list@broadcom.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Subject: Re: [PATCH v2 net-next 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <ZFFn3UdlapiTlCam@corigine.com>
References: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
 <1682535272-32249-4-git-send-email-justinpopo6@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682535272-32249-4-git-send-email-justinpopo6@gmail.com>
X-ClientProxiedBy: AM0PR03CA0007.eurprd03.prod.outlook.com
 (2603:10a6:208:14::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4759:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e518014-f02a-474c-d5ee-08db4b45980a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kg4lNuCdaybcJ73X0mCOpGBfYF4bDmV69X2yEVkZiZrzugGBk2pr+A3WQMamY6EFUHCBfWf9DbktzRQhaL7S5ll86ddZQRG1O7pzhDjWZXBbp/Khd2gniTnpy77865F5UYLkqvD3yQHpqIEVzPpLWW4EBJlH2JQ9e6OAdMRAVw2ywXif5V+/TFdHf9Rm2CjXYa3scpgQ9q89zFisMst/lHQTOMC+t4SsG0EcbvXbu5EQz0aqlp+KtC2Xn975/5GlcmH/Cw4jGG1SlbVSKe1Fr4YWDvCgRRFidssNnFvwDTNxVQdWtMxlmbxTUPfleHJjwcMQed0ad8rihxoIQckOUqcGfsYHKBx6opvihhV07fcgD3bFJgx67MQsrfeEf34+/zx7Kh9it9toffaeX0vjLFC+rhprVJCFJW42polfH7OjtMMsex/CUP43CBddlS7vSEBLtJA0ivwQgv86jnMf6gmMVOISfpZ9UbiDAVNh6wT9VxkOFm9sqX8qyBSNKHc/snlOFHURfMp4UDGPo46ZHDu0PAQmB2+Emrk1a3isEOIa/OKQ/wmI3bUU2FPfALhWksHHI3slEIbFlJ3y6kpjzV+Cmr6ViPfk7EDD/hq5ZxA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(346002)(39830400003)(451199021)(41300700001)(5660300002)(8936002)(8676002)(38100700002)(66946007)(66556008)(66476007)(6916009)(4326008)(316002)(2906002)(7416002)(86362001)(44832011)(966005)(6506007)(6512007)(186003)(6486002)(6666004)(83380400001)(36756003)(2616005)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hL4PuNNdR2QOsCpZr4CDo/ytjYFG9chMGB7AXy2xixFTeBAFKIvm0shErQct?=
 =?us-ascii?Q?HOtLtbs8810No/sW/pJjsZLiTtgGQYUkpLJKL3cunZoco7ca/PTj8yKn0sJg?=
 =?us-ascii?Q?6p0AkIj7YYJYICb7KaW55XECQJrEg8PXIrLsMmpGuW8yjV6dZGrOfiDHTxS/?=
 =?us-ascii?Q?tnouNXNuwI8xkL3Ak9A2t5sxp5iEBmBdpDUyDeDr9SGsYJD1+yPVyDqzfRUb?=
 =?us-ascii?Q?zesRcTIqRhQHYpixxzJyAL1ucnMJvrVjBRwskFaqdpNlqrcP18TfzmBKuoio?=
 =?us-ascii?Q?+QE2fLaJNuQpNaym6UUOE3AKR4DQ+37n1VF9Lvb0H6qwO3iqLpNK7mKKAroG?=
 =?us-ascii?Q?Bn/2JAPLwNb4AgHXqdGbq7UmJVGsrYAGOVDfq4TiCIM5uikTWkRuLumbGAsI?=
 =?us-ascii?Q?Gp0ZxTkY7DsHbEnS5dydMOP+V9GzOeWhjxQbHOBkIkmRcspSZpuHRKvemJg5?=
 =?us-ascii?Q?i5pLnZD8QgeZxImuICkq8DxAzToEwAfitGJLMx2VWTuUUuzlHgrQqgFGLPj9?=
 =?us-ascii?Q?Qnj1RHhigvy4zJ5feZVs3xOO6HtD1K0l2QGtZ9hV+QgVhAI2yV0V1SfEeg1j?=
 =?us-ascii?Q?kJoaPnetoYkIu7chkoDE7occ/OG3g045J1tYfJASVUD/6jyOH6ifHPnBa/5F?=
 =?us-ascii?Q?MlZOQY3Zd87X5m/5lft5XNpk1v1wsovajNYD5zg8jqPwGpZ1DNH4cbFhBScR?=
 =?us-ascii?Q?FJCJh87cKrnuSAzBw7Ty+vHyasG/9MC7bqNcjqF/5kTklSzMsB5UQMCNLQFD?=
 =?us-ascii?Q?Ifpi3MYEjotSmyQ0JEwdDgY+t+7WJ4tT/FrOvoDTRETvmvw39Ukh2/aGNjLH?=
 =?us-ascii?Q?pumZbogyQ7MTb/q1rDE4jc0Xcg01mAOe5x+qDS37tWaLALwY9E+0FOKqH60v?=
 =?us-ascii?Q?Dd0i0AJc7M+7FoWOzdRW1zHz+UJ1JqvMWhnBNe9IbDFBwPHjhvpBTq226day?=
 =?us-ascii?Q?54ahkyeSPFgtAPlV13UdCKR8Le+Q9iKNAlO+zlbBhLtzsuZm0Q6c/bInxnny?=
 =?us-ascii?Q?DhIUGOyqwwTsizopHim8fu1kOhbX5e/rFrigqn6uEqGGOdAM7wS5yxA2GWn7?=
 =?us-ascii?Q?Ntsmrt17pHBq89cgO2FDUEvnf9Lof0RUR4LyA1/lowtT19kMx4yOKFwAVDsZ?=
 =?us-ascii?Q?AQ8rykuSl7oQx2uvl7YIwG56Nf3PjAYcRWlaOE1slfwN9qSmj6IDiZLabrwa?=
 =?us-ascii?Q?uW+5pXQtWtou7A5mVFo6cRx/SCV0gULX4lufY9Xt7Y5x2XqLfmMLxHYTTAF8?=
 =?us-ascii?Q?SmLvg11J/iLw7sKH2XnUheGV7zjcC2aSnV6knVy9+9OQJsOo54mTAMPMFABx?=
 =?us-ascii?Q?qZriGbNWSihVIDZIN86iFYBTLC+3R1YokTrxqbW0aGzSKJsCWd6rbY07sCKG?=
 =?us-ascii?Q?CD7FlEFd9rjxUrVO1UUmKnpqqLRDslGcAOM9F3lgBW8tfc/G8EcRqm3NdAyS?=
 =?us-ascii?Q?Jxax0lQsrwST2olExAcVDi+2QkOiDTgwXcDOglIC3gzcxMm19yaN8ak9uCC6?=
 =?us-ascii?Q?MoStyaN/Vsrw+In4582DzRDKq7y3G+VDFaOuBbW3R7DYjZ+axz20ute4lxIy?=
 =?us-ascii?Q?6iRAE9bT+S6alfTsxMooMt5izZkOsbp77umLRX24d069oDUMP2P835W4KXK4?=
 =?us-ascii?Q?mPRmvcQmw2D5by3nPtOXJSCZ8gE8SfuqRly3WbzzrbaYqZzYabeqKTLRPOHU?=
 =?us-ascii?Q?2txyLA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e518014-f02a-474c-d5ee-08db4b45980a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 19:44:08.7914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WantQVpiQfmAjzdxhH8qqwxiXVSehblNhG4HYpWEDNwbNIddsu4q+wlfV0MSVL2WcDqrDmfsQ1MW52K+gwW7HlazXpPPUq8/cqI37VSCPIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4759
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 11:54:29AM -0700, Justin Chen wrote:
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
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>

...

> diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c

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

block_index and filter_sel are uninitialised if offset doesn't match any
of the conditions above. Can that happen?

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

> +static void bcmasp_netfilt_tcpip4_wr(struct bcmasp_priv *priv,
> +				     struct bcmasp_net_filter *nfilt,
> +				     struct ethtool_tcpip4_spec *match,
> +				     struct ethtool_tcpip4_spec *mask,
> +				     u32 offset)
> +{
> +	__be16 val_16, mask_16;
> +
> +	val_16 = htons(ETH_P_IP);
> +	mask_16 = 0xFFFF;

mask_17 is __be16, but 0xFFFF is host byte order.

Please make sure there are no new warnings when building with W=1 C=1.

...

> +/* If no network filter found, return open filter.
> + * If no more open filters return NULL
> + */
> +struct bcmasp_net_filter *bcmasp_netfilt_get_init(struct bcmasp_intf *intf,
> +						  int loc, bool wake_filter,
> +						  bool init)
> +{
> +	struct bcmasp_priv *priv = intf->parent;
> +	struct bcmasp_net_filter *nfilter = NULL;
> +	int i, open_index = -1;

Please use reverse xmas tree - longest line to shortest - for local
variable declarations in networking code.

You can check for this using https://github.com/ecree-solarflare/xmastree

...

> +static int bcmasp_combine_set_filter(struct bcmasp_intf *intf,
> +				     unsigned char *addr, unsigned char *mask,
> +				     int i)
> +{
> +	u64 addr1, addr2, mask1, mask2, mask3;
> +	struct bcmasp_priv *priv = intf->parent;
> +
> +	/* Switch to u64 to help with the calculations */
> +	addr1 = ether_addr_to_u64(priv->mda_filters[i].addr);
> +	mask1 = ether_addr_to_u64(priv->mda_filters[i].mask);
> +	addr2 = ether_addr_to_u64(addr);
> +	mask2 = ether_addr_to_u64(mask);
> +
> +	/* Check if one filter resides within the other */
> +	mask3 = mask1 & mask2;
> +	if (mask3 == mask1 && ((addr1 & mask1) == (addr2 & mask1))) {
> +		/* Filter 2 resides within fitler 1, so everthing is good */

nit: s/fitler/filter/

Please consider running ./scripts/checkpatch.pl --codespell

...

> +static void bcmasp_update_mib_counters(struct bcmasp_intf *priv)
> +{
> +	int i, j = 0;
> +
> +	for (i = 0; i < BCMASP_STATS_LEN; i++) {
> +		const struct bcmasp_stats *s;
> +		u16 offset = 0;
> +		u32 val = 0;
> +		char *p;
> +
> +		s = &bcmasp_gstrings_stats[i];
> +		switch (s->type) {
> +		case BCMASP_STAT_NETDEV:
> +		case BCMASP_STAT_SOFT:
> +			continue;
> +		case BCMASP_STAT_RUNT:
> +			offset += BCMASP_STAT_OFFSET;
> +			fallthrough;
> +		case BCMASP_STAT_MIB_TX:
> +			offset += BCMASP_STAT_OFFSET;
> +			fallthrough;
> +		case BCMASP_STAT_MIB_RX:
> +			val = umac_rl(priv, UMC_MIB_START + j + offset);
> +			offset = 0;	/* Reset Offset */
> +			break;
> +		case BCMASP_STAT_RX_EDPKT:
> +			val = rx_edpkt_core_rl(priv->parent, s->reg_offset);
> +			break;
> +		case BCMASP_STAT_RX_CTRL:
> +			offset = bcmasp_stat_fixup_offset(priv, s);
> +			if (offset != ASP_RX_CTRL_FB_FILT_OUT_FRAME_COUNT)
> +				offset += sizeof(u32) * priv->port;
> +			val = rx_ctrl_core_rl(priv->parent, offset);
> +			break;
> +		}
> +
> +		j += s->stat_sizeof;
> +		p = (char *)priv + s->stat_offset;
> +		*(u32 *)p = val;

Is p always 32bit aligned?

> +	}
> +}
> +
> +static void bcmasp_get_ethtool_stats(struct net_device *dev,
> +				     struct ethtool_stats *stats,
> +				     u64 *data)
> +{
> +	struct bcmasp_intf *priv = netdev_priv(dev);
> +	int i, j = 0;
> +
> +	if (netif_running(dev))
> +		bcmasp_update_mib_counters(priv);
> +
> +	dev->netdev_ops->ndo_get_stats(dev);
> +
> +	for (i = 0; i < BCMASP_STATS_LEN; i++) {
> +		const struct bcmasp_stats *s;
> +		char *p;
> +
> +		s = &bcmasp_gstrings_stats[i];
> +		if (!bcmasp_stat_available(priv, s->type))
> +			continue;
> +		if (s->type == BCMASP_STAT_NETDEV)
> +			p = (char *)&dev->stats;
> +		else
> +			p = (char *)priv;
> +		p += s->stat_offset;
> +		if (sizeof(unsigned long) != sizeof(u32) &&
> +		    s->stat_sizeof == sizeof(unsigned long))
> +			data[j] = *(unsigned long *)p;
> +		else
> +			data[j] = *(u32 *)p;

Maybe memcpy would make this a little easier to read.

> +		j++;
> +	}
> +}

...

> diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c

...

> +static int bcmasp_init_rx(struct bcmasp_intf *intf)
> +{
> +	struct device *kdev = &intf->parent->pdev->dev;
> +	struct net_device *ndev = intf->ndev;
> +	void *p;
> +	dma_addr_t dma;
> +	struct page *buffer_pg;
> +	u32 reg;
> +	int ret;
> +
> +	intf->rx_buf_order = get_order(RING_BUFFER_SIZE);
> +	buffer_pg = alloc_pages(GFP_KERNEL, intf->rx_buf_order);
> +
> +	dma = dma_map_page(kdev, buffer_pg, 0, RING_BUFFER_SIZE,
> +			   DMA_FROM_DEVICE);
> +	if (dma_mapping_error(kdev, dma)) {
> +		netdev_err(ndev, "Cannot allocate RX buffer\n");

I think the core will log an error on allocation failure,
so the message above is not needed.

> +		__free_pages(buffer_pg, intf->rx_buf_order);
> +		return -ENOMEM;
> +	}

...
