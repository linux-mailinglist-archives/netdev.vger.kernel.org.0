Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C304D470125
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbhLJNGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238013AbhLJNGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:06:11 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066E5C061746;
        Fri, 10 Dec 2021 05:02:37 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id p13so8434721pfw.2;
        Fri, 10 Dec 2021 05:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XObccc6i0WV6lUN+UYdTlB9ulDBMm+DYkO+X5MZJRr8=;
        b=eTdcmPh8qVcvc33YF3aOPnIhwXBao55Stzp4LB81L0vIUjtyGVZxej+Qtl2OKo0DoE
         WzLsAz3iu+V55Wj+YWvzFbE3af2sr7P/EIkVNqAAwQCgG4DR92STOYtKPA+e5foxPadg
         y69XPFQGH9RWO6pHP5qSQk09x4YAWUFQJwJVZFBuy6fk8zzWnlnOfq4hl9JmHW7E31pd
         l8sMoPk5UXMrIpw0DpEfCwHRAN77WtdYWU/H1/LgadvgXp0T09EWm3eN2y3nnJ7P4tRA
         Yri2Pd7dK4dxvw8WJ2Zf7ZRqscjrboCVGDCHu1vjL4p1nmSsUWER6/5YBEui6/ArcI13
         l0lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XObccc6i0WV6lUN+UYdTlB9ulDBMm+DYkO+X5MZJRr8=;
        b=21E/9fwbh8aw5YPJm6E3WzZfu8TNO/oC8CFJP4bXH8cJFpIFrgV1OPNgxxltUgs+Uy
         i2X2WiEZaQp7V/USor27eKbtIU/lv/i3jq9HGVWPig8dPH/KdM8GrdrNTFhHY1X+ypAn
         +67Hg49Te9zzXHCjw6NAKUVnZE+jLlMaF9BWhRUWcWq6RUq+2F4wQdhOwg8ox/jdZC1x
         4c3sMSeUtTbsC+LqUtUBHdRqPjZ2E6KaAG7s0QW7tJPnv6xcJR3t+B3HWcM7UmSxydjN
         AQrG2Q5+bH/zCZfKCz7I5yyjSdl4XEodHl4XZ08FE7axlM9qToQBaI2DxduxymdRSH2s
         8ahQ==
X-Gm-Message-State: AOAM531XSHVKfZynkYP44SD7MBYgO31SiJfPFcnO3b6uHGCw+wF/twW3
        I4EVfkNuGPNppS9GPbh2yzZhU8T6ieg=
X-Google-Smtp-Source: ABdhPJxuSZKB5U0rwL1zlBUufZ86DTmw0LjvD/ztnRAxRgh3X7dG4i6Dm/y9hMP5Hx06DRpm6u/fnA==
X-Received: by 2002:a63:554:: with SMTP id 81mr39257332pgf.298.1639141356342;
        Fri, 10 Dec 2021 05:02:36 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id l21sm12497575pjt.24.2021.12.10.05.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 05:02:35 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v3 1/9] bpf: Refactor bpf_check_mod_kfunc_call
Date:   Fri, 10 Dec 2021 18:32:22 +0530
Message-Id: <20211210130230.4128676-2-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211210130230.4128676-1-memxor@gmail.com>
References: <20211210130230.4128676-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2877; h=from:subject; bh=JcAbu0xP+htcdwPg50dEXX7O7OhUxipN5J5IETU3E5I=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhs0/TxrALiDhM1kYXp6Q9KyT5HNK9cgGU7+0QLJDp q7d1eZKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbNP0wAKCRBM4MiGSL8RyqJTD/ 9z/JyjCuN7z0im5RjuZ6j0wdCR65C93OMNmH35i/cRaW1t9BqJmxjLwqwUObAneBDlpsyx+oSSrdH2 VrX+rfJglSDmqKe3HAxZhEueSpRK3JEciOah/sk55PriYY9CdDoy45VErXAdUYPQxFyO2QCSEOAyG1 4Hwg55VYyU2YKzCN6VqwStY3m/HtEatN+pBE6VarTe3udGH3nSwgCEA9vTcFyo92Kv8ZjV6Y11woqC qIe2oYvN/FmD0NUnlvdx1iQueZLhd4juXsImCH8YsZq0lCwkUswMgLt1+JP+pJxaFhn4GXTx95Wk6a Z0rDV2S2QTuwbS61dwBaFHmacdm7NfdRSa4tSl4sxJenFIyM+8LRCnlu0xLZ23H7fKkC0K1Tt0b4Qa v8YTHr2Uqccsln6nMJQfM9e+LASfhbNhwKY/IC9yUgzBHLzk/SOEwJNte7doKniYKQw9A7KR3iPR3J m24fMIOsOqNRTnXfi1sMzNtD06ISFjNBosa/kPFjWCw0I2MgqOAP9EBD00wxudGI2bhkDEEdps4eeZ efwIWonpgSDdkgPaRciRUwpO8dgO6oLPu7Tf31Yhgk1FlKDfCItiDLNUEbrQtVOCYtF1tPJf8yWbTp Z96+Cq2Cu08Mj/TYwnh+XIxmOIR4mAGtXc+2PpYX6hVzvNur76uR65JAp88A==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Future commits adding more callbacks will implement the same pattern of
matching module owner of kfunc_btf_id_set, and then operating on more
sets inside the struct.

While the btf_id_set for check_kfunc_call wouldn't have been NULL so
far, future commits introduce sets that are optional, hence the common
code also checks whether the pointer is valid.

Note that we must continue search on owner match and btf_id_set_contains
returning false, since more entries may have same owner (which can be
NULL for built-in modules). To clarify this case, a comment is added, so
that future commits don't regress the search.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h | 12 +++++++++++-
 kernel/bpf/btf.c    | 27 +++++++++++++++++++--------
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index acef6ef28768..d96e2859382e 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -320,9 +320,19 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 }
 #endif
 
+enum kfunc_btf_id_set_types {
+	BTF_SET_CHECK,
+	__BTF_SET_MAX,
+};
+
 struct kfunc_btf_id_set {
 	struct list_head list;
-	struct btf_id_set *set;
+	union {
+		struct btf_id_set *sets[__BTF_SET_MAX];
+		struct {
+			struct btf_id_set *set;
+		};
+	};
 	struct module *owner;
 };
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 27b7de538697..c9413d13ca91 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6390,22 +6390,33 @@ void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 }
 EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
 
-bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
-			      struct module *owner)
+/* Caller must hold reference to module 'owner' */
+static bool kfunc_btf_id_set_contains(struct kfunc_btf_id_list *klist,
+				      u32 kfunc_id, struct module *owner,
+				      enum kfunc_btf_id_set_types type)
 {
-	struct kfunc_btf_id_set *s;
+	struct kfunc_btf_id_set *s = NULL;
+	bool ret = false;
 
-	if (!owner)
+	if (type >= __BTF_SET_MAX)
 		return false;
 	mutex_lock(&klist->mutex);
 	list_for_each_entry(s, &klist->list, list) {
-		if (s->owner == owner && btf_id_set_contains(s->set, kfunc_id)) {
-			mutex_unlock(&klist->mutex);
-			return true;
+		if (s->owner == owner && s->sets[type] &&
+		    btf_id_set_contains(s->sets[type], kfunc_id)) {
+			ret = true;
+			break;
 		}
+		/* continue search, since multiple sets may have same owner */
 	}
 	mutex_unlock(&klist->mutex);
-	return false;
+	return ret;
+}
+
+bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_CHECK);
 }
 
 #endif
-- 
2.34.1

