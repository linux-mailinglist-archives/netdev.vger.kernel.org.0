Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DD54804F3
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 22:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhL0Vxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 16:53:38 -0500
Received: from mail-eopbgr80124.outbound.protection.outlook.com ([40.107.8.124]:45430
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229728AbhL0Vxh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 16:53:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/oRCfQOb8tGNkFjxo5mNahsBaAmToTkwgrTv+1qANicP5UgoW+9IMVB1vAlYKvJE16tw/19JezbxSbwBIt2jLHz8k73WrVrj3ifU65D5V3tjc4RA9MMo+JKSqVOdYeB5G9+wwPfaoTOisyDqkrAjv4pdH/m4Ho0W9vXz8Lj7Z5wb7bxwPh17TVTqbzPfSI2btxIM/lcVucB9NaXJz3MjB4FNhPEBvysQE9/kyBKMQOf62R9FCFyRYF4gvMBOO3XGEa/GJrWd8kcytwwPgSGWPD9IXEsFYRf39mt+X4i5SVfnkMeMPoD1Ahe0cGm2l6qJqx6lueAMfoMDZdXcuObgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOu7w4KMNi0U+FWoY36QVH9Jvq1QrgAeqBGrZ2o94Kk=;
 b=Ookd0jOdcKnXZJMgQu66C/m1oHBlEBoQt15XlEnd6XPKZqB/aq5E4KT9NNPZ/OVvg5mDn8lgrsFAH/01ym/8qYnKgfrxswgQ0TyAqu2vG+DCUb8ydqZiLr4v8/hsYrbN5CtPDlk/XDxcG1E7CPcTmGYdJeme1A4JYbTvtbMh8U7lFF+g6gzXcXyAZUAOBc0xJpFUMJ5QmuTFojF+64xStrd6zeRhsm+7qiuEousnI+wTWoUFGSJ/LBw00RB6wSaCyVHnBoIF8Pe++SLKYM0jlo69Iv7Hyg2cdZav1Op6djJDw4PDY4GI7tPlwCAZsXGcgIuzzc0xQRrUPppRALRLxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOu7w4KMNi0U+FWoY36QVH9Jvq1QrgAeqBGrZ2o94Kk=;
 b=lXj4dxrIvOPNGrAV0C9p7GAy1G4RHuTR8QZunbIJtvVYbTmhWs6krBRVwh3P9I7+LiCdYRvK27S3IigcdKyRz5YsB1rpmaoaWZuuxU6O37YsMjO4dqseAJ7d11WrwaM3JA/RiWQlfY64x/Utik+ROxbtIsA6gmXBXwtUsTnFoJQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM4P190MB0145.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:62::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Mon, 27 Dec
 2021 21:53:34 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4823.023; Mon, 27 Dec 2021
 21:53:34 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/6] prestera: add basic router driver support
Date:   Mon, 27 Dec 2021 23:52:25 +0200
Message-Id: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::8) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bed5155-cf75-4384-bff0-08d9c983540d
X-MS-TrafficTypeDiagnostic: AM4P190MB0145:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB01458030AA32BAEFB276F19493429@AM4P190MB0145.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T8f02mh+kOlrXwaDaarPpZrrIeu98vgIa7yrILAScbI/C1cJ6vfdBSRne6x8+lmjCxIBt2v6SfSzqSRgVtQEp3ZtckBUygQ/Lv/0PrkOroukuwmzN0m2jEf3Kapv5fkN527DUuCDMrQ5z8W4OZ8vt2sMOUsK1+LxTic7lz+l8asPFk8vn+3Ph22Si63DIeKjPjFyr2zLMlxQ7oF6B+I333BduEQ8EQ4jPbg0l2TwUDEaNL50v5SAgBPcpNV/evUv/N+DBohkd2itOMlhLJUVChHdKU9HjXp1xci1d+ZbhN4woigN81OovJNsVDBt4lgYtCJS6hPOV+WrvarNcaN+69UW1WRvLZ35u3YWzsjrXDlF1cK7bCpF0P/6eod2LV5LglRN6Rpo1KoKmc1nHKMwGis+bGPqDFH+vuXX1yG+ZxrzEi3vmJSNT4kbm3Qeqej5tvvQQ2BicabQozbYbUROcIU87O62YCMv6C8QFh4rSZDVD068k5XzFoT/mrUAp7+i/B4wc/2T+DxLAEJc7yx+QWWkum7RhglKDNf+N38KnQ1ftSlXd8RrFLMAsKpqgqfDSTYqIz6TdgqtTJB3Yba/M0rd0pkNgIp+eMdFcMUP2an9I9hoJ8b9/UQjA0h5CAthSVAOaRhnKTpVxsajP43wH/yajWsug2t6KbvoZOQp9IKCA7KaYwrjwJHhRQEEauwIUDK9Dv+vW+4gwzykR4Qvbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(376002)(39830400003)(5660300002)(83380400001)(26005)(1076003)(54906003)(316002)(186003)(2906002)(6506007)(8936002)(4326008)(8676002)(2616005)(508600001)(38350700002)(38100700002)(66574015)(36756003)(6666004)(52116002)(86362001)(6486002)(6512007)(66556008)(66476007)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AHpYpeLZD6fA1y+9gFz81zgh/XzIwhBUCLSzBjdLOTx4NLXTX9Ly7pEJxFfy?=
 =?us-ascii?Q?LZYS589yCdBZBDSo4ftk44g/dXmhSjzBX+JYhcIgJRHYmHfAqjWiRtEAuYy4?=
 =?us-ascii?Q?/Bc6SIDX8gOnLQmaNVJS6KkdvqCzYYcFwF9o1XOllMOgVZpIg14tpeLL3P95?=
 =?us-ascii?Q?p3KO/X0624G2Nd1w9ecXmsU8pULDAycQpM/6phQ7A2t5H1d+PUDvTM9GW5Vr?=
 =?us-ascii?Q?KpahrvufTn1u6s532lRH/gOkv3jJzG4DDN3BdJ2Jx2r/wXITTPiNtCiWgC1e?=
 =?us-ascii?Q?/fNkkeGFP9ALiFrL2BLl5cL7X0GfYEFMDQ1kS5cjU5MgwwFBeJ7IpLKwQAuW?=
 =?us-ascii?Q?nMDGYDGvN04MPwCK7OFR2Xod9QAfpGN8wiVrA/OEL5OVZ5QxpQxZCzLepmWu?=
 =?us-ascii?Q?cDdLBHe9SfJMP+gAYLFPaHqEe18Rb4NHWVer1RH0M4Qx0dklCz8dy0T1zcXf?=
 =?us-ascii?Q?X7kDv1e2SjpJWdb7PdcW5ONxwbfwicqI6JC0wp60+C20GnQ/MjrDSY2/noig?=
 =?us-ascii?Q?672/rVLWNufBiS3oo40vKzL1fwlnyXY8JhtzPr3MWXqyeHfjlJ9hI7o+0urs?=
 =?us-ascii?Q?KLhbG69J01pOiwBdOj0CKY47EO/r/kAvlVmkCNRdR7u2bhBToarc2to/5CaK?=
 =?us-ascii?Q?2D3KcE+NFGQGZypEF37zosvGRgciU1We7zOa+SLvfNXixWDuB7TAhozab4au?=
 =?us-ascii?Q?DS02jWtSYtoxpD5sCgl0ndMED86NbssyJ5s/a2aTT5WbJRYFJ3ueqDM68Zct?=
 =?us-ascii?Q?kyAksXu64N2CwQW8ieSVIuwjRaNTHHCJn6eRsEkkKWaxcAZEyIqloAASpTNn?=
 =?us-ascii?Q?v/tObwl9RAx2g6btgXzqqDfnpOwpW+UYcnJFLA2kMm1IGi/o/9BzMODMUkjb?=
 =?us-ascii?Q?YOyYhWlvDvL/lUm40vJezTxfKiv2I+SJaMEK3em6FqNg6vCEowWWSghcA9qx?=
 =?us-ascii?Q?mQsOcKl8CaaSpBbMXIkMpLA7qvJkACgiFLaoWyEDqYm68/XG0J8410oCu/N2?=
 =?us-ascii?Q?zRG9zw+b3OF1MnZbgS2horK6SKpAvQPmyJtHxxM2RIjAj//99D8LW6TV8CjS?=
 =?us-ascii?Q?rXw3wvh9W4LEdxIvwRQ561OEIRWKAGhd/Q9vGbAqyfgzubBFU6RsawCygoQD?=
 =?us-ascii?Q?pSh1WqLkPGKX7LSWUH5UITJqnyYuCvFKscFoI6gtP9f+SasIkUV/65rzsMBk?=
 =?us-ascii?Q?HD5htxCeDiBZcmt/ZmgHTb6sJt7AcQEVfOyDzIDsEBLMnSw/PhsPNtsXmZB5?=
 =?us-ascii?Q?gaH5RoYRAgMtZ+erGfrKEC3C0KZAci5bpIIm7kVu01ifX/mQqJnP1dII9CRs?=
 =?us-ascii?Q?Odxb6PtGOxDtRIvH7HuMhWlnDd8ySE82+JV7BEM97fcF885+Pjn44OzCdILR?=
 =?us-ascii?Q?od20E9/+ZEej6I4aCw3nUHywZEjuiWZcpRG5ekh3dEoyX1uSeNLvhMFhYNqi?=
 =?us-ascii?Q?7GWC9BHmxlq2Fmm6EM889DQdQSNV6NMnzrW+wgNK+oz7OxEDtpNMGAMdop48?=
 =?us-ascii?Q?KxyaOSeAMioW7gTcOwlac8UP9B0NbmekQJdWm/8mP0ii9fJgOUevhdeuliPZ?=
 =?us-ascii?Q?39UtS5rFOI40ou7pY++mPf3fiBdxsjPyAiAgaqiRj7Xdf/+lKXR/MrJWTEh9?=
 =?us-ascii?Q?3S3rsz1JNrWVJAjV0n9aKcS4Reqc0qhrUO4tQvSdCNA/UMxD8ifpemzan+a3?=
 =?us-ascii?Q?6rXePw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bed5155-cf75-4384-bff0-08d9c983540d
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2021 21:53:33.9596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uh019XbRGgtLOxuAl2xBAPHYDL7YhdLKoiddJwUdUwI79fmNB4K1Uo81G+YmHM2FwucRDvbFTvhtB2HoHx2NcliGHe5HCxm6BAw/WmNvJoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add initial router support for Marvell Prestera driver.
Subscribe on inetaddr notifications. TRAP packets, that has to be routed
(if packet has router's destination MAC address).

Add features:
 - Support ip address adding on port.
   e.g.: "ip address add PORT 1.1.1.1/24"

Limitations:
 - Only regular port supported. Vlan will be added soon.
 - It is routing through CPU. Offloading will be added in
   next patches.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Changes for v2:
* Remove useless assignment

Yevhen Orlov (6):
  net: marvell: prestera: add virtual router ABI
  net: marvell: prestera: Add router interface ABI
  net: marvell: prestera: Add prestera router infra
  net: marvell: prestera: add hardware router objects accounting
  net: marvell: prestera: Register inetaddr stub notifiers
  net: marvell: prestera: Implement initial inetaddr notifiers

 .../net/ethernet/marvell/prestera/Makefile    |   3 +-
 .../net/ethernet/marvell/prestera/prestera.h  |  38 ++++
 .../ethernet/marvell/prestera/prestera_hw.c   | 139 ++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  11 +
 .../ethernet/marvell/prestera/prestera_main.c |   8 +-
 .../marvell/prestera/prestera_router.c        | 183 +++++++++++++++
 .../marvell/prestera/prestera_router_hw.c     | 209 ++++++++++++++++++
 .../marvell/prestera/prestera_router_hw.h     |  36 +++
 8 files changed, 625 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h

-- 
2.17.1

