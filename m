Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5BE63FDBD
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 02:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiLBBjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 20:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiLBBjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 20:39:15 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2103.outbound.protection.outlook.com [40.107.20.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D098BAC18C;
        Thu,  1 Dec 2022 17:39:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1R1WGqk8BXpbAbDAjS9ZFQ5vuotgexPJahvSNVt1/qpTyt9xf3t6b1PLZifXl1EGvOtM/GU2c48xFSlHIl5QgkcAb4QSPHgJ0w12tbSWbwMZqojJx1xZHuKkZqbSyfrAlIO++1bIKSmwzj0BeiRO6p0b1oKEc4hsGoDN/kgNmo+agq84MDNR9nG4FdWcn8OzRW8WgxUQoHVO1+Rp/bZ4ectt1MLRfoBGxhRIMhw+DbM0tz58e0a4pCpU6B2+eu+Nn5j0Cr95G+G3xjWV1dHLUbimkkmyOOhgQc1K+GulG2EiwjErUugbO6W9xdwvC/FB6VOWMvi7v38kH4br5Ljjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJoAYcNKFCm7b556eHpPT1k1cw9+OaVPmJ0Hik2fn+s=;
 b=NLv5RLSCOyMF3s5zd1k/c8lnLkMm6QbJ1F/y8QAVGT8UvecPUlRHK7cw9HscdxE6xpvBJZ4JAES9Kuo6G1FA+HCSCejuvqkB052ps1JzphdPpbe8hXCaf7dSG1buOvc/fBRVX79v3xWxSNIIx6dOFCXK5rPxsIIa/BFwGs9lxi38bN0yeyAs50ucjvRZLgMUlRl7XQUtuuZ8h4u2XHEZRSgTIW8uwasl/mVHSEzSlAtrLF/ItD8mPJKq55txdjICTPW8tbPD6gBgkqaM4PeUi4VBOAvKk0sq75DWd0OvXMgNonkxVCNyBcSMbiCKASKjJB2/R27+R1mgMnXhqGTptw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJoAYcNKFCm7b556eHpPT1k1cw9+OaVPmJ0Hik2fn+s=;
 b=OOh9DlAXND8801Q4GJ7yck+8snWkotS32++9gv7tsdQnU6RCe477tWgFDZwB5Bx95qzM5z0yJswlN9mN7ksRUZBYcCuDhLlrKT1sEf+Q/3/CnGq1T5YTML8Diz8rHk4U+qTPwuFLNH+5I0po5Dd+DgoDjP4/hWBzbAZqhiAn9X4=
Received: from DU2PR04CA0028.eurprd04.prod.outlook.com (2603:10a6:10:3b::33)
 by AM0PR03MB6306.eurprd03.prod.outlook.com (2603:10a6:20b:158::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 2 Dec
 2022 01:39:09 +0000
Received: from DB8EUR06FT041.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:3b:cafe::26) by DU2PR04CA0028.outlook.office365.com
 (2603:10a6:10:3b::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Fri, 2 Dec 2022 01:39:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (81.14.233.218) by
 DB8EUR06FT041.mail.protection.outlook.com (10.233.252.190) with Microsoft
 SMTP Server id 15.20.5857.19 via Frontend Transport; Fri, 2 Dec 2022 01:39:09
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 685997C16C5;
        Wed, 30 Nov 2022 21:22:55 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 57C192F0711; Wed, 30 Nov 2022 21:22:55 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 0/1] can: esd_usb: Some preparation for supporting esd CAN-USB/3
Date:   Wed, 30 Nov 2022 21:22:41 +0100
Message-Id: <20221130202242.3998219-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR06FT041:EE_|AM0PR03MB6306:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 556da82f-0e40-420b-c8a0-08dad4060203
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pyVxGIaxyDeBZ/g8IfBPWe1GkzpCiWp/CRdDG+0LNeJdI3ACHWqtk7Ep/by7k2IGAovDOMlFyMrKjEnthXUQw6tmxHI3mDt+JJF3TdjDGIBV4F5EiOroc+vh4eSnOpzHEFrfhhK1f5qGWBiT8d/E1kC+5fUAYNE/HagkJvsG/vE1JHhVlJyHrPYm90qYrRB0dhuhQSBP2ANgUu7xiFQXqbLCDGPhMOciIweBrFwpZDnQeYqvoXmKNmLzfgjCyJdIr9/F12unBcZe5ClzQktk89Bq+0RQEuOUCiR9obBSdwTwwKxstEr+tZ16j9cl1IoJaYSjGjw9n7IQGK6LwpHlRXxgKR5WYZdzpmw+QP9pFIVGK5bXvnjMFnPS9LF3n4AwVii9mXUCVCMjTQjqg+8kduRf9hw33nJRtTmafeA8svcL6M4zBBMw6i8JZ7CfthvlKn8VBbHrmRX4fcoos+5JdvGdgBX6o4nRa7zLJSgfW0/nnmvcQffClL/0FaG5EwL4DL9LzDcdzRO7PuQ6kIbxv2wiVN/acPgGd+rnmGseKyGiI+MSi+E7x9at/IszI6kzAo61jwqJK8HHUrTda4NSREJLcf+CWhfkM2J7VNQVt1dQE5ttohfRcEYE19RJnIIBIcmAx0eY/qSX82BCeTbKYKW0MxLPMdLGVuWYuKQ7a0PXjqRC98qQxpz8E1gN+FzLtL4/nfpRty1YN8FRRufQCA==
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(13230022)(4636009)(396003)(39840400004)(136003)(346002)(376002)(451199015)(36840700001)(46966006)(86362001)(356005)(36860700001)(54906003)(81166007)(40480700001)(1076003)(82310400005)(4326008)(42186006)(70206006)(70586007)(110136005)(316002)(4744005)(966005)(5660300002)(47076005)(336012)(186003)(2906002)(8936002)(2616005)(6666004)(6266002)(8676002)(44832011)(41300700001)(26005)(478600001)(36756003);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 01:39:09.3947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 556da82f-0e40-420b-c8a0-08dad4060203
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT041.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB6306
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Being sucked into another higher prioritized project in the mid of
July, my work on preparations for adding support of the newly available
esd CAN-USB/3 to esd_usb.c came to a halt. Let's start again ...

Here is a attempt to resend a slightly overhauled and split
into two pieces version of my patch series from Fri, 8 Jul 2022.
Link to the patch series in July 2022:
https://lore.kernel.org/all/20220708181235.4104943-1-frank.jungclaus@esd.eu/

* Changelog *

v1 -> v2:
  * Added a "Fixes:" tag
  * Removed an unrelated indentation 
  * Link to v1: https://lore.kernel.org/all/20221124203806.3034897-1-frank.jungclaus@esd.eu/


Frank Jungclaus (1):
  can: esd_usb: Allow REC and TEC to return to zero

 drivers/net/can/usb/esd_usb.c | 6 ++++++
 1 file changed, 6 insertions(+)


base-commit: 3755b56a9b8ff8f1a6a21a979cc215c220401278
-- 
2.25.1

