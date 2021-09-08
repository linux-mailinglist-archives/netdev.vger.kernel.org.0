Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4FE403DCE
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 18:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352240AbhIHQrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 12:47:55 -0400
Received: from mail-db8eur05on2130.outbound.protection.outlook.com ([40.107.20.130]:10496
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235706AbhIHQrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 12:47:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPLUjajgyDpqcnX04nzvhZFuNSL0nxdMY2wxfju8lYEibF9mlnkRxI+MP2/BwAN3NXhauQDKa1VtF0UaANxP7nP9C12PtdLT8GJ7LV3GFUodf5coboZfFTh3Dei0tkuaMcvAcSmYXKi+UANjQQN1y8OoTFnsRggdNkPzEmGp7DyVzaAYc1F+SzHzPd1foW/a25AK9DebzzxaKqZgoeXR/vtvHWD86Y1so+Pv9kS8aw79n4uG7p90nI7dF9XRypM5th7WiurXWj2GSQa8q69alUq5W4DfhQ17vk83mywG1FPIhR3+eJk0kk99CqNv9SGo4CShHNbnG7o6hCaFY1Uscw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=f54UZO95xXDyn9dkNPU5+hXtGxJCjtmLlgu3tk9Eolc=;
 b=XEMq6M9vgUR0HnyZ2I/WBngXPj231MO8SF/VzTlYE8zWBm49RyoiKDgb4lokgzjfeC1D0wmM/C38sPxdZguteB9aRbGs7KtRw4MWyI862CH5NPnGSg5IeUiJd99ZldmuGG+zUpxN+AE2QsCpw2NwrtaaoG0oP2ggcigUiTkzf57ORd3mVwWywMXKJQZAkHvrNpr5V/c0rXLlDxadT5j9r18m95smRIQ79kW5YB7T4UzRjpO87W6V7GaEd77VY6DFjmwVDcwa8B5frptObR0lyK/tEYX+gnCWUmXotyZ6t3Z7oikWLThWsHlrKBQmPsusw6GiGM9CidZIswqiNKb5HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f54UZO95xXDyn9dkNPU5+hXtGxJCjtmLlgu3tk9Eolc=;
 b=B+fPkh4kUZHLAt30Kfvy1XEInC2nXBFiAY7NOT7rPcSoB/MgedtWV+KGkENFkxKEw12+ou9Pm95opAOommh9rnvuH9gVPhwXbSN/+eCCrp70XEtKRB4dYnq1v6IwTNyHe2aTgJm+Y93CB8VU9/hko7eQzanwacRJULwBIkF7ls8=
Received: from DB8P191CA0013.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::23)
 by AM0PR03MB5075.eurprd03.prod.outlook.com (2603:10a6:208:fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.24; Wed, 8 Sep
 2021 16:46:41 +0000
Received: from DB8EUR06FT017.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:130:cafe::1e) by DB8P191CA0013.outlook.office365.com
 (2603:10a6:10:130::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Wed, 8 Sep 2021 16:46:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; grandegger.com; dkim=none (message not signed)
 header.d=none;grandegger.com; dmarc=bestguesspass action=none
 header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd;
Received: from esd-s7.esd (81.14.233.218) by
 DB8EUR06FT017.mail.protection.outlook.com (10.233.252.113) with Microsoft
 SMTP Server id 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 16:46:41
 +0000
Received: from esd-s9.esd.local (unknown [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTP id BAE107C16C5;
        Wed,  8 Sep 2021 18:46:40 +0200 (CEST)
Received: by esd-s9.esd.local (Postfix, from userid 2044)
        id AB5F4E00E3; Wed,  8 Sep 2021 18:46:40 +0200 (CEST)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] =?UTF-8?q?MAINTAINERS:=20add=20Stefan=20M=C3=A4tje=20?= =?UTF-8?q?as=20maintainer=20for=20the=20esd=20electronics=20GmbH=20CAN=20?= =?UTF-8?q?drivers?=
Date:   Wed,  8 Sep 2021 18:46:39 +0200
Message-Id: <20210908164640.23243-2-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20210908164640.23243-1-stefan.maetje@esd.eu>
References: <20210908164640.23243-1-stefan.maetje@esd.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eab952fb-cb22-4e6f-24dd-08d972e83bd7
X-MS-TrafficTypeDiagnostic: AM0PR03MB5075:
X-Microsoft-Antispam-PRVS: <AM0PR03MB5075B2AE69507BF162E54F3881D49@AM0PR03MB5075.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yrERl3eVpxKUOGI7o4vksaaUYVpMyGbVPakD1RBHss402xBlOWnjY1pOuQ6vi1ALzutMfjxkjZPkX5BCCwQlyWHwX5TAsfPX3u6st4K1HiNMI8tYu7yo1wgg1H+s///54OeDoOWpw1/2lt8W4d7M5p9ays4PNkeUJPHDz0V8zgKVJrc/PwKYlnw3g7jwNATwwpBl/rLC1TBObvT7Bc8obIvQ9EQwG4rkSWreNcqStRNGkTzvj7P3tNMlqfdWlX6vQIBuBrW4kT3ZxcjhjE4BLzfG4UFCKIn/3UqrwjFqeoz0QxUapFSfHyAZuO8bn+Dcapmnjb1yjqe2KCoPXBxvVHfjeHMmOhrHNASNPsVgK7azJlsQCVlaQryPlPUJi8l+eIagFXjeRv31tyW8mlOLW2fImjaw/MODBTmll7fOS3wlPxYBiP3CGQ2tX0YXIkK5ahinC4m7UZRwZc1lsw30GM7Y3trPj5C2leQYr2ntM7KG1VwC8uouMLPYL4KiWd7GmknK6w5oIrQHsxXVpaf9BFdwKjNhIELlrJdpMuMqQqxCdDD1343e2uhs7z/Orj8Zsr3pAckN/dve3/TTjXhOP3XsDqkA01MfvQMtZ3o0ja1FKYHENRXWoyh6zJLKbEMR+F4S/CraqKzC8ybDY/rwL/m5Ll8ZBfq4/69Bm3AAg2FI9VuslXv8dSCsJNEOu9rorh5ZUf1QAKdNAn7loQd8EQ==
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(39830400003)(36840700001)(46966006)(8936002)(224303003)(6266002)(186003)(36756003)(26005)(5660300002)(478600001)(4744005)(2616005)(47076005)(36860700001)(1076003)(81166007)(356005)(70206006)(70586007)(110136005)(2906002)(42186006)(4326008)(316002)(82310400003)(336012)(86362001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 16:46:41.0321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eab952fb-cb22-4e6f-24dd-08d972e83bd7
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT017.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB5075
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

