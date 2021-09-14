Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3060140AA8F
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 11:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhINJUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 05:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhINJUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 05:20:22 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE0EC061574
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 02:19:05 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id q3so18806805edt.5
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 02:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g4szUZHrnRLZn3KxdEXIj/VZsmSmPhHDadsukkjWnXg=;
        b=WpNAeokuQRKwzqb4UmTrEM8PumucT+On6A51iDSRt02sKFkVKQ2HXVv/oWob++wXpo
         euNKNaAcXd9CdgfOQlHTQRm3I6BcCLC4dc6ORPKerujqYOFTei8h6tkhthIn7GmbK+Fg
         0yzfYwRV20Y6Hx+89Ztfwm5L6QzHJS4y51JwyDXo9JQMd0Zmi36zlso6T6GIW/5jUnQ0
         G5UYfuiLCwiYuwhggmlrQrX7ZriRkqTQverpy8FMNGQHk8mjQVTl0dvoq2mjvRM2wAaz
         O6eLh9sv8LWx0KYtTSlwCYehaRdPAQddCPymmFAkW9p/An5jmYNJO1ZgxEvh8+YMItX0
         G40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g4szUZHrnRLZn3KxdEXIj/VZsmSmPhHDadsukkjWnXg=;
        b=ULLdlj9dobHSzcX/7316uAK47/2cZ7CRZY4HdTSEqiF1hUMyECUt76HyR84xMSaict
         OlmUUQiLlwiNJVyg5tKxDV381I6LoohcxMj2B6WZl4Q49MHvFv7XjAvOOF0jMWYTb5ZS
         LVWV7VMX3AqURxqSek3hM0QmHAvqIFpHbWtxwtYqWtdidE8HvG48YZlq7VBhIt4mTcPp
         0U29tBBVGIRfy4AEtZmcRyMLI6XU8LX3bjLwR5dn86yKYDYI7eiQD5iE4M+sSq1OfhlV
         R/8mLXW4d7xMd2tt9nrQj53r6E265aolkXc+jMMEvadO5cDPCwV3hznnWQL7gBV0uEU9
         rJOA==
X-Gm-Message-State: AOAM5318wIx1RaHSLnMCb6PABHv01S9b0BaZek9E1r2Z1HHGrar3piUj
        8GWT2K91zUL+loIHSm7LhzRnsEoW4sqZmhss
X-Google-Smtp-Source: ABdhPJylSSau2jdehto4rdbmFmuccEA2oxuR28/rIUaeEWgw5RHEO8wh2srMhxbnkPhmLPIcgL7BTg==
X-Received: by 2002:aa7:c2cb:: with SMTP id m11mr15399356edp.150.1631611143652;
        Tue, 14 Sep 2021 02:19:03 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id h10sm4615915ede.28.2021.09.14.02.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 02:19:03 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf v4 00/14] bpf/tests: Extend JIT test suite coverage
Date:   Tue, 14 Sep 2021 11:18:28 +0200
Message-Id: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds a number of new tests to the test_bpf.ko test suite.
It also corrects a faulty test case for tail call limits that failed
erronously on the x86-64 and i386 JITs. The tests are intended to verify
the correctness of eBPF JITs.

Changes since v3:
* New patch 13 to fix faulty test cases for tail call error paths (13/14).
* Fixed new tail call limit test accordingly (14/14).

Changes since v2:
* Fixed tail call test case to handle the case where a called function is
  outside the 32-bit range of the BPF immediate field. Such calls are
  now omitted in this test. (13/14)
* Fixed typo in commit message. (7/14)

Link: https://lore.kernel.org/bpf/20210909143303.811171-1-johan.almbladh@anyfinetworks.com/
Link: https://lore.kernel.org/bpf/20210907222339.4130924-1-johan.almbladh@anyfinetworks.com/
Link: https://lore.kernel.org/bpf/20210902185229.1840281-1-johan.almbladh@anyfinetworks.com/

Johan Almbladh (14):
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
  bpf/tests: Fix error in tail call limit tests
  bpf/tests: Add tail call limit test with external function call

 lib/test_bpf.c | 3406 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 3345 insertions(+), 61 deletions(-)

-- 
2.30.2

