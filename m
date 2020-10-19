Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F642926E7
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgJSMEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:04:46 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53572 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgJSMEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:04:46 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201019120428euoutp01f56d9fce54802b85377b9e76764ef179~-YzRKHoQU0330203302euoutp01J
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 12:04:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201019120428euoutp01f56d9fce54802b85377b9e76764ef179~-YzRKHoQU0330203302euoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603109068;
        bh=J03U/1SdKjL9qcicYqjiprNSvz33NcM7GNhEKlLdi1k=;
        h=From:To:Cc:Subject:Date:References:From;
        b=QNgK9fiLghNEesvwAuWNivALNTe1ntFfqTzXJnnhtuUTeEswlnI5wB19NtD4lDAZr
         1pjWNgz/SHcYCCcYWqJeWZcKpw2mOFatdbPGBY6HkN5lwFsmn+pJujwvpZ3p6PC7aU
         jMZECSNJwJG3V4qQe9EKyqfEjIAxq5D5UKof8W4o=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201019120420eucas1p231819231aedec593bed7d4c09bc1c6f0~-YzJKrLU73115931159eucas1p2b;
        Mon, 19 Oct 2020 12:04:20 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id F8.E1.06456.3C08D8F5; Mon, 19
        Oct 2020 13:04:19 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201019120419eucas1p26a296cc89b171e85642c6255872e23f0~-YzI1Sg3h2331523315eucas1p2r;
        Mon, 19 Oct 2020 12:04:19 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201019120419eusmtrp10eeddeab3025d3cdfc205e215ca7f5f9~-YzI0mabQ0980409804eusmtrp1w;
        Mon, 19 Oct 2020 12:04:19 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-8e-5f8d80c3cc58
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 00.29.06314.3C08D8F5; Mon, 19
        Oct 2020 13:04:19 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201019120419eusmtip1413898dbe763aa5cbd3ccd24fc19203d~-YzIrdOLo2443224432eusmtip1p;
        Mon, 19 Oct 2020 12:04:19 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v3] net: mii: Report advertised link capabilities when
 autonegotiation is off
Date:   Mon, 19 Oct 2020 14:04:15 +0200
Message-Id: <20201019120415.1416-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbTBUYRSed+/d3Wtr9VriJJOxJcMUkdGdyKTxY/3zu5lo4w4mi3YR+ZHK
        JN/5KGymDBnLJB+tDYNyMyj5LiGMEfloSllmS1LWZfLvOc85z3me885LERIt35oKi4hmlBHy
        cKlAROo6fvUef5WYEXiir9OT7ptgCbq2oJpPF/UlkXTJUgGf7tdl8ulRVoPooaYiAc3ea0F0
        VfuEkO4otjwrkg0NDxAybcUoT9aonhDK6ipTBLLGBj1PlqmtRDJ93SF/4XmRVzATHhbLKF28
        L4pCDTdwVJtl3P3JcUEiWpakIhMKsDssNrcJjViCNQhalu1SkWgTryCY3kgTcoUewQa7xN9R
        5A2rEdcoR9D0p4XHFXMIkqv1AuOUAPtAVlkX39iwwKsIZj7XbEkI3IqgcTKPSEUUZY4DISk/
        wCggsT00PfsmMNJifBrGVhI4N1tILn++tVOMzeB14QxpxPuwEzy5+WELE5szt+ofEMb1gFuF
        0Df2G3FiX0gZ7CI5bA6LnVohh22gOzedNHoBvg65OR6cNh2Brujn9rwnjPeubeUhsCNUN7lw
        tA9Mv8zmc1JTGPlqxkUwhRxdPsHRYrhze/t1j8DTrObthdaQsajZDiaDGkMxcRfZqXcdpt51
        jPq/bzEiKpEVE6NShDAq1wjmqrNKrlDFRIQ4B0Uq6tDmX+re6FxuQKuDl1iEKSTdK56KTA+U
        8OWxqngFi4AipBbicz3dARJxsDz+GqOMDFTGhDMqFh2kSKmV+GTJwgUJDpFHM5cZJopR7nR5
        lIl1IiomSv20jmtnPs3NWxoc3qSx2lMvuhZWjvq5QYL735p1fwNhbzNQVjXnkV0rbKufVWcV
        5jz20tSO/Ei9MhInynTzGpMeIPUF33E/bduuSB6oqJlKsHH40uut8U1+aL1eNT+g2B/U2YMi
        9xxuEX3MefSuufK9pvQtO7vi53BMPS4lVaFyVydCqZL/A40vDjBHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t/xu7qHG3rjDX59VLU4f/cQs8XGGetZ
        Leacb2GxWPR+BqvFhW19rBY3D61gtLi8aw6bxaGpexkt1h65y25xbIGYA5fH5WsXmT22rLzJ
        5LFz1l12j02rOtk8du74zOTRt2UVo8fnTXIB7FF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYm
        lnqGxuaxVkamSvp2NimpOZllqUX6dgl6Gd8bBQoOilVMu3eHrYHxk1AXIyeHhICJxJRrsxi7
        GLk4hASWMkr8OL6RtYuRAyghJbFybjpEjbDEn2tdbBA1TxklPl+dxQaSYBNwlOhfeoIVJCEi
        8JtRYsvReWAOs8A+Ron9Rxezg1QJC8RKLF51AqyDRUBVYtfmd2wgG3gFrCRufamG2CAv0b58
        O1gJr4CgxMmZT1hASpgF1CXWzwM7lF9AS2JN03UWEJsZqLx562zmCYwCs5B0zELomIWkagEj
        8ypGkdTS4tz03GJDveLE3OLSvHS95PzcTYzAuNp27OfmHYyXNgYfYhTgYFTi4X2Q3xMvxJpY
        VlyZe4hRgoNZSYTX6ezpOCHelMTKqtSi/Pii0pzU4kOMpkDfTGSWEk3OB8Z8Xkm8oamhuYWl
        obmxubGZhZI4b4fAwRghgfTEktTs1NSC1CKYPiYOTqkGRo9dAiF72vkitZNvdeqU3Ntsco1f
        yMfGTTKkgyHD8EJMo/hnt/pZd556ZAsy3g7xPnnyo86UCM69ScfcP33eULI73SYkcsqMS44P
        Sy1NXRjX5jdeLuao84ytv6kkdICrrUZw272rEgHWAjs95QtK1d+lr0uYxKLQ/tnDaNep8KIy
        7o+H5mcpsRRnJBpqMRcVJwIAYD2UH8ECAAA=
X-CMS-MailID: 20201019120419eucas1p26a296cc89b171e85642c6255872e23f0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201019120419eucas1p26a296cc89b171e85642c6255872e23f0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201019120419eucas1p26a296cc89b171e85642c6255872e23f0
References: <CGME20201019120419eucas1p26a296cc89b171e85642c6255872e23f0@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unify the set of information returned by mii_ethtool_get_link_ksettings(),
mii_ethtool_gset() and phy_ethtool_ksettings_get(). Make the mii_*()
functions report advertised settings when autonegotiation if disabled.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
This is the third version of ("net: phy: Prevent reporting advertised
modes when autoneg is off")  patch[1] that started as change for phy.c
to make phy_ethtool_ksettings_get() work like mii_*() below. After
suggestions from Russell King came v2[2].

Following Andrew Lunn's suggestions[2] to report advertised parameters even
when autonegotiation is off I decided to drop changes to phy.c and make
appropriate to mii.c

Changes in v3:
  - drop changes to phy.c
  - introduce changes to mii.c

Changes in v2:
  - clear lp_advertising
  - set ETHTOOL_LINK_MODE_TP_BIT and ETHTOOL_LINK_MODE_MII_BIT in advertising

[1] https://lore.kernel.org/lkml/20201014125650.12137-1-l.stelmach@samsung.com/ 
[2] https://lore.kernel.org/lkml/20201015084435.24368-1-l.stelmach@samsung.com/

 drivers/net/mii.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/mii.c b/drivers/net/mii.c
index f6a97c859f3a..e71ebb933266 100644
--- a/drivers/net/mii.c
+++ b/drivers/net/mii.c
@@ -84,15 +84,16 @@ int mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd)
  		ctrl1000 = mii->mdio_read(dev, mii->phy_id, MII_CTRL1000);
 		stat1000 = mii->mdio_read(dev, mii->phy_id, MII_STAT1000);
 	}
+
+	ecmd->advertising |= mii_get_an(mii, MII_ADVERTISE);
+	if (mii->supports_gmii)
+		ecmd->advertising |=
+			mii_ctrl1000_to_ethtool_adv_t(ctrl1000);
+
 	if (bmcr & BMCR_ANENABLE) {
 		ecmd->advertising |= ADVERTISED_Autoneg;
 		ecmd->autoneg = AUTONEG_ENABLE;
 
-		ecmd->advertising |= mii_get_an(mii, MII_ADVERTISE);
-		if (mii->supports_gmii)
-			ecmd->advertising |=
-					mii_ctrl1000_to_ethtool_adv_t(ctrl1000);
-
 		if (bmsr & BMSR_ANEGCOMPLETE) {
 			ecmd->lp_advertising = mii_get_an(mii, MII_LPA);
 			ecmd->lp_advertising |=
@@ -171,14 +172,15 @@ void mii_ethtool_get_link_ksettings(struct mii_if_info *mii,
 		ctrl1000 = mii->mdio_read(dev, mii->phy_id, MII_CTRL1000);
 		stat1000 = mii->mdio_read(dev, mii->phy_id, MII_STAT1000);
 	}
+
+	advertising |= mii_get_an(mii, MII_ADVERTISE);
+	if (mii->supports_gmii)
+		advertising |= mii_ctrl1000_to_ethtool_adv_t(ctrl1000);
+
 	if (bmcr & BMCR_ANENABLE) {
 		advertising |= ADVERTISED_Autoneg;
 		cmd->base.autoneg = AUTONEG_ENABLE;
 
-		advertising |= mii_get_an(mii, MII_ADVERTISE);
-		if (mii->supports_gmii)
-			advertising |= mii_ctrl1000_to_ethtool_adv_t(ctrl1000);
-
 		if (bmsr & BMSR_ANEGCOMPLETE) {
 			lp_advertising = mii_get_an(mii, MII_LPA);
 			lp_advertising |=
-- 
2.26.2

