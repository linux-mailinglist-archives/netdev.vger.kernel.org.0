Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D15300E61
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 21:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbhAVU6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 15:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730770AbhAVUzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 15:55:16 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2E2C061788;
        Fri, 22 Jan 2021 12:54:34 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id h192so7518255oib.1;
        Fri, 22 Jan 2021 12:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6cUrGuJbAAzbmOZxLUmIXIAt0gGPRKf0H8ukS5QNZuo=;
        b=Y05zV/4NNupFAdTX5/j8xXgZ8dCXunYy/bA/WtyMgWKn7a/6HRLLz57fFCzqUOEmIb
         JinOXZnYL9p4n0u8CMlaiDeduAqKvdjZ3AiYDsrnJhFA1VCoIueYAayO94QKqNQsVE4R
         luiBMdnhgvDTwcqUt+Pyd3mMvPYItgCKfW3u5/v1DqAN361VWTBkNuwiHB7rfAD/1wl+
         GuVCgEKJ8TtlrsxTmlABsT4kvzY/iy1I+HvHKn4SKkFH6yfGQUWCFoDJ0j6SUrl45BXI
         FbpapkZ8vyIKD1BEMi99OOlChBf6aJQcZn6YCxmfToA0AknMShT+07BVMQ30aaYlTiCI
         wnOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6cUrGuJbAAzbmOZxLUmIXIAt0gGPRKf0H8ukS5QNZuo=;
        b=CkRtylDh0t/+iDBokkG60IpT9lDkkbcNGDR+4dsrOoRznZUEBqzRJLfCmeLKLHMlkE
         a3J614gW36MChsmB7FcJPoG9d1dkP9UAf9VtzghDIIFgcXLKGtFE/W7x+rr+tbUUxYaq
         5xFldN4EGqS8tR3O8xpauSFj0lGSs843yUT5SluzBGbZabyV+zZZjXFqn+sFobsdfT1a
         v832YhNP4sXBvBu7o6Rc7MQBkTeFDUCqASwHO3QHKzSogjKsCX+Wv/CeMkVjZJUzMOLx
         DI9SrjQu9xoI8OIbuF3QgxEx7GmiZE3411i9Y+QR7bL7fOYqnvpXuU7Ha7HwVYXPKIIE
         y/yQ==
X-Gm-Message-State: AOAM532oSFl5/96+gS+pYVbPxugCytvHHVm+VYEMmHHsDodETuUz/JeB
        hiejtpdjtD/RSY9hF0dHjsSKG8cLIz4uVg==
X-Google-Smtp-Source: ABdhPJxt+nTs9bDdH9W3mjPO1YEk+OcZLxje5zVzBQ+ICCGvWmA+5Boa7jQIf0na1WLe/BIJUgNRKQ==
X-Received: by 2002:aca:d417:: with SMTP id l23mr4537916oig.145.1611348874165;
        Fri, 22 Jan 2021 12:54:34 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1c14:d05:b7d:917b])
        by smtp.gmail.com with ESMTPSA id k18sm1349193otj.36.2021.01.22.12.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 12:54:33 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jhs@mojatatu.com, andrii@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        Cong Wang <cong.wang@bytedance.com>,
        Andrey Ignatov <rdna@fb.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next v5 3/3] selftests/bpf: add timeout map check in map_ptr tests
Date:   Fri, 22 Jan 2021 12:54:15 -0800
Message-Id: <20210122205415.113822-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Similar to regular hashmap test.

Acked-by: Andrey Ignatov <rdna@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 .../selftests/bpf/progs/map_ptr_kern.c        | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
index d8850bc6a9f1..424a9e76c93f 100644
--- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
+++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
@@ -648,6 +648,25 @@ static inline int check_ringbuf(void)
 	return 1;
 }
 
+struct {
+	__uint(type, BPF_MAP_TYPE_TIMEOUT_HASH);
+	__uint(max_entries, MAX_ENTRIES);
+	__type(key, __u32);
+	__type(value, __u32);
+} m_timeout SEC(".maps");
+
+static inline int check_timeout_hash(void)
+{
+	struct bpf_htab *timeout_hash = (struct bpf_htab *)&m_timeout;
+	struct bpf_map *map = (struct bpf_map *)&m_timeout;
+
+	VERIFY(check_default(&timeout_hash->map, map));
+	VERIFY(timeout_hash->n_buckets == MAX_ENTRIES);
+	VERIFY(timeout_hash->elem_size == 64);
+
+	return 1;
+}
+
 SEC("cgroup_skb/egress")
 int cg_skb(void *ctx)
 {
@@ -679,6 +698,7 @@ int cg_skb(void *ctx)
 	VERIFY_TYPE(BPF_MAP_TYPE_SK_STORAGE, check_sk_storage);
 	VERIFY_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, check_devmap_hash);
 	VERIFY_TYPE(BPF_MAP_TYPE_RINGBUF, check_ringbuf);
+	VERIFY_TYPE(BPF_MAP_TYPE_TIMEOUT_HASH, check_timeout_hash);
 
 	return 1;
 }
-- 
2.25.1

