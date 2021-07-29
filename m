Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4563DAC7F
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 22:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhG2ULV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 16:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhG2ULS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 16:11:18 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026DEC061765;
        Thu, 29 Jul 2021 13:11:14 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c16so8279825plh.7;
        Thu, 29 Jul 2021 13:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SFY+mAXfPYLLK9cW7HzO6u98/FnYWTRchgWW3VXCzJY=;
        b=CZRZWcBHZ3gsBtAsaaCXtu4WXrBPcFPXBjErtIBPrg3LCfGvZKMvnvfzxOpuB8yNuS
         b7hhyG7Ydp7eXWqF8NZvY4Lk1EBHnBK1p9DWUGTAWBOWxqGVTxU/8wFyMteNvkDgQsu/
         /D4PUp0w1T3efUYYyJrY/whFdocsigxCWbSaSOONiVqCG1LMGxL/6XSduRWAMFT4NY/0
         3wGuS5uxtRvB+kGK/10DuuJNLa57PUIf04hkTgiN/AhzEhd5/8FmI3+ezlTqRSIMW9fY
         /8FKk7lN/0ho69zNfQ/k9avzfqLVlDOOiDcavnkKkuof89/k0Ite+rQ1I6n4ghc6uEWo
         VU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SFY+mAXfPYLLK9cW7HzO6u98/FnYWTRchgWW3VXCzJY=;
        b=UOgg4bJ8Pu/bQl4W+HpVm/aq2v4DTuFVGm9v5IsLBysWv2G3vQj/RUtIiOyCqs9CDO
         P+u/Fa5nxSXH5d/U8HzthyJUDWpHXBpvTLS8XM9+XQPlCPBgm1PGGGvdI/LiO1ovfoa8
         8ZoK4m+2p18uwxWWHY5Zwe0bb5DgeXN+ZZoh8+eyU2vwPoqw5SKYuwZ+ZJejxHR6oY/U
         P4JFMBOKDE24NeD4L7VJWrtM9TDZAu6Qmv17PTB+ZgxALnWUdFX+Fy9NrFlXtatr2gXj
         8jFeF0hs82yRUJnkKIKXaN8sSiMYiTKdkr1NmJ0K0eGZcFhMUH2rSSjduIukm8fJoKWT
         L0oA==
X-Gm-Message-State: AOAM532KxMWC9HUDq4aHkFKy1pNtms83XTObWFxdGs8+0eW5jpwkJri/
        QQxFEp2oXEPB+vA20yqi6CeZXa1b1jYg6A==
X-Google-Smtp-Source: ABdhPJyLfmsnUTsywkKEatkPj6U8cyNcuBN/igDBOIZHeLE0gMDlmQgZxQF2YmSyYSFXYKsLiD5tZA==
X-Received: by 2002:a17:902:f68d:b029:12c:4619:c63a with SMTP id l13-20020a170902f68db029012c4619c63amr6316218plg.66.1627589473174;
        Thu, 29 Jul 2021 13:11:13 -0700 (PDT)
Received: from archl-on1.. ([103.51.72.31])
        by smtp.gmail.com with ESMTPSA id i25sm4581407pfo.20.2021.07.29.13.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 13:11:12 -0700 (PDT)
From:   Anand Moon <linux.amoon@gmail.com>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        devicetree@vger.kernel.org
Cc:     Anand Moon <linux.amoon@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Emiliano Ingrassia <ingrassia@epigenesys.com>
Subject: [PATCHv1 0/3] Add Reset controller to Ethernet PHY
Date:   Fri, 30 Jul 2021 01:40:49 +0530
Message-Id: <20210729201100.3994-1-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is being observed some time the Ethernet interface
will not send / recive any packet after reboot.

Earlier I had submitted Ethernet reset ID patch
but it did not resolve it issue much, Adding new 
reset controller of the Ethernet PHY for Amlogic SoC
could help resolve the issue.

Thanks
-Anand

Anand Moon (3):
  arm64: dts: amlogic: add missing ethernet reset ID
  ARM: dts: meson: Use new reset id for reset controller
  net: stmmac: dwmac-meson8b: Add reset controller for ethernet phy

 arch/arm/boot/dts/meson8b.dtsi                |  2 +-
 arch/arm/boot/dts/meson8m2.dtsi               |  2 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |  2 ++
 .../boot/dts/amlogic/meson-g12-common.dtsi    |  2 ++
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi     |  3 +++
 .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 20 +++++++++++++++++++
 6 files changed, 29 insertions(+), 2 deletions(-)

-- 
2.32.0

