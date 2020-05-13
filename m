Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8886C1D1EAE
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390527AbgEMTM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390303AbgEMTMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:12:25 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280AFC061A0C;
        Wed, 13 May 2020 12:12:25 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id 79so323055iou.2;
        Wed, 13 May 2020 12:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=F4i0Z8PHrlNI/GYRpSkh4NjTTQDBam11j0I9Vsu5IkQ=;
        b=LaesHTemoNB9gN/8/z0dRJmz/1WUbCGQq7L8tVovYx/KfFKjZJZ7E8d2WJBsgok9sM
         Ro+ZRzqft/GggkFln+36ssN/piZftUAxK9qXBHYIqhEI8YXH4v3ustYKfNkzn//C4wBb
         +tlO8ZVg6WbGJOrPa6ERvziNnna1Ev9RIWogR+oTLBapn1MA4GXJ4qG2lpxmvY92KkeE
         DPtPnSBI4m77MuFllfz78WTi9uqgajHG2s9crWyc3vI+RRC0ZZFv6Wz7Sh7CJs++bpHm
         BwrXzDDQnpD4lnbc52GTRQfXJSLdxJKzahdHp3hgkMRj27T+TzubZG4BxCe0LJTORXra
         KwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=F4i0Z8PHrlNI/GYRpSkh4NjTTQDBam11j0I9Vsu5IkQ=;
        b=S4bAGYtiy0lPGD3zz+EpSx4fudx1TVYKrzwLsdnVoreWC9IeQ6ENnBzrcXVk+s7+HR
         KLoXclt3Uu9h4Ij2dc6kCRxo2e1zwiWT3EheAsmSeE5dnYonUh021+5K8hDN1xutd9Zb
         /6vRW4gpZB1MrXX3Y18WqcSYZplZh5aH12vZ8cjCTEy9kSJ5GFy03uibjWvJ2kOlXMVa
         W+f6Cslp/GpKYDx6dH/xG+ltrUhUSHiUOUjKFJcfqNK1fMQ64bvygxzetWfqgSHYQjF2
         S1LN+TqTIPBFj583S9/gQPRROcft6wOff91GoaAnBfVnHnVEM5G9T/oFdia3W2xBEtzp
         CWYA==
X-Gm-Message-State: AOAM531ZBYQlHniWZvr+cj2vD2fzdn5OGK25B4Nt92NNhiSbyQtrlDiH
        qqf2EUDK1H0RtPuhrlQtnX8=
X-Google-Smtp-Source: ABdhPJxS79N9GFSctCl32COYlHRhh5FhqTcMMpRdylHfMzzBPG0/Qk323/bz/DFom9c86G6yOEl1Ig==
X-Received: by 2002:a6b:f005:: with SMTP id w5mr724713ioc.76.1589397144466;
        Wed, 13 May 2020 12:12:24 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 17sm158099ill.14.2020.05.13.12.12.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:12:23 -0700 (PDT)
Subject: [bpf-next PATCH v2 00/12] bpf: selftests, test_sockmap improvements
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Wed, 13 May 2020 12:12:09 -0700
Message-ID: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Note: requires fixes listed below to be merged into bpf-next before
      applied.

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

Requires these two fixes from net tree,

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=3e104c23816220919ea1b3fd93fabe363c67c484
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=81aabbb9fb7b4b1efd073b62f0505d3adad442f3

v1->v2: Addressed Jakub's comments, exit to _exit and strerror typo.
        Added Jakubs Reviewed-by tag, Thanks!

---

John Fastabend (12):
      bpf: sockmap, msg_pop_data can incorrecty set an sge length
      bpf: sockmap, bpf_tcp_ingress needs to subtract bytes from sg.size
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
 tools/testing/selftests/bpf/test_sockmap.c         |  913 ++++++++++----------
 tools/testing/selftests/bpf/test_sockmap_kern.h    |  451 ----------
 3 files changed, 770 insertions(+), 893 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_kern.h
 delete mode 100644 tools/testing/selftests/bpf/test_sockmap_kern.h

--
Signature
