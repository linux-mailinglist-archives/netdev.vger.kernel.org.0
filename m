Return-Path: <netdev+bounces-3996-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C23A70A020
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:56:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38F872819FE
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DD3F17AA0;
	Fri, 19 May 2023 19:56:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DE8DDD0
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 19:56:10 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2093.outbound.protection.outlook.com [40.107.21.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1408E1B5;
	Fri, 19 May 2023 12:56:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPIGaEFoPv/uif1v4Os5KQLM0LYXqsBeoP5l/C0BP284Lqwqbzt+3urWQhJix5uO07tM5Rs7H9qiOiArKZSltMoYJ5+gmGDUhR6j6koCTTGrW25NZllu7IPr3FMAgM5jqMO7ndwDdzukos0ePxPL+7rZRFh8dh4BME/5jTI5sH6pHdW9SzILFWjJHW8aqdARX+gDwDkvgg9jbWci53OB133w9cg9CIF9oRWYL2J/mVFypN9rGEC5rGjzrH31BVoNnK+k05KeCFjlERFvhiFp80gg9hjUH0o0Awk8djn1sVoiGjr5HARxz0bNm6fw41aIa1Vhpu7Z0ApHEROhaJcnZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+W7p7mTBu1xmJqXr7qzmjCGHn8C/HxLC+oJU8gmOLo=;
 b=YrXJtYJhVfBqu+4739DTKfjN37i9VbqwIKWyLyItP/xRaeVHddBU9k3tD5/fA7ZQU2lx5D4UwHILBmseB8o+RZ2YUbS58NJOPm06TGqAgKvIckC+8d0e6TsjzxdFV+yGInPVCcxxU/KXHHkdxWoIRkPY5ikiw0Ck1NQB9FlhBoSzvz7V9FqJ5MBqeWA2qjhY39rGGqzoBUB7wPTzOmA80CL65hLgtb0FHkMoNXMMH8LAq5bkoPrBVxS0NtRobRMxbEUDBoHH+6S4xjvlCcRhbz7jd1M5c+6A7it22KfzwcKNTpT+k9LivyIR/zjBS5DGS/ncZ+kd2legczfDz4NSUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+W7p7mTBu1xmJqXr7qzmjCGHn8C/HxLC+oJU8gmOLo=;
 b=nnkaGnaAQq8XQlb17XuQCJHB37wuhf2bdonW8n16bCpUnKuslYMofwWM7JP0HfyUHHTtbpsLBV7HMXsLFMuv2OA3XIBlbmQsMZ+1ExOKTU3UhrYMI/Pd8XCONiFse1uN6fj0fW9S9B8jMNSWvw1jdE9x/0U7Uxs1NknvalwfDHk=
Received: from AM3PR04CA0140.eurprd04.prod.outlook.com (2603:10a6:207::24) by
 AS2PR03MB9612.eurprd03.prod.outlook.com (2603:10a6:20b:594::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Fri, 19 May
 2023 19:56:04 +0000
Received: from VI1EUR06FT058.eop-eur06.prod.protection.outlook.com
 (2603:10a6:207:0:cafe::ec) by AM3PR04CA0140.outlook.office365.com
 (2603:10a6:207::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21 via Frontend
 Transport; Fri, 19 May 2023 19:56:04 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT058.mail.protection.outlook.com (10.13.6.196) with Microsoft SMTP
 Server id 15.20.6411.21 via Frontend Transport; Fri, 19 May 2023 19:56:04
 +0000
Received: from esd-s20.esd.local (jenkins.esd [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id E28187C162F;
	Fri, 19 May 2023 21:56:03 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id CDA5C2E1801; Fri, 19 May 2023 21:56:03 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 0/6] can: esd_usb: More preparation before supporting esd CAN-USB/3
Date: Fri, 19 May 2023 21:55:54 +0200
Message-Id: <20230519195600.420644-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT058:EE_|AS2PR03MB9612:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 43c7ca90-9009-4bfd-f3de-08db58a3140e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	C/mt4doWWi5Kp7sQSowWeeOFNM8eSUhUe6rlrvNelFhqFBBNXxp0X+VqB57I3HMbe9ZxuRub3SwJhGEk3EGNjKOlE8hmi36cfd02/Y1Bkkk/g3RJiPqGOyZCeoAkoBTFwCyPWcsjFfEfiK6GdMy0RE58Td8lXh7E+dFFCP7oFGMumRZ3uPcnlaqp16iCBvCwopQlEG8a477bVXEytwx6ecsN5jcizPDrNuvrQV0zbFG7nA0jPmgMDrlm+czXe3C/GcZGwYTA7iSafVZjswLz5ZDxlIhh7XQOriyJzMGoj4wC+LBqpljGk2EqVFFL2LFzopgTCxpq4Jcps51VM7VJYgPoC7Hh+rxq9RnQzzJCreRaeqWnqifb3urHMVrO+VbxHvtuMHym3RRLdIIiMWDWIjZkDde0+03bCGAXcSGLCCTmYSNj9HGpjh5vz6fr1u98BTiUx9HAJquxp6Tud8gJVQoxOCXR1hL5nlc3qYKdNY5s+lEbBQIXiMdrVL0W71cC+dywhUKrE31TCWEuKmFTYcDQjHqvh6IOgCZFohZBbm4mv+gBZVcFhrCISbVc14cbA2ahxA59gFh0Gt7BpX8ZGaWa41DGpcvxtrVkaaL62Q/BbSJyMRq2RId0JV7DsyLDzsCMoh6jmcY9Wm6dX5gjbvWt3S1x2I1NlE6K6bQrRiTOKEGSNK7I6kzQO9J+eZYQYh5+xehj9I1Tc3SDDp2vzx1MkAhDG1yLIgAdglXMKZA=
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39840400004)(451199021)(36840700001)(46966006)(36756003)(478600001)(86362001)(6666004)(316002)(54906003)(110136005)(966005)(70586007)(4326008)(70206006)(42186006)(356005)(82310400005)(8936002)(5660300002)(336012)(40480700001)(8676002)(2906002)(41300700001)(44832011)(81166007)(36860700001)(2616005)(26005)(6266002)(47076005)(1076003)(83380400001)(186003)(43170500006);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 19:56:04.1557
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c7ca90-9009-4bfd-f3de-08db58a3140e
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	VI1EUR06FT058.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR03MB9612
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Apply another small batch of patches as preparation for adding support
of the newly available esd CAN-USB/3 to esd_usb.c.
---
* Changelog *

v1 -> v2:
* Make use of GENMASK() macro for ESD_USB_NO_BAUDRATE and
  ESD_USB_IDMASK
* Also use the BIT() macro for ESD_USB2_3_SAMPLES
* Removed comments with redundant hexadecimal values from
  BIT()-constants
* Reworded (shortened) the commit messages
* Changed the macro ESD_USB_3_SAMPLES to ESD_USB_TRIPLE_SAMPLES

v1:
* Link: https://lore.kernel.org/all/20230517192251.2405290-1-frank.jungclaus@esd.eu/

Frank Jungclaus (6):
  can: esd_usb: Make use of existing kernel macros
  can: esd_usb: Replace initializer macros used for struct
    can_bittiming_const
  can: esd_usb: Use consistent prefixes for macros
  can: esd_usb: Prefix all structures with the device name
  can: esd_usb: Replace hardcoded message length given to USB commands
  can: esd_usb: Don't bother the user with nonessential log message

 drivers/net/can/usb/esd_usb.c | 339 +++++++++++++++++-----------------
 1 file changed, 168 insertions(+), 171 deletions(-)


base-commit: 833e24aeb4d9a4803af3b836464df01293ce9041
-- 
2.25.1


