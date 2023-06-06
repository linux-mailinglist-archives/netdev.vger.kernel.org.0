Return-Path: <netdev+bounces-8308-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9657238E1
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:23:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 963A11C20E8E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D602328C14;
	Tue,  6 Jun 2023 07:20:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDCE611B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:20:35 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F50AE60
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686036023; x=1717572023;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=zN+PjeDzSFDEdv5Jhk42nP1VBAljb2fleW0XlIZxKBc=;
  b=Zx1XQ3Q6ct7a4U+hKpOmdBtDzFwuIF2qKr/5kOzl0ub0MqYBDZglLZG3
   dxZrQz0hhkCXwU4V30s9dOnANMJo+oU4Fx67HYt7Em37LcfYYZ2jdJ6rj
   vW4hrl0xaKWOfQQVj5CdZscIDiEaZB26Sl0K3gLcqFc3hqYnO7t6AqyRp
   1UgEkp6/WHBEnO4s+jSuQJiJQCmhzuapFQ6DU2yY7Qh+yd3XJ9hCAoqCK
   +51ilQGCAexOP6Ssm0D8kcMPkiBLn32D9so+5QEs0/ymzIb5RW/x5TxXO
   Ubzc+VOvayzFGDLjN9uJk9QmDgBtjmZxJ/PBvMgYKAl/1aGxAY/x0rhCc
   g==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="216983824"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 00:20:23 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 00:20:22 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 00:20:20 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Tue, 6 Jun 2023 09:19:44 +0200
Subject: [PATCH iproute2-next v3 09/12] dcb: rewr: add symbol for max DSCP
 value
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v3-9-60a766f72e61@microchip.com>
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

A symbol, DCB_APP_PCP_MAX, for maximum PCP value, already exists. Lets
add a symbol DCB_APP_DSCP_MAX and update accordingly.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb.h      | 1 +
 dcb/dcb_app.c  | 2 +-
 dcb/dcb_rewr.c | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/dcb/dcb.h b/dcb/dcb.h
index ff11a122ba37..b2e8e89f7701 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -73,6 +73,7 @@ struct dcb_app_parse_mapping {
 };
 
 #define DCB_APP_PCP_MAX 15
+#define DCB_APP_DSCP_MAX 63
 
 int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
 
diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 9c2727eff7d8..7040e62cbb47 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -306,7 +306,7 @@ static int dcb_app_parse_mapping_dscp_prio(__u32 key, char *value, void *data)
 	if (get_u8(&prio, value, 0))
 		return -EINVAL;
 
-	return dcb_parse_mapping("DSCP", key, 63,
+	return dcb_parse_mapping("DSCP", key, DCB_APP_DSCP_MAX,
 				 "PRIO", prio, IEEE_8021QAZ_MAX_TCS - 1,
 				 dcb_app_parse_mapping_cb, data);
 }
diff --git a/dcb/dcb_rewr.c b/dcb/dcb_rewr.c
index facbdbe664a4..5bb649adce24 100644
--- a/dcb/dcb_rewr.c
+++ b/dcb/dcb_rewr.c
@@ -76,7 +76,7 @@ static int dcb_rewr_parse_mapping_prio_dscp(__u32 key, char *value, void *data)
 		return -EINVAL;
 
 	return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1,
-				 "DSCP", dscp, 63,
+				 "DSCP", dscp, DCB_APP_DSCP_MAX,
 				 dcb_rewr_parse_mapping_cb, data);
 }
 

-- 
2.34.1


