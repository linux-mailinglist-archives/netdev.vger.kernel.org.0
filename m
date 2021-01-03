Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C152E8BF0
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 12:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbhACL0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 06:26:39 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:38673 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbhACL0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 06:26:33 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 4BA8D559;
        Sun,  3 Jan 2021 06:25:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 03 Jan 2021 06:25:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=0jMm0S9SFKrwV
        SbdgBC8QS4qosT0AHHQhVFIOD733mE=; b=dVSFOhyvJ5+f1s1NtlmtNQFbFRm10
        oY49OrmV6U3T/IiCJMxBV3IKwUtHYBuPmSt/2Ct3zUM4HuwhmbRYEqRiz6aByd17
        nc/2dMsXNkdr0sWgqB+ihdfXvyyGF19VTdO4SyhuU/4YWyrWg2bb1md+aF9FygTK
        wBPSsrVQih3TxcmcahyiKFHDtxpCA5llMv2/IiMe5GxoUK5XIyJW4FoRelds4+B8
        yvw+O5570zNZQLNN2G+3uBVAGdG5zjliCRiKzdg+Btq/q8A2Tntbn31GyEIQKdr+
        Cff5g9x2VfexswyPgtS1kLXFPzfNVWKwiXLVimweEIFy4KFde875RMgfg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=0jMm0S9SFKrwVSbdgBC8QS4qosT0AHHQhVFIOD733mE=; b=YzoJWflS
        I2cVnsGvTjyYmD5+jt00BuB0PPvAm3o3jpu0+CqUJwu09sVTVVIDMqOfr6owdbiw
        cbo7IELcbzJBT3r6QTsEfN+tvI04T0Exb2K8+WIuW3bfwjO2475tpxOLNd2SCX+h
        0ZSu+10MzoD2oNGUtuJqX8pgXu4sO6y4sAout1LbFCpzRHmA1yzliXnprnARiT7X
        2kZZc4rj3RbFz6dK3ypVYoQ+RUaNBOT2w1TxYT88t/SEubtOn5iGSz6TILDy2XEw
        igCK9Svn1ZVn2wBkaDpP3vweKlqOH3or15SDjKewtiWpZk3zQdX2otwMeHkbUwdU
        +VZOfuFdgzfHQw==
X-ME-Sender: <xms:uanxX0LFvWmZjZKFRdDq0Z-noD4ztJqDx-bje2k197IanQPdPncb9g>
    <xme:uanxX0Jl1OG-ZLCoO5FGpIRY0mnBjy-oTBcF1nJu0QNxfDVgEyGC41hO97oMUmLH3
    _KG3lGrLS3YWmKezA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefuddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpeduhfejfedvhffgfeehtefghfeiiefgfeehgfdvvdevfeegjeehjedv
    gfejheeuieenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:uanxX0vBoIYoZAVcnmSRgsvJ2HcIpL7_eYTidl-hVgwi8xaEVXGcsg>
    <xmx:uanxXxYbI0AYijojcO45AibXYX15FqxMRo2Vkzyi2ibS9eztcrXRsw>
    <xmx:uanxX7YQ1CG3UwKNCXkkjznVUkadpgNQPP_gwiHuT46R2OpZ7Gf7cA>
    <xmx:uanxX_S0VFD9WNeydrNnqB3tBzUQzdlauj5BMh-SL9Oo3B-p6DJB5YLFDD4>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 25BA41080063;
        Sun,  3 Jan 2021 06:25:45 -0500 (EST)
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
Subject: [PATCH net-next 4/5] net: stmmac: dwmac-sun8i: Minor probe function cleanup
Date:   Sun,  3 Jan 2021 05:25:41 -0600
Message-Id: <20210103112542.35149-5-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103112542.35149-1-samuel@sholland.org>
References: <20210103112542.35149-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust the spacing and use an explicit "return 0" in the success path
to make the function easier to parse.

Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 0e8d88417251..4638d4203af5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1227,6 +1227,7 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 
 	ndev = dev_get_drvdata(&pdev->dev);
 	priv = netdev_priv(ndev);
+
 	/* The mux must be registered after parent MDIO
 	 * so after stmmac_dvr_probe()
 	 */
@@ -1245,7 +1246,8 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
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

