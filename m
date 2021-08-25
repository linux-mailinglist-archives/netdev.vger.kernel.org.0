Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE353F7E0A
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 00:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbhHYVyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 17:54:10 -0400
Received: from mail-vi1eur05on2109.outbound.protection.outlook.com ([40.107.21.109]:32225
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231448AbhHYVyI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 17:54:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kk4tsoRB0sD/MnGSvM8E/QZ9WmZLJHsL0Vg3sM52RSc73WgZzV2dIVDe+Lp15+fju0+bsSX751W5+rgrGNutWM/hfrXOqHpHLF6oxUoJXt0GvGnFjxA5oOMdJTDuTOk7cl0Lqps2lRGBBdK1kASgthtTCggBCbIlZGcSJxpPSVbhWKVggVD+rm4a7k7jWjHVkGdMTsMqMMVgYIQu0GEhkLaTtbcWzSXAP8l5H9VqUWIGEiO3iProqCK2spxkyDH0k7m9IwKh5vHoBspy/gqyn1B2e8m7Odde8KjXATLPur4Ky4Zf57W3xU8SiZvo0+reaLp6q0nodVLlkcc5lJLNxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSDaWf43DAYFho0p1d/p3bZFiQP5g9p3VX0DdwGDM9k=;
 b=QSWzazq6R7/XkSmhNwjTJgkyUJ7VFkE/bEkqFdbHezCDQ4iiCwdxVp1fCpbpnnL67InolJpuImdCxhegQlTkLOTmDUCJfr0NdmQDE2GyBoD7gzRggwMCNHer1zhlCPjC8Y55P7I23Ebex3VWPtTa4Mobp7R0CzioVhGQJT3ccJbmLk9CB56WFfZu1+8ScfsmM33lue1ioPtnFI3w7kdHt7P7KsPg5UlWXPj+sdHFSezBr+SCaeUEk8En/52G1o4EaZkFpF9FaPFC9sVh1g9wDxzNz4HXS2iDbJxXlYYjWzivtVAsGR2F4nhKxNxGWjMCY1zHYqXk22FyvHHSwD+tpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSDaWf43DAYFho0p1d/p3bZFiQP5g9p3VX0DdwGDM9k=;
 b=sIBT/XUQk42zb1z524pNp+rNRiR//BfzXYVmHfXNpE2WukmdzrV1MYRGimdtDEAW8slhZFgSCHOzdUwmFdwBWbRdPOSZa3KQc5MfnQwO3wQGaPpRijcePVX8/4gS1CPKAh3sY4/AJRHdybVhE5kYu39wgdZ5rycQOPUT2ygUOFg=
Received: from FR3P281CA0024.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::15)
 by DBBPR03MB5271.eurprd03.prod.outlook.com (2603:10a6:10:db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.23; Wed, 25 Aug
 2021 21:53:17 +0000
Received: from VI1EUR06FT054.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:1c:cafe::49) by FR3P281CA0024.outlook.office365.com
 (2603:10a6:d10:1c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.8 via Frontend
 Transport; Wed, 25 Aug 2021 21:53:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; esd.eu; dkim=none (message not signed)
 header.d=none;esd.eu; dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd;
Received: from esd-s7.esd (81.14.233.218) by
 VI1EUR06FT054.mail.protection.outlook.com (10.13.6.124) with Microsoft SMTP
 Server id 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 21:53:17
 +0000
Received: from esd-s9.esd.local (unknown [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTP id E5E977C16C5;
        Wed, 25 Aug 2021 23:53:16 +0200 (CEST)
Received: by esd-s9.esd.local (Postfix, from userid 2044)
        id B658DE00E4; Wed, 25 Aug 2021 23:53:16 +0200 (CEST)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
Subject: [PATCH 0/1] can: usb: esd_usb2: Fix the interchange of CAN TX and RX error counters
Date:   Wed, 25 Aug 2021 23:52:26 +0200
Message-Id: <20210825215227.4947-1-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d895c45-43a5-40cc-3c14-08d96812bf04
X-MS-TrafficTypeDiagnostic: DBBPR03MB5271:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR03MB5271F668B587586FE585E2AF81C69@DBBPR03MB5271.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vEsJ+tiBn1rx3JlfFGg3frgQ9tqelPFEGd07NrpIoEJzy4UMo7TTphv+eI7DvwwambJdsXhdiXCCQPSoqBynu8dhT6fV8gNe8lgcE2jLDkD+VMEO7e76BsYg38bvMbP29R/Bf70xzrQPXeREOG7xJbuuckX7JT1l/cIxML4Mx1c6R3EneN/gBP9eNDdX1ggScnhhhBCW0RQ1ROEiPRsbdy1fLskXBDHyd8Wzr90g3/Y6VqA7MXONq+gSm6L3FFM4YfayrWXEMiUC2wkAdthIxtOllQYsVRddCQakAthnttMlDuuyQEquLV3iLdB7UddsH2KgL95zxdKMSM12f7O6wJnnM5VGdQNC+DsI4RMTQw60D9GmzbTTH1WAwhcOtTNMsgGF63euTXRqVzp+DARz/2mKo2bsYX0PKxjpA+RmnrX++1jnklj6Ope2DieDxYvwHqJV0E0WWD+/XBPFdk+HMmCVXvcDb/WdzLQ2KyKcw/aHLjp4Iw7ABeF/QkqR2MHTJ7kIHh+sU9tWn5q2UOkTBXcssiZQLLlS6ln53SV2voi26GyGcq+n1wogZuJTfd1LBx5gxg7J84j2UYXYtrMd9Nl0xcbCzi9sfXLOo57dITOzafFHm9l/Jxbe2EwVp/SQYvPqMaEceE+mlX1Ev8oVGzhQ/6iM9jb0Up0T4TEoGGSQdjWvrdwm6deTxjR2aHWtrTLiP0su1jYOUckXvBVr6A==
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(46966006)(36840700001)(42186006)(8936002)(47076005)(2616005)(316002)(2906002)(81166007)(54906003)(70206006)(70586007)(83380400001)(6666004)(336012)(86362001)(8676002)(186003)(26005)(4744005)(66574015)(5660300002)(508600001)(36756003)(6916009)(4326008)(356005)(36860700001)(82310400003)(1076003)(6266002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 21:53:17.2102
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d895c45-43a5-40cc-3c14-08d96812bf04
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT054.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the driver for the esd CAN-USB/2 the CAN RX and TX error counters
were fetched interchanged from the ESD_EV_CAN_ERROR_EXT message and
therefore delivered wrong to the user.

To verify the now correct behavior call the candump tool to print CAN
error frames with extra infos (including CAN RX and TX error counters)
like "candump -e -x can4,0:0,#fffffffff".
Then send a CAN frame to the open (no other node) but terminated CAN
bus. The TX error counter must increase by 8 for each transmit attempt
until CAN_STATE_ERROR_PASSIVE is reached.

Stefan Mätje (1):
  can: usb: esd_usb2: Fix the interchange of the CAN RX and TX error
    counters.

 drivers/net/can/usb/esd_usb2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


base-commit: cbe8cd7d83e251bff134a57ea4b6378db992ad82
-- 
2.25.1

