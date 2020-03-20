Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F311C18D801
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 19:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgCTS5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 14:57:38 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38585 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTS5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 14:57:38 -0400
Received: by mail-pj1-f65.google.com with SMTP id m15so2888475pje.3
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 11:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zVfALwvu3zSfBzPTP7/Ke9u2Arsne90290ch/JMdZKc=;
        b=jAYlQgB2gI2j7KWEBSo/79SFPy8FziCfFjno8eDCchllR8afG3CfxftiJliWbvsbTV
         S+clg/E/sLB0ISWZmvYmpHFru5H3Klhrxiyx/2v5aWOoORGOtYuRre4YvSS9WlgI7OoH
         gx5Ha4i2PyAoLK+lhqVyql0IT5lOKEUOnG2jiVRqjVA5DIq1IFeQQLyrupmyyUu/PURb
         hw8MmEhApVqytbXbiTDUbWJHVQR48ojO8Rt67//NjrlZvG+rnBEBvi14AYGmi30Rl5/j
         H3OKtY1sOQKBzsSbhitohfGW3OeiedKHNs/5gGEi8v5eSgcP20BJ7yTDa321krqBJX8p
         59ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zVfALwvu3zSfBzPTP7/Ke9u2Arsne90290ch/JMdZKc=;
        b=Rg0ND3MBAM0RHY+2TH/M5Pjx5BGpfe0FHPs875pnJ5znBGlUpGthb4ShroLZbPIvle
         tFrtKcUXP9fm08ah9cgy6LSCV99Krpsgo7zTRbQnNEz3f4C9csYAh8+X0GAlPADwdAh5
         qEWrI/ThyYfoqNdx2C0fGtmUZhSUVHr92jwx96nvIW/g5us/ayhXfPPF6Af3EbCPAEAu
         sHIfhIiGW36HXznrbzB/qfxEA29f4xsnIksoOwMD+rSn0QGXzv7vB+a3esM0O9JdWqSa
         1f77hqKwC9tHNVU282eBomhmvFfhI10jCn2mHIRyPjk7/mJLJFX0BBqYsvUlRh7bi6pr
         1/Ig==
X-Gm-Message-State: ANhLgQ3ecB67pIg56GH4Hp6FfEVVY39Q9mQ3IpskXlgLKzXtb5fB5X7s
        uje1ALFQjAuCSDhngSbl8WRGMLZfIc0=
X-Google-Smtp-Source: ADFU+vu89T2hBHZANpTEqp6YnOld/d9Kq+NPZusVPWoUaUj98XXV5LZIVcC9/L8OkikzH6yDzyBvNw==
X-Received: by 2002:a17:90b:11d0:: with SMTP id gv16mr11251802pjb.106.1584730656234;
        Fri, 20 Mar 2020 11:57:36 -0700 (PDT)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id l59sm2407044pjb.2.2020.03.20.11.57.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Mar 2020 11:57:35 -0700 (PDT)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        andrew@lunn.ch, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v4 net-next 0/8] octeontx2-vf: Add network driver for virtual function
Date:   Sat, 21 Mar 2020 00:27:18 +0530
Message-Id: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patch series adds  network driver for the virtual functions of
OcteonTX2 SOC's resource virtualization unit (RVU).

Changes from v3:
   * Removed missed out EXPORT symbols in VF driver.

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
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  40 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 128 +++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 824 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  13 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  41 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   | 648 ++++++++++++++++
 10 files changed, 1693 insertions(+), 112 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c

-- 
2.7.4

