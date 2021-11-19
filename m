Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B7D456F9D
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 14:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbhKSNck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 08:32:40 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:54431 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232869AbhKSNcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 08:32:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 77EB6580D4B;
        Fri, 19 Nov 2021 08:29:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 19 Nov 2021 08:29:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=BTqa9V4sNzf2Hf3EnYLoECME+NW
        Ze3HdYdsh3e4uy2A=; b=apW7Ds+cCq9t+uB0eMfs+Xkzs6hVs9xjliKyLH/LUaW
        AdcOOMMzvZhMWKnao+tZ3RQpyGlb8T3Ao1rT8PXTuD59Rh2R3jmxB6R5VRtjtZmV
        8YGHNMZJULBFtPU1ZdJrM28brsSv2q6uRMWiedkNCi+8zpc5k+hTnozbN7mY2Kb9
        2hTQUEKGTBbaTu+XblfLflW+AyCyr9V/jNJB8KJ1hFBLVKoJGBp95+rP9LvKkGfm
        ptun11ZPfZcsM/LcrEhfnPlbdMDQ5HEQI5rYJn0OSJfExTvelKAKk5ERFv0inIzs
        X1mV4uBPoQ84St1r28FCCyGO1SDFKQwc0BTE89ABpiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=BTqa9V
        4sNzf2Hf3EnYLoECME+NWZe3HdYdsh3e4uy2A=; b=FakVhT0/bQnT7/duK5mi1k
        ZAoA7IftHrai1/Yb5TEbRyDejIkA4ixpCppsrYsrT9Nn6sX9jsjZJxyLpTjNI3Ge
        ewBtvfV/o8oo5qnUftWIlqu3KEmTX14o7rTE2aPrTwKZB/eHiVSSL0q7EF44hLZh
        kOO9Dp6WujNZaPm43/NwuAJKr54QBd1mIWiUGNshe+KCI1gNH6igEs5yG01SIYPJ
        M57yDWia0PV7Z2klyYCxcZQDjgahE7Fl7N37l54zz9bxneQHj3mPasXeuU2IXha1
        Th8KndqxaUkGRe+Wzvpx+1JikHyAcvlhdNY9mAXunt9VBAEU4ohcnGcZNE+chXvQ
        ==
X-ME-Sender: <xms:wKaXYW7T0CKzPstg5ishlh086E85vvol9EWnWnkUmyC6K6ELFoQbrA>
    <xme:wKaXYf71PAZsubaGgW1pz2kPQNYxyiWwuzt1DLsW0HoasELjQ2BCRRJXIS_iQlBXf
    hMx1WZ0tC0kKA>
X-ME-Received: <xmr:wKaXYVdJf25mIec3-aAH6VVnX1cVV40g5V0bziVvSVZYabk768P6IDbBlXRwIsAN1TFuug_7WL0D3uGrh32U1J9B0b-djpBe>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeekgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:wKaXYTLQLbtXqifvlSvf2HumT-iXF04Y1JAE-7vZK75j8Y57Q-pn7g>
    <xmx:wKaXYaJV6mECg0p1vdoMUzg0VWgJIExRPv6rv1HOWE07f_BB6J_czw>
    <xmx:wKaXYUye9Ceh_4fjaOwZv3lmvzSjklare8EZiXGPFTTdkrCDjqueng>
    <xmx:waaXYfCjUhbdP0E9BIDHNQ46etf8X1AL8C8ce2jtePo0Ztxf9_GIIg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Nov 2021 08:29:36 -0500 (EST)
Date:   Fri, 19 Nov 2021 14:29:25 +0100
From:   Greg KH <greg@kroah.com>
To:     Meng Li <Meng.Li@windriver.com>
Cc:     stable@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        qiangqing.zhang@nxp.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] backport patches to improve clocks management for
 stmmac driver
Message-ID: <YZemteFqu3/5ryNL@kroah.com>
References: <20211119025359.30815-1-Meng.Li@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119025359.30815-1-Meng.Li@windriver.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 10:53:53AM +0800, Meng Li wrote:
> From: Meng Li <meng.li@windriver.com>
> 
> In stable kernel v5.10, when run below command to remove ethernet driver on
> stratix10 platform, there will be warning trace as below:
> 
> $ cd /sys/class/net/eth0/device/driver/
> $ echo ff800000.ethernet > unbind
> 
> WARNING: CPU: 3 PID: 386 at drivers/clk/clk.c:810 clk_core_unprepare+0x114/0x274
> Modules linked in: sch_fq_codel
> CPU: 3 PID: 386 Comm: sh Tainted: G        W         5.10.74-yocto-standard #1
> Hardware name: SoCFPGA Stratix 10 SoCDK (DT)
> pstate: 00000005 (nzcv daif -PAN -UAO -TCO BTYPE=--)
> pc : clk_core_unprepare+0x114/0x274
> lr : clk_core_unprepare+0x114/0x274
> sp : ffff800011bdbb10
> clk_core_unprepare+0x114/0x274
>  clk_unprepare+0x38/0x50
>  stmmac_remove_config_dt+0x40/0x80
>  stmmac_pltfr_remove+0x64/0x80
>  platform_drv_remove+0x38/0x60
>  ... ..
>  el0_sync_handler+0x1a4/0x1b0
>  el0_sync+0x180/0x1c0
> This issue is introduced by introducing upstream commit 8f269102baf7
> ("net: stmmac: disable clocks in stmmac_remove_config_dt()")
> 
> But in latest mainline kernel, there is no this issue. Because commit
> 5ec55823438e("net: stmmac: add clocks management for gmac driver") and its
> folowing fixing commits improved clocks management for stmmac driver.
> Therefore, backport them to stable kernel v5.10.
> 

All now queued up, thanks.

greg k-h
