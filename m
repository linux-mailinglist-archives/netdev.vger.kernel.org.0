Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D667218D85
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730414AbgGHQug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgGHQug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 12:50:36 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC8CC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 09:50:36 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id 72so7843764ple.0
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 09:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3B9JQlboND7uu2oqs60UkgNTlXYwPNJGifVp+MsSN08=;
        b=N6raitJ8swRv1FUHc3GWAz4QB7IlDhvW5VDrhjN1R1kliKMjF7QHxlWjR0Js1btG42
         7PpUByiQ6SlhQBfvWPaHKf53EW0I2s+0hu3IDHSmHKAue7l1yWPY3jWOAQLgbQAfIyAb
         aUlWCvbs5mWUNcCvLZf7Yo677YXPpw3UCR4vP21/q9Ajs/irdsLxCfi9pKBU2mDAEpA2
         ZUvAGqrGYibl00FQ4jLaT0G3x27rcVxR+tvV3pZ43KYCv0tslX4cclCSt7LdJ4JNJmr8
         IR+5kaLNeoJspGAqOx6aT7FQ9XBszczGFUr07B2uEQvniFWTTHzm08buLiZQnYeq8mu2
         /qeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3B9JQlboND7uu2oqs60UkgNTlXYwPNJGifVp+MsSN08=;
        b=S64ACNKxIwUeYrwu6smMWLqjwrGYiyt2/2xCuoTxE5RzQA4VWXvmpPoXZ4UQjJh5hx
         82FIn1ASbY6iuHBni4SLZwPRdDOpxVlXq4+0tvJEHTit/Nyja/SwpuEjQNUCK+inJ8Pc
         8MGq14lQC84vRWYB+iq1wJzNOdO4IWbMCb9i0bn1RGexYFRMY07UirhFcK86oNUhqFZL
         /X/x4IkMzpbXQQFJK2+p8vKGXCCr2iNJpo5RZC9uC0yQWePWJqZexB7E6rxmmByxy9hA
         qNz86zfntgsvtuIqhXoxbkSd9/MJ9Vcx34/Xe17ztRQ6CjTS3Dpld4qA2fhmoAzDanwS
         S7ZA==
X-Gm-Message-State: AOAM5307tpLN2v3LXGkbOlfgiL+szNaPKg6uR7SPWmKZSo9OEVaOJFpo
        hPhf+FQjvBxApHJ0tE9vXTU=
X-Google-Smtp-Source: ABdhPJxyDbG51dcbqWMHU70j3GXpUwjg0Qh+UJgAVc9gTRTxkdGqIzdb5mgIrYnhbt2CweEUlXEKyw==
X-Received: by 2002:a17:90a:7487:: with SMTP id p7mr10555402pjk.233.1594227036000;
        Wed, 08 Jul 2020 09:50:36 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id c1sm323716pgi.52.2020.07.08.09.50.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2020 09:50:35 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org, sgoutham@marvell.com
Cc:     Subbaraya Sundeep <sundeep.lkml@gmail.com>
Subject: [PATCH v2 net-next 0/3] Add PTP support for Octeontx2
Date:   Wed,  8 Jul 2020 22:20:15 +0530
Message-Id: <1594227018-4913-1-git-send-email-sundeep.lkml@gmail.com>
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
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    | 245 +++++++++++++++++++++
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
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  | 208 +++++++++++++++++
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

