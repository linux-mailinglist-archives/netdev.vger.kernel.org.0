Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C3E6B4C66
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjCJQOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjCJQMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:12:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4F535A5
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 08:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678464498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6woSO0hLQ5AOX8ml8J8Kv2DAmsiAIUA/7xq1WhwbYPM=;
        b=B9ai03vccdA3Uj8Z4vu7j0aqdYs0yYruFN691C9K+t2WDqFdD4jkdfA9neHgs0WDoRfPtj
        FJSWBOkd77x9CmaHBI10+GK71UTK4k6uWpCPkb0eRHPMpipKFefBUvsJGqLjts2eK55r8R
        Zn2IbCWXmvVxa2wxnHckLVcmdrQeezA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-HSShDvcENL6mqIOrmek3JA-1; Fri, 10 Mar 2023 11:08:14 -0500
X-MC-Unique: HSShDvcENL6mqIOrmek3JA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2559882824;
        Fri, 10 Mar 2023 16:08:08 +0000 (UTC)
Received: from thuth.com (unknown [10.45.224.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6A5F492B00;
        Fri, 10 Mar 2023 16:08:06 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc:     linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 3/5] Move bp_type_idx to include/linux/hw_breakpoint.h
Date:   Fri, 10 Mar 2023 17:07:55 +0100
Message-Id: <20230310160757.199253-4-thuth@redhat.com>
In-Reply-To: <20230310160757.199253-1-thuth@redhat.com>
References: <20230310160757.199253-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Palmer Dabbelt <palmer@dabbelt.com>

This has a "#ifdef CONFIG_*" that used to be exposed to userspace.

The names in here are so generic that I don't think it's a good idea
to expose them to userspace (or even the rest of the kernel).  There are
multiple in-kernel users, so it's been moved to a kernel header file.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
Message-Id: <1447119071-19392-10-git-send-email-palmer@dabbelt.com>
[thuth: Remove it also from tools/include/uapi/linux/hw_breakpoint.h]
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/linux/hw_breakpoint.h            | 10 ++++++++++
 include/uapi/linux/hw_breakpoint.h       | 10 ----------
 tools/include/uapi/linux/hw_breakpoint.h | 10 ----------
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index f319bd26b030..7fbb45911273 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -7,6 +7,16 @@
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
+enum bp_type_idx {
+	TYPE_INST	= 0,
+#if defined(CONFIG_HAVE_MIXED_BREAKPOINTS_REGS)
+	TYPE_DATA	= 0,
+#else
+	TYPE_DATA	= 1,
+#endif
+	TYPE_MAX
+};
+
 extern int __init init_hw_breakpoint(void);
 
 static inline void hw_breakpoint_init(struct perf_event_attr *attr)
diff --git a/include/uapi/linux/hw_breakpoint.h b/include/uapi/linux/hw_breakpoint.h
index 965e4d8606d8..1575d3ca6f0d 100644
--- a/include/uapi/linux/hw_breakpoint.h
+++ b/include/uapi/linux/hw_breakpoint.h
@@ -22,14 +22,4 @@ enum {
 	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
 };
 
-enum bp_type_idx {
-	TYPE_INST 	= 0,
-#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
-	TYPE_DATA	= 0,
-#else
-	TYPE_DATA	= 1,
-#endif
-	TYPE_MAX
-};
-
 #endif /* _UAPI_LINUX_HW_BREAKPOINT_H */
diff --git a/tools/include/uapi/linux/hw_breakpoint.h b/tools/include/uapi/linux/hw_breakpoint.h
index 965e4d8606d8..1575d3ca6f0d 100644
--- a/tools/include/uapi/linux/hw_breakpoint.h
+++ b/tools/include/uapi/linux/hw_breakpoint.h
@@ -22,14 +22,4 @@ enum {
 	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
 };
 
-enum bp_type_idx {
-	TYPE_INST 	= 0,
-#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
-	TYPE_DATA	= 0,
-#else
-	TYPE_DATA	= 1,
-#endif
-	TYPE_MAX
-};
-
 #endif /* _UAPI_LINUX_HW_BREAKPOINT_H */
-- 
2.31.1

