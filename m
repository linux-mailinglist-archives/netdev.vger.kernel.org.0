Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BA76657A9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbjAKJiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235868AbjAKJhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:37:19 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6EC6142;
        Wed, 11 Jan 2023 01:36:00 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id w1so14415791wrt.8;
        Wed, 11 Jan 2023 01:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FFiukE0krVg+8r1ykvsDR/QkWY0EexPf6HWIJaxy92k=;
        b=qHi8ocWVAGMVCWsJxlB23RLjkqNBDbSuScphrBAA1inlsHryeSKWiEXxPwVCOBXITx
         dXs1cfxmMx2X9kbUy7nqrOQt93VWDyNYTZj7Wl5q/E71B+iKA54kSHFId/Uv6B4i5WT5
         Zuzxp0F+iB36k1wcU4G/iaBjrD4fpYyquYwyqbJ6vAhni2oxi5WKWm75yu09RROpNx1/
         ILKG6JmL8sQp2FM7FGRgJ4ry+SpsCYwMOEwW7QgOVSjYg5zTnRTyt29S8MDWIT7ZorcQ
         2PNwNEvIQh/FxLBIIvy+9u51u35c0x3yrLp+tSSVhdMjNfix20iZ/SnHNO3C+Oy8YC4/
         BIQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FFiukE0krVg+8r1ykvsDR/QkWY0EexPf6HWIJaxy92k=;
        b=Gyt7nscXV6mkq2+MbvVNaAHt4YyeYf6k7pi87/lgeSeQlUWv54LxjOjswxOm+5SG07
         u/HHfSDeTIR/y66iijxIJN9SK2oa1TA1kDY6dEZKfKkEV5Bd17Czj45DWYO1+GS57mLh
         Sc7szM02vhiaf3fsuh36v9n5jtH6K9iv7LbwDjbS/qPOKWlYf21iAkSqlRMiPJHJP9mD
         bUS6wR7mn6AvwQnddErpi7D4HWPL8JjJCLAGuwqZj+DEtpmZJRKHuKcTfhkc29+bHYd8
         6/besbevyEIY4ckl/VeLLdrAWC9kMlAxFe8aefF4Q6HbuAdE1BKNOXIRzC5YE/E6+5po
         kV5A==
X-Gm-Message-State: AFqh2koSWxMiUKxmuRmlBW34xuOtKQOWW0hebO7KVCmzH3YKv9DNd3uj
        rX22YDNjStnPEd/l7rNHFiI=
X-Google-Smtp-Source: AMrXdXudfuXqi8QAwEG5zaImoWDf1u+vGrPC6T1zJOjDIDESs5a44Szc9EHFShGsqLxNwIJYIe7syg==
X-Received: by 2002:a5d:4842:0:b0:2bb:62bf:f5d1 with SMTP id n2-20020a5d4842000000b002bb62bff5d1mr11391504wrs.29.1673429758882;
        Wed, 11 Jan 2023 01:35:58 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b0025e86026866sm15553069wrs.0.2023.01.11.01.35.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:35:58 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 00/15] selftests/xsk: speed-ups, fixes, and new XDP programs
Date:   Wed, 11 Jan 2023 10:35:11 +0100
Message-Id: <20230111093526.11682-1-magnus.karlsson@gmail.com>
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

This is a patch set of various performance improvements, fixes, and
the introduction of more than one XDP program to the xsk selftests
framework so we can test more things in the future such as upcoming
multi-buffer and metadata support for AF_XDP. The new programs just
reuse the framework that all the other eBPF selftests use. The new
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

v2 -> v3:
* Fixed compilation error for llvm [David]
* Made the function xsk_is_in_drv_mode(ifobj) more generic by changing
  it to xsk_is_in_mode(ifobj, xdp_mode) [Maciej]
* Added Maciej's acks to all the patches

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

 tools/testing/selftests/bpf/Makefile          |   6 +-
 .../selftests/bpf/progs/xsk_xdp_progs.c       |  30 +
 tools/testing/selftests/bpf/test_xsk.sh       |  42 +-
 tools/testing/selftests/bpf/xsk.c             | 677 +-----------------
 tools/testing/selftests/bpf/xsk.h             |  97 +--
 tools/testing/selftests/bpf/xsk_prereqs.sh    |  12 +-
 tools/testing/selftests/bpf/xskxceiver.c      | 382 +++++-----
 tools/testing/selftests/bpf/xskxceiver.h      |  17 +-
 8 files changed, 316 insertions(+), 947 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c


base-commit: 6920b08661e3ad829206078b5c9879b24aea8dfc
--
2.34.1
