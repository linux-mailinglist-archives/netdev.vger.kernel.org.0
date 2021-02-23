Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CA7323108
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhBWSvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbhBWSvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 13:51:12 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A41C061793;
        Tue, 23 Feb 2021 10:49:54 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id h22so8320009otr.6;
        Tue, 23 Feb 2021 10:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lb541298bg1a1LVfNREWSWqClAn06Ny8gkf8FeuM0Kw=;
        b=HnnOAO0Wr/3NRsUvY32Zszva2j5QuPaUmEvR1GGVwY5P7FH8bDhuZEVRBVVtmSVSRp
         xqORShalYgwXRI15XIJI1u7qWceqpfShApYFe6QsjQSf63x76/RqmiQMu1+ls9bp8/zi
         DqvOWLgVTtUT6qsLXb9eqyz9CVm6DSd/KGRsxfYWE9mykq7LiZPm2eE4a/JTlj9J2qIx
         kr9tqjFGZB/ZU8PveEb9kp3tD0ZaY+X+aCL9lMwK41cmK3QgGr6rkPD5TLAPzwG+g8sX
         CB2ZzPIlwr0ssTeu6n3yM2+riRt/VMajKtvKovdGO6Sg8awiWDhJVKYlNHiheQM1hpAQ
         e4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lb541298bg1a1LVfNREWSWqClAn06Ny8gkf8FeuM0Kw=;
        b=IZpYy2e+tOxkqOsMCsftiNHhgEA5VYfHSbKH4ugNVZQEEtbQXaqOvY5HB1uXQRjj0K
         q+z5oAcsIVC7njnM92EivCck1r7UqAYfAdl7utu5wlcS8o9Wu/6OVh0jm2WQFf1JycHw
         t6l2usu5xLbjDosQF16heEaKhUKh5AoWAzVnK9zVIdMEjaEcGnc3m0fYJ2R8OJH8RHdU
         NdI9wSlaVDtOfpRGIZPTNjoOneMDSYh1OWA4uGg87/LHdYZ8WvML+objpIe+fTa3Y0WG
         OV5geaYVDo/rGjESbyS9pf/olR82v58Hfwi1rbPbpXZ4YMKgxkXrXMOPwRaNwyGiR6tt
         ZPgw==
X-Gm-Message-State: AOAM5332+uABdTlSUXqPZ4Oy3mIX03uXAWXC+fnrwmUb9luLkIFGBLr6
        Buz/BKgXCRPTFdg57vheQXOmCmEPcm6YsA==
X-Google-Smtp-Source: ABdhPJwXVXskOtD/RDMzBOktqM/Dn30oBvnmMQhWv8WVecWhDzzbNEqxptKqWRsWISrdcYa0txLa1A==
X-Received: by 2002:a9d:400a:: with SMTP id m10mr1195777ote.33.1614106193291;
        Tue, 23 Feb 2021 10:49:53 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4543:ab2:3bf6:ce41])
        by smtp.gmail.com with ESMTPSA id p12sm4387094oon.12.2021.02.23.10.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:49:52 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v7 6/9] sock_map: make sock_map_prog_update() static
Date:   Tue, 23 Feb 2021 10:49:31 -0800
Message-Id: <20210223184934.6054-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
References: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
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
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
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

