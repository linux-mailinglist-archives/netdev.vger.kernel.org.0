Return-Path: <netdev+bounces-8307-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28EDE7238E0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:22:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82A201C20E40
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613C527727;
	Tue,  6 Jun 2023 07:20:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5174E24132
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:20:34 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6203DE5E
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686036019; x=1717572019;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=0aLnW9TTygaOt5fQ/F0TLi/eHZkLYdaHltxKvVsC+1Y=;
  b=m0OpFc25FSruExk5Vp18149H+cZMvi5ftEhF8ahywDGPiuoJYA0DxIm2
   j30zcqrmVV2HH7c02YE+Ln0+l4+3DwFBwobXgDt1AaiKmZ2w/xiUSoLBy
   qGsH5AJQfD12DwRgT+OKSijO4fgWnU3NvAfoh5RwkdGZLIfH1Ss0HLgvK
   lu88JMr/h7Pmu3BZAXl70VBqdiDHxgKPMW8S/NUnLM44v90GnUefEDGh+
   o+uxd+t2/z+sPSavZFSprMyjjtR9VfUvSU3XFsX6Ouq8XmIMKU0VFxWQX
   hBbzN9KJ4Qh1T8nn3XPoizKvNgFmh7vWXlOs30wrP+7oWgXpau7M7x9Gw
   A==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="219027996"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 00:20:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 00:20:18 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 00:20:17 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Tue, 6 Jun 2023 09:19:42 +0200
Subject: [PATCH iproute2-next v3 07/12] dcb: app: expose functions required
 by dcb-rewr
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v3-7-60a766f72e61@microchip.com>
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

In preparation for the dcb-rewr implementation, expose required
functions, and structs.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb.h     | 49 ++++++++++++++++++++++++++++++++++++++++++++
 dcb/dcb_app.c | 66 +++++++++++++++++++++++------------------------------------
 2 files changed, 75 insertions(+), 40 deletions(-)

diff --git a/dcb/dcb.h b/dcb/dcb.h
index d40664f29dad..82ad72bc9ff3 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -56,11 +56,60 @@ void dcb_print_array_kw(const __u8 *array, size_t array_size,
 
 /* dcb_app.c */
 
+struct dcb_app_table {
+	struct dcb_app *apps;
+	size_t n_apps;
+	int attr;
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
 int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
+
+int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab);
+int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
+		    const struct dcb_app_table *tab,
+		    bool (*filter)(const struct dcb_app *));
+
+bool dcb_app_is_dscp(const struct dcb_app *app);
+bool dcb_app_is_pcp(const struct dcb_app *app);
+
+int dcb_app_print_pid_dscp(__u16 protocol);
+int dcb_app_print_pid_pcp(__u16 protocol);
+int dcb_app_print_pid_dec(__u16 protocol);
+void dcb_app_print_filtered(const struct dcb_app_table *tab,
+			    bool (*filter)(const struct dcb_app *),
+			    void (*print_pid_prio)(int (*print_pid)(__u16),
+						   const struct dcb_app *),
+			    int (*print_pid)(__u16 protocol),
+			    const char *json_name,
+			    const char *fp_name);
+
 enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
 bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
 bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
 
+int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app);
+int dcb_app_table_copy(struct dcb_app_table *a,
+		       const struct dcb_app_table *b);
+void dcb_app_table_sort(struct dcb_app_table *tab);
+void dcb_app_table_fini(struct dcb_app_table *tab);
+void dcb_app_table_remove_existing(struct dcb_app_table *a,
+				   const struct dcb_app_table *b);
+void dcb_app_table_remove_replaced(struct dcb_app_table *a,
+				   const struct dcb_app_table *b,
+				   bool (*key_eq)(const struct dcb_app *aa,
+						  const struct dcb_app *ab));
+
+int dcb_app_parse_pcp(__u32 *key, const char *arg);
+int dcb_app_parse_dscp(__u32 *key, const char *arg);
+
 /* dcb_apptrust.c */
 
 int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 4b309016fb65..9c2727eff7d8 100644
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
@@ -68,12 +66,6 @@ static void dcb_app_help(void)
 	dcb_app_help_add();
 }
 
-struct dcb_app_table {
-	struct dcb_app *apps;
-	size_t n_apps;
-	int attr;
-};
-
 enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector)
 {
 	switch (selector) {
@@ -106,12 +98,12 @@ bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector)
 	return dcb_app_attr_type_get(selector) == type;
 }
 
-static void dcb_app_table_fini(struct dcb_app_table *tab)
+void dcb_app_table_fini(struct dcb_app_table *tab)
 {
 	free(tab->apps);
 }
 
-static int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
+int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
 {
 	struct dcb_app *apps = realloc(tab->apps, (tab->n_apps + 1) * sizeof(*tab->apps));
 
@@ -125,8 +117,8 @@ static int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
 	return 0;
 }
 
-static void dcb_app_table_remove_existing(struct dcb_app_table *a,
-					  const struct dcb_app_table *b)
+void dcb_app_table_remove_existing(struct dcb_app_table *a,
+				   const struct dcb_app_table *b)
 {
 	size_t ia, ja;
 	size_t ib;
@@ -159,7 +151,7 @@ static bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab)
 	       aa->protocol == ab->protocol;
 }
 
-static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
+void dcb_app_table_remove_replaced(struct dcb_app_table *a,
 				   const struct dcb_app_table *b,
 				   bool (*key_eq)(const struct dcb_app *aa,
 						  const struct dcb_app *ab))
@@ -198,8 +190,8 @@ static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
 	a->n_apps = ja;
 }
 
-static int dcb_app_table_copy(struct dcb_app_table *a,
-			      const struct dcb_app_table *b)
+int dcb_app_table_copy(struct dcb_app_table *a,
+		       const struct dcb_app_table *b)
 {
 	size_t i;
 	int ret;
@@ -226,17 +218,11 @@ static int dcb_app_cmp_cb(const void *a, const void *b)
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
 static void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
 {
 	struct dcb_app_parse_mapping *pm = data;
@@ -269,7 +255,7 @@ static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data
 				 dcb_app_parse_mapping_cb, data);
 }
 
-static int dcb_app_parse_pcp(__u32 *key, const char *arg)
+int dcb_app_parse_pcp(__u32 *key, const char *arg)
 {
 	int i;
 
@@ -295,7 +281,7 @@ static int dcb_app_parse_mapping_pcp_prio(__u32 key, char *value, void *data)
 				 dcb_app_parse_mapping_cb, data);
 }
 
-static int dcb_app_parse_dscp(__u32 *key, const char *arg)
+int dcb_app_parse_dscp(__u32 *key, const char *arg)
 {
 	if (parse_mapping_num_all(key, arg) == 0)
 		return 0;
@@ -386,12 +372,12 @@ static bool dcb_app_is_default(const struct dcb_app *app)
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
@@ -411,7 +397,7 @@ static bool dcb_app_is_port(const struct dcb_app *app)
 	return app->selector == IEEE_8021QAZ_APP_SEL_ANY;
 }
 
-static int dcb_app_print_pid_dec(__u16 protocol)
+int dcb_app_print_pid_dec(__u16 protocol)
 {
 	return print_uint(PRINT_ANY, NULL, "%u", protocol);
 }
@@ -421,7 +407,7 @@ static int dcb_app_print_pid_hex(__u16 protocol)
 	return print_uint(PRINT_ANY, NULL, "%x", protocol);
 }
 
-static int dcb_app_print_pid_dscp(__u16 protocol)
+int dcb_app_print_pid_dscp(__u16 protocol)
 {
 	const char *name = rtnl_dsfield_get_name(protocol << 2);
 
@@ -431,7 +417,7 @@ static int dcb_app_print_pid_dscp(__u16 protocol)
 	return print_uint(PRINT_ANY, NULL, "%u", protocol);
 }
 
-static int dcb_app_print_pid_pcp(__u16 protocol)
+int dcb_app_print_pid_pcp(__u16 protocol)
 {
 	/* Print in numerical form, if protocol value is out-of-range */
 	if (protocol > DCB_APP_PCP_MAX)
@@ -440,13 +426,13 @@ static int dcb_app_print_pid_pcp(__u16 protocol)
 	return print_string(PRINT_ANY, NULL, "%s", pcp_names[protocol]);
 }
 
-static void dcb_app_print_filtered(const struct dcb_app_table *tab,
-				   bool (*filter)(const struct dcb_app *),
-				   void (*print_pid_prio)(int (*print_pid)(__u16),
-							  const struct dcb_app *),
-				   int (*print_pid)(__u16 protocol),
-				   const char *json_name,
-				   const char *fp_name)
+void dcb_app_print_filtered(const struct dcb_app_table *tab,
+			    bool (*filter)(const struct dcb_app *),
+			    void (*print_pid_prio)(int (*print_pid)(__u16),
+						   const struct dcb_app *),
+			    int (*print_pid)(__u16 protocol),
+			    const char *json_name,
+			    const char *fp_name)
 {
 	bool first = true;
 	size_t i;
@@ -601,7 +587,7 @@ static int dcb_app_get_table_attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab)
+int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab)
 {
 	uint16_t payload_len;
 	void *payload;
@@ -644,9 +630,9 @@ static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
 	return 0;
 }
 
-static int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
-			   const struct dcb_app_table *tab,
-			   bool (*filter)(const struct dcb_app *))
+int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
+		    const struct dcb_app_table *tab,
+		    bool (*filter)(const struct dcb_app *))
 {
 	struct dcb_app_add_del add_del = {
 		.tab = tab,

-- 
2.34.1


