Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB72068737F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 04:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjBBDBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 22:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBBDBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 22:01:08 -0500
Received: from out29-124.mail.aliyun.com (out29-124.mail.aliyun.com [115.124.29.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00661710;
        Wed,  1 Feb 2023 19:01:02 -0800 (PST)
X-Alimail-AntiSpam: AC=SUSPECT;BC=0.63959|-1;BR=01201311R451b1;CH=blue;DM=|SUSPECT|false|;DS=CONTINUE|ham_system_inform|0.000518413-2.39536e-05-0.999458;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047205;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=18;RT=18;SR=0;TI=SMTPD_---.R7sRqPV_1675306854;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.R7sRqPV_1675306854)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 11:00:58 +0800
From:   Frank Sae <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        yanhong.wang@starfivetech.com
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v5 0/5] add dts for yt8521 and yt8531s, add driver for yt8531
Date:   Thu,  2 Feb 2023 11:00:32 +0800
Message-Id: <20230202030037.9075-1-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Add dts for yt8521 and yt8531s, add driver for yt8531.
 These patches have been verified on our AM335x platform (motherboard)
 which has one integrated yt8521 and one RGMII interface.
 It can connect to daughter boards like yt8531s or yt8531 board.

 v5:
 - change the compatible of yaml
 - change the maintainers of yaml from "frank sae" to "Frank Sae"

 v4:
 - change default tx delay from 150ps to 1950ps
 - add compatible for yaml

 v3:
 - change default rx delay from 1900ps to 1950ps
 - moved ytphy_rgmii_clk_delay_config_with_lock from yt8521's patch to yt8531's patch
 - removed unnecessary checks of phydev->attached_dev->dev_addr

 v2:
 - split BIT macro as one patch
 - split "dts for yt8521/yt8531s ... " patch as two patches
 - use standard rx-internal-delay-ps and tx-internal-delay-ps, removed motorcomm,sds-tx-amplitude
 - removed ytphy_parse_dt, ytphy_probe_helper and ytphy_config_init_helper
 - not store dts arg to yt8521_priv 

Frank Sae (5):
  dt-bindings: net: Add Motorcomm yt8xxx ethernet phy
  net: phy: Add BIT macro for Motorcomm yt8521/yt8531 gigabit ethernet
    phy
  net: phy: Add dts support for Motorcomm yt8521 gigabit ethernet phy
  net: phy: Add dts support for Motorcomm yt8531s gigabit ethernet phy
  net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy

 .../bindings/net/motorcomm,yt8xxx.yaml        | 117 ++++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 MAINTAINERS                                   |   1 +
 drivers/net/phy/Kconfig                       |   2 +-
 drivers/net/phy/motorcomm.c                   | 553 +++++++++++++++---
 5 files changed, 597 insertions(+), 78 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml

-- 
2.34.1

