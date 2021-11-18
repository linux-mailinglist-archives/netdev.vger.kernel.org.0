Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26BB4553A5
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242863AbhKRESG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:18:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240638AbhKRESF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:18:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A61CD61B4C;
        Thu, 18 Nov 2021 04:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637208905;
        bh=b7WcUL+9GTX88WH0SCFJdmYqeS/aXfbRKp681lTjABI=;
        h=From:To:Cc:Subject:Date:From;
        b=nYFrzJ5zWHMhDGeIOu1zDAVH/lrHyy114HTWiyOGlOdnG3xg/HyDSVHD75vtzRvDs
         AFuZeppTNj8jB5l22hrqGpp+G0Do87QQap6hLkWUgBSCGR1mPU6+9eQycH01ZzDF3s
         Ym4PthdrTbjMjzWNHYCWCvOfgN1aaPBJum0SdNqQsQ1FcDiHWAqW/z+H17+dWqHQ8t
         6vIg84h3jxLIkQgaBFyXaolArR+6pxP6Jwj3ltv+NTEKSUyax0/reIb0X9R6mTm2nY
         kOi+sBv6IudWy5VuWhipcTWQm0eeHWP81SGDFMJ+oIIcC0IidQHsHCndGa2JR5vg7t
         A+DBmIsMbFmrg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/9] net: constify netdev->dev_addr
Date:   Wed, 17 Nov 2021 20:14:52 -0800
Message-Id: <20211118041501.3102861-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take care of a few stragglers and make netdev->dev_addr const.

netdev->dev_addr can be held on the address tree like any other
address now.

Jakub Kicinski (9):
  net: ax88796c: don't write to netdev->dev_addr directly
  mlxsw: constify address in mlxsw_sp_port_dev_addr_set
  wilc1000: copy address before calling wilc_set_mac_address
  ipw2200: constify address in ipw_send_adapter_address
  net: constify netdev->dev_addr
  net: unexport dev_addr_init() & dev_addr_flush()
  dev_addr: add a modification check
  dev_addr_list: put the first addr on the tree
  net: kunit: add a test for dev_addr_lists

 drivers/net/ethernet/asix/ax88796c_main.c     |  18 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |   2 +-
 .../net/wireless/microchip/wilc1000/netdev.c  |   6 +-
 include/linux/netdevice.h                     |  17 +-
 net/Kconfig                                   |   5 +
 net/core/Makefile                             |   2 +
 net/core/dev.c                                |   1 +
 net/core/dev_addr_lists.c                     |  93 ++++---
 net/core/dev_addr_lists_test.c                | 234 ++++++++++++++++++
 10 files changed, 328 insertions(+), 52 deletions(-)
 create mode 100644 net/core/dev_addr_lists_test.c

-- 
2.31.1

