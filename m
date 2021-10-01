Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE71A41EE25
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354226AbhJANGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354167AbhJANGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:06:03 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B88C0613E6
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 06:03:59 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id p13so6294978edw.0
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 06:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jw9IUMaLywJloQik8I5Go3bAQFQF2YDMapxftvHW9ss=;
        b=kL2uqYRQ2DVtojeTq45f2PBUCs/JXBOYH0ZwK8Hfc2IXN7XA4Hqq5tcw+M/hSqfiXN
         Y3/VRbCBvw+Pjo+kfDnIKtI3KmDbh+ucB5dej+lwpi97aoX8mvdHKvoQgbisctbT5CEt
         BVmfsMrbV55wU0vIvK3l1yt4YhuVzXjk6uIPOqvroOzAibAIsUYHNQy9cBn7wSVwPg7f
         gFzFhwTQfz+rJHM0ikSrFhloNT333EeEWi284vZfKSGIQK1EVAoacjypl9YPwpbw4Mi8
         9ZFnos4j8jcKN5c3nQZDZA42diEPI0bQN+inwWP+tpNI4Xlnt/PRPLUuIpS3KxqjM/sY
         7tWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jw9IUMaLywJloQik8I5Go3bAQFQF2YDMapxftvHW9ss=;
        b=EFlEQbSQMX4s8zCGiZ0Rc0fX8Fp0zc9yoVVk0CvHPY6j4MR7JllJzIWnoD6nBSFFr5
         dnQbaZw4ioeZgD2zvYjeZK/XWYBwrW11S8l5+fpMi0LnI8aX0njV3HVC48eMW1/TDmBZ
         hPJii+9+59U7UdJQf2gnjzq6L3enNb3BQCRh9ClVZ6v/qIKt9qs2kyqKkiyiBVyXVN9h
         djXYNZ9S75ym+phxgL+EVqd2Gr/XwdSQ9lsLVPqc4SI8oLZkHUd0GLJi80G2qUqM1jst
         CnHI4Q0PXWYXcR2IuhjoC/zemSqg7oW3ZH4RDF3IdcU5DzQcXBcIYvuyHr1h9KN1e+9M
         RIcw==
X-Gm-Message-State: AOAM531Io7+VCTmVg2xohMrOYzUt9NUar9M2gVVxAYriXJUQejR9+KB8
        Mn1YrqFFnczwhZXvMXrxNSQsfA==
X-Google-Smtp-Source: ABdhPJwuOTrl9CV5KOgJa7gOtxUuQMDtwaAPUEqH9sxYW38UFTjXcrHMs0X9p1BIGX0ZvtcWv66ZGA==
X-Received: by 2002:a17:906:8aa7:: with SMTP id mu39mr6081129ejc.298.1633093437608;
        Fri, 01 Oct 2021 06:03:57 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id p22sm2920279ejl.90.2021.10.01.06.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:03:57 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 00/10] bpf/tests: Extend eBPF JIT test suite
Date:   Fri,  1 Oct 2021 15:03:38 +0200
Message-Id: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds a number of new tests to the test_bpf.ko test suite.
The new tests focus on the behaviour of operations with different
combinations of register operands, and in particular, when two or more
register operands are in fact the same register. It also verifies things
like a src register not being zero-extended in-place in ALU32 operations,
and that operations implemented with function calls do not clobber any
other eBPF registers.

Johan Almbladh (10):
  bpf/tests: Add tests of BPF_LDX and BPF_STX with small sizes
  bpf/tests: Add zero-extension checks in BPF_ATOMIC tests
  bpf/tests: Add exhaustive tests of BPF_ATOMIC magnitudes
  bpf/tests: Add tests to check source register zero-extension
  bpf/tests: Add more tests for ALU and ATOMIC register clobbering
  bpf/tests: Minor restructuring of ALU tests
  bpf/tests: Add exhaustive tests of ALU register combinations
  bpf/tests: Add exhaustive tests of BPF_ATOMIC register combinations
  bpf/tests: Add test of ALU shifts with operand register aliasing
  bpf/tests: Add test of LDX_MEM with operand aliasing

 lib/test_bpf.c | 2803 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 2571 insertions(+), 232 deletions(-)

-- 
2.30.2

