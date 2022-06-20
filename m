Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949175525BF
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 22:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343768AbiFTU0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 16:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241309AbiFTU0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 16:26:09 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10115.outbound.protection.outlook.com [40.107.1.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AC815723;
        Mon, 20 Jun 2022 13:26:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EvU3gs25iaJIBOtY1yaD76AOQuTYFhDWVQ1NoAzvt+MnHrWoSjfP9m0ROH/x0C2nvbU4S6ZOsnIncKQ4B2skU9YA/+V3JaH0Wr/Tk3C8GuAA7fl6dwFr0X145OxUCTFz4jyw7z3HfWRHO/A3sIuq0vnQrBO3QOsqy87rMFTCxvKRgsnveu7HEsg6l9GtofCjPc3DlISJrmkvLJJgqeJPNhiaQ2M2MYwc5Kg9DcMVMOho/gtkdcKPRAjo3b6Zf90c4iw0io6uIBJQDP1ePCVGCUCCTAvKCyktD0yK1IYQvG2j/a6tveFZ/gKEY82EU8ytfopTR0NQcIORc+NSUjLm8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4uA/v23Bu0KPOCh7/O3oP8g6pWbIlOlfKkb9m9Dkc/U=;
 b=cCbJJMztjP9K/euqmEwE6tyCYceyJlool4U6pHCNE6YWuklatSpgwOUURyDMMTRjmHiQoq6UFXoqjDmQAwOBrkfS3WkYM7gumY7YnVEQSeG3Zi7Q/AKtqScGntAyVHEJuTr8+LlHr1Y4kHth/bSzXZm0/+tg2PC0gAZV/oez34KrLF6Oxjk+7ADfambOGij6Z7znm5kj1Is1AJulQL52TcQUOKQkFHr68eOzMK37mwvplHBip7vHe2nQ8c32huL09Nk9ru4b5U+2Frf4PDNEMieBztjq/2BTaElevQ5KP0PL/QwVx1kMNEmBnl/YQe4xjSUnITDLt4Rd8zkpOchh7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4uA/v23Bu0KPOCh7/O3oP8g6pWbIlOlfKkb9m9Dkc/U=;
 b=kdZBlkIHYBeI6AEgryxi8jGV29AaTq3SQ5Eu215EB2jYy5ll9qSaP0NBISLps9NYvFKNOyuIRnkXhMTOYIzHT6qFZ6isA9ZUOKuLjwqUce7bMuOkaa0Cps6lB2MbNjBUZt3Z/nYTQa098Jj+8oFF2TBzBjwaWxuh3U4bXMpZfJk=
Received: from DB8P191CA0012.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::22)
 by AM6PR03MB3896.eurprd03.prod.outlook.com (2603:10a6:20b:15::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Mon, 20 Jun
 2022 20:26:04 +0000
Received: from DB8EUR06FT055.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:130:cafe::59) by DB8P191CA0012.outlook.office365.com
 (2603:10a6:10:130::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 20:26:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT055.mail.protection.outlook.com (10.233.253.118) with Microsoft
 SMTP Server id 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022
 20:26:04 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id CDC387C16C5;
        Mon, 20 Jun 2022 22:26:03 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id A602D2E4AEC; Mon, 20 Jun 2022 22:26:03 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 0/1] can/esd_usb2: Added support for esd CAN-USB/3
Date:   Mon, 20 Jun 2022 22:26:02 +0200
Message-Id: <20220620202603.2069841-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 03ba111c-5b24-4679-a4f1-08da52fb1960
X-MS-TrafficTypeDiagnostic: AM6PR03MB3896:EE_
X-Microsoft-Antispam-PRVS: <AM6PR03MB3896ED303BF70B90CA0A18A196B09@AM6PR03MB3896.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KgMFI7jHlfltu/Lxntoe/F01vSvaXmYcN6P9MdNgbva3KPDMt727frBTIHVsSv8aYy9oi7hOXGo1G1C516Khm5DFTz0qtfvBGPNd5DPdBtwX+7pRkjiUxPkyOBpuZ7ztMdxvCo32fR4rMyRPCO7mNOxMORJyNYmltTuNpflldjsLEsRW8OeJ9/g0mx8uHy+aehP2puNM7GhxlOFxmXZYQdanaw8eFrAMARJxeb/z3gvTTNY7pVZkLCM0vCn4PfIn4C4b5AIDew3hLbICrwQiu5YsS01zwuqMetbTMA4bx1kz1Ys+WGylbHqcU841CqW+O9L6yHuszflhykUtW4ZQEun4d4J0TLFVvJ4z6d0fPnVslMc4bbWCuyq/r0sYp6KvH0pdqvR/bmvlQY//maJx59bKF+kZEo2OtkudRaIHZF5+oEwrv64uxlixHhouFWbteEShQcpgiWHnDQoHgCtaQr0MC3tr2Wxol49kedyKfH9Sm+ouDJDK7n2Qa7C9MdWUl1KqW+Nv8IovLNnXXjgcU2Vr8NWgZ8IRU9EEMhm2BXi+6X+W+ERNYH3A0I2sdiXYPMvpST5nA0iF20UEg7cO3fM6rVEZq+LokH6fI0SowlbAGc8uZs+Aku7XVd4tdlgPS1Is/sEMhaeeHnuTaRDVlLv4wds9f8T0qfve8QFg6adm3d8TkXNuVm2KQM425Qer
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39840400004)(396003)(376002)(36840700001)(46966006)(478600001)(26005)(41300700001)(36860700001)(6266002)(336012)(83380400001)(186003)(2616005)(1076003)(44832011)(47076005)(40480700001)(82310400005)(4744005)(5660300002)(70586007)(4326008)(8676002)(42186006)(8936002)(316002)(2906002)(110136005)(54906003)(356005)(70206006)(81166007)(86362001)(36756003);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 20:26:04.1285
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ba111c-5b24-4679-a4f1-08da52fb1960
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT055.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB3896
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the newly available esd CAN-USB/3.

The USB protocol for the CAN-USB/3 is similar to the protocol used
for the CAN-USB/2 and the CAN-USB/Micro, so most of the code can be
shared for all three platforms.
Due to the fact that the CAN-USB/3 additionally supports CAN FD
some new functionality / functions are introduced.
Each occurrence of the term "usb2" within variables, function names,
etc. is changed to "usb" where it is shared for all three platforms.

The patch has been tested against / should apply to Marc's 
current testing branch:
commit 934135149578 ("Merge branch 'document-polarfire-soc-can-controller'")

Frank Jungclaus (1):
  can/esd_usb2: Added support for esd CAN-USB/3

 drivers/net/can/usb/esd_usb2.c | 647 ++++++++++++++++++++++++---------
 1 file changed, 467 insertions(+), 180 deletions(-)

-- 
2.25.1
