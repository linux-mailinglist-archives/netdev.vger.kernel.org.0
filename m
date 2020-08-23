Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD48F24ED5E
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 15:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgHWNxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 09:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbgHWNxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 09:53:10 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E91C061573;
        Sun, 23 Aug 2020 06:53:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u128so3432803pfb.6;
        Sun, 23 Aug 2020 06:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sD1FQMMwZynoPD77mgKlAipOywDFOvrgKbtU1x4LJuM=;
        b=qehOR7paicgWwy8oVrx6Nuwi91rx7RoN/PjXp7l/5c2jfA5zuQ2AffnvmTxmM1gO83
         0jJ2YyJQJFphB61jAGK4SrjOiwN13ketztc9uabhakRxVR6DsmgZbWnWVQfDnUShZKdb
         s7ibsOiC7zb8UPMYiWZ1T/2oeZ3ULNs/5df6hDXPF2MxxknTEGAm6I7V0XdY6+d9R2Yv
         qM0JT81PCG7nTU5lO8TbINEzfE6/2NaWdI3I68xYTkMq7kl4No3Eyxh2sYrNxA5TftZ/
         rzDP+IGLDikBccuT0C4Slrip4m8QpUCvJyHhJ+Nkf63QlbrnhGu6SiavRM/Uo0kQrrv5
         1w2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sD1FQMMwZynoPD77mgKlAipOywDFOvrgKbtU1x4LJuM=;
        b=OXTEuF068r2xvTd0obcg6Or0Ft67S4Yua1GezOnBbw4P+J9/BVVPDbKeghKlZWUSl8
         +CoNsByaPz/7xt5GaI1r8fL4czi90/KkLQ+qBM+PU5FBtTLT2Muo3ZHyUKVIAmqwz7w9
         Q/3fZIt3ShcEcBmO52G78su6iG8pYJpAqivCUzq7CJa6WBlCl+KIMoBbG6VELylbsH9w
         Vqs0fIvc82WrJR6qhapGps56ZJHuVvvDupEpg2zzhFPrwSKLkqebR/UDJkBtPk3H76gI
         mvdg5AQSmeFtC7GDmLnmuY899qJoOjjVaWq0dqV3/XW12DnGDF5tsWhuJZEipAjQirns
         xlzA==
X-Gm-Message-State: AOAM533Bq5c13VqzNdqXPgpOCDKOg0TH6jKeTOmQJpdBdP0WiXdT0gsR
        WDm17Kth3NqFXop2RXkwKjE=
X-Google-Smtp-Source: ABdhPJyoeZ93KPgG7c2a8bNJlooBliJLcBchiA0RzJl36SFRKNSucU2lev9NNPQZbm+p+MI5xPGh8g==
X-Received: by 2002:a62:1803:: with SMTP id 3mr1079040pfy.198.1598190788902;
        Sun, 23 Aug 2020 06:53:08 -0700 (PDT)
Received: from localhost.localdomain ([49.207.210.11])
        by smtp.gmail.com with ESMTPSA id q5sm1290809pfu.16.2020.08.23.06.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 06:53:08 -0700 (PDT)
From:   Sumera Priyadarsini <sylphrenadin@gmail.com>
To:     davem@davemloft.net
Cc:     Julia.Lawall@lip6.fr, UNGLinuxDriver@microchip.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sumera Priyadarsini <sylphrenadin@gmail.com>
Subject: [PATCH] net: ocelot: Add of_node_put() before return statement
Date:   Sun, 23 Aug 2020 19:22:45 +0530
Message-Id: <20200823135245.5857-1-sylphrenadin@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Every iteration of for_each_available_child_of_node() decrements
the reference count of the previous node, however when control
is transferred from the middle of the loop, as in the case of
a return or break or goto, there is no decrement thus ultimately
resulting in a memory leak.

Fix a potential memory leak in felix.c by inserting of_node_put()
before the return statement.

Issue found with Coccinelle.

Signed-off-by: Sumera Priyadarsini <sylphrenadin@gmail.com>
---
 drivers/net/dsa/ocelot/felix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index c69d9592a2b7..04bfa6e465ff 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -400,6 +400,7 @@ static int felix_parse_ports_node(struct felix *felix,
 		if (err < 0) {
 			dev_err(dev, "Unsupported PHY mode %s on port %d\n",
 				phy_modes(phy_mode), port);
+			of_node_put(child);
 			return err;
 		}
 
-- 
2.17.1

