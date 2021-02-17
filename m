Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C17831D492
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 05:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhBQEWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 23:22:01 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:49197 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231196AbhBQEVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 23:21:13 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 70600580379;
        Tue, 16 Feb 2021 23:20:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 16 Feb 2021 23:20:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=OhQXn3RW7Fq5W
        eW0YK8stGZwIJtakGlXtoagEETPVuo=; b=qoE60RQqZ21sHfSUKGIC/fJqsB9c5
        JLsjRbftMIjxgXG/ts3LQ/1pJhcXTQVh69mrprhXt+86Tb7/AmPZmxYP3tyW/42d
        sV0iTbePstr5lTOZrxy0hTCdL/oaqqJ7eTWAdwZYtwzQaJtnnQFKkBghFEzM9dyy
        blbONK0FFXcJ2OFRUax16yzOKXZQQ7wZ64rGotg2WUrL3LnaXvM9HqjSpQH7teq6
        YV+lAupP4qLLhgUE1+f6+hAMBCcH2jtwxKAGIdqz/1RiR1dLZ5aDfagRaspUclIl
        fMkJww20JBBG788xf3KlaKKyTLuwzJMCdo+mCRRp6E7ZfrDVhJN5GdgTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=OhQXn3RW7Fq5WeW0YK8stGZwIJtakGlXtoagEETPVuo=; b=iIrmR/ut
        BXb1/NPJptHndtb32v18Z6QbJWQzkTmsE0VqqVviJv4b3EChctquJx33xboJ3shK
        A87AV+HWXEJill+eSuOKi75C54MHXedpqRvCE2BHhC+vB2+ZdeOeQC8FbRj47lVc
        qtYHQo88LckJfu47l7ZprYGeQB+56oEzU9p2M20DX4yX4Ta/DexZhk1oqhnx+yS4
        SOG5c7gF2o2NYQBAewfCX4ROfHjLIg+wltx6s79AmObKlQCK757DV8FFs5x73fi9
        byobBoWbhpAsp4e9TL4sNqzNmLWMylOqIH/ZOREIMMzRidl1ANn0Q/nijnCj//aG
        8FjfjBpwgVIJEQ==
X-ME-Sender: <xms:eZksYBB_p24t7LC_98qPrOaTJJ9utJnkjrN-ywjjk9ed9-JCSmTSxA>
    <xme:eZksYPiVL-QvyYRHIdVjU9fEYUpFJKHQwxHRDFW8AqJUcxmjoGBi-y3S13DbomJut
    -mrQlDMZMIGCZs8VQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrjedugdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:epksYMkCADGGi9jv1BBnIQkKaWDMIe9hdhIThTI7OBsry_RHYmAasg>
    <xmx:epksYLwxsQMwE2nCgMMG4jjUrUjOO2Aw0qfRlMd0WlsVMynFVzhZTA>
    <xmx:epksYGTZtOJbaL-XgtK-OyPe1up-bppy76EQfOCuVxHF8HYD4D2udg>
    <xmx:epksYNJjs1hS7mSbJWk3gM7YbP49-1UFjGaaCRBGzOoATWImbyL6Mg>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 692C024005D;
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
Subject: [PATCH net-next v2 4/5] net: stmmac: dwmac-sun8i: Minor probe function cleanup
Date:   Tue, 16 Feb 2021 22:20:05 -0600
Message-Id: <20210217042006.54559-5-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210217042006.54559-1-samuel@sholland.org>
References: <20210217042006.54559-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust the spacing and use an explicit "return 0" in the success path
to make the function easier to parse.

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index b61f442ed3033..a3d333b652836 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1229,6 +1229,7 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 
 	ndev = dev_get_drvdata(&pdev->dev);
 	priv = netdev_priv(ndev);
+
 	/* The mux must be registered after parent MDIO
 	 * so after stmmac_dvr_probe()
 	 */
@@ -1247,7 +1248,8 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 			goto dwmac_remove;
 	}
 
-	return ret;
+	return 0;
+
 dwmac_mux:
 	reset_control_put(gmac->rst_ephy);
 	clk_put(gmac->ephy_clk);
-- 
2.26.2

