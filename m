Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA651C6247
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgEEUtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726593AbgEEUtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:49:51 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C44C061A0F;
        Tue,  5 May 2020 13:49:51 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id e8so3629973ilm.7;
        Tue, 05 May 2020 13:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=HAORnzATD1/hyMslg+Z7QSjVRzupkIXfkl6KlowFBD0=;
        b=tmBKsEoTqnB3rIZ6Zp1Gj+ae3EMWsWP2jSvRNeA05mGXfOFU7Sy8FHSa4Tw+2E72sS
         GUfZFp0758upHsTVimh+Vz9iGPJwps7Ipb/IyGR3JUyxsHLBZxulpthG00ps82VoD9Qt
         9cyE3HW0ldx1s6fvt9hNbxM9l3YDoakg2sxQZ27bbZ/Y6CWnYS9h76x9xUbsaXTIv7/p
         8ZXSPp/dFd14J1Aa8Q5tm4UCgcLNLoWtsmpMBJQRyTSHdq/hw3dD02qEz3yy4OPNXKVL
         ROabrjgwW/Dg2kVqqe70jhZcYt+iUGskhlsC9Jz4jdCUSXtT0JF18KDaAW10G2AMk8/P
         wjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=HAORnzATD1/hyMslg+Z7QSjVRzupkIXfkl6KlowFBD0=;
        b=H9cJ622gOqbikQOUSYbspEBBehKFoMYxJkIxInxhged/cBkHQWCrjtHVj4FHi4di9c
         HIQaRs4bTcePPYGnwCdq83eh+c0mMTLZeLaSJ9NG/QgiAkGu3DrAxBPeb/RVftA8jHaG
         Xz2H7AE+kYs7RwDdd7T01GXoBqDrkrhyooHZlSb+fHWfKAV7Pua0kudnMQ6Uic0ggDng
         LUikp1Ct+boJmwWcG9BkO+WF5+Us+yHESi9JrT/eXz5fWnitPYBbdeDUSM28Y5RnKyqv
         9PFASGQyRhvXtrh1JGgn58j4+ruDVMN1sTvraCqr9jfSb7PxO0mfGCDt6+iOAN4P6Ltx
         XQeA==
X-Gm-Message-State: AGi0PuaBi/yTG56L1uUKqhGDucCaZYtiLJGhfk7HcA8BI0ufxKKe+0kC
        0evBy+cPV1g9tv81H8V6Hk0=
X-Google-Smtp-Source: APiQypLIo3pMrFv4Bq7vvXDk1cdFUSi13fd51N2vq9v/9LvGRMIZ1PVPv2V8zf0KUhMUsvqISWPocg==
X-Received: by 2002:a92:4014:: with SMTP id n20mr5667607ila.249.1588711790494;
        Tue, 05 May 2020 13:49:50 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u17sm2354609ilb.86.2020.05.05.13.49.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 13:49:49 -0700 (PDT)
Subject: [bpf-next PATCH 00/10] bpf: selftests, test_sockmap improvements
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Tue, 05 May 2020 13:49:36 -0700
Message-ID: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update test_sockmap to add ktls tests and in the process make output
easier to understand and reduce overall runtime significantly. Before
this series test_sockmap did a poor job of tracking sent bytes causing
the recv thread to wait for a timeout even though all expected bytes
had been received. Doing this many times causes significant delays.
Further, we did many redundant tests because the send/recv test we used
was not specific to the parameters we were testing. For example testing
a failure case that always fails many times with different send sizes
is mostly useless. If the test condition catches 10B in the kernel code
testing 100B, 1kB, 4kB, and so on is just noise.

The main motivation for this is to add ktls tests, the last patch. Until
now I have been running these locally but we haven't had them checked in
to selftests. And finally I'm hoping to get these pushed into the libbpf
test infrastructure so we can get more testing. For that to work we need
ability to white and blacklist tests based on kernel features so we add
that here as well.

The new output looks like this broken into test groups with subtest
counters,

 $ time sudo ./test_sockmap
 # 1/ 6  sockmap:txmsg test passthrough:OK
 # 2/ 6  sockmap:txmsg test redirect:OK
 ...
 #22/ 1 sockhash:txmsg test push/pop data:OK
 Pass: 22 Fail: 0

 real    0m9.790s
 user    0m0.093s
 sys     0m7.318s

The old output printed individual subtest and was rather noisy

 $ time sudo ./test_sockmap
 [TEST 0]: (1, 1, 1, sendmsg, pass,): PASS
 ...
 [TEST 823]: (16, 1, 100, sendpage, ... ,pop (1599,1609),): PASS
 Summary: 824 PASSED 0 FAILED 

 real    0m56.761s
 user    0m0.455s
 sys     0m31.757s

So we are able to reduce time from ~56s to ~10s. To recover older more
verbose output simply run with --verbose option. To whitelist and
blacklist tests use the new --whitelist and --blacklist flags added. For
example to run cork sockhash tests but only ones that don't have a receive
hang (used to test negative cases) we could do,

 $ ./test_sockmap --whitelist="cork" --blacklist="sockmap,hang"

---

John Fastabend (10):
      bpf: selftests, move sockmap bpf prog header into progs
      bpf: selftests, remove prints from sockmap tests
      bpf: selftests, sockmap test prog run without setting cgroup
      bpf: selftests, print error in test_sockmap error cases
      bpf: selftests, improve test_sockmap total bytes counter
      bpf: selftests, break down test_sockmap into subtests
      bpf: selftests, provide verbose option for selftests execution
      bpf: selftests, add whitelist option to test_sockmap
      bpf: selftests, add blacklist to test_sockmap
      bpf: selftests, add ktls tests to test_sockmap


 .../selftests/bpf/progs/test_sockmap_kern.h        |  299 +++++++
 tools/testing/selftests/bpf/test_sockmap.c         |  911 ++++++++++----------
 tools/testing/selftests/bpf/test_sockmap_kern.h    |  451 ----------
 3 files changed, 769 insertions(+), 892 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_kern.h
 delete mode 100644 tools/testing/selftests/bpf/test_sockmap_kern.h

--
Signature
