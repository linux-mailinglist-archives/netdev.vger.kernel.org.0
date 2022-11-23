Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A62636A30
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbiKWTyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239271AbiKWTyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:54:06 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2131.outbound.protection.outlook.com [40.107.114.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8F6DEAF;
        Wed, 23 Nov 2022 11:52:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NT5b4RF+2PbNDf9YepUXgbHgUcp7dibjIvmIRMUoYYQ+hTP2YP7SGlOPtO0h0HRZpSiPB9r5LhaU4Qo4795/+acghwsSaA2FY3b6ACcbCJnTUjP5osxL7/SU2jnh5IqFyJTceGcM5ofOOlIcM5FM6KBkLhIwXHTfi72bs6EyNcCGbTkanhnSaqnpdVs+AxE4Tyas2sVI+zLa+L2E2uM6BJhzEgE+lVtDqG2SytWmPumh7OuknAupNsUTap3c5jjPERowiZQunSrT2J9FZvBl+bv+pKgNELBDU3R6q44IaDbD2YFpY4AuqTabtT1/JbEszoO2w9mWsYq2BDZFui7ZMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=anBKNIhcQ7UtGgE/nnmamPRdsh9+7CG3lZttd34MBrE=;
 b=NdQ/ddOgbAiOpbeoMcONPVja2PFa7AvNZPDmo/8o8Qo50/EknwJfPFBe2SEnlr2dSBXvx1CpC2elIF0oH9qJsIzj0KNmGxyrhoPNTovh8SdUQtj3r7w6so0GtDHpHVWjyXh7QRwxaPsWKfvI9zGfJSKJTYN/+KrDC10TcJc0L0A6FnryfbVe2Zaqps+wP3z31rKp9H1VOmJkn6wQVoT4jXc0qi6Mxqmvl8vHUco4zn0mAyGAH8ppHPH3mXH51I4M63VAAHU3TK8NVzkQxiimLiD4kWv1kJioHIe+EVV6r3LTdLXIYP6jzim4HNih/96nbwTdN7iO9HlEF785S6iv7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anBKNIhcQ7UtGgE/nnmamPRdsh9+7CG3lZttd34MBrE=;
 b=e+2QlQUnSZJmfke156WmPEeS7B2Tz/leWUEf7kPsTsHcaiwpb+41EKHlNHiI1u1XIJs3Ro5SLs7M88BFV17pqdL8z5bd8l9B8qBulMgs6LKZ8lAVzBSRFavd26dX7qr975WwBK0cuC4imvMmkZ1GQFWuUNwoO8UknwJUVAew/TQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OS3PR01MB8700.jpnprd01.prod.outlook.com (2603:1096:604:155::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 19:52:30 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::e53e:6fe6:a2de:d7f3]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::e53e:6fe6:a2de:d7f3%4]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 19:52:30 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 2/2] ptp: idt82p33: remove PEROUT_ENABLE_OUTPUT_MASK
Date:   Wed, 23 Nov 2022 14:52:07 -0500
Message-Id: <20221123195207.10260-2-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221123195207.10260-1-min.li.xe@renesas.com>
References: <20221123195207.10260-1-min.li.xe@renesas.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:408:94::43) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3PR01MB6593:EE_|OS3PR01MB8700:EE_
X-MS-Office365-Filtering-Correlation-Id: d149de1e-775c-4d09-c026-08dacd8c418c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KTSkmrYs8IsN7DLmeyDeOiF67ZQItTTcGmk/ezrFv0ZMc3Qk+n39UKhXfVau2V34ozOPBUhKr2w2cGFE3CkIhVtkmZ2kg9CWQ4Zae13LolAhYPQEB3qwtUK/a6lAiVKdp6ZydpH69jJl2vt+hpseale9WgwPSvp9sUUPTXC7WtbslAyoYNM/LSltJNql5HK46SIw+YXdnYeGUWd6sWeQzAnDj2Lzlp5XfnOZrXP8xSlyfVEP9Nc9sq1SX6T1hUHcOS7PABa/myixTcTv02ePYhUxRjH9ZowEXq6OO7IEwfNt/iY+BQa0Me35rCpoOaef/QYbjYfakT+U/0Lw6mWcNfR4YTx55QolgtFpitC/gHHG1WaVze3bhLdmZ/0kmBwV9JsBK/LhSZzY5XxGBPGSbAXzfAq69SaEpppghYu4sVhEjKMxT67l8GyH4PQAUzNYl10YI30mKEdgk0g/9zt+bVOMkgd71Lmx4KDfkiGWTJrHqHuVTQDJn2m45QPlUMY6c+qxFWa7JESSCsQuB/FmEGd6B+LSvsCRkg+PvmCw/8v8/F0QTShPj31T9wL+L69DvuCD5/eaXxzZgKzFxSvfr7rJ7e4pv04J2wdrn/plZicVfdtHeH46SufXm0vHPNHvbY97d0i2icPjGO4SKWPuyI4T4l3D/1M5dnFfyHIS8WktX/y616G/nae7Etq8BRqGMbM/gWroXgpILx9PSoe3kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(451199015)(41300700001)(66946007)(66476007)(66556008)(4326008)(8676002)(26005)(316002)(6916009)(83380400001)(2906002)(6512007)(38100700002)(36756003)(103116003)(1076003)(8936002)(2616005)(186003)(5660300002)(86362001)(478600001)(6506007)(6486002)(38350700002)(52116002)(107886003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BWYYU8Ugmry24QdNkQKuO2mhL4dQ0Noa0HTkfZ6lai1ns3rRQpmssttPWzZQ?=
 =?us-ascii?Q?g3coVF+Q5e6I5AmC4XXrQX5hPTKDz7NtU/pLGOuKUEjJmqWaihwWmwLgM4ep?=
 =?us-ascii?Q?p4XPbLzNBnmyigyIlDUsTYf/rugUOdS1M7i2879/B15nikR5cl7UGfUXHI6b?=
 =?us-ascii?Q?SdgpkhScDiGkul0iE2KNisiHpJnovmxci+Dpzo+eMyT4mFS++PdKvWGPfMdI?=
 =?us-ascii?Q?W5X5oK7UrfEtRwhC70Ysu6+QnK5BnQdCwwcXr8GOYcbh0CuApAxvVtf98mHT?=
 =?us-ascii?Q?kXGoIJGZXhGtw+1UO9F8aRk3y3TSo2I9YtyqKz+FfCIdMPGxBWUXaamd80T3?=
 =?us-ascii?Q?Jrj7G1cEkudrbY2ffbsxtnrCe0j+SiGpBin8SJLQvvJ2X6H6zxJMvhG1SGCM?=
 =?us-ascii?Q?CTHrXjjxOECZz969wjiSLLtxsdcHEb1dwGbjI0GXD0zWApQ1AlECv7u01o9g?=
 =?us-ascii?Q?CxyVoMpLOYcdj63UhjQas3E0FcKsJp1JP6fKgjEEOOUjHs5DrCxIQST4tqwC?=
 =?us-ascii?Q?UjsXDNCEXVBuQkPSII5AVxMeliZqb9nmMvdqVFrFycAF4iQgjPOXUgMvC1fF?=
 =?us-ascii?Q?YPrn2Kcg6spzIPo5GjHAWTWToHv5kedjOCcVektTF9jFpwD6k7DlvtN/O76H?=
 =?us-ascii?Q?6J+ByY80eV56UW3LCq/5osG8LP2HQdHXPoMb0SKqg9P994xpPh/RvDb9hyy1?=
 =?us-ascii?Q?Fbxi7iNSww//9SXlO7sDX6Qgn4KpGp5VQdAhT3UoVYOayTML/9TDJttuGFXJ?=
 =?us-ascii?Q?LCpfP4yuGd06xKi4kWe80PjAmgSKY7n8ImbXNfBe8WuK0a+4yZowT9Rrbq20?=
 =?us-ascii?Q?f+D1wCvO5Nme8x0l6PfkgdES8JEAhl1llCSTxzMBKI4zPQjH+bbGxOEhVTrr?=
 =?us-ascii?Q?kjj+3e/yCYR7sFWEAkdoUzwOPZgWHlTEtsE3yd9DEUvQes1mBXBE89y3X0sm?=
 =?us-ascii?Q?TsEVRuYqoikpm4sz888p31rWq5oAI5S2JWPu++PQf2vjOHFWSOxdzG4+47T0?=
 =?us-ascii?Q?AD4YEZWVSe+f+JGqQQFzn5mtFo2/9h5JLxi8xbJdWmWAUHxHITPxKrswktOW?=
 =?us-ascii?Q?1vFw2M/ZUoITmFWShfxs+5eNKiIWbL7O8dZR5Z9Rrm8A1JOk++TQR7Ip0xMw?=
 =?us-ascii?Q?fBPjKLdrsCXUsitdJSZxFjc+qrsIF9TTvPj8pLtwLokQ7mxSQSWe7UPDZcjB?=
 =?us-ascii?Q?QR67Cd5zHS8guq+foWpIApCKeus+TnQHmiKp3e+IUtcccFeN9eitwN/QA/aM?=
 =?us-ascii?Q?UzohbknJh81hQT4uCwSvH3l1vzR+UYQhoMtz8a8oXPPEk3iqshmjWid1jpVX?=
 =?us-ascii?Q?EYUMS18112MKi8xD9Hp4ojGYIcbookg4B6z2PuIa7+8er/Ekk89f6k1yemui?=
 =?us-ascii?Q?3M48BpEuydqba1qwBaODlkvOraxOWKv1AoBYC7CZkDQv/RcHvRAOEwXOmJYo?=
 =?us-ascii?Q?XnD6r+r7KITqr0VMmc00UcZDCNvbv7DraiKnPle6p2jO2OpIrWTpY1mhGgRB?=
 =?us-ascii?Q?OEOB5sq2DtYJoybj5wJ62hgOFNbTdw17Qh8cyqTcV5cY+WUgcQeZg6HsVeDq?=
 =?us-ascii?Q?M9BiBBNRF+sKQiHzS7SVs14FWy0ymhyntyeB4FdLt06ltzNKjdeTxEdiyrEC?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d149de1e-775c-4d09-c026-08dacd8c418c
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 19:52:30.7549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3vF3K5owIPT/OSE3g7qi0zfjN3x26BUlqm1HLIxtlC6K+7jZflhrH66ei8UPi4k0b4lpdXRHzVLCRnTlXS4PqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8700
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PEROUT_ENABLE_OUTPUT_MASK was there to allow us to enable/disable
all the perout pins. But it is not standard procedure, we will
have to discard it.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_idt82p33.c | 34 ----------------------------------
 drivers/ptp/ptp_idt82p33.h |  1 -
 2 files changed, 35 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index aece499c26d4..afc76c22271a 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -895,40 +895,10 @@ static int idt82p33_output_enable(struct idt82p33_channel *channel,
 	return idt82p33_write(idt82p33, OUT_MUX_CNFG(outn), &val, sizeof(val));
 }
 
-static int idt82p33_output_mask_enable(struct idt82p33_channel *channel,
-				       bool enable)
-{
-	u16 mask;
-	int err;
-	u8 outn;
-
-	mask = channel->output_mask;
-	outn = 0;
-
-	while (mask) {
-		if (mask & 0x1) {
-			err = idt82p33_output_enable(channel, enable, outn);
-			if (err)
-				return err;
-		}
-
-		mask >>= 0x1;
-		outn++;
-	}
-
-	return 0;
-}
-
 static int idt82p33_perout_enable(struct idt82p33_channel *channel,
 				  bool enable,
 				  struct ptp_perout_request *perout)
 {
-	unsigned int flags = perout->flags;
-
-	/* Enable/disable output based on output_mask */
-	if (flags == PEROUT_ENABLE_OUTPUT_MASK)
-		return idt82p33_output_mask_enable(channel, enable);
-
 	/* Enable/disable individual output instead */
 	return idt82p33_output_enable(channel, enable, perout->index);
 }
@@ -939,10 +909,6 @@ static int idt82p33_enable_tod(struct idt82p33_channel *channel)
 	struct timespec64 ts = {0, 0};
 	int err;
 
-	/* STEELAI-366 - Temporary workaround for ts2phc compatibility */
-	if (0)
-		err = idt82p33_output_mask_enable(channel, false);
-
 	err = idt82p33_measure_tod_write_overhead(channel);
 
 	if (err) {
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h
index cddebf05a5b9..8fcb0b17d207 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -22,7 +22,6 @@
 #define IMMEDIATE_SNAP_THRESHOLD_NS (50000)
 #define DDCO_THRESHOLD_NS	(5)
 #define IDT82P33_MAX_WRITE_COUNT	(512)
-#define PEROUT_ENABLE_OUTPUT_MASK	(0xdeadbeef)
 
 #define PLLMASK_ADDR_HI	0xFF
 #define PLLMASK_ADDR_LO	0xA5
-- 
2.37.3

