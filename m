Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25AD337090
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfFFJrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:47:13 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36616 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727545AbfFFJrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:47:09 -0400
Received: by mail-lf1-f65.google.com with SMTP id q26so1069667lfc.3
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 02:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZUJtTHTXNxu11uFgApSggUR6FUDtGDSUrwD5+2c4fw4=;
        b=fjWTs+v9sRcacPTkE7/eRu/9lwuTPBz6IVARKm6m4Eq7OW7fr63Dg12tQgHVVCRbol
         X9xJuP/JqN3cXHjJiC6f8ejkT+eMEcvNjqmDsSgH22spBK04YFEiIlwrHageUyfQp0xt
         Dr0W1fN4Dhoc4Vs0e2dMfi84pDucPLYspHEx1qyBDNLoCiJIDHxXk89F7LxCZQIsKONd
         8my/z5+M+Fr/vICw5e12GUeEZWFVwbkdPpr56GF9RuHraCzJOfRPTERnTkxQX5WMo6cS
         EP4xY+CInGYsGcd/8/b+F6qjYG5PezinP4T3p0CCu/MDQ46QsZOu/D1w+p5MJ3axD+dR
         KU2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZUJtTHTXNxu11uFgApSggUR6FUDtGDSUrwD5+2c4fw4=;
        b=aiSce34xemD3kj4Rj/OWu/Kgy0zTldy7HIxoJmx+rEDGb0Q3b17eoUeMD0XHTZ1750
         TvQ2Smg2QhkJVWHeo+0USuPGnObjJyNamg6vGafPsZ8Rb+6QcEgXLSzdgZWJ4CGF6KuU
         S3s8ZL5gWMhCsSuTjeC8+T2v+tGkJ3mgXks/8jD1QPdqeP5+ypsmDZJ2+bDXtLOY1zdG
         OUsF9RO46kAd205p2GZaZSQzMbCM1Qic9yrY2M1H/SxHEjenIBH5oD7rG0xkv7n6qhAa
         kdIBq1D4/9bdB3VzWn4YqTaPSuwh2rk9t1gA224lB0oEhuG3e30gjRSIaDGhwau7gQZh
         EX/Q==
X-Gm-Message-State: APjAAAWnHIf7u3OfveLaLmOZIOCD53QwugPOkeM8H1ivJvcYWhDUXk20
        JkRKKhkIjHv6xylZsHfB930jKA==
X-Google-Smtp-Source: APXvYqyfSm4WZqLlK2FuAsUFqx7p2Ew9DH+2Np2QIeyhi9dQlGG8JR0BxiRPugpDfNWGd0YdYSALPA==
X-Received: by 2002:ac2:5609:: with SMTP id v9mr15271221lfd.27.1559814426775;
        Thu, 06 Jun 2019 02:47:06 -0700 (PDT)
Received: from localhost (c-1c3670d5.07-21-73746f28.bbcust.telenor.se. [213.112.54.28])
        by smtp.gmail.com with ESMTPSA id e8sm241763lfc.27.2019.06.06.02.47.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 02:47:06 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        marex@denx.de, stefan@agner.ch, airlied@linux.ie, daniel@ffwll.ch,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        b.zolnierkie@samsung.com, a.hajda@samsung.com, mchehab@kernel.org,
        p.zabel@pengutronix.de, hkallweit1@gmail.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-media@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 0/8] fix warnings for same module names
Date:   Thu,  6 Jun 2019 11:46:57 +0200
Message-Id: <20190606094657.23612-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch set addresses warnings that module names are named the
same, this may lead to a problem that wrong module gets loaded or if one
of the two same-name modules exports a symbol, this can confuse the
dependency resolution. and the build may fail.


Patch "drivers: net: dsa: realtek: fix warning same module names" and
"drivers: net: phy: realtek: fix warning same module names" resolves the
name clatch realtek.ko.

warning: same module names found:
  drivers/net/phy/realtek.ko
  drivers/net/dsa/realtek.ko


Patch  "drivers: (video|gpu): fix warning same module names" resolves
the name clatch mxsfb.ko.

warning: same module names found:
  drivers/video/fbdev/mxsfb.ko
  drivers/gpu/drm/mxsfb/mxsfb.ko

Patch "drivers: media: i2c: fix warning same module names" resolves the
name clatch adv7511.ko however, it seams to refer to the same device
name in i2c_device_id, does anyone have any guidance how that should be
solved?

warning: same module names found:
  drivers/gpu/drm/bridge/adv7511/adv7511.ko
  drivers/media/i2c/adv7511.ko


Patch "drivers: media: coda: fix warning same module names" resolves the
name clatch coda.ko.

warning: same module names found:
  fs/coda/coda.ko
  drivers/media/platform/coda/coda.ko


Patch "drivers: net: phy: fix warning same module names" resolves the
name clatch asix.ko.

warning: same module names found:
  drivers/net/phy/asix.ko
  drivers/net/usb/asix.ko

Patch "drivers: mfd: 88pm800: fix warning same module names" and
"drivers: regulator: 88pm800: fix warning same module names" resolves
the name clatch 88pm800.ko.

warning: same module names found:
  drivers/regulator/88pm800.ko
  drivers/mfd/88pm800.ko


Cheers,
Anders

Anders Roxell (8):
  drivers: net: dsa: realtek: fix warning same module names
  drivers: net: phy: realtek: fix warning same module names
  drivers: (video|gpu): fix warning same module names
  drivers: media: i2c: fix warning same module names
  drivers: media: coda: fix warning same module names
  drivers: net: phy: fix warning same module names
  drivers: mfd: 88pm800: fix warning same module names
  drivers: regulator: 88pm800: fix warning same module names

 drivers/gpu/drm/bridge/adv7511/Makefile | 10 +++++-----
 drivers/gpu/drm/mxsfb/Makefile          |  4 ++--
 drivers/media/i2c/Makefile              |  3 ++-
 drivers/media/platform/coda/Makefile    |  4 ++--
 drivers/mfd/Makefile                    |  7 +++++--
 drivers/net/dsa/Makefile                |  4 ++--
 drivers/net/phy/Makefile                |  6 ++++--
 drivers/regulator/Makefile              |  3 ++-
 drivers/video/fbdev/Makefile            |  3 ++-
 9 files changed, 26 insertions(+), 18 deletions(-)

-- 
2.20.1

