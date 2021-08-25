Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1083F754D
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240717AbhHYMr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhHYMr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:47:56 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947AEC061757;
        Wed, 25 Aug 2021 05:47:10 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id t42so18599229pfg.12;
        Wed, 25 Aug 2021 05:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7duThHeJjxw1i1HwqENqMgEFWO8144Pl5kuBz52Xjek=;
        b=IN4QMy5y401zq8WXwcAwqoe67+TVk9BJmkJaaJVhPjVPsVfC0n9PkskoEVmTerVpuW
         /8IQ/SYP/MoHImTyc8dTzcF4SUFivC8hOVDCW8wmtcpDltxxabsizcAIa5ff9LhYJHCQ
         HWBCEchU2idveA5tp37LYYSXLT78rfSnd0XdHuNtyK9N/jDK4hnYNPbiJ4UFxJ29R+PW
         9Z2MtBg/y0KtcDa5nWM+ebM9lD96+eMT6EisaHHgxW6cAO4OB2Vz22PS6wzFY4uLjrM0
         y9980Qa42NbbLpJmx0iQUQgNt3X8lAgN+8lHKUfV3Oethl6v+m7/BHni7zI8g6ckwgkZ
         vhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=7duThHeJjxw1i1HwqENqMgEFWO8144Pl5kuBz52Xjek=;
        b=QUPYvqWB/wfbAmo5vYQLPjP5GGd0ccLHHZUlz3v6WDoCoNqpNIlRfkEIksQUQjA+NW
         bw8v2GmQHTrHbGMYpYq/eTqqXPsBIW81M0WsLTtWpueV6jbL3eUeaWfxcMcqmkidMKkt
         5YErCZE8DAaj3vn3bmiH3k0VQmhohuY1aUbt1ODR9MW3vK1fuUV0Kjc4L57adRH8dYWt
         Udpyon7kE5OVkP70TpnVLJSv0eUnZS+6bQFV8o3IcUTvcykeLxD7epjOicUoU8CFhYTR
         DITMgnoMIApgUiQx70nrDA0C+cBgSSYI9IK3eBwMH4RVYpydjs8rqkPxMbgJ74x2/hOi
         NeBQ==
X-Gm-Message-State: AOAM532x83ld+9Zoax3HfNIl4SdowBczsoDhI5G4MuKoYOCSFNnQZg1Z
        t1Zo6wAuHbBsbeCUlFNYyzw=
X-Google-Smtp-Source: ABdhPJypUuKtzhdSbO2d/dZteEkLcdz+85GjpKa0gYpvloytIUB+dQ6faHVIrrVXF+HLNPI6y7BeiQ==
X-Received: by 2002:a63:fd51:: with SMTP id m17mr41616827pgj.395.1629895630017;
        Wed, 25 Aug 2021 05:47:10 -0700 (PDT)
Received: from localhost.localdomain ([45.124.203.15])
        by smtp.gmail.com with ESMTPSA id s16sm21511301pfk.185.2021.08.25.05.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 05:47:08 -0700 (PDT)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org,
        Florent Kermarrec <florent@enjoy-digital.fr>,
        "Gabriel L . Somlo" <gsomlo@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] net: Add LiteETH network driver
Date:   Wed, 25 Aug 2021 22:16:53 +0930
Message-Id: <20210825124655.3104348-1-joel@jms.id.au>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a driver for the LiteX network device, LiteEth.

v3 Updates the bindings to describe the slots in a way that makes more
sense for the hardware, instead of trying to fit some existing
properties. The driver is updated to use these bindings, and fix some
issues pointed out by Gabriel.

v2 Addresses feedback from Jakub, with detailed changes in each patch.

It also moves to the litex register accessors so the system works on big
endian litex platforms. I tested with mor1k on an Arty A7-100T.

I have removed the mdio aspects of the driver as they are not needed for
basic operation. I will continue to work on adding support in the
future, but I don't think it needs to block the mac driver going in.

The binding describes the mdio registers, and has been fixed to not show
any warnings against dtschema master.

LiteEth is a simple driver for the FPGA based Ethernet device used in various
RISC-V, PowerPC's microwatt, OpenRISC's mor1k and other FPGA based
systems on chip.

Joel Stanley (2):
  dt-bindings: net: Add bindings for LiteETH
  net: Add driver for LiteX's LiteETH network interface

 .../bindings/net/litex,liteeth.yaml           | 100 ++++++
 drivers/net/ethernet/Kconfig                  |   1 +
 drivers/net/ethernet/Makefile                 |   1 +
 drivers/net/ethernet/litex/Kconfig            |  27 ++
 drivers/net/ethernet/litex/Makefile           |   5 +
 drivers/net/ethernet/litex/litex_liteeth.c    | 317 ++++++++++++++++++
 6 files changed, 451 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml
 create mode 100644 drivers/net/ethernet/litex/Kconfig
 create mode 100644 drivers/net/ethernet/litex/Makefile
 create mode 100644 drivers/net/ethernet/litex/litex_liteeth.c

-- 
2.33.0

