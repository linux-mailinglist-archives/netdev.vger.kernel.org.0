Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811AE426115
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241742AbhJHAY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbhJHAY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:24:56 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865C9C061570;
        Thu,  7 Oct 2021 17:23:01 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id i20so13530459edj.10;
        Thu, 07 Oct 2021 17:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LyjEeedD0BxDJuvasLd7RHLEOZodhxXpgHAP8dUw5Fs=;
        b=Ud7ZBs6a66t8Au7A5b3N5E4w8dKUd2I8F3L7hD6XsTm1hiTVL9Ig8BOluZXWLKytUV
         2iZLYmHGwZK4AQFTiYAQ+Pe3QnVqAPpVKUJNNbDpnQkKkddzmUQ7IaGGBjKoGmcRo174
         V/VZtRNlWtUu6uULWzpYzVmbZHDA9hjdcNr3NDdnOyGuZLAC/AbW4hMss+zQuBOYuF5N
         v5O0htp3SifZZa5eF4TVSZkAeoqSxxBn2Rv4yu0352du8RURwPcy+rPdpSwgVE9Ubszp
         585MhrIeZbECOVIYJMnfHgS7deKByaigyxI61p5NgOXUMUh6JV2Wao+KBetauEiYX9B7
         22xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LyjEeedD0BxDJuvasLd7RHLEOZodhxXpgHAP8dUw5Fs=;
        b=H6a+b1hHDYml4sUGOi+Ac4limo9DQgwjxRxlM71yDwTZFHt9TFA+kcOzvErlDlg4fY
         sc28y/uyTJxf5NNr1xI9MOzGMVysdv+TWui2F+EJR7/UkKByFk4VALYbNOsHN6CQyHJt
         DHImoFeUhL0ZnKnei1yx6U1CtPwdcEIW+0SJ7aZ8UtL8QM8m7dsbhW8qu8ECfPfz+HHb
         S76v5Opezh9ynspcIrkdcOUEP7ULYzM41VmaI3heNqsnFoQ1i6RNWfGwMfvqdLvCfiXL
         Zq/33s7yhZW/6C1cUmhTK/cN77f60NYSf8Zq46bsO0r2Hcd72iwI5Z3sagBVVVZZGN6t
         erdg==
X-Gm-Message-State: AOAM532u0+T4w572dadiLPuJ5zgwe5Zq1HrDCuFwYs477ImXSRQd8MU3
        euo5Fby2nqIRmed/eJymqDs=
X-Google-Smtp-Source: ABdhPJzeMXdtkCxz5Zv++DUsXNxpvAPlpnr9KC7mMMKSxdaHBqzP8i34xRW3orrxSY0Qp21NxiohRw==
X-Received: by 2002:a17:906:230c:: with SMTP id l12mr173474eja.52.1633652579998;
        Thu, 07 Oct 2021 17:22:59 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:22:59 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH v2 00/15] Multiple improvement for qca8337 switch
Date:   Fri,  8 Oct 2021 02:22:10 +0200
Message-Id: <20211008002225.2426-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is the final step of a long process of porting 80+ devices
to use the new qca8k driver instead of the hacky qca one based on never
merged swconfig platform.
Some background to justify all these additions.
QCA used a special binding to declare raw initval to set the swich. I
made a script to convert all these magic values and convert 80+ dts and
scan all the needed "unsupported regs". We find a baseline where we
manage to find the common and used regs so in theory hopefully we don't
have to add anymore things.
We discovered lots of things with this, especially about how differently
qca8327 works compared to qca8337.

In short, we found that qca8327 have some problem with suspend/resume for
their internal phy. It instead sets some dedicated regs that suspend the
phy without setting the standard bit. First 4 patch are to fix this.
There is also a patch about preferring master. This is directly from the
original driver and it seems to be needed to prevent some problem with
the pause frame.

Every ipq806x target sets the mac power sel and this specific reg
regulates the output voltage of the regulator. Without this some
instability can occur.

Some configuration (for some reason) swap mac6 with mac0. We add support
for this.
Also, we discovered that some device doesn't work at all with pll enabled
for sgmii line. In the original code this was based on the switch
revision. In later revision the pll regs were decided based on the switch
type (disabled for qca8327 and enabled for qca8337) but still some
device had that disabled in the initval regs.
Considering we found at least one qca8337 device that required pll
disabled to work (no traffic problem) we decided to introduce a binding
to enable pll and set it only with that.

Lastly, we add support for led open drain that require the power-on-sel
to set. Also, some device have only the power-on-sel set in the initval
so we add also support for that. This is needed for the correct function
of the switch leds.
Qca8327 have a special reg in the pws regs that set it to a reduced
48pin layout. This is needed or the switch doesn't work.

These are all the special configuration we find on all these devices that
are from various targets. Mostly ath79, ipq806x and bcm53xx.

Changes v2:
- Reword Documentation patch to dt-bindings
- Propose first 2 phy patch to net
- Better describe and add hint on how to use all the new
  bindings 
- Rework delay scan function and move to phylink mac_config
- Drop package48 wrong binding
- Introduce support for qca8328 switch
- Fix wrong binding name power-on-sel
- Return error on wrong config with led open drain and 
  ignore-power-on-sel not set

Ansuel Smith (15):
  drivers: net: phy: at803x: fix resume for QCA8327 phy
  drivers: net: phy: at803x: add DAC amplitude fix for 8327 phy
  drivers: net: phy: at803x: enable prefer master for 83xx internal phy
  drivers: net: phy: at803x: better describe debug regs
  net: dsa: qca8k: add mac_power_sel support
  dt-bindings: net: dsa: qca8k: document rgmii_1_8v bindings
  net: dsa: qca8k: add support for mac6_exchange, sgmii falling edge
  dt-bindings: net: dsa: qca8k: Add MAC swap and clock phase properties
  net: dsa: qca8k: move rgmii delay detection to phylink mac_config
  net: dsa: qca8k: add explicit SGMII PLL enable
  dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
  drivers: net: dsa: qca8k: add support for pws config reg
  dt-bindings: net: dsa: qca8k: document open drain binding
  drivers: net: dsa: qca8k: add support for QCA8328
  dt-bindings: net: dsa: qca8k: document support for qca8328

 .../devicetree/bindings/net/dsa/qca8k.txt     |  31 +++
 drivers/net/dsa/qca8k.c                       | 207 ++++++++++++------
 drivers/net/dsa/qca8k.h                       |  17 +-
 drivers/net/phy/at803x.c                      | 127 +++++++++--
 4 files changed, 302 insertions(+), 80 deletions(-)

-- 
2.32.0

