Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D706B6086
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 21:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjCKUcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 15:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjCKUcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 15:32:22 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAC46E6A2;
        Sat, 11 Mar 2023 12:32:20 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id f11so7998741wrv.8;
        Sat, 11 Mar 2023 12:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678566739;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=68SOf0uLJuHjIMu1OsjsJ4D0I1tz4+lC1OJ1oPaWRu0=;
        b=gTzP74pGi+v8bjINEolo9wKKKDz8UZGVBUmlmlB/P3xpFP4JtWqQ5yCtvKfqT/K9wv
         wO4rdprJ0WxtPUYP9Cf8IOExDAH8oOYNEhDH8lXbzyxAkOYuzIjkUkzP9AUIm1hh0GTt
         yJsmJV9dLkzU+KWK/9mQJqG4zYyniFqIC08/wDcUf5n6lmCHdYJUPHqBEhGDntYYUFRO
         Z+elmqqdCxZE2RgNUnlfjo+4lLttP8yYpgJL3lBGA7Xb4rOWwUy14/k9tS0PJgfPYqYo
         gxzq6WIPMTbjasCS3CbeI9hgRlasv+pMroW62Sux+6S2j8s7VIJyyjRg8Lea9b65wUbd
         xpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678566739;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=68SOf0uLJuHjIMu1OsjsJ4D0I1tz4+lC1OJ1oPaWRu0=;
        b=HLVgcDsBwaBY/2n6tpc9Q/rnw4ezwyA5Sjus8IkapWPYuaCRZnGkVAIjO7WV2eAJj0
         TgOwNGFBCRCzm8A/UVL0BfzTbisgbI0AzaTT8NhvNHkWXJgf4Fk2nB5WDYCrXrGmQsDX
         /WbqAnG0bjSk3yzhdA2+VeO23tyuPJEo6SYBZAThDqMBxwsDk2SUUiXmJOlshSzawzai
         SLIuA64gXjHefl3PK5bTRbu2UwTVywR/iA4Skl3uXDH4kD565x+5/wRqmwuDnKItMZBH
         2ro0+IMQtO4d6gxAi/GVNALJNhjT6u+4R+SK5wU/o9dWD9LF9cjFqS/N2fLF7O4ugDC6
         0XLg==
X-Gm-Message-State: AO0yUKUw3Pr8jrMOxFeLz9p4K68qoGeEX8ThPkknZmmFJiJJhXfGvxAe
        U2e/p1MoLiRoUbmgdRUswew=
X-Google-Smtp-Source: AK7set8WKxnjxI0kyuJomCuyV7+EVlCMTGJj92DOj7Sepntvi/Re0o1ott42cHMOqdY2OQeM9gAS8Q==
X-Received: by 2002:a5d:4566:0:b0:2c7:dec:77a8 with SMTP id a6-20020a5d4566000000b002c70dec77a8mr18412706wrc.57.1678566738671;
        Sat, 11 Mar 2023 12:32:18 -0800 (PST)
Received: from mars.. ([2a02:168:6806:0:cb1:a328:ee29:2bd6])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c451100b003dc434b39c7sm4524319wmo.0.2023.03.11.12.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 12:32:18 -0800 (PST)
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Klaus Kudielka <klaus.kudielka@gmail.com>
Subject: [PATCH net-next v2 0/3] net: dsa: mv88e6xxx: accelerate C45 scan
Date:   Sat, 11 Mar 2023 21:31:29 +0100
Message-Id: <20230311203132.156467-1-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with commit 1a136ca2e089 ("net: mdio: scan bus based on bus
capabilities for C22 and C45"), mdiobus_scan_bus_c45() is being called on
buses with MDIOBUS_NO_CAP. On a Turris Omnia (Armada 385, 88E6176 switch),
this causes a significant increase of boot time, from 1.6 seconds, to 6.3
seconds. The boot time stated here is until start of /init.

Further testing revealed that the C45 scan is indeed expensive (around
2.7 seconds, due to a huge number of bus transactions), and called twice.

Two things were suggested:
(1) to move the expensive call of mv88e6xxx_mdios_register() from
    mv88e6xxx_probe() to mv88e6xxx_setup().
(2) to mask apparently non-existing phys during probing.

With those two changes, boot time on the Turris Omnia is back to normal.

Patch #1 is preparatory code movement, without functional change.
The remaining two patches implement the suggestions above.

Link: https://lore.kernel.org/lkml/449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com/

Changes in v2:
Add cover letter
Extend the cleanup in mv88e6xxx_setup() to remove the mdio bus on failure 
Add separate patch for phy masking

Klaus Kudielka (3):
  net: dsa: mv88e6xxx: re-order functions
  net: dsa: mv88e6xxx: move call to mv88e6xxx_mdios_register()
  net: dsa: mv88e6xxx: mask apparently non-existing phys during probing

 drivers/net/dsa/mv88e6xxx/chip.c | 381 ++++++++++++++++---------------
 1 file changed, 192 insertions(+), 189 deletions(-)

-- 
2.39.2

