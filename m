Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532D065D242
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbjADMSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239146AbjADMSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:18:43 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE1434773;
        Wed,  4 Jan 2023 04:18:39 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id g10so11614900wmo.1;
        Wed, 04 Jan 2023 04:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2YgCNa798Y3VIjbywLXHXW9LQqnWg0J7rGSAleAUdGg=;
        b=XDNrh+IA2Ln7BXFQ+jh8N4Yn5KnMqAgxQjUgs3qIj6S+aliRZknmtEv5DKiJsAZ2J5
         y+rkvhK4i8gNBhiXa7ZCRlgb/h3v0Qkq972QY1FVOZrLglqC5KWuZuyTR2TMOFugLywT
         xOB/+/+9i3m4UoFeGeQ/ROT3L8Vu3uOaTodzwQNOTI10ZK4pYn7hjqUc7bUCaE58g7Fw
         cFf/oh56jYh7SS8RAONCDXJ/r/ASsKjddDsTWaMlO7jGo9bISzcbZCQluFNahhJfGBkI
         qFFGZdtRMLSQxwTIlPmLcVF+COgcgpOVSyJuMq/XoP7dtswKsvt9GnC3xXOfDSIsufHD
         lYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YgCNa798Y3VIjbywLXHXW9LQqnWg0J7rGSAleAUdGg=;
        b=vMAw6KBdGUrA/bib0zSPGJUY9IRgktdqBky0OqEKrNpvtpTe1jZlKmby1abIiU+XcV
         snNdK31S/+7OCgV1Im2MZGERVREFiS2EQ5yPIqW6q69SdByJROdan3TI15wIghZWZ13a
         7oxSplN8HNFgGXBEogZVa5t41wBZ+2HHmkpL9cwdvSa4bsssaoxaJfTbBdxHeRtUh8fZ
         cWfN7dq7ZzLR6snwh+NR7LRE7E5UKyJ3pruC8Xgw/Gg3kBSYllKXIRUypABA+XILhBYf
         6jwa+6Ii+jx/be+GbMoGx1LQRHAJ36nc+oMd4sVRg2/QIMjrlumxirU9EFFVZGbeApmt
         MNBg==
X-Gm-Message-State: AFqh2kqx7nUGmbaOKE4UqZKhodoLv+3/4cqGpKwU6OKsSJYIdYumhuSg
        U9yp07LKiW0V968Z5w1rM28=
X-Google-Smtp-Source: AMrXdXsTftAWH3w/1n/02NgZtSLe+zhaocSNx4aKzBrs9Jg9wWbI3Er0lysJLQlndBN1AIz8+XAm7Q==
X-Received: by 2002:a05:600c:3b26:b0:3d7:fa4a:681b with SMTP id m38-20020a05600c3b2600b003d7fa4a681bmr35782813wms.0.1672834717866;
        Wed, 04 Jan 2023 04:18:37 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003d04e4ed873sm35013749wmo.22.2023.01.04.04.18.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:18:37 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 00/15] selftests/xsk: speed-ups, fixes, and new XDP programs
Date:   Wed,  4 Jan 2023 13:17:29 +0100
Message-Id: <20230104121744.2820-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a patch set of various performance improvements, fixes and the
introduction of more than one XDP program to the xsk selftests
framework so we can test more things in the future such as upcoming
multi-buffer and metadata support for AF_XDP. The new programs just
reuses the framework that all the other eBPF selftests use. The new
feature is used to implement one new test that does XDP_DROP on every
other packet. More tests using this will be added in future commits.

Contents:

* The run-time of the test suite is cut by 10x when executing the
  tests on a real NIC, by only attaching the XDP program once per mode
  tested, instead of once per test program.

* Over 700 lines of code have been removed. The xsk.c control file was
  moved straight over from libbpf when the xsk support was deprecated
  there. As it is now not used as library code that has to work with
  all kinds of versions of Linux, a lot of code could be dropped or
  simplified.

* Add a new command line option "-d" that can be used when a test
  fails and you want to debug it with gdb or some other debugger. The
  option creates the two veth netdevs and prints them to the screen
  without deleting them afterwards. This way these veth netdevs can be
  used when running xskxceiver in a debugger.

* Implemented the possibility to load external XDP programs so we can
  have more than the default one. This feature is used to implement a
  test where every other packet is dropped. Good exercise for the
  recycling mechanism of the xsk buffer pool used in zero-copy mode.

* Various clean-ups and small fixes in patches 1 to 5. None of these
  fixes has any impact on the correct execution of the tests when they
  pass, though they can be irritating when a test fails. IMHO, they do
  not need to go to bpf as they will not fix anything there. The first
  version of patches 1, 2, and 4 where previously sent to bpf, but has
  now been included here.

v1 -> v2:
* Fixed spelling error in commit message of patch #6 [Björn]
* Added explanation on why it is safe to use C11 atomics in patch #7
  [Daniel]
* Put all XDP programs in the same file so that adding more XDP
  programs to xskxceiver.c becomes more scalable in patches #11 and
  #12 [Maciej]
* Removed more dead code in patch #8 [Maciej]
* Removed stale %s specifier in error print, patch #9 [Maciej]
* Changed name of XDP_CONSUMES_SOME_PACKETS to XDP_DROP_HALF to
  hopefully make it clearer [Maciej]
* ifobj_rx and ifobj_tx name changes in patch #13 [Maciej]
* Simplified XDP attachment code in patch #15 [Maciej]

Patches:
1-5:   Small fixes and clean-ups
6:     New convenient debug option when using a debugger such as gdb
7-8:   Removal of unnecessary code
9:     Add the ability to load external XDP programs
10-11: Removal of more unnecessary code
12:    Implement a new test where every other packet is XDP_DROP:ed
13:    Unify the thread dispatching code
14-15: Simplify the way tests are written when using custom packet_streams
       or custom XDP programs

Thanks: Magnus

Magnus Karlsson (15):
  selftests/xsk: print correct payload for packet dump
  selftests/xsk: do not close unused file descriptors
  selftests/xsk: submit correct number of frames in populate_fill_ring
  selftests/xsk: print correct error codes when exiting
  selftests/xsk: remove unused variable outstanding_tx
  selftests/xsk: add debug option for creating netdevs
  selftests/xsk: replace asm acquire/release implementations
  selftests/xsk: remove namespaces
  selftests/xsk: load and attach XDP program only once per mode
  selftests/xsk: remove unnecessary code in control path
  selftests/xsk: get rid of built-in XDP program
  selftests/xsk: add test when some packets are XDP_DROPed
  selftests/xsk: merge dual and single thread dispatchers
  selftests/xsk: automatically restore packet stream
  selftests/xsk: automatically switch XDP programs

 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/progs/xsk_xdp_progs.c       |  30 +
 tools/testing/selftests/bpf/test_xsk.sh       |  42 +-
 tools/testing/selftests/bpf/xsk.c             | 674 +-----------------
 tools/testing/selftests/bpf/xsk.h             |  97 +--
 tools/testing/selftests/bpf/xsk_prereqs.sh    |  12 +-
 tools/testing/selftests/bpf/xskxceiver.c      | 382 +++++-----
 tools/testing/selftests/bpf/xskxceiver.h      |  17 +-
 8 files changed, 308 insertions(+), 948 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c


base-commit: bb5747cfbc4b7fe29621ca6cd4a695d2723bf2e8
--
2.34.1
