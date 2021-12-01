Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA17F4658D0
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353293AbhLAWHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:07:15 -0500
Received: from mail-eopbgr40132.outbound.protection.outlook.com ([40.107.4.132]:33860
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353234AbhLAWGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 17:06:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U49Yo0G6MqbdlLDg9l7QISL3kTniAgmzvTwvRBOo9Lznfl2uGhxt3fmc701WSVgwgdSEQvZ3YR9i6VPIMiI4xpD6Uak3ISIimHj/BZVRKb+bhGQlpq0AOXFq3AKUX0N5e9KPOMNE8gkdN04pEUae52OR39mBpP5kauy4pUBTJ432NA61RTAvKPoW91vjekd8vNvcwwJpJQvJCKfiXGbG+ZukwPEot2EGtFyIxBWMFStlCyA4DZghWwpPiK3t0LBsKhyr/zKdVjkhzpf3D798nZZfedYrwZPOxK0oiHJmxe/VIwjEcGv9g/QYwETZcqcnhr7ty9pBd9voYvs2yXUy0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4PB0DFH1/CWZ2WhCB5JY/JeUEavOtsRe4BB47Qo4Lc=;
 b=M02+t1SSsNnq49ao8ToSh8P3qEXXctJsy7rwoACtJO7f8zlBjTj5RYlEK+yhQZglMjXzy15g461D451y0LNf5oB3jY+7LFxX7Kp12SymgIc+tjOYbRfRWK5udozRO4NapW/jyC6c1h8oE0PIfLp+KpwnKynsH9P9Myj+ej/9/bTWXV83ulziwDIo1L/NJTBGYbB6zhblObC6WwPlEBsdn5RL/Z315vMr73lv5Sal0kq12bwptDMg/uBBpg6YvymV4yE5DrFcfrtVJdDOReWYeybUnY0HgeD8jmdEjBt+v4Y8V3IXUDekBW1QgWsxWdI59izeUBRqsmvpY74lKlZMnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4PB0DFH1/CWZ2WhCB5JY/JeUEavOtsRe4BB47Qo4Lc=;
 b=FpnaJUcAypr9ROorGdOecKaHSmITvA0/1kUHXdvAQdUNpWN5J7bkTbPIgdYhs5mfQ69K0/pmjmqAXLeCd6u4TRinV1VOBuu+jBL869HRIR5A5YfIEDfuNk4qRgatuLRGA43s6Gwui3B5eqr9Yl89XS2+fSNaezMcK9Keo72ay3k=
Received: from DB9PR02CA0001.eurprd02.prod.outlook.com (2603:10a6:10:1d9::6)
 by AM0PR03MB3892.eurprd03.prod.outlook.com (2603:10a6:208:70::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 1 Dec
 2021 22:03:29 +0000
Received: from DB8EUR06FT016.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:1d9:cafe::10) by DB9PR02CA0001.outlook.office365.com
 (2603:10a6:10:1d9::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend
 Transport; Wed, 1 Dec 2021 22:03:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd;
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT016.mail.protection.outlook.com (10.233.252.98) with Microsoft SMTP
 Server id 15.20.4755.13 via Frontend Transport; Wed, 1 Dec 2021 22:03:29
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id CE3C47C16C5;
        Wed,  1 Dec 2021 23:03:28 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2044)
        id 6E0EB2E4540; Wed,  1 Dec 2021 23:03:28 +0100 (CET)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] =?UTF-8?q?MAINTAINERS:=20add=20Stefan=20M=C3=A4tje=20?= =?UTF-8?q?as=20maintainer=20for=20the=20esd=20electronics=20GmbH=20CAN=20?= =?UTF-8?q?drivers?=
Date:   Wed,  1 Dec 2021 23:03:25 +0100
Message-Id: <20211201220328.3079270-2-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201220328.3079270-1-stefan.maetje@esd.eu>
References: <20211201220328.3079270-1-stefan.maetje@esd.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7d51b5e-9678-4f1b-2c23-08d9b5166839
X-MS-TrafficTypeDiagnostic: AM0PR03MB3892:
X-Microsoft-Antispam-PRVS: <AM0PR03MB38922F83F354F38E39A1CDB981689@AM0PR03MB3892.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9zHAuSzZpll6Gx/gVA/NbCIa7KOqezbxBVepjHcFNCCb//VP4jd+LddwXM648KH+A30Vt127KyB1VifIxevnavdoKg0NWL9PNkEIAwq+mdKFDhLB2jsdcPfo0OD/l2WDJ9erjKYotE9+NNKr6mcvQtrx0B46mI86TKALRrJngiHzZozGXBy6IC8LtvzZj5B1ix0oJsJRBsJiICjMuv1xBAYhxcPhxnMO1+ZpuWDM3wQCs763JdIZTBT77iHML1dLaV36Gxgr8CfjqmVgQzmHiw0q3W4Ldd/wJzVi2gpeaUjebcbbLT9m+qnZkeLwAqjSLEpIVMGrQDbaWS/P3Z7ogPj+X2ZG9rNhBZHBtiCGkwJTCQhPmjqnkoJLqKKoAJlwT4Nxte/tSij1EAR0V3Adr9bS1i9Qfdd5yffNPm7eWyfciuvXyv1ixg/91Ud8DHepf0RNQiw1JMuH5y5XEnkkNyG7C15hx3zawdZ1Y/mpl8O3L8lUF6yIGHXYTYZEQd1pmRrvjJvzZx2icOIfEDiZi8XH+C6Etl7VbPJdPM+y4AX9q/xQh5CRciTRxB/SNQ+D8TrZao8vtYgJIUiikMXVvUb4L8Dgk0BgcfqOaigF0xm+bqw2On1FPLbssniytXbJIKI5T8arQRs3suhZBogXK7FZEFlLKKjpxt+y3a3DKN4urcwgNyCz69qrthtr7tzKKPFUAfzfZUqnqlIp/6+ndnGXL3HBeEcM/vF0kn50kE=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(376002)(39830400003)(346002)(396003)(136003)(36840700001)(46966006)(508600001)(2906002)(82310400004)(4744005)(2616005)(36756003)(8936002)(86362001)(5660300002)(356005)(81166007)(26005)(336012)(186003)(1076003)(36860700001)(70206006)(6266002)(70586007)(110136005)(6666004)(42186006)(316002)(47076005)(224303003)(4326008)(40480700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 22:03:29.0948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d51b5e-9678-4f1b-2c23-08d9b5166839
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT016.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB3892
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

