Return-Path: <netdev+bounces-2807-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A30277040C2
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 00:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2EAD1C20C60
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6F119E40;
	Mon, 15 May 2023 22:11:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81CE1FBE
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 22:11:28 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2125.outbound.protection.outlook.com [40.107.22.125])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F56411543;
	Mon, 15 May 2023 15:10:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0cRGFbMfX9Lgnr7G+g8eCnEf7wcv/QCxNuB52m5rAsPMFT3ab+6vJkCnFHrRq52kMUpdXM3HoYXx5zOdqfwwfWsR8giO3z3H7AlSPC1C8UijwpDyphlV8oCyVYC52kGBU9Sv/uC0esXqHeFkr8BaxsYefUC7IFL/W4WEIS1HfMUjgjdxnCyU5AopNPYTQ05k1YHJNr1ACp5y/DKWhKYazMKXe0mkyis7YSST2LDhUV1xQkMd9JvwNf8dRXpVGL6aSgJ4jk87cOzdfLmI8lf/YdtrIcli/0xkpPJbhm4xZOEX/vpswFIa298B/qIchCFU+Ezc0mvg3uMi4o+v4d6UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPlUljuMbDnP1CXJTWlEkSpDh4kuGthF0Fv2Xwwrgh8=;
 b=iYJt6iRRnyLrkzUlSi9RGKCkqtNoxP1V22NSSRWmP0/VlPiY2uwCMTZoonTEqFtSMN1JebcDfXcL3g3Q3INQl2K44y50oAxQCf3H06vIM1gm58yyO/FmAM4yrRcTj8EcBn/2woPiHsX+gZ4q/ESRxmNqsQPa4pI1FsF3ofGJosdZbZV6nxQq73im9k4KENjpJdhSiEh8B/3oh53hrWzFP0pU4ESeTcgbWbQCeX+PsXwEruN858jQu0EnmqniPwze6ENjIpmwKDdmK5QW/Ic6B/RU1Ju+G4l7Hilp/rRBwzaI+HW7OPMXkkBhJNdw2VGsLwr2tON+0MAfWCWRsswYIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=tiesse.com; dmarc=pass action=none header.from=tiesse.com;
 dkim=pass header.d=tiesse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=tiesse.com;
Received: from DB9P189MB1626.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:2af::17)
 by DB4P189MB2462.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:3f1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 22:09:49 +0000
Received: from DB9P189MB1626.EURP189.PROD.OUTLOOK.COM
 ([fe80::f6b6:1762:92f7:9ccc]) by DB9P189MB1626.EURP189.PROD.OUTLOOK.COM
 ([fe80::f6b6:1762:92f7:9ccc%6]) with mapi id 15.20.6387.032; Mon, 15 May 2023
 22:09:49 +0000
From: Marco Migliore <m.migliore@tiesse.com>
To: andrew@lunn.ch
Cc: m.migliore@tiesse.com,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: mv88e6xxx: Fix mv88e6393x EPC write command offset
Date: Tue, 16 May 2023 00:09:18 +0200
Message-Id: <20230515220918.80709-1-m.migliore@tiesse.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::11) To DB9P189MB1626.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:2af::17)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9P189MB1626:EE_|DB4P189MB2462:EE_
X-MS-Office365-Filtering-Correlation-Id: 318476f4-86be-4ca5-02bb-08db559119bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xhH0sAUqavTYEfrvFTqtR9e4M/H5C1jfbVIf/NNN441nnzdbcAm8Bb6PjPPfGKVjSCEm8INFUe7DYtndaLtZ3xC0iijaCCKbi++Fe4bdG6lflM++O0xNW75cfV1EYbOUxifPhlzBG0Dxj4630dEK0Jsa56hq0qS6YogDlIvugal3AA1TDF0LqJlyZjTyGHjTGXLkmsckhgvNh07gccxD2Z9XrsHx8wlXa6XFTgYh6eoomGlFEFrkTPppbCaZga0GSb5ZMNDpsstuDeaIM6Gj43oiC5NaR+xZcp2kByUbuM53rcMRLkZlqaMlhebMGwodCSFZ2EWk+qcJ+LdT3pRa1vtnQW3fSR3TeuC/uPk47JA5qbTVaIuWzLVIk3v0nKZQZINU0D5uQ2rAttSdzaeqtkl2iCkqMv7Lf+zvnXRSaDRiultxrkntpg1GgNlCFcdJ4IS6Wb1Nj9pQ8M3CNtbjAew1usN3tdEm/M9cVJzd0R/KMQ4RVnOp0coP2UEN2FNIgaAOlc2Ew8BRPGBgkHC15wZuGcKk5VsLgxguFfM40RpjzHQSesFQY6e7+STva9/EvZRNdGMfruZb30pYpwnhGUviCAAVWnDAG1ulYkarCWL/RepSJyIhZ3P/IsZaf2hR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P189MB1626.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(366004)(39830400003)(396003)(451199021)(66476007)(66946007)(66556008)(6666004)(8936002)(83380400001)(6512007)(52116002)(26005)(6486002)(6506007)(1076003)(6916009)(4326008)(8676002)(2616005)(2906002)(5660300002)(4744005)(316002)(38100700002)(38350700002)(41300700001)(86362001)(54906003)(478600001)(186003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JuJF5WO8EqyjUbBNyPGnoPWbKWx3YoCS1eb06V3YrMLS89mMCgrNS7cdV0Yy?=
 =?us-ascii?Q?3Xe+NjqthEjUlxqhrwY9zJrELMJYmGmLHmwKM9eyMxzN9pyUMs5eYBmarBE3?=
 =?us-ascii?Q?xYxZpWFoE1Dy4oFnNhlJGj9YPOjITCfpHXMq8CyJbsafpR1G0w2rx/GZZjem?=
 =?us-ascii?Q?cTEBhVJ+wwIzqFao/hoi4k/Zyj3TqIF8YScmKdo283zOr9npykWnq2dPel8P?=
 =?us-ascii?Q?K176rre9eHe6L69RY/hFPGbA50qzLDG+qR4t3QKSHmbjtiDDdrbb/pkWhv+m?=
 =?us-ascii?Q?KVaLsCjll001xDe4e9ZemkOc687bBEF1RlravlXIPox/84MJrcDrXA1ExK56?=
 =?us-ascii?Q?z4Jfu1dC22qgQ55VJRTKYKBML32juq503D3fFbXgcbJ+sGscnhhSrA7ck1Ed?=
 =?us-ascii?Q?EosUfjH1x7lV3i8YXf9zd36x24DBeWsdmrQQKZW8l6DrS1S3H1/Y1Xtylc79?=
 =?us-ascii?Q?FgWl4MXJ3deXAwfAhezq5dt+RkKIEx0btlKSX/gsgVNxvAEaCtWZD5zSeJfm?=
 =?us-ascii?Q?uQDPTyOoe6tszE0B/G0Y0dpidP4Ggtjo9rPtulhkfX1pcae67O19QGh4WwW9?=
 =?us-ascii?Q?6GMj41M9JGko17HKIXsBz5B9PDwpt/BSLKIlEd1bjvUbpJ0FaZ2xOQUWf2Mk?=
 =?us-ascii?Q?vDTQDtDADsuNamv61Bjv8cmCAi1f3R0H/SBlFuniT+SkCWFcOEXMYsnMTRp8?=
 =?us-ascii?Q?SfrxETMS51pLZVfLtz2P45ztmCk8tufZj/R5o2H1Jw24Jzd5ZQTgFj722eCr?=
 =?us-ascii?Q?Vf6O3PhaSpTnfghpNWx/2S1XEv/3xU3HXUIhCx6KdclWL8Kr+OK981P3OyS6?=
 =?us-ascii?Q?VRb6fSinfw93RDYwdTC78AWT2z98nOzM1cyu1X7GxiqQKHEZbGcaUMV2PiR6?=
 =?us-ascii?Q?edjqJLMkhi2EMccvWJ+Ea//mDlcwOybWWq63ZXrn9+bBStL9cyqIa7MMg7WD?=
 =?us-ascii?Q?uWIlF1zmlr5NBLS7tXbofZWnVFMR3CqAzZDLSu3NgAY2XH/++73FkWxsMWji?=
 =?us-ascii?Q?ITREJ4ZLVtmSmlTVY8NkqHbaWWBivzpUizn6iQilLyzlaKJyD54YdLKvSunV?=
 =?us-ascii?Q?BZZTrj7SvDVP4gOvnV4h3kLLLF+c/256Ba/xpbMBkB6BSZ0Es5hfieglEYh7?=
 =?us-ascii?Q?4jAVVJTIJIdTMylr9OuP9mRG0Sbr1doUUN8VkS50FYWZCtqQG3gMS5n59Xcw?=
 =?us-ascii?Q?As9l6cCjINOBXL2X0cvLiyj/IetUfkyiO7vafB2dTBNC78pZJIfKeTuK+JzQ?=
 =?us-ascii?Q?WRufyT6HmrFgcrPU0uwtbQ81cFDEzJ+EJ6sLJf6yK5ACLKr4y+BjcELeeh0E?=
 =?us-ascii?Q?l+5vOm54/AH/UDSsLj5xE18EiwcRM5nuGj6LjO3j9Mb7A8reztNeBmHMkBoz?=
 =?us-ascii?Q?Oy/6SXL/0I8lOFBN01atvIUzKzL82WV5172y8MHs4z4YMWX3jexseBHyz38o?=
 =?us-ascii?Q?0traZ0hP0d9G3VeKg0ibX+sD2w8dvUGzKeYcPrj4gmnZN2zNVDq8Q2bj8ELp?=
 =?us-ascii?Q?B/NKpf1Dr6diXFBMoy9SYr7hzlNMFNlIyvR6QzwRSZGX4aVh20M2WCQZjZd6?=
 =?us-ascii?Q?6oqWjdkR5l9uMaBeXbKr2Txy3DdeCyCeoaKb+9jV5DNHrQt1ns4bD2OGxvG2?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: tiesse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318476f4-86be-4ca5-02bb-08db559119bd
X-MS-Exchange-CrossTenant-AuthSource: DB9P189MB1626.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 22:09:49.5314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1d7a2948-30aa-4ea7-8dac-d5ab64ed5cb1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gvNmpJVXm/e46f7rr/oCKFdwLVCNWERDPRA9ZMCuvbtxqHF0zN4kXknDDNwdZDQg9GeyLsYS4VKzUkE1d7XlJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4P189MB2462
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

According to datasheet, the command opcode must be specified
into bits [14:12] of the Extended Port Control register (EPC).

Signed-off-by: Marco Migliore <m.migliore@tiesse.com>
---
 drivers/net/dsa/mv88e6xxx/port.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index aec9d4fd20e3..d19b6303b91f 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -276,7 +276,7 @@
 /* Offset 0x10: Extended Port Control Command */
 #define MV88E6393X_PORT_EPC_CMD		0x10
 #define MV88E6393X_PORT_EPC_CMD_BUSY	0x8000
-#define MV88E6393X_PORT_EPC_CMD_WRITE	0x0300
+#define MV88E6393X_PORT_EPC_CMD_WRITE	0x3000
 #define MV88E6393X_PORT_EPC_INDEX_PORT_ETYPE	0x02
 
 /* Offset 0x11: Extended Port Control Data */
-- 
2.34.1


