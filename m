Return-Path: <netdev+bounces-4397-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3854570C56D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:42:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0CB4281108
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDB9168BF;
	Mon, 22 May 2023 18:41:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA3F168B9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:41:36 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3819718B
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684780890; x=1716316890;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=9ezf1ZQc5Uwx0m6kF828+rN5S5pfb5JqHrcbI/QkGT0=;
  b=wK+sh6j+q5cEknZQsCKn43nvMOC/4sS9rUN5SXQOLBkdIHrR+ToXfRac
   ckiejZuWtUXc0He/nCzSEuoiYTwY5IyelK8hoOux9OTh8kXkF9LzU/iCT
   LXrG9f+ZBH6s68YXl944NWAJnmePag4l4G2pZd6R9Y2DgPpt79WRNUYY2
   oIki5xm7lLQv0jTpNBc3BPBFJ2sZr4QiwgvrvH043Ki9G9Bl6KNBfLVRG
   SBAeaRhewlCWj8IuQkEde1cRZZXnC4XD8PeqTkRBILvHoSwQdgkM4cAdT
   mVh+8Of7Xc5KJBst1Qm9ClhmF+2bIKHRdNnUfCWtJytWDOckofFgrFKex
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="214969732"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 11:41:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 11:41:28 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 22 May 2023 11:41:27 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Mon, 22 May 2023 20:41:05 +0200
Subject: [PATCH iproute2-next 2/9] dcb: app: add new dcbnl attribute field
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v1-2-83adc1f93356@microchip.com>
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

Add a new field 'attr' to the dcb_app_table struct, in order to inject
different dcbnl get/set attributes for APP and rewrite. This is required
later, when a number of the existing dcb-app functions are refactored
for reuse by dcb-rewr.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb_app.c | 18 +++++++++---------
 dcb/dcb_app.h |  1 +
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index df339babd8e6..1d0da35f987d 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -570,7 +570,7 @@ int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab)
 	void *payload;
 	int ret;
 
-	ret = dcb_get_attribute_va(dcb, dev, DCB_ATTR_IEEE_APP_TABLE, &payload, &payload_len);
+	ret = dcb_get_attribute_va(dcb, dev, tab->attr, &payload, &payload_len);
 	if (ret != 0)
 		return ret;
 
@@ -588,7 +588,7 @@ static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
 	struct nlattr *nest;
 	size_t i;
 
-	nest = mnl_attr_nest_start(nlh, DCB_ATTR_IEEE_APP_TABLE);
+	nest = mnl_attr_nest_start(nlh, add_del->tab->attr);
 
 	for (i = 0; i < add_del->tab->n_apps; i++) {
 		const struct dcb_app *app = &add_del->tab->apps[i];
@@ -697,7 +697,7 @@ static int dcb_cmd_app_parse_add_del(struct dcb *dcb, const char *dev,
 
 static int dcb_cmd_app_add(struct dcb *dcb, const char *dev, int argc, char **argv)
 {
-	struct dcb_app_table tab = {};
+	struct dcb_app_table tab = { .attr = DCB_ATTR_IEEE_APP_TABLE };
 	int ret;
 
 	ret = dcb_cmd_app_parse_add_del(dcb, dev, argc, argv, &tab);
@@ -711,7 +711,7 @@ static int dcb_cmd_app_add(struct dcb *dcb, const char *dev, int argc, char **ar
 
 static int dcb_cmd_app_del(struct dcb *dcb, const char *dev, int argc, char **argv)
 {
-	struct dcb_app_table tab = {};
+	struct dcb_app_table tab = { .attr = DCB_ATTR_IEEE_APP_TABLE };
 	int ret;
 
 	ret = dcb_cmd_app_parse_add_del(dcb, dev, argc, argv, &tab);
@@ -725,7 +725,7 @@ static int dcb_cmd_app_del(struct dcb *dcb, const char *dev, int argc, char **ar
 
 static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **argv)
 {
-	struct dcb_app_table tab = {};
+	struct dcb_app_table tab = { .attr = DCB_ATTR_IEEE_APP_TABLE };
 	int ret;
 
 	ret = dcb_app_get(dcb, dev, &tab);
@@ -777,7 +777,7 @@ out:
 
 static int dcb_cmd_app_flush(struct dcb *dcb, const char *dev, int argc, char **argv)
 {
-	struct dcb_app_table tab = {};
+	struct dcb_app_table tab = { .attr = DCB_ATTR_IEEE_APP_TABLE };
 	int ret;
 
 	ret = dcb_app_get(dcb, dev, &tab);
@@ -830,9 +830,9 @@ out:
 
 static int dcb_cmd_app_replace(struct dcb *dcb, const char *dev, int argc, char **argv)
 {
-	struct dcb_app_table orig = {};
-	struct dcb_app_table tab = {};
-	struct dcb_app_table new = {};
+	struct dcb_app_table orig = { .attr = DCB_ATTR_IEEE_APP_TABLE };
+	struct dcb_app_table tab = { .attr = DCB_ATTR_IEEE_APP_TABLE };
+	struct dcb_app_table new = { .attr = DCB_ATTR_IEEE_APP_TABLE };
 	int ret;
 
 	ret = dcb_app_get(dcb, dev, &orig);
diff --git a/dcb/dcb_app.h b/dcb/dcb_app.h
index 8e7b010dcf75..3aea0bfd1786 100644
--- a/dcb/dcb_app.h
+++ b/dcb/dcb_app.h
@@ -7,6 +7,7 @@ struct dcb;
 struct dcb_app_table {
 	struct dcb_app *apps;
 	size_t n_apps;
+	int attr;
 };
 
 struct dcb_app_add_del {

-- 
2.34.1


