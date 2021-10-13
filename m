Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5323942CE8A
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhJMWlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhJMWlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:31 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F904C061570;
        Wed, 13 Oct 2021 15:39:27 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id t16so16414301eds.9;
        Wed, 13 Oct 2021 15:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fs7a+pJLX7Ly1b5/OfKoQ2CNdMi+iCB+c5iETb3iJAs=;
        b=khosMBTpnaYqwJtL2CNzhlhzg7ycqBssztC3dQq7A0hUdzuumZGEgCdm/QoQYPTJGm
         O9EqmnnbNLq+l4fQm6DQHDX9oh5F0qWWx/TCDubPISPwLTX2KbGOd54atFA7jiqcKF4a
         8FtvY4r2JOjo5JM6r8eQAp5cw6B5Q/z8xsHz/WaUN9sqyPqsAeWNu6HHgRJpnsExUcpN
         l7rKe+SL1Z0slT8oxuwAvwjvehhEKCUiGkfGzJprwnjVJOFZIIkexd1DnhvPLwLWVirG
         QGK2et4PwwF9S/UoJj5h8KEvjkHIY3BtX+iDQDrVkvzzBeOGBjksTw7arIbou7rNNzB+
         mxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fs7a+pJLX7Ly1b5/OfKoQ2CNdMi+iCB+c5iETb3iJAs=;
        b=k+fOKrHO35sFWbwEHpnZsTEUtGZFLznBtuYkp/fMEquA0atFTS0xev9QI81KS9JxWy
         HqetWEsnEgaidDHWyr1CTGZz7pUyhSG6j5MC6MOAqPCuUhEr1J0hlvfArGAn1jCxbh29
         mB9hNXMWF43kCU3doEZnKPS0sHJOAMXbHATDvWr2mcYxNn9GKTPHPLd6aPlNfx/UOuju
         g8MYlhSAwjH8yu/8pkEWftxi7qXF7lNZN/+blGHMTZ2t8rYt8lGRQhf1NIaEflVdEmLj
         t70PAsMEz16bKMhVrdLMC/8hbWFDZXg5+yOXHmThFsTWcbcc/p7d+p+Enegcr0+2AYSb
         YYvg==
X-Gm-Message-State: AOAM531KJdlPmhuXpYsgOntXj5gNLlC648NP11aMRFcklVuMb+fZbEDg
        vM3f4FAIDnaY2n1ThVqN4ew=
X-Google-Smtp-Source: ABdhPJxDYcPnEWE6ikXctbosVkrqvdZMNzCOh35EqnVabtdstIixYM2EI2l4JGHrWjdmhJPe3HKjoA==
X-Received: by 2002:a17:906:1f09:: with SMTP id w9mr2390251ejj.472.1634164765460;
        Wed, 13 Oct 2021 15:39:25 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:25 -0700 (PDT)
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
Subject: [net-next PATCH v7 00/16] Multiple improvement for qca8337 switch
Date:   Thu, 14 Oct 2021 00:39:05 +0200
Message-Id: <20211013223921.4380-1-ansuelsmth@gmail.com>
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

This was the original implementation. Since we decided that mac swap
doesn't make sense, we decided to rework the driver to accept a
configuration with just the CPU port6 defined.

Lastly, we add support for led open drain that require the power-on-sel
to set. Also, some device have only the power-on-sel set in the initval
so we add also support for that. This is needed for the correct function
of the switch leds.
Qca8327 have a special reg in the pws regs that set it to a reduced
48pin layout. This is needed or the switch doesn't work.

These are all the special configuration we find on all these devices that
are from various targets. Mostly ath79, ipq806x and bcm53xx

Changes v7:
- Fix missing newline in yaml
- Handle error with wrong cpu port detected
- Move yaml commit as last to fix bot error

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
 drivers/net/dsa/qca8k.c                       | 365 ++++++++++++++----
 drivers/net/dsa/qca8k.h                       |  35 +-
 5 files changed, 685 insertions(+), 297 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.yaml

-- 
2.32.0

