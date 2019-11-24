Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B4F10818C
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfKXDbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:31:10 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39330 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXDbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 22:31:09 -0500
Received: by mail-pf1-f193.google.com with SMTP id x28so5578684pfo.6
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 19:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=WPT7U8y7jsx8W5Sdje8GwQC4BajnoKFUeCfrgfdKulM=;
        b=AYi/TeJfNsGMwoVshrBSop1zoiQIVV2TsU02/Ty2lHhffn/9oZZ1fvu3/6f3nTMmp8
         bSZYqfvYf3U/gMKtZbbr5bfXMOuehVfNDaI/1g9W3h4p9n/Rnqr4FjgwmVFBclqytmZZ
         KN24WtMupppxszYiPMyOzb7KndbWvFbNPnWJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WPT7U8y7jsx8W5Sdje8GwQC4BajnoKFUeCfrgfdKulM=;
        b=ZNELCCcWf5BV/vNq/evTUwowi39Uv3r8faldqORlpfz2k9/pnMNKIQ5lv9uUc3Gonx
         ugWBGQV4SQxTLcmkJhqGhJ+V87tW97RBJzTn22xPsojqu8HnH3fsA9Ln/zlhu+MRAbmo
         9h2YHuok+QrxVRvlKeRe+V1qLLFwYk8My9uMpXIHkNoRf6yLE5cdXcf3hUWVCT8zr8my
         ttPMP70SNG1pMPy70WI9rEf9m94SEgxueSny9a4oKgOa8aoqqKa12H+GpybD7p9NtGv/
         6tX4pMdDFVOX0Kh+Sy9TeYEv8OcSqcQv8IAVcGRf3PxnoGvAebaMhBJNW7WYvYtRUwG/
         23Hw==
X-Gm-Message-State: APjAAAX4KU6bEqBELRuGi8qAGz4dXxm7tDTaPF/ln0UCYuDD5fpeaxW8
        bteFYrYyZgy0kMgoBy+Fuwge18tsvP8=
X-Google-Smtp-Source: APXvYqykT+BDu6szZsmk0ZN+sqD2l2fVGDSReO5R5/yUd0ozJpNdkFY8teoGziz4Qkij4nHrHWKLiw==
X-Received: by 2002:a62:2ccf:: with SMTP id s198mr27020459pfs.42.1574566269126;
        Sat, 23 Nov 2019 19:31:09 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v63sm3111901pfb.181.2019.11.23.19.31.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 19:31:08 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 00/13] bnxt_en: Updates.
Date:   Sat, 23 Nov 2019 22:30:37 -0500
Message-Id: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2: Dropped the devlink info patches to address some feedback and resubmit for
the 5.6 kernel.

This patchset contains these main features:

1. Add the proper logic to support suspend/resume on the new 57500 chips.  
2. Allow Phy configurations from user on a Multihost function if supported
by fw.
3. devlink NVRAM flashing support.
4. Add a couple of chip IDs, PHY loopback enhancement, and provide more RSS
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

Vasundhara Volam (5):
  bnxt_en: Do driver unregister cleanup in bnxt_init_one() failure path.
  bnxt_en: Combine 2 functions calling the same HWRM_DRV_RGTR fw
    command.
  bnxt_en: Send FUNC_RESOURCE_QCAPS command in bnxt_resume()
  bnxt_en: Fix suspend/resume path on 57500 chips
  bnxt_en: Add support for flashing the device via devlink

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 212 ++++++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  21 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  20 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  15 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c   |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |   4 +-
 7 files changed, 190 insertions(+), 92 deletions(-)

-- 
2.5.1

