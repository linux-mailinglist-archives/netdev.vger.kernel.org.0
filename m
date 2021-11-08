Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D963C447C09
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238096AbhKHImP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbhKHImN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 03:42:13 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6A0C061570;
        Mon,  8 Nov 2021 00:39:29 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id j9so14544958pgh.1;
        Mon, 08 Nov 2021 00:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iq4zrNVdlh/5wG73Ug/p6d/NCH5T/gwaZPmqV+SFNKo=;
        b=maKAqki5wXCbTQ/fH6Jk+nVp6iuVd+6TxHryAX3qBLaIGjY1EUHFKRg0BjhtS+b7rc
         ND7BY8wMUexofSUrich+OavZEjxkGN9IOjTM5O40/ayuUMiV5kecxpwqtXCYkfIJVu6H
         oznEBwko1QaKnz0HAcguBI5BmVxp06eRNUyWWexz0STcPyytRZ0Omq4KNJ5bJuzt6i/5
         EtZUBdkMm+70IRETGjQClhAj954jzO/TTj9updGyFBOB/X5/lTJzit3bjO60zgRSD0W7
         ZFEDUlm9fglKynTukFdl9B6yw8Qsd8x2YhBrw9xzmyh7OJsleQY8oJn9KwBJ9nO6+lc5
         piyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iq4zrNVdlh/5wG73Ug/p6d/NCH5T/gwaZPmqV+SFNKo=;
        b=wffbn9bfccyGjgwIC9jokkZ5rPTy/W0mhk2dL41pPWzmuYa/Nsvo5IIq6eVHGrXhcT
         J4WD3x3X5X95eYVUyJK8ndLTQIzjn93plRDd8s2iIUEnbG6QdbyRrTVgslA0aOrqZONj
         HfGa8hIL6p2fd7w1XwqgPNLHkRqgEknOFwgP1d+3gcWLJjjcHSDRwb21WKoIGKWwhQOK
         pGBZ0JTiB02CGeRQ5GehUejNjkGtem+FBEHKeHDARGS2F2Ch3ADCFilma1KVOpW8QC72
         A1JmMd+xTgtPaNqxth5y1H/V2l54vNJObhrIztapKU2Xopm4tSdu4NjNc5yw3I4Epp2m
         21iw==
X-Gm-Message-State: AOAM532VyV0/agmVC7DEfq85JfqPGYKoNdS4l6CP2f9lgpL6FH5QTs2c
        cE/XHYfd9CCe6vW6qA/K3aE=
X-Google-Smtp-Source: ABdhPJz5rnIMMev+bztAzoBsTj6gT08dyrO7wwf++qNFeLHZzz0+q7nORNR0ZylFcShM0uAssI/+SA==
X-Received: by 2002:a05:6a00:1686:b0:44d:50e:de9e with SMTP id k6-20020a056a00168600b0044d050ede9emr80979907pfc.4.1636360768710;
        Mon, 08 Nov 2021 00:39:28 -0800 (PST)
Received: from localhost.localdomain ([45.63.124.202])
        by smtp.gmail.com with ESMTPSA id w3sm12253206pfd.195.2021.11.08.00.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:39:28 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, lkp@intel.com,
        Yafang Shao <laoar.shao@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 1/7] fs/exec: make __set_task_comm always set a nul terminated string
Date:   Mon,  8 Nov 2021 08:38:34 +0000
Message-Id: <20211108083840.4627-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211108083840.4627-1-laoar.shao@gmail.com>
References: <20211108083840.4627-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the string set to task comm is always nul terminated.

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
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index a098c133d8d7..404156b5b314 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1224,7 +1224,7 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
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

