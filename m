Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0442E8BF2
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 12:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbhACL0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 06:26:54 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:43401 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbhACL0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 06:26:52 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id B8381542;
        Sun,  3 Jan 2021 06:25:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 03 Jan 2021 06:25:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=xMlquvf3yzLui
        EN8mbFrfPmz2sg7YCp1DdhC7ccdm/c=; b=eEIciF+9rZgKJxlYNf7F6ftlaJ58l
        wS8D5yUbr9D9PZdCHxFpjB9GWls0UA+CeMDMeByNw8CWMBL4FAasZ7aR/IjCQsCG
        pzgziJgSpLEPDkvbX1XsFrg1/kyqM9PkFAt2EKbModk2saX4eN0P+d3Be/kzAJ+z
        CJqw93xmBkjgRVgWlOM0IWVpEBRQA+FgTHYVM1gRWDdLwVVYGVp/2+BKltsygA4y
        xg75/UxU+Oujdnw5ZhjHJQFgi2FN4PgoJh6ky6zk+X4XmyfKMfTMNC1WelZybvBQ
        WjSABS2J3rbaF4T39VqtqTUNWMGjjaxpFS14saOr23t1kIaF6pljUmIWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=xMlquvf3yzLuiEN8mbFrfPmz2sg7YCp1DdhC7ccdm/c=; b=DcyZIdxT
        DDpLLCCnPKy1f1Zo5+SvZ6iiImF/OsTyibXoMKd2ok2aEgxl3HlGmC/rUNE+AfYa
        bg/sTK+5TSeSpmIYFWkHA995xsy5LydpVisFwedO2v6VX5ZiezYpAzBSsy0SJMJt
        okYBL3dg8waK2zTuXFM269nPI0v66NA6cFeM7i/lMKQZfWtwKDKkTyPGleav4GH1
        NgDNoq5cJZYuMhv+UBSzxFJKPsw4DS0FDrYRuZf1gOu93KJzNxHnIkIIdVBiOr4E
        147g25gT7PNoA6S09mKZUVlkePR1Fl260l2Cn/x6ZW3JWr1UFHnlaV101BXH6QdK
        Gi94FinsYY3Kjg==
X-ME-Sender: <xms:uanxX5Z4RqT5tLThJSQ_80inu0esvzkeRM8ioBYOWWKYlSqyc5ldXg>
    <xme:uanxXwY4lsj5T1L0IeWM88-H36a-H-ZlFmq9-40vjW9v83VMNEF4LceFSac1iHlGi
    GK_ImO8HyS5gUlvbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefuddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeduhfejfedvhffgfeehtefghfeiiefgfeehgfdvvdevfeegjeehjedv
    gfejheeuieenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:uanxX7-WMy8VXijLtVkzhsoqHrmyJv4BcX6pta4JgGFIwWaGDKgq8g>
    <xmx:uanxX3o1XlE2RIP-jV-NNeywA-LCyJJQL-MXjlWZh_PQG_S4N4topA>
    <xmx:uanxX0ol5J3WA5Q8oc1ZWN63XDpfv6-PgSxxfAAQf6zelJlnoosaxQ>
    <xmx:uanxX6iCylJ6WmItoJO70FsACWTrPHUjFYuhbRkvnZCIDIKQVhb_vKBdsLE>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8B2C0108005F;
        Sun,  3 Jan 2021 06:25:44 -0500 (EST)
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
Subject: [PATCH net-next 3/5] net: stmmac: dwmac-sun8i: Use reset_control_reset
Date:   Sun,  3 Jan 2021 05:25:40 -0600
Message-Id: <20210103112542.35149-4-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103112542.35149-1-samuel@sholland.org>
References: <20210103112542.35149-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the appropriate function instead of reimplementing it,
and update the error message to match the code.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 3c3d0b99d3e8..0e8d88417251 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -806,11 +806,9 @@ static int sun8i_dwmac_power_internal_phy(struct stmmac_priv *priv)
 	/* Make sure the EPHY is properly reseted, as U-Boot may leave
 	 * it at deasserted state, and thus it may fail to reset EMAC.
 	 */
-	reset_control_assert(gmac->rst_ephy);
-
-	ret = reset_control_deassert(gmac->rst_ephy);
+	ret = reset_control_reset(gmac->rst_ephy);
 	if (ret) {
-		dev_err(priv->device, "Cannot deassert internal phy\n");
+		dev_err(priv->device, "Cannot reset internal PHY\n");
 		clk_disable_unprepare(gmac->ephy_clk);
 		return ret;
 	}
-- 
2.26.2

