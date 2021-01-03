Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B0B2E8BE7
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 12:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbhACLS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 06:18:56 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:56983 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726713AbhACLSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 06:18:54 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 7D156546;
        Sun,  3 Jan 2021 06:17:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 03 Jan 2021 06:17:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=mHnSeKRCkdCYl8YY3wS1zcBquB
        u1Bad4dFa8jggcJow=; b=tj1lxCIVDnGQpGvxoElQBX6voWmfKKIX4WWOgSlGLs
        bj/aCfkMTudtRiGwHxoTl8F5khv+ZeLKX55/dyxV10N4E5o6x08yM3y8zL4MLuXw
        piJbpWAWxGeoA/seAs99YrwGbcFZOFu9dDSOZWpem31iu2g5IUVtkd40BkLDafA/
        9pMinlUm8bA3Xz11FqLPXgT5E8g5nbP7CxlfkEO/u+6Ss4IiMUKAVpX1QDfAcF/2
        mYDLUoRPthE9oSxrbY+WmXfrqWmykD4v/85Efbme8svWGbDIDW9HqwotXu14kOzQ
        oKMO0mahPfFvPPG4kaMgpHZD/OJif5lQE9FdeVZ1VTeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mHnSeKRCkdCYl8YY3
        wS1zcBquBu1Bad4dFa8jggcJow=; b=UJx6ZdX+agEsfHVO7BeuOiQjEhFPBZV76
        EtFHoDkR4uScHwI8C2DpLGFE/GQyJzhjDQNByt15ICmcjuHc1PRI38d3bV0Z8xBB
        thNTMj+3xS02XVTZPdNTCghiDf5FRBQhdVV18tss/K7hQ3NV68NeOnIMoAJHN/HY
        0AFN87ksgeL+D6o3YkLLA+2K3v0fVyfC/CXgZbK7JS8E4s8qR5wrwbiZrP9aMgym
        TNVvx4hcfDFS0XxJ8J/7hU7TcfKvgGlt4iz3P2DuXuxnsq1/stcCJlyiJxj53kDW
        cd+DqwRiZr+1DQhj2n8M1aSGPppSlvSpuXj2mYypO7CZoxay+tExA==
X-ME-Sender: <xms:2afxX1TMgEUGSzigdO1OTBOywUjWsVTcClldkRXT8e1exj0skK-y1A>
    <xme:2afxX-yT0MzhAhW2HrqEMJPutGB3Yx89zlWdZ_aioUHMoCrRumfpGlZ2Lnzjqcx4p
    AOxPUfVGPTaUDQUjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefuddgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgvlhcu
    jfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtffrrg
    htthgvrhhnpeeiteekhfehuddugfeltddufeejjeefgeevheekueffhffhjeekheeiffdt
    vedtveenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghnugdr
    ohhrgh
X-ME-Proxy: <xmx:2afxX61bpZb4sbJ49GLIOVJlm8HXByUmcIvk7f6bEGzFLGe3FmxJ1w>
    <xmx:2afxX9DiJIPz2mKW6V_TCt9dNVybHKPvzPKoWwtNCyujBdlwrEmW2Q>
    <xmx:2afxX-g2f67BhyJGnaWeFK4-s-LLuBiVWegdgBB2_Un4Tk1_UbTpNw>
    <xmx:26fxX_b3Eb1Op35qgwopsCMVnsuv6r0btJ-tS5qqDWmtbV9Wra0ViGty9Gs>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B1CD108005B;
        Sun,  3 Jan 2021 06:17:44 -0500 (EST)
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
Subject: [PATCH net 0/4] Fixes for dwmac-sun8i suspend/resume
Date:   Sun,  3 Jan 2021 05:17:40 -0600
Message-Id: <20210103111744.34989-1-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes issues preventing dwmac-sun8i from working after a
suspend/resume cycle. Those issues include the PHY being left powered
off, the MAC syscon configuration being reset, and the reference to the
reset controller being improperly dropped. They also fix related issues
in probe error handling and driver removal.

Samuel Holland (4):
  net: stmmac: dwmac-sun8i: Fix probe error handling
  net: stmmac: dwmac-sun8i: Balance internal PHY resource references
  net: stmmac: dwmac-sun8i: Balance internal PHY power
  net: stmmac: dwmac-sun8i: Balance syscon (de)initialization

 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 129 +++++++++++-------
 1 file changed, 82 insertions(+), 47 deletions(-)

-- 
2.26.2

