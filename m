Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F186C56BF86
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239092AbiGHSOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239057AbiGHSOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:14:06 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2091.outbound.protection.outlook.com [40.107.22.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DC233E09;
        Fri,  8 Jul 2022 11:14:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c36j7nF5MfZ0EZIoCTgCIJISnGdQl9e/lDna6FPJwS/71+Cdkjwwt0wnpQmHaVGneXK8DREl6afOAgyMv/a0M3U11REp0f+RnmUoxn9DXQCzZmW8QkIy59G2PjJXRdr08MAMkxfCQK3j+o/e2bOtKci4RQjtEhPA6ZLW6ssHBc1Txd6TOCmmJztKeD14jbdKN40zv6OMaiR1IhsbRDjfzyDLLz5d01oFHdRP+BmsHZKSElecKbMol0ekeaPqgJ9paxVF0Ufx5x9WdHgmvOYctdbnZIT1hz31ruVHcPSitMF0YHVR3hqIzTtB9vpZGWRJkkJP/zWwlKDoHYInT07iTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvuM3aNdc9VgHm1I1aWvm9euqEbRSIgw7Pvti2VEZdc=;
 b=D01WJFGq8Dyd4ybNnXk/pO/FBQviecgbQOPYcycai/qzzfsF3209mtGBxL/ZPC0vcdRTdDjD5g60jSmRfE/8hdypRkPydQyyPA/Wy+Aqcdm3Mk0sSrEmSxDH6Vuh8HNkVEpdHBoyEH/SdUZKMGzZNfEJMVBkMrHC9ZAbxsLis6AgSdULWRC4AUYAmuB1nzRpZ+4ZHNnm6QO0bs7D+YoPquG659aoMBw+MuNPGQDOJtt4kLuRfhKMXPzmxZKSNNLnatcm1tjoGRmTH74oXSKABEoDxz0vd+7j+LvahKqnegI8Vdo4mjN46Oj89tPvZrX67pVua2yYr6R3TbgCmCM5SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvuM3aNdc9VgHm1I1aWvm9euqEbRSIgw7Pvti2VEZdc=;
 b=NJIxuAfJtqu5GbhT2oQtV/jbKqjE/LI0RnY4Cf71CJ5t/99ZMvnNlG66M8ODUSiUxa0OyRdM5uvUcz9vRfbHlJLhnXA39NGmD7Dcvfz4uj96XQpEnqwLjXSI3ubBaCb1ZJQFmokH+Jgz13e2joAz8UBTP1EHhZmvUUHONdoqrWg=
Received: from DU2PR04CA0025.eurprd04.prod.outlook.com (2603:10a6:10:3b::30)
 by VI1PR03MB4510.eurprd03.prod.outlook.com (2603:10a6:803:5c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Fri, 8 Jul
 2022 18:13:55 +0000
Received: from DB8EUR06FT035.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:3b:cafe::3c) by DU2PR04CA0025.outlook.office365.com
 (2603:10a6:10:3b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Fri, 8 Jul 2022 18:13:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 DB8EUR06FT035.mail.protection.outlook.com (10.233.253.35) with Microsoft SMTP
 Server id 15.20.5417.15 via Frontend Transport; Fri, 8 Jul 2022 18:13:54
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id BF0317C16C8;
        Fri,  8 Jul 2022 20:13:54 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 727782E01E4; Fri,  8 Jul 2022 20:13:54 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 3/6] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (2)
Date:   Fri,  8 Jul 2022 20:12:34 +0200
Message-Id: <20220708181235.4104943-4-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
References: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 78e0b1ab-898f-4281-6704-08da610d9ead
X-MS-TrafficTypeDiagnostic: VI1PR03MB4510:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VmKuCegfX41I/A8A04JaxO2xnhxP5JqUiqTjd1CHQ5+u+c1mqr5fqV2FGWNZJZojeYXwLDJ7bGhIM7GFRRBo7mS0iNIsyX3bqWwOz1DmyJ0C7vNfzQEreXXXPH2aIv8bdksIbJNY9vWcPqTyFuiTdBnrIvWjGdIGTvu0Joc70/6TzvJiHa9aiNHXBlIwOoYMg5qRPGM8dbsVznDGKDNT/iALkA3XQt/OCIWsUf9dqEv2WSJk9OEoejgypIlovySkR7T2RiUDL2NLI70E8Fg5fTohQIs0raKGIs7UzA2y/7vI7suk5SeIsR+egAjm0fed8Y9pu9UL73NxsDJvFWtyrM668J0ICnz4nIJdJGMVWUqogFN7hVPvocysiih3Ujq38tQXKlirctaSTPrxRfZO80v+0f4YEE2uNCOdvRc4Z/3n22ql5eYOEBETGNbOmwSMALL3DRFperpR5iwaQ7bN2XAUt4MBe7QXGboVl1bGhMb9kFpeMoDD6nKSyahfatzOXDhiP8NAyJazoKS86GAIydpF/uwkCwlVHb8nItWV9bUEL0GwIJLSzJFPF2BjnWrBg8Fd+Fwg+hg2VzPKF7Q9wh4UTjSexOmuVyQqkc2ffuUmADdE5OVfC+yeGzAPRxsGEFUuEil8vtADVlc68PhhTawJGXP/yH+XIVVIcik3EudqvTW0CCJObJo0p3KD8oV97IREeAQnNSGHKQDPahWIl1ZT6T4uFmKGPVkleLvahOvHjHhf4Qnnj86avWztZeB4ToPMC2lDyjIkFlnn+DoMRxL45Vx8+qdfaOpnmZVKxT0=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39830400003)(136003)(376002)(36840700001)(46966006)(42186006)(110136005)(316002)(36860700001)(82310400005)(54906003)(186003)(26005)(47076005)(36756003)(6266002)(83380400001)(336012)(70206006)(4326008)(2906002)(8676002)(5660300002)(478600001)(86362001)(1076003)(70586007)(81166007)(44832011)(41300700001)(6666004)(356005)(2616005)(8936002)(40480700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 18:13:54.9886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e0b1ab-898f-4281-6704-08da610d9ead
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT035.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB4510
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moved mislocated supply for cf->data[3] (location of CAN error)
outside of the "switch (ecc & SJA1000_ECC_MASK){}"-statement

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index e14f08d30b0b..0a402a23d7ac 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -294,7 +294,6 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				cf->data[2] |= CAN_ERR_PROT_STUFF;
 				break;
 			default:
-				cf->data[3] = ecc & SJA1000_ECC_SEG;
 				break;
 			}
 
@@ -302,6 +301,9 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			if (!(ecc & SJA1000_ECC_DIR))
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
+			/* Store error in CAN protocol (location) in data[3] */
+			cf->data[3] = ecc & SJA1000_ECC_SEG;
+
 			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
 			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
 				cf->data[1] = (txerr > rxerr) ?
-- 
2.25.1

