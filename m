Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2F831D493
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 05:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhBQEWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 23:22:53 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:36469 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231216AbhBQEVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 23:21:15 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 42F4E5801CA;
        Tue, 16 Feb 2021 23:20:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 16 Feb 2021 23:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm2; bh=vcAcHB+fD0WBZ4/KZULBkvSTwy
        AFLPO+DmF46sm6krc=; b=o1JlfthmQKSDLiuQkWLqrwI13ij3loAs6cEm4wG0LR
        lt/5+hJ4Ppq5lmda6B0xRiThJNMC85/6z7swcqnpfYmVApQeFCiCyalfg752DfSL
        1y2g6waJFCf1zZMiFZxXAlTjp8zNndhQEMwmzWm76oSMw7EBiG+VKVO+slrWR1TR
        5WPdZJ/cdQZW29maof3tQXR+xVvgbX7VtEBntahGfhpRO+qwsl3C8ZzY4P/yznVk
        kccHquHyi/btURufj/HW09b/q9huQp+LOBaWpp7shAYizFgSHXLuIOcXFNsCfYqo
        Tc0ClfnDR3HVHe8dpRCNng5rGUiX9HBEdBwFHhCDVsVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vcAcHB+fD0WBZ4/KZ
        ULBkvSTwyAFLPO+DmF46sm6krc=; b=kcy/W/OWjjjHEvqZKJSgxHzt+tJ4SDyuB
        NqEVVC5Ao7mFbxTDnLvMP3XW4ytm9rrRiG3QJJI7s0EQCxO7Bmn8tsRi6GbcC9SP
        +GUnIeH7TAWcObIPw+G15PXj2vDtYwHch43w8e001RXS2NgygcWx3rUKKX9Dgws4
        qpxB1c9sFO8vegNv7IqszKmfw8tHF1jYd5uZPp2cXBZ+1N/dFkm1qboBgJymg4/C
        aOl8bbrqfux6ElVfVM98tPraT3q3hFztvJ1bEBdTwkNYq68dpJtmDeUpL3l+Ux33
        SBsQ8ahhIQFWY7ZSiHzdINR1Jr/SGhRnVdwAesD6Qg5+NDcIgk8bA==
X-ME-Sender: <xms:d5ksYEG6eaIbVMUYGMSPCV45z2mWQeKg0-6aBvZvCFcfFb4U0YC41Q>
    <xme:d5ksYNQ0jAVNWNisI2ZD0FCWp2n6TKS__9eFjuwi67Wp4HuExVRxa5evjzCsvxrNk
    565dEejZEjPF1trrA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrjedugdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghlucfj
    ohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrfgrth
    htvghrnhepieetkefhheduudfgledtudefjeejfeegveehkeeufffhhfejkeehiefftdev
    tdevnecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgurdho
    rhhg
X-ME-Proxy: <xmx:d5ksYLDrvYD-ix2xUyYp66JncfmyCPvk_2M5RwaS7eoT2wqVcrpyDA>
    <xmx:d5ksYN1miBot7w1_cAz5_I60tHFY0eHLpwXtpG2HTuFnNyJZBkxaag>
    <xmx:d5ksYJVjOWE6m2xtVExIpDcIPUUZQ9msEUvUxUFHY1m8B5_sl2YBog>
    <xmx:eZksYOD76BO5jJqVE8yKC4PmzpKhZpth4N3no-2psDCNIPw9btVguQ>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 083B824005D;
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
Subject: [PATCH net-next v2 0/5] dwmac-sun8i cleanup and shutdown hook
Date:   Tue, 16 Feb 2021 22:20:01 -0600
Message-Id: <20210217042006.54559-1-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches clean up some things I noticed while fixing suspend/resume
behavior. The first four are minor code improvements. The last one adds
a shutdown hook to minimize power consumption on boards without a PMIC.

Changes v1 to v2:
  - Note the assumption of exclusive reset controller access in patch 3

Samuel Holland (5):
  net: stmmac: dwmac-sun8i: Return void from PHY unpower
  net: stmmac: dwmac-sun8i: Remove unnecessary PHY power check
  net: stmmac: dwmac-sun8i: Use reset_control_reset
  net: stmmac: dwmac-sun8i: Minor probe function cleanup
  net: stmmac: dwmac-sun8i: Add a shutdown callback

 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 33 ++++++++++++-------
 1 file changed, 21 insertions(+), 12 deletions(-)

-- 
2.26.2

