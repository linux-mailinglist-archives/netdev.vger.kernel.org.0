Return-Path: <netdev+bounces-8303-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B1D27238D5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:21:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA07328147F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B05416119;
	Tue,  6 Jun 2023 07:20:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60576AA2
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:20:32 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C9A10CC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686036014; x=1717572014;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=jFnSIp8lbMkQt3WOYP17mjK2yAni6DdS7zWSiCIvY5Y=;
  b=VDsPF5Yb7zJtSHxWP0ULVcRct86O9/OtFf8MyBe+PFmunEBNy2rzgF/R
   Cb7i1TMVkG6Gc/5i9g4rAVpASKVGn2cEMHHOfmco+en000mWCrZIs/YJe
   zqBtUa/DJUifrJQ0oS5xuWJz6KdafVJQiTHV4cAwkZqUcRBX8LohWGfB4
   0Dyu4j3INhnGGIzTC1Fi6ysRZtOVYqf0pQBP5wwUdKIeUXaSfDJ7zjX+B
   Nk6/6OR5Wgfp6F87SSqXgMSJqTyT2oKCKbKBUKbv+8lXJ5bWXq2yMAmoF
   vCxIvedGoi5Y2LiY8e/JvMGHLR/DXXog7SMqKiy1OaYGPEVC+59Wz9X2d
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="219027958"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 00:20:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 00:20:11 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 00:20:10 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Tue, 6 Jun 2023 09:19:38 +0200
Subject: [PATCH iproute2-next v3 03/12] dcb: app: move colon printing out
 of callbacks
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v3-3-60a766f72e61@microchip.com>
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In preparation for changing the prototype of dcb_app_print_filtered(),
move the colon printing out of the callbacks, and into
dcb_app_print_filtered().

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb_app.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 644c37d36ffb..ed7930ae7b37 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -405,12 +405,12 @@ static bool dcb_app_is_port(const struct dcb_app *app)
 
 static int dcb_app_print_key_dec(__u16 protocol)
 {
-	return print_uint(PRINT_ANY, NULL, "%u:", protocol);
+	return print_uint(PRINT_ANY, NULL, "%u", protocol);
 }
 
 static int dcb_app_print_key_hex(__u16 protocol)
 {
-	return print_uint(PRINT_ANY, NULL, "%x:", protocol);
+	return print_uint(PRINT_ANY, NULL, "%x", protocol);
 }
 
 static int dcb_app_print_key_dscp(__u16 protocol)
@@ -419,17 +419,17 @@ static int dcb_app_print_key_dscp(__u16 protocol)
 
 
 	if (!is_json_context() && name != NULL)
-		return print_string(PRINT_FP, NULL, "%s:", name);
-	return print_uint(PRINT_ANY, NULL, "%u:", protocol);
+		return print_string(PRINT_FP, NULL, "%s", name);
+	return print_uint(PRINT_ANY, NULL, "%u", protocol);
 }
 
 static int dcb_app_print_key_pcp(__u16 protocol)
 {
 	/* Print in numerical form, if protocol value is out-of-range */
 	if (protocol > DCB_APP_PCP_MAX)
-		return print_uint(PRINT_ANY, NULL, "%u:", protocol);
+		return print_uint(PRINT_ANY, NULL, "%u", protocol);
 
-	return print_string(PRINT_ANY, NULL, "%s:", pcp_names[protocol]);
+	return print_string(PRINT_ANY, NULL, "%s", pcp_names[protocol]);
 }
 
 static void dcb_app_print_filtered(const struct dcb_app_table *tab,
@@ -454,7 +454,7 @@ static void dcb_app_print_filtered(const struct dcb_app_table *tab,
 
 		open_json_array(PRINT_JSON, NULL);
 		print_key(app->protocol);
-		print_uint(PRINT_ANY, NULL, "%u ", app->priority);
+		print_uint(PRINT_ANY, NULL, ":%u ", app->priority);
 		close_json_array(PRINT_JSON, NULL);
 	}
 

-- 
2.34.1


