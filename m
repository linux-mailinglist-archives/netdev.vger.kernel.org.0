Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39114FE0EA
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350773AbiDLMuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355302AbiDLMsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:48:10 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C858FDEC3;
        Tue, 12 Apr 2022 05:16:45 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id r13so36974383ejd.5;
        Tue, 12 Apr 2022 05:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=woYPht1iAY/ITrpUe+WmESGMoM6pZPj3PA3p1Q9RO1s=;
        b=oasmHws7BuqZeiAnnEcufYNIOD4sU3eIiCPzUYDX+cUval+yJ0H9LT/MmLwdvoBpMZ
         9zFKCwOBa6nTXisJYGOIgg1AGsRvd4Ez5i+KpuetjgS1Q8e6/YYY5mvZiGq/XwgNiAwn
         bko+hrTqq0EygSMKT70ewwGQscJHCcLuYLecAOdlWZIJJ5wJ/7emPyWW4Hwem4aU1LJD
         P6ltWVFnqYcySXBoCdDjoLXdtyti2Sk7duYICoCwkenjZ8w/Nf2eJKg59lrgJpKzT9Il
         PnhVbUYThdvURVCrtkEt0vy6ieIIm0tZeeLQg+GDLc5IXzyw7eCO/zIOc+Su9gmwOxlo
         OXYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=woYPht1iAY/ITrpUe+WmESGMoM6pZPj3PA3p1Q9RO1s=;
        b=nsahirZgOTKcsfSo7bXOXQKOEU69ywNv1hK4OfVkEJeF7uRtTqE+7yBn8vTjzWN+wo
         G2kZSMncFqrxbrzq8PjPyONnp/XDZr+5pR+io7LC7shUc6nYYvd65elh6u/ciO/ywyWH
         Scq9xZ8Feq2dlTUOJkJr8aoNgPB4GsfKFreBMrYMjtD3xv7+D8aq4DeZ2bdaDLw4o/Km
         flJHkxWDPFOTfIXjw8nVXk0TdS+l2E0vo2y8wDwuhmIuU/Du6DnCH8IHNbSqQasNa7ys
         080y1w80Q+DUYGdlO43xaBxoiB7aGovpP2Hc2Nz9nO7teu5SR0SEZi/SQN11Hw9vhh/d
         +Xlw==
X-Gm-Message-State: AOAM533LMJBzqWrhSViIZCNvAaUz8TcfBB2Uql2ntJBAfiCUE0TCUpPM
        WK1TpoehBZP0ojtGYOX/hTg=
X-Google-Smtp-Source: ABdhPJzrAP+PQXb0DFEQ9HcHdQKAL7TxzAM/HxpCqMIP0jD133MWnZ5gDRQWL8hAUdfyvtgXIQXmFw==
X-Received: by 2002:a17:906:1615:b0:6bb:150f:adf8 with SMTP id m21-20020a170906161500b006bb150fadf8mr34278716ejd.272.1649765804298;
        Tue, 12 Apr 2022 05:16:44 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id b5-20020a17090630c500b006e8044fa76bsm8827900ejb.143.2022.04.12.05.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 05:16:43 -0700 (PDT)
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
        Michael Walle <michael@walle.cc>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v3 15/18] net: netcp: Remove usage of list iterator for list_add() after loop body
Date:   Tue, 12 Apr 2022 14:15:54 +0200
Message-Id: <20220412121557.3553555-16-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412121557.3553555-1-jakobkoschel@gmail.com>
References: <20220412121557.3553555-1-jakobkoschel@gmail.com>
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

