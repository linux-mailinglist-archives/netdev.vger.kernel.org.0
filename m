Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F9E56C086
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238537AbiGHSOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238944AbiGHSOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:14:00 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60131.outbound.protection.outlook.com [40.107.6.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986642F387;
        Fri,  8 Jul 2022 11:13:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7dIb7c73rgKIgB7cvLeyLBBHh+A1c9FgWUKumjloxLzdWM3IIm6PFIoMwKrcjM6ue7KzzwPHvcwAMEjOqPk8mGP+u2HqpocO1/Ojo9wLUB75KZtxndOQXuky7if79ac70ckL14sJoT1mvJpCSae9NcjwuGgQEcvXX4MfSXPSQP7LkDRea0CBbYquIdLjxSxiaZghhPGmTzYZcZ+IGOBGnfBwxyhfJoh2Sc9c0sapCCfkM1sEaBFcLzYfDQYrapSxQv+OhoDLyWvA1q6HJOcTdkWyZ31UcR/jkCQDzPDu6KjI7hvOVLzg4QpXCDnxge5a0mqYxCKIih2tVtnH7LVng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4jA+jfjga+g2rsYzXr0HWDVe2gHV1BaPVJR1VGggHI=;
 b=NNQYkAU/O37FE1YgHGNslKP4qR50nmbQ62qj6Bj6apPVEDRZiCXu9oXl8oNIc+E5p+ZJFRgTDNg6uKnaO2TC+5BCmbJmrjvgnVJM2BALvxhIyIUB8loXVEwGYbzHiGxlLPpmm7TIpqMP+tid77jF8Nvph0jb3MfQrQSURxYOvh29YY9HPlCMnyUhds0dwPK+pQrWXfjYS9sYZg+o4ZTcsUHul/IPZazpbbJGdQDOeVFPmYLBAf/5f2ZLaUssHXNo+L5NBjO6k8OhMTYKuGdvv8WAEmfdjqot2Al5bn8agUfr9t8dbJ1pRk9YHq5DtV5p46dEhd9OVxUizTdJ/dfsWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4jA+jfjga+g2rsYzXr0HWDVe2gHV1BaPVJR1VGggHI=;
 b=C6paYrb+XhFrUsikstrLEzKZRUlfexWMEJx6Y8+eAvc0ph/X4p6RrubAScabvsmw0hDHJNKJiEDfwIRDmj2JJVIxnmLtdWH3k112s7PQOrE9GP9QAOzEeE5UAGRsr2PBOsLDsUhZWTrpczepwdjqMgP4EaxTeZlUZb84GLuV6bw=
Received: from FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:49::7) by
 VI1PR03MB3934.eurprd03.prod.outlook.com (2603:10a6:803:71::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.16; Fri, 8 Jul 2022 18:13:56 +0000
Received: from VI1EUR06FT019.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:49:cafe::4a) by FR0P281CA0059.outlook.office365.com
 (2603:10a6:d10:49::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.6 via Frontend
 Transport; Fri, 8 Jul 2022 18:13:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 VI1EUR06FT019.mail.protection.outlook.com (10.13.7.161) with Microsoft SMTP
 Server id 15.20.5417.15 via Frontend Transport; Fri, 8 Jul 2022 18:13:55
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 04E4C7C16CB;
        Fri,  8 Jul 2022 20:13:55 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 796F92E4AF8; Fri,  8 Jul 2022 20:13:54 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 6/6] can: esd_usb: Improved decoding for ESD_EV_CAN_ERROR_EXT messages
Date:   Fri,  8 Jul 2022 20:12:37 +0200
Message-Id: <20220708181235.4104943-7-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
References: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 54d9aca4-c4cf-4304-44b8-08da610d9f1e
X-MS-TrafficTypeDiagnostic: VI1PR03MB3934:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZY6poXmYbyOh7qfWvY3ypA/0pzNOinLmqZF3P4Ussn6bjZYIpp8C1w+6NzYwTQZsU6lYuR2XVHEJz8YIUJlV8+wuQbWT4WTMmbcyYLwCJBQNQMhwZjkaWWN8b86MVwpvQjB2J78jODx34mMz3xJMdEUVhqrQIDArUDSa47DZwHLcqrqkLRyUbm/BN/BrcD+XAwNhLa7HEq8e/RhCpIkIi8mOptu1XJhX+hez0k2oBH8APmqm49qrrDN88xIeEUqKMwiSvcaQf8jNrH60dyvBCCSNS9lUcRAe5aluOU4mqH9zbB+sl09X9rUzqjtzl/ckv0cW9cOnfck1XWEQVgrV8V/44rMk/hJrdW6kFbz3qgMe1K2WmBXRfoBTQYeAWCsSdiSVCZftbDg9wgHEfVH0iD2DEKRsMdZUEx2pAwLf+wxnIc8Ic4D5Zg+3uruCNWb50va18eYlKLc/dAkxHDuzfxzHbcpr2A7MIduBbFBAczW7vBSGEJ+J9XZYayEIB5EONmQeH39sBn/jYjgB+cPFaZE8g8V3yNA4BpXVJGj5/Bbm2tGbtL6NgA5tSnU0bhq7YoAeWnBODFfxevraqiRbnZJsij/eMOHcr2UfOP77JYEpmfHL+ymDPfnMmvLf/uI7we5izKcr4CHkzclcgixHMe2rhghAqVXoEDZXVl0JzrNndyQrzQzLczZRXCw4RSVtJN4+56f0MRLVZKsjRQ+QVZyT7GEbJV2bWSagOCx7fT2WsJw5OFtB3OSfZtsBRixAxrDoZv8CH20zPmReESYf/LAoJKWq6CTSKjOrWE/4qfk=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(136003)(346002)(39830400003)(36840700001)(46966006)(42186006)(81166007)(6666004)(356005)(83380400001)(478600001)(54906003)(316002)(86362001)(26005)(6266002)(41300700001)(186003)(36756003)(47076005)(110136005)(1076003)(2616005)(8676002)(8936002)(336012)(2906002)(4326008)(82310400005)(15650500001)(44832011)(5660300002)(70586007)(36860700001)(40480700001)(70206006);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 18:13:55.7439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d9aca4-c4cf-4304-44b8-08da610d9f1e
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT019.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB3934
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested by Vincent I spend a union plus a struct ev_can_err_ext
for easier decoding of an ESD_EV_CAN_ERROR_EXT event message (which
simply is a rx_msg with some dedicated data).

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 09649a45d6ff..2b149590720c 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -126,7 +126,15 @@ struct rx_msg {
 	u8 dlc;
 	__le32 ts;
 	__le32 id; /* upper 3 bits contain flags */
-	u8 data[8];
+	union {
+		u8 data[8];
+		struct {
+			u8 status; /* CAN Controller Status */
+			u8 ecc;    /* Error Capture Register */
+			u8 rec;    /* RX Error Counter */
+			u8 tec;    /* TX Error Counter */
+		} ev_can_err_ext;  /* For ESD_EV_CAN_ERROR_EXT */
+	};
 };
 
 struct tx_msg {
@@ -134,7 +142,7 @@ struct tx_msg {
 	u8 cmd;
 	u8 net;
 	u8 dlc;
-	u32 hnd;	/* opaque handle, not used by device */
+	u32 hnd;   /* opaque handle, not used by device */
 	__le32 id; /* upper 3 bits contain flags */
 	u8 data[8];
 };
@@ -228,11 +236,11 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 	u32 id = le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
 
 	if (id == ESD_EV_CAN_ERROR_EXT) {
-		u8 state = msg->msg.rx.data[0];
-		u8 ecc   = msg->msg.rx.data[1];
+		u8 state = msg->msg.rx.ev_can_err_ext.status;
+		u8 ecc   = msg->msg.rx.ev_can_err_ext.ecc;
 
-		priv->bec.rxerr = msg->msg.rx.data[2];
-		priv->bec.txerr = msg->msg.rx.data[3];
+		priv->bec.rxerr = msg->msg.rx.ev_can_err_ext.rec;
+		priv->bec.txerr = msg->msg.rx.ev_can_err_ext.tec;
 
 		netdev_dbg(priv->netdev,
 			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
-- 
2.25.1

