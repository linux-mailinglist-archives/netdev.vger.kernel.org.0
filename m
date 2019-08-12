Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F95E8A9CE
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfHLVvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:51:45 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:41224 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbfHLVvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:51:45 -0400
Received: by mail-pf1-f202.google.com with SMTP id q14so67116014pff.8
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+V6H61t/WhJBtoDgPI8KA/pTwpjh8ARqkJflJLJFNkA=;
        b=B1M/tQczf/XakLDt4Inap3j9ElF/nZDax8kM67P0+4rSAEH7C64FdFFYSLrRzqKkYX
         0BjVEzzXsoy4prlbQ9UO0XjUaVioPsJepUdinCXmNmWblyLhMttRjyNxD395r0K07Uzq
         +/vSotQ5Btm7RMFUZCamhb3TLsBzJCaWms2wf2rRuXQexO/KFVHurKufzwuszAO9xl8y
         /c8iAdvW+4Z8pgK6ZZu2qf3nKfh7SLjj/Z2XrgIF3XmS8VDTsFKsRyWO7EKfHlCChLLB
         Ynh+8+O0K3H3ODFi/7qj3ZBp5fP0ts2nLOsZEEbcDm3suCCsaDUMEh0gh9cDLV1vqruy
         dkgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+V6H61t/WhJBtoDgPI8KA/pTwpjh8ARqkJflJLJFNkA=;
        b=r+Fq0S7i9YU6/k6hg2d1ZoxLlEVlRpvVyfoykpYKiox8IK9HVMv2PFR+hcFIJIXsOZ
         qyfEAgcnHafLpJyeL+IVCHGXa3BHUepH7l2Rr0C5Nj2RDsmjQQWlJ6Y/7ikLFkXVRtDi
         ccdMVNvf1I4AfYL4z3rWuDkGJoEf1ZdUVfWBBmKDEZcWeOgGdTZQu2kqbqqttfupy3Hc
         beytrKlemq/u8K3t0fMD49W70IwM/mP3gO9qfVfkJLEc/lPUdfpr8q0PQjnx4fMusxTr
         hkQinHK8t/JPhwgTMV7MGRNZMpN1ys7L0YznV4f2/2inQZktq5r7rXjJ5M/1RGF8Cgep
         en7A==
X-Gm-Message-State: APjAAAXc6dxs85OK5SzJykMnpFzEXUa9FJYCMrNym7ZlvXDCOSWSgBxH
        9YSqL/g1IT18QFaVn/DGlhe7pkJfETmVQcHscQg=
X-Google-Smtp-Source: APXvYqy+gBnwTRFqFtcaUPFVCV+RN8fBOs7JrKztEUXGWzHzMhKgSUKueSt0oxa7kDLjRP4KiZmrddRZ5NjXndqtJSs=
X-Received: by 2002:a65:68d9:: with SMTP id k25mr32098928pgt.337.1565646704006;
 Mon, 12 Aug 2019 14:51:44 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:50:37 -0700
In-Reply-To: <20190812215052.71840-1-ndesaulniers@google.com>
Message-Id: <20190812215052.71840-4-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH 04/16] um: prefer __section from compiler_attributes.h
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     akpm@linux-foundation.org
Cc:     sedat.dilek@gmail.com, jpoimboe@redhat.com, yhs@fb.com,
        miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-um@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/um/kernel/um_arch.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index a818ccef30ca..18e0287dd97e 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -52,9 +52,9 @@ struct cpuinfo_um boot_cpu_data = {
 	.ipi_pipe		= { -1, -1 }
 };
 
-union thread_union cpu0_irqstack
-	__attribute__((__section__(".data..init_irqstack"))) =
-		{ .thread_info = INIT_THREAD_INFO(init_task) };
+union thread_union cpu0_irqstack __section(.data..init_irqstack) = {
+	.thread_info = INIT_THREAD_INFO(init_task)
+};
 
 /* Changed in setup_arch, which is called in early boot */
 static char host_info[(__NEW_UTS_LEN + 1) * 5];
-- 
2.23.0.rc1.153.gdeed80330f-goog

