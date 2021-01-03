Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544FE2E8BF4
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 12:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbhACL0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 06:26:55 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:35751 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726686AbhACL0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 06:26:52 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id C195D548;
        Sun,  3 Jan 2021 06:25:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 03 Jan 2021 06:25:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=+FVXHJywYn5HO
        +Q77R6/9hCLYI494XIlo4EmogXhRdk=; b=PfPGRuggemNVUlTt69LBqOFkYHinX
        a5BFY9pKFmvRoRw6LJppKoyYMBTpbpHP+8vrP91bXsOXjVbp1Is3ywpytwN2WbKs
        yOGCWMKqYeIxuS224gTeszjz+fnD+9F2i1MB5Am+mPI7x6X3DOZJNq14gynGS56X
        AMm1TOOLBHznQo8tb3ujB7SbmczQwEI7uKJUie7/6gbeCBIoJo0uifV1oxONqDQF
        5VKMSdYWf1XG5+hTQMG01+EpUfP/rO2IjZ2JEriOc1x5fAwLxsP0y2eybMMXLrfN
        YyHG2/EMElSBh+FCCzlSC7wSnbXnkJJm7Rmuw5lXrzciAjO22KtIZjCKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=+FVXHJywYn5HO+Q77R6/9hCLYI494XIlo4EmogXhRdk=; b=Ac6pZWA6
        eOWbsT/9McwQafA8yumTCGoGusZkn2MDhONWamLvNCB+Sl5CzRF7Dy0iET6tACYC
        BxWvSYIkDZhozOn3jtTp1dkzEyNfw24rEyyS1fvvQ7k/05f7Y0bkBOlHFKjfMvIC
        /wMQTQwrcplywpXScgrP3dACJRj/4jECy31U6C7KU0S8aDDuDYNqvyfp8fLKxxeK
        kcWSMgYlDPFdEf2mrYIUDTPxWLKHWIqD6+0XRq8o8OEcB5qG1HXIlplUN8OgAbVi
        DO2zaWOjS19fMUWvlLRAaO0ZPWQzosGhf7EPTqiejYGLY9psTXw+1TUxLPQsYwCo
        NQ1mWmXOW+TRyw==
X-ME-Sender: <xms:t6nxXz2NheJW_u_Bt0MqHC2kTgdoO9pMouAmtlUajU5bgR8RgchuNQ>
    <xme:t6nxXyEN9NEjGa-2qBXq5V3sTM1kKmi9E7PslfS4p9NfBWABWAGTw337OJWS5txh_
    SXkDLhR4GxeoFohJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefuddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeduhfejfedvhffgfeehtefghfeiiefgfeehgfdvvdevfeegjeehjedv
    gfejheeuieenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:t6nxXz6VgVhnSegLQvz2RmxRe8VZ0uZWPKGtOJCgO1Q7saipODy1IA>
    <xmx:t6nxX42rTbmf5SMKyBm3zKsPwwC8S9xdDsk822bFmN_FJViZ7SRFLg>
    <xmx:t6nxX2F9cla2pzKJ2BB-Opoo-lhiaprQ6mIcJMI31MAIHN0VhYAZzQ>
    <xmx:uanxX9dDWkokoGfNsweS1qNYVvPqh5XT1_kSczflspmZjOD-rT59BynOfm4>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 258F3108005B;
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
Subject: [PATCH net-next 1/5] net: stmmac: dwmac-sun8i: Return void from PHY unpower
Date:   Sun,  3 Jan 2021 05:25:38 -0600
Message-Id: <20210103112542.35149-2-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103112542.35149-1-samuel@sholland.org>
References: <20210103112542.35149-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a deinitialization function that always returned zero, and that
return value was always ignored. Have it return void instead.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index a5e0eff4a387..8e505019adf8 100644
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

