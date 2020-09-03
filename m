Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884F425B9D2
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 06:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgICEjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 00:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgICEjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 00:39:53 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45855C061244;
        Wed,  2 Sep 2020 21:39:53 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k15so1207989pfc.12;
        Wed, 02 Sep 2020 21:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bBAwYh7KGiwK459fhijOjtPafXM5aZ06REwJK/5M7uQ=;
        b=Re6Yw7ahpzcR2kblJ6CsFoaO0fCLe1sMKih0xqUYOO2uhY+tMrunxfxPE9mZRlD7N4
         CgepBE1pdzG++kWq+0uF1dBRXL1dd/6vKNdRrqLmL65X4F3Qc6aPcA4oCv8JTexDqVd9
         2oxKZ2zmIkKBgEFIWsIuFXqm2PK17F5KGYZP0/gSPNpH8m78FjzcNsUF9tigDgUZApFl
         nWHbvtpKSBtKKKLs5dAb5fG1uLrrzuRKf55a5JVgyvN1e32xFMoq5X40wxzSiQXHibsc
         3/TvAzCOmjRS0i3ZVVAqwYdxCVbmlzyheqIRPpy2CBgH8SGJ1bDLmQMXEjvyVHzzu8Yw
         Lqcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bBAwYh7KGiwK459fhijOjtPafXM5aZ06REwJK/5M7uQ=;
        b=pzDWBnm/zKYbPqmRp9j63Zqs0GEsOkhtrBHfKCkY5pG04A4WqcN3tAXyW23WK+FUIz
         iHjU/ztbq8YxT/t9wEOyx/+/r6OXQuhag86iLkY/bw6FZNShpDoMql/fecZSkuZM4+IM
         TyqJ8CoKTBoBywPuL+82+GJlKynS33owb/hmDrbJKp+JrghINxeuEP4cfu7D+lGV2Fss
         Ei1/bwiduTOsxOu9/IX8Jy9VtmmXlbhI33davPH00+Vli2+i7th3MTAFKIT5gtAho+3C
         K1q9bXCEwPrYmNjkpyCBkMI6E5kbBewDHmq0RIZSJPKmlpv3z5WN11+0vRLZXGP8xtYA
         QhDA==
X-Gm-Message-State: AOAM533Qb+NvmA90oct8PsTPRfIBZ35YQdfXnTatrYr4iCoxvBtNhW6G
        elavPRcz832NaS7+LuvQm40fAVTlf4I=
X-Google-Smtp-Source: ABdhPJxCrISfOFBHV3qMEueAIYia7U0plyqd4d1sDOSWL9Y9kBeVqsHj8/21kiX0WrG8VGhnncSF4g==
X-Received: by 2002:a17:902:7048:: with SMTP id h8mr1834305plt.225.1599107992167;
        Wed, 02 Sep 2020 21:39:52 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u63sm1251805pfu.34.2020.09.02.21.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 21:39:51 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        adam.rudzinski@arf.net.pl, m.felsch@pengutronix.de,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
Subject: [PATCH net-next 0/3] net: phy: Support enabling clocks prior to bus probe
Date:   Wed,  2 Sep 2020 21:39:44 -0700
Message-Id: <20200903043947.3272453-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series takes care of enabling the Ethernet PHY clocks in
DT-based systems (we have no way to do it for ACPI, and ACPI would
likely keep all of this hardware enabled anyway).

Please test on your respective platforms, mine still seems to have
a race condition that I am tracking down as it looks like we are not
waiting long enough post clock enable.

The check on the clock reference count is necessary to avoid an
artificial bump of the clock reference count and to support the unbind
-> bind of the PHY driver. We could solve it in different ways.

Comments and test results welcome!

Changes since RFC:

- resolved the timing hazard on ARCH_BRCMSTB platforms, the resource
  enabling for these platforms needs to happen *right before* the
  dummy BMSR read which is needed to work around a flaw in the internal
  Gigabit PHYs MDIO logic, doing this after would not work. This means
  that we need to enable resources during bus->reset for those specific
  platforms.

- export of_mdiobus_device_enable_resources() for other drivers to use
  (like mdio-bcm-unimac), would they need it

- added boolean to keep track of resources being already enabled

- disable resources just before calling drv->probe() so as to let PHY
  drivers manage resources with a normal reference count

Florian Fainelli (3):
  net: phy: Support enabling clocks prior to bus probe
  net: phy: mdio-bcm-unimac: Enable GPHY resources during bus reset
  net: phy: bcm7xxx: request and manage GPHY clock

 drivers/net/mdio/mdio-bcm-unimac.c | 10 ++++
 drivers/net/phy/bcm7xxx.c          | 18 +++++-
 drivers/net/phy/phy_device.c       | 15 ++++-
 drivers/of/of_mdio.c               | 95 ++++++++++++++++++++++++++++++
 include/linux/of_mdio.h            | 16 +++++
 include/linux/phy.h                | 13 ++++
 6 files changed, 165 insertions(+), 2 deletions(-)

-- 
2.25.1

