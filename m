Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3379B63803C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 21:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiKXUiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 15:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiKXUim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 15:38:42 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2106.outbound.protection.outlook.com [40.107.22.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13276F0F4;
        Thu, 24 Nov 2022 12:38:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdoteukILvGu4qqf69gxZiG+YYBxrWW7EC+8PwGPs/pFCmVqm/orc2v7U67pmXKARPFBRNoDSrKXSlMaVCf5SQVrEiOW40fYsOL93pUrjTJWCkmBYZcTB5JuQbDbV1dImwOrR8quUwZ0/+Fknn4cAKs/uPwcNc3zOpg+2kFqrB6cRAhng0Xz7t/6xZ+YgIZm+VIZR+iDut5UhYuWEd6PMMu3KVE0urt6CU0ApUo8iCrN2RkvvVI1vLKXR8YpDCIw55JozF4gDe6JCMzKSUwdYkimROWB2thyqpmMXshtedsvVi1s/MiLMycjIxDKDfr8fep5n7w/dD2TYM6JFxp3xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjcqDcce8YKwhBxZBlRV/JEQzOJP+0Ndd4nXaFrczi4=;
 b=gLnqqL+0kdZJYe+CYxTYS0MfANlWOPRjMLpu/buwJQv0tSZPNXzAWEotHyd5NOyAEH2RjklC61pRLlklJ8aYm92Lwa9W6RRFULwjZjIy5NxMsODVyEOVUizE/t24ZT01QyRcr99Ahao46AcCqzmls+r4skTK9NS2GGsKh2CKz9Y8LLwG5yDRn2lTfopP9+t2e7xLYtPRQVTc1ByhAgMfaTWMTPd7XAXoka9S8ic5/da2MP9WhoiW7YKJh99NBW9Bd2hHLNN5VDCsa2KVxRHIx3BHNSYdY2Ut6IkKQRxS9DeebFBH2CuAmE7qt8QcSbb2Ap+xlO8/SsshLQFmDbRhWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjcqDcce8YKwhBxZBlRV/JEQzOJP+0Ndd4nXaFrczi4=;
 b=KdU4Wvqg6vjB/GiiPzY2o+nrksyIuBdzY/UbeZ0tnd+7HlTpi0KEX4XB/3H0+CeD2n2ZNC152iuct6iCOtO8LBnWjwpHh90uQg3JtElr418L9taGtoh6CV9B1u4SQ3W/wwcppUWfjjN+712VUEQGlz5lcFR1j/EGS10yLCxX088=
Received: from AM5PR0101CA0007.eurprd01.prod.exchangelabs.com
 (2603:10a6:206:16::20) by AM9PR03MB7425.eurprd03.prod.outlook.com
 (2603:10a6:20b:260::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 20:38:34 +0000
Received: from AM7EUR06FT025.eop-eur06.prod.protection.outlook.com
 (2603:10a6:206:16:cafe::d8) by AM5PR0101CA0007.outlook.office365.com
 (2603:10a6:206:16::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 20:38:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (81.14.233.218) by
 AM7EUR06FT025.mail.protection.outlook.com (10.233.255.223) with Microsoft
 SMTP Server id 15.20.5834.8 via Frontend Transport; Thu, 24 Nov 2022 20:38:34
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 374057C16C5;
        Thu, 24 Nov 2022 21:38:34 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 2CF8C2F0710; Thu, 24 Nov 2022 21:38:34 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH RESEND 1/1] can: esd_usb: Allow REC and TEC to return to zero
Date:   Thu, 24 Nov 2022 21:38:06 +0100
Message-Id: <20221124203806.3034897-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221124203806.3034897-1-frank.jungclaus@esd.eu>
References: <20221124203806.3034897-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM7EUR06FT025:EE_|AM9PR03MB7425:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 6111c78b-67fd-4fb8-a20b-08dace5bdb60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3KoSnOM/6No9mwI6kWJLE9LSggsOoqEA3uLN6O9uMB4yb9Yj5Wj5XiVTvcRfxiIOBQUDOh7WtjMny4bFLnTjCt8Y9wTWmQ6l1JUQd6H7kNsJ7xMx/yLEBav+Em2bFU0C3ui2ClkydWui8v+PUzJ6dzc6Jl1+AHPC+6DLo1ZZ97emEmYHO16MhOCXV2znbLxawaZBhXeRMrMgZZJ8KKNHZhwh3TM6bPuBecDXkDM0Jai2SSflm+CbLEzZb7PW1AA0SSuZ0p3cbhQaCnXp4Q4kC1l0JwXaNrf8joyeTxR/RKeB4PGUCCUI5F6V22DcmGJSuJZIg7KZ1rPLjb/On1ErHfs2a7tLoys/HpFNbT2hgnELi1ZHIp9OryMf+7wCmz1cAsjAeyhPUXNKKIu6A3qnzLaw4wf0xKNQeFWnsLAWiB5W2pc3zTJ/xzU8WsLIefa1Dc1mzdJ6y+ifEX+sFt9TbV+mCBkPKDHrYEVtuL/2272S69o2OjOefPQzadkicNbhguF/1hBRQ75oxPSZV6i0h5FbpBExmrqssAqALe+JoKvVFHHyMcxv6PlpgiBOXsvE0L+GfiXNWPoAGzrUgqcOIj9zPuP7evmvfvcuTtqNnGYYBGhZpkLxE22cFXf+2TRL469Do0YXclahSRD+SrR4oML/CBh56I7+1Zgu0/XCzHM=
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39840400004)(376002)(451199015)(46966006)(36840700001)(44832011)(5660300002)(2906002)(356005)(81166007)(83380400001)(70586007)(36756003)(70206006)(8676002)(4326008)(110136005)(86362001)(54906003)(316002)(42186006)(8936002)(41300700001)(82310400005)(478600001)(40480700001)(6266002)(26005)(6666004)(2616005)(47076005)(36860700001)(1076003)(186003)(336012);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 20:38:34.3454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6111c78b-67fd-4fb8-a20b-08dace5bdb60
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR06FT025.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7425
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't get any further EVENT from an esd CAN USB device for changes
on REC or TEC while those counters converge to 0 (with ecc == 0).
So when handling the "Back to Error Active"-event force
txerr = rxerr = 0, otherwise the berr-counters might stay on
values like 95 forever ...

Also, to make life easier during the ongoing development a
netdev_dbg() has been introduced to allow dumping error events send by
an esd CAN USB device.

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 1bcfad11b1e4..da24c649aadd 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -230,10 +230,14 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->msg.rx.data[0];
-		u8 ecc = msg->msg.rx.data[1];
+		u8 ecc   = msg->msg.rx.data[1];
 		u8 rxerr = msg->msg.rx.data[2];
 		u8 txerr = msg->msg.rx.data[3];
 
+		netdev_dbg(priv->netdev,
+			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
+			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
+
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {
 			stats->rx_dropped++;
@@ -260,6 +264,8 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				break;
 			default:
 				priv->can.state = CAN_STATE_ERROR_ACTIVE;
+				txerr = 0;
+				rxerr = 0;
 				break;
 			}
 		} else {
-- 
2.25.1

