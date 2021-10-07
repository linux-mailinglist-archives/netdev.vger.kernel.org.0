Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F169F425060
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 11:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbhJGJx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 05:53:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:46353 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232662AbhJGJx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 05:53:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="287094687"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="287094687"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 02:51:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="568576676"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 07 Oct 2021 02:51:29 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 1E24C3A3; Thu,  7 Oct 2021 12:51:36 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kunit-dev@googlegroups.com, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 3/4] lib/rhashtable: Replace kernel.h with the necessary inclusions
Date:   Thu,  7 Oct 2021 12:51:28 +0300
Message-Id: <20211007095129.22037-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007095129.22037-1-andriy.shevchenko@linux.intel.com>
References: <20211007095129.22037-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/rhashtable.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index a422c7dd9126..01502cf77564 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -12,9 +12,13 @@
  */
 
 #include <linux/atomic.h>
+#include <linux/bit_spinlock.h>
 #include <linux/container_of.h>
-#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/export.h>
 #include <linux/init.h>
+#include <linux/jhash.h>
+#include <linux/lockdep.h>
 #include <linux/log2.h>
 #include <linux/sched.h>
 #include <linux/rculist.h>
-- 
2.33.0

