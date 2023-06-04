Return-Path: <netdev+bounces-7774-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3638572176D
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 15:29:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A62CA1C20967
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 13:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34BBDAD24;
	Sun,  4 Jun 2023 13:28:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264E233F2
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 13:28:56 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E197DCD;
	Sun,  4 Jun 2023 06:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685885335; x=1717421335;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Zovk716GPnoB1qLDIB+AYUE5g3/yq4Mdf6F3N/4N33c=;
  b=PRh0S6AE/E6ABuRnAQIUs8+bi2k6CYSkI9mqeLYYZt37/J5ctQiE91Z1
   Q1udrAM7jhuBerQbY3KjKTWFED8NUJm2Is9OUIqHqikSKMTfNqCssd2Bd
   hj82X8rjoZ3oshdeAadqQ2+AHBfM3FrbIT4vHyqDsRKBRGIOG48ef/FTN
   juTfP3jqJ9dv7SGb/oWhPvNh52Q6luqE2zvV0XmmOWzeP8tkNpKrjiHTA
   xPiXWuqq/rdM2nVzTWmw7wcPKvWp2PBHmQ56wWnaoU5iQAFJtmD0d4W9U
   cav4htd73xo4+MTkHOf5elGbJM4vJvek7AGWmKadq+5WOkhV+vU0cj4t1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="356197738"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="356197738"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 06:28:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="955038532"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="955038532"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jun 2023 06:28:53 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id 2DE33204; Sun,  4 Jun 2023 16:28:59 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v1 1/1] mac_pton: Clean up the header inclusions
Date: Sun,  4 Jun 2023 16:28:58 +0300
Message-Id: <20230604132858.6650-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.40.0.1.gaa8946217a0b
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Since hex_to_bin() is provided by hex.h there is no need to require
kernel.h. Replace the latter by the former and add missing export.h.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/net_utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/net_utils.c b/lib/net_utils.c
index c17201df3d08..42bb0473fb22 100644
--- a/lib/net_utils.c
+++ b/lib/net_utils.c
@@ -2,7 +2,8 @@
 #include <linux/string.h>
 #include <linux/if_ether.h>
 #include <linux/ctype.h>
-#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/hex.h>
 
 bool mac_pton(const char *s, u8 *mac)
 {
-- 
2.40.0.1.gaa8946217a0b


