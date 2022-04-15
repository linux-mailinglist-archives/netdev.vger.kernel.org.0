Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A785029DF
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353444AbiDOMdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353840AbiDOMd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:33:26 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520302F03F;
        Fri, 15 Apr 2022 05:30:58 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ks6so15187167ejb.1;
        Fri, 15 Apr 2022 05:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7YEqjlB8bsXZ45gzNCMwH2JxmTxm4dwtRKumhhyyThw=;
        b=T7ylaXjrwRyWiTc0Rk/AGiAUhp47Dwm32Ks4vuxph9an+0z1xHj59O1MX/r1Hx67px
         8+EOa0zPfsbd+6OeFm/ZLRXrOmwVi1n/z4+OC6/ShauOZtv8ETJJ6UUxs8zdoMTpYvlv
         f7d6Sa/nHrWnCc3tNiQD0aDmpEQfg3JLMAu3+0BAUPK9JynfpPu+cxUVCO1dR/fCVadO
         z1XrXzFIxZ7GQUxqMlNe6nGA0eBdmoz6K/xJ7ayYwY2XLh5s2/4Oc7u6QgePCmUCS6yJ
         HONc9MP2eI2HzyLJLql9Kmauz4rVI6HzYhE3fDEFu77+bIGGjvjumr7yEVn3LlsK/PEt
         atTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7YEqjlB8bsXZ45gzNCMwH2JxmTxm4dwtRKumhhyyThw=;
        b=8RmfgT+xq4jr7qUQo1NTNcKjGYMcMNOAzNDo3HNgCb1kUK5IAyJVVD4yz89AVOKZfV
         JmXIC0t2IOOsfRd6uwn/+wyH981tutLaIs9D7Od9kmCO5Yd1/pMu9I2YXkxF2Il61U2+
         74sY6t7pswaXpZoh8TMFx7XKWaAbd7Smdp/dep1MT1pUUKgO/rmcx9xsT1slNlDgn8LU
         BQNKRT8e3Cb6tltqsz64B4Z9CCre0ZdrnxqJ8gk5JwtPfZGj49mfZ1eMVnlPoWOV4kp2
         tGrNzs9Nli3LAxTA/SjGFfwC4DqzfT0hgpOxvqBBcdUeI+i8jnQBPpMDHqSoMTwz0FgK
         vsGg==
X-Gm-Message-State: AOAM532gCithooOotzcMo6snw6aWdIbXbJLwPXn4juuE79sd/NSHsVXj
        6vl/lyo8eUb/KXvo5fsnA94=
X-Google-Smtp-Source: ABdhPJyUUJDEq8iUjmbpZnPlBcAN+S98Ospicf2P4TBMAkg0qLhJ8vZC0xGS1LIiK4ovBtz3ZS4QfQ==
X-Received: by 2002:a17:907:72d5:b0:6ec:abf:dc87 with SMTP id du21-20020a17090772d500b006ec0abfdc87mr5374442ejc.120.1650025856776;
        Fri, 15 Apr 2022 05:30:56 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm1649533ejb.194.2022.04.15.05.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:30:56 -0700 (PDT)
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
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v4 08/18] net: sparx5: Replace usage of found with dedicated list iterator variable
Date:   Fri, 15 Apr 2022 14:29:37 +0200
Message-Id: <20220415122947.2754662-9-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415122947.2754662-1-jakobkoschel@gmail.com>
References: <20220415122947.2754662-1-jakobkoschel@gmail.com>
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
 .../microchip/sparx5/sparx5_mactable.c        | 25 +++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
index a5837dbe0c7e..bb8d9ce79ac2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -362,8 +362,7 @@ static void sparx5_mact_handle_entry(struct sparx5 *sparx5,
 				     unsigned char mac[ETH_ALEN],
 				     u16 vid, u32 cfg2)
 {
-	struct sparx5_mact_entry *mact_entry;
-	bool found = false;
+	struct sparx5_mact_entry *mact_entry = NULL, *iter;
 	u16 port;
 
 	if (LRN_MAC_ACCESS_CFG_2_MAC_ENTRY_ADDR_TYPE_GET(cfg2) !=
@@ -378,28 +377,28 @@ static void sparx5_mact_handle_entry(struct sparx5 *sparx5,
 		return;
 
 	mutex_lock(&sparx5->mact_lock);
-	list_for_each_entry(mact_entry, &sparx5->mact_entries, list) {
-		if (mact_entry->vid == vid &&
-		    ether_addr_equal(mac, mact_entry->mac)) {
-			found = true;
-			mact_entry->flags |= MAC_ENT_ALIVE;
-			if (mact_entry->port != port) {
+	list_for_each_entry(iter, &sparx5->mact_entries, list) {
+		if (iter->vid == vid &&
+		    ether_addr_equal(mac, iter->mac)) {
+			iter->flags |= MAC_ENT_ALIVE;
+			if (iter->port != port) {
 				dev_warn(sparx5->dev, "Entry move: %d -> %d\n",
-					 mact_entry->port, port);
-				mact_entry->port = port;
-				mact_entry->flags |= MAC_ENT_MOVED;
+					 iter->port, port);
+				iter->port = port;
+				iter->flags |= MAC_ENT_MOVED;
 			}
 			/* Entry handled */
+			mact_entry = iter;
 			break;
 		}
 	}
 	mutex_unlock(&sparx5->mact_lock);
 
-	if (found && !(mact_entry->flags & MAC_ENT_MOVED))
+	if (mact_entry && !(mact_entry->flags & MAC_ENT_MOVED))
 		/* Present, not moved */
 		return;
 
-	if (!found) {
+	if (!mact_entry) {
 		/* Entry not found - now add */
 		mact_entry = alloc_mact_entry(sparx5, mac, vid, port);
 		if (!mact_entry)
-- 
2.25.1

