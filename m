Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FE152C43A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242360AbiERUJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242355AbiERUJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:09:49 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FB420EE29
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:09:47 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id p5-20020a1c2905000000b003970dd5404dso1629388wmp.0
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UQvDOEplxNi18/Jxa8yZiTJ2YNZLIpsMwzvuZh33DE4=;
        b=lb2LXhnv3KRqu2NBVbbFYLjc9vviV+NW9xcex3N3B4BXG48hS8qT6t+rByuDUgWlwm
         Lk7CO2bbUQm7wjKqB7CRZTsZh5Mn8VkSK1JB9ctk81t1iMnHrewBL5bLjaU+NvNf3YlQ
         SE2q8xOJXLgD488r22FnpoXL69/kvIrYLWGBtJXlHW8/Kxi7cUwZfE573ZgEAnoh42FJ
         ST/AbhiIDDYtd/Uj2POZ79FWKKwVCIhmhytQs10O14g9ncj4zWiPpGhkKDKgabLKdAos
         KXQNnpNCj8p/BEoQ/hvkw7prPMMwfZB5zJ/YJwDDvb2pQdHOLmLbJKmu6Y90XFAUE2jY
         SBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UQvDOEplxNi18/Jxa8yZiTJ2YNZLIpsMwzvuZh33DE4=;
        b=hZE48B+86jtbTWYQWGskPjPW2hJRNHeWWWAsztS7u6W2Yn1jAFzVFazlbJFB+VPlnq
         UK2Wyj0EUseBVBP0Hpfh+IY533mwwbLietmSyIZMgvElL11ZuwTk030/m8mkXRP0C+V3
         e8d/D6Y0e30FW9ME2n/aVRRKnuYjJ44wxnYmeANYo1GTpcglu7npKANkurVVpQFTTn2w
         yUEGQm+6mRRbmoeF3nGAYEtJWaTEHyT2ptnIQFwkyl5wzuKVA11GpDCrexy5uN1Eah01
         36Eyr2ylfTWjQqzQYxNlJMxPBnbzu0prltV2MotyfWbo15p4AXRAb+zm5e4/ho2/iFYl
         CvMA==
X-Gm-Message-State: AOAM531IQPRTYlOsYj8LeZ8Q8WKI6/EGPkIHaAbU2uxMvLOYVdQyXQXF
        1xXML29vtnRQxYBEPCB1QkNLSA==
X-Google-Smtp-Source: ABdhPJxoUw2+BXaf4Y28HS5oxoosSZfU/YZu5JBdifHIEfMkQuE6hByHYsEOEqC0UqBpGNdiveL4aQ==
X-Received: by 2002:a05:600c:1e0f:b0:394:7759:64f3 with SMTP id ay15-20020a05600c1e0f00b00394775964f3mr1388874wmb.19.1652904586352;
        Wed, 18 May 2022 13:09:46 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o23-20020a05600c511700b0039456c00ba7sm6859281wms.1.2022.05.18.13.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 13:09:45 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     andrew@lunn.ch, broonie@kernel.org, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        netdev@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 0/5] arm64: add ethernet to orange pi 3
Date:   Wed, 18 May 2022 20:09:34 +0000
Message-Id: <20220518200939.689308-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

2 sunxi board still does not have ethernet working, orangepi 1+ and
orangepi 3.
This is due to the fact thoses boards have a PHY which need 2 regulators.

A first attempt was made to support them was made by adding support in
stmmac driver:
https://lore.kernel.org/lkml/20190820145343.29108-6-megous@megous.com/
Proposal rejected, since regulators need to be handled by the PHY core.

This serie try to handle this.

This serie was tested on whole range of board and PHY architecture:
- internal PHY
  * sun8i-h3-orangepi-pc
- external PHY
  * sun50i-h6-pine-h64
  * sun8i-r40-bananapi-m2-ultra
  * sun8i-a83t-bananapi-m3
  * sun50i-a64-bananapi-m64
  * sun50i-h6-orangepi-3
  * sun50i-h5-nanopi-neo-plus2

The resume/suspend of PHY was tested.

Regards

changes since v1:
- Add regulator_bulk_get_all for ease handling of PHY regulators
- Removed all convertion patchs to keep DT compatibility.

Corentin Labbe (4):
  regulator: Add of_get_regulator_from_list
  regulator: Add regulator_bulk_get_all
  phy: handle optional regulator for PHY
  dt-bindings: net: Add documentation for optional regulators

Ondřej Jirman (1):
  arm64: dts: allwinner: orange-pi-3: Enable ethernet

 .../devicetree/bindings/net/ethernet-phy.yaml |  9 ++
 .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 38 ++++++++
 drivers/net/mdio/Kconfig                      |  1 +
 drivers/net/mdio/fwnode_mdio.c                | 34 ++++++-
 drivers/net/phy/phy_device.c                  | 10 ++
 drivers/regulator/core.c                      | 93 ++++++++++++++++++-
 include/linux/phy.h                           |  3 +
 include/linux/regulator/consumer.h            |  2 +
 8 files changed, 182 insertions(+), 8 deletions(-)

-- 
2.35.1

