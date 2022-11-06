Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67D361E6F2
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 23:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiKFWmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 17:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiKFWmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 17:42:01 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2105.outbound.protection.outlook.com [40.107.104.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A117DFCEF;
        Sun,  6 Nov 2022 14:41:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOSduaVGEO/ynGbMJkgAZbfi2NMjHH/QLUtDULYV5KcIjAyZHn6NtYWD1z66oCue5Z8QuhrELZGOAby9c1UORr079ai7inwgSKCeaQ+6/QAGo1ZPxG+m6IEJJbuOZTyIhxu3GSp7jNE5N1BiUcDYo0TX8EJqERUh1bfIdy87ZyoqsezZH47Fae6BPiBBwrd6lYTOaUne7XMBhHnO5klEeG4AT4dXkxat/P1SrR4F7LSGjvbcpa9v5+w/AHSPzXZUGpm+Ln0aVxhc7bvq7hvgrpyWJ92jBqW7iMRnUqbfu0f11Dt79zLCSHykmb9oQPvCFZ99MCafEw5UGWyicK4b2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gcZJIgz5T7DOqyb2aAmDbJW7zQWQJKJ/igShZg2QuVo=;
 b=D0T0lM6WUr60y9qy6fIiyJxnFyxoCUHfLZJOLUtWhIB2K7Nfh8ilziDde056HcNK1SxvmDkA+voDWs7/KG/iczJy10Q8X6ZqEwMn0mhHo6aYcw0wfHOTm2j/6/Yc3Cka1u5cug2l8aTjsfDNqb2+nShh2lVAI3L4HpFINFV9gle3t6OtCxHInP/xuRY9+uXEUMVZTInOX/XLIXdjZW/dUmqI91BrOMNNwUYZt0hjmaV8PC+Pd1XqLeTEMHFSqEh7/1q56wKbawc78SwHsi3r8yxx08+BwH8918ZEJw8PiWeR6tFWirxWhdr6N4uan0UG7okHh/dkSPMYAFYQp6ZnBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gcZJIgz5T7DOqyb2aAmDbJW7zQWQJKJ/igShZg2QuVo=;
 b=co9PG9DVWtvec7E9P3D8oC5OnUsZbuhLBp/WdFsuBToY7a+rOXVL3x/W400BJzE3E89l/3i37vn9qNPZK5ffs6ArQ3/Lupxxy+CTN4rIG5lwzNhoHHHiulxgwkmqOqzDWcRGP1OPdiPaScRIf3ih+TzzFbRr/6n/BVx/YpSgOrc=
Received: from AS9PR06CA0671.eurprd06.prod.outlook.com (2603:10a6:20b:49c::15)
 by AM7PR03MB6309.eurprd03.prod.outlook.com (2603:10a6:20b:131::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Sun, 6 Nov
 2022 22:41:57 +0000
Received: from VI1EUR06FT048.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:49c:cafe::3c) by AS9PR06CA0671.outlook.office365.com
 (2603:10a6:20b:49c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 22:41:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (81.14.233.218) by
 VI1EUR06FT048.mail.protection.outlook.com (10.13.6.110) with Microsoft SMTP
 Server id 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 22:41:56
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 6C7257C16C9;
        Sun,  6 Nov 2022 23:41:56 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2044)
        id 543ED2F00DA; Sun,  6 Nov 2022 23:41:56 +0100 (CET)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 1/2] =?UTF-8?q?MAINTAINERS:=20add=20Stefan=20M=C3=A4tje?= =?UTF-8?q?=20as=20maintainer=20for=20the=20esd=20electronics=20GmbH=20PCI?= =?UTF-8?q?e/402=20CAN=20drivers?=
Date:   Sun,  6 Nov 2022 23:41:55 +0100
Message-Id: <20221106224156.3619334-2-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221106224156.3619334-1-stefan.maetje@esd.eu>
References: <20221106224156.3619334-1-stefan.maetje@esd.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT048:EE_|AM7PR03MB6309:EE_
X-MS-Office365-Filtering-Correlation-Id: 80b7990c-e2c9-45f9-e7e2-08dac0481c2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nEPSHCMP9I8rwd4mHZxKjSpdxNouwo3qE7hjpIFJ9lbBWVwaPceS/taPinB9Rm1pRqchOF/9G9KsxvtuUEILJC5s59JEfXtXHc1Zkq6yUfyCLibCMJGNcs1LFHgFBSMpBpTjFzuz5Fgth//cK4DUZiF5HhrdDWbemD/Lz3lp1naQpzJKi9HdiC6SfN7GYaua4u76xnxfypLptRbDk/TmaNCUMpHwES3wwhyJjv0d1K2lrIJRc/zqegyJ0K59yXz+sumDGq4JkjiGIKOzG7k7N/k00PPYQKbmBLw8Fnbp562+er+DcRzP3u7/malU8q1Is4gHgcNz8B2elr6mcW0wCytY8sMPYNbFJQPW5ET2Rjc6CpiZgcsh04jHxymVIF0KXyy0V0PAla2Izm8ru9FlFpXwLYno2k1CFrb11j7169QfLZN5EmtHV2bcpfi+y3xtON+wr7JZni9tUpwz98SQbowudBQ1Do0hvVP8LT1w5xU1311WZcJmMkG5qy5hUgAUlZCjf4zU3RxUat2GGlYMslBJC6dORUFNGC+Fk5rct8J3VuZsLGqySSx9eJ7HkCS044pGrczphdVwOjNfRVoX0l0FDagUZE8MALd1Szxyk8ssEeIJTuUPfbLqSuKZgnRwykOl5jpDPoFO7eveRkxDx/5vbCTuPFqfUIRQeWzk8IKRVbta+U+SDH3OLYjgpM9Xn4R9nBXeVObpuXbApJmAouSUG8exezKAW+YkSCRcyy3kfPqVPBGSH1C9KOl4sDsZ
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39830400003)(451199015)(36840700001)(46966006)(82310400005)(36756003)(224303003)(4326008)(70206006)(70586007)(316002)(356005)(81166007)(5660300002)(40480700001)(41300700001)(8936002)(478600001)(110136005)(2906002)(42186006)(4744005)(26005)(6266002)(47076005)(2616005)(186003)(1076003)(336012)(36860700001)(86362001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 22:41:56.8423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b7990c-e2c9-45f9-e7e2-08dac0481c2e
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT048.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6309
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding myself (Stefan Mätje) as a maintainer for the upcoming driver of
the PCIe/402 interface card family.

Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 95fc5e1b4548..30128ded914a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7677,6 +7677,13 @@ L:	linux-can@vger.kernel.org
 S:	Maintained
 F:	drivers/net/can/usb/esd_usb.c
 
+ESD CAN NETWORK DRIVERS
+M:	Stefan Mätje <stefan.maetje@esd.eu>
+R:	socketcan@esd.eu
+L:	linux-can@vger.kernel.org
+S:	Maintained
+F:	drivers/net/can/esd/
+
 ET131X NETWORK DRIVER
 M:	Mark Einon <mark.einon@gmail.com>
 S:	Odd Fixes
-- 
2.25.1

