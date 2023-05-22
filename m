Return-Path: <netdev+bounces-4396-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37A2170C56B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:41:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F03F21C20B6E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B05061643F;
	Mon, 22 May 2023 18:41:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E751641F
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:41:33 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECED11A
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684780889; x=1716316889;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=uYa82/qjX7//OFvIcicvGXMubHSVLKMTGcZH7kb3plo=;
  b=DeIpAokcrnDBJ7SgjgTmpBZRNYH9z4LfioqDRyw2gnYKMsIJsdwl5j5m
   3gPWfFi14wstnvxPJw5UAQ9XTVR7GVDzaUvQOY4LYPHiblT+fD183L7iB
   hSG0hPLE3nBOForcKgqL4V+zXFBHZA39/WdiblcCFkNAHTE9wJqD1QDt+
   BCNFi9fF0C2gq6eMw9y9WN/SZeZ2Hea3riGtgQqwy+pBXpXjEV1FXn11P
   /3+k+JmZKdU5DkccC6hUTObcA7gUbvbQpWBWIyJYVgpqKJ6aGR+NrX6IW
   1XNyKbhR9NJjvJUK7kkNZ6YXngkXXGf3IRvUK8p4PRLb+d3CC3+s8rL1m
   w==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="214969716"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 11:41:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 11:41:27 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 22 May 2023 11:41:25 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Mon, 22 May 2023 20:41:04 +0200
Subject: [PATCH iproute2-next 1/9] dcb: app: expose dcb-app functions in
 new header
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v1-1-83adc1f93356@microchip.com>
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add new headerfile dcb-app.h that exposes the functions required later
by dcb-rewr. The new dcb-rewr implementation will reuse much of the
existing dcb-app code.

I thought this called for a separate header file, instead of polluting
the existing dcb.h file.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb.h     |  9 ++-------
 dcb/dcb_app.c | 54 ++++++++++++++++++------------------------------------
 dcb/dcb_app.h | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 43 deletions(-)

diff --git a/dcb/dcb.h b/dcb/dcb.h
index d40664f29dad..4c8a4aa25e0c 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -6,6 +6,8 @@
 #include <stdbool.h>
 #include <stddef.h>
 
+#include "dcb_app.h"
+
 /* dcb.c */
 
 struct dcb {
@@ -54,13 +56,6 @@ void dcb_print_array_on_off(const __u8 *array, size_t size);
 void dcb_print_array_kw(const __u8 *array, size_t array_size,
 			const char *const kw[], size_t kw_size);
 
-/* dcb_app.c */
-
-int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
-enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
-bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
-bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
-
 /* dcb_apptrust.c */
 
 int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index eeb78e70f63f..df339babd8e6 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -10,8 +10,6 @@
 #include "utils.h"
 #include "rt_names.h"
 
-#define DCB_APP_PCP_MAX 15
-
 static const char *const pcp_names[DCB_APP_PCP_MAX + 1] = {
 	"0nd", "1nd", "2nd", "3nd", "4nd", "5nd", "6nd", "7nd",
 	"0de", "1de", "2de", "3de", "4de", "5de", "6de", "7de"
@@ -22,6 +20,7 @@ static const char *const ieee_attrs_app_names[__DCB_ATTR_IEEE_APP_MAX] = {
 	[DCB_ATTR_DCB_APP] = "DCB_ATTR_DCB_APP"
 };
 
+
 static void dcb_app_help_add(void)
 {
 	fprintf(stderr,
@@ -68,11 +67,6 @@ static void dcb_app_help(void)
 	dcb_app_help_add();
 }
 
-struct dcb_app_table {
-	struct dcb_app *apps;
-	size_t n_apps;
-};
-
 enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector)
 {
 	switch (selector) {
@@ -105,7 +99,7 @@ bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector)
 	return dcb_app_attr_type_get(selector) == type;
 }
 
-static void dcb_app_table_fini(struct dcb_app_table *tab)
+void dcb_app_table_fini(struct dcb_app_table *tab)
 {
 	free(tab->apps);
 }
@@ -124,8 +118,8 @@ static int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
 	return 0;
 }
 
-static void dcb_app_table_remove_existing(struct dcb_app_table *a,
-					  const struct dcb_app_table *b)
+void dcb_app_table_remove_existing(struct dcb_app_table *a,
+				   const struct dcb_app_table *b)
 {
 	size_t ia, ja;
 	size_t ib;
@@ -152,8 +146,8 @@ static void dcb_app_table_remove_existing(struct dcb_app_table *a,
 	a->n_apps = ja;
 }
 
-static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
-					  const struct dcb_app_table *b)
+void dcb_app_table_remove_replaced(struct dcb_app_table *a,
+				   const struct dcb_app_table *b)
 {
 	size_t ia, ja;
 	size_t ib;
@@ -189,8 +183,7 @@ static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
 	a->n_apps = ja;
 }
 
-static int dcb_app_table_copy(struct dcb_app_table *a,
-			      const struct dcb_app_table *b)
+int dcb_app_table_copy(struct dcb_app_table *a, const struct dcb_app_table *b)
 {
 	size_t i;
 	int ret;
@@ -217,18 +210,12 @@ static int dcb_app_cmp_cb(const void *a, const void *b)
 	return dcb_app_cmp(a, b);
 }
 
-static void dcb_app_table_sort(struct dcb_app_table *tab)
+void dcb_app_table_sort(struct dcb_app_table *tab)
 {
 	qsort(tab->apps, tab->n_apps, sizeof(*tab->apps), dcb_app_cmp_cb);
 }
 
-struct dcb_app_parse_mapping {
-	__u8 selector;
-	struct dcb_app_table *tab;
-	int err;
-};
-
-static void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
+void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
 {
 	struct dcb_app_parse_mapping *pm = data;
 	struct dcb_app app = {
@@ -260,7 +247,7 @@ static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data
 				 dcb_app_parse_mapping_cb, data);
 }
 
-static int dcb_app_parse_pcp(__u32 *key, const char *arg)
+int dcb_app_parse_pcp(__u32 *key, const char *arg)
 {
 	int i;
 
@@ -286,7 +273,7 @@ static int dcb_app_parse_mapping_pcp_prio(__u32 key, char *value, void *data)
 				 dcb_app_parse_mapping_cb, data);
 }
 
-static int dcb_app_parse_dscp(__u32 *key, const char *arg)
+int dcb_app_parse_dscp(__u32 *key, const char *arg)
 {
 	if (parse_mapping_num_all(key, arg) == 0)
 		return 0;
@@ -377,12 +364,12 @@ static bool dcb_app_is_default(const struct dcb_app *app)
 	       app->protocol == 0;
 }
 
-static bool dcb_app_is_dscp(const struct dcb_app *app)
+bool dcb_app_is_dscp(const struct dcb_app *app)
 {
 	return app->selector == IEEE_8021QAZ_APP_SEL_DSCP;
 }
 
-static bool dcb_app_is_pcp(const struct dcb_app *app)
+bool dcb_app_is_pcp(const struct dcb_app *app)
 {
 	return app->selector == DCB_APP_SEL_PCP;
 }
@@ -402,7 +389,7 @@ static bool dcb_app_is_port(const struct dcb_app *app)
 	return app->selector == IEEE_8021QAZ_APP_SEL_ANY;
 }
 
-static int dcb_app_print_key_dec(__u16 protocol)
+int dcb_app_print_key_dec(__u16 protocol)
 {
 	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
 }
@@ -412,7 +399,7 @@ static int dcb_app_print_key_hex(__u16 protocol)
 	return print_uint(PRINT_ANY, NULL, "%x:", protocol);
 }
 
-static int dcb_app_print_key_dscp(__u16 protocol)
+int dcb_app_print_key_dscp(__u16 protocol)
 {
 	const char *name = rtnl_dsfield_get_name(protocol << 2);
 
@@ -422,7 +409,7 @@ static int dcb_app_print_key_dscp(__u16 protocol)
 	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
 }
 
-static int dcb_app_print_key_pcp(__u16 protocol)
+int dcb_app_print_key_pcp(__u16 protocol)
 {
 	/* Print in numerical form, if protocol value is out-of-range */
 	if (protocol > DCB_APP_PCP_MAX)
@@ -577,7 +564,7 @@ static int dcb_app_get_table_attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab)
+int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab)
 {
 	uint16_t payload_len;
 	void *payload;
@@ -594,11 +581,6 @@ static int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *t
 	return 0;
 }
 
-struct dcb_app_add_del {
-	const struct dcb_app_table *tab;
-	bool (*filter)(const struct dcb_app *app);
-};
-
 static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
 {
 	struct dcb_app_add_del *add_del = data;
@@ -620,7 +602,7 @@ static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
 	return 0;
 }
 
-static int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
+int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
 			   const struct dcb_app_table *tab,
 			   bool (*filter)(const struct dcb_app *))
 {
diff --git a/dcb/dcb_app.h b/dcb/dcb_app.h
new file mode 100644
index 000000000000..8e7b010dcf75
--- /dev/null
+++ b/dcb/dcb_app.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __DCB_APP_H_
+#define __DCB_APP_H_
+
+struct dcb;
+
+struct dcb_app_table {
+	struct dcb_app *apps;
+	size_t n_apps;
+};
+
+struct dcb_app_add_del {
+	const struct dcb_app_table *tab;
+	bool (*filter)(const struct dcb_app *app);
+};
+
+struct dcb_app_parse_mapping {
+	__u8 selector;
+	struct dcb_app_table *tab;
+	int err;
+};
+
+#define DCB_APP_PCP_MAX 15
+
+int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
+
+int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab);
+int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
+		    const struct dcb_app_table *tab,
+		    bool (*filter)(const struct dcb_app *));
+
+void dcb_app_table_sort(struct dcb_app_table *tab);
+void dcb_app_table_fini(struct dcb_app_table *tab);
+int dcb_app_table_copy(struct dcb_app_table *a, const struct dcb_app_table *b);
+void dcb_app_table_remove_replaced(struct dcb_app_table *a,
+				   const struct dcb_app_table *b);
+void dcb_app_table_remove_existing(struct dcb_app_table *a,
+				   const struct dcb_app_table *b);
+
+bool dcb_app_is_pcp(const struct dcb_app *app);
+bool dcb_app_is_dscp(const struct dcb_app *app);
+
+int dcb_app_print_key_dec(__u16 protocol);
+int dcb_app_print_key_dscp(__u16 protocol);
+int dcb_app_print_key_pcp(__u16 protocol);
+
+int dcb_app_parse_pcp(__u32 *key, const char *arg);
+int dcb_app_parse_dscp(__u32 *key, const char *arg);
+void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data);
+
+bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
+bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
+enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
+
+#endif

-- 
2.34.1


