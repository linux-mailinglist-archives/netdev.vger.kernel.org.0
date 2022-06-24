Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBC755A1A8
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 21:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiFXTF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 15:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiFXTFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 15:05:52 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50092.outbound.protection.outlook.com [40.107.5.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8167E81D85;
        Fri, 24 Jun 2022 12:05:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+DuJqUqOpwtsF1Pmo3axMPeBYbo2Xjv9yTwhSZmKhxlgQrLcrS6fLwX0Dvv1uGNG6kLa6Fbgexv8yH6IAqanbrLDIsWtNDZnCGo5boxInQvY+LhXMmSSqmrU3pOfCM9Jd7WC82mZlNC06s58+uUB9H6I8HWXWe5S5QFMHOEuluW9gBlqyP0XeAANGeUri/qIGvm8rYWQShtOEcS/6kYYygXWYddJ6vZtB3+2eFP0yXoU66d2m5ILvk0U2RCzjb46KDCVBOmclhhfmGp7ZMk60+AGoAdh/634oIL2aNqu5tuwbH96K3G/JDzCFEhFIFF9mzbE5+MTJIxERkb9lI4lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfP0tOz+7MWo/tXaqlT6yj+tKF2DtPYZb65U/lAP9n8=;
 b=IPtjDDxvuNQFd0hcQpU2ZxPIBZRJVAZdcnQMPfw7q7n1/r8FiruCZJsv6QIl/mRXbvnANAaQ1rOxk88W2Kn8p0SJWEXh4NaqZF8ovfFq+JeXjdO/H+jYIL1bisQQ//TSFKGWlRPYwqfvB0uT2/IYpvuPJFaB329NyWfAJyvGiQir40ayC6QVgTjhjvnLBShWZEEZRS1cZ9NJ8Ww6KExbImv7yFRbjW5YDzWkOdR4BUiEbMt8lyjVPYoF/6Te+fglg1TFcvzxKH3euh1AtoYCVx2rRhNYEavGuCCkYUVuB2h49kqK2ls6Lvbx2kFe0wvqee1gdcrm1qCpgvtO0ikEaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfP0tOz+7MWo/tXaqlT6yj+tKF2DtPYZb65U/lAP9n8=;
 b=VmythIqHPFjGbFDADUQ3I2fw7vT/7k+/bDi0Sux5edq6YVLSWkZsrQRqxLemiY1GAEm4LmMDQPSI/teIYwh/1DfygFXx2k10dwwdDZcuTbM+GBKMcGjU6yDWStMogHBChSrpfG7GxEo0kV8jbHkm4renGaU41j9k/IZF7ofISrc=
Received: from DB3PR06CA0011.eurprd06.prod.outlook.com (2603:10a6:8:1::24) by
 VI1PR03MB3951.eurprd03.prod.outlook.com (2603:10a6:803:6a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.15; Fri, 24 Jun 2022 19:05:48 +0000
Received: from DB8EUR06FT015.eop-eur06.prod.protection.outlook.com
 (2603:10a6:8:1:cafe::f9) by DB3PR06CA0011.outlook.office365.com
 (2603:10a6:8:1::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Fri, 24 Jun 2022 19:05:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT015.mail.protection.outlook.com (10.233.252.156) with Microsoft
 SMTP Server id 15.20.5373.15 via Frontend Transport; Fri, 24 Jun 2022
 19:05:47 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 80D1B7C16CB;
        Fri, 24 Jun 2022 21:05:47 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 69C602E4AF0; Fri, 24 Jun 2022 21:05:47 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 5/5] can/esd_usb: Update to copyright, M_AUTHOR and M_DESCRIPTION
Date:   Fri, 24 Jun 2022 21:05:19 +0200
Message-Id: <20220624190517.2299701-6-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624190517.2299701-1-frank.jungclaus@esd.eu>
References: <20220624190517.2299701-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: ecfae95f-22e1-4093-531a-08da56148c3d
X-MS-TrafficTypeDiagnostic: VI1PR03MB3951:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CntANY44iug4cVTLcRi/LtDTfQ4Xnv4sKVa0BmuPkrjDDjGm/nsXZ7CPQhs0ysqdn6KZlkfNXeL1LB1fPYOTa1QVnloo9uxDCiuK/jzgfhuBJH0sqjvhpwPD1Xkb2a6DCHf8b6/ju4szbQHDyop4RmR+7KQVnKPH+c5u9SnSyxC0BrEtZR3obH7L4Gp1Aob+QXWN9/ZTdXsleiss8WdHyeizkZZKYZcAAxAFaBChpsnlKllUaUSWjpHRUdeTNfZiB78HenrYq69RNjKsI6exx2Y/Vc+N4JlwVxETiG9rI8OGIMmKx7/sXKcC5gsD0yO51j9ryVJPPVP1RYvGk3vpgRiH9QHsR9qmksU7I7HUA0hc1wKyvskESpN0l+UWUzP4jbRCoBo1YuXfAnMIcRJvEzuZ+G07BC+5/AYnR2+ISFkVgY+xDAabsKjha7IXQ9c8H2XaQubo4SwfUWuN6yI7qlJXei57jRGJC3c/ZF1SjbQTXFqPAxHVOR4pZzJRNPX7FqsJWKuLfqgkkq93Z+kgWiSO5q8I/ebVAP+fZjN5eH9GApD9IsGLVatAuTt3j9QF5oNsrVdXisUtemXZl6fi8RcvM9lzDSe0kRAzZzbAH6p/Az9eARQFAoF8oV4SNEL206VNDtzXmOYXLCETzI1lHEc27ISqrg3R2TOZ/Dsihj5ayB1P00r5rT/J1/qJbeJCZ+BdQ9x4JSEFjRFGs15RaqeVz7ptHcSjuCU6cfEhXR/SsG7N3vcjNIrDzIzL/AgD5WgGfbXyRofG1LAnKVKMGg==
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(39830400003)(136003)(36840700001)(46966006)(15650500001)(41300700001)(86362001)(6266002)(8936002)(40480700001)(70586007)(316002)(42186006)(82310400005)(36756003)(2906002)(81166007)(70206006)(1076003)(110136005)(83380400001)(356005)(6666004)(5660300002)(336012)(8676002)(36860700001)(478600001)(47076005)(2616005)(44832011)(186003)(54906003)(26005)(4326008);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 19:05:47.7416
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecfae95f-22e1-4093-531a-08da56148c3d
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT015.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB3951
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Brought the copyright notice up to date
- Also regarding the changed company name from
esd electronic system design gmbh to esd electronics gmbh
- Using socketcan@esd.eu as a generic mail address for matthias who
left esd 6 years before
- Added a second MODULE_AUTHOR() for Frank Jungclaus

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index e23dce3db55a..8a4bf2961f3d 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * CAN driver for esd CAN-USB/2 and CAN-USB/Micro
+ * CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro
  *
- * Copyright (C) 2010-2012 Matthias Fuchs <matthias.fuchs@esd.eu>, esd gmbh
+ * Copyright (C) 2010-2012 esd electronic system design gmbh, Matthias Fuchs <socketcan@esd.eu>
+ * Copyright (C) 2022 esd electronics gmbh, Frank Jungclaus <frank.jungclaus@esd.eu>
  */
 #include <linux/signal.h>
 #include <linux/slab.h>
@@ -14,8 +15,9 @@
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
 
-MODULE_AUTHOR("Matthias Fuchs <matthias.fuchs@esd.eu>");
-MODULE_DESCRIPTION("CAN driver for esd CAN-USB/2 and CAN-USB/Micro interfaces");
+MODULE_AUTHOR("Matthias Fuchs <socketcan@esd.eu>");
+MODULE_AUTHOR("Frank Jungclaus <frank.jungclaus@esd.eu>");
+MODULE_DESCRIPTION("CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro interfaces");
 MODULE_LICENSE("GPL v2");
 
 /* USB vendor and product ID */
-- 
2.25.1

