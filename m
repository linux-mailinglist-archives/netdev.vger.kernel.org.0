Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D125942B1E8
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbhJMBS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhJMBS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:29 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5163C061570;
        Tue, 12 Oct 2021 18:16:26 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g8so3161851edt.7;
        Tue, 12 Oct 2021 18:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2JmKy8xN/pIap5yTmxsvrf4D29OhIHecjCNJEgH+8XY=;
        b=ksp/MR7Day9yp5UQ5VpthHoia50Ys7kQvpUycsnEgdNznLU3/7RV4EA87y0zCrW80x
         FUWf6mtL8+vjH9GzfLvCrlF76eO66+AbED2wAOhPPKfzZ7Z7yTmrf0x+aY3B1LHKiQ8q
         B8Kyv2B5Bkv+8yjJ8XMPwvg5j5F+bYkznHPmDjcobf7n9CyP+URcpAih4FiKmGRB51yT
         wn5R+4ZHSr7jEXABKT5Oe2nJHBMOhgOLQfKEwtYb54lq4f/YKpkhiy2nWrepzhbu9JIz
         PD7woefB0gWwpEdRifdaKuLBPbAXHri39UUe1d9ehILCW9PTwCZTDBDY1cPhT4T5JjFm
         hXkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2JmKy8xN/pIap5yTmxsvrf4D29OhIHecjCNJEgH+8XY=;
        b=79vjRx3Rrl/uVs4NWlYoz0BoNvMexg3J6HNOxymYKhoKebZXXlv885XImSafpqlLTT
         69vSNYzZAnLaAAh4HD6BMF6IyjNE8vpvRM/49LKXGrJhYoKg3B0UK4VSJo6lX8Swb4js
         cioCsyKYod8zEjrlGHtPWX/xLOzjKCOBcA5x2DMZIhv9WlNJOxzTgirS8VJfy/Pdyg3k
         Zm9bjR3UtY2BQHSk0T7x6sYKXUuW6Rd/ZSVxdUeyrkFqZnbqprQNfza3wpsKeXhf8MH8
         ATDr7vq53YpcGyffYpb1Baf1OeBzPJv2srlAqUWGpNL200o49fdVgVQROnNMhaWL3U2t
         dvLg==
X-Gm-Message-State: AOAM530RauAsFS9LD0+4AMP+yOTw6nXg1UYRZtSeZWwuBuA0e84ZWw2H
        dTAXbLi0/AtHWQCl/tiq8ac=
X-Google-Smtp-Source: ABdhPJzkYp9U7ob7F0PAVVc8woRTE2y+GjPy85wxbgP37C0GBnqM5bF2qTplabpLiu6OXOW1+0GPiw==
X-Received: by 2002:a17:906:7d09:: with SMTP id u9mr17243706ejo.120.1634087785079;
        Tue, 12 Oct 2021 18:16:25 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:24 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v6 00/16] Multiple improvement for qca8337 switch
Date:   Wed, 13 Oct 2021 03:16:06 +0200
Message-Id: <20211013011622.10537-1-ansuelsmth@gmail.com>
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

Changes v6:
- Convert Documentation to yaml
- Add extra check for cpu port and invalid phy mode
- Add co developed by tag to give credits to Matthew

Changes v5:
- Swap patch. Document first then implement.
- Fix some grammar error reported.
- Rework function. Remove phylink mac_config DT scan and move everything
  to dedicated function in probe.
- Introduce new logic for delay selection where is also supported with
  internal delay declared and rgmii set as phy mode
- Start working on ymal conversion. Will later post this in v6 when we
  finally take final decision about mac swap.

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

Ansuel Smith (15):
  dsa: qca8k: add mac_power_sel support
  dt-bindings: net: dsa: qca8k: Add SGMII clock phase properties
  net: dsa: qca8k: add support for sgmii falling edge
  dt-bindings: net: dsa: qca8k: Document support for CPU port 6
  net: dsa: qca8k: add support for cpu port 6
  net: dsa: qca8k: rework rgmii delay logic and scan for cpu port 6
  dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
  net: dsa: qca8k: add explicit SGMII PLL enable
  dt-bindings: net: dsa: qca8k: Document qca,led-open-drain binding
  net: dsa: qca8k: add support for pws config reg
  dt-bindings: net: dsa: qca8k: document support for qca8328
  net: dsa: qca8k: add support for QCA8328
  net: dsa: qca8k: set internal delay also for sgmii
  net: dsa: qca8k: move port config to dedicated struct
  dt-bindings: net: ipq8064-mdio: fix warning with new qca8k switch

Matthew Hagan (1):
  dt-bindings: net: dsa: qca8k: convert to YAML schema

 .../devicetree/bindings/net/dsa/qca8k.txt     | 215 -----------
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 362 +++++++++++++++++
 .../bindings/net/qcom,ipq8064-mdio.yaml       |   5 +-
 drivers/net/dsa/qca8k.c                       | 364 ++++++++++++++----
 drivers/net/dsa/qca8k.h                       |  35 +-
 5 files changed, 685 insertions(+), 296 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.yaml

-- 
2.32.0

