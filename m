Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F88C29AB19
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 12:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750177AbgJ0LsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 07:48:01 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35854 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2899541AbgJ0LsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 07:48:01 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201027114749euoutp02e3cb0e5a8c414f904dc68dcde1df8ac0~B1vA-xVKw3036430364euoutp02M
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 11:47:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201027114749euoutp02e3cb0e5a8c414f904dc68dcde1df8ac0~B1vA-xVKw3036430364euoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603799269;
        bh=+6TmqewcngAaw1AzJXeK9FrivbLzGJcUPqOJsaqXGzk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=biCL/9tPuCUIulmi5qTHS0Je5mXR8oinFd3Reqo6hYmsYGaBNYlWIIPQMZh7SpYXy
         XPMANpUh6Vc4MhZKEpdvDoJRDIAVcpne5QgmDQ5lIL+Nz6EOZSewh2lUjchV91yAsB
         /tblSSBo/DU3a2W876ocj3uFG0/cVqzJbhgkESpM=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201027114744eucas1p10763432fb308b544b9fc3c14645f93a0~B1u8A200j2024320243eucas1p1U;
        Tue, 27 Oct 2020 11:47:44 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 25.DF.06456.0E8089F5; Tue, 27
        Oct 2020 11:47:44 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201027114743eucas1p23c4a5e6762ce18509296cf23435e7268~B1u7j0uaj1780617806eucas1p2v;
        Tue, 27 Oct 2020 11:47:43 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201027114743eusmtrp28cf53377ebc7de1441612a0a2bf0532b~B1u7in6vp0588405884eusmtrp2z;
        Tue, 27 Oct 2020 11:47:43 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-84-5f9808e02d58
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 63.F1.06017.FD8089F5; Tue, 27
        Oct 2020 11:47:43 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201027114743eusmtip2823c77c36ee11bd84a6d4630ed7904b4~B1u7ZA6ZP0639906399eusmtip2g;
        Tue, 27 Oct 2020 11:47:43 +0000 (GMT)
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
Subject: [PATCH v3 RESEND] net: mii: Report advertised link capabilities
 when autonegotiation is off
Date:   Tue, 27 Oct 2020 12:43:17 +0100
Message-Id: <20201027114317.8259-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRTmt7vHdTi7btKO9sJhoIZT6XWxlCz/mP4R9U+CoLb0ppavdtWa
        BKn5KPOVmZoNEytcko+t6aak1RKn+FbwQVpRYrgwIR/4CMvtTvK/7zvn+853DhwcE+o5Lnhc
        YgqlSJTHS7h8dmv3+qDXV7wy0qfIbE8OzRgxUlPZxCFVQ9lssnaxkkMOtxZxyCmjGpFj7Sou
        aXzcgciGrhke2V2z9wxfNjY+gsl0r6ZYsraqGZ5MW3+fK2szLLFkRbp6JFvSHrzAC+Ofjqbi
        49IohXfAZX7sgG4TS84S31LnTrAzUJ0oH9nhQByDAq2Zm4/4uJBQIyhq3rSRZQTPq7d4DFlC
        0FWRzd2xjI2qMaZRh6C2/xeHIT8QvJ8sZFlUXCIQil/2WBtOxAqC2blmZCEY0Ymg7XMZZlGJ
        iKtgalqzzmUTh6F/ZHQ7EMcFhB+oHnCYuEOQV6e3SgSEI/Q+mWVb8B7CE15nTVgxtq252/LU
        uhIQnTwwmUvYjDkIMjPLbFgEZpOOx+D98LftGcuSBcQdeFR6gvEWIGhVrdn0p2B6cINr0WCE
        BzS1ezPlQDCsajDG6gCTC47MCg5Q2lphKwvgXq6QUbtBY/Fb20AXKDSrEYNlYOj9ySpBrlW7
        DqvadUzV/9wahNUjMZVKJ8RQtG8idVNKyxPo1MQYaVRSghZtv1Pflum3Aa2MXjEiAkcSe8Hw
        QnmkkCNPo5UJRgQ4JnESnB3oixAKouXKdEqRFKlIjadoI9qHsyViwdHa+XAhESNPoa5TVDKl
        2OmycDuXDJQ096cvRKmjA0XmT+KHmp7b+jB9zosowfFx/+aLxsyNjfSs2Ea/Hk3Pu3MfncPB
        teLSlCu3EFbj4xrnOzPcV3M4GeejljvIZveua9/cpA3GYNP38C8TIQdCp7E3a9r5oOC8k+Vi
        5xaPDzWhSmlIXsS6f8Cij5fbjaZsj5zqI14SNh0r9/XEFLT8H/rN8/hKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xe7r3OWbEG7y9rW9x/u4hZouNM9az
        Wsw538Jisej9DFaLC9v6WC1uHlrBaHF51xw2i0NT9zJarD1yl93i2AIxBy6Py9cuMntsWXmT
        yWPnrLvsHptWdbJ57Nzxmcmjb8sqRo/Pm+QC2KP0bIryS0tSFTLyi0tslaINLYz0DC0t9IxM
        LPUMjc1jrYxMlfTtbFJSczLLUov07RL0Ms5u+c1c0CResaLtOksD43LhLkZODgkBE4nLl1Yw
        dzFycQgJLGWU+HC9g6WLkQMoISWxcm46RI2wxJ9rXWwQNU8ZJb62X2QDSbAJOEr0Lz3BCpIQ
        EfjNKLHl6Dwwh1lgH6PE/qOL2UGqhAVSJPb9fgTWwSKgKnHm4iV2kA28AlYSc7pZITbIS7Qv
        3w5WwisgKHFy5hOwI5gF1CXWzxMCCfMLaEmsabrOAmIzA5U3b53NPIFRYBaSjlkIHbOQVC1g
        ZF7FKJJaWpybnltspFecmFtcmpeul5yfu4kRGFnbjv3csoOx613wIUYBDkYlHt4Lb6fFC7Em
        lhVX5h5ilOBgVhLhdTp7Ok6INyWxsiq1KD++qDQntfgQoynQNxOZpUST84FRn1cSb2hqaG5h
        aWhubG5sZqEkztshcDBGSCA9sSQ1OzW1ILUIpo+Jg1OqgbHINbiz9Gf0MdfQllzhkv0xk28u
        C064qmcj/Xry7rXBbfXXvdemqp1/sf3iJhfP36eW/j70mLHW6MNMlbZmc38+yQKdLZOTG1TE
        zUWZOX6G7rjV75yaPl+/ckb3mVZLsT/7n4Y0GiznYSzY3Pp84uT9k6ManscWr1j3qaBLytBh
        ybvc7N08r5RYijMSDbWYi4oTAYXQXsLCAgAA
X-CMS-MailID: 20201027114743eucas1p23c4a5e6762ce18509296cf23435e7268
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201027114743eucas1p23c4a5e6762ce18509296cf23435e7268
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201027114743eucas1p23c4a5e6762ce18509296cf23435e7268
References: <CGME20201027114743eucas1p23c4a5e6762ce18509296cf23435e7268@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unify the set of information returned by mii_ethtool_get_link_ksettings(),
mii_ethtool_gset() and phy_ethtool_ksettings_get(). Make the mii_*()
functions report advertised settings when autonegotiation if disabled.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
Resending according to last Anddrew Lunn's request last week.

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

