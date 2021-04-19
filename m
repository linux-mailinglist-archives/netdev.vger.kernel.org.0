Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286603639E4
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 06:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbhDSEEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 00:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbhDSEEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 00:04:39 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3A7C06174A;
        Sun, 18 Apr 2021 21:04:09 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g16so9000970pfq.5;
        Sun, 18 Apr 2021 21:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nooF0bh3uQe/ilf/ttra6OUts5vU91KPBygIK+rN8CU=;
        b=lAE1M2kH8mYGvH4QI2ZOpm39wWa82gcbp2UhP0pd8YfHtS/cOHPn9k/+8vBbmYjPJQ
         B7YLOHcKKQodQni2ID6ZRG2C0cTCaYNx0r8PsACXLeUGRwGlqUl6sFPiguWqasIDKqv7
         9sQbY2hmfpnYLHWq9rpDcQ8NcaTO9VZfmP6dzOiwAOykn5lV7XDx4ktxT1rTQzVPy/K8
         EoGHHeIwtJ2vkaSTMK03l0Ffalq/2ItfJ/UjGYt33pY8UzUOtJc4ki8GM+TECddbVxH9
         gZBsQUe370IvM+hutvbSC+uZlHx4BTSlVKqXbdZ4kLdJaD68OVyJoBhG9DWErIBZWrLm
         Ucbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nooF0bh3uQe/ilf/ttra6OUts5vU91KPBygIK+rN8CU=;
        b=pZsKj0eAEPdjU+IouHOAPGGdSDQGwSmTdIl+LheHsfKZh/BA8wR9sBsPHkY3tdMycd
         apb2m5oq46OATYz224ivbInrAlZJnBaKdV38L+dblG41urlQXnWCqEn4quhwrt7TSFrX
         EUq/TNCxQHq3XQgJgCmb2SdzQdEwYPkHUrDrnYKgLhbhdN3Y3BTGnZiEfSLK0UlOJOwU
         PNAtd3WvXI3SeNL5JG8pTVOr3fTM9CZMwBt6kjtLn2R99GU/25UY+du9WugRr1fH5c1K
         T4Z8IF1KSyKxb4U2K2UhgtrCunvA97u2GKyWGhzzY7HnxhHsU9QWA7MNjLX3jgsEtUs7
         ZEIQ==
X-Gm-Message-State: AOAM533oNstQZktnlU5NLsziM0pRVwPSJisMipSrL5ySPpqLIqF2l0Gn
        a+h2JsXIxe1DW5lAIAHGFRM=
X-Google-Smtp-Source: ABdhPJz2bKhFE3qPTDDPaQXc8tpwKJvnnZWr0+4qR2uTa5yoJE0Y33ONufXaKA1nPG7HARQ8c5C9Tw==
X-Received: by 2002:a63:5f54:: with SMTP id t81mr3727918pgb.286.1618805048816;
        Sun, 18 Apr 2021 21:04:08 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id 25sm12169423pgx.72.2021.04.18.21.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 21:04:08 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH net-next 2/2] net: ethernet: mediatek: support custom GMAC label
Date:   Sun, 18 Apr 2021 21:03:52 -0700
Message-Id: <20210419040352.2452-3-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419040352.2452-1-ilya.lipnitskiy@gmail.com>
References: <20210419040352.2452-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC device name can now be set within DTS file instead of always
being "ethX". This is helpful for DSA to clearly label the DSA master
device and distinguish it from DSA slave ports.

For example, some devices, such as the Ubiquiti EdgeRouter X, may have
ports labeled ethX. Labeling the master GMAC with a different prefix
than DSA ports helps with clarity.

Suggested-by: René van Dorst <opensource@vdorst.com>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6b00c12c6c43..4c0ce4fb7735 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2845,6 +2845,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 
 static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 {
+	const char *label = of_get_property(np, "label", NULL);
 	const __be32 *_id = of_get_property(np, "reg", NULL);
 	phy_interface_t phy_mode;
 	struct phylink *phylink;
@@ -2940,6 +2941,9 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	else
 		eth->netdev[id]->max_mtu = MTK_MAX_RX_LENGTH_2K - MTK_RX_ETH_HLEN;
 
+	if (label)
+		strscpy(eth->netdev[id]->name, label, IFNAMSIZ);
+
 	return 0;
 
 free_netdev:
-- 
2.31.1

