Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6704434FB22
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbhCaIGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbhCaIGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:06:34 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF276C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:06:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so761062pjc.2
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 01:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qd7q0+7mMIaCO7kNrN03miiLmUUotvU02ar15rGLAYA=;
        b=TC4wgya5iSyGQZApckwILsZ07cID8JY+wSUKJkkjSK6QenG/Nmjt6rFLbaVUVwLWuR
         qZUC8Y0GjUhiGVid8GxHZKbu9gf4fU+lvhfmVfPgGy+5jgQjVK7BNWsvr6SfgOEkycaZ
         5vq2ipI4hpOZ0O2rO+5j+j/r4ClYjWkyP2C+gZCHd4C/hmSUIOJRWa8irRXib6jNL6bu
         kD4W62kB3IbxjCgNwxzpm1RKEIwtcxPZUTI1DX3Y9RXd+XOhqYwQUafQpdnDpvkcgH0M
         D8Gqf8VvrAIYcVLhc6Mm5fymUe/OERG1iFMO5tcrA4RGKFIGu9cfuHfcaCK9xR+LNdNI
         8BIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qd7q0+7mMIaCO7kNrN03miiLmUUotvU02ar15rGLAYA=;
        b=gn77aHI+s5xghUXDqjALfUv2JcU5DHKcHBRecZhXfM02g5Ut8vVp1rrEL83snTqqQk
         SQ0PjKOAnq+360E7UIZl0GCpNAIRhZDmPOXHjKW1Wvx8gWN7yoqWWWS7DEciJo3qiAVh
         gPf7V1D0Xm6YAoz4dMrDiFQ1OPuziawlf59n6gP00yW0WO5LcxOb0ONKqW4VuTQjsnds
         vjDADZ/KqeKH+M99Ly6B/P15QSOKeI3D6YHY+ktfZ++nYpmqt2yscGUWndYmDAOZKT15
         lazwZJRWcp6yk+yHC9BDC26bIVIkmUFpNIuqkiB7ZmP3LyomUwxRLuZSy8KDjPXQ84YT
         zweA==
X-Gm-Message-State: AOAM532XxjqNUqVdCT9mGLWS+fR6vIKXDGYOizY5E6jzUOEQuFj1OJaY
        PWzhoeNAJPBcH6tlVN5BDrZY
X-Google-Smtp-Source: ABdhPJydrF0nk0d3cE3vx8KgidDGa8Zfry5KovS8f39HDenv+8gD9ih8HKxbhTFZ2J9TJmZpWj0qlg==
X-Received: by 2002:a17:90a:fb83:: with SMTP id cp3mr2363661pjb.33.1617177981360;
        Wed, 31 Mar 2021 01:06:21 -0700 (PDT)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id 23sm1644744pgo.53.2021.03.31.01.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 01:06:20 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 01/10] file: Export receive_fd() to modules
Date:   Wed, 31 Mar 2021 16:05:10 +0800
Message-Id: <20210331080519.172-2-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331080519.172-1-xieyongji@bytedance.com>
References: <20210331080519.172-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export receive_fd() so that some modules can use
it to pass file descriptor between processes without
missing any security stuffs.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 fs/file.c            | 6 ++++++
 include/linux/file.h | 7 +++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index dab120b71e44..d7d957217576 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1108,6 +1108,12 @@ int __receive_fd(int fd, struct file *file, int __user *ufd, unsigned int o_flag
 	return new_fd;
 }
 
+int receive_fd(struct file *file, unsigned int o_flags)
+{
+	return __receive_fd(-1, file, NULL, o_flags);
+}
+EXPORT_SYMBOL(receive_fd);
+
 static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 {
 	int err = -EBADF;
diff --git a/include/linux/file.h b/include/linux/file.h
index 225982792fa2..4667f9567d3e 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -94,6 +94,9 @@ extern void fd_install(unsigned int fd, struct file *file);
 
 extern int __receive_fd(int fd, struct file *file, int __user *ufd,
 			unsigned int o_flags);
+
+extern int receive_fd(struct file *file, unsigned int o_flags);
+
 static inline int receive_fd_user(struct file *file, int __user *ufd,
 				  unsigned int o_flags)
 {
@@ -101,10 +104,6 @@ static inline int receive_fd_user(struct file *file, int __user *ufd,
 		return -EFAULT;
 	return __receive_fd(-1, file, ufd, o_flags);
 }
-static inline int receive_fd(struct file *file, unsigned int o_flags)
-{
-	return __receive_fd(-1, file, NULL, o_flags);
-}
 static inline int receive_fd_replace(int fd, struct file *file, unsigned int o_flags)
 {
 	return __receive_fd(fd, file, NULL, o_flags);
-- 
2.11.0

