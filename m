Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B9121A0CF
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgGIN1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbgGIN1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:27:13 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614C5C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 06:27:13 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t15so1103651pjq.5
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 06:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=t90y1hpILXk9lXT7NyDqZT2ReWEzILMzfGmZdQ+z4k4=;
        b=bYujjB75cARQ79NMfb/+na9fLXLvyK0w8lPXEH/sBqr6r1YcMsrcdjr7iPO1SO8k0q
         F4yUC0cw0HkoNHJml0Hi/eXl1adQ/XtNJYAYJHMllYkE35P25yKlwPjvMBg1oN3XkMki
         le5gmbyMppEYJRc0fWusJgN2XyFlyd/fo6+xfYavnm8cyEAX33rMe4WX1MNZV2xZf/eI
         U2DOv2DppL5ZdAXhvbhv2wS8vTO6F7Fo9oP7/tIlx79AP3tQTLuWL3i28SYoCa0EQg1b
         HdweK6YhZrVcgOd+f6dy2+++sCWWduc09tNltK0ZYtqtWLPrt0UJVFR1pnr9nvGjHnnr
         owWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=t90y1hpILXk9lXT7NyDqZT2ReWEzILMzfGmZdQ+z4k4=;
        b=n/g5AoBjhsRRjKLAgoWjcSGEuuEOKAv0B0Cy0jifnj7PXfPSdoOxDr/Ta0hFqTqkM0
         ZC9NuJr9B7Cu+lSijKg8x4zAZPsqUwBqXaHeDPUzB0LMp6vYXc8dknvXkuujJJQIGRGh
         6wIdJ8jZIvUE0+XPgBhdoi83ItkCgU8/1ymjMXMwUpCbWwxkO9aodmPzVE/Ln1d+nT6s
         nXiFvvERrD5IpC+4xp39CFyPHuxrHm8isbd/+IrZnh7Pw4TiKJSGOfOB8NVt9Z80KtRq
         P2fD4XaIwtI5IbcVch1+oLo07PU7vTD6rpx8RGEXXN+4i3JA9CHYrHrT3KEfQvBphlCu
         AReQ==
X-Gm-Message-State: AOAM533UHrrZfTnTyFXisEOdZFQlmLUX2A9q9x1FJqG2gmcrEQA3wq4P
        uz7dg9z8V76ihef5uwu/DicL/tRwf6k=
X-Google-Smtp-Source: ABdhPJzuRODvgSE8g3qSKF4GoK+CvdHRI+p6ahXsBtmQeYeCUXtsrc/aqAsOemmZEnhAaDDLeS6wqQ==
X-Received: by 2002:a17:902:b216:: with SMTP id t22mr52784207plr.181.1594301232827;
        Thu, 09 Jul 2020 06:27:12 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w17sm2863911pge.10.2020.07.09.06.27.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jul 2020 06:27:12 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org
Cc:     sgoutham@marvell.com, sbhatta@marvell.com,
        Subbaraya Sundeep <sundeep.lkml@gmail.com>
Subject: [PATCH v3 net-next 0/3] Add PTP support for Octeontx2
Date:   Thu,  9 Jul 2020 18:56:58 +0530
Message-Id: <1594301221-3731-1-git-send-email-sundeep.lkml@gmail.com>
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
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  | 208 ++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.h  |  13 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  87 +++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   1 +
 20 files changed, 1013 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h

-- 
2.7.4

