Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8846B30F1F6
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbhBDLWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:22:34 -0500
Received: from mail-eopbgr30054.outbound.protection.outlook.com ([40.107.3.54]:21206
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235608AbhBDLWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 06:22:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cM1cfFb4xSQztbLITf9cAOjClUeC0H9Ux6XdqeTkhy5mTebSL5TOKyj3cjmJ/Qn/C00Ufti5ucSzrWaLZ6wBNAoT9wdRgAiVtZSBKjNSmwQDlWLs0kgHs44Esl78UPOm6FeQ2yKCcmlhPUXy/DqlaHGN+ECemCDFv/6UB/h1KF5ciF158z81mpeJCujafWDL3wVZc0iBzJfge7OQO4/2+NBf7zcu/yvD+8TtVMVfyqwSqZ+/1IE6BIrF0uMBm/Mjm16tv4FLT4aCUcDCHlAVTeR+nDPDAn4tPFViQTTiFAx0eL8OIvTl5eRpRdv22P/mM2SZbxeJRiB4ZAIR5uIAqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wT5Lm/RQxC61tr2TZavpnWTpbiu0tu9yCVUnBFEE8DM=;
 b=iQs3fJAiHCKt33ArDDknJBRCanQ/m1OUvqO0ygeFu9NeALGi05K6XEJw0yTDtRqJfHpcY0W397w3vkwclJi89xozniYeG4CothxO72Nxk+7Bb0uHuO6w2c619PMgSbMQozSS3Ra1sMNi61QBYmXc0fR7RUg47GJP5sVrLvIrvwB5zR/lQp9/i3WLI7FLY4+hmUuF50tzVjTurqoyUOfy5dIgKf+xSLBhs6BVPTYhT5UPlznRzz1WWHqESpm+B2bhcVMqU+koVnMPQOeIYCftFPMJPCnZBQMKKqwtppNOIDbWJa9aKmYqvfz8R5JzWg2woJ4Qr+qqu/W9IzCHwwq8cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wT5Lm/RQxC61tr2TZavpnWTpbiu0tu9yCVUnBFEE8DM=;
 b=BVvMVxp8jB6UvG+uef5gNzlgsz5K53yZ0Yk6UC/QaNegFTdepggeJoQ0pxmSHvbgs0+WtqOfkTED7FTUROBjAABcQAYfne877xJhy2GaU883Lki5Cm28e9EloOguCbdN9cAkZHMZ7pkGQnokvpd0PAn9tLGwA2tOVZdwbrY7Chk=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VE1PR04MB6366.eurprd04.prod.outlook.com (2603:10a6:803:12a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Thu, 4 Feb
 2021 11:21:39 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14%9]) with mapi id 15.20.3825.019; Thu, 4 Feb 2021
 11:21:39 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V4 net 0/5] ethernet: fixes for stmmac driver
Date:   Thu,  4 Feb 2021 19:21:39 +0800
Message-Id: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0128.apcprd03.prod.outlook.com
 (2603:1096:4:91::32) To VI1PR04MB6800.eurprd04.prod.outlook.com
 (2603:10a6:803:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0128.apcprd03.prod.outlook.com (2603:1096:4:91::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Thu, 4 Feb 2021 11:21:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c38b0d2e-420f-4afa-1e23-08d8c8ff0a96
X-MS-TrafficTypeDiagnostic: VE1PR04MB6366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB63662478F4C0AE8AA612F7D1E6B39@VE1PR04MB6366.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pyJENxJT5nMmthtVoQLy/hzKPgqrv9k4J4WrFPH8lUcGN+VEMuM3us5gOo4S6ouwZG5qFEfLGjQE76Q/oZXzp7ejrSXBR62KUHEJsn0ahpCqxbbDMyjtm0/XXN0HVb1E/BBsENCrCaywAAP/SUpGUiwRFkoPmK5xUFQKX6oLpMDIHu9MN2uoJTxk2qlGcHjCGFtq+jY8dyzChdAKJZ5SXZSVR++gzD5zFW1AyZZZWYOmPvGZO7icDMRhlFhDrfO21o3mdb12cx5+bVqqfKifhzc+wZXBDOjVUHFdYTmajDwJL0JYUNuPH0T2GN/tG90JR8uZqG54CtIkPGMWJvFnMHVMa0KYSn16mtfNR0wsk4U8AQ+1tSeSqgkMdYtMPcms61fLLXOnlvSJGQ9K5nXRFqvLfRnJlKK91LkkfFXD9WhLh1B+7AmK2sL7iPpJu13kDnLwQAZuqwMN3IjaA1dfgLbpO9uMmAXmpu33pdPUnXwh75s6lQjCJbbP2gUz40IWN2kQMUnn8cgbtO4eGNLPGErTJao+T47635098lByG9zwj9AudBvgSo2feTysf5hx3q2uT5QniYyC4QyytYaqIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(316002)(83380400001)(66476007)(478600001)(4326008)(66556008)(66946007)(2906002)(26005)(36756003)(956004)(5660300002)(8676002)(1076003)(6486002)(86362001)(8936002)(69590400011)(186003)(16526019)(52116002)(2616005)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bgz3ULELrcaTnfoTEc7Oc+aWpTwT5zK1SBz5EnEtGSWO9IloSMtAI6ffoeo4?=
 =?us-ascii?Q?GEBblGFYuJQDReasWubPKP59TtjKhv9oYQwPTLw4H1w3VD6AXDtPZy4pvve8?=
 =?us-ascii?Q?ZuVIz8wb8O4zz+63v5HdvFwo7Z+qFUthqqNfkaf1hgLN4BKdptsEZVZi7ffY?=
 =?us-ascii?Q?GBD2aNXeoK3PInQ1DM8GoB4nWyX2Axr2Rr8KRNosb3qJFe/+/uj2xj3UTuvE?=
 =?us-ascii?Q?KXkEg/Es/hYa7Vf7bOOA40Rl5MML3PUqNagOyJ27KGuoBTewQP3bEYcLPmlB?=
 =?us-ascii?Q?iRnKZTYPXWqmNg6+TNP6XiabuIM3unddamZncKtxkp9eyN2JNP51k3Hazg2q?=
 =?us-ascii?Q?sPxbvUugrSeiZUefoBXIpR/bfhVuaVupgNIfR66yb1Z4aPmKmAH7UBQ+Gsh4?=
 =?us-ascii?Q?CgMlUvbBZIXY4xi6sctKH1bQrcwTmKckPwF4941osTaA7Tw3PZV2NTXCP1In?=
 =?us-ascii?Q?53DHVjISTQmnaQqDd0wyommzeC35gWZ567R81ef7uxbdkLlYMwIkl/VxS66A?=
 =?us-ascii?Q?nlW2CLLkwfpZdaSfvLqcQGxPDtcj3Nz1bG/ZXb3N1E4BOyVDyRNF7HGYiuxV?=
 =?us-ascii?Q?vuJF/g1gi/cHRxExDzvc958cvzvRkD/2GqV9CI27QbvSPh9LimrT61+C+aEs?=
 =?us-ascii?Q?Edg7gHX3i65taO/3zz2Mhg7JGS365IAgZQs++jsbKgJWxdLzGBEOhGOn0K4f?=
 =?us-ascii?Q?tPQVzkQs8S8jwtYfvHAWyOeCEsTkesrgV38CTzWHCMJgrKaE8bpR7g3B738M?=
 =?us-ascii?Q?NC7jBMwdDCWcsbMcBSxi4Uyj3bOg19pfNuI2a4wJ2g6j1WHF4V0AsRpMaXyV?=
 =?us-ascii?Q?lVHHlsqQdV1Qk+XlzcPRERjnLM58DrfAJivxsmwm14GsC4QrvsPOceVxUc1Z?=
 =?us-ascii?Q?AH49srhmnIrCr280inivsVckslOF3kswfnkujNPn1ohtUHUCAtLVVfPSvxBL?=
 =?us-ascii?Q?GLJhllCwDeDvbaprzlTmIakk+ZmlnD1e2paPew8NHlakBbsNiB33JyqGobxm?=
 =?us-ascii?Q?jOS5LzZfGoJ0FOa4k2IzuFdCwZSZ4D2zrA7Xld3sF2rsDB1HIyvhkhHA5P9H?=
 =?us-ascii?Q?08GPHXKq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38b0d2e-420f-4afa-1e23-08d8c8ff0a96
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:21:39.6624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /WkkvKOZe9zg8AtXzP7ofHcTm+eppH1gI6++kRtMyLL4vdXp82Z858PSWMJhrLhVvsUm98BDYpsw3QQKXKFinQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes for stmmac driver.

---
ChangeLogs:
V1->V2:
	* subject prefix: ethernet: stmmac: -> net: stmmac:
	* use dma_addr_t instead of unsigned int for physical address
	* use cpu_to_le32()
V2->V3:
	* fix the build issue pointed out by kbuild bot.
	* add error handling for stmmac_reinit_rx_buffers() function.
V3->V4:
	* remove patch (net: stmmac: remove redundant null check for ptp clock),
	  reviewer thinks it should target net-next.

Joakim Zhang (5):
  net: stmmac: stop each tx channel independently
  net: stmmac: fix watchdog timeout during suspend/resume stress test
  net: stmmac: fix dma physical address of descriptor when display ring
  net: stmmac: fix wrongly set buffer2 valid when sph unsupport
  net: stmmac: re-init rx buffers when mac resume back

 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  16 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |   4 -
 .../ethernet/stmicro/stmmac/dwxgmac2_descs.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |   7 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   5 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |   7 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 151 +++++++++++++++---
 7 files changed, 152 insertions(+), 40 deletions(-)

-- 
2.17.1

