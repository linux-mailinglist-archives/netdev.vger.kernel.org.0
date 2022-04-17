Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E8350477D
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 12:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbiDQKPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 06:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbiDQKPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 06:15:38 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407BE6363;
        Sun, 17 Apr 2022 03:13:01 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t184so1026445pgd.4;
        Sun, 17 Apr 2022 03:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=tnxQ28g16xyWY4jpni1bxp4mS8xc6P9msQoQxWMyEUg=;
        b=faltGP9pOom1QILuKTrGl+MwC0FaFyIfyFtdRJLCXVxOBJ/XIAt7VZpPpWMWvGBiAf
         6U6fapzcH3iPn5xcPXH/plxY8C5KVRN3AshCe+Ph4yZs5w2KLvdml8IJ/qMT+JTgWNU1
         lSRqXt0BfrLAVYclFVNBWAAl1Y4gCQDj4wZ/pTNjecjFJKsAFb0oqKe82YK2YAiojCcg
         y2FcjVgMzjI+zrQPQzLKKz8wNMFTRF8tbYhMSW99NC6FqkgDmDbTa84V0wCgYmH+cWKs
         SmWY4CyCm/oB7A9sShTb1Enlta4HQruvb9V41TLxD8BkxGw+QZZXtCn56IZcvxhH9KVE
         lBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tnxQ28g16xyWY4jpni1bxp4mS8xc6P9msQoQxWMyEUg=;
        b=2BJO4zeMk2skVqQlRaqkCLO/eGDTF5DSWSE5NHVWmKVoC+v94aoe4LDVufUVnqPG4W
         h0mdDPXGHugj/UTOKjPVwMHnQJI8nI3G2LABKl49EAZgejUoSIJlbUYhqsKeZEIJUXNf
         atfu3Rez51DHaRfjyw/rVzHQ5fg1BNO4OrVr1xmyEMJsAtiXBtk8fAcxl0Sml5NbiGUS
         GMJxJyq3tHp8XzQbfMe2rSytikkz+cbUYREg4UypzWmXQ7kKMlzXOxHvrgWLjH/4lYSa
         Mn4vvl0IzAyYe+kbUYMCrhnEof5SRiQl3HApDy8hz8fAyvOk7VrcsoPTMUxLpcSSsqU/
         SImA==
X-Gm-Message-State: AOAM530JwnM9fX7EJXoVZj+GykG8YEBTPnHjVZxhANWwrFLME+1OIhjK
        8mlxTMPm3dgxS7s9LFvlSiYX3rmYMgs=
X-Google-Smtp-Source: ABdhPJxxXZr6WWxnempIPtA7rsUDtvwzjMzrUdSczUbM/V+0Io/8r08DJpx40PPzcLQLOyoWM/drTw==
X-Received: by 2002:a62:2742:0:b0:505:89a5:2023 with SMTP id n63-20020a622742000000b0050589a52023mr7046911pfn.18.1650190379407;
        Sun, 17 Apr 2022 03:12:59 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x36-20020a056a000be400b0050a40b8290dsm7473760pfu.54.2022.04.17.03.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 03:12:58 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, irusskikh@marvell.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v5 0/3] net: atlantic: Add XDP support
Date:   Sun, 17 Apr 2022 10:12:44 +0000
Message-Id: <20220417101247.13544-1-ap420073@gmail.com>
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

Memory model is MEM_TYPE_PAGE_SHARED.

Order-2 page allocation is used when XDP is enabled.

LRO will be disabled if XDP program doesn't supports multi buffer.

AQC chip supports 32 multi-queues and 8 vectors(irq).
There are two options.
1. under 8 cores and maximum 4 tx queues per core.
2. under 4 cores and maximum 8 tx queues per core.

Like other drivers, these tx queues can be used only for XDP_TX,
XDP_REDIRECT queue. If so, no tx_lock is needed.
But this patchset doesn't use this strategy because getting hardware tx
queue index cost is too high.
So, tx_lock is used in the aq_nic_xmit_xdpf().

single-core, single queue, 80% cpu utilization.

  32.30%  [kernel]                  [k] aq_get_rxpages_xdp
  10.44%  [kernel]                  [k] aq_hw_read_reg <---------- here
   9.86%  bpf_prog_xxx_xdp_prog_tx  [k] bpf_prog_xxx_xdp_prog_tx
   5.51%  [kernel]                  [k] aq_ring_rx_clean

single-core, 8 queues, 100% cpu utilization, half PPS.

  52.03%  [kernel]                  [k] aq_hw_read_reg <---------- here
  18.24%  [kernel]                  [k] aq_get_rxpages_xdp
   4.30%  [kernel]                  [k] hw_atl_b0_hw_ring_rx_receive
   4.24%  bpf_prog_xxx_xdp_prog_tx  [k] bpf_prog_xxx_xdp_prog_tx
   2.79%  [kernel]                  [k] aq_ring_rx_clean

Performance result(64 Byte)
1. XDP_TX
  a. xdp_geieric, single core
    - 2.5Mpps, 100% cpu
  b. xdp_driver, single core
    - 4.5Mpps, 80% cpu
  c. xdp_generic, 8 core(hyper thread)
    - 6.3Mpps, 40% cpu
  d. xdp_driver, 8 core(hyper thread)
    - 6.3Mpps, 30% cpu

2. XDP_REDIRECT
  a. xdp_generic, single core
    - 2.3Mpps
  b. xdp_driver, single core
    - 4.5Mpps

v5:
 - Use MEM_TYPE_PAGE_SHARED instead of MEM_TYPE_PAGE_ORDER0
 - Use 2K frame size instead of 3K
 - Use order-2 page allocation instead of order-0
 - Rename aq_get_rxpage() to aq_alloc_rxpages()
 - Add missing PageFree stats for ethtool
 - Remove aq_unset_rxpage_xdp(), introduced by v2 patch due to
   change of memory model
 - Fix wrong last parameter value of xdp_prepare_buff()
 - Add aq_get_rxpages_xdp() to increase page reference count

v4:
 - Fix compile warning

v3:
 - Change wrong PPS performance result 40% -> 80% in single
   core(Intel i3-12100)
 - Separate aq_nic_map_xdp() from aq_nic_map_skb()
 - Drop multi buffer packets if single buffer XDP is attached
 - Disable LRO when single buffer XDP is attached
 - Use xdp_get_{frame/buff}_len()

v2:
 - Do not use inline in C file

Taehee Yoo (3):
  net: atlantic: Implement xdp control plane
  net: atlantic: Implement xdp data plane
  net: atlantic: Implement .ndo_xdp_xmit handler

 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |   1 +
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |   9 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  87 ++++
 .../net/ethernet/aquantia/atlantic/aq_main.h  |   2 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 136 ++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   5 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 409 ++++++++++++++++--
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  21 +-
 .../net/ethernet/aquantia/atlantic/aq_vec.c   |  23 +-
 .../net/ethernet/aquantia/atlantic/aq_vec.h   |   6 +
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |   6 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  10 +-
 12 files changed, 670 insertions(+), 45 deletions(-)

-- 
2.17.1

