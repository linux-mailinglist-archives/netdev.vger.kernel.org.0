Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F11E195FFC
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgC0Ur1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:47:27 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34341 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgC0Ur1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 16:47:27 -0400
Received: by mail-ed1-f65.google.com with SMTP id i24so12946142eds.1;
        Fri, 27 Mar 2020 13:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KrwX+7IzzOcdtmf9GL8aP68WQccVqVWSmtAG1GU9fKQ=;
        b=ZHJZ1sVao15S3PsXnhgLvQKmGh+O3Mrw5UAt6NlaAgQyn2ZmDn/JZuh0bJ5DcWpSmt
         Pb8woPwR21dktkpk17yEH74bwFfUaqlH15wb0TupQEUwbiH95dVBaN0L0S8urJytHLM3
         YnOgNEVJJcct8WA5h+ZjlYw7V/HoJ1P1h56E4g5/bOyXy15gq4P2hQ0Q8b51BoE0ChGD
         st/R7hd71pURtL2VPnBDAtacN7kPswlcWf+kzA+OO1vmbgcZFh0hC12JJsgixnuxMhvv
         A7IOrkb7zT1aZtU2fLMPD/BOjdz8kpURUT8qwMvIIwltjjtzks76Rry0+bwm/XbjJh4I
         JljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KrwX+7IzzOcdtmf9GL8aP68WQccVqVWSmtAG1GU9fKQ=;
        b=S7duBvmKwYwJecfq5KIF2v6YyQW0U0dAB+FAzT+DbF5+Y12aoySAE/et3xA2pTtUfA
         9H7GZbBTNoitlHaZBQRIO0whrOKBKnhbn4nh+/xl7PP9oPVmx5E3pfGfeVgwEzI0Omq4
         q9Aexyo+deEjgMY7jCz82fWVilr9zBMweIv5iwC+48zCuHTQV78QfQfzM9TNLefo6O9U
         yySsNAXxgx1j7J0eV9W/JZHQp0wIpPJXM26w+1Jwj+eihT8eRX5kDL3qEovKPF4hHpQ3
         u/UwWDeGAqNIGx5Rkas4wsGbq1kdNV3FTzcfnKi8YJkovah0O0314bYbU48LhyPiONsS
         WaMw==
X-Gm-Message-State: ANhLgQ0dZsM+jajyALC9p1E9HCTxrOiXdwwzd7t3irzgnL56AyBYQDe3
        yv1P011pRSX1EfA2CvS2UAM=
X-Google-Smtp-Source: ADFU+vu2kBpouAt4iFovayfU8Nv6v1u2o+RYuTZtb4ny6MP0OKtvpfFVrmCI9cxb/fF2Qok5vQ/H4w==
X-Received: by 2002:a17:906:4e12:: with SMTP id z18mr868375eju.49.1585342045395;
        Fri, 27 Mar 2020 13:47:25 -0700 (PDT)
Received: from localhost.localdomain (bbcs-97-49.pub.wingo.ch. [144.2.97.49])
        by smtp.googlemail.com with ESMTPSA id p17sm1048552edq.57.2020.03.27.13.47.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 13:47:24 -0700 (PDT)
From:   Jean-Philippe Menil <jpmenil@gmail.com>
To:     daniel@iogearbox.net
Cc:     kernel-janitors@vger.kernel.org, jpmenil@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4] bpf: fix build warning - missing prototype
Date:   Fri, 27 Mar 2020 21:47:13 +0100
Message-Id: <20200327204713.28050-1-jpmenil@gmail.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <3164e566-d54e-2254-32c4-d7fee47c37ea@iogearbox.net>
References: <3164e566-d54e-2254-32c4-d7fee47c37ea@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build warnings when building net/bpf/test_run.o with W=1 due
to missing prototype for bpf_fentry_test{1..6}.

Instead of declaring prototypes, turn off warnings with
__diag_{push,ignore,pop} as pointed by Alexei.

Signed-off-by: Jean-Philippe Menil <jpmenil@gmail.com>
---
 net/bpf/test_run.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 4c921f5154e0..73e703895343 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -114,6 +114,9 @@ static int bpf_test_finish(const union bpf_attr *kattr,
  * architecture dependent calling conventions. 7+ can be supported in the
  * future.
  */
+__diag_push();
+__diag_ignore(GCC, 8, "-Wmissing-prototypes",
+	      "Global functions as their definitions will be in vmlinux BTF");
 int noinline bpf_fentry_test1(int a)
 {
 	return a + 1;
@@ -150,6 +153,8 @@ int noinline bpf_modify_return_test(int a, int *b)
 	return a + *b;
 }
 
+__diag_pop();
+
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
 
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
-- 
2.26.0

