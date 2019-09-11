Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6494EAF74B
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 09:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfIKHwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 03:52:21 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41049 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfIKHwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 03:52:20 -0400
Received: by mail-pf1-f193.google.com with SMTP id b13so13129573pfo.8;
        Wed, 11 Sep 2019 00:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q4c1ESOOpjE2P/uFd/KkrtGxclO2zKfVzjnW7aP5b5c=;
        b=icWt7W0/ZGxLPm02+gnA/J9j34su+UEYXiIxB1YxkdgQeerLuWIogY5w8f411VOCOq
         SgN3HpCyUKKt0AHKyEgPID2BBTF3u4+NAuk3B9QNNX/KsAULVe9vssToPV0QF4zjzvr0
         KKcBVuk0hI5R1cs9G7wNbXYDTEXe4mDCRGFBMbrNiIb2Z+MPOKB/5nd+zOlxhG7ImCxG
         bQPZ2M+gW9iF9Aikn4j/ghPrWXFh5X+F6gpMOK/20erVWKwkcBiH7ran3LtCKIHxFUnF
         4jUTN0gHJNHvc/00+XZPU9eLUehHBeQae0yLzl5aTDWL/DklS1NCHKX2o3qv5IO278+C
         /jmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q4c1ESOOpjE2P/uFd/KkrtGxclO2zKfVzjnW7aP5b5c=;
        b=hVs+MlzzlcOWf6afERJANW73FuqA9/qlcUxEMhazrFhYlDnNh3tLfNt9IcTLf5w8BX
         V5Jj3Sj4DxXrBidhKtVSWH8OlIX8Q/uxJ5SY4wP9bwmLmmm1Li//xbwNkjgzW+vvkJ5l
         1tjBL0D6KVsrKei/5+Ec06iwy23krOlgOOxkWD+n0K84p2IbP1QtpiQHXSXVzwvDPt/U
         FjAhi64ebcVp/w9yeyU1QPpkqiVG07RHQj3/nyeR7aR3O5M6B4Pn4C1S6JR4xt0sroPP
         /K6Oe5iN9Md+TlAJzOczJHYKS4ob00I36HWOiNQlRs1z6zdzjN0ikwy0zBjL61OrT0Wu
         Kf1g==
X-Gm-Message-State: APjAAAX5SHn81kdD08rPok9eR8N3aIHLh5vn9h2D2ck2HbQQLvLCIFyg
        BrjT3g8SJmd5/y1ulsIMzmsd2BmRBT0=
X-Google-Smtp-Source: APXvYqyrkl1nQUV0tQy2ao6Qp1atdp6sVcb56rA8O+j9Av28pZKjTEmBQuuMIwaP++GyQIODri9+7A==
X-Received: by 2002:a62:ee0a:: with SMTP id e10mr41430645pfi.197.1568188339617;
        Wed, 11 Sep 2019 00:52:19 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id u2sm8582445pgp.66.2019.09.11.00.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 00:52:19 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Jonas Karlman <jonas@kwiboo.se>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 00/11] Add support for software nodes to gpiolib
Date:   Wed, 11 Sep 2019 00:52:04 -0700
Message-Id: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.23.0.162.g0b9fbb3734-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series attempts to add support for software nodes to gpiolib, using
software node references that were introduced recently. This allows us
to convert more drivers to the generic device properties and drop
support for custom platform data:

static const struct software_node gpio_bank_b_node = {
|-------.name = "B",
};

static const struct property_entry simone_key_enter_props[] = {
|-------PROPERTY_ENTRY_U32("linux,code", KEY_ENTER),
|-------PROPERTY_ENTRY_STRING("label", "enter"),
|-------PROPERTY_ENTRY_REF("gpios", &gpio_bank_b_node, 123, GPIO_ACTIVE_LOW),
|-------{ }
};

If we agree in principle, I would like to have the very first 3 patches
in an immutable branch off maybe -rc8 so that it can be pulled into
individual subsystems so that patches switching various drivers to
fwnode_gpiod_get_index() could be applied.

Thanks,
Dmitry

Dmitry Torokhov (11):
  gpiolib: of: add a fallback for wlf,reset GPIO name
  gpiolib: introduce devm_fwnode_gpiod_get_index()
  gpiolib: introduce fwnode_gpiod_get_index()
  net: phylink: switch to using fwnode_gpiod_get_index()
  net: mdio: switch to using fwnode_gpiod_get_index()
  drm/bridge: ti-tfp410: switch to using fwnode_gpiod_get_index()
  gpliolib: make fwnode_get_named_gpiod() static
  gpiolib: of: tease apart of_find_gpio()
  gpiolib: of: tease apart acpi_find_gpio()
  gpiolib: consolidate fwnode GPIO lookups
  gpiolib: add support for software nodes

 drivers/gpio/Makefile              |   1 +
 drivers/gpio/gpiolib-acpi.c        | 153 ++++++++++++++----------
 drivers/gpio/gpiolib-acpi.h        |  21 ++--
 drivers/gpio/gpiolib-devres.c      |  33 ++----
 drivers/gpio/gpiolib-of.c          | 159 ++++++++++++++-----------
 drivers/gpio/gpiolib-of.h          |  26 ++--
 drivers/gpio/gpiolib-swnode.c      |  92 +++++++++++++++
 drivers/gpio/gpiolib-swnode.h      |  13 ++
 drivers/gpio/gpiolib.c             | 184 ++++++++++++++++-------------
 drivers/gpu/drm/bridge/ti-tfp410.c |   4 +-
 drivers/net/phy/mdio_bus.c         |   4 +-
 drivers/net/phy/phylink.c          |   4 +-
 include/linux/gpio/consumer.h      |  53 ++++++---
 13 files changed, 471 insertions(+), 276 deletions(-)
 create mode 100644 drivers/gpio/gpiolib-swnode.c
 create mode 100644 drivers/gpio/gpiolib-swnode.h

-- 
2.23.0.162.g0b9fbb3734-goog

