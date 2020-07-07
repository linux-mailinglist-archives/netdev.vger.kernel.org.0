Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EC121685F
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 10:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgGGI36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 04:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGGI35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 04:29:57 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A96C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 01:29:57 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id p1so7195653pls.4
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 01:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gi9AUWvKHBxsgeNzNjvq3Traaevp48iBvws+7LcTlQc=;
        b=n0DzExPv6NxRVxQRUNIvhVrMt5m9Eo5GhNvCXKap3LOZU58IV7C642APLwJEtf4lpK
         ueDO3TZJoG+87gM/WdcCEGw/spZjeHX7LfQxjVR6XlcKMXuDTqeLCrwrxjonotcy4r3Z
         Thwum2AHatMhgVbeRFT98v21Vt65/mzQqPBSoRsUAQysyr/b50WU5RaEvhue3Yip5cjf
         epqyLvmcMqRxW/2l9CXiznn8lbopYk/34+6aTZUS46oG6Uxxf95Q9eIRkxizmWOoHMEf
         bK0E+1EhXsprABFtgRXnimQvyjieCkEW7IsIpFGzj5FVIyVnj4gVsPseBml7Dxca8P6n
         Amew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gi9AUWvKHBxsgeNzNjvq3Traaevp48iBvws+7LcTlQc=;
        b=JHXg9NDqkXbxtJanS/zgOLqPjqnjISFTyso/0kkATa9XrNYoTwGTZGUsxB+cJrADWQ
         wf957bABKgDQ3CFIOBaIlrjo7ysy4lJbUp6A07hc5ASo6/LMA91jDHaGgfex37wKwGOV
         hFMq+BXHjumCnUd8Aw2DueMLKzUEGgqDUUSx1+8PyZYCUlW7PBQFAw2RE5WAlB+d50A6
         cBrMlYVVUWJ9qVNE4qsBEHKM05GUXC+MAwQi7IE3LtkQwAf2aD6vP/ikuRqbtCpvRMp/
         DCF60zqu/7R0PdYSKJaJfFsT89wIZZIGjriYpdoIxtv5CCxbpfulx8srOS+atWBOTUr3
         EGpg==
X-Gm-Message-State: AOAM5314tPHjmdaAqswxoOxgTAvVYYtK5nvJTqd4k89pE8A464KH4Lzm
        hAobLoYZECByPYUJPsgeIQc=
X-Google-Smtp-Source: ABdhPJwT8azrdzQ9gdPwqykO3DDH0bf7mJL8QvIb34ZYvLw/BkQH0G7GcFI7iQxqWQEz0EsPzpRUuA==
X-Received: by 2002:a17:90a:254f:: with SMTP id j73mr2968772pje.16.1594110597396;
        Tue, 07 Jul 2020 01:29:57 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id i196sm127510pgc.55.2020.07.07.01.29.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Jul 2020 01:29:56 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org, sgoutham@marvell.com
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [PATCH net-next 0/3] Add PTP support for Octeontx2
Date:   Tue,  7 Jul 2020 13:59:43 +0530
Message-Id: <1594110586-11674-1-git-send-email-sundeep.lkml@gmail.com>
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
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  10 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  28 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 168 +++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  | 219 ++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.h  |  13 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  87 +++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   1 +
 20 files changed, 1016 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h

-- 
2.7.4

