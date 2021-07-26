Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825CE3D5545
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhGZHiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 03:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbhGZHiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:38:00 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAB6C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:29 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id da26so9471276edb.1
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pw8O2SexVmj1oy+pXNKPW9g3Q6JL7loQc3LgajuYwfQ=;
        b=mgel/MKNBLUiEQymk3PCln9n51XavCwkcB7dNX40Gxjt/QFL7K9g90ljSZHasXP51c
         eN4SPn2AnhYha3ZE/UT7FNmu01QvnRM/jC7TVogxs5eQSWOYdx3o5RTxYfqm6/6Ekx26
         UosbE2P9UkGzdPn+0PKcGIjgFUt5QmsZ4sF2Pvxi1URuaPhKDNERV2C/h5VqVCIDb0Rw
         jo9ws7DpuU6x6RAIDjiMQ0bpl4hTpzd3bCypyW0FK7Ebl3zzorEm0GE/pFAgABZ7HdyX
         Rjm9Z5mb76agzwR0/qkPVsQAqB/zq5V91iiGUODFGEAoIoZNS17N0SauHbQVtBpncmWY
         fjjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pw8O2SexVmj1oy+pXNKPW9g3Q6JL7loQc3LgajuYwfQ=;
        b=p0g80ScVOSDqqer8vKwiwC9cWwMSQi6c+x0vQlHmSlSDFDUzgZIYIkLFfwiVLeiH/S
         W5Tu0hLPjjqKctX6vxUFUHLeKGrOib61wrJjBOJFzGCDUJJjDJ8/iklhS9UTdem7pkaN
         T4f+F1Zb2xM8hFH6p2aPTZDyhI0hdo60L1mxt7wuv4RW9Ol7foBYGVniXzIB7s+5fgig
         o/3HStj5BNan5dwau1o/LbMMoaWt29fQsLEiAIz2EHMgvinHYLl3xWfuV01/c6FZtxY0
         OgFJPYI5YdhEzqJ00CtBq88VPLDUiMZ2lT3ZwyIMDE/ch4nZSFueTNt2+f+vbIgV94Mk
         IjYw==
X-Gm-Message-State: AOAM533SWBE6GugMuJzhO4mQtRHhUu83/8AOPcdBvqxr+g3Fwsm6BLLF
        +m5F7bnr5qCUmn3Xxrs6AN7q/Q==
X-Google-Smtp-Source: ABdhPJyTeWxBkuZ8Y0SP0X4gnCZ4bYKgSfQexFE7ZqHLrmApBgQheiLiIWdCQbMrqh8r9BkB0KMJGw==
X-Received: by 2002:a05:6402:51c7:: with SMTP id r7mr20820640edd.150.1627287508447;
        Mon, 26 Jul 2021 01:18:28 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id q9sm13937539ejf.70.2021.07.26.01.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 01:18:28 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [RFC PATCH 00/14] bpf/tests: Extend the eBPF test suite
Date:   Mon, 26 Jul 2021 10:17:24 +0200
Message-Id: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

During my work with the 32-bit MIPS JIT implementation I also added a
number of new test cases in the test_bpf kernel module. I found it
valuable to be able to throughly test the JIT on a low level with
minimum dependency on user space tooling. If you think it would be useful,
I have prepared a patch set with my additions. I have verified it on
x86_64 and i386, with/without JIT and JIT hardening. The interpreter
passes all tests. The JITs do too, with one exception, see NOTE below.
The result for the x86_64 JIT is summarized below.

    test_bpf: Summary: 577 PASSED, 0 FAILED, [565/565 JIT'ed]
    test_bpf: test_tail_calls: Summary: 6 PASSED, 1 FAILED, [7/7 JIT'ed]

I have inserted the new tests in the location where related tests are run,
rather than putting them at the end. I have also tried to use the same
description style as the surrounding tests. Below is a summary of the
new tests.

* Operations not previously covered
  JMP32, ALU32 ARSH, remaining ATOMIC operations including
  XCHG and CMPXCHG.

* ALU operations with edge cases
  32-bit JITs implement ALU64 operations with two 32-bit registers per
  operand. Even "trivial" operations like bit shifts are non-trivial to
  implement. Test different input values that may trigger different JIT
  code paths. JITs may also implement BPF_K operations differently
  depending on if the immediate fits the corresponding field width of the
  native CPU instruction or not, so test that too.

* Word order in load/store
  The word order should follow endianness. Test that DW load/store
  operations result in the expected word order in memory.

* 32-bit eBPF argument zero extension
  On a 32-bit JIT the eBPF argument is a 32-bit pointer. If passed in
  a CPU register only one register in the mapped pair contains valid
  data. Verify that value is properly zero-extended.

* Long conditional jumps
  Test to trigger the relative-to-absolute branch conversion in MIPS JITs,
  when the PC-relative offset overflows the field width of the MIPS branch
  instruction.

* Tail calls
  A new test suite to test tail calls. Also test error paths and TCC
  limit.

NOTE: There is a minor discrepancy between the interpreter and the
(x86) JITs. With MAX_TAIL_CALL_CNT = 32, the interpreter seems to allow
up to 33 tail calls, whereas the JITs stop at 32. This causes the max TCC
test to fail for the JITs, since I used the interpreter as reference.
Either we change the interpreter behavior, change the JITs, or relax the
test to allow both behaviors.

Let me know what you think.

Cheers,
Johan

Johan Almbladh (14):
  bpf/tests: add BPF_JMP32 test cases
  bpf/tests: add BPF_MOV tests for zero and sign extension
  bpf/tests: fix typos in test case descriptions
  bpf/tests: add more tests of ALU32 and ALU64 bitwise operations
  bpf/tests: add more ALU32 tests for BPF_LSH/RSH/ARSH
  bpf/tests: add more BPF_LSH/RSH/ARSH tests for ALU64
  bpf/tests: add more ALU64 BPF_MUL tests
  bpf/tests: add tests for ALU operations implemented with function
    calls
  bpf/tests: add word-order tests for load/store of double words
  bpf/tests: add branch conversion JIT test
  bpf/tests: add test for 32-bit context pointer argument passing
  bpf/tests: add tests for atomic operations
  bpf/tests: add tests for BPF_CMPXCHG
  bpf/tests: add tail call test suite

 lib/test_bpf.c | 2732 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 2475 insertions(+), 257 deletions(-)

-- 
2.25.1

