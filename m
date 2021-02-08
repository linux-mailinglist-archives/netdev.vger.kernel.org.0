Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85297312ABA
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 07:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhBHGbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 01:31:48 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:48879 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229784AbhBHGah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 01:30:37 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id F17D058021E;
        Mon,  8 Feb 2021 01:29:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 08 Feb 2021 01:29:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=99nDwIDYp/GCl
        fWRHK7X+wEzBpp6sch5zVozu7busRs=; b=V4S7YOjqHaQ9rAddwCoAPp2ieEv+i
        rSb/VGZULwUEzcD2wrvUHgANYLIyjDQEQdbVVtkBBgrLGzyMIvNIGkXGQn0aVtN+
        Xa9FUd0M3e2jCnrojYJ8MhiFcOok8EJtWJYFoye6S9t4PFRsHKvzy6EN/1GT01Wm
        zLXKF0QnVl0me6x6moD4ZYXUr+hpb2e4tG2l/vNzFwlSWd7AoB9EGqBDETqgyfoL
        EPDCJhAaInVZOL4rXHCN0lr/BSB2v7GsnBXBEOzeVwQxJS/t+eF6+Xi4h50WxfNy
        QW2SIsY+0bmU2NdWA7mupEYOZoKUCxup1EfIDtkL/oxGeYagWifvlVd2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=99nDwIDYp/GClfWRHK7X+wEzBpp6sch5zVozu7busRs=; b=LRUVjT5W
        gszhJ9l7fXpwW1gwmLcNnkFtyT7IVij5aVePuSuPGqT09CeeWQRCIN6c0ABXEQ8F
        9Nvpi6bDy22NytWoeQ5y1xuxOQy5vqVBuI4v8QzEZykdjMMwaV1ib8LLhzw++N7t
        CcM0tfagzGlvpCIxKo0U8QI//IWyE+JvW8T5dmkr2qbanbeApUXhBQxiAx8eqb2l
        EF8VcQRI+SMfgUiHVsa0P4QFD+8YpvLbLroRMy1/sGAsZtm8yogK1kznCJ4LxLNv
        ysLH4m2vueNxEaqt19HxW+B6SjQdMZUyMi9kOJXG6oMUk+OelUjh9fHmdUZEg06t
        WqnqhrQGUKT5tA==
X-ME-Sender: <xms:L9ogYHIGbitThAZVwJ7H2sr0Xfzg6zsT3kNuuBvEQta8eq-8qHZE8A>
    <xme:L9ogYGA0jpKnIBpAxJ-dC5OO7lEGGdSwoWSAFO4dN45yDbymzHQvTWFxq4E4vldMg
    LdjrdlTV5M-TiUdvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedvgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:L9ogYHhNSRVTZT7EGRfwqtUwJ6-G4ftzxC8YPPfssOfc5XpAHJIlzQ>
    <xmx:L9ogYOnZWdTXHytD5-VcmPIhUx2JIHqpX0lh-hutVXGbMXYftxWmVQ>
    <xmx:L9ogYDos9e0pW-YFl4RR7Q69WvFcNLCRanjE31Ej5x-u6-wypxiwbg>
    <xmx:L9ogYPSFX34DlPLyGwu_8TKEyJmmOWUOYoeujk-sBE_6iVfpEKUghQ>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53D331080059;
        Mon,  8 Feb 2021 01:29:03 -0500 (EST)
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
Subject: [PATCH net-next RESEND 4/5] net: stmmac: dwmac-sun8i: Minor probe function cleanup
Date:   Mon,  8 Feb 2021 00:28:58 -0600
Message-Id: <20210208062859.11429-6-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210208062859.11429-1-samuel@sholland.org>
References: <20210208062859.11429-1-samuel@sholland.org>
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

