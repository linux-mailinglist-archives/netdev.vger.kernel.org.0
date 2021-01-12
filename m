Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6D02F2DFB
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 12:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbhALLfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 06:35:02 -0500
Received: from mail-eopbgr20080.outbound.protection.outlook.com ([40.107.2.80]:62622
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728953AbhALLfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 06:35:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biEtEoMnCeJt15dpMsn06ZQzto4LLJjjDc/ha1Xd0eWt/eYEJLBEFOIxNNi3MyjpdCtjv2Ycn9sNA9nIccMgVQ/bYqLrHE9GChxeZTBQ26glqr2cHGgLTWoCnP8SW9Tr6nXtXyjHX8Z4mxMXK2QZKDiljXn9NbtK7U+Mve7tTZXL8Mt1ARvc1x7ie/P7BuPyXHQOkTYhocgVr6G3tvoImACV/Wcy1TsFWbRQ3Jxg9cEdscLE7CC6GUTlf55HKi4tAhMTLNyPF7AOKB1yHkC1ou7zdazAb3XmKLoC1LvqV91wQvhhd1yi/BILxFCEW0dEcdwiw7jMCYiJuekXlw1+pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/T9EVF60pAmw+eDVI3K6EZYkusjjau1cHTlmN4InE1g=;
 b=i/fm0sd+rXDQQ5kIfR5uE0hooJVr0soYUIzrUTyzKe2hw/jSsLJV74lPWFlk3z+MUsYPiqgzyDAC/328NlQrP7VvoakxwB94t/HMF/5aBF2Ey6aGRSYQWcwKqS1PbxXdAKTazFD5EAqMZuNEelQroGobZk4uBcGD0YR2ZwviRYHljoiGapywZkFVw6fUB2xp6x17m8nZx1m3zL79tSpDZEXkt99MU0Dv44JBNQg0WhKFIHsu8yZIsYmMT88IuHTxiMUl9GZbNYEtpfhTsZVIEaitXs27KUbaNdW8q9EitkPVR37K0FceZ9w5Q2P5kwK1oLY4GYiwehamlotfLM5SRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/T9EVF60pAmw+eDVI3K6EZYkusjjau1cHTlmN4InE1g=;
 b=sAJ5nGmh/NptovjEGpMkKIHzFJqRIW7j+NJqA2SM8GCt2yGgRGqZz+Jlv48fPTfED61o4K1TTfd1Y2dgd0mL5bLu7NEShLMNeEDBUepFlPjWkM+EhBz089ZagtScxPAeAx/n4hWdzYwGmxFDqZ3mp7reU2UuH27UnFHbn+/emug=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6139.eurprd04.prod.outlook.com (2603:10a6:10:ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Tue, 12 Jan
 2021 11:34:11 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 11:34:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V2 net 0/6] ethernet: fixes for stmmac driver
Date:   Tue, 12 Jan 2021 19:33:39 +0800
Message-Id: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 11:34:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6179483a-1b74-4148-45b8-08d8b6edfb47
X-MS-TrafficTypeDiagnostic: DBBPR04MB6139:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB6139482BD13C965CFA5EFED2E6AA0@DBBPR04MB6139.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ea3RWrhJkP3K4Y6fih7qRtgjOWunmaJF/iR3FVk7DpN7v/92ST/ZFYTlTQcsr41caQyC2AIF8H9rXcygfIThJeTL7Fbu7uAWUk7S/QlL6FnpsJu+ezQnGnGBYltNdWt0IYNV7H2sAtHkuDLfOGJKgRyLPF4CBbWoje6dGOXQQdfo0QcPSqtahjcvf3L/JSbIjfDrsNvBwRnCQLsZG4Ct2yGlju1QD+LMTNhO+CvfIB//+pGrKmKC0ad2zHtTuy8aaLB8LTB0ZouQdHF+YUUBu3AQ+bqnepN/UMZAzGEx09F/MDpDjLGkdaOzjwEWEkwvyLvMTyWYEOx42eflMOKJB53SITAg6RK+Fw90wp+BQpEpo64NkV1hHaiSaW/EBFaiPrjMTS42rJ4jRfOAzJt5+Xpxo+BO/qJ3KVdhvW+3MqXmeua3Ws5Jh4l83hQr4LkAyYLSow6FPsps5PKTZR/8Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(69590400011)(66946007)(8936002)(26005)(8676002)(6666004)(66556008)(66476007)(1076003)(186003)(2616005)(6506007)(498600001)(83380400001)(6512007)(16526019)(956004)(2906002)(86362001)(4744005)(36756003)(6486002)(4326008)(5660300002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qRFrhtCLdi8JG1Ydldb6wEJkI4sahI2nghTMPCOfNmA9gYElvEJFRalKa0PX?=
 =?us-ascii?Q?Ne0gmdwT3CtVRy07uBcZ14/omQ3dTboxcGp8t1YxvsSVrU8jFVkOa3Tc1q4B?=
 =?us-ascii?Q?XLtATngfAb2hxr6LCPegT2mH6s1DI18rS5tCajdxjjyPEKmaNs77EJZgB0WJ?=
 =?us-ascii?Q?evzJYqZ8c7VabhaidIc/J6Kr5YFqKbwIqq8JKNvQ6sVYDujhSNWv5dvvYfuB?=
 =?us-ascii?Q?RO2IVinDsCfQCf56r7prdleNqFkmj27ID91R3jElmceKGdsSIDdpj24ykuuQ?=
 =?us-ascii?Q?Xc3MLLQg51kqEK4JRkIrV27XQAW+LSYFZO2lBuWUAz0NqFQ85YaCP21PVmLo?=
 =?us-ascii?Q?7RigKQlMjTOKFkx2xMrXTa11605T4uBCfwW5J9tXi6CcyJinQVXIxY6zf1DX?=
 =?us-ascii?Q?E2cs9Wnmn6sU6q5ta7Dmrl5Z+crIXuxtZXJDTi5QlN7+FjpBWmBIxNKtUgDx?=
 =?us-ascii?Q?CSesbBg6Snkkwq2M9yRDmp95dT6kcrRwPCIOSIOw2jE2h+lcxoc/BdbU+4x9?=
 =?us-ascii?Q?ZQxH+NIba8h/HcAh97OE4N2pvt1/W8IQR09+Rc5tGh5j6jZVgtiEu24KgrZl?=
 =?us-ascii?Q?QQK1JofDhP0srkSMFaVzTCIu0Avq/2iVSV86gx2VzMS+5Z7RpiymnRsibLIm?=
 =?us-ascii?Q?/GPEVTps7n/gY2bUZDZ/7G7Q5bhfasmOH6PvGi66QWmJdpsfixqSTp+qYNy0?=
 =?us-ascii?Q?AZcBWnWD8IHdezNBlhZweTcTEFmqrzBcu4cgkieZN6MRoiRkBnXDMIbS7ak9?=
 =?us-ascii?Q?Mz/SBMbyHQLD/H2FvIQQ2n3vAd8aHo0m7uCG30PqKhuIXJlQYfxPe0AZrPUd?=
 =?us-ascii?Q?+Py+/A0XSwY6Ifu9il5q/+LElIno10i3hQ8XDvdObXz1HW23iRedwdJ+FsAx?=
 =?us-ascii?Q?b6JBJkTywp6OzPWyH1w5wRtPKIgcnouf4qehflEY8xtlIbJ2lHwnm6ssgMAF?=
 =?us-ascii?Q?9uLyyOLA5AjC7p4gzKJKhQpniazrGCCeFrgZf9X3J02JZfnpLt60bsreXQb7?=
 =?us-ascii?Q?jGbX?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 11:34:11.0986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 6179483a-1b74-4148-45b8-08d8b6edfb47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N6s9KyAgJLNy12RautipONZe8uZ2gPQE1XJGx9ArQZLJ2cJrHZLopeTEW4SrtQv2GDpmbGweHmh0yHOwDeAscA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6139
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
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 140 +++++++++++++++---
 7 files changed, 139 insertions(+), 42 deletions(-)

-- 
2.17.1

