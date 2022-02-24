Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477584C2D2C
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbiBXNfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbiBXNfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:35:01 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B5617868A
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:34:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCoKXPtjG8F3ThiGJMWc3Fk8zFk7XrxM8+lP0BLny8k+8YgsnahcIM+Uyo0G5QzPzynWzFcTMgZDyT6FHylhjmI0f0sFsLJGiSbUH6jQuUkXu6qgRcaEL9Nd46lV4KAfMJ7JaIDSmArgiQjMpqdGQeanRQ83pqhKhkw8yTCy50USYkWqbcdkx4+j70sb4v2W75HxBifaVF7v3CfkowU664MLGgPEflxepJE3uHZX8pVKcQBlkjR/jpmuoee3xJ5FPFfozadp473TLaFkz+4+nRVqEBXLCxryGnhinGcO1tOori1/czj7HijpR3n9RWeyRkw70g12j4RG0hjv9ec1Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Etpm+jsvSXLq8FMHU7P41vRZJW2QMlomJy8oMVhrOlg=;
 b=I+pKy7iZwzqN2yH99gx5HuuJcsuibBmpwASzRrohHyic9+581owelKxHSzx2zMUrxPxc9Ns/mYxqyPHyH7MNPr2e4ekqcT9isKJz1DFXmI7ToeSEYHdsV3S2EbI+S6hr6IYmrLK5ow9nYnPXwg4zVyBW4RDYDghIuFUGcv7/f0ciOA3xXkh5PFzc6kUvR4kEFmVbx6cZO7OtvddeeKURB0u5K4f3pmKxvmpjhMO8W37u+g9/uO7lRb2UUvg8aGcPJJ3Kl5OD2YfOrhQGuScFINqKmhPc66bKG8HrTyDHUSj+m+Wx97yhEHE1PCtqyVnZ/FXoWignm3d8hBQoAJi7Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Etpm+jsvSXLq8FMHU7P41vRZJW2QMlomJy8oMVhrOlg=;
 b=UxdsXdtrksVrvgilYfxct2Rg900S59Qz+4oddL/+WCVn9wMJcSpvyOgX/DuRaAC+KjXL9VzfXykABgVIvf7QMtsk1GQaWtthH8VwB/RHi31qJ9XltWSSS92feD4cVEFmfFgDQTk1Y/dH9n21aTkNZUMRfXe5SAZ2ULhK724AD6oRAC7JBGm3cCojnr7Qew49Ckc9eGIP4TEFOsaBIH93f6sSvQwVptEBSc8QAfcQGcZLvDBI3QQ+9rEhEBvzfCWQRkCDZd51iHHMNO3y7Z/De4vUoVfMv3TixAEbS77zhXGTg47x69uZdU9ZXCM6NMKno6uxxLE/Mk29q2R9UQfGYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM8PR12MB5416.namprd12.prod.outlook.com (2603:10b6:8:28::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 24 Feb
 2022 13:34:29 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:34:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/14] net: rtnetlink: rtnl_fill_statsinfo(): Permit non-EMSGSIZE error returns
Date:   Thu, 24 Feb 2022 15:33:26 +0200
Message-Id: <20220224133335.599529-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0016.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::26) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 532562c3-6f71-4e58-5293-08d9f79a6257
X-MS-TrafficTypeDiagnostic: DM8PR12MB5416:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB54168794C8F15B145ACFD307B23D9@DM8PR12MB5416.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wSxePjivbaQ4aN7IoQHX3IQXlMrEpFANCje45dAaobnbsr8MsH//DPZlnogX+BNMu+yPs3wmjiHjz2/AOnrLWFWVjejraLvXUv9wnIlunoEn5RnRzJCGn/e9BYK18JuZH8V/GRIWefcpXwlBnp/Rh17ioSlHCAzs58CRwhq0msgIEjRkitmhcsLmhKJ5y7t23YO5TE/kM+S8mEdMejpG8KttfmihXX67xX2YoyMuPsQYWW/8p0NxtCkwUfrRZtwq0XnTMqUeLhjKiTzfYdvfYSb+r/ATb5IsfcBgt/fTxhJ+fmQz0ObVMIWPOtKwJX0FHzOtOyHuRQOO1dxmYAEAc3JWTSVbxiXt94gLVpiSOn9hCIhtkft9OEOgo2p7j529CCJ8sTN/a1t1/yvKVytRP1s9ft0RrFtp49UH4EVZ+XX2DyWokEe6ESt2dvORCY67nV4CjytTrrmjyNjh6OYHL9rAMsfo9dnY7LtcNYcuEIvfWg+cjUf9/uYuB3YlXe5hTOaSdRBFkQ1avMJNVF3FTe3u6GEZnGy4pDer+aR2ta6rl9wm2PdFxdl/NWiuFcHy8XLjwWhKIFjDe372B8zOVgwJcqg5lpXwHRBFYsFGZCPfMO+XrmZw0zKs7EUF9FKN8MX61RsrVU5PpOXwe/yXvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6512007)(1076003)(107886003)(186003)(26005)(5660300002)(2616005)(2906002)(36756003)(8936002)(6486002)(38100700002)(508600001)(316002)(6506007)(6666004)(66946007)(66476007)(8676002)(86362001)(66556008)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8cYUun/3krUoNMakBVF6MA9ffzGcyK0Szll1tVFS2rE6T5Bbkx/A0UBE9HYx?=
 =?us-ascii?Q?zAn6EH7KIEyaIrl/Lr7ZUQ1WRA4MmQsfubOQsL1dkqKqBgjuP+800P7PQQ2/?=
 =?us-ascii?Q?XbD9W7eEcnPM5r+fYK5Q22oUFm9sfi8GORkG2ohcRgSTWjO3Vn1u07chJ+y1?=
 =?us-ascii?Q?eyPy8j6aH8mgPSiDM7gRckL4ZePdR9DbxLodWSgaqEcGIhsldSHjel5YLXjM?=
 =?us-ascii?Q?bUgxdWDEUmn1fuuaADJP5HBhwDLrBEvudy4YrbVQB28ovF0BC273bP3p0h03?=
 =?us-ascii?Q?xqDiIp/yewBbdto2sv5PJ3G3tmx16ZpFPqTS7vsyaU/vmqewv/B547F50BqD?=
 =?us-ascii?Q?cCFMjQvjSS6ktNZns07ROMFTIwQ+/C2+r7KdB2pEXF51KYL6HyhdlmL3oDbw?=
 =?us-ascii?Q?xlbiSn9LIvMVnEOkPhImBsUFNcupWJWsvTrAvck4hC3ObWDOg6TaElx0smug?=
 =?us-ascii?Q?omcK9jwHk4nMksY1yYbuTGSk78Q+QFY1AL6N3/OP2+HTI3KQxYs/2kVMR1w6?=
 =?us-ascii?Q?OpPbO0FqgMBezuvzJtS4FUVNmBV1qL7EEoxmG/84LviO7aJoN35SHYBBuEfu?=
 =?us-ascii?Q?kEMI5m0piqzyJxuvJdpVQVPUkfPmVOVm+i51L0AnJW28lOEDntM71VkhDj5v?=
 =?us-ascii?Q?KpRL5RuQON9xFRbWhWYqkqjxSsyR67Mkqi1eT6+HN79N1danxMSWkS2yDj+t?=
 =?us-ascii?Q?2n3X1FSCPQMZn+lFaydQicxaH9VN0moXJZyEDdqGeha+UbNqvWlX55SJGSpg?=
 =?us-ascii?Q?+vwUl9SI4a0q9DSQRDWpLlb3728m/siyInoM7wHutwuBqMZQ/wwex2g0/7Np?=
 =?us-ascii?Q?F7EWMnOCAuNopI/TirlIEuL1LgQ0QHCyjFhRmNn2Edpff1pE07DTNxXjUTvQ?=
 =?us-ascii?Q?5j/LVjo22ipdeW1jqkKyelKbzc640FlHU6a/Z5Ac8GelaST0AAdhPhwDNacv?=
 =?us-ascii?Q?Pny6XFWIQ1k3DGwSNWOGw+rpCQd0xMqLrW78KVuM5T6YL4h/EzBuKz4I34d9?=
 =?us-ascii?Q?oAQepHZbD/ky8WnufQ1hrnT9/t6g8q6w+WKQo1WFf2eODdU78dpHMvo3yKtT?=
 =?us-ascii?Q?s1xhBEMjGnEZ05+98PGX6jXUNvf/Ywk+OzX9KpCKwmvvQ5rgq5c3+cMeWZYS?=
 =?us-ascii?Q?GaKXZj5+GHa7Ounqq1/uHE5uY1lRFCI4+2X9Z7FJUhIH/SU09hZsG8MLIKWz?=
 =?us-ascii?Q?8lJk6qAVRHyAxjOBkgTPcLFoHQVrVpldYTCE9XG911ncqiL2vg4pZOwiDN68?=
 =?us-ascii?Q?YvkMOWTL+TWgPMhIbPSJoCgqBUuEOUroz2WYm64C7F+uCz/Ui81KmXsLm/gh?=
 =?us-ascii?Q?iwvYLev8k1K2fVsvgONC1x1MicUZu7ssrAUSc0kic6f8dLC7Gztf+Rx/BQ/P?=
 =?us-ascii?Q?jM+3Ve7Sl86Tg8jyyIu/awFbWZSHW3VLkdN/QFGgs78sdyWFYvfvkYiFJ7VH?=
 =?us-ascii?Q?qoGX+wuCaNx3eG/NZj1EDh9Wo22a5hMlNhG+DmeBX3ObE7nRa6ZsoUMExvbt?=
 =?us-ascii?Q?xNJD1UGCAUAoAGHZEQCkh/kyL14UoZcEsKqP9UDDKtzMVf2yqrh/iHqB1xJf?=
 =?us-ascii?Q?4OZlRUNMauYexvUzTkTLHG9Qc66EsrNPv/aYYlIQGYes9zw7PGz/KTpZcRK3?=
 =?us-ascii?Q?PXXfFaJST8bYHkWLtYFuKSw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 532562c3-6f71-4e58-5293-08d9f79a6257
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:34:29.7331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7gsPzL7WfdOO/g9Q4QXtotr5SV4R5oaTfTg5onN1aAq+UUun+FGzDqhFBJ4WpQvHzyz6nRDdAnF2dpS2zxeBmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5416
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Obtaining stats for the IFLA_STATS_LINK_OFFLOAD_XSTATS nest involves a HW
access, and can fail for more reasons than just netlink message size
exhaustion. Therefore do not always return -EMSGSIZE on the failure path,
but respect the error code provided by the callee. Set the error explicitly
where it is reasonable to assume -EMSGSIZE as the failure reason.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/core/rtnetlink.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 67451ec587ee..d79e2c26b494 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5177,8 +5177,10 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 		attr = nla_reserve_64bit(skb, IFLA_STATS_LINK_64,
 					 sizeof(struct rtnl_link_stats64),
 					 IFLA_STATS_UNSPEC);
-		if (!attr)
+		if (!attr) {
+			err = -EMSGSIZE;
 			goto nla_put_failure;
+		}
 
 		sp = nla_data(attr);
 		dev_get_stats(dev, sp);
@@ -5191,8 +5193,10 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			*idxattr = IFLA_STATS_LINK_XSTATS;
 			attr = nla_nest_start_noflag(skb,
 						     IFLA_STATS_LINK_XSTATS);
-			if (!attr)
+			if (!attr) {
+				err = -EMSGSIZE;
 				goto nla_put_failure;
+			}
 
 			err = ops->fill_linkxstats(skb, dev, prividx, *idxattr);
 			nla_nest_end(skb, attr);
@@ -5214,8 +5218,10 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 			*idxattr = IFLA_STATS_LINK_XSTATS_SLAVE;
 			attr = nla_nest_start_noflag(skb,
 						     IFLA_STATS_LINK_XSTATS_SLAVE);
-			if (!attr)
+			if (!attr) {
+				err = -EMSGSIZE;
 				goto nla_put_failure;
+			}
 
 			err = ops->fill_linkxstats(skb, dev, prividx, *idxattr);
 			nla_nest_end(skb, attr);
@@ -5233,8 +5239,10 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 		*idxattr = IFLA_STATS_LINK_OFFLOAD_XSTATS;
 		attr = nla_nest_start_noflag(skb,
 					     IFLA_STATS_LINK_OFFLOAD_XSTATS);
-		if (!attr)
+		if (!attr) {
+			err = -EMSGSIZE;
 			goto nla_put_failure;
+		}
 
 		err = rtnl_offload_xstats_fill(skb, dev, prividx,
 					       off_filter_mask, extack);
@@ -5253,8 +5261,10 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 
 		*idxattr = IFLA_STATS_AF_SPEC;
 		attr = nla_nest_start_noflag(skb, IFLA_STATS_AF_SPEC);
-		if (!attr)
+		if (!attr) {
+			err = -EMSGSIZE;
 			goto nla_put_failure;
+		}
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(af_ops, &rtnl_af_ops, list) {
@@ -5298,7 +5308,7 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 	else
 		nlmsg_end(skb, nlh);
 
-	return -EMSGSIZE;
+	return err;
 }
 
 static size_t if_nlmsg_stats_size(const struct net_device *dev,
-- 
2.33.1

