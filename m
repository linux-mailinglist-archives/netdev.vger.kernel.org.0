Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E73F4FDEF7
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346608AbiDLMFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351520AbiDLMCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:40 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0929A7A9BE;
        Tue, 12 Apr 2022 03:59:01 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id p15so36531187ejc.7;
        Tue, 12 Apr 2022 03:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6t7Nl01e4cvCsyopQipowOOZNCNPO7CspXlgqSRJfN8=;
        b=eSGSjXghlomi9azQlGr8ioc93WtOY0TuT/i6asBU/eQ+Q1w2HuQr9Vbj0Lv+K2Uwd6
         lXdCp6Vbsjqb5Tp7v0fWY/1qyy/i8g8zwSwikdYrSgIRB7uQP9o+u+3aqohN3d5QBPnP
         O4mRo1gAyGu1nbzgZwnvP9EAz/wI6yc3NzZ4bclnifBH7zuHLKkaqhGX1U63ThGSZauP
         WZ+sMhbur0UIkqVmNVJeRpye8a4Q3jZgiinMGQQxTzyF3nF8Mw+K59r+DiRp3aQNsYpa
         DdIpdyl4Ejhf0ewOKioasVXY5lbD/Pnm2HFjg4mbFodfu/4l26vi13SEfg+nBtyg/yVz
         7lbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6t7Nl01e4cvCsyopQipowOOZNCNPO7CspXlgqSRJfN8=;
        b=oclKrK7c9HqaJaaBfF1Nj7Kg4mgNicC2XkPLZnOZQSV3BE4cPRJ9wQs/PSrqrQMZyw
         Jee/cIpRElrGBK0ozSSDrYGlrW9SVl+IdCLOtHQ2GtndiFAClajKTgecYq2ndJhxQKwa
         ZuT4auf/+F8ps2C7ZPsIZp49efoEiRR9W+wNI0yuvEBCtByj6536b7JMKRyQ7+fP+1cy
         RvnH7O8yqoT/ZbXHlf25YrRMNBfk1ABDwV+61v1AyLj0SdBz8+Q0YHACCVD+2aR74LTA
         JD3KUxvIzJwrMFGJnTYGQWtuRK9GpAwZ6NIL1YeFAZed8iNVMslYc+pKUu8aPPE02YPz
         UCcQ==
X-Gm-Message-State: AOAM530LE6k7PJAciSwWr+2FuEs6FU1NJPYSgtVuo/i7J/rB3d5fCuDb
        NMcmgurfsz1E6b3nFVHWMAo=
X-Google-Smtp-Source: ABdhPJwVYANoguUGdZzhpnrpdU22VVN93loOJ+LRG4RlNJ4J6OzE+BXNUMPf7L3VgsdYHMP9/kOrsw==
X-Received: by 2002:a17:907:72c3:b0:6e8:a265:4232 with SMTP id du3-20020a17090772c300b006e8a2654232mr5352112ejc.86.1649761139587;
        Tue, 12 Apr 2022 03:58:59 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm16986370edz.35.2022.04.12.03.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:58:59 -0700 (PDT)
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
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v2 06/18] net: dsa: mv88e6xxx: refactor mv88e6xxx_port_vlan()
Date:   Tue, 12 Apr 2022 12:58:18 +0200
Message-Id: <20220412105830.3495846-7-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412105830.3495846-1-jakobkoschel@gmail.com>
References: <20220412105830.3495846-1-jakobkoschel@gmail.com>
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

To avoid bugs and speculative execution exploits due to type-confused
pointers at the end of a list_for_each_entry() loop, one measure is to
restrict code to not use the iterator variable outside the loop block.

In the case of mv88e6xxx_port_vlan(), this isn't a problem, as we never
let the loops exit through "natural causes" anyway, by using a "found"
variable and then using the last "dp" iterator prior to the break, which
is a safe thing to do.

Nonetheless, with the expected new syntax, this pattern will no longer
be possible.

Profit off of the occasion and break the two port finding methods into
smaller sub-functions. Somehow, returning a copy of the iterator pointer
is still accepted.

This change makes it redundant to have a "bool found", since the "dp"
from mv88e6xxx_port_vlan() now holds NULL if we haven't found what we
were looking for.

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 54 ++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b3aa0e5bc842..1f35e89053e6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1378,42 +1378,50 @@ static int mv88e6xxx_set_mac_eee(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static struct dsa_port *mv88e6xxx_find_port(struct dsa_switch_tree *dst,
+					    int sw_index, int port)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->ds->index == sw_index && dp->index == port)
+			return dp;
+
+	return NULL;
+}
+
+static struct dsa_port *
+mv88e6xxx_find_port_by_bridge_num(struct dsa_switch_tree *dst,
+				  unsigned int bridge_num)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_bridge_num_get(dp) == bridge_num)
+			return dp;
+
+	return NULL;
+}
+
 /* Mask of the local ports allowed to receive frames from a given fabric port */
 static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 {
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_switch_tree *dst = ds->dst;
 	struct dsa_port *dp, *other_dp;
-	bool found = false;
 	u16 pvlan;
 
-	/* dev is a physical switch */
 	if (dev <= dst->last_switch) {
-		list_for_each_entry(dp, &dst->ports, list) {
-			if (dp->ds->index == dev && dp->index == port) {
-				/* dp might be a DSA link or a user port, so it
-				 * might or might not have a bridge.
-				 * Use the "found" variable for both cases.
-				 */
-				found = true;
-				break;
-			}
-		}
-	/* dev is a virtual bridge */
+		/* dev is a physical switch */
+		dp = mv88e6xxx_find_port(dst, dev, port);
 	} else {
-		list_for_each_entry(dp, &dst->ports, list) {
-			unsigned int bridge_num = dsa_port_bridge_num_get(dp);
-
-			if (bridge_num + dst->last_switch != dev)
-				continue;
-
-			found = true;
-			break;
-		}
+		/* dev is a virtual bridge */
+		dp = mv88e6xxx_find_port_by_bridge_num(dst,
+						       dev - dst->last_switch);
 	}
 
 	/* Prevent frames from unknown switch or virtual bridge */
-	if (!found)
+	if (!dp)
 		return 0;
 
 	/* Frames from DSA links and CPU ports can egress any local port */
-- 
2.25.1

