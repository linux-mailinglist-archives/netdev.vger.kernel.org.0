Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4C44280A2
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhJJLSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhJJLSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:05 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DD8C061570;
        Sun, 10 Oct 2021 04:16:07 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g10so54616655edj.1;
        Sun, 10 Oct 2021 04:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4liKrR8mMA8hT9DKULIIGvwf/DdgjMoFKuhVI7oPpeU=;
        b=mIWh05z815rLEdKLRYBz1YNbz4LXOSZPsAkqtmDcRqpIc8IsQKv+Gl3iV4lxgoWNdl
         WWPOCh1IAAj+yX7jxbalrsl3j9weUuW3wi4f4wta7fW6lHwlvjDBLrVQgAirv2ce/6pz
         uOrNG4GdJgsrfqfGE9T8otBfaSNZPyvi0LlEFqXThwK0AIQQFGVfLJVCnoXuw60XwbIS
         cnjPCYvRi4KiDy8BMxkvJIdGqrIdiHKjeTyKMyGb/UAC1CZGTa5WpR1LgulrMBV+oj/K
         ELpFhTsPrlEFR5HTPWI+op4/nOgyKcMD2fQ4/gVkBWnswBg0MiBFFJZcq9Uni4uPF0L5
         mhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4liKrR8mMA8hT9DKULIIGvwf/DdgjMoFKuhVI7oPpeU=;
        b=f2n5nLj3Wq7e2th9cSoeo3mjmRJHEnJ9c+vVNBG6H5OHsqXQBf9nBUzFNqpAgA8vLW
         lL76j7yKPsB4fVgFYK0oEPDiJrMS2oplsTGOf+Vr3zBR6HYa7uW4IKJysSzG0TBgRd65
         WzGL0Ey4m9OyyXR+RyU1mGqE3j0Ms78yLVnRibzd32swOhhJkc72cc6EeHlab8hfL1e7
         Qkg8AG7tprK4nZrScC4KAVKNd4pUFJBi2Pqe+Vpj0jA/+Jmyto2ZHJ7JQR+J5W1nsNyO
         wnGsutJFJ/4nPFZWELAl6L4ogvxO0j+CN78qLXsCmG0gbs+hMaRWbFMqMeyPL/gqI9eq
         RYkw==
X-Gm-Message-State: AOAM530WjtMU+7SmbzV17iu620uC34jIz/TkJk7OGt12fCkoIVReQAYw
        byzTtDfLSBDr71tbxXJlWlk=
X-Google-Smtp-Source: ABdhPJz/hgTlT3Lx9B5eovDZsPc3anVeNsXwlbB1Jb01I4Z+RoDqSKiKa23Ccu4xnMmlo8IlCGsqBA==
X-Received: by 2002:a50:d84e:: with SMTP id v14mr31404777edj.85.1633864565639;
        Sun, 10 Oct 2021 04:16:05 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:05 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v4 00/13] Multiple improvement for qca8337 switch
Date:   Sun, 10 Oct 2021 13:15:43 +0200
Message-Id: <20211010111556.30447-1-ansuelsmth@gmail.com>
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

Changes v4:
- Fix typo in SGMII falling edge about using PHY id instead of
  switch id

Changes v3:
- Drop phy patches (proposed separateley)
- Drop special pwr binding. Rework to ipq806x specific
- Better describe compatible and add serial print on switch chip
- Drop mac exchange. Rework falling edge and move it to mac_config
- Add support for port 6 cpu port. Drop hardcoded cpu port to port0
- Improve port stability with sgmii. QCA source have intenal delay also
  for sgmii
- Add warning with pll enabled on wrong configuration

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

Ansuel Smith (13):
  net: dsa: qca8k: add mac_power_sel support
  net: dsa: qca8k: add support for sgmii falling edge
  dt-bindings: net: dsa: qca8k: Add MAC swap and clock phase properties
  drivers: net: dsa: qca8k: add support for cpu port 6
  dt-bindings: net: dsa: qca8k: Document support for CPU port 6
  net: dsa: qca8k: move rgmii delay detection to phylink mac_config
  net: dsa: qca8k: add explicit SGMII PLL enable
  dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
  drivers: net: dsa: qca8k: add support for pws config reg
  dt-bindings: net: dsa: qca8k: document open drain binding
  drivers: net: dsa: qca8k: add support for QCA8328
  dt-bindings: net: dsa: qca8k: document support for qca8328
  drivers: net: dsa: qca8k: set internal delay also for sgmii

 .../devicetree/bindings/net/dsa/qca8k.txt     |  38 ++-
 drivers/net/dsa/qca8k.c                       | 285 +++++++++++++-----
 drivers/net/dsa/qca8k.h                       |  21 +-
 3 files changed, 262 insertions(+), 82 deletions(-)

-- 
2.32.0

