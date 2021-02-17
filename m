Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761EE31D48F
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 05:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhBQEVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 23:21:22 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:54133 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231195AbhBQEVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 23:21:13 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 47724580374;
        Tue, 16 Feb 2021 23:20:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 16 Feb 2021 23:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm2; bh=OdOwRMbhjRgte
        /bLoZP0VS2UuOzAJR1c1RX9afQgw+k=; b=awSL0WIhHp0aMGesl//hxx3CGq4JF
        hI0dIO+pGWIE1lNy9lXcFVlm84lQOql/rDMPTr8s69B741sON3AzaPd+fEgmtVdn
        ohcZ/Y0ffPZEdcDuuM49m8uBx5+Y64CrKAz2sv0m0QEoVc/xawlnfIg+MI3y+ks8
        KiZ5JFFzoEXDloB1wjgMPPo/MZmh1LrdNl5WJHRbB1RSz7m04OLKuZGvemc9/I/e
        E1xhdQP8hKZdYPXBhCrNUhEvgTqq5xrZcv65+CzJMwj9/feMNAg58r4UPRn44hDH
        tajHnjIqzsOBJWcvHXchVqNvdzC5LYScprFsgaBwgIOoFZrVj8NO+BHmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=OdOwRMbhjRgte/bLoZP0VS2UuOzAJR1c1RX9afQgw+k=; b=uWOk9hDG
        4QxAgqSZ1Kd60sXXxFouoc8WUrta0lHAN6d9obSZL1C0254qdQA/K9PVeGSv2LUZ
        +3Kx4oxAyKp8KGUJ0bLptfwIt5lmhWsyH9GhUSYAfBm+M2ELfDDwTLVqx964ch6a
        Rz92s3Mvx2iglGtu9giMiVo5gEritSFfUpNdFcSl8YdMUzDDaliaAPyR9kV+AoZ5
        1cSqIdKSyeEc/HgYJQUjkpasH/bkhGon/2SR3XUqbCzN3MQkTtVUh/GRhLvgcGml
        R6tofDRQfaDGeradgl8FEMnDESwdbIhNbQz/qQP31gtBS50EVJcYCZaWSe4aJtUa
        ZXynMqrzNklVyw==
X-ME-Sender: <xms:eJksYEmyjuBfrOfezj6jd1nVJWDuYEsx8p2w0O8wsuBh2G5O0LxmKw>
    <xme:eJksYDwAseKkt5hhBgCstdh-nlQrjnEV8Vu8z9X9fWz6a9U3dBCoFNiXaCrGckAV8
    3yNp9sRSkqF9_US2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrjedugdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:eJksYPj2B2xsaERFV1UEaZyFuANb3z1up736_jNfReHYTGQRwMDObw>
    <xmx:eJksYIXkkaUj2L6iAIfuBSByDbC7Ik98mriovrcLrDajTj0ribiL8g>
    <xmx:eJksYB3UCKLI3RZ-eX7LbqBtTMOfjrbpGYR34NXB18uPuCC4IsFRog>
    <xmx:eZksYKj1kHCRg_F_WyPncdyZb1omV-Tlvkak7TvH5jI1u3d40SuYcQ>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 45A37240066;
        Tue, 16 Feb 2021 23:20:08 -0500 (EST)
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
Subject: [PATCH net-next v2 2/5] net: stmmac: dwmac-sun8i: Remove unnecessary PHY power check
Date:   Tue, 16 Feb 2021 22:20:03 -0600
Message-Id: <20210217042006.54559-3-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210217042006.54559-1-samuel@sholland.org>
References: <20210217042006.54559-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sun8i_dwmac_unpower_internal_phy already checks if the PHY is powered,
so there is no need to do it again here.

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 8e505019adf85..3c3d0b99d3e8c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1018,10 +1018,8 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
 {
 	struct sunxi_priv_data *gmac = priv;
 
-	if (gmac->variant->soc_has_internal_phy) {
-		if (gmac->internal_phy_powered)
-			sun8i_dwmac_unpower_internal_phy(gmac);
-	}
+	if (gmac->variant->soc_has_internal_phy)
+		sun8i_dwmac_unpower_internal_phy(gmac);
 
 	clk_disable_unprepare(gmac->tx_clk);
 
-- 
2.26.2

