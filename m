Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DFE31D499
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 05:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhBQE15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 23:27:57 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:34083 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231185AbhBQEWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 23:22:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 89A7258037B;
        Tue, 16 Feb 2021 23:20:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 16 Feb 2021 23:20:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=/Ll9sOu6/aNt8
        sKVthTKqJ9f/C+c6WcSRYeGV0Onyhk=; b=IcCMWw+oIFDwum354Zkm3Z/pcQJ06
        ZI+zzhRgnmzqSSEivC6y2fhlJ1uiigjNjUBwwzbyNdXgX9XX7vquCYo2jU7h0hWk
        fVkVYBGhMFwoQ/8Iw/WUSSpfvJ2vdV8TY6wUsiAWsYRAjsgSCVwr3FMaM7GQw/mt
        zq0s11o9WRfh43LxexLB6T8sdWJEEOIphZKmCP34DRAoJ4UNwFKvtOlgq8D8Fdf5
        WLENXI5nmD9AGe0mDUfz2/IzSaHOiSeqxNeWe2m/GiIALhDhmmwh+Tbw1z7td8L7
        InA/KqNOByil73kSoWoBQ1tLHLRCCpiX64TbrjTdh8wKdayB3oKQWWFmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/Ll9sOu6/aNt8sKVthTKqJ9f/C+c6WcSRYeGV0Onyhk=; b=FIYYxLsR
        gnCz93LHiPBAQVKUjCg1/rC6m8VIu1YGLNNhaKJdy7+PzIC5yl2tCxTcRnrW0sSv
        Ix5tbGdaZ1Elle9p8JCvI4aWZGNK/nJTyPrsA+pX7x5OrzlAXWk12mvkqFu7JmU2
        dYrpIYTrt0a/HJR1/aKI2aFVjDXCEyK3Chgps5T+aRDl88jhdd9jsAD/1qSHeeQu
        64YWZmF38J4Y63JMYLlxUXXUH+NeYeIFYWVwscuwcxu0UX9A5KkkmHeDKBRvZjFf
        xrFZIuSYwIRjbehJ7rRBDUqso98ucPGAu8FSTnAaUu2saz30+l6JyNhiyi51jmP9
        hF2nrKxCFnqlVA==
X-ME-Sender: <xms:epksYB5vemyz7r1hTepmDn6Xczf0kQQosbVOOzt_o0kINq51dQ5olQ>
    <xme:epksYKbWsEZjuPXSN21r6kjqx2YqnyOmUsjodAPdM-B3EHkm8DdDYIBdTYPLC25BU
    1C2XROpPNiWjMWLEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrjedugdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:epksYO6yzVRsZhAG92J7Kn4QrByI3nUH5rSuT2xSAL8fiCIy9QShkw>
    <xmx:epksYFDA1HZ8Y1PI9rzX1WewSwISO_GXoDc46KlFrYxAm-0bnPtupw>
    <xmx:epksYMcbGmsYu_5hS2nCKBt7OY4nByqi7pABPk-kgSgA71JG4GkFPw>
    <xmx:epksYPkRTfBhtmBkqotxXMuswpNc4SKxNtIyh9ER8hrmDJ6y-P3XaA>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 015A2240064;
        Tue, 16 Feb 2021 23:20:09 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>
Cc:     Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Samuel Holland <samuel@sholland.org>
Subject: [PATCH net-next v2 5/5] net: stmmac: dwmac-sun8i: Add a shutdown callback
Date:   Tue, 16 Feb 2021 22:20:06 -0600
Message-Id: <20210217042006.54559-6-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210217042006.54559-1-samuel@sholland.org>
References: <20210217042006.54559-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ethernet MAC and PHY are usually major consumers of power on boards
which may not be able to fully power off (those with no PMIC). Powering
down the MAC and internal PHY saves power while these boards are "off".

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index a3d333b652836..6b75cf2603ffc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1284,6 +1284,15 @@ static int sun8i_dwmac_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void sun8i_dwmac_shutdown(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	struct sunxi_priv_data *gmac = priv->plat->bsp_priv;
+
+	sun8i_dwmac_exit(pdev, gmac);
+}
+
 static const struct of_device_id sun8i_dwmac_match[] = {
 	{ .compatible = "allwinner,sun8i-h3-emac",
 		.data = &emac_variant_h3 },
@@ -1304,6 +1313,7 @@ MODULE_DEVICE_TABLE(of, sun8i_dwmac_match);
 static struct platform_driver sun8i_dwmac_driver = {
 	.probe  = sun8i_dwmac_probe,
 	.remove = sun8i_dwmac_remove,
+	.shutdown = sun8i_dwmac_shutdown,
 	.driver = {
 		.name           = "dwmac-sun8i",
 		.pm		= &stmmac_pltfr_pm_ops,
-- 
2.26.2

