Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A31934FB16
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbhCaIGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbhCaIGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:06:25 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EB0C06175F
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:06:25 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so2611821pjb.1
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b7apvPbQfTG1FYg2uNsocmvMG/QdC7c4RuzNmrGKxtc=;
        b=A3wAmnxCijyv4JmqyD+7kgtLs8qirdeNzXs9OkQLZgeSTN5oUQUq0roBMJbBPxt+/9
         KCpvVlFgxw9ZZn26eKmnOXdTk/yUg65g4D7FuF+OkmhsVMHtXbzEo9csOzlt61WDfo5l
         otQaPwZTrHtFhq2LaSUvhBbnk3a4qdoG8SzepxCM1HjSG+y4FAJrbwjVnc8KQwZGJR1e
         CfGVzDy1y8PTrPtOC8GzgLs4uQqr400S/WFl8PXrgHskVyafDc7WUeOP2bcK8aupMQhG
         i7D6kXW2EKvhLjAVavOvYtm/r8NX8BoRCI40+VVdhnIMvk6XnOHXiH9lgCy/TfikG8TD
         wozA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b7apvPbQfTG1FYg2uNsocmvMG/QdC7c4RuzNmrGKxtc=;
        b=A1airmhxia2iuWpJvR4/YLVfddbg/iyyV18A9QuogH6eHu2EJmtbqPx57QMpbo3LIb
         SLrh5tmOsEOlY6D61yCaAQTMgIiiJntneSunyK2xNuHu6xiMlM1bPTO1GSzRiuMvfBYr
         n4A9g+fPfXvjGy+QM7bdTzA6paTRs6V1BoIfUm/kkf9FpFZabvYztVf8kkax/hYOtk2N
         xXvUikp0HG9h9U4Z3Alst7tBWrbz1MJYDTeSLDZD5mpmK6zh7a10sGf91WTlRqwKyfX9
         PbRhi0ium98UZ5uett02LQWoDQxOuFjte6So0YbjrSkhBOgib/8ZsfW1ASL1WnFCEtAW
         NLAg==
X-Gm-Message-State: AOAM533INYNLB75aSBP/DNflv1cvU425MnlYmK/HQ/mysD98MLLT4wAV
        RR5HN4riSlJMvyCuWVcq+3ff
X-Google-Smtp-Source: ABdhPJxHUvXwhgpDdQBLTdQxkUD9V2flhkuKgUAC1U22SyapfEwojQlQDvAYR/WYJKJ9peQYTPOWLw==
X-Received: by 2002:a17:902:7b82:b029:e7:32bc:92 with SMTP id w2-20020a1709027b82b02900e732bc0092mr1917558pll.34.1617177984900;
        Wed, 31 Mar 2021 01:06:24 -0700 (PDT)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id p2sm1643371pgm.24.2021.03.31.01.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 01:06:24 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 02/10] eventfd: Increase the recursion depth of eventfd_signal()
Date:   Wed, 31 Mar 2021 16:05:11 +0800
Message-Id: <20210331080519.172-3-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331080519.172-1-xieyongji@bytedance.com>
References: <20210331080519.172-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increase the recursion depth of eventfd_signal() to 1. This
is the maximum recursion depth we have found so far, which
can be triggered with the following call chain:

    kvm_io_bus_write                        [kvm]
      --> ioeventfd_write                   [kvm]
        --> eventfd_signal                  [eventfd]
          --> vhost_poll_wakeup             [vhost]
            --> vduse_vdpa_kick_vq          [vduse]
              --> eventfd_signal            [eventfd]

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 fs/eventfd.c            | 2 +-
 include/linux/eventfd.h | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index e265b6dd4f34..cc7cd1dbedd3 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -71,7 +71,7 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 	 * it returns true, the eventfd_signal() call should be deferred to a
 	 * safe context.
 	 */
-	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count)))
+	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH))
 		return 0;
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index fa0a524baed0..886d99cd38ef 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -29,6 +29,9 @@
 #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
 #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
 
+/* Maximum recursion depth */
+#define EFD_WAKE_DEPTH 1
+
 struct eventfd_ctx;
 struct file;
 
@@ -47,7 +50,7 @@ DECLARE_PER_CPU(int, eventfd_wake_count);
 
 static inline bool eventfd_signal_count(void)
 {
-	return this_cpu_read(eventfd_wake_count);
+	return this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH;
 }
 
 #else /* CONFIG_EVENTFD */
-- 
2.11.0

