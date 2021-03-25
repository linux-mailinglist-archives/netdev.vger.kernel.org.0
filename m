Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0430C349246
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhCYMnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhCYMmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:42:35 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB40C06174A;
        Thu, 25 Mar 2021 05:42:33 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id l76so1656269pga.6;
        Thu, 25 Mar 2021 05:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C4nI1KUl9G1G9ZlgtJo82RLpSdsCwNuG0Shl5fKFntc=;
        b=f8WRyre9YmwoNrvQkJg0F7VluVW7CcXOXHpNuoeoWdw7bVKZTRzfY8UU5aIZq6mFhb
         oglkr07dW0ahasGEWwPCeyIrLCIrPlnllLV1GkGig3VckQ8teJVcnfqYu/OrVgIvGdsZ
         zhmWPmywNCX2hKxmfnIHyQKx3YCfp+1W9Ta+34gdFXGdMHMs5l/bzzZb8Uysz8Eg/qci
         3xfR8gwJgpS4W2daTOEOI2SNYgOY6BbmSJJHmdtOy3+BS3vqU3YQavNVL5FvOhbp4zW2
         LQN3dWIZkzV45+Gf/C0oC0DN2Z08wTcRzVGcxwuLXivC8/puO95avE5aBMs1c82ezGmW
         KAPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C4nI1KUl9G1G9ZlgtJo82RLpSdsCwNuG0Shl5fKFntc=;
        b=UGrpl8Q53Lo2W/imnAST6Q/4Niz0HRxtbkRXJhxwWMRDgzRQFEdbmm5WrJ8Q0mMPqn
         6yI977rCuxy1Io6VLeXFzsY/UBPz4n7t3zPXgNV2f6iuAGRkByN8SyTeSG2cCPTPsMOF
         FQZ7TS6QxQtprs9qSGi6wt0U8NLeFvg1ymDoIu5foFwRooA2RpJwXJI0wNNdTZgh7Ykf
         Ee+H7QcYOomicasA5An1eoDh4cTEUtPZkHthgL+DMbJ3ViGINZnuAbCCz/uOodcKZ8Q5
         F1stHMiiTcfUeWpnGkPaBzxzfCmLQjiZgYkTDzhCKfRXqL6tQ8X5H2NZukCgtxYBAl/h
         K7/A==
X-Gm-Message-State: AOAM532pnP3g+3vKXBVcijjPoN0D6wLVg/Rm6l6SltKwbY7lR9XSltp6
        PPxVdXxy/eu1mICnvLd1Csk=
X-Google-Smtp-Source: ABdhPJys3UTK7w3g7KmDs+EYdtyXHqpK1lJXIYfn1mX99LDU3uLj/z/qMmlAI144Vlv6vi9TiMJFqQ==
X-Received: by 2002:a17:902:7887:b029:e6:d880:de91 with SMTP id q7-20020a1709027887b02900e6d880de91mr9741816pll.34.1616676153125;
        Thu, 25 Mar 2021 05:42:33 -0700 (PDT)
Received: from archl-c2lm.. ([103.51.72.9])
        by smtp.gmail.com with ESMTPSA id t17sm6125917pgk.25.2021.03.25.05.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:42:32 -0700 (PDT)
From:   Anand Moon <linux.amoon@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Anand Moon <linux.amoon@gmail.com>,
        linux-amlogic@lists.infradead.org
Subject: [PATCHv1 0/6] Amlogic Soc - Add missing ethernet mdio compatible string
Date:   Thu, 25 Mar 2021 12:42:19 +0000
Message-Id: <20210325124225.2760-1-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On most of the Amlogic SoC I observed that Ethernet would not get
initialize when try to deploy the mainline kernel, earlier I tried to
fix this issue with by setting ethernet reset but it did not resolve
the issue see below.
	resets = <&reset RESET_ETHERNET>;
	reset-names = "stmmaceth";

After checking what was the missing with Rockchip SoC dts
I tried to add this missing compatible string and then it
started to working on my setup.

Also I tried to fix the device tree binding to validate the changes.

Tested this on my Odroid-N2 and Odroid-C2 (64 bit) setup.
I do not have ready Odroid C1 (32 bit) setup so please somebody test.

Best Regards
-Anand

Anand Moon (6):
  dt-bindings: net: ethernet-phy: Fix the parsing of ethernet-phy
    compatible string
  arm: dts: meson: Add missing ethernet phy mdio compatible string
  arm64: dts: meson-gxbb: Add missing ethernet phy mimo compatible
    string
  arm64: dts: meson-gxl: Add missing ethernet phy mdio compatible string
  arm64: dts: meson-g12: Add missing ethernet phy mdio compatible string
  arm64: dts: meson-glx: Fix the ethernet phy mdio compatible string

 Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 +++---
 arch/arm/boot/dts/meson8b-ec100.dts                     | 1 +
 arch/arm/boot/dts/meson8b-mxq.dts                       | 1 +
 arch/arm/boot/dts/meson8b-odroidc1.dts                  | 1 +
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts               | 1 +
 arch/arm64/boot/dts/amlogic/meson-axg-s400.dts          | 1 +
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts      | 1 +
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi   | 3 ++-
 arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi        | 1 +
 arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi  | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts      | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts    | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts  | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts     | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts         | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi    | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi       | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts    | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi              | 2 +-
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts   | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts     | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts          | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts      | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dts      | 1 +
 arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi      | 1 +
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi       | 1 +
 26 files changed, 29 insertions(+), 5 deletions(-)

-- 
2.31.0

