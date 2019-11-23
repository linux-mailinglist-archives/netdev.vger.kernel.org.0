Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C2A107DB3
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfKWI0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:25 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32885 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfKWI0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:24 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so88812pgk.0
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=yzU5G/pHT3IXLFsxKfZmhn/3sjWZxcFuDStLmuYghmY=;
        b=ZPAVcl48O/PXRbg93CUHsSwKQg4z+sl+/+uoyVdK3NKVguwjGmbU0fMNcoEgC9Q+yv
         ufmf0eNQ5mVjUyDT2ZJHnyru9rPKRhscTQGSW+JgPkX+hAq3lNBShfePYb7TqY5cnq/L
         gBHikYD+rFCP0blvqv+AgLoc2upmLYBdDt23M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yzU5G/pHT3IXLFsxKfZmhn/3sjWZxcFuDStLmuYghmY=;
        b=KFAdjmjXmxnOn1yPFL/I7/5Zr4+yjFpV/+9NZtTi8YHimqEz6GrzvKnWT4vyw8M5SD
         NDCmd164OaXvHaTTkmVRBjkKMCmRhOzCpyMk3TU+M2Cb9Lv6vDUPxLNhW9PBVevzzpVv
         xs4ynrppK4S5Xo4w1X/cj1OxKZW0HbB7PAzTT6OBvXW7/8s2iQ3qIf2eOfKmvzevBluT
         U/YJgrrVrwGFnjtik3FZg2I8E7i0gJVTzTcmiAuC12xmuLxVyWz1sr+4K8HVkCBG7mo6
         aSoskfvKcpE7QQ9Ya6IRSdB7OCiRmxWOQ/d+EOkdvui5YmIDETCJ72rzkWvnUpcnqrM5
         F5XQ==
X-Gm-Message-State: APjAAAWFBuTkuCPeSTjfVN0lHNVhTnw2LmTJsbTcaJe31x+jcw675cIa
        +bS1v+YSHeFPXFR18u4E5FpIiYwPsfY=
X-Google-Smtp-Source: APXvYqxug9Wa1bjTnafTXAtUXnaT8brVrFpAz7Pij4QXy33ujMEetK3wPgwoY65Xd7OgW7RSkd/LzA==
X-Received: by 2002:a63:e343:: with SMTP id o3mr20938597pgj.131.1574497583768;
        Sat, 23 Nov 2019 00:26:23 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:22 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 00/15] bnxt_en: Updates.
Date:   Sat, 23 Nov 2019 03:25:55 -0500
Message-Id: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains these main features:

1. Add the proper logic to support suspend/resume on the new 57500 chips.  
2. Allow Phy configurations from user on a Multihost function if supported
by fw.
3. devlink NVRAM flashing support.
4. devlink info support to return some adapter info.
5. Add a couple of chip IDs, PHY loopback enhancement, and provide more RSS
contexts to VFs.

Michael Chan (8):
  bnxt_en: Add chip IDs for 57452 and 57454 chips.
  bnxt_en: Disable/enable Bus master during suspend/resume.
  bnxt_en: Initialize context memory to the value specified by firmware.
  bnxt_en: Assign more RSS context resources to the VFs.
  bnxt_en: Skip disabling autoneg before PHY loopback when appropriate.
  bnxt_en: Refactor the initialization of the ethtool link settings.
  bnxt_en: Add async. event logic for PHY configuration changes.
  bnxt_en: Allow PHY settings on multi-function or NPAR PFs if allowed
    by FW.

Vasundhara Volam (7):
  bnxt_en: Do driver unregister cleanup in bnxt_init_one() failure path.
  bnxt_en: Combine 2 functions calling the same HWRM_DRV_RGTR fw
    command.
  bnxt_en: Send FUNC_RESOURCE_QCAPS command in bnxt_resume()
  bnxt_en: Fix suspend/resume path on 57500 chips
  bnxt_en: Add support for flashing the device via devlink
  bnxt_en: Rename switch_id to dsn
  bnxt_en: Add support for devlink info command

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 218 ++++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  23 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 152 ++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  15 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |   4 +-
 8 files changed, 328 insertions(+), 98 deletions(-)

-- 
2.5.1

