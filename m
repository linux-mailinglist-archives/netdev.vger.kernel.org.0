Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89E75BAE32
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbiIPNcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiIPNcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:32:25 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10043.outbound.protection.outlook.com [40.107.1.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755643DF30;
        Fri, 16 Sep 2022 06:32:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvKnoYmqbsl+UYVc3r7E3Prdrku8TP/ZPomq0E6W6BmvLk3OcrMQ8dDOW/QoQkQjab4X1XjBctBsZfo3OixNTEk3rjYyfbA/FN9/bA9l9RP9hv6RRFbGrzdGGzfDqVtJkxwezSCMnlZ0ssxauWlPvB/s64lfxVNeH4nACYV1RdnM/kwiGKLU1+m/IPVDGlw9r7h9M5yjuuvKjB/ju1BUZR5B1klMn3k6ztEg3X2nBZ4XQf03IhErlHXX38sVO/9WIQMkqJZ3pNABitAPlIrn+qKR6r6zp1rVo2SAMFrkO/Sj1+dzZ4mkq8iS/zXJy6x1zhME5e37zgBgGCWyYfHFkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14oUJUgQ5R2P0vp5tu4KfRgE+RSAU2uSDK/VSil476w=;
 b=mV5aMBOzv9gJr95DZP512oc/e2ImqcVRGIy0FLxozokgkCh+zQuZUdexR3B89zl53U2BtApuIjjmluR0CFwZbrR20oniYvhIrdpM+prAg5xnSqbmAI5a7kuSsaAHw/JaV/mRamxrbwztg/OLJVflj2A2jovXBku4luqsy1HlLoCpBW8KJL3jGTh4bR+98H36zXkMhE3qD3dKTVsgVUQlQXdT3ifG4clDn6pK2+yUvbHMHl4APpv861MlAG9m8zNISlaeAYADmtzq1f6J5XoLlrHmKiQgkrfFZ9x1tW/FxD9XD62FQYINcdScno8C2/J/Bnawxtki+5XyuDGdQgo0mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14oUJUgQ5R2P0vp5tu4KfRgE+RSAU2uSDK/VSil476w=;
 b=rpHz4/hqgYkd89zubfLckNseSEK8U49/Mby5taZAx6lT5XUQSfyUOTaubF3Ezz2OSFKdn6hGFZQpbVh/i/PrUcOrQryyJhZBYiwIHTTZLIheQK5dK7+n2YZFgRekPwRY8JacSD5n3S3AL+awY3DrZrVSdB8BkOm4IH36svV679s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7332.eurprd04.prod.outlook.com (2603:10a6:20b:1db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Fri, 16 Sep
 2022 13:32:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.016; Fri, 16 Sep 2022
 13:32:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 2/2] net: enetc: deny offload of tc-based TSN features on VF interfaces
Date:   Fri, 16 Sep 2022 16:32:09 +0300
Message-Id: <20220916133209.3351399-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220916133209.3351399-1-vladimir.oltean@nxp.com>
References: <20220916133209.3351399-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0701CA0050.eurprd07.prod.outlook.com
 (2603:10a6:203:2::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7332:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f337d4b-edb9-4ea9-2aa7-08da97e7e21e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ia07N8KUpyv8M5RZDI6HCB4xswVkF6O2T5OgU60Lvb88uAiR4cMXU9v5HeQr0hZlIfWj0Wy0xlml3OVBJ0Vg7V9b4qS7dtcqn0B1oNMO3vPeYKtC4w27aXlU07TbxmG9413V3RbVH5JsMPrTEQM10BEtAcTmk5+00xN1j+JwyPVhGv4O+f27xBHFn0ZLDLfc9OLyi1eTu2KJQIz3MxS1q5ycFSXfFsi1C+W0ZigDn955vxvMg2DVWFcFGZcHrSiGu0CMARdML1kAF6RnA8uqzJmB11NjcullhS4yoGNXmYtr8ntnrZVpzVfWZ0eOX8Em5Z8U2RAbXv+ESIIuxe35NpYQL8mXJ1N57d80Pw/TVHijdFpqkqgPPds6m4JFfAo1G15cRWVlbRJ/9nJJjq40KBbqOHxW8u4JO7DzsQaLQo9p4Qc4WD3kzSluKFFXCxjY6g9EJv8adx8OVEB8jCc/h/NUP10ji2OGTC8ZD1uvIE/mnTxS2iOC6sX44Wl6n4fVu3fiD7OUPzh+3cDRikVaQsSvHYFnXcr1oJnVLPjoZvEwlbzjESCuddMyWQsBlKVRf7ihGz2SCsqTUlgIdcH1kG2wnz8mgJYUy33BFPGjW0TXp8YHUkf342zH1LwdaEgT9+Ef/AbkPB7PnFzPFAv9tBdLk8Y7QH7PdMLfNOrXBZZsdlDULeCEPZoAL8+fotcgRJEh7V/PzJtRPX8UhdzhmMUmqrwIiqSQwnL24HOHTfh8sBVXOF9p6f129Gxa2IF9Egt6q3cFuqwr2W75xhrMkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(36756003)(41300700001)(83380400001)(86362001)(316002)(38350700002)(54906003)(6486002)(6916009)(2906002)(38100700002)(8676002)(4326008)(66476007)(66556008)(44832011)(5660300002)(478600001)(6512007)(26005)(66946007)(6506007)(8936002)(2616005)(6666004)(186003)(1076003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6BbEOhEjQa+1HXtQAz7WVwIzaneiuMwqJh/ua+032/fsnJltkSlzbjXhvZUt?=
 =?us-ascii?Q?Zr+RjNxH7dJs2eQxXFOX162XuQHja1XXgOTmTbCOpKiO9vcMEXugO2iQr1O4?=
 =?us-ascii?Q?WykYjKxEwjDWI3n0sDGvYq0a0yXa06bq3zBQeuLhfR6AFCwd7KC6mSkxm6u3?=
 =?us-ascii?Q?/K9pZnNqAiG8pAnj7m+f2OOCryhPVGhL3ZjYMI35Sq8Ze4BvFrC2pKl46qW+?=
 =?us-ascii?Q?aPC1cKh0LNyomuVC5lWkiPGNSSdbi8N9fpVNIBYV8u45reEn5cGOwCYz7PRc?=
 =?us-ascii?Q?JnZru0OxJYuA8Mxj3TasmZh0EYEGd5mbCNRD9uwfvtZKyvrAK9bQCVFCz+tf?=
 =?us-ascii?Q?2sHpZLGMkQ6ad9uTF0yrjcIAktQj1B6ChdI8+6SWE9AZUeiomDhdvkMlSsTQ?=
 =?us-ascii?Q?Cf1m173qDa6mREWEBikiaUp8hqq8lNzNqLWDeit335cPwj07C+RXo9OyX71Q?=
 =?us-ascii?Q?KblGqB8jZT+8VdRujLCUccpwJ+VuVYP0VVH7VL1tMIftY98akj3JIQhgOb0B?=
 =?us-ascii?Q?N44/dNXNwHs7EklVNj89HgVihB5QqctK0XLYyOOal7GL2yfKDNUZjQbPOnY8?=
 =?us-ascii?Q?ij7Cr8eoi8sBdZRvedSzLI4MH63G6gCeke69Ac6oqCgFO8+M6aSbZYYfjtCT?=
 =?us-ascii?Q?L5r9Frd45xxIYBhonCkfkyE9dtYn2XZUq1R6neotnE62aRcsVIRq0s6QT4RP?=
 =?us-ascii?Q?nUdbe37F46hUwU3OHsSasKCZyCS0bo7EgEcAU9ZEzPxww8K+UQECG7b31geL?=
 =?us-ascii?Q?kYyafDJBEkhl+6/jUtTj67aA73OJRK72nYPYowecx7R6BaAt4fdHTfe/5z5X?=
 =?us-ascii?Q?62NMqTfPvzNfYo9GfpFpgbGvhh/Y7Nol9tTr05jI4i3CNTgTpKLP36okcyXL?=
 =?us-ascii?Q?DN6iZ3dzOGZjvQY1QTuNyj7gInDqtkXQ4rJenwcBe1zTseiVzu3QCOhFtKEf?=
 =?us-ascii?Q?Q2Jd5z+j2fSEJkpPJCcuykNSpvF9Xtt3HSLMLvWLSiYJJ6lGbnPxZ5IqutRx?=
 =?us-ascii?Q?g/m74mPD9k1LM/WH39gMVwKk0uj3G5e9O+lwevZi1i+hinkPVnOS5a4iEPOp?=
 =?us-ascii?Q?bojmN85sUEN4MmiAzAfImWNqo7Gla12lxZTE7foYBwQLe4w7eMENXMzHN1EX?=
 =?us-ascii?Q?mrUdWqv0kknBt2gZqbsaM6cz1nfG5UC99C5Qz6jFQe/yP0VYc5PT/7gSqlNw?=
 =?us-ascii?Q?Bh7+q7p3L6dGammkNCfG2mGFqAN4O5nRX/s9DkJDpeNyRtHEdG2gOj1n581h?=
 =?us-ascii?Q?V+T7B/qjmsKqHnr9vBkeIxpOUdQogS07d/w6W7hm9wHXw8+mtnIRSl0F9A1F?=
 =?us-ascii?Q?QPPRb6R0rnoylwR1mVPGbSgb8abhJRiuiaENx0DCdsMBFrCTDdHBdRrlq4UD?=
 =?us-ascii?Q?Yl8CU4B0ZWIjr+GWUf9IUwSBndReqCiynHezK1FOpZf/I/iw+Uj02hfq3fyK?=
 =?us-ascii?Q?g2+d5g4ka81QhERjpQ8nUuyhJW1oNYuQhWU6XihAYlOVX2XgOx+QA74EPt75?=
 =?us-ascii?Q?Y56tpzlM9srSRIg2MLYpusxrZ/3sILyrVoO9MIuS1HhmPY6it7fiuBWFkV+4?=
 =?us-ascii?Q?YGKrx7j2Pogh3xN8k06xq/5tnJroeyrEMnz9iuH2oV8hTCDlQX0YzCQF1AEJ?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f337d4b-edb9-4ea9-2aa7-08da97e7e21e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 13:32:21.7276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 97Syi0K7wzUErGKecR/gQO0JA0W0dAhTwfAOWhsOCI4Md0RlsS6IbEVhnd2FUmKVebfC6mw3cdRlc8nnQ2TmAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7332
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TSN features on the ENETC (taprio, cbs, gate, police) are configured
through a mix of command BD ring messages and port registers:
enetc_port_rd(), enetc_port_wr().

Port registers are a region of the ENETC memory map which are only
accessible from the PCIe Physical Function. They are not accessible from
the Virtual Functions.

Moreover, attempting to access these registers crashes the kernel:

$ echo 1 > /sys/bus/pci/devices/0000\:00\:00.0/sriov_numvfs
pci 0000:00:01.0: [1957:ef00] type 00 class 0x020001
fsl_enetc_vf 0000:00:01.0: Adding to iommu group 15
fsl_enetc_vf 0000:00:01.0: enabling device (0000 -> 0002)
fsl_enetc_vf 0000:00:01.0 eno0vf0: renamed from eth0
$ tc qdisc replace dev eno0vf0 root taprio num_tc 8 map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 0 \
	sched-entry S 0x7f 900000 sched-entry S 0x80 100000 flags 0x2
Unable to handle kernel paging request at virtual address ffff800009551a08
Internal error: Oops: 96000007 [#1] PREEMPT SMP
pc : enetc_setup_tc_taprio+0x170/0x47c
lr : enetc_setup_tc_taprio+0x16c/0x47c
Call trace:
 enetc_setup_tc_taprio+0x170/0x47c
 enetc_setup_tc+0x38/0x2dc
 taprio_change+0x43c/0x970
 taprio_init+0x188/0x1e0
 qdisc_create+0x114/0x470
 tc_modify_qdisc+0x1fc/0x6c0
 rtnetlink_rcv_msg+0x12c/0x390

Split enetc_setup_tc() into separate functions for the PF and for the
VF drivers. Also remove enetc_qos.o from being included into
enetc-vf.ko, since it serves absolutely no purpose there.

Fixes: 34c6adf1977b ("enetc: Configure the Time-Aware Scheduler via tc-taprio offload")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/freescale/enetc/Makefile |  1 -
 drivers/net/ethernet/freescale/enetc/enetc.c  | 21 +------------------
 drivers/net/ethernet/freescale/enetc/enetc.h  |  3 +--
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 21 ++++++++++++++++++-
 .../net/ethernet/freescale/enetc/enetc_vf.c   | 13 +++++++++++-
 5 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/ethernet/freescale/enetc/Makefile
index a139f2e9d59f..e0e8dfd13793 100644
--- a/drivers/net/ethernet/freescale/enetc/Makefile
+++ b/drivers/net/ethernet/freescale/enetc/Makefile
@@ -9,7 +9,6 @@ fsl-enetc-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
 
 obj-$(CONFIG_FSL_ENETC_VF) += fsl-enetc-vf.o
 fsl-enetc-vf-y := enetc_vf.o $(common-objs)
-fsl-enetc-vf-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
 
 obj-$(CONFIG_FSL_ENETC_IERB) += fsl-enetc-ierb.o
 fsl-enetc-ierb-y := enetc_ierb.o
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3df099f6cbe0..9f5b921039bd 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2432,7 +2432,7 @@ int enetc_close(struct net_device *ndev)
 	return 0;
 }
 
-static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio = type_data;
@@ -2486,25 +2486,6 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	return 0;
 }
 
-int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
-		   void *type_data)
-{
-	switch (type) {
-	case TC_SETUP_QDISC_MQPRIO:
-		return enetc_setup_tc_mqprio(ndev, type_data);
-	case TC_SETUP_QDISC_TAPRIO:
-		return enetc_setup_tc_taprio(ndev, type_data);
-	case TC_SETUP_QDISC_CBS:
-		return enetc_setup_tc_cbs(ndev, type_data);
-	case TC_SETUP_QDISC_ETF:
-		return enetc_setup_tc_txtime(ndev, type_data);
-	case TC_SETUP_BLOCK:
-		return enetc_setup_tc_psfp(ndev, type_data);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int enetc_setup_xdp_prog(struct net_device *dev, struct bpf_prog *prog,
 				struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index caa12509d06b..2cfe6944ebd3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -395,8 +395,7 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev);
 struct net_device_stats *enetc_get_stats(struct net_device *ndev);
 void enetc_set_features(struct net_device *ndev, netdev_features_t features);
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
-int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
-		   void *type_data);
+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data);
 int enetc_setup_bpf(struct net_device *dev, struct netdev_bpf *xdp);
 int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 		   struct xdp_frame **frames, u32 flags);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 201b5f3f634e..bb7750222691 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -734,6 +734,25 @@ static int enetc_pf_set_features(struct net_device *ndev,
 	return 0;
 }
 
+static int enetc_pf_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+			     void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return enetc_setup_tc_mqprio(ndev, type_data);
+	case TC_SETUP_QDISC_TAPRIO:
+		return enetc_setup_tc_taprio(ndev, type_data);
+	case TC_SETUP_QDISC_CBS:
+		return enetc_setup_tc_cbs(ndev, type_data);
+	case TC_SETUP_QDISC_ETF:
+		return enetc_setup_tc_txtime(ndev, type_data);
+	case TC_SETUP_BLOCK:
+		return enetc_setup_tc_psfp(ndev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_open		= enetc_open,
 	.ndo_stop		= enetc_close,
@@ -748,7 +767,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_vf_spoofchk	= enetc_pf_set_vf_spoofchk,
 	.ndo_set_features	= enetc_pf_set_features,
 	.ndo_eth_ioctl		= enetc_ioctl,
-	.ndo_setup_tc		= enetc_setup_tc,
+	.ndo_setup_tc		= enetc_pf_setup_tc,
 	.ndo_bpf		= enetc_setup_bpf,
 	.ndo_xdp_xmit		= enetc_xdp_xmit,
 };
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 4048101c42be..dfcaac302e24 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -93,6 +93,17 @@ static int enetc_vf_set_features(struct net_device *ndev,
 	return 0;
 }
 
+static int enetc_vf_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+			     void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return enetc_setup_tc_mqprio(ndev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 /* Probing/ Init */
 static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_open		= enetc_open,
@@ -102,7 +113,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_mac_address	= enetc_vf_set_mac_addr,
 	.ndo_set_features	= enetc_vf_set_features,
 	.ndo_eth_ioctl		= enetc_ioctl,
-	.ndo_setup_tc		= enetc_setup_tc,
+	.ndo_setup_tc		= enetc_vf_setup_tc,
 };
 
 static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
-- 
2.34.1

