Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F283649D215
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 19:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244299AbiAZSyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 13:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244297AbiAZSyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 13:54:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A49C06161C;
        Wed, 26 Jan 2022 10:54:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9791615B5;
        Wed, 26 Jan 2022 18:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA925C340E3;
        Wed, 26 Jan 2022 18:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643223263;
        bh=gpNo0idve1k/jtFgYHpg+wC9Im7sAT1VpgQ0wvRYm64=;
        h=From:To:Cc:Subject:Date:From;
        b=d8Orsmcz4QpmvQueLgU8kvqaWQr7yhK4uS+miaFZDw/272gcYS5an5MkfmpyRDVKD
         1KTvKpQ3VY3kKiW9mB7CJCZhgiwiwyQcpQ0y/n05peHttOHU1dQUsGhePuSeV08Zpl
         5f+yEoYyuXNcOBpofcA1Ovgb0ukJ1ZLApSjTO74HeamRCCniHJDnhZS0axdMDCpPsR
         qDoCFhKbnydCF5JUvWbbWUKBKpg64mkkoBqjJOsU4njA4j43KVVJKZDf/InjX35uT0
         MbMaQADmWaAvB+14DH6DBMq3gS363GyroMagJa2aXS85ze+Kxd8KmZLfxUoTHG3te2
         92gn3JyWdKNVQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     daniel@iogearbox.net, ast@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, hawk@kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next] bpf: remove unused static inlines
Date:   Wed, 26 Jan 2022 10:54:12 -0800
Message-Id: <20220126185412.2776254-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove two dead stubs, sk_msg_clear_meta() was never
used, use of xskq_cons_is_full() got replaced by
xsk_tx_writeable() in v5.10.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: ast@kernel.org
CC: daniel@iogearbox.net
CC: andrii@kernel.org
CC: kafai@fb.com
CC: songliubraving@fb.com
CC: yhs@fb.com
CC: john.fastabend@gmail.com
CC: kpsingh@kernel.org
CC: jakub@cloudflare.com
CC: lmb@cloudflare.com
CC: bjorn@kernel.org
CC: magnus.karlsson@intel.com
CC: jonathan.lemon@gmail.com
CC: hawk@kernel.org
CC: bpf@vger.kernel.org
---
 include/linux/bpf.h   | 10 ----------
 include/linux/skmsg.h |  5 -----
 net/xdp/xsk_queue.h   |  7 -------
 3 files changed, 22 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8c92c974bd12..652b29763423 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1875,11 +1875,6 @@ static inline int bpf_obj_get_user(const char __user *pathname, int flags)
 	return -EOPNOTSUPP;
 }
 
-static inline bool dev_map_can_have_prog(struct bpf_map *map)
-{
-	return false;
-}
-
 static inline void __dev_flush(void)
 {
 }
@@ -1943,11 +1938,6 @@ static inline int cpu_map_generic_redirect(struct bpf_cpu_map_entry *rcpu,
 	return -EOPNOTSUPP;
 }
 
-static inline bool cpu_map_prog_allowed(struct bpf_map *map)
-{
-	return false;
-}
-
 static inline struct bpf_prog *bpf_prog_get_type_path(const char *name,
 				enum bpf_prog_type type)
 {
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 18a717fe62eb..ddde5f620901 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -171,11 +171,6 @@ static inline u32 sk_msg_iter_dist(u32 start, u32 end)
 #define sk_msg_iter_next(msg, which)			\
 	sk_msg_iter_var_next(msg->sg.which)
 
-static inline void sk_msg_clear_meta(struct sk_msg *msg)
-{
-	memset(&msg->sg, 0, offsetofend(struct sk_msg_sg, copy));
-}
-
 static inline void sk_msg_init(struct sk_msg *msg)
 {
 	BUILD_BUG_ON(ARRAY_SIZE(msg->sg.data) - 1 != NR_MSG_FRAG_IDS);
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index e9aa2c236356..79be3e53ddf1 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -304,13 +304,6 @@ static inline void xskq_cons_release_n(struct xsk_queue *q, u32 cnt)
 	q->cached_cons += cnt;
 }
 
-static inline bool xskq_cons_is_full(struct xsk_queue *q)
-{
-	/* No barriers needed since data is not accessed */
-	return READ_ONCE(q->ring->producer) - READ_ONCE(q->ring->consumer) ==
-		q->nentries;
-}
-
 static inline u32 xskq_cons_present_entries(struct xsk_queue *q)
 {
 	/* No barriers needed since data is not accessed */
-- 
2.34.1

