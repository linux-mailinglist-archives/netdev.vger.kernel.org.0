Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A67E305C9D
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238137AbhA0NLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238211AbhA0NJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 08:09:25 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD893C06178A;
        Wed, 27 Jan 2021 05:08:57 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id q131so1149210pfq.10;
        Wed, 27 Jan 2021 05:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vBvz2YbWfOX3Q1Cs7mp1zN0scocgctdq3d4EpjgIfoU=;
        b=HWyptk4zgJU+E4QeZpyMjSvaPvBMY7rf07ldY7/Bv4bILZqUBSAOhMheNqi9rFwQYk
         NANnDBOlnyO4jsl87JBiYpmaA7iCEM/+gbckv+t876UEc1kRp+E+Vps+l1aPS2ZiXM27
         cBF6LqzILcGZDhuIAlw0J/EGaYml1Wiq7XYKF2Eb7KjDATgZ9moQxplY4gwp4XDeDRzN
         6vo+tL/rBSeblVzAhT8F/ukP3+Kim40ENLFURvY0paqglf1KWtXmY24WPscPMV0DTQwu
         7k58CpzgxZIXmX/45cBfTp7kEphhLzMuqK71d+mZWxmvPBl2GfR6lCfe19UQwgZAp677
         hmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vBvz2YbWfOX3Q1Cs7mp1zN0scocgctdq3d4EpjgIfoU=;
        b=CgniCRT9+RcAGRV7xWonQzi85mVm505pX4NHah1zBH5Hby+n26X69Xkjop1+yKBgaM
         zlJVjAL8pJL+Menr0NRuV274FYz/64R1yPcLJK+KY5eJxEpoz6IVUVNFAYfdllM57bu4
         pROpTicKtrXgHjgaBfFTtJ4BHONPPTTisGOWBhOaFXgPGWUnu8tSLXpesy/H50jBJlDY
         VZpDxVpg+dwG/ZTLWdAHCzOTDMaZ16HAa/aTkn/1Ykx3ivPJMWJ5fz25zpK3BjanUvXQ
         vf1J0Vk2ue3yof4DVKudCsfrJ3KHfiRS6ZDXQ5o8yx9LppTu/heO6r9GtCIDeBeetm67
         ig0Q==
X-Gm-Message-State: AOAM530SxhlE/WgywB0M9y5aajLVW8nJjUNlcYbRdZfmxB/7f048Vxne
        D0iQfuSuRYtBMibRAZT+T+M=
X-Google-Smtp-Source: ABdhPJwJ3ZbS/A9K/Dz8QDeaaIcw5Fgp1F+mE/cRkvf5VvaWnPI+a/EzoL8/Rc8N3QgbqeEQOWnOQA==
X-Received: by 2002:a63:504e:: with SMTP id q14mr11062319pgl.306.1611752937308;
        Wed, 27 Jan 2021 05:08:57 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id 6sm2163343pjm.31.2021.01.27.05.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 05:08:56 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     kuba@kernel.org, shuah@kernel.org
Cc:     krzk@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next v4 0/2] Add nci suit and virtual nci device driver
Date:   Wed, 27 Jan 2021 22:08:27 +0900
Message-Id: <20210127130829.4026-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

1/2 is the Virtual NCI device driver.
2/2 is the NCI selftest suite

v4:
 1/2
 - flip the condition for the ioctl.
 - refactor some code.
 - remove the unused function after refactoring.
v3:
 1/2
 - change the Kconfig help comment.
 - remove the mutex init code.
 - remove the unnecessary mutex(nci_send_mutex).
 - remove the full_txbuff.
 - add the code to release skb at error case.
 - refactor some code.
v2:
 1/2
 - change the permission of the Virtual NCI device.
 - add the ioctl to find the nci device index.
 2/2
 - add the NCI selftest suite.

Bongsu Jeon (2):
  nfc: Add a virtual nci device driver
  selftests: Add nci suite

 MAINTAINERS                           |   8 +
 drivers/nfc/Kconfig                   |  11 +
 drivers/nfc/Makefile                  |   1 +
 drivers/nfc/virtual_ncidev.c          | 215 +++++++++
 tools/testing/selftests/Makefile      |   1 +
 tools/testing/selftests/nci/Makefile  |   6 +
 tools/testing/selftests/nci/config    |   3 +
 tools/testing/selftests/nci/nci_dev.c | 599 ++++++++++++++++++++++++++
 8 files changed, 844 insertions(+)
 create mode 100644 drivers/nfc/virtual_ncidev.c
 create mode 100644 tools/testing/selftests/nci/Makefile
 create mode 100644 tools/testing/selftests/nci/config
 create mode 100644 tools/testing/selftests/nci/nci_dev.c

-- 
2.25.1

