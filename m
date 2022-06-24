Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AAF55A183
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 21:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbiFXTF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 15:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiFXTFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 15:05:52 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2097.outbound.protection.outlook.com [40.107.104.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E817481D83;
        Fri, 24 Jun 2022 12:05:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSn+DE861UqweXl4wIGRR65lxGEOJAvWIjWyRWxCyITrDM2qul/gSULDyYzVN4TGiyiqrw4M/Xi3iWGDzEsY2JigzeLAqsA+FB6iba2O64SrMIQSV1lvfDTZAHn60qpFnsQHMSm1U2hpKCkxSIU5+Qa1ri+bgtdFBEGOK/V7EKRfpoX8Twpu3LIcIWDIYRzAtvW3R47FVJohFfkbuskQdDsRG2n7gJE4JU0Wh+3b5coE76OUVj6tVAClyxm9dB+jLB4JOXp3ZsQeiftyoSd1O6witBsyCTCc2sBw8aZpcCrWZTSltKmI1gvdD7k+OcYBUbCAh72LbKO1pj9njx+G2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+g6k4AcPdTLMCJZLEiV8LuZCvnfNx+meEMW0q+gqRRU=;
 b=Ytw7j2h7fAdfaayIHSIHZJ2g/uDI1hI+/z1fA5kfOREVE/uVtrUZqfbeq92U2vJJmyToj4G68IuM3M9IWmKELEq+lMOhVp3T42kpDNF5aTY0UQ0/GaJU1v/nnSuNmY4r6EoNWuQvJBuUp8OPkdv6trCwj59bnWMNpabzghTII/ETKQBy/x++icpJaTEpI6NOd3wqqB8ETDmo6bwM9h2KPyQbwTI2XtQ/7L9fcuGn34lbJNtfTaVRPJhDy8vKV6sZSsL38DEfKxNfQomrRB+GWOi2T770mEzCBCGAfHjRM71eh+f/zbXL7tLQJApB5AbOFI9jrTozCzt5uxn8m6a62g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+g6k4AcPdTLMCJZLEiV8LuZCvnfNx+meEMW0q+gqRRU=;
 b=riaM5Aw8tfRePG8+0z6WFqFYSxRPcSlJRc/PNK6YrV6DF1b6VaoqK7olJDsVf5XDg2DUUl9l5qcGc7F6NNxkI+87ocorBWsBzZyhM/ZJl6LBLOAw4udA6V5cAfeu7ZkxOhYPFaM8AybhyW1j5z84zmHlwNLO5LCE/zgvQknJfr0=
Received: from AM6P194CA0046.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:84::23)
 by DB9PR03MB7642.eurprd03.prod.outlook.com (2603:10a6:10:2be::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 24 Jun
 2022 19:05:48 +0000
Received: from VI1EUR06FT010.eop-eur06.prod.protection.outlook.com
 (2603:10a6:209:84:cafe::44) by AM6P194CA0046.outlook.office365.com
 (2603:10a6:209:84::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15 via Frontend
 Transport; Fri, 24 Jun 2022 19:05:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 VI1EUR06FT010.mail.protection.outlook.com (10.13.6.179) with Microsoft SMTP
 Server id 15.20.5373.15 via Frontend Transport; Fri, 24 Jun 2022 19:05:47
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 6A6867C16C8;
        Fri, 24 Jun 2022 21:05:47 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 5A2882E4AF1; Fri, 24 Jun 2022 21:05:47 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 2/5] can/esd_usb: Add an entry to the MAINTAINERS file
Date:   Fri, 24 Jun 2022 21:05:16 +0200
Message-Id: <20220624190517.2299701-3-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624190517.2299701-1-frank.jungclaus@esd.eu>
References: <20220624190517.2299701-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 326cc9b3-eed8-4387-36bc-08da56148c27
X-MS-TrafficTypeDiagnostic: DB9PR03MB7642:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H1UwmGjOH3Qq+BLPmvWnb6AQW1isdFXnEqTkzOSsTyp0mzqsH0eSkj7YqwqECpwm47xwsDtjxqPH5y0nZLjzuaQL5c0d4IQozP96WmT6j0mfu/swuCXSfcupWQFHZIH+yuMKejAzcRfGGvEMxDlyArewtWmpJkG6hzBqBl3rX52AW/nixPbXY283GyIGkYCd2YPuUZbQ4c2mHa2w1pWNbtSCu0C3gRxY25KEN3pTXBj+q4D4fbkwmZHlrHmAqMEDBvBO9ss8c6LPqlKtlb/URqNigo5pvieWGl6GD567YZGiM1OQ8AZeRKaM31WNcB7o1nPOmCsLI+4rTm5nNwBsdTnSHLnbxyv/nNpTLYNmMe2EOKpxPO0TRb9RRdgJLTY5Y+KVcLY/L+GGlhp060tJvA+l25d0TEnCPpv7w4pR0V9zxS/T4xDFw2iOyZVEZR7sMZ1F1MK/XUwLxF4ssDms5coUqjhgIpVMAoFa3XbZ3E0wmprxtFxIIq2R6DgyRxC0rWBmd9hVO91TPbyQFzgNNm9jWkh6zbpMF9da4Gr+UrUmNVVxLI7LnIYYKbHzzOaLAsjGnAhWCmK8x/VJlYd5Yg7k6Wv9jYIt9KfoXW4rnGfmPCnnU85M5+wcWU2v+ouDUlTFp2vhIOPmNQNVGaC91kT7MWG9T5yBV18BGcY5i3USdmpa4x0dVi6zfXtCm86YtBPR5lURlcOUyGkkNvByWEqEYseC1FQdwXPV0wwfZLjtz1zdKQsE64+/URE7UctVE8wHyuXRZwd26zgX5n16pg==
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(136003)(346002)(396003)(376002)(36840700001)(46966006)(26005)(110136005)(1076003)(5660300002)(2906002)(47076005)(186003)(81166007)(6266002)(41300700001)(2616005)(4744005)(4326008)(42186006)(316002)(6666004)(8676002)(70586007)(54906003)(70206006)(44832011)(8936002)(40480700001)(36860700001)(36756003)(356005)(336012)(478600001)(86362001)(82310400005);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 19:05:47.6123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 326cc9b3-eed8-4387-36bc-08da56148c27
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT010.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7642
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested by Marc, I added an entry for ESD CAN/USB Drivers
to the MAINTAINERS file

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 05fcbea3e432..2d1cf1718140 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7406,6 +7406,13 @@ S:	Maintained
 F:	include/linux/errseq.h
 F:	lib/errseq.c
 
+ESD CAN/USB DRIVERS
+M:	Frank Jungclaus <frank.jungclaus@esd.eu>
+R:	socketcan@esd.eu
+L:	linux-can@vger.kernel.org
+S:	Maintained
+F:	drivers/net/can/usb/esd_usb.c
+
 ET131X NETWORK DRIVER
 M:	Mark Einon <mark.einon@gmail.com>
 S:	Odd Fixes
-- 
2.25.1

