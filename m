Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B203D96D7
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 22:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhG1UhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 16:37:19 -0400
Received: from mail-eopbgr70118.outbound.protection.outlook.com ([40.107.7.118]:10413
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231126AbhG1UhS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 16:37:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZqbxbUoq9Z0JYQtQ/qh/7JztdZHATaiQP7NjFUsklvczAw2Ijiy7YUkUQ6RXr+N27n7h4nX5r5yFTB/WEk1s2abonSUxPYOfZ/MLLtSivtVvZsiU7KwmK04nTiZLfm76ovX3jjmfjq+kzadMDlmyZ9d816z9xa7MAFrhw2xrzeD/sX6kzzbm0kw4zSeaU8FE1DVxFi1gYo/PRqvkaC9LxCXqik470ILL8O7feFv7nuQSmIe6xLJ6gfFgCysawH67j+oqbzX1l1/wLkhGT/THW6F8DG/JP+7bHe35qEx9R/XXXPhUEJvRSBjC6eOgLAFY4YDKGsxmdKEI8Ko3daL/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFjp1NGI6PjO3aK6T9acMtmI6rHYFU6HaIJeP3os7yI=;
 b=kAhWziW/GKSGSbIqH0cxo6mC6S6gy205I8O0Tgb6IaevxQYft56zL09a6sJSCv/pd+QqdDBVz1EcgWzeUuKPA0wBRpwFGFeE/+HAFdM75JJY9kNpi8F6yN+iDuBbMf3L2ewPfkefcLAZT3EXs/Ui0D6tP1lvxFISk56L0N+UwNK4pE4RwYUPvSNMX19rjELrOKb3Axk48XOYTyUfCBzVoSXtnBdDpi//QS7sRBENxMyvtKCN0vauyJFqk/KOuybJ6NT+aSszzEvNFWcGAreCdqxJEAEOjtiF98LqdLaXROEPShjmCJwQ0U/sPJT4S7YEPWiFwbJYaIKegYs3H7ghMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFjp1NGI6PjO3aK6T9acMtmI6rHYFU6HaIJeP3os7yI=;
 b=GZshHPIZJXGL4OLcQ1JTPKXfMjJJoslD9iqW2j+vnAyzNUPWWNkffQKXDcS2XiR+jjsoNCHV2k1zxClTchQDd7M3r3qNADkzJP0lEXA/PJ5nyauLj1sf3p02Pop07D4ML8DJ72auc8LlGoTTiqc/H916r3p0DS8aWEwucR3GaYQ=
Received: from DU2P251CA0002.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::11)
 by VI1PR03MB6239.eurprd03.prod.outlook.com (2603:10a6:800:140::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 20:37:12 +0000
Received: from DB8EUR06FT020.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:230:cafe::3b) by DU2P251CA0002.outlook.office365.com
 (2603:10a6:10:230::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Wed, 28 Jul 2021 20:37:12 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 217.86.141.140) smtp.mailfrom=esd.eu; esd.eu; dkim=none (message not signed)
 header.d=none;esd.eu; dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 217.86.141.140 as permitted sender)
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT020.mail.protection.outlook.com (10.233.253.6) with Microsoft SMTP
 Server id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 20:37:12
 +0000
Received: from esd-s9.esd.local (unknown [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTP id E92F07C16C5;
        Wed, 28 Jul 2021 22:37:11 +0200 (CEST)
Received: by esd-s9.esd.local (Postfix, from userid 2044)
        id D46E0E00E4; Wed, 28 Jul 2021 22:37:11 +0200 (CEST)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>
Subject: [PATCH 0/1] can: esd: add support for esd GmbH PCIe/402 CAN interface family
Date:   Wed, 28 Jul 2021 22:36:46 +0200
Message-Id: <20210728203647.15240-1-Stefan.Maetje@esd.eu>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcadf09a-8520-414a-528a-08d952077a7b
X-MS-TrafficTypeDiagnostic: VI1PR03MB6239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR03MB6239B9520A4EE31048CDBCE081EA9@VI1PR03MB6239.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ja2Pej20CsJEK0855yUHIsu+3WNi2k3s8H9KThK8t3BClR4EO3TFdyDBDxZoMU0hbjN+yKvpj00/DR/n0/PoD2nzKuY/Lj54DYThw1KVpS3n/4R7XPxe0slwifj8rwpWEr3EGCPqPcDntDZeW0XQyjY2clCicDHcbRZADwGn0VauTebogh4lJEdLoYDzunuYm1cmyCxAut3+j4WqaGS3EilPMHatR+J/H9T8KqJEkmlFxNcrQfPhVrQW1qZtb9DSdmmIxngTlo0Xw4uV8qOSnUl1bQXJFkxLk6dvmYKRNllwu/OrQcMV7yTsuD5XrVyeOgHXirkjySALS9LJTSj3hLUxy1FPzAxCj/2DKSqMmJtHShVEkSso6p2G5VlJhSe55eXhEBynpYNaEzpvwxNfn1kAgQmP7BsgHoSADTDQeSOC9SpQH3r9VbBAGJ1ontzk0NzkztUUYJMb9aDBb2HkZ3Us+9OizQ/WtD4/9pWyk8LiwINLpTETEuBNm9bKccnxjqXVSTIG0XpQL6RkfomGS3Fp34/2xFK432ZQBOf/qckXSRQyOx8TfZUqcunmhyH/FDQGhNHmWyiNUwCMA4y8/GToOO4hpw5evteL82K8iBNJPip5Lcf0dwFNzMRTo+glve6JtqA29Nhj2onoJfKECt6a/ixssnWhrOzFoR4SLn/YTx+lNinoF51swBmOqcNIahBRzCDSrCrUJ2GzYB4kJXgFObJb+23Yskckh98mI6Gyu+IoRwVwvajmEh3HJMmAPEtnnfBO3J/1KMqrWAVYyis3GCRUe2y7JhafMXdx1/k=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(136003)(346002)(39830400003)(396003)(376002)(36840700001)(46966006)(36756003)(2906002)(36860700001)(86362001)(186003)(82310400003)(4326008)(966005)(81166007)(2616005)(1076003)(26005)(336012)(6666004)(70586007)(66574015)(47076005)(83380400001)(8676002)(8936002)(110136005)(42186006)(6266002)(5660300002)(478600001)(356005)(70206006)(316002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 20:37:12.1677
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcadf09a-8520-414a-528a-08d952077a7b
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT020.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6239
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch is to introduce a new CAN driver to support
the esd GmbH 402 family of CAN interface boards. The hardware design
is based on a CAN controller implemented in a FPGA attached to a
PCIe link.

More information on these boards can be found following the links
included in the commit message.

This patch supports all boards but will operate the CAN-FD capable
boards only in Classic-CAN mode. The CAN-FD support will be added
when the initial patch has stabilized.

The patch is based on the linux-can-next testing branch.

The patch is uses the previous work of my former colleague:
Link: https://lore.kernel.org/linux-can/1426592308-23817-1-git-send-email-thomas.koerper@esd.eu/

*Note*: scripts/checkpatch.pl still emits the following warnings:
1.esd402_pci.c:293: Still prints the non-hashed virtual address for
  debug purposes with pci_err(). This is done only on fatal
  initialization failure during modprobe and seems sensible in this
  case to debug the error. This will never occur in normal operation.
2.esdacc.h:269: The irq_cnt pointer is still declared volatile and
  this has a reason and is explained in detail in the header
  referencing the exception noted in volatile-considered-harmful.rst.

Stefan Mätje (1):
  can: esd: add support for esd GmbH PCIe/402 CAN interface family

 drivers/net/can/Kconfig          |   1 +
 drivers/net/can/Makefile         |   1 +
 drivers/net/can/esd/Kconfig      |  12 +
 drivers/net/can/esd/Makefile     |  11 +
 drivers/net/can/esd/esd402_pci.c | 531 +++++++++++++++++++++++
 drivers/net/can/esd/esdacc.c     | 717 +++++++++++++++++++++++++++++++
 drivers/net/can/esd/esdacc.h     | 394 +++++++++++++++++
 7 files changed, 1667 insertions(+)
 create mode 100644 drivers/net/can/esd/Kconfig
 create mode 100644 drivers/net/can/esd/Makefile
 create mode 100644 drivers/net/can/esd/esd402_pci.c
 create mode 100644 drivers/net/can/esd/esdacc.c
 create mode 100644 drivers/net/can/esd/esdacc.h


base-commit: 8dad5561c13ade87238d9de6dd410b43f7562447
-- 
2.25.1

