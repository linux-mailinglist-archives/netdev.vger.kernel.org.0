Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542991DAF2B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgETJsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 05:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETJsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 05:48:04 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E684C061A0E;
        Wed, 20 May 2020 02:48:04 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d3so1109525pln.1;
        Wed, 20 May 2020 02:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9dJe2oHyvoiR+fTCA0j6ZOhuiiAtyg/FZcYMXKy0ro8=;
        b=KcQNn+UoMqWLrUprQnDSqx4iFGnIWilqL9Yn9UPcdySoIWLIcklhUke9DgT89/SLG1
         95kiFhCK5gaUS4nY8z/nG0SQh9Q6JYTIILiMWwd8ehOjNpbP3zFZ8F1ervDRcG/hcJK5
         DYApbaoXU4CU5gUvybcHlM9QcJju7Rv1iNWe3eAczP7HJOx0xNb/FJ7RFgT0bPa/TKYp
         Yll1KDvDzf8WpQ+CGnWr5Z6GNbkUeG5LBsXZ9wAPy464TtVCnxH+ktSGha+4PQi8Hrgp
         OvUM9xYNcvWfTJmoh8Ndt8JX7v0ht84G42JXZuq7yaa1oN8zY9XpO1Jbux2pjTYuTLKP
         PQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9dJe2oHyvoiR+fTCA0j6ZOhuiiAtyg/FZcYMXKy0ro8=;
        b=ZEoqaVYhk3q1R6YhEm9mU7LNbb/3T2KJPLcvpjt8zswGU8ROAe+lDw6gzlaYIXAUbc
         7cqcgaEyv1m0iKYJg8zYjl7VY0ucPAWfrt3rYC/HNj1BMJIX7CKoS8VpEZzeJleabYOV
         fVqfP4uHWFyPNelhm4NkYDphzCsobU5XjDG9JkInbLju1e0oqM2cm82FYzM4Ri5ALZ1Z
         SJrH59MEWPChpf5nMTpRMOL7wPZc+QdRl3afnHpLeGs/Ify2M/7H7EHW+o0fUw+wO6Ft
         nVLtS5ZE7olHugLZKZG2Z38yLzYlut6lKN1YIye8cCg5Jj5PBLpE65MtQ24BVwTF3ap6
         EqLQ==
X-Gm-Message-State: AOAM532VGv/IY29YTGwpfrnr1caoEXQXP5aVI68RkJoGuibgPOXwj5ip
        IrZge9y94ycliXuO38CTrfqXJOiQLyOsgMqh
X-Google-Smtp-Source: ABdhPJxWlJbDm8DCHL0E2oVngabUrzM2a95rNHSG2GKOHr2F0aicwRuzulAMsPRbLaeqnt7gE7Ic/Q==
X-Received: by 2002:a17:90a:23e7:: with SMTP id g94mr4060527pje.210.1589968083035;
        Wed, 20 May 2020 02:48:03 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id c124sm1707494pfb.187.2020.05.20.02.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 02:48:02 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        bjorn.topel@intel.com
Subject: [PATCH bpf-next v4 00/15] Introduce AF_XDP buffer allocation API
Date:   Wed, 20 May 2020 11:47:27 +0200
Message-Id: <20200520094742.337678-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Overview
========

Driver adoption for AF_XDP has been slow. The amount of code required
to proper support AF_XDP is substantial and the driver/core APIs are
vague or even non-existing. Drivers have to manually adjust data
offsets, updating AF_XDP handles differently for different modes
(aligned/unaligned).

This series attempts to improve the situation by introducing an AF_XDP
buffer allocation API. The implementation is based on a single core
(single producer/consumer) buffer pool for the AF_XDP UMEM.
    
A buffer is allocated using the xsk_buff_alloc() function, and
returned using xsk_buff_free(). If a buffer is disassociated with the
pool, e.g. when a buffer is passed to an AF_XDP socket, a buffer is
said to be released. Currently, the release function is only used by
the AF_XDP internals and not visible to the driver.
    
Drivers using this API should register the XDP memory model with the
new MEM_TYPE_XSK_BUFF_POOL type, which will supersede the
MEM_TYPE_ZERO_COPY type.

The buffer type is struct xdp_buff, and follows the lifetime of
regular xdp_buffs, i.e.  the lifetime of an xdp_buff is restricted to
a NAPI context. In other words, the API is not replacing xdp_frames.

DMA mapping/synching is folded into the buffer handling as well.

@JeffK The Intel drivers changes should go through the bpf-next tree,
       and not your regular Intel tree, since multiple (non-Intel)
       drivers are affected.

The outline of the series is as following:

Patch 1 is a fix for xsk_umem_xdp_frame_sz().

Patch 2 to 4 are restructures/clean ups. The XSKMAP implementation is
moved to net/xdp/. Functions/defines/enums that are only used by the
AF_XDP internals are moved from the global include/net/xdp_sock.h to
net/xdp/xsk.h. We are also introducing a new "driver include file",
include/net/xdp_sock_drv.h, which is the only file NIC driver
developers adding AF_XDP zero-copy support should care about.

Patch 5 adds the new API, and migrates the "copy-mode"/skb-mode AF_XDP
path to the new API.

Patch 6 to 11 migrates the existing zero-copy drivers to the new API.

Patch 12 removes the MEM_TYPE_ZERO_COPY memory type, and the "handle"
member of struct xdp_buff.

Patch 13 simplifies the xdp_return_{frame,frame_rx_napi,buff}
functions.

Patch 14 is a performance patch, where some functions are inlined.

Finally, patch 15 updates the MAINTAINERS file to correctly mirror the
new file layout.

Note that this series removes the "handle" member from struct
xdp_buff, which reduces the xdp_buff size.

After this series, the diff stat of drivers/net/ is:

 
This series is a first step of simplifying the driver side of
AF_XDP. I think more of the AF_XDP logic can be moved from the drivers
to the AF_XDP core, e.g. the "need wakeup" set/clear functionality.

Statistics when allocation fails can now be added to the socket
statistics via the XDP_STATISTICS getsockopt(). This will be added in
a follow up series.


Performance
===========

As a nice side effect, performance is up a bit as well.

  * i40e: 3% higher pps for rxdrop, zero-copy, aligned and unaligned
    (40 GbE, 64B packets).
  * mlx5: RX +0.8 Mpps, TX +0.4 Mpps


Changelog
=========

v3->v4:
    * i40e: Made i40e_fd_handle_status() static. (kbuild test robot)
    * mlx5: Remove unused variable num_xsk_frames. (Jakub)

v2->v3: 
  * Added xsk_umem_xdp_frame_sz() fix to the series. (Björn)
  * Initialize struct xdp_buff member frame_sz. (Björn)
  * Add API to query the DMA address of a frame. (Maxim)
  * Do DMA sync for CPU till the end of the frame to handle possible
    growth (frame_sz). (Maxim)
  * mlx5: Handle frame_sz, use xsk_buff_xdp_get_frame_dma, use
    xsk_buff API for DMA sync on TX, add performance numbers. (Maxim)

v1->v2: 
  * mlx5: Fix DMA address handling, set XDP metadata to invalid. (Maxim)
  * ixgbe: Fixed xdp_buff data_end update. (Björn)
  * Swapped SoBs in patch 4. (Maxim)

rfc->v1:
  * Fixed build errors/warnings for m68k and riscv. (kbuild test
    robot)
  * Added headroom/chunk size getter. (Maxim/Björn)
  * mlx5: Put back the sanity check for XSK params, use XSK API to get
    the total headroom size. (Maxim)
  * Fixed spelling in commit message. (Björn)
  * Make sure xp_validate_desc() is inlined for Tx perf. (Maxim)
  * Sorted file entries. (Joe)
  * Added xdp_return_{frame,frame_rx_napi,buff} simplification (Björn)

Thanks for all the comments/input/help!


Cheers,
Björn

Björn Töpel (14):
  xsk: fix xsk_umem_xdp_frame_sz()
  xsk: move xskmap.c to net/xdp/
  xsk: move defines only used by AF_XDP internals to xsk.h
  xsk: introduce AF_XDP buffer allocation API
  i40e: refactor rx_bi accesses
  i40e: separate kernel allocated rx_bi rings from AF_XDP rings
  i40e, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
  ice, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
  ixgbe, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
  mlx5, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
  xsk: remove MEM_TYPE_ZERO_COPY and corresponding code
  xdp: simplify xdp_return_{frame,frame_rx_napi,buff}
  xsk: explicitly inline functions and move definitions
  MAINTAINERS, xsk: update AF_XDP section after moves/adds

Magnus Karlsson (1):
  xsk: move driver interface to xdp_sock_drv.h

 MAINTAINERS                                   |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  28 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 134 +++----
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  17 +-
 .../ethernet/intel/i40e/i40e_txrx_common.h    |  40 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 378 +++---------------
 drivers/net/ethernet/intel/i40e/i40e_xsk.h    |   3 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  16 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   8 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 376 ++---------------
 drivers/net/ethernet/intel/ice/ice_xsk.h      |  13 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   9 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  15 +-
 .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 309 +++-----------
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   7 +-
 .../ethernet/mellanox/mlx5/core/en/params.c   |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  33 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 113 +-----
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  25 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |   9 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.h   |   2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.c |  51 +--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  25 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  34 +-
 drivers/net/hyperv/netvsc_bpf.c               |   1 -
 include/net/xdp.h                             |   9 +-
 include/net/xdp_sock.h                        | 287 +------------
 include/net/xdp_sock_drv.h                    | 232 +++++++++++
 include/net/xsk_buff_pool.h                   | 140 +++++++
 include/trace/events/xdp.h                    |   2 +-
 kernel/bpf/Makefile                           |   3 -
 net/core/xdp.c                                |  51 +--
 net/ethtool/channels.c                        |   2 +-
 net/ethtool/ioctl.c                           |   2 +-
 net/xdp/Makefile                              |   3 +-
 net/xdp/xdp_umem.c                            |  55 +--
 net/xdp/xdp_umem.h                            |   2 +-
 net/xdp/xsk.c                                 | 204 ++++------
 net/xdp/xsk.h                                 |  30 ++
 net/xdp/xsk_buff_pool.c                       | 336 ++++++++++++++++
 net/xdp/xsk_diag.c                            |   2 +-
 net/xdp/xsk_queue.c                           |  62 ---
 net/xdp/xsk_queue.h                           | 117 ++----
 {kernel/bpf => net/xdp}/xskmap.c              |   2 +
 47 files changed, 1278 insertions(+), 1937 deletions(-)
 create mode 100644 include/net/xdp_sock_drv.h
 create mode 100644 include/net/xsk_buff_pool.h
 create mode 100644 net/xdp/xsk_buff_pool.c
 rename {kernel/bpf => net/xdp}/xskmap.c (99%)


base-commit: dda18a5c0b75461d1ed228f80b59c67434b8d601
-- 
2.25.1

