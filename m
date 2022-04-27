Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F47511D87
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241775AbiD0QNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242307AbiD0QME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:12:04 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BF53ECCB5;
        Wed, 27 Apr 2022 09:08:25 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id g6so4402418ejw.1;
        Wed, 27 Apr 2022 09:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=woYPht1iAY/ITrpUe+WmESGMoM6pZPj3PA3p1Q9RO1s=;
        b=ggGv5P+EjcqZAl8voak+pwbzxzcjAmNNNxozwigeVhgulY+Vg7Hr8WKASQPrdbJxaK
         iNx74FS82CGgZTJVRSG4Oomayax8Ix2G83dwD/ChqX7H3+drsjBoiyv5lCzqeyuioEaS
         XBD5wk28Byq9pX2aiPXMyH6LlS/LvHPJDThnFQKgh3nlde4cQ2ah/HtfA3uKG+KOtjGk
         xhzjAAKQPnpbxT1RB3eO/pkRPdJwrx+Vpa+tNsGGA6zuKUYXr3twD3nOR/1emeN0SbJi
         Y4gsNXWxuiO8WT6EK1yWlB0Uc+qo03WXDB1xMzaj7Jhdwr74YVl19BVt0dpCl+0lzojy
         2L+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=woYPht1iAY/ITrpUe+WmESGMoM6pZPj3PA3p1Q9RO1s=;
        b=hr0X0q8uI7YjV0SMd1CkbavGlJ8L7hJAUtJVaJtlaVGUIDOkz43UlX0vClvxVaTtkl
         PJ97O3LEYyJOkHBmXKdeNybVNl+jWJqhnywhOxf3IBGY9sOvqFgsWn5Q4ijvX/fL8nfX
         Cue+vhCPZ5YVrNQslmE2WQDHj9120vVco+SIDVjUvqSbv4wZZktqLFnNeJtB/vKHauiW
         Q8nEM8N+enAgfCAV2lW24p/N7+rcpls1y+c2aEeq15guLHMz6+Yq/ZSlN/x5gYr3PC6c
         wBcHu9qB2J3wgs88BcqZj0Pybb0QORF4tckdRqUknssnnX5OuvSfx6JxNTjgZhcHf1/Z
         9bLw==
X-Gm-Message-State: AOAM533fGZ1ieiTiApN5fHfYGY8GazBL9HM8LdWUNLBIlCn/O4rqu8i1
        NMAUMnTqRFLdcLDCZwLitWk=
X-Google-Smtp-Source: ABdhPJxu/+RIi87EI1f36Vr7Li+Ul/kNIIoagY73de2BeXztI3uQN8w4l7WqyA51zpnq1qGpZm55vg==
X-Received: by 2002:a17:906:1c12:b0:6f3:9eed:e0 with SMTP id k18-20020a1709061c1200b006f39eed00e0mr14192987ejg.656.1651075654602;
        Wed, 27 Apr 2022 09:07:34 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:34 -0700 (PDT)
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
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v5 15/18] net: netcp: Remove usage of list iterator for list_add() after loop body
Date:   Wed, 27 Apr 2022 18:06:32 +0200
Message-Id: <20220427160635.420492-16-jakobkoschel@gmail.com>
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

In preparation to limit the scope of a list iterator to the list
traversal loop, use a dedicated pointer pointing to the location
where the element should be inserted [1].

Before, the code implicitly used the head when no element was found
when using &next->list. The new 'pos' variable is set to the list head
by default and overwritten if the list exits early, marking the
insertion point for list_add().

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/ethernet/ti/netcp_core.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index 16507bff652a..f25104b5a31b 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -471,6 +471,7 @@ struct netcp_hook_list {
 int netcp_register_txhook(struct netcp_intf *netcp_priv, int order,
 			  netcp_hook_rtn *hook_rtn, void *hook_data)
 {
+	struct list_head *pos = &netcp_priv->txhook_list_head;
 	struct netcp_hook_list *entry;
 	struct netcp_hook_list *next;
 	unsigned long flags;
@@ -485,10 +486,12 @@ int netcp_register_txhook(struct netcp_intf *netcp_priv, int order,
 
 	spin_lock_irqsave(&netcp_priv->lock, flags);
 	list_for_each_entry(next, &netcp_priv->txhook_list_head, list) {
-		if (next->order > order)
+		if (next->order > order) {
+			pos = &next->list;
 			break;
+		}
 	}
-	__list_add(&entry->list, next->list.prev, &next->list);
+	list_add_tail(&entry->list, pos);
 	spin_unlock_irqrestore(&netcp_priv->lock, flags);
 
 	return 0;
@@ -520,6 +523,7 @@ EXPORT_SYMBOL_GPL(netcp_unregister_txhook);
 int netcp_register_rxhook(struct netcp_intf *netcp_priv, int order,
 			  netcp_hook_rtn *hook_rtn, void *hook_data)
 {
+	struct list_head *pos = &netcp_priv->rxhook_list_head;
 	struct netcp_hook_list *entry;
 	struct netcp_hook_list *next;
 	unsigned long flags;
@@ -534,10 +538,12 @@ int netcp_register_rxhook(struct netcp_intf *netcp_priv, int order,
 
 	spin_lock_irqsave(&netcp_priv->lock, flags);
 	list_for_each_entry(next, &netcp_priv->rxhook_list_head, list) {
-		if (next->order > order)
+		if (next->order > order) {
+			pos = &next->list;
 			break;
+		}
 	}
-	__list_add(&entry->list, next->list.prev, &next->list);
+	list_add_tail(&entry->list, pos);
 	spin_unlock_irqrestore(&netcp_priv->lock, flags);
 
 	return 0;
-- 
2.25.1

