Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E142721CBC2
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgGLWQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgGLWQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:16:34 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F68AC061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:16:34 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x72so5100788pfc.6
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 15:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QTw+jA+ArKpqiqcK8Myn9viOFfEAg24TfEG+S5tlHtA=;
        b=FH+4E+Znqkjhw4PYsO1R/LUSOBBK+PlmLYhoWxz0OQwh/DwDDmDIaKhPz6PmeO7/51
         RqJuXvCvg16PFhAJdJzZnMXWWXDL9Sk2KHjFKAN6SXZMVFf4D5PleRkO8j5RPDDaSQZt
         55pSGj1WA977M4FKFSklWYa0RFwwBWESaeHddvwZxGL/Mt+3W1JKC2cWwfOBsI6jERG+
         Yv6C3ZCDiGZ+CzePwj/Dm2a+QWc3kqEZUPP8355bu/8KqamVVnbQsyX6B73usx0DZ7Dg
         BoO2OLJADXThROFt1j/oWBHjWRxg5l8oJt4liVF5+Pf+oZPxpsQzJSMJMdbB8nzcVcK4
         mg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QTw+jA+ArKpqiqcK8Myn9viOFfEAg24TfEG+S5tlHtA=;
        b=tz9wty6NnzoRKJIQeKPkHgXVAvIzagHpTvEjs7TG6SzNANcG7CFt8ogOjvmrtMo1cw
         F+eHevXiJ1zoKBdC0QJq+61fjD+WAWsul30z2Nkw3NQ0zUppyUYYC89SDGt7iklwMnCg
         lthgUgfw2I02IKtfjo0OyJFRhkmm0np8CNjafVpoDoAxTc59gk8nBYPtnc4/OmpFkmhW
         I4wNhaKepyDTnSTzDt4dz6/4F9UQr919E/yiI2ozHILH7wVPFqpmwWyArXCSEiugVUe7
         IxBqgrZuZFyl8QCx1Kjcm4+SLl2CjesCv8PjjCYFyC+rYvv4LUmNQ3XzCfGm6njm4N3N
         twdQ==
X-Gm-Message-State: AOAM531mjqVp4IMzvIywLNvQDB1hpXcHmOsCUTvIIXGFq0qzD0RefXnU
        z4POQwE0HeRNDGE6xqLnblx3ezEu
X-Google-Smtp-Source: ABdhPJz4cAtK6idOjLyhZyFpHDD0aH0zF16l/qWQ6gqdCLGivzaqbbcjEcTsGGjefYMHVF5y6fNVTA==
X-Received: by 2002:a63:924b:: with SMTP id s11mr64548286pgn.74.1594592193063;
        Sun, 12 Jul 2020 15:16:33 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y198sm12470228pfg.116.2020.07.12.15.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 15:16:31 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, mkubecek@suse.cz, kuba@kernel.org,
        davem@davemloft.net
Subject: [PATCH net-next 0/3] net: Preserve netdev_ops equality tests
Date:   Sun, 12 Jul 2020 15:16:22 -0700
Message-Id: <20200712221625.287763-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

This patch series addresses a long standing with no known impact today
with the overloading of netdev_ops done by the DSA layer.

First we introduce a ndo_equal netdev_ops function pointer, then we have
DSA utilize it, and finally all in tree users are converted to using
either netdev_ops_equal() or __netdev_ops_equal() (for const struct
net_device reference).

I did my best to build test each driver being changed here.

A coccinelle script will be submitted later on when it works with the
coccicheck target integration.

Florian Fainelli (3):
  net: Introduce netdev_ops_equal
  net: dsa: Implement ndo_equal for CPU port net_device
  net: treewide: Convert to netdev_ops_equal()

 drivers/net/ethernet/broadcom/bcmsysport.c    |  4 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  2 +-
 .../net/ethernet/cavium/liquidio/lio_vf_rep.c |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  4 +--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  2 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.h |  2 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  2 +-
 drivers/net/ethernet/sfc/efx.c                |  2 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  2 +-
 drivers/net/ethernet/via/via-velocity.c       |  2 +-
 drivers/net/gtp.c                             |  2 +-
 drivers/net/hyperv/netvsc_drv.c               |  4 +--
 drivers/net/ipvlan/ipvlan_main.c              |  2 +-
 drivers/net/ppp/ppp_generic.c                 |  2 +-
 drivers/net/team/team.c                       |  2 +-
 drivers/net/tun.c                             |  4 +--
 .../broadcom/brcm80211/brcmfmac/core.c        |  4 +--
 drivers/net/wireless/quantenna/qtnfmac/core.c |  2 +-
 drivers/s390/net/qeth_l3_main.c               |  4 +--
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |  2 +-
 .../staging/unisys/visornic/visornic_main.c   |  2 +-
 include/linux/netdevice.h                     | 26 +++++++++++++++++++
 net/atm/clip.c                                |  2 +-
 net/dsa/master.c                              |  9 +++++++
 net/dsa/slave.c                               |  2 +-
 net/openvswitch/vport-internal_dev.c          |  4 +--
 net/openvswitch/vport-internal_dev.h          |  2 +-
 33 files changed, 73 insertions(+), 38 deletions(-)

-- 
2.25.1

