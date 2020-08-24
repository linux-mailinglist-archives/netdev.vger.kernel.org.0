Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A82125017B
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 17:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgHXPvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 11:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgHXPuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 11:50:18 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6FEC061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 08:50:18 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t11so4424850plr.5
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 08:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=am2YTk69bZPww31hWNSRhp2rjscR/0DGL1d27cgbq4k=;
        b=K48ZxfwSg07NYR0ttfNUhicT8CFyTyO/ySq+sbL93SScM8g2XM/+65Q8+BvMldE9A9
         MV7x+yAKpgaH0LMPPEiFcbNN3Rvs+QqBUoxv93XnQ0SLkEcBopLHIVFbcQlNoYq/18we
         rRxgsifKm8SaYB1FwlYtj1/nk+8PQjNzyPzDlSyZBD4CkWIGwqjEc3SuyL4ss44EnfJ9
         8ew+EUNDht3CEdQhQGdh0Wzdgo0ykFJjiWIESkk4MHdNwB4UUVaohSF/4M+yBYzBR/WG
         I5yX2nMq+Sngks/pf62K77vbvef+3a7V+KJRde3PWzJZEMfQBMjTEXF6aakLy9qKtDS3
         qlDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=am2YTk69bZPww31hWNSRhp2rjscR/0DGL1d27cgbq4k=;
        b=jomx0UM2U0XJbXA0uh93/7fkEfYFMC8H6mRP1r3LiVlj8VkvHl+I++2dq8gjti27JM
         gmWqvdi4jyvjzL56O7qCeYaT2XOb/tFwdHnYNabGSmO1Ul4nEVqyz0CtC78yluxghKrl
         75qryct9on15PU965kvdG1Xu758B1S7AqfXyL7X0RwcWAtBgqE53b1hOr1BU8TzIw0BT
         yRx/4TKQ48kk/KxvZMSDCcAKaAgevyEjEuYrOQFEMnkckVHpaKA1TRLZj0REOIek1E/P
         v7GvFGsN7EV5IAaNyrrey+I1pBUYi38HlDIvVaobQaxPQREnEzD88kk044faClmN3xZj
         97Ow==
X-Gm-Message-State: AOAM532IG4eaq52JmED9RPaPXxA8AY/O5CuveYzMECngE+jvwHnkVk3C
        mqufOPU3yT5rr3WHM6sJyzs6j/H+qrDgvQ==
X-Google-Smtp-Source: ABdhPJwHIiYH8b7vbTyalutqmim7uNtA6I+uFWFq+nCxfo6YNoSRwaTvtjkBklFgdAprVfs2AnV4Cw==
X-Received: by 2002:a17:90b:951:: with SMTP id dw17mr5376763pjb.9.1598284217694;
        Mon, 24 Aug 2020 08:50:17 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id p24sm3364543pgn.49.2020.08.24.08.50.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 08:50:16 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org, sgoutham@marvell.com
Cc:     Subbaraya Sundeep <sundeep.lkml@gmail.com>
Subject: [PATCH v8 net-next 0/3] Add PTP support for Octeontx2
Date:   Mon, 24 Aug 2020 21:19:59 +0530
Message-Id: <1598284202-19917-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sundeep.lkml@gmail.com>

Hi,

This patchset adds PTP support for Octeontx2 platform.
PTP is an independent coprocessor block from which
CGX block fetches timestamp and prepends it to the
packet before sending to NIX block. Patches are as
follows:

Patch 1: Patch to enable/disable packet timstamping
         in CGX upon mailbox request. It also adjusts
         packet parser (NPC) for the 8 bytes timestamp
         appearing before the packet.

Patch 2: Patch adding PTP pci driver which configures
         the PTP block and hooks up to RVU AF driver.
         It also exposes a mailbox call to adjust PTP
         hardware clock.

Patch 3: Patch adding PTP clock driver for PF netdev.

Acked-by: Richard Cochran <richardcochran@gmail.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>

v8:
 Added missing header file reported by kernel test robot
 in patch 2
v7:
 As per Jesse Brandeburg comments:
 Simplified functions in patch 1
 Replaced magic numbers with macros
 Added Copyrights
 Added code comments wherever required
 Modified commit description of patch 2
v6:
 Resent after net-next is open
v5:
 As suggested by David separated the fix (adding rtnl lock/unlock)
 and submitted to net.
 https://www.spinics.net/lists/netdev/msg669617.html
v4:
 Added rtnl_lock/unlock in otx2_reset to protect against
 network stack ndo_open and close calls
 Added NULL check after ptp_clock_register in otx2_ptp.c
v3:
 Fixed sparse error in otx2_txrx.c
 Removed static inlines in otx2_txrx.c
v2:
 Fixed kernel build robot reported error by
 adding timecounter.h to otx2_common.h

Aleksey Makarov (2):
  octeontx2-af: Add support for Marvell PTP coprocessor
  octeontx2-pf: Add support for PTP clock

Zyta Szpak (1):
  octeontx2-af: Support to enable/disable HW timestamping

 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  29 +++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   4 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  21 ++
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    | 275 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |  25 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  29 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   5 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  39 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  43 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  31 +++
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   7 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  19 ++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  28 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 168 ++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  | 212 ++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.h  |  13 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  87 ++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   1 +
 20 files changed, 1031 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h

-- 
2.7.4

