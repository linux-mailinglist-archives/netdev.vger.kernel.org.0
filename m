Return-Path: <netdev+bounces-8302-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C39817238D2
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33C1A1C208D4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C10D6135;
	Tue,  6 Jun 2023 07:20:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DF56112
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:20:31 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9579FE7D
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686036012; x=1717572012;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=+qUa9ZCKa1qwvZTUwTGk3ipymnAXatsEgkst/+aVBmw=;
  b=zsZsLuKojhLniBl6UwVrT+kyGR+sBVp6DMLxAu7d2U9Ux71W59j9NDOk
   /KIvunX01aK/ZTk6St500FW8naLam59Mal8DQZ2HlxuMYvb4Ox/s5WlMm
   nZZRRCsBta7wUR+NQekO8RHCERLBVdFvztH+n1U7tCSTT3XmxQ4O3uKZD
   YMWI6foMRQU/IU1hNzi9YH8xEreOuOMuT7O4a5uVDW2WxGF2fxkfcPX+f
   UglDtSoeWrKXPaaQThoyNwzIwiSNEFxi780ezFSuMlo61iHc6c+e07M81
   ud21RL7MP1yl531Ylbj5TGbtiCcoHs1ZKkAR5qdOfCferqQZsfU6oLzr4
   w==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="214809783"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 00:20:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 00:20:10 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 00:20:08 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Tue, 6 Jun 2023 09:19:37 +0200
Subject: [PATCH iproute2-next v3 02/12] dcb: app: replace occurrences of %d
 with %u for printing unsigned int
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v3-2-60a766f72e61@microchip.com>
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
replace occurrences of %d for printing unsigned integer, with %u as it
ought to be.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb_app.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 8073415ad084..644c37d36ffb 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -405,7 +405,7 @@ static bool dcb_app_is_port(const struct dcb_app *app)
 
 static int dcb_app_print_key_dec(__u16 protocol)
 {
-	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
+	return print_uint(PRINT_ANY, NULL, "%u:", protocol);
 }
 
 static int dcb_app_print_key_hex(__u16 protocol)
@@ -420,14 +420,14 @@ static int dcb_app_print_key_dscp(__u16 protocol)
 
 	if (!is_json_context() && name != NULL)
 		return print_string(PRINT_FP, NULL, "%s:", name);
-	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
+	return print_uint(PRINT_ANY, NULL, "%u:", protocol);
 }
 
 static int dcb_app_print_key_pcp(__u16 protocol)
 {
 	/* Print in numerical form, if protocol value is out-of-range */
 	if (protocol > DCB_APP_PCP_MAX)
-		return print_uint(PRINT_ANY, NULL, "%d:", protocol);
+		return print_uint(PRINT_ANY, NULL, "%u:", protocol);
 
 	return print_string(PRINT_ANY, NULL, "%s:", pcp_names[protocol]);
 }
@@ -454,7 +454,7 @@ static void dcb_app_print_filtered(const struct dcb_app_table *tab,
 
 		open_json_array(PRINT_JSON, NULL);
 		print_key(app->protocol);
-		print_uint(PRINT_ANY, NULL, "%d ", app->priority);
+		print_uint(PRINT_ANY, NULL, "%u ", app->priority);
 		close_json_array(PRINT_JSON, NULL);
 	}
 
@@ -519,7 +519,7 @@ static void dcb_app_print_default_prio(const struct dcb_app_table *tab)
 			print_string(PRINT_FP, NULL, "default-prio ", NULL);
 			first = false;
 		}
-		print_uint(PRINT_ANY, NULL, "%d ", tab->apps[i].priority);
+		print_uint(PRINT_ANY, NULL, "%u ", tab->apps[i].priority);
 	}
 
 	if (!first) {
@@ -550,13 +550,13 @@ static int dcb_app_get_table_attr_cb(const struct nlattr *attr, void *data)
 
 	if (!dcb_app_attr_type_validate(type)) {
 		fprintf(stderr,
-			"Unknown attribute in DCB_ATTR_IEEE_APP_TABLE: %d\n",
+			"Unknown attribute in DCB_ATTR_IEEE_APP_TABLE: %u\n",
 			type);
 		return MNL_CB_OK;
 	}
 	if (mnl_attr_get_payload_len(attr) < sizeof(struct dcb_app)) {
 		fprintf(stderr,
-			"%s payload expected to have size %zd, not %d\n",
+			"%s payload expected to have size %zu, not %u\n",
 			ieee_attrs_app_names[type], sizeof(struct dcb_app),
 			mnl_attr_get_payload_len(attr));
 		return MNL_CB_OK;

-- 
2.34.1


