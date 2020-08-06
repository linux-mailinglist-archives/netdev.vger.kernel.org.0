Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F5623DF7F
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbgHFRsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728621AbgHFQfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 12:35:48 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446AAC0A8938
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 09:35:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t6so6880202pjr.0
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 09:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LrfpxJapN5Whw362ysmueBnYm5S5mysz/IRV5u6I9Y8=;
        b=avlI4+lvHofTYV5vpnliFiRfSLNIm2iVCYWVvOrni23HNL8qeHXLccOpmmIdRVE65z
         RMVfxoUrxk1G1M8F/ytQ2Q6P/z1VDZigmPdi9uMQjpXDUeusPUGT8pn/JLOyPhVoulRo
         W7nF94T/8SpPUN2Psi7pGV0R0hmeery1bB5b8K91IWKvuLCX+mnSX5ugDmIvn5Fodshn
         EQ4jQl534GKfgmCmcqlE8iwdCpzyPBcigg2+BZmMVaIuBNE7wgJfXvdJyRD48L2Lj1d5
         DG6yg9jtFwZ6zDaWyKUeRSjqXHKyMEaRtJ/NZtz2JxL19F/rfVKXmVJRHmW4BWZ2BA8V
         RUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LrfpxJapN5Whw362ysmueBnYm5S5mysz/IRV5u6I9Y8=;
        b=lvaS7jVG791WbWPtfcmQSS4oEt9L08Zy/UXAW46awdruQCsCj+ZJ1R2x0NEmQ6neIv
         2Cegc0xyLG0Nm15lPdRuspyQ70F3vAIEDrwX9d1PqUNUPIg+cSlX2vrfjzGg8u6VQlTz
         nHaYQOLv7YcH2WhnFhETnwRGkOvfdExRIvmr4K4e4CzvsydDLYQCrI6e2QGPtfc+LCh5
         UOtFDmPakQYg3UUSj50b+dgHTTcIi57D2Bo0HMhXdRr4pBkDBeLuw4SrLmkeKJOP0R8c
         5H7/BVTqr2CYdKNRcLpc5MiBiuXzJvF80bm/YRE2Rb7w9OLdIvdtYajn+pWubq4xafXP
         6I3g==
X-Gm-Message-State: AOAM530js41c9gkb2QKmf1JXswArKPe15OtKzQG/0HwWhvGi3nxx1Itm
        Ug/QPhW1fYBXezSzFeh6Y3A=
X-Google-Smtp-Source: ABdhPJy57RT0i4aYAfiiZVRNPywS0KgTFsEsd+Lt1QU7eVyIJzg0UXhnhNwJpqWQe7JiL7jK5UoqtQ==
X-Received: by 2002:a17:90a:e381:: with SMTP id b1mr9048082pjz.218.1596731742654;
        Thu, 06 Aug 2020 09:35:42 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id g15sm9071839pfh.70.2020.08.06.09.35.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Aug 2020 09:35:42 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org, sgoutham@marvell.com
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [PATCH v5 net-next 0/3] Add PTP support for Octeontx2
Date:   Thu,  6 Aug 2020 22:05:28 +0530
Message-Id: <1596731731-31581-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

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
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    | 244 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |  22 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  29 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   5 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  54 +++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  52 +++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  27 +++
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   7 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  19 ++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  28 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 168 +++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  | 209 ++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.h  |  13 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  87 +++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   1 +
 20 files changed, 1014 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h

-- 
2.7.4

