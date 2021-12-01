Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED2B4658D3
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353329AbhLAWHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:07:20 -0500
Received: from mail-eopbgr80139.outbound.protection.outlook.com ([40.107.8.139]:47873
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343535AbhLAWGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 17:06:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lK2aboC9igY2QVHzV2UPJP9dcGSzAUF9aDLaT84Wt0Pm1vSemRnBdgVZ5h/h6TM3AHDZTj5VqTEoLJLWdpvfd06tCFS/VwQjG0g0vquRFl09bEn4/Fv7EEDnyWoZggqGHMZTC37y76ySYgxZMlTvHYhuSJ/1ZlWwxr9ZUfV4Ee8OL/KpaZ82VVEhuMdVwMzHcVy0vG/kF0qmyE+aPUB6eY3H0sxVRXi3f8ySzIj+5oAMXyklBBtQRg9h7bT0gy7E7Bsq7gt0m/xBwfAnUYOlkwbkYeTJpYzUuHQHSBF1hXUVQxfRuZdaualfJh9pRo5/ygiI44dJC/FeInsb1rHY2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g9TW7OTKhBtrASBm6oYT6ZGnRkBGmc+3dbddtTZ3Ygs=;
 b=YYgir2VPWjCn4DgRIVeTINccb+1viukZW7Slb+gud9bYNJ6eyyBiZvf2aRaaAXHb5deVjK2FE+wMeu0cgNqH3i0JreXzpuxulkCxLxf7mWzHa5NBOCgDHfIHMZ4+ZoR/pj9viRO4bCPZf49xCWyp4wO1bP1qefP08pRkgnh8nUU/KS5tWVvO3qhsLq3BrsTMvhD2qjSu9GWp1CoTqmhuy6ykCGStDv4hwAEvbfcyywST8ii3cgNf56V68YfGssni5nOfhZrbXX78x6XIFwxCbctdbdhLOElVZnnQoGb+b6iL4BYeT4LY/I71BU1xVqXmZTX5zpPvuJwOQ7vcA671ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=grandegger.com smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9TW7OTKhBtrASBm6oYT6ZGnRkBGmc+3dbddtTZ3Ygs=;
 b=ZCFV54MIivEc7btb84g9w6NU2fHqM8TWoB4kWTT9+lfhBAf3h0APz1KC3lopBO2a5YgOM62UGr35fsQMH3yjYWXx/J9ekH3FkuqLn3ZkhUCJ9T5n8Lj1ae+AHumFFgS4StHK/rZNdJBhQ0k3VTHTtJMv6VpARV12Nap0sn6N2o8=
Received: from DB6PR0601CA0032.eurprd06.prod.outlook.com (2603:10a6:4:17::18)
 by DBBPR03MB5158.eurprd03.prod.outlook.com (2603:10a6:10:df::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Wed, 1 Dec
 2021 22:03:29 +0000
Received: from DB8EUR06FT023.eop-eur06.prod.protection.outlook.com
 (2603:10a6:4:17:cafe::7b) by DB6PR0601CA0032.outlook.office365.com
 (2603:10a6:4:17::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend
 Transport; Wed, 1 Dec 2021 22:03:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd;
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT023.mail.protection.outlook.com (10.233.253.45) with Microsoft SMTP
 Server id 15.20.4755.13 via Frontend Transport; Wed, 1 Dec 2021 22:03:29
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id D22787C16CB;
        Wed,  1 Dec 2021 23:03:28 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2044)
        id 747E12E4543; Wed,  1 Dec 2021 23:03:28 +0100 (CET)
From:   =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] can: esd_402_pci: do not increase rx_bytes statistics for RTR frames
Date:   Wed,  1 Dec 2021 23:03:28 +0100
Message-Id: <20211201220328.3079270-5-stefan.maetje@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201220328.3079270-1-stefan.maetje@esd.eu>
References: <20211201220328.3079270-1-stefan.maetje@esd.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6336f2d-b09b-4978-df89-08d9b5166835
X-MS-TrafficTypeDiagnostic: DBBPR03MB5158:
X-Microsoft-Antispam-PRVS: <DBBPR03MB51587CA2A54E4DB6AD123D8581689@DBBPR03MB5158.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ip4kqN9gveoYbUwcMOnpfi5Liz3wsAviiScTwYKF+WMoxyQE64aixD4e2Y2xi5ToaGy4aqdZ/23DpHnDr4HC0GDinEiLCBaNOMYk0Op+pP9jL9kKV9byBknIV2i78Smt5lwtOA4yG/rSqAktybUUCVxd87oB2Ug+Mhuorh6bXjkQ8/n8pTZdISpH6ij9SiiX1xtKol9tkTg8gvAINExBYdpJ26u8Kxq2gbBiDv9WTdKHr5WDG7EcZzjimmIRuFKhHGEuYYCwrRQLMYr19x3E5IMLTS/sWLbDGlvuNslPJiChwp0akBibqpQ9K+5BoKOZTxFO3ID29IWQR33hMB4+zjIMd4TCZlvUOPf7eIiUOxCmn+JDhLKoTuUgMyZMeAeFv3PvTJ8Z5dgK8s/9p7z3/H6TTN6YAO4Tx51N8JSLEfva9hmVfytF0N8odo9oJ1HUFx6ogtDJ+LeZ8DGwZMFyjvvffkA40feLlDPSITI2I07EphcVW04/D4Uk35aRRe85yMbGTrkT+eoc1XMsPzL55EeLHXs032pWN4fohPtLaOsvQJfvXlTI93dhHaTyeKYAtWnDJfGHQ7z6I0oC3ZuNbge7Led1h+Pyq0NzMfe+5T8+DgFxRtXZEbopfYcyjeT37mg+IfHxIUYtVvivfI+hzZ8tgq/lcHwW8O6WG0m8MAZs7C9jrT6sGeZJQlQEtPRSCdJhfSjIsKT87Z4XAM1Nj+SFnsBA2zOJnUfp3/E2xB4=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(346002)(136003)(39830400003)(396003)(376002)(46966006)(36840700001)(5660300002)(2906002)(110136005)(356005)(1076003)(86362001)(40480700001)(81166007)(66574015)(8676002)(36860700001)(36756003)(316002)(42186006)(508600001)(47076005)(6266002)(8936002)(82310400004)(336012)(26005)(186003)(83380400001)(4326008)(70586007)(2616005)(70206006);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 22:03:29.0866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6336f2d-b09b-4978-df89-08d9b5166835
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT023.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5158
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The actual payload length of the CAN Remote Transmission Request (RTR)
frames is always 0, i.e. nothing is transmitted on the wire. However,
those RTR frames still use the DLC to indicate the length of the
requested frame.

As such, net_device_stats:rx_bytes should not be increased for the RTR
frames.

This patch brings the esd_402_pci driver in line with the other CAN
drivers which have been changed after a suggestion of Vincent Mailhol.

Suggested-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
---
 drivers/net/can/esd/esdacc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/esd/esdacc.c b/drivers/net/can/esd/esdacc.c
index f74248662cd6..99c1e1bdd72d 100644
--- a/drivers/net/can/esd/esdacc.c
+++ b/drivers/net/can/esd/esdacc.c
@@ -483,15 +483,16 @@ static void handle_core_msg_rxtxdone(struct acc_core *core,
 		can_frame_set_cc_len(cf, msg->dlc.rx.len & ACC_CAN_DLC_MASK,
 				     priv->can.ctrlmode);
 
-		if (msg->dlc.rx.len & ACC_CAN_RTR_FLAG)
+		if (msg->dlc.rx.len & ACC_CAN_RTR_FLAG) {
 			cf->can_id |= CAN_RTR_FLAG;
-		else
+		} else {
 			memcpy(cf->data, msg->data, cf->len);
+			stats->rx_bytes += cf->len;
+		}
+		stats->rx_packets++;
 
 		skb_hwtstamps(skb)->hwtstamp = acc_ts2ktime(priv->ov, msg->ts);
 
-		stats->rx_packets++;
-		stats->rx_bytes += cf->len;
 		netif_rx(skb);
 	}
 }
-- 
2.25.1

