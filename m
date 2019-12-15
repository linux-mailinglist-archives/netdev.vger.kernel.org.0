Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D680011FBA6
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 23:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfLOWNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 17:13:09 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46247 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfLOWNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 17:13:09 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so4899923wrl.13
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 14:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Fg1vsAsuu7r+fiHBg9UoeGH5ICk21CnUpnQUQhW68qQ=;
        b=IPOFPNLkCPAycyrJNrpzQAoQfmOMMErrcMfWpVGvIWiCNOBqTIA+e/xxI7c+R4aZaW
         FsoTvseioKgPySSNsC6mLiNsDJCvODWTFvhk2gfX+vaZ/75vrgNpt9LIRCUq+03Wk23f
         cMmOcFmg/gqkWVfqUT16g53cqUh+9e0jZHnMh+mql7v4ijqBPERg5V9E9//Jk2ChkZWX
         0sgb75mTaXIEM0qIPtTs/nEu+4AGhFNYQ6OUeKeE2RjtCGgHwFgwQlYij906uLdNtQt+
         6CuQktaUDOIg7dExaBiv8578EARi6cGBiDVRHf6GixZb51UGNrbcs+lrfJ8K/DgdJjQW
         HXjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Fg1vsAsuu7r+fiHBg9UoeGH5ICk21CnUpnQUQhW68qQ=;
        b=UIWeQu+KgZ74h5MIhWF4DXS3TXhU1CLd4JZVFfZTKjicGmj3fDjhY+AsIhT5vk7YOv
         MCCG4vO/6E96sUnX5aS3aUe6AGlOF8CFGDAqUpUDbCUyqNNNwDUTQdhVRxV4nAVf2tyz
         iVSLr4p5dLBbv4io7OzQ2FCPHnIxt2EExapLjceS6aiGTVAVStt6HWakUYrt9XN2wdIZ
         Wr8aALB+vk2yFQZ8iAYHenyanm/MQNabm0msXcZlBxo+DDLvxMFgTEo4z3VeFzaz5oWy
         kGr+iAhZwOmPbL5JkTlhTPmSKOiTgoIB48DgcHhWJVycQwZGX0dC9gCFlY8uwdoEwr93
         CR0w==
X-Gm-Message-State: APjAAAVb/zoFIp10QdqKh6IfZ1oy6Dl9JmKcPGJQ+WFXUNJEzLerDhya
        LmqVVyqdBE1EF7x6rum2+J0=
X-Google-Smtp-Source: APXvYqwRSC28i1VINlSs2pBF0CQNFLnKrle0XFFMerNKZ4wVbvjsB77XFpN66fj10JcQN/wgqM8TKQ==
X-Received: by 2002:a05:6000:11c5:: with SMTP id i5mr25805068wrx.102.1576447987233;
        Sun, 15 Dec 2019 14:13:07 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id s10sm19228066wrw.12.2019.12.15.14.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 14:13:06 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     arnd@arndb.de, maowenan@huawei.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net v2] net: dsa: ocelot: add NET_VENDOR_MICROSEMI dependency
Date:   Mon, 16 Dec 2019 00:12:14 +0200
Message-Id: <20191215221214.15337-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Selecting MSCC_OCELOT_SWITCH is not possible when NET_VENDOR_MICROSEMI
is disabled:

WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
  Depends on [n]: NETDEVICES [=y] && ETHERNET [=n] && NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
  Selected by [m]:
  - NET_DSA_MSCC_FELIX [=m] && NETDEVICES [=y] && HAVE_NET_DSA [=y] && NET_DSA [=y] && PCI [=y]

Add a Kconfig dependency on NET_VENDOR_MICROSEMI, which also implies
CONFIG_NETDEVICES.

Depending on a vendor config violates menuconfig locality for the DSA
driver, but is the smallest compromise since all other solutions are
much more complicated (see [0]).

https://www.spinics.net/lists/netdev/msg618808.html

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
- Back to Arnd's and Mao's original proposal. The final straw to the
  much more complicated approach in the v1 linked above is the need to
  do this in drivers/net/ethernet/Makefile:

  -obj-$(CONFIG_NET_VENDOR_MICROSEMI) += mscc/
  +obj-y += mscc/

 drivers/net/dsa/ocelot/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 0031ca814346..6f9804093150 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -2,6 +2,7 @@
 config NET_DSA_MSCC_FELIX
 	tristate "Ocelot / Felix Ethernet switch support"
 	depends on NET_DSA && PCI
+	depends on NET_VENDOR_MICROSEMI
 	select MSCC_OCELOT_SWITCH
 	select NET_DSA_TAG_OCELOT
 	help
-- 
2.17.1

