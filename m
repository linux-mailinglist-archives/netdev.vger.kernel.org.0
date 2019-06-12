Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8478643032
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 21:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbfFLTbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 15:31:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33802 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbfFLTbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 15:31:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id e16so18179523wrn.1;
        Wed, 12 Jun 2019 12:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=piJHUi4lk+8l3N6vpCR4aXaFS5oizipdYRkQO+KF1qQ=;
        b=Z16lXH8fCl6C5qbOQPQTz2P6w/DihSOJFI8TyxYwWTfTBbw73Du2lc+fqNe2U3KzZl
         v51mK6JVlP5ZEoQ9IMShm+xVQ665mKx/QvFUTY7eQAa6sEbwxr/Vk6tKBZTRiR9K7P3F
         RMufcoChyle0YhJhhHNS0sbZbvdG+uzCi754D7DDW6j/4U8+KP70WWcPVNnAFbknuyc0
         z7eGRB59ZaKuTptvlulTj5Kiarslp+WO7D8JdVUwG8jTkNzN1SbzqPp9OjK17VNnJPG0
         9uzQ5TmybU/EmZzxvo+WeSAXkDgAuSHBQlGkjmS/PdZAyTE0VHWulxTdhAd1gcNMlX+r
         RnMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=piJHUi4lk+8l3N6vpCR4aXaFS5oizipdYRkQO+KF1qQ=;
        b=em+OC/EObBnWljYsZdDrq8NBJ7rGulgRh8OO5gLpQ5isMzINh6naFqsahA5OpvlZx8
         ij6qb8Po+4gJOemsYBswtYN+/kFfHYNTawozZgspX/AHsZnWyW/9lKtiadN4THaNUuIx
         JxdCGSufnBtoNoUNFaG7O5MoB8PYhLH62o3cjMDZk0o0w/0b5haUgwzHkE3kzKwm9m6a
         rp6bo01fjk9CSfzEDu3QyLvcrCsXafWtKcE7pQO4p7WthzbrILgzOkYAh4sIxtszjHc8
         VXIhR0shHUoPhJ7CPiwPD0t+wXqQr5n0HGCqditg/5OdLkDyrdpo5C2xhEArpfeJEilO
         F4Fw==
X-Gm-Message-State: APjAAAU2UErmRhfw+eVPMd/vrgiWwrcG8+5Zoo7eYsjgEXxuZrSZd2lj
        poSt3DNQ/phxoI2rKs3wZZ03+msk
X-Google-Smtp-Source: APXvYqyGq9L4GORx9QxsX5rk1418GVqtaX0ZpZZsqVbJqkJiH4gzhyYbqE2/1oCnWRloDJhytm05cg==
X-Received: by 2002:adf:e2c7:: with SMTP id d7mr1272968wrj.272.1560367894513;
        Wed, 12 Jun 2019 12:31:34 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA400428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:33dd:a400:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q15sm379054wrr.19.2019.06.12.12.31.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 12:31:33 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        andrew@lunn.ch
Cc:     linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        maxime.ripard@bootlin.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next v2 0/1] stmmac: honor the GPIO flags for the PHY reset GPIO
Date:   Wed, 12 Jun 2019 21:31:14 +0200
Message-Id: <20190612193115.6751-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
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
stmmac (even though the "snps,reset-gpio" binding is deprecated).

My test-cases were:
- X96 Max: snps,reset-gpio = <&gpio GPIOZ_15 0> with and without
           snps,reset-active-low before these patches. The PHY was
           not detected.
- X96 Max: snps,reset-gpio = <&gpio GPIOZ_15
                              (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>.
           The PHY is now detected correctly
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


Changes since RFC v1 at [0]:
- dropped all patches except the main patch which changes
  stmmac_mdio_reset to use GPIO descriptors (I will send the cleanup
  patches in a separate series once this patch is merged)
- drop the active_low field from struct stmmac_mdio_bus_data
- added Linus Walleij's Reviewed-by (thank you!)


DEPENDENCIES:
This has a runtime dependency on the preparation patch [0] from
Linus W.'s GPIO tree. Without that dependency the
snps,reset-active-low property (which quite a few .dts files use)
will be ignored.
Linus created an immutable branch which can be pulled into net-next:
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
ib-snps-reset-gpio
gitweb for this immutable branch: [2]


[0] https://patchwork.kernel.org/cover/10983801/
[1] https://patchwork.ozlabs.org/cover/1113217/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git/log/?h=ib-snps-reset-gpio


Martin Blumenstingl (1):
  net: stmmac: use GPIO descriptors in stmmac_mdio_reset

 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 27 +++++++++----------
 include/linux/stmmac.h                        |  2 +-
 2 files changed, 14 insertions(+), 15 deletions(-)

-- 
2.22.0

