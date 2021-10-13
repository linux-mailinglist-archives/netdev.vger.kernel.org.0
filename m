Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32C342BB36
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239065AbhJMJNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:13:50 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:42561 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239067AbhJMJNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 05:13:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id BB52F580BEA;
        Wed, 13 Oct 2021 05:11:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 13 Oct 2021 05:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=ze/R6OhPdJBigyPk+ZDOG+YF/1b
        XIPDQ8E8tmsolguo=; b=iP/C6xnZ9xiQKGdJctkYNWkK4Ki/6Akx62XU+q4QG08
        keubdtX1CRNceI6n65Oy6G9A5/niusuUXtGxIEwfiJUMYU1DP0GDKcoxWA8QcMsM
        0lOFsprdulHXwvu9tU+qf3sWTmmrySQ4W9MT7a42lmcmhianfsS0MyuHJiqMC5WE
        GsGMQZvCxNmsYG+rZu0GSsIsKK1T5qYzDfFkhTVDZ4NpjrbQ8OzpYckG16B3R0cH
        tN39dvCGhMQdeoiGQDaGYEIOj4ZH06wKN55RO6bU7oYGmHbbfBbOnaJGPQFiviH7
        /dh+4CevIDC4q7RDblO2Hyg3b41EdurthYPpHNh5PKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ze/R6O
        hPdJBigyPk+ZDOG+YF/1bXIPDQ8E8tmsolguo=; b=DvS49/i5AHyPadhF6eguZu
        ikQWhO2oSHEig4Yh0c86hdegFyqciLYwyTQXEYdvS26Ie7SP9nk5mLZiC/zlMLrP
        BJGobZMwcJNpNgCn3kYE9jq1RjOt3LHgfXIOspUP4a+i9ZMJOFSIA8BqtQ/rDpaU
        C+tRIBIasaPacUG3ZGWAXIVI4bT3qa+QIgQQPPeJtDzOcGGTuHUAfucFs5LKFjHR
        FKbfxsF+ltAdveGI9aPLC/fd8NzKZvOVFGykIObPJg3+AQIfIR0lvANW93YbJu88
        nil4H9VKHXz/gM/0oeSAT0mUYunoNZyvrI0Ll1BtVYyu3IZT36rSCvXJeCwNqTeQ
        ==
X-ME-Sender: <xms:0qJmYXD9fYJWOAczzazVG9Z47yTjEjSZcjPrVrozWpK1dr3C0-Npfw>
    <xme:0qJmYdikjczUJd_Xpgete0Z4grMnSX6EFoUTODVs0axZaioc7D2HGNhO07yExLLrx
    Qp5eWHMwrXInQ>
X-ME-Received: <xmr:0qJmYSmY6ZiyOv4JngmKq-QYMLXNaYkpW3UvCeV-hguxnn5kUDxZ3UnjwkuaV8TtydiyflcxTllIStFK6Cgy0Qp47HpdIUlK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddutddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:0qJmYZwL2hLzilnOOn5f1m9yqmZjfNJS-M_ia-lFg_3yrBdrsaIvLw>
    <xmx:0qJmYcTdWCU1d7DyG7bScELQ4uvewk6-9G1JfeQNZAGG0LoW5gC5BQ>
    <xmx:0qJmYcYgq6cjLPgRJzS5nfK_wdfbNWO5zVizPjm2IK1414aBrT_UzQ>
    <xmx:0qJmYRJpgrpXv9BN_f1M8OYTY2Lk4gfoUfwJ5Z_tKoat3_lJuNKO4g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Oct 2021 05:11:45 -0400 (EDT)
Date:   Wed, 13 Oct 2021 11:11:44 +0200
From:   Greg KH <greg@kroah.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        "open list:ETHERNET PHY LIBRARY" <netdev@vger.kernel.org>
Subject: Re: [PATCH stable 4.14] net: phy: bcm7xxx: Fixed indirect MMD
 operations
Message-ID: <YWai0CXJaI+sJaf8@kroah.com>
References: <20211011181516.103835-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011181516.103835-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 11:15:16AM -0700, Florian Fainelli wrote:
> commit d88fd1b546ff19c8040cfaea76bf16aed1c5a0bb upstream
> 
> When EEE support was added to the 28nm EPHY it was assumed that it would
> be able to support the standard clause 45 over clause 22 register access
> method. It turns out that the PHY does not support that, which is the
> very reason for using the indirect shadow mode 2 bank 3 access method.
> 
> Implement {read,write}_mmd to allow the standard PHY library routines
> pertaining to EEE querying and configuration to work correctly on these
> PHYs. This forces us to implement a __phy_set_clr_bits() function that
> does not grab the MDIO bus lock since the PHY driver's {read,write}_mmd
> functions are always called with that lock held.
> 
> Fixes: 83ee102a6998 ("net: phy: bcm7xxx: add support for 28nm EPHY")
> [florian: adjust locking since phy_{read,write}_mmd are called with no
> PHYLIB locks held]
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/phy/bcm7xxx.c | 94 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 94 insertions(+)

All 3 now queued up, thanks!

greg k-h
