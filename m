Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC48511E8D
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241977AbiD0QMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242238AbiD0QL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:11:56 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A41457F8C;
        Wed, 27 Apr 2022 09:08:09 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id r13so4369376ejd.5;
        Wed, 27 Apr 2022 09:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3BKs+pBPEYltsCMoPwYgKcbwLFhDzC1Y/+CPLcIFxmM=;
        b=Q4jfMoI5WjWw4XYAaHu1x0te1gTTF/pJ9bwG1D3UmYTwPFRaYgjLLsbmhuhk/XZNFJ
         Gs8uOU1t7JXsV/V7/4dDaMLIhUoBV2frgHYjQ5lQbEgd8FcSvsvHoouafbjEK3TIVsMj
         +NVquu65opHryDgmkWpdBebfRUbtAI3oNqkDQInrMxRltVtO7H8w/6m0ySGIBVj+XaV7
         a34xA7mMrfDVCwe1yMmIpA+jykOeQCZnIKzI15T9Z0JVYEBPoZg+21P5Xw7GptsP4b/I
         PW0wcWSCPNMFhaU0An6yw00SZb7MHVda9Lrhtc6dbDnC/2USs2JWfJpTjLx3K14+psKU
         5rcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3BKs+pBPEYltsCMoPwYgKcbwLFhDzC1Y/+CPLcIFxmM=;
        b=mEXBXimI2bL/MiZCWYvRIV1jhC2rtawToDfmVttIin2qv+iMcHbN/xzwCT1MuxzU4Z
         l7FCU6RjJp1IzsqQqox3r+6wzVujRGu5PST1GU1SDMVhsprVTB9QErAdTpSt8/Sr3hA7
         K45LGxW9zuWvQ48Rm6IIV+/tQXCbHGjXvAu/fYDajx7Ml2SjSD4OG3KxWepiBUaiDZkP
         pa28MFFpODKmtERzitnP8+ilKIGF4bjyErWCOw1zGvr0wIM2RkATmGQXPYhShpnR0+0+
         3tb+2QcSf5JOClAqhiugyxqsWvJYzXVB/8AcrvCSmQGZc67hIFbDDkHoYFd/zMPaEnUO
         NZyA==
X-Gm-Message-State: AOAM531JttBt6fMWSbbMhUJxZywTW43XXFce0Kvv2eZMNS3KkHK+nUIs
        +/mYjPGiFGpbBLDBpvyG1ZU=
X-Google-Smtp-Source: ABdhPJxeQHxPbZdIJ6XcQd2QkZ7X9v6YaYy7SDbsVYwTBp0P8/o+DdHREpRXEGzvpSxDNi7/SjRi0Q==
X-Received: by 2002:a17:907:2d24:b0:6f3:91fd:db8f with SMTP id gs36-20020a1709072d2400b006f391fddb8fmr16274815ejc.150.1651075642191;
        Wed, 27 Apr 2022 09:07:22 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:21 -0700 (PDT)
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
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v5 06/18] net: dsa: mv88e6xxx: refactor mv88e6xxx_port_vlan()
Date:   Wed, 27 Apr 2022 18:06:23 +0200
Message-Id: <20220427160635.420492-7-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220427160635.420492-1-jakobkoschel@gmail.com>
References: <20220427160635.420492-1-jakobkoschel@gmail.com>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

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

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

