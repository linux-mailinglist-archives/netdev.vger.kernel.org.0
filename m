Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B654F6514E0
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 22:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbiLSV1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 16:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbiLSV1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 16:27:38 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2121.outbound.protection.outlook.com [40.107.6.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538BD13F09;
        Mon, 19 Dec 2022 13:27:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Na5J3SSkgqF1zrDNToJiSUQb8jusCRIniW2SVDT54vTIWgwimZ0RQJsp4nZHBSjp9k8IqeZ93YYTvikfyXP7/6LisryH2zRU0m7X/pLOCCCpSuccj9Wb4GiKrbKKVSQnSusykvFNkMMx8sW9iF0Psg7YcJyk/26Wa4rLiEN95Il9B8C5Kx2q26UVMwYJZK0KLwMWsJfShdjxmIJGEXEzWS5Gj/2RtgeztY43KQanc+ZmkHl4UnMH2EUeBA+5CO/imrfoAfMi1643JN0Cff8M+/snc7XdG5eOPV/3G+6qPp241LnuFIwbuNxjnVudbjXnfGQQgLuZDyP8jQjFgfs2RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLCrW5mNwfs26NWA4N8ao2qXw+YqsWSEuJb20hNJhys=;
 b=G00eFTZVIABnoR9jLYtA//K7D9S/VIuQ66+/0tdZykaEAP0x3+Okka2eS6SDhBjAo7tY76Vc+uj3Bkl7+wdJ6vX2AlProh6bMlAHM4AeIUCyrhv3AxgQEdkA1Iu3vhEblOnn8iSJIUPjK+Cio3A5u7jgKbtNXdEeLCvCm+OkI1HNFmwPi1S4r80xnW3r+m6H6c4zSUQzH1fcb/LBR2gfGrgGD3OJDks8iBcbXh+S0C2harl8Qbc8+eTqKPn3vhUlYbDPJ0C9d/bCIerTBxJVnVBljG+0IuQA3j+LFpWpuR4K/P8FJEEGYFov5bTz1DK6v1QemB/e85zkrypqj8EPGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLCrW5mNwfs26NWA4N8ao2qXw+YqsWSEuJb20hNJhys=;
 b=C5RMAIC4AjU4X0huCwI9A4TS7XGYzZqekXwCVOOyRo3bH9nOhGwYPdtGJcKlGh+8uE6Z5Mw6ZucOjKPZApLgVqHDLpv+pZgOIG2cM7oB9KlVqg2+1jqLPJoEbNCmISqLxYs/KoKRW++d8SXHyTrOSxQssgVnIl771IIUtZvRBY0=
Received: from DB6PR07CA0187.eurprd07.prod.outlook.com (2603:10a6:6:42::17) by
 GV1PR03MB8710.eurprd03.prod.outlook.com (2603:10a6:150:92::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.16; Mon, 19 Dec 2022 21:27:30 +0000
Received: from DB8EUR06FT007.eop-eur06.prod.protection.outlook.com
 (2603:10a6:6:42:cafe::ec) by DB6PR07CA0187.outlook.office365.com
 (2603:10a6:6:42::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.9 via Frontend
 Transport; Mon, 19 Dec 2022 21:27:29 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 DB8EUR06FT007.mail.protection.outlook.com (10.233.252.171) with Microsoft
 SMTP Server id 15.20.5924.16 via Frontend Transport; Mon, 19 Dec 2022
 21:27:28 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 64E347C16C8;
        Mon, 19 Dec 2022 22:27:28 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 5564B2E1DC1; Mon, 19 Dec 2022 22:27:28 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 2/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (2)
Date:   Mon, 19 Dec 2022 22:27:16 +0100
Message-Id: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR06FT007:EE_|GV1PR03MB8710:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: a0c61598-c893-4a4d-59fa-08dae207d4e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XpH2NmUmxbnpq67w3jmJUI5hKE3/OBt+8V5iROGekzJbq0krA6t8NFVQ//S8nzFa+QSYnnh+liz/n4TcDA76ySFEugRtJcLH8NoIulubrJuzCufoVbKUlqwC6rPBTB4ui+yeTs180eHJqHpkdyWXeJ8kujFQqnZ6PtlSqGbEv4KYmXPGPqF9tJMLzgXQZ37O9L6u9lSJuTGFMcaPyOh4AV4Kjv4qKQq/AZiWhUw86a7Rte+Gvj0tFORN2BkZmDH7Z1WLrjm/mosCj5TGLSw41HibUZKjuUzjMWtZFjLXFB9R1oI7KGJ+MhmzSw8ZFkbHZtuIJxlECKG5vHXjkIJts28G2Cw2NnVr7b0ckJpV5DwyDLZPydRQJxR03zKqZd0avEi52AhzM6WpC+BwPEDvcakIWery9q/s5ZjMONr5jWLusgntXlIlhvnSamfjgMlFy1z771PpmYVeQEA0Mk3vYjYOZsyj0dyuA7Up6Lt+06hRgtlby856fzvYD8WqCnmXa7H6ghO+Pf1wX5+peJfsdCFDNL63gPb8diO9BjTEUdvRg+Lwplzm79UNxojVmaWwzwarefWi+WOrhAObFPvDoEiZugL2PJMk2l8k50DuuR3ZnC7I1XMzIeePanmXsrOIz/QUBoU/2wAAqTF6v+k9dDXUu+ZRrqNfcibfHmm13cbzhed0exF4frZPOSVmXdBVohymZdDH9aO68qaAXOJnrg==
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39840400004)(376002)(136003)(451199015)(46966006)(36840700001)(70586007)(70206006)(86362001)(4326008)(8676002)(42186006)(316002)(36756003)(8936002)(5660300002)(2616005)(41300700001)(1076003)(82310400005)(6666004)(186003)(36860700001)(26005)(336012)(6266002)(47076005)(356005)(83380400001)(54906003)(40480700001)(81166007)(110136005)(478600001)(966005)(44832011)(2906002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 21:27:28.9767
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c61598-c893-4a4d-59fa-08dae207d4e6
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT007.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB8710
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Started a rework initiated by Vincents remarks "You should not report
the greatest of txerr and rxerr but the one which actually increased."
[1] and "As far as I understand, those flags should be set only when
the threshold is *reached*" [2] .

Now setting the flags for CAN_ERR_CRTL_[RT]X_WARNING and
CAN_ERR_CRTL_[RT]X_PASSIVE regarding REC and TEC, when the
appropriate threshold is reached.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Link: [1] https://lore.kernel.org/all/CAMZ6RqKGBWe15aMkf8-QLf-cOQg99GQBebSm+1wEzTqHgvmNuw@mail.gmail.com/
Link: [2] https://lore.kernel.org/all/CAMZ6Rq+QBO1yTX_o6GV0yhdBj-RzZSRGWDZBS0fs7zbSTy4hmA@mail.gmail.com/
---
 drivers/net/can/usb/esd_usb.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 5e182fadd875..09745751f168 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -255,10 +255,18 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				can_bus_off(priv->netdev);
 				break;
 			case ESD_BUSSTATE_WARN:
+				cf->can_id |= CAN_ERR_CRTL;
+				cf->data[1] = (txerr > rxerr) ?
+						CAN_ERR_CRTL_TX_WARNING :
+						CAN_ERR_CRTL_RX_WARNING;
 				priv->can.state = CAN_STATE_ERROR_WARNING;
 				priv->can.can_stats.error_warning++;
 				break;
 			case ESD_BUSSTATE_ERRPASSIVE:
+				cf->can_id |= CAN_ERR_CRTL;
+				cf->data[1] = (txerr > rxerr) ?
+						CAN_ERR_CRTL_TX_PASSIVE :
+						CAN_ERR_CRTL_RX_PASSIVE;
 				priv->can.state = CAN_STATE_ERROR_PASSIVE;
 				priv->can.can_stats.error_passive++;
 				break;
@@ -296,12 +304,6 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			/* Bit stream position in CAN frame as the error was detected */
 			cf->data[3] = ecc & SJA1000_ECC_SEG;
 
-			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
-			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
-				cf->data[1] = (txerr > rxerr) ?
-					CAN_ERR_CRTL_TX_PASSIVE :
-					CAN_ERR_CRTL_RX_PASSIVE;
-			}
 			cf->data[6] = txerr;
 			cf->data[7] = rxerr;
 		}
-- 
2.25.1

