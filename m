Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9387DBC7E
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503918AbfJRFGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:06:07 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35374 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfJRFGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:06:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id p30so2681052pgl.2;
        Thu, 17 Oct 2019 22:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3znI3jfyxhlrImFZP1YaxjrIboRVdgk6y/Uv9/1hgdY=;
        b=XnvfBet4AbU0ExahHoD7IWNzMYRW3M2/FYWTAgA1MZybbezJNpGTEccvqnFVMAXY0g
         Fm0bBX+M1hT/UDnZNpwGLB4vuqnJ/OaTwDXaCTJHKl4dxIN8im6vEpUpcevzthFxneMp
         TNBS3RM2ahiDNdj1RY9GdN7Ll8WPPcD7Zxhri2GgvbPW3eiJCs8nbXuswgoeAnsadwaL
         xF5+yCHVVr2wWk/+D+K2bmO1jCAuqN9xrS5+wtI35rO+NJ4WBaKyX+pjIgqkHE8we+yP
         NPgoiYv2pwL1o+8s42S27f0NvxZLak+jSeq/MpskJ0CrReBjXWcAVGaJubKBRJsyY+vE
         rzbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3znI3jfyxhlrImFZP1YaxjrIboRVdgk6y/Uv9/1hgdY=;
        b=KCgzlAraGzGUt17Lj8ksMiacufWFmi+ExSF4M2erl0twQVNxt4BUipLUUvCvhhStUk
         3JmY5otxs5HVYjfsLiZMhYsrDUrgVexeFeSM3eb20D3mgsU8R7xKQidaFbdPzFd3XjP0
         cFr5gQPbxl43Wrvlo50MNLE4oAmrucyr+iv1vQ4WQ4TXWQDYxfXdhA01S5F0Ny3q8GtC
         x1/kZVur3ogY9pYBevvjp5kp+CMNCCuvgbPpOzdU+f9iRmRKAnL6zG6BntGnQ2uoQ90X
         xMiI5iRxYF8yu14kWXXCVIyGyXBBou45qe0h80M4XAwPuCYeEc3uBPxJS4nQosDDiu0q
         rbFA==
X-Gm-Message-State: APjAAAVUNallv2HZoGEYSTKaREIILRbf/C0J4RZkXxKy/js+G8ajnyuX
        NLt+qsm1E/pBlTFvgPUxR2A9PQsJ
X-Google-Smtp-Source: APXvYqzDPlDkah3w9vs71p4pB03R5Apr7H6F4vO+4UvTHwe9ETXCUnl1vgZ0+kcqJFrRfIeWNlCnZw==
X-Received: by 2002:a17:90a:5896:: with SMTP id j22mr8122854pji.55.1571371775397;
        Thu, 17 Oct 2019 21:09:35 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d11sm4341680pfo.104.2019.10.17.21.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:09:34 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: [RFC PATCH v2 bpf-next 15/15] bpf, hashtab: Compare keys in long
Date:   Fri, 18 Oct 2019 13:07:48 +0900
Message-Id: <20191018040748.30593-16-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memcmp() is generally slow. Compare keys in long if possible.
This improves xdp_flow performance.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 kernel/bpf/hashtab.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 22066a6..8b5ffd4 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -417,6 +417,29 @@ static inline struct hlist_nulls_head *select_bucket(struct bpf_htab *htab, u32
 	return &__select_bucket(htab, hash)->head;
 }
 
+/* key1 must be aligned to sizeof long */
+static bool key_equal(void *key1, void *key2, u32 size)
+{
+	/* Check for key1 */
+	BUILD_BUG_ON(!IS_ALIGNED(offsetof(struct htab_elem, key),
+				 sizeof(long)));
+
+	if (IS_ALIGNED((unsigned long)key2 | (unsigned long)size,
+		       sizeof(long))) {
+		unsigned long *lkey1, *lkey2;
+
+		for (lkey1 = key1, lkey2 = key2; size > 0;
+		     lkey1++, lkey2++, size -= sizeof(long)) {
+			if (*lkey1 != *lkey2)
+				return false;
+		}
+
+		return true;
+	}
+
+	return !memcmp(key1, key2, size);
+}
+
 /* this lookup function can only be called with bucket lock taken */
 static struct htab_elem *lookup_elem_raw(struct hlist_nulls_head *head, u32 hash,
 					 void *key, u32 key_size)
@@ -425,7 +448,7 @@ static struct htab_elem *lookup_elem_raw(struct hlist_nulls_head *head, u32 hash
 	struct htab_elem *l;
 
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
-		if (l->hash == hash && !memcmp(&l->key, key, key_size))
+		if (l->hash == hash && key_equal(&l->key, key, key_size))
 			return l;
 
 	return NULL;
@@ -444,7 +467,7 @@ static struct htab_elem *lookup_nulls_elem_raw(struct hlist_nulls_head *head,
 
 again:
 	hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
-		if (l->hash == hash && !memcmp(&l->key, key, key_size))
+		if (l->hash == hash && key_equal(&l->key, key, key_size))
 			return l;
 
 	if (unlikely(get_nulls_value(n) != (hash & (n_buckets - 1))))
-- 
1.8.3.1

