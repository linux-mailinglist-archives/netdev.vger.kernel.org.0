Return-Path: <netdev+bounces-8304-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB3407238D6
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F2E91C20E15
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A5651118E;
	Tue,  6 Jun 2023 07:20:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34261097E
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:20:32 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C0910D0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686036014; x=1717572014;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=loEFBV9uD0uMUW/MxstjP1kjKYMn/HSFoDn/oCMlINU=;
  b=PD2YVHkDpt9YyLd9JiZOimbNAKXYWm+4v/d0kxcGhj+KtPbY82vkf7lg
   2LLhsffM+FlwkYV0syWEVi0+9jk8miMUOZBdJ5cnYJGVfxHxTBIxsrBtv
   ZHWoJrZ+qRu4aZ3YkZZnr/6VoaT0LD3AV+jqVCeSghBWtsbuAtOwCbphH
   EnV00I8rjqrOJnvmxLiq25AZwl7kjhcDHnd5icMyVfucJkguIT8RDI2aW
   SR07Nu3zwdcEBqNfPkLA6GcsLt3jQLMDGtA/DMwCz7dscx8+ecHnmd3vy
   ILWsnG3QK+k4XbxDmHYmy9CIqCfhGi6Ceb46ujmHqU55AK7c8YejODKmB
   w==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="214809808"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 00:20:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 00:20:13 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 00:20:12 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Tue, 6 Jun 2023 09:19:39 +0200
Subject: [PATCH iproute2-next v3 04/12] dcb: app: rename
 dcb_app_print_key_*() functions
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v3-4-60a766f72e61@microchip.com>
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
rename the _print_key_*() functions to _print_pid_*(), as the protocol
can both be key and value with the introduction of dcb-rewr.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb_app.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index ed7930ae7b37..a8f3424db9f7 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -403,17 +403,17 @@ static bool dcb_app_is_port(const struct dcb_app *app)
 	return app->selector == IEEE_8021QAZ_APP_SEL_ANY;
 }
 
-static int dcb_app_print_key_dec(__u16 protocol)
+static int dcb_app_print_pid_dec(__u16 protocol)
 {
 	return print_uint(PRINT_ANY, NULL, "%u", protocol);
 }
 
-static int dcb_app_print_key_hex(__u16 protocol)
+static int dcb_app_print_pid_hex(__u16 protocol)
 {
 	return print_uint(PRINT_ANY, NULL, "%x", protocol);
 }
 
-static int dcb_app_print_key_dscp(__u16 protocol)
+static int dcb_app_print_pid_dscp(__u16 protocol)
 {
 	const char *name = rtnl_dsfield_get_name(protocol << 2);
 
@@ -423,7 +423,7 @@ static int dcb_app_print_key_dscp(__u16 protocol)
 	return print_uint(PRINT_ANY, NULL, "%u", protocol);
 }
 
-static int dcb_app_print_key_pcp(__u16 protocol)
+static int dcb_app_print_pid_pcp(__u16 protocol)
 {
 	/* Print in numerical form, if protocol value is out-of-range */
 	if (protocol > DCB_APP_PCP_MAX)
@@ -466,7 +466,7 @@ static void dcb_app_print_filtered(const struct dcb_app_table *tab,
 
 static void dcb_app_print_ethtype_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_ethtype,  dcb_app_print_key_hex,
+	dcb_app_print_filtered(tab, dcb_app_is_ethtype,  dcb_app_print_pid_hex,
 			       "ethtype_prio", "ethtype-prio");
 }
 
@@ -474,8 +474,8 @@ static void dcb_app_print_pcp_prio(const struct dcb *dcb,
 				   const struct dcb_app_table *tab)
 {
 	dcb_app_print_filtered(tab, dcb_app_is_pcp,
-			       dcb->numeric ? dcb_app_print_key_dec
-					    : dcb_app_print_key_pcp,
+			       dcb->numeric ? dcb_app_print_pid_dec
+					    : dcb_app_print_pid_pcp,
 			       "pcp_prio", "pcp-prio");
 }
 
@@ -483,26 +483,26 @@ static void dcb_app_print_dscp_prio(const struct dcb *dcb,
 				    const struct dcb_app_table *tab)
 {
 	dcb_app_print_filtered(tab, dcb_app_is_dscp,
-			       dcb->numeric ? dcb_app_print_key_dec
-					    : dcb_app_print_key_dscp,
+			       dcb->numeric ? dcb_app_print_pid_dec
+					    : dcb_app_print_pid_dscp,
 			       "dscp_prio", "dscp-prio");
 }
 
 static void dcb_app_print_stream_port_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_stream_port, dcb_app_print_key_dec,
+	dcb_app_print_filtered(tab, dcb_app_is_stream_port, dcb_app_print_pid_dec,
 			       "stream_port_prio", "stream-port-prio");
 }
 
 static void dcb_app_print_dgram_port_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_dgram_port, dcb_app_print_key_dec,
+	dcb_app_print_filtered(tab, dcb_app_is_dgram_port, dcb_app_print_pid_dec,
 			       "dgram_port_prio", "dgram-port-prio");
 }
 
 static void dcb_app_print_port_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_port, dcb_app_print_key_dec,
+	dcb_app_print_filtered(tab, dcb_app_is_port, dcb_app_print_pid_dec,
 			       "port_prio", "port-prio");
 }
 

-- 
2.34.1


