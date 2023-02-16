Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAF669A24C
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjBPXXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjBPXXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:23:23 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2089.outbound.protection.outlook.com [40.107.104.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B096654D0B;
        Thu, 16 Feb 2023 15:22:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtDJZN9GfiRzJG4CXvflTDA/3s1MUctkag9xoebsJpVoXJTWomzUHVnYBMNkynnMwMzlVorQd7EQzEOVHIBKaV54aIM8IZoStsDLjuH0BIs01RotPzXgVSPHjLHwH1EtTLm0K8hVlZM3JrTbM9WDEwVUM+1KdWe0dowEPxH/La35dJlV5U+ZVdb25nVVicsOhas5fD+Z7PU+w/s15Nx4ODdlg63j6VpkXBAyivlyUEua5Er7IAn85EQH59229/76vWhODfUxxnQwzmOsYiRL94yTKfXJag4ciXxHUwhMih8tr0AyZntzx0nKeGs5XalnezukZ7sJIEojoN3pQ7aAiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3T4BHjiL3x/4CkYmBq68my7S7dLUmIM77eYFaSDln3Y=;
 b=avMDexf4SZFh79TntXD43ucLqscCCVe2hzMKGMtpXDtjbljyhgQh5USnACu9sfil73LwAjuCJjYZkYB6WJgGP7tJCys41wE+ih0YrxyMmuta7cXpnlnG8n020uINQCnvjKx2jeDZvxmobHWpXzM+phGTqxYdwAw4hFKF9MNa2OBBeWY134xEMDGyw6Xula2+BAfT7jJApqVfmK//5oSC4c/v39N1Zs1s0xVCtQ03y2tczIPlY7ZEa8RaJrQYRYSSL4+T1onx/t2lLMJtu9F82ZTZps69BJq10gSf9gbBVPDWdITAJPNe1oxF4tSnKmygHqY6SfKv2tj9Fia6uz/1dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3T4BHjiL3x/4CkYmBq68my7S7dLUmIM77eYFaSDln3Y=;
 b=qfBwBuuAfmsUsyN1Dt0Ot7Nkng5G0l940hsX4G/ooOqx/YyfkMMpGyEhC8r8oQvnC8zBmdX6pEyJPug8d0vnpNNWleRSh83y687aoGxlKJiWBgo8BRCd2439bkn63gVuoITz+YosUljZ56yRRhFxK+D3EQaD+WgkpY3T54n4Awk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 12/12] net: enetc: add support for preemptible traffic classes
Date:   Fri, 17 Feb 2023 01:21:26 +0200
Message-Id: <20230216232126.3402975-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: e8911449-bddc-44a0-99fb-08db107496d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rsSqckUAYaUWd4B4rLVrwbIP+CttgSC7u03LVFj5/a8CG1q3iQWLWkxYHoZXapa35hyTWW4+lvy3DqSZNlqjEhYLVBE6rp9cZZHFkC6hJVkUbSiSQslwJ6Zc4mw9I8+nhocAHV1F5naonXO3LA3RGwpQtjPnSeBtZklM4MAPNTp9gtRJEgO15JPmM3J0ZdJRO2BQXgCAP3DwXJKnsgsKFhRm59BiCGY0YO9CZ/siUAOy6Sel7KqEPRYguhJYPft5AMKiaXvPXH/MJzyTek+UEpR1rNZlPcb2WWHEhJeBVTldwmz5g2lZ5o70fRniZ//ARdXbJcx7uIrbXax/WYtGNDeOVzVbm5TgYAnMVFXlcS6y3UDkFgp2qtBYGeDRHIfLeB0cX22bq5cONcEEJr/LWfY/Gab+xXT+dTaLM1mA50t/+YdlGtd5m7FFVwL1XUd5OxpZcjIbBLxgKsp4AEaikh0r7mxJutbxVymkcB+2+JO00g/pL8JEGeaDDsOrG55qlDy7Dw4KsNNLwwcYxWkF12puT2Fd2bUGN21wldMOIrlVQ1mdFrDc16mHPCLJbf1oNAg0uWJHSaJG0fKnrMCSgYTKwp/S+a/FHoWr7q8wqFQ3q02PVvqnzm4qHiNi0ImyCxeJK2OlCA5ppMmgKgjoGkpmRSjF5bmoyGpQeebc/KEwEl+zmXnp1A+BuWiK9MoYjWTDwpwrMkC83t4Pct715w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(83380400001)(66476007)(2616005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EWs83fWYUA0o1FfJgzqm/4Nanj7jEWQm8hl2VmhspHNV1NNZ/3yvpbae+OVb?=
 =?us-ascii?Q?bzfRTfkx8mV7+QlnitU+axjLqZYc4isuidGetge+X0iDF4b/guj9KerHPHcz?=
 =?us-ascii?Q?EyYSJXV2gzb60KEv32SYPcQhvPYUiZBgGC76SQM3x8GeoqNNdG6PKzTpJSH+?=
 =?us-ascii?Q?77Ym5Y7EWAV0oOMXxYUclaEklKwxOoIOK6E1IWbG5nsrUBt+kR2UnQZr+cgM?=
 =?us-ascii?Q?62FBpzgY/l2UvHFHmrTYV2Cww71PWaQJnxNiLkSjb8zCn2kTiwuCHriqrwyx?=
 =?us-ascii?Q?UtJdEteOPKB+WO2xN8R2ORFOWoIt10nbO8A3dtN9o+xvtZxtqLW0puvBhfar?=
 =?us-ascii?Q?v/BgUcbsrcaPEyas6T1dbO7vN5ekyfM8XZK4yoQOWFHhBckMtItMAgdGX6yD?=
 =?us-ascii?Q?IFdG8l4oLNtEKcO5KaVAo5Pbu1ZIMHhWD9g8GO6cZcllz22bari9OHMNlCis?=
 =?us-ascii?Q?/G+P+/lSOI1Zmp1sjakzmFLNAwMEht8elI2/mAKiiHqyMth2Cj69QzU8lEMv?=
 =?us-ascii?Q?aq3jxXH3hJZJH1SWZV7kboYGqu8X1zDgDTfQhX3QE73Jcau6UCnCiwZy/bOD?=
 =?us-ascii?Q?ATLsP/7KtmNv/6UqWWla7s+nZXfsAdp9NEMaCO/axR9nMRWxx9Wq6ayCDrIa?=
 =?us-ascii?Q?iBjQqIrrveAnqW6oUQ+oI+6k0duqws5Lk5jwyWmkJ2TjZMTneD2AwVlzVe77?=
 =?us-ascii?Q?1pQUuYte6mmPMBo7h4PXXFhaScRaVmp9TZAKLlErYxFiyzBl5qcSxWoVFzZC?=
 =?us-ascii?Q?Lsyj/sMpkHzaoQf6NV0McOBZJcFUenMv274GUaCXHF8ODguR5qmwBnZ3xLLM?=
 =?us-ascii?Q?XgFkWQ4WnH/NJmkU9XF09TA+vsEW3zw8tzaD5UU90xaY7wfZwhjgPuAlEnI/?=
 =?us-ascii?Q?/Ki9hLvoJxf5Lv8Q+UqLaBC2Bzggp7wJg7tzaJHxrC+97wm2u7hYGaRKDfas?=
 =?us-ascii?Q?ZDm/faMVq8F1Q617xW4diDJQgkzw6hu1Wkh+be9OoLJhCiAzI/1BUzG0N8eY?=
 =?us-ascii?Q?C/w/46iaNOt9tdUH9rBSykb56SX5RZafqbveBE2GqRmbw9kXGg12tr4y0AQD?=
 =?us-ascii?Q?AEvSFyyBEVEZ10jBbx8ya/P2ZsEQBCCmEkjdCedVFBdwRv8hOgi4VAjSJM7j?=
 =?us-ascii?Q?7BjiT7vQHr1C1bjCE/785o+rFpcUHcowRY0wZXYbHqD8C8urLL76Kg1D9lMR?=
 =?us-ascii?Q?YC7L0zIDELA9sZrXsyJW4tgBq2jv2lbDyqR8gGlygZ6ZY5d/Mx4A3LM2fDPh?=
 =?us-ascii?Q?9YNXtbiFd1Kxk7e+45Ge7TZg6OPgtzqCn4CR7sxA5gmGprxeUDkurA/ziCq4?=
 =?us-ascii?Q?COMeHGT4f1kIbkwvCA6zD7j8n9Swn15Zu9cBHZl+CAhnWAJqRr11C10GUCvw?=
 =?us-ascii?Q?Vf5ayZUQub0T+lNKlOwW01sIl3ZY8DoSF3hHP9IGgK+OP4NvkH1uSxBsFMnE?=
 =?us-ascii?Q?jzOOJfGdMvX7hLjg1mbHMQ/d2KsbcGn/j/QGw9Qv9g4dryjD/vTG39ZBBHkU?=
 =?us-ascii?Q?meUfFSIMOG3cExsz3Bt3ewJIQL/TEgi+vfDqV4dlzsIp2aLa4yqbZo3zN7nA?=
 =?us-ascii?Q?BbmrhcUik0AKgvskOmOVwH+Gicr9cnI3Y+TSqXORBAlWwCWxpxrl/dFeEBMW?=
 =?us-ascii?Q?4w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8911449-bddc-44a0-99fb-08db107496d7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:53.7582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nu3vfOyMkgFsQ+i7S2Kkaai4W59X+YOK6gLYNSB2OB8GnqFS0Pe79stX6FEJaVgLQoZqNiV413H/h5DMMCU0Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PFs which support the MAC Merge layer also have a set of 8 registers
called "Port traffic class N frame preemption register (PTC0FPR - PTC7FPR)".
Through these, a traffic class (group of TX rings of same dequeue
priority) can be mapped to the eMAC or to the pMAC.

There's nothing particularly spectacular here. We should probably only
commit the preemptible TCs to hardware once the MAC Merge layer became
active, but unlike Felix, we don't have an IRQ that notifies us of that.
We'd have to sleep for up to verifyTime (127 ms) to wait for a
resolution coming from the verification state machine; not only from the
ndo_setup_tc() code path, but also from enetc_mm_link_state_update().
Since it's relatively complicated and has a relatively small benefit,
I'm not doing it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 22 +++++++++++++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h  |  1 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  4 ++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e0207b01ddd6..41c194c1672d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -25,6 +25,24 @@ void enetc_port_mac_wr(struct enetc_si *si, u32 reg, u32 val)
 }
 EXPORT_SYMBOL_GPL(enetc_port_mac_wr);
 
+void enetc_set_ptcfpr(struct enetc_hw *hw, unsigned long preemptible_tcs)
+{
+	u32 val;
+	int tc;
+
+	for (tc = 0; tc < 8; tc++) {
+		val = enetc_port_rd(hw, ENETC_PTCFPR(tc));
+
+		if (preemptible_tcs & BIT(tc))
+			val |= ENETC_PTCFPR_FPE;
+		else
+			val &= ~ENETC_PTCFPR_FPE;
+
+		enetc_port_wr(hw, ENETC_PTCFPR(tc), val);
+	}
+}
+EXPORT_SYMBOL_GPL(enetc_set_ptcfpr);
+
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
 {
 	int num_tx_rings = priv->num_tx_rings;
@@ -2640,6 +2658,8 @@ static void enetc_reset_tc_mqprio(struct net_device *ndev)
 	}
 
 	enetc_debug_tx_ring_prios(priv);
+
+	enetc_set_ptcfpr(hw, 0);
 }
 
 int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
@@ -2694,6 +2714,8 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 
 	enetc_debug_tx_ring_prios(priv);
 
+	enetc_set_ptcfpr(hw, mqprio->preemptible_tcs);
+
 	return 0;
 
 err_reset_tc:
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 8010f31cd10d..143078a9ef16 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -486,6 +486,7 @@ static inline void enetc_cbd_free_data_mem(struct enetc_si *si, int size,
 
 void enetc_reset_ptcmsdur(struct enetc_hw *hw);
 void enetc_set_ptcmsdur(struct enetc_hw *hw, u32 *queue_max_sdu);
+void enetc_set_ptcfpr(struct enetc_hw *hw, unsigned long preemptible_tcs);
 
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_qos_query_caps(struct net_device *ndev, void *type_data);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index de2e0ee8cdcb..36bb2d6d5658 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -965,6 +965,10 @@ static inline u32 enetc_usecs_to_cycles(u32 usecs)
 	return (u32)div_u64(usecs * ENETC_CLK, 1000000ULL);
 }
 
+/* Port traffic class frame preemption register */
+#define ENETC_PTCFPR(n)			(0x1910 + (n) * 4) /* n = [0 ..7] */
+#define ENETC_PTCFPR_FPE		BIT(31)
+
 /* port time gating control register */
 #define ENETC_PTGCR			0x11a00
 #define ENETC_PTGCR_TGE			BIT(31)
-- 
2.34.1

