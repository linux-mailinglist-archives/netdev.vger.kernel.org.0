Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26C35029D4
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353498AbiDOMeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353387AbiDOMdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:33:36 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D569329A7;
        Fri, 15 Apr 2022 05:31:08 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bg10so15161617ejb.4;
        Fri, 15 Apr 2022 05:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=woYPht1iAY/ITrpUe+WmESGMoM6pZPj3PA3p1Q9RO1s=;
        b=J29YX3EEMEL7T374lnld4XKuYjiGeeoVO1klWLUIkfZJQeL2lLiOJu41mh8Mlrt/vB
         0hc1mDL5NN2TTVjsBWWdsfB0RlH9u8WpBKvaSwodSk+R4GZNluAP3ZKaTkkPMlIbNlTk
         w9cBhCyuJv+3wLIzF/9Kc7oQdcKK/rIIWAVsgeZIVRYleGEFkaYTlnrjHromHPnbM1/7
         3lP8wZeKMpEF3W4eWzvgySheAoJ/fSA4dloEVHWMNtpL4XJqAwi6ktnNLBkPCF3RqAtL
         FfsqZ0RtqT0it3Iyvym50ZYXeiMDeI0khBXLATZMg661vZKB6wij6XlgY68sJ/G4H+3v
         pltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=woYPht1iAY/ITrpUe+WmESGMoM6pZPj3PA3p1Q9RO1s=;
        b=QR1GbEDnXtxEMtwbQ1X4m8y7nR/oY8FcZKw6vY4U3nJYf3fKZ1e1bbg1ft8S1mH8ya
         AAe05Azb4UypRl3lh5rSBkgayy3THhNC7KExlXXciqZ5+PmIGyB5j8MtLFvFF5LADN9O
         DfDnNFNWmRivprUW3XjOsX52PKPeVpiGqCLdJYa0J7ZRF9Iw2ddygsS4I6wCw0veSX1Y
         IcZJQjZFQuaNHyOsx4O23iFK7/xlxnmbjyb6EfejCkFYf7dOs8xAQlN2rpODcCL6zFvk
         ZD3ySdt1r3DEY5HsmIG9QLFft5hZuoj1VGYQfm5UlQrGMH+YVglxtkYutsiwA4p8gNvF
         UIRA==
X-Gm-Message-State: AOAM533YIBcmsj5kEXuBL3hGM88QGnIwNVHtoAL7sYDQBkMDqiFo41RE
        mEqmWcV7KG/tDV+dWqKIW0w=
X-Google-Smtp-Source: ABdhPJyYIoFdAFzmkkdjuJw1d5/znELShtA1rZkNdZGQuvIqYGA+O8h6GmIux5FiMuA0sKmX8w24Kg==
X-Received: by 2002:a17:907:6d9b:b0:6db:8eab:94e0 with SMTP id sb27-20020a1709076d9b00b006db8eab94e0mr5947836ejc.687.1650025866683;
        Fri, 15 Apr 2022 05:31:06 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm1649533ejb.194.2022.04.15.05.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:31:06 -0700 (PDT)
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
Subject: [PATCH net-next v4 15/18] net: netcp: Remove usage of list iterator for list_add() after loop body
Date:   Fri, 15 Apr 2022 14:29:44 +0200
Message-Id: <20220415122947.2754662-16-jakobkoschel@gmail.com>
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

