Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16749EA0CD
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 17:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfJ3PyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:54:17 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:34094 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbfJ3PyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:54:16 -0400
Received: by mail-wr1-f51.google.com with SMTP id e6so1057637wrw.1
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 08:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=jWEhqZt9LYIejbeeXyBHqZ/6ZK3DUBswkTDyOQjmctk=;
        b=abWxQJxDUyMyhxtnDwX/xcTYhyZukDsV1EvX7XvsJb7GQh9wf6fAvZ3Pt97GdFNXbB
         FTMZva7WScVv1ytasMJr8yJU8Z7nbgjGk64Nem1HDXosAYyh+Tsoc1kIeYt1W662a+cM
         Oyruksj7yy1kTtRrQT4sC+j3Cg3kM6MQTYz/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jWEhqZt9LYIejbeeXyBHqZ/6ZK3DUBswkTDyOQjmctk=;
        b=rKp+bzljB+kZ64VGzZDJ6W83QNwUeAVXacZxKQ+EZNKZSYrdq89OrkSWMku68qyQDZ
         xdp13MBCKdwDEujrywXJslcv0NOUIu00oPh0Xc/RdEA+9GpVYO9TAnVHGgfk0daRUYwJ
         D6p+YfunWi23ulypwGUn4FDBzfj+JzerPPz22hpUI6G8l4e/g04Ynl7mn/FYqg3Dexzh
         edIHmkk/AcUqG6kcrTb7vRNtY2FsGT7UJqJ5lBDJWD9aURcxqt4JiXPGWV2rPGQ23Tvr
         ghbmFB0HCVG2iCcxopsBZNIRyuKb2AZraklzAAzVL8YCtlppEq5Q0x4IBr04KJhJ8cAd
         jxbA==
X-Gm-Message-State: APjAAAW/z/wICgC1e/94EY7iL2RMXZtPRjfutwKxumzHJwNdUrY80aFo
        vJRYkRfx01GZLER160AjRQbTdQ==
X-Google-Smtp-Source: APXvYqzNOvTaSec6IwibKk2zSp2eYM03odLztiWGwylqONfHQQHRcjx9PV4xZhgGXz7qkNeeD84QYw==
X-Received: by 2002:a05:6000:118f:: with SMTP id g15mr518021wrx.242.1572450854008;
        Wed, 30 Oct 2019 08:54:14 -0700 (PDT)
Received: from shitalt.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id g184sm499931wma.8.2019.10.30.08.54.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 30 Oct 2019 08:54:13 -0700 (PDT)
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
Subject: [PATCH net-next V4 0/3] Add OP-TEE based bnxt f/w manager
Date:   Wed, 30 Oct 2019 21:24:21 +0530
Message-Id: <1572450864-16761-1-git-send-email-sheetal.tigadoli@broadcom.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for TEE based BNXT firmware
management module and the driver changes to invoke OP-TEE
APIs to fastboot firmware and to collect crash dump.

changes from v3:
 - address review comments from sumit
 - fix SZ_4M undeclared error reported by kbuild test robot

Vasundhara Volam (2):
  bnxt_en: Add support to invoke OP-TEE API to reset firmware
  bnxt_en: Add support to collect crash dump via ethtool

Vikas Gupta (1):
  firmware: broadcom: add OP-TEE based BNXT f/w manager

 drivers/firmware/broadcom/Kconfig             |   8 +
 drivers/firmware/broadcom/Makefile            |   1 +
 drivers/firmware/broadcom/tee_bnxt_fw.c       | 279 ++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  13 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   6 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  37 ++-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.h |   2 +
 include/linux/firmware/broadcom/tee_bnxt_fw.h |  14 +
 8 files changed, 356 insertions(+), 4 deletions(-)
 create mode 100644 drivers/firmware/broadcom/tee_bnxt_fw.c
 create mode 100644 include/linux/firmware/broadcom/tee_bnxt_fw.h


base-commit: 749234419aeeb275900c2706e1fa078fd7394743
-- 
2.17.1

