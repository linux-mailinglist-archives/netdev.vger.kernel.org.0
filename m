Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2BC3C365A
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 21:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhGJT3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 15:29:11 -0400
Received: from mail-bn7nam10on2107.outbound.protection.outlook.com ([40.107.92.107]:9249
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229614AbhGJT3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 15:29:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdGeF7paL4EIPXR4XeLEVgmA1/mvUNwsNd363eh84v0PUtODQv3Dfplmu8gpHNlqdLzheOE5P7OHW2h1ntp2LP+3039OQD4eEY5G6i+Q3tDpYTsBRJjRVI12JhYGU4y9qjfc/p6N6rPus3Wtsk1UHyYOhVxQj5NyhR/uTsr245jZit1drA3QN2QNBOJ95FYYEYvcCuLW6R+d4H7Zl6o/bS7sVwacaqX8ft+l7rn+8/xyS57VGpjh6oLsRxhdTQSydV9o1MS/FdmFAgq5LiO7RhYUzZePEPaIo+dH5gJCk/xV94q6PGAVc1zsBf2VUmT2wE73rX34LOEJuozlu3ezrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Sll1HQrZ+iKaYGw5atsj5OKPSgrS5pUR9v1e1ssyjw=;
 b=itkS9ne1L9xwaSFRL8lA1C9UEn/1OcDngcccuk37HnX8CoI6fXiwVngCP+X0XwAfdB61J18fRQuQvFHLLBbIDF5uKgh6KLlx7ur7ACzLov9Tr/nxaT1gDrMCXl8ymrhiGnyBp9RiKcgAaGF0dlODBXhWYrCRIyA/pgv5h87qz0CKS5FwA07SozkiCzbFBmoOWyp7R8i0/Act5Y2unBiXFajQ0sxKKKENFT7ipMU7xn4AhIGuY12V656q89iwKIWnSKpYUPYvmeRP8Lv/lhiYMbB9aD939ozOB7mHOs1gROH6EcrFUsWmbhBviqzL6bJrnNwkuWfX1Ef4QDnSru9yUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Sll1HQrZ+iKaYGw5atsj5OKPSgrS5pUR9v1e1ssyjw=;
 b=pPagMDH1BloIir2uRCDrS8cmIBSFepQ2E4uEY9xkpRdMRKfQ7k+Dcm8gVXnb52IuXAwSrznlkp4IWFEbngVOvDjtDKpy1ao61F3ikjXazu4Niosyxh6lGDeNE4LLC1QMIsAS8aHvvXE7cN7QEa6zc9DE8u7V5ERzr3n0tLeAcU4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1709.namprd10.prod.outlook.com
 (2603:10b6:301:7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Sat, 10 Jul
 2021 19:26:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4287.033; Sat, 10 Jul 2021
 19:26:16 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 net-next 0/8] Add support for VSC7511-7514 chips over SPI
Date:   Sat, 10 Jul 2021 12:25:54 -0700
Message-Id: <20210710192602.2186370-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR12CA0042.namprd12.prod.outlook.com
 (2603:10b6:301:2::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MWHPR12CA0042.namprd12.prod.outlook.com (2603:10b6:301:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Sat, 10 Jul 2021 19:26:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 253a6814-6535-4106-4aed-08d943d8966e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1709:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1709AD29C8C84DED5496E2EBA4179@MWHPR10MB1709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KWSVZ8SGy4by7T0uXccsVvfX166u2z1gPRQaB7C8bjRjQNaH6dwfnXOKB4PZTDvsn4GChXv7bBUzsjxKhOvNIoFo/8UKLD3EOn09Qp8l+0W1Ov0YT/s5533raqWTGnwi2KUC1OnbqBw9aRagAmGWIjAVlMx59pF/782ULHYGak2jRxoxGCw5lBjamWYGJG2qbbukjwJ81Le50fCXDGCbSeLUizUT9ZyUD1zFlqwn28srq/gyJYtSLaATYcYv0NcnZ8Z7s87WQyIOgYjO/obJ9KMSGgwC6XN7jP78yzlCGtlhYlC6yXtQ0JMyjvfpFdZ5Y/km305rpwHpaIHIDMF0e8dAzkdQscYz6E79/2uVz7PPWjww+DSs35mT461PvfKJ8z2mo7qRA3aXiwilIsYzp2ji0ht2gOs+1ORfr2iVTPUG1KJNR2oc6o5EoTqS/dmWZp8qnsWv/c03BProcq+eFFyNRDuZiEdcNCFo5pwltigee33kBUzkHjO9dyqw9diXDvmtzlX0uNert1Kwy7FFpK/0yk09bN7d4u7TXJIO/fBBLL/55BqyEY1Bv8u6yFSjF2mgVHOd9/mV1ycuFFzwd4o9sshc39Jy9CJvBlOz8qNXn/lnMjPym9aWZB+xTOqgQyBfiVIMor99qxhvMY0n65lfITTLOG/mBUofez6Y8C5fYRmRnIwG+7842gCRmMWByjtepBqGiT3MyCGznuyKTsJrQlMY+RhkcKgp6qacipE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39830400003)(136003)(366004)(8936002)(7416002)(6506007)(5660300002)(2906002)(66556008)(26005)(2616005)(8676002)(44832011)(6486002)(6512007)(66476007)(6666004)(38100700002)(38350700002)(52116002)(66946007)(921005)(4326008)(956004)(83380400001)(1076003)(316002)(36756003)(86362001)(186003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y2Pz5SLTVwV30de92rMtmREYB3Rci+DTR9ch/9GjlXSqK0jK8NVk/JnY/4BV?=
 =?us-ascii?Q?yDhTjJf2dOwi/FU2pdDv9rbQE181foS8U7Ut33y0xe4lMAlxx9YrLd97rQft?=
 =?us-ascii?Q?bsvZLWe+Y9rfPLDQM97BQQ8tCTsF2uVNDwbo4dEyAMSq3NQw74oKH8BEG4Qp?=
 =?us-ascii?Q?FOECQ/WeLgGA+u/J92sx2SS0wNxbNIsFQdSuUJwNSico03qFHJU6i00lmKro?=
 =?us-ascii?Q?5UoMOOuFGJnxUoz4+7aF5a3ZyOwKcAXGlacmBScHKMm0D0zLwdE4CbFcCuSX?=
 =?us-ascii?Q?sLvWXmkQQf7Va9gHICocq/4RRcQ3HDWVE9LXLRFKrptKol2rKTm6NmE7lfpk?=
 =?us-ascii?Q?lk1XWkD3PsTTAuf8qIH0vOHjYvHD56OpeBRlwKd2jQhlykg3sAsaLeZlIa8b?=
 =?us-ascii?Q?kqN9yY/3KBz6FeQm+V6Lxjz1lU+s4b3BOh/WkG5bQJ48UOvq1fcSO3y9iK09?=
 =?us-ascii?Q?rGxHu1gxjrAocPgmVWe1djayc61BEzy5OJikA85wrhHwES1t0Qa1wl3XiqXe?=
 =?us-ascii?Q?1Cs6urLJmJKlG3oBRW+mw1XDe1G9kkiS8PEHkXUj+1tKZYrIZ1aRVs+yccsf?=
 =?us-ascii?Q?AVrW9umIvtw7AFFa7nGmSGo8emgNvKiE8PdiyHbZeZFUQs94sycYEU1SRoH0?=
 =?us-ascii?Q?hFnxVG0SuZRA0xygHhvviWV97N30lPpxj/cb828yBr1LRJzV+0/fdfW25ftU?=
 =?us-ascii?Q?aYMkomlJuvHuw/jeWRrvDEn97VxaApYFNejQgF5NybK/tpIuyHzvZThFfkW6?=
 =?us-ascii?Q?U5XN6Z/b8KkDymdzHBVEoXlS9tSfGKVweDZdC8Fkrwclj1J0UgCz/3YzKdsr?=
 =?us-ascii?Q?wxTNS0+HccFUJQ0EBfkbj27y2BanWJ743Ek1B4hQg2qQxY8gnRO4YLY8C8lA?=
 =?us-ascii?Q?/MWhWxCnEe/MWrtBlVNXY9qBgFxAUbDA0npkhEh28rRbAgFUNHTNGj7Sg/8c?=
 =?us-ascii?Q?0VjB5s6OAExSfCCz+7DlMi+eUjxhPZFgT20zg6HWjyckh9iq/IS+x1jiM8JA?=
 =?us-ascii?Q?UFluput9EWr8J/+9089zjUbYHaYp+WDJm2utf5UtbexQtdAbZ6l4/l3y5EoS?=
 =?us-ascii?Q?t2hJFDm3+OCUVOlwrl6BT92NlF5TTQHLkwqlsZigP90Xjexym52Z2QrMuDnr?=
 =?us-ascii?Q?lYYO6U7mkX7jIP/xVuL3YPeiHokjzcRtenpjOkBIYTE+Ac/u1K52IOXa0Y45?=
 =?us-ascii?Q?Pf0trRbB7VXDIEu2Lm9kEaWRoiTCRtn2Byjsdn7CDo8FbYKQIQADwh7ctJnm?=
 =?us-ascii?Q?JMB3kgIwv/fINvapAQ66CNeVtbAvG0t1oTGsiL+eS9iOfDYpbx20t6kYi2V8?=
 =?us-ascii?Q?SsXNoXrnZTZFyZaP9LIt7Cu6?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 253a6814-6535-4106-4aed-08d943d8966e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2021 19:26:16.6802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ePO2MeQAZFxcupehgLIiAWrmsIQB1XrpDby1/f1XMKw2ebZqKp6NS3YNWhzZxkxMGw2eCZO4vPcNUnKV26pFyZpLgrMX8BpSZ9YUDWMtcDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuration and control of the VSC7511, VSC7512, VSC7513, and
VSC7514 chips over a SPI interface. The intent is to control these chips from an
external CPU. The expectation is to have most of the features of the
net/ethernet/mscc/ocelot_vsc7514 driver.

I have tried to heed all the advice from my first patch RFC. Thanks to everyone
for all the feedback.

The current status is that there are two functional "bugs" that need
investigation:
1. The first probe of the internal MDIO bus fails. I suspect this is related to
power supplies / grounding issues that would not appear on standard hardware.
2. Communication to the CPU bus doesn't seem to function properly. I suspect
this is due to the fact that ocelot / felix assumes it is using the built-in CPU
/ NPI port for forwarding, though I am not positive.

Nonetheless, these two issues likely won't require a large architecture change,
and perhaps those who know much more about the ocelot chips than I could chime
in.

Colin Foster (8):
  net: dsa: ocelot: remove unnecessary pci_bar variables
  net: dsa: ocelot: felix: move MDIO access to a common location
  net: dsa: ocelot: felix: NULL check on variable
  net: dsa: ocelot: felix: add interface for custom regmaps
  net: mscc: ocelot: split register definitions to a separate file
  net: mscc: ocelot: expose ocelot wm functions
  net: dsa: ocelot: felix: add support for VSC75XX control over SPI
  Update documentation for the VSC7512 SPI device

 .../devicetree/bindings/net/dsa/ocelot.txt    |   68 ++
 drivers/net/dsa/ocelot/Kconfig                |   12 +
 drivers/net/dsa/ocelot/Makefile               |    7 +
 drivers/net/dsa/ocelot/felix.c                |    6 +-
 drivers/net/dsa/ocelot/felix.h                |    4 +-
 drivers/net/dsa/ocelot/felix_mdio.c           |  145 +++
 drivers/net/dsa/ocelot/felix_mdio.h           |   11 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   12 +-
 drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c   | 1068 +++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c      |  109 +-
 drivers/net/ethernet/mscc/Makefile            |    2 +
 drivers/net/ethernet/mscc/ocelot.c            |    8 +
 drivers/net/ethernet/mscc/ocelot_regs.c       |  310 +++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  323 +----
 drivers/net/ethernet/mscc/ocelot_wm.c         |   40 +
 include/soc/mscc/ocelot.h                     |   24 +
 include/soc/mscc/ocelot_regs.h                |   21 +
 17 files changed, 1737 insertions(+), 433 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.c
 create mode 100644 drivers/net/dsa/ocelot/felix_mdio.h
 create mode 100644 drivers/net/dsa/ocelot/ocelot_vsc7512_spi.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_regs.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_wm.c
 create mode 100644 include/soc/mscc/ocelot_regs.h

--
2.25.1

