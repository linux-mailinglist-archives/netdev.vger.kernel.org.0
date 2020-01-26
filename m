Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F751499AE
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgAZJDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:25 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:34308 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgAZJDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:24 -0500
Received: by mail-pj1-f67.google.com with SMTP id f2so1451930pjq.1
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Ir8NnxhXO8krnOVpFz1CzqDb6tWC7FXKBv0qn8PFV9M=;
        b=bkvrvvX2IdEvVd2Qg/rVldFku3f1VI+pBcG7iBT+byyWm5En6yj/PwlULxFhZGg6jy
         5LhYL+oORdKNV/Rc6GsrBnVIN3oxH8wrXduNLLXdTDIjwKgPRwpiYk4CUYYo9CO1ENDj
         zMX1OVP6mKwiPdizybYudFbRh43jI2pHpMzSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ir8NnxhXO8krnOVpFz1CzqDb6tWC7FXKBv0qn8PFV9M=;
        b=lsy2AJSOP/rFoyTSc9X7djlzpWr9CYBJG7qTxx8Vdz1urvCgyllTM9R/jxJqDkXd3z
         mTsen6+6348RD9wDTbNM3clncFZgvLtcbthuNclViOr2aq1S4uZlSlMmxRu6EAbqUDlS
         AhfNfeeNB8TylLgp/52qbBhT0Dd5/DwpNW5HCh3sW3trD76+c7qcke1APXUcTzcykga3
         izPINakGLRpuc8jPnNZOayVK275iTFp9wHMOk2a0H5vX0h3Dm1NcmZ3J4jMpiga4O8X8
         cw3woZ0/qALfDygJIFhCyHBI2Eww0JnqOlCG2BUgfBUsegqb/fqbn4/WiPmyeAuq3Gvr
         Lamg==
X-Gm-Message-State: APjAAAX9aP8z+VwrTTgYesWYLZu8Q6HLSRfEj7drUTwi+MOl1Es4Jp1W
        PGL8RbS4n7KsBH5sxe4OYhcSrlNAmXg=
X-Google-Smtp-Source: APXvYqwOJkDfiadiM8RpQS70DuoVqWElKLEQPXcSkNWSDN783/fxak6iXqFRrO1QLi9BKkbwJeYxXA==
X-Received: by 2002:a17:90a:9f04:: with SMTP id n4mr8603714pjp.76.1580029403911;
        Sun, 26 Jan 2020 01:03:23 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:23 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 00/16] bnxt_en: Updates for net-next.
Date:   Sun, 26 Jan 2020 04:02:54 -0500
Message-Id: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains a TC ingress rate limiting offload feature,
link up and link initialization improvements, RSS and aRFS improvements,
devlink refactoring and registration improvements, devlink info
support including documentation.

Michael Chan (6):
  bnxt_en: Improve link up detection.
  bnxt_en: Improve bnxt_probe_phy().
  bnxt_en: Remove the setting of dev_port.
  bnxt_en: Support UDP RSS hashing on 575XX chips.
  bnxt_en: Do not accept fragments for aRFS flow steering.
  bnxt_en: Disable workaround for lost interrupts on 575XX B0 and newer
    chips.

Pavan Chebbi (1):
  bnxt_en: Periodically check and remove aged-out ntuple filters

Sriharsha Basavapatna (1):
  bnxt_en: Support ingress rate limiting with TC-offload.

Vasundhara Volam (8):
  bnxt_en: Refactor bnxt_dl_register()
  bnxt_en: Register devlink irrespective of firmware spec version
  bnxt_en: Move devlink_register before registering netdev
  bnxt_en: Add support to update progress of flash update
  bnxt_en: Rename switch_id to dsn
  devlink: add macros for "fw.roce" and "board.nvm_cfg"
  bnxt_en: Add support for devlink info command
  devlink: document devlink info versions reported by bnxt_en driver

 Documentation/networking/devlink/bnxt.rst         |  33 ++++
 Documentation/networking/devlink/devlink-info.rst |  11 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  46 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 225 ++++++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  16 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c      |  90 +++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h      |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c     |   2 +
 include/net/devlink.h                             |   4 +
 11 files changed, 381 insertions(+), 58 deletions(-)

-- 
2.5.1

