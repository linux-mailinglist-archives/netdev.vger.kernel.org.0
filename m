Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437C2597167
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240281AbiHQOhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240267AbiHQOgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:36:42 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DED19BB6F
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 07:36:22 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id fy5so24904074ejc.3
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 07:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=v2QQ7Uff4GoH2848IKCxUQX2XDpeKAuPtOB6PZeLpak=;
        b=BUBqid1m+LsLr2gz85xHUy+sqUiJRXFfzq8DQbh9692q8D5hYkQR/AXZMx2yNvg2BF
         kpYK78ofw8qiX49x58to7+p26d/YmXLzidby5943Y2BYBEZVdBAkkDu1k1+81Xgpiz2L
         a/EI5qETsF1LBhveYT/3UZCqwVmWXcJoNCoMg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=v2QQ7Uff4GoH2848IKCxUQX2XDpeKAuPtOB6PZeLpak=;
        b=l+aYmrKZiH7JhTsU4Zm8pXlxy7Ny+isbtTmA1k/g6NLj8EGZvUcMTa/49QRPkfErS3
         M7K+5nbO4aRq07HRm7zKUp2Qj5AUdj435PC5+VgC+9nnXV9iHG0NwRNHj7YswoQ5mqZc
         ThNUGV9lWbpJ2L3XjK5w3KpEWHtexNlo9plj4sMn4DJTEJupOOzO5u/LtKZByusqUxbz
         EGLZXRPByfrIr2CyKBwmvIhCKhECmo0s2Sl/Ve/EmyeuRUsrWEjwbF9LynoqaLX6OI8V
         JN27wiCEa5qCBmVJSz4Ri84WOm1i9QLJc5pHXB6avmgfSawqMYgxi5HSCCJZ4O/iiQuD
         QpbQ==
X-Gm-Message-State: ACgBeo1/BU6CJWoDBGThNyErs3Q8BAiip238qaHgPDS+B5HLavWyaFyb
        JY+Bt5/UjdJ91vF/oktq0Sxo5A==
X-Google-Smtp-Source: AA6agR5YUv4QupDUzNnqnMMjKDP7wWxVCPQSvpHYL5+qDVNTthgT+NTs0hhCQiAsRsgJXzTy1/nXVQ==
X-Received: by 2002:a17:907:7609:b0:730:d70a:1efc with SMTP id jx9-20020a170907760900b00730d70a1efcmr16930699ejc.766.1660746980935;
        Wed, 17 Aug 2022 07:36:20 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id o9-20020aa7c7c9000000b0043cab10f702sm10711982eds.90.2022.08.17.07.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 07:36:20 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Marc Kleine-Budde <mkl@pengutronix.de>,
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
Subject: [RFC PATCH 0/4] can: bxcan: add support for ST bxCAN controller
Date:   Wed, 17 Aug 2022 16:35:25 +0200
Message-Id: <20220817143529.257908-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The series adds support for the basic extended CAN controller (bxCAN)
found in many low- to middle-end STM32 SoCs.

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


Dario Binacchi (4):
  dt-bindings: net: can: add STM32 bxcan DT bindings
  ARM: dts: stm32: add CAN support on stm32f429
  ARM: dts: stm32: add pin map for CAN controller on stm32f4
  can: bxcan: add support for ST bxCAN controller

 .../devicetree/bindings/net/can/st,bxcan.yaml | 139 +++
 arch/arm/boot/dts/stm32f4-pinctrl.dtsi        |  32 +
 arch/arm/boot/dts/stm32f429.dtsi              |  30 +
 drivers/net/can/Kconfig                       |   1 +
 drivers/net/can/Makefile                      |   1 +
 drivers/net/can/bxcan/Kconfig                 |  34 +
 drivers/net/can/bxcan/Makefile                |   4 +
 drivers/net/can/bxcan/bxcan-core.c            | 201 ++++
 drivers/net/can/bxcan/bxcan-core.h            |  33 +
 drivers/net/can/bxcan/bxcan-drv.c             | 980 ++++++++++++++++++
 10 files changed, 1455 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/st,bxcan.yaml
 create mode 100644 drivers/net/can/bxcan/Kconfig
 create mode 100644 drivers/net/can/bxcan/Makefile
 create mode 100644 drivers/net/can/bxcan/bxcan-core.c
 create mode 100644 drivers/net/can/bxcan/bxcan-core.h
 create mode 100644 drivers/net/can/bxcan/bxcan-drv.c

-- 
2.32.0

