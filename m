Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F8F3E4274
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbhHIJTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbhHIJTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:19:02 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7747AC0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 02:18:42 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b7so23568393edu.3
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 02:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2iLuig7hnPNCo1xvz7ikUqKL/k0jIgrQqZ82ub8BSsk=;
        b=yl/Mgq89zx7j/2AGO2xts4EqdU330mRhor87v6Hso/45vs8r6S8vblCBMJ3aCD6Z3a
         zdHTEIzejOAc/7O57J2ZFq8DmnwEzOXd8N3jj1L46tx2veQKOVVbd5Zi6/pXypkyRJJt
         tV3NvWWEYzJhA5y2LwdQelQs1e2ST3kLG52BmmNXHAXINoEvlLclPf4HC4iTKVIaBy9N
         xbIXaOVNvz2VhLUNpW8DOfm7kZ7Eo5RGuW8I6kepiWVvhZitxI6rJRY/NkGpPUlE1Iqn
         x7EvqO2hYQyIsWOPPnswoVUg89LqFWWjRbiqZ1ygKbXXiNImWhTqGfxu3NHRQJpG1sFi
         rqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2iLuig7hnPNCo1xvz7ikUqKL/k0jIgrQqZ82ub8BSsk=;
        b=du1S2wOt4z/KN4m7DL88xZpA8I0iKD2pmKz7g2KXjSzrcJ92u84isu/pOZZHHJvB0p
         NIp4v0UQebHg9+k9CbhilJjkINo+h5U2+FtpKUP1q5HFAoxlXwzQ7Kzsp36Kq9k1RIuV
         H8J3at5a7mHRMZztiK85UCykYFt1Y2XO2ygOyMRMSB5Yz23HKCDq9klq2uwcCk/wYBwr
         YJ2hjdM0Yh5H+I7OtSKgLW1RYZ+m3r5T6qtZdVylqgnZAQV82Bb0GWz3auyOauxZIwsy
         iOg7+h6xwI6YdM4QVzdo3lGyAg8O81GrFae0mm9Iw68J31LYKA5rxEi9QWOtwga9vFN6
         3rqQ==
X-Gm-Message-State: AOAM531qXg+L+Wp1W1dzoK5gkhYgO9yKTkSk+t3W02HFVN6GHORT8ne3
        cI/L3DS9byr1o99lwly+HQzi4Q==
X-Google-Smtp-Source: ABdhPJyM6417e1uu4vi72bVZQuJXJP3ufWjrrwlLo1pCORv6IE1WOQDbIjskMq7aJWKdroYX4pQ8Sw==
X-Received: by 2002:a05:6402:cb9:: with SMTP id cn25mr29185480edb.271.1628500721074;
        Mon, 09 Aug 2021 02:18:41 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id dg24sm1234250edb.6.2021.08.09.02.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 02:18:40 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 00/14] bpf/tests: Extend the eBPF test suite
Date:   Mon,  9 Aug 2021 11:18:15 +0200
Message-Id: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set extends the eBPF test suite in the test_bpf kernel module
to add more extensive tests of corner cases and new tests for operations
not previously covered.

Link: https://lore.kernel.org/bpf/20210728170502.351010-1-johan.almbladh@anyfinetworks.com/
Link: https://lore.kernel.org/bpf/20210726081738.1833704-1-johan.almbladh@anyfinetworks.com/

Changes since v1:
 * Fixed bad jump offset in JMP32 tests that would cause a test
   to pass in some cases when it should fail (1/14).
 * Added comment explaining the purpose of the register clobbering
   test case for ALU operations implemented with function calls (8/14).
 * Fixed bug in test case that would cause it to pass in some cases
   when it should fail (8/14).
 * Added comment explaining the branch conversion test (10/14).
 * Changed wording in commit message regarding 32-bit context
   argument, /should/will/ (11/14).
 * Removed unnecessary conditionals in tail call test setup (14/14).
 * Set offset to 0 when preparing tail call instructions (14/14).
 * Formatting fixes and cleanup in tail call suite (14/14).

Johan Almbladh (14):
  bpf/tests: Add BPF_JMP32 test cases
  bpf/tests: Add BPF_MOV tests for zero and sign extension
  bpf/tests: Fix typos in test case descriptions
  bpf/tests: Add more tests of ALU32 and ALU64 bitwise operations
  bpf/tests: Add more ALU32 tests for BPF_LSH/RSH/ARSH
  bpf/tests: Add more BPF_LSH/RSH/ARSH tests for ALU64
  bpf/tests: Add more ALU64 BPF_MUL tests
  bpf/tests: Add tests for ALU operations implemented with function
    calls
  bpf/tests: Add word-order tests for load/store of double words
  bpf/tests: Add branch conversion JIT test
  bpf/tests: Add test for 32-bit context pointer argument passing
  bpf/tests: Add tests for atomic operations
  bpf/tests: Add tests for BPF_CMPXCHG
  bpf/tests: Add tail call test suite

 lib/test_bpf.c | 2743 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 2484 insertions(+), 259 deletions(-)

-- 
2.25.1

