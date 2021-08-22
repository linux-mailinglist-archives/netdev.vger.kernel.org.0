Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB8C3F4134
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 21:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhHVTdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 15:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhHVTdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 15:33:21 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FDFC061756
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 12:32:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id n27so276152eja.5
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 12:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DmrWrvyIHW/izeB1HmQaq15NlKbvEv6PvoGXABD0FYg=;
        b=UPGrIlZbooDfgQQZcQSPVe7VDiWM2uW5gX6HrlUEtWx2ylAqLvODE7/QKHxZnLxNqx
         eANDBCqEOyhRIeV0ruOInU5HIoRHkFZWl3cEhYRwyJ9C7Iu77mMvR2tTlOw3LnnqfGJ5
         0FoPiQL3CbuDUpHGhCuRngfynETTaNqTBr1T4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DmrWrvyIHW/izeB1HmQaq15NlKbvEv6PvoGXABD0FYg=;
        b=D9UL4pW/e+stLB/0C01Sh3hLUBNvN/hae3IvC8I+E58eKTjdWNLmdI/OXWXSwTkHKn
         3+YAhhxdY+/H1yZxNIXOajZeG1GwTk3TSzG8RAkbnLRz53CTuqG5ODI8p+juhsNnAve4
         TZCVfM+iWgDdnffO3cR1PIftoUB8Zil/wFzWVefpv50rbXQpWd+i0v/2YqhshO8ChMfU
         N7cyMb73Lebo/A3NqWiRlS88ISob6jecPH6/LhqIDJLhKl2reZosW2vlhpcPm++pa2gC
         y9wUjCImLn13SR4yf+YQcGV/HNyVBdx7HTp5fU4mbKv4n5gX8slyJvFZ/PkRwKBHji0e
         HUqg==
X-Gm-Message-State: AOAM530aCrxwuGTffb0g5Nk8k9qDjuvrfxL2/j5eWyhThPMlWqvO3cEr
        TTKqskcRZs5mum1rUHwb9tB6PQ==
X-Google-Smtp-Source: ABdhPJzJMko7+irpdeI9GclqERGTcpjtciS3jmauwbgSK8PT7+h6Bqr+f1ifRCjQSPchYa7UpUPiKg==
X-Received: by 2002:a17:906:1913:: with SMTP id a19mr1266028eje.390.1629660758771;
        Sun, 22 Aug 2021 12:32:38 -0700 (PDT)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id cn16sm7780053edb.9.2021.08.22.12.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 12:32:38 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     mir@bang-olufsen.dk, alvin@pqrs.dk,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 0/5] net: dsa: add support for RTL8365MB-VC
Date:   Sun, 22 Aug 2021 21:31:38 +0200
Message-Id: <20210822193145.1312668-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

This series adds support for Realtek's RTL8365MB-VC, a 4+1 port
10/100/1000M Ethernet switch. The driver - rtl8365mb - was developed by
Michael Ramussen and myself.

Summary of patches:

  - The first patch in the series is a bugfix in realtek-smi which I
    found when writing the new rtl8365mb subdriver and building
    realtek-smi as a module. If desired, I can spin it off into a
    separate patch and target it for net (not net-next).

  - The second patch updates the dt-bindings for the new compatible
    string.

  - The third patch adds the 8 byte tag protocol driver.

  - The fourth patch adds the rtl8365mb subdriver - the main feature of
    this patch series.

  - The fifth patch adds a PHY driver for the internal PHYs found in the
    RTL8365MB-VC. This is not strictly necessary for the rtl8365mb
    driver to work, but it avoids using the poll-only Generic PHY driver
    directly by hooking into the IRQs made available by the switch
    driver.

This is my first time in the DSA subsystem, so I am submitting this as
an RFC patch series for now. Apologies if I have made some terrible
mistakes along the way. All feedback - no matter how minor - is thus
very welcome.

There is a lot more work that can be done on this driver, particularly
when it comes to offloading certain DSA features to the hardware. I
intend to revisit this later when I have more time. In the mean time,
the driver seems to be in a good enough state for upstream submission.

Finally, there is an outstanding issue in probing the PHY driver when
fw_devlink=on. This seems to be a generic problem with DSA drivers which
create a dependency between an internal interrupt-controller and child
PHY nodes, realtek-smi being one of them. See [1] for an ongoing
discussion about that. Since this seems to be an existing problem and
not unique to this new driver, I hope that it will not impede the
upstreaming of this patch series.

[1] https://lore.kernel.org/netdev/cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk/

Alvin Šipraga (5):
  net: dsa: realtek-smi: fix mdio_free bug on module unload
  dt-bindings: net: dsa: realtek-smi: document new compatible rtl8365mb
  net: dsa: tag_rtl8_4: add realtek 8 byte protocol 4 tag
  net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC
  net: phy: realtek: add support for RTL8365MB-VC internal PHYs

 .../bindings/net/dsa/realtek-smi.txt          |    1 +
 drivers/net/dsa/Kconfig                       |    1 +
 drivers/net/dsa/Makefile                      |    2 +-
 drivers/net/dsa/realtek-smi-core.c            |   10 +
 drivers/net/dsa/realtek-smi-core.h            |    2 +
 drivers/net/dsa/rtl8365mb.c                   | 2124 +++++++++++++++++
 drivers/net/dsa/rtl8366rb.c                   |    8 +
 drivers/net/phy/realtek.c                     |    8 +
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    6 +
 net/dsa/Makefile                              |    1 +
 net/dsa/tag_rtl8_4.c                          |  178 ++
 12 files changed, 2342 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/dsa/rtl8365mb.c
 create mode 100644 net/dsa/tag_rtl8_4.c

-- 
2.32.0

