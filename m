Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9DB31D498
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 05:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBQE0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 23:26:19 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:47597 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231218AbhBQEVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 23:21:15 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 599C0580376;
        Tue, 16 Feb 2021 23:20:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 16 Feb 2021 23:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=n2MqGhQ5o4Ylt
        VCPJ1jY0hzOaCnyziRkK7pQjX/OSoE=; b=bdWVV8mYOlJeYKBDDjEBZE1OZGm/H
        VyVacPJAcKwStlWAYmVO4J0XEKavxZyFvlUqZ2O/geyoI/nJEWr5Cm/e3euGhGaj
        Da4hSRGjKmMIuyA8by20VEgXb7Es5I7lnFl7Dgy3Q4wEp4q4x9IjOfUFgcMLmhyr
        DJMyziqKAqBJWaH/2HWnAwcFIagsAvT51DnQ1TA7qUYjUAjtjmY/U+lRfieSKxmG
        SBCkrJOLfcEVci0dL0Gb+oOv/Me/5gqAAukOqpVopXojgxa77XcBn3F4SHc1k9aU
        m9xDmgornL/t3byZL1CMLxwoJxnS3LKR+kmYmaTK57hJD/z0yooZETBQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=n2MqGhQ5o4YltVCPJ1jY0hzOaCnyziRkK7pQjX/OSoE=; b=j6p8JpPl
        us5XEIAth3QRuQQxrso0QlVc5oXFivMY87+BZ/HSYvR2dOV/4b9XREtOnqGh/mm8
        G5tZxWdzbJTG9xh9LRhsvPWMDbyDrvRg4RGGDeH5B4SeyAGi/xU+h1Qak9LVYyJF
        gULM8XgoGrz+UIk/83zbHf7snVojKcfW+9J9yr+ZsCKHVdrwADPMH8bcmN31RWpn
        AQiKBdugfr72dJ8Wuh4tuudumrxR2WmngtH657WR64uYPGFBBCx96eZZkFaKFw/p
        l6UA0ZBLFd/vcWMfNp3NVp+TXyQByV7gQn/v2tyVPnoJ/ntqe9PohzzUXMts+3yB
        DruiMqX/vkx6ew==
X-ME-Sender: <xms:eJksYJGWrFi6LiU5BLZ7FxTlzD4MtvBCeJ4r1Clj7SkYbSdGvCyRIg>
    <xme:eJksYH8UAzhnHDXpYRLTdKRdJlVYePeoj20RkS0V2EHZqn6bCUzTjLq1nx_TfcXUZ
    YVhtt1KLeux-J87Tg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrjedugdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:eJksYLLLn1aWNEQpWWAS2nyB8_S6RUO4yVMb2rT7tMp1y1iCqxUxjQ>
    <xmx:eJksYCavocv744IkKW0OaM_N3JdZu_6MS5w700-GaBk9k4P42LGk8w>
    <xmx:eJksYNI6Bksuz0Ucul-MR1MrGOPR92DYPbMDMb9BT7D7fJcl1CbB0Q>
    <xmx:eZksYHclIkTR3pUIVqASgStNA528wnab_O-eIanWVhHXhlBlhY2CBA>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id AA6AC240062;
        Tue, 16 Feb 2021 23:20:07 -0500 (EST)
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
Subject: [PATCH net-next v2 1/5] net: stmmac: dwmac-sun8i: Return void from PHY unpower
Date:   Tue, 16 Feb 2021 22:20:02 -0600
Message-Id: <20210217042006.54559-2-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210217042006.54559-1-samuel@sholland.org>
References: <20210217042006.54559-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a deinitialization function that always returned zero, and that
return value was always ignored. Have it return void instead.

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index a5e0eff4a3874..8e505019adf85 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -820,15 +820,14 @@ static int sun8i_dwmac_power_internal_phy(struct stmmac_priv *priv)
 	return 0;
 }
 
-static int sun8i_dwmac_unpower_internal_phy(struct sunxi_priv_data *gmac)
+static void sun8i_dwmac_unpower_internal_phy(struct sunxi_priv_data *gmac)
 {
 	if (!gmac->internal_phy_powered)
-		return 0;
+		return;
 
 	clk_disable_unprepare(gmac->ephy_clk);
 	reset_control_assert(gmac->rst_ephy);
 	gmac->internal_phy_powered = false;
-	return 0;
 }
 
 /* MDIO multiplexing switch function
-- 
2.26.2

