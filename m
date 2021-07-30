Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1813DBDD9
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhG3Rik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:38:40 -0400
Received: from mail-am6eur05on2095.outbound.protection.outlook.com ([40.107.22.95]:24736
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229773AbhG3Rii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:38:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUhjPsV4qnv7loCl7nNGr14XH/g4uoL9kHChZdEwf6yHFQHjzzLSnOdiWVdqCsXyoJOSKyH1MDaZXvuwun7Z/123dLEtUxSo+xCs+OxTtV7UvxbP6kmb0Zh/fg3d8xj18VRo5OxWxOyMYuTC59m2I5+BhVUu+sxVLttyuui/mnb/ikUfHqhT+6o/UbbYOIfPm08rEoUx55pF/cZtNZZWoxXsKBWP+hm7gAchg9Fk9s3Qod2nvYxlN+3i4ljfau7di5MmzzQDE+iJQduQQHM8NrFYIT6lY+foC6Hs9HbXTvFGir9vB1sbno9Z4AfT/oqi3wGSfWgIAvy7BYgZoFpouQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TacgoLGDSNUXO2egRONWhSyXH5HYcq9IcqHhTpnEgcg=;
 b=cSzF3gr+M6soSIgH4rPMEkuF4ApfyCxx7ZeE90OXDGjFOA+BdUncKn936cLHBybq3UhaicQbBkLsPY4QSASz7B4gKm/rDZIvaXqBK+EKIa3GpP+ZfHrmXa7mUYcJQQQ2RQuCPnS1cgxQG4tQH4TZ83/luG0HQgR07i2eeJruaknoNAJEvco2OxwNl+zW68uIN50irx3TnNWwMeibuxvCERw1BLGt+nrQnBZss1nUKXigY4aqpnZ5takER3i7p6j3RBejdppuoxYzw19GPkXYEAm6KSr1gm4LZkKJ6uxSWbdarACL04dw20uUg8y4ixNVt0OsKkQCHB9P8/qoz/LN5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TacgoLGDSNUXO2egRONWhSyXH5HYcq9IcqHhTpnEgcg=;
 b=geT9g8XdGZHpmoMLuNAxHu1ZBG9psEDbbDKg0Wr2Zbp1Ow4XStbQWgVc3X2mo9p4i92dFSZTxeK44ucWzkotVElfzey8BPzQICgceNSx3Zps/MNrb6mbzKFHBqNwgmRMhZiaDBddvR2bQ5LbFzDLP/7VYP5FBXgczUi9n2Oz9PA=
Received: from FR0P281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::18)
 by PA4PR03MB6814.eurprd03.prod.outlook.com (2603:10a6:102:f1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 30 Jul
 2021 17:38:29 +0000
Received: from VI1EUR06FT007.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:15:cafe::bf) by FR0P281CA0013.outlook.office365.com
 (2603:10a6:d10:15::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.11 via Frontend
 Transport; Fri, 30 Jul 2021 17:38:29 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 217.86.141.140) smtp.mailfrom=esd.eu; esd.eu; dkim=none (message not signed)
 header.d=none;esd.eu; dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 217.86.141.140 as permitted sender)
Received: from esd-s7.esd (217.86.141.140) by
 VI1EUR06FT007.mail.protection.outlook.com (10.13.6.219) with Microsoft SMTP
 Server id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 17:38:29
 +0000
Received: from esd-s9.esd.local (unknown [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTP id 20BEA7C1635;
        Fri, 30 Jul 2021 19:38:29 +0200 (CEST)
Received: by esd-s9.esd.local (Postfix, from userid 2044)
        id 0F9F1E00E4; Fri, 30 Jul 2021 19:38:29 +0200 (CEST)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>
Subject: [PATCH v2 0/1] can: esd: add support for esd GmbH PCIe/402 CAN interface family
Date:   Fri, 30 Jul 2021 19:38:04 +0200
Message-Id: <20210730173805.3926-1-Stefan.Maetje@esd.eu>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83625bf0-adaf-4675-d28c-08d95380d804
X-MS-TrafficTypeDiagnostic: PA4PR03MB6814:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PA4PR03MB6814099914CB6242FE0281E181EC9@PA4PR03MB6814.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6KIA0yHlbdVCfDJ44F4JFKISHwtuYkfRtA93orOnhmW0lE7pDFDxZ209YIHqyZjbWYbqSSfhV31eSYlnmovbpWxUmN5/Q1btDezW62COitXfkxtnpMIXww+1sYay571+mfuijW51KUuBy/QDGu4N8W0GpYGWjf/nUA4Lgwi9hBzLhj+lgA8ZUydvjzkAWv5IchXr8vf5BejDhD6VEVC0En6OtRoZNa+P8cHIH8uNhW7rUMJA2Dj5I+aR8evU1G22i/v+Bx15TSE8rHRpqyiUkWbX226i884t4x4jGlVWXs3CfLPVPJ5oxPZwdDx4wgSzahMe6yXKdDaqFxefFrRICXBMXR8Y85b/McPTz12VH+Cd245an/WU/IfyA6cF9K0Z6DU+SUEiId+F4X+U4jpMZryNipnVWAl91GsLawzn6vxbmncjxhXMWHc5TXu+kBH0f2jZp/d6VWg8idhE98M3y7WLbYwt4TEVoBG3o1Pf3aOrv/wcDyZ0q+H9b9FwkRbqeyRrcwWMUtLT+VYz6nnI1Bdbh9gVo1+L9OHN1ZSkg6WWiS/MAzyV9XuqpHpdwrg51ESe4esrYRNLWzVv/IDsmdtsGAPtfqjkZvb5k7W4kX+rFpaRgWTYJtWUAenUCXgLVZf1VdBf3JfHcvhA81YCIYI8DCFFcTqBWVromUA/sfOZEyuRnktcMlKadqC5R7L59soeKt8gFeOsM8wyWhEzrL2trx/Vuj1cEIMEA4Fqjpb+kbIn8XRSw1cfDwpMxke3SE+WGSsP0HyJu0V7Cp9p9/sHxwieIuaUTQ1uHj2cKDE=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(346002)(376002)(136003)(39830400003)(396003)(36840700001)(46966006)(356005)(70586007)(42186006)(478600001)(70206006)(66574015)(8676002)(336012)(6666004)(1076003)(2616005)(83380400001)(36860700001)(47076005)(82310400003)(81166007)(5660300002)(86362001)(966005)(8936002)(110136005)(316002)(4326008)(186003)(26005)(36756003)(6266002)(2906002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 17:38:29.3820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83625bf0-adaf-4675-d28c-08d95380d804
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT007.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB6814
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

Changes in v2:
- Avoid warning triggered by -Wshift-count-overflow on architectures
  with 32-bit dma_addr_t.
- Fixed Makefile not to build the kernel module always. Doing this
  renamed esd402_pci.c to esd_402_pci-core.c as recommended by Marc.

Stefan Mätje (1):
  can: esd: add support for esd GmbH PCIe/402 CAN interface family

 drivers/net/can/Kconfig                |   1 +
 drivers/net/can/Makefile               |   1 +
 drivers/net/can/esd/Kconfig            |  12 +
 drivers/net/can/esd/Makefile           |   7 +
 drivers/net/can/esd/esd_402_pci-core.c | 530 ++++++++++++++++++
 drivers/net/can/esd/esdacc.c           | 717 +++++++++++++++++++++++++
 drivers/net/can/esd/esdacc.h           | 394 ++++++++++++++
 7 files changed, 1662 insertions(+)
 create mode 100644 drivers/net/can/esd/Kconfig
 create mode 100644 drivers/net/can/esd/Makefile
 create mode 100644 drivers/net/can/esd/esd_402_pci-core.c
 create mode 100644 drivers/net/can/esd/esdacc.c
 create mode 100644 drivers/net/can/esd/esdacc.h


base-commit: 8dad5561c13ade87238d9de6dd410b43f7562447
-- 
2.25.1

