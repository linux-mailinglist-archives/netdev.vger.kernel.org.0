Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8E25B18D4
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiIHJgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiIHJgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:36:14 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09171113C43;
        Thu,  8 Sep 2022 02:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662629771; x=1694165771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B8K38Uejd1kJxA9v/2p4IJIfmLlbBwgR3JRQVKaLcjA=;
  b=nQj/7kV4doPvpof4/dVi8DJtcDi5pEN7YvtnI+Uvn0ye9bPu4IrEYXpd
   9/LfKgAlF1N8mNaVMyiD1/717w6BxMn+M5sdgiURj4D2bfx+l+Sib+hhl
   T7uM36KtgytchHsrWnYunPhXpCO+zOi5wjl65n5Bxow3RBpJqbKgup87w
   /d3h+k42vZrARICTmH6TgHmNYQv+CZuAbJkSBMIGnmRePJUzIW1gx5e2V
   qRPKXC3bPFnJNYEH/PhI73nIEhLOlvthGGl+wgn9lXAzVHi1tNIjPAY5o
   Lm3o3rZfVBw6ZuzUGyjBIosZPmhpZWvtVr5sZncxz5GwOhGUMYONpI78m
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="298460234"
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="298460234"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 02:36:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="740613366"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 08 Sep 2022 02:36:01 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2889a0Yh022113;
        Thu, 8 Sep 2022 10:36:00 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Subject: Re: [xdp-hints] [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW offload hints via BTF
Date:   Thu,  8 Sep 2022 11:30:43 +0200
Message-Id: <20220908093043.274201-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Wed, 07 Sep 2022 17:45:00 +0200

> This patchset expose the traditional hardware offload hints to XDP and
> rely on BTF to expose the layout to users.
> 
> Main idea is that the kernel and NIC drivers simply defines the struct
> layouts they choose to use for XDP-hints. These XDP-hints structs gets
> naturally and automatically described via BTF and implicitly exported to
> users. NIC drivers populate and records their own BTF ID as the last
> member in XDP metadata area (making it easily accessible by AF_XDP
> userspace at a known negative offset from packet data start).
> 
> Naming conventions for the structs (xdp_hints_*) is used such that
> userspace can find and decode the BTF layout and match against the
> provided BTF IDs. Thus, no new UAPI interfaces are needed for exporting
> what XDP-hints a driver supports.
> 
> The patch "i40e: Add xdp_hints_union" introduce the idea of creating a
> union named "xdp_hints_union" in every driver, which contains all
> xdp_hints_* struct this driver can support. This makes it easier/quicker
> to find and parse the relevant BTF types.  (Seeking input before fixing
> up all drivers in patchset).
> 
> 
> The main different from RFC-v1:
>  - Drop idea of BTF "origin" (vmlinux, module or local)
>  - Instead to use full 64-bit BTF ID that combine object+type ID
> 
> I've taken some of Alexandr/Larysa's libbpf patches and integrated
> those.

Not sure if it's okay to inform the authors about the fact only
after sending? Esp from the eeeh... "incompatible" implementation?
I realize it's open code, but this looks sorta depreciatingly.

> 
> Patchset exceeds netdev usually max 15 patches rule. My excuse is three
> NIC drivers (i40e, ixgbe and mvneta) gets XDP-hints support and which
> required some refactoring to remove the SKB dependencies.
> 
> 
> ---
> 
> Jesper Dangaard Brouer (10):
>       net: create xdp_hints_common and set functions
>       net: add net_device feature flag for XDP-hints
>       xdp: controlling XDP-hints from BPF-prog via helper
>       i40e: Refactor i40e_ptp_rx_hwtstamp
>       i40e: refactor i40e_rx_checksum with helper
>       bpf: export btf functions for modules
>       btf: Add helper for kernel modules to lookup full BTF ID
>       i40e: add XDP-hints handling
>       net: use XDP-hints in xdp_frame to SKB conversion
>       i40e: Add xdp_hints_union
> 
> Larysa Zaremba (3):
>       libbpf: factor out BTF loading from load_module_btfs()
>       libbpf: try to load vmlinux BTF from the kernel first
>       libbpf: patch module BTF obj+type ID into BPF insns
> 
> Lorenzo Bianconi (1):
>       mvneta: add XDP-hints support
> 
> Maryam Tahhan (4):
>       ixgbe: enable xdp-hints
>       ixgbe: add rx timestamp xdp hints support
>       xsk: AF_XDP xdp-hints support in desc options
>       ixgbe: AF_XDP xdp-hints processing in ixgbe_clean_rx_irq_zc
> 
> 
>  drivers/net/ethernet/intel/i40e/i40e.h        |   1 +
>  drivers/net/ethernet/intel/i40e/i40e_main.c   |  22 ++
>  drivers/net/ethernet/intel/i40e/i40e_ptp.c    |  36 ++-
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 252 ++++++++++++++---
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   5 +
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 217 +++++++++++++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  |  82 ++++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |   2 +
>  drivers/net/ethernet/marvell/mvneta.c         |  59 +++-
>  include/linux/btf.h                           |   3 +
>  include/linux/netdev_features.h               |   3 +-
>  include/net/xdp.h                             | 256 +++++++++++++++++-
>  include/uapi/linux/bpf.h                      |  35 +++
>  include/uapi/linux/if_xdp.h                   |   2 +-
>  kernel/bpf/btf.c                              |  36 ++-
>  net/core/filter.c                             |  52 ++++
>  net/core/xdp.c                                |  22 +-
>  net/ethtool/common.c                          |   1 +
>  net/xdp/xsk.c                                 |   2 +-
>  net/xdp/xsk_queue.h                           |   3 +-
>  tools/lib/bpf/bpf_core_read.h                 |   3 +-
>  tools/lib/bpf/btf.c                           | 142 +++++++++-
>  tools/lib/bpf/libbpf.c                        |  52 +---
>  tools/lib/bpf/libbpf_internal.h               |   7 +-
>  tools/lib/bpf/relo_core.c                     |   8 +-
>  tools/lib/bpf/relo_core.h                     |   1 +
>  26 files changed, 1127 insertions(+), 177 deletions(-)
> 
> --

Olek
