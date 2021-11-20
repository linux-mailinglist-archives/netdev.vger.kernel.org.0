Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80264457D56
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbhKTLbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 06:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhKTLbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 06:31:05 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665FFC061574;
        Sat, 20 Nov 2021 03:28:02 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso10995375pjb.2;
        Sat, 20 Nov 2021 03:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1bhmfU5jdQeu9SB00q/vtwct43J0/YFTE1w/oQ1md1g=;
        b=afkFqnCvcjnyD8nxdVXqFTSVEVUwnC2uqZPLEPV2jtxoh8iP7hESwhZR+iKFi624AK
         RH++PL7SD5LtzMS97jz58+9YWhK/11GWAslrKTZF2qL5kLy7PaHEpL0Z8ha5A3QSeH7d
         K055K9W/KzVS0TtrsOKVTaZqxYlMy1Jl88y16mrB9ZqHqazzpRNk92K38Uh6vWoD9jJ0
         a4+AHmUUC8DBfR5dlnfj/Jr7bobaOJKTh+6ziBZvfWiOeDH5vERkp1qgicWS+SxHSieO
         YIlL4/qQrJYUJyKRMtSomhCiIa4ajT1ZKTWNa3ISbd10qhd3fbKLriJ/fn5M2go77Qlc
         B+2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1bhmfU5jdQeu9SB00q/vtwct43J0/YFTE1w/oQ1md1g=;
        b=csUooddDX+RFboK+F9ii4WIhRtPyaYwceNfojTJE15K74nTMf4j5SiFiXfLl5fwkX5
         BtVs4IY5hUArpzxjZ1CFaEthPvmKOj6q1EwwRCpmoogRFLliT38Euc/p+VyFyqH1eV0r
         k+M0iWdGSC0WxoSzsYB5FQYZRrUB0RIfWIdZiTm9F94H8g0BFCdHmYDHyHpEd2/qLUXU
         1CJQ+DtbVruTVaAnr93chJHZxGkKCQu5/4cuEUn1qyH3mETduBvcXTAQ9qKJEzxRI65E
         P9m/bVNl3GMmYYupuKaZBy1IpP6PDSr/f5xwTa0L6QWYWf0T4M0c4aiZmKT7r5Gfc0Rb
         VVRg==
X-Gm-Message-State: AOAM530FSlr2blo2s7NgoxJlLYHz0scrle7tQiIwBxJ8yz0ASfuz8yPk
        DNGJ5tWGR9FE7IfePq6eQ/g=
X-Google-Smtp-Source: ABdhPJxliuUDz1XN5kYH2h4oCti40BWvEgRwwTYsKQppVM5CgiOYDrqQRp0zNR3XM7eeyPTuLR4MPg==
X-Received: by 2002:a17:90a:c091:: with SMTP id o17mr9315675pjs.35.1637407682005;
        Sat, 20 Nov 2021 03:28:02 -0800 (PST)
Received: from vultr.guest ([66.42.104.82])
        by smtp.gmail.com with ESMTPSA id q17sm2835490pfu.117.2021.11.20.03.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 03:28:01 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 2/7] fs/exec: replace strncpy with strscpy_pad in __get_task_comm
Date:   Sat, 20 Nov 2021 11:27:33 +0000
Message-Id: <20211120112738.45980-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211120112738.45980-1-laoar.shao@gmail.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the dest buffer size is smaller than sizeof(tsk->comm), the buffer
will be without null ternimator, that may cause problem. Using
strscpy_pad() instead of strncpy() in __get_task_comm() can make the string
always nul ternimated and zero padded.

Suggested-by: Kees Cook <keescook@chromium.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
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
 fs/exec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 51d3cb4e3cdf..fa142638b191 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1207,7 +1207,8 @@ static int unshare_sighand(struct task_struct *me)
 char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
 {
 	task_lock(tsk);
-	strncpy(buf, tsk->comm, buf_size);
+	/* Always NUL terminated and zero-padded */
+	strscpy_pad(buf, tsk->comm, buf_size);
 	task_unlock(tsk);
 	return buf;
 }
-- 
2.17.1

