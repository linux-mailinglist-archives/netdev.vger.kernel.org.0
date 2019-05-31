Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E2A30BDC
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfEaJmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:42:37 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42774 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfEaJmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 05:42:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id r22so5861523pfh.9;
        Fri, 31 May 2019 02:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u1q9TZNLu1Y4vVAKPL9nLxJ9PhZmOg6mX9+0aK52ux0=;
        b=eA/LgEhX8JN3JWLd6aqHhxm6PJzfFUsrVgUZv/urb+RzVBnA2e+fDEptjyfMKEbrtG
         Em/t9VZrfFcItqOd52m4TbltN2ELebBRKoMoUJYWrKMK3s87+g5936XvTFWgRovAkNHH
         3hqoQ9THo19H3txepUBCeumwevn4vmGTb/DkeJuvp+BxLDCB16lB0ptsCqqKa+c96qHJ
         8IGr6vu7T8YW49lEqIx7VEWRtTWaGX8VzGckbv9BjQB+jwQnVeDROXQbHdwRRdsQPYRM
         M6vpb+q056oaYp52PLESljWd8N6C4U5rW4CU5BT4UQ9HSYARejscVKfRlOwGJsRW2BIA
         hjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u1q9TZNLu1Y4vVAKPL9nLxJ9PhZmOg6mX9+0aK52ux0=;
        b=Ihux+Z17BwkO5UqXsUwch4UenYVetuBVNy4rtNK0NjHLDpdHy0WiR32rQWkO2HGMiW
         BCoqC38F3UglWOh7kbR+zCC3yBXygHqe+3Vy1FzvAF5dDgdhPxqEuUV8StMIj7xL5Dyj
         H6eeyHlEUz7LQK2lKNBzhHzIG7qpPmjz3EUXMY6kCWDSVcPFGhPzx8igzHiQF0alwSM1
         XGBNgixE1GmytVPHlx9tUfczemnOL2Du32Az1yzZKp82wHISlo8hoTnxFxisRiON9KNv
         tYgpWDgT6OHPjVqXh/4mTKN9IOcfxUNMGAnenoqEFRlK8/BrZs27O0crTdToiQCu+/Ue
         GOHw==
X-Gm-Message-State: APjAAAUak99dk2U6NW82idadQLgqqAcKxkTacTM36EYBFFd7xa6lRTzX
        NPxQU8LZlplAHlYfwZTq2bVxX1xyHPHOIg==
X-Google-Smtp-Source: APXvYqwH2eny7mBVI5q2mEA4y2nB0zY3VxgFjf4YayEppGGcinAaw3JGHTl4WfbPMguhdcwjkWDXQw==
X-Received: by 2002:aa7:81ca:: with SMTP id c10mr8783734pfn.163.1559295756379;
        Fri, 31 May 2019 02:42:36 -0700 (PDT)
Received: from btopel-mobl.isw.intel.com ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id e4sm4887936pgi.80.2019.05.31.02.42.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 02:42:35 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     toke@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        brouer@redhat.com, bpf@vger.kernel.org,
        jakub.kicinski@netronome.com, saeedm@mellanox.com
Subject: [PATCH bpf-next v2 0/2] net: xdp: refactor the XDP_QUERY_PROG and XDP_QUERY_PROG_HW code
Date:   Fri, 31 May 2019 11:42:13 +0200
Message-Id: <20190531094215.3729-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's yet another attempt tomove the XDP_QUERY_PROG{,_HW} code out
from the drivers to generic netdev code.

The first patch in the series move the XDP query functionality, and
the second remove XDP_QUERY_PROG{,_HW} from all drivers.

Please refer to the individual commit messages for more details.

The patch passes test_offload.py from selftests. Thanks to Jakub for
pointing this out.

I, hopefully, addressed all comments from Jakub and Saeed, except one;
I did not move the XDP struct net_device into a struct of its own.


Thanks,
Björn


Björn Töpel (2):
  net: xdp: refactor XDP_QUERY_PROG{,_HW} to netdev
  net: xdp: remove XDP_QUERY_PROG{,_HW}

 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   4 -
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   3 -
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   3 -
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   4 -
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   4 -
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  24 ---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  18 ---
 .../ethernet/netronome/nfp/nfp_net_common.c   |   4 -
 .../net/ethernet/qlogic/qede/qede_filter.c    |   3 -
 drivers/net/netdevsim/bpf.c                   |   4 -
 drivers/net/netdevsim/netdevsim.h             |   2 +-
 drivers/net/tun.c                             |  15 --
 drivers/net/veth.c                            |  15 --
 drivers/net/virtio_net.c                      |  17 ---
 include/linux/netdevice.h                     |  23 ++-
 include/net/xdp.h                             |   6 +-
 net/core/dev.c                                | 143 +++++++++++-------
 net/core/rtnetlink.c                          |  53 ++++---
 net/core/xdp.c                                |  20 ++-
 20 files changed, 137 insertions(+), 231 deletions(-)

-- 
2.20.1

