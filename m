Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54B65A3DC0
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 15:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiH1Ndl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 09:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiH1Ndk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 09:33:40 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87A024F12
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 06:33:38 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id fy31so10573185ejc.6
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 06:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=DNUvT1ZZ3fFrLVQIyi9us/iFYLs4Qz0Ypyc3D33P4jw=;
        b=RwRoWd9AYF8OGCjv58SePtwQnPalN5pnfcu2PcXDc0X7SEZ27f2l6auvNoy6bXv/f3
         s1Jz5d6OXF0ydCOHiLCPggZ95FgKN7QL6W+ILfKCFECPetB1kiMS2E8RRcVVgX0n6TZj
         CPBbEDkleISRtbCLdgimRmsY6T0ErgmyzHeAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=DNUvT1ZZ3fFrLVQIyi9us/iFYLs4Qz0Ypyc3D33P4jw=;
        b=vImtKRbxK2Hi8Wwekacrp6TXlaKbMcdRl3sVqzQmd22ZCyzvZ6M+577b9T5NYgfWID
         SY6fMe9in+b7jXnR1QuN/vGsRkUrbHKwdtROqx/zzfr9SPvuZGrJ/r+DLXBqfqTopcca
         gGoHXJ5RG4qBNxU052fpKe8DeEckKuiTi61nXCyVaxlhUF4dU9pPTnU6CRllSRALuu7E
         68/ShN53lTvWEqkSpNKrVsphhaW+u4sL8UYbYjTr0Bx+ySJ9RfwHB6audLMLqYIBGuou
         bP5P/S1DL0s3hSraI69yWOjGB65A5g+bcv5dm98VHsraEV4dQHh41U2yzEkvQmvZaaQ6
         hzEg==
X-Gm-Message-State: ACgBeo12lmXW+W3KHfo53S1CAs2h62Y/d0U8e5BpCC9ZGbYYhoxGSz5r
        Jf5xGb3SPsmCKx75ZWH6X/A7kA==
X-Google-Smtp-Source: AA6agR589FF7S2UjahMF8q4laiggfgapRLShsh241BpWLPPW6mBtYh3v02vIrAfWhFEGX8XoEZ4PZQ==
X-Received: by 2002:a17:907:6d24:b0:731:7720:bb9b with SMTP id sa36-20020a1709076d2400b007317720bb9bmr10836381ejc.717.1661693617054;
        Sun, 28 Aug 2022 06:33:37 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id u26-20020a1709064ada00b007313a25e56esm3247669ejt.29.2022.08.28.06.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 06:33:36 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: [RFC PATCH v3 0/4] can: bxcan: add support for ST bxCAN controller
Date:   Sun, 28 Aug 2022 15:33:25 +0200
Message-Id: <20220828133329.793324-1-dario.binacchi@amarulasolutions.com>
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

The series adds support for the basic extended CAN controller (bxCAN)
found in many low- to middle-end STM32 SoCs.

The driver design (one core module and one driver module) was inspired
by other ST drivers (e. g. drivers/iio/adc/stm32-adc.c,
drivers/iio/adc/stm32-adc-core.c) where device instances share resources.
The shared resources functions are implemented in the core module, the
device driver in a separate module.

The driver has been tested on the stm32f469i-discovery board with a
kernel version 5.19.0-rc2 in loopback + silent mode:

ip link set can0 type can bitrate 125000 loopback on listen-only on
ip link set up can0
candump can0 -L &
cansend can0 300#AC.AB.AD.AE.75.49.AD.D1

For uboot and kernel compilation, as well as for rootfs creation I used
buildroot:

make stm32f469_disco_sd_defconfig
make

but I had to patch can-utils and busybox as can-utils and iproute are
not compiled for MMU-less microcotrollers. In the case of can-utils,
replacing the calls to fork() with vfork(), I was able to compile the
package with working candump and cansend applications, while in the
case of iproute, I ran into more than one problem and finally I decided
to extend busybox's ip link command for CAN-type devices. I'm still
wondering if it was really necessary, but this way I was able to test
the driver.

Changes in v3:
- Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
- Add description to the parent of the two child nodes.
- Move "patterProperties:" after "properties: in top level before "required".
- Add "clocks" to the "required:" list of the child nodes.
- Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
- Add "clocks" to can@0 node.
- Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
- Remove a blank line.
- Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
- Fix the documentation file path in the MAINTAINERS entry.
- Do not increment the "stats->rx_bytes" if the frame is remote.
- Remove pr_debug() call from bxcan_rmw().

Changes in v2:
- Change the file name into 'st,stm32-bxcan-core.yaml'.
- Rename compatibles:
  - st,stm32-bxcan-core -> st,stm32f4-bxcan-core
  - st,stm32-bxcan -> st,stm32f4-bxcan
- Rename master property to st,can-master.
- Remove the status property from the example.
- Put the node child properties as required.
- Remove a blank line.
- Fix sparse errors.
- Create a MAINTAINERS entry.
- Remove the print of the registers address.
- Remove the volatile keyword from bxcan_rmw().
- Use tx ring algorithm to manage tx mailboxes.
- Use can_{get|put}_echo_skb().
- Update DT properties.

Dario Binacchi (4):
  dt-bindings: net: can: add STM32 bxcan DT bindings
  ARM: dts: stm32: add CAN support on stm32f429
  ARM: dts: stm32: add pin map for CAN controller on stm32f4
  can: bxcan: add support for ST bxCAN controller

 .../bindings/net/can/st,stm32-bxcan.yaml      |  142 +++
 MAINTAINERS                                   |    7 +
 arch/arm/boot/dts/stm32f4-pinctrl.dtsi        |   30 +
 arch/arm/boot/dts/stm32f429.dtsi              |   31 +
 drivers/net/can/Kconfig                       |    1 +
 drivers/net/can/Makefile                      |    1 +
 drivers/net/can/bxcan/Kconfig                 |   34 +
 drivers/net/can/bxcan/Makefile                |    4 +
 drivers/net/can/bxcan/bxcan-core.c            |  200 ++++
 drivers/net/can/bxcan/bxcan-core.h            |   31 +
 drivers/net/can/bxcan/bxcan-drv.c             | 1045 +++++++++++++++++
 11 files changed, 1526 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
 create mode 100644 drivers/net/can/bxcan/Kconfig
 create mode 100644 drivers/net/can/bxcan/Makefile
 create mode 100644 drivers/net/can/bxcan/bxcan-core.c
 create mode 100644 drivers/net/can/bxcan/bxcan-core.h
 create mode 100644 drivers/net/can/bxcan/bxcan-drv.c

-- 
2.32.0

