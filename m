Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB8C32020F
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 01:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBTAAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 19:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhBTAAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 19:00:02 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC0CC061794;
        Fri, 19 Feb 2021 15:58:49 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id d7so6692421otq.6;
        Fri, 19 Feb 2021 15:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jAJa42OPzb/qV3fNsR+S2DkBgQytqm4smQJoFdDwVEE=;
        b=veyLlrSLv6FrB3BUkPWMgXS5MihvwCqyEixsP15BgdsB1Zn6DlvDQMrfXtPrJaQ4v2
         EYY/inmoRxiWm24fcABlyV1tKmkK9NPX2nS3RsYRKLAZDWqvV8BnE3EV1vAskwDz3ZqH
         BuvarCqvNDsV9r/DRRc6nSJ0/n6sPsdjxa6ZK2RboEuOkrYFJ1qg/u+ojlKHbMUu4mMb
         AeXZXymdMSDM5Av2s/sM/X2yp7MMR9UuwNK7UBKUAb0wqUHopIprzO0+6fr60XIIYShc
         urIMKRmC3SxeMtTvIid/7eBEyd8i5Ckz6d1Kr9bW1FH0YMOYmq8rlVTBg+PgnwibxX3R
         vBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jAJa42OPzb/qV3fNsR+S2DkBgQytqm4smQJoFdDwVEE=;
        b=Fnu/o3Nx2Uh1MVIBMmRvZAdL3Ju7i8Sjkb7EhmHHAvW2dSDKUARE+IVAekhiSzl8P0
         cJo4Pg1Gsc+NBBePa0msfK8dW9KDPWMdGcWAq6BvTe/tdN86gUTK20nHVz81HshnbVvY
         cWH/sbP942c3LYzdgapv+HgTY8/5swiPG2LGOKoiLwU6tH+oiyxemT4XNQ9W5daiNrT7
         GtBbk13b3zCztGs5cGKtVe+XJNFrQjq8riLkgLdtR2KJBcnFTtOJu+81uSitBV2+ZCf3
         KY6BYDFZwZ5XnrIH9xRL4vE9WH4StVlejGIfBib86V9W/Z5AZooea8Gmfa3Eq4Z9ZgPU
         LuBw==
X-Gm-Message-State: AOAM533EaEhlAVFuFtXqyFWDdEG8QyBcXewg7RAHRPWQHbAy+at2/Rze
        ZaXlnVF2FFC+JFKawF9n36nj16An+oL32Q==
X-Google-Smtp-Source: ABdhPJx2/3pzIcQGB7wTxvwI1j+EiHM5grAkMP6T6ba6v1mHLHm0Rax0NRozQb1wbYj1iZ3F4+FFWA==
X-Received: by 2002:a9d:7e87:: with SMTP id m7mr9175166otp.128.1613779128684;
        Fri, 19 Feb 2021 15:58:48 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id h11sm2064186ooj.36.2021.02.19.15.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 15:58:48 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v5 6/8] sock_map: make sock_map_prog_update() static
Date:   Fri, 19 Feb 2021 15:58:34 -0800
Message-Id: <20210219235836.100416-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210219235836.100416-1-xiyou.wangcong@gmail.com>
References: <20210219235836.100416-1-xiyou.wangcong@gmail.com>
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
index e29600f01585..9b31893f1b32 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1742,8 +1742,6 @@ static inline bool bpf_map_is_dev_bound(struct bpf_map *map)
 struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr);
 void bpf_map_offload_map_free(struct bpf_map *map);
 
-int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
-			 struct bpf_prog *old, u32 which);
 int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
 int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
 int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value, u64 flags);
@@ -1775,13 +1773,6 @@ static inline void bpf_map_offload_map_free(struct bpf_map *map)
 {
 }
 
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

