Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216DB5120B0
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242245AbiD0QMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241854AbiD0QLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:11:51 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4284C3656E3;
        Wed, 27 Apr 2022 09:07:46 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b24so2485415edu.10;
        Wed, 27 Apr 2022 09:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ry4cO5XKq+tSuqaPwnaD/oB6fR112JLGwCzZrnPEBlA=;
        b=gTz2VhWRMedOoCha0T1KppSjULk3Bc0IGbzfh8dYjxj0EMR9lXQhicmKaHe9WX8kjX
         EDzy4DCZgowX8w66jFwEOxdW3OJWSpKXEb7hLc2rGLcGjJLW94luIc1K0woOWuGAT6bs
         eoru8bk/NksbqyIbrM7zkCX7jp4W8Z+Cl9BI99WOHmGOROz4wHLvdYp6mjCsCPb+XEn2
         Aj5pJkeUi6siV5Ti4LW9sACgwKybqhKcVft6ZEOaacEDZVOn6HcPQyUSbRyYwyWCSu16
         20AZk0c6WgnbUFseXQhY7NzwsMpDGqhwzgBrDYQdHOZ/vTTYz6MtyG/AlxQQ/ooEqthL
         PwCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ry4cO5XKq+tSuqaPwnaD/oB6fR112JLGwCzZrnPEBlA=;
        b=h33tvvPnzjtr9VLHHtFboeKkRz/wGdkRmwWg5t3V1tJotD4O1Nj1EA9b8HwEuc+tnd
         ZZeI7Hi5oKmzHXer9lblIkSI7r7DJbnzH1Iz3fsg4rbj5t6H8NJyBlW9jwRW+uj2MhWh
         t+jBpp7/lrx+aviRxRCTM2bucbc25SsQF6sdO0uGmpYVqTw737iomcY9CgfhTqei5Mga
         I7vEKdDGDEM+wSSnOKxG9tmYy8ZpxBUHAaXAx0hH0a1Qjma6NXgmuRlDjKjFGrPP3H73
         8e196c3rJmTknsJEwo5N9RBrK39HB9ULRuY8F3AkAiR/wT/kQuShBMN9Y2H+TS/axO4D
         45Mg==
X-Gm-Message-State: AOAM532mR/gFdYuH1NdakUU+x0stXsx5O9KmMr2Ejwv7l3mHQJ8au3vF
        6d2Chm5PA1Cb/OS0uvZx44k=
X-Google-Smtp-Source: ABdhPJzmxCEbRgdEJxeGjIzOLAzD6Jz8BmWV4O0tXcBy7605EBHJeCvxAjeCBnzVK+USBG4J1UHv1Q==
X-Received: by 2002:a05:6402:486:b0:413:bd00:4f3f with SMTP id k6-20020a056402048600b00413bd004f3fmr31661472edv.103.1651075636619;
        Wed, 27 Apr 2022 09:07:16 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:16 -0700 (PDT)
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
Subject: [PATCH net-next v5 02/18] net: dsa: sja1105: remove use of iterator after list_for_each_entry() loop
Date:   Wed, 27 Apr 2022 18:06:19 +0200
Message-Id: <20220427160635.420492-3-jakobkoschel@gmail.com>
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

The link below explains that there is a desire to syntactically change
list_for_each_entry() and list_for_each() such that it becomes
impossible to use the iterator variable outside the scope of the loop.

Although sja1105_insert_gate_entry() makes legitimate use of the
iterator pointer when it breaks out, the pattern it uses may become
illegal, so it needs to change.

It is deemed acceptable to use a copy of the loop iterator, and
sja1105_insert_gate_entry() only needs to know the list_head element
before which the list insertion should be made. So let's profit from the
occasion and refactor the list iteration to a dedicated function.

An additional benefit is given by the fact that with the helper function
in place, we no longer need to special-case the empty list, since it is
equivalent to not having found any gating entry larger than the
specified interval in the list. We just need to insert at the tail of
that list (list_add vs list_add_tail on an empty list does the same
thing).

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220407102900.3086255-3-jakobkoschel@gmail.com/#24810127
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 46 ++++++++++++++++++----------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index b7e95d60a6e4..369be2ac3587 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -7,6 +7,27 @@
 
 #define SJA1105_SIZE_VL_STATUS			8
 
+static struct list_head *
+sja1105_first_entry_longer_than(struct list_head *entries,
+				s64 interval,
+				struct netlink_ext_ack *extack)
+{
+	struct sja1105_gate_entry *p;
+
+	list_for_each_entry(p, entries, list) {
+		if (p->interval == interval) {
+			NL_SET_ERR_MSG_MOD(extack, "Gate conflict");
+			return ERR_PTR(-EBUSY);
+		}
+
+		if (interval < p->interval)
+			return &p->list;
+	}
+
+	/* Empty list, or specified interval is largest within the list */
+	return entries;
+}
+
 /* Insert into the global gate list, sorted by gate action time. */
 static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
 				     struct sja1105_rule *rule,
@@ -14,6 +35,7 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
 				     struct netlink_ext_ack *extack)
 {
 	struct sja1105_gate_entry *e;
+	struct list_head *pos;
 	int rc;
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
@@ -24,25 +46,15 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
 	e->gate_state = gate_state;
 	e->interval = entry_time;
 
-	if (list_empty(&gating_cfg->entries)) {
-		list_add(&e->list, &gating_cfg->entries);
-	} else {
-		struct sja1105_gate_entry *p;
-
-		list_for_each_entry(p, &gating_cfg->entries, list) {
-			if (p->interval == e->interval) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Gate conflict");
-				rc = -EBUSY;
-				goto err;
-			}
-
-			if (e->interval < p->interval)
-				break;
-		}
-		list_add(&e->list, p->list.prev);
+	pos = sja1105_first_entry_longer_than(&gating_cfg->entries,
+					      e->interval, extack);
+	if (IS_ERR(pos)) {
+		rc = PTR_ERR(pos);
+		goto err;
 	}
 
+	list_add(&e->list, pos->prev);
+
 	gating_cfg->num_entries++;
 
 	return 0;
-- 
2.25.1

