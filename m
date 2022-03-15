Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0AC4D9563
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 08:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiCOHg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 03:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345489AbiCOHgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 03:36:23 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD564B417;
        Tue, 15 Mar 2022 00:35:10 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 7DE763201F33;
        Tue, 15 Mar 2022 03:35:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 15 Mar 2022 03:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=wN51J1LY2kXsxIHGBKgeZHsokHznm7NO/gSK6t
        Q6uDE=; b=ThQ7eHoBYYich3qIQexLPlWrnqamnrhA+9N605nELQWNrzQ7iFoYot
        uGGrtR9zYIcb7p4+UQr1Yf7gyMFDa6CJ6UeMkh8dc3odsHMS61//ult+EAiiNi/B
        kEf+2AHcVoi1i20ro8Owt468HeDMrcF8DQUCLeQU0NpkFLl3+3RaeytfwHZ/0WQO
        RdFDUpOw6621W9FnIgR1fBLv5m8QASROK6sx0RfidWkIcTDjxfj2rDYey4NDQent
        XsuOgWDg4+A0mpIqqUtw0HAoWtDJLuXE3xvN5NJ1YsYv0XdoUIC2QsYaY7NPa5vi
        ywr2huIPvpDy/4NBX3dL6WdkbZ36pPCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wN51J1LY2kXsxIHGB
        KgeZHsokHznm7NO/gSK6tQ6uDE=; b=Us9nLKryhHJNkInanY+nK2oE1XRPgALPe
        Lz04AjuA9TLvabYwqaQY16awSyAeJq2dyuI1/aHBSs02XGtlCjn+clD6mzTQvduC
        x5za47h+cjUgvyXi4JcBakl84c7+tVkKssI7tu7FxZRoTemv2+bEkNJ7uEF97W5g
        WltpgI/j7IM91CifYHTA6OdCp8eA6evHOKHpgTPia+283Cf/E7WiNV1e4EXnBJZI
        b4nYXrvJvOZNHvNb0J75fDLlh1w0Yp8XEzX/EggpuovqyHPhCM9jjiCjXaJdQSwR
        qgTOF6NjoPh57jCooWYcLpYyJ77iBzIGDCdGgd0T6oTyKPlOtYDWg==
X-ME-Sender: <xms:qUEwYi7-m8HN3NDkBizjoxJ5-WiQoVUyocDZvFkkav94YaeBxogt-Q>
    <xme:qUEwYr6pJhT_SSVt_Rh_bq-d7YhwHUqqjajUtEvgxG400JuTUoG8zdWmRcPWWMwTX
    H3FIdkPAUYhjQ>
X-ME-Received: <xmr:qUEwYhdSf4eOk6OF76nf8VKk-x_OYnaIDFdur-xYii4S4qyKTmySaaPxZbAhn-1xkNMN9KJtf2QvkXb9jxcuWQuECnauN2br>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvledguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveehgf
    ejiedtffefhfdvgeelieegjeegieffkeeiffejfeelhfeigeethfdujeeunecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:qUEwYvIJDvnOqWpcg-BwsK7XVVjaJIAeLlNcyA_NKgvQAEHTH9T9LA>
    <xmx:qUEwYmJsResWTQZDuxV8Vj-WN2T0Uc1elo-v3GHPdpk_6PeZFR2j_g>
    <xmx:qUEwYgzOLfPkLVf53NRQ_INgJ9MKb1ktZOLCPhGkHU0odfAN2-lFnA>
    <xmx:qkEwYn4l3wqEEcLX5flw2AV79CrqgdPTXG72uNOTzsjJhMl0SGoaWg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Mar 2022 03:35:04 -0400 (EDT)
Date:   Tue, 15 Mar 2022 08:35:02 +0100
From:   Greg KH <greg@kroah.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: linux-next: manual merge of the char-misc tree with the net-next
 tree
Message-ID: <YjBBpnDBXLzuFPuI@kroah.com>
References: <20220315164531.6c1b626b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315164531.6c1b626b@canb.auug.org.au>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 04:45:31PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the char-misc tree got a conflict in:
> 
>   drivers/phy/freescale/Kconfig
> 
> between commit:
> 
>   8f73b37cf3fb ("phy: add support for the Layerscape SerDes 28G")
> 
> from the net-next tree and commit:
> 
>   3d565bd6fbbb ("phy: freescale: i.MX8 PHYs should depend on ARCH_MXC && ARM64")
> 
> from the char-misc tree.
> 
> I fixed it up (I think, see below) and can carry the fix as necessary.
> This is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc drivers/phy/freescale/Kconfig
> index 0e91cd99c36b,856cbec7057d..000000000000
> --- a/drivers/phy/freescale/Kconfig
> +++ b/drivers/phy/freescale/Kconfig
> @@@ -23,12 -26,4 +26,14 @@@ config PHY_FSL_IMX8M_PCI
>   	  Enable this to add support for the PCIE PHY as found on
>   	  i.MX8M family of SOCs.
>   
>  +config PHY_FSL_LYNX_28G
>  +	tristate "Freescale Layerscape Lynx 28G SerDes PHY support"
>  +	depends on OF
>  +	select GENERIC_PHY
>  +	help
>  +	  Enable this to add support for the Lynx SerDes 28G PHY as
>  +	  found on NXP's Layerscape platforms such as LX2160A.
>  +	  Used to change the protocol running on SerDes lanes at runtime.
>  +	  Only useful for a restricted set of Ethernet protocols.
> ++
> + endif



Looks good, thanks!
