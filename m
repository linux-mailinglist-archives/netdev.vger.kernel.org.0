Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F964643F59
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbiLFJIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbiLFJIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:08:54 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B590A1CFD9;
        Tue,  6 Dec 2022 01:08:52 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id o5so22534504wrm.1;
        Tue, 06 Dec 2022 01:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3o4QtSJ7c4P7HZT5L+mxX3DZ2HgHpAgbZ1YjOIxIeqo=;
        b=W1Pl3qLLo8V/jqatIoiVw0zMU1rjeZ0r9FRnKMEPCgYg9B8ftTCu2MgVxiQ+RjVAqh
         olqJJnbBDXVBoJL76h/W0VtKIxfUV2MAF3Pcf9VXVewzvIi/lN/46VzApIiKf6O5oHdh
         dDeyd+UlS8CF3URb3QuYgDIXlgG9+cpOBVQUaxywIykfiOZl5Z75cULOwgCSWz2QTI/y
         WA08Lmo7EAThvfk6W/KoLqxyYPhV74K9hdJ8GqcseuOOyhCMt7Cy0erLiUojSjXPR/Zc
         y6YDAiMSfh6s1PboVTjkQb/w46k4sdGuOkcdHM3xZ5zSFBsfF63JxePCUKUQF9c/9i/G
         McrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3o4QtSJ7c4P7HZT5L+mxX3DZ2HgHpAgbZ1YjOIxIeqo=;
        b=WYd0J3Lg1nCR/zTPeC6oCwogZOMy3+i06Ykw+D5ElF1vdJTnLc4C4YL/N+XyKLRI7E
         YVFFkwQkdF2FpgbKdMIfJUHHOyQX95BPnFENzlOo2DZa05CjwnxMM/dApjmorLUV6O6r
         8P4e0qzwadFhDEdUI84CI25bD51vmQvzTNpaQNkd2qeVZUqoKcIGz/X0xS8wwmCUKzEv
         oZM7T4tSGPIl3I5Mq0W6MbJuBlSUqB5aLa/JKhFWa/YFfLOuCdLVzDg0d4+E5J1ZFc5f
         Ialtme5kM1ab0wOs5Cxe8KonNc9DBmF+cC4rwULtEHxeD7ckoWPXA9ihpgMkmoDgljpb
         D2Bg==
X-Gm-Message-State: ANoB5pkpTd9FRlaixEXahe+d1FVGPwpHRLnWraAhDdITNw/+WhSQz4jE
        itw4z3P5bR9fZ3LkjA3DWVk=
X-Google-Smtp-Source: AA0mqf5z43eL/Ti+R8aAu7XmWjpYxhXUGtqtwzVO5G+zimMKzNd+ZXDMUDuqs7sPS2byceA4PsRrfQ==
X-Received: by 2002:a05:6000:50f:b0:241:ee78:b109 with SMTP id a15-20020a056000050f00b00241ee78b109mr34460979wrf.203.1670317730976;
        Tue, 06 Dec 2022 01:08:50 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.08.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:08:50 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 00/15] selftests/xsk: speed-ups, fixes, and new XDP programs
Date:   Tue,  6 Dec 2022 10:08:11 +0100
Message-Id: <20221206090826.2957-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
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
  we test, instead of once per test program.

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
  selftests/xsk: get rid of asm store/release implementations
  selftests/xsk: remove namespaces
  selftests/xsk: load and attach XDP program only once per mode
  selftests/xsk: remove unnecessary code in control path
  selftests/xsk: get rid of built-in XDP program
  selftests/xsk: add test when some packets are XDP_DROPed
  selftests/xsk: merge dual and single thread dispatchers
  selftests/xsk: automatically restore packet stream
  selftests/xsk: automatically switch XDP programs

 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/progs/xsk_def_prog.c        |  19 +
 .../selftests/bpf/progs/xsk_xdp_drop.c        |  25 +
 tools/testing/selftests/bpf/test_xsk.sh       |  42 +-
 tools/testing/selftests/bpf/xsk.c             | 674 +-----------------
 tools/testing/selftests/bpf/xsk.h             |  97 +--
 tools/testing/selftests/bpf/xsk_prereqs.sh    |  12 +-
 tools/testing/selftests/bpf/xskxceiver.c      | 376 +++++-----
 tools/testing/selftests/bpf/xskxceiver.h      |  19 +-
 9 files changed, 333 insertions(+), 933 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xsk_def_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_drop.c


base-commit: 08388efe593106d2fcd6ddf7a269db58a62a5dda
--
2.34.1
