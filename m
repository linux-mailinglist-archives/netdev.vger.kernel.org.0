Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F8944B0B6
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 16:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbhKIP4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 10:56:16 -0500
Received: from mail-eopbgr30120.outbound.protection.outlook.com ([40.107.3.120]:64654
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239110AbhKIP4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 10:56:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCShWEGGAiMkNp1cnIlLJHWeFT+Xm/wRaFkm95OLbHlSzYOXDbznN7HPP8nlFuPY9LpgnIZviKIXVROVpBFzblYtCSDv+x+uTSQ/wjGFFodJaA/Wcsv+K3tizGGjbugCD1dUekyRogiQODd2ctHy9ujsvrNoP3iyvARSwBPNT7HQRXOmfoUb5LWFVVd3OuRpa7Y0Yl8AE9uqk78muMZOo7JLOa0HFVqEpc+BKbC8J5GyoIL1MBprh0Njb5UKeamoUYDe54h9Pcftd2+uP62FoV+3vzq8DqQYzKFAAZRw23Ft35KZ9Kty7MTySiK0MwCz6tk6jsnH4n5phLE652S44A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4PB0DFH1/CWZ2WhCB5JY/JeUEavOtsRe4BB47Qo4Lc=;
 b=j6P/b8PTB2E3f7MJBe8IHDrTi17ipamcZz8QqvTpYTfbIJ8AYq4cy739YKIn6O4FuigEKAbkVMui0D3xmDcNcdMWtw35vfi2TVRqcu92NxCPav124qMKITacthp66V/ujTKCPwyWGzPTY9cydNJgurRzisBSLVm96/WSJ8sZ0w8w+VDzV7+2I6vWptVBUgYRy8vTj/tFdg7cnqCz+T8W6WaCbJtD4zh4Szr1U6O23uGGjpZ/BXU7s7SHxbmJ6c9NAeS3rxGyN95uCD1GG53j5s6jwhI7/xGC9YOIRiAFGCe7P/UlUd9CPmV9VIUBAjQVB+TBCp3i4X/BAsaKH9st6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4PB0DFH1/CWZ2WhCB5JY/JeUEavOtsRe4BB47Qo4Lc=;
 b=YuHDdprNIKtRmyS72+/bCf22J/34S9cLZEZlIEhMGE4l+5lvLkG9tK9AylLMlhMWaoWWJb81RtC89OVVvg/a3qGM2niayHnrjMFeNp3Lky0xF12gGHDyQbZR+CM41LR3FXTTj8WRiCTgwxOBsnOTCDjhJvam8/fl6b3sEhTFu2U=
Received: from DB9PR02CA0005.eurprd02.prod.outlook.com (2603:10a6:10:1d9::10)
 by PR3PR03MB6554.eurprd03.prod.outlook.com (2603:10a6:102:76::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 15:53:26 +0000
Received: from DB8EUR06FT022.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:1d9:cafe::5f) by DB9PR02CA0005.outlook.office365.com
 (2603:10a6:10:1d9::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend
 Transport; Tue, 9 Nov 2021 15:53:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd;
Received: from esd-s7.esd (81.14.233.218) by
 DB8EUR06FT022.mail.protection.outlook.com (10.233.253.31) with Microsoft SMTP
 Server id 15.20.4669.11 via Frontend Transport; Tue, 9 Nov 2021 15:53:26
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 52F717C16C5;
        Tue,  9 Nov 2021 16:53:26 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2044)
        id 4504C2E0193; Tue,  9 Nov 2021 16:53:26 +0100 (CET)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] =?UTF-8?q?MAINTAINERS:=20add=20Stefan=20M=C3=A4tje=20?= =?UTF-8?q?as=20maintainer=20for=20the=20esd=20electronics=20GmbH=20CAN=20?= =?UTF-8?q?drivers?=
Date:   Tue,  9 Nov 2021 16:53:25 +0100
Message-Id: <20211109155326.2608822-2-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211109155326.2608822-1-stefan.maetje@esd.eu>
References: <20211109155326.2608822-1-stefan.maetje@esd.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61befb30-d4bd-4f76-781b-08d9a399115d
X-MS-TrafficTypeDiagnostic: PR3PR03MB6554:
X-Microsoft-Antispam-PRVS: <PR3PR03MB6554ACDF9802FD30827FC9ED81929@PR3PR03MB6554.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8jj4wmsyhN886YruHrDBkALqeTR0QNQiY8Ojf+I+fCuaphi9YGOEKX4VlhuPmQI++5r6QBu8kkzVCzh1g8LTVkk83rsHBgj//bXXjq2/G0QqN11QaNGaIABL5dLwTUndV/OpSSA88DwYGFg7BQ6e5dfgLnCDRqAJ9Z+9KTp53vEJ/WlGyBDctzXOXm9AJKICIJ5LDUhCjdPE27REVhYV/2fTPj2elXJiuc2uaI73LKBV+DeNmhqaml5cRbfbKGTYaHKar9ij5LviV9zBDiChMv8mrTEqeOBOy1AY1kTpQEsZ5Uaiv8RKoTiw0Lrm9Esvf592b9uEzizZO2dX/seIQodOnOnDPNsxrU8R1pDEqieXOdm6xB8YU4InHQhNVHPSekXkReKhwdJweyJNUT1xMQwIj0bZ4mZ+w4OJK7OTtto77R+IvM7dml4rx41RWcgDzvkFtvbXVD0SBxJ1Ox5+56yzpxGXCK5aHsTlDzV5dj6iyIwaQ4Ygpd6u0txV2LbymXXxfglgSShJl0jEVLv/saOshZTeqP7DQeeZANaI0nJnmH92XxHZikPD+9H/t+NXSAl+1K/Aq+L0zLzm8Y9T2K5iWrlQOCJiuNBLNyAY4LDFe7gIkErp1u/X1m+6JU1V2T1obi5m/zR1zBzMrSvx9OzglCeBvd/+TnXDQYVJ6YMskppUNGihnEo5QDSwynm8gQd7/nXCuK7XnRRuSI5j0A==
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(136003)(39840400004)(346002)(376002)(396003)(36840700001)(46966006)(2906002)(110136005)(8936002)(42186006)(186003)(6266002)(316002)(47076005)(70206006)(336012)(356005)(4744005)(70586007)(2616005)(508600001)(82310400003)(86362001)(36860700001)(26005)(81166007)(224303003)(5660300002)(4326008)(1076003)(36756003);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 15:53:26.5238
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61befb30-d4bd-4f76-781b-08d9a399115d
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT022.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6554
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
index 975086c5345d..1cd23dcbdd8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6980,6 +6980,14 @@ S:	Maintained
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

