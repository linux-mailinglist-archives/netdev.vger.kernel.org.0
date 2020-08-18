Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFE1248C93
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 19:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgHRRJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 13:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgHRRJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 13:09:43 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30519C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 10:09:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mt12so9693765pjb.4
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 10:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qXdWEuvd22lEVDFg9V58eaLDHv8IsNPp2JsP676ORew=;
        b=fJkxOxrQCXeVasMvJYJxRgJojKxkmq7Rc6bppo4yXE/63st2Aba11o+BYuvJA2VXcj
         kDasiR/bYoNdD/AjdMc6hdcK+p0WssGUvypPbE5KEcplciYB1wlR6rgDMlP5Ldb/Hbg7
         B/HUl0RNPJ7TzdYS+xJuGKvOsc2tnEZ6HTzXLbUZF59nrUR9QUy7Dld8U7P8MJ3BHKAL
         80xcHQ4gTQ1jPnVwW7lhRmMKzyLfOa254x8cGHYQuZTKm9oCjh2K6FgQP76D/1InIrfA
         10xVb7RP+JlLybDzV++gWK7MiOHrWIkAExjhBFhC3pKqbPV6cZaxfXLQiFrI+S/LPrkf
         QWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qXdWEuvd22lEVDFg9V58eaLDHv8IsNPp2JsP676ORew=;
        b=HkyO/rJ7buj83IsnOx432Rp1FvAxxNPlHwEkiKyOQ44a87HK2B0zvEC3U6i6mJPwIm
         Y9uSNYcVPxWnbGJJugsTh/TslbacCBJvIx64UY43Xo7o46OyeSe0jMconiFz1PoWIEWY
         idmrw6GlxC5upmsJEOCYezJ1zyShUW02EjX804W/gws119zG3R/BycHoNBWKsOwedywd
         0a3I9VNdhMYjb0Fyovk70IU1HdbwAEW2vdfEbcga4bVQUbCPNNb+XNUhr/PGDPLDZv44
         63TLFvYolQxulhQNtLhLD+FGyMNwKE//lR5YrVAx3dNSM5UznAl5+xn50nx6nMxdPBIA
         MYOw==
X-Gm-Message-State: AOAM532+Zb3yMZkZ6pFAoJgnu5K2dC/zkOwos4fBkJE3HhbNdQxFf29c
        MapHRgP50/m8UZRp9lxDNwY=
X-Google-Smtp-Source: ABdhPJxwmo2K5zO5MuJ05HOSSw9lYUt6B6tW8706pUMANdDaj/2RtOL1rXZYyOCQUPOAu1pXx6ezKQ==
X-Received: by 2002:a17:90a:6f85:: with SMTP id e5mr730210pjk.128.1597770580231;
        Tue, 18 Aug 2020 10:09:40 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id q82sm27507096pfc.139.2020.08.18.10.09.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2020 10:09:39 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org, sgoutham@marvell.com
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [PATCH v6 net-next 0/3] Add PTP support for Octeontx2
Date:   Tue, 18 Aug 2020 22:39:14 +0530
Message-Id: <1597770557-26617-1-git-send-email-sundeep.lkml@gmail.com>
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
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    | 248 +++++++++++++++++++++
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
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  | 209 +++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.h  |  13 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  87 +++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   1 +
 20 files changed, 1018 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h

-- 
2.7.4

