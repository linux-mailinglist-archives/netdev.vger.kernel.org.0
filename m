Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6883828EC
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbhEQJ5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbhEQJ5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:57:25 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C525BC061344
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:56:08 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q15so4266785pgg.12
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b7apvPbQfTG1FYg2uNsocmvMG/QdC7c4RuzNmrGKxtc=;
        b=lXRHbHSIsb1KADw2tX2zKstf7SBlVEY4DtJnDMFT3EHKIWMje067JnmjgrkNReUxPn
         I0z2aIAyJGaL9m4k2OpOD29iaKpNcW4xfR7d14dIuNrPK0hQOvA8kl9rxSPc6f69Mm6p
         R0F2LeWEZA0PPqOKTYoBW3+9nQSkYxFKNz5WUEn2djE6598CZ00wKdFzTggwdy8opqtd
         +LicmUYFz5R2JqJ3r3lQ/vDv0gKToNlIKrKEdVnqYs5TGR2EJsU3XPEKupH3aVQAL9FE
         3exCZ90aL2Cb7tTVwr9v8iYtnhbog2Qo9fEaKaJOYYh61niFj77C/LAndUBtJYYe86bM
         nS5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b7apvPbQfTG1FYg2uNsocmvMG/QdC7c4RuzNmrGKxtc=;
        b=hdut8cE8FXfhZIMqJvOFrOIvq8wwfnz1j5z0KvYR8HKeJ/0FS8C4XX4T6IvYwkEw2S
         FlCLgEJ2bt6ZZqQaggnyd+q4AhigVDrtz9PKH+X2JjoY4Z6JxlIYmsH30pDGFQXJlRyY
         MMYgWdF5SeirNp6g/9skBThGw1cflri68QElasVhSpPrPPVkk9ZWSIvdG4yzkycuEdKA
         /gmlTKbBC+zGTr3Wkyu4syE+lN109MWrgfgOfysczxadPfDe6PXhcNu+ujdQNBriZWm1
         AI8NADUEKmB+hMjOJkrkkNoX7tUYdDYux6q3okzISJhxf/6QxuQFrJePKfqGiJMfj8ag
         7n7A==
X-Gm-Message-State: AOAM5306/Z6m7I+lZ0PGwPoWQq9xWvxBFA3PQt7ZhyOTbMrbwG6f2Kyk
        aNoAk7eGX7AJR+e0uU8zWNEP
X-Google-Smtp-Source: ABdhPJwO1N2BTDcGIAdEBE1GwKwtKYl5hxzWv7M8ro+LthKkIXN/GYpMnfpVi6rAWoY6mIGZm1TWzA==
X-Received: by 2002:a63:741e:: with SMTP id p30mr61016414pgc.68.1621245368362;
        Mon, 17 May 2021 02:56:08 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id 24sm10063099pgz.77.2021.05.17.02.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:56:07 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 03/12] eventfd: Increase the recursion depth of eventfd_signal()
Date:   Mon, 17 May 2021 17:55:04 +0800
Message-Id: <20210517095513.850-4-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517095513.850-1-xieyongji@bytedance.com>
References: <20210517095513.850-1-xieyongji@bytedance.com>
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

