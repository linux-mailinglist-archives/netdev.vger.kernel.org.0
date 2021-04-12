Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101F235B900
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 05:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbhDLDnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 23:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbhDLDnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 23:43:05 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC2AC061574;
        Sun, 11 Apr 2021 20:42:47 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id m18so3419699plc.13;
        Sun, 11 Apr 2021 20:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TbV7aHs7TaIhyV0H0KiEJQJbVjhXqA5DKHSoe6+ECPw=;
        b=P49so0HJzAqTv6dJXeU7iuIOm7fDFNyyZSoqpw0IGgN2WT+OcbM9TVUJvnSps2D6FV
         ocO0sEZhJJMEU8qIE/a51GoTocEhwzbbkMoH0Cbmf+i9p+bbVlTM5qiDzKSJ37wOZC3+
         2pUZyv/F3wPJPIoqSvt0bd2RN12rfYLYmzhOb5YGyAoZm8uFGpsriEsX+57HU1yUB7Iy
         mI8w5yu0620bLR90MrBddwfrU7ye/05QYa9LKIlsWV9iWDE99DJJVsYSU6B4PcYuMQgd
         59B/WiVnFR7obFfZ8ZEmiSr7tMKT1M3t95asjWXeRUB4DUBYPIf4toqvDlwXT924+iyM
         MxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TbV7aHs7TaIhyV0H0KiEJQJbVjhXqA5DKHSoe6+ECPw=;
        b=KlLoM1XB/RfsU4dOM6OJRi3FjJNM6vipRL3mqTCIGi2zpA3rH76u8S5jKAZ0odnKdz
         ZYAp+hMr+V04IG4mEbpdqSyFWjngnfpU2KLs/583bIvyoVANsqL5RHdGn1X024LUMxYn
         AD4/YZvaxoyItO6Q4zdcAFrgx7YrZEYPY/5I5D1h6Ur8ou0WWSrYtYs37eyS8FaX9WzA
         /dQUb9jSM+xSuBH/4aegm0X+vDhe3HYVHQlC+/ndWJMC9jlE2HyrR2o5l4tFAGrV9VTq
         v3TxDP/yPUCuY7C2byIMZyQzGCXm7KCysCFncLev/HLUvuSOgqfu0tG5ayGNZMMtM0J1
         1CTQ==
X-Gm-Message-State: AOAM532UTslK+fyHjsj/AJAYWSWiptnHw/y6uZAO9LsjpM3YUgYhATTB
        9uoiJUrmN7C7kd+c3I0TQlk=
X-Google-Smtp-Source: ABdhPJwdVRYU3h0l1OFzieG7ZRMhsfTOWmdz910QyVB1NKZu1Di8amy5CJ8Q0tY3NgFMgooSH6PiMQ==
X-Received: by 2002:a17:90b:390f:: with SMTP id ob15mr1860487pjb.100.1618198967574;
        Sun, 11 Apr 2021 20:42:47 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id v22sm5387185pff.105.2021.04.11.20.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 20:42:46 -0700 (PDT)
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
Subject: [RFC v4 net-next 0/4] MT7530 interrupt support
Date:   Mon, 12 Apr 2021 11:42:33 +0800
Message-Id: <20210412034237.2473017-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MT7530 interrupt controller.

DENG Qingfang (4):
  net: phy: add MediaTek PHY driver
  net: dsa: mt7530: add interrupt support
  dt-bindings: net: dsa: add MT7530 interrupt controller binding
  staging: mt7621-dts: enable MT7530 interrupt controller

 .../devicetree/bindings/net/dsa/mt7530.txt    |   6 +
 drivers/net/dsa/Kconfig                       |   1 +
 drivers/net/dsa/mt7530.c                      | 266 ++++++++++++++++--
 drivers/net/dsa/mt7530.h                      |  20 +-
 drivers/net/phy/Kconfig                       |   5 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/mediatek.c                    | 111 ++++++++
 drivers/staging/mt7621-dts/mt7621.dtsi        |   4 +
 8 files changed, 385 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/phy/mediatek.c

-- 
2.25.1

