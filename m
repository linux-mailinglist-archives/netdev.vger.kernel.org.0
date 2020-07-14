Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A0621F8CC
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgGNSK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbgGNSK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 14:10:28 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26A9C061755;
        Tue, 14 Jul 2020 11:10:27 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id u12so13508019qth.12;
        Tue, 14 Jul 2020 11:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZX4l9y/mb02MIUOaKSz1lj12ECx0wlEAm51QAfF6o/8=;
        b=WsiJGXVqDNs9WargJT52mvIz/gaCVCuxb52bFJeFukAYzSUEIh2fdlkQeVqeuWbB0D
         Bzbqn0r0doaRe/L6ZZIb3zStjHYGZ8RF2beyf9yjYgP8agdHAl0PAiSbAO4euheDv12l
         8btObml9Y9hX6nYx8w01Xl2cH7DSo25hPOO4FJFsbXHDRP0OEfMtN0dqr2T/CmkEn3QC
         pOonLTv9BirBHzAunpzAGUXm4OHH4ctLfxxq13swaSMV/LTuMoEKHkYbwWJA0nb4jEM7
         7Ke2VPeIG86ZGrJ4GX1h39LqB8Ud3pcWPrGhbq8RY+MWZ+rPqXoJNibnsLvzBSqf90bk
         QeSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZX4l9y/mb02MIUOaKSz1lj12ECx0wlEAm51QAfF6o/8=;
        b=WK71pxN91y9WAgxJ1Gm/yHPuW91KAmwbGJnGDseTNRa445SVDVBhAkkW8sVHRLEuPd
         SqHZ6F97P7CCk6BtDSbH0NQf04eR3vgRUIbOywAa4pXh1KlQTjkqVGgTpDQbL47RKlvS
         9RzOi9xVrEuuTtKMQPDlK2j0IXWhn3jId1uOA/im9vxzPpCgEbdBn9EyQ2PVSM0NYpFM
         e1NDWJVwCouTeWhVbSUOmnx2YFIrBb5U34ntq4uUa8HThl/zddlkzNBSY7zf+cDPwT4e
         me+k/BLRReO0VbQwlO/VC41qwiRLj2XJFDD1r4a70o8mL8JeMs+DDQ4kMCLIjSJpspk4
         JCww==
X-Gm-Message-State: AOAM530SlVMg0pF7ewMbMJLxRkYDhfv+nxzPBG+E1DMbXlbzwSW5RVCB
        v9i7lTg3ntGGtIix6rhL4w==
X-Google-Smtp-Source: ABdhPJzIfX8uNaGelEtus3hlnEHUAzJCj9p6MTHvuiHUjgC4AFO0/AIzEJVEUS+Rr3I8EFtZYkxMRQ==
X-Received: by 2002:ac8:3028:: with SMTP id f37mr5775930qte.351.1594750226967;
        Tue, 14 Jul 2020 11:10:26 -0700 (PDT)
Received: from localhost.localdomain ([209.94.141.207])
        by smtp.gmail.com with ESMTPSA id n64sm22663726qke.77.2020.07.14.11.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 11:10:26 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
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
Subject: [Linux-kernel-mentees] [PATCH v3] bpf: Fix NULL pointer dereference in __btf_resolve_helper_id()
Date:   Tue, 14 Jul 2020 14:09:04 -0400
Message-Id: <20200714180904.277512-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAADnVQ+jUPGJapkvKW=AfXESD6Vz2iuONvJm8eJm5Yd+u9mJ+w@mail.gmail.com>
References: <CAADnVQ+jUPGJapkvKW=AfXESD6Vz2iuONvJm8eJm5Yd+u9mJ+w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prevent __btf_resolve_helper_id() from dereferencing `btf_vmlinux`
as NULL. This patch fixes the following syzbot bug:

    https://syzkaller.appspot.com/bug?id=f823224ada908fa5c207902a5a62065e53ca0fcc

Reported-by: syzbot+ee09bda7017345f1fbe6@syzkaller.appspotmail.com
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
Sorry, I got the link wrong. Thank you for pointing that out.

Change in v3:
    - Fix incorrect syzbot dashboard link.

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

