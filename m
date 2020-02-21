Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3421679FC
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgBUJ4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:56:49 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:52141 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbgBUJ4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:56:48 -0500
Received: by mail-wm1-f47.google.com with SMTP id t23so1032114wmi.1
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tu9UBgcN0MT+G2SG64rVKy0R6Z70GV0DH6Oo847J2GE=;
        b=uzz47gBWYWgROTNQH8wU/uZSnWPuPT0kV/cyNiiWRU7IKNFsvVPEYSMr+0/EmD8kY7
         dMls6cmNxv2maGsme+SUwsHGicOORFOSY2Y/AZooWZAGDf9Oevq4dnlnD2mufnIaMnQw
         x7jcR27b+r3zoi9bhO1CJLsCe4MAU9HjZXF5ybqcA//Dy5JXJb8SB51K6Pw915TtXkB6
         WENgMXTLkm+CUmWEjPSuUxpDknmPcf0D1WXGpowdgbioRlmIEStHMxBll3h0bPZD+Smp
         Q1Z/gn2oNSVwLUYrK9bQ0QKy7lUO3L2JVG9M+9598B+rRAIMmHQUVKrBmXSf2pFirN3v
         38QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tu9UBgcN0MT+G2SG64rVKy0R6Z70GV0DH6Oo847J2GE=;
        b=uAHZJvfiu8gLfM7Ivpsbwky8gTZVvtNj1Rx2G6byXZ0MTsljX848T6oAL7W2BV6Fn1
         3rpLxRMBZiljIKMEUpHLXGcv1Rwh1t72B3Os9cPUTeBTH0ZWN9zsT1e6mxsR9Gikazu7
         lqwcVuoN1RrQilYoLIS3Mq5VIcpYqADKwvWP4TUc3doCNaBHYbBAY+1i6l7NsVMjB6Gn
         bciYodfaBvJutYYSx5krzai5gmz9IyY3nWTKa9Flwba51TcYD6UkGKBzzZuESRlvb57Y
         8f3jNFXHBI6iYkgX5LZNdR9vhmIgE+PEL/w/eWzAXLFwQqP1worlkeU+LeOggS+/DOxj
         9dzg==
X-Gm-Message-State: APjAAAWowgcq3sNnlpgcquVyvxuNep6flN7QcyQfoRApIyjLrsckrMsc
        JQ7DQ1DGde+1dKCjXg361jsAc9DY2+Q=
X-Google-Smtp-Source: APXvYqzokEtKQz4YFjnvPrKXAIDtiYMigLV/V13Ej/QWahDvaoHup1QZu1e7MXD4lI8J90Xl9kLixg==
X-Received: by 2002:a05:600c:2207:: with SMTP id z7mr2630232wml.167.1582279004334;
        Fri, 21 Feb 2020 01:56:44 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id c77sm3163703wmd.12.2020.02.21.01.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 01:56:43 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: [patch net-next 00/10] net: allow user specify TC filter HW stats type
Date:   Fri, 21 Feb 2020 10:56:33 +0100
Message-Id: <20200221095643.6642-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently, when user adds a TC filter and the filter gets offloaded,
the user expects the HW stats to be counted and included in stats dump.
However, since drivers may implement different types of counting, there
is no way to specify which one the user is interested in.

For example for mlx5, only delayed counters are available as the driver
periodically polls for updated stats.

In case of mlxsw, the counters are queried on dump time. However, the
HW resources for this type of counters is quite limited (couple of
thousands). This limits the amount of supported offloaded filters
significantly. Without counter assigned, the HW is capable to carry
millions of those.

On top of that, mlxsw HW is able to support delayed counters as well in
greater numbers. That is going to be added in a follow-up patch.

This patchset allows user to specify one of the following types of HW
stats for added fitler:
any - current default, user does not care about the type, just expects
      any type of stats.
immediate - queried during dump time
delayed - polled from HW periodically or sent by HW in async manner
disabled - no stats needed

Examples:
$ tc filter add dev enp0s16np28 ingress proto ip handle 1 pref 1 flower hw_stats disabled dst_ip 192.168.1.1 action drop
$ tc -s filter show dev enp0s16np28 ingress
filter protocol ip pref 1 flower chain 0 
filter protocol ip pref 1 flower chain 0 handle 0x1 
  eth_type ipv4
  dst_ip 192.168.1.1
  in_hw in_hw_count 2
  hw_stats disabled
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 10 sec used 2 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
        backlog 0b 0p requeues 0

$ tc filter add dev enp0s16np28 ingress proto ip handle 1 pref 1 flower hw_stats immediate dst_ip 192.168.1.1 action drop
$ tc -s filter show dev enp0s16np28 ingress
filter protocol ip pref 1 flower chain 0 
filter protocol ip pref 1 flower chain 0 handle 0x1 
  eth_type ipv4
  dst_ip 192.168.1.1
  in_hw in_hw_count 2
  hw_stats immediate
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 14 sec used 7 sec
        Action statistics:
        Sent 102 bytes 1 pkt (dropped 1, overlimits 0 requeues 0) 
        Sent software 0 bytes 0 pkt
        Sent hardware 102 bytes 1 pkt
        backlog 0b 0p requeues 0

Jiri Pirko (10):
  net: rename tc_cls_can_offload_and_chain0() to
    tc_cls_can_offload_basic()
  iavf: use tc_cls_can_offload_basic() instead of chain check
  flow_offload: Introduce offload of HW stats type
  net: extend tc_cls_can_offload_basic() to check HW stats type
  mlx5: restrict supported HW stats type to "any"
  mlxsw: restrict supported HW stats type to "any"
  flow_offload: introduce "immediate" HW stats type and allow it in
    mlxsw
  flow_offload: introduce "delayed" HW stats type and allow it in mlx5
  flow_offload: introduce "disabled" HW stats type and allow it in mlxsw
  sched: cls_flower: allow user to specify type of HW stats for a filter

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  8 ++--
 drivers/net/ethernet/intel/igb/igb_main.c     |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  8 +++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  3 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 31 +++++++++++-----
 drivers/net/ethernet/mscc/ocelot_flower.c     |  2 +-
 drivers/net/ethernet/mscc/ocelot_tc.c         |  2 +-
 drivers/net/ethernet/netronome/nfp/abm/cls.c  |  2 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.c |  2 +-
 .../ethernet/netronome/nfp/flower/offload.c   |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +-
 drivers/net/netdevsim/bpf.c                   |  2 +-
 include/net/flow_offload.h                    |  8 ++++
 include/net/pkt_cls.h                         | 37 ++++++++++++++++++-
 include/uapi/linux/pkt_cls.h                  | 27 ++++++++++++++
 net/sched/cls_flower.c                        | 12 ++++++
 22 files changed, 132 insertions(+), 32 deletions(-)

-- 
2.21.1

