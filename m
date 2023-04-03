Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661536D4230
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjDCKgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjDCKfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:35:53 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2064.outbound.protection.outlook.com [40.107.104.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E0AF74E;
        Mon,  3 Apr 2023 03:35:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDa0W10bAPqF+w+BuYj+9SslsIr697SAEfQcbVEiwBCyvgwkC5EETF8y1LqTaZ4hu/FTyJYlKJ2UDJOoUIW1Cgdm/eLZhSl2cjXW8MauxfiGWpS+mLxDfSgEyA74IUWkyhmPIjBkz4rakMQ5miufBnZwcqMB8tbs93gg6ginLbV4nCmvYr6l5xGZ7Z2JYILHDB7UVJl49gh9Z8z5a/3QAiGL7N1/5wMkw79Y7Rk62JHS5VxsLUWvcdbsZ+uc8mNbTDrIhhwVcbybUY3o9vZ2Yl7jMiHgioe+4bZIhG9T9+CU+c1KT1GukKwKVqTj0WfJXTDDcbzDQqqVY88mIrn/ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z8zEq79FjoG5oEijxtnUWrNee5FdcLjHhpKH5V2iIiY=;
 b=AzW3y0hwknv3gzGF1vEyjknkViDutpNT0ktf7/grFQwTFEW90mHfrXD2bWnKHq/EmWEz4qsuxCx6YWSbxxn/KHtT8IrQ4I+UE1rVxMQCSriabKuUtiEkcKLlAq3KFldhZhqs5MBos4yH4n2Peg+RzUVRjqLUnspMY7MKS91BN6CnIPgTTG8okQMWdLo5APsCjhQpVW4/s43m0W3iqSwa2CPzjCqPdvYEU1z4I7aoZ1/O5zkNBX0W29lBVgH91tt5GmUcPuRWbDh3Wj2nfoQqdfpqcl9ddXXMzzy6+30NEPnhvArfaSs3BEp2PoRZ6qrQP7Pr7fxv5W00qTA0hw1LuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8zEq79FjoG5oEijxtnUWrNee5FdcLjHhpKH5V2iIiY=;
 b=XP/C8ZLMHnL/fVVfBaduMV2JgRaLO5aos2iu29iZt045J1m5mXNeoezxs2TqZHNB3KE7FVYUDZ672lZfciVmk3X4pnKsxBgwJ2W/Trho/y4ZQSREd5nRVidHUvFMrHvKNdW83f0zk3sbA3agGKdZaGSBDiSLoM9dCvwBfScN9eY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7536.eurprd04.prod.outlook.com (2603:10a6:102:e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:35:12 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:35:12 +0000
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
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v4 net-next 9/9] net: enetc: add support for preemptible traffic classes
Date:   Mon,  3 Apr 2023 13:34:40 +0300
Message-Id: <20230403103440.2895683-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0221.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7536:EE_
X-MS-Office365-Filtering-Correlation-Id: 920ea710-592a-4d66-79ec-08db342f1a91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TDHxl62FuaBBW868WBysHFe56KqDHimnr6L/6HTDES2o6d8oClq9cnbydCPYzy+VB24u4FyHrVQUkrJDEzO+YSj+Z9KZuanu3k/WNONdTCwL/krlE8zEk2gkLU7ERbqQbKaOBfG59hbGyXRnnKmcUpSwDoTWRRz39nXKGIy+EZNHP3s6FD4qV9gjM1QvKHIVInXrhc725jbJWqbLz+1vEkD/o0GZG4sL1Fpve65J9seN6QLmREA8w/fJ1h27XR/s8h1W1E5oExasoZ3/ZDAHKO2p3noZ/SakZqjZsuMwlR9iO1XZqKP1DanOFi8NBC4Zf42AXzlQpblmpJTItoH/edTuEslEy+ebxpBOyDFYSi5eGrKfnXAkt85gVlqtI88un3GH1suhZfTpnK4IkfqmoE79Qgt3KfDUdbYV246CJQ1c1RypTMRowYfPlU+04ccrlhzCKuaWad4Sp1pUKmv+AB176zLNE+GSQdRZMyZPFuwHzH5zRKM03Wm0c6/qyZTwMoQEjQ+//pHh3vairO4TtOPmssKwDUecbEFMztXF4pqVlYv8r1v8w07RH8K9p6FtDYwgEIY7QAdzTXsc/XfLK6X+rbfpAm2nGISvEaBlvsxXTDoTWHBLvnTKAvH0OxYo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199021)(8676002)(6916009)(66556008)(66476007)(66946007)(54906003)(316002)(478600001)(8936002)(44832011)(7416002)(41300700001)(5660300002)(38100700002)(38350700002)(4326008)(186003)(83380400001)(2616005)(52116002)(6486002)(6666004)(1076003)(26005)(6506007)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q45ZhJyBBfyUoQ9uXGmEnJmfDwrVsUjdCQKy03GPS4mdNZImFF9KWcD47roi?=
 =?us-ascii?Q?m+HMPk0S3mDvG94mWHUNIPPhzr9rw1BjC6eEqs2dQPZyGw/tmkhqju+Bvyeu?=
 =?us-ascii?Q?UYWmu/K3viUkoAICw7WUlVEdz923QKvfcHTDZGRP+8+X6JND8s4HLhd2ERvu?=
 =?us-ascii?Q?FzcM+8zyCWEI+/bKp5UezpRm1YD3X2/idm1hlUm7KJ47qgy4WAfprNFLhbJp?=
 =?us-ascii?Q?SBqRlxkqA0XGGbiBwUUam5XhAZkPyakiCS95+HFx3K1DI2PcGTRSicpGlnzh?=
 =?us-ascii?Q?DdHDnuLBru+QOUr0DRrufGC3Nm+wy4MuYGJK8CUy75+pB0+IkusTNQsqQx1N?=
 =?us-ascii?Q?1A5UED77Hm8XE5Rd6iFYtMSOYE6f6StT3S8qQ/592++RsgWV++6mr0vbzWAA?=
 =?us-ascii?Q?tIJduF5/SFRFxjw75MnMS/ywrrgeHCILJEDFSqSgOOGHAwCoRy4uA062Ivp0?=
 =?us-ascii?Q?2iGDoc1/TF/5/d3f0/k/U1aQpLnksCsJNhaH9syqaC6KAm0Z2VAL+sniIZGz?=
 =?us-ascii?Q?4iQVa6lUBcp4GTPdY0uaEw1IRr5Kx1Dl6pqeOF9RAg0dFHREY984tU6VNZ5b?=
 =?us-ascii?Q?WRstPMEMTwadcHtiQimyRXQfJzKow2kiwbsp/IvAWeuuRfBbApSU/UnTbVes?=
 =?us-ascii?Q?6q5ILH4D1vPe0adCNfAFZse3SRV6zjvOmlRl+tBdC7cRrg5BSd+r2eWd1eey?=
 =?us-ascii?Q?gIaCI54hw1o6fBR8/sKUP9glVeSNL0TAX/N0uSxkXmdSudq9hmHzh9rYncVU?=
 =?us-ascii?Q?Ir56qgFKp0fzkQePgX9hZRHTjU11p8GYAbJngZ3lJWQYJ6xtPYyl72Vq4mT+?=
 =?us-ascii?Q?DnGU0Tpxhxb9otsy8F4YOWLEB5PulWWaLz9J6uZ8M0cMpM8rbdBb7LdQ0oUE?=
 =?us-ascii?Q?NG0u1ZKNJlJCP+ccEv3UjJEuLaFutXNsCoYUFt3akmwvKRyDIFI3SXQWSzQU?=
 =?us-ascii?Q?behZVA+j5cs7oNDXdNWJ04FGl+wiaXwMKY48gEbjRcZRidQi6XeAOyjqyze5?=
 =?us-ascii?Q?TOvMDZDyEjlaXUqMVHEHWX54pjVEHjG68oPeUtQ9/5HpcSlLyPMNBIgYzBRJ?=
 =?us-ascii?Q?f830TXOkbnvkmWvtBlCxHTbcv71ISOmM/fAt04Kd+xAkR9dIxOc56nr0g4ZN?=
 =?us-ascii?Q?N4PEOcQ72m4uox4iXNaEfZWWgs2bc4prHHkLv6v3cDkYJK6pFlXegYPk/MYI?=
 =?us-ascii?Q?DkFcST/Hd2/MoOUWWFpsv5SlQrfnF9lqoHscB07R6e6ZZRp+H0zYlwKP1aUe?=
 =?us-ascii?Q?jSAO/VLWAKHmgD5ZK7g0R1DEOcWTAtznBF3Cohbbev3oXNXDKw9X+GItE1Qp?=
 =?us-ascii?Q?8hRVKj/ChK1vtLAQ8Gi2VKgpfI/r8zWVhp/ClUh6QciMUw8usk7zkIk/fgqu?=
 =?us-ascii?Q?7YeFYuK5Z/g5qCmrhItFLfssPGL165knltgmrTi/fA4/ic/8DajZPFypxXNQ?=
 =?us-ascii?Q?nQOr7fq5wOnijPN/tB+P6NHBBRRK+8XA1mIpz7eoVuMf2HPmCMZ3g+hC4i5f?=
 =?us-ascii?Q?m254S9ID30Yw++5YXCgmjRKqdgBEIv8lkCw8XevikXaw6qnReHmE4+P9+8wQ?=
 =?us-ascii?Q?/AeEyKLa4Jrdo1LUdgPALP0z1/yoC7hfxehVsOYgSFadLUvhgczEuFe89R+U?=
 =?us-ascii?Q?Rw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 920ea710-592a-4d66-79ec-08db342f1a91
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:35:11.8878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rP5FP6wUUfnPJYdugtGpzNNGBqF5TdFjilYV98MnEgJHF6R+IVqPPdincZEI4+3I12n3FhLBR/ERQPFxYD6ONw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7536
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v1->v4: none

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

