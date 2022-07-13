Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A559A5731A9
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbiGMI4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbiGMI4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:56:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2104.outbound.protection.outlook.com [40.107.243.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13305EDB7A
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 01:56:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgWISbBfbswxBS4WVHPc+yW+nP8GV1O8rTsweYRGZkMAL9tfYf9ldqtLyMMYC/JM5I2r0fock301hemOJiGKjytjs6fISflXKQVZjsM+3vjqB4JToK4+crz/Pls9IZ4wWW+30bAdOrEelMCiwdGZOxgSGXVq8GHEpcrb0CH4NmCpgf29uQzhrhm31si9HyzM8+h5xN8YngLh7fEDlzEgPVcMPc1sZjWuh7MDvFOv4JwKnr3V2m+gmfmtaAXWMWXyB21aZl3kxRNcffQUwC301Uh7za9Z1BDn6UvmfTGZGfPaeid9BHnQZeNUdqvnFsqDEgZrN5Q7JM1B12Xe+dq6JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQCof66sbftYxJKSk76UhjKQ4bNOlyoeKiNCqbUrsxA=;
 b=LtGllELPQ+IpMIDeIXkxUyRHkBTAZm27w5Cv4+KZcQHU/MWmeISe3dHAct3Eh0J9TTwwhf6DsTsR6fQAbb4lqLHqTKrcO1naiBGkqE9L1ET1wyHd4o0d8s/RcYnKgA6KxhjZNX/+sECBFlsNaOdit3PWLm9PNVWaDZiiMFlpaRwRuEaldbD/sbZgLDrdn9CU2PCNZsl5OBeJALpQLyC+PrDBAe2hWMKd3mQjXLREVv25IP5QQyA9vVY8SlU6osFzkWWCkTRhBbahaQdPsps6Q/Olx6g8tH8tOulPxgqcosmtJDFU9e5Lym5lW3IHaMsFZQotUcNFHUYG/agHYlwBow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQCof66sbftYxJKSk76UhjKQ4bNOlyoeKiNCqbUrsxA=;
 b=c24eQkd8WJTj3EnT2z1plU+0WZG7212f+tUVGl4bWHfZc5DQCZvCnOQW/Wjj5oPzdSnjCXR3TLhxopzOqgvtden9Opi0H03GpQ72Lg/op6imCua8+GhN4SFxfxIOcqiwk6UnantOpAMlh+7pwtUskVwHyKm4R3TBwkIp332K3RY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3439.namprd13.prod.outlook.com (2603:10b6:208:162::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.11; Wed, 13 Jul
 2022 08:56:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%9]) with mapi id 15.20.5438.011; Wed, 13 Jul 2022
 08:56:35 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net] nfp: flower: configure tunnel neighbour on cmsg rx
Date:   Wed, 13 Jul 2022 10:56:20 +0200
Message-Id: <20220713085620.102550-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR09CA0007.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de606152-bb0b-4396-e9d5-08da64ad9706
X-MS-TrafficTypeDiagnostic: MN2PR13MB3439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r9c1MYB58e68Cx7xfdhueIMB4bW2xpgVGBZgy/g4WHv7z8disbDQp5C60nXjtUiZvAddkRrcPt3JR/SuNC6uebv4gZ74EkfsEN6hoMPfkGD+j10SYvj/DPcEN3d5sMJH0eZh8K/fec5aNoFIMCMTBIasdCVzvEDzBXT3xFseGSZueERmF2s/2AZqx/gYv62UpfC3jiDA31ooh2fBlMaD8HIxb72lAz4uyBwcRL2U/nnmh9DNMLcYKv+BhdphOarCdLV/bLmlpY2TBWS0NqZbMx4YH/m/nMwbmFlaKv94VUOgJBi4GWqlJrYbnySPwEZIik6VIMbfByPwbw/w3Bra6nT/BCP3YDUc7Q/zYUy/WmjbLO1Etib1h8UeoDZ1UOo41B4lXejRPW7FPxEMvgtItt5vYrfmSDkXZceXuFg425P+U8SZ0IWYf1kDywhJdYYJjRNF2Om9aLcaoKtpajZKo58oVjpBOYIE4Bc0Q1ggJMs9wmZxh+OeqBdGp7pBXIN7LAepdSMf09RhUo0irebNTdEQAM1fZhbsXuHMVU8gt62N8cPyYEXakNJZhidVAOnPuNeXNUSADl9Fwa9nw+tIcqZtB5QcgWvMFZePhBV3Ftjm1a0lSY+XjZFMDaAUrbiwPp3I+wNJQP8bK1zK24oI6kUuOUrhjANu9vVma1c1jl29AgeRphf5S9SkxkTz3K2mbC9hetIrfUHWwz6kOJZhAQTGjyrp2KHCifrR9b2YXCLd0Hmh7i8uT7VGQNes7O3iHKuO/1XBvP1gAI4ZaORPA9JGRXGVAJlOZmbUqJhqHSHMpmlmZ+0yap9ODw85sh5Gx9Mh001RFs8fJMoLSYZPFuc05P5cGwWLO5sqCE7yxlQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(346002)(396003)(39840400004)(1076003)(44832011)(66946007)(52116002)(107886003)(6486002)(186003)(2906002)(478600001)(2616005)(6512007)(6506007)(38100700002)(316002)(83380400001)(5660300002)(66556008)(86362001)(8676002)(110136005)(8936002)(66476007)(6666004)(36756003)(41300700001)(4326008)(83323001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?frhwT4pvyoRi02kso6qHaHD3/Qbq7Ko/nfYJl0TKcRy8WHEVW4ZMfG/LqroH?=
 =?us-ascii?Q?JYpU0+jYiWGQUp1+92hGGbjcZRFugRUQi5Fcdihvj/tilbpL7pnD94763eAG?=
 =?us-ascii?Q?p+JC2GN4EmGOhzoFXJxICAnAN6c/+LRrYVPRRY2HSMdLYrW4UqBnRNEj/dUG?=
 =?us-ascii?Q?KAtFCWIQh373nt42358ZUnADtAymo0Z4C5rujcW9nU2n2fPelQ61FydblvbO?=
 =?us-ascii?Q?8JcPHaBa/eQ0Qa6ive91/1Hy9n2fkSbSIfT8Qa7oaqMrotyrd2EwJKCrw9J1?=
 =?us-ascii?Q?yIgUdw6NoCdQMIn0WvaC3vbfK5xpz7FWhihqEl7Lns9neqqFhX3o9kVjwFcK?=
 =?us-ascii?Q?etqiMhtBEYdEFuuftde1c9dJfsjzgA0fBi6YE4lPexZPSuKW8x3q/sYZZ1yW?=
 =?us-ascii?Q?gZqYItm2fFwX0jzjN9qA1c1zTUwYPRayha3+talS1CjDetR8fnt2F3eUjdi/?=
 =?us-ascii?Q?HQduB1SPajihIkapxtinLbQB3JiAxyPRviQkSUjGDffjNVQQRaU9PiblJDKY?=
 =?us-ascii?Q?MnqwrdUMcNVYE4wOHfpiIwzGO5qKM105ZmV8Ig6uD9CmLHg87Q1cKrwjAYoX?=
 =?us-ascii?Q?SDjtbw9gRkIMNpJ2wznqyDp21+QdzmZQxkHk7RmtLJp/jwFvBcN9MCjE3tEf?=
 =?us-ascii?Q?11yHNlQNXNZxpQTKZVUhWsMHyf+cwWt5wGrLg7zOEchErudE8kt+XOFevT7t?=
 =?us-ascii?Q?v+/F5qkOmt49Sysz/jt2pjeDReOZJzOu8BLlca/XdDtcyB+5BWZZiJaCq8aa?=
 =?us-ascii?Q?e3cmcC7rLGBdt/8gh0vQI7JZQccGN1hvi01cch6aAKI4kR4MC239RQmm8HIc?=
 =?us-ascii?Q?esekN8DsDlhQZYHTGFsGwsKVNrSe35nZMnXv3WgiW9+31zv6uuq9veVQi3Ko?=
 =?us-ascii?Q?F5IulVuAvlNC6GTJb5jSP1QiMtbPnOUjMVnrArVnswFDNmNrE/LXS510NNTp?=
 =?us-ascii?Q?gUw1++HPS8lr0Nnpzp4FklOQGRIShyPK7cFqQ0O/l5EJ9BV8SHb+hImqbv5C?=
 =?us-ascii?Q?WRVJyHCdYByhQeNDfRNMkWWgunPEdM6+NQ/KtFbW+R0FUxXwCXY9yeNCC4mE?=
 =?us-ascii?Q?li7bB/zaZLjAecDmaosYG7Kii2nH2uTqPMNRqPex+7JatmP4jWh1LbFql1cd?=
 =?us-ascii?Q?WjPN2B42h50npB1P4kuMm7mlC0UhRFlArxm2MFrYvt5ZCd0xom95ZLUSTcfC?=
 =?us-ascii?Q?O1DRaALZ+ucm23Sa0T8OK2wij7apJrMZ7DCNqF8AizZR6a4PdfdxSSMtoKnL?=
 =?us-ascii?Q?HQbOq4n7xlMCoCDgjLFkuK1ccG7uRlK1MtjmOnOQ29vDRFu4ujSHMFYJ1ltG?=
 =?us-ascii?Q?8PZ/Ie3hzAdItzS/aR3wzVyDBtEPPdi3sTApLe7vG5W/5+NSMmJIGgOvORqd?=
 =?us-ascii?Q?7x6uvxfRzcd5LbXqWUTtDDI2zhQl/dBRq/9Li9TceCO0Qs1hdrH3llEF33D/?=
 =?us-ascii?Q?14GqoPjjZwqVo927KIxIBBZ6kYzWKHECxocth262+VNmgZefQ0iCpXlAbt8u?=
 =?us-ascii?Q?j/e3kTCcYBX4ypvCw2YzhEbIHm3mSyPAikOmJcVCIMDKQ49HENrVwDu9Q8R7?=
 =?us-ascii?Q?SYW2Gb9X9QrjjlVCzbRo6j9EgS73Zevd3v/QCsWvoyExn78RWFJ16s3rV/KO?=
 =?us-ascii?Q?+ytyGjrlMva6z5/Gd08LpCBiaLdaSzEedoQBE7zncc1ReZmbDvKi7gcC0rTf?=
 =?us-ascii?Q?NxbiaQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de606152-bb0b-4396-e9d5-08da64ad9706
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 08:56:35.4153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yE3pLuk6IqvdVXTX56ECpSIkwjxDErflo8dwM08LQLUPWAQSqc2ZnnPhHDDSXf3Mqjh2khbfPakFRUcUwCMgQ7Vy5VisIBlty0zjIesUAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3439
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Yuan <tianyu.yuan@corigine.com>

nfp_tun_write_neigh() function will configure a tunnel neighbour when
calling nfp_tun_neigh_event_handler() or nfp_flower_cmsg_process_one_rx()
(with no tunnel neighbour type) from firmware.

When configuring IP on physical port as a tunnel endpoint, no operation
will be performed after receiving the cmsg mentioned above.

Therefore, add a progress to configure tunnel neighbour in this case.

Fixes: f1df7956c11f("nfp: flower: rework tunnel neighbour configuration")
Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Reviewed-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../netronome/nfp/flower/tunnel_conf.c         | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 6bf3ec448e7e..97dcf8db7ed2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -447,7 +447,8 @@ void nfp_tun_unlink_and_update_nn_entries(struct nfp_app *app,
 
 static void
 nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
-		    void *flow, struct neighbour *neigh, bool is_ipv6)
+		    void *flow, struct neighbour *neigh, bool is_ipv6,
+		    bool override)
 {
 	bool neigh_invalid = !(neigh->nud_state & NUD_VALID) || neigh->dead;
 	size_t neigh_size = is_ipv6 ? sizeof(struct nfp_tun_neigh_v6) :
@@ -546,6 +547,13 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 		if (nn_entry->flow)
 			list_del(&nn_entry->list_head);
 		kfree(nn_entry);
+	} else if (nn_entry && !neigh_invalid && override) {
+		mtype = is_ipv6 ? NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6 :
+				NFP_FLOWER_CMSG_TYPE_TUN_NEIGH;
+		nfp_tun_link_predt_entries(app, nn_entry);
+		nfp_flower_xmit_tun_conf(app, mtype, neigh_size,
+					 nn_entry->payload,
+					 GFP_ATOMIC);
 	}
 
 	spin_unlock_bh(&priv->predt_lock);
@@ -610,7 +618,7 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 
 			dst_release(dst);
 		}
-		nfp_tun_write_neigh(n->dev, app, &flow6, n, true);
+		nfp_tun_write_neigh(n->dev, app, &flow6, n, true, false);
 #else
 		return NOTIFY_DONE;
 #endif /* CONFIG_IPV6 */
@@ -633,7 +641,7 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 
 			ip_rt_put(rt);
 		}
-		nfp_tun_write_neigh(n->dev, app, &flow4, n, false);
+		nfp_tun_write_neigh(n->dev, app, &flow4, n, false, false);
 	}
 #else
 	return NOTIFY_DONE;
@@ -676,7 +684,7 @@ void nfp_tunnel_request_route_v4(struct nfp_app *app, struct sk_buff *skb)
 	ip_rt_put(rt);
 	if (!n)
 		goto fail_rcu_unlock;
-	nfp_tun_write_neigh(n->dev, app, &flow, n, false);
+	nfp_tun_write_neigh(n->dev, app, &flow, n, false, true);
 	neigh_release(n);
 	rcu_read_unlock();
 	return;
@@ -718,7 +726,7 @@ void nfp_tunnel_request_route_v6(struct nfp_app *app, struct sk_buff *skb)
 	if (!n)
 		goto fail_rcu_unlock;
 
-	nfp_tun_write_neigh(n->dev, app, &flow, n, true);
+	nfp_tun_write_neigh(n->dev, app, &flow, n, true, true);
 	neigh_release(n);
 	rcu_read_unlock();
 	return;
-- 
2.30.2

