Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B894940E6EE
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 19:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349319AbhIPR0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 13:26:37 -0400
Received: from mail-eopbgr80112.outbound.protection.outlook.com ([40.107.8.112]:24740
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348157AbhIPRXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 13:23:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6mAGG+iWRwDR2NUs0PJJuiXU6jJQMTmfFno0piTHZj5lNAoAMVqpvHE5QqTOTpXBUstvyabvZ+33mlbyF7QAg1cJ3znYRHqnELl0NhqQUn8lEGIBzKYQ6QV496cGvmH47dq65zTQKIuZ2nJgqFXTb5XjkAVimY1zOSzCcQWAKrFMzGpb3LM8f4zA1dVD5RGxGJ3oHwzu7CtkYXw9WcguL6UIB/jG1Df7gdQoJBYUD+C4gtX41nNS0H1eQ5Hw+h0/jx5mUfBn+wrcflC76gWWtTGy/HYOXeBI6a+M77JWKNcRkHI3MfDT/ohUHhy1VZwflP3p3LNw1j5kMg2ULLL0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=f54UZO95xXDyn9dkNPU5+hXtGxJCjtmLlgu3tk9Eolc=;
 b=AmUCC4ZrztsFAYyLsi4QlWLjKBcZipE+WfP4TaAcEqIru0rIyJ9uVi11p9mo62ABiEb08Y3Ui9nG7qH0AD6gGo36+U0yAvLppQXr2zRkxgJNgl/AfE8sigfkqQ3/nJ7KnRAoITzlDWOW/1zdtpqIbv4L3Z8ySPzEp3uQXLwGnGhRh2JN9L63WwvK3MFiwvEh1ugd86fnAbriN/q6cNAVw5VeH8ycbY7HmfNlctvHRfHAQaBjswVLAnLj/XM7lKVUWyH9h9wlaxb7iwt1tHV1FJZoHb1tCxxrl0YveHDGX0wH0GuMM9F/H1hsu05qcuMPRtBxEXSoYiIh3GDoqNL48A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f54UZO95xXDyn9dkNPU5+hXtGxJCjtmLlgu3tk9Eolc=;
 b=nMmDRLp7TvxPM7l+7M3Sd3C4Sr0ZOUTb3yLEwojbt5Nuv5NXfLu3Gde+D8+IjQiex5wzXCYwMtVLa+QZIZuWXK+qkkEGSaPQhZEU8gYAzOILUXwqSL4GlPEERw9OK8zhj2GU4xD/4/u3S7UPYNUzflBannFMSJS+qSlUN8loscw=
Received: from DB9PR05CA0007.eurprd05.prod.outlook.com (2603:10a6:10:1da::12)
 by DBAPR03MB6408.eurprd03.prod.outlook.com (2603:10a6:10:194::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Thu, 16 Sep
 2021 17:21:53 +0000
Received: from DB8EUR06FT061.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:1da:cafe::c6) by DB9PR05CA0007.outlook.office365.com
 (2603:10a6:10:1da::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Thu, 16 Sep 2021 17:21:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; grandegger.com; dkim=none (message not signed)
 header.d=none;grandegger.com; dmarc=bestguesspass action=none
 header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd;
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT061.mail.protection.outlook.com (10.233.253.209) with Microsoft
 SMTP Server id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021
 17:21:52 +0000
Received: from esd-s9.esd.local (unknown [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTP id 9A8967C16C5;
        Thu, 16 Sep 2021 19:21:52 +0200 (CEST)
Received: by esd-s9.esd.local (Postfix, from userid 2044)
        id 8723BE00E6; Thu, 16 Sep 2021 19:21:52 +0200 (CEST)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] =?UTF-8?q?MAINTAINERS:=20add=20Stefan=20M=C3=A4tje=20?= =?UTF-8?q?as=20maintainer=20for=20the=20esd=20electronics=20GmbH=20CAN=20?= =?UTF-8?q?drivers?=
Date:   Thu, 16 Sep 2021 19:21:51 +0200
Message-Id: <20210916172152.5127-2-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20210916172152.5127-1-stefan.maetje@esd.eu>
References: <20210916172152.5127-1-stefan.maetje@esd.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f52d6d0-b481-465b-830b-08d9793679eb
X-MS-TrafficTypeDiagnostic: DBAPR03MB6408:
X-Microsoft-Antispam-PRVS: <DBAPR03MB6408B0ABB3027D374CC1A17B81DC9@DBAPR03MB6408.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RiSOdP4uYZLPVcJJCGgPpJFySVja7xrQi40hNSn4jD+FOqmAxgYAXZFS+zSvM6i0cxVFvscokAcyyWpEIon0db7ToA2RPi9Q+CwfScDupNJ2acKpDWsk4vFHCn5vMFiXh+fsU9LrhwMoY5rM3kMGjKfyvePvFG7KuDjbH6rjrtHTXjldiCGLpRY16nMlpU1wsciVSCVPzL687uEpFmDLvwGju3kfjLRKVX3mm/Qxl6OauNkp0+kQ7UtCkk8FLXTcCEEzUVKGLrojlEPXguKJpIFV/jG8vDJZO0obBE6rDMIfHwUm4Dd1ZYCR5Wy7lgXoyDpzQaQVKgRenLwa3HCNV1L10mQcfFnRFewgBe9SNx8gJL/lNKxlyIDkfaUxbHxX7Rd4RlGcZl83sSgeniyMu1bNxC47bClaF6SBXDpNzcU5+7thr05DZgUTeM5JjnVIZMWpVq6U6umnHhHHXpKbszip9ORWHKoV17gv5DY6NDecGXMybJxhuDAUpE2l3N/5Wjd48nQAh7PWIt/ckWAIDcgz/XbYkMNiXFPcisixB4Yi0V+MghQOn2KnM2qxZe2tk/jY6+tzE4hNiOSXsidZxFZQZrEEF0IS0vYZ55yG6Pqa9ziW2o3qNo8XnNArQli1nl2sUOYLMLGL9Sm6qgXKW2tLG4GXJOOfCsUOr5Pi/4N72xjwfLWJMsbE54U2GBL1RLtvyL9TQcgd6uF6gwz14A==
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(39840400004)(346002)(376002)(396003)(136003)(36840700001)(46966006)(47076005)(42186006)(2616005)(4326008)(4744005)(316002)(82310400003)(8936002)(1076003)(6266002)(36756003)(86362001)(110136005)(478600001)(356005)(81166007)(26005)(336012)(186003)(2906002)(224303003)(5660300002)(70586007)(70206006)(36860700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 17:21:52.9179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f52d6d0-b481-465b-830b-08d9793679eb
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT061.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding myself (Stefan Mätje) as a maintainer for the esd_usb2.c the driver for the
CAN-USB/2 and CAN-USB/Micro.
Also for the upcoming driver for the PCIe/402 interface card family.

Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 06e39d3eba93..a2759872f1fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6900,6 +6900,14 @@ S:	Maintained
 F:	include/linux/errseq.h
 F:	lib/errseq.c
 
+ESD CAN NETWORK DRIVERS
+M:	Stefan Mätje <stefan.maetje@esd.eu>
+R:	socketcan@esd.eu
+L:	linux-can@vger.kernel.org
+S:	Maintained
+F:	drivers/net/can/esd/
+F:	drivers/net/can/usb/esd_usb2.c
+
 ET131X NETWORK DRIVER
 M:	Mark Einon <mark.einon@gmail.com>
 S:	Odd Fixes
-- 
2.25.1

