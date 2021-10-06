Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BB74249BF
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239620AbhJFWiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbhJFWiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:23 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB6DC061746;
        Wed,  6 Oct 2021 15:36:30 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r18so15507947edv.12;
        Wed, 06 Oct 2021 15:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9k7TWptIH/bFMs9Um5tkzN7D5KkD58vun6yLJntZ8VE=;
        b=inohWf6JX+4CAey/G4R5c4WQ70lcvhnI/8QNuaZs5Sm46nbEJiZkXLzsBrxzEr/wuS
         DZokEJMEzAikbAccMeG4/HZszFpzmKVS+iGkFeTmaV6Fj6/nRu9fHmdOk7ix1w4m3NiY
         BBqjWXlsIbv0kUnvAQGR9eO71WWggy1s+OiJcBZpJHh7gJw92N/Cmq1d3CemtuJzY5sK
         GnNRrCEshLrJa9Ao91fryZlMepS//cmKMd76bHYBxIffig5AZVZQU1bBHwKwDwXsapIn
         Y33x7IMiKWn0qGC4ighHF7pHx4KhXIX6ga0+GUxDiG7UAI2yrcduaDi3pe2OKJtPbPF8
         znDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9k7TWptIH/bFMs9Um5tkzN7D5KkD58vun6yLJntZ8VE=;
        b=HCaDMlNZZnzOwNAS6QtUHNONAu85YgYeTSJf3n+ol5MxWmFEM7SHX9Rx9V0k2saIhv
         HKs/B0xavCWX/8f5hoNX50pr4LzmSXGuzpJ9TbF+NUybGOHU/XwIn41mtAyvTzIz4INy
         rMCbhVtw39n+3UOHSDxjq2GSnypG4xWrg/WVRn8JE/1XORAADHwYU39jSSa2qykJgwvE
         FenPDDMXNkG0WIQk7j5dtfBTpkop7TIvgskNyx60+EOXlvrY0pPqtl5DNWX+fHXIMV+B
         GjICDI5+V++fUHWVU1PSR9FSzAy3vWvcej7LER1ReyGlTSoht8DoO+VjVPtiwUq5Y5AR
         AWaw==
X-Gm-Message-State: AOAM530ALAzD3Q4sIh1Y6w2vpLdo4B+USPAAqR90FWFVzM6J3T42mL45
        TbhjZRAqwhMyENZbMEJpmVQ=
X-Google-Smtp-Source: ABdhPJxQGzGTNGXydsEi+8ffXjlVbCrzVSLna5MchKheaplv+Lo7Syp7kK63JvVBRSTp63+4PislhQ==
X-Received: by 2002:a50:d50c:: with SMTP id u12mr1269343edi.118.1633559788671;
        Wed, 06 Oct 2021 15:36:28 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:28 -0700 (PDT)
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
Subject: [net-next PATCH 00/13] Multiple improvement for qca8337 switch
Date:   Thu,  7 Oct 2021 00:35:50 +0200
Message-Id: <20211006223603.18858-1-ansuelsmth@gmail.com>
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

Ansuel Smith (13):
  drivers: net: phy: at803x: fix resume for QCA8327 phy
  drivers: net: phy: at803x: add DAC amplitude fix for 8327 phy
  drivers: net: phy: at803x: enable prefer master for 83xx internal phy
  drivers: net: phy: at803x: better describe debug regs
  net: dsa: qca8k: add mac_power_sel support
  Documentation: devicetree: net: dsa: qca8k: document rgmii_1_8v
    bindings
  net: dsa: qca8k: add support for mac6_exchange, sgmii falling edge
  dt-bindings: net: dsa: qca8k: Add MAC swap and clock phase properties
  net: dsa: qca8k: check rgmii also on port 6 if exchanged
  net: dsa: qca8k: add explicit SGMII PLL enable
  devicetree: net: dsa: qca8k: Document qca,sgmii-enable-pll
  drivers: net: dsa: qca8k: add support for pws config reg
  Documentation: devicetree: net: dsa: qca8k: document open drain
    binding

 .../devicetree/bindings/net/dsa/qca8k.txt     |  11 ++
 drivers/net/dsa/qca8k.c                       | 111 ++++++++++++++-
 drivers/net/dsa/qca8k.h                       |  11 ++
 drivers/net/phy/at803x.c                      | 127 +++++++++++++++---
 4 files changed, 240 insertions(+), 20 deletions(-)

-- 
2.32.0

