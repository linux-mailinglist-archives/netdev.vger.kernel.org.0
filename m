Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71206253A79
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgHZW4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgHZW4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:56:41 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F379C061574;
        Wed, 26 Aug 2020 15:56:40 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f26so4229242ljc.8;
        Wed, 26 Aug 2020 15:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gyu34eqNIzm7NHyu71tvXj/6BZWs11p7Z/KgaEDFzxg=;
        b=Urv33F113PADAG1mDhqUyy9F+l6t3eEJtPXqPEm14U5YrOtRAYae7t970B1UxB1QW1
         ksll53n4tloVnrddAxvshwMERcm0WF8fCA9qb3g2ux1TD3yppKPm/Ek6ziaNAXfTZWX0
         eq/Z5kawDvjjHztTAGrOX8S6XL2eUwWXrZBUNn1ruAq2QlVDfHwikjUUPGdj8LVHRMeA
         z5rc4Nx9s/IAw2TzvGgSQ5EQH4TW5+ZzN9NHMsPvdJyq227W7JhMSBR/jp8trbhVenC9
         oasbftIhwQ2izMAC8r/56u6e9A36c9ASJ2NjCYNrFhvmYz3etttr2P2HF6qrQVLNV4qK
         IEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gyu34eqNIzm7NHyu71tvXj/6BZWs11p7Z/KgaEDFzxg=;
        b=oahTtYgKBzJVBMDn0s6Tz5qlkg+17IrpC7Gd7gPjllDfHm7WxxLih0G2KyJ7Kx3BED
         g4Yo5trSqY1VTICZeG9AooN9QnSN2B3kqBa8pqnIFbyuT5ArgsAtOQiyAjbSE2dZspmr
         Xl/CIUzeybR0ZfFoVVYry6e6M/Cl/kzZley6ZaAMC0rYVLs+nVow9sJ5nLrFkx9te+2u
         RxzNoSG7bedAuf4BkdLvrdueoVeAKF56OsAcwlUv+ORyVmrC9MhZDxelMNX6lReUpE/G
         FrtiLguH8lDjXP5T4fs0g/tsvVraEmU1pytvyL/lpCmpv4AmQ4bqa+zdteJCA36ObVpz
         U1uQ==
X-Gm-Message-State: AOAM530OzW5tuDcM5DSh/j/rT7Qj4n3amD/LY1F+qGAEY6StLEJ3jwBR
        Twr8XU09a9VzGEtjnnYmUjA=
X-Google-Smtp-Source: ABdhPJy5R3OaYZkfrzmMwNaDf/6vVUJyPNM2j0O2fvAcTtmpOckD7xr1Mna4zW+WtossdAx+ebNCpA==
X-Received: by 2002:a05:651c:155:: with SMTP id c21mr8770175ljd.453.1598482598696;
        Wed, 26 Aug 2020 15:56:38 -0700 (PDT)
Received: from localhost.localdomain (h-82-196-111-59.NA.cust.bahnhof.se. [82.196.111.59])
        by smtp.gmail.com with ESMTPSA id u28sm49075ljd.39.2020.08.26.15.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 15:56:37 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Kalle Valo <kvalo@codeaurora.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH net-next 0/6] drivers/net: constify static ops-variables
Date:   Thu, 27 Aug 2020 00:56:02 +0200
Message-Id: <20200826225608.90299-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series constifies a number of static ops variables, to allow the
compiler to put them in read-only memory. Compile-tested only.

Rikard Falkeborn (6):
  net: ethernet: qualcomm: constify qca_serdev_ops
  net: ethernet: ravb: constify bb_ops
  net: renesas: sh_eth: constify bb_ops
  net: phy: at803x: constify static regulator_ops
  net: phy: mscc: macsec: constify vsc8584_macsec_ops
  net: ath11k: constify ath11k_thermal_ops

 drivers/net/ethernet/qualcomm/qca_uart.c  | 2 +-
 drivers/net/ethernet/renesas/ravb_main.c  | 2 +-
 drivers/net/ethernet/renesas/sh_eth.c     | 2 +-
 drivers/net/phy/at803x.c                  | 4 ++--
 drivers/net/phy/mscc/mscc_macsec.c        | 2 +-
 drivers/net/wireless/ath/ath11k/thermal.c | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.28.0

