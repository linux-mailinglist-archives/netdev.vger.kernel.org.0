Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD1462C8ED
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 20:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiKPT1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 14:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbiKPT1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 14:27:30 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2087.outbound.protection.outlook.com [40.107.105.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C245E9E1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 11:27:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJWCiDpPwjwgatb4tj+5KCMX9Q2Yin04EXX5mV/Lg8Hq1Yqkug1kKlx/adn/4zP4xr5T/8+RX1tMbeyWHOikeQFthlWz8waU5cJtTwTZUiFnvKGaCUeaMdyrSt3nymEqOL9BUC+lr5mSWJJHK8rUExFPeulQWA387kSKfhcOt4p0+iQ3UgItSMy63IxxfBN/j/kFI6JRLjP0ZfQLJfDeziYuXeKJyLDdqyJCuI1tzW/oRNKT2HkdanDByYec/g6qCOHIeui0LfjCX4NNNKD0T0fkZZPr7QSUA/VS4PmUjLRyjc+yVSePNabxJoXu3Qdp3Gd/vhqP5ndQK+MoHeEoIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QsBf3woVrfTmXNBDd/5MRPoC16HQpFtINy/LVpHV/W0=;
 b=lmDpx1u+h/Xda1N1KTj4QtiNJzwRu75Kb4bCI435gUfkbb/EYxivfgLDhaS8DQdOPkOchXDefrtt8wa+QSEi6ztaROVINGXA2sOwvqYWNaafEsas4iwWmj2RA4zghwpk2jwEmmQ2C3ic/0maC4FHr/g/AFc3sycwvX09MFv1S7xHud8WslLqXnV5jqBBFs9RTcc3hO3Whf6mfuXlunJjtBv8GAsOlKDnNkHIdq97hnI8HipdTnSAbcCMdIrsoqQl0Kh2El3NF0fD+aVqUmJBduNCMCp6tmjOo5mkWz+22LEJQq3aCaf31oSKKH5inhq1n3NdIe8CQrd/viH1WzSQgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsBf3woVrfTmXNBDd/5MRPoC16HQpFtINy/LVpHV/W0=;
 b=tD7k55Hrx0kQUW7UfWrI+K0TaTq32JbX96Pbi3Uqmo720FNYyO6vE7r38UsRm2sf9xMDAPgfE2CgAF2NJO2kJdnJI8EI64jbne24EkzIh+aNJD9PB2qAnR/V1ZK9Jho+uVM1ZkqTMHPBlEQu5Kgws5BlNbzwB0wYhYZBBYoH1fQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7723.eurprd04.prod.outlook.com (2603:10a6:10:20a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Wed, 16 Nov
 2022 19:27:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 19:27:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v2 ethtool] fsl_enetc: add support for NXP ENETC driver
Date:   Wed, 16 Nov 2022 21:27:05 +0200
Message-Id: <20221116192705.660337-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::13)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBBPR04MB7723:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d5eec73-42a8-4213-c9a4-08dac80896ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hhXebn6oYoosAXKBOtYLniLNmEpwF5pTYYG9Yd4zO+eyePwiRaTEiNogVpBl/c1fL/lUg2t11OsejEyzAaNk3zpdvx63Os07yuWM959TAx+iQYv9BKOygzFahOrE8hIOndBwxmQzjVSQ+SvBipzOC6yveYH+DYUcgo6Lpka5LCQNSyriOuro2RLHvCpuF7n88KYy5Ff1hYJT2lUfmZiiTbWqhTi9PWUo53vN8rnvyVXcb7L2J5Gz3bDFfOq+57Um+0kZnFiXRbdO/YsT5hnTTmWkp+ekupx8qzmGoBOWWcmhrheokyS/1AMLOoR/WjY9ADf981To87dMBE2YXoxIAwfm6Cb7fnU9X3EjEn37lla6OTuffPUkgN3lc1ZfWF8IWw4GyGCR1uQaErfB4S9NFR8b6OR5jc58FVN0FXVI+zR8G9CIH00/0L+kw3JU0Cx6pTHee9tlRJJvkFcAOZt88JYG7vM4yzqek6TOCuzZuhIRFogAfb8eTmbEOva+u+GIkWvVPPXGYc5k939e5E6U3ACgEXyudcSfbd4AGqFHia0t6ToKiM3Xe0bt54q/2aDHDdNlBVSGmClrZCoWM8c21NTuZs+Dc1ATKy1IL2K70p0gG8pfRkEmrcyZMtwF6JwD8jOqiwxjuWZtxQTpkdpcOe+7IczZJTYOrV3dPneWUJV/2LZck+38jmc3VIVgt0nx7egnt4Q/6luLp0ZI2+YMXieOK/aKYjm9eyPnImfXduqdANOlW0ewH1FELLCMOnrI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199015)(478600001)(6666004)(6916009)(54906003)(83380400001)(6486002)(4326008)(66946007)(66476007)(66556008)(86362001)(41300700001)(6512007)(30864003)(8936002)(38100700002)(2616005)(5660300002)(52116002)(186003)(1076003)(36756003)(316002)(44832011)(26005)(6506007)(2906002)(8676002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ekgJcRRIJtsT0cgr75FVbjLmfq8S7ZxA+gOQO2ws6lmF4LfeaB6ewDlpV8ze?=
 =?us-ascii?Q?laAUlG2TK101P1Ugj1r8DTogKLhCa9Cuxt2FUUgtbgbUEUa2Bhtwix/iLrtb?=
 =?us-ascii?Q?F6EF/4kcaBtaO+fE9xnSD3vTw0ncUbGe/F3+e6SuBblxQjfugL2F7Q2pTYlr?=
 =?us-ascii?Q?EDCmS/1Q5z5hQ29osmIxoVJtMNpDNf2mD9+tBTNiwS0WTa4W24LFIHoSD+Lu?=
 =?us-ascii?Q?cZgwRLy9WOzImCZxMS1D8m0UKOJbMmHGlqneFSrKFXJUdVRBC9l4dqXJgA9E?=
 =?us-ascii?Q?3hwuZJJoGmP7x6V7879NdJdpnVntOFo+1N0DOToCkc1WGbwTdGQsat3+L/SC?=
 =?us-ascii?Q?Xd+HXs0cdKpv+tumBvfYTl9ZaO3nLRpcbLvS+gbEQIhcPwL6V9Lo3PzFcIga?=
 =?us-ascii?Q?0dykCuEktDvpo3m53e8AD/WQ8lmJiDklrYzx4of7PmU4PbdWeb3t5z+CJWk1?=
 =?us-ascii?Q?KwUK1HXOE8D5727/lr3mO8pfWSWPBsOHxqVaVgk3sikzSROz18jm0fbLBwds?=
 =?us-ascii?Q?u7Qd9oumGZ8jS/cMXB+LYGQvmp87CeCp+F5n8UzAMMQQ+cVkF/stL357ugQT?=
 =?us-ascii?Q?cRpA2AVum2qSVY0YA4wKmuLMijQ9trxi150bfYakJ1MxSkElzl7wBk+Kz+Sq?=
 =?us-ascii?Q?UpYys0FNvtdDJ1KTi4D0JiY4Q1hX2ym9yshXzTLyjL9q596smbRaLtF18lA3?=
 =?us-ascii?Q?PoC7CUyqgfzR5siGIlQz+ib3e1w2ioN2vX3kpoSEyClGu1JqVaRoXdVE7Tdu?=
 =?us-ascii?Q?3p5tDu1iMFqZhahGG0xu6D+9Ub18ZxTynBtfy0dple2U2dcgNbYXr7f1+onx?=
 =?us-ascii?Q?iw6tipc86ahTPDc6Iz25hlsm1IgAb+/9jgP+9IEAmc9nImdE7Z+kyh8PRtVt?=
 =?us-ascii?Q?8whydJKAW85TALyJXpks4iZqE/LRX8QoMQouh55QtMFri26YmYQ6FBsy2D2i?=
 =?us-ascii?Q?lHFkM1gzWmCjTqHTST0f8L7dtuuxnmX1sdm2nja9pBQSeqowmZc2L7Tnoma6?=
 =?us-ascii?Q?cn6XUDoJ9c/IWRZXbiaAMpA+sirIfaTRGIwKMlG6MGBl7yPex/pbgHwxCQo3?=
 =?us-ascii?Q?KBRbOMb5p1JZ+IZWO4j2lOCqkAgCnZzK9Q0fTifBY0cySN9w5KviV6Ga/PzO?=
 =?us-ascii?Q?WwMARh90ZHXDHqZSJBJn9hGw5odIQml9QzQveCPMHxbRidXxEH8hhczG6FQF?=
 =?us-ascii?Q?GsFZbQCNjFHg78I+X3KvGTJaiWuuDzYajdZ1vjpBFu9q3MBhF4qLNpg3P8v5?=
 =?us-ascii?Q?e4GochpYFQM6kgG9hA2ZW/c7nIyhZV3LfV5BpwicyNeFMSYxo0gI7TToo5qp?=
 =?us-ascii?Q?gXwyVmCfrlMu+IWOzoP6viBVaFGyrhv20FNx9glo+dKVhKOf5gba0aRMTTFI?=
 =?us-ascii?Q?z4x0EceOONMvtdNoC3Zu4yii2i/VSDQSxDWJQDn/XDr9zW+2UcWgOYQ1odyg?=
 =?us-ascii?Q?whniPiAKbCqnp/QumN/gOJxFy/YzbtlLNRzYWJItSwPMiqxCJ62yqh3Tf+CU?=
 =?us-ascii?Q?uO17vd+6F6H3KN+H1iV70IOi4GYf12x8ZeILRggRukqhGMNe+tW/FQdIThIe?=
 =?us-ascii?Q?m13W1hxujDt/YPIx46henMDSAif2rHUc/iXdM9Ue?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5eec73-42a8-4213-c9a4-08dac80896ce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 19:27:24.4430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y8+wF/+M9Iu1zy022E2LDGAjzzRZ+IqMWsgyLvr0E4vFgNiTPljPH3yVI+hy26/kruy2nklWrIwLcm8B6ZQc2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pretty printer for the registers which the enetc PF and VF drivers
support since their introduction in kernel v5.1. The selection of
registers parsed is the selection exported by the kernel as of v6.1-rc2.
Unparsed registers are printed as raw.

One register is printed field by field (MAC COMMAND_CONFIG), I didn't
have time/interest in printing more than 1. The rest are printed in hex.

Sample output:

$ ethtool -d eno0
SI mode register: 0x80000000
SI primary MAC address register 0: 0x59f0400
SI primary MAC address register 1: 0x27f6
SI control BDR mode register: 0x40000000
SI control BDR status register: 0x0
SI control BDR base address register 0: 0x8262f000
SI control BDR base address register 1: 0x20
SI control BDR producer index register: 0x3a
SI control BDR consumer index register: 0x3a
SI control BDR length register: 0x40
SI capability register 0: 0x10080008
SI capability register 1: 0x20002
SI uncorrectable error frame drop count register: 0x0
TX BDR 0 mode register: 0x80000200
TX BDR 0 status register: 0x0
TX BDR 0 base address register 0: 0xebfa0000
TX BDR 0 base address register 1: 0x0
TX BDR 0 producer index register: 0x12
TX BDR 0 consumer index register: 0x12
TX BDR 0 length register: 0x800
TX BDR 0 interrupt enable register: 0x1
TX BDR 0 interrupt coalescing register 0: 0x80000008
TX BDR 0 interrupt coalescing register 1: 0x3a980
(repeats for other TX rings)
RX BDR 0 mode register: 0x80000034
RX BDR 0 status register: 0x0
RX BDR 0 buffer size register: 0x680
RX BDR 0 consumer index register: 0x7ff
RX BDR 0 base address register 0: 0xec430000
RX BDR 0 base address register 1: 0x0
RX BDR 0 producer index register: 0x0
RX BDR 0 length register: 0x800
RX BDR 0 interrupt enable register: 0x1
RX BDR 0 interrupt coalescing register 0: 0x80000100
RX BDR 0 interrupt coalescing register 1: 0x1
(repeats for other RX rings)
Port mode register: 0x70200
Port status register: 0x0
Port SI promiscuous mode register: 0x0
Port SI0 primary MAC address register 0: 0x59f0400
Port SI0 primary MAC address register 1: 0x27f6
Port HTA transmit memory buffer allocation register: 0xc390
Port capability register 0: 0x10101b3c
Port capability register 1: 0x2070
Port SI0 configuration register 0: 0x3080008
Port RFS capability register: 0x2
Port traffic class 0 maximum SDU register: 0x2580
Port eMAC Command and Configuration Register: 0x8813
        MG 0
        RXSTP 0
        REG_LOWP_RXETY 0
        TX_LOWP_ENA 0
        SFD 0
        NO_LEN_CHK 0
        SEND_IDLE 0
        CNT_FRM_EN 0
        SWR 0
        TXP 1
        XGLP 0
        TX_ADDR_INS 0
        PAUSE_IGN 0
        PAUSE_FWD 0
        CRC 0
        PAD 0
        PROMIS 1
        WAN 0
        RX_EN 1
        TX_EN 1
Port eMAC Maximum Frame Length Register: 0x2580
Port eMAC Interface Mode Control Register: 0x1002

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: s/1/1U/ in BIT() macro definition

 Makefile.am |   4 +-
 ethtool.c   |   2 +
 fsl_enetc.c | 259 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 internal.h  |   3 +
 4 files changed, 266 insertions(+), 2 deletions(-)
 create mode 100644 fsl_enetc.c

diff --git a/Makefile.am b/Makefile.am
index 21fa91a58453..0bd41dd4600e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -13,8 +13,8 @@ ethtool_SOURCES = ethtool.c uapi/linux/ethtool.h internal.h \
 if ETHTOOL_ENABLE_PRETTY_DUMP
 ethtool_SOURCES += \
 		  amd8111e.c de2104x.c dsa.c e100.c e1000.c et131x.c igb.c	\
-		  fec.c fec_8xx.c ibm_emac.c ixgb.c ixgbe.c natsemi.c	\
-		  pcnet32.c realtek.c tg3.c marvell.c vioc.c	\
+		  fec.c fec_8xx.c fsl_enetc.c ibm_emac.c ixgb.c ixgbe.c \
+		  natsemi.c pcnet32.c realtek.c tg3.c marvell.c vioc.c \
 		  smsc911x.c at76c50x-usb.c sfc.c stmmac.c	\
 		  sff-common.c sff-common.h sfpid.c sfpdiag.c	\
 		  ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c \
diff --git a/ethtool.c b/ethtool.c
index 96cef4630693..f15a7cef60ab 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1131,6 +1131,8 @@ static const struct {
 	{ "bnxt_en", bnxt_dump_regs },
 	{ "cpsw-switch", cpsw_dump_regs },
 	{ "lan743x", lan743x_dump_regs },
+	{ "fsl_enetc", fsl_enetc_dump_regs },
+	{ "fsl_enetc_vf", fsl_enetc_dump_regs },
 };
 #endif
 
diff --git a/fsl_enetc.c b/fsl_enetc.c
new file mode 100644
index 000000000000..1180a664f777
--- /dev/null
+++ b/fsl_enetc.c
@@ -0,0 +1,259 @@
+/* Code to dump registers for the Freescale/NXP ENETC controller.
+ *
+ * Copyright 2022 NXP
+ */
+#include <stdio.h>
+#include "internal.h"
+
+#define BIT(x)			(1U << (x))
+
+enum enetc_bdr_type {TX, RX};
+#define ENETC_SIMR		0
+#define ENETC_SIPMAR0		0x80
+#define ENETC_SIPMAR1		0x84
+#define ENETC_SICBDRMR		0x800
+#define ENETC_SICBDRSR		0x804
+#define ENETC_SICBDRBAR0	0x810
+#define ENETC_SICBDRBAR1	0x814
+#define ENETC_SICBDRPIR		0x818
+#define ENETC_SICBDRCIR		0x81c
+#define ENETC_SICBDRLENR	0x820
+#define ENETC_SICAPR0		0x900
+#define ENETC_SICAPR1		0x904
+#define ENETC_SIUEFDCR		0xe28
+
+#define ENETC_BDR_OFF(i)	((i) * 0x200)
+#define ENETC_BDR(t, i, r)	(0x8000 + (t) * 0x100 + ENETC_BDR_OFF(i) + (r))
+
+/* RX BDR reg offsets */
+#define ENETC_RBMR		0
+#define ENETC_RBSR		0x4
+#define ENETC_RBBSR		0x8
+#define ENETC_RBCIR		0xc
+#define ENETC_RBBAR0		0x10
+#define ENETC_RBBAR1		0x14
+#define ENETC_RBPIR		0x18
+#define ENETC_RBLENR		0x20
+#define ENETC_RBIER		0xa0
+#define ENETC_RBICR0		0xa8
+#define ENETC_RBICR1		0xac
+
+/* TX BDR reg offsets */
+#define ENETC_TBMR		0
+#define ENETC_TBSR		0x4
+#define ENETC_TBBAR0		0x10
+#define ENETC_TBBAR1		0x14
+#define ENETC_TBPIR		0x18
+#define ENETC_TBCIR		0x1c
+#define ENETC_TBLENR		0x20
+#define ENETC_TBIER		0xa0
+#define ENETC_TBIDR		0xa4
+#define ENETC_TBICR0		0xa8
+#define ENETC_TBICR1		0xac
+
+/* Port registers */
+#define ENETC_PORT_BASE		0x10000
+#define ENETC_PMR		ENETC_PORT_BASE + 0x0000
+#define ENETC_PSR		ENETC_PORT_BASE + 0x0004
+#define ENETC_PSIPMR		ENETC_PORT_BASE + 0x0018
+#define ENETC_PSIPMAR0(n)	ENETC_PORT_BASE + (0x0100 + (n) * 0x8) /* n = SI index */
+#define ENETC_PSIPMAR1(n)	ENETC_PORT_BASE + (0x0104 + (n) * 0x8)
+#define ENETC_PTXMBAR		ENETC_PORT_BASE + 0x0608
+#define ENETC_PCAPR0		ENETC_PORT_BASE + 0x0900
+#define ENETC_PCAPR1		ENETC_PORT_BASE + 0x0904
+#define ENETC_PSICFGR0(n)	ENETC_PORT_BASE + (0x0940 + (n) * 0xc)  /* n = SI index */
+
+#define ENETC_PRFSCAPR		ENETC_PORT_BASE + 0x1804
+#define ENETC_PTCMSDUR(n)	ENETC_PORT_BASE + (0x2020 + (n) * 4) /* n = TC index [0..7] */
+
+#define ENETC_PM0_CMD_CFG	ENETC_PORT_BASE + 0x8008
+#define ENETC_PM0_CMD_TX_EN		BIT(0)
+#define ENETC_PM0_CMD_RX_EN		BIT(1)
+#define ENETC_PM0_CMD_WAN		BIT(3)
+#define ENETC_PM0_CMD_PROMISC		BIT(4)
+#define ENETC_PM0_CMD_PAD		BIT(5)
+#define ENETC_PM0_CMD_CRC		BIT(6)
+#define ENETC_PM0_CMD_PAUSE_FWD		BIT(7)
+#define ENETC_PM0_CMD_PAUSE_IGN		BIT(8)
+#define ENETC_PM0_CMD_TX_ADDR_INS	BIT(9)
+#define ENETC_PM0_CMD_XGLP		BIT(10)
+#define ENETC_PM0_CMD_TXP		BIT(11)
+#define ENETC_PM0_CMD_SWR		BIT(12)
+#define ENETC_PM0_CMD_CNT_FRM_EN	BIT(13)
+#define ENETC_PM0_CMD_SEND_IDLE		BIT(16)
+#define ENETC_PM0_CMD_NO_LEN_CHK	BIT(17)
+#define ENETC_PM0_CMD_SFD		BIT(21)
+#define ENETC_PM0_CMD_TX_LOWP_ENA	BIT(23)
+#define ENETC_PM0_CMD_REG_LOWP_RXETY	BIT(24)
+#define ENETC_PM0_CMD_RXSTP		BIT(29)
+#define ENETC_PM0_CMD_MG		BIT(31)
+
+#define ENETC_PM0_MAXFRM	ENETC_PORT_BASE + 0x8014
+#define ENETC_PM0_IF_MODE	ENETC_PORT_BASE + 0x8300
+
+struct enetc_register {
+	u32 addr;
+	const char *name;
+	void (*decode)(u32 val, char *buf);
+};
+
+#define REG(_reg, _name)	{ .addr = (_reg), .name = (_name) }
+
+#define REG_DEC(_reg, _name, _decode) \
+	{ .addr = (_reg), .name = (_name), .decode = (_decode) }
+
+static void decode_cmd_cfg(u32 val, char *buf)
+{
+	sprintf(buf, "\tMG %d\n\tRXSTP %d\n\tREG_LOWP_RXETY %d\n"
+		"\tTX_LOWP_ENA %d\n\tSFD %d\n\tNO_LEN_CHK %d\n\tSEND_IDLE %d\n"
+		"\tCNT_FRM_EN %d\n\tSWR %d\n\tTXP %d\n\tXGLP %d\n"
+		"\tTX_ADDR_INS %d\n\tPAUSE_IGN %d\n\tPAUSE_FWD %d\n\tCRC %d\n"
+		"\tPAD %d\n\tPROMIS %d\n\tWAN %d\n\tRX_EN %d\n\tTX_EN %d\n",
+		!!(val & ENETC_PM0_CMD_MG),
+		!!(val & ENETC_PM0_CMD_RXSTP),
+		!!(val & ENETC_PM0_CMD_REG_LOWP_RXETY),
+		!!(val & ENETC_PM0_CMD_TX_LOWP_ENA),
+		!!(val & ENETC_PM0_CMD_SFD),
+		!!(val & ENETC_PM0_CMD_NO_LEN_CHK),
+		!!(val & ENETC_PM0_CMD_SEND_IDLE),
+		!!(val & ENETC_PM0_CMD_CNT_FRM_EN),
+		!!(val & ENETC_PM0_CMD_SWR),
+		!!(val & ENETC_PM0_CMD_TXP),
+		!!(val & ENETC_PM0_CMD_XGLP),
+		!!(val & ENETC_PM0_CMD_TX_ADDR_INS),
+		!!(val & ENETC_PM0_CMD_PAUSE_IGN),
+		!!(val & ENETC_PM0_CMD_PAUSE_FWD),
+		!!(val & ENETC_PM0_CMD_CRC),
+		!!(val & ENETC_PM0_CMD_PAD),
+		!!(val & ENETC_PM0_CMD_PROMISC),
+		!!(val & ENETC_PM0_CMD_WAN),
+		!!(val & ENETC_PM0_CMD_RX_EN),
+		!!(val & ENETC_PM0_CMD_TX_EN));
+}
+
+#define RXBDR_REGS(_i) \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBMR), "RX BDR " #_i " mode register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBSR), "RX BDR " #_i " status register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBBSR), "RX BDR " #_i " buffer size register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBPIR), "RX BDR " #_i " producer index register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBCIR), "RX BDR " #_i " consumer index register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBBAR0), "RX BDR " #_i " base address register 0"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBBAR1), "RX BDR " #_i " base address register 1"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBLENR), "RX BDR " #_i " length register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBIER), "RX BDR " #_i " interrupt enable register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBICR0), "RX BDR " #_i " interrupt coalescing register 0"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBICR1), "RX BDR " #_i " interrupt coalescing register 1")
+
+#define TXBDR_REGS(_i) \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBMR), "TX BDR " #_i " mode register"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBSR), "TX BDR " #_i " status register"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBBAR0), "TX BDR " #_i " base address register 0"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBBAR1), "TX BDR " #_i " base address register 1"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBPIR), "TX BDR " #_i " producer index register"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBCIR), "TX BDR " #_i " consumer index register"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBLENR), "TX BDR " #_i " length register"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBIER), "TX BDR " #_i " interrupt enable register"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBICR0), "TX BDR " #_i " interrupt coalescing register 0"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBICR1), "TX BDR " #_i " interrupt coalescing register 1")
+
+static const struct enetc_register known_enetc_regs[] = {
+	REG(ENETC_SIMR, "SI mode register"),
+	REG(ENETC_SIPMAR0, "SI primary MAC address register 0"),
+	REG(ENETC_SIPMAR1, "SI primary MAC address register 1"),
+	REG(ENETC_SICBDRMR, "SI control BDR mode register"),
+	REG(ENETC_SICBDRSR, "SI control BDR status register"),
+	REG(ENETC_SICBDRBAR0, "SI control BDR base address register 0"),
+	REG(ENETC_SICBDRBAR1, "SI control BDR base address register 1"),
+	REG(ENETC_SICBDRPIR, "SI control BDR producer index register"),
+	REG(ENETC_SICBDRCIR, "SI control BDR consumer index register"),
+	REG(ENETC_SICBDRLENR, "SI control BDR length register"),
+	REG(ENETC_SICAPR0, "SI capability register 0"),
+	REG(ENETC_SICAPR1, "SI capability register 1"),
+	REG(ENETC_SIUEFDCR, "SI uncorrectable error frame drop count register"),
+
+	TXBDR_REGS(0), TXBDR_REGS(1), TXBDR_REGS(2), TXBDR_REGS(3),
+	TXBDR_REGS(4), TXBDR_REGS(5), TXBDR_REGS(6), TXBDR_REGS(7),
+	TXBDR_REGS(8), TXBDR_REGS(9), TXBDR_REGS(10), TXBDR_REGS(11),
+	TXBDR_REGS(12), TXBDR_REGS(13), TXBDR_REGS(14), TXBDR_REGS(15),
+
+	RXBDR_REGS(0), RXBDR_REGS(1), RXBDR_REGS(2), RXBDR_REGS(3),
+	RXBDR_REGS(4), RXBDR_REGS(5), RXBDR_REGS(6), RXBDR_REGS(7),
+	RXBDR_REGS(8), RXBDR_REGS(9), RXBDR_REGS(10), RXBDR_REGS(11),
+	RXBDR_REGS(12), RXBDR_REGS(13), RXBDR_REGS(14), RXBDR_REGS(15),
+
+	REG(ENETC_PMR, "Port mode register"),
+	REG(ENETC_PSR, "Port status register"),
+	REG(ENETC_PSIPMR, "Port SI promiscuous mode register"),
+	REG(ENETC_PSIPMAR0(0), "Port SI0 primary MAC address register 0"),
+	REG(ENETC_PSIPMAR1(0), "Port SI0 primary MAC address register 1"),
+	REG(ENETC_PTXMBAR, "Port HTA transmit memory buffer allocation register"),
+	REG(ENETC_PCAPR0, "Port capability register 0"),
+	REG(ENETC_PCAPR1, "Port capability register 1"),
+	REG(ENETC_PSICFGR0(0), "Port SI0 configuration register 0"),
+	REG(ENETC_PRFSCAPR, "Port RFS capability register"),
+	REG(ENETC_PTCMSDUR(0), "Port traffic class 0 maximum SDU register"),
+	REG_DEC(ENETC_PM0_CMD_CFG, "Port eMAC Command and Configuration Register",
+		decode_cmd_cfg),
+	REG(ENETC_PM0_MAXFRM, "Port eMAC Maximum Frame Length Register"),
+	REG(ENETC_PM0_IF_MODE, "Port eMAC Interface Mode Control Register"),
+};
+
+static void decode_known_reg(const struct enetc_register *reg, u32 val)
+{
+	char buf[512];
+
+	reg->decode(val, buf);
+	fprintf(stdout, "%s: 0x%x\n%s", reg->name, val, buf);
+}
+
+static void dump_known_reg(const struct enetc_register *reg, u32 val)
+{
+	fprintf(stdout, "%s: 0x%x\n", reg->name, val);
+}
+
+static void dump_unknown_reg(u32 addr, u32 val)
+{
+	fprintf(stdout, "Reg 0x%x: 0x%x\n", addr, val);
+}
+
+static void dump_reg(u32 addr, u32 val)
+{
+	const struct enetc_register *reg;
+	u32 i;
+
+	for (i = 0; i < ARRAY_SIZE(known_enetc_regs); i++) {
+		reg = &known_enetc_regs[i];
+		if (reg->addr == addr) {
+			if (reg->decode)
+				decode_known_reg(reg, val);
+			else
+				dump_known_reg(reg, val);
+			return;
+		}
+	}
+
+	dump_unknown_reg(addr, val);
+}
+
+/* Registers are structured in an array of key/value u32 pairs.
+ * Compare each key to our list of known registers, or print it
+ * as a raw address otherwise.
+ */
+int fsl_enetc_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
+			struct ethtool_regs *regs)
+{
+	u32 *data = (u32 *)regs->data;
+	u32 len = regs->len;
+
+	if (len % 8) {
+		fprintf(stdout, "Expected length to be multiple of 8 bytes\n");
+		return -1;
+	}
+
+	while (len) {
+		dump_reg(data[0], data[1]);
+		data += 2; len -= 8;
+	}
+
+	return 0;
+}
diff --git a/internal.h b/internal.h
index 9fa6d80b4b29..dd7d6ac70ad4 100644
--- a/internal.h
+++ b/internal.h
@@ -406,6 +406,9 @@ int dsa_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 /* i.MX Fast Ethernet Controller */
 int fec_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 
+/* Freescale/NXP ENETC Ethernet Controller */
+int fsl_enetc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
+
 /* Intel(R) Ethernet Controller I225-LM/I225-V adapter family */
 int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 
-- 
2.34.1

