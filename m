Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A0A2B3FE3
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbgKPJfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgKPJfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:35:14 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49586C0613CF;
        Mon, 16 Nov 2020 01:35:12 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id f11so24200040lfs.3;
        Mon, 16 Nov 2020 01:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=phafJMA73+KNOmHJBlDaNagv8vGkjcmIaidHQZjre5g=;
        b=VimgtruRxZPULC4qattrtFlD0286R2FnJ8dcr0wRMQ6KLayA5SXdQjqeZS80CCvkkt
         e9xdAjcBxHLSy8LitTPB/6OQ3gPe+7xfhVPvnr7xNvg57M6DxxpvJCUtlRktvv1rWiFr
         tlPW+C03EQ4J2b4z/y49Uj+VobHVGYHs8jl6sMehtkGJaMTqSa4J2HzaJUZxoehRhX6E
         Og8nk2jfQdqKB/aWeSaTzSEgjp7c+97Y5VUlRwAK8SKggJ58zNSrOEnyExnxhn6XRJkp
         AWJ1UyCBRMfORZ//IlTfIx9raiI1onYeaEZ+Z6O3qxpoWZOq5FnlpctAXpFRFDXLq0nG
         62iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=phafJMA73+KNOmHJBlDaNagv8vGkjcmIaidHQZjre5g=;
        b=TXHV+WXuYslwX/Ej8zWpE7SFkwbJAPdZtSjOhSHX7Tsv5crB9w7dH1ozR4zrlBIltx
         Awc8C1JS8fNIhrkmShZhpbJtYYhRvLQE5JkMCvxMlr+8a5TMiCq/7WlRj+8YrWui/v8w
         lEt2zex4oh87UzJv9aJvCtuty838a+fx2DppeIl5m4m8Ca3f0KJVK8Y0vHD8m9ljJvzf
         GFp9L08isZXQwR+PfK5RVcX2yIkWosEhQigVlNpTtowXd0nfabzNF4lXPZ+lCSDALaRj
         KvBzNwdSv+BgSK60DV0g56AqPHCt5qzENedtKtZTCGup1otgjuhSHS1OHefIV8t7pkhu
         OWFw==
X-Gm-Message-State: AOAM530l1HYKekXOylToMfr/8axPj8YAJDNLTg8qgwGmhNA0VaRMe3ye
        J6JZtusROGA4k8ciV6pS2JE=
X-Google-Smtp-Source: ABdhPJxVqmfN2e4+h/bCRxlDwFEvQCslssey+W3hiVKCreqO4jwBhaQqVcPdVREk+7csPhECbGFrjQ==
X-Received: by 2002:a19:cb8f:: with SMTP id b137mr5193330lfg.448.1605519310761;
        Mon, 16 Nov 2020 01:35:10 -0800 (PST)
Received: from localhost.localdomain (87-205-71-93.adsl.inetia.pl. [87.205.71.93])
        by smtp.gmail.com with ESMTPSA id t26sm2667986lfp.296.2020.11.16.01.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 01:35:10 -0800 (PST)
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
Subject: [PATCH 0/8] New netdev feature flags for XDP
Date:   Mon, 16 Nov 2020 10:34:44 +0100
Message-Id: <20201116093452.7541-1-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.20.1
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
  - bnxt, 
  - dpaa2, 
  - mvmeta, 
  - mvpp2, 
  - qede,
  - sfc, 
  - netsec, 
  - cpsw, 
  - xen, 
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

Marek Majtyka (8):
  net: ethtool: extend netdev_features flag set
  drivers/net: turn XDP flags on
  xsk: add usage of xdp netdev_features flags
  xsk: add check for full support of XDP in bind
  libbpf: extend netlink attribute API
  libbpf: add functions to get XSK modes
  libbpf: add API to get XSK/XDP caps
  samples/bpf/xdp: apply netdev XDP/XSK modes info

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   4 +
 drivers/net/ethernet/intel/igb/igb_main.c     |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   3 +
 drivers/net/ethernet/marvell/mvneta.c         |   1 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   2 +
 drivers/net/ethernet/qlogic/qede/qede_main.c  |   1 +
 drivers/net/ethernet/sfc/efx.c                |   1 +
 drivers/net/ethernet/socionext/netsec.c       |   1 +
 drivers/net/ethernet/ti/cpsw.c                |   2 +
 drivers/net/ethernet/ti/cpsw_new.c            |   2 +
 drivers/net/tun.c                             |   4 +
 drivers/net/veth.c                            |   1 +
 drivers/net/virtio_net.c                      |   1 +
 drivers/net/xen-netfront.c                    |   1 +
 include/linux/netdev_features.h               |   6 +
 include/net/xdp.h                             |  13 +
 include/net/xdp_sock_drv.h                    |  11 +
 include/uapi/linux/if_xdp.h                   |   1 +
 net/ethtool/common.c                          |   2 +
 net/xdp/xsk.c                                 |   4 +-
 net/xdp/xsk_buff_pool.c                       |  21 +-
 samples/bpf/xdpsock_user.c                    | 117 +++++-
 tools/include/uapi/linux/ethtool.h            |  44 ++
 tools/include/uapi/linux/if_xdp.h             |   1 +
 tools/lib/bpf/ethtool.h                       |  49 +++
 tools/lib/bpf/libbpf.h                        |   1 +
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/lib/bpf/netlink.c                       | 379 +++++++++++++++++-
 tools/lib/bpf/nlattr.c                        | 105 +++++
 tools/lib/bpf/nlattr.h                        |  22 +
 tools/lib/bpf/xsk.c                           |  54 ++-
 tools/lib/bpf/xsk.h                           |   3 +-
 36 files changed, 845 insertions(+), 20 deletions(-)
 create mode 100644 tools/lib/bpf/ethtool.h

-- 
2.20.1

