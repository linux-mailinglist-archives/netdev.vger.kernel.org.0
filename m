Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B55514EB4
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239636AbiD2PLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 11:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239525AbiD2PLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:11:31 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2108.outbound.protection.outlook.com [40.107.114.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A97D444A;
        Fri, 29 Apr 2022 08:08:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maq2z9LKIlmfWKv3UpxcGv5Ifo6mLcYqyp52XDFXnJFYXrwqPBh5rLAEQedws5skfOtZPCNC5Fp8YUQMsi3O4fnMWF4BE4S7Ejqg5ETxjoH7LdEZPSG2HZGNIwDMGUGnOdzHuQVUsJLZ8y/dumuYNVvKuk97BUwfsbQOL8h3xr6JxNuYXcH7V68vtIob3vaaJ8T794AJgAl8W1BJhJsIFBu110DmreyEoKtd/MU1+oXEqYYdlVSv3lmUXJfJrrUI+dLX6oMYm4Tu+ZXAA3dKJFeRJH9rk/q76c79hcvEHj9US4W5D44TJQIDNg2NMnrZlYOlr8vaYZFD+zevSs4Gog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gjVTCqWoLtDioFZTu03GTTWD3UO84Gedlxr0GEkWQW4=;
 b=DDYCfYnVHiK/iw5IdprV+LuHQMVIwuDHYQTy/xmtaC9eNMkUugVCNZL/aXsmDRhuv65a9Qcd0RWM5RxVYvIf5toT5XaUfOcqr0194qMXZpc5fZPbzMmthVlTt8HAFXAEXH9jz+TecXvqxsDRQFFHu32OizOtV+z3sZhN6UHcd2oyulfv/mrA2MezyYVxG4iTQO0OzHL8zBgmvi5e//RumNghZd/q/PEKudWBmLZZd8hXUSJpOYpyjyzf9oX1TYKb65Rd3ElfHcM8ZPMOPpU5vIW+2IJgTLKHetPZLLtXybCLVViOtt1Tl7zuNtdh9/cx7ukMudJ/bkOGdE/IIMou9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjVTCqWoLtDioFZTu03GTTWD3UO84Gedlxr0GEkWQW4=;
 b=AcNO8FaGwlpqeYUhioUUAXLdzQSpvvBu3Ddni5/cThOBXJeUBChPSXNzFJDJ7w87mBuOkdQsRFVgoZtPZhmtJN+e80fX+tx03YNFdfwchwNEmAC58knXzXO9lH4rI7yr3QXHT6JgwxRMFguAsruCzBzSjyp0C+pBsJQMDwR030c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OSZPR01MB8670.jpnprd01.prod.outlook.com (2603:1096:604:182::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Fri, 29 Apr
 2022 15:08:11 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%9]) with mapi id 15.20.5206.012; Fri, 29 Apr 2022
 15:08:11 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v2 2/2] ptp: ptp_clockmatrix: return -EBUSY if phase pull-in is in progress
Date:   Fri, 29 Apr 2022 11:07:44 -0400
Message-Id: <1651244864-14297-2-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1651244864-14297-1-git-send-email-min.li.xe@renesas.com>
References: <1651244864-14297-1-git-send-email-min.li.xe@renesas.com>
Content-Type: text/plain
X-ClientProxiedBy: BN0PR08CA0007.namprd08.prod.outlook.com
 (2603:10b6:408:142::32) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 122a357e-5a03-4a21-48b4-08da29f2135f
X-MS-TrafficTypeDiagnostic: OSZPR01MB8670:EE_
X-Microsoft-Antispam-PRVS: <OSZPR01MB8670FD6C55FE13730BC75695BAFC9@OSZPR01MB8670.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q3Ox5tlTXoLk6lDYcAX4cznk+vKJotVr8OCC67jo/F+mph89MldN9/rOti8RsDXPfKm/GVNUCu9yaB9waIEB67xkAnDde15KxH3my0UeSQ6XEH5SgL2BvOZP1ycaXG0EdzHKeHFxGT+o8aY9VQqzP3adswQ9b5B911w2hpe/W9WzdDd6NbCDzJ8JSvTmA+/rzwM3W+SyCU99gi7U3qxiCdzlx07hP9IYD/TTlBKngDhwA8e+r6tJhCTaNyYfFE4ltq0khDSov+iF6nUTpt+cM8MeEADpc3hFjDno/mkBE7D1k1uNF1bRLPEVvngOeCd5CGJNcDUK7x1/4ZySo+humo30zbm3Q8IkWMR71pULGjJioRQGDsLXsNg0O8wNAoYZvmDpWLtBNcL/LUP1O8FRdDOXV9BmWTy0sQbaxPN+jGYy3QIx+4jO0ajf0ke7ChEc7uf7wEqVjDD6z+og5BYDSWT4D2O1Y3y/RV+LsZfZ7dVFfwojOt9RoAmaks46WC1xm+kQGYwRtngjB+b3b0QLu3YxT+2RVs9oZT2/8kt0G9d9AT4ZuV28uTl/0Vw5l9aN1GlgWxVLg7KwDYf/hES1bVEID7BJeUv8Hg5YX3n9aASbbwnUCJJluSds2tNuisE0Tg4NWIuPJWbGbRW4Ee05a+Ueh3TZ+nlpCxX7M4sNvCz7QC/e1dM17ciQbmwhfmmgCBSeXIYDpupXyCw0CcLEzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(8676002)(186003)(83380400001)(26005)(2906002)(66946007)(66556008)(86362001)(6512007)(6666004)(6506007)(508600001)(6486002)(2616005)(5660300002)(107886003)(8936002)(52116002)(38350700002)(38100700002)(316002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EEOulMSdTzj1aKaCDFdzMG5osnP/rDtAjdZwdvGBWcj7psnGXIq6EXWD7lJQ?=
 =?us-ascii?Q?6ddTvYAQdWpz/arKKb4YAt3zFYXRs0MFkjVzZEo1ISxYvz/9PmnEedBgQZsu?=
 =?us-ascii?Q?mevCdfk5pNp0Odv8Qb2tJd0fTXNhqZerXKsDHVcmy/SwI9U9gs8BjA0VFnOx?=
 =?us-ascii?Q?qivBfXZPrz+6Ga/XoiCQXa68rY/OwFcXQwaTudTFCcstYvgStvm5cN1oyfe2?=
 =?us-ascii?Q?AjtcfEe4uOFIrQFlto4pf0x7W/yd7d8GbP+O82PQrJ4ZztsJ/o2RTIkCq1sK?=
 =?us-ascii?Q?3+py1qR1MIpJYqJb1JZoJpge/TZuFbAdpYhFtsn3gHuHNl2spbgE2uYLsz9s?=
 =?us-ascii?Q?rHr7RO47rYU0r8rK2O7AudIiPImBXe7fDDkCjUl/4pM3KUZoFBgezRgWYyzt?=
 =?us-ascii?Q?CjqAq3M8c7y7X8uJgS0ZJvfQtGNZCv8h4co81NXucuwpRO3fjjR+j7cF2pSD?=
 =?us-ascii?Q?u/o42vbzfNSx/eB+R2bCbxKAWGvciRTxXKeFcJqp0KcOOez3MmoPkgGvV9jZ?=
 =?us-ascii?Q?mOVBV7uEvzWMOal+KbZ1+XqS4fGxHGn6qFjO1pwKkRklqS2osQBQ22LQonZL?=
 =?us-ascii?Q?mf+6UxJ5I26j5NjDU81WWb2C0FogIhhTFfcfL3ooqJjV/B3thQSGEJEoxltL?=
 =?us-ascii?Q?m78ymbhrz43OIiCfZBw09t+srMt9bpA+3dZZV6RNySMAvUiy5jOgbtnHTO3k?=
 =?us-ascii?Q?auVgEYvpogi0SDNDiFbZTAIrpLU689BGL7AD/Y41UajZyaiv38ua/d/JIJGc?=
 =?us-ascii?Q?OzDJvwAhOmMh7jGSAT1HIBJ+Kv2IcAktfPL7tCfTfySSzSQnMliYHZUtDGqi?=
 =?us-ascii?Q?j5OQs2WS41DxYIM+QZzjIalNcfMoM52W89NPtAo0rjHky4VT7eZE5Bpq4nZq?=
 =?us-ascii?Q?ViIAn2glwp2aja49XE7yhmjXbXdyOLrP/4O6iwhj83cIcfBJdn9PDx4WLHOu?=
 =?us-ascii?Q?As49gpU3wEiPGniP5kZYiEh1JP9uWckVDzLOF4evGu4waMiFT1nMIY8N3JlI?=
 =?us-ascii?Q?aqu9POTtLeAZwmeMrNnXidg2N7+0WXp7Bt6Hx02L8dOi++h9HDp6nHZT8R7Q?=
 =?us-ascii?Q?tv5JhLQlkcz/Bm6tzX/CMQkSweNK7/4bnDjDRxwzACMwuGR2BAh4BeBkknS/?=
 =?us-ascii?Q?vqXbnVweW3Bxu/XJLvq4HXMDBP20Q6vrI1xHkoZR8aUU7Z3m7IaGtyh+1nIZ?=
 =?us-ascii?Q?kVVTnuSxPUycXTkavUbu6BIE0Aj01lXeYIdme8GtvcFh+/Sk3Q6N1UCouji4?=
 =?us-ascii?Q?8CNlAHT4qpvkUGhtcQoTRF1iVrHmrr+sXS0PTU0q7HKSHBsb8fzo060B18Bc?=
 =?us-ascii?Q?yCkOO3+vqIBQtYD7POfHtV6PRcZ6XOfled6VQgdU1ubCZUdblzUMJHNUmnl6?=
 =?us-ascii?Q?GgXnK7kf6K5Mi3CZetPLr+k7D4FRL2ZPO8MQAUZQ8581DhVBCATqATmy073p?=
 =?us-ascii?Q?+p3DNreboQQs+UvbeCS8ptJ58H2GSo2uOoGMivqnF3sEXrwd/ptF4NgKpskw?=
 =?us-ascii?Q?WG+0j/eShxrWjy5zF+xGmvrAFMxwP2HmBOYi4H45a2QiVS/SoPAQT04sHZL1?=
 =?us-ascii?Q?XocHCUVrIkdF5A4IFkFRq96QggLydlR8mdhNYdGv5Y/fRj2408jTcFMGoaVy?=
 =?us-ascii?Q?j0AY62eVRbf2gOZeqhD9TFIV+8cr9Z0S1pRL3gLMgp44KGRa01M4hB/TtXru?=
 =?us-ascii?Q?luckdAHnPsKxLMiyQxQk8BEmzKPxRvtfytI/7Ni8ALBmtKSoESLOyHcJpSh8?=
 =?us-ascii?Q?TEMxI+EjAlIz0FfmIlTaAJH94Wogw8c=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 122a357e-5a03-4a21-48b4-08da29f2135f
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 15:08:11.1119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6IoJJxCBWYZX35VS0cjJ4FSoJlgB8EzsWuOAvyaDaBbqABz3CySsrdweku0wllnPoG1lx+9p3+uKCRnwYJ6gSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB8670
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also removes PEROUT_ENABLE_OUTPUT_MASK

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 32 ++------------------------------
 drivers/ptp/ptp_clockmatrix.h |  2 --
 2 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 3a18f38..dafc4f6 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -1363,43 +1363,15 @@ static int idtcm_output_enable(struct idtcm_channel *channel,
 	return idtcm_write(idtcm, (u16)base, OUT_CTRL_1, &val, sizeof(val));
 }
 
-static int idtcm_output_mask_enable(struct idtcm_channel *channel,
-				    bool enable)
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
-			err = idtcm_output_enable(channel, enable, outn);
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
 static int idtcm_perout_enable(struct idtcm_channel *channel,
 			       struct ptp_perout_request *perout,
 			       bool enable)
 {
 	struct idtcm *idtcm = channel->idtcm;
-	unsigned int flags = perout->flags;
 	struct timespec64 ts = {0, 0};
 	int err;
 
-	if (flags == PEROUT_ENABLE_OUTPUT_MASK)
-		err = idtcm_output_mask_enable(channel, enable);
-	else
-		err = idtcm_output_enable(channel, enable, perout->index);
+	err = idtcm_output_enable(channel, enable, perout->index);
 
 	if (err) {
 		dev_err(idtcm->dev, "Unable to set output enable");
@@ -1903,7 +1875,7 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	int err;
 
 	if (channel->phase_pull_in == true)
-		return 0;
+		return -EBUSY;
 
 	mutex_lock(idtcm->lock);
 
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 4379650..bf1e49409 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -54,8 +54,6 @@
 #define LOCK_TIMEOUT_MS			(2000)
 #define LOCK_POLL_INTERVAL_MS		(10)
 
-#define PEROUT_ENABLE_OUTPUT_MASK	(0xdeadbeef)
-
 #define IDTCM_MAX_WRITE_COUNT		(512)
 
 #define PHASE_PULL_IN_MAX_PPB		(144000)
-- 
2.7.4

