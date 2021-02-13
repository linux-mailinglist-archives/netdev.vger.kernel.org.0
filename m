Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7303D31A9C8
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 04:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhBMDrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 22:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbhBMDrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 22:47:16 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B260DC061574;
        Fri, 12 Feb 2021 19:46:36 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gx20so732257pjb.1;
        Fri, 12 Feb 2021 19:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HHroYqFOhd153R2kmw2Y6C5M9yxYxK4rF0L1fVxmrHg=;
        b=SuFe4fKhf2YrTZcI4XqxCeDWEG/M4epx1nCeiZWFJDSKYzGcUCsMelP68WmLyD4pnq
         AOGN2aIjssmQmuVOJmTAEOPf8wfWOcBacSIm0CJTRiiOr7NyHYjQMirr2G1GTpIYpor6
         qv0KwtJjcDqE1UDv253x9GvTm7q4drVDC6YjwTxkbs5HYLCAU1uGDlkj4lDnekDAgRi7
         sliv9eGVpC6pOOv5M2OjhuLrlbsP+SOgnDxECxbupxTalnyKe1ZeizRpJmZlVFvEo2PI
         sob5hV5Lh7dwgHk1ZlNDCeQLa7SQMO1eDKnPFOOidC683cF7LBxWGFdm4N4ulGL/UFGs
         YEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HHroYqFOhd153R2kmw2Y6C5M9yxYxK4rF0L1fVxmrHg=;
        b=H2jh5dUhRhD9ilfFGCrX9p1MdkKmHt586dvlNL68KL2+eVlqKwwanKUJxn3ctU96h1
         1yYu/Vci9uTMBgVu2Tm+l9ceOhzDLLCH2+pW0MWNWQmo7vXSJMvhMmOotwm8HwloK5AP
         +4Hve6QKGlx8AE3Ppkz3DaDxTdRSc/CTTrXubNW/tGmTeDX71NO85zKg0OUi4lzIJuuE
         EFFHY/T5NQcvZB+PiLODxYXb0iZbYxX1E5d/iGIeE0DtB6kNh1n1yDGzPdiqAEs8pQTU
         UpADh3GHSMp2ws4cDWWgKuQoDpFFUcwyvJi6MJ1enXb8K/BlaFjlvDd4zoVGysDuKeVm
         +evg==
X-Gm-Message-State: AOAM53058KRty5xSFcGHt1/txvbzFZgelXMlGwt+LUZo4JHXF6rJqwYo
        ghrHasV4ZbBi76oWiQ2mV5nOMAg+JcQ=
X-Google-Smtp-Source: ABdhPJzhQw2iUNrjSDL8HptXHY7a5tF9VNixE2A8KaArVlH8duaeBHZmsez2laH+2VrB2iPqWuTFiA==
X-Received: by 2002:a17:90b:1804:: with SMTP id lw4mr5628000pjb.141.1613187995705;
        Fri, 12 Feb 2021 19:46:35 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y14sm10399057pfg.9.2021.02.12.19.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 19:46:35 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list),
        olteanv@gmail.com, michael@walle.cc
Subject: [PATCH net-next v2 0/3] net: phy: broadcom: Cleanups and APD
Date:   Fri, 12 Feb 2021 19:46:29 -0800
Message-Id: <20210213034632.2420998-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series cleans up the brcmphy.h header and its numerous unused
phydev->dev_flags, fixes the RXC/TXC clock disabling bit and allows the
BCM54210E PHY to utilize APD.

Changes in v2:

- dropped the patch that attempted to fix a possible discrepancy between
  the datasheet and the actual hardware
- added a patch to remove a forward declaration
- do additional flags cleanup

Florian Fainelli (3):
  net: phy: broadcom: Avoid forward for bcm54xx_config_clock_delay()
  net: phy: broadcom: Remove unused flags
  net: phy: broadcom: Allow BCM54210E to configure APD

 drivers/net/phy/broadcom.c | 101 +++++++++++++++++++++----------------
 include/linux/brcmphy.h    |  23 ++++-----
 2 files changed, 66 insertions(+), 58 deletions(-)

-- 
2.25.1

