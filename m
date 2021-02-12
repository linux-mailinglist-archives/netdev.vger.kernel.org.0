Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F423831A65E
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhBLU6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 15:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhBLU6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 15:58:08 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F96C061574;
        Fri, 12 Feb 2021 12:57:27 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d13so491033plg.0;
        Fri, 12 Feb 2021 12:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DEUkvm57SUfZ67LkdaZx+i3F1trO96ZGOnr2uOFwqVY=;
        b=ss6Apm3cg6mbHhc6Hm7Lwt419zpbPZRXJAPmFYAwyHAGq4A3iJklE/7wMZSIMzBnjy
         iM1T8LWVZAw/c5G0ICTq3W4bit+D7JOtHLVKA2wqJAZ7GS42+hCHB7PBaqWoxe5BHePU
         P6QKiMf6ndA888cxvF2GLfETG/0C2MBhEuEjlqkXMWeHvtvA6pMX67XLZJcjVyQApdSM
         9hd5rUeZkIlnac+gLLnygC7PGW3vz1ZhwTJLV21VkWhNezXhrjcTcEmrZWN8qJ8thfCb
         s4uYRz64ejU9GU78px7OjoNJi6F24B1QIwasWX2lcHqXXc4NX/0L0C5fYrm1KTiX1rF2
         7C3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DEUkvm57SUfZ67LkdaZx+i3F1trO96ZGOnr2uOFwqVY=;
        b=Ys66YNhNbTqcecXl8mkKTvSr2XFwahzUpwr7WB69HiYDHhYtCty5bNkMnNM0lNgsrq
         qK9sc7FF6wYo3rPKMuAe1Gcyv1jtLYiAqCaS0nAhqrIgAGOUD6Siv6pFfp4OfauRIrHc
         To2G0G4+eNqCyi5idmvAYZ3THl26ZZ5owzkOv7aeuw02jtyXOhZANuWV9GCa+A14m6kV
         ka4uP7wSETbuoFV0gUdbj7RQdn9Fd20w+igS9twQEm6BiDgySfD/ach7TpUtIJeW2B5h
         Hb7conef0H66mrbVDoyhOdU9KIddtKToWoJLspGL/yMPj/sTlCCdWt4ge1lLSHMiiYzY
         c/XQ==
X-Gm-Message-State: AOAM5325EBQp1ZsPnjSVG/06r89ZBXHVvIhqjh6l3rllAMUbBX2LxqL4
        s/m6M8dKwrljLqcLR0OiSMMt4jdzyok=
X-Google-Smtp-Source: ABdhPJzBHsu05uhppEkdg7JIPB8izrs0CVVL6kh0Or7j6BXRMc5kczp/fxp/0w3gTk9PuFZGuAsm3Q==
X-Received: by 2002:a17:90a:3905:: with SMTP id y5mr3702891pjb.203.1613163447137;
        Fri, 12 Feb 2021 12:57:27 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a141sm9891628pfa.189.2021.02.12.12.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 12:57:26 -0800 (PST)
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
Subject: [PATCH net-next 0/3] net: phy: broadcom: APD improvements
Date:   Fri, 12 Feb 2021 12:57:18 -0800
Message-Id: <20210212205721.2406849-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series cleans up the brcmphy.h header and its numerous unused
phydev->dev_flags, fixes the RXC/TXC clock disabling bit and allows the
BCM54210E PHY to utilize APD.

Thanks!

Florian Fainelli (3):
  net: phy: broadcom: Remove unused flags
  net: phy: broadcom: Fix RXC/TXC auto disabling
  net: phy: broadcom: Allow BCM54210E to configure APD

 drivers/net/phy/broadcom.c |  1 +
 include/linux/brcmphy.h    | 24 ++++++++++--------------
 2 files changed, 11 insertions(+), 14 deletions(-)

-- 
2.25.1

