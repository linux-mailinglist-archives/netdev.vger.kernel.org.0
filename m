Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F9E6318A0
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 03:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiKUC3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 21:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiKUC3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 21:29:18 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6502A95F
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 18:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668997757; x=1700533757;
  h=from:to:cc:subject:date:message-id;
  bh=V9i1b20xtvNGSzyV1wht8aJ3//5lbdD6Lro2VAybm08=;
  b=ng5hu6QUT2phGnpDBsCfAvqEZj7tq7Y3T5KUNYt8k0aPLRu7wIX2DTwm
   xGp+sm69fWrr8rzXxiZUwjUOl+I5C11YpiGfrTvuaKquhidH1K6rAJ5Di
   a7CCiE7Slwn84JgPKw3hjCXSIbLyjcllPe8MZl7eMRoe9LXTgUUEdLHUn
   tbZHBcihjuUqhas3YMTaL7SAIoGTzopdvEcXg5ZPWe9cdlCNpouPLTuSE
   RWfatilK+fKpyWxOdQ6BD29QwMCV7nltHyx+rnc5HJsXmIOHLL+lrrH2f
   AZVj9KKgu1cHBL6098qShliKT7f93xQYjN1d8pXBuyh20C3SHh0gUuy47
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="375601909"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="375601909"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 18:29:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="709641471"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="709641471"
Received: from ssid-ilbpg3.png.intel.com ([10.88.227.111])
  by fmsmga004.fm.intel.com with ESMTP; 20 Nov 2022 18:29:14 -0800
From:   Lai Peter Jun Ann <jun.ann.lai@intel.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Lai Peter Jun Ann <jun.ann.lai@intel.com>
Subject: [PATCH iproute2-next v1] tc_util: Change datatype for maj to avoid overflow issue
Date:   Mon, 21 Nov 2022 10:29:09 +0800
Message-Id: <1668997749-5942-1-git-send-email-jun.ann.lai@intel.com>
X-Mailer: git-send-email 1.9.1
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value by stroul() is unsigned long int. Hence the datatype
for maj should defined as unsigned long to avoid overflow issue.

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Signed-off-by: Lai Peter Jun Ann <jun.ann.lai@intel.com>
---
 tc/tc_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 44137ad..f8d9c88 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -74,7 +74,7 @@ const char *get_tc_lib(void)
 
 int get_qdisc_handle(__u32 *h, const char *str)
 {
-	__u32 maj;
+	unsigned long maj;
 	char *p;
 
 	maj = TC_H_UNSPEC;
-- 
1.9.1

