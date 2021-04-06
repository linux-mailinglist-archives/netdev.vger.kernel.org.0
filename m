Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90034355658
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 16:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345034AbhDFOSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 10:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345015AbhDFOSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 10:18:40 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD4BC06174A;
        Tue,  6 Apr 2021 07:18:29 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y2so7586786plg.5;
        Tue, 06 Apr 2021 07:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oHeyYOhTyr/Pj14dswoKpegMv2vJUh025+BN2sVtXu8=;
        b=RtwbzxaLtNZ0nmdC4WJ/Cx9sZwXO1DHJ8WqQYOxbxvHGlQneXoT8hZHtjuYkmAPLAn
         +6JTWU6Ws84uztBHt7NYBcbVcXDde3Fj5zcCJ5ssBJQDm9xUC4IaYY0HcCH+8YFW/sDo
         4mu6CsmLrotTPSTK9y77uxPSMmLcL3qJBaJhRafv9kEsBXP62g+trAQjsOGilTI0c00Y
         zQmg6e8jMR4cMxkGHgs4R7BFQA+O035RKOVNLgcCWxHlWwMBKQRC3FavgUGBJ8WpE974
         ui3F38lBrgyaZ5tDeXKuR/6umDgfaSsfj+ifEIs2c1ddA3B9/Z4FrDCcvKIa7ONX2wu2
         dJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oHeyYOhTyr/Pj14dswoKpegMv2vJUh025+BN2sVtXu8=;
        b=QoUuAFOPNBXwkcUZsdE0XjKAIX0M1gh/gIakny+WcMe9D26pvolFgdmfjrokHwgAYT
         9pT02UGEb8iiCtzNEAcK8jE5uhP47RYv8VJVs5dWQ1u1nwjk9T2+IevnBRFlpbkTxySC
         neB68ZXtGOJxHYYC8n/zsqN+7/CSs10FhLqYkgqwb58L4vPH8a/xFOXEdK4EF5KbF4UG
         /anwduQcTaZXRpgaDADLQL/sCg4bh9HHkbQ/jDOH/pP8gKp4DQsYCQ0d7jMP+IPF70pG
         OJYoyIjpzQqDRrBytzfA8kPIDI0jopCTbljOUmSHpE9/VwdaPW3a91Tqvww7CWKYekFX
         ckWA==
X-Gm-Message-State: AOAM530z/LXAeNzdcdz54wSvQVTHH8lQGbyBIiswg66OOMHO2PFleznu
        +CHkmK9wTrNUXzCSFa1wd5s=
X-Google-Smtp-Source: ABdhPJycUf08xH7qOZt9syoGWZKCK/ZFzVK3LiVHhby8ua9De8vgDPchYrwqPZAbqEJIvB6LOhGhgw==
X-Received: by 2002:a17:90a:314:: with SMTP id 20mr4735746pje.72.1617718709461;
        Tue, 06 Apr 2021 07:18:29 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id u1sm18337581pgg.11.2021.04.06.07.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 07:18:28 -0700 (PDT)
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
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [RFC net-next 0/4] MT7530 interrupt support
Date:   Tue,  6 Apr 2021 22:18:15 +0800
Message-Id: <20210406141819.1025864-1-dqfext@gmail.com>
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

 .../devicetree/bindings/net/dsa/mt7530.txt    |   5 +
 drivers/net/dsa/mt7530.c                      | 203 ++++++++++++++++--
 drivers/net/dsa/mt7530.h                      |  18 +-
 drivers/net/phy/Kconfig                       |   5 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/mediatek.c                    | 109 ++++++++++
 drivers/staging/mt7621-dts/mt7621.dtsi        |   3 +
 7 files changed, 323 insertions(+), 21 deletions(-)
 create mode 100644 drivers/net/phy/mediatek.c

-- 
2.25.1

