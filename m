Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AE946870D
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344225AbhLDSco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:32:44 -0500
Received: from mail-dm6nam11on2112.outbound.protection.outlook.com ([40.107.223.112]:6588
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233170AbhLDSco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:32:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kn95Guk5hx0RSvFx71dICIoNqTcbyRmB4zcXI6hWLhuiC+Fm879d2HUG9yhhaBwSpaNTVr3WeNzWoPpI+2ksdsL0Pi7xhSXytKJ9mvODKW5ZLV7J22amVmjIgTl22NmbGBoDaFsnJaBn5mVBmSJAMATJvkySyxQTbQVW5qoQXYiso0l15IM4Gqj0ifN+B0Ukhp44O78WIRPcW/OQFq1ZZ5eErCwZboYJPm/BKL82El7Km8GM5Ttty9FeSiU2RvM0yWQJvQmRPndgnSaKkghUZnLGQ6VSX8ZG/7NrA6j3YU71xdKjhlwFn0aXoaXREtWkVY+jxGz4CBmTg6fjN6U7qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+x4T5WnsWVPfFokKCsu8GBdbpISEMYV/UPtXOcKvKU=;
 b=F91r3I4bKg1KiIkAb1kQgD9YZscJS9AsT0UWbIt4RgiP7Q6pqojVUbSwcCeBEgYOX2vWSKncWsDI/+gkgLu6sOdv81vTqd6AkQaDR/eZhax5iBzP0I/9qy75HyYn1R49zWoB0yVIYSjopgbOvrYQLzrQCsdVm+SO9VlL4wFIZSwjCymIL8NcGOG8uSGqLLWHtDkXbkUKlvRHSUJ2O2dp+CKU6AzpsCUzZf6qJAEIyFN+uOVaw4aMXaBHuvOt5z6WAgjYdT5pAhYBAMl5NJzPP3vu8IHPWWjL8n7P+CHOLk2z4zcS2w3Js7G2LM0Ur3D1+Zfg5i5cf15iz+pv+mnZxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+x4T5WnsWVPfFokKCsu8GBdbpISEMYV/UPtXOcKvKU=;
 b=0V3/2FeygQP/DDgC2Amb+d6Bh8LZkdoA6XqD34VKXxO1HlcfqrRBYK3LredYtNxljbo2HZ3YwAv8+1zPgAFC04MIEOgDuS5g22xwQUVD9wH6GYQvXK4Ix/uxdoYk1roaUd9Oluhv/ZOs8mpWv/eG0x1dlS9x/qM71/11mkHuOy8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com (10.174.170.165) by
 MWHPR1001MB2063.namprd10.prod.outlook.com (10.174.170.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Sat, 4 Dec 2021 18:29:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:29:08 +0000
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
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v4 net-next 0/5] prepare ocelot for external interface control 
Date:   Sat,  4 Dec 2021 10:28:53 -0800
Message-Id: <20211204182858.1052710-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:300:115::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0045.namprd11.prod.outlook.com (2603:10b6:300:115::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend Transport; Sat, 4 Dec 2021 18:29:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b68d3fde-2e0b-459c-7eb7-08d9b753f5bc
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2063:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20630D991E1C1B942B301C92A46B9@MWHPR1001MB2063.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wp4CD2L8EF3Rtlu6hdafSdjWxoCUUY7vj1leGnufJAYpIud0CbORRnzskC4JtQPD9abcXQNF41bg878IXKSmulup+6BeOn2tIowaa/DWnxqBPTMgrnATAh5VgortaCuapoKh3lFNMb4iibFyi6KSPR7kO1IDVIFofb7Av29YCWgZJORy/4oddXDZyUjN3rX0mTkOViYO2pb7Au0noHJb/aVrNqJXl3yhsUCIeS1GWs55WGvdlEwmNxDYkSiiMl5jIrGDayhlbrhgdM9BIYr3lWvfvnxORXcWnhLwiuMt9qKl65Ihg5xoQ5wQowCkU8KdJopuv+fldJr2jSZw42fe8rBHYNLwEB58FIzFcDlX/cDLLGqNK67vknN5DPHcKnXZbQ61TGaX5QyjgY3mr/+k3mWNsInaD5WozUPeHC6P+udnNKOmCsqZiXUVDRPZ6TVPNhrmDdnflJfE57L63vKsxq1zRP+TFhTocdyKYusRCJu3oUyeoTk8cyE+1pj57ApaAnQzi/WhRpB3zIjvaxXk7zsVv3PsFlPbm4qN3Jb04QujZAgJOo+T3ErkfILsuOZBNN2T+NFB6EYXA4TZM6ORatckn0bDM4g6QLZxpzjGwGgwt8jOGoF8hP34EGb7ueWT4pLLOYhrOrZTxFZ+/+thKNCXJdAUPg2PDft8u6A2wGGKyhpKwiA1ypOCfYHNuN1+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(366004)(376002)(136003)(346002)(396003)(8936002)(2616005)(956004)(86362001)(4326008)(508600001)(1076003)(66556008)(7416002)(4743002)(6486002)(66946007)(6506007)(52116002)(6512007)(36756003)(54906003)(66476007)(8676002)(83380400001)(26005)(5660300002)(44832011)(316002)(2906002)(38350700002)(6666004)(38100700002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JlxKzPd1vynAU42GQTr8EVJ8Yl3PzQwnYuKMkk4HjZgIXnwa1sYl3hL/m5bN?=
 =?us-ascii?Q?G+nTPd5VJxj9sqm+Vq5EN+9EFoHIuw0afAFoic0Nx/sjoH89KgiGng/0y83e?=
 =?us-ascii?Q?Q8k/GzH0a6czF/1ebq3+BoRyK5SZB1cO3lo8quPEXHyO6YgnElRi0+tESM1B?=
 =?us-ascii?Q?y1KjRbVUTDRTWTEnKFKwPQj4mwkUfaF5prqUQeiZna+qshveCJWh2mhH+c4g?=
 =?us-ascii?Q?rHf82+Z0V8ysnu2ntLaeiQ1+saSneXsKNbrz0oqSn7Sq75qURcbu2RKQDKmu?=
 =?us-ascii?Q?GUUF73xmCLN80DB+zMa7AC7MuEKQGJvtSaM0Z2bluz4yUfsqThHAYRW3c1PH?=
 =?us-ascii?Q?EjSfsFKz5/aoOJa1ll0Tkv0qSvzhLzwZZh7ReD81/MlChTbsqgiNN3vxpgts?=
 =?us-ascii?Q?h/KEPb+aQfU9XULgO/BDmuV4KXShM+R+rDje+zyUcgWAntGanQ1knhjADPT+?=
 =?us-ascii?Q?+ocrSwrfppx4dN1VLbHniTZOoD43jU1ew6DSOh5wbvkWzROS9y2PZp75nHqg?=
 =?us-ascii?Q?AT2DYk0eb72RNVEju1sHC4PyLuyqpmiqM513chw3Nl+6kwhKqzKqyzinKGXp?=
 =?us-ascii?Q?rFZdYpIMkqskBv6rzac8JSvLYu2U0OSUi8Hg/9mNZP5Rv/O4Xx/46lN/fo7H?=
 =?us-ascii?Q?nFv82czp89ajquVW1opMo+kxC+RUYorg+Dy07HUHuVYzzAU62xQv2foQW4ar?=
 =?us-ascii?Q?Wm0sw4J2E6fsTUEsWlyQGteXs4SIBzlc9rK+RCOtqlLAGXd76OgiL/nMKFYy?=
 =?us-ascii?Q?H0FI1o3CpoXUVrnGN4pZkzOJHd0XlshLoCQB8o6DTQ24PmU1A0YSR+Md/ttJ?=
 =?us-ascii?Q?DMwVGfVynUmA7k9WDFR8WiC04s5SMqu1kwpaOUHfmtI6GTpyZhAcsllU4RPR?=
 =?us-ascii?Q?CxqoX3w7w/EjSK595FRLuf8SeNh3b/8FQWeK6X+8B0Si2gSq1SSENxvO7wHA?=
 =?us-ascii?Q?CMKD0/Y3OqrXFMR2ddx9aBH2LyH7guHO/yAkHFzAXqnfWybcWyla3/Jed6fb?=
 =?us-ascii?Q?RFSFenurr6eXiZtEQ1wQukRPU9f9yXnXoFr43purxenJRsdAr+eUGqSzRn9I?=
 =?us-ascii?Q?PUtaxiObSiEt+p0kaXcxN3fgCozqVfnC3cyPVi8S9nHVKDBsoNmo7YkRdQBh?=
 =?us-ascii?Q?gsPaqljE2sfVMDQKhMDAiJvwLhQw75ZFAG414dMPoGRrkWPaLfc2dKJQ2sJo?=
 =?us-ascii?Q?4MAaqK7laUUy3t+pIp06JTv3JL3wWBmOm0obre2KE6YdvTabCYz8cR9/qTJO?=
 =?us-ascii?Q?CXmLSrUYh+l4jSjZNpoL1YD9HqeWbvtY+4hWnuo9ZXYy4cR52tiYUpb5b/ch?=
 =?us-ascii?Q?VeU6AKCkkaLUyX17lXexk+09HStL6lcaD33rph/9nJFUWOtx08r+iZnn0GAn?=
 =?us-ascii?Q?gQXstRCWRwqcyd5KeDcSD97yAG/Ac1idlXTxPjVony+HtJAbR4keCFmbfnQS?=
 =?us-ascii?Q?cGzS2kydMjzGrZGfBW0INnggTouLlEMU3XYZEow+MgoS8yc6IaUsGsGBVifh?=
 =?us-ascii?Q?ug8TLhhz+L7xAQVsmOAERCycBmgM0rhbBIlP4mEZJKrKfSADlVvPoRXX1Le3?=
 =?us-ascii?Q?L3OnduYmhu3yyg4y+bQt7u0zDKvvNdlWtaa5znwppSlJEnUnt08yCPOBqXOI?=
 =?us-ascii?Q?Ts9jUNrsLGxQYkH9Kk3L8uLqmo+0PR6jG4fMJWQ0rf3Qh4VGKq69qAJiVGlg?=
 =?us-ascii?Q?fFsa04CZIXBvuOYWtyTHmqzdHR4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b68d3fde-2e0b-459c-7eb7-08d9b753f5bc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:29:08.3854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KkOKQJbctT/k2aYkY5BJ+jEMCLoDnQSjRVN6qL4VYXfANb9/RYGTN4IGzb6cAYgdA2GkBKi0Ptfnx9fitkRYrVekKvX+weO6/89mShoXVcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is derived from an attempt to include external control
for a VSC751[1234] chip via SPI. That patch set has grown large and is
getting unwieldy for reviewers and the developers... me.

I'm breaking out the changes from that patch set. Some are trivial 
  net: dsa: ocelot: remove unnecessary pci_bar variables
  net: dsa: ocelot: felix: Remove requirement for PCS in felix devices

some are required for SPI
  net: dsa: ocelot: felix: add interface for custom regmaps

and some are just to expose code to be shared
  net: mscc: ocelot: split register definitions to a separate file
  net: mscc: ocelot: expose ocelot wm functions


The entirety of this patch set should have essentially no impact on the
system performance.

v1 -> v2
    * Removed the per-device-per-port quirks for Felix. Might be
    completely unnecessary.
    * Fixed the renaming issue for vec7514_regs. It includes the
    Reported-by kernel test robot by way of git b4... If that isn't the
    right thing to do in this instance, let me know :-)

v2 -> v3
    * Fix an include. Thanks Jakub Kicinski!

v3 -> v4
    * Add reviewed by tags

Colin Foster (5):
  net: dsa: ocelot: remove unnecessary pci_bar variables
  net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
  net: dsa: ocelot: felix: add interface for custom regmaps
  net: mscc: ocelot: split register definitions to a separate file
  net: mscc: ocelot: expose ocelot wm functions

 drivers/net/dsa/ocelot/felix.c             |   6 +-
 drivers/net/dsa/ocelot/felix.h             |   4 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  11 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   1 +
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c |  31 ++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 548 +--------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 523 ++++++++++++++++++++
 include/soc/mscc/ocelot.h                  |   5 +
 include/soc/mscc/vsc7514_regs.h            |  27 +
 10 files changed, 610 insertions(+), 549 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/vsc7514_regs.c
 create mode 100644 include/soc/mscc/vsc7514_regs.h

-- 
2.25.1

