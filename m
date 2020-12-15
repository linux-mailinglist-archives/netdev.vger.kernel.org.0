Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7ED2DA847
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 07:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgLOGyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 01:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgLOGyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 01:54:53 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4217EC06179C;
        Mon, 14 Dec 2020 22:54:24 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id v3so10467272plz.13;
        Mon, 14 Dec 2020 22:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yqTrtcKq3MfV/8DAfuQcEKoeQF8SszVYywTAk5nC5NQ=;
        b=qo2BsIqXa6VTyiHxrtBXiun73Bd5bRI9jp3kwB1niPJYdTLs2Y2ZWnLjLk1gTcnZik
         AuXqP0i6l3LoG/MuMp7bw9TVnywBWYXfKgLAyEI62yN6P5PsFkpoJdlesF90TlpB9ERX
         K/ulnS1xG49ianhqkJklI9sK8imuVEATUvRW11CUinwVlJ4BrtJGZEvoiZbJtwsZKsOu
         r/c/334o5AXDwC3e6TrTRNmYk4aDDdtRRu2lC1t2BMInkGeajyAEqXPRugoFNJyxFIid
         +YFPOG44Z5SH7IeazvtLl2T+LNzNIlL1eN8MPr38TZCS9yLOolCGFAqa60SbNnwkwiET
         ixUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yqTrtcKq3MfV/8DAfuQcEKoeQF8SszVYywTAk5nC5NQ=;
        b=pUDhgU8nWHrz4JIX5gmYJmhmTzlHKPVf4os0R2XJm0MTdcVDSvp5aj11k7/UrMkXny
         yNLnEoSYn+QGZQGVvOQSdga9dmepmZhIAVB/ltVRS5DNMeJBuKoNWVrBcvpC9ChF14S3
         vYgKL27Tzj0FtX1n8cgedbmvu3+AwxUAJvhFHXk/+er/lbGTeloiGjZIwRur2OI/Yl+p
         4obK00lMb1RC2Dk1sV2mhKXMZ6Fx+pQDJMVMmBGINyX8L8avYyOCLNHAvD5eWCMEaAuX
         oKtMI2iVzQHu5zRdJUlZwD7U1ngbaDA6LHJx/mPubYKMdNZJgg0+dgbeubL4OyZZYqvo
         jz7g==
X-Gm-Message-State: AOAM531bmmmwLVPu5SgnbG5oeEi1D8/uh6QmRAnmE3U2yEMiUstLlp5a
        KarwF5I3E97AGw3E3T7iFeA=
X-Google-Smtp-Source: ABdhPJwmKRbPnTOtBnS4zIqc7wIG/iMfiDU8tnyX+78Bx/n5YnqdDKdNSubviPrGhjNopb0ccNisuA==
X-Received: by 2002:a17:90a:474c:: with SMTP id y12mr29493691pjg.175.1608015263904;
        Mon, 14 Dec 2020 22:54:23 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id na6sm19124134pjb.12.2020.12.14.22.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 22:54:23 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 0/2] nfc: s3fwrn5: Refactor the s3fwrn5 module
Date:   Tue, 15 Dec 2020 15:53:59 +0900
Message-Id: <20201215065401.3220-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Refactor the s3fwrn5 module.

1/2 is to remove the unneeded delay for NFC sleep.
2/2 is to remove the unused NCI prop commands.

ChangeLog:
 v2:
  - Update the commit messages.

Bongsu Jeon (2):
  nfc: s3fwrn5: Remove the delay for NFC sleep
  nfc: s3fwrn5: Remove unused NCI prop commands

 drivers/nfc/s3fwrn5/nci.c        | 25 -------------------------
 drivers/nfc/s3fwrn5/nci.h        | 22 ----------------------
 drivers/nfc/s3fwrn5/phy_common.c |  3 ++-
 3 files changed, 2 insertions(+), 48 deletions(-)

-- 
2.17.1

