Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5888814A140
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgA0J46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:56:58 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:43996 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0J45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:56:57 -0500
Received: by mail-pf1-f175.google.com with SMTP id s1so4067159pfh.10
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=fIYiiwMd9z48bOBXK6crDtgvZJhx0dwrez+iHOIrthU=;
        b=AUIbP8Lq68g7FLfv6qI4hdHtadnIYPwJoWyKXpQhu5GeWbNvEtW5QUG5QOHisBUS2u
         e1Qar23lixh1l/S2CtT8cOYx5hM8oyixvLW1lVtLCO92GZTJrVswUx/KaJBVq54c8bU/
         SLJjFTfHH8ZaukQRPsFGxXUCs2ri2e8Nh2HdQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fIYiiwMd9z48bOBXK6crDtgvZJhx0dwrez+iHOIrthU=;
        b=shNB5sDdWUiu6uOQHF276nDkAJID71lQ3pJSetWbiVmwkJtE+0vgWBYo/nilKLeBQu
         voT9fuvQ3Db/Oreg7dMYeFXsz/KSdj3tLziIIuF2slL6QMXHrvdI91zZu+DvMSLnG5O3
         nB8ZFoVsRCWNdhKDMg0Udj17MwqCYlQO+Lghh+a6XrPpYqqVnEIIoGc86VYsGhAr1x0V
         FbbzOMYsEwg+9iaB6YOWYmTbz2jU0WXlqB61wf+qrXpOVaXfj1LTxaWABZbooGT+ujB+
         MWKu6JjWYKWpHiugIG8mx9Qo4QJ70hQyTgUswfKDeTnFXKw1ueranHEYgLGEutULYErn
         nAQg==
X-Gm-Message-State: APjAAAVX4fcnipo62i5neuvz15B8KsUeP+AXUxYbPcznS9EJjdkT23g4
        xeZvgZIHEJMfdoeIuRvtketZSqb2gr4=
X-Google-Smtp-Source: APXvYqz4XgRopCPyVT3G6bFFUMC8BvcmPPyZCfkW53rCh4rYZZanVH3wHkI0qY+yJSjoH/8BO9EV/g==
X-Received: by 2002:a65:484d:: with SMTP id i13mr18893343pgs.32.1580119017150;
        Mon, 27 Jan 2020 01:56:57 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.56.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:56:56 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-net v2 00/15] bnxt_en: Updates for net-next.
Date:   Mon, 27 Jan 2020 04:56:12 -0500
Message-Id: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set includes link up and link initialization improvements,
RSS and aRFS improvements, devlink refactoring and registration
improvements, devlink info support including documentation.

v2: Removed the TC ingress rate limiting patch. The developer Harsha needs
to rework some code.
    Use fw.psid suggested by Jakub Kicinski.

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

Vasundhara Volam (8):
  bnxt_en: Refactor bnxt_dl_register()
  bnxt_en: Register devlink irrespective of firmware spec version
  bnxt_en: Move devlink_register before registering netdev
  bnxt_en: Add support to update progress of flash update
  bnxt_en: Rename switch_id to dsn
  devlink: add macro for "fw.roce"
  bnxt_en: Add support for devlink info command
  devlink: document devlink info versions reported by bnxt_en driver

 Documentation/networking/devlink/bnxt.rst         |  33 ++++
 Documentation/networking/devlink/devlink-info.rst |   6 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  46 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 224 ++++++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  16 +-
 include/net/devlink.h                             |   2 +
 8 files changed, 277 insertions(+), 58 deletions(-)

-- 
2.5.1

