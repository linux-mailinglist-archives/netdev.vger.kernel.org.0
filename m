Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852544B0B78
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240259AbiBJKzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 05:55:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240231AbiBJKzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:55:00 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91E1C24
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 02:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644490501; x=1676026501;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vweFh7VnaFRYNvvj/V4hsv++JuOv1C0XYoz/6dM0HhA=;
  b=kCbdcuO+nxhfe8V3yrm1juSrjlH7b0e26xXPTGinPWcM2SAskEXqYLql
   GS0vDeFqkSs7v1BOjdI+XAj9Tl21y8TzfOD2vfC/FNgRrlrcUWSgg4j8c
   99eyHXk2YoYiuxzVT8EuUgogSuHE5lw0Vqs5uqF4HCDCitEOVuhmhqLlq
   OQcy/w0M9c85ZB6lhn2Me4rFr9DTsaJ3jnVdh5IdwFK6FOCENV9i4dQPd
   RQ8xM+162hQvbMknoHB3zRnN3NCzaiqORIqI1d7egBEtLgh7JVbubKv0w
   SY0AjiLZyxy/bKtUUhlEHocSZHwT0PfvMAKQ+/JmJfGdOJNYPdQHNoS/J
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="236867510"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="236867510"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 02:55:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="526433568"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 10 Feb 2022 02:55:00 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 21AAswZe001996;
        Thu, 10 Feb 2022 10:54:58 GMT
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org
Subject: [PATCH iproute2-next] f_flower: fix indentation for enc_key_id and u32
Date:   Thu, 10 Feb 2022 11:51:52 +0100
Message-Id: <20220210105152.48904-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 tc/f_flower.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 1ff8341d27a6..b7dc37a112a2 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -109,6 +109,12 @@ static void print_indent_name_value(const char *name, const char *value)
 	print_string_name_value(name, value);
 }
 
+static void print_uint_indent_name_value(const char *name, uint value)
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

