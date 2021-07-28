Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B903D93CE
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 19:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhG1RFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 13:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhG1RFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 13:05:33 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D31C061764
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 10:05:30 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id y12so4196536edo.6
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 10:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s+QqHPqZggMQaZGKXR2VVFIndf9VN9KG+RGnz6ho2Zs=;
        b=IfqZ0fKOwbjtCaAKErL/a/NWfXsCE6WWzRUnT3JHGuY92UKiPJW/tuFKcHIZvY3q9t
         AOduDpxxGj0Hn0XjZv91l8tN8B7ps2KihkloNvVYC4qZ8aMqBFUICABNdAxSrw7BGPWL
         r5sAaJXClEoHSCjS8aMAMOsbttYOrDIX5reQG9PG0cF/s2/TYPuiFw10q8kLl624O0hv
         oipE9EDCKB4DgCvGdFblDnzT7PPder+3kx+oCO7SiH/gfakrw/UqMk02YPtwLSRfWb66
         JQivaKIP0dmInAOXtA5sigkUk/b9P8OYeUNQje9a5WwiLtFauDw8Z2QB+Ss8OGeABmKv
         IDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s+QqHPqZggMQaZGKXR2VVFIndf9VN9KG+RGnz6ho2Zs=;
        b=lcVOpAAkcThSxh5nbx7E9s0krsXL2KezGVhB2esJwmKBEY/zGN9NR6f6G4ZNWjonbN
         ujlONiq85x6fspkH21EZrkIAV6smOHgH16Z3ghuwGjfG3BXEv/OZFOpbI70sAabQBjPf
         TyTFgVYZD6gm1QSpkDI/W0+iGYqLIgV1mCqxTuY9b89FH4IPrFa4KXoDHX9xJ+WOINN8
         o20N9PSzVO77JO7QG+/oie8nY6SH//CygBAXcZOgMEmCh850YbkUOz768eBWnm1v5al2
         DHXLZQJC2Y7PUV0mkqAzTvhPdJvczZIhuhY7nwQgIrNi9CzEWNs7zyjPDtHUI3cBTMQQ
         zX3A==
X-Gm-Message-State: AOAM531zovNgvN9n22POdLT7pCXJY0vXl+rVcULgXuFgo/Ew+g0ZrIOR
        jaXtu0f/SDLCr0VpJrQvh1md+g==
X-Google-Smtp-Source: ABdhPJwrva6ykDLoKT/MV9lp2Sk8XHsyEzd7ViryzPMBebNhaLGegKjgH7gJ8Iel/7GXv6NtLJ154A==
X-Received: by 2002:a05:6402:4248:: with SMTP id g8mr992591edb.302.1627491929070;
        Wed, 28 Jul 2021 10:05:29 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bd24sm139349edb.56.2021.07.28.10.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 10:05:28 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH 00/14] bpf/tests: Extend the eBPF test suite
Date:   Wed, 28 Jul 2021 19:04:48 +0200
Message-Id: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set extends the eBPF test suite in the test_bpf kernel module
to add more extensive tests of corner cases and new tests for operations
not previously covered.

An RFC patch set was previously submitted.

Link: https://lore.kernel.org/bpf/20210726081738.1833704-1-johan.almbladh@anyfinetworks.com/

Changes from RFC patch set:

* Changed tail call count limit test to comply with the new behavior of
  the interpreter, i.e. at most MAX_TAIL_CALL_CNT tail calls are
  permitted.

* Fixed an uninitilized variable in tail call test error path, found by
  the Kernel test robot. Also fixed a warning due to pointer-to-u32 cast
  in IMM64 load instructions.

The checkpatch.pl script reports an error for the multi-line macro in
patch 14/14 ("bpf/tests: Add tail call test suite"). However, it cannot
be enclosed in parenthesis as suggested since it is an array element
initialization, similar the existing BPF_LD_IMM64() helper macro. It can
be replaced, but I do think the code and the intent is clearer this way.

Thanks,
Johan

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

 lib/test_bpf.c | 2732 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 2475 insertions(+), 257 deletions(-)

-- 
2.25.1

