Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3733F8ED3
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243497AbhHZTk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:40:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243491AbhHZTk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eqAj4ZrmrtKDThZEc8WrAKFFOfUsJKx4HE/+LaO0ups=;
        b=Aqv01lJYjYD8nAuWAlTu4/fQk5EYYnyoRW2U3cBdRoPozjUCJ6H9tvdwQ2DnaI6f/M7aq2
        /NbrS0Hy8uBgYpuj8lPnG1vzD/xiSpk3R/Pmd+92Gcr/MiNXf4l7CzH/fq26ZuN54bPacb
        uWXiBzIkRpqPXZRJVKMat6wLY+ygHC4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-cptDl3w1PPilCz1_OCbszA-1; Thu, 26 Aug 2021 15:39:37 -0400
X-MC-Unique: cptDl3w1PPilCz1_OCbszA-1
Received: by mail-wm1-f71.google.com with SMTP id r125-20020a1c2b830000b0290197a4be97b7so1124943wmr.9
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eqAj4ZrmrtKDThZEc8WrAKFFOfUsJKx4HE/+LaO0ups=;
        b=NnY6wOYSCaUW9rrz1ikqyrfOzoyRxZjQXDjIwga12ZpZUHS3IH2kOYafMiFzwT7V4C
         5rde1P5z8JZmb/+TOaxaO31GuJGMjlDLasJ6wLhfmvJhGfRoJHfzBSUACFdr8Q3fVc3H
         pPvRiIjqnXRPorM9aDKzp5kLXHYqnH1bSnTHc1l97oFlZLSiXp491m2+NtEG2tMvOA6u
         al9yO+siut4+T4i06hyDm9HnuW6E+iqN01BdsDOAP8u+t+7Po4hA4SA8UWZsw3BQBVAF
         0xEYyjmhvwpqoAtsc5WrkIm38bAUOOJYd4jB7WiyPrrAkdwOZ85CSYMF3WhX6kJ9ruBc
         LklA==
X-Gm-Message-State: AOAM530KrqOoAejNXduIL1akWsF11d1a8ykZHXlkjn9LSN3nkFhPBLcm
        2Y+IytH+ilF6mgRuiVNxBPSLZ05WgxauD0KCk9M/qpGwzloh/67zw+ESsuGytgcFCWSEtkBRV9S
        VPC8L/R3NLIUYoSbK
X-Received: by 2002:a5d:664b:: with SMTP id f11mr5900059wrw.39.1630006776008;
        Thu, 26 Aug 2021 12:39:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynG5QoqDJvteuV2aFyjTpD5oRelW0Ocw2434p+kHB3WTHEdIOLbOwZ+xN6eQOLJnZF/BgGeQ==
X-Received: by 2002:a5d:664b:: with SMTP id f11mr5900047wrw.39.1630006775853;
        Thu, 26 Aug 2021 12:39:35 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id o5sm3981177wrw.17.2021.08.26.12.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:39:35 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 02/27] x86/ftrace: Remove fault protection code in prepare_ftrace_return
Date:   Thu, 26 Aug 2021 21:38:57 +0200
Message-Id: <20210826193922.66204-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Removing the fault protection code when writing return_hooker
to stack. As Steven noted:

> That protection was there from the beginning due to being "paranoid",
> considering ftrace was bricking network cards. But that protection
> would not have even protected against that.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/kernel/ftrace.c | 38 +++-----------------------------------
 1 file changed, 3 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1b3ce3b4a2a2..c555624da989 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -625,12 +625,10 @@ int ftrace_disable_ftrace_graph_caller(void)
  * Hook the return address and push it in the stack of return addrs
  * in current thread info.
  */
-void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
+void prepare_ftrace_return(unsigned long ip, unsigned long *parent,
 			   unsigned long frame_pointer)
 {
 	unsigned long return_hooker = (unsigned long)&return_to_handler;
-	unsigned long old;
-	int faulted;
 
 	/*
 	 * When resuming from suspend-to-ram, this function can be indirectly
@@ -650,37 +648,7 @@ void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
-	/*
-	 * Protect against fault, even if it shouldn't
-	 * happen. This tool is too much intrusive to
-	 * ignore such a protection.
-	 */
-	asm volatile(
-		"1: " _ASM_MOV " (%[parent]), %[old]\n"
-		"2: " _ASM_MOV " %[return_hooker], (%[parent])\n"
-		"   movl $0, %[faulted]\n"
-		"3:\n"
-
-		".section .fixup, \"ax\"\n"
-		"4: movl $1, %[faulted]\n"
-		"   jmp 3b\n"
-		".previous\n"
-
-		_ASM_EXTABLE(1b, 4b)
-		_ASM_EXTABLE(2b, 4b)
-
-		: [old] "=&r" (old), [faulted] "=r" (faulted)
-		: [parent] "r" (parent), [return_hooker] "r" (return_hooker)
-		: "memory"
-	);
-
-	if (unlikely(faulted)) {
-		ftrace_graph_stop();
-		WARN_ON(1);
-		return;
-	}
-
-	if (function_graph_enter(old, self_addr, frame_pointer, parent))
-		*parent = old;
+	if (!function_graph_enter(*parent, ip, frame_pointer, parent))
+		*parent = return_hooker;
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-- 
2.31.1

