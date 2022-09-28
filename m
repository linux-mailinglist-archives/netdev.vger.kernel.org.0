Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832D35ED98C
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiI1JyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbiI1JxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:53:13 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70074.outbound.protection.outlook.com [40.107.7.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BD0AF0CA;
        Wed, 28 Sep 2022 02:52:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfmVGtvkbib4CPn1sQ/mmzZFCdAbYG5XJjVaMzkf7Pj867uS4HUq6Ev4nTT2CuDMAgsVqtbpfy/h2Ey14oF6zip7p7I2WKOgVu7UewcuKhwyuK6UE6s9ZWf2c0fQ1Ud/QPRUY1/31qvQMl2nQpemLQ32Jewvzw/PKRFBKbogW5Ff1gmuft0tOmei8lOjgBdmoMPcGkFETDvrA27g/u8FEpGqZWB2HkLLJyGyKNvcRfKcS5/5kkzg0dCPHGCeIboIi2x3qnvl9c2BZnRoQFzQGPd5i2TGCx9CZK0OMqe5Q1k9SMx7lJCJUUMhYo6U6Jl1Oo4nEB67Et74ruI2QDCKbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GvNrljXOs8S6OhrSGpXiYVpW8VU+eFZ6ojE5/3hFU50=;
 b=EKLrmTpC2i5pLaDB4sRW1ZN7djMwLylgljHJZYuEy0p2zryutMWR+ySYuFl0Ro0rYnvkWfPYzbVx64mdTNL/3tzajfykAQQpmbN9jXcN5eb2O3Gf7Js+sK4nezXk0bJM1va3S/aI4ROMshhJoXplqhQwJ9mZkKR1x5RrfPnt6d4vzPOUWLmvRWs9hHXeKHZ9E+pjMT3ZGEzM4jM47t09M0vLk0v4oHpWIydCQpgdtHYt1zluzGE/0cSIwnKX2T/oj+Uve/0loU6eAqS4GdQlbDaKeaJtFFSJqdtN9Nt/moNxz64tsRzpECEnHjOeGJ8MTo38XB1ei0ZBx4Ml/Laq7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvNrljXOs8S6OhrSGpXiYVpW8VU+eFZ6ojE5/3hFU50=;
 b=l6TSo3mGRd0QlslWFzAwu4B5LF9OnmvFLUjLa8uT0vjEr5v6JjroOaBv74uTGGSOgiEissVlmtlvZmHqrdFceu0ekh/QVyODB3eY51oHirRIlxfYKJ6UDqkZBWM8SqCN6J27WlHUEeEUkB+EB4OYp47cbmP2fmjpP4oPle7htrg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7752.eurprd04.prod.outlook.com (2603:10a6:20b:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Wed, 28 Sep
 2022 09:52:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 09:52:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 8/8] net: enetc: offload per-tc max SDU from tc-taprio
Date:   Wed, 28 Sep 2022 12:52:04 +0300
Message-Id: <20220928095204.2093716-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
References: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0006.eurprd05.prod.outlook.com
 (2603:10a6:800:92::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: c0f66d90-f571-4767-77a1-08daa137284c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fQKxoahUg61ckFREtcuws6WNMA4hCqMPcqH8EJlOZNpq1Dtj4Mqki/u6DcHFbohc8LIYmGkKZH23jvoctQuqs2CAUJLzKMR0Nk/XaJBtiblBW0RPrhjKNdFXebdT1AAW+MH0lR9wZatNuXFJ89Xf6rf1dLVtTW3TWHLNioDqxGdXyna1uDQeVQU+wNsaZjv6zRo9OtncFmiz3CfrcFnsLzlUgL2z49s2auxuyw8YdGJl44p/kg96TltKRUTF95qcyO1MdZB46MUJcD9S8laCqpmxGWzdY2ZjGnTG2Nm8WwZvRx31UAiFmyNUUOt1Xd5+dgEVgqp6h+qt+DP/V128ofSkXyVKtDYHfe7N5sg0frUkI3FBkE+wD/U5COMi/zOvkqhZTrURRFE7PkqTk311T/w7SoRkqAqIWlVhIkGfxnTmjLqI7dBflSJJ5UCU1g5JL69hh5wlatwcrSXV5Y39uPmfct0Sq/TFrtgL5k4UgxhzWV2050vyB9IGQxnihng6OlrsRcXUM27voVEgU0869dJ4ZUeA+Vm0ST5vc4vr8mBBZ2vyUzL0VHnDMkBf8SAm+pIvkZJAHfgnj9nbuD3DIcOpuSY13tlhV88IvHImNGFTLOLlLLHm7y6hmDXHjkGqcmb/pM1qrVPYtvcbC3h2EuF2OCVVTBHKcfqpVvUktSReVLjRLCmds63UhdQZpJp5z+XEhpoITxXhf0+pWRi1VKe6tWZKaXoh10t1omBdDkK8ydTX57vrcMKrElbpNfBVjyo06Sp2TuxkKTNe6Em/xA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(38350700002)(38100700002)(5660300002)(6506007)(52116002)(6666004)(6512007)(8936002)(7416002)(2906002)(41300700001)(44832011)(36756003)(6486002)(478600001)(86362001)(54906003)(6916009)(26005)(4326008)(83380400001)(1076003)(186003)(8676002)(66476007)(66946007)(66556008)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dMdrdWVodwJzDZf60yFvNTap1098WRs8ORUVtgbSdFVVhTXbLk0F7kzOy972?=
 =?us-ascii?Q?2WJslCmruvGsoH0BVWWfngbw9/UAlb0Xq0n/iqGNdmD4vi1oCRZGQHuDC94A?=
 =?us-ascii?Q?NPNWix0uOiTCXwaqCGsjquwOkKZUgc1HcQc4eY0aCoDT8BlzDLxCP20E6ZwX?=
 =?us-ascii?Q?ZiF7QRpruSGMlp8iU0q7KhAzvzNOpJzMeqm/xidPe2ZZOQOXdUa8P605gcsn?=
 =?us-ascii?Q?IXVzGMEpx4ZI7HvXJVPDI3ycfVkoCVh/p8FAf8nESIw8Qb6gqmon4il3Qlcx?=
 =?us-ascii?Q?iXD7z58cwjBvzgqeRvZzGXJ4lKpTHe0ydRX6xXsKQ7pwp/RD9t94iwlbrwJI?=
 =?us-ascii?Q?dl7PBMLpqfEHbNC/HqHeIVpc/Z5lZqOm5CxOQWdRHxSB6TGZ4jkbhowXz+vV?=
 =?us-ascii?Q?10NpL4QwHYiHUfO9yo58sg5cyqZCGdUexYPCGiz/MnEymH+TR4T37AvjY9kj?=
 =?us-ascii?Q?y22Lo+LX8kCCpO68fxKi3bL28mo0UZXHbpmIZcKOeAiT40x+aW8RrJ1go3SP?=
 =?us-ascii?Q?trve56w9nIthlrPc3wzn3ckUjrqcZ+eeOj97b5kfeQzwXNtHiee8HKSa71jJ?=
 =?us-ascii?Q?sDNWURIEQ7fOqnlXfel6Ifpji+9tqmh34gc4Ho0YjXG+lkuH/SNKS+aIGxCf?=
 =?us-ascii?Q?oeRLXJxaDBZzZ1XnxmjZKBaS2J0BxaZmfbw/1MBjHgBX3VKcwXtYM00ccs9X?=
 =?us-ascii?Q?QgN1nBr99/m7nbKyip+3m3pkSh2kk2BuQfMozITxLqptndbBHotdMh7ZZ+mG?=
 =?us-ascii?Q?tmbIx9GrebHUnL0XNAJCIh6oufKthiaL1mWUhQm0w/i3shatflLmrIIX/lgE?=
 =?us-ascii?Q?zBKJOea1thz9EQabVnsTS6+QGSmbEeSU3iE6ni1TqDqRMan72bLHFHTf7uvQ?=
 =?us-ascii?Q?8tpDp1tYNKl0vsZaI5iQJCvJAoeEyL9UYPVkwJcjv1439qDzGuLoMZeUkUpC?=
 =?us-ascii?Q?g8zLCgIvSflLqgjnh3IgoUioZ8ghLGwnZRuHEFi+yTiRhdpkdW9f86wawHfF?=
 =?us-ascii?Q?P4CSEbYN+/p7Uby6aIE0R3qtZhTF03Aw/6Qf2ofJW+cpOtyNO3OApdTOj5MZ?=
 =?us-ascii?Q?mNiwkcM+Zlyt7V3DySkbCyYB0JQl1nRSa1ywYCEd/2JJIvsq5+3FRKBD8HPM?=
 =?us-ascii?Q?emC5H3O2b2E/r+3JmItf5HPPCA6hjtKl+ox3xdDOo3XXrDb9w8KyV+slkY6t?=
 =?us-ascii?Q?Ecnypp+LJ1KBCjvKDRxoFmoBExJziPKKZXZ44A4wdUPMA9cmFpYA31yEWb37?=
 =?us-ascii?Q?qcooqzpi95xyuGLM4ENubgJWfiDyVQkozDCR0rM70qk166MhKB9lm6CRGJ4M?=
 =?us-ascii?Q?pEAH0DAGBUQFm4Gfe/Q2fz0eoTlT+IonO5DxOIFXS25yNgKMym2kr+2ZU8Jp?=
 =?us-ascii?Q?mOql7Ew6IlylkiKTl3n9t0a10qC/cu2REKAhC4dVk7XuEX+6ajhaWLwHzo8X?=
 =?us-ascii?Q?zZlixaMgGWPfHl9Oi8xdDjG8EqcGI+TWChOelGsJe+UNv6hOF5Atg9Ad4qa0?=
 =?us-ascii?Q?BT0NIhwg8Yf8bxZylNJLZWlv1CxfA+c84LZJPJKaZCAciB4HTkyNyl9AQYUs?=
 =?us-ascii?Q?dMIPKB7bj67diG1B6VN8mCtEnkTl6NmyDaJA2JkYn/iVoUfIxxjzKvpaJBZI?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f66d90-f571-4767-77a1-08daa137284c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 09:52:30.0063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0kUs++kZU6EE5s732pIckO2mLLcdqo9t10D/v/fOVzsxaGjm5DFiaAHShV3Ygp+M2RuqCH5byFgOiZInvJuYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7752
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver currently sets the PTCMSDUR register statically to the max
MTU supported by the interface. Keep this logic if tc-taprio is absent
or if the max_sdu for a traffic class is 0, and follow the requested max
SDU size otherwise.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none
v2->v3: implement TC_QUERY_CAPS with TC_SETUP_QDISC_TAPRIO
v3->v4: none

 drivers/net/ethernet/freescale/enetc/enetc.h  |  5 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 27 ++++++++++++++--
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 31 +++++++++++++++++--
 3 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 748677b2ce1f..161930a65f61 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -453,7 +453,11 @@ static inline void enetc_cbd_free_data_mem(struct enetc_si *si, int size,
 			  data, *dma);
 }
 
+void enetc_reset_ptcmsdur(struct enetc_hw *hw);
+void enetc_set_ptcmsdur(struct enetc_hw *hw, u32 *queue_max_sdu);
+
 #ifdef CONFIG_FSL_ENETC_QOS
+int enetc_qos_query_caps(struct net_device *ndev, void *type_data);
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed);
 int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
@@ -521,6 +525,7 @@ static inline int enetc_psfp_disable(struct enetc_ndev_priv *priv)
 }
 
 #else
+#define enetc_qos_query_caps(ndev, type_data) -EOPNOTSUPP
 #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
 #define enetc_sched_speed_set(priv, speed) (void)0
 #define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index bb7750222691..bdf94335ee99 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -516,15 +516,34 @@ static void enetc_port_si_configure(struct enetc_si *si)
 	enetc_port_wr(hw, ENETC_PSIVLANFMR, ENETC_PSIVLANFMR_VS);
 }
 
-static void enetc_configure_port_mac(struct enetc_hw *hw)
+void enetc_set_ptcmsdur(struct enetc_hw *hw, u32 *max_sdu)
 {
 	int tc;
 
-	enetc_port_wr(hw, ENETC_PM0_MAXFRM,
-		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
+	for (tc = 0; tc < 8; tc++) {
+		u32 val = ENETC_MAC_MAXFRM_SIZE;
+
+		if (max_sdu[tc])
+			val = max_sdu[tc] + VLAN_ETH_HLEN;
+
+		enetc_port_wr(hw, ENETC_PTCMSDUR(tc), val);
+	}
+}
+
+void enetc_reset_ptcmsdur(struct enetc_hw *hw)
+{
+	int tc;
 
 	for (tc = 0; tc < 8; tc++)
 		enetc_port_wr(hw, ENETC_PTCMSDUR(tc), ENETC_MAC_MAXFRM_SIZE);
+}
+
+static void enetc_configure_port_mac(struct enetc_hw *hw)
+{
+	enetc_port_wr(hw, ENETC_PM0_MAXFRM,
+		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
+
+	enetc_reset_ptcmsdur(hw);
 
 	enetc_port_wr(hw, ENETC_PM0_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
@@ -738,6 +757,8 @@ static int enetc_pf_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			     void *type_data)
 {
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return enetc_qos_query_caps(ndev, type_data);
 	case TC_SETUP_QDISC_MQPRIO:
 		return enetc_setup_tc_mqprio(ndev, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index ee28cb62afe8..e6416332ec79 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -7,6 +7,7 @@
 #include <linux/math64.h>
 #include <linux/refcount.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/tc_act/tc_gate.h>
 
 static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
@@ -67,6 +68,7 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	tge = enetc_rd(hw, ENETC_PTGCR);
 	if (!admin_conf->enable) {
 		enetc_wr(hw, ENETC_PTGCR, tge & ~ENETC_PTGCR_TGE);
+		enetc_reset_ptcmsdur(hw);
 
 		priv->active_offloads &= ~ENETC_F_QBV;
 
@@ -122,10 +124,13 @@ static int enetc_setup_taprio(struct net_device *ndev,
 
 	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
-	if (!err)
-		priv->active_offloads |= ENETC_F_QBV;
+	if (err)
+		return err;
 
-	return err;
+	enetc_set_ptcmsdur(hw, admin_conf->max_sdu);
+	priv->active_offloads |= ENETC_F_QBV;
+
+	return 0;
 }
 
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
@@ -1594,3 +1599,23 @@ int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data)
 
 	return 0;
 }
+
+int enetc_qos_query_caps(struct net_device *ndev, void *type_data)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct tc_query_caps_base *base = type_data;
+	struct enetc_si *si = priv->si;
+
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		if (si->hw_features & ENETC_SI_F_QBV)
+			caps->supports_queue_max_sdu = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
-- 
2.34.1

