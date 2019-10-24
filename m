Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7111E29EE
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406817AbfJXFce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:32:34 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46331 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfJXFce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:32:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id b25so328343pfi.13
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 22:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=t4PAHH8PJaCZ4qiU56+PESatCmdynQQlnlANmSc3Nko=;
        b=LjjEwZkkgUv6wfE1FBdccGQk4cftdKD9U4BnZA3syJjmzYufUKVCllwB4FjaHJNAFz
         xKsY22E2ojGlVWHJRdoAKOCH13dbOQRrkZPn2i6+5bUKihu5Ka66mlnHAOuT81AM5wb4
         7gu/Nt2/9jJt9zsFgqAO5i2G+n1bumZf0Lj64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=t4PAHH8PJaCZ4qiU56+PESatCmdynQQlnlANmSc3Nko=;
        b=ZotgLcLSDESO36vXxe+xYO/9eUuFQnfvRGx+lL30h+BJucy9nxL452jqnFN26aGc0C
         q6KUnwdm8LL6rvhK+iOoN2FMsjB2q3H/0eYlFZAs4LqD/qcY9kZT6aU5DKVB8CiuxELM
         RcM/LdDroVaKjyrd6+edBPYMEWmbX9Qp3Y6FwtaHf4BEG/AIMUSA7rALNBUm9Tobny4t
         CVpI6rqeTN9eu8y3vhyvXuxALBHMbS6WbDYZ7IO1a2nYxoLbecVl1fif0JtLZE/yyjCD
         aSRvLRT0Cuy+0Y4qSRtJ6ujyCK8PZ2wK44+Bpwwgi4xCyBwZkGZ2FbcPMvxDj1/1LNpy
         AzqQ==
X-Gm-Message-State: APjAAAVMZC5rV3zYZaXgJAasoM4veQCHDeIyjSFoo3f2TXzUp+bK/NLP
        tA1neE8YjB9XWcdM40r+Xn6AKg==
X-Google-Smtp-Source: APXvYqxpdZoWV3+xyLulndr7rwvyUTVaUc6FLaeDLcNGv6LTqTVuranco+MpYNdRb4AjnneGiuKmOQ==
X-Received: by 2002:a63:7247:: with SMTP id c7mr10891580pgn.311.1571895153531;
        Wed, 23 Oct 2019 22:32:33 -0700 (PDT)
Received: from shitalt.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id e17sm29491331pfl.40.2019.10.23.22.32.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 22:32:32 -0700 (PDT)
From:   Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org,
        Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
Subject: [PATCH V3 0/3] Add OP-TEE based bnxt f/w manager
Date:   Thu, 24 Oct 2019 11:02:38 +0530
Message-Id: <1571895161-26487-1-git-send-email-sheetal.tigadoli@broadcom.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for TEE based BNXT firmware
management module and the driver changes to invoke OP-TEE
APIs to fastboot firmware and to collect crash dump.

changes from v2:
 - address review comments from Jakub

Vasundhara Volam (2):
  bnxt_en: Add support to invoke OP-TEE API to reset firmware
  bnxt_en: Add support to collect crash dump via ethtool

Vikas Gupta (1):
  firmware: broadcom: add OP-TEE based BNXT f/w manager

 drivers/firmware/broadcom/Kconfig                 |   8 +
 drivers/firmware/broadcom/Makefile                |   1 +
 drivers/firmware/broadcom/tee_bnxt_fw.c           | 277 ++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  13 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |   6 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  37 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |   2 +
 include/linux/firmware/broadcom/tee_bnxt_fw.h     |  14 ++
 8 files changed, 354 insertions(+), 4 deletions(-)
 create mode 100644 drivers/firmware/broadcom/tee_bnxt_fw.c
 create mode 100644 include/linux/firmware/broadcom/tee_bnxt_fw.h

-- 
1.9.1

