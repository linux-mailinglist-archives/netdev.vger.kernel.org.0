Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F762990A0
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 16:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783324AbgJZPJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 11:09:50 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45924 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2443808AbgJZPJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 11:09:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id e17so12995921wru.12;
        Mon, 26 Oct 2020 08:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nn2oZLRjT+64BciW+Hx/seUtuN7aSBzpzwVj8jN3tsQ=;
        b=C7idnwP+y3uDL1Ofk5oMTvxHJHIXc0hMrDq2keHCargyWZzY8Cl6CitI6nISeyBTwW
         D1YSiDl+l0TeGC7nv48Abdx/s6WoGPE8YKojE0AuEZoQIMclfJecW7u2AZKCB229eZhG
         hP7cCuFYMd0vt9ztAMCIBYuLJClcJxl2kzKgauvoVrm2xzt1nQQdPMp4Lenieg5Xl1n+
         JeQIhwYy4KfO0qLZmG6tIIms9QrXPNvTphumaKxBk6OIl8z1zHCIhibFPTPQGAB0zH3y
         tdgTrCvVhTTMhDbYvg6sxAhS1RK/BqSVv/zvfNCtO461u6aeL4jFF6El9/tEzu4n29Yr
         EUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nn2oZLRjT+64BciW+Hx/seUtuN7aSBzpzwVj8jN3tsQ=;
        b=XUacBpvZ4j5jVy3Hivj1Ko85lxsh0ppZzRuZ9Tcejd7ncz6Myz19PM+KGDsAZOdwlk
         xGGkuonng5NYmEzBe7/g5StMGiKZJPnfUxQpcbZMf8DRtmf2n5MuWzoz63BVZ0IyesQT
         rzNx6wLs3Adp5BB8GRUcv1JGa/YnRHyVTFAhLKG5OyXB5kxsqCaqlKWEVd/BSXnxx8cD
         yV5gERcyTbVQ2l0y8HoqSFWNp3Q3f3F1PjF0Rm4q7U29KTUu1ihj19Nw5/MKoMHHX4j4
         kxQQhwrmjwgOQzAhqPCdEBi7FgP5UZe/cPYDF6jFiKO9YfxpHltPYovAnZzFt79jIVKv
         oPUA==
X-Gm-Message-State: AOAM533Qip/pKKKRSyuPSaC04WysCjEWamK38cHXKmAphS0JeWvJocod
        xdSyDPbyLGGf/9LofMDPLew=
X-Google-Smtp-Source: ABdhPJzhNgEcDXqJqCg/MooLOeJUAnn6NwAJuov/VPgKE4f1uGuz7icBHRwTXX6yVQbqDrtiABCcuA==
X-Received: by 2002:a5d:4103:: with SMTP id l3mr18538567wrp.260.1603724981721;
        Mon, 26 Oct 2020 08:09:41 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 24sm20043967wmf.44.2020.10.26.08.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 08:09:41 -0700 (PDT)
From:   Aleksandr Nogikh <aleksandrnogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Subject: [PATCH v3 2/3] net: add kcov handle to skb extensions
Date:   Mon, 26 Oct 2020 15:08:50 +0000
Message-Id: <20201026150851.528148-3-aleksandrnogikh@gmail.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
In-Reply-To: <20201026150851.528148-1-aleksandrnogikh@gmail.com>
References: <20201026150851.528148-1-aleksandrnogikh@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

Remote KCOV coverage collection enables coverage-guided fuzzing of the
code that is not reachable during normal system call execution. It is
especially helpful for fuzzing networking subsystems, where it is
common to perform packet handling in separate work queues even for the
packets that originated directly from the user space.

Enable coverage-guided frame injection by adding kcov remote handle to
skb extensions. Default initialization in __alloc_skb and
__build_skb_around ensures that no socket buffer that was generated
during a system call will be missed.

Code that is of interest and that performs packet processing should be
annotated with kcov_remote_start()/kcov_remote_stop().

An alternative approach is to determine kcov_handle solely on the
basis of the device/interface that received the specific socket
buffer. However, in this case it would be impossible to distinguish
between packets that originated during normal background network
processes or were intentionally injected from the user space.

Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
--
v2 -> v3:
* Reimplemented this change. Now kcov handle is added to skb
extensions instead of sk_buff.
v1 -> v2:
* Updated the commit message.
---
 include/linux/skbuff.h | 31 +++++++++++++++++++++++++++++++
 net/core/skbuff.c      | 11 +++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a828cf99c521..b63d90faa8e9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4150,6 +4150,9 @@ enum skb_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 	SKB_EXT_MPTCP,
+#endif
+#if IS_ENABLED(CONFIG_KCOV)
+	SKB_EXT_KCOV_HANDLE,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
@@ -4605,5 +4608,33 @@ static inline void skb_reset_redirect(struct sk_buff *skb)
 #endif
 }
 
+#ifdef CONFIG_KCOV
+
+static inline void skb_set_kcov_handle(struct sk_buff *skb, const u64 kcov_handle)
+{
+	/* No reason to allocate skb extensions to set kcov_handle if kcov_handle is 0. */
+	if (skb_has_extensions(skb) || kcov_handle) {
+		u64 *kcov_handle_ptr = skb_ext_add(skb, SKB_EXT_KCOV_HANDLE);
+
+		if (kcov_handle_ptr)
+			*kcov_handle_ptr = kcov_handle;
+	}
+}
+
+static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
+{
+	u64 *kcov_handle = skb_ext_find(skb, SKB_EXT_KCOV_HANDLE);
+
+	return kcov_handle ? *kcov_handle : 0;
+}
+
+#else
+
+static inline void skb_set_kcov_handle(struct sk_buff *skb, const u64 kcov_handle) { }
+
+static inline u64 skb_get_kcov_handle(struct sk_buff *skb) { return 0; }
+
+#endif /* CONFIG_KCOV */
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1ba8f0163744..c5e6c0b83a92 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -249,6 +249,9 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 
 		fclones->skb2.fclone = SKB_FCLONE_CLONE;
 	}
+
+	skb_set_kcov_handle(skb, kcov_common_handle());
+
 out:
 	return skb;
 nodata:
@@ -282,6 +285,8 @@ static struct sk_buff *__build_skb_around(struct sk_buff *skb,
 	memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
 	atomic_set(&shinfo->dataref, 1);
 
+	skb_set_kcov_handle(skb, kcov_common_handle());
+
 	return skb;
 }
 
@@ -4203,6 +4208,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_MPTCP)
 	[SKB_EXT_MPTCP] = SKB_EXT_CHUNKSIZEOF(struct mptcp_ext),
 #endif
+#if IS_ENABLED(CONFIG_KCOV)
+	[SKB_EXT_KCOV_HANDLE] = SKB_EXT_CHUNKSIZEOF(u64),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)
@@ -4219,6 +4227,9 @@ static __always_inline unsigned int skb_ext_total_length(void)
 #endif
 #if IS_ENABLED(CONFIG_MPTCP)
 		skb_ext_type_len[SKB_EXT_MPTCP] +
+#endif
+#if IS_ENABLED(CONFIG_KCOV)
+		skb_ext_type_len[SKB_EXT_KCOV_HANDLE] +
 #endif
 		0;
 }
-- 
2.29.0.rc1.297.gfa9743e501-goog

