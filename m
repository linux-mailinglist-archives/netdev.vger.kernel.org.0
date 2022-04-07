Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C734F7CCA
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244280AbiDGKdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237738AbiDGKdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:33:04 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E547852E4E;
        Thu,  7 Apr 2022 03:31:04 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id dr20so9835489ejc.6;
        Thu, 07 Apr 2022 03:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kT9lxrok+SOZ0lJZngMY/3t48p6ivac6h4GBagGgqlA=;
        b=A8dgIRU7XpwGn8L/TWG7eFAfHkVAzizRPgoC1D4gc2OIpAMDpQJiTRoz9/IZCjJOM9
         0s/42Xr99tqQ/JiR7ikZbfNGvGTjsSHBNU0AYR/pK/X2p6qv+xnvCz5faMoZxi90/IKT
         PNc0mh3GTFWBDQq/CMrWD0tfMR9PZS5MU6bXydxhfUYbVNe/A45xXvJgVLM0d4Ko+mBZ
         zEwllUgvuEavEaIEI448YgPIJ4PuwL86Fv8WZf4DJCkQAfkD6Ngv7DCP695sV2rZt6D+
         o3zzSLnoDfg2cEkyeyKGITs5rnEClHAm1GR6V9FxE6OPBIgGTU//ptm4fVdBqItJvn9G
         MWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kT9lxrok+SOZ0lJZngMY/3t48p6ivac6h4GBagGgqlA=;
        b=WO70yEgXh2sDXsnu8vavLQCAHJn4BxVBaz5BO1OnWvrfuXnw8QCXP7WMwdp/SHe6H+
         naqQzyGeIwksJ34SDjJiQ/Sk9oLZUHBnlB7lTYTaZynpq03F24ndDWSiGv5Yu5K41vlE
         /YwkcirJqqE+ZqMTsyT5imjDuy+qNlUcL0rvFDioKXY2ZICD3C2EJ4aFKtFQkypI+cCA
         R+5aTk0yHAc7dBiyp5jqO2ELM/SkJl20Z88FSswZn/QEBTaGORhBvIwGkMemCP1vaD4t
         p60m93QHKA3UrYvrx/qi1/SuzrVYM1FAS45qO8E15Khf9HQxmDT48c10qc98Rjnirawk
         U/cw==
X-Gm-Message-State: AOAM532tEqbYP3NzQBPVX0pWQ39RywogFlNV82+0J72waNnLyFhx+MQ4
        mOsSQTgrm6sZKJycBefRHxc=
X-Google-Smtp-Source: ABdhPJz1ozEcGcfvbMMbR7f3V/Sq2iRBo4hnJMmtYdRPitfh6Ug/fwJ4nnyfng/IyzCFUa3t6H3CwQ==
X-Received: by 2002:a17:906:4787:b0:6e1:409f:8deb with SMTP id cw7-20020a170906478700b006e1409f8debmr12629244ejc.80.1649327463446;
        Thu, 07 Apr 2022 03:31:03 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm7413573ejz.57.2022.04.07.03.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 03:31:03 -0700 (PDT)
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
Subject: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of iterator for list_add() after loop
Date:   Thu,  7 Apr 2022 12:28:47 +0200
Message-Id: <20220407102900.3086255-3-jakobkoschel@gmail.com>
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

In preparation to limit the scope of a list iterator to the list
traversal loop, use a dedicated pointer to point to the found element [1].

Before, the code implicitly used the head when no element was found
when using &pos->list. Since the new variable is only set if an
element was found, the list_add() is performed within the loop
and only done after the loop if it is done on the list head directly.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index b7e95d60a6e4..cfcae4d19eef 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -27,20 +27,24 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
 	if (list_empty(&gating_cfg->entries)) {
 		list_add(&e->list, &gating_cfg->entries);
 	} else {
-		struct sja1105_gate_entry *p;
+		struct sja1105_gate_entry *p = NULL, *iter;
 
-		list_for_each_entry(p, &gating_cfg->entries, list) {
-			if (p->interval == e->interval) {
+		list_for_each_entry(iter, &gating_cfg->entries, list) {
+			if (iter->interval == e->interval) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "Gate conflict");
 				rc = -EBUSY;
 				goto err;
 			}
 
-			if (e->interval < p->interval)
+			if (e->interval < iter->interval) {
+				p = iter;
+				list_add(&e->list, iter->list.prev);
 				break;
+			}
 		}
-		list_add(&e->list, p->list.prev);
+		if (!p)
+			list_add(&e->list, gating_cfg->entries.prev);
 	}
 
 	gating_cfg->num_entries++;
-- 
2.25.1

