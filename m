Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1C8388547
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 05:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353005AbhESDdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 23:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237387AbhESDde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 23:33:34 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D716DC06175F;
        Tue, 18 May 2021 20:32:14 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 27so7161672pgy.3;
        Tue, 18 May 2021 20:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7wVF+iyY+kYlSNZc2QC2Z8VNfrjdof9DM0HbDZzRDL4=;
        b=aOyqJAKwmvsZyYiDlUgzeEe/3RU9eb2s4NxJULYlSTuRDmMUpja71h7HaBZCys3UiM
         CvuNuAGePQq3xt4HR/9abBde1nJuD7GVHZ0HsUIHFzUfsdVBypZd4eN9GUlbUBPK2eJK
         UxUw9pum7YIYqf3WsRXFz6NaOOhSEVU3+HDZvqBUtrK5DXb/ZQjuY89L1vy0EBFk/U4b
         aqwAzsRpM09sWwCVZneSlmxH3LJTbl9P261eXTjbD6YI23EMXIV87n7w1ocOywVo8nhU
         l2Va1mQuBjm5T4HlTs7PLEegs06/FyFPV3BfxpCdgZ+sOsVxstOMRHAmPxINpfe89zJk
         wDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7wVF+iyY+kYlSNZc2QC2Z8VNfrjdof9DM0HbDZzRDL4=;
        b=tVYsqy0F/nLbuCyzPfKDiLyeXsYUUGcZl1H3tSCfsifgF2alzZalDpoJiAq0xOLJ79
         WHsVj/vDiyneB88JDhXv9lHL6Bo2ju5mLMueNAMMOkiLT/crFGyA5obdJHSLTy+Pxzzu
         +Qe7DcaiZcQwv0XuK5oHBg/2wVGPUGRgEbKatEIRDWyfXsYZg1BPF2TuIfV+FmdIvELk
         euIyMGZYz62p96Qj1oJm+G8OkLqoU4LdEpmo5cDboheqXvPN+ZOS33Yjc8nUD03Mz6V6
         OIiGhP4Q9qJnHXSZR0uVY4yC9t2sVNayV8r55Jz/qA54+/13yPQzds1qyx+eosPnLmkL
         EA0A==
X-Gm-Message-State: AOAM533PW0fs45iMl9/p8FKrQBaxASBx57yoJ86mjzMJ+FDkwp7cS/cb
        ladROyC3JyHOVb7L1yXgdhVyczIUcKinWN9vwjg=
X-Google-Smtp-Source: ABdhPJzL5kZiNFGM+U3ygMPBbAYn/1cVFHYVTB5yxRM5MpHnBFLDvopgXYW7dJID7qZzvU4Ng4kDrQ==
X-Received: by 2002:aa7:8207:0:b029:251:20c1:1861 with SMTP id k7-20020aa782070000b029025120c11861mr8476632pfi.13.1621395134400;
        Tue, 18 May 2021 20:32:14 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g13sm8244587pfr.75.2021.05.18.20.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 20:32:13 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH net-next v2 0/4] MT7530 interrupt support
Date:   Wed, 19 May 2021 11:31:58 +0800
Message-Id: <20210519033202.3245667-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MT7530 interrupt controller.

DENG Qingfang (4):
  net: phy: add MediaTek Gigabit Ethernet PHY driver
  net: dsa: mt7530: add interrupt support
  dt-bindings: net: dsa: add MT7530 interrupt controller binding
  staging: mt7621-dts: enable MT7530 interrupt controller

 .../devicetree/bindings/net/dsa/mt7530.txt    |   6 +
 drivers/net/dsa/mt7530.c                      | 264 ++++++++++++++++--
 drivers/net/dsa/mt7530.h                      |  20 +-
 drivers/net/phy/Kconfig                       |   5 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/mediatek-ge.c                 | 112 ++++++++
 drivers/staging/mt7621-dts/mt7621.dtsi        |   4 +
 7 files changed, 384 insertions(+), 28 deletions(-)
 create mode 100644 drivers/net/phy/mediatek-ge.c

-- 
2.25.1

