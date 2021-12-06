Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B7146AE87
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 00:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350890AbhLFXpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 18:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240513AbhLFXpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 18:45:34 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DD0C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 15:42:04 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id k2so24050201lji.4
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 15:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zU2qkVgD/No35PDL2s6VLlL2QE5X4s3l9G2Wvt3zlqw=;
        b=gZ1gkfk5L5mFICVN+5kyx5rJL7pllWVHk47PmZQDFR3DrUbTcCYSNlUAZYQSO9OrQh
         83pa/MDUllVJt9KVhMp43RRGwzMY/qImWbvOT54CTmE8IfOyuKB/lGiaipXJw7JSjxyn
         WBGqVzhhBpxLejjdkCXAlOpG4WDfoU1wPjeG+17j9jGLrnYr+0IDjWbx91vLp49Lar/7
         JpgMW2suarSy25BxeX/FqFqPmJTBzbvfSzPARAhoLru4Tnv/+7d92kw2gJGXqS0mjhtN
         gyyDXBaWCkAC+EzGTdce+NL8Xfa745d9eCCp/+KBSJKs9L5/oeqX5I8lmtRYZTN1wzLs
         GUDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zU2qkVgD/No35PDL2s6VLlL2QE5X4s3l9G2Wvt3zlqw=;
        b=EAcMXDA1t0Qkc6tMEsnq+SlcdpaEPZemBIkMeCVFRO3XCe7xXGPmXoVzg9Ww5FMl1u
         5VGjV2FpaAyo2qbTKKxR8TGfwBawwoK4T4pw0KIeTgZeRWg0HPYbPnPAjG49EmgQA4zc
         ONTWaXCyDx9ApGoNvcsKlzaB4XsC5wG6T62KbnazPup/mfBi3VKlo4Qzg2FyD3SPodjZ
         yhcZb/j6/QKEA3D4RPoom7Sdwhop5XlVft4AnBwXZsliupZDJB2jyc0Bbj8tXovn+u22
         mfVE5EmuONNR3b9NAyuA286tiAkHp9DWBhmBISXMbbptIp8aZuyHNjl8FvqTUevCKfyN
         exRw==
X-Gm-Message-State: AOAM530YrmfSS8rh158j1XETTvJHHvsSOFbKAzSOYI1ZA348EDWXIJs1
        5vCbSeYyLeMIu3cJnDH+XKeV5GGiwiJSQQ==
X-Google-Smtp-Source: ABdhPJz1hid7Y2Y4cs1u3eh0FTV9kozrTZdHKafS6/7OVsRUcdco4/JWvpTo5N3w1/wpkFFuLhpsCg==
X-Received: by 2002:a05:651c:235:: with SMTP id z21mr39477142ljn.473.1638834123111;
        Mon, 06 Dec 2021 15:42:03 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id f23sm1590333ljg.90.2021.12.06.15.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 15:42:02 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next v2 0/4] WWAN debugfs tweaks
Date:   Tue,  7 Dec 2021 02:41:51 +0300
Message-Id: <20211206234155.15578-1-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up series to just applied IOSM (and WWAN) debugfs
interface support [1]. The series has two main goals:
1. move the driver-specific debugfs knobs to a subdirectory;
2. make the debugfs interface optional for both IOSM and for the WWAN
   core.

As for the first part, I must say that it was my mistake. I suggested to
place debugfs entries under a common per WWAN device directory. But I
missed the driver subdirectory in the example, so it become:

/sys/kernel/debugfs/wwan/wwan0/trace

Since the traces collection is a driver-specific feature, it is better
to keep it under the driver-specific subdirectory:

/sys/kernel/debugfs/wwan/wwan0/iosm/trace

It is desirable to be able to entirely disable the debugfs interface. It
can be disabled for several reasons, including security and consumed
storage space. See detailed rationale with usage example in the 4th
patch.

The changes themselves are relatively simple, but require a code
rearrangement. So to make changes clear, I chose to split them into
preparatory and main changes and properly describe each of them.

IOSM part is compile-tested only since I do not have IOSM supported
device, so it needs Ack from the driver developers.

The 4th patch should be applied after the Arnd Bergmann fix for the
relayfs support selection [2].

I would like to thank Johannes Berg and Leon Romanovsky. Their
suggestions and comments helped a lot to rework the initial
over-engineered solution to something less confusing and much more
simple. Thanks!

Changes since v1:
* 1st and 2nd patches were not changed
* add missed field description in the 3rd patch
* 4th and 5th patches have been merged into a single one with rework of
  the configuration options and and a few other fixes (see detailed
  changelog in the patch)

1. https://lore.kernel.org/netdev/20211120162155.1216081-1-m.chetan.kumar@linux.intel.com
2. https://patchwork.kernel.org/project/netdevbpf/patch/20211204174033.950528-1-arnd@kernel.org/

Cc: M Chetan Kumar <m.chetan.kumar@intel.com>
Cc: Intel Corporation <linuxwwan@intel.com>
Cc: Loic Poulain <loic.poulain@linaro.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Leon Romanovsky <leon@kernel.org>

Sergey Ryazanov (4):
  net: wwan: iosm: consolidate trace port init code
  net: wwan: iosm: allow trace port be uninitialized
  net: wwan: iosm: move debugfs knobs into a subdir
  net: wwan: make debugfs optional

 drivers/net/wwan/Kconfig                  | 13 +++++++++-
 drivers/net/wwan/iosm/Makefile            |  5 +++-
 drivers/net/wwan/iosm/iosm_ipc_debugfs.c  | 29 +++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_debugfs.h  | 17 +++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem.c     | 13 ++++------
 drivers/net/wwan/iosm/iosm_ipc_imem.h     |  6 +++++
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 18 --------------
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h |  2 +-
 drivers/net/wwan/iosm/iosm_ipc_trace.c    | 23 ++++++++++++------
 drivers/net/wwan/iosm/iosm_ipc_trace.h    | 25 ++++++++++++++++++-
 drivers/net/wwan/wwan_core.c              | 17 +++++++++----
 include/linux/wwan.h                      |  7 ++++++
 12 files changed, 134 insertions(+), 41 deletions(-)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.h

-- 
2.32.0

