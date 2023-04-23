Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14456EC151
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 19:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjDWRZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 13:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjDWRZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 13:25:41 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E298E6C
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 10:25:40 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f193ca059bso14477265e9.3
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 10:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1682270738; x=1684862738;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uL5yPRaPsceCGbvCtDdOlsKWMRHlRugtX8iMSJPTZDk=;
        b=mH0TBJ+YAOpAbtbc1vKOUVVwzrk15k/GVhEPrxPHJvV1gC4gYIpH8Jn37Y1287nzdZ
         uyd2mE82dzvqUKHv5JESijMtiCwVlPHGKy7Hv+b1CD7YGIbgTTrPAjzad6wzxpbgYCaS
         2mzyqaG6llYkQOqYL7XWP6exZu4mULi+zs/JE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682270738; x=1684862738;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uL5yPRaPsceCGbvCtDdOlsKWMRHlRugtX8iMSJPTZDk=;
        b=Jl1Ta6F4wfI0Na1HqhQ0nw8gcDulzHxgsiezrnhHN4eXqvW6Y6x+YuaU32JS/VG8GB
         XYNfbkkwOFa6AYAIaeRkx1Mew6Ho2jAg2+SZZkpMYCIchYlt3x2ATV81hQYfnlt7lNJx
         e5597eMZvya1ioGiJp3nNwYyq5AgmjTvcwQ9aAv0GHrrHOdAJsHdpTU4g6VDTRarA4Q7
         LLKe3jLKanYUJ/AIp8b1gCAH6yEJx/NwolZRd8y7xf7Iq84dpMKOKX1J79PKdeczp27D
         +7I3029wEaAZWCclDh3R3keSYIxmojNAWAcy1oRZPZin5eDsupRuRpEUHqPq9redl+BV
         WhJA==
X-Gm-Message-State: AAQBX9fHXZzSsjOJL1nMNx4zX73B6hkl4/iSH4jEayzjFFbLC4XL5sVJ
        Sr7YEMeFGlb3TMRbfl9Wpdk5/w==
X-Google-Smtp-Source: AKy350YCZkiNToumnXq7+bIHyotRHqEZokos7hy69QN8FWGz3YKB3GeKCYoy3JtFDIpfTe7nhp6uOA==
X-Received: by 2002:a7b:c84d:0:b0:3f1:7129:6b25 with SMTP id c13-20020a7bc84d000000b003f171296b25mr6361534wml.18.1682270738546;
        Sun, 23 Apr 2023 10:25:38 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.. ([37.159.119.249])
        by smtp.gmail.com with ESMTPSA id j32-20020a05600c1c2000b003f173987ec2sm13511653wms.22.2023.04.23.10.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 10:25:38 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lee Jones <lee@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: [PATCH 0/4] can: bxcan: add support for single peripheral configuration
Date:   Sun, 23 Apr 2023 19:25:24 +0200
Message-Id: <20230423172528.1398158-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The series adds support for managing bxCAN controllers in single peripheral
configuration.
Unlike stm32f4 SOCs, where bxCAN controllers are only in dual peripheral
configuration, stm32f7 SOCs contain three CAN peripherals, CAN1 and CAN2
in dual peripheral configuration and CAN3 in single peripheral
configuration:
- Dual CAN peripheral configuration:
 * CAN1: Primary bxCAN for managing the communication between a secondary
   bxCAN and the 512-byte SRAM memory.
 * CAN2: Secondary bxCAN with no direct access to the SRAM memory.
   This means that the two bxCAN cells share the 512-byte SRAM memory and
   CAN2 can't be used without enabling CAN1.
- Single CAN peripheral configuration:
 * CAN3: Primary bxCAN with dedicated Memory Access Controller unit and
   512-byte SRAM memory.

The driver has been tested on the stm32f769i-discovery board with a
kernel version 5.19.0-rc2 in loopback + silent mode:

ip link set can[0-2] type can bitrate 125000 loopback on listen-only on
ip link set up can0
candump can[0-2] -L &
cansend can[0-2] 300#AC.AB.AD.AE.75.49.AD.D1



Dario Binacchi (4):
  dt-bindings: mfd: stm32f7: add binding definition for CAN3
  ARM: dts: stm32: add CAN support on stm32f746
  ARM: dts: stm32: add pin map for CAN controller on stm32f7
  can: bxcan: add support for single peripheral configuration

 arch/arm/boot/dts/stm32f7-pinctrl.dtsi | 82 ++++++++++++++++++++++++++
 arch/arm/boot/dts/stm32f746.dtsi       | 39 ++++++++++++
 drivers/net/can/bxcan.c                | 20 ++++++-
 include/dt-bindings/mfd/stm32f7-rcc.h  |  1 +
 4 files changed, 139 insertions(+), 3 deletions(-)

-- 
2.32.0

