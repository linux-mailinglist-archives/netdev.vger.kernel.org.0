Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8A33F8ED1
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbhHZTkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:40:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243407AbhHZTkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:40:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630006772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t8XYUgR9kHcOYFdSNrWNV6bYolumP9ymhRdSASBvoKM=;
        b=J4TD16JPNXes7ncQkhVlXA103mslDdrHwNveGgWlQL1CffLKe1ANTWj93MbmteKA9FHpUD
        tKW4tJaMbpdd2zIK0ads27ujFJPJBSvNm8STzIHwpJEV3F6yB6LcKXyxfE26yEsiuJIqyl
        9wo7C8LpYJGu3CiebMOH8/NarcAfrlw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-BYXGoto1PSeYbaFSTb_yPA-1; Thu, 26 Aug 2021 15:39:30 -0400
X-MC-Unique: BYXGoto1PSeYbaFSTb_yPA-1
Received: by mail-wm1-f69.google.com with SMTP id z186-20020a1c7ec30000b02902e6a27a9962so4767001wmc.3
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t8XYUgR9kHcOYFdSNrWNV6bYolumP9ymhRdSASBvoKM=;
        b=ZlYdiGioWqyf7oahc96ENtiuTlgY521d5phcx9BRquoqmzTkByCkepMseFotmrREV+
         g8NjPJzwn7t5ZjhC3hxYL2AfOUMSREYGHFdEMuqumbqGTqckkTnSl5yIvirVKgcFAo9H
         xpHnDT9vE/3ItpMSpx8EUnROTtcEW/5LgJehHtdeGCUNFg4sDvK22jcVxW8FkZbxwgxT
         fnSx9CtFJNjXsMUpP+0cQRTTkVnchlIZWk6rxGl4D1AlOyb1w9Xe6nNUYx6bTiY22oAy
         9BKw8TZFBKpFyecaY7swO0q8t35yNCHKYk3NMVSromvazuda+sUVjOdXoln0LJ3roZ1M
         qRxg==
X-Gm-Message-State: AOAM532GiGCSf/gcYnWvXHQ8WjHJbNZq3pMtiZf4MLim/VAELekUGP59
        VEl1RfMAk5iX6AkvYaR98yW7cew0rxlKeohMwVAHQCJ2RK3CytEmIYy7RH+VJyUDcCwqOti+uVa
        6M2mnxmgKGdVAyFiH
X-Received: by 2002:a5d:4142:: with SMTP id c2mr6091476wrq.340.1630006769760;
        Thu, 26 Aug 2021 12:39:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBL1FafyptrQyoXeyUcyn0ennz0cwN+Ah0kJWNT5IknqO/e8yH2B5sBSVQLTvUBYm9pq1F/Q==
X-Received: by 2002:a5d:4142:: with SMTP id c2mr6091460wrq.340.1630006769637;
        Thu, 26 Aug 2021 12:39:29 -0700 (PDT)
Received: from krava.redhat.com ([83.240.63.86])
        by smtp.gmail.com with ESMTPSA id r1sm8012572wmn.46.2021.08.26.12.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:39:29 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 01/27] x86/ftrace: Remove extra orig rax move
Date:   Thu, 26 Aug 2021 21:38:56 +0200
Message-Id: <20210826193922.66204-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826193922.66204-1-jolsa@kernel.org>
References: <20210826193922.66204-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's identical move 2 lines earlier.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 arch/x86/kernel/ftrace_64.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 7c273846c687..a8eb084a7a9a 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -251,7 +251,6 @@ SYM_INNER_LABEL(ftrace_regs_call, SYM_L_GLOBAL)
 	 * If ORIG_RAX is anything but zero, make this a call to that.
 	 * See arch_ftrace_set_direct_caller().
 	 */
-	movq ORIG_RAX(%rsp), %rax
 	testq	%rax, %rax
 SYM_INNER_LABEL(ftrace_regs_caller_jmp, SYM_L_GLOBAL)
 	jnz	1f
-- 
2.31.1

