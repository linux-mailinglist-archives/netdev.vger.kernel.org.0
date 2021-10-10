Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950E9427E3F
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhJJB6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhJJB6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:08 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D233CC061570;
        Sat,  9 Oct 2021 18:56:10 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id d3so24497593edp.3;
        Sat, 09 Oct 2021 18:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gTfaka8Pz1ktsGyu11SQTbgTqP0j1W5UerGz8aBIKfw=;
        b=X5BB5xeJAey+a+fjT11tj4xEsuk3+0bPxjkZeEdYR2RpuJ5h/xiiaz+OsEsrjZDRfJ
         H4dt9a8obXVEqf9ADqmUc/0QPZnYXtfHDZEpczjgA1I5oAn7+LUbItIyWvwaVQTiF0/Z
         8Bp/iwUAtESjXIAdIACHOqA1D+eLlSS+CnbWmEQGy72X8PvJ6DWEOJ6kAbYZ/lDgxRCS
         fJikDwqlS29IMD7gFuHdqcPGVz0afuWKX3VxlAYzfOL55phEa8YAgsqNQi3mLBx+RyuT
         EdUQqbrV1VNr+rJmKI2w1N0EmU/tPgfe4pwSu5MdmWkbES5xHfrTTm/4szI64m+RgNyN
         PyrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gTfaka8Pz1ktsGyu11SQTbgTqP0j1W5UerGz8aBIKfw=;
        b=Zj6l4u+yuzLfdrUJ9iPgQwjd7cGmyYwvHzo5QhKvfOusM7mz+85sblIUNk53uvrgY/
         aMuAKQiVVL4fRKQdwpaa4MfBjz+DYdmttgykNQcAhWatanU/hVlmS4/VtvPmu45uBw9/
         GYi8mQc6N3M2sMibAEjdlq2ly4YYfkCL4imNkXKX9vjihOVH9UHhUxYGsfX5UgQfWwxc
         +mXB5Kj34o1TJscXEmwJcEMac951h7pwJFMIT690euEsS7HKx67iunJEHN06WvqwpOHk
         9kJjKc1fdZ9+MakUdQ8Sb6ThjADxI7puQptGzhN4ZdH4JiElY0xjoD1mPDHWjB3fMQfE
         XeeA==
X-Gm-Message-State: AOAM530iCJguX5485v37R6W1IlJngpk1SbTveo1ysuI2bTYmGells+aR
        FvkhMpjaJT7qPIev8Qi7uI0=
X-Google-Smtp-Source: ABdhPJx+fjPXhOPOASEr4Ddv2f+PQ7q0TZ8/Jd5QXUKnhNEi23OTSqja5UCttDDNQq60M5ePq4bkWQ==
X-Received: by 2002:a17:906:368c:: with SMTP id a12mr15803241ejc.143.1633830969037;
        Sat, 09 Oct 2021 18:56:09 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:08 -0700 (PDT)
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
Subject: [net-next PATCH v3 00/13] Multiple improvement for qca8337 switch
Date:   Sun, 10 Oct 2021 03:55:50 +0200
Message-Id: <20211010015603.24483-1-ansuelsmth@gmail.com>
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

