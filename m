Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A272CEC3D
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 11:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgLDKaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 05:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgLDKaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 05:30:39 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5E8C0613D1;
        Fri,  4 Dec 2020 02:29:59 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id s9so5985930ljo.11;
        Fri, 04 Dec 2020 02:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=So8nR/+TGOHKI8YuGPoCpAuJbgXY1+7Z6aKdtfAcFRs=;
        b=aJR/VMmcsWYVZOQD4ndCpzEUaMvKQnZGCRIe/JmGPbpOmT3hVOVYoy8Kp4NLuwG1/X
         oYIM8zSHpYPvyRC3n9QJFIbxj74IrvZACRHpIs65+ms63Ce6UJVvgZee45AB1ybyTFFC
         puD3GSKvXm1+UcZ+e5TL9AwmPMpJz8Cwz0/jOL3cbmeEU4choM1EEl041tJs/i2/TjJW
         3Qcn+zTid6JC0bEz7LRa62Jt2EnlX4aekHk/ntoFLGd1hYGWAi1iks2nXJUWMxewtAmA
         o5LDAjOYjZn2HK3IsUn4p1nYiVIAx5aNvPeVlZgClge2Z2aa0laim+B/QlXZDtJodvsS
         Ms4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=So8nR/+TGOHKI8YuGPoCpAuJbgXY1+7Z6aKdtfAcFRs=;
        b=rPFDboyi2121x81fpqaoulgmuIcfvDqrckuSXGTSh1h59Riezr82GgAs0CQh+mp458
         IFmypOt+lPGnA3HEEzBVEKY7MDUVDyt+LOFn8MYKhVFJwlBc17bLcDIHichAEdf3fK9+
         2PX/qchpjvhx8Zq5/ef9tTTLkN5QrCCMcqyB6S05NvFVGtiLtKhKyj6useyMERFQCYXW
         zBF8LJXatPmsiVzwAv8jogKj5nyfv93PXotPEUYK6Ak0QYX6tNxvF4OwSP3PJis2ZjGO
         S/3XUoMxTuHrgvelPFrz3pRY9izhWEzrgC3LBHEAncW4030Mf5XurDjvtYfr6gXtBVx3
         R+4A==
X-Gm-Message-State: AOAM5308oNbIAE3tWwvDQ0H7VWGmltT0WphmnEBCbtQ+hAxemB56v9eT
        VimCdr2CKQht59z9T0r1TRc=
X-Google-Smtp-Source: ABdhPJwCkpGmh1eFASP0RSM302qX2ny3ITLPlqR8xshLeF7KBQx5UWSO2wPReK01NvP9zJCD4pYJwQ==
X-Received: by 2002:a2e:9718:: with SMTP id r24mr3253682lji.20.1607077797549;
        Fri, 04 Dec 2020 02:29:57 -0800 (PST)
Received: from localhost.localdomain (87-205-71-93.adsl.inetia.pl. [87.205.71.93])
        by smtp.gmail.com with ESMTPSA id d9sm62738lfj.228.2020.12.04.02.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 02:29:56 -0800 (PST)
From:   alardam@gmail.com
X-Google-Original-From: marekx.majtyka@intel.com
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        andrii.nakryiko@gmail.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org, toke@redhat.com
Cc:     maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: [PATCH v2 bpf 0/5] New netdev feature flags for XDP
Date:   Fri,  4 Dec 2020 11:28:56 +0100
Message-Id: <20201204102901.109709-1-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <marekx.majtyka@intel.com>

Implement support for checking if a netdev has native XDP and AF_XDP zero
copy support. Previously, there was no way to do this other than to try
to create an AF_XDP socket on the interface or load an XDP program and
see if it worked. This commit changes this by extending existing
netdev_features in the following way:
 * xdp        - full XDP support (XDP_{TX, PASS, DROP, ABORT, REDIRECT})
 * af-xdp-zc  - AF_XDP zero copy support
NICs supporting these features are updated by turning the corresponding
netdev feature flags on.

NOTE:
 Only the compilation check was performed for:
  - ice, 
  - igb,
  - mlx5, 
  - mlx4.
  - bnxt, 
  - dpaa2, 
  - mvmeta, 
  - mvpp2, 
  - qede,
  - sfc, 
  - netsec, 
  - cpsw, 
  - xen, 
  - netronome
  - ena
  - virtio_net.

Libbpf library is extended in order to provide a simple API for gathering
information about XDP supported capabilities of a netdev. This API
utilizes netlink interface towards kernel. With this function it is
possible to get xsk supported options for netdev beforehand.
The new API is used in core xsk code as well as in the xdpsock sample.

These new flags also solve the problem with strict recognition of zero
copy support. The problem is that there are drivers out there that only
support XDP partially, so it is possible to successfully load the XDP
program in native mode, but it will still not be able to support zero-copy
as it does not have XDP_REDIRECT support. With af-xdp-zc flag the check
is possible and trivial.

Changes since v1:
 * Replace netdev_feature flags variable with a bitmap of XDP-specific
   properties. New kernel and uapi interfaces are added to handle access
   to the XDP netdev properties bitmap. [Toke]

 * Set more fine grained XPD properties for netdevs when necessary. [Toke]

 * Extend ethtool netlink interface in order to get access to the XDP
   bitmap (XDP_PROPERTIES_GET). [Toke]

 * Removed the libbpf patches for now.
---
Marek Majtyka (5):
  net: ethtool: add xdp properties flag set
  drivers/net: turn XDP properties on
  xsk: add usage of xdp properties flags
  xsk: add check for full support of XDP in bind
  ethtool: provide xdp info with XDP_PROPERTIES_GET

 .../networking/netdev-xdp-properties.rst      | 42 ++++++++
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  3 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  4 +
 drivers/net/ethernet/intel/igb/igb_main.c     |  2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  3 +
 drivers/net/ethernet/marvell/mvneta.c         |  3 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  3 +
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |  5 +
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  2 +
 drivers/net/ethernet/sfc/efx.c                |  2 +
 drivers/net/ethernet/socionext/netsec.c       |  2 +
 drivers/net/ethernet/ti/cpsw.c                |  3 +
 drivers/net/ethernet/ti/cpsw_new.c            |  2 +
 drivers/net/tun.c                             |  4 +
 drivers/net/veth.c                            |  2 +
 drivers/net/virtio_net.c                      |  2 +
 drivers/net/xen-netfront.c                    |  2 +
 include/linux/netdevice.h                     |  2 +
 include/linux/xdp_properties.h                | 53 +++++++++++
 include/net/xdp.h                             | 95 +++++++++++++++++++
 include/net/xdp_sock_drv.h                    | 10 ++
 include/uapi/linux/ethtool.h                  |  1 +
 include/uapi/linux/ethtool_netlink.h          | 14 +++
 include/uapi/linux/if_xdp.h                   |  1 +
 include/uapi/linux/xdp_properties.h           | 32 +++++++
 net/ethtool/Makefile                          |  2 +-
 net/ethtool/common.c                          | 11 +++
 net/ethtool/common.h                          |  4 +
 net/ethtool/netlink.c                         | 38 +++++---
 net/ethtool/netlink.h                         |  2 +
 net/ethtool/strset.c                          |  5 +
 net/ethtool/xdp.c                             | 76 +++++++++++++++
 net/xdp/xsk.c                                 |  4 +-
 net/xdp/xsk_buff_pool.c                       | 20 +++-
 tools/include/uapi/linux/if_xdp.h             |  1 +
 tools/lib/bpf/xsk.c                           |  3 +
 41 files changed, 449 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/networking/netdev-xdp-properties.rst
 create mode 100644 include/linux/xdp_properties.h
 create mode 100644 include/uapi/linux/xdp_properties.h
 create mode 100644 net/ethtool/xdp.c


base-commit: eceae70bdeaeb6b8ceb662983cf663ff352fbc96
-- 
2.27.0

