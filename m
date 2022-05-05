Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3970851C1BA
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380281AbiEEN7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380298AbiEEN7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:59:00 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24756255;
        Thu,  5 May 2022 06:55:20 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gh6so8940803ejb.0;
        Thu, 05 May 2022 06:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yEHOMcuhZdD8iiVryYSYsQQJvPICrzWTzhkdXbqbOh4=;
        b=f0oe8b34qhyHBhRStMC/F4qC80Gsw+fZFC2Ma/awi+7RWzk5h1+3HRlfNufs6nAMS8
         7rIeRKou7pZ79oJx1CXV/FEgXdNFiURLRIn7gWMheU+a3IYR6whf27aLpqu/1YLgGWa/
         7vMMQmkCL45KIR0LRq9xa9XnlheqZIy9GWcbfTqGJvNyRkmAcxUhj77BnXsEy0z4QbH3
         hCs5XxwTQQehukEcWpaZ2MSgSs7HI/CVXdzhihcSZ9Gtg2QgAwFvR8pkSl/T+QxLHOSq
         BIhklJ5fsYzBW+yDzpmOTx7WUYjUjaAZQM0jj75FmUEHFANokGeIIW4tiLE/TeeagWbi
         K+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yEHOMcuhZdD8iiVryYSYsQQJvPICrzWTzhkdXbqbOh4=;
        b=y7NRw/JyHcv/vEdSaXeoThF5FJfWKzyn2TiANafympfQzstkUjJVtdl/a/yI36RBZW
         Pm/KMfpMVwMCEQ168aZece4ImUD7qdzu6Ztw6Q4udTygDxYJ4EyNgDkasOzOW7sc8F/o
         PSr1BCTxhzHd9cr/VEQtcIO8YCY7skcUfOLOsncLoBH4K8a+SCZ914AkxOBWiCWQEZZV
         IFpIuqUCTgAgREOXyvA0n5veWxn8gEJHmdVUh2IE5ZI+0c59w1acYRdHG/ZswKdrAxkm
         KU+ksoo4g0m0fTpE4lw56TA9vqz4OmssOAOv6kb4RAv1XGxdVRkhzHVg+WMyJwi7AUwj
         /fQQ==
X-Gm-Message-State: AOAM530uu8gBS1bJGlNVjSvgjHzg2vX241AYHPkDxKY1/6RhEyX7mtDL
        L4adJlRLDnEHhSfQ8mrvTjo=
X-Google-Smtp-Source: ABdhPJxktlUW+KP6G/s7o+RKbaEpK2t+eFGt0AQo9Buyj9Kw3iqH3RtqwEM0hoyWgp102NXkAmi8bg==
X-Received: by 2002:a17:906:3ce9:b0:6ef:a8aa:ab46 with SMTP id d9-20020a1709063ce900b006efa8aaab46mr26563882ejh.579.1651758919171;
        Thu, 05 May 2022 06:55:19 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id e15-20020a50e44f000000b0042617ba63c7sm877949edm.81.2022.05.05.06.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:55:18 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, ansuelsmth@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH RESEND 0/5] dt-bindings: support Ethernet devices as LED triggers
Date:   Thu,  5 May 2022 15:55:07 +0200
Message-Id: <20220505135512.3486-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Some LEDs are designed to represent a state of another device. That may
be USB port, Ethernet interface, CPU, hard drive and more.

We already have support for LEDs that are designed to indicate USB port
(e.g. light on when USB device gets connected). There is DT binding for
that and Linux implementation in USB trigger.

This patchset adds support for describing LEDs that should react to
Ethernet interface status. That is commonly used in routers. They often
have LED to display state and activity of selected physical port. It's
also common to have multiple LEDs, each reacting to a specific link
speed.

Patch 5/5 is proof of concept and is not meant to be applied yet.

Rafał Miłecki (5):
  dt-bindings: net: add bitfield defines for Ethernet speeds
  dt-bindings: net: allow Ethernet devices as LED triggers
  dt-bindings: leds: add Ethernet triggered LEDs to example
  ARM: dts: BCM5301X: Add triggers for Luxul XWR-1200 network LEDs
  leds: trigger: netdev: support DT "trigger-sources" property

 .../devicetree/bindings/leds/common.yaml      | 21 +++++++++++++++
 .../bindings/net/ethernet-controller.yaml     |  3 +++
 arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts | 22 +++++++++++----
 drivers/leds/trigger/ledtrig-netdev.c         | 26 ++++++++++++++++++
 include/dt-bindings/net/eth.h                 | 27 +++++++++++++++++++
 5 files changed, 94 insertions(+), 5 deletions(-)
 create mode 100644 include/dt-bindings/net/eth.h

-- 
2.34.1

