Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8983D3D0D9E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhGUKrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbhGUJ7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 05:59:22 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0657C061766
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 03:39:04 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id ec55so1806961edb.1
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 03:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=actVck42QEjdYfIC2+WRyto/8BTycoXWTekXEbzoZVY=;
        b=vdIkctQ8bh+DenGDuthoROL+xfsKQ933isnkdw0NIgFANFaT+yU0laI7XJef4GrAab
         4R/3QAwc4AQ1+NXpaPHXD6OcE7sFoWSYe03hpIVrWKbFtkjK75IJUIUPaghSLjVOx8Dv
         oaQsfbUNSVAun2u7Bb6pNgqsO62CDW8bfctHCu3ZNR8Aj4pBZ9V+Tu5LSUi5HwUik+Z5
         rl9EgXUzVLZO8/bc540l0mMivjk6sxuj6gfbaC2LN7/K6BpuxYvxI+b5ZXIkkxvFD5hA
         RPWlnz/swXiWkhd57TcDJ2ZijpLbDPly3tEU69bkjzmTttWpp5F0BxLfO33G6YaqY+nQ
         Ie5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=actVck42QEjdYfIC2+WRyto/8BTycoXWTekXEbzoZVY=;
        b=csxTmuL9VxPFaHOdbduuIpakhi0LYnzAuGrv41kzNyk9TF6rYp5947kPSVAXw1SoXy
         1B/ZQMRxp/nGI21bbD1GUDzbjhhR6aUSv1Z04x/X98CFa0GJl2M/RC7cA9+ftq3Jg4Gz
         x2AJVWsNXYqyEtM5f4W8bwBMswSYQu5leyZcP5LpWfIbJBi/JbKIE99S054qeYuYxE0n
         JFFKqFgs9ygmMAPZvi6JhmADi2BGd4+r8XCcbUHKB96G4HMt+c7+8zcIECKlQU9eLOZs
         WQI7ur76eFSsvMXHKJ0FnGR6VCstHLwhehkCRCZH+HFCSWJKu6kdU1oumCNC1ZDiWuam
         z5Mg==
X-Gm-Message-State: AOAM533rlg7JxYTN3Ig5/RKREggxlG6W6P26i20EBZBZUWsMqYdmwHab
        mWxevsc/yzIHdD8A45jxjW2rCtBMl4/LVNix9Md6bw==
X-Google-Smtp-Source: ABdhPJwag9FutvMJfVZClejf5HjAnZCqP3cjfnDiTLA1sElmnKKBlw6YVJZ4X7yykilHHZq9GTFRRg==
X-Received: by 2002:a05:6402:10d9:: with SMTP id p25mr21492868edu.51.1626863943546;
        Wed, 21 Jul 2021 03:39:03 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id j21sm10559668edq.76.2021.07.21.03.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 03:39:03 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH] bpf/tests: do not PASS tests without actually testing the result
Date:   Wed, 21 Jul 2021 12:38:22 +0200
Message-Id: <20210721103822.3755111-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each test case can have a set of sub-tests, where each sub-test can
run the cBPF/eBPF test snippet with its own data_size and expected
result. Before, the end of the sub-test array was indicated by both
data_size and result being zero. However, most or all of the internal
eBPF tests has a data_size of zero already. When such a test also had
an expected value of zero, the test was never run but reported as
PASS anyway.

Now the test runner always runs the first sub-test, regardless of the
data_size and result values. The sub-test array zero-termination only
applies for any additional sub-tests.

There are other ways fix it of course, but this solution at least
removes the surprise of eBPF tests with a zero result always succeeding.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index d500320778c7..baff847a02da 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6659,7 +6659,14 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
 		u64 duration;
 		u32 ret;
 
-		if (test->test[i].data_size == 0 &&
+		/*
+		 * NOTE: Several sub-tests may be present, in which case
+		 * a zero {data_size, result} tuple indicates the end of
+		 * the sub-test array. The first test is always run,
+		 * even if both data_size and result happen to be zero.
+		 */
+		if (i > 0 &&
+		    test->test[i].data_size == 0 &&
 		    test->test[i].result == 0)
 			break;
 
-- 
2.25.1

