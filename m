Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24D92E1957
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 08:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgLWHQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 02:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgLWHQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 02:16:56 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6BEC0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 23:16:15 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id e25so5214640wme.0
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 23:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BSmgSuDuoUx/Y5HZU+3fSaL+Xdhrw1YtSQJpgb6Oa8Y=;
        b=hm0Ds+6pK6QZDqGwbArkm4DzLIIUwwbOiBcBsOufWtbNW/i2nLgcIOgAITYLVODQHd
         HtR5YnRuLF/FfbHrXInUYPbKWoLzpAYMw4KldIgiS9TwlmmZBBtoYGi6i8vvQ03+pag1
         k+66ZwGD8dsJJpUYD5CKZx/SroXlBjQtzcdjvY3ia3FNgD/n7ezy+9nOnv8iCFhMBEKG
         S8bZbImta7AvyQ+sqtdhFHJjC5OrZqNpdETZ/QzXJ02yyxstUkSHUiOcPjuKCTbaa4fG
         vgT3cW0R0eMaZuo5G/0xDMD7wvskEPIGoHRKBdIyKh0Ji0jXm+ip4NRwItGP+POt0oQQ
         zc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BSmgSuDuoUx/Y5HZU+3fSaL+Xdhrw1YtSQJpgb6Oa8Y=;
        b=rQWEBqIYdWiebRkZ2Wk5KNitKQBlVh9Npo6JeM/vNM36rm4LwGqQ94yy2BDsfyMX/y
         qferJBBXCF7WsnbV0Eg+hOxmh5Ua8sRn2N3sQrmEanvK7c/DrqZy5B7WJswL3CqZe2EL
         pVDsO3QaV7qga9zi58qkgq3WIaOlWLK2aSyj583XB8itmpJ07PUUU44kr2trILMYO/t5
         Xibs+SFJoUWzRLnHTwSBumQcLwSjEcw+blTyv7Nk4tVT50cBlwXuGdhmCz++wTQ1i8rv
         BXQ2o+fogoA0nDsGV6CpJWrrVJckbNJPs4r3xUcBs0vcFWaFidO38y/QKbgPCzNt1KVi
         m24g==
X-Gm-Message-State: AOAM531MYigr2GwVqqELVS/rumbr0I31M54NDM7GINYqMTb1WMCz/UNu
        f3XC/hAy4roYoTQRrxQOqRo=
X-Google-Smtp-Source: ABdhPJwUVA2xRfrbr5tXIRWXxf8tCKxhtb/5fkKv0ArMVrSn6BnmmPkxwfbnC9Qlup1k2Z/dOztOag==
X-Received: by 2002:a1c:2091:: with SMTP id g139mr25716513wmg.133.1608707773488;
        Tue, 22 Dec 2020 23:16:13 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id 125sm27926105wmc.27.2020.12.22.23.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 23:16:12 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        shmulik.ladkani@gmail.com, Eyal Birger <eyal.birger@gmail.com>
Subject: [RFC ipsec-next] xfrm: interface: enable TSO on xfrm interfaces
Date:   Wed, 23 Dec 2020 09:15:38 +0200
Message-Id: <20201223071538.3573783-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Underlying xfrm output supports gso packets.
Declare support in hw_features and adapt the xmit MTU check to pass GSO
packets.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/xfrm/xfrm_interface.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 9b8e292a7c6a..d28e9f05d9dd 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -296,7 +296,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	}
 
 	mtu = dst_mtu(dst);
-	if (skb->len > mtu) {
+	if ((!skb_is_gso(skb) && skb->len > mtu) ||
+	    (skb_is_gso(skb) && !skb_gso_validate_network_len(skb, mtu))) {
 		skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 		if (skb->protocol == htons(ETH_P_IPV6)) {
@@ -579,6 +580,11 @@ static void xfrmi_dev_setup(struct net_device *dev)
 	eth_broadcast_addr(dev->broadcast);
 }
 
+#define XFRMI_FEATURES (NETIF_F_SG |		\
+			NETIF_F_FRAGLIST |	\
+			NETIF_F_GSO_SOFTWARE |	\
+			NETIF_F_HW_CSUM)
+
 static int xfrmi_dev_init(struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
@@ -596,6 +602,8 @@ static int xfrmi_dev_init(struct net_device *dev)
 	}
 
 	dev->features |= NETIF_F_LLTX;
+	dev->features |= XFRMI_FEATURES;
+	dev->hw_features |= XFRMI_FEATURES;
 
 	if (phydev) {
 		dev->needed_headroom = phydev->needed_headroom;
-- 
2.25.1

