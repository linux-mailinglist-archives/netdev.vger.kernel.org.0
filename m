Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B586558D7
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 08:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiLXHP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 02:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiLXHPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 02:15:53 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81ED2644B;
        Fri, 23 Dec 2022 23:15:47 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so10584447pjj.2;
        Fri, 23 Dec 2022 23:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=etHLeTNew4fJlRfaoMniwFyAw1Vgdj/SeT5idN6XmJY=;
        b=czV1PcLaQPnbrXTJ8aib7fpbN+o8rkS4vP+OxTXwTOGtifOwWt3BMvgi/5LWpwS8Tl
         SfEhqjNp7PXj8RirMBRj9XhjafcDnXJj3DQqu0eQWTlR+YRs0wkH59R8KfNQyWOzQeHO
         t1q9+k4wtzNJxgF6My/4mY7hjL7zdJ7giZZd+k8N9vUiydf2hQOsBTkPZOionyNP+hIP
         CKgP2bdhmxvJHW+wu9j+htgXFeT8p6BWmiBHfI4v38NcCYRq29VSRKRUG0qTHqezF4nW
         FPvpWqmETvOmhlDsXStLQAsx0l8vNnUpl/r0lwso/cEJz0j7QlhFuKPTSTeBeJ8D7fmy
         wOgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=etHLeTNew4fJlRfaoMniwFyAw1Vgdj/SeT5idN6XmJY=;
        b=c/wO3I9W/DaPBODIFCKJVw3bLdWKCMLbRxRCStZv23dTxwloSYLNpTXrHt/PnlZrS4
         Rmsm2mn0v0BGW9s0fg0HvG6Mdw7fyQvx8XgeUML3vXu3f+Ccpzca+01CY2eS9AkSDDZA
         U4x7Tew1RQKnweuPgce1UQeSZOgyN+rzmNRmLMJIryHwR/V+3agOTZwObh8kRpiDLiaQ
         datoFQ+c7zo9n2UVm4luv1c4O7d4Qd23xX4A2oYRZQd/MlAUiQqKyKhv1xb7UVeRLm+P
         voDOzrZtzUkdIFUtNgVnLOiAZuCfk19CpYO/qHyVx8P7+XQjYMMB8QShcWwqvCgqvr/p
         V6Dw==
X-Gm-Message-State: AFqh2kr/UPtp9G2YNRqlDIqlpFPh8VnZ98AU+HUPGqz77eZ36by8g4hk
        V++24dVKI+6TUzjZ+FhZNw==
X-Google-Smtp-Source: AMrXdXvifhZa2VwYa2kLpQ5xq5fwOctvLGkjgqpeQ77KnAzPBwdSDlEwIASdV6e4e3x7No+3s40t4A==
X-Received: by 2002:a17:902:eb11:b0:189:f69d:d5cc with SMTP id l17-20020a170902eb1100b00189f69dd5ccmr12230275plb.58.1671866147030;
        Fri, 23 Dec 2022 23:15:47 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id bf4-20020a170902b90400b00186b7443082sm3433222plb.195.2022.12.23.23.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 23:15:46 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v3 4/6] samples/bpf: fix tracex2 by using BPF_KSYSCALL macro
Date:   Sat, 24 Dec 2022 16:15:25 +0900
Message-Id: <20221224071527.2292-5-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221224071527.2292-1-danieltimlee@gmail.com>
References: <20221224071527.2292-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there is a problem with tracex2, as it doesn't print the
histogram properly and the results are misleading. (all results report
as 0)

The problem is caused by a change in arguments of the function to which
the kprobe connects. This tracex2 bpf program uses kprobe (attached
to __x64_sys_write) to figure out the size of the write system call. In
order to achieve this, the third argument 'count' must be intact.

The following is a prototype of the sys_write variant. (checked with
pfunct)

    ~/git/linux$ pfunct -P fs/read_write.o | grep sys_write
    ssize_t ksys_write(unsigned int fd, const char  * buf, size_t count);
    long int __x64_sys_write(const struct pt_regs  * regs);
    ... cross compile with s390x ...
    long int __s390_sys_write(struct pt_regs * regs);

Since the nature of SYSCALL_WRAPPER function wraps the argument once,
additional process of argument extraction is required to properly parse
the argument.

    #define BPF_KSYSCALL(name, args...)
    ... snip ...
    struct pt_regs *regs = LINUX_HAS_SYSCALL_WRAPPER                    \
			   ? (struct pt_regs *)PT_REGS_PARM1(ctx)       \
			   : ctx;                                       \

In order to fix this problem, the BPF_SYSCALL macro has been used. This
reduces the hassle of parsing arguments from pt_regs. Since the macro
uses the CORE version of argument extraction, additional portability
comes too.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/tracex2.bpf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/tracex2.bpf.c b/samples/bpf/tracex2.bpf.c
index 4b9d956a3e2c..1e1a75850307 100644
--- a/samples/bpf/tracex2.bpf.c
+++ b/samples/bpf/tracex2.bpf.c
@@ -8,6 +8,7 @@
 #include <linux/version.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_HASH);
@@ -76,14 +77,13 @@ struct {
 } my_hist_map SEC(".maps");
 
 SEC("ksyscall/write")
-int bpf_prog3(struct pt_regs *ctx)
+int BPF_KSYSCALL(bpf_prog3, unsigned int fd, const char *buf, size_t count)
 {
-	long write_size = PT_REGS_PARM3(ctx);
 	long init_val = 1;
 	long *value;
 	struct hist_key key;
 
-	key.index = log2l(write_size);
+	key.index = log2l(count);
 	key.pid_tgid = bpf_get_current_pid_tgid();
 	key.uid_gid = bpf_get_current_uid_gid();
 	bpf_get_current_comm(&key.comm, sizeof(key.comm));
-- 
2.34.1

