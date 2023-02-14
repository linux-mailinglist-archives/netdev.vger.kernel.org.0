Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2DE6968B8
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjBNQDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBNQDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:03:47 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2119.outbound.protection.outlook.com [40.107.105.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A502132;
        Tue, 14 Feb 2023 08:03:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmcNzuCm6Bry52pBstqhMeBsISyMBuXYUt9wHfK488l5FeP/2mllZIEJ/W+4EYQwCL3P+fSswbdMNQjBeTzlJsbu36zoUWvsU8umlYnCZRgVAJneinUax7ufAj9vF67aUPp/fYTJrkYuJBYeSVpvu8B1G2oNJYBABev+moQyN11ctumURDasvDZaMmjk6Lbo+ahGwDZSyHZFKNNs32eM81W5fiCNbAL2QGAxK2alHaWNng+M1eF46K42m+E/y2TVwzF7uvB3Qwz4qzMXMehFq9FnWjcvho/ofr7b4nPlWJL2WfCWpZbqus1Lf6IaqsuW/MI2RF6sJ8Om7fqXdMLvaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySpz1nlgcq/mVnqqCPG7zzsJF94xzgLeBnibFVWUUbs=;
 b=b/12WeyBJJ21Nj6OiH+zJ8E6vqAVnx5adWJYtyofhUcS7EeoE+8TVM1ImGbGaiH3qVktxwnYnmvJN5AiuecZ8SuJgiEaUG5DBGYiAvPj7eu4fobnvgXZ4nSRqKRaGJDmn0iaVOk1qKPcRzTn43QIFXYS+KuknDF7H8Jveh+/YiAb1n5QlNSd50tkl016Ie4H4u00gy+3e6ttw4C1EDom1EJDfWQX3Zu1v8nec0mDuFk0w80LCycBQ2yKcUZ9nfm084+SN2sAC3wh9ZW0HststRjAeS2nky7Z6uYMqOXJN4djxCjR8gjLxzaSjlipxXLVt8RZ0W4Y4UuHCiWayBWabw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySpz1nlgcq/mVnqqCPG7zzsJF94xzgLeBnibFVWUUbs=;
 b=iSs/czP2qlcXaPys0uLva5TJDgeubW8pKIKlKeeEeNInlfWFBKNTWEJczSxlN1/owdI3Gn90p+Idj9p6UPuI/34VFbjxVfArkPLmILLxt4UFiTgqwm5yyGVy/YIiKTMkc36wsLs7GjVIysD8mHfoCq7i8n7+0kn+me245k5AsxA=
Received: from AM5PR0701CA0022.eurprd07.prod.outlook.com
 (2603:10a6:203:51::32) by AS2PR03MB9049.eurprd03.prod.outlook.com
 (2603:10a6:20b:5f0::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Tue, 14 Feb
 2023 16:03:10 +0000
Received: from AM7EUR06FT049.eop-eur06.prod.protection.outlook.com
 (2603:10a6:203:51:cafe::8) by AM5PR0701CA0022.outlook.office365.com
 (2603:10a6:203:51::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10 via Frontend
 Transport; Tue, 14 Feb 2023 16:03:10 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 AM7EUR06FT049.mail.protection.outlook.com (10.233.255.201) with Microsoft
 SMTP Server id 15.20.6086.24 via Frontend Transport; Tue, 14 Feb 2023
 16:03:10 +0000
Received: from esd-s20.esd.local (jenkins.esd.local [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 6A8977C1635;
        Tue, 14 Feb 2023 17:03:10 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 5F1652E0125; Tue, 14 Feb 2023 17:03:10 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 1/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (1)
Date:   Tue, 14 Feb 2023 17:02:21 +0100
Message-Id: <20230214160223.1199464-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214160223.1199464-1-frank.jungclaus@esd.eu>
References: <20230214160223.1199464-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM7EUR06FT049:EE_|AS2PR03MB9049:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: f9121bc2-4c5f-4f9e-cee2-08db0ea4f856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cmFw5xy9Ua969J4Vv/9ezup/o4bzi7nHpbhoHlEKo5vqdSIsfVbFHRqRTdOjJGJbkKow4UkrlAVM740FfS3anJM/z5XedULvg6dVTZ5FHtAEfB/eoRaaCUJYhdY3Kz2QiZklc5Qg0mrReMGqaNvn7PPDuNEQAhJikBDV+n30eVLUEuRJ3JNdnDdD/vI5G9BqHiy+z9W5tUB6T9dWg6vCTpIGyIj4Zcl1jnhyrdU3jNZ8dmqeduiXxeCCFAIIBGc7FggSh5b6QdKNaFpyLjR2Mjm2dxjpvTLSZOwSvsWOlct/thezYYKt/K3al9eA0bMSn9vBtU7c6wUFs7sok//CJIc0mTJvHZNmhdjyViMeJ4OvgJxwXyZo7W42bTqUm7O8Z0WWYD9jr1x/KPnDVFmXeRrB4d04yk7cFQ2EPnh9eWlsQ9sFN5ClpDqsllboypmmEYfAgi/YkGpILOx/N3OswP47q40+O5TdMT9BZOy7tqXgkeo144/GIqzee6jK9RR30kuJXo5W+A0TJgvFR7O7ljeToiYIjlb9dUTCORveKp3Tn5ymmPKHSfZuxyBnICjebC9k/29zM1hI2+Mvb5I6j0SsOtUyfCInAaRIJPWUk49GJo985RocH9521GNWoxURdfvWtwYiD9gI1FtENm8eT/uPWDKcctwAEOVa/VmWYLU=
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39840400004)(451199018)(36840700001)(46966006)(36756003)(47076005)(2616005)(336012)(83380400001)(356005)(36860700001)(81166007)(82310400005)(40480700001)(186003)(8936002)(2906002)(41300700001)(44832011)(5660300002)(6666004)(6266002)(26005)(1076003)(8676002)(4326008)(316002)(86362001)(110136005)(42186006)(54906003)(70206006)(70586007)(478600001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:03:10.6139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9121bc2-4c5f-4f9e-cee2-08db0ea4f856
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR06FT049.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR03MB9049
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moved the supply for cf->data[3] (bit stream position of CAN error)
outside of the "switch (ecc & SJA1000_ECC_MASK){}"-statement, because
this position is independent of the error type.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 42323f5e6f3a..5e182fadd875 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -286,7 +286,6 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				cf->data[2] |= CAN_ERR_PROT_STUFF;
 				break;
 			default:
-				cf->data[3] = ecc & SJA1000_ECC_SEG;
 				break;
 			}
 
@@ -294,6 +293,9 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			if (!(ecc & SJA1000_ECC_DIR))
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
+			/* Bit stream position in CAN frame as the error was detected */
+			cf->data[3] = ecc & SJA1000_ECC_SEG;
+
 			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
 			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
 				cf->data[1] = (txerr > rxerr) ?
-- 
2.25.1

