Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C9D3F7E09
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 00:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhHYVyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 17:54:09 -0400
Received: from mail-eopbgr00132.outbound.protection.outlook.com ([40.107.0.132]:48611
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229707AbhHYVyI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 17:54:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CH529VG7k0BXO5froUG9TyxAKLWvmC03QO4/ZMEcUEn+uP5DBn0v13ke0eVuJwyQz3A0P+x+oJ31MQHJnTi9mfpps/X59vw26Cl8K0HTYfj9mVRFf9FtNgT6zm/EV3qQlZddtDk8Q+FI60MB/87WUjY+bkimTPNCG3yTtp1xnwus2JkyPs6iIE4X8bVPhEH6jCTtR+R0XGaxn8gZwk5+Jl3ItObL7G6q4Aobt8Ssrpd+IA+WugS83BMGpfwRi4f8XFV2DcqEdw1pbbqT8hd1Zo9HDa5W8mlcVNhs3zck/iVwXqC1hMMKUtU4uHt6ay4dt2y8yWPfPPewCWRpX7FqlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5BtOpUdW+JaHWG5tH1USJRKSPORFjaePfcrEOGDsQGk=;
 b=Hj2+4r5Q/RprqZoGG+gi+oU6NIWm63tZrGQSQpqVAQ3FMLjTmGCNf16cXO+AeHXi1bKacsy/r3KkN0uiqylOFwLOPGdytbbFCnr74nv5QdUSlatGYtcktvimfWNtGflZwXLEo4fXvFhdQ5nOliKEJzON+lGFDPwAzizin+Ydoa6+Nez/DGtDb4svAQkCt2lIzba4vMBjrj3xF9+gO1UHX0Brttiw0IGxHJSJGNJgJ1wO3zEdcGIskeGlUc0bwZV2WLWcK8EjyHz9L/DCW1qniHG4EV0LRqdKJR46Z5hcIwncXhRHW+B1wtD3lKpnRPdC/wo4/in7rTWgkMK9qVyxiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5BtOpUdW+JaHWG5tH1USJRKSPORFjaePfcrEOGDsQGk=;
 b=Yt4KYwdQBtAoqHajB+cJWjR22o4UZpgh6TkBXn3dkiLTWEtpHJ/D/85ruGO+G7NcS2LGyaHlj8BrOw4aP9U2gU32FnEyFP9KP8FTqHMcl3Y3hJmD3jeArKdd+mMImzMmvR4T67UVnZ7rDAFAm/hC8PVYMOr/46MvJmfPlqBbw7c=
Received: from FR3P281CA0034.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::20)
 by AS8PR03MB7448.eurprd03.prod.outlook.com (2603:10a6:20b:293::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Wed, 25 Aug
 2021 21:53:20 +0000
Received: from VI1EUR06FT054.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:1c:cafe::cb) by FR3P281CA0034.outlook.office365.com
 (2603:10a6:d10:1c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend
 Transport; Wed, 25 Aug 2021 21:53:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; esd.eu; dkim=none (message not signed)
 header.d=none;esd.eu; dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd;
Received: from esd-s7.esd (81.14.233.218) by
 VI1EUR06FT054.mail.protection.outlook.com (10.13.6.124) with Microsoft SMTP
 Server id 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 21:53:19
 +0000
Received: from esd-s9.esd.local (unknown [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTP id 8BAB57C16C5;
        Wed, 25 Aug 2021 23:53:19 +0200 (CEST)
Received: by esd-s9.esd.local (Postfix, from userid 2044)
        id 889E3E00E4; Wed, 25 Aug 2021 23:53:19 +0200 (CEST)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
Subject: [PATCH 1/1] can: usb: esd_usb2: Fix the interchange of the CAN RX and TX error counters.
Date:   Wed, 25 Aug 2021 23:52:27 +0200
Message-Id: <20210825215227.4947-2-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20210825215227.4947-1-stefan.maetje@esd.eu>
References: <20210825215227.4947-1-stefan.maetje@esd.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6fd9878-3859-442a-228c-08d96812c086
X-MS-TrafficTypeDiagnostic: AS8PR03MB7448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8PR03MB74488E85AE1DEE799A2D108E81C69@AS8PR03MB7448.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4bKLPF7kR3hFQahmfKoUwR1Nm6TQeQqRWvtsHUJWQhCGcgjbEgaqUHCY8UyGjJCLSRFQnpQPy3fd9i/Ia+ATfCZZkqihnmdcIiF7R9JS1PzrdPru+YEHmG1DITbePae7dZbSQqG9hb9/wFTv7V4eCwxuwUTdJA/1aJ0F7ZGNH79IipuZfgvsgYnEhAciUhkKs5vtSpR/R6zVeAGnRVISJ1DC1qrDAgHvw1BwOpMcAKYW87wh6My9Rwpnl/yVWVjXYrQ188DLbaavurQl5+1W7IyT4xTlWFn9USmk4N115DFu330wxGj1W/xSYVyr2qfRBj6Ra0c1RGZMPTQ49KXepbC903YqKnpAjRFqZfjFtDkNtpOk1CTCAtWCahuHZwHfBI3exvSvXDD4P9ew44XTEn08BeLtiemzNLjhTrCoeoGFPyAlXm15QCoYQzKaEEFWv3Bpfj74AUCSBkaekh51ar/KmGct93Z6bHZAbWmPg0akv4OjKp5v5rW+iWzdbaXKFw+1FV0uJCbbyHLGOynSKJfyGyEIf3egfCIrgsnZlwrVjwgDJr7fMbGAzqymxlWMmluvds4TYP5yNGCmBwmp7jjqhAjQDKL6KE33Tg6fClaaNHHf2qaSDRj+FvM/Y7FVxLU1E1Rleuj/u6Hr+LIzLtbcteRnnIWEf3eID+2gMtBe/1NrFG/aBqmyCE3ey4uNjZAtzIV1lOI5BWbSj/B0dA==
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(39840400004)(376002)(346002)(136003)(396003)(46966006)(36840700001)(336012)(26005)(186003)(6266002)(86362001)(82310400003)(47076005)(36860700001)(83380400001)(1076003)(2616005)(2906002)(4744005)(4326008)(316002)(8936002)(8676002)(5660300002)(70206006)(36756003)(6666004)(42186006)(478600001)(6916009)(54906003)(356005)(70586007)(81166007);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 21:53:19.7462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6fd9878-3859-442a-228c-08d96812c086
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT054.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7448
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the interchanged fetch of the CAN RX and TX error counters
from the ESD_EV_CAN_ERROR_EXT message. The RX error counter is really in
struct rx_msg::data[2] and the TX error counter is in struct rx_msg::data[3].

Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
---
 drivers/net/can/usb/esd_usb2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 7370981e9b34..c6068a251fbe 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -224,8 +224,8 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->msg.rx.data[0];
 		u8 ecc = msg->msg.rx.data[1];
-		u8 txerr = msg->msg.rx.data[2];
-		u8 rxerr = msg->msg.rx.data[3];
+		u8 rxerr = msg->msg.rx.data[2];
+		u8 txerr = msg->msg.rx.data[3];
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {
-- 
2.25.1

