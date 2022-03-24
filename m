Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583F24E5F45
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 08:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346821AbiCXHYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 03:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242325AbiCXHYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 03:24:19 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB1B985AF;
        Thu, 24 Mar 2022 00:22:47 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id r13so7315210ejd.5;
        Thu, 24 Mar 2022 00:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k6M1gtBhcLwqQhb+6I8nGgl3IyuB311pIjZdGukijdI=;
        b=L4IX3OwTZxUxrNhktlXcbxAakQfTvK2MJI+NKsQsKmxHywc5E5OpaiPdrGSpqXwGbY
         TLhQIHemuM/TMwUjD0cLJcNJY2/O9RnmQlwOEKARWNWUFAKnz15/3QCMgQ08hblJ4Ci1
         74tRnVeF6AkwQ8wZjq5nh2BZFDuj4cgokhTxRdVywRTOYNzjgefnoBLMFe/Bx6E9FVLw
         cYDh7FDOQIWLktc8w0zc6I/XOeh2sItjkXVbH/aNbMAVMKsmU4518cKP/3ubA8kegvjc
         r2g6MwwqUilEmJmuwpXxvIgIk0dc+NXsYKKXmITjriQwHPff6yMs0D+JWkOG95OB8MuU
         sXLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k6M1gtBhcLwqQhb+6I8nGgl3IyuB311pIjZdGukijdI=;
        b=n05Pr6worbl4pwvRhRWYd1RTjXlXu66+WZVppsRGiFfdXjtxQfbckUlJJi8Aa9tk8L
         SuUBCKaWVNt2X+h/vXLExJNwrI8lVChcZer0Ei/VXCvWsi8/KC38EqQb1Jzr+IpBQB2b
         CqcWZXppQZ2BgLlpUfRtbvnD7aF0ASbUw4OJQRyP88QEwfzj88nxTeUyCH0RwkNQd2Ld
         oUczV61cLXc8dFWDihZVWmgaMsUBjPM6NadbXTbHgS5nmaWJ2aFv7mZAuXt9QjORYcM+
         bcEOwREY8ErTD2DCOYHDCf7mKRHij96C6V75uU2DGdpMx0J17ZPcGOk3xe5Rj/j9JXWr
         pDDA==
X-Gm-Message-State: AOAM530CtduJH6nAmjiqQQogW+JZBWHvuZKJTe9D73Izmsm//QqmS+i/
        EMuZY5fgV+FEXiYa2F+1deI=
X-Google-Smtp-Source: ABdhPJwIp/xzeJPmwR1G32bIVCIfFh55Pl6gao8TcaC0AZAsDGrk5eDexTV6HfibDkyOdUhWcNsYEQ==
X-Received: by 2002:a17:907:97c5:b0:6da:c285:44f5 with SMTP id js5-20020a17090797c500b006dac28544f5mr4169179ejc.208.1648106566094;
        Thu, 24 Mar 2022 00:22:46 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id i11-20020a05640242cb00b0041922d3ce3bsm1071532edc.26.2022.03.24.00.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 00:22:45 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH] rtlwifi: replace usage of found with dedicated list iterator variable
Date:   Thu, 24 Mar 2022 08:21:24 +0100
Message-Id: <20220324072124.62458-1-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 13 ++++++-------
 drivers/net/wireless/realtek/rtlwifi/pci.c  | 15 +++++++--------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index ffd150ec181f..a7ef84f55939 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1994,8 +1994,7 @@ void rtl_collect_scan_list(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	unsigned long flags;
 
-	struct rtl_bssid_entry *entry;
-	bool entry_found = false;
+	struct rtl_bssid_entry *entry = NULL, *iter;
 
 	/* check if it is scanning */
 	if (!mac->act_scanning)
@@ -2008,10 +2007,10 @@ void rtl_collect_scan_list(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	spin_lock_irqsave(&rtlpriv->locks.scan_list_lock, flags);
 
-	list_for_each_entry(entry, &rtlpriv->scan_list.list, list) {
-		if (memcmp(entry->bssid, hdr->addr3, ETH_ALEN) == 0) {
-			list_del_init(&entry->list);
-			entry_found = true;
+	list_for_each_entry(iter, &rtlpriv->scan_list.list, list) {
+		if (memcmp(iter->bssid, hdr->addr3, ETH_ALEN) == 0) {
+			list_del_init(&iter->list);
+			entry = iter;
 			rtl_dbg(rtlpriv, COMP_SCAN, DBG_LOUD,
 				"Update BSSID=%pM to scan list (total=%d)\n",
 				hdr->addr3, rtlpriv->scan_list.num);
@@ -2019,7 +2018,7 @@ void rtl_collect_scan_list(struct ieee80211_hw *hw, struct sk_buff *skb)
 		}
 	}
 
-	if (!entry_found) {
+	if (!entry) {
 		entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
 
 		if (!entry)
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index ad327bae754b..8e4c15654746 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -323,14 +323,13 @@ static bool rtl_pci_check_buddy_priv(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	bool find_buddy_priv = false;
-	struct rtl_priv *tpriv;
+	struct rtl_priv *tpriv = NULL, *iter;
 	struct rtl_pci_priv *tpcipriv = NULL;
 
 	if (!list_empty(&rtlpriv->glb_var->glb_priv_list)) {
-		list_for_each_entry(tpriv, &rtlpriv->glb_var->glb_priv_list,
+		list_for_each_entry(iter, &rtlpriv->glb_var->glb_priv_list,
 				    list) {
-			tpcipriv = (struct rtl_pci_priv *)tpriv->priv;
+			tpcipriv = (struct rtl_pci_priv *)iter->priv;
 			rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
 				"pcipriv->ndis_adapter.funcnumber %x\n",
 				pcipriv->ndis_adapter.funcnumber);
@@ -344,19 +343,19 @@ static bool rtl_pci_check_buddy_priv(struct ieee80211_hw *hw,
 			    tpcipriv->ndis_adapter.devnumber &&
 			    pcipriv->ndis_adapter.funcnumber !=
 			    tpcipriv->ndis_adapter.funcnumber) {
-				find_buddy_priv = true;
+				tpriv = iter;
 				break;
 			}
 		}
 	}
 
 	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
-		"find_buddy_priv %d\n", find_buddy_priv);
+		"find_buddy_priv %d\n", tpriv != NULL);
 
-	if (find_buddy_priv)
+	if (tpriv)
 		*buddy_priv = tpriv;
 
-	return find_buddy_priv;
+	return tpriv != NULL;
 }
 
 static void rtl_pci_get_linkcontrol_field(struct ieee80211_hw *hw)

base-commit: f443e374ae131c168a065ea1748feac6b2e76613
-- 
2.25.1

