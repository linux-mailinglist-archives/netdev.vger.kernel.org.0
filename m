Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCB94F9B35
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 19:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbiDHRCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 13:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiDHRCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 13:02:08 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E1B31A282;
        Fri,  8 Apr 2022 10:00:04 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 66so8239411pga.12;
        Fri, 08 Apr 2022 10:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=UEoq6A0DN6+BIRyVMFa/7Wyj2PKUdP0gzCqFi4WerTs=;
        b=cbBA+ym/0QFCRH7SGhtKzWo6vfGWs848JQ4wJ5/hKfHFtJ17f9q1Xl+KT2bGecdLvs
         N4rDULh7FQ36KtM94SuiXUqTIVuWvyCQkurFVANBpu21BWDHFN3fTzWWAyA7wdlwZkJ8
         FAJQeBKAmTzhA5B24Zp/wGzwnh4fa9+sISXFvVbcPNv1Zq92YQMj0hqW6Ehi00JRkV3S
         a32bmI0YKF4zS2NFQUSEVd2hojDQiM5fgv8zg6mgqKLh3OYL044y0TJqxJ1SZrI+Cl/N
         iUZy67uK7JL4x61HGVM8EFI++/ePzHvTkb4jJa6MdMhFAgTwhP7stfEqa20docYwPCpj
         qa6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UEoq6A0DN6+BIRyVMFa/7Wyj2PKUdP0gzCqFi4WerTs=;
        b=TO9f0hGRCLuSgzZF8FA9Iykj8JHUXZ0/SuBOhvqYtmuYBbCdFejFGBihaoPTNEU6YG
         o2p87QOV9C3Gx8HFJu4AQwe62Amuy5Oa48kFI2EORJUimAx5hDzHvYq5ikRYCE6zxdM6
         y2qEF5qoJFHiXI9T17W9sBt4wV49ASeyyl8eh76wynAQ+kefdnXqnslw/JQSoMaS7Tjf
         k+fsDdztQ/nbRxc1TCRpzx6aQLVPLL9q1IJgmuaB5jNbOUO5Txrjb85YCNJ8kghbq6BU
         EYk+rMWsn9/inLFdRWhbUdqHNXyI5wrnKZrvrOasvsVPCZSa4WZ+uFDVghgqSJfJWH/C
         /5Bg==
X-Gm-Message-State: AOAM531iC5Y6hQ98XlxjQLNaI5Z9vgp/EhKJ5Xx6+Vz+iGx18veDrvGJ
        qb7n4rHB8EHvD91CJs11JcU=
X-Google-Smtp-Source: ABdhPJy7jCwBbXFP4D4/UnfHFDSYYIloUOQ+dJJ/6Z3CPJSa14jN+5JIHOV72toRWK1PAfPpmHIK2g==
X-Received: by 2002:a05:6a00:10d3:b0:4fe:5d:75c8 with SMTP id d19-20020a056a0010d300b004fe005d75c8mr20115912pfu.6.1649437203829;
        Fri, 08 Apr 2022 10:00:03 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id j24-20020aa78d18000000b0050564584660sm6513479pfe.32.2022.04.08.09.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 10:00:03 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, irusskikh@marvell.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next v3 0/3] net: atlantic: Add XDP support
Date:   Fri,  8 Apr 2022 16:59:47 +0000
Message-Id: <20220408165950.10515-1-ap420073@gmail.com>
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
It can be reused when XDP_DROP, and XDP_ABORTED.

Atlantic driver has AQ_CFG_RX_PAGEORDER option and it will be always 0
if xdp is attached.

LRO will be disabled if XDP program supports only single buffer.

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
    - 4.5Mpps, 80% cpu
  c. xdp_generic, 8 core(hyper thread)
    - 6.3Mpps, 5~10% cpu
  d. xdp_driver, 8 core(hyper thread)
    - 6.3Mpps, 5% cpu

2. XDP_REDIRECT
  a. xdp_generic, single core
    - 2.3Mpps
  b. xdp_driver, single core
    - 4.5Mpps

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
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |   8 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  87 ++++
 .../net/ethernet/aquantia/atlantic/aq_main.h  |   2 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 137 ++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   5 +
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 415 ++++++++++++++++--
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  17 +
 .../net/ethernet/aquantia/atlantic/aq_vec.c   |  23 +-
 .../net/ethernet/aquantia/atlantic/aq_vec.h   |   6 +
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |   6 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  10 +-
 12 files changed, 675 insertions(+), 42 deletions(-)

-- 
2.17.1

