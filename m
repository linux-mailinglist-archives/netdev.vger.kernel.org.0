Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFB54F7CD8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240845AbiDGKd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244328AbiDGKdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:33:38 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A736CC1CBA;
        Thu,  7 Apr 2022 03:31:17 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bq8so9852331ejb.10;
        Thu, 07 Apr 2022 03:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MSY1nTudb+PZHTwNW0++Hw3ZkegN7YQIOboMBZ6jBg0=;
        b=Brx4PkxB2qdWTRw7gD0HT3PEDbMMWi0XZkbblBnTtAVRKFZm8RAn4P1cLxUzGaUSWj
         r6JxWEq0muCi0zq0RyRsEDl8YQa7DCNKZBC1Gj5rF17+x2LK3VvqVWEVI6k/8DvOCHIq
         xClZCgthVxp4u5kv6LFjYJJnSkK1bZEibqrgmMQ0JP8dYZ+15cOAVnkRAzi3IgoT+dqm
         k4uFx+UARieV2bsoVD67F5Xff9RQaJx4M76B8zZgTKoP9mHwlZS7m8uDs2+oJzpKPok8
         ktve3WHvQOVXDYKLjmG23a4XmTmuEu3OvZtYcVC0FpEHV2nWXBTKR8Gatcf/PU9USmof
         mfYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MSY1nTudb+PZHTwNW0++Hw3ZkegN7YQIOboMBZ6jBg0=;
        b=ckTcCs6ZE6xhKT2L22ndE8SCvAvO9GcuOf8zM6maRdqkuucT7RsL2akx70vST9v0nF
         YCBjioYlahIsz59Hq4C5oPPnJMjqfd8Ykm4pp7/wM2QF5EO5qnwq2EBSCkx6Hy8trrb7
         MOstPNETajqcAnvDvBS1nrapMwwvzNpBtZBvXpSYHVLGDFtLg3P8zWONXB9kb2jje9Jd
         me2xHG6QcmEF1DOheH8Xjv98yJEgvM3yBzBLt7jIFzGLZq/pwGK2iAnknYeCh+6DSxGC
         Hh1eUtLwZh/jxlLEOkuP08WRWIvvq4W/HBpDTEy9jYH6SGhmAzgwYf0r/4xqJC1H8Gb4
         novQ==
X-Gm-Message-State: AOAM532ZB7otaXQTIW/yAvBksqnn+Fcoy/fruAVOGE9t8bG16uejSUxt
        6zxCxurfG+TLlcLehtcZPvM=
X-Google-Smtp-Source: ABdhPJwwT5jmVo5qc9B+eZATYpRQi7yTuAnE1UXZHjgZUgliXLWJp7twbPBsvZlMRQCsjFWFpTIFiQ==
X-Received: by 2002:a17:907:7f1a:b0:6e8:4127:6bc4 with SMTP id qf26-20020a1709077f1a00b006e841276bc4mr375201ejc.496.1649327476146;
        Thu, 07 Apr 2022 03:31:16 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm7413573ejz.57.2022.04.07.03.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 03:31:15 -0700 (PDT)
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
Subject: [PATCH net-next 12/15] net: netcp: Remove usage of list iterator for list_add() after loop body
Date:   Thu,  7 Apr 2022 12:28:57 +0200
Message-Id: <20220407102900.3086255-13-jakobkoschel@gmail.com>
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
 drivers/net/ethernet/ti/netcp_core.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index 16507bff652a..7f89fd82ecc8 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -471,8 +471,8 @@ struct netcp_hook_list {
 int netcp_register_txhook(struct netcp_intf *netcp_priv, int order,
 			  netcp_hook_rtn *hook_rtn, void *hook_data)
 {
+	struct netcp_hook_list *next = NULL, *iter;
 	struct netcp_hook_list *entry;
-	struct netcp_hook_list *next;
 	unsigned long flags;
 
 	entry = devm_kzalloc(netcp_priv->dev, sizeof(*entry), GFP_KERNEL);
@@ -484,11 +484,15 @@ int netcp_register_txhook(struct netcp_intf *netcp_priv, int order,
 	entry->order     = order;
 
 	spin_lock_irqsave(&netcp_priv->lock, flags);
-	list_for_each_entry(next, &netcp_priv->txhook_list_head, list) {
-		if (next->order > order)
+	list_for_each_entry(iter, &netcp_priv->txhook_list_head, list) {
+		if (iter->order > order) {
+			next = iter;
+			list_add_tail(&entry->list, &iter->list);
 			break;
+		}
 	}
-	__list_add(&entry->list, next->list.prev, &next->list);
+	if (!next)
+		list_add_tail(&entry->list, &netcp_priv->txhook_list_head);
 	spin_unlock_irqrestore(&netcp_priv->lock, flags);
 
 	return 0;
@@ -520,8 +524,8 @@ EXPORT_SYMBOL_GPL(netcp_unregister_txhook);
 int netcp_register_rxhook(struct netcp_intf *netcp_priv, int order,
 			  netcp_hook_rtn *hook_rtn, void *hook_data)
 {
+	struct netcp_hook_list *next = NULL, *iter;
 	struct netcp_hook_list *entry;
-	struct netcp_hook_list *next;
 	unsigned long flags;
 
 	entry = devm_kzalloc(netcp_priv->dev, sizeof(*entry), GFP_KERNEL);
@@ -533,11 +537,15 @@ int netcp_register_rxhook(struct netcp_intf *netcp_priv, int order,
 	entry->order     = order;
 
 	spin_lock_irqsave(&netcp_priv->lock, flags);
-	list_for_each_entry(next, &netcp_priv->rxhook_list_head, list) {
-		if (next->order > order)
+	list_for_each_entry(iter, &netcp_priv->rxhook_list_head, list) {
+		if (iter->order > order) {
+			next = iter;
+			list_add_tail(&entry->list, &iter->list);
 			break;
+		}
 	}
-	__list_add(&entry->list, next->list.prev, &next->list);
+	if (!next)
+		list_add_tail(&entry->list, &netcp_priv->rxhook_list_head);
 	spin_unlock_irqrestore(&netcp_priv->lock, flags);
 
 	return 0;
-- 
2.25.1

