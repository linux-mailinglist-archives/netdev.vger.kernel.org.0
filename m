Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666BD619EFF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiKDRmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiKDRl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:41:59 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1391AB842;
        Fri,  4 Nov 2022 10:41:56 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BE086FF804;
        Fri,  4 Nov 2022 17:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667583715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hRN6TmZRqEG3ji2w4dBfaFdcgHUq8qs2x6FTGFXjvdU=;
        b=LsPg9BvXp6A+afED5a5+DSQw2o+6gW5FbJIIR+Nh9jc68J5IYwq8agjnV330+84uRtIhGw
        u/AjZ0S+EsH6BcOASDjvownFRu2iBydlJbYPtvg524UlqOqbXAGEDi2OnSgyNq6uvBW/Ls
        9j9tQ7rHh/L4EFE+H4K8VBUW7NNHJsF1S8pnZwnCmDzz6nLRmNkWEN59UcekU0t5VNqdLL
        JxX90haEq7UpiQOY6tPHhtlfOIkCbHU/L3RTrzAQNIY+6InDJyf43vZGIr935oi927yfNR
        d7r5mZ2SXelxgsfJdMWKalb2GMti3LJSn17OfVECwbjHAqYYVMMBdNnGL9xdWA==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: [PATCH net-next v8 0/5] net: ipqess: introduce Qualcomm IPQESS driver
Date:   Fri,  4 Nov 2022 18:41:46 +0100
Message-Id: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

This is the 8th iteration on the IPQESS driver, that includes a new
DSA tagger to let the MAC convey the tag to the switch through an
out-of-band medium, here using DMA descriptors.

Notables changes on v8 :
 - Added fixed-link in the dtsi SoC file
 - Removed the ethernet0 alias from the dtsi
 - Added a missing blank line in tagger driver

Notables changes on V7 :
 - Fixed sparse warnings
 - Fixed a typo in the bindings
 - Added missing maintainers in CC

Notables changes on V6 :
 - Cleanup unused helpers and fields in the tagger
 - Cleanup ordering in various files
 - Added more documentation on the tagger
 - Fixed the CHANGEUPPER caching
 - Cleanups in the IPQESS driver

Notables changes on V5 :
 - Fix caching of CHANGEUPPER events
 - Use a skb extension-based tagger
 - Rename the binding file
 - Some cleanups in the ipqess driver itself

Notables changes on V4 :
 - Cache the uses_dsa info from CHANGEUPPER events
 - Use better string handling helpers for ethtool stats
 - rename ethtool callbacks
 - Fix a binding typo

Notables changes on V3 :
 - Took into account Russell's review on the ioctl handler and the mac
   capabilities that were missing
 - Took Andrew's reviews into account by reworking the napi rx loop,
   some stray "inline" keywords, and useless warnings
 - Took Vlad's reviews into account by reworking a few macros
 - Took Christophe's review into account by removing extra GFP_ZERO
 - Took Rob's review into account by simplifying the binding

Notables changes on V2 :
 - Put the DSA tag in the skb itself instead of using skb->shinfo
 - Fixed the initialisation sequence based on Andrew's comments
 - Reworked the error paths in the init sequence
 - Add support for the clock and reset lines on that controller
 - Fixed and updated the binding

The driver itself is pretty straightforward, but has lived out-of-tree
for a while. I've done my best to clean-up some outdated API calls, but
some might remain.

This controller is somewhat special, since it's part of the IPQ4019 SoC
which also includes an QCA8K switch, and uses the IPQESS controller for
the CPU port. The switch is so tightly intergrated with the MAC that it
is connected to the MAC using an internal link (hence the fact that we
only support PHY_INTERFACE_MODE_INTERNAL), and this has some
consequences on the DSA side.

The tagging for the switch isn't done inband as most switch do, but
out-of-band, the DSA tag being included in the DMA descriptor.

This series includes a new out-of-band tagger that uses skb extensions
to convey the tag between the tagger and the MAC driver.

Thanks to the Sartura folks who worked on a base version of this driver,
and provided test hardware.

Best regards,

Maxime

Maxime Chevallier (5):
  net: dt-bindings: Introduce the Qualcomm IPQESS Ethernet controller
  net: ipqess: introduce the Qualcomm IPQESS driver
  net: dsa: add out-of-band tagging protocol
  net: ipqess: Add out-of-band DSA tagging support
  ARM: dts: qcom: ipq4019: Add description for the IPQESS Ethernet
    controller

 .../bindings/net/qcom,ipq4019-ess-edma.yaml   |   94 ++
 Documentation/networking/dsa/dsa.rst          |   13 +-
 MAINTAINERS                                   |    8 +
 arch/arm/boot/dts/qcom-ipq4019.dtsi           |   48 +
 drivers/net/ethernet/qualcomm/Kconfig         |   12 +
 drivers/net/ethernet/qualcomm/Makefile        |    2 +
 drivers/net/ethernet/qualcomm/ipqess/Makefile |    8 +
 drivers/net/ethernet/qualcomm/ipqess/ipqess.c | 1308 +++++++++++++++++
 drivers/net/ethernet/qualcomm/ipqess/ipqess.h |  522 +++++++
 .../ethernet/qualcomm/ipqess/ipqess_ethtool.c |  164 +++
 include/linux/dsa/oob.h                       |   16 +
 include/linux/skbuff.h                        |    3 +
 include/net/dsa.h                             |    2 +
 net/core/skbuff.c                             |   10 +
 net/dsa/Kconfig                               |    9 +
 net/dsa/Makefile                              |    1 +
 net/dsa/tag_oob.c                             |   49 +
 17 files changed, 2268 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq4019-ess-edma.yaml
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/Makefile
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess.c
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess.h
 create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess_ethtool.c
 create mode 100644 include/linux/dsa/oob.h
 create mode 100644 net/dsa/tag_oob.c

-- 
2.37.3

