Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8C4621B89
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbiKHSMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiKHSMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:12:00 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F15B5654A
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 10:11:58 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id j5-20020a05600c410500b003cfa9c0ea76so4188032wmi.3
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 10:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WLjAfgXrY6iJ/scApshW4hQNZQBkL3nMQTzPyRA/Obo=;
        b=wdkxgsgVnJdyizPXCxIkbwj0180QnsDpzSBH3moSDjBmmto1uZ54uGEjCnVLtq6hd+
         PDPOlTNjFcRBBnBGhYHgT13X5jR27y8NixF1yl835kEjduAQaEvvtrLudrICkjNYHJvV
         yQ4y/zvOUNwBtKPHB2hZ+c/bmXacipZdAD0HPaSLLC162zd2Lo0i6kUGBOHAKdApjNT4
         kyyFyJfP47zZPMsGHnUDz583NoEG/9mKzErUsNRU6n6Ys27kyX8iBJhTS1D/hT4jAods
         bT+TVFgX92+b5HTh4PD/koX0t73B9ako+lytupbYOhlzGX8E6Wlvp2kunie2mbcgvxPi
         KTcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WLjAfgXrY6iJ/scApshW4hQNZQBkL3nMQTzPyRA/Obo=;
        b=YVFx7L0VICUG0sjp5tfc3W8T9iCWP9nFJAWUZybj2cXost1mG3EnFPsU6bTVx1CkTh
         jsBWtbFvG6+Y1LkHCzMwSWAeihu8+JQ8I+NNaZfT8RlW8WLjC0Djn1Q2ySuXdCT4uPu2
         KIp6MGO3RGCcPszoxI0fEnieBUdqlHXBVGksv3VaHVE10Mh0ZCT0JMGOwvhKFcT5MeG4
         ZXIR9DP9pMPWkPK/TuMZBuqYwGpPxNUf8oJtG2h0+6qPDi4H3mvo+NBFVxZ9funh0PLs
         IOPBOEd3ChRnsL2aomAMqy3vWwiaR3tI1nGB8s0ox+Is8ysFvez2z51LzG2vQs7aXI6c
         m3ew==
X-Gm-Message-State: ACrzQf2t7QBGI4pc7yljKStmqC/cL5RiKTVNx1LDFjBfLWTh+mrTzuds
        W8hhmQS3hJ/eHlzCmZaD38zhPA==
X-Google-Smtp-Source: AMsMyM5FqYutJUSJ6XbIxmAWRIfI8aNW03g0ydxdb/+41CbBFkbtxJ+oROmeateisOYYMIhw2B3HwA==
X-Received: by 2002:a05:600c:354f:b0:3cf:4c20:584b with SMTP id i15-20020a05600c354f00b003cf4c20584bmr47536057wmq.58.1667931117025;
        Tue, 08 Nov 2022 10:11:57 -0800 (PST)
Received: from nicolas-Precision-3551.home ([2001:861:5180:dcc0:7d10:e9e8:fd9a:2f72])
        by smtp.gmail.com with ESMTPSA id q12-20020a5d61cc000000b002238ea5750csm13037109wrv.72.2022.11.08.10.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 10:11:56 -0800 (PST)
From:   Nicolas Frayer <nfrayer@baylibre.com>
To:     nm@ti.com, ssantosh@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, peter.ujfalusi@gmail.com,
        vkoul@kernel.org, dmaengine@vger.kernel.org,
        grygorii.strashko@ti.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     khilman@baylibre.com, glaroque@baylibre.com, nfrayer@baylibre.com
Subject: [PATCH v4 0/4] soc: ti: Add module build support to the socinfo
Date:   Tue,  8 Nov 2022 19:11:40 +0100
Message-Id: <20221108181144.433087-1-nfrayer@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for the TI K3 SoC info driver to be built as a module, the
following changes have been made:
- Converted memory allocations to devm and added the remove callback
- Added necessary code to build the driver as a module
- UDMA: Added deferred probe when soc_device_match() fails because the
socinfo driver is built as a module and hasn't probed yet
- MDIO: Same as the UDMA driver, return deferred probe if
soc_device_match() returns null

v2->v3:
dropped module conversion part of this series while other driver
dependencies on socinfo are worked out.
A dependency issue is introduced by changing subsys_initcall()
to module_platform_driver(). Some drivers using the socinfo information
probe before the socinfo driver itself and it makes their probe fail.

v3->v4:
reintegrated the module build support and added patches for udma and mdio
drivers to allow for deferred probe if socinfo hasn't probed yet.

Nicolas Frayer (4):
  soc: ti: Convert allocations to devm
  soc: ti: Add module build support
  dmaengine: ti: k3-udma: Deferring probe when soc_device_match()
    returns NULL
  net: ethernet: ti: davinci_mdio: Deferring probe when
    soc_device_match() returns NULL

 arch/arm64/Kconfig.platforms           |  1 -
 drivers/dma/ti/k3-udma.c               |  2 +-
 drivers/net/ethernet/ti/davinci_mdio.c |  4 +++
 drivers/soc/ti/Kconfig                 |  3 +-
 drivers/soc/ti/k3-socinfo.c            | 47 ++++++++++++++++----------
 5 files changed, 37 insertions(+), 20 deletions(-)

-- 
2.25.1

