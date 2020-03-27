Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43438195264
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 08:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgC0H4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 03:56:04 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33524 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgC0H4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 03:56:04 -0400
Received: by mail-ed1-f68.google.com with SMTP id z65so10039687ede.0;
        Fri, 27 Mar 2020 00:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DOngrTjBMh1Wy5Q62zykbp/GEp/RVLEjSOAHb9wDE0c=;
        b=ryfx4Hftnscsun3x0YRsp74LdqQiGv/vq2nUpom1Hz3IuxiKxC61rgDIm13OxGkthi
         y1mIStVSphXp5/D8Dsk9k2T0tHZLc374B8qvpNTwvxhpmieYSLwjv1P7wD4iDN126CAj
         KIXpaTHgVAq/+9kLhFyYBYMBpq1oEOClAiZERxUYwhfipTk0XlFHnOjj+CWczNIA8JQf
         BOwWhdjL+Gjm6ScPcPyL2HjiL93loKaKQX8ZlQf8lgFXMxXpTFRDEAxd82euJGCEw3lY
         xARqvWx2jaQ6hZiLQvkQoei6YvSBLT6kjGl1xX1ugQixeCZ8oGJb5J51IZenKRukYsrb
         nt5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DOngrTjBMh1Wy5Q62zykbp/GEp/RVLEjSOAHb9wDE0c=;
        b=Ltg3u/CBwMhn8tsAqThcenad04eYruJtGRzow3Cb/hfQUrjfvATvcCG7R3LfXhc+QS
         edULvuRsgXoo7xsb6zq9401Gd3ORdsnJGBV6L/Nn4oZ5n2VU45uZ3M4DQkLE4QKX/hXO
         wCcRo2kyMKSqF16m6Bwczq1rkkqhQ1tP5xrC+8hYMgOtWjb+f5afe2fBoQ0nRMM/0KHE
         XU8e1Mv7A0BsjNx00nD55Tzb3lTbGTII30NaBA58+KXSvWLlrsWISKTvP0oAFJO1kFB5
         2PO+vKDRzlkxxQ+VulsEFhiEfRwqWBfrhU0jfnE0rssZmT2JpQ4hzB6sWtXG5Eo8omO3
         32LQ==
X-Gm-Message-State: ANhLgQ10r9f7vuaSuR6U/YylTf0sRL4rnmjUldUkWgA+pAeLphYBiGHL
        cOebi/Z71kd1tcwB5oG8e38=
X-Google-Smtp-Source: ADFU+vstx/W2tBPN+4MRXuf6ruZaoVkf6YjvrW6OBAO9GSINxibsBVs6wEpuM49d+z3UubAGouAUTA==
X-Received: by 2002:a50:bb47:: with SMTP id y65mr9666906ede.204.1585295761754;
        Fri, 27 Mar 2020 00:56:01 -0700 (PDT)
Received: from localhost.localdomain (163.239.197.178.dynamic.wless.lssmb00p-cgnat.res.cust.swisscom.ch. [178.197.239.163])
        by smtp.googlemail.com with ESMTPSA id b11sm718149edj.20.2020.03.27.00.56.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 00:56:01 -0700 (PDT)
From:   Jean-Philippe Menil <jpmenil@gmail.com>
To:     alexei.starovoitov@gmail.com
Cc:     kernel-janitors@vger.kernel.org, jpmenil@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] bpf: fix build warning - missing prototype
Date:   Fri, 27 Mar 2020 08:55:44 +0100
Message-Id: <20200327075544.22814-1-jpmenil@gmail.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200326235426.ei6ae2z5ek6uq3tt@ast-mbp>
References: <20200326235426.ei6ae2z5ek6uq3tt@ast-mbp>
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
index d555c0d8657d..cc1592413fc3 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -113,6 +113,9 @@ static int bpf_test_finish(const union bpf_attr *kattr,
  * architecture dependent calling conventions. 7+ can be supported in the
  * future.
  */
+__diag_push();
+__diag_ignore(GCC, 8, "-Wmissing-prototypes",
+	      "Global functions as their definitions will be in vmlinux BTF);
 int noinline bpf_fentry_test1(int a)
 {
 	return a + 1;
@@ -143,6 +146,8 @@ int noinline bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)
 	return a + (long)b + c + d + (long)e + f;
 }
 
+__diag_pop();
+
 static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 			   u32 headroom, u32 tailroom)
 {
-- 
2.26.0

