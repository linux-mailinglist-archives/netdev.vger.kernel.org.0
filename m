Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FB049C6A2
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbiAZJj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:39:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:26605 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239281AbiAZJjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 04:39:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643189979; x=1674725979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KcRtycUl4lDfGh110lR4XASfjxvG1FP1xhGR1aDDOAA=;
  b=dzDcJHul1ERWMAXInc7mCYqO/OtfydXH71bwwKDrKgFXTdbbYq/BS0uQ
   5MXU9Yo5tC88ibxVWKmi1Zy8W8/phJNOZE+s0IRS285Nan+qPhSpG1/gu
   9CpMoO2vwRFgSsKwxZfRNGSzk+B8yo21ZkynCy5xMSqb48ikcbSoECMPh
   YNhhCHyQ1uhNKWK9GpQmPLj8RgE+df1vG2I7yNMkvv0LkKHCMURFD8EQH
   +5XotoVOvLynbFlVx1I/w6SpYg/H8d4igv9ggoDH9xH9azfqKCEvl/D83
   4HfGY28KI1yPN6gReSzUJUHjW07g7/r2todelJgghBEIpOo2aVAgEt/By
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="244114638"
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="244114638"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 01:39:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="477433109"
Received: from lucas-s2600cw.jf.intel.com ([10.165.21.202])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 01:39:30 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>, Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH v2 10/11] tomoyo: Use str_yes_no()
Date:   Wed, 26 Jan 2022 01:39:50 -0800
Message-Id: <20220126093951.1470898-11-lucas.demarchi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126093951.1470898-1-lucas.demarchi@intel.com>
References: <20220126093951.1470898-1-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the local yesno() implementation and adopt the str_yes_no() from
linux/string_helpers.h.

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 security/tomoyo/audit.c  |  2 +-
 security/tomoyo/common.c | 19 +++++--------------
 security/tomoyo/common.h |  1 -
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/security/tomoyo/audit.c b/security/tomoyo/audit.c
index d79bf07e16be..023bedd9dfa3 100644
--- a/security/tomoyo/audit.c
+++ b/security/tomoyo/audit.c
@@ -166,7 +166,7 @@ static char *tomoyo_print_header(struct tomoyo_request_info *r)
 		       "#%04u/%02u/%02u %02u:%02u:%02u# profile=%u mode=%s granted=%s (global-pid=%u) task={ pid=%u ppid=%u uid=%u gid=%u euid=%u egid=%u suid=%u sgid=%u fsuid=%u fsgid=%u }",
 		       stamp.year, stamp.month, stamp.day, stamp.hour,
 		       stamp.min, stamp.sec, r->profile, tomoyo_mode[r->mode],
-		       tomoyo_yesno(r->granted), gpid, tomoyo_sys_getpid(),
+		       str_yes_no(r->granted), gpid, tomoyo_sys_getpid(),
 		       tomoyo_sys_getppid(),
 		       from_kuid(&init_user_ns, current_uid()),
 		       from_kgid(&init_user_ns, current_gid()),
diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 5c64927bf2b3..ff17abc96e5c 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -8,6 +8,7 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/security.h>
+#include <linux/string_helpers.h>
 #include "common.h"
 
 /* String table for operation mode. */
@@ -174,16 +175,6 @@ static bool tomoyo_manage_by_non_root;
 
 /* Utility functions. */
 
-/**
- * tomoyo_yesno - Return "yes" or "no".
- *
- * @value: Bool value.
- */
-const char *tomoyo_yesno(const unsigned int value)
-{
-	return value ? "yes" : "no";
-}
-
 /**
  * tomoyo_addprintf - strncat()-like-snprintf().
  *
@@ -730,8 +721,8 @@ static void tomoyo_print_config(struct tomoyo_io_buffer *head, const u8 config)
 {
 	tomoyo_io_printf(head, "={ mode=%s grant_log=%s reject_log=%s }\n",
 			 tomoyo_mode[config & 3],
-			 tomoyo_yesno(config & TOMOYO_CONFIG_WANT_GRANT_LOG),
-			 tomoyo_yesno(config & TOMOYO_CONFIG_WANT_REJECT_LOG));
+			 str_yes_no(config & TOMOYO_CONFIG_WANT_GRANT_LOG),
+			 str_yes_no(config & TOMOYO_CONFIG_WANT_REJECT_LOG));
 }
 
 /**
@@ -1354,8 +1345,8 @@ static bool tomoyo_print_condition(struct tomoyo_io_buffer *head,
 	case 3:
 		if (cond->grant_log != TOMOYO_GRANTLOG_AUTO)
 			tomoyo_io_printf(head, " grant_log=%s",
-					 tomoyo_yesno(cond->grant_log ==
-						      TOMOYO_GRANTLOG_YES));
+					 str_yes_no(cond->grant_log ==
+						    TOMOYO_GRANTLOG_YES));
 		tomoyo_set_lf(head);
 		return true;
 	}
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index 85246b9df7ca..ca285f362705 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -959,7 +959,6 @@ char *tomoyo_read_token(struct tomoyo_acl_param *param);
 char *tomoyo_realpath_from_path(const struct path *path);
 char *tomoyo_realpath_nofollow(const char *pathname);
 const char *tomoyo_get_exe(void);
-const char *tomoyo_yesno(const unsigned int value);
 const struct tomoyo_path_info *tomoyo_compare_name_union
 (const struct tomoyo_path_info *name, const struct tomoyo_name_union *ptr);
 const struct tomoyo_path_info *tomoyo_get_domainname
-- 
2.34.1

