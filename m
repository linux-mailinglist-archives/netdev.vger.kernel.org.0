Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0123303C5B
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405166AbhAZMAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:00:55 -0500
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:25954
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405217AbhAZMAX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 07:00:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSJ+tG4r2De0tkOe5McD3zBbKZtDOXgA1UPkdghSDgKamw9s9gZiKNH+aItCvOMUutvSMhpNd7aI+o20bE9R+DpKZDp0NUBsDcIVTFHQoPLmoF/HTW6BOrysvgCn87oYjJQs8IWGaG1dmQ0t/OGE3wee8boO5Cz4l1TFH0RjAP/OPY8fzlF4SW4l4Pv7P9iABRy0WinLdRrvUuEmyas+ypwBf79SiWBn96C+HnPH5OhSTcggPiUASYnfFeAUc6+AdXBhwIlrZWotkSSH5X7tTXKor4ESe2q/S6ybW9Hyz1Cp0t8Pk7uLwh0o9di5groZE6M0Q5f3zrAOC/MxIOHLTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/ntE69R8DkRJ96OJPK6xrmqf2d5rNQdXSP1dDYKNwo=;
 b=fCL91J7cqUJk3HPepm9+RH2GaP4guePi85NKNzakuYuLOOhuaNvCSV+fUHLWNJFeSkuteXnMW57Uq6fPwbz67RA+RV0NpxYuE/XE5sVs82rjeXyt62Pbh38W39xH1ixcfMmU2QwM8JvKVEBucNo4YqUHdhC0j/Xh5wcMG/L1w4QI1iSxer1aI0iZ2zbAVgojR4tOdzDEJs4Vtah+zgJLTKawdcsrM0WgXeYOz18lxp3zv2jL8teJHYpv8MrjYcxDy6qZ+kHBPljtutzLRNLR5OkV21NL46nBua9g+sGRnaxK6B5nIi2k7H4P6MkIRSOoaqCYDqD1yNhqp4GERGxU8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/ntE69R8DkRJ96OJPK6xrmqf2d5rNQdXSP1dDYKNwo=;
 b=p3QkXRQVj3TMXOfN+91+muEWC50nkbul/Xtkd7LVm70M8GUnIGvdWCNPQcKjk1IGMgfu+7/sEEqM9L/RpNty2g5X5G1BVX9tIdZr0YHt3yrBU6V3FyFG97FtQwK09apcV3x5gFCZkgkKzy8YqTLMjAC8ZJu3V0RRiwdx4nwW7FA=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2903.eurprd04.prod.outlook.com (2603:10a6:4:9b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Tue, 26 Jan
 2021 11:59:34 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 11:59:34 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V3 0/6] ethernet: fixes for stmmac driver
Date:   Tue, 26 Jan 2021 19:58:48 +0800
Message-Id: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 26 Jan 2021 11:59:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 140c2c74-8cad-4556-5072-08d8c1f1d876
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2903:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB29032260F86BB03F13246254E6BC0@DB6PR0402MB2903.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +lTl9ZjMavo9fpcHHFPSApTGAg+u9xkS/uGMOT49DOnqEg85JzSEYLWKimFsQxNSITrwdXzzgCZvs9YSVwEbeJqMr3HjDXdVRUt+1ih1R+EDj1PRcUau/65bH4kEDhPafToyJoo+97DA5SOP4PLranx3zszvqyz5/ryZPgiCcqrIF5ftZEAoh4Wl2zd+HIx6xu2Xf/HxDqZXNDaJBye2rYLv5vEyMZXHX/UZa4DijU16zDh6bvMWLqtxzUGFJLNGB2cm/PhWIoeEtynNpcCM+zgEBssM4ntYJFad29ghPqharsGLWQXA7k5wBpPEcy0VENZm+8EjJDdOluk0NUJg9bRW1W+XIxbBMNNnFcK+W6KHLqMC8ixx6xmoXxFMFje6kYpK2iYyw+xvlXi6Tyj/aHDQYoobJau45UOGlOmEPEol7dGCkL99otiGa01uqTYr+jA5dRRK5Pv1sxntaImGl/onmciPgESr7XhtB9fhAJrQeWyOItHcdNKlTfaFBkAyqNeK2RZQTMaSr8C2Z1GqlpqJ6fPcQYpWevHKn1rYzM0PkLCpBbv3d9fQBn9z5SN4oqRGrj5mzdjHsNXZRTnlYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(376002)(136003)(346002)(36756003)(478600001)(66476007)(6486002)(8936002)(2906002)(4326008)(1076003)(66556008)(6512007)(6666004)(52116002)(86362001)(316002)(5660300002)(6506007)(956004)(83380400001)(26005)(69590400011)(66946007)(186003)(2616005)(16526019)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?d0M8eG35xxDXBH3p35yydNRlfTB1FXXEaYZQMoMr9ChHMsrMuubH3uT5eRKl?=
 =?us-ascii?Q?cMCh+3nDwHWxA+PlUcU9MqwVFea72rGBmTzhVSFgl7wSzVpfvYjvGgk4ZwsR?=
 =?us-ascii?Q?9B01sFTuByZV/ufq8CHecBqYrKpAhbJ+ZMCfNXdpYr08aXksqDNsV/d4R3yu?=
 =?us-ascii?Q?d2zhRaR6YZalK+CB6VRPhfJK+eHKBOVp4E5dtSY/BhUJFHwdQI7+CiWXr3Yb?=
 =?us-ascii?Q?VY4tnwW1LP8SlOV5e0iqTOunnXVEY6+QBtlyymwZz2VbETn8Mz83awI3bsI2?=
 =?us-ascii?Q?qP06BIdsy/bS0VMXEE/2N3Dq+z7SwRIuv9csEqiG9IT8ceh0mKfOFjzL6ioU?=
 =?us-ascii?Q?2sWgvZ6nkCtlsgpVDPJGKiztpg/Byd4iNIbCyc+dtiJA38mFYH7xtpXJNGSd?=
 =?us-ascii?Q?GMueIVCSMsh0eQ7eZkJrxNGZirTRTLPITer6I7SKK5etq2V01GrmL+nypZkT?=
 =?us-ascii?Q?lG+e7qOsrtyRfmVYQoWMX9lMpTpcqHdh2bXOBRGz+ELEY/lIjsl8dCAtBgUE?=
 =?us-ascii?Q?xCyiRmZLiBRGRZNkuKDFxaGBCq4j4dhqk0Blq/KDSx9YN2rhwwypaexQNrVv?=
 =?us-ascii?Q?EmzEmqBcG3G7FN8jso6Qzs0lyvqkQBfk3lQCjGgPRb+yFdyir9src0KgK7zK?=
 =?us-ascii?Q?0mBrGsoEkVO2NwWf4NsKmlVSh+0WP5pd7aLy1BfjB3DvlUpek+1YBUZQzHV5?=
 =?us-ascii?Q?VcT1ZpLLwWB8LLGgVDPRA2gizVzjTlZpfccowwq/6FzXLXiAMjeW6zC3MoOz?=
 =?us-ascii?Q?wcd10SvSSOZX0UD0grzBLkr52lGPptR0CuV8wdNUNxwjiapR2n8Hxez2eZyA?=
 =?us-ascii?Q?LQ2OP5h+kvOZpud30g/G0uOV5O9I7i2jcHO7Qmayvl3iykua7IiBlmoi1qC4?=
 =?us-ascii?Q?uSHy8rUzToaQdUxIFhbxF1FkNUNEim1Lykmnb4eJBLG8bkolTr/oi2TfsjTs?=
 =?us-ascii?Q?12pgXmivjzMFgDlemB3ZdWm0WIIuoS3ho+EDotl7HvBplFNZ1Ffx6SRK+mzS?=
 =?us-ascii?Q?iSkXgTGz4syttFkRDfmwGsEVue7auPurVsZvt2zqZH7vhV6KdkISgcEb2EWJ?=
 =?us-ascii?Q?GEYs9cbX?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 140c2c74-8cad-4556-5072-08d8c1f1d876
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 11:59:33.9988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 93Qmq3izcJDmCIlQaMjNmyXgh0uz2g5kG9NkoHy3KaWZnYxrf945bkybx2YJraNjbg8jUQzVN1xwVBU8k+87RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2903
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
V2-V3:
	* fix the build issue pointed out by kbuild bot.
	* add error handling for stmmac_reinit_rx_buffers() function.

Joakim Zhang (6):
  net: stmmac: remove redundant null check for ptp clock
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
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 154 +++++++++++++++---
 7 files changed, 153 insertions(+), 42 deletions(-)

-- 
2.17.1

