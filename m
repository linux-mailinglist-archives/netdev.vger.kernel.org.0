Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0A640596F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348120AbhIIOqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344558AbhIIOqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:46:00 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19EAC05BD20
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 07:33:14 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a25so4037499ejv.6
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 07:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jlYtNVI6TuHDqTfFXy2pYNiOsiXmR1EZWOxg8MEom7w=;
        b=hM7CWgJpKcQ4qgOW/wf88DKoNAAnaAbf/YCiU37BsmVNbuQaTsE9ZNqSw7F4V1wQr1
         9PLvjH/be6agqv7v2emics/emY6swH1QVzGgESWhJ7WWGzAhpJsz+dK0Uejoqyjvh0bV
         cVmVmhTJ164S4NcbYQ9KRjg0zXd/v5xcnM9OwZ7M56OP7nK7rjeZGSAycByAD96hXkd9
         WlM3agB1IQMjPbEDwu8J7nv3121vNRnH1+6UXUe45ZStlL5ksrOAsTwig6lCDzTdMCkT
         6zWkECuZHsg3cvOjIE759hLb0deDyZsEFptdk4iJl6JJXXmnnr9r7gLybeFExM+wtDzJ
         B+Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jlYtNVI6TuHDqTfFXy2pYNiOsiXmR1EZWOxg8MEom7w=;
        b=I36JWkOqEXfWZ56R2s7S2V//+cpu7uc2iUXPt1ZOyFLbW4IlfTcSisc7IoqdO/4cA8
         ftgd/sEVeE+hNVCNMVLEjZHo5jJ6cY0t/bvKxJYOZntFsT+1gL+7fgKyRLBz2vToPX0M
         8y0WOsaw6fQZ74AbdZAk+eBhxrn8/2sB0l8LKEa8nyDNIm2ONY1h7rJLDWem/cDdjKqX
         zaxnHHo0ukN9ictVWtaktv79CboMmuhsoPUSsSJn9OMaEUaPv/wuSdfJz6Nk8+AwVGCq
         5I8+Ui9gW4ReOHXEcPKe86QRC3Ab3eYic+Zs0/J3O04tbrjcgMum4N4TOoLKKWmBUGsk
         pI+g==
X-Gm-Message-State: AOAM5329JH7dJG82o4MLkTMzW/aN5lmF6oNrz2Ww6t+88ca9Rzh500nl
        9j8uuc1kGuqujO6ZuGF60bw9zQ==
X-Google-Smtp-Source: ABdhPJwV54VCR3d0LHqic66zeutbSRGlxcMZexvBX4tLlvLXh8Yxp+2rhF9UDged46fV4OqryBmdJw==
X-Received: by 2002:a17:906:c0cd:: with SMTP id bn13mr3767773ejb.251.1631197993316;
        Thu, 09 Sep 2021 07:33:13 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bj10sm1030909ejb.17.2021.09.09.07.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 07:33:12 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v3 00/13] bpf/tests: Extend JIT test suite coverage
Date:   Thu,  9 Sep 2021 16:32:50 +0200
Message-Id: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds a number of new tests to the test_bpf.ko test suite.
The tests are intended to verify the correctness of eBPF JITs.

Changes since v2:
* Fixed tail call test case to handle the case where a called function is
  outside the 32-bit range of the BPF immediate field. Such calls are
  now omitted in this test. (13/13)
* Fixed typo in commit message. (7/13)

Link: https://lore.kernel.org/bpf/20210907222339.4130924-1-johan.almbladh@anyfinetworks.com/
Link: https://lore.kernel.org/bpf/20210902185229.1840281-1-johan.almbladh@anyfinetworks.com/

Johan Almbladh (13):
  bpf/tests: Allow different number of runs per test case
  bpf/tests: Reduce memory footprint of test suite
  bpf/tests: Add exhaustive tests of ALU shift values
  bpf/tests: Add exhaustive tests of ALU operand magnitudes
  bpf/tests: Add exhaustive tests of JMP operand magnitudes
  bpf/tests: Add staggered JMP and JMP32 tests
  bpf/tests: Add exhaustive test of LD_IMM64 immediate magnitudes
  bpf/tests: Add test case flag for verifier zero-extension
  bpf/tests: Add JMP tests with small offsets
  bpf/tests: Add JMP tests with degenerate conditional
  bpf/tests: Expand branch conversion JIT test
  bpf/tests: Add more BPF_END byte order conversion tests
  bpf/tests: Add tail call limit test with external function call

 lib/test_bpf.c | 3348 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 3306 insertions(+), 42 deletions(-)

-- 
2.30.2

