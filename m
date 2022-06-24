Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02EE455A191
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 21:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiFXTFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 15:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiFXTFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 15:05:52 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2113.outbound.protection.outlook.com [40.107.20.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB37781C7A;
        Fri, 24 Jun 2022 12:05:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3HC9qOc+MRS3YhPvdtSlFBlh+JUoOiByp/KsCskw+N8ILwWocvN4hhjupbhzLQJhjDG2gBCcovlmltSjT18QxneRYCv/qKI7wtAT9z6qq/wGxmmAtdIeJyMyixGNaedZIXADCDaPLtLLpeOjbIAJzzyC3m+/oyrdmk5e27YVLLWDhtmQCXxfsozjGRhtsXPf6B5jbCTlmprQ/jXlOy1xNzB5JbRi3oBvKdfahM/95tI24rlaf9NVVQE9/O3nYHkZVFjsEHExV3T+nRY/D4aP34HUyGu/RJsUhfUvwSrtcpNHXcu36skC7TksuTpWs+LkNZ1T6N4j2Y7fQAw25lJtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYGGqdFT08GLVLbRwtArHUMEUhhoDoD7rGyzTCLggoY=;
 b=JePP4rMZ6lLvHY7VBQD6b72cLcqd766OzfJ1iaeypkGqF6X9cbqpF1WIwdCXUrvsTBqiXqFvJ8oEmkXhyjz415NP2cJpPAFhH9fH/3WTd1rlf2udCF/Z0eIAprOjuUmvdgtJmUNc1Uts0ybgyEBDpHgbvuuMvRbRYZgAq2aIG4xiR6YszSJIjO5OM5qQjpTs1UJmA76T5Yd5v9wiNZGjNeFiyqmvF7r4/MkkDrJVUY2QENfm14l3JApzz/fC/yiHTvzDMOg6un72KA7l+EtXT+GIP2B+enRlkDMrGP/9gNCeas2VqfF7AS4W2V7YF6sQ9wzLOsZ0Z9LWiApKK6o2Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYGGqdFT08GLVLbRwtArHUMEUhhoDoD7rGyzTCLggoY=;
 b=SfOSOaTv8suy96YrtrsiYDb/N+LP8F6cGy9rK/uS6j5ekiCtF20qbm9UsxQxl2yPxzCN+qWfEs5B0qMlYINgBBYDZQ3+2KIpL/DGv7Qdh1DCFqhohmrcIss7SO+57BircCu2Q911CUO3jO6blllGLAswkj2l6JAdl1LA+MpijIU=
Received: from AS8P250CA0009.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:330::14)
 by AS8PR03MB8665.eurprd03.prod.outlook.com (2603:10a6:20b:54b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 24 Jun
 2022 19:05:48 +0000
Received: from VI1EUR06FT049.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:330:cafe::e3) by AS8P250CA0009.outlook.office365.com
 (2603:10a6:20b:330::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17 via Frontend
 Transport; Fri, 24 Jun 2022 19:05:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 VI1EUR06FT049.mail.protection.outlook.com (10.13.6.72) with Microsoft SMTP
 Server id 15.20.5373.15 via Frontend Transport; Fri, 24 Jun 2022 19:05:47
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 613B67C16C5;
        Fri, 24 Jun 2022 21:05:47 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 56C6C2E4AF0; Fri, 24 Jun 2022 21:05:47 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 1/5] can/esd_usb2: Rename esd_usb2.c to esd_usb.c
Date:   Fri, 24 Jun 2022 21:05:15 +0200
Message-Id: <20220624190517.2299701-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624190517.2299701-1-frank.jungclaus@esd.eu>
References: <20220624190517.2299701-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 1cbde8bc-d1da-4611-df30-08da56148c31
X-MS-TrafficTypeDiagnostic: AS8PR03MB8665:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PJxWDWkZR5bztrH3q5JuQFT1ifUc8i/mdph5aTyVZSwGPdTeULQFX0UktykN6CO9WxS/hzqizrsTlTixVPkN0RkqTPGF13qyQWvbwKzwfrehuRS6KTV3htZAG8WRvhqsZTbBtvMww8P+n8D+8vwEaMyjO2PEs++XffdfXCdb+9M7rR6V4K8ZYRMh+2V1Dx8tbjDebLjVRZndGehy/zfG7fKxqCZBVXuS0y/tEsTj4kU0Rs3uYCXRxurpd4FtEn4OcX3Uqlriw7ui3KgSzxn8xKsauYyGRQIjb7MPFviLfP2aNL2FDi0D1jd/qfG4f9ZOGrE5QyGR7JZ6SHEiTrt22OKo+EXRUwa2UO9TDzw92XFcxulMI8Bv4oLJ5dK84Uq1Fc5n7Cc4ok5aFTO87geGNVxtji8XRF+T2+ycduuf1vUZIeeGshcew7tNa6eSj1PWFAqxIThP8d7G9cvO3h69x1lSnoX3KUhopEE2EGUTxcBL4N177qgro5wNLZUjGqXw3qVIGr2ac5DlHPLePCKvcAKXk8xS8FJvPSkYJ1mWHTsDOh3nk/uYUtnz8R93MN6gWQwF45N6MVs7bxw2vFOEa4Z8mVYoNfbRv5xOpwy3F1O61tbMJpA7tdK/4t8a6jwIDM/lJzSkwR9YPquHu00nDOk4+awbBCnpDz0PVWt5WLJnoIhE/kjy++7ZTdFt9X7SkSLGJoOcAnnGFk7CztRTsphjcjG+fgStCs+Dvdk4ySls9Wkqc3O7UM7kScviYFCWmeLxRXvthM0XpJ+fkq3JLT/scMVMXu63TqZMXhHWdLk=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(136003)(346002)(396003)(376002)(36840700001)(46966006)(8676002)(6666004)(40480700001)(5660300002)(4326008)(82310400005)(44832011)(86362001)(70586007)(356005)(70206006)(316002)(478600001)(1076003)(2616005)(2906002)(110136005)(8936002)(336012)(47076005)(42186006)(54906003)(186003)(36860700001)(36756003)(6266002)(81166007)(83380400001)(26005)(41300700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 19:05:47.6822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cbde8bc-d1da-4611-df30-08da56148c31
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT049.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB8665
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested by Vincent, renaming of esd_usb2.c to esd_usb.c
and according to that, adaption of Kconfig and Makfile, too.

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/Kconfig                   | 15 +++++++++++----
 drivers/net/can/usb/Makefile                  |  2 +-
 drivers/net/can/usb/{esd_usb2.c => esd_usb.c} |  0
 3 files changed, 12 insertions(+), 5 deletions(-)
 rename drivers/net/can/usb/{esd_usb2.c => esd_usb.c} (100%)

diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index f959215c9d53..1218f9642f33 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -14,11 +14,18 @@ config CAN_EMS_USB
 	  This driver is for the one channel CPC-USB/ARM7 CAN/USB interface
 	  from EMS Dr. Thomas Wuensche (http://www.ems-wuensche.de).
 
-config CAN_ESD_USB2
-	tristate "ESD USB/2 CAN/USB interface"
+config CAN_ESD_USB
+	tristate "esd electronics gmbh CAN/USB interfaces"
 	help
-	  This driver supports the CAN-USB/2 interface
-	  from esd electronic system design gmbh (http://www.esd.eu).
+	  This driver adds supports for several CAN/USB interfaces
+	  from esd electronics gmbh (https://www.esd.eu).
+
+	  The drivers supports the following devices:
+	    - esd CAN-USB/2
+	    - esd CAN-USB/Micro
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called esd_usb.
 
 config CAN_ETAS_ES58X
 	tristate "ETAS ES58X CAN/USB interfaces"
diff --git a/drivers/net/can/usb/Makefile b/drivers/net/can/usb/Makefile
index 748cf31a0d53..1ea16be5743b 100644
--- a/drivers/net/can/usb/Makefile
+++ b/drivers/net/can/usb/Makefile
@@ -5,7 +5,7 @@
 
 obj-$(CONFIG_CAN_8DEV_USB) += usb_8dev.o
 obj-$(CONFIG_CAN_EMS_USB) += ems_usb.o
-obj-$(CONFIG_CAN_ESD_USB2) += esd_usb2.o
+obj-$(CONFIG_CAN_ESD_USB) += esd_usb.o
 obj-$(CONFIG_CAN_ETAS_ES58X) += etas_es58x/
 obj-$(CONFIG_CAN_GS_USB) += gs_usb.o
 obj-$(CONFIG_CAN_KVASER_USB) += kvaser_usb/
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb.c
similarity index 100%
rename from drivers/net/can/usb/esd_usb2.c
rename to drivers/net/can/usb/esd_usb.c
-- 
2.25.1

