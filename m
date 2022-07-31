Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF74585F5E
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 17:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237259AbiGaPDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 11:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237250AbiGaPDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 11:03:40 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6198FDEAB
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 08:03:39 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p8so8339623plq.13
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 08:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=+KdIGDnlE1pFASraMJLIHKzyorzKHb1nnqifBa3MKrg=;
        b=RUg1wFNT011vKK/EU8fzO3fwr5d99dgL5h0RGWowmoAy79hhfR0YLSXvCYfU00ANaa
         MZNsI1iHefnwyIuxTo12N/Xnu4BnYZew0b6DsteYPw7/vzDoVjoMsEln8S6ho2CXancb
         ZImcWNpSLI3Ml80Ic5VFxfrtRWRMwCuJU9PfxBsoMtUmnaGvqxh2RGU7DqXceuZLEMN2
         Oz12h8VASL4Ks/mio1gRoHUPnjw77VcAJpeDleKdBQq78EnZwfviFWld7zbDArmDA62t
         PJ2EQl6rlFThCTNAi0HJFmEn757AJuPihbFHwMsUFv0UFWBwZMut8LZm7E6D6K9Wx5n1
         W3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=+KdIGDnlE1pFASraMJLIHKzyorzKHb1nnqifBa3MKrg=;
        b=5O6SOtNR7lbobt87UXKdWn0OrXqamES2HaA2uoyKfMDFkESOjuGscg2z5zvZZHtz9A
         K4V0kmEJdzQvJa0kkCr2Dh7v2S0T/4KKGuIbUThizyS469TXJGrNv8v7mUzclu3pUxx5
         XbsVF08SbSt5iEZz5FuWWRTenXrkn/9YKN/x6MKSCKrGEQ8UNgEqM7ZStSnnskUQEJ0d
         zT/wCJkHaqPCNDGXxhjEzst2IaUkFQZ3DnTytEqoetVF+5X4UZV4Ln8ch6dxQrDvWL1H
         S2PqWmjykUJKo7RajGgAh1vyWqkhH5Okdck3sj8mgp1w1YFxaliglKyVHU9iUhVslTwr
         SSaQ==
X-Gm-Message-State: ACgBeo2P+3tn2lGV/ckq0UKoumdsLhqAWRqar+goFHlusauXkPh03AQg
        0JK7dSj4r4bM2xsylbomcZlbPbYjFIrW1g==
X-Google-Smtp-Source: AA6agR6hDzGoFs+MfCplLHrSs7L/fdVk0SXyCzVyP9OsjTRbH6ANhCc1D+RRc3qT1gtB6rHcsLG0zw==
X-Received: by 2002:a17:902:8645:b0:16d:2b60:bc80 with SMTP id y5-20020a170902864500b0016d2b60bc80mr12602712plt.126.1659279818815;
        Sun, 31 Jul 2022 08:03:38 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u1-20020a170902714100b0016ed715d244sm2658986plm.300.2022.07.31.08.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jul 2022 08:03:37 -0700 (PDT)
Message-ID: <d5568318-39ea-0c39-c765-852411409b68@kernel.dk>
Date:   Sun, 31 Jul 2022 09:03:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring support for zerocopy send
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On top of the core io_uring changes, this pull request adds support for
efficient support for zerocopy sends through io_uring. Both ipv4 and
ipv6 is supported, as well as both TCP and UDP.

The core network changes to support this is in a stable branch from
Jakub that both io_uring and net-next has pulled in, and the io_uring
changes are layered on top of that.

All of the work has been done by Pavel.

Please pull!


The following changes since commit f6b543fd03d347e8bf245cee4f2d54eb6ffd8fcb:

  io_uring: ensure REQ_F_ISREG is set async offload (2022-07-24 18:39:18 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.20/io_uring-zerocopy-send-2022-07-29

for you to fetch changes up to 14b146b688ad9593f5eee93d51a34d09a47e50b5:

  io_uring: notification completion optimisation (2022-07-27 08:50:50 -0600)

----------------------------------------------------------------
for-5.20/io_uring-zerocopy-send-2022-07-29

----------------------------------------------------------------
David Ahern (1):
      net: Allow custom iter handler in msghdr

Jens Axboe (2):
      Merge branch 'io_uring-zerocopy-send' of git://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux into for-5.20/io_uring-zerocopy-send
      Merge branch 'for-5.20/io_uring' into for-5.20/io_uring-zerocopy-send

Pavel Begunkov (33):
      ipv4: avoid partial copy for zc
      ipv6: avoid partial copy for zc
      skbuff: don't mix ubuf_info from different sources
      skbuff: add SKBFL_DONT_ORPHAN flag
      skbuff: carry external ubuf_info in msghdr
      net: introduce managed frags infrastructure
      net: introduce __skb_fill_page_desc_noacc
      ipv4/udp: support externally provided ubufs
      ipv6/udp: support externally provided ubufs
      tcp: support externally provided ubufs
      net: fix uninitialised msghdr->sg_from_iter
      io_uring: initialise msghdr::msg_ubuf
      io_uring: export io_put_task()
      io_uring: add zc notification infrastructure
      io_uring: cache struct io_notif
      io_uring: complete notifiers in tw
      io_uring: add rsrc referencing for notifiers
      io_uring: add notification slot registration
      io_uring: wire send zc request type
      io_uring: account locked pages for non-fixed zc
      io_uring: allow to pass addr into sendzc
      io_uring: sendzc with fixed buffers
      io_uring: flush notifiers after sendzc
      io_uring: rename IORING_OP_FILES_UPDATE
      io_uring: add zc notification flush requests
      io_uring: enable managed frags with register buffers
      selftests/io_uring: test zerocopy send
      io_uring/net: improve io_get_notif_slot types
      io_uring/net: checks errors of zc mem accounting
      io_uring/net: make page accounting more consistent
      io_uring/net: use unsigned for flags
      io_uring: export req alloc from core
      io_uring: notification completion optimisation

 include/linux/io_uring_types.h                     |  30 +
 include/linux/skbuff.h                             |  66 ++-
 include/linux/socket.h                             |   5 +
 include/uapi/linux/io_uring.h                      |  45 +-
 io_uring/Makefile                                  |   2 +-
 io_uring/io_uring.c                                |  61 +--
 io_uring/io_uring.h                                |  43 ++
 io_uring/net.c                                     | 193 ++++++-
 io_uring/net.h                                     |   3 +
 io_uring/notif.c                                   | 159 ++++++
 io_uring/notif.h                                   |  90 +++
 io_uring/opdef.c                                   |  24 +-
 io_uring/rsrc.c                                    |  67 ++-
 io_uring/rsrc.h                                    |  25 +-
 io_uring/tctx.h                                    |  26 -
 net/compat.c                                       |   1 +
 net/core/datagram.c                                |  14 +-
 net/core/skbuff.c                                  |  37 +-
 net/ipv4/ip_output.c                               |  50 +-
 net/ipv4/tcp.c                                     |  33 +-
 net/ipv6/ip6_output.c                              |  49 +-
 net/socket.c                                       |   2 +
 tools/testing/selftests/net/Makefile               |   1 +
 tools/testing/selftests/net/io_uring_zerocopy_tx.c | 605 +++++++++++++++++++++
 .../testing/selftests/net/io_uring_zerocopy_tx.sh  | 131 +++++
 25 files changed, 1604 insertions(+), 158 deletions(-)
 create mode 100644 io_uring/notif.c
 create mode 100644 io_uring/notif.h
 create mode 100644 tools/testing/selftests/net/io_uring_zerocopy_tx.c
 create mode 100755 tools/testing/selftests/net/io_uring_zerocopy_tx.sh

-- 
Jens Axboe

