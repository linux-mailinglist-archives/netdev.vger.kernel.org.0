Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035C34FE572
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347035AbiDLP6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357464AbiDLP6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:58:02 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E3E26139
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 08:55:37 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bg10so38237763ejb.4
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 08:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R41hcNskYvCznNDmOyxQUN5KldJzQl0F7yh3jWVjHMg=;
        b=nM/Cqb83xekaaMw+WCaocT6vW9NU9dez6JLdVXMOsiig3P2zQkG/QAiqrUf1Wv1rMX
         dTpfdKVFsSoRifIR/ubBGHmvVbIglUJnv55DxQnpLCJ8Pd7RaQAfzN6/N579TboBOFXC
         YankKB127eLO/nKoV8GAsEVzIQoe32h+hFW98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R41hcNskYvCznNDmOyxQUN5KldJzQl0F7yh3jWVjHMg=;
        b=BRjCm5LnD8j9beYJrarfeR7xmuuLocNYOIY8YF4WVSkgYfZIoB8f5O+4Tc2LWYhkPX
         1LvZRXRuK/p2pi4Nt2zpt1pEEinfKVPbiTmAq7/DhmEQkJ+eWYFSSfcUIQ8KeMd043lk
         3q4jidy1y4ypvwEphtDlAZaeE8Yz6T6rJwo+ySTMuh46XMlAU+BTHrqz+CQOA+6hIDPa
         GWnxeaOxro4Fg1t2q2zQhnThzsnylswLEZlA07ec3B+zxzR2BXUkBB+/0DxQrAg/Z9eE
         RM9s++yHwzMez78hCLe/I4z/6rv421qPtho6f9pqVPWRwVC15Xj8YB/rncPsBTM6HK0a
         574A==
X-Gm-Message-State: AOAM533llDddb9VimySjMDYqG93vbC5o8v/Rc6DARTCegtEKda0S3CoB
        pf4j8Bbj2N8OyxduE4BuU4CmEA==
X-Google-Smtp-Source: ABdhPJxIUWG9bOo8PxIdZSIbsvvUVdLtTbwRKK0JGOPVVgnNsu4G5KJyzmPQDVmYsrPKQKk8aeebAg==
X-Received: by 2002:a17:906:730c:b0:6e6:c512:49c8 with SMTP id di12-20020a170906730c00b006e6c51249c8mr35471265ejc.405.1649778936500;
        Tue, 12 Apr 2022 08:55:36 -0700 (PDT)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id jl28-20020a17090775dc00b006e05cdf3a95sm13354161ejc.163.2022.04.12.08.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 08:55:35 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: dsa: realtek: fix Kconfig to assure consistent driver linkage
Date:   Tue, 12 Apr 2022 17:55:27 +0200
Message-Id: <20220412155527.1824118-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

The kernel test robot reported a build failure:

or1k-linux-ld: drivers/net/dsa/realtek/realtek-smi.o:(.rodata+0x16c): undefined reference to `rtl8366rb_variant'

... with the following build configuration:

CONFIG_NET_DSA_REALTEK=y
CONFIG_NET_DSA_REALTEK_SMI=y
CONFIG_NET_DSA_REALTEK_RTL8365MB=y
CONFIG_NET_DSA_REALTEK_RTL8366RB=m

The problem here is that the realtek-smi interface driver gets built-in,
while the rtl8366rb switch subdriver gets built as a module, hence the
symbol rtl8366rb_variant is not reachable when defining the OF device
table in the interface driver.

The Kconfig dependencies don't help in this scenario because they just
say that the subdriver(s) depend on at least one interface driver. In
fact, the subdrivers don't depend on the interface drivers at all, and
can even be built even in their absence. Somewhat strangely, the
interface drivers can also be built in the absence of any subdriver,
BUT, if a subdriver IS enabled, then it must be reachable according to
the linkage of the interface driver: effectively what the IS_REACHABLE()
macro achieves. If it is not reachable, the above kind of linker error
will be observed.

Rather than papering over the above build error by simply using
IS_REACHABLE(), we can do a little better and admit that it is actually
the interface drivers that have a dependency on the subdrivers. So this
patch does exactly that. Specifically, we ensure that:

1. The interface drivers' Kconfig symbols must have a value no greater
   than the value of any subdriver Kconfig symbols.

2. The subdrivers should by default enable both interface drivers, since
   most users probably want at least one of them; those interface
   drivers can be explicitly disabled however.

What this doesn't do is prevent a user from building only a subdriver,
without any interface driver. To that end, add an additional line of
help in the menu to guide users in the right direction.

Link: https://lore.kernel.org/all/202204110757.XIafvVnj-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Fixes: aac94001067d ("net: dsa: realtek: add new mdio interface for drivers")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---

Note that the Fixes: tag could arguably go back to: 

765c39a4fafe ("net: dsa: realtek: convert subdrivers into modules")

... but this would not help the stable branches, since the following
commit (which is the chosen point of my Fixes: tag) changes things a
lot. I will have to send a separate backport for stable.

---
 drivers/net/dsa/realtek/Kconfig | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index 1aa79735355f..060165a85fb7 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -9,34 +9,46 @@ menuconfig NET_DSA_REALTEK
 	help
 	  Select to enable support for Realtek Ethernet switch chips.
 
+	  Note that at least one interface driver must be enabled for the
+	  subdrivers to be loaded. Moreover, an interface driver cannot achieve
+	  anything without at least one subdriver enabled.
+
+if NET_DSA_REALTEK
+
 config NET_DSA_REALTEK_MDIO
-	tristate "Realtek MDIO connected switch driver"
-	depends on NET_DSA_REALTEK
+	tristate "Realtek MDIO interface driver"
 	depends on OF
+	depends on NET_DSA_REALTEK_RTL8365MB || NET_DSA_REALTEK_RTL8366RB
+	depends on NET_DSA_REALTEK_RTL8365MB || !NET_DSA_REALTEK_RTL8365MB
+	depends on NET_DSA_REALTEK_RTL8366RB || !NET_DSA_REALTEK_RTL8366RB
 	help
 	  Select to enable support for registering switches configured
 	  through MDIO.
 
 config NET_DSA_REALTEK_SMI
-	tristate "Realtek SMI connected switch driver"
-	depends on NET_DSA_REALTEK
+	tristate "Realtek SMI interface driver"
 	depends on OF
+	depends on NET_DSA_REALTEK_RTL8365MB || NET_DSA_REALTEK_RTL8366RB
+	depends on NET_DSA_REALTEK_RTL8365MB || !NET_DSA_REALTEK_RTL8365MB
+	depends on NET_DSA_REALTEK_RTL8366RB || !NET_DSA_REALTEK_RTL8366RB
 	help
 	  Select to enable support for registering switches connected
 	  through SMI.
 
 config NET_DSA_REALTEK_RTL8365MB
 	tristate "Realtek RTL8365MB switch subdriver"
-	depends on NET_DSA_REALTEK
-	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
+	imply NET_DSA_REALTEK_SMI
+	imply NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL8_4
 	help
 	  Select to enable support for Realtek RTL8365MB-VC and RTL8367S.
 
 config NET_DSA_REALTEK_RTL8366RB
 	tristate "Realtek RTL8366RB switch subdriver"
-	depends on NET_DSA_REALTEK
-	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
+	imply NET_DSA_REALTEK_SMI
+	imply NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL4_A
 	help
-	  Select to enable support for Realtek RTL8366RB
+	  Select to enable support for Realtek RTL8366RB.
+
+endif
-- 
2.35.1

