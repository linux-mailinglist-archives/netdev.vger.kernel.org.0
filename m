Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C1F42849C
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbhJKBcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbhJKBcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:32:41 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52899C061570;
        Sun, 10 Oct 2021 18:30:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id d3so33700207edp.3;
        Sun, 10 Oct 2021 18:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=In+JRarX2nyGbELg94Ye35SZR6x4eidKj+QFaJYHnf4=;
        b=HhGxPqHFo1foKcr5H+M2AtO3lYSm85kpuM+ITZyRofw0BNVdQD4zAWajcCTUFJHwRs
         9UdYGoTv9/E38qpc35WMVImM8jM1sM3QEH7UlfYlEOhnx5WQlsXXa4hxOZj62zLwLfCt
         012HoUIerlYQvwabN/siE6tLZlakhNq/D3fGgdpHJ1akFm2sr7+CwlVlD/NHydyRS1El
         NAC0KBHQIcZZnkFIRMgHdlI4WifMbFy62LNCLqdVjrWtg9ffwwmsflN2icDwlwCAtAG5
         zFvQ7GI1JzDRdKRKY+Vk+eRIxGLV2l8EsSuqfVLkKkAWOQGSgmU50+7f07C/xthgNLN+
         nSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=In+JRarX2nyGbELg94Ye35SZR6x4eidKj+QFaJYHnf4=;
        b=kNutkpUZeXiNgeTB6+GSSIsnk/SsssKc/jxmS4d2QZTUAibQcH96hvWTbJMNoOebVj
         P4m6qzuCcnZnIc8EuuQtP7hsLRXMdE4GqrAU+vB5OjFKXrOqr1inGHrakEoeSzXDC3g9
         OlnIuvEuWvDCEbS8zMfACJTDvMaQ7pW9JPTgsAe+9x1U+NfYZ48xqqhlxbLrirErqAgn
         sL7FDdLdv68nCwUePGdLQd3bhclel5nlBQ9qwnJFM5riqLDVwoaEQYpPb38tYkWcxFs2
         qOX3jUreDYJUnjL/eM0svommEJOb7/CZbjypPPgnA1lg/t0zeij66HuWSdhOlb3yIYpr
         npxQ==
X-Gm-Message-State: AOAM530wDzbvy2C7NmmARTst1y2/upH2x8OsmsU4KWXD5Gs9PMzYousG
        PvR7pc9h7S9Fgxv28dxg6So=
X-Google-Smtp-Source: ABdhPJwkpTaHBBzjL7+ab5Y9nKz6SGMtncmFQFGISyD9S2/eTwCfkA0KNla1QOs7BVT0/eB2p4+UEw==
X-Received: by 2002:aa7:cd8b:: with SMTP id x11mr38551618edv.384.1633915840641;
        Sun, 10 Oct 2021 18:30:40 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:40 -0700 (PDT)
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
Subject: [net-next PATCH v5 00/14] Multiple improvement for qca8337 switch
Date:   Mon, 11 Oct 2021 03:30:10 +0200
Message-Id: <20211011013024.569-1-ansuelsmth@gmail.com>
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
Ansuel Smith (14):
  net: dsa: qca8k: add mac_power_sel support
  dt-bindings: net: dsa: qca8k: Add SGMII clock phase properties
  net: dsa: qca8k: add support for sgmii falling edge
  dt-bindings: net: dsa: qca8k: Document support for CPU port 6
  drivers: net: dsa: qca8k: add support for cpu port 6
  net: dsa: qca8k: rework rgmii delay logic and scan for cpu port 6
  dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
  net: dsa: qca8k: add explicit SGMII PLL enable
  dt-bindings: net: dsa: qca8k: Document qca,led-open-drain binding
  drivers: net: dsa: qca8k: add support for pws config reg
  dt-bindings: net: dsa: qca8k: document support for qca8328
  drivers: net: dsa: qca8k: add support for QCA8328
  drivers: net: dsa: qca8k: set internal delay also for sgmii
  drivers: net: dsa: qca8k: move port config to dedicated struct

 .../devicetree/bindings/net/dsa/qca8k.txt     |  38 +-
 drivers/net/dsa/qca8k.c                       | 350 ++++++++++++++----
 drivers/net/dsa/qca8k.h                       |  35 +-
 3 files changed, 339 insertions(+), 84 deletions(-)

-- 
2.32.0

