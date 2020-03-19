Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 260B018B439
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgCSNHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:07:45 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52436 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbgCSNHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:07:42 -0400
Received: by mail-pj1-f65.google.com with SMTP id ng8so1008792pjb.2
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 06:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EiCffRJzs1rPLEHZVeeVO+6enSILFAhPzCiZrfUMA1c=;
        b=hzTeTogp2lBxj2ggXhTE7LahQs/qdWaCzvvxMg4lY8sf3Fe/WmzywdlVDUvoduVgp3
         9UWkymsMwW6xLtLG7z1EsMvsbeN/302oTwDQwTRNJ9fJY04tCfiGtAIUFkIodPvugQxy
         wKucW4wYFRSrvTsDHa2uv9kXanVL2bNZyH/viqBGC2EAcDHNctr9XEWc2DNV3Sg5Rjij
         ONJun1Cyjr2bRYx2bGNR67rgTLBf18l8gk4iw3Z1/8205Ht/ZAQ9r28vwFAI5lFEbLfk
         poSjChEaD3AUXrq7zuwN02vRq+sUeIdw76mT/uDaUaelUEUYz/WzB7ZoPtYPq79iNXur
         UO4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EiCffRJzs1rPLEHZVeeVO+6enSILFAhPzCiZrfUMA1c=;
        b=hAH6BuRFkaNBMvWuOBSmv5d/LAkyMS8hVyUzkpslX7CXWlf+PugpFaT+LNLooSggFx
         WIySYebA7ENdW6XTxo5ihhH25+kVurzKbz2h30ykSM6gv+s0U1LzVg0bhyP9PFDoUQ9k
         imhoqf4PIZN9oZtv+xzCa4QWtztmZmi2FS+X+9QldECGyib7B6WRZnjew8aKLFJcQ9Jh
         QoFEa4VxWvsaTkLZcbTaMfrxSDBn4Lafb+71kIhEEJfxNrOOgjuEPOb6u9XNvGaim0d6
         zY/DAVHCStkPEdXZdXyRPj2TKdBn7EmewmdQJYUvrNS9HNWgPk4uG7rRgdnyNA+yqpRy
         l6LA==
X-Gm-Message-State: ANhLgQ0UCE1x+N09OqCiEpICLtpCjm/AQkbaVJTB1M3CCMvS0Wk7hvhP
        iYsWTTOryiu4XTGVBKvZ+GxAM6tEOQs=
X-Google-Smtp-Source: ADFU+vt4S5V3cleJA/aFJnkx+mwgjF3u061qltqBouVPsZfQz+qr33Gd0Q2vJBSD1XIJAkAqRHia2g==
X-Received: by 2002:a17:902:123:: with SMTP id 32mr3570080plb.38.1584623259094;
        Thu, 19 Mar 2020 06:07:39 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id c15sm2336292pgk.66.2020.03.19.06.07.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 19 Mar 2020 06:07:38 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        andrew@lunn.ch, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v3 net-next 0/8] octeontx2-vf: Add network driver for virtual function
Date:   Thu, 19 Mar 2020 18:37:20 +0530
Message-Id: <1584623248-27508-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patch series adds  network driver for the virtual functions of
OcteonTX2 SOC's resource virtualization unit (RVU).

Changes from v2:
   * Removed Copyright license text.
   * Removed wrapper fn()s around mutex_lock and unlock.
   * Got rid of using macro with 'return'.
   * Removed __weak fn()s.
        - Sugested by Leon Romanovsky and Andrew Lunn

Changes from v1:
   * Removed driver version and fixed authorship
   * Removed driver version and fixed authorship in the already
     upstreamed AF, PF drivers.
   * Removed unnecessary checks in sriov_enable and xmit fn()s.
   * Removed WQ_MEM_RECLAIM flag while creating workqueue.
   * Added lock in tx_timeout task.
   * Added 'supported_coalesce_params' in ethtool ops.
   * Minor other cleanups.
        - Sugested by Jakub Kicinski

Geetha sowjanya (2):
  octeontx2-pf: Handle VF function level reset
  octeontx2-pf: Cleanup all receive buffers in SG descriptor

Sunil Goutham (3):
  octeontx2-pf: Enable SRIOV and added VF mbox handling
  octeontx2-af: Remove driver version and fix authorship
  octeontx2-pf: Remove wrapper APIs for mutex lock and unlock

Tomasz Duszynski (3):
  octeontx2-vf: Virtual function driver support
  octeontx2-vf: Ethtool support
  octeontx2-vf: Link event notification support

 drivers/net/ethernet/marvell/octeontx2/Kconfig     |   6 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   4 +-
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  99 +--
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  42 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 128 +++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 824 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  13 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  41 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   | 650 ++++++++++++++++
 10 files changed, 1697 insertions(+), 112 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c

-- 
2.7.4

