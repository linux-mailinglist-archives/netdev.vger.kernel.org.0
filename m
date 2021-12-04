Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54E9468716
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385437AbhLDScy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:32:54 -0500
Received: from mail-dm6nam11on2112.outbound.protection.outlook.com ([40.107.223.112]:6588
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355624AbhLDScr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:32:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlxbCI3FsUVCufAM+neH3lXq9ORgsZK4dkj0OilYm97VWemfpyUVRavDxavaBzbpgmoz2aEdBo8AhMqZWGVLo56Jqfrmg1XdmjZAYQ2CzNNkUdtZZNXgPN1s+QNKOfB8OWTIpWU4cPY42K2ZlldOHQ15SxfFcFJwrIX4l/eg5NrlpxdBlrfe2HiPAn0NEoY/S38+TZjQHqJFhhzoXV3I/3Xvh9GIPj+iQYcjQv+QhYg9Gj6SOAE1ikcQHZJPanN4H6ZV2cgyFqERMkV3huGjQjIKlL9/2xGPrO7Ank1MvFoOcyS9vcHVh3hz4XtZ0TlXqQY3p9x7yRgGcGIJHFgRog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJz9bCqVBP1GML/RTm10m6exhjSQCIDuGOVYkcHo2XU=;
 b=cK/wy+emwE+0c5qRhVQZfXyNpH/rvz4fUhS0x7A9CvIqISSaMhhSyAi6FpYU2bMQ7yCLnLWMVtNvUqaVXD2mfeFCh4/sugj2/Nq9FrMeDVBvOR0ykDW69dY1Bky8ilKy9e78WjQ4b6kgLv44ZeY2+67mdh9cT9dD8bwX7sz4300Qx/m8IgcBowMM6IK+UtulUz2Uwv7EMjCquOHWQzl01YFA7F/9cbnOA5FarBsozI9cTSUSCrgH4L33pgceyCS5RO36P0jW+6EUMTjw42Hgdn91Nr7gT4KNMt5Tk8wEMNEaf9TGk0FFHod88TbBqSOmy3Umb/j71uV04cyJwVm3pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJz9bCqVBP1GML/RTm10m6exhjSQCIDuGOVYkcHo2XU=;
 b=z1DomwLBuDxFoQuRlZ9MRqHjxi5gdbF/WaNlUZ+RvgB5GtV8b87Cy1N2/KUsbUT6xgDCq2aigC5t19eyz44TuTdyHwQaEbUpuKAsS4JtAxHH/xZHNJm3Ry0vaqKSAtUzhl84VFdg2W7gJL+FEC4zqVbelaIIlaL+pkyDJAAAgiM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com (10.174.170.165) by
 MWHPR1001MB2063.namprd10.prod.outlook.com (10.174.170.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Sat, 4 Dec 2021 18:29:17 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:29:17 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v4 net-next 4/5] net: mscc: ocelot: split register definitions to a separate file
Date:   Sat,  4 Dec 2021 10:28:57 -0800
Message-Id: <20211204182858.1052710-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204182858.1052710-1-colin.foster@in-advantage.com>
References: <20211204182858.1052710-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:300:115::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0045.namprd11.prod.outlook.com (2603:10b6:300:115::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend Transport; Sat, 4 Dec 2021 18:29:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9d249b5-7073-4a9f-9b39-08d9b753f70c
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2063:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB206391E8CE64AD67FADBCE36A46B9@MWHPR1001MB2063.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:556;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: URPD7M+h1i0saT4dcpYo8DyLEfSz4bMV/uSUnXaefgpIhewEmGe/U25BMkdYoFOd8dARJOvymiB+SdNXNuhOo01QDbMlGu1DX22c2M7Ig+5AejdJxeKKaDLMPqthZitdZOVMVgAxDYess5CVcTPY5PZAczIhf2uCniWrZeb22mLsBWOiBYD/BGxTj1dNB0W1P5vvzEm125ElTK/ang5+61xZE1EzmdX7a75HKiU5grRDbQRRPoj+TtNYoNrBNb7wJN64n4ogkEza65vAZvo/Ihvne9/x15+DBQ1+5CD0QQtGuFfsHBtYkFFIrsjgoVDM6XwHm8qckPTwc3L08YLYhyXZMzyNHA64zCFmVWZGPmQXw7xKczbNst9zydu80yjcc/WPjbiUVcwzBvKKvwY5EjOtqL6110KyY4vTJg/06amxcEyeoWEPr9iffYpuiI7vtYvwvATRSqayaS0py6ppIQl972C10HVhH9ryncDjlF0uZyXE39xuazETTbbXlnIhNgp+hb5T5gUh8dO5TLyWewdF+4JEF7xmTIeBDWGoCPQg8lBG3/O2xQrjM7A+EBAYLD/KFFwMLRM7nf/J6A6qETQlCSn8xXjScgnMe1vzjcENlNJNVOwTlF29AZ6Ej1jjPnTYDUjytX8sWKMeBsN51P8konuDQTSokzMpuS9UYZ18+NddERauOMGrQBrdc3j1KQxVeikrdGCoFaKP50Nf8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(366004)(376002)(136003)(346002)(396003)(8936002)(2616005)(956004)(86362001)(4326008)(508600001)(1076003)(66556008)(7416002)(6486002)(66946007)(6506007)(52116002)(30864003)(6512007)(36756003)(54906003)(66476007)(8676002)(83380400001)(26005)(5660300002)(44832011)(316002)(2906002)(38350700002)(6666004)(38100700002)(186003)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jWyWpudenGiHI6/fybhoAJlSmraZ+VZ5cb9d9AIdTbAyhDuAvSAhy5RLYkQI?=
 =?us-ascii?Q?vl52Z6tQ9XV/WRDim4NxpoS95gWE1Wc82RwXhFWJlD+VOy/0TrykhhJlTsEa?=
 =?us-ascii?Q?Ls4ZdurT27yT0IBmr2DgvQsQ6bFiSXVQx91xRrbtg1eCorP86x/4yT9ZvM8h?=
 =?us-ascii?Q?S/QGfxKLJfK40SkYxKTQ0o27kq6FEpovNCUWJcwPVp9go3LG4EaZrKGJ3h5m?=
 =?us-ascii?Q?/cte4c6I2Vf8LLmXspNGmxi3lgD9l2tsvxEx5dVXJDLPPKhMIUlUSX3A60bR?=
 =?us-ascii?Q?a4r6USo1x8EEcmVJMxoLFHCm7LrDm0bOhb4UjTkhY5waPWsrQLQ8ad6863EN?=
 =?us-ascii?Q?cLrAiQR6P9OHOj0sNwgIFduZADiWwRLTqnfPzZ2qF76OYrQPdeulRFRHDPzI?=
 =?us-ascii?Q?N123YZnjNXnq3iumHxdWR/cncpXdz35FdV5ZtB+bp8RxZMfq+W18tHzRNNJl?=
 =?us-ascii?Q?TSaymKZRsy7snno1c/R2kIzEoD1sSX4gTrz0ItVuNgbTBu2UEf1nrSgcxgmi?=
 =?us-ascii?Q?F/Z/07jt3CZyZkw3YZoNekHJyUm2cL/ZUFONtupLC2PPO17xt27ZfeuSvXSo?=
 =?us-ascii?Q?j5QhKrLPLxjbqBsKbxMSBKspepQuagCWQgyAP7iBK1FucgxBos5gnswSuLch?=
 =?us-ascii?Q?nkbH1EW2B2w2GD+NUkb/woqnDQl+Q0eNDAqjs1n3mJFPBzV5HftsOndx/N2z?=
 =?us-ascii?Q?mEJHiyRghpaOtQFJhcBlfXVpb0tDESHiCkaTX4tNxCO/JOgChpe13Xm4L9Zp?=
 =?us-ascii?Q?63K57NcTX1JlY6FTS6k0pxKmDrqdUI8qgPB5KVUYiDGF2aHZRbIXmit0cT4D?=
 =?us-ascii?Q?qDDWzO1QhRsRNJhBFibE7sKT4FaJ2JYJrBlRnAldepRLQwhIi5iW1RJyWTNa?=
 =?us-ascii?Q?I9sM8ntzS8L618v/UEQMrYuDRv3KYmgfgSbdXR3k6vxofs+kzGwSPlK6UW17?=
 =?us-ascii?Q?XtuuMB411MDgyxQyjzI2Kk69uIM1508Fr0MbrFChT8ZFfM6V9vSeaRgSt5ga?=
 =?us-ascii?Q?nYIvjo+h6WdYuV4ktB3Xr1jQfpysTn7N7DfLVlsLuwmfKqcSAsbqQdOgsf7L?=
 =?us-ascii?Q?8RM6Lw62P/K0jQxko1rFYKSI1cBK/KrPY0OUN8YUbHnPG7u1Cogx9EEq8wfW?=
 =?us-ascii?Q?HcVTmGpwHzXUil6RjTRLOc2PgzxDmgUUX7wA8nBofKZmP8xlnsREPMit7x2J?=
 =?us-ascii?Q?tedbmtLWUOdjdoEpygaBqhH9LjelIbtqyPnsraR3cLITk/8Gu6WzO6q43ujB?=
 =?us-ascii?Q?ECQcy8Dqt/yLuwTJ9TCB+UaiSqv50TELh+1p87vcSZ1utMCIzX47iDHpB1ri?=
 =?us-ascii?Q?0aK3bpIaGBNEPSphE92JfRNfmXkRIN/jmKr4tBn6GtoFWOmwbglJ8vmtRbCJ?=
 =?us-ascii?Q?00SLXEroDMAxp2b7OfluSiN2nLAasmJapTw+PUjYJK/2xtDCkTcFBPevFho4?=
 =?us-ascii?Q?Z38rEyG8nTrrIhMb2rOHJmaJJDK8TyjYK2yILJY6fAFWgEs5r7repR9Yucn2?=
 =?us-ascii?Q?pbu4RkobH+npA8ELDQ6tHYpFHOOvuEh0L3wen65c8slh+wfXTaZ3rP7nym4e?=
 =?us-ascii?Q?Ah/sn6S/IyF7M5LsYT49FGL8auW+81sEVQuyNeI4Iq15OoCcc3/09a0exxoB?=
 =?us-ascii?Q?vxjm6vKcW4vk4EtPhVWa6h1o9xi4cWR6iJBNv1/QAxIHAyc/VIeW4OQQQfWR?=
 =?us-ascii?Q?R42GJpgTYYZz0ZURdi1QWdlyHFs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d249b5-7073-4a9f-9b39-08d9b753f70c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:29:10.6751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ggpvLLae8A47QhQ6WcebeaA1gKJctViO28gE3jq8isil8eeiVeZSkjHUJtlMFrTfgeuzBc7nMpWS8Xx2IdqV7dV8kwc8iSlBkP/g4ZeAZlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move these to a separate file will allow them to be shared to other
drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 520 +-------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 523 +++++++++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  27 ++
 4 files changed, 563 insertions(+), 510 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/vsc7514_regs.c
 create mode 100644 include/soc/mscc/vsc7514_regs.h

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 722c27694b21..dfa939376d6c 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -7,7 +7,8 @@ mscc_ocelot_switch_lib-y := \
 	ocelot_vcap.o \
 	ocelot_flower.o \
 	ocelot_ptp.o \
-	ocelot_devlink.o
+	ocelot_devlink.o \
+	vsc7514_regs.o
 mscc_ocelot_switch_lib-$(CONFIG_BRIDGE_MRP) += ocelot_mrp.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
 mscc_ocelot-y := \
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index cd3eb101f159..2db59060f5ab 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -18,316 +18,23 @@
 
 #include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot_hsio.h>
+#include <soc/mscc/vsc7514_regs.h>
 #include "ocelot.h"
 
 #define VSC7514_VCAP_POLICER_BASE			128
 #define VSC7514_VCAP_POLICER_MAX			191
 
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
-	[ANA] = ocelot_ana_regmap,
-	[QS] = ocelot_qs_regmap,
-	[QSYS] = ocelot_qsys_regmap,
-	[REW] = ocelot_rew_regmap,
-	[SYS] = ocelot_sys_regmap,
-	[S0] = ocelot_vcap_regmap,
-	[S1] = ocelot_vcap_regmap,
-	[S2] = ocelot_vcap_regmap,
-	[PTP] = ocelot_ptp_regmap,
-	[DEV_GMII] = ocelot_dev_gmii_regmap,
+	[ANA] = vsc7514_ana_regmap,
+	[QS] = vsc7514_qs_regmap,
+	[QSYS] = vsc7514_qsys_regmap,
+	[REW] = vsc7514_rew_regmap,
+	[SYS] = vsc7514_sys_regmap,
+	[S0] = vsc7514_vcap_regmap,
+	[S1] = vsc7514_vcap_regmap,
+	[S2] = vsc7514_vcap_regmap,
+	[PTP] = vsc7514_ptp_regmap,
+	[DEV_GMII] = vsc7514_dev_gmii_regmap,
 };
 
 static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
@@ -636,211 +343,6 @@ static const struct ocelot_ops ocelot_ops = {
 	.netdev_to_port		= ocelot_netdev_to_port,
 };
 
-static const struct vcap_field vsc7514_vcap_es0_keys[] = {
-	[VCAP_ES0_EGR_PORT]			= {  0,  4},
-	[VCAP_ES0_IGR_PORT]			= {  4,  4},
-	[VCAP_ES0_RSV]				= {  8,  2},
-	[VCAP_ES0_L2_MC]			= { 10,  1},
-	[VCAP_ES0_L2_BC]			= { 11,  1},
-	[VCAP_ES0_VID]				= { 12, 12},
-	[VCAP_ES0_DP]				= { 24,  1},
-	[VCAP_ES0_PCP]				= { 25,  3},
-};
-
-static const struct vcap_field vsc7514_vcap_es0_actions[] = {
-	[VCAP_ES0_ACT_PUSH_OUTER_TAG]		= {  0,  2},
-	[VCAP_ES0_ACT_PUSH_INNER_TAG]		= {  2,  1},
-	[VCAP_ES0_ACT_TAG_A_TPID_SEL]		= {  3,  2},
-	[VCAP_ES0_ACT_TAG_A_VID_SEL]		= {  5,  1},
-	[VCAP_ES0_ACT_TAG_A_PCP_SEL]		= {  6,  2},
-	[VCAP_ES0_ACT_TAG_A_DEI_SEL]		= {  8,  2},
-	[VCAP_ES0_ACT_TAG_B_TPID_SEL]		= { 10,  2},
-	[VCAP_ES0_ACT_TAG_B_VID_SEL]		= { 12,  1},
-	[VCAP_ES0_ACT_TAG_B_PCP_SEL]		= { 13,  2},
-	[VCAP_ES0_ACT_TAG_B_DEI_SEL]		= { 15,  2},
-	[VCAP_ES0_ACT_VID_A_VAL]		= { 17, 12},
-	[VCAP_ES0_ACT_PCP_A_VAL]		= { 29,  3},
-	[VCAP_ES0_ACT_DEI_A_VAL]		= { 32,  1},
-	[VCAP_ES0_ACT_VID_B_VAL]		= { 33, 12},
-	[VCAP_ES0_ACT_PCP_B_VAL]		= { 45,  3},
-	[VCAP_ES0_ACT_DEI_B_VAL]		= { 48,  1},
-	[VCAP_ES0_ACT_RSV]			= { 49, 24},
-	[VCAP_ES0_ACT_HIT_STICKY]		= { 73,  1},
-};
-
-static const struct vcap_field vsc7514_vcap_is1_keys[] = {
-	[VCAP_IS1_HK_TYPE]			= {  0,   1},
-	[VCAP_IS1_HK_LOOKUP]			= {  1,   2},
-	[VCAP_IS1_HK_IGR_PORT_MASK]		= {  3,  12},
-	[VCAP_IS1_HK_RSV]			= { 15,   9},
-	[VCAP_IS1_HK_OAM_Y1731]			= { 24,   1},
-	[VCAP_IS1_HK_L2_MC]			= { 25,   1},
-	[VCAP_IS1_HK_L2_BC]			= { 26,   1},
-	[VCAP_IS1_HK_IP_MC]			= { 27,   1},
-	[VCAP_IS1_HK_VLAN_TAGGED]		= { 28,   1},
-	[VCAP_IS1_HK_VLAN_DBL_TAGGED]		= { 29,   1},
-	[VCAP_IS1_HK_TPID]			= { 30,   1},
-	[VCAP_IS1_HK_VID]			= { 31,  12},
-	[VCAP_IS1_HK_DEI]			= { 43,   1},
-	[VCAP_IS1_HK_PCP]			= { 44,   3},
-	/* Specific Fields for IS1 Half Key S1_NORMAL */
-	[VCAP_IS1_HK_L2_SMAC]			= { 47,  48},
-	[VCAP_IS1_HK_ETYPE_LEN]			= { 95,   1},
-	[VCAP_IS1_HK_ETYPE]			= { 96,  16},
-	[VCAP_IS1_HK_IP_SNAP]			= {112,   1},
-	[VCAP_IS1_HK_IP4]			= {113,   1},
-	/* Layer-3 Information */
-	[VCAP_IS1_HK_L3_FRAGMENT]		= {114,   1},
-	[VCAP_IS1_HK_L3_FRAG_OFS_GT0]		= {115,   1},
-	[VCAP_IS1_HK_L3_OPTIONS]		= {116,   1},
-	[VCAP_IS1_HK_L3_DSCP]			= {117,   6},
-	[VCAP_IS1_HK_L3_IP4_SIP]		= {123,  32},
-	/* Layer-4 Information */
-	[VCAP_IS1_HK_TCP_UDP]			= {155,   1},
-	[VCAP_IS1_HK_TCP]			= {156,   1},
-	[VCAP_IS1_HK_L4_SPORT]			= {157,  16},
-	[VCAP_IS1_HK_L4_RNG]			= {173,   8},
-	/* Specific Fields for IS1 Half Key S1_5TUPLE_IP4 */
-	[VCAP_IS1_HK_IP4_INNER_TPID]            = { 47,   1},
-	[VCAP_IS1_HK_IP4_INNER_VID]		= { 48,  12},
-	[VCAP_IS1_HK_IP4_INNER_DEI]		= { 60,   1},
-	[VCAP_IS1_HK_IP4_INNER_PCP]		= { 61,   3},
-	[VCAP_IS1_HK_IP4_IP4]			= { 64,   1},
-	[VCAP_IS1_HK_IP4_L3_FRAGMENT]		= { 65,   1},
-	[VCAP_IS1_HK_IP4_L3_FRAG_OFS_GT0]	= { 66,   1},
-	[VCAP_IS1_HK_IP4_L3_OPTIONS]		= { 67,   1},
-	[VCAP_IS1_HK_IP4_L3_DSCP]		= { 68,   6},
-	[VCAP_IS1_HK_IP4_L3_IP4_DIP]		= { 74,  32},
-	[VCAP_IS1_HK_IP4_L3_IP4_SIP]		= {106,  32},
-	[VCAP_IS1_HK_IP4_L3_PROTO]		= {138,   8},
-	[VCAP_IS1_HK_IP4_TCP_UDP]		= {146,   1},
-	[VCAP_IS1_HK_IP4_TCP]			= {147,   1},
-	[VCAP_IS1_HK_IP4_L4_RNG]		= {148,   8},
-	[VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE]	= {156,  32},
-};
-
-static const struct vcap_field vsc7514_vcap_is1_actions[] = {
-	[VCAP_IS1_ACT_DSCP_ENA]			= {  0,  1},
-	[VCAP_IS1_ACT_DSCP_VAL]			= {  1,  6},
-	[VCAP_IS1_ACT_QOS_ENA]			= {  7,  1},
-	[VCAP_IS1_ACT_QOS_VAL]			= {  8,  3},
-	[VCAP_IS1_ACT_DP_ENA]			= { 11,  1},
-	[VCAP_IS1_ACT_DP_VAL]			= { 12,  1},
-	[VCAP_IS1_ACT_PAG_OVERRIDE_MASK]	= { 13,  8},
-	[VCAP_IS1_ACT_PAG_VAL]			= { 21,  8},
-	[VCAP_IS1_ACT_RSV]			= { 29,  9},
-	/* The fields below are incorrectly shifted by 2 in the manual */
-	[VCAP_IS1_ACT_VID_REPLACE_ENA]		= { 38,  1},
-	[VCAP_IS1_ACT_VID_ADD_VAL]		= { 39, 12},
-	[VCAP_IS1_ACT_FID_SEL]			= { 51,  2},
-	[VCAP_IS1_ACT_FID_VAL]			= { 53, 13},
-	[VCAP_IS1_ACT_PCP_DEI_ENA]		= { 66,  1},
-	[VCAP_IS1_ACT_PCP_VAL]			= { 67,  3},
-	[VCAP_IS1_ACT_DEI_VAL]			= { 70,  1},
-	[VCAP_IS1_ACT_VLAN_POP_CNT_ENA]		= { 71,  1},
-	[VCAP_IS1_ACT_VLAN_POP_CNT]		= { 72,  2},
-	[VCAP_IS1_ACT_CUSTOM_ACE_TYPE_ENA]	= { 74,  4},
-	[VCAP_IS1_ACT_HIT_STICKY]		= { 78,  1},
-};
-
-static const struct vcap_field vsc7514_vcap_is2_keys[] = {
-	/* Common: 46 bits */
-	[VCAP_IS2_TYPE]				= {  0,   4},
-	[VCAP_IS2_HK_FIRST]			= {  4,   1},
-	[VCAP_IS2_HK_PAG]			= {  5,   8},
-	[VCAP_IS2_HK_IGR_PORT_MASK]		= { 13,  12},
-	[VCAP_IS2_HK_RSV2]			= { 25,   1},
-	[VCAP_IS2_HK_HOST_MATCH]		= { 26,   1},
-	[VCAP_IS2_HK_L2_MC]			= { 27,   1},
-	[VCAP_IS2_HK_L2_BC]			= { 28,   1},
-	[VCAP_IS2_HK_VLAN_TAGGED]		= { 29,   1},
-	[VCAP_IS2_HK_VID]			= { 30,  12},
-	[VCAP_IS2_HK_DEI]			= { 42,   1},
-	[VCAP_IS2_HK_PCP]			= { 43,   3},
-	/* MAC_ETYPE / MAC_LLC / MAC_SNAP / OAM common */
-	[VCAP_IS2_HK_L2_DMAC]			= { 46,  48},
-	[VCAP_IS2_HK_L2_SMAC]			= { 94,  48},
-	/* MAC_ETYPE (TYPE=000) */
-	[VCAP_IS2_HK_MAC_ETYPE_ETYPE]		= {142,  16},
-	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0]	= {158,  16},
-	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD1]	= {174,   8},
-	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD2]	= {182,   3},
-	/* MAC_LLC (TYPE=001) */
-	[VCAP_IS2_HK_MAC_LLC_L2_LLC]		= {142,  40},
-	/* MAC_SNAP (TYPE=010) */
-	[VCAP_IS2_HK_MAC_SNAP_L2_SNAP]		= {142,  40},
-	/* MAC_ARP (TYPE=011) */
-	[VCAP_IS2_HK_MAC_ARP_SMAC]		= { 46,  48},
-	[VCAP_IS2_HK_MAC_ARP_ADDR_SPACE_OK]	= { 94,   1},
-	[VCAP_IS2_HK_MAC_ARP_PROTO_SPACE_OK]	= { 95,   1},
-	[VCAP_IS2_HK_MAC_ARP_LEN_OK]		= { 96,   1},
-	[VCAP_IS2_HK_MAC_ARP_TARGET_MATCH]	= { 97,   1},
-	[VCAP_IS2_HK_MAC_ARP_SENDER_MATCH]	= { 98,   1},
-	[VCAP_IS2_HK_MAC_ARP_OPCODE_UNKNOWN]	= { 99,   1},
-	[VCAP_IS2_HK_MAC_ARP_OPCODE]		= {100,   2},
-	[VCAP_IS2_HK_MAC_ARP_L3_IP4_DIP]	= {102,  32},
-	[VCAP_IS2_HK_MAC_ARP_L3_IP4_SIP]	= {134,  32},
-	[VCAP_IS2_HK_MAC_ARP_DIP_EQ_SIP]	= {166,   1},
-	/* IP4_TCP_UDP / IP4_OTHER common */
-	[VCAP_IS2_HK_IP4]			= { 46,   1},
-	[VCAP_IS2_HK_L3_FRAGMENT]		= { 47,   1},
-	[VCAP_IS2_HK_L3_FRAG_OFS_GT0]		= { 48,   1},
-	[VCAP_IS2_HK_L3_OPTIONS]		= { 49,   1},
-	[VCAP_IS2_HK_IP4_L3_TTL_GT0]		= { 50,   1},
-	[VCAP_IS2_HK_L3_TOS]			= { 51,   8},
-	[VCAP_IS2_HK_L3_IP4_DIP]		= { 59,  32},
-	[VCAP_IS2_HK_L3_IP4_SIP]		= { 91,  32},
-	[VCAP_IS2_HK_DIP_EQ_SIP]		= {123,   1},
-	/* IP4_TCP_UDP (TYPE=100) */
-	[VCAP_IS2_HK_TCP]			= {124,   1},
-	[VCAP_IS2_HK_L4_DPORT]			= {125,  16},
-	[VCAP_IS2_HK_L4_SPORT]			= {141,  16},
-	[VCAP_IS2_HK_L4_RNG]			= {157,   8},
-	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]		= {165,   1},
-	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]		= {166,   1},
-	[VCAP_IS2_HK_L4_FIN]			= {167,   1},
-	[VCAP_IS2_HK_L4_SYN]			= {168,   1},
-	[VCAP_IS2_HK_L4_RST]			= {169,   1},
-	[VCAP_IS2_HK_L4_PSH]			= {170,   1},
-	[VCAP_IS2_HK_L4_ACK]			= {171,   1},
-	[VCAP_IS2_HK_L4_URG]			= {172,   1},
-	[VCAP_IS2_HK_L4_1588_DOM]		= {173,   8},
-	[VCAP_IS2_HK_L4_1588_VER]		= {181,   4},
-	/* IP4_OTHER (TYPE=101) */
-	[VCAP_IS2_HK_IP4_L3_PROTO]		= {124,   8},
-	[VCAP_IS2_HK_L3_PAYLOAD]		= {132,  56},
-	/* IP6_STD (TYPE=110) */
-	[VCAP_IS2_HK_IP6_L3_TTL_GT0]		= { 46,   1},
-	[VCAP_IS2_HK_L3_IP6_SIP]		= { 47, 128},
-	[VCAP_IS2_HK_IP6_L3_PROTO]		= {175,   8},
-	/* OAM (TYPE=111) */
-	[VCAP_IS2_HK_OAM_MEL_FLAGS]		= {142,   7},
-	[VCAP_IS2_HK_OAM_VER]			= {149,   5},
-	[VCAP_IS2_HK_OAM_OPCODE]		= {154,   8},
-	[VCAP_IS2_HK_OAM_FLAGS]			= {162,   8},
-	[VCAP_IS2_HK_OAM_MEPID]			= {170,  16},
-	[VCAP_IS2_HK_OAM_CCM_CNTS_EQ0]		= {186,   1},
-	[VCAP_IS2_HK_OAM_IS_Y1731]		= {187,   1},
-};
-
-static const struct vcap_field vsc7514_vcap_is2_actions[] = {
-	[VCAP_IS2_ACT_HIT_ME_ONCE]		= {  0,  1},
-	[VCAP_IS2_ACT_CPU_COPY_ENA]		= {  1,  1},
-	[VCAP_IS2_ACT_CPU_QU_NUM]		= {  2,  3},
-	[VCAP_IS2_ACT_MASK_MODE]		= {  5,  2},
-	[VCAP_IS2_ACT_MIRROR_ENA]		= {  7,  1},
-	[VCAP_IS2_ACT_LRN_DIS]			= {  8,  1},
-	[VCAP_IS2_ACT_POLICE_ENA]		= {  9,  1},
-	[VCAP_IS2_ACT_POLICE_IDX]		= { 10,  9},
-	[VCAP_IS2_ACT_POLICE_VCAP_ONLY]		= { 19,  1},
-	[VCAP_IS2_ACT_PORT_MASK]		= { 20, 11},
-	[VCAP_IS2_ACT_REW_OP]			= { 31,  9},
-	[VCAP_IS2_ACT_SMAC_REPLACE_ENA]		= { 40,  1},
-	[VCAP_IS2_ACT_RSV]			= { 41,  2},
-	[VCAP_IS2_ACT_ACL_ID]			= { 43,  6},
-	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32},
-};
-
 static struct vcap_props vsc7514_vcap_props[] = {
 	[VCAP_ES0] = {
 		.action_type_width = 0,
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
new file mode 100644
index 000000000000..c2af4eb8ca5d
--- /dev/null
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -0,0 +1,523 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Microsemi Ocelot Switch driver
+ *
+ * Copyright (c) 2017 Microsemi Corporation
+ * Copyright (c) 2021 Innovative Advantage
+ */
+#include <soc/mscc/ocelot_vcap.h>
+#include <soc/mscc/vsc7514_regs.h>
+#include "ocelot.h"
+
+const u32 vsc7514_ana_regmap[] = {
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
+EXPORT_SYMBOL(vsc7514_ana_regmap);
+
+const u32 vsc7514_qs_regmap[] = {
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
+EXPORT_SYMBOL(vsc7514_qs_regmap);
+
+const u32 vsc7514_qsys_regmap[] = {
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
+EXPORT_SYMBOL(vsc7514_qsys_regmap);
+
+const u32 vsc7514_rew_regmap[] = {
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
+EXPORT_SYMBOL(vsc7514_rew_regmap);
+
+const u32 vsc7514_sys_regmap[] = {
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
+EXPORT_SYMBOL(vsc7514_sys_regmap);
+
+const u32 vsc7514_vcap_regmap[] = {
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
+EXPORT_SYMBOL(vsc7514_vcap_regmap);
+
+const u32 vsc7514_ptp_regmap[] = {
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
+EXPORT_SYMBOL(vsc7514_ptp_regmap);
+
+const u32 vsc7514_dev_gmii_regmap[] = {
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
+EXPORT_SYMBOL(vsc7514_dev_gmii_regmap);
+
+const struct vcap_field vsc7514_vcap_es0_keys[] = {
+	[VCAP_ES0_EGR_PORT]			= { 0,   4 },
+	[VCAP_ES0_IGR_PORT]			= { 4,   4 },
+	[VCAP_ES0_RSV]				= { 8,   2 },
+	[VCAP_ES0_L2_MC]			= { 10,  1 },
+	[VCAP_ES0_L2_BC]			= { 11,  1 },
+	[VCAP_ES0_VID]				= { 12, 12 },
+	[VCAP_ES0_DP]				= { 24,  1 },
+	[VCAP_ES0_PCP]				= { 25,  3 },
+};
+EXPORT_SYMBOL(vsc7514_vcap_es0_keys);
+
+const struct vcap_field vsc7514_vcap_es0_actions[]   = {
+	[VCAP_ES0_ACT_PUSH_OUTER_TAG]		= { 0,   2 },
+	[VCAP_ES0_ACT_PUSH_INNER_TAG]		= { 2,   1 },
+	[VCAP_ES0_ACT_TAG_A_TPID_SEL]		= { 3,   2 },
+	[VCAP_ES0_ACT_TAG_A_VID_SEL]		= { 5,   1 },
+	[VCAP_ES0_ACT_TAG_A_PCP_SEL]		= { 6,   2 },
+	[VCAP_ES0_ACT_TAG_A_DEI_SEL]		= { 8,   2 },
+	[VCAP_ES0_ACT_TAG_B_TPID_SEL]		= { 10,  2 },
+	[VCAP_ES0_ACT_TAG_B_VID_SEL]		= { 12,  1 },
+	[VCAP_ES0_ACT_TAG_B_PCP_SEL]		= { 13,  2 },
+	[VCAP_ES0_ACT_TAG_B_DEI_SEL]		= { 15,  2 },
+	[VCAP_ES0_ACT_VID_A_VAL]		= { 17, 12 },
+	[VCAP_ES0_ACT_PCP_A_VAL]		= { 29,  3 },
+	[VCAP_ES0_ACT_DEI_A_VAL]		= { 32,  1 },
+	[VCAP_ES0_ACT_VID_B_VAL]		= { 33, 12 },
+	[VCAP_ES0_ACT_PCP_B_VAL]		= { 45,  3 },
+	[VCAP_ES0_ACT_DEI_B_VAL]		= { 48,  1 },
+	[VCAP_ES0_ACT_RSV]			= { 49, 24 },
+	[VCAP_ES0_ACT_HIT_STICKY]		= { 73,  1 },
+};
+EXPORT_SYMBOL(vsc7514_vcap_es0_actions);
+
+const struct vcap_field vsc7514_vcap_is1_keys[] = {
+	[VCAP_IS1_HK_TYPE]			= { 0,    1 },
+	[VCAP_IS1_HK_LOOKUP]			= { 1,    2 },
+	[VCAP_IS1_HK_IGR_PORT_MASK]		= { 3,   12 },
+	[VCAP_IS1_HK_RSV]			= { 15,   9 },
+	[VCAP_IS1_HK_OAM_Y1731]			= { 24,   1 },
+	[VCAP_IS1_HK_L2_MC]			= { 25,   1 },
+	[VCAP_IS1_HK_L2_BC]			= { 26,   1 },
+	[VCAP_IS1_HK_IP_MC]			= { 27,   1 },
+	[VCAP_IS1_HK_VLAN_TAGGED]		= { 28,   1 },
+	[VCAP_IS1_HK_VLAN_DBL_TAGGED]		= { 29,   1 },
+	[VCAP_IS1_HK_TPID]			= { 30,   1 },
+	[VCAP_IS1_HK_VID]			= { 31,  12 },
+	[VCAP_IS1_HK_DEI]			= { 43,   1 },
+	[VCAP_IS1_HK_PCP]			= { 44,   3 },
+	/* Specific Fields for IS1 Half Key S1_NORMAL */
+	[VCAP_IS1_HK_L2_SMAC]			= { 47,  48 },
+	[VCAP_IS1_HK_ETYPE_LEN]			= { 95,   1 },
+	[VCAP_IS1_HK_ETYPE]			= { 96,  16 },
+	[VCAP_IS1_HK_IP_SNAP]			= { 112,  1 },
+	[VCAP_IS1_HK_IP4]			= { 113,  1 },
+	/* Layer-3 Information */
+	[VCAP_IS1_HK_L3_FRAGMENT]		= { 114,  1 },
+	[VCAP_IS1_HK_L3_FRAG_OFS_GT0]		= { 115,  1 },
+	[VCAP_IS1_HK_L3_OPTIONS]		= { 116,  1 },
+	[VCAP_IS1_HK_L3_DSCP]			= { 117,  6 },
+	[VCAP_IS1_HK_L3_IP4_SIP]		= { 123, 32 },
+	/* Layer-4 Information */
+	[VCAP_IS1_HK_TCP_UDP]			= { 155,  1 },
+	[VCAP_IS1_HK_TCP]			= { 156,  1 },
+	[VCAP_IS1_HK_L4_SPORT]			= { 157, 16 },
+	[VCAP_IS1_HK_L4_RNG]			= { 173,  8 },
+	/* Specific Fields for IS1 Half Key S1_5TUPLE_IP4 */
+	[VCAP_IS1_HK_IP4_INNER_TPID]		= { 47,   1 },
+	[VCAP_IS1_HK_IP4_INNER_VID]		= { 48,  12 },
+	[VCAP_IS1_HK_IP4_INNER_DEI]		= { 60,   1 },
+	[VCAP_IS1_HK_IP4_INNER_PCP]		= { 61,   3 },
+	[VCAP_IS1_HK_IP4_IP4]			= { 64,   1 },
+	[VCAP_IS1_HK_IP4_L3_FRAGMENT]		= { 65,   1 },
+	[VCAP_IS1_HK_IP4_L3_FRAG_OFS_GT0]	= { 66,   1 },
+	[VCAP_IS1_HK_IP4_L3_OPTIONS]		= { 67,   1 },
+	[VCAP_IS1_HK_IP4_L3_DSCP]		= { 68,   6 },
+	[VCAP_IS1_HK_IP4_L3_IP4_DIP]		= { 74,  32 },
+	[VCAP_IS1_HK_IP4_L3_IP4_SIP]		= { 106, 32 },
+	[VCAP_IS1_HK_IP4_L3_PROTO]		= { 138,  8 },
+	[VCAP_IS1_HK_IP4_TCP_UDP]		= { 146,  1 },
+	[VCAP_IS1_HK_IP4_TCP]			= { 147,  1 },
+	[VCAP_IS1_HK_IP4_L4_RNG]		= { 148,  8 },
+	[VCAP_IS1_HK_IP4_IP_PAYLOAD_S1_5TUPLE]	= { 156, 32 },
+};
+EXPORT_SYMBOL(vsc7514_vcap_is1_keys);
+
+const struct vcap_field vsc7514_vcap_is1_actions[] = {
+	[VCAP_IS1_ACT_DSCP_ENA]			= { 0,   1 },
+	[VCAP_IS1_ACT_DSCP_VAL]			= { 1,   6 },
+	[VCAP_IS1_ACT_QOS_ENA]			= { 7,   1 },
+	[VCAP_IS1_ACT_QOS_VAL]			= { 8,   3 },
+	[VCAP_IS1_ACT_DP_ENA]			= { 11,  1 },
+	[VCAP_IS1_ACT_DP_VAL]			= { 12,  1 },
+	[VCAP_IS1_ACT_PAG_OVERRIDE_MASK]	= { 13,  8 },
+	[VCAP_IS1_ACT_PAG_VAL]			= { 21,  8 },
+	[VCAP_IS1_ACT_RSV]			= { 29,  9 },
+	/* The fields below are incorrectly shifted by 2 in the manual */
+	[VCAP_IS1_ACT_VID_REPLACE_ENA]		= { 38,  1 },
+	[VCAP_IS1_ACT_VID_ADD_VAL]		= { 39, 12 },
+	[VCAP_IS1_ACT_FID_SEL]			= { 51,  2 },
+	[VCAP_IS1_ACT_FID_VAL]			= { 53, 13 },
+	[VCAP_IS1_ACT_PCP_DEI_ENA]		= { 66,  1 },
+	[VCAP_IS1_ACT_PCP_VAL]			= { 67,  3 },
+	[VCAP_IS1_ACT_DEI_VAL]			= { 70,  1 },
+	[VCAP_IS1_ACT_VLAN_POP_CNT_ENA]		= { 71,  1 },
+	[VCAP_IS1_ACT_VLAN_POP_CNT]		= { 72,  2 },
+	[VCAP_IS1_ACT_CUSTOM_ACE_TYPE_ENA]	= { 74,  4 },
+	[VCAP_IS1_ACT_HIT_STICKY]		= { 78,  1 },
+};
+EXPORT_SYMBOL(vsc7514_vcap_is1_actions);
+
+const struct vcap_field vsc7514_vcap_is2_keys[] = {
+	/* Common: 46 bits */
+	[VCAP_IS2_TYPE]				= { 0,    4 },
+	[VCAP_IS2_HK_FIRST]			= { 4,    1 },
+	[VCAP_IS2_HK_PAG]			= { 5,    8 },
+	[VCAP_IS2_HK_IGR_PORT_MASK]		= { 13,  12 },
+	[VCAP_IS2_HK_RSV2]			= { 25,   1 },
+	[VCAP_IS2_HK_HOST_MATCH]		= { 26,   1 },
+	[VCAP_IS2_HK_L2_MC]			= { 27,   1 },
+	[VCAP_IS2_HK_L2_BC]			= { 28,   1 },
+	[VCAP_IS2_HK_VLAN_TAGGED]		= { 29,   1 },
+	[VCAP_IS2_HK_VID]			= { 30,  12 },
+	[VCAP_IS2_HK_DEI]			= { 42,   1 },
+	[VCAP_IS2_HK_PCP]			= { 43,   3 },
+	/* MAC_ETYPE / MAC_LLC / MAC_SNAP / OAM common */
+	[VCAP_IS2_HK_L2_DMAC]			= { 46,  48 },
+	[VCAP_IS2_HK_L2_SMAC]			= { 94,  48 },
+	/* MAC_ETYPE (TYPE=000) */
+	[VCAP_IS2_HK_MAC_ETYPE_ETYPE]		= { 142, 16 },
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0]	= { 158, 16 },
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD1]	= { 174,  8 },
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD2]	= { 182,  3 },
+	/* MAC_LLC (TYPE=001) */
+	[VCAP_IS2_HK_MAC_LLC_L2_LLC]		= { 142, 40 },
+	/* MAC_SNAP (TYPE=010) */
+	[VCAP_IS2_HK_MAC_SNAP_L2_SNAP]		= { 142, 40 },
+	/* MAC_ARP (TYPE=011) */
+	[VCAP_IS2_HK_MAC_ARP_SMAC]		= { 46,  48 },
+	[VCAP_IS2_HK_MAC_ARP_ADDR_SPACE_OK]	= { 94,   1 },
+	[VCAP_IS2_HK_MAC_ARP_PROTO_SPACE_OK]	= { 95,   1 },
+	[VCAP_IS2_HK_MAC_ARP_LEN_OK]		= { 96,   1 },
+	[VCAP_IS2_HK_MAC_ARP_TARGET_MATCH]	= { 97,   1 },
+	[VCAP_IS2_HK_MAC_ARP_SENDER_MATCH]	= { 98,   1 },
+	[VCAP_IS2_HK_MAC_ARP_OPCODE_UNKNOWN]	= { 99,   1 },
+	[VCAP_IS2_HK_MAC_ARP_OPCODE]		= { 100,  2 },
+	[VCAP_IS2_HK_MAC_ARP_L3_IP4_DIP]	= { 102, 32 },
+	[VCAP_IS2_HK_MAC_ARP_L3_IP4_SIP]	= { 134, 32 },
+	[VCAP_IS2_HK_MAC_ARP_DIP_EQ_SIP]	= { 166,  1 },
+	/* IP4_TCP_UDP / IP4_OTHER common */
+	[VCAP_IS2_HK_IP4]			= { 46,   1 },
+	[VCAP_IS2_HK_L3_FRAGMENT]		= { 47,   1 },
+	[VCAP_IS2_HK_L3_FRAG_OFS_GT0]		= { 48,   1 },
+	[VCAP_IS2_HK_L3_OPTIONS]		= { 49,   1 },
+	[VCAP_IS2_HK_IP4_L3_TTL_GT0]		= { 50,   1 },
+	[VCAP_IS2_HK_L3_TOS]			= { 51,   8 },
+	[VCAP_IS2_HK_L3_IP4_DIP]		= { 59,  32 },
+	[VCAP_IS2_HK_L3_IP4_SIP]		= { 91,  32 },
+	[VCAP_IS2_HK_DIP_EQ_SIP]		= { 123,  1 },
+	/* IP4_TCP_UDP (TYPE=100) */
+	[VCAP_IS2_HK_TCP]			= { 124,  1 },
+	[VCAP_IS2_HK_L4_DPORT]			= { 125, 16 },
+	[VCAP_IS2_HK_L4_SPORT]			= { 141, 16 },
+	[VCAP_IS2_HK_L4_RNG]			= { 157,  8 },
+	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]		= { 165,  1 },
+	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]		= { 166,  1 },
+	[VCAP_IS2_HK_L4_FIN]			= { 167,  1 },
+	[VCAP_IS2_HK_L4_SYN]			= { 168,  1 },
+	[VCAP_IS2_HK_L4_RST]			= { 169,  1 },
+	[VCAP_IS2_HK_L4_PSH]			= { 170,  1 },
+	[VCAP_IS2_HK_L4_ACK]			= { 171,  1 },
+	[VCAP_IS2_HK_L4_URG]			= { 172,  1 },
+	[VCAP_IS2_HK_L4_1588_DOM]		= { 173,  8 },
+	[VCAP_IS2_HK_L4_1588_VER]		= { 181,  4 },
+	/* IP4_OTHER (TYPE=101) */
+	[VCAP_IS2_HK_IP4_L3_PROTO]		= { 124,  8 },
+	[VCAP_IS2_HK_L3_PAYLOAD]		= { 132, 56 },
+	/* IP6_STD (TYPE=110) */
+	[VCAP_IS2_HK_IP6_L3_TTL_GT0]		= { 46,   1 },
+	[VCAP_IS2_HK_L3_IP6_SIP]		= { 47, 128 },
+	[VCAP_IS2_HK_IP6_L3_PROTO]		= { 175,  8 },
+	/* OAM (TYPE=111) */
+	[VCAP_IS2_HK_OAM_MEL_FLAGS]		= { 142,  7 },
+	[VCAP_IS2_HK_OAM_VER]			= { 149,  5 },
+	[VCAP_IS2_HK_OAM_OPCODE]		= { 154,  8 },
+	[VCAP_IS2_HK_OAM_FLAGS]			= { 162,  8 },
+	[VCAP_IS2_HK_OAM_MEPID]			= { 170, 16 },
+	[VCAP_IS2_HK_OAM_CCM_CNTS_EQ0]		= { 186,  1 },
+	[VCAP_IS2_HK_OAM_IS_Y1731]		= { 187,  1 },
+};
+EXPORT_SYMBOL(vsc7514_vcap_is2_keys);
+
+const struct vcap_field vsc7514_vcap_is2_actions[] = {
+	[VCAP_IS2_ACT_HIT_ME_ONCE]		= { 0,   1 },
+	[VCAP_IS2_ACT_CPU_COPY_ENA]		= { 1,   1 },
+	[VCAP_IS2_ACT_CPU_QU_NUM]		= { 2,   3 },
+	[VCAP_IS2_ACT_MASK_MODE]		= { 5,   2 },
+	[VCAP_IS2_ACT_MIRROR_ENA]		= { 7,   1 },
+	[VCAP_IS2_ACT_LRN_DIS]			= { 8,   1 },
+	[VCAP_IS2_ACT_POLICE_ENA]		= { 9,   1 },
+	[VCAP_IS2_ACT_POLICE_IDX]		= { 10,  9 },
+	[VCAP_IS2_ACT_POLICE_VCAP_ONLY]		= { 19,  1 },
+	[VCAP_IS2_ACT_PORT_MASK]		= { 20, 11 },
+	[VCAP_IS2_ACT_REW_OP]			= { 31,  9 },
+	[VCAP_IS2_ACT_SMAC_REPLACE_ENA]		= { 40,  1 },
+	[VCAP_IS2_ACT_RSV]			= { 41,  2 },
+	[VCAP_IS2_ACT_ACL_ID]			= { 43,  6 },
+	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32 },
+};
+EXPORT_SYMBOL(vsc7514_vcap_is2_actions);
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
new file mode 100644
index 000000000000..98743e252012
--- /dev/null
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Microsemi Ocelot Switch driver
+ *
+ * Copyright (c) 2021 Innovative Advantage Inc.
+ */
+
+#ifndef VSC7514_REGS_H
+#define VSC7514_REGS_H
+
+extern const u32 vsc7514_ana_regmap[];
+extern const u32 vsc7514_qs_regmap[];
+extern const u32 vsc7514_qsys_regmap[];
+extern const u32 vsc7514_rew_regmap[];
+extern const u32 vsc7514_sys_regmap[];
+extern const u32 vsc7514_vcap_regmap[];
+extern const u32 vsc7514_ptp_regmap[];
+extern const u32 vsc7514_dev_gmii_regmap[];
+
+extern const struct vcap_field vsc7514_vcap_es0_keys[];
+extern const struct vcap_field vsc7514_vcap_es0_actions[];
+extern const struct vcap_field vsc7514_vcap_is1_keys[];
+extern const struct vcap_field vsc7514_vcap_is1_actions[];
+extern const struct vcap_field vsc7514_vcap_is2_keys[];
+extern const struct vcap_field vsc7514_vcap_is2_actions[];
+
+#endif
-- 
2.25.1

