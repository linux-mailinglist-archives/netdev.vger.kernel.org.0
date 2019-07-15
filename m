Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 702186992E
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 18:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731013AbfGOQkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 12:40:02 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:36554 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730600AbfGOQkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 12:40:02 -0400
Received: by mail-vk1-f202.google.com with SMTP id o75so6485073vke.3
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 09:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/4GOuezfoSXQsme0oY5IMJILtncU/YuwK20WFYPvy1k=;
        b=Gfw+Q+z+kXoFqI16PLUwNK/6E70/lm4vOqq+bKJ13ZpCyrp70pRmT1fYi5jbkMbwAw
         SOFKaZf3EjFEH7OhTsl3U9DmJRcBrzirZVLEHUPhCceZ4j+HFWUiNEyiIaCDjnTyJXIG
         xN3pVaeZue566N5J12JOSiNygwTsdiiP1teRecRFWbgxzhiVw2KirE+/KyKI/v9k9+zI
         AxMth2N/N/0HyPEL/vVq9JesXrSpXvrZrRGAXuLUrzxKyJRDfRsQGDBO8q9KA4VnwbEm
         Rwno00SHHD9T54tGB4/vSp1xlw81ACqequZBb8tcx2SFqKTMp/p2ivc4XXKWsM82xdvK
         6pmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/4GOuezfoSXQsme0oY5IMJILtncU/YuwK20WFYPvy1k=;
        b=Sjc4j5f+krzUiSP1fA4VLluvfsu47/Vyb/3G/pPObX1+N+HnomTPO/NWY3TxuUa9kq
         XPSMTqjeTM5c7RiGfwbs0KBygp99ebleayoJ8zhqvkpfI74fh6d+mLy389pJ+Ky9W6Wo
         kvCzttepoJ3P9wHsmE+W2uOZcIDLqGAsq0wXBV0TUBIIvnIfgU+rHzZO8IPJdB9hT7k7
         4Kr7lNR7pyiluIg3M5GbinCOzNiiSTXURyMj0O4pckajrYdHt714irCXAkEFaMo0RBFS
         HPbArNZJFirfAUEB0dkmjt8ohzm8kVQMO8AV5PcYwr/4U3FEWmZmPSx4ycfAkdhLWYUx
         A8zQ==
X-Gm-Message-State: APjAAAXNDK2sV+OHj1YVE6uw0xYYsPAFdISRHz+qHJQGAdcg+11IkTCG
        1Rfig1DWYJ2dnSOyHKhQ8axoc36pTnbxbJSEO0puat+1G17UJj3fgUymV5EyyMRHtMgLQpGmkj+
        y5Y8imFoXwP4ks84/6alAFWtAEl6DUPcF5+NJbh1GUGJ/7phlZfpjXw==
X-Google-Smtp-Source: APXvYqw7IFloMg0HVhi260b0gZX2quy3sDJU/zr7RMuDgUDJqNowz1SrVOyRSqWfIgM+cOTXrW4r47Q=
X-Received: by 2002:ab0:69c8:: with SMTP id u8mr16512558uaq.132.1563208801299;
 Mon, 15 Jul 2019 09:40:01 -0700 (PDT)
Date:   Mon, 15 Jul 2019 09:39:52 -0700
In-Reply-To: <20190715163956.204061-1-sdf@google.com>
Message-Id: <20190715163956.204061-2-sdf@google.com>
Mime-Version: 1.0
References: <20190715163956.204061-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
Subject: [PATCH bpf 1/5] bpf: rename bpf_ctx_wide_store_ok to bpf_ctx_wide_access_ok
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename bpf_ctx_wide_store_ok to bpf_ctx_wide_access_ok to indicate
that it can be used for both loads and stores.

Cc: Yonghong Song <yhs@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/filter.h |  2 +-
 net/core/filter.c      | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 6d944369ca87..ff65d22cf336 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -747,7 +747,7 @@ bpf_ctx_narrow_access_ok(u32 off, u32 size, u32 size_default)
 	return size <= size_default && (size & (size - 1)) == 0;
 }
 
-#define bpf_ctx_wide_store_ok(off, size, type, field)			\
+#define bpf_ctx_wide_access_ok(off, size, type, field)			\
 	(size == sizeof(__u64) &&					\
 	off >= offsetof(type, field) &&					\
 	off + sizeof(__u64) <= offsetofend(type, field) &&		\
diff --git a/net/core/filter.c b/net/core/filter.c
index 47f6386fb17a..c5983ddb1a9f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6890,14 +6890,14 @@ static bool sock_addr_is_valid_access(int off, int size,
 			if (!bpf_ctx_narrow_access_ok(off, size, size_default))
 				return false;
 		} else {
-			if (bpf_ctx_wide_store_ok(off, size,
-						  struct bpf_sock_addr,
-						  user_ip6))
+			if (bpf_ctx_wide_access_ok(off, size,
+						   struct bpf_sock_addr,
+						   user_ip6))
 				return true;
 
-			if (bpf_ctx_wide_store_ok(off, size,
-						  struct bpf_sock_addr,
-						  msg_src_ip6))
+			if (bpf_ctx_wide_access_ok(off, size,
+						   struct bpf_sock_addr,
+						   msg_src_ip6))
 				return true;
 
 			if (size != size_default)
-- 
2.22.0.510.g264f2c817a-goog

