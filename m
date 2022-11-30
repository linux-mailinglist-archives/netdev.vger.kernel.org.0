Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFC863FDBA
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 02:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiLBBjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 20:39:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiLBBjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 20:39:13 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2122.outbound.protection.outlook.com [40.107.6.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34095AC18C;
        Thu,  1 Dec 2022 17:39:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vxj3WNXFdhpzjYZX2zH1xx1PK5wLgmZp8yXdy0fiUthg8pawFOGpBk4VjGlrbjC1X/dgWi8xODG/5niykI+tOHce55mT8TUbQSyYupfVnIpRmCFGAchWuspgU30dLhgOofy+ETyAS+RLYrhnbeFkMVQC7EZoz4hjBiIBstrkkbcOZjs/iO08r6oQ2dp74TrmPIesgWtVh3rAcy3H4QYnCccrJvLekzRMpnrzIwrsVR7tywXkFja4Re/3Z4L6NMZi2XMMmQ0Bcn6VmPDn+PimclAV9y5sVexApv3NCjm0H8ktJb1gb3MMG+5Feo/YQD4FRhWkH3vwE2LC+BL6gDHtHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xeIBgNnIBfXmmBPJg9pzvthB0fz0jCWPs/WQFH6jy8=;
 b=MMj815H3CQMjB3k3EUHUNimqnuZt31o7cOMk5kF9vwsQcWYt9/P+kVV4x7GV1zAuuP2OiQRoEQAUKRwfiPJBXKmKW9DXXAHpnkEXE7Tm9PvmY6EY5PnpObFIni9MjDddSYwOLcNZTLpL16mQYRETMxiItOqk4YvCodE48/K8USievpl+43AfhXP1JqWY0QK9gnUPPEkfJzEfWcaJoyc8r7MC4mGBP616FV3SEnBsgWScfeqmhLnLO/iwD2FzNaFmLfrVFMK7QJaNw+RaNKMBwauDEonIInLVvcMkepl8uVYtgdM79tBLvD4HABYzdV5sAoA4gGnlDca7nB4A+Luy3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xeIBgNnIBfXmmBPJg9pzvthB0fz0jCWPs/WQFH6jy8=;
 b=jPS74lmRzcBT8S8z8Mo0Q6kZwcBOonG2jd9bCpEGmSBKZS0BvQNTSqbPefXRrbFTEo4rSmHF/An9rLwz7KiKuWvMSdDGy2eh4YArkwCjRg40+URr9sjsgfIv+mCd8m5wY4m/BmjnAS4sFs2N4jkmE/riqdGQywtzIOkhX43WHuE=
Received: from FR3P281CA0075.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1f::23)
 by DU2PR03MB7973.eurprd03.prod.outlook.com (2603:10a6:10:2da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 2 Dec
 2022 01:39:09 +0000
Received: from VI1EUR06FT068.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:1f:cafe::60) by FR3P281CA0075.outlook.office365.com
 (2603:10a6:d10:1f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8 via Frontend
 Transport; Fri, 2 Dec 2022 01:39:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (81.14.233.218) by
 VI1EUR06FT068.mail.protection.outlook.com (10.13.7.50) with Microsoft SMTP
 Server id 15.20.5880.8 via Frontend Transport; Fri, 2 Dec 2022 01:39:09 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id C75077C16C8;
        Wed, 30 Nov 2022 21:22:58 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id BDCAE2F0711; Wed, 30 Nov 2022 21:22:58 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 1/1] can: esd_usb: Allow REC and TEC to return to zero
Date:   Wed, 30 Nov 2022 21:22:42 +0100
Message-Id: <20221130202242.3998219-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221130202242.3998219-1-frank.jungclaus@esd.eu>
References: <20221130202242.3998219-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT068:EE_|DU2PR03MB7973:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 42e280b0-5527-4432-43d6-08dad40601f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgu3cEdrIwIcZGu81UjI6lcb7vxkIPQkk17bKNVV6gM5Y32rRkS1n4NahriU5V41jf3tzKzzZ1cekl23hczGSBPDMmxKTkYAEgHqYXLXfAy/+1LnjB8k5y+zhSJXtwx5mD+e942RHcFxDCGUgnwhtOg+XRTFEM8VaMjEh+bFT+BrFjEdWS+V+RVKNPfkYvU9Nz2ii+37Ks0uaTU9fOtYpcofvdGIqgLkmFnfvtP9AxHME1WmZtzRFB+6Cuk8lr6znBv87s9xLErSapRihnqt+jvkzgIP/T3oKAj/D+7dYcEtbCcn/9Ra7pEDv90UXs90AC4gaSVAgAHMV/FGYfTWLpdSe24pBnMnNyD2E2Qz5sTkhAsge2/oOdMbBzfjKVkPnOMb+tl8sXLz8ERd6eDs+FYVsu3GHfi4cYmjmUIKCaLX9Y4kuPWk5GLeNakYOAvHq3UUR9eMe2YWarWfMDj6CkQ+CjJ+v4rdfeR+WzJTj/4mTjBZJbVphFL7AQ16jmhTJj7Ea4dpRgeJaysOYYcNflGqs+pkNW15066D+eO1Sv/eQMfmq+SgbOty5dI3+WzMt2yVgc3awu0I/rMUJ7Jk5d7EAyDt+5w9MTuR1GTEVGRLA9DoxB6UlW7WIcUvUOukkD9iRek8fg2Cu7r5ilr7cqpwwcLzaGhnuVGGhPN0OTo=
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(39840400004)(451199015)(36840700001)(46966006)(6666004)(40480700001)(36860700001)(82310400005)(26005)(2906002)(6266002)(81166007)(86362001)(44832011)(478600001)(5660300002)(110136005)(316002)(42186006)(54906003)(8936002)(36756003)(70586007)(70206006)(336012)(2616005)(8676002)(47076005)(356005)(1076003)(186003)(4326008)(41300700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 01:39:09.3505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e280b0-5527-4432-43d6-08dad40601f8
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT068.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR03MB7973
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

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 1bcfad11b1e4..acfc439a325c 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -234,6 +234,10 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
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

