Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95F559AC9C
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 10:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343939AbiHTIaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 04:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244366AbiHTIaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 04:30:08 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAA31F2DF
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 01:30:05 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id tl27so12662159ejc.1
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 01:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=RS+9z5xIA7IJQfYdhvS13wGTMb0Y1SSjn5eINN5tz5M=;
        b=KYglLr5IT5Q6SjG1hpSADMsfLqBTmSm2RePc/Mk+1a6/IuYwltxIMjKHELWXq0raEi
         vJ8dtvWbLa7e3oCV42BvkGk1Rzu+b3b+GMAbinrVoPbJWAX7hYPbCjLZyV57Y30zDrxX
         PMdQHOv6kMqvF2mbnxdajLqBjL3wVvx85kgpo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=RS+9z5xIA7IJQfYdhvS13wGTMb0Y1SSjn5eINN5tz5M=;
        b=qcqZCHLwWe2QjPoRZWCm0B6+1IQzXLwaWHlKhamSRKoh5h8RIiqsoQQcO4W7nxIlFx
         WTIGAC/bqwtOcf9qLvMGgMPStT9lNyHbiW8llnCsPXfzxuRIid3e/DeAFR461EwWZBJA
         BfupKG0NAlmFf/pVeiM3c97lsm87oYRvUz5kGN2Ud5ndS8hODEdBNdeCnB3KAtP9drK3
         P+KZNNj0tt/9tzKgQiuCBZXIU8c6jTctA/2wEUnxUP22GA1hJBRVIi+jsa7jOr9rO+4w
         bT+xKagWZO/8F8GGhJVDgaemARFIXicXMX5A/3xIV3ZGM5YkDoTxDYqrFXIM8eAI3HhE
         cK6A==
X-Gm-Message-State: ACgBeo1wHXJ9sw0uZ+rpFDBxWiBigeep2IDF37l1bV0p5Y7KMwnLereZ
        Bct2IvoGYmDuTt2B4DMcPjdGHg==
X-Google-Smtp-Source: AA6agR4A8pPFIlY6qv6Yh7WGjQYbnonjfl0k2GshtoUrZurNwTFSfhBwDqSTiHrxzWK3LnU0zmuwtQ==
X-Received: by 2002:a17:907:60c7:b0:731:14e2:af10 with SMTP id hv7-20020a17090760c700b0073114e2af10mr7085806ejc.92.1660984204133;
        Sat, 20 Aug 2022 01:30:04 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id gx14-20020a1709068a4e00b0072b33e91f96sm3336112ejc.190.2022.08.20.01.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 01:30:03 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        michael@amarulasolutions.com,
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
Subject: [RFC PATCH v2 0/4] can: bxcan: add support for ST bxCAN controller
Date:   Sat, 20 Aug 2022 10:29:32 +0200
Message-Id: <20220820082936.686924-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

 .../bindings/net/can/st,stm32-bxcan.yaml      |  136 +++
 MAINTAINERS                                   |    7 +
 arch/arm/boot/dts/stm32f4-pinctrl.dtsi        |   31 +
 arch/arm/boot/dts/stm32f429.dtsi              |   30 +
 drivers/net/can/Kconfig                       |    1 +
 drivers/net/can/Makefile                      |    1 +
 drivers/net/can/bxcan/Kconfig                 |   34 +
 drivers/net/can/bxcan/Makefile                |    4 +
 drivers/net/can/bxcan/bxcan-core.c            |  200 ++++
 drivers/net/can/bxcan/bxcan-core.h            |   33 +
 drivers/net/can/bxcan/bxcan-drv.c             | 1043 +++++++++++++++++
 11 files changed, 1520 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
 create mode 100644 drivers/net/can/bxcan/Kconfig
 create mode 100644 drivers/net/can/bxcan/Makefile
 create mode 100644 drivers/net/can/bxcan/bxcan-core.c
 create mode 100644 drivers/net/can/bxcan/bxcan-core.h
 create mode 100644 drivers/net/can/bxcan/bxcan-drv.c

-- 
2.32.0

