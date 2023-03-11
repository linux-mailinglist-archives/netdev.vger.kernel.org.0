Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043096B6093
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 21:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjCKUhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 15:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCKUhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 15:37:50 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7EC5DC84;
        Sat, 11 Mar 2023 12:37:49 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id bw19so7997030wrb.13;
        Sat, 11 Mar 2023 12:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678567068;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+0kS7aVJWn2QRxzhK3/aqBqmHgTgSZuYdBYMBRoKq/8=;
        b=Qm6k/ImzwAlyuiPoeFuH3k0SUoxzoxnjGF9VQuItbR0sfiqm/2awfdOdhvX9Eb1KG6
         9uJY68wqVjwxoVDKI0J1Wp74etF2pmcWaNCKjAD2nHTtnbUk/E1GV9Cf7HOd1ZoYFjLp
         97UwV0+A6pb6YPzQ92Ax9zk1RlBoXRAkhNqt9E42ZU/vwgjwXe3zfQI4LsI8cY/7LFf5
         R5snYkexAuB8tGNxgD/D0HMQtfn218tJL7j+zqQdpCBs1sF2EL1Sne5cIHoEey0Ih6Eu
         ZiKnwtD1XDf1szsy7cYWjXUZq+QGE749aczcdYZ671yRtmoRDB4wDWfPTKfQvOOYqua1
         XbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678567068;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+0kS7aVJWn2QRxzhK3/aqBqmHgTgSZuYdBYMBRoKq/8=;
        b=RbJraohICM7niT1Nr0BemUwxs4B+IGYv+pqwRIb2hHRWLfjqtUPKVMF4Tw2F9WNTiG
         Yb4ko6YyhAyRT6kD6uQvY89wNTVoTJ7kdt+mf1d/hO1fEBTpqzLYSE+qCZpeWWbeEP1+
         GpU3u/ZizPAymGS2y02t6gEn6nOrH3+jCZly9LgKJ+lvRfcnWOpc1JIiPgKYYwJT8Mp8
         6GflvrZWRwjEMx3MgAQHOC1DnZlkcwfi/EhT1XOWnUwUCDkqOZIrY9UsdypvBEUQFhXz
         2xS25Y3SacNHZy1BCM14WBXI782uO4zmQhSbnNQN/l3sQfq3cLG6s6ulkRSqqvEpj0YC
         Tw7A==
X-Gm-Message-State: AO0yUKUtGoExYE1UCjZWax5v5qA9wENrrAIIsJ0DFhF0nxpPAiYzM/ov
        /7NRb5IBe8cLe7Xtd+PKZRs=
X-Google-Smtp-Source: AK7set998zBaWk9BpBD6UqWjkC4AP/SpwMf7Z9hn7bpKjBWbP0akzJJnVjysT7bvrTQpVYtMG68K5w==
X-Received: by 2002:adf:e60b:0:b0:2ca:9950:718 with SMTP id p11-20020adfe60b000000b002ca99500718mr20262213wrm.52.1678567067886;
        Sat, 11 Mar 2023 12:37:47 -0800 (PST)
Received: from mars.. ([2a02:168:6806:0:cb1:a328:ee29:2bd6])
        by smtp.gmail.com with ESMTPSA id x6-20020adff646000000b002c5694aef92sm3257615wrp.21.2023.03.11.12.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 12:37:47 -0800 (PST)
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
Date:   Sat, 11 Mar 2023 21:37:36 +0100
Message-Id: <20230311203736.156664-1-klaus.kudielka@gmail.com>
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

