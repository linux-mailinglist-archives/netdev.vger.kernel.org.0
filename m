Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C69C2CA455
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 14:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391133AbgLANv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 08:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387587AbgLANv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 08:51:27 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA272C0613D4;
        Tue,  1 Dec 2020 05:51:02 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f17so1231349pge.6;
        Tue, 01 Dec 2020 05:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tgdnxgocJilBY0LIhoWcqqg7xNfqmOppZMkE2HBCVKI=;
        b=q9rPszauSvPYTj6Zxwu//UCEY08rpQ1WLsFJNjxu4NKuq/MiWShM3gzeAK45G/a+Ic
         xoqBuXphnuCqDkaDv6kvN0pUeiL5tPgW7Dw0SOjxm9/QJA6I40ggJUrtXoJrYCIVNHhG
         +Uq2m1v23/LwOZOtsds825+rvIAOQP5tU5WDkBZf4e2BdG3hvg/p3Wbmk6jH61ehLnXA
         jgEMNZH36v2AoadPXROAVCxQe/AAJ5E5DVArkSthPvqLXpHJ1kUduDAw7/VgQDFsIlwX
         Lvb4snAyPm3wMLZ3xSKZQwfSIqwDaAZQ+Vuk9R/oDYtwKayvMr7KtK0gdnH/J35EYwEQ
         qe7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tgdnxgocJilBY0LIhoWcqqg7xNfqmOppZMkE2HBCVKI=;
        b=FL384n1FRbey++YNkr0AkUTmhpYeAj4Uukk7XJkBCinABx4pkTwscJsoW83es2W5DO
         Pls+HNRmfXk9NDmCLxfpTGawdrdQnzFFZtxVFuW4xINnGkxdM7B+MLpJ+/XZwBFF7x0Z
         y9GQXCN2c5n43dfgZrbtYcqzyO4hYoD/EmeaVv8PZcS8WWVh4uPhAP5d0oIjWGTGFo20
         nbDviSQyQJ8PTkyBwJ84booe91VtzKraS3t9ljGGVE1eAm7a2EA3OqTYDHi6NWZFL+Sg
         k01q+sc4ELTEg99TBEdKBoauiMD+tsglEXNopfgVllYogj4/i3EmKa0u9QFHDQXsNXc1
         DS0w==
X-Gm-Message-State: AOAM533tTTam7KiS4zKu2rW+Dx6i1sSSW2VKkG3Xc9ml6qLg7jyu4H6r
        sNUdv3LxsbTbSv9UfXBLofE=
X-Google-Smtp-Source: ABdhPJyb96I51/Z0DlMUwhMsHbFNnUIGGUG7H/1FKq0F9CdCuh8yziVK+k3DqasdNev6gR496AefBg==
X-Received: by 2002:a63:2351:: with SMTP id u17mr2349405pgm.72.1606830662385;
        Tue, 01 Dec 2020 05:51:02 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id z22sm3134111pfn.153.2020.12.01.05.50.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Dec 2020 05:51:01 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v4 net-next 0/4] nfc: s3fwrn5: Support a UART interface
Date:   Tue,  1 Dec 2020 22:50:24 +0900
Message-Id: <1606830628-10236-1-git-send-email-bongsu.jeon@samsung.com>
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

 .../bindings/net/nfc/samsung,s3fwrn5.yaml          |  32 +++-
 drivers/nfc/s3fwrn5/Kconfig                        |  12 ++
 drivers/nfc/s3fwrn5/Makefile                       |   4 +-
 drivers/nfc/s3fwrn5/i2c.c                          | 117 ++++--------
 drivers/nfc/s3fwrn5/phy_common.c                   |  75 ++++++++
 drivers/nfc/s3fwrn5/phy_common.h                   |  37 ++++
 drivers/nfc/s3fwrn5/uart.c                         | 196 +++++++++++++++++++++
 7 files changed, 391 insertions(+), 82 deletions(-)
 create mode 100644 drivers/nfc/s3fwrn5/phy_common.c
 create mode 100644 drivers/nfc/s3fwrn5/phy_common.h
 create mode 100644 drivers/nfc/s3fwrn5/uart.c

-- 
1.9.1

