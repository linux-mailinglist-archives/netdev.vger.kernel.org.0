Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C3C3AB09
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 20:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfFISGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 14:06:39 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:33374 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbfFISGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 14:06:39 -0400
Received: by mail-wr1-f49.google.com with SMTP id n9so6928972wru.0;
        Sun, 09 Jun 2019 11:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ano8Vhtn94lHxYeXYf8C2liDhnRtj0RyswD7iYRMvtE=;
        b=omjgj0A/dXurFQujeU9x3OaA4una8zKFS92v5PE9/JYTnJWa6oc/E9pXSgNTjW+cfQ
         +AQqXFl17iW48FBo6FJXBY9sBgMQM1QROsg5PJUPTKiGdw6tbyN4d/yxNqw1b+hatMMh
         QSBYSGYulFDDJk/CW3DBKMjWyx2QewK8pVAx9imma1xZe8DgMyHSBdBl2pKFuOpONEf9
         6pVrGECfuLHXS0/pU7Oign+LkPvvcCjoxMMLk2MNmNftTn6GLhOF+QwuwGdXf/Vpnx3k
         Gc3tFKqDvuPgFlhxke2trXxsfU0pljBqm6UpyMqFw7wGOaxjiP20Q6NkhcnCLmD8v9Iq
         Wi8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ano8Vhtn94lHxYeXYf8C2liDhnRtj0RyswD7iYRMvtE=;
        b=LPWfDo5KMFGz5nB0LU5YwLHogn0ZIE2Yj1VvrefeUSuQvdURRmNcqQsikp7rIgph4/
         hdPnuIdSOq4dXECkXjQbijg+zUDiHnSYNcdr76t444wVfBzWjZMWEVz9yC/iW3bOUcY2
         caMCsB7Wfv5l3Gb8tyBLt1slgeSx09odkOJHzd208vAO4kQOgdSXPnTScdXOCGPmJbfE
         AGFQjdhFFWCwos3y6oEYwLlQ442EzEn6oT0VELkRBx/g2EVsVF5nOlpKRiptn0AGV1Hh
         2MRoKmW4+z+a/hvfzPepSeyPHcoVzQa0rH+6Wl7VGhbD8sF9O3AzI2+1Bphu9uU4ArMX
         BC9g==
X-Gm-Message-State: APjAAAVcyldBzW0bUct6CQ3MWhMWjynYr31WUHtOboO6atYrI6e3hfoD
        AYEll3cI484cQdWt9RhdZCmTrTQ2
X-Google-Smtp-Source: APXvYqzMsHnTza3f8EEGCKkomYS21dQSyTH6qbpkHUxB3C0jHRwfrV9JvjmS1SqIWP57n6N7utEh7w==
X-Received: by 2002:adf:ee4a:: with SMTP id w10mr30497619wro.311.1560103596369;
        Sun, 09 Jun 2019 11:06:36 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA400B42D8EB9D711C35E.dip0.t-ipconnect.de. [2003:f1:33dd:a400:b42d:8eb9:d711:c35e])
        by smtp.googlemail.com with ESMTPSA id h14sm2007731wrs.66.2019.06.09.11.06.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 11:06:35 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Cc:     devicetree@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        khilman@baylibre.com, narmstrong@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC next v1 0/5] stmmac: honor the GPIO flags for the PHY reset GPIO
Date:   Sun,  9 Jun 2019 20:06:16 +0200
Message-Id: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent Amlogic SoCs (G12A which includes S905X2 and S905D2 as well as
G12B which includes S922X) use GPIOZ_14 or GPIOZ_15 for the PHY reset
line. These GPIOs are special because they are marked as "3.3V input
tolerant open drain (OD) pins" which means they can only drive the pin
output LOW (to reset the PHY) or to switch to input mode (to take the
PHY out of reset).
The GPIO subsystem already supports this with the GPIO_OPEN_DRAIN and
GPIO_OPEN_SOURCE flags in the devicetree bindings.

The goal of this series to add support for these special GPIOs in
stmmac.

Patch #2 prepares gpiolib-of for the switch from (legacy) GPIO numbers
to GPIO descriptors in stmmac. This requires the gpiolib-of to take
care of the "snps,reset-active-low" property.

Patch #3 switches stmmac from (legacy) GPIO numbers to GPIO descriptors
because this enables tracking of the GPIO flags which are passed via
devicetree. In other words: GPIO_OPEN_DRAIN and GPIO_OPEN_SOURCE are
now honored correctly, which is exactly what is needed for these
Amlogic platforms.

Patch #1 and #4 are minor cleanups which follow the boyscout rule:
"Always leave the campground cleaner than you found it."

Patch #5 is included here to show how this new functionality is used.

My test-cases were:
- X96 Max: snps,reset-gpio = <&gpio GPIOZ_15 0> with and without
           snps,reset-active-low before these patches. The PHY was
           not detected.
- X96 Max: snps,reset-gpio = <&gpio GPIOZ_15 GPIO_OPEN_SOURCE>. The
           PHY is now detected correctly
- Meson8b EC100: snps,reset-gpio = <&gpio GPIOH_4 0> with
                 snps,reset-active-low. Before and after these
                 patches the PHY is detected correctly.
- Meson8b EC100: snps,reset-gpio = <&gpio GPIOH_4 0> without
                 snps,reset-active-low. Before and after these
                 patches the PHY is not detected (this is expected
                 because we need to set the output LOW to take the
                 PHY out of reset).
- Meson8b EC100: snps,reset-gpio = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>
                 but without snps,reset-active-low. Before these
                 patches the PHY was not detected. With these patches
                 the PHY is now detected correctly.

I am sending this as RFC because I'm not very familiar with the GPIO
subsystem. What I came up with seems fine to me, but I'm not sure so
I don't want this to be applied before Linus W. is happy with it. I
am also looking for suggestions how to handle these cross-tree changes
(patch #2 belongs to the linux-gpio tree, patches #1, 3 and #4 should
go through the net-next tree. I will re-send patch #5 separately as
this should go through Kevin's linux-amlogic tree).


Martin Blumenstingl (5):
  net: stmmac: drop redundant check in stmmac_mdio_reset
  gpio: of: parse stmmac PHY reset line specific active-low property
  net: stmmac: use GPIO descriptors in stmmac_mdio_reset
  net: stmmac: use device_property_read_u32_array to read the reset
    delays
  arm64: dts: meson: g12a: x96-max: fix the Ethernet PHY reset line

 .../boot/dts/amlogic/meson-g12a-x96-max.dts   |  3 +-
 drivers/gpio/gpiolib-of.c                     |  6 +++
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 43 ++++++++-----------
 3 files changed, 26 insertions(+), 26 deletions(-)

-- 
2.21.0

