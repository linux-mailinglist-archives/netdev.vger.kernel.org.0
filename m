Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FC53AC941
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhFRK5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhFRK5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 06:57:47 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D967DC061574;
        Fri, 18 Jun 2021 03:55:36 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 13-20020a17090a08cdb029016eed209ca4so5655556pjn.1;
        Fri, 18 Jun 2021 03:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z+Lt9uCVLmu8+kIm3gV6NL1iTkcvcppxfgXT24ufRMM=;
        b=LsFlCaFqS8uvZUfAHKKZ/mz0Zn68hVxj81lSvCYXrKbluGdVs9mQ6kWinE9Z/UCe3X
         ZoelfObearC/yyo3QAisi6jTXcjU3Dxjay7EBJKg/j0IIbjFSDeb/4Jnh82CfixCfkmt
         DrxtixWJoOWgeWp5HDbsf5kg6s/1HGtx8roNt1ACn3K+39yo+nhrQEgHogW8Mk3jGmBh
         RwuSYTLDnRp6XtZfU/KJSEfeZAnWgYV8M4B0U78tTYnWUMFe7CM1F602voZFRkvqTjVD
         D7Q5WL/6p/FBzIVlxKF0G288YgOyeYQRV7ztlb+i1ZEkgx4312KnfuKPIjYbW98rMr0X
         Kcew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z+Lt9uCVLmu8+kIm3gV6NL1iTkcvcppxfgXT24ufRMM=;
        b=Fhh+28KUG8KvaGH97Ls6f3SGvdzIT1EoUcuKfZdOR6kcFURYXnEM0vDRyEPO8olhC0
         XRkVIFsalQ/s7KWEGqsojHaZdnWsE3bfUi/IHuhoNM4AbKHcOkGZnBpLv2FHNcl3KrRF
         /j3v1uv68J+R+k6LyHiVrbnD2RPGme+bJM2nLz+lAENfFFzRv/00tibYYfwYILYkl4ya
         EVsp51rGQT4wvmIXSrpAXqicvgj0smRFQvZdKslEg/YLlfmiyiRxwsrVU+kpEIBtcFRH
         2kgrk4beirAWJwByWbeOIM6E9SXoQJFDfZyToIDziR84oYirIVfd7BMREaGjaOpnF/ax
         klFQ==
X-Gm-Message-State: AOAM530ggE7fhEheCve5r2VWhX//LKsZ/+g5VliAYFRNdr5LlUH+Hq1g
        vPdWMMLeIYEF6MbLE7+NpHg=
X-Google-Smtp-Source: ABdhPJxR+OT7T+N0scu7+OJ3N5zKnaK10AZc+5oAWBKuauFerzmmg/ujgPWxJmGGltuVI0V11eTxXg==
X-Received: by 2002:a17:90a:4414:: with SMTP id s20mr10248080pjg.81.1624013736445;
        Fri, 18 Jun 2021 03:55:36 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:37fe:3511:289c:b90e])
        by smtp.gmail.com with ESMTPSA id r10sm8827701pga.48.2021.06.18.03.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 03:55:35 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Greg Kroah-Hartman <gregkh@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf] Revert "bpf: program: Refuse non-O_RDWR flags in BPF_OBJ_GET"
Date:   Fri, 18 Jun 2021 03:55:26 -0700
Message-Id: <20210618105526.265003-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This reverts commit d37300ed182131f1757895a62e556332857417e5.

This breaks Android userspace which expects to be able to
fetch programs with just read permissions.

See: https://cs.android.com/android/platform/superproject/+/master:frameworks/libs/net/common/native/bpf_syscall_wrappers/include/BpfSyscallWrappers.h;drc=7005c764be23d31fa1d69e826b4a2f6689a8c81e;l=124

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Greg Kroah-Hartman <gregkh@google.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Fixes: d37300ed1821 ("bpf: program: Refuse non-O_RDWR flags in BPF_OBJ_GET")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 kernel/bpf/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index b4ebd60a6c16..80da1db47c68 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -543,7 +543,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
 		return PTR_ERR(raw);
 
 	if (type == BPF_TYPE_PROG)
-		ret = (f_flags != O_RDWR) ? -EINVAL : bpf_prog_new_fd(raw);
+		ret = bpf_prog_new_fd(raw);
 	else if (type == BPF_TYPE_MAP)
 		ret = bpf_map_new_fd(raw, f_flags);
 	else if (type == BPF_TYPE_LINK)
-- 
2.32.0.288.g62a8d224e6-goog

