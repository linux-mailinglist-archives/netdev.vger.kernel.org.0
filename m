Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3BD447C0E
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238121AbhKHImW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238099AbhKHImR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 03:42:17 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71888C061570;
        Mon,  8 Nov 2021 00:39:33 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id g19so9286023pfb.8;
        Mon, 08 Nov 2021 00:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pMvCN74ycpQtuiyiIco6Y7Jz+XXe+RFDsv6G89oMXm4=;
        b=c4A9tarfW3eVsp46QAt4AR1nyCmnNvt5dVVK234LNS0uX8r6BsOgCAPOiCqxs3LbUI
         /xWgGIqLh2OFP7JQsuQo+ZLqMNeVgfvziBtdZX5JhzsuGdtdqaaxCxHM7qKw1C3YfZkC
         R6YX/9r1i0bRp1jS95bazWORKKTyRrBUaW+OYJ6diyZOpiEb1XzRVjFpt0iSBloqkEj7
         +9O7AK5eq6iCFNB1e/+QF6pB/lqRQMh6JiqbE3SJ+0zLZXu53alxkrc643rYYLBfiR7o
         K0qCPuYXgyr+5VXUb+tYHHviFwCxfChPpGq41G69PJ3BPQy6cyCeHN+MTGDK9BlCtGSB
         Jk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pMvCN74ycpQtuiyiIco6Y7Jz+XXe+RFDsv6G89oMXm4=;
        b=aTiDQH4nbIdfy2TT8PpZxpU7LNVbseTWskpPlEAoUIwmpqF9XRKfrhuBM9uJxE/ZTQ
         fIiw2ExB25mAtqXU2w8OI3DYSx9haIA7qT2D+LEOUp/N+4+OuEVG1w9xfSO83RRkRFyo
         bTz0u/t8StK5XFUPAiNrZIY1LzxltLXuE7TKVWt8aTtRzfOcAHeDjVUo2ZZ6XgQSAzDZ
         SoM/CsNU/imXZPkVyPin6vOEnmzxgEGmOUHd4ty6m7aOys33Tgpkg/bw8FNVfGV6x8Jq
         EdUcX3/aU0ivciNLJ403wN7wqhnaKoAi8EbcyAlrCLGDI4B7hCb064aC3tPHeNDKTg4B
         G4dQ==
X-Gm-Message-State: AOAM530LK9Aed+rQ14//6LjSko5tTnYN3YsAbumxYIvNQH7gaIxoutLW
        sBOGOwSLjHp2rlS5QBYMaM8=
X-Google-Smtp-Source: ABdhPJwHHU5s/XJqHJ5mA3bH36SqqIoONZM5F5Gk6ynW4tqq/51O2I2aSuIIWykfZ34KJrCRSlkf8g==
X-Received: by 2002:a05:6a00:216f:b0:49f:dcb7:2bf2 with SMTP id r15-20020a056a00216f00b0049fdcb72bf2mr4101842pff.19.1636360773086;
        Mon, 08 Nov 2021 00:39:33 -0800 (PST)
Received: from localhost.localdomain ([45.63.124.202])
        by smtp.gmail.com with ESMTPSA id w3sm12253206pfd.195.2021.11.08.00.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:39:32 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 2/7] fs/exec: make __get_task_comm always get a nul terminated string
Date:   Mon,  8 Nov 2021 08:38:35 +0000
Message-Id: <20211108083840.4627-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211108083840.4627-1-laoar.shao@gmail.com>
References: <20211108083840.4627-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the dest buffer size is smaller than sizeof(tsk->comm), the buffer
will be without null ternimator, that may cause problem. Using
strscpy_pad() instead of strncpy() in __get_task_comm() can make the string
always nul ternimated.

Suggested-by: Kees Cook <keescook@chromium.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
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
index 404156b5b314..013b707d995d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1209,7 +1209,8 @@ static int unshare_sighand(struct task_struct *me)
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

