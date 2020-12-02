Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5492CBBD8
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 12:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgLBLsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 06:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgLBLsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 06:48:22 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE794C0613CF;
        Wed,  2 Dec 2020 03:47:56 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id w16so924082pga.9;
        Wed, 02 Dec 2020 03:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=91aj9edY77hTt39KhpEZSPjKyf9MNh9XT2J/er9ipzg=;
        b=EZR9E0bgDgWC0etCy8AykgZf4yg9d1q/QNSsUz52oU9csexLmcGiMLbnzBtG2pWJWF
         +Q7h2qXwkUU79wxOwtoB4oeYOLkbrNmhVc9+/UyQKDDD59vZJMMZs8VFxgWRYYB1yCXN
         j4iUS7fW+e3iCsSF3A1uBPY6QMSFhAS8nP8xJjWK1GJuYcusG8jIvKhSFyO0i+MP7LgG
         /866WU6Tr+CDSNNbAj/pEjS4qGB0SPNEgaNdQlwAEeUyaLGvgEJvUNzP11sGidLIJ4AB
         BKEmI5n0wgpBu939mN8jPHAea7ZqzEzyrsMRnOvGlwRjcAsPiNUh4/j1TU2DUdnf5SjO
         ZfIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=91aj9edY77hTt39KhpEZSPjKyf9MNh9XT2J/er9ipzg=;
        b=F7KX0m3vlGqAM/DBstqnOkwBk7MQguWafhVXwMzEWLn1VF3N7j+QsZzLnYa4oP2h7d
         lrL4zRSKnf8WkQstnSbREwmRE833SeNfihSlw4PbenYbCv/Q7ULf3LbvFCnlJE/ZZfIH
         GefYuOa7OabarGhDcc2+MftGoCi6+SYsHJvH3BCO1vnQqK+4/GRn+as2eQ31kAsIe60U
         3mpQGIJkMrZtTWsPI6wjPdy/KtXQPdK2/I9PQjpWXL5kvBvhKWeKM7xZzmX2qopfaonn
         giyo+77JLDeKpIsz16qibKLoBrQmrCxkOo0qDELp5E7bP7x+d4QCpEH4EpkIpkU6Dq8A
         yWxA==
X-Gm-Message-State: AOAM530vS7r9H/B/ycDvDw+c2Ayy9cKD1a+RPuIH2jvP3hwhLZhjli5V
        bTAx+KBqSprh73lLlpY5Ip1KCmuoKsM=
X-Google-Smtp-Source: ABdhPJw6SuIwNlvL71go4Pdz71/9jVaJMw3SD7ij3mF7r4stN98PhXQS7CXU//7s3ABIopmsvoX0vQ==
X-Received: by 2002:a65:6891:: with SMTP id e17mr231710pgt.410.1606909676495;
        Wed, 02 Dec 2020 03:47:56 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id q18sm2108806pfs.150.2020.12.02.03.47.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Dec 2020 03:47:55 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v5 net-next 0/4] nfc: s3fwrn5: Support a UART interface
Date:   Wed,  2 Dec 2020 20:47:37 +0900
Message-Id: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

S3FWRN82 is the Samsung's NFC chip that supports the UART communication.
Before adding the UART driver module, I did refactoring the s3fwrn5_i2c module 
to reuse the common blocks.

1/4 is the dt bindings for the RN82 UART interface.
2/4..3/4 are refactoring the s3fwrn5_i2c module.
4/4 is the UART driver module implementation.

ChangeLog:
 v5:
   1/4
    - remove the 'items' of the compatible property.
    - change the GPIO flags.
 v4:
   1/4
    - change 'oneOf' to 'items'.
    - fix the indentation.
   2/4
    - add the ACK tag.
   4/4
    - remove the of_match_ptr macro.
 v3:
   3/4
    - move the phy_common object to s3fwrn.ko to avoid duplication.
    - include the header files to include everything which is used inside.
    - wrap the lines.
   4/4
    - remove the kfree(phy) because of duplicated free.
    - use the phy_common blocks.
    - wrap lines properly.
 v2:
   1/4
    - change the compatible name.
    - change the const to enum for compatible.
    - change the node name to nfc.
   3/4
    - remove the common function's definition in common header file.
    - make the common phy_common.c file to define the common function.
    - wrap the lines.
    - change the Header guard.
    - remove the unused common function.

Bongsu Jeon (4):
  dt-bindings: net: nfc: s3fwrn5: Support a UART interface
  nfc: s3fwrn5: reduce the EN_WAIT_TIME
  nfc: s3fwrn5: extract the common phy blocks
  nfc: s3fwrn5: Support a UART interface

 .../bindings/net/nfc/samsung,s3fwrn5.yaml          |  31 +++-
 drivers/nfc/s3fwrn5/Kconfig                        |  12 ++
 drivers/nfc/s3fwrn5/Makefile                       |   4 +-
 drivers/nfc/s3fwrn5/i2c.c                          | 117 ++++--------
 drivers/nfc/s3fwrn5/phy_common.c                   |  75 ++++++++
 drivers/nfc/s3fwrn5/phy_common.h                   |  37 ++++
 drivers/nfc/s3fwrn5/uart.c                         | 196 +++++++++++++++++++++
 7 files changed, 390 insertions(+), 82 deletions(-)
 create mode 100644 drivers/nfc/s3fwrn5/phy_common.c
 create mode 100644 drivers/nfc/s3fwrn5/phy_common.h
 create mode 100644 drivers/nfc/s3fwrn5/uart.c

-- 
1.9.1

