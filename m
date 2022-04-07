Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D924F7CD7
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244316AbiDGKdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244287AbiDGKdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:33:14 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8E339161;
        Thu,  7 Apr 2022 03:31:08 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dr20so9835822ejc.6;
        Thu, 07 Apr 2022 03:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7YEqjlB8bsXZ45gzNCMwH2JxmTxm4dwtRKumhhyyThw=;
        b=U64EZxGRbbD6pcGGxysdvb6UC8spWf9j4i/wUJz5ddDFhoazBBRgniBsbGKwfcoyB6
         Y3R4h1Jtnl+dMLUOBbQ3Mbtm240Zz7D8ggLMYTHXI8X/jbDk1z9cYJGh/sLyB33Q2ux0
         KIgo/Wp5dSFk/3NP6hRm8dkwZGAsHMDsOZULMSXvK/IP8Y9KLG1lBXjHYOTqUGyNCicZ
         wDNvabeOOARFjYAssvgtqouuoCfNlxKTBH/1005bkg7MdUe5xwWfEjQv76oDHtA04/ZY
         /HuBH2goLAhsQSwB7tRtkJ3V7VOarq6n22XJJGBdtp/b0lvGwyiWMwrDLCGrNCYZf+tp
         8R0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7YEqjlB8bsXZ45gzNCMwH2JxmTxm4dwtRKumhhyyThw=;
        b=8NRRyfbTZZ1dPxy/6s49kZKoVfMueFRZMJvAVhUCRShVTxWA6jAnjXCiBCgkfcFSi8
         bOpZe2Xx1CI8226KLu5C0vux9stTJhYJNZlGBgeX+6S4+siwkbmr/fJHKMwLXOYlmaG3
         SRNGVZBZe/z6+jUrk70ArnxOkEr7drTEFkwOywN7E0RjBkKP99m9Lbq2xyUtg6umcSve
         dEfzPCEvPHd8KhGDDplwFO5W9ehJ9ZnsfzN71FguA3vNVA10OANCwlLtjS8P8YnUdEIr
         8A6RLQWPO+UQfeiVV6u0Qaphz7F78YVlUg5VAMme9nQUYKyR0Rx5UfuATAEuPi8NnTFN
         ycSw==
X-Gm-Message-State: AOAM530f8uiloqzN1DY3U0KKxJxkKPLUA0Ww+7VxU6GOiLQp2actP7L3
        riD7/YNocVP96NxkWkRzK70=
X-Google-Smtp-Source: ABdhPJzfK7J/oVVIzBQuOre8YptTYXi0JAQavlyqub2o6edmGoAwWmVzAvj4GmM2kfON5LuClIxWJQ==
X-Received: by 2002:a17:907:3f92:b0:6e7:2ad3:a92b with SMTP id hr18-20020a1709073f9200b006e72ad3a92bmr13146230ejc.239.1649327467049;
        Thu, 07 Apr 2022 03:31:07 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm7413573ejz.57.2022.04.07.03.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 03:31:06 -0700 (PDT)
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
Subject: [PATCH net-next 05/15] net: sparx5: Replace usage of found with dedicated list iterator variable
Date:   Thu,  7 Apr 2022 12:28:50 +0200
Message-Id: <20220407102900.3086255-6-jakobkoschel@gmail.com>
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

