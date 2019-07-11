Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C31465400
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 11:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfGKJku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 05:40:50 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35258 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbfGKJkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 05:40:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id y4so5540980wrm.2;
        Thu, 11 Jul 2019 02:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XCX9jE72PgkcoZQV6rWjyFaKhpvGYfcrX9M8ab1CPrw=;
        b=tTnECAgQENTRAvFolzVMqQNAdRuuxyLIyO6WnwNCZtbl+6ZtEcBnIX9+BmrieYKt0K
         ruIexHnyZNoen+DLPZDU1/k8ZbGwLWSiw5AYk/hFDoEYbUhlKti0+fnOwa5lTtRI+UH7
         7xOqP5rO9g+eeYOIRxNGsgobWuaJDCBZw75r5HKaYFW4sijjGQZC1u/MMis9O0HjR1N6
         BX8gYw/BsczC2hruBtbVBrsJ8bhLHDskAAqQ4S5QZuPwZnfrtyVj4MvBugcysLV0cO7S
         WpE5dLEal/9OjBdOcFi1RLySx29lVIORPeTBWspYjza4r1V8gkhdWgGuc9Z9LJtgZB9G
         zF3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XCX9jE72PgkcoZQV6rWjyFaKhpvGYfcrX9M8ab1CPrw=;
        b=HGcx844vXWb0QHbOZWjaXmENPPaDmPMpUB+lkL2nmOhr1uCKPaHwWmZ/1z6cmtLVL8
         kuTEmlK0ql5irVjSm+pvjadxLWWa55sl3CZyRHyUYJTJQYPQO2KSHa5eZDYSyhQN5qjX
         eDjVBMBnPBsbxRpyk3T616skzo206E6jPvDWhYhQvgA3xy2l34HIo5lindYJ18QvCUuk
         57CkRriVQ+3TvqDYF/WEAVy2F+2Qlz3LxtcvwsBqVMlIavkO7OGBn0KneT0qPb3vQuZA
         oMHjR9+iQAdpdO+gQM5qvrw/Nkv+VFiKpj7+E76/MnSPMm2sAMahLQmhC0Tp6eWX3Se5
         NdsA==
X-Gm-Message-State: APjAAAU274vc9KhrOfdiDiS1G9VcegQyiYcQmSmLwaRJ83yYxxQUEdRG
        a1CIk+HdG0dnHeV99B0O0QY=
X-Google-Smtp-Source: APXvYqxf5RE+8jpE6XU2p2NQvJdttw5dquomhM5T/35Dwg7JJMJHsZKUgzddC7X0DKbJsdQmhngvlA==
X-Received: by 2002:adf:e841:: with SMTP id d1mr4073489wrn.204.1562838041120;
        Thu, 11 Jul 2019 02:40:41 -0700 (PDT)
Received: from gmail.com (net-5-95-187-49.cust.vodafonedsl.it. [5.95.187.49])
        by smtp.gmail.com with ESMTPSA id r5sm5075433wmh.35.2019.07.11.02.40.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 02:40:40 -0700 (PDT)
From:   Paolo Pisati <p.pisati@gmail.com>
To:     --to=Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] bpf, selftest: fix checksum value for test #13
Date:   Thu, 11 Jul 2019 11:40:37 +0200
Message-Id: <1562838037-1884-3-git-send-email-p.pisati@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562838037-1884-1-git-send-email-p.pisati@gmail.com>
References: <20190710231439.GD32439@tassilo.jf.intel.com>
 <1562838037-1884-1-git-send-email-p.pisati@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Pisati <paolo.pisati@canonical.com>

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
---
 tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/verifier/array_access.c b/tools/testing/selftests/bpf/verifier/array_access.c
index bcb83196e459..4698f560d756 100644
--- a/tools/testing/selftests/bpf/verifier/array_access.c
+++ b/tools/testing/selftests/bpf/verifier/array_access.c
@@ -255,7 +255,7 @@
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.fixup_map_array_ro = { 3 },
 	.result = ACCEPT,
-	.retval = -29,
+	.retval = 28,
 },
 {
 	"invalid write map access into a read-only array 1",
-- 
2.17.1

