Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A352A572E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbgKCVgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730985AbgKCVeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:34:44 -0500
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83796C0613D1;
        Tue,  3 Nov 2020 13:34:44 -0800 (PST)
Received: by mail-qv1-xf43.google.com with SMTP id t20so8696323qvv.8;
        Tue, 03 Nov 2020 13:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=+PVHEUL2w6S2z1c91WgnV7bNX5j6G+8lqPCaD84HLqQ=;
        b=RIHuEjNdd+2vyjGo/DDGaiEOhRIEWTiEp/ykBGnutccTpifOvCkocvrB5U8mxLVRXb
         Q+oHtIoUOX+LMdxzPqrIAvoBhlQuA+47YCfmToQrHPdD2VVBVnBJ0o7YzgwvYUCEx/aN
         LYsot+2ftka7p/+GAiuj/XZ3+PzhwQWB6TIJj3oE4KPBoB3Z71ydNNoQUOj3/WiZYytp
         Mv6Rj6nrxvjjkHOmDcwgkvjZxNXNW0X9ZbyceCskpr9pyYE5pXPEu/GzG5wmbj/MVR/W
         /yZUG1W3bfnBPRji1eQPppsE5XG9/zXp+3Avw1YBOAq7uyZO+Eg5jGyYhdqH52AJVuh5
         B8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=+PVHEUL2w6S2z1c91WgnV7bNX5j6G+8lqPCaD84HLqQ=;
        b=TILrvyChsdQWhS1gLelUyGMMdtSzgLj38xo5d4l/CXcTQ/e3nr6DsDRMB1gCc0Uf0f
         XPJnMjXCOlXY8jMwPEISReo6/tGoA9xNOW+kIzIPWffOEiAsdhSht0yrau/iMhpq/q0A
         DMu76yWh6u6ZJ2wI1CVhDWq44P+ffZ/LO7bPFJEzq/8sGEtO5PNMWh5TKeGsFs2vPkZV
         WQIlrB1hpbO2aO6C6vK+dX+w8lwWkjeeVOEzAv+kv+9gByeTF9PDjncCWSytr1xn/vsy
         tjkx800E0Xdb3UjBq3mSgAc+gbr+iJ6ZA4KhwWc9mZZZ4NijqmqFx8i8ey+fJMV+PK/r
         tfTg==
X-Gm-Message-State: AOAM531FhtyFxL0I2WnrRYeQFIPWa5RTimZ1s/3apewTBRKHUn/JqADV
        9Uyr5EvQjRnskAWVmjovSTY=
X-Google-Smtp-Source: ABdhPJx1tUgGk5jltVPkblhvB1Qd8ijRlKP627n2CmOsRT//tlBK+Sc0PuPg6UelhWreGLEvUQ7Vuw==
X-Received: by 2002:a0c:b44a:: with SMTP id e10mr4060234qvf.4.1604439283650;
        Tue, 03 Nov 2020 13:34:43 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id n201sm16285qka.32.2020.11.03.13.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 13:34:42 -0800 (PST)
Subject: [bpf-next PATCH v3 0/5] selftests/bpf: Migrate test_tcpbpf_user to be
 a part of test_progs framework
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        andrii.nakryiko@gmail.com, alexanderduyck@fb.com
Date:   Tue, 03 Nov 2020 13:34:40 -0800
Message-ID: <160443914296.1086697.4231574770375103169.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
v3: Left err at -1 while we are performing send/recv calls w/ data
    Drop extra labels from test_tcpbpf_user in favor of keeping err label
    Dropped redundant zero init for tcpbpf_globals result and key
    Dropped replacing of "printf(" with "fprintf(stderr, "
    Fixed error in use of ASSERT_OK_PTR which was skipping of run_test
    Replaced "{ 0 }" with "{}" in init of global in test_tcpbpf_kern.c
    Added "Acked-by" from Martin KaiFai Lau and Andrii Nakryiko

---

Alexander Duyck (5):
      selftests/bpf: Move test_tcppbf_user into test_progs
      selftests/bpf: Drop python client/server in favor of threads
      selftests/bpf: Replace EXPECT_EQ with ASSERT_EQ and refactor verify_results
      selftests/bpf: Migrate tcpbpf_user.c to use BPF skeleton
      selftest/bpf: Use global variables instead of maps for test_tcpbpf_kern


 .../selftests/bpf/prog_tests/tcpbpf_user.c    | 226 +++++++++---------
 .../selftests/bpf/progs/test_tcpbpf_kern.c    |  86 +------
 tools/testing/selftests/bpf/tcp_client.py     |  50 ----
 tools/testing/selftests/bpf/tcp_server.py     |  80 -------
 tools/testing/selftests/bpf/test_tcpbpf.h     |   2 +
 5 files changed, 128 insertions(+), 316 deletions(-)
 delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
 delete mode 100755 tools/testing/selftests/bpf/tcp_server.py

--

