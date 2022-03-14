Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589A44D8EC7
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 22:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245300AbiCNVd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 17:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245262AbiCNVdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 17:33:23 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1592633365
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 14:32:10 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 734802C06C6;
        Mon, 14 Mar 2022 21:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1647293527;
        bh=RkXxbfpxz60sVinFQqrsDITL8geh/kJ2X57zBM2mDPM=;
        h=From:To:Cc:Subject:Date:From;
        b=In19C3dXzVgwGr5PhKZkb5Yy3bTLcfN1vn2xzyL+pbty/VNKEQQXFRyx7/olVmGIt
         WEGHEwAG4dWs7iiY55QdUv4agc5Ka81npkwUtHzRVJhX91Cln6ht8s7gB3gnjwB0bh
         9kuaWTiZAiL6N5LJ2+LPUCEYjaqDi7EZZAy6rirdPH8A3G5P73lrNXZ6yy93mEWQMD
         zvHiG4qdUO2UVqR0BF1J74vI4x7LQOrgnra/xrvQkGBh/QtHf6RKYi+0yYyJ49QanN
         1nCK2sZ2jXlbrIY7rGAfRB85FzDxu+VjT5dKFBRwQIZOl11xroMrfmaBQKGlHDN/gZ
         EGFWIl1gfw3Uw==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B622fb4570000>; Tue, 15 Mar 2022 10:32:07 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by pat.atlnz.lc (Postfix) with ESMTP id 0704C13EE36;
        Tue, 15 Mar 2022 10:32:07 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id DF60C2A2678; Tue, 15 Mar 2022 10:32:03 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     huziji@marvell.com, ulf.hansson@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        catalin.marinas@arm.com, will@kernel.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        adrian.hunter@intel.com, thomas.petazzoni@bootlin.com,
        kostap@marvell.com, robert.marko@sartura.hr
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2 0/8] arm64: mvebu: Support for Marvell 98DX2530 (and variants)
Date:   Tue, 15 Mar 2022 10:31:35 +1300
Message-Id: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Cfh2G4jl c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=o8Y5sQTvuykA:10 a=vfzu8PMGQmK49s0qG5oA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the Marvell 98DX2530 SoC which is the Contro=
l and
Management CPU integrated into the AlleyCat5/AlleyCat5X series of Marvell
switches.

The CPU core is an ARM Cortex-A55 with neon, simd and crypto extensions.

This is fairly similar to the Armada-3700 SoC so most of the required
peripherals are already supported. This series adds a devicetree and pinc=
trl
driver for the SoC and the RD-AC5X-32G16HVG6HLG reference board.

Chris Packham (8):
  dt-bindings: pinctrl: mvebu: Document bindings for AC5
  dt-bindings: net: mvneta: Add marvell,armada-ac5-neta
  dt-bindings: mmc: xenon: add AC5 compatible string
  pinctrl: mvebu: pinctrl driver for 98DX2530 SoC
  net: mvneta: Add support for 98DX2530 Ethernet port
  mmc: xenon: add AC5 compatible string
  arm64: dts: marvell: Add Armada 98DX2530 SoC and RD-AC5X board
  arm64: marvell: enable the 98DX2530 pinctrl driver

 .../bindings/mmc/marvell,xenon-sdhci.txt      |  52 +++
 .../bindings/net/marvell-armada-370-neta.txt  |   1 +
 .../bindings/pinctrl/marvell,ac5-pinctrl.yaml |  70 ++++
 arch/arm64/Kconfig.platforms                  |   2 +
 arch/arm64/boot/dts/marvell/Makefile          |   1 +
 .../boot/dts/marvell/armada-98dx2530.dtsi     | 343 ++++++++++++++++++
 arch/arm64/boot/dts/marvell/rd-ac5x.dts       |  62 ++++
 drivers/mmc/host/sdhci-xenon.c                |   1 +
 drivers/mmc/host/sdhci-xenon.h                |   3 +-
 drivers/net/ethernet/marvell/mvneta.c         |  13 +
 drivers/pinctrl/mvebu/Kconfig                 |   4 +
 drivers/pinctrl/mvebu/Makefile                |   1 +
 drivers/pinctrl/mvebu/pinctrl-ac5.c           | 226 ++++++++++++
 13 files changed, 778 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,ac5=
-pinctrl.yaml
 create mode 100644 arch/arm64/boot/dts/marvell/armada-98dx2530.dtsi
 create mode 100644 arch/arm64/boot/dts/marvell/rd-ac5x.dts
 create mode 100644 drivers/pinctrl/mvebu/pinctrl-ac5.c

--=20
2.35.1

