Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BD121E510
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 03:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGNB3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 21:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgGNB3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 21:29:30 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936C7C061755;
        Mon, 13 Jul 2020 18:29:30 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c30so14195428qka.10;
        Mon, 13 Jul 2020 18:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R5IIzVMOgCGftVB47FAaShDA0o6roHJ+qQ1SXjjeBPw=;
        b=py84OM+5bG/8beCPdSOmQckjN7FoZchWH/ZlMsgqV0kEXJzeMI3pkaCzwYjHe8FN7q
         7lkkAI/fQ4Bu8cS6E5f0PFiFL0D6+fhbm9SLHkASWNLELrUBTnIBwoEECSb+fHP52QMX
         svXQQgU+Sm9cq4s1ikEcdzccc5mS4h87wkIcsPIpApZRk5/yyyfSrZb67FBOxqWKVt95
         lsAMYIkTgw/TZ+Hd4srf3NaLYg0Wp3lo2J2vWXGeKmhvr72JlJCzW1U9xftaXYJ06UCX
         6e2yRiMobflrXWYyMLPittWrzTkFblzDCn/ay5piTeaLgkIxbVK3+xWqYGwammud6K4v
         D3Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R5IIzVMOgCGftVB47FAaShDA0o6roHJ+qQ1SXjjeBPw=;
        b=CqerWyAImO6k7YCKx55S3ll4WqPw04l4qckjmxsNlvjCSE+xothRGg1qvhK7d1eOmi
         PK96srrEdms33KPVzmmNXQ6bgWpANUDehyCkNFgrJpE4iiOBR6wgCgNyXd18V+bBER5W
         U6/WBeAs9dWMRfH16h3RXHlBn6A2BhvfjvFRT70cGO8Npu2FDcM3f3VIkrXK49HljdkL
         7dP02AAtO66bVvNeENLRSt6ThwHFMCtltEhC+l1KvlLiMB1M4BY2udxVY+aGpwX+gBhR
         hP7JQ0fvYmQXNYAauDVZBa4Phq6vkRkl3MiwHcRaHY1kNFkKFOoG4KpzlYPKXtZGZDOi
         rwSQ==
X-Gm-Message-State: AOAM532htHZ9YM7uywImzTmx/tIRuA4zpXsjcKU8z5m80A0jQxsZdhSJ
        QnvCQorKbr+g8VSvoia11A==
X-Google-Smtp-Source: ABdhPJwiHJEuFip+53k+1C0OC/E9TC3f8o1MxGFmfFAYhf0A8tB6Hb8t/KlSZbhCmgIH8HWpRiLTYw==
X-Received: by 2002:ae9:ea13:: with SMTP id f19mr2317534qkg.331.1594690169776;
        Mon, 13 Jul 2020 18:29:29 -0700 (PDT)
Received: from localhost.localdomain ([209.94.141.207])
        by smtp.gmail.com with ESMTPSA id w28sm19125827qkw.92.2020.07.13.18.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 18:29:29 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [Linux-kernel-mentees] [PATCH v2] bpf: Fix NULL pointer dereference in __btf_resolve_helper_id()
Date:   Mon, 13 Jul 2020 21:27:32 -0400
Message-Id: <20200714012732.195466-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAEf4BzZRGOsTiW3uFWd1aY6K5Yi+QBrTeC5FNOo6uVXviXuX4g@mail.gmail.com>
References: <CAEf4BzZRGOsTiW3uFWd1aY6K5Yi+QBrTeC5FNOo6uVXviXuX4g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prevent __btf_resolve_helper_id() from dereferencing `btf_vmlinux`
as NULL. This patch fixes the following syzbot bug:

    https://syzkaller.appspot.com/bug?id=5edd146856fd513747c1992442732e5a0e9ba355

Reported-by: syzbot+ee09bda7017345f1fbe6@syzkaller.appspotmail.com
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
Thank you for reviewing my patch! I am new to Linux kernel development; would
the log message and errno be appropriate for this case?

Change in v2:
    - Split NULL and IS_ERR cases.

 kernel/bpf/btf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 30721f2c2d10..092116a311f4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4088,6 +4088,11 @@ static int __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
 	const char *tname, *sym;
 	u32 btf_id, i;
 
+	if (!btf_vmlinux) {
+		bpf_log(log, "btf_vmlinux doesn't exist\n");
+		return -EINVAL;
+	}
+
 	if (IS_ERR(btf_vmlinux)) {
 		bpf_log(log, "btf_vmlinux is malformed\n");
 		return -EINVAL;
-- 
2.25.1

