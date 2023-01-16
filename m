Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C329466BA0C
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjAPJRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbjAPJQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:16:55 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607C74C10
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:16:48 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id q8so7690855wmo.5
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jQqy7tmNPC1sLB0qog9J3nsScKuE7+zMY2apGe1a7LY=;
        b=kaf9ULVPufRZua7B4XdDJbK0fz0YS33wTnOyjdev+zPeRS3mCSGhZ1fBQcXM+0SA44
         DxXiGtm93SWoxgCmvT1tqQxqKkwAgNe1jRaTTD+HBIyqoYMoczZdGTtRcvUsNq2Q00km
         ATPU3q/WopXzNMdW3hvoempiWeKgzZ1ogoM4xX6ggPfannwE/kUDhU4ZfVtw2Mr6Yy86
         LFbaB+VILy7tLIaAJQQBMSd7KyGxE9lLikfNe36hkLmjMC1lppCszlTbIkXSwD7rm+49
         4LcsoyLkZGFuB1ZtlgtZizWit7vJOmL3z8Qz4X9frXYEeSpoGAkFksS66WciG6GmID79
         xg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jQqy7tmNPC1sLB0qog9J3nsScKuE7+zMY2apGe1a7LY=;
        b=2XplkFw3YdNoMToXuFgHe26ViUL0RJz0YM+bRNn9+sVeIMVKJjQ3mw9gNCJSQ82TuV
         yKJy2Rzzu7+zxl7eO2Lt0D2Cwws4RrOPSu33lnXdfTXr8fpGrUq1bHMTdDM1mYVdW3zr
         sriHrqLO667VORHfpbrGXlqHXJDC7vYE6QD4kplyR8mR0uKw+qwHHaSgDPSb/viNyAKD
         1rqnEgjbCNNaYmLUZgCtHputeJDVeDrwKojzIvDHCk9MHJ5gOzrpKjxGnjYzqszEaspt
         wEayekvl7vJB5fahCZcBhK7MUBtFgHXQAoJUjvxrTFHcV+KFev4g+57VwGzo9jzGPq6S
         iRwQ==
X-Gm-Message-State: AFqh2kq70aMpaNJfnbSvgWHeHifYSkwdYpNJBZmgYu8UG0ybgvnX5Yry
        S0OE2ZJcnViUKm9BEOcyi2GHfX89yF8bHKiL
X-Google-Smtp-Source: AMrXdXu9LWONh81BHjCmB6gNIdUCS0z8SVL3vdAXL+JwO2VJt70ZV99BaV8Tt983HoGGK8orA9dUWg==
X-Received: by 2002:a05:600c:1c03:b0:3db:13f:c86c with SMTP id j3-20020a05600c1c0300b003db013fc86cmr669081wms.41.1673860606919;
        Mon, 16 Jan 2023 01:16:46 -0800 (PST)
Received: from localhost.localdomain (82-65-169-74.subs.proxad.net. [82.65.169.74])
        by smtp.googlemail.com with ESMTPSA id h19-20020a05600c351300b003d9a86a13bfsm35923491wmq.28.2023.01.16.01.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 01:16:46 -0800 (PST)
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: mdio: add amlogic gxl mdio mux support
Date:   Mon, 16 Jan 2023 10:16:34 +0100
Message-Id: <20230116091637.272923-1-jbrunet@baylibre.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the MDIO multiplexer found in the Amlogic GXL SoC family.
This multiplexer allows to choose between the external (SoC pins) MDIO bus,
or the internal one leading to the integrated 10/100M PHY.

This multiplexer has been handled with the mdio-mux-mmioreg generic driver
so far. When it was added, it was thought the logic was handled by a
single register.

It turns out more than a single register need to be properly set.
As long as the device is using the Amlogic vendor bootloader, or upstream
u-boot with net support, it is working fine since the kernel is inheriting
the bootloader settings. Without net support in the bootloader, this glue
comes unset in the kernel and only the external path may operate properly.

With this driver (and the associated DT update), the kernel no longer relies
on the bootloader to set things up, fixing the problem.

This has been tested on the aml-s905x-cc (LePotato) for the internal path
and the aml-s912-pc (Tartiflette) for the external path.

Jerome Brunet (2):
  dt-bindings: net: add amlogic gxl mdio multiplexer
  net: mdio: add amlogic gxl mdio mux support

 .../bindings/net/amlogic,gxl-mdio-mux.yaml    |  64 +++++++
 drivers/net/mdio/Kconfig                      |  11 ++
 drivers/net/mdio/Makefile                     |   1 +
 drivers/net/mdio/mdio-mux-meson-gxl.c         | 160 ++++++++++++++++++
 4 files changed, 236 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/amlogic,gxl-mdio-mux.yaml
 create mode 100644 drivers/net/mdio/mdio-mux-meson-gxl.c

-- 
2.39.0

