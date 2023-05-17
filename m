Return-Path: <netdev+bounces-3442-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BD3E707200
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:24:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FEB41C20FD2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 868BA449B9;
	Wed, 17 May 2023 19:23:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716A1449B6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 19:23:15 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2099.outbound.protection.outlook.com [40.107.21.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7E3271C;
	Wed, 17 May 2023 12:23:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQYQoTTY+KWV3+amLi8FxiTvbBYHlzOdyBC9SnSJEMm0g+hGftER2c8YGzs19thhNl91MhZExTSaBV7kYySjONpL2GJcU6fLCg/jnUqRTL/8ku26HUpbgE6nR+2ixyrIF4yjEFsB2Ac871dlJWBRpxK6RLg4H2LLN0j7eGSf9rO0aXzFaB82k/iskQkjLzVZlEAcHpu6RnJA/g2is25xTG5G15Q2kXBQKjB0ZvmNCdbJpVFSlJUdItglErZ3jPoWawq17XUIwnsLh/M89y8uv9FWMnBm8KmE/8XW3YJnVL07zmxEDRuHTsEZRJ+waEzKMEZO1Gswxnwkq0rvJ1WqMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUJW4C0hUDB+USndlFz/vHyiJqSIKRU7esnI0JWh7hY=;
 b=dFCHlM0wV57R2U4Zy8gE/fnquoY6PrI6zGtHt+rU8gjdRhTtMZhTUNt/x00+qEEaR2Xj+gfB24TwMySIv7sUP5Ljf8OnRflw2cKXvTb95GCDd5oZIEGhqbVAsJ8Ar8AFkZzPCsVI4oJNnYXN3IPUs/D8GGezlLwyQ5fC3ZPGKtMFcj0dIR5j934qV2SN9m59eoVO8jeCX2VlJNVhOpUnlE/whI2pT89fAr07KNd95nY72PA91V/wslGwL6PL0lpl/oB1T0aW2LmtGqOkNCAPCeDRYN9jcSXInVQoeg3+ff576r0121JTsZXexCw5YD+qw4UIs64pZkBVNvTpaTY6Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUJW4C0hUDB+USndlFz/vHyiJqSIKRU7esnI0JWh7hY=;
 b=iAxkmWfYPXpY0H6z5ECBC0yPC29DSS3/rUgjF/sEcKmFNPTjSjSQE4b5cRAKPeTSkSBW95baRaFRSzSz7p7mibHrREkUN2JS2NFN2IbynJDLtEK4QrytGj4fpZZq5KXG3n+Lp7HkRkha2meFj5GNK3BVHnAEkyutmMOxlUs9rfo=
Received: from AS9PR05CA0084.eurprd05.prod.outlook.com (2603:10a6:20b:499::24)
 by DB9PR03MB8798.eurprd03.prod.outlook.com (2603:10a6:10:3c5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 19:22:56 +0000
Received: from AM7EUR06FT042.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:499:cafe::b0) by AS9PR05CA0084.outlook.office365.com
 (2603:10a6:20b:499::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33 via Frontend
 Transport; Wed, 17 May 2023 19:22:56 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 AM7EUR06FT042.mail.protection.outlook.com (10.233.255.77) with Microsoft SMTP
 Server id 15.20.6411.18 via Frontend Transport; Wed, 17 May 2023 19:22:56
 +0000
Received: from esd-s20.esd.local (jenkins.esd.local [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id DBDC87C162F;
	Wed, 17 May 2023 21:22:55 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id CD81E2E1801; Wed, 17 May 2023 21:22:55 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 0/6] *** can: esd_usb: More preparation before supporting esd CAN-USB/3 ***
Date: Wed, 17 May 2023 21:22:45 +0200
Message-Id: <20230517192251.2405290-1-frank.jungclaus@esd.eu>
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
X-MS-TrafficTypeDiagnostic: AM7EUR06FT042:EE_|DB9PR03MB8798:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 7b1d2c2d-9959-4bfe-0a47-08db570c1e70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xHo3QT2Aw2HH7L5Ddy/gna1jaqzq9Jgr00PKfUPw7lbqOHL8MT7AikOvX0nlfNgp2U5UlahcswfoIf/VH9Ztz3ppJlKzC+6KdE+gB+kKr+3EjfbKhQz+VgpKVUvNC0adCHSItGxtisB4Rln4TSKs1AMdP+fh9wzs5a3hfGMrEPuCk69lrfclTquCu5OPP5FhCt/JOLc+ovJyKyVZsY9T0BFvnpywMU85wQbv1PzypreZd6tp0JLw7LL20ARQbzqVMRtOmKhnAPhpAf8ZYpKpQ7ydaVgElizSEvnHr8m/f1N+3/7RpUZ+ahXV6cvxSuCNoUTLePohvML5ZhioZrJj5rou5tdSSwynmF4aXRKSZLXF0muzQrPXeyI/fq49YrteL34goDN4AGSaii0IsUhktk80zkzl2a2L9M07tHr84casvN1IRNTRbtwQ97ibvEAKX+j2lSeN00TXR90HyMBpslIHME/AdK5KMSYbmSg8GLuSiHuua+L4noHCkREo5NerbEroHnV6wGlit46e+wdz1CcO9A0rFyd7s0b+PYSEgfodszPqUK+V72bylV35K6QBfBdFLZlxD4JflWUqS+2HCcMDXkguEQaBG8XdBg+xxz4R2EmB63xszmX6bhE5mKXmj6TueN8EpLhrz8306O+8eJJui0uUNIFaMVZyQeOwuV6kLxWTJvP3yLI27p3uhkep+XkC7KkdUqxC7OshDUGaOe21M9VNFBYVeeoQ4ww4sfIgK1sX7aIaSgMrbAUF7ePE
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(396003)(376002)(451199021)(36840700001)(46966006)(110136005)(8936002)(5660300002)(44832011)(83380400001)(47076005)(186003)(36860700001)(6266002)(26005)(43170500006)(1076003)(81166007)(356005)(86362001)(2616005)(336012)(40480700001)(8676002)(6666004)(41300700001)(316002)(70206006)(70586007)(36756003)(4326008)(82310400005)(478600001)(54906003)(2906002)(42186006)(4744005);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 19:22:56.4159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b1d2c2d-9959-4bfe-0a47-08db570c1e70
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR06FT042.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB8798
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Apply another small batch of patches as preparation for adding support
of the newly available esd CAN-USB/3 to esd_usb.c.

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


base-commit: 14575e3b5f3ece74e9143d7f7f195f3e5ff085f5
-- 
2.25.1


