Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FDD2A1995
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgJaSbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727967AbgJaSbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 14:31:17 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EABC0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 11:31:17 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b12so4640461plr.4
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 11:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=vaeJ0RKy5Qs9c7TWIrAwHROLabv4QsvhsnBOhDq3MAc=;
        b=HrmD4yuMpjGTNW0BgXBxPKuUAFMKB3qsS5es9mC5h6JiW4wIQ0cuAJw82yu1Y/VoFm
         PkvwTWBgyI0KqSTCt+je9RfJIwdHojAVMqNzjn6rX5omydbnm2W2jG8LAm3M1Qs/C9qn
         vsY9xnH68238nZfeGfO/zZk460Zgf03YOzGMKjrL1PQ0cRVN+bN9LRNfH+FREyklaIYm
         ZcjT+MOKgaCqbaVpRXW8SPPmndmHCWF+x4sdwmQiQydlcFl14p17CmskWmMyG4HNaYcB
         xQseHSxSq6dpZlU6IvzUQC9HDea4KNral7R6gSWjOqaa82wG5IrZcwBPOcvCwtKjhqA5
         LkpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=vaeJ0RKy5Qs9c7TWIrAwHROLabv4QsvhsnBOhDq3MAc=;
        b=OEmEstFhvsddebWWkpWBKczjj2lVfGbt/TFEWtfLs+13CdRSqR+lTI+ZfEEl1AbPHz
         QJKElKQT1cguDlJ9uySAvYsOwKL35vQlbjVgnBRRkfXSHt51yhYUZ8zaLPxMdJ0ZWQsi
         hIBwOanLdmihKRf6y9RJuLxy4/BNNc/ROtHnCDuDv0MjVh5eD/dSm/u0yl+68CsTVw6A
         S7v8Gjt0TQLanKkocR1gLr5ZB/+KSLaqHnlNiS3ys3E+G3kRhNUnXkFqDxvG++JqsG/Q
         tt+Q4O1G0oxFa5PI66EQjbcRoEgVfSu9ay8UoOPXfj1gCkNMZ8dbkzQD98ckLGeARso0
         5WWQ==
X-Gm-Message-State: AOAM533nPRXgqzXCsrb52367nTU7HXOkeetxu7iJqj6XViuXKKi9yNNB
        CWPSRaQXJOyrXLjxaIV8Q2EoQqv/8898zA==
X-Google-Smtp-Source: ABdhPJwheaNTrU7dHYGwCS7aWHe8VuIytTAq74xAvFLa0FC6w0u894dPXqA0n3j6WxiRRz3ErjFRtg==
X-Received: by 2002:a17:90a:dc82:: with SMTP id j2mr9480932pjv.68.1604169075511;
        Sat, 31 Oct 2020 11:31:15 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id t11sm6913578pjs.8.2020.10.31.11.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:31:14 -0700 (PDT)
Subject: [bpf-next PATCH v2 0/5] selftests/bpf: Migrate test_tcpbpf_user to be
 a part of test_progs framework
From:   Alexander Duyck <alexander.duyck@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        andrii.nakryiko@gmail.com, alexanderduyck@fb.com
Date:   Sat, 31 Oct 2020 11:31:14 -0700
Message-ID: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the test functionality from test_tcpbpf_user into the test_progs
framework so that it will be run any time the test_progs framework is run.
This will help to prevent future test escapes as the individual tests, such
as test_tcpbpf_user, are less likely to be run by developers and CI
tests.

As a part of moving it over the series goes through and updates the code to
make use of the existing APIs included in the test_progs framework. This is
meant to simplify and streamline the test code and avoid duplication of
effort.

v2: Dropped test_tcpbpf_user from .gitignore
    Replaced CHECK_FAIL calls with CHECK calls
    Minimized changes in patch 1 when moving the file
    Updated stg mail command line to display renames in submission
    Added shutdown logic to end of run_test function to guarantee close
    Added patch that replaces the two maps with use of global variables    

---

Alexander Duyck (5):
      selftests/bpf: Move test_tcppbf_user into test_progs
      selftests/bpf: Drop python client/server in favor of threads
      selftests/bpf: Replace EXPECT_EQ with ASSERT_EQ and refactor verify_results
      selftests/bpf: Migrate tcpbpf_user.c to use BPF skeleton
      selftest/bpf: Use global variables instead of maps for test_tcpbpf_kern


 .../selftests/bpf/prog_tests/tcpbpf_user.c    | 239 +++++++++---------
 .../selftests/bpf/progs/test_tcpbpf_kern.c    |  86 +------
 tools/testing/selftests/bpf/tcp_client.py     |  50 ----
 tools/testing/selftests/bpf/tcp_server.py     |  80 ------
 tools/testing/selftests/bpf/test_tcpbpf.h     |   2 +
 5 files changed, 135 insertions(+), 322 deletions(-)
 delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
 delete mode 100755 tools/testing/selftests/bpf/tcp_server.py

--

