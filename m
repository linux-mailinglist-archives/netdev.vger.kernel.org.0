Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F292E8BED
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 12:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbhACL0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 06:26:33 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:49277 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725889AbhACL0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 06:26:32 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id B76CC52C;
        Sun,  3 Jan 2021 06:25:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 03 Jan 2021 06:25:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=s0u0iw4NXUklB
        tchF6xGq/pKW5YBdSZTP5OnSimeOLk=; b=sphcgAim3lcd6mwB/ux61x4dTrkfg
        riL2UosJfHrVDA3nrTZm/VQByJEdHkHLF2VT0oihehi7ZTN5UBGWL0YqXaTUrdLZ
        pfbKkX8nJY/NQT24y/P4vOBtSaA8V5l8ab2iV0uERBTJb3QQMM6mAkj9rR2hVa/G
        RdsMEsPxCl1GANlkQ69/7WEW1x7HonErpGlxI5f7frgt+tI0LVGEWp/COwNYTpu1
        qtJBRxxOiyhvZXkH0PXBlNCAo5Ei1JgKJhzByccJa3lic1tiCaxW9V/CYvPLvwAG
        Wz4naIKj/ZCKhb8zd6A675/ZNux0Epy9asxJTi2mOIgGOovKo11nJRvmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=s0u0iw4NXUklBtchF6xGq/pKW5YBdSZTP5OnSimeOLk=; b=VgHTlXKh
        p5zz+qBdWN4xn2ejP40GDXG7zn2WtPFCwSloSalpwhqtkjrVD8SWxjv/WZGPeGrS
        yq3Hk3o9bCXo3XFINMFswEDFZXPDAR0PEJH1dxtKHmf282nf0gBfzvEVl5VI0dre
        ojL/mQQDXoBxfK0/AiKi6pQp7oMCakrYGh9x8mKVzX6EjPHYuzeL9X2+jKn90ckO
        3ko/FQb3E2eYjy8Ws8Hd5tujuwh5edqRIzR+voa2CrvI1fUr6dKv/hjIflyYPnw5
        O5/0X0SFyjcseRcRYwnEzQlplVwrekFbaEsuA99bLdvATPB947uoTepjFD6MSFWw
        uLOGvxPaVVf0ZA==
X-ME-Sender: <xms:uKnxX-vbS9eZgixvuwba8JHOgRRc5GlYNXRDx92Y7G-ejlg7os7cYA>
    <xme:uKnxXzfhe6GHTkev5vjrMeDS6Mmp5RGCCgy6qcZhar3Myg6W_ansFt5FHqkFAMRZp
    dAjSa1ZxdtIqjD4XQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefuddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeduhfejfedvhffgfeehtefghfeiiefgfeehgfdvvdevfeegjeehjedv
    gfejheeuieenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:uKnxX5ymKla8i5QxKXOoWsfXlVdlHL-8d7fcldqZI9mr4eRXsJr-Ig>
    <xmx:uKnxX5OEjCbNWL7bnCUYP_p_09iyBgdeBfy18qn73LP69WroeZWoqA>
    <xmx:uKnxX-9IuJbsPqDyctWQY0AjzMuKwL6OQInRPoFBc8UOh_SygZxsww>
    <xmx:uanxX5UYW5vN9udDstM3KAh8pBXUAS48d-1hp4tjo6os5wrs3i-maNi11fQ>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id B2BCF108005C;
        Sun,  3 Jan 2021 06:25:43 -0500 (EST)
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
Subject: [PATCH net-next 2/5] net: stmmac: dwmac-sun8i: Remove unnecessary PHY power check
Date:   Sun,  3 Jan 2021 05:25:39 -0600
Message-Id: <20210103112542.35149-3-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103112542.35149-1-samuel@sholland.org>
References: <20210103112542.35149-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sun8i_dwmac_unpower_internal_phy already checks if the PHY is powered,
so there is no need to do it again here.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 8e505019adf8..3c3d0b99d3e8 100644
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

