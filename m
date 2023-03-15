Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF176BBA04
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjCOQlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjCOQlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:41:03 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C184C26C0E;
        Wed, 15 Mar 2023 09:39:56 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id p4so11697810wre.11;
        Wed, 15 Mar 2023 09:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678898351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JvzcYRRHLaq6TI4TXBM15s0dsHxp7KPK7DQmexv8hRA=;
        b=Xite94GhXv3kLSRrGzXJ5DdDif4BrqHfX6eJmhR6GLLJZ+jzgqs7aSig39jOltzQHd
         E5aXPXPjiGyBCSgsBBweEuxrx8+Qulu1JniwhZ1kRlmnqoNhUQvKjDn/k0aUl5By1FKn
         +MZHhRarAoLAld8dX8PUA/ivi2WW6ghcj2BQDFgsw8tcWIza38wR9uHGvPE7tJ96fRQY
         Z1iL6KT7Dvrkxkn9VZxXo7qRztoxBmD0rxBvrq2sswkqO/dFsQkZLbtBbeZkHZ70ijN+
         R8e59CZ7hVSUHj3DAB8SUzLR4Huab4SS3ASBLp8PZtDIpK8vbAuMkcDpTEpLe5BTbtdv
         uygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678898351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JvzcYRRHLaq6TI4TXBM15s0dsHxp7KPK7DQmexv8hRA=;
        b=kmEta591CbrV947XJkYlSjL+jGucg7sXa2cBfUkOe39WnquaDuZELYmDZljQVRgVUc
         OD3u5yET5uRwZO+goErtnA7+IDo3axFR2NmS0ET5z96AoLzr07kJeJSu6WC/kvW0hdWq
         WKedtVa/+XHietlRKOsmcra+A7h7Go8JEm65Tmsu8HFHFsFvH+EslUW+IPnrz/p67Sv6
         V4qj3yO9zEy0I2xNSPhA0BAC4kB35A5lqmC1MWTacuSRr/2ip2TcACXQB7utQlFjBWML
         ANRvQy+668kWXCQ/MgFUwzg57hAAqErR/RqZ7wztQpYabxy7XsBhCKNaE7QuMmrU/YoH
         ZulA==
X-Gm-Message-State: AO0yUKXyVbjXldJRnyHYGB8EbXALnKZLQRsOwKG/lcD6Gl9bLb4mI4gx
        r6zS+Ve4lsnGo+ebNeBRtYcq4P2QNehlxw==
X-Google-Smtp-Source: AK7set8xLgjT4OYhFP6YhJC19O5aB+7XYvTAk6Fu4ry/in34yhOLtbKHJqaA487YQqYAAb4SFuv/SQ==
X-Received: by 2002:adf:de0a:0:b0:2c7:a9ec:3 with SMTP id b10-20020adfde0a000000b002c7a9ec0003mr2466682wrm.65.1678898351599;
        Wed, 15 Mar 2023 09:39:11 -0700 (PDT)
Received: from mars.. ([2a02:168:6806:0:839a:f879:3eb0:8b4e])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d4d11000000b002c5a1bd527dsm5039595wrt.96.2023.03.15.09.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 09:39:11 -0700 (PDT)
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
Subject: [PATCH net-next v4 0/4] net: dsa: mv88e6xxx: accelerate C45 scan
Date:   Wed, 15 Mar 2023 17:38:42 +0100
Message-Id: <20230315163846.3114-1-klaus.kudielka@gmail.com>
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

Before that:
Patch #1 prepares the driver to handle the movement of
mv88e6xxx_mdios_register() to mv88e6xxx_setup() for cross-chip DSA trees.
Patch #2 is preparatory code movement, without functional change.

With those changes, boot time on the Turris Omnia is back to normal.

Link: https://lore.kernel.org/lkml/449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com/

v2:
Add cover letter
Extend the cleanup in mv88e6xxx_setup() to remove the mdio bus on failure 
Add patch "mask apparently non-existing phys during probing"

v3:
Add patch "don't dispose of Global2 IRQ mappings from mdiobus code"

v4:
Resubmit, this time hopefully with all subject prefixes correct
 
Klaus Kudielka (3):
  net: dsa: mv88e6xxx: re-order functions
  net: dsa: mv88e6xxx: move call to mv88e6xxx_mdios_register()
  net: dsa: mv88e6xxx: mask apparently non-existing phys during probing

Vladimir Oltean (1):
  net: dsa: mv88e6xxx: don't dispose of Global2 IRQ mappings from
    mdiobus code

 drivers/net/dsa/mv88e6xxx/chip.c    | 381 ++++++++++++++--------------
 drivers/net/dsa/mv88e6xxx/global2.c |  20 +-
 2 files changed, 196 insertions(+), 205 deletions(-)

-- 
2.39.2

