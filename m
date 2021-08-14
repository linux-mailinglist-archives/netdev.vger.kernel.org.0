Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894193EBFF7
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbhHNCvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:51:50 -0400
Received: from mail-bn1nam07on2106.outbound.protection.outlook.com ([40.107.212.106]:10517
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236506AbhHNCux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 22:50:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CAAULd8E7cq6xJzYiGk+Aphb5+4q1FKNORjINb//mNGwoJ+R00aZxF4w/srqqnd7TL0gAI+gSx4qU+QNezxO7PQuhZYwd6wAhc6Vym3ABzziM/IcGG3xvLrOZqzkxByWQkqyP4gg9/QxDrhfNgL4Dbxc6kZCAPTs24A410XIfqJLWkJHNTAGD/PCY2EK5qE7yZaDmMHVKssNb5sBUedqKe7hWhGJVl0zzF2Pz3cH5j4XZ6Hv+SgdJRgsIOpyQO1zxFBqLdiwWkKUZpfgCa3IlmahvtDUVW5c5oo459C7p5X/noSKqyo8qHzzfOfDJ+PmHcmGdd9UZFLsiflhv4UvPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBuWqXlYX3fZ3vNn5kQsYkYJo6GfbPO+a7AyImhH528=;
 b=FWLRHg0+odaA5JW/OlXfQiuvFNQX5XUpYKUXTK6G2+CfTq/b4ytx33uCmmXrHd9GUP03RJmdMS8UYEz489w6p0BrGd+KdPaYfZTWrh+W0GfRUTJ5pthKfttgz/ZE/7O062sXrJBapn3QsT6L6FTojaXIxACwHfCx2GxB04QWs+cd1BJbMn/uwj+CxYmrRq6jY4ivNKXdcgAz37yS9u5LWvtxfKyaE4b4FmdK46HS1yBRzw7Q8KZC0bxkz4uLlT2QI6uhNwPf/WBLR3nC5BDvbUK5uDuGoFMxkH/3TlndpRC4BwkS3kHh0zEGzvudLugywuhFQ1XkmNGrJXSI6YzJhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBuWqXlYX3fZ3vNn5kQsYkYJo6GfbPO+a7AyImhH528=;
 b=FosT6wnM+8AF0AMxbQQTbUFqWxTkR0baaKhdhS6pt0mF3zVmjPzMLBLmVSgVf2z51tYQUawHvmfAbQxtRlVlD3AMjMgSSBc/aw2Tgjbo/UbygbTQhUT5W2Q1GmiAwslof/meJOOSrMf2ImLpyyy2TRZ0NGa5UqN1yrQccJXF9vE=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB2030.namprd10.prod.outlook.com
 (2603:10b6:300:10d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sat, 14 Aug
 2021 02:50:19 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 02:50:19 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 net-next 06/10] net: mscc: ocelot: split register definitions to a separate file
Date:   Fri, 13 Aug 2021 19:49:59 -0700
Message-Id: <20210814025003.2449143-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814025003.2449143-1-colin.foster@in-advantage.com>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 02:50:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eabed90c-0ab1-4828-9c88-08d95ece40b3
X-MS-TrafficTypeDiagnostic: MWHPR10MB2030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB20301D483C1F30E4ADFF7CF0A4FB9@MWHPR10MB2030.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:635;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lUHmp0fC4kJ6qrax8HFRCzMJZ+rOhCtwDk1/kMHbV701mtbmRUGzDjONA9Wpu4aGoEBpLkRL/U9RMD+vyMUZGrtSF0RdbCtM5f7mXeUa7/4kb/J3T9Yh6F2J1gfiMiP8Aef3GWy3tj0BiDUMkRJ/+FXoM2nyvyYsrR+/sICmkfGQTnNdjunbFvEQN2aRWG+duLQr0butlkm65YX4jfgkjjIAc2atzjcXIdf2z2RIa02dwK6LVoHyvThCHQePPr3Y7e1ERCpINW2+QC5sPrRl2iIBknWlDP/luXPWJYbCAD10vc56gYxWYvcGbLfO+9cCPTMZHpG//ItP3fttgZY9nEJCbzZ1YZHRRMNe79UvXkm8I5hO3M6DfOP1fwd9onlvcAwn1thDQkeWnKOWvD6cS2bCyZnB+Wyg4O26WfwlXZJLLsFdPmTM3AvaIBjpzUnrW6l7W67ODrBLD2TK3qjHC9OiEfjyMoSyD8edPgmGcbJZqUjTzq9MuYSckolb/kQjWk2ONucd7NmX2K8gwI9ksB/YexhGwQrouJ/PVAipBCDkRn06ls2Qqn1o4VbY790x4Ij0OgKlJxyznqTL67z4lmByx/eu0NAHETRGZXDqOmNhblcQNFlDoSZ9zQHmXJOv1wQgg7VqronqxqcZ/fGale0uZeaHh2ikUOH9mPbCOnV7rI6JD/qsvKHH2sIc++iO8N6fOzXqjLJwwVNEPhssbtWCEHtLUI2FDtYdf60YwOE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39830400003)(136003)(376002)(186003)(5660300002)(30864003)(316002)(4326008)(8936002)(6486002)(2906002)(52116002)(66476007)(66556008)(44832011)(956004)(2616005)(66946007)(1076003)(921005)(36756003)(83380400001)(38100700002)(38350700002)(6512007)(6506007)(26005)(478600001)(8676002)(86362001)(6666004)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8ieTT+LnQzHi7t6IzTm5H8wWWnDYO++foAZpI+2q14m8f2mVjtTOmUywVKuT?=
 =?us-ascii?Q?igxNGxyxPH+2WVlhLcuMCG8M/APBF0reju/671+NdqKrIS1luvnELZghy9rx?=
 =?us-ascii?Q?/ykxYyLNsGlRZDin3oltiyxx1HRPQWPGWn86FMKcza1t0KH6F+aK7HFJCQLP?=
 =?us-ascii?Q?1E6Nay5k0/xZ5fMpZV9gjbmmI71n/kNe+gzajAHw7RCwQUnSqL48/ABo8TOg?=
 =?us-ascii?Q?irRCvtYksvO6VLYEWP7Gk1eF1TftTnx0hYSpguegdKV5Z5vlTuYziqIn+vDA?=
 =?us-ascii?Q?zhCsMa01eRdmXb3pjPhBfBeN83iga74TfL1+CSCreYQX+3+PmO4VrkhzLWfq?=
 =?us-ascii?Q?0O2I+xBbvnOcbOLABUaxgRbwMxjeOtPrIr71jShEnC+KaSNrXsjUl3N7JS4K?=
 =?us-ascii?Q?Laf2mKeWGrrvLvAgit3d1k9+ghAgnc0Bn0Uz0rOeX0wKIsRzkwm9MEirtqXc?=
 =?us-ascii?Q?umF0xwoxOoZNY0DovUweCu1cebqaGsVUOT0BeAtubQ6i1uOaBNbnGDZd7tZl?=
 =?us-ascii?Q?dE1SpRCjXef1YHaD45h7agSugxQ+I7lDD99Ij/lnuvWLjdB6n/Nk3aZc+ItI?=
 =?us-ascii?Q?1tH20We34F7BnDKRpuoupDZkWYPYDszzfJmaV99xzKKgHzJu5rsigG76nbsB?=
 =?us-ascii?Q?+SXbTS3qvOoBj6EdItwLfpGx2blSkEo7kDC06bUOaO6CDbDmT0flgBAuZvvy?=
 =?us-ascii?Q?Kz8N5/iLEsnTz+bj5lRfqeAYeSW1Unm0jv2lBsWBMaula9WIPRm9MFEfwlXw?=
 =?us-ascii?Q?F+yw0ckAjhOpqgVWj/OEvE1GTNFCsXQ7YaRz9n/1NgqqOFZlIAvFYeLMAKZz?=
 =?us-ascii?Q?XBEvfvfzJiWfNxW0wZYgH4K8koDilw6D+WMUzzzi9WS6mm2hCRoKzia3C5/W?=
 =?us-ascii?Q?WeBOUwptjnXD5SWpodkx3sYZkcUo86O5ofVvT4JBWzyuNu/ElnW9902xGp0O?=
 =?us-ascii?Q?76QpomP+yZ4OSzemEKGSHiFTSR1MoeZmBTHJXVk02SfZ3tzOprq5onetYjPt?=
 =?us-ascii?Q?pCAp4k89coX8ZqGHNObRLwvTQDr9mgG09Z1GTx8g9Z7MmZXyQkUHVkQYTTy3?=
 =?us-ascii?Q?8l+WZcsr5beefsjxowxmFSgVrcgu2Srq3mlk9F8WsW6bqAH5V6PrEFaqxM0X?=
 =?us-ascii?Q?QkyRcIKD76rhRML4wcRFLFAzMODjs0CDnTWtwH+fXSRbANaBDmhnK+4CcINx?=
 =?us-ascii?Q?yEKJ4xd8d4t7kJwD/CTIHx62mb3LWCA8gGhmQUL2kSjr/feCx2RcgD+395au?=
 =?us-ascii?Q?wOt/P0MsV2jK+WrNCvIkklIKRO/GvntAqW0VR0N1uL3RESheCIVqH4O6Q5cW?=
 =?us-ascii?Q?EniefMSVLMeU39BEzi4djCjk?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eabed90c-0ab1-4828-9c88-08d95ece40b3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 02:50:19.2951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B7ouVgAFio2LFvWTST28qgR8pKR26TJ652+4KwnskMoyhq4mBTwNHx3yQijCCVMP3QkPESSlczuHreUf5rP1ObI0xVSo/Mxcq8vgC5x5MsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2030
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moving these to a separate file will allow them to be shared to other
drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/Makefile         |   1 +
 drivers/net/ethernet/mscc/ocelot_regs.c    | 309 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 295 +-------------------
 include/soc/mscc/ocelot_regs.h             |  20 ++
 4 files changed, 331 insertions(+), 294 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_regs.c
 create mode 100644 include/soc/mscc/ocelot_regs.h

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 722c27694b21..d539a231a478 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -7,6 +7,7 @@ mscc_ocelot_switch_lib-y := \
 	ocelot_vcap.o \
 	ocelot_flower.o \
 	ocelot_ptp.o \
+	ocelot_regs.o \
 	ocelot_devlink.o
 mscc_ocelot_switch_lib-$(CONFIG_BRIDGE_MRP) += ocelot_mrp.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
new file mode 100644
index 000000000000..b7ba137a7c90
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -0,0 +1,309 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Microsemi Ocelot Switch driver
+ *
+ * Copyright (c) 2017 Microsemi Corporation
+ */
+#include "ocelot.h"
+
+const u32 ocelot_ana_regmap[] = {
+	REG(ANA_ADVLEARN,				0x009000),
+	REG(ANA_VLANMASK,				0x009004),
+	REG(ANA_PORT_B_DOMAIN,				0x009008),
+	REG(ANA_ANAGEFIL,				0x00900c),
+	REG(ANA_ANEVENTS,				0x009010),
+	REG(ANA_STORMLIMIT_BURST,			0x009014),
+	REG(ANA_STORMLIMIT_CFG,				0x009018),
+	REG(ANA_ISOLATED_PORTS,				0x009028),
+	REG(ANA_COMMUNITY_PORTS,			0x00902c),
+	REG(ANA_AUTOAGE,				0x009030),
+	REG(ANA_MACTOPTIONS,				0x009034),
+	REG(ANA_LEARNDISC,				0x009038),
+	REG(ANA_AGENCTRL,				0x00903c),
+	REG(ANA_MIRRORPORTS,				0x009040),
+	REG(ANA_EMIRRORPORTS,				0x009044),
+	REG(ANA_FLOODING,				0x009048),
+	REG(ANA_FLOODING_IPMC,				0x00904c),
+	REG(ANA_SFLOW_CFG,				0x009050),
+	REG(ANA_PORT_MODE,				0x009080),
+	REG(ANA_PGID_PGID,				0x008c00),
+	REG(ANA_TABLES_ANMOVED,				0x008b30),
+	REG(ANA_TABLES_MACHDATA,			0x008b34),
+	REG(ANA_TABLES_MACLDATA,			0x008b38),
+	REG(ANA_TABLES_MACACCESS,			0x008b3c),
+	REG(ANA_TABLES_MACTINDX,			0x008b40),
+	REG(ANA_TABLES_VLANACCESS,			0x008b44),
+	REG(ANA_TABLES_VLANTIDX,			0x008b48),
+	REG(ANA_TABLES_ISDXACCESS,			0x008b4c),
+	REG(ANA_TABLES_ISDXTIDX,			0x008b50),
+	REG(ANA_TABLES_ENTRYLIM,			0x008b00),
+	REG(ANA_TABLES_PTP_ID_HIGH,			0x008b54),
+	REG(ANA_TABLES_PTP_ID_LOW,			0x008b58),
+	REG(ANA_MSTI_STATE,				0x008e00),
+	REG(ANA_PORT_VLAN_CFG,				0x007000),
+	REG(ANA_PORT_DROP_CFG,				0x007004),
+	REG(ANA_PORT_QOS_CFG,				0x007008),
+	REG(ANA_PORT_VCAP_CFG,				0x00700c),
+	REG(ANA_PORT_VCAP_S1_KEY_CFG,			0x007010),
+	REG(ANA_PORT_VCAP_S2_CFG,			0x00701c),
+	REG(ANA_PORT_PCP_DEI_MAP,			0x007020),
+	REG(ANA_PORT_CPU_FWD_CFG,			0x007060),
+	REG(ANA_PORT_CPU_FWD_BPDU_CFG,			0x007064),
+	REG(ANA_PORT_CPU_FWD_GARP_CFG,			0x007068),
+	REG(ANA_PORT_CPU_FWD_CCM_CFG,			0x00706c),
+	REG(ANA_PORT_PORT_CFG,				0x007070),
+	REG(ANA_PORT_POL_CFG,				0x007074),
+	REG(ANA_PORT_PTP_CFG,				0x007078),
+	REG(ANA_PORT_PTP_DLY1_CFG,			0x00707c),
+	REG(ANA_OAM_UPM_LM_CNT,				0x007c00),
+	REG(ANA_PORT_PTP_DLY2_CFG,			0x007080),
+	REG(ANA_PFC_PFC_CFG,				0x008800),
+	REG(ANA_PFC_PFC_TIMER,				0x008804),
+	REG(ANA_IPT_OAM_MEP_CFG,			0x008000),
+	REG(ANA_IPT_IPT,				0x008004),
+	REG(ANA_PPT_PPT,				0x008ac0),
+	REG(ANA_FID_MAP_FID_MAP,			0x000000),
+	REG(ANA_AGGR_CFG,				0x0090b4),
+	REG(ANA_CPUQ_CFG,				0x0090b8),
+	REG(ANA_CPUQ_CFG2,				0x0090bc),
+	REG(ANA_CPUQ_8021_CFG,				0x0090c0),
+	REG(ANA_DSCP_CFG,				0x009100),
+	REG(ANA_DSCP_REWR_CFG,				0x009200),
+	REG(ANA_VCAP_RNG_TYPE_CFG,			0x009240),
+	REG(ANA_VCAP_RNG_VAL_CFG,			0x009260),
+	REG(ANA_VRAP_CFG,				0x009280),
+	REG(ANA_VRAP_HDR_DATA,				0x009284),
+	REG(ANA_VRAP_HDR_MASK,				0x009288),
+	REG(ANA_DISCARD_CFG,				0x00928c),
+	REG(ANA_FID_CFG,				0x009290),
+	REG(ANA_POL_PIR_CFG,				0x004000),
+	REG(ANA_POL_CIR_CFG,				0x004004),
+	REG(ANA_POL_MODE_CFG,				0x004008),
+	REG(ANA_POL_PIR_STATE,				0x00400c),
+	REG(ANA_POL_CIR_STATE,				0x004010),
+	REG(ANA_POL_STATE,				0x004014),
+	REG(ANA_POL_FLOWC,				0x008b80),
+	REG(ANA_POL_HYST,				0x008bec),
+	REG(ANA_POL_MISC_CFG,				0x008bf0),
+};
+EXPORT_SYMBOL(ocelot_ana_regmap);
+
+const u32 ocelot_qs_regmap[] = {
+	REG(QS_XTR_GRP_CFG,				0x000000),
+	REG(QS_XTR_RD,					0x000008),
+	REG(QS_XTR_FRM_PRUNING,				0x000010),
+	REG(QS_XTR_FLUSH,				0x000018),
+	REG(QS_XTR_DATA_PRESENT,			0x00001c),
+	REG(QS_XTR_CFG,					0x000020),
+	REG(QS_INJ_GRP_CFG,				0x000024),
+	REG(QS_INJ_WR,					0x00002c),
+	REG(QS_INJ_CTRL,				0x000034),
+	REG(QS_INJ_STATUS,				0x00003c),
+	REG(QS_INJ_ERR,					0x000040),
+	REG(QS_INH_DBG,					0x000048),
+};
+EXPORT_SYMBOL(ocelot_qs_regmap);
+
+const u32 ocelot_qsys_regmap[] = {
+	REG(QSYS_PORT_MODE,				0x011200),
+	REG(QSYS_SWITCH_PORT_MODE,			0x011234),
+	REG(QSYS_STAT_CNT_CFG,				0x011264),
+	REG(QSYS_EEE_CFG,				0x011268),
+	REG(QSYS_EEE_THRES,				0x011294),
+	REG(QSYS_IGR_NO_SHARING,			0x011298),
+	REG(QSYS_EGR_NO_SHARING,			0x01129c),
+	REG(QSYS_SW_STATUS,				0x0112a0),
+	REG(QSYS_EXT_CPU_CFG,				0x0112d0),
+	REG(QSYS_PAD_CFG,				0x0112d4),
+	REG(QSYS_CPU_GROUP_MAP,				0x0112d8),
+	REG(QSYS_QMAP,					0x0112dc),
+	REG(QSYS_ISDX_SGRP,				0x011400),
+	REG(QSYS_TIMED_FRAME_ENTRY,			0x014000),
+	REG(QSYS_TFRM_MISC,				0x011310),
+	REG(QSYS_TFRM_PORT_DLY,				0x011314),
+	REG(QSYS_TFRM_TIMER_CFG_1,			0x011318),
+	REG(QSYS_TFRM_TIMER_CFG_2,			0x01131c),
+	REG(QSYS_TFRM_TIMER_CFG_3,			0x011320),
+	REG(QSYS_TFRM_TIMER_CFG_4,			0x011324),
+	REG(QSYS_TFRM_TIMER_CFG_5,			0x011328),
+	REG(QSYS_TFRM_TIMER_CFG_6,			0x01132c),
+	REG(QSYS_TFRM_TIMER_CFG_7,			0x011330),
+	REG(QSYS_TFRM_TIMER_CFG_8,			0x011334),
+	REG(QSYS_RED_PROFILE,				0x011338),
+	REG(QSYS_RES_QOS_MODE,				0x011378),
+	REG(QSYS_RES_CFG,				0x012000),
+	REG(QSYS_RES_STAT,				0x012004),
+	REG(QSYS_EGR_DROP_MODE,				0x01137c),
+	REG(QSYS_EQ_CTRL,				0x011380),
+	REG(QSYS_EVENTS_CORE,				0x011384),
+	REG(QSYS_CIR_CFG,				0x000000),
+	REG(QSYS_EIR_CFG,				0x000004),
+	REG(QSYS_SE_CFG,				0x000008),
+	REG(QSYS_SE_DWRR_CFG,				0x00000c),
+	REG(QSYS_SE_CONNECT,				0x00003c),
+	REG(QSYS_SE_DLB_SENSE,				0x000040),
+	REG(QSYS_CIR_STATE,				0x000044),
+	REG(QSYS_EIR_STATE,				0x000048),
+	REG(QSYS_SE_STATE,				0x00004c),
+	REG(QSYS_HSCH_MISC_CFG,				0x011388),
+};
+EXPORT_SYMBOL(ocelot_qsys_regmap);
+
+const u32 ocelot_rew_regmap[] = {
+	REG(REW_PORT_VLAN_CFG,				0x000000),
+	REG(REW_TAG_CFG,				0x000004),
+	REG(REW_PORT_CFG,				0x000008),
+	REG(REW_DSCP_CFG,				0x00000c),
+	REG(REW_PCP_DEI_QOS_MAP_CFG,			0x000010),
+	REG(REW_PTP_CFG,				0x000050),
+	REG(REW_PTP_DLY1_CFG,				0x000054),
+	REG(REW_DSCP_REMAP_DP1_CFG,			0x000690),
+	REG(REW_DSCP_REMAP_CFG,				0x000790),
+	REG(REW_STAT_CFG,				0x000890),
+	REG(REW_PPT,					0x000680),
+};
+EXPORT_SYMBOL(ocelot_rew_regmap);
+
+const u32 ocelot_sys_regmap[] = {
+	REG(SYS_COUNT_RX_OCTETS,			0x000000),
+	REG(SYS_COUNT_RX_UNICAST,			0x000004),
+	REG(SYS_COUNT_RX_MULTICAST,			0x000008),
+	REG(SYS_COUNT_RX_BROADCAST,			0x00000c),
+	REG(SYS_COUNT_RX_SHORTS,			0x000010),
+	REG(SYS_COUNT_RX_FRAGMENTS,			0x000014),
+	REG(SYS_COUNT_RX_JABBERS,			0x000018),
+	REG(SYS_COUNT_RX_CRC_ALIGN_ERRS,		0x00001c),
+	REG(SYS_COUNT_RX_SYM_ERRS,			0x000020),
+	REG(SYS_COUNT_RX_64,				0x000024),
+	REG(SYS_COUNT_RX_65_127,			0x000028),
+	REG(SYS_COUNT_RX_128_255,			0x00002c),
+	REG(SYS_COUNT_RX_256_1023,			0x000030),
+	REG(SYS_COUNT_RX_1024_1526,			0x000034),
+	REG(SYS_COUNT_RX_1527_MAX,			0x000038),
+	REG(SYS_COUNT_RX_PAUSE,				0x00003c),
+	REG(SYS_COUNT_RX_CONTROL,			0x000040),
+	REG(SYS_COUNT_RX_LONGS,				0x000044),
+	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,		0x000048),
+	REG(SYS_COUNT_TX_OCTETS,			0x000100),
+	REG(SYS_COUNT_TX_UNICAST,			0x000104),
+	REG(SYS_COUNT_TX_MULTICAST,			0x000108),
+	REG(SYS_COUNT_TX_BROADCAST,			0x00010c),
+	REG(SYS_COUNT_TX_COLLISION,			0x000110),
+	REG(SYS_COUNT_TX_DROPS,				0x000114),
+	REG(SYS_COUNT_TX_PAUSE,				0x000118),
+	REG(SYS_COUNT_TX_64,				0x00011c),
+	REG(SYS_COUNT_TX_65_127,			0x000120),
+	REG(SYS_COUNT_TX_128_511,			0x000124),
+	REG(SYS_COUNT_TX_512_1023,			0x000128),
+	REG(SYS_COUNT_TX_1024_1526,			0x00012c),
+	REG(SYS_COUNT_TX_1527_MAX,			0x000130),
+	REG(SYS_COUNT_TX_AGING,				0x000170),
+	REG(SYS_RESET_CFG,				0x000508),
+	REG(SYS_CMID,					0x00050c),
+	REG(SYS_VLAN_ETYPE_CFG,				0x000510),
+	REG(SYS_PORT_MODE,				0x000514),
+	REG(SYS_FRONT_PORT_MODE,			0x000548),
+	REG(SYS_FRM_AGING,				0x000574),
+	REG(SYS_STAT_CFG,				0x000578),
+	REG(SYS_SW_STATUS,				0x00057c),
+	REG(SYS_MISC_CFG,				0x0005ac),
+	REG(SYS_REW_MAC_HIGH_CFG,			0x0005b0),
+	REG(SYS_REW_MAC_LOW_CFG,			0x0005dc),
+	REG(SYS_CM_ADDR,				0x000500),
+	REG(SYS_CM_DATA,				0x000504),
+	REG(SYS_PAUSE_CFG,				0x000608),
+	REG(SYS_PAUSE_TOT_CFG,				0x000638),
+	REG(SYS_ATOP,					0x00063c),
+	REG(SYS_ATOP_TOT_CFG,				0x00066c),
+	REG(SYS_MAC_FC_CFG,				0x000670),
+	REG(SYS_MMGT,					0x00069c),
+	REG(SYS_MMGT_FAST,				0x0006a0),
+	REG(SYS_EVENTS_DIF,				0x0006a4),
+	REG(SYS_EVENTS_CORE,				0x0006b4),
+	REG(SYS_CNT,					0x000000),
+	REG(SYS_PTP_STATUS,				0x0006b8),
+	REG(SYS_PTP_TXSTAMP,				0x0006bc),
+	REG(SYS_PTP_NXT,				0x0006c0),
+	REG(SYS_PTP_CFG,				0x0006c4),
+};
+EXPORT_SYMBOL(ocelot_sys_regmap);
+
+const u32 ocelot_vcap_regmap[] = {
+	/* VCAP_CORE_CFG */
+	REG(VCAP_CORE_UPDATE_CTRL,			0x000000),
+	REG(VCAP_CORE_MV_CFG,				0x000004),
+	/* VCAP_CORE_CACHE */
+	REG(VCAP_CACHE_ENTRY_DAT,			0x000008),
+	REG(VCAP_CACHE_MASK_DAT,			0x000108),
+	REG(VCAP_CACHE_ACTION_DAT,			0x000208),
+	REG(VCAP_CACHE_CNT_DAT,				0x000308),
+	REG(VCAP_CACHE_TG_DAT,				0x000388),
+	/* VCAP_CONST */
+	REG(VCAP_CONST_VCAP_VER,			0x000398),
+	REG(VCAP_CONST_ENTRY_WIDTH,			0x00039c),
+	REG(VCAP_CONST_ENTRY_CNT,			0x0003a0),
+	REG(VCAP_CONST_ENTRY_SWCNT,			0x0003a4),
+	REG(VCAP_CONST_ENTRY_TG_WIDTH,			0x0003a8),
+	REG(VCAP_CONST_ACTION_DEF_CNT,			0x0003ac),
+	REG(VCAP_CONST_ACTION_WIDTH,			0x0003b0),
+	REG(VCAP_CONST_CNT_WIDTH,			0x0003b4),
+	REG(VCAP_CONST_CORE_CNT,			0x0003b8),
+	REG(VCAP_CONST_IF_CNT,				0x0003bc),
+};
+EXPORT_SYMBOL(ocelot_vcap_regmap);
+
+const u32 ocelot_ptp_regmap[] = {
+	REG(PTP_PIN_CFG,				0x000000),
+	REG(PTP_PIN_TOD_SEC_MSB,			0x000004),
+	REG(PTP_PIN_TOD_SEC_LSB,			0x000008),
+	REG(PTP_PIN_TOD_NSEC,				0x00000c),
+	REG(PTP_PIN_WF_HIGH_PERIOD,			0x000014),
+	REG(PTP_PIN_WF_LOW_PERIOD,			0x000018),
+	REG(PTP_CFG_MISC,				0x0000a0),
+	REG(PTP_CLK_CFG_ADJ_CFG,			0x0000a4),
+	REG(PTP_CLK_CFG_ADJ_FREQ,			0x0000a8),
+};
+EXPORT_SYMBOL(ocelot_ptp_regmap);
+
+const u32 ocelot_dev_gmii_regmap[] = {
+	REG(DEV_CLOCK_CFG,				0x0),
+	REG(DEV_PORT_MISC,				0x4),
+	REG(DEV_EVENTS,					0x8),
+	REG(DEV_EEE_CFG,				0xc),
+	REG(DEV_RX_PATH_DELAY,				0x10),
+	REG(DEV_TX_PATH_DELAY,				0x14),
+	REG(DEV_PTP_PREDICT_CFG,			0x18),
+	REG(DEV_MAC_ENA_CFG,				0x1c),
+	REG(DEV_MAC_MODE_CFG,				0x20),
+	REG(DEV_MAC_MAXLEN_CFG,				0x24),
+	REG(DEV_MAC_TAGS_CFG,				0x28),
+	REG(DEV_MAC_ADV_CHK_CFG,			0x2c),
+	REG(DEV_MAC_IFG_CFG,				0x30),
+	REG(DEV_MAC_HDX_CFG,				0x34),
+	REG(DEV_MAC_DBG_CFG,				0x38),
+	REG(DEV_MAC_FC_MAC_LOW_CFG,			0x3c),
+	REG(DEV_MAC_FC_MAC_HIGH_CFG,			0x40),
+	REG(DEV_MAC_STICKY,				0x44),
+	REG(PCS1G_CFG,					0x48),
+	REG(PCS1G_MODE_CFG,				0x4c),
+	REG(PCS1G_SD_CFG,				0x50),
+	REG(PCS1G_ANEG_CFG,				0x54),
+	REG(PCS1G_ANEG_NP_CFG,				0x58),
+	REG(PCS1G_LB_CFG,				0x5c),
+	REG(PCS1G_DBG_CFG,				0x60),
+	REG(PCS1G_CDET_CFG,				0x64),
+	REG(PCS1G_ANEG_STATUS,				0x68),
+	REG(PCS1G_ANEG_NP_STATUS,			0x6c),
+	REG(PCS1G_LINK_STATUS,				0x70),
+	REG(PCS1G_LINK_DOWN_CNT,			0x74),
+	REG(PCS1G_STICKY,				0x78),
+	REG(PCS1G_DEBUG_STATUS,				0x7c),
+	REG(PCS1G_LPI_CFG,				0x80),
+	REG(PCS1G_LPI_WAKE_ERROR_CNT,			0x84),
+	REG(PCS1G_LPI_STATUS,				0x88),
+	REG(PCS1G_TSTPAT_MODE_CFG,			0x8c),
+	REG(PCS1G_TSTPAT_STATUS,			0x90),
+	REG(DEV_PCS_FX100_CFG,				0x94),
+	REG(DEV_PCS_FX100_STATUS,			0x98),
+};
+EXPORT_SYMBOL(ocelot_dev_gmii_regmap);
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4bd7e9d9ec61..ef1bf24f51b5 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -16,303 +16,10 @@
 #include <net/switchdev.h>
 
 #include <soc/mscc/ocelot_vcap.h>
+#include <soc/mscc/ocelot_regs.h>
 #include <soc/mscc/ocelot_hsio.h>
 #include "ocelot.h"
 
-static const u32 ocelot_ana_regmap[] = {
-	REG(ANA_ADVLEARN,				0x009000),
-	REG(ANA_VLANMASK,				0x009004),
-	REG(ANA_PORT_B_DOMAIN,				0x009008),
-	REG(ANA_ANAGEFIL,				0x00900c),
-	REG(ANA_ANEVENTS,				0x009010),
-	REG(ANA_STORMLIMIT_BURST,			0x009014),
-	REG(ANA_STORMLIMIT_CFG,				0x009018),
-	REG(ANA_ISOLATED_PORTS,				0x009028),
-	REG(ANA_COMMUNITY_PORTS,			0x00902c),
-	REG(ANA_AUTOAGE,				0x009030),
-	REG(ANA_MACTOPTIONS,				0x009034),
-	REG(ANA_LEARNDISC,				0x009038),
-	REG(ANA_AGENCTRL,				0x00903c),
-	REG(ANA_MIRRORPORTS,				0x009040),
-	REG(ANA_EMIRRORPORTS,				0x009044),
-	REG(ANA_FLOODING,				0x009048),
-	REG(ANA_FLOODING_IPMC,				0x00904c),
-	REG(ANA_SFLOW_CFG,				0x009050),
-	REG(ANA_PORT_MODE,				0x009080),
-	REG(ANA_PGID_PGID,				0x008c00),
-	REG(ANA_TABLES_ANMOVED,				0x008b30),
-	REG(ANA_TABLES_MACHDATA,			0x008b34),
-	REG(ANA_TABLES_MACLDATA,			0x008b38),
-	REG(ANA_TABLES_MACACCESS,			0x008b3c),
-	REG(ANA_TABLES_MACTINDX,			0x008b40),
-	REG(ANA_TABLES_VLANACCESS,			0x008b44),
-	REG(ANA_TABLES_VLANTIDX,			0x008b48),
-	REG(ANA_TABLES_ISDXACCESS,			0x008b4c),
-	REG(ANA_TABLES_ISDXTIDX,			0x008b50),
-	REG(ANA_TABLES_ENTRYLIM,			0x008b00),
-	REG(ANA_TABLES_PTP_ID_HIGH,			0x008b54),
-	REG(ANA_TABLES_PTP_ID_LOW,			0x008b58),
-	REG(ANA_MSTI_STATE,				0x008e00),
-	REG(ANA_PORT_VLAN_CFG,				0x007000),
-	REG(ANA_PORT_DROP_CFG,				0x007004),
-	REG(ANA_PORT_QOS_CFG,				0x007008),
-	REG(ANA_PORT_VCAP_CFG,				0x00700c),
-	REG(ANA_PORT_VCAP_S1_KEY_CFG,			0x007010),
-	REG(ANA_PORT_VCAP_S2_CFG,			0x00701c),
-	REG(ANA_PORT_PCP_DEI_MAP,			0x007020),
-	REG(ANA_PORT_CPU_FWD_CFG,			0x007060),
-	REG(ANA_PORT_CPU_FWD_BPDU_CFG,			0x007064),
-	REG(ANA_PORT_CPU_FWD_GARP_CFG,			0x007068),
-	REG(ANA_PORT_CPU_FWD_CCM_CFG,			0x00706c),
-	REG(ANA_PORT_PORT_CFG,				0x007070),
-	REG(ANA_PORT_POL_CFG,				0x007074),
-	REG(ANA_PORT_PTP_CFG,				0x007078),
-	REG(ANA_PORT_PTP_DLY1_CFG,			0x00707c),
-	REG(ANA_OAM_UPM_LM_CNT,				0x007c00),
-	REG(ANA_PORT_PTP_DLY2_CFG,			0x007080),
-	REG(ANA_PFC_PFC_CFG,				0x008800),
-	REG(ANA_PFC_PFC_TIMER,				0x008804),
-	REG(ANA_IPT_OAM_MEP_CFG,			0x008000),
-	REG(ANA_IPT_IPT,				0x008004),
-	REG(ANA_PPT_PPT,				0x008ac0),
-	REG(ANA_FID_MAP_FID_MAP,			0x000000),
-	REG(ANA_AGGR_CFG,				0x0090b4),
-	REG(ANA_CPUQ_CFG,				0x0090b8),
-	REG(ANA_CPUQ_CFG2,				0x0090bc),
-	REG(ANA_CPUQ_8021_CFG,				0x0090c0),
-	REG(ANA_DSCP_CFG,				0x009100),
-	REG(ANA_DSCP_REWR_CFG,				0x009200),
-	REG(ANA_VCAP_RNG_TYPE_CFG,			0x009240),
-	REG(ANA_VCAP_RNG_VAL_CFG,			0x009260),
-	REG(ANA_VRAP_CFG,				0x009280),
-	REG(ANA_VRAP_HDR_DATA,				0x009284),
-	REG(ANA_VRAP_HDR_MASK,				0x009288),
-	REG(ANA_DISCARD_CFG,				0x00928c),
-	REG(ANA_FID_CFG,				0x009290),
-	REG(ANA_POL_PIR_CFG,				0x004000),
-	REG(ANA_POL_CIR_CFG,				0x004004),
-	REG(ANA_POL_MODE_CFG,				0x004008),
-	REG(ANA_POL_PIR_STATE,				0x00400c),
-	REG(ANA_POL_CIR_STATE,				0x004010),
-	REG(ANA_POL_STATE,				0x004014),
-	REG(ANA_POL_FLOWC,				0x008b80),
-	REG(ANA_POL_HYST,				0x008bec),
-	REG(ANA_POL_MISC_CFG,				0x008bf0),
-};
-
-static const u32 ocelot_qs_regmap[] = {
-	REG(QS_XTR_GRP_CFG,				0x000000),
-	REG(QS_XTR_RD,					0x000008),
-	REG(QS_XTR_FRM_PRUNING,				0x000010),
-	REG(QS_XTR_FLUSH,				0x000018),
-	REG(QS_XTR_DATA_PRESENT,			0x00001c),
-	REG(QS_XTR_CFG,					0x000020),
-	REG(QS_INJ_GRP_CFG,				0x000024),
-	REG(QS_INJ_WR,					0x00002c),
-	REG(QS_INJ_CTRL,				0x000034),
-	REG(QS_INJ_STATUS,				0x00003c),
-	REG(QS_INJ_ERR,					0x000040),
-	REG(QS_INH_DBG,					0x000048),
-};
-
-static const u32 ocelot_qsys_regmap[] = {
-	REG(QSYS_PORT_MODE,				0x011200),
-	REG(QSYS_SWITCH_PORT_MODE,			0x011234),
-	REG(QSYS_STAT_CNT_CFG,				0x011264),
-	REG(QSYS_EEE_CFG,				0x011268),
-	REG(QSYS_EEE_THRES,				0x011294),
-	REG(QSYS_IGR_NO_SHARING,			0x011298),
-	REG(QSYS_EGR_NO_SHARING,			0x01129c),
-	REG(QSYS_SW_STATUS,				0x0112a0),
-	REG(QSYS_EXT_CPU_CFG,				0x0112d0),
-	REG(QSYS_PAD_CFG,				0x0112d4),
-	REG(QSYS_CPU_GROUP_MAP,				0x0112d8),
-	REG(QSYS_QMAP,					0x0112dc),
-	REG(QSYS_ISDX_SGRP,				0x011400),
-	REG(QSYS_TIMED_FRAME_ENTRY,			0x014000),
-	REG(QSYS_TFRM_MISC,				0x011310),
-	REG(QSYS_TFRM_PORT_DLY,				0x011314),
-	REG(QSYS_TFRM_TIMER_CFG_1,			0x011318),
-	REG(QSYS_TFRM_TIMER_CFG_2,			0x01131c),
-	REG(QSYS_TFRM_TIMER_CFG_3,			0x011320),
-	REG(QSYS_TFRM_TIMER_CFG_4,			0x011324),
-	REG(QSYS_TFRM_TIMER_CFG_5,			0x011328),
-	REG(QSYS_TFRM_TIMER_CFG_6,			0x01132c),
-	REG(QSYS_TFRM_TIMER_CFG_7,			0x011330),
-	REG(QSYS_TFRM_TIMER_CFG_8,			0x011334),
-	REG(QSYS_RED_PROFILE,				0x011338),
-	REG(QSYS_RES_QOS_MODE,				0x011378),
-	REG(QSYS_RES_CFG,				0x012000),
-	REG(QSYS_RES_STAT,				0x012004),
-	REG(QSYS_EGR_DROP_MODE,				0x01137c),
-	REG(QSYS_EQ_CTRL,				0x011380),
-	REG(QSYS_EVENTS_CORE,				0x011384),
-	REG(QSYS_CIR_CFG,				0x000000),
-	REG(QSYS_EIR_CFG,				0x000004),
-	REG(QSYS_SE_CFG,				0x000008),
-	REG(QSYS_SE_DWRR_CFG,				0x00000c),
-	REG(QSYS_SE_CONNECT,				0x00003c),
-	REG(QSYS_SE_DLB_SENSE,				0x000040),
-	REG(QSYS_CIR_STATE,				0x000044),
-	REG(QSYS_EIR_STATE,				0x000048),
-	REG(QSYS_SE_STATE,				0x00004c),
-	REG(QSYS_HSCH_MISC_CFG,				0x011388),
-};
-
-static const u32 ocelot_rew_regmap[] = {
-	REG(REW_PORT_VLAN_CFG,				0x000000),
-	REG(REW_TAG_CFG,				0x000004),
-	REG(REW_PORT_CFG,				0x000008),
-	REG(REW_DSCP_CFG,				0x00000c),
-	REG(REW_PCP_DEI_QOS_MAP_CFG,			0x000010),
-	REG(REW_PTP_CFG,				0x000050),
-	REG(REW_PTP_DLY1_CFG,				0x000054),
-	REG(REW_DSCP_REMAP_DP1_CFG,			0x000690),
-	REG(REW_DSCP_REMAP_CFG,				0x000790),
-	REG(REW_STAT_CFG,				0x000890),
-	REG(REW_PPT,					0x000680),
-};
-
-static const u32 ocelot_sys_regmap[] = {
-	REG(SYS_COUNT_RX_OCTETS,			0x000000),
-	REG(SYS_COUNT_RX_UNICAST,			0x000004),
-	REG(SYS_COUNT_RX_MULTICAST,			0x000008),
-	REG(SYS_COUNT_RX_BROADCAST,			0x00000c),
-	REG(SYS_COUNT_RX_SHORTS,			0x000010),
-	REG(SYS_COUNT_RX_FRAGMENTS,			0x000014),
-	REG(SYS_COUNT_RX_JABBERS,			0x000018),
-	REG(SYS_COUNT_RX_CRC_ALIGN_ERRS,		0x00001c),
-	REG(SYS_COUNT_RX_SYM_ERRS,			0x000020),
-	REG(SYS_COUNT_RX_64,				0x000024),
-	REG(SYS_COUNT_RX_65_127,			0x000028),
-	REG(SYS_COUNT_RX_128_255,			0x00002c),
-	REG(SYS_COUNT_RX_256_1023,			0x000030),
-	REG(SYS_COUNT_RX_1024_1526,			0x000034),
-	REG(SYS_COUNT_RX_1527_MAX,			0x000038),
-	REG(SYS_COUNT_RX_PAUSE,				0x00003c),
-	REG(SYS_COUNT_RX_CONTROL,			0x000040),
-	REG(SYS_COUNT_RX_LONGS,				0x000044),
-	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,		0x000048),
-	REG(SYS_COUNT_TX_OCTETS,			0x000100),
-	REG(SYS_COUNT_TX_UNICAST,			0x000104),
-	REG(SYS_COUNT_TX_MULTICAST,			0x000108),
-	REG(SYS_COUNT_TX_BROADCAST,			0x00010c),
-	REG(SYS_COUNT_TX_COLLISION,			0x000110),
-	REG(SYS_COUNT_TX_DROPS,				0x000114),
-	REG(SYS_COUNT_TX_PAUSE,				0x000118),
-	REG(SYS_COUNT_TX_64,				0x00011c),
-	REG(SYS_COUNT_TX_65_127,			0x000120),
-	REG(SYS_COUNT_TX_128_511,			0x000124),
-	REG(SYS_COUNT_TX_512_1023,			0x000128),
-	REG(SYS_COUNT_TX_1024_1526,			0x00012c),
-	REG(SYS_COUNT_TX_1527_MAX,			0x000130),
-	REG(SYS_COUNT_TX_AGING,				0x000170),
-	REG(SYS_RESET_CFG,				0x000508),
-	REG(SYS_CMID,					0x00050c),
-	REG(SYS_VLAN_ETYPE_CFG,				0x000510),
-	REG(SYS_PORT_MODE,				0x000514),
-	REG(SYS_FRONT_PORT_MODE,			0x000548),
-	REG(SYS_FRM_AGING,				0x000574),
-	REG(SYS_STAT_CFG,				0x000578),
-	REG(SYS_SW_STATUS,				0x00057c),
-	REG(SYS_MISC_CFG,				0x0005ac),
-	REG(SYS_REW_MAC_HIGH_CFG,			0x0005b0),
-	REG(SYS_REW_MAC_LOW_CFG,			0x0005dc),
-	REG(SYS_CM_ADDR,				0x000500),
-	REG(SYS_CM_DATA,				0x000504),
-	REG(SYS_PAUSE_CFG,				0x000608),
-	REG(SYS_PAUSE_TOT_CFG,				0x000638),
-	REG(SYS_ATOP,					0x00063c),
-	REG(SYS_ATOP_TOT_CFG,				0x00066c),
-	REG(SYS_MAC_FC_CFG,				0x000670),
-	REG(SYS_MMGT,					0x00069c),
-	REG(SYS_MMGT_FAST,				0x0006a0),
-	REG(SYS_EVENTS_DIF,				0x0006a4),
-	REG(SYS_EVENTS_CORE,				0x0006b4),
-	REG(SYS_CNT,					0x000000),
-	REG(SYS_PTP_STATUS,				0x0006b8),
-	REG(SYS_PTP_TXSTAMP,				0x0006bc),
-	REG(SYS_PTP_NXT,				0x0006c0),
-	REG(SYS_PTP_CFG,				0x0006c4),
-};
-
-static const u32 ocelot_vcap_regmap[] = {
-	/* VCAP_CORE_CFG */
-	REG(VCAP_CORE_UPDATE_CTRL,			0x000000),
-	REG(VCAP_CORE_MV_CFG,				0x000004),
-	/* VCAP_CORE_CACHE */
-	REG(VCAP_CACHE_ENTRY_DAT,			0x000008),
-	REG(VCAP_CACHE_MASK_DAT,			0x000108),
-	REG(VCAP_CACHE_ACTION_DAT,			0x000208),
-	REG(VCAP_CACHE_CNT_DAT,				0x000308),
-	REG(VCAP_CACHE_TG_DAT,				0x000388),
-	/* VCAP_CONST */
-	REG(VCAP_CONST_VCAP_VER,			0x000398),
-	REG(VCAP_CONST_ENTRY_WIDTH,			0x00039c),
-	REG(VCAP_CONST_ENTRY_CNT,			0x0003a0),
-	REG(VCAP_CONST_ENTRY_SWCNT,			0x0003a4),
-	REG(VCAP_CONST_ENTRY_TG_WIDTH,			0x0003a8),
-	REG(VCAP_CONST_ACTION_DEF_CNT,			0x0003ac),
-	REG(VCAP_CONST_ACTION_WIDTH,			0x0003b0),
-	REG(VCAP_CONST_CNT_WIDTH,			0x0003b4),
-	REG(VCAP_CONST_CORE_CNT,			0x0003b8),
-	REG(VCAP_CONST_IF_CNT,				0x0003bc),
-};
-
-static const u32 ocelot_ptp_regmap[] = {
-	REG(PTP_PIN_CFG,				0x000000),
-	REG(PTP_PIN_TOD_SEC_MSB,			0x000004),
-	REG(PTP_PIN_TOD_SEC_LSB,			0x000008),
-	REG(PTP_PIN_TOD_NSEC,				0x00000c),
-	REG(PTP_PIN_WF_HIGH_PERIOD,			0x000014),
-	REG(PTP_PIN_WF_LOW_PERIOD,			0x000018),
-	REG(PTP_CFG_MISC,				0x0000a0),
-	REG(PTP_CLK_CFG_ADJ_CFG,			0x0000a4),
-	REG(PTP_CLK_CFG_ADJ_FREQ,			0x0000a8),
-};
-
-static const u32 ocelot_dev_gmii_regmap[] = {
-	REG(DEV_CLOCK_CFG,				0x0),
-	REG(DEV_PORT_MISC,				0x4),
-	REG(DEV_EVENTS,					0x8),
-	REG(DEV_EEE_CFG,				0xc),
-	REG(DEV_RX_PATH_DELAY,				0x10),
-	REG(DEV_TX_PATH_DELAY,				0x14),
-	REG(DEV_PTP_PREDICT_CFG,			0x18),
-	REG(DEV_MAC_ENA_CFG,				0x1c),
-	REG(DEV_MAC_MODE_CFG,				0x20),
-	REG(DEV_MAC_MAXLEN_CFG,				0x24),
-	REG(DEV_MAC_TAGS_CFG,				0x28),
-	REG(DEV_MAC_ADV_CHK_CFG,			0x2c),
-	REG(DEV_MAC_IFG_CFG,				0x30),
-	REG(DEV_MAC_HDX_CFG,				0x34),
-	REG(DEV_MAC_DBG_CFG,				0x38),
-	REG(DEV_MAC_FC_MAC_LOW_CFG,			0x3c),
-	REG(DEV_MAC_FC_MAC_HIGH_CFG,			0x40),
-	REG(DEV_MAC_STICKY,				0x44),
-	REG(PCS1G_CFG,					0x48),
-	REG(PCS1G_MODE_CFG,				0x4c),
-	REG(PCS1G_SD_CFG,				0x50),
-	REG(PCS1G_ANEG_CFG,				0x54),
-	REG(PCS1G_ANEG_NP_CFG,				0x58),
-	REG(PCS1G_LB_CFG,				0x5c),
-	REG(PCS1G_DBG_CFG,				0x60),
-	REG(PCS1G_CDET_CFG,				0x64),
-	REG(PCS1G_ANEG_STATUS,				0x68),
-	REG(PCS1G_ANEG_NP_STATUS,			0x6c),
-	REG(PCS1G_LINK_STATUS,				0x70),
-	REG(PCS1G_LINK_DOWN_CNT,			0x74),
-	REG(PCS1G_STICKY,				0x78),
-	REG(PCS1G_DEBUG_STATUS,				0x7c),
-	REG(PCS1G_LPI_CFG,				0x80),
-	REG(PCS1G_LPI_WAKE_ERROR_CNT,			0x84),
-	REG(PCS1G_LPI_STATUS,				0x88),
-	REG(PCS1G_TSTPAT_MODE_CFG,			0x8c),
-	REG(PCS1G_TSTPAT_STATUS,			0x90),
-	REG(DEV_PCS_FX100_CFG,				0x94),
-	REG(DEV_PCS_FX100_STATUS,			0x98),
-};
-
 static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[ANA] = ocelot_ana_regmap,
 	[QS] = ocelot_qs_regmap,
diff --git a/include/soc/mscc/ocelot_regs.h b/include/soc/mscc/ocelot_regs.h
new file mode 100644
index 000000000000..d4508eb9e04a
--- /dev/null
+++ b/include/soc/mscc/ocelot_regs.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Microsemi Ocelot Switch driver
+ *
+ * Copyright (c) 2021 Innovative Advantage Inc.
+ */
+
+#ifndef OCELOT_REGS_H
+#define OCELOT_REGS_H
+
+extern const u32 ocelot_ana_regmap[];
+extern const u32 ocelot_qs_regmap[];
+extern const u32 ocelot_qsys_regmap[];
+extern const u32 ocelot_rew_regmap[];
+extern const u32 ocelot_sys_regmap[];
+extern const u32 ocelot_vcap_regmap[];
+extern const u32 ocelot_ptp_regmap[];
+extern const u32 ocelot_dev_gmii_regmap[];
+
+#endif
-- 
2.25.1

