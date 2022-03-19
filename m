Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7794DE7D2
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 13:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242877AbiCSMVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 08:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236834AbiCSMVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 08:21:37 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A1B1A8FCB
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 05:20:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n2so9124138plf.4
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 05:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=1X+WrWT0DCquyZEULaNXEiIImLqh1qdpdfLE6maXvKE=;
        b=VWhsGNhUzhIZ1jmJvNBKG5sKxDyIXimKmB9MzsUg6xg4kl2dmewIzoaOe5eVKG9JTb
         2Mta9U8hMT3ycXcf7WoA0UXL7fsndEne9UI/xPWCcPoRbcMmqG4RUijxGkXQE0LzjsPg
         pwdTDlUsvTGMsSDMDv524oV31MCsCBRU7mHkZAr4BJfAKWM7bP7qpWSBvhRaw4tHcFMP
         9zSJTEOVKOLvO8Rv7jHhfW/kJbnR+xOcWL/cIhd5+H9DAIwYlPlaXi0q/0D1yPqtR9cJ
         YCiZBK4CYiaw34ubYrUJkycDsDK6rlgPNg22kBoiOL2X6B+wiSzPp9aUR1NvRmGZiWdE
         6gPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1X+WrWT0DCquyZEULaNXEiIImLqh1qdpdfLE6maXvKE=;
        b=eup/okjbD2Cu4t0tcQLmlSyjM+YrcghLyumugBYbHv9fl41LFG0mc6eB/KC32XdMOn
         PJmYOSE3x9K2W+yPhin6oHHdwHezCdokyt4O/jwdFiAGj08g/Hve+AB65Bo6mRh0Nx1/
         qI5UaJuvracA2GTdTB4uT+K9uVq8bd4rnRWW9dR4irWD5yq+ga5KeOIVlR76R2JeN5yX
         w7v31t4meDqBAUx8teCQ4oQvZbqssFuJl3Rja20gpCSHebAwad+wOYclxRoowdAVQl4h
         bWofzOF5Rc/YEDcGZnwZBOYfcwr484bxEkn+Q+HpQeuqL/7BPNvCq3bEoXs82qb+o9p6
         3YYw==
X-Gm-Message-State: AOAM531cMj2FErLz5Ot/8t9M+Mzw/zKLMEpBtlMwNc2hxTsygIJvOHmE
        zNOjyjeiMFXuOsRe0FMO2Xc=
X-Google-Smtp-Source: ABdhPJy4b4JbeZ116n0zLGvaMbbFue4tTE0EWscyifTemWwrYAdLdfsv24lw+jacGXlqJa1By/elyw==
X-Received: by 2002:a17:90a:4604:b0:1bc:8bdd:4a63 with SMTP id w4-20020a17090a460400b001bc8bdd4a63mr26896742pjg.147.1647692416627;
        Sat, 19 Mar 2022 05:20:16 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id z23-20020aa79597000000b004fa3634907csm9485537pfj.72.2022.03.19.05.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 05:20:16 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        irusskikh@marvell.com, epomozov@marvell.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 0/3] net: atlantic: Add XDP support
Date:   Sat, 19 Mar 2022 12:19:10 +0000
Message-Id: <20220319121913.17573-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to make atlantic to support multi-buffer XDP.

The first patch implement control plane of xdp.
The aq_xdp(), callback of .xdp_bpf is added.

The second patch implements data plane of xdp.
XDP_TX, XDP_DROP, and XDP_PASS is supported.
__aq_ring_xdp_clean() is added to receive and execute xdp program.
aq_nic_xmit_xdpf() is added to send packet by XDP.

The third patch implements callback of .ndo_xdp_xmit.
aq_xdp_xmit() is added to send redirected packets and it internally
calls aq_nic_xmit_xdpf().

Memory model is MEM_TYPE_PAGE_ORDER0 so it doesn't reuse rx page when
XDP_TX, XDP_PASS, XDP_REDIRECT.

Default the maximum rx frame size is 2K.
If xdp is attached, size is changed to about 3K.
It can be reused when XDP_DROP, XDP_ABORTED.

Atlantic driver has AQ_CFG_RX_PAGEORDER option and it will be always 0
if xdp is attached.

AQC chip supports 32 multi-queues and 8 vectors(irq).
There are two options.
1. under 8 cores and maximum 4 tx queues per core.
2. under 4 cores and maximum 8 tx queues per core.

Like other drivers, these tx queues can be used only for XDP_TX,
XDP_REDIRECT queue. If so, no tx_lock is needed.
But this patchset doesn't use this strategy because getting hardware tx
queue index cost is too high.
So, tx_lock is used in the aq_nic_xmit_xdpf().

single-core, single queue, 40% cpu utilization.

  30.75%  bpf_prog_xxx_xdp_prog_tx  [k] bpf_prog_xxx_xdp_prog_tx
  10.35%  [kernel]                  [k] aq_hw_read_reg <---------- here
   4.38%  [kernel]                  [k] get_page_from_freelist

single-core, 8 queues, 100% cpu utilization, half PPS.

  45.56%  [kernel]                  [k] aq_hw_read_reg <---------- here
  17.58%  bpf_prog_xxx_xdp_prog_tx  [k] bpf_prog_xxx_xdp_prog_tx
   4.72%  [kernel]                  [k] hw_atl_b0_hw_ring_rx_receive

Performance result(64 Byte)
1. XDP_TX
  a. xdp_geieric, single core
    - 2.5Mpps, 100% cpu
  b. xdp_driver, single core
    - 4.5Mpps, 40% cpu
  c. xdp_generic, 8 core(hyper thread)
    - 6.3Mpps, 5~10% cpu
  d. xdp_driver, 8 core(hyper thread)
    - 6.3Mpps, 5% cpu

2. XDP_REDIRECT
  a. xdp_generic, single core
    - 2.3Mpps
  b. xdp_driver, single core
    - 4.5Mpps

Taehee Yoo (3):
  net: atlantic: Implement xdp control plane
  net: atlantic: Implement xdp data plane
  net: atlantic: Implement .ndo_xdp_xmit handler

 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |   1 +
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |   8 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  59 +++
 .../net/ethernet/aquantia/atlantic/aq_main.h  |   2 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 126 ++++--
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   7 +-
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 409 ++++++++++++++++--
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  17 +
 .../net/ethernet/aquantia/atlantic/aq_vec.c   |  23 +-
 .../net/ethernet/aquantia/atlantic/aq_vec.h   |   6 +
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |   6 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  10 +-
 13 files changed, 595 insertions(+), 81 deletions(-)

-- 
2.17.1

