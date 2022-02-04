Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31ADF4A9C90
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243386AbiBDP7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:59:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47784 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243078AbiBDP7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:59:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63841B8381C
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 15:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22DFC340E9;
        Fri,  4 Feb 2022 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643990369;
        bh=Of4E/0Jl+edk3fw1EEQV128+SiGRRSY3eruR43VLkHw=;
        h=From:To:Cc:Subject:Date:From;
        b=PfhR49kDK6MnWieEAbTeTkRNfFf6xcpqMQv8h4FcPEKxxGjT+b00dhB7h84JWXbXt
         q72ZO6whIU0u3YR8ZL9hZRtrkV/C9GnLHQDJHko4t5k8Q+mNbX86XviMz+motf7rGK
         E1ruLBzozXnAjrjlgIQeYKuXpFCku/Ojo/6G5pAfDOn6BZszoOUItlfaFhi5tIonit
         bI58TM3Dxs2gK4MYJjd7oF5KgAbPcs9eNePvKBWhOIh6zgn7cEGqMkxK1VuO6w1xxd
         zP5YKPe2uewQ5ye/B9U7056RAcia9T9Mp0hUEhI+x1uTZC1AxE0Z0F1S5QSGGOYREO
         DVFFWdbD1tgjg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: [PATCH net-next] net: dsa: realtek: don't default Kconfigs to y
Date:   Fri,  4 Feb 2022 07:59:27 -0800
Message-Id: <20220204155927.2393749-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We generally default the vendor to y and the drivers itself
to n. NET_DSA_REALTEK, however, selects a whole bunch of things,
so it's not a pure "vendor selection" knob. Let's default it all
to n.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Happy to drop this if someone has a better patch, e.g. making
NET_DSA_REALTEK a pure vendor knob!

CC: Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC: Arınç ÜNAL <arinc.unal@arinc9.com>
CC: linus.walleij@linaro.org
CC: andrew@lunn.ch
CC: vivien.didelot@gmail.com
CC: f.fainelli@gmail.com
CC: olteanv@gmail.com
---
 drivers/net/dsa/realtek/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index 5242698143d9..b7427a8292b2 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -12,7 +12,6 @@ menuconfig NET_DSA_REALTEK
 config NET_DSA_REALTEK_MDIO
 	tristate "Realtek MDIO connected switch driver"
 	depends on NET_DSA_REALTEK
-	default y
 	help
 	  Select to enable support for registering switches configured
 	  through MDIO.
@@ -20,14 +19,12 @@ config NET_DSA_REALTEK_MDIO
 config NET_DSA_REALTEK_SMI
 	tristate "Realtek SMI connected switch driver"
 	depends on NET_DSA_REALTEK
-	default y
 	help
 	  Select to enable support for registering switches connected
 	  through SMI.
 
 config NET_DSA_REALTEK_RTL8365MB
 	tristate "Realtek RTL8365MB switch subdriver"
-	default y
 	depends on NET_DSA_REALTEK
 	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL8_4
@@ -36,7 +33,6 @@ config NET_DSA_REALTEK_RTL8365MB
 
 config NET_DSA_REALTEK_RTL8366RB
 	tristate "Realtek RTL8366RB switch subdriver"
-	default y
 	depends on NET_DSA_REALTEK
 	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL4_A
-- 
2.34.1

