Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E82A29DB71
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389318AbgJ1X4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389300AbgJ1X4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:56:02 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECA9C0613CF;
        Wed, 28 Oct 2020 16:56:00 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id z1so411058plo.12;
        Wed, 28 Oct 2020 16:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=1vsqD5bc2UZ7V9V3Htvf4zNSqM1ZDN3I7GuebF6ahpk=;
        b=YBdKz0If6Rp6U7D4dZ1u5sqhSnf2pj3KbeJcx1dqPgie73VtM5kBl0/ragDqIPElf2
         MXBiEG/onHZmK8+uo1Ik+TyXp8h2Q+w0OYeSr0ggw/CfadIN4j7fisjGvC+8hEAaiYz6
         A3kFqAl2qwk2ZY3DHsVjZXk1OGrWz9gLEH+hUZndEc1E2zt0WWl8kRLCBqXQiB8YW6sN
         yZDWMBGmIkspt/y9K9NDJlhiCQ02fw/sUa+dcrbOapAzLU6wq5SoOFBtZwxlryddO+hR
         kcQyD4IjXEJ+atzYspS0IVIhqfPYPVQAgYHVPA/+i0hNlDDVamorF3sP7ff716ibc838
         wxxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=1vsqD5bc2UZ7V9V3Htvf4zNSqM1ZDN3I7GuebF6ahpk=;
        b=ngsYd9M71iUrZeHf/j9+yyuu/wWwR9hqn7UyolHWHLzxb5uEQSRQCiUcY/XMto2Aps
         l77aKUOMSDezSamrGgfeLxjpTkWVoViWS2sIL2iVqjKvBmfBDbvDJe11TUVRmepkhoEs
         7RhN54NLqOMNDre7DMKRB+KWwYv+Boo9sADmYZKr49eFVizrSKDKxuXJHwDqROt1h46L
         3SWuG2qNOyyrl3Z9oNO/41eoDFw4T5aEe9knOnl8w4SA8BdY70uq9/8UtMQmZ2Jp4MVh
         Kul9uNFSSug4iEaze1m5qRR0WT8Yx5j0h4tTS2DWBRFUXfhbr+b+Oxc22T3lFDq3xMXt
         ETwg==
X-Gm-Message-State: AOAM532c9AV4NMgM5RE4BsZlknwQeXVzm7w+RpL+l1PxVhijMAEqDcf8
        VNSmk0IxUuKL0KAC42YNDiyJGT83RuK4mw==
X-Google-Smtp-Source: ABdhPJzmnwSnBXDSjArFTW90GtCBqMU1O5FvNYIZzDoNZbUnNXe9WQ0xATwNoKuA8taxfTH1xt9aZA==
X-Received: by 2002:a0c:b587:: with SMTP id g7mr1205162qve.37.1603849620496;
        Tue, 27 Oct 2020 18:47:00 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id v204sm2098870qka.4.2020.10.27.18.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 18:46:59 -0700 (PDT)
Subject: [bpf-next PATCH 0/4] selftests/bpf: Migrate test_tcpbpf_user to be a
 part of test_progs framework
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        alexanderduyck@fb.com
Date:   Tue, 27 Oct 2020 18:46:58 -0700
Message-ID: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the test functionality from test_tcpbpf_user into the test_progs
framework so that it will be run any time the test_progs framework is run.
This will help to prevent future test escapes as the individual tests,
such as test_tcpbpf_user, are less likely to be run by developers and CI
tests.

As a part of moving it over the series goes through and updates the code
to make use of the existing APIs included in the test_progs framework. 
This is meant to simplify and streamline the test code and avoid
duplication of effort.

---

Alexander Duyck (4):
      selftests/bpf: Move test_tcppbf_user into test_progs
      selftests/bpf: Drop python client/server in favor of threads
      selftests/bpf: Replace EXPECT_EQ with ASSERT_EQ and refactor verify_results
      selftests/bpf: Migrate tcpbpf_user.c to use BPF skeleton


 .../selftests/bpf/prog_tests/tcpbpf_user.c    | 260 +++++++++++-------
 tools/testing/selftests/bpf/tcp_client.py     |  50 ----
 tools/testing/selftests/bpf/tcp_server.py     |  80 ------
 3 files changed, 158 insertions(+), 232 deletions(-)
 delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
 delete mode 100755 tools/testing/selftests/bpf/tcp_server.py

--

