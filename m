Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3883F8EF2
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243586AbhHZTlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:41:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243538AbhHZTlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:41:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z2XITBrOxDpGRyjAJ/GeVEmFFxm+Vz1j/C47GlqXHzU=;
        b=Lw1A6wOP8nC5CRP2xAJw+SRdOfhZH3wJmGw1aDOk/5Pxz3xEiidK3hAwBHwDEoioGXLkjO
        WMfE9FrNiwMHl0CgUp/koZf3/4amyvrGptmW8sIUXLTtmLfwsf7nI0t/dbAPJSc3rN/8Gg
        BWmNpzBzpuicFcae2JrWA068olSsLR4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-gwJ_cUiSO9mf6jR66IYLGw-1; Thu, 26 Aug 2021 15:40:45 -0400
X-MC-Unique: gwJ_cUiSO9mf6jR66IYLGw-1
Received: by mail-wm1-f70.google.com with SMTP id z186-20020a1c7ec30000b02902e6a27a9962so4768274wmc.3
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:40:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z2XITBrOxDpGRyjAJ/GeVEmFFxm+Vz1j/C47GlqXHzU=;
        b=WkAh7VPiiPpztWU2PO8I8P8wTlFdKzMqrl//ISRWuxqg5/YuFcpyYgm77Rcncwkya+
         jBWjz50oVVcdUhNygeUbkmSjYuKmw69TRsXw+zS1wsp6dUHS1kNLp4cmgqSuiW4y0S++
         980aur/SIfNbScRLF3AFZyx2iHJOcbmz2XUQi/XSZ/xPKCjvROBDFEVYACfl04y2UI9R
         gvwMrTGRq6236Ie882z5eimAlNDMQ+KKl2aW5bScON8IjoDIb1pcLIJyRxK5k0NEtg3s
         Tix8PrjzKZ4FSik6ucc7PusKsb779aXwP4OFWcm5IHORVB1DmnXMqwG4odPYawhUgDLR
         ZgmQ==
X-Gm-Message-State: AOAM530HmKux7ZlENRbpV9nffutdgkKoMhbwk2pTLtHUW6fqW+teNwCL
        1YjKS72LpI3Tc8xH9tO5LYUuTj/8Z4GJsVpk4x00mVzAelVUnCH3UsXlBZISixkFXSLgVJot34H
        lMA3ZJY4bUmjzU0UC
X-Received: by 2002:a1c:ed10:: with SMTP id l16mr15751505wmh.8.1630006844418;
        Thu, 26 Aug 2021 12:40:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzitQXnasWLsuJudMdZeXK+TS2WTVT2UhHDl/35tfbJIVjoTYJHVpOxEFwQ00OumMXLgAsD+g==
X-Received: by 2002:a1c:ed10:: with SMTP id l16mr15751486wmh.8.1630006844263;
        Thu, 26 Aug 2021 12:40:44 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id f7sm9136006wmh.20.2021.08.26.12.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:40:43 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH bpf-next v4 13/27] bpf: Factor out __bpf_trampoline_put function
Date:   Thu, 26 Aug 2021 21:39:08 +0200
Message-Id: <20210826193922.66204-14-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separating out __bpf_trampoline_put function, so it can
be used from other places in following patches.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/trampoline.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 6dba43266e0b..8aa0aca38b3a 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -522,18 +522,16 @@ struct bpf_trampoline *bpf_trampoline_get(u64 key,
 	return tr;
 }
 
-void bpf_trampoline_put(struct bpf_trampoline *tr)
+static void __bpf_trampoline_put(struct bpf_trampoline *tr)
 {
-	if (!tr)
-		return;
-	mutex_lock(&trampoline_mutex);
+	lockdep_assert_held(&trampoline_mutex);
 	if (!refcount_dec_and_test(&tr->refcnt))
-		goto out;
+		return;
 	WARN_ON_ONCE(mutex_is_locked(&tr->mutex));
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FENTRY])))
-		goto out;
+		return;
 	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
-		goto out;
+		return;
 	/* This code will be executed even when the last bpf_tramp_image
 	 * is alive. All progs are detached from the trampoline and the
 	 * trampoline image is patched with jmp into epilogue to skip
@@ -542,7 +540,14 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
 	 */
 	hlist_del(&tr->hlist);
 	kfree(tr);
-out:
+}
+
+void bpf_trampoline_put(struct bpf_trampoline *tr)
+{
+	if (!tr)
+		return;
+	mutex_lock(&trampoline_mutex);
+	__bpf_trampoline_put(tr);
 	mutex_unlock(&trampoline_mutex);
 }
 
-- 
2.31.1

