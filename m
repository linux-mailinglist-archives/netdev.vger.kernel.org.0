Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0646B608A
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 21:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjCKUc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 15:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjCKUcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 15:32:24 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317D26EBA2;
        Sat, 11 Mar 2023 12:32:22 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id p16so5520063wmq.5;
        Sat, 11 Mar 2023 12:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678566740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+0kS7aVJWn2QRxzhK3/aqBqmHgTgSZuYdBYMBRoKq/8=;
        b=Des4jwYTOyK0w+CSUeBjA8GQUVC6GH07szSLdPl5GmR3KoARotp2M+8bDrX7I0/BKw
         LrzUhIXhlFvyDFfzoOAnrScOyWP37jnULP621Y7hTSEmk38nb9/TpiDgbraLjJogMcy4
         iWpZgBLkLrk5pKfKTwY3WYLAIjJrRZm6xgTwlub7rhaPhvX4Hh+P8qYf+6z7OJNQaOUZ
         xgCE86nMh/sfO6b9VtfrNuuJaZCEMO/xXt7xr0ltz19EYZp3HS+n6gqmEl2mhgOxNDRu
         10rgnDv7NhBSZMm8MeSQNRrtqFgJ9IzplnXzEe0HmnzhK1roPqTaKGxdZ3AWBwo+1Z3F
         f2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678566740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+0kS7aVJWn2QRxzhK3/aqBqmHgTgSZuYdBYMBRoKq/8=;
        b=ZytGFteQ6mHyu5Y10Vavk/Kput9+5CLy4rbTR8dEmpPcbC8gs4O7cASqd4weARsY8B
         OZHvQvdkLqn0zHqcqLW+yhR/ZePobyzJA3h0GTN9bY8wj35rbC0Dv1tOYyEIaf7hEuH3
         p1k3R8OhW9zifhn97LjBqiVwaUiMTC9p6a49fZ3hUojzDjYCMw6uW4Q9WJjvl7NOrDjZ
         +efOtXBlvHKPCdTQ0skPzhA5SaI6PGphfakBp4qq3TPlcXy6mSAS+Wc8VzTS7ZPMH7Ez
         WX6WWWgqqqXpnpmw82rXN7MPUDOtjabS5C/5zHn0RzBzLh7tlZkP4/NR18J8YRMnQr0p
         dp1A==
X-Gm-Message-State: AO0yUKWrQgMQR5A/mr/FKESa3tULoZNufV+ZtbKWQULT1zckXkkYc3pZ
        Pq9eoyYnQTQlGiZ3tfZUjIY=
X-Google-Smtp-Source: AK7set9qnsniMJHBuh+hg9gSiuN6l0ykRvaspRnEDHdfjs2BjTyEkGLcdwA4iNN/mmZqxwol/rX0Kg==
X-Received: by 2002:a05:600c:4690:b0:3ea:f6c4:305e with SMTP id p16-20020a05600c469000b003eaf6c4305emr6746861wmo.38.1678566740639;
        Sat, 11 Mar 2023 12:32:20 -0800 (PST)
Received: from mars.. ([2a02:168:6806:0:cb1:a328:ee29:2bd6])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c451100b003dc434b39c7sm4524319wmo.0.2023.03.11.12.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 12:32:20 -0800 (PST)
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
Subject: [PATCH net-next v2 3/3] net: dsa: mv88e6xxx: mask apparently non-existing phys during probing
Date:   Sat, 11 Mar 2023 21:31:32 +0100
Message-Id: <20230311203132.156467-4-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230311203132.156467-1-klaus.kudielka@gmail.com>
References: <20230311203132.156467-1-klaus.kudielka@gmail.com>
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

To avoid excessive mdio bus transactions during probing, mask all phy
addresses that do not exist (there is a 1:1 mapping between switch port
number and phy address).

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
---
v2: Patch is new

 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 29b0f3bb1c..c52798d9ce 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3797,6 +3797,7 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 	bus->read_c45 = mv88e6xxx_mdio_read_c45;
 	bus->write_c45 = mv88e6xxx_mdio_write_c45;
 	bus->parent = chip->dev;
+	bus->phy_mask = GENMASK(31, mv88e6xxx_num_ports(chip));
 
 	if (!external) {
 		err = mv88e6xxx_g2_irq_mdio_setup(chip, bus);
-- 
2.39.2

