Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8EC36E4CA
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 08:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238885AbhD2GW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 02:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhD2GW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 02:22:28 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EBDC06138B;
        Wed, 28 Apr 2021 23:21:42 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id m11so2220392pfc.11;
        Wed, 28 Apr 2021 23:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cSEiNE02KkOTwO/RKhNbgZVSZuIXExN7hZU+pPtcLaA=;
        b=nbSHE1l3NP5OwYE5EpCU3ThMiKP9NsP7Bywu8FPOZy/Vzh1szBvBOiCkGq0abTdHRm
         OMQYBr1XHVHRpEcHVV9RTUkXRFru5qiZCDHr7hsFf/8U2mSbpbA33gCWUGiQHv4L7Zor
         3D1oINl27NIFDJc4gBBz6XuyFym0FTIgM0fSC+r6dpw/CN+ZGnojk2ObkUjzqKDJJQC4
         ieNpsLMxVPLIjFGSg6XXMSol+kM4D9RdkZS85jszhApH4uPJMF3xe/2+nRuN8y/QdLB/
         Ba8aAkqt5AatUncj+gqkcn6S3l6uyWPaIlkUKYDscyQZjfbsBBsDr4pv4hQ6BLZy7Q4B
         /V2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cSEiNE02KkOTwO/RKhNbgZVSZuIXExN7hZU+pPtcLaA=;
        b=Y2qLTSlL0zTAii8kY+WTt0E6Uy0+ga+CYXXXzwtxAlB6r0rRA39eESc8E3a8uNuJ+d
         fQi06k81P5v3FtMuwpvnlo1u77MaB39yw8tRq34sgYqB9H5yglJNGz1lCvt9mSkwGsF3
         VJKsynp67w4BZLrzZ0Cs3xECIkhsS1W+sV43E8lQmBZyZ3Hj7gOrMLDwmXv2F59ganrE
         zUjYxdG6BJMsZ7QKhwvBVEWJrNNMG95h7gk7TQbzIJajwKmv1Nuwbt/QDa8DvtCaTL/r
         Ose4SS9S7m6mi+eBsJwD+TBcK6a4D7WhVcGwMUuGI6WcV9fMC/zLP681yhw8kUZ0tKTu
         Ge4A==
X-Gm-Message-State: AOAM532D0N8MGzw/JV12mHs+F9daGQVCWGVpuwgrgSZg9A3jEMKH1D32
        epk1nAhe98Z3Q9HRLJUDdFg=
X-Google-Smtp-Source: ABdhPJxCISaXTPCHZ6fvrC28Ztfs6TYBjxQ36OVnc7nf0Q2Y0g2Un2fmRrsDf5JqqBpiA+kSQoYlHQ==
X-Received: by 2002:a05:6a00:1494:b029:278:a4bc:957f with SMTP id v20-20020a056a001494b0290278a4bc957fmr15386193pfu.55.1619677301870;
        Wed, 28 Apr 2021 23:21:41 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id b7sm1431008pfi.42.2021.04.28.23.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 23:21:41 -0700 (PDT)
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
Subject: [PATCH net-next 0/4] MT7530 interrupt support
Date:   Thu, 29 Apr 2021 14:21:26 +0800
Message-Id: <20210429062130.29403-1-dqfext@gmail.com>
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
 drivers/net/dsa/mt7530.c                      | 264 ++++++++++++++++--
 drivers/net/dsa/mt7530.h                      |  20 +-
 drivers/net/phy/Kconfig                       |   5 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/mediatek.c                    | 112 ++++++++
 drivers/staging/mt7621-dts/mt7621.dtsi        |   4 +
 8 files changed, 385 insertions(+), 28 deletions(-)
 create mode 100644 drivers/net/phy/mediatek.c

-- 
2.25.1

