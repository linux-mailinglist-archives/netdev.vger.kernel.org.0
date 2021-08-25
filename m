Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B533F73D4
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240037AbhHYK6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237446AbhHYK6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 06:58:10 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3087C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 03:57:24 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id k24so22682163pgh.8
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 03:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=esMSKXwnANkLgpZjhGQy+GZoLtHSPcb855z8lvhlfyQ=;
        b=H14BXyG73ubqs9sDlgWW4EU9B4l70eP/45lMAEGQ/RwSTyioYcynx2S+BTE290HYn7
         r5f4v/ZjXCFPsJdNW8XiwXK8/HNFhpCK4LJlvhN1NVTnX4vzglWMYcUpGFkkLZ+Ju1Jq
         8w7X6+Z6CEON6F52ejUP/Jf4dQpr/mQrU4MIa0/EwaEh3Uat2s/F9G2nb7lKb0CEbWPk
         5un9ejkKMwaA7SoSsGnMV8d1skXNgd38QkwH3RCDTqhnSsbyZXySuN4vj584QsBtP1Rc
         Vu0PihFoZw/yBnLrT7vYku0B5smWjphnZcKyNkJ5zY0whhOO8E7xl/n1vFixtaTlwoVF
         Dlsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=esMSKXwnANkLgpZjhGQy+GZoLtHSPcb855z8lvhlfyQ=;
        b=kkgT2Iamp/EumeS/QtryzzUm6e56PYhRsrCV53lDp3QQB3hQ6RsKO1ymGI/Dd8yKaf
         e0QeBOvzQ3VJW9flQ4f4B1clfPaheS739YgU1cQOcPpLqASzn8QHyfKQYWu7Q1gbGfyH
         UIA3LXXzUE3mxEaR1yf1tYZnbM69H5oYy3fzl6PLMpFoF1EDrO14URKC2IoGHn1fowyf
         1Gh6me34sqK0MP+8RPF/UMdQdRv6yYefCmIs6zPugTxj91c2GufDOeB40/epTWVDc9dV
         Oh3C/MKD51IkjYIRQmA4z+zyeLMVNRtF6tCAck2dnuXpQ6lpN3L0uX9wbC8I4HWPboqC
         K3RA==
X-Gm-Message-State: AOAM532+ChVGVi6HZI4HNi1P6b2cpMpwLq1KosFy2zzMY6C4EnJQJ+YT
        TIpkYZXQ3Ku5SXjxv9uJvCc=
X-Google-Smtp-Source: ABdhPJy8auw4X3nU4AAPsxQPEhhmQYuHTN/lr9sZlZrl80nE7IYB1wqNkPp7odx3d2UbFFrCBieucQ==
X-Received: by 2002:a62:5c6:0:b029:341:e0b1:a72c with SMTP id 189-20020a6205c60000b0290341e0b1a72cmr44184520pff.71.1629889044228;
        Wed, 25 Aug 2021 03:57:24 -0700 (PDT)
Received: from MASTER.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id 6sm5606191pjz.8.2021.08.25.03.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 03:57:23 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     hawk@kernel.org, davem@davemloft.net, toke@toke.dk
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] samples: pktgen: enhance the ability to print the execution results of samples
Date:   Wed, 25 Aug 2021 19:57:14 +0900
Message-Id: <20210825105717.43195-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series improves the ability to print the execution result of pktgen
samples by adding a line which calls the function before termination and adding
trap SIGINT. Also, this series documents the latest pktgen usage options.

Currently, pktgen samples print the execution result when terminated usually.
However, sample03 is not working properly.

This is results of sample04 and sample03:

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample04_many_flows.sh -n 1
    Running... ctrl^C to stop
    Device: eth0@0
    Result: OK: 19(c5+d13) usec, 1 (60byte,0frags)
    51762pps 24Mb/sec (24845760bps) errors: 0

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample03_burst_single_flow.sh -n 1
    Running... ctrl^C to stop

Because sample03 doesn't call the function which prints the execution result
when terminated normally, unlike other samples. So the first commit solves
this issue by adding a line which calls the function before termination.

Also, all pktgen samples are able to send infinite messages per thread by
setting the count option to 0, and pktgen is stopped by Ctrl-C. However,
the sample besides sample{3...5} don't work appropriately because Ctrl-C stops
the script, not just pktgen.

This is results of samples:

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample04_many_flows.sh -n 0
    Running... ctrl^C to stop
    ^CDevice: eth0@0
    Result: OK: 569657(c569538+d118) usec, 84650 (60byte,0frags)
    148597pps 71Mb/sec (71326560bps) errors: 0

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample01_simple.sh -n 0
    Running... ctrl^C to stop
    ^C

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample02_multiqueue.sh -n 0
    Running... ctrl^C to stop
    ^C

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_sample06_numa_awared_queue_irq_affinity.sh -n 0
    Running... ctrl^C to stop
    ^C

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_bench_xmit_mode_netif_receive.sh -n 0
    Running... ctrl^C to stop
    ^C

    # DEV=eth0 DEST_IP=10.1.0.1 DST_MAC=00:11:22:33:44:55 ./pktgen_bench_xmit_mode_queue_xmit.sh -n 0
    Running... ctrl^C to stop
    ^C

So the second commit solves this issue by adding trap SIGINT. Also, changes
control_c function to print_results to maintain consistency with other samples
on the first commit and second commit.

And current pktgen.rst documentation doesn't add the latest pktgen sample
usage options such as count and IPv6, and so on. Also, the old pktgen
sample scripts are still included in the document. The old scripts were removed
by the commit a4b6ade8359f ("samples/pktgen: remove remaining old pktgen
sample scripts").

Thus, the last commit documents the latest pktgen sample usage and removes
old sample scripts. And fixes a minor typo.

Juhee Kang (3):
  samples: pktgen: fix to print when terminated normally
  samples: pktgen: add trap SIGINT for printing execution result
  pktgen: document the latest pktgen usage options

 Documentation/networking/pktgen.rst           | 18 ++++++++----------
 .../pktgen_bench_xmit_mode_netif_receive.sh   | 19 +++++++++++++------
 .../pktgen_bench_xmit_mode_queue_xmit.sh      | 19 +++++++++++++------
 samples/pktgen/pktgen_sample01_simple.sh      | 13 ++++++++++---
 samples/pktgen/pktgen_sample02_multiqueue.sh  | 19 +++++++++++++------
 .../pktgen_sample03_burst_single_flow.sh      |  6 ++++--
 ...sample06_numa_awared_queue_irq_affinity.sh | 19 +++++++++++++------
 7 files changed, 74 insertions(+), 39 deletions(-)

--
2.30.2

