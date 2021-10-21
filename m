Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A17C436AD6
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 20:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhJUSsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 14:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhJUSsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 14:48:30 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B597C061764;
        Thu, 21 Oct 2021 11:46:14 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s136so1128447pgs.4;
        Thu, 21 Oct 2021 11:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=f+vLzPhKqYW+u2TyM1CJYz0VqLaKVG+1YIt+vOSwseY=;
        b=kupY+tcTa5oHBGDy+CeW5aRpSIWBWUZp0w9u+DTQqpLREit91lPulHzuAtsn1Qo7Tz
         S29w7f+Kji3yfzl9mVAbw4augIyLXjf1lZRA0VXR5BtmYHGQPJSgBOMvMl9XhwIsVsz7
         QFUixdkJ+SnC1MqVciImr88ASZP5HCu0Cdt6LJnGhWtcuGZvKPL4Tg10q587Fe6DkGFE
         O68VKjgs810X40U4e9ybxLW+TDc9lIFifghlreBXzFmEXMkEahyr13ueJx/eLaVnGUQ+
         90fCIebVoFfAv+AlLx2IVU3ST/+ROra2F3ZsSMw1t7ppcmJb+0sOEPwFe1zHIGud+NPh
         VxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=f+vLzPhKqYW+u2TyM1CJYz0VqLaKVG+1YIt+vOSwseY=;
        b=RICor2sfGzZfJWtNXNnTmSM4W4SzxA7Dp7wdWruRqTjbY5nTR01b3cqrVXztG+nI+u
         1ANLMU57MZWmdUwZ2aUyrjp6WCxPBJiPhbdTxnFFaZsaenrHG8nN07IGvBWf/n0isYTs
         rz1OtBS/evxZ83/Mcrnitfi2GJxok4tNXrSyLVaXgSSfTGQukM4IG/TEmDW6ISFZ4Vwu
         D3huyseooFsAibopDs7nAVWNrPEKiNjxyFnQJIt49noWMY5hYrCUTW0YijjBWSfvzYhh
         nbi+an/u4NBXMh9e4fzj0Czn1+cRR5eGWuDb4EzJocwonU4RU2H7VU78rgh8A1LzIcK0
         cK3w==
X-Gm-Message-State: AOAM533nqB9kzBJGAjPIL6GbvU5qZMy1scGhhjEiIFNcbt3zHJTjR4jO
        6ClAEuEi5u47HTLi3ZDLMgM=
X-Google-Smtp-Source: ABdhPJzqGXvLKwCGdiL7X38HU/QgJsL8HaczyXcl7J2bCjsXGgMZGnPqGy/IJcp+Mwl/AmWsFzdb0Q==
X-Received: by 2002:a05:6a00:22c8:b0:44d:cb37:86e4 with SMTP id f8-20020a056a0022c800b0044dcb3786e4mr7240063pfj.78.1634841973905;
        Thu, 21 Oct 2021 11:46:13 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id p31sm6829296pfw.201.2021.10.21.11.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 11:46:12 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 21 Oct 2021 08:46:10 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, kernel-team@fb.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: Move BPF_MAP_TYPE for INODE_STORAGE and TASK_STORAGE
 outside of CONFIG_NET
Message-ID: <YXG1cuuSJDqHQfRY@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_types.h has BPF_MAP_TYPE_INODE_STORAGE and BPF_MAP_TYPE_TASK_STORAGE
declared inside #ifdef CONFIG_NET although they are built regardless of
CONFIG_NET. So, when CONFIG_BPF_SYSCALL && !CONFIG_NET, they are built
without the declarations leading to spurious build failures and not
registered to bpf_map_types making them unavailable.

Fix it by moving the BPF_MAP_TYPE for the two map types outside of
CONFIG_NET.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
---
 include/linux/bpf_types.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 9c81724e4b985..bbe1eefa4c8a9 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -101,14 +101,14 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STACK_TRACE, stack_trace_map_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY_OF_MAPS, array_of_maps_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_HASH_OF_MAPS, htab_of_maps_map_ops)
-#ifdef CONFIG_NET
-BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
-BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
 #ifdef CONFIG_BPF_LSM
 BPF_MAP_TYPE(BPF_MAP_TYPE_INODE_STORAGE, inode_storage_map_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_TASK_STORAGE, task_storage_map_ops)
+#ifdef CONFIG_NET
+BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP, dev_map_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_DEVMAP_HASH, dev_map_hash_ops)
+BPF_MAP_TYPE(BPF_MAP_TYPE_SK_STORAGE, sk_storage_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_CPUMAP, cpu_map_ops)
 #if defined(CONFIG_XDP_SOCKETS)
 BPF_MAP_TYPE(BPF_MAP_TYPE_XSKMAP, xsk_map_ops)
