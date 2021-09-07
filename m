Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287614030E2
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348183AbhIGWZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 18:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241562AbhIGWY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 18:24:57 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E01C061757
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 15:23:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z19so50040edi.9
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iSAVXuQHVYqkBfCzECbIyafToN/+xfGCAmaG2XA6/Jc=;
        b=x9YlaDHS3ZJ+/8geUZQAIDQ3CVZDTIsbZgbaSRQAzcUlD+jFmrQ2ENv1IO8DrrOALy
         mm+PYCCl/Hgj6tdtcS9HhAP1kXbsz4VjbDdZzf62uSwvkGx91zmJXwLsYCv0eqHtiy89
         S/8d2in9m9y4xSP6NkCU+ztTfAUrqhvljyp7Mdm+jD1bQN9ic4uCmp1J5Ak3WbEZjKlU
         3zX4F8bqrgMxP16Qnb9JwFIlwSdadDUkgvuXd5g/5XJUIAukNvrkzBccGYUwa1a+LmiN
         OzIjJBGNEMpsDm/FGyQwVEBlMbJ8Wa/6dQM9hWnQi15Uz6dg7uUi1q4S+vqagz9R/4UC
         JJ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iSAVXuQHVYqkBfCzECbIyafToN/+xfGCAmaG2XA6/Jc=;
        b=omGU/I9D9SgdSlU4Wy5e9/cajBhdrhAW3//takMoEiqw+aerCa7s3L5WP1laNwFTBo
         gl7qzR2nIkVf44jE2uhKzQ6Q5Es/9p4RyIXzTp4FDcpwgAqjII8CxhyRn3tYSnmNH2ZP
         2vVfvaoD9XY2vrtxPqT14J5Nm43pIhf5aPgqqphVM71LkibGfI2Ydf1KIuqx+jvKO8pC
         dZM/0TYUnVDB7xDaRbjAT5hJ4oeQE6H0nAvb2IJ/WNKmrIksT9mZdjdEWt5tjK299FS5
         9swSFwxbt6vjRCwKMFBrcySo/OnaUxRroJ01RsETgpS71eedr+OPGOz86mjr2SxSJEhO
         R8RQ==
X-Gm-Message-State: AOAM531j4417itTDjnJ78F0fgJWNDg3SsZHoRTrC1novo1TKXe2dlYn3
        KM9MYiJKf0LA9CfZ/dFBI7DuvA==
X-Google-Smtp-Source: ABdhPJySKnc7m7Nf8TU4fjrsZwxbCMv1kIl0E/jlTFjRQdt2EGRC+2UncbYh/QBkqg9WnWZzANdF2Q==
X-Received: by 2002:a05:6402:1cbb:: with SMTP id cz27mr523878edb.334.1631053429007;
        Tue, 07 Sep 2021 15:23:49 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id gb24sm71772ejc.53.2021.09.07.15.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 15:23:48 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 00/13] bpf/tests: Extend JIT test suite coverage
Date:   Wed,  8 Sep 2021 00:23:26 +0200
Message-Id: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds a number of new tests to the test_bpf.ko test suite.
The tests are intended to verify the correctness of eBPF JITs.

Changes since v1:
* Fixed ASCII diagram of staggered jump test pattern (6/13).
* Fixed R0 initialization issue found by kbuild CI. Add comment on
  diagnostics/debugging instead of setting R0 to the current
  instruction index (3,4,7/13).

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

 lib/test_bpf.c | 3316 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 3274 insertions(+), 42 deletions(-)

-- 
2.25.1

