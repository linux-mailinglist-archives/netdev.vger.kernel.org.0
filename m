Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9D1585EEE
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbiGaMlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbiGaMl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:41:29 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00075.outbound.protection.outlook.com [40.107.0.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE4CDF7F
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 05:41:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWCQZPXPlzvfEmIjCbayfDCYttN4kvWLcPHcY7ibFd1Xpe/ok2nk0/AGqW9dxPKtdAGXdP8BOiLXv7+5DvORp9NHsG8YX8SP2evAxw8wRSBeevGrmSt2WNxDwWW7B8qPvu75kxLHCRGgJxryQ50pNxH117os87zfn6QVajgpl2IJ6K72/3DGGyJ+nKu+R1nKsYpANBfWytCku5OGOZU8JR/Yo8nmJ1BWq74GisLMY2V9u/Ciy7XKAC3jNj6rsIp3htql9gVM0fnlaHsKZv2tQPQgQUkVjbM+nUDI0s4jcKfxw0oSg+yKmkbMx81tPEMFUjKoVCUl4vXvc5IRm275OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAI9CH93n6+HHD3pl9eXGINe5RJBz/1lXC1PCaUVlNw=;
 b=OfgHkv+EBA5uPPd8nqd5663gAEKorK4QtFh6VimxtxAt+8uncBnYKsGDbbkz7e4jyFJME+Qrcvihy3VyVaH9qVmib3+MUoRzT+OTKURhSIwd8E3pw+6ToVl5FZ76xt2aDaVDF7ykerAQ5dOj4nLrOejX6SUcqeV9b5hZvAPYQaznlPGUeCQaf5PkhOYt1qBTiWODZfcjFlj8+wFcEqLiKFF8gi6M0W3Id7eKTyO71yfvhpC/oC1kuUdzrKMeXIZqLsEhfjP4011mBRr/RX2NdZJFCwomzwGnRwshMURe6QZJ2n5cpg7dSy7c4VrwAAvtSiu+yziaZeiTiK6x7r3A3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAI9CH93n6+HHD3pl9eXGINe5RJBz/1lXC1PCaUVlNw=;
 b=dwLRySHg+TEIAvVcHzMKB3Kisn9joPoD/TUQOclcck2A0IZt+3+ExriVa+zXRtdgQFqvAhMRu+xUgDGC8yKK0lTEaYFM07Vk3X4vzXY0/pajHQ7I2SJ0TL68gSF8WOXr+CwhCla9kbt1iuGtmC32D1JEsR39RkMHSfcJabmFP00=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6446.eurprd04.prod.outlook.com (2603:10a6:803:11f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Sun, 31 Jul
 2022 12:41:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.015; Sun, 31 Jul 2022
 12:41:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 net 3/4] Revert "veth: Add updating of trans_start"
Date:   Sun, 31 Jul 2022 15:41:07 +0300
Message-Id: <20220731124108.2810233-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0191.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e32bbcc5-6a94-4e05-8f2a-08da72f1fa23
X-MS-TrafficTypeDiagnostic: VE1PR04MB6446:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Lpdc2d4mwch4vLJ/2W/s6ELrXooRXhaBEyZJ/yD2KBTZSDD8y/va8H31XkFCZ3OTRRP9Ax3/EHEnSIuQTmDlIGnrRva2azO2No+2UO26N8n/C+xD2oa8bbrN7eAwCNToMoy5S1iMuEYrJxQv2F9StVeaqGgj84ec8K2ToIjv80CqAwH/YqoLZsbIqvZgnmi7mMwEF/OReSbNeMApouz0P10dWcV6mBr8ERh+oUAuFveqXMdfieqpvDzNEcnEjXhdlPNWuGEjSS5kZ7awybKCEiT55VxhzJf5Uqg7Kua5pg7C51Aqz2iEa3cDZvqmdDkGZ5Rjb4lhMqVHb1OV/HsqwePg74j4j2bG/vZTxv1cePiKz/w3H+NUAZmNTdk+3aScENZpquT7E9PFv2LHFzySfLtGNNccHm8g2TICOB5XIRZpqvt4CWMeOBLwCr94KjW1OwjroIi4xLgNCq3keSYQluoSUXcMchrKE6xHZqU7q7Ik400Y785IYicJClRqkOBi3n6byxh11pBLUI6DDagaVc2J7EVbZTYNE5o4hDRnmYADbHzkkvjW0nHAUwpaPeyCgfxGlOavweta/cowz0jUASleCD8BMAcbTPQKthRWMfy8RJsloYWOhddiJ4XzhmSiaxa3ygfpJ9KltfKvUhl4Cqk5GHJRi8nXcy6Igi9aHZhvqn6lqS8A8y7yq1BV8kT234xLAgrbtBL6joFSj7ibYwRsHVHE6Or7oUbU5S8jnU0q8bUzO0X6cRk03WlX8gtbj9RyU5M/wIvUdModIxQ1eruvf0lMJKspIa7dcAn5O0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(39850400004)(346002)(376002)(316002)(7416002)(8676002)(4326008)(44832011)(66946007)(8936002)(36756003)(54906003)(6916009)(6486002)(5660300002)(66476007)(478600001)(66556008)(6512007)(6506007)(52116002)(186003)(38350700002)(2906002)(41300700001)(6666004)(26005)(2616005)(1076003)(83380400001)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VZF30of2lq/5YS+AOYEjEXns/65HKL8YWkUVUhG0RpqrHEtq3FkNG1rnujSB?=
 =?us-ascii?Q?R/tA6oXMw9bjHuEEx3cSQd7sCZ1JdKmbkkE3YfwRIUFPPqdZw4WtT6RPB6R/?=
 =?us-ascii?Q?wGnUTk4aWMt4z8953dvrTYwOIG05XCl4wpN0t3kHXwTgyhEO4OCjkTUtniTr?=
 =?us-ascii?Q?jEI3Jf7DTsCVUTzv5CXLxMBNRpGUVM8IaCqoAbGHcIX1LRv1qxNDrD8RbT7l?=
 =?us-ascii?Q?3zeuE2Os8l65D1Y53hX+k5oY8IurlxpZYYopVpYdwTVXQ2WHqtFzz56DfjYW?=
 =?us-ascii?Q?E/wHkfcSZEeJ3SQdKhK97JDinVx9pbHv5+mMpPNsH15YTn16QmO2l71Y1p2H?=
 =?us-ascii?Q?IiqquXAiLSmXd41ZRDDUfGExOiaEErjX2ESOqSDCbCCXK4CPCfSKwvEnqXZY?=
 =?us-ascii?Q?5Ww384C/6i0nez7TFvnXJvnimyo3QtDodkDwJNJuWbR0yMgc5al9dt1tRTF9?=
 =?us-ascii?Q?vdsfDuQAhgvBgQ52JrE84VnSAEL2JzmDKYLZ/IbsaNhgiNjB/1/aJfoJ7AFI?=
 =?us-ascii?Q?c/eh3Blb0l5wm2P0bBE45UAZ78Yefg3pv+T16NvoTEkk4FiGQUkLq6CqJIfX?=
 =?us-ascii?Q?3TCjMgTxHEQ+Fc6LU9a3xSbgc3kt+5zk12LueY7wflvBS2xs3e1PS/WPXKC+?=
 =?us-ascii?Q?92Rfm7jaPqiftHpxSrpMftjOMZ6u7YIu7xo3TcC51JG4BDulDb4MSuh8JtTx?=
 =?us-ascii?Q?VBRRwySPupCXmbRIE+N9xG0G70Gp3LCGeTsyrMlLcVwn4DcuuFnUnxDeqbpS?=
 =?us-ascii?Q?6HJ84I46AR2WcY9H4tI/+p7KNBPHovjbdKiI/jegiHWVr1lnmeH5BFcg9Y3u?=
 =?us-ascii?Q?pU5LKp1s8f+Poedc2QRyrpoEffisyaiv57rnarDbIJmHvwOlJx3tqh43Mcsd?=
 =?us-ascii?Q?bk/zTgdPF8dsR7DXUuB6PlJ/5Gdo0iZR+BumdCg9v9mbtDuDkigLIf4kuwMs?=
 =?us-ascii?Q?T1Tlv1lvcikqew1vTYvl+BX558hAPdK6fUM0e/JGusaCXt//3NN8L1Q0dKhS?=
 =?us-ascii?Q?lA3I1Vsd74YixaAOzkPwh8MmzEpKt9CVLZfpJHRDNuYgMSkhPq5IEpHpluSx?=
 =?us-ascii?Q?LKdmscfkWs0Oo0KwV0PTwVrCK4AP6jNL8bGUSBpjNhZ1L9sIl0HM1GBvZmhA?=
 =?us-ascii?Q?/a3De1FODMHfwa6djZ8ZVRumgJrZ8mCnRLX+9LZ2xVYsCWf/HOsrW5Epa39k?=
 =?us-ascii?Q?5c/FSMJUupFdGSoOXkAzK0wdohYOMGv71kynd5bpCL2svxTXWkN+LZsCgyqh?=
 =?us-ascii?Q?e+F60DOmhBoMHBvS2FgwrJmCHLoDeHoRzGp1VP1bMvtfRZDPNFPhdDrRhp6B?=
 =?us-ascii?Q?qxBUjTC2Rx2kT+2taNuuaml3uKonp66LceW0kHg/F9J+fvtnePWvLiTIEO8F?=
 =?us-ascii?Q?5BZPVXUlo+UWfjKLymyEtrcgHMwiK6WCI15ZMfuk5lVgHfaTh/IooosXXNkK?=
 =?us-ascii?Q?sTSck5wfDeHyHfeACU777nPAAIOUhC9aZBnroOstxXROU5jpytw8KDymJdc7?=
 =?us-ascii?Q?qnSS7RquQNaNEFzxcgVQ9wIVZTamwbdzD0R91OotMlMbbMBjAn/9NlpSj3lJ?=
 =?us-ascii?Q?Ze4PMfT3Q/pF+sJyMpeEfS6hgPwpLrwnayYWGBvZicThudmCV/lP+TQPm1Qh?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32bbcc5-6a94-4e05-8f2a-08da72f1fa23
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:41:23.6915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4Xe1qtFabEY9GdUSGHrWWwRgnuqYz6FaFDtL9yoQ2URMgzkzcM0rY7B/FWRrJM36cverTDXp/KYf+9Fcnu5Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6446
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit e66e257a5d8368d9c0ba13d4630f474436533e8b. The veth
driver no longer needs these hacks which are slightly detrimential to
the fast path performance, because the bonding driver is keeping track
of TX times of ARP and NS probes by itself, which it should.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/veth.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 2cb833b3006a..466da01ba2e3 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -312,7 +312,6 @@ static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
 static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
-	struct netdev_queue *queue = NULL;
 	struct veth_rq *rq = NULL;
 	struct net_device *rcv;
 	int length = skb->len;
@@ -330,7 +329,6 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 	rxq = skb_get_queue_mapping(skb);
 	if (rxq < rcv->real_num_rx_queues) {
 		rq = &rcv_priv->rq[rxq];
-		queue = netdev_get_tx_queue(dev, rxq);
 
 		/* The napi pointer is available when an XDP program is
 		 * attached or when GRO is enabled
@@ -342,8 +340,6 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb_tx_timestamp(skb);
 	if (likely(veth_forward_skb(rcv, skb, rq, use_napi) == NET_RX_SUCCESS)) {
-		if (queue)
-			txq_trans_cond_update(queue);
 		if (!use_napi)
 			dev_lstats_add(dev, length);
 	} else {
-- 
2.34.1

