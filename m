Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969B23FD6BF
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 11:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243532AbhIAJ3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 05:29:38 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:41261 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243314AbhIAJ3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 05:29:37 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 71BA8580B31;
        Wed,  1 Sep 2021 05:28:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 01 Sep 2021 05:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=hjKhFYSRanqW3ieK7WfmVCGe65O
        txH7oj5QcwBwcF/I=; b=kH7ZD4TbENRfccCEhk7bbqWw/tR+TJRq4arDsT7sBoR
        3Ag2qPqjOIprqEh1Ke4KKAjE0kpuXex8gafDEvmcxn6QxrX6ItPwEnpTVyR0n2e5
        IlI84zbpa2VEBk81hVYqV6Yy0g48VNJp/Yen2YqbViQiDqJ3UP9Y8LHUwh2QQbhe
        tSE5qCMFadYPmXMBGzNWr3WcWN7UwHihq1Ne9ygJw1ppgpTp2+GxDKU0znyvf6DN
        9UzUGSqLJAyoCLPMblUBR4GqafOhHqEF3HA1Py3l0rL664j6sqV34jKROo4D4ayr
        zAtVlCr6tBFBfjhyEzT3BVn1qIW7U+35WX383rcH8oA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hjKhFY
        SRanqW3ieK7WfmVCGe65OtxH7oj5QcwBwcF/I=; b=UUO4osKr4lAXGXmd/Wcgm2
        XNCDf3I5+NYFvgw/jEQbEhnKTUtW+dFiMqGf9BcdR2N+VT49HXbqMXXScak9WmAM
        AxDg/ERJ5Gwcl+tKi/uO1lS6iW12K5E9ZpsiLAb2vFE8qQDGybZfz2pK9QEJyEmr
        1r/UPoAS9ev5gpO6eRkxpbvna/QBsJlYHRR31oYCU4ijFjTdJndCehytsmUhT7ig
        j9tcnBVo4q9wWE9GTiikXMoZfs0k+qfuqlgvdhSrkAgew8nEU8Dnwar1tDey5kNs
        Q6Ad4xYJBoLFomH1ybqfQjkVdyS/7KVBn1RO3zrqA0VdIAAoec+DDvIN9kMy2UAg
        ==
X-ME-Sender: <xms:xkcvYYNWVqd0R3X-VOb3eOudZ3OBdhL2zAItJT26y2xSYWiFRm5Big>
    <xme:xkcvYe-jNnTjfaSZIfQTHonWcEylQqgSInpqSSyIgxYYwrJYs9Ly2IRtBDlwmviYf
    CnLhpa-uttcOQ>
X-ME-Received: <xmr:xkcvYfTeQOygYOs-XPacW2GqgX_RW_ZV0KQMdBvar8LnPQfO7kZl7Qqr6FMiESlbOmP-I08nCUKXBu2S01uBhUY7dUB_X_1a>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:xkcvYQuSwUVRjF46xtUj1idAMdICA_myxKthNPm2ukIxxLBbQbXaTA>
    <xmx:xkcvYQfVCAXY_4NmVAEsPaiXWae3JWT9XIvC_N55DNoSg3VfFNdEbA>
    <xmx:xkcvYU2agQmAgPDCp0CwpmOnManxPEMQAp0wxj5ec3VrXV-Vv9T4rg>
    <xmx:yEcvYTxIAokmDCwRpkbj5FYb1sTxiMCuS7wTwV56pt1uq5vRePzb2g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 05:28:37 -0400 (EDT)
Date:   Wed, 1 Sep 2021 11:28:34 +0200
From:   Greg KH <greg@kroah.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5.4.y] net: dsa: mt7530: fix VLAN traffic leaks again
Message-ID: <YS9HwpC9TulUvps/@kroah.com>
References: <20210823070928.166082-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823070928.166082-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 03:09:27PM +0800, DENG Qingfang wrote:
> [ Upstream commit 7428022b50d0fbb4846dd0f00639ea09d36dff02 ]
> 
> When a port leaves a VLAN-aware bridge, the current code does not clear
> other ports' matrix field bit. If the bridge is later set to VLAN-unaware
> mode, traffic in the bridge may leak to that port.
> 
> Remove the VLAN filtering check in mt7530_port_bridge_leave.
> 
> Fixes: 4fe4e1f48ba1 ("net: dsa: mt7530: fix VLAN traffic leaks")
> Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/dsa/mt7530.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Now queued up, thanks.

greg k-h
