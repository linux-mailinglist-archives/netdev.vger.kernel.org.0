Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF16320407
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 06:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhBTFbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 00:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhBTFav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 00:30:51 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45860C061794;
        Fri, 19 Feb 2021 21:29:37 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id b8so7130721oti.7;
        Fri, 19 Feb 2021 21:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZIvtSmlziE+/XNUkzlDmjZl9RoZpZH0rqhWzogWDKek=;
        b=ELG5e6k8Ob91V8HZWsfNvKH9vceOWnJoU8ofv+az3dd1unsVx5pL9i+HDHGtAr1Huu
         Gj+GG2J26nd8kjMEebF9fcnIsmfygrQ9BbzmECXhx6Qz8lXPX1Dvfz76j7QvnZAn9G4i
         bBltzCeq9nbjjPVeRqjC4BWiyH4y+JXe0p1pKrL5ahlCnoJov6KKFPUOtOA7xhe1pJct
         b5nVnk4gdsoo1h67r/IUYvpzDgsFrNZ6vS/ushZGQ1+QRfhVXDFGX9Nis0VzZ4LRr7nR
         5UhNfuaeHAoQJeohmQhCjyISciI8ivYWVexG0aArBQRI4nyDMtdwrAjvpvQ+Hj3AySWD
         I19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZIvtSmlziE+/XNUkzlDmjZl9RoZpZH0rqhWzogWDKek=;
        b=PSGwZTigNvTYd4HMwqNF6wS5kLGoQS62umt2KlLu9x1+L5RMQaP2evEBm/By2uFqHm
         Sr+3G9JlR+irv5YUqjp0tDAxd1hPIQyEyfcjFaphqjSeH7Y90OnPWq/BwMbBJY+u+hhf
         QhNIgoiRpf8LFtdy7DIPkxzz+L8xebhiRT0ZSvZvgiA/uiZdELXE4XUT+/7ky72iuXNn
         oAIQsNJUuYKzZRuAE4ao4mEnu/UpxU6ajWQnThD6sJoTWUQd8vkjMIo+OMXCxUTz9xmj
         +UoAb224BAY5gDTWkoCX6ktMkYbya8eIUf5yGW8KK9IyImopt+yGI+A+1ImJIx/rN9Qs
         b5Hg==
X-Gm-Message-State: AOAM533/CvQDVW1vaNKPlA5LOmodkeIHhrOCC34hf1Vit7OnRINrfHH0
        tkblmwSlzjGJxFeayrSUIA5yy5I/+Jayxw==
X-Google-Smtp-Source: ABdhPJwpZV4mHQD/XLs/9itft+Y9ZgvDswnNLkk3aFekgfVm4vJMpFBARPM3+cmKE/G/EMn7btX93A==
X-Received: by 2002:a05:6830:138c:: with SMTP id d12mr9231518otq.291.1613798976587;
        Fri, 19 Feb 2021 21:29:36 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id v20sm945955oie.2.2021.02.19.21.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 21:29:36 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v6 6/8] sock_map: make sock_map_prog_update() static
Date:   Fri, 19 Feb 2021 21:29:22 -0800
Message-Id: <20210220052924.106599-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

It is only used within sock_map.c so can become static.

Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf.h | 9 ---------
 net/core/sock_map.c | 7 +++++--
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 813f30ef44ff..521b75a81aa6 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1769,8 +1769,6 @@ static inline void bpf_map_offload_map_free(struct bpf_map *map)
 #endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
 
 #if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
-int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
-			 struct bpf_prog *old, u32 which);
 int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
 int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
 int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value, u64 flags);
@@ -1788,13 +1786,6 @@ static inline void bpf_sk_reuseport_detach(struct sock *sk)
 }
 
 #ifdef CONFIG_BPF_SYSCALL
-static inline int sock_map_prog_update(struct bpf_map *map,
-				       struct bpf_prog *prog,
-				       struct bpf_prog *old, u32 which)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline int sock_map_get_from_fd(const union bpf_attr *attr,
 				       struct bpf_prog *prog)
 {
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 69785070f02d..dd53a7771d7e 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -24,6 +24,9 @@ struct bpf_stab {
 #define SOCK_CREATE_FLAG_MASK				\
 	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
 
+static int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
+				struct bpf_prog *old, u32 which);
+
 static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_stab *stab;
@@ -1444,8 +1447,8 @@ static struct sk_psock_progs *sock_map_progs(struct bpf_map *map)
 	return NULL;
 }
 
-int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
-			 struct bpf_prog *old, u32 which)
+static int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
+				struct bpf_prog *old, u32 which)
 {
 	struct sk_psock_progs *progs = sock_map_progs(map);
 	struct bpf_prog **pprog;
-- 
2.25.1

