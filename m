Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025E14F7CCE
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244295AbiDGKdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244274AbiDGKdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:33:06 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CD07E0A4;
        Thu,  7 Apr 2022 03:31:06 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id k23so9902269ejd.3;
        Thu, 07 Apr 2022 03:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jhyzYWxSgWQ5UdJQbW741q+z9oGhpyCDqsCBhTcqlFE=;
        b=G3UZPomec6PoLWQr0bjC3OjAkRdJzUbc8hdH4J8L5rIZWtj65qOF0I5tw+uanOORtq
         M/QkTiV8pUSGlmzmp3/T/8gXv4ofkAQnbHHfbVNRR80ErhX14WWqa3zHwK6oMOxaABA8
         CXvz7W5DwipofPsajlF9nWVUSWrZjvu2UGyC4GTd4GfBrnoV8i8WJqIrUnF91eME18Z/
         li2jILa4O1yDRJp1q8IwWm+ClS9QJrbNBiMVn8sUaKRITd/xWXx5L1fpnf6pQ4bjpDdY
         rP5sGgqicELTA+FXuNOs5iiAGlujjTdxO4aWIpC80IYh7qHhgKXFKn0qVqddkhh09Sn1
         kTVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jhyzYWxSgWQ5UdJQbW741q+z9oGhpyCDqsCBhTcqlFE=;
        b=ib6Z+bTCGYkXwQoOlygGZb2dBkLvuX358EWNgFaSULWpUaw8Rrr67ThDNbf1A+VoT6
         ZILZcj3DYyxBrzUpjRVYwwRezi1s8A/f1XbMD0oBqn9YhlEDw/EyFvWPoiUQhOf1TSto
         if+HGdjYRZH0gFcPkB7dIKtnJw6FU5og676wvzO/HWt6BRGvbugegFlBLrNd9o6f4E7D
         wAJ/qppyy6ehgaViHUP4ICQwJUCu/3l7ZmNtopEBVnK+5y2VPIFDOrZTb5bZq7WBgBjW
         vepOC3tdcxxiDGLkEzp0T6cgHEGjq3KuvuDQ83xaHbIrvKm3LGRVKSDUjwcgJf+Rvwly
         WC2A==
X-Gm-Message-State: AOAM530hViGuA6tdEZ3OS5lKT8wPPWE+9MTtED/TyQHt0ufuFYUCoMz7
        AUuVSwYWjEbba/abqjCMxCg=
X-Google-Smtp-Source: ABdhPJyE7I0SFQsOWGAsoCOLM9ViYaVOBqxCDbFEkgAjLcx6OMRDiQC9PRBkCRmOmfperDK8wZQAYg==
X-Received: by 2002:a17:906:8301:b0:6e4:896d:59b1 with SMTP id j1-20020a170906830100b006e4896d59b1mr12370590ejx.396.1649327464586;
        Thu, 07 Apr 2022 03:31:04 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm7413573ejz.57.2022.04.07.03.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 03:31:04 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next 03/15] net: dsa: mv88e6xxx: Replace usage of found with dedicated iterator
Date:   Thu,  7 Apr 2022 12:28:48 +0200
Message-Id: <20220407102900.3086255-4-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407102900.3086255-1-jakobkoschel@gmail.com>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 64f4fdd02902..f254f537c357 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1381,28 +1381,27 @@ static int mv88e6xxx_set_mac_eee(struct dsa_switch *ds, int port,
 /* Mask of the local ports allowed to receive frames from a given fabric port */
 static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 {
+	struct dsa_port *dp = NULL, *iter, *other_dp;
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_switch_tree *dst = ds->dst;
-	struct dsa_port *dp, *other_dp;
-	bool found = false;
 	u16 pvlan;
 
 	/* dev is a physical switch */
 	if (dev <= dst->last_switch) {
-		list_for_each_entry(dp, &dst->ports, list) {
-			if (dp->ds->index == dev && dp->index == port) {
-				/* dp might be a DSA link or a user port, so it
+		list_for_each_entry(iter, &dst->ports, list) {
+			if (iter->ds->index == dev && iter->index == port) {
+				/* iter might be a DSA link or a user port, so it
 				 * might or might not have a bridge.
-				 * Use the "found" variable for both cases.
+				 * Set the "dp" variable for both cases.
 				 */
-				found = true;
+				dp = iter;
 				break;
 			}
 		}
 	/* dev is a virtual bridge */
 	} else {
-		list_for_each_entry(dp, &dst->ports, list) {
-			unsigned int bridge_num = dsa_port_bridge_num_get(dp);
+		list_for_each_entry(iter, &dst->ports, list) {
+			unsigned int bridge_num = dsa_port_bridge_num_get(iter);
 
 			if (!bridge_num)
 				continue;
@@ -1410,13 +1409,13 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 			if (bridge_num + dst->last_switch != dev)
 				continue;
 
-			found = true;
+			dp = iter;
 			break;
 		}
 	}
 
 	/* Prevent frames from unknown switch or virtual bridge */
-	if (!found)
+	if (!dp)
 		return 0;
 
 	/* Frames from DSA links and CPU ports can egress any local port */
-- 
2.25.1

