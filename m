Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A429457D47
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbhKTLbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 06:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237364AbhKTLbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 06:31:03 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80EBC061574;
        Sat, 20 Nov 2021 03:28:00 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id g19so11581952pfb.8;
        Sat, 20 Nov 2021 03:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z7z8Lk8HQyp7Owzrc1xbHZJuDcW2wrqL7RcrZw36R8w=;
        b=nQPN6mdVaURVKIXfc1WLRgCv3LcDfgP+BvR5M8bS7uDh9hb7+0CR/cbwG+1w5WOEQ6
         Vvjd5bswZ+eUyJf6IEEUJ3X4nw4wp6LYK+qEl+LNZUKwEFNjW+vYQwwd4HwWkThtN0YH
         ABITWvIYzC1j4vzBdyDj1GadxflpStTg597iJ1sjW6FKKAL2A+fMWGFXVkoP8BJ91FK6
         LihypxMER6hOyMDVdKR9ILrkdyvXJgXHUISem4H0h8IzU/5gdbolUTA7vEaLFbVutke5
         jGLHaUXCSmHu7IwiQ9TDKfxjeJZp6KdJY/RkGrqg+I9aO0S7/yFjx4eO2ZmmkGhOdER/
         uicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z7z8Lk8HQyp7Owzrc1xbHZJuDcW2wrqL7RcrZw36R8w=;
        b=OKiuja5otnSkz480FXPzJutrn9JzOHvPYvg1+mPSsSkrN8GDplRxs98p4eLaDlZV9Q
         EsfJI9SeR+R5zapPDBFiuRJZl51hmJ8Y2hVKSZlcq5frIEYIgbC8zjgV3W8mZXFgJA8o
         46OFyzjTALCvHBvTwaZGtqVvgDlzRBK75P2vj3IWU4fvLN0W7o7UVepEnO/mSoKytjjm
         LUFXFsw25TMvXF8vAQ8TuoLXQ20Aczvc/9fwXudSz7SuZFgxi5NLn5LdZZBf4bWmQTNE
         YgI/G9WjptaWeMU/Cb7K/kvYIVyCXbblU68h/mdCjDkzTQhQ1kMZI+G0euNzdqB9mqtC
         S5Ew==
X-Gm-Message-State: AOAM5331SLSDkJcNISvrwdE0VEDtANFxSbkms5S5vcUbkZYEC2fTYIbX
        xj77j3Q3dHt7du8TAbYW8ho=
X-Google-Smtp-Source: ABdhPJyRIisol+5siMpWb0J3Nc8SIlVbonIjAvGoaujIU+KdXppeIb88o7SguvA8H1tXupl8NMAHhw==
X-Received: by 2002:aa7:888d:0:b0:46b:72b2:5d61 with SMTP id z13-20020aa7888d000000b0046b72b25d61mr69933734pfe.73.1637407680517;
        Sat, 20 Nov 2021 03:28:00 -0800 (PST)
Received: from vultr.guest ([66.42.104.82])
        by smtp.gmail.com with ESMTPSA id q17sm2835490pfu.117.2021.11.20.03.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 03:28:00 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 1/7] fs/exec: replace strlcpy with strscpy_pad in __set_task_comm
Date:   Sat, 20 Nov 2021 11:27:32 +0000
Message-Id: <20211120112738.45980-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211120112738.45980-1-laoar.shao@gmail.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

strlcpy() can trigger out-of-bound reads on the source string[1], we'd
better use strscpy() instead. To make it be robust against full
tsk->comm copies that got noticed in other places, we should make sure
it's zero padded.

[1] https://github.com/KSPP/linux/issues/89

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
---
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 537d92c41105..51d3cb4e3cdf 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1222,7 +1222,7 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 {
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
-	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
+	strscpy_pad(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
 	perf_event_comm(tsk, exec);
 }
-- 
2.17.1

