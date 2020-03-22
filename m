Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC7A18E952
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 15:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCVOJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 10:09:16 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42539 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgCVOJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 10:09:15 -0400
Received: by mail-ed1-f67.google.com with SMTP id b21so13201824edy.9;
        Sun, 22 Mar 2020 07:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pBi9Z1+WU4iatz2iMB4jF1UwMBCBTv6eef7cooUFzms=;
        b=TJIxq9L5ba4cEhBvxABO8RbqK99o+J/uKW5K1NX4zXF9+ccmgGCPN9xMUi3ODDtmLB
         PBcy2vAXjGmcFRLGDazaFjQZvbJh+C9y+uSB775OZQa/Bt5Ggi0yydC2VFFqBXH7gj52
         LqUsLpN7NtK+REuoB0Nv2mBg0qVXg+k4aMoRmFVo+m6xiMAgWrlFo8W/hI4JadSMvf7J
         bhqnmhjnGg9m1dsznfGJ6HxlhaTKBtn0UWLHwW+Ec8zCodR4zlWgkqxU1ENYrBPSsQ9d
         UHQONLyRmz2kJCTh6MrOG+d2qEE7dNmpMg8y2pJLEqAK5KvYotdGwiZn02+j2embB16p
         W3UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pBi9Z1+WU4iatz2iMB4jF1UwMBCBTv6eef7cooUFzms=;
        b=J1DcsnXm0zWPVxh2lHFMBcVbWxxwbsnarohsNTjO6RrtJGuYFTwtJGs/2OhcfrXOzS
         RlBS/Omeza/s6TmtostNIrP4t8e4q39hZlIu8FqEhfA4Wq7VyIEw+kr5JUZlK2eCb2mq
         SG0EDCTNrQ8BteQJK99BuqMQY4d6k24rJlTYSXPi7UeB0GEWifl8NOMDTu1n3JHXKEJG
         dm8ZVyS3G7q2cszI2bhGCtIv8lN9JNFwrbBXZyaVBAEjNi0mvQl8rVwy2z3tb8nMvKjg
         VocdeRbzbMI+JFHC5A7yxaeYsN5z2+aIIZPtnFgadOazp0T1XWQKx/QrCRCaK7TaXHwl
         eWjQ==
X-Gm-Message-State: ANhLgQ3D/unUw2dHkkCNc5RqTAWsiaaVgPNebeYhYgcNOu1H/e8JtZ6M
        DOI7I/rhScA+JTHebTqELMV66jGgG14=
X-Google-Smtp-Source: ADFU+vuhSK4TFcDIFhTkZwOxUmu0pr1ErNd/GgOB/C6SQTrQ+k1F8Ju8FjeneoUiS7JIUf/BaHIP1g==
X-Received: by 2002:a17:906:34db:: with SMTP id h27mr15609447ejb.111.1584886152225;
        Sun, 22 Mar 2020 07:09:12 -0700 (PDT)
Received: from localhost.localdomain ([2a02:21b0:9002:6131:e6f7:db0e:d6e9:e56e])
        by smtp.googlemail.com with ESMTPSA id q21sm223858ejb.47.2020.03.22.07.09.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 07:09:11 -0700 (PDT)
From:   Jean-Philippe Menil <jpmenil@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, jpmenil@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: fix build warning - missing prototype
Date:   Sun, 22 Mar 2020 15:08:44 +0100
Message-Id: <20200322140844.4674-1-jpmenil@gmail.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build warning when building net/bpf/test_run.o with W=1 due
to missing prototype for bpf_fentry_test{1..6}.

These functions are only used in test_run.c so just make them static.
Therefore inline keyword should sit between storage class and type.

Signed-off-by: Jean-Philippe Menil <jpmenil@gmail.com>
---
 net/bpf/test_run.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index d555c0d8657d..c0dcd29f682c 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -113,32 +113,32 @@ static int bpf_test_finish(const union bpf_attr *kattr,
  * architecture dependent calling conventions. 7+ can be supported in the
  * future.
  */
-int noinline bpf_fentry_test1(int a)
+static noinline int bpf_fentry_test1(int a)
 {
 	return a + 1;
 }
 
-int noinline bpf_fentry_test2(int a, u64 b)
+static noinline int bpf_fentry_test2(int a, u64 b)
 {
 	return a + b;
 }
 
-int noinline bpf_fentry_test3(char a, int b, u64 c)
+static noinline int bpf_fentry_test3(char a, int b, u64 c)
 {
 	return a + b + c;
 }
 
-int noinline bpf_fentry_test4(void *a, char b, int c, u64 d)
+static noinline int bpf_fentry_test4(void *a, char b, int c, u64 d)
 {
 	return (long)a + b + c + d;
 }
 
-int noinline bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e)
+static noinline int bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e)
 {
 	return a + (long)b + c + d + e;
 }
 
-int noinline bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)
+static noinline int bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)
 {
 	return a + (long)b + c + d + (long)e + f;
 }
-- 
2.25.2

