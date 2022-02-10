Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBD64B0E05
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241888AbiBJNAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:00:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbiBJNAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:00:23 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD571034
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644498024; x=1676034024;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GNnbNJWmrAn2uC89IGfjoP7mkqSNYDuGvANFcC7t4EA=;
  b=GxccRIr7Y/b5/pSpWdkySdYKRRnT3qtyA05TySANQAsTQFymZjJUWN1z
   9j4aqkzJLsr7yAFu5E1wi78xoLHKPABpVrimbUlwruyEgqLdUxr9SwG5P
   CjwvBFs4SYyjC6x9hlOceovjEcdGg2gmWxUOAQWlNxS2u8yJslzghEJqD
   5p/EFpCc1BG5tJvFt5iMJRi8YOzB595G+/5ji8nIWjnOL8Xgj7YD246dV
   LoOXMnaS3WPFFflnkxh6uRqqAzDhSushYX4VZdY4pxBjwZukhV/yVM2FP
   wAPg58f5dMKSOOKAu4SUeHPgupLaVh4qCg/GLC2zOOTsUHKw9Jsfe17nz
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="335900519"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="335900519"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 05:00:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="771719957"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 10 Feb 2022 05:00:22 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 21AD0LM8031763;
        Thu, 10 Feb 2022 13:00:21 GMT
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org
Subject: [PATCH iproute2-next v2] f_flower: fix indentation for enc_key_id and u32
Date:   Thu, 10 Feb 2022 13:57:15 +0100
Message-Id: <20220210125715.54568-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b2450e46b7b2 ("flower: fix clang warnings") caused enc_key_id
and u32 to be printed without indentation. Fix this by printing two
spaces before calling print_uint_name_value.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v2: use unsigned int instead of uint in print_uint_indent_name_value
---
 tc/f_flower.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 1ff8341d27a6..6c1d0df62255 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -109,6 +109,12 @@ static void print_indent_name_value(const char *name, const char *value)
 	print_string_name_value(name, value);
 }
 
+static void print_uint_indent_name_value(const char *name, unsigned int value)
+{
+	print_string(PRINT_FP, NULL, "  ", NULL);
+	print_uint_name_value(name, value);
+}
+
 static int flower_parse_eth_addr(char *str, int addr_type, int mask_type,
 				 struct nlmsghdr *n)
 {
@@ -2324,7 +2330,7 @@ static void flower_print_key_id(const char *name, struct rtattr *attr)
 		return;
 
 	print_nl();
-	print_uint_name_value(name, rta_getattr_be32(attr));
+	print_uint_indent_name_value(name, rta_getattr_be32(attr));
 }
 
 static void flower_print_geneve_opts(const char *name, struct rtattr *attr,
@@ -2573,7 +2579,7 @@ static void flower_print_u32(const char *name, struct rtattr *attr)
 		return;
 
 	print_nl();
-	print_uint_name_value(name, rta_getattr_u32(attr));
+	print_uint_indent_name_value(name, rta_getattr_u32(attr));
 }
 
 static void flower_print_mpls_opt_lse(struct rtattr *lse)
-- 
2.31.1

