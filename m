Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED301BE867
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgD2URN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD2URN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:17:13 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06956C03C1AE;
        Wed, 29 Apr 2020 13:17:12 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i10so4099902wrv.10;
        Wed, 29 Apr 2020 13:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2QFptVeNUiGucrPStRhcbu3GmH4ZZHPExUVqKC5KTNE=;
        b=TEUDwHugOlDARK5/PgrSs+m57fyUAKQ+ezjCjGVH9wSY5rquCGXEIqz78rbyvz3q+6
         dbfgrfpY1X99iqyx8jG2BgBjErs/kZwKXGi1PmUReZfUn4yFFyzxRdvYqUmueqbx3EDg
         5dmVGY1ReWiJNe6OWCrx3+dJXK0EWA+B76fZmMWa3ASR175qH3TLtUR5QAWDLrK47gz9
         8IXMI/bDfACX2CiY+CHHBvOxD4cv2RJd+Y0SBP61FcUtkvbIOMqYmk6BwthYuyRbHoaq
         vgyf+oG2wzF38C4tpPPlEfTaS99pIyNCdMPZcpyWQuAcbPDYK/O80pLda5dOio39tthB
         Dc1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2QFptVeNUiGucrPStRhcbu3GmH4ZZHPExUVqKC5KTNE=;
        b=e5+yogfUvcxn/fvEz9jU6Pp1BQa6WOjkaNfsaERIWmQW8M1Gc1MUQm3GYxSYmc43Ia
         y9dCSaDA96Z7l3NUjiZimtbVdlhxGHS2V7TGQ3PB/VvPoevrPAOZhNvGooohqYlL5l2n
         rn6Y3Iq4W1fUQ5hrsN/Ou14c6V8IIB2ENALT2/nlfQ9f9yvtRWqhIkZX9mxNnTCCpq5B
         JZutjo3Enyf9HRIMHD2UvAkxZL74UUz3XD6rtb1X/FwwSDarvJ999pVBLmoHiMgpo9lv
         frVdyBKavtCKeBJi3ag5v/FNtl6xtYoV2xWrfmCzGF4gjB/s7FGRyszsu0Vkmc6FmtEx
         vE9A==
X-Gm-Message-State: AGi0PuYaFKSYMCXFCgk3Cdvn+ktxc1hEGzNXrhDvyVkT+ycfsf61Ojxf
        ZZcUKEryoVxbYQ6vc3ajCys=
X-Google-Smtp-Source: APiQypKmWbt8lj9u0K6Q8MSDHiXGVwacgaiLnfiCNuXjDcwsnRsHUXCWXg3gmbfoan5C/msPR1zi9g==
X-Received: by 2002:a5d:5304:: with SMTP id e4mr39007886wrv.87.1588191431421;
        Wed, 29 Apr 2020 13:17:11 -0700 (PDT)
Received: from localhost.localdomain (p200300F137142E00428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:3714:2e00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q143sm9923623wme.31.2020.04.29.13.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 13:17:10 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 00/11] dwmac-meson8b Ethernet RX delay configuration
Date:   Wed, 29 Apr 2020 22:16:33 +0200
Message-Id: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ethernet TX performance has been historically bad on Meson8b and
Meson8m2 SoCs because high packet loss was seen. I found out that this
was related (yet again) to the RGMII TX delay configuration.
In the process of discussing the big picture (and not just a single
patch) [0] with Andrew I discovered that the IP block behind the
dwmac-meson8b driver actually seems to support the configuration of the
RGMII RX delay (at least on the Meson8b SoC generation).

Since I sent the last RFC I got additional documentation from Jianxin
(many thanks!). Also I have discovered some more interesting details:
- Meson8b Odroid-C1 requires an RX delay (by either the PHY or the MAC)
  Based on the vendor u-boot code (not upstream) I assume that it will
  be the same for all Meson8b and Meson8m2 boards
- Khadas VIM2 seems to have the RX delay built into the PCB trace
  length. When I enable the RX delay on the PHY or MAC I can't get any
  data through. I expect that we will have the same situation on all
  GXBB, GXM, AXG, G12A, G12B and SM1 boards


Changes since RFC v1 at [1]:
- add support for the timing adjustment clock input (dt-bindings and
  in the driver) thanks to the input from the unnamed Ethernet engineer
  at Amlogic. This is the missing link between the fclk_div2 clock and
  the Ethernet controller on Meson8b (no traffic would flow if that
  clock was disabled)
- add support fot the amlogic,rx-delay-ns property. The only supported
  values so far are 0ns and 2ns. The registers seem to allow more
  precise timing adjustments, but I could not make that work so far.
- add more register documentation (for the new RX delay bits) and
  unified the placement of existing register documentation. Again,
  thanks to Jianxin and the unnamed Ethernet engineer at Amlogic
- DO NOT MERGE: .dts patches to show the conversion of the Meson8b
  and Meson8m2 boards to "rgmii-id". I didn't have time for all arm64
  patches yet, but these will switch to phy-mode = "rgmii-txid" with
  amlogic,rx-delay-ns = <0> (because the delay seems to be provided by
  the PCB trace length).


[0] https://patchwork.kernel.org/patch/11309891/
[1] https://patchwork.kernel.org/cover/11310719/


Martin Blumenstingl (11):
  dt-bindings: net: meson-dwmac: Add the amlogic,rx-delay-ns property
  dt-bindings: net: dwmac-meson: Document the "timing-adjustment" clock
  net: stmmac: dwmac-meson8b: use FIELD_PREP instead of open-coding it
  net: stmmac: dwmac-meson8b: Move the documentation for the TX delay
  net: stmmac: dwmac-meson8b: Add the PRG_ETH0_ADJ_* bits
  net: stmmac: dwmac-meson8b: Fetch the "timing-adjustment" clock
  net: stmmac: dwmac-meson8b: Make the clock enabling code re-usable
  net: stmmac: dwmac-meson8b: add support for the RX delay configuration
  arm64: dts: amlogic: Add the Ethernet "timing-adjustment" clock
  ARM: dts: meson: Add the Ethernet "timing-adjustment" clock
  ARM: dts: meson: Switch existing boards with RGMII PHY to "rgmii-id"

 .../bindings/net/amlogic,meson-dwmac.yaml     |  23 ++-
 arch/arm/boot/dts/meson8b-odroidc1.dts        |   3 +-
 arch/arm/boot/dts/meson8b.dtsi                |   5 +-
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts     |   4 +-
 arch/arm/boot/dts/meson8m2.dtsi               |   5 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   6 +-
 .../boot/dts/amlogic/meson-g12-common.dtsi    |   6 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi   |   5 +-
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   5 +-
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 140 ++++++++++++++----
 10 files changed, 150 insertions(+), 52 deletions(-)

-- 
2.26.2

