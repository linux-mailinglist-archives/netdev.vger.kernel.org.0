Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC58D4EB86E
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 04:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242084AbiC3Cqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 22:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239261AbiC3Cqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 22:46:30 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFCB522DC;
        Tue, 29 Mar 2022 19:44:45 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 0AB755C00E9;
        Tue, 29 Mar 2022 22:44:45 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute5.internal (MEProxy); Tue, 29 Mar 2022 22:44:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=pWGqz/nqqothglGzobmCKu7DG/1JSXSUyXe/q5
        An9Zg=; b=QDpbEUH9w2Ecd0+KdNb9tLPfzPhaYPagfT4adhaVXXddbzLg79KxN7
        GUa2fqs+x7His5EBPNdafnOj72BsMwx/DmxUveTtWnf7KwgVLULXu33TTgX7fKtO
        BANpVt91XwpV4u+N5wRDzctEKp+TdI0GYVhPUoU3jrBArwYu9ZJMMsplG7xEDsAA
        4InE2O0ulPiU1N39HhCelO2l9Oe1eDV1ZBnNXdqfAV7nipi166meViUAPORD1uw7
        wRQ6SpurVUU2sUjtAxU9OeeZiQbVogCE/n9TfjM4lHmL1FJXQ73VMeZiZwZFkpNH
        JtGTdPK2JgDcDH3GoYB+P2SnFO9snLRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pWGqz/nqqothglGzo
        bmCKu7DG/1JSXSUyXe/q5An9Zg=; b=jW//zp40NLZ3YKumvewgmK+Vj7WIeziA7
        sAyoGV78rGq46afqbqBeB6Xv+EtD/FAYWFWT/H+HlBNfNimq9eUGZ0TWOwPLAMsX
        nu/yTpU7L0qZYWcpqHsMAIpz8d26uO4HMb1Kt4gBzbqI1VBsRUI3i5L3cNAr7BmU
        w0BL/tY541uVGR2xwM9DwnGCtgxK8ZxJ4YOKZHT2cnP5LX71i6VXcy64S2Zn6NsO
        uDezzzgcUsspl7xE+oEb7H4vOmaKED+e5Ry0zjmF3XooimU+9mCWih61M+aZSe31
        c4k5Xwkt6qnulTKD+QoDvydEWi41pzfZPqEEL7h63JojCjo7vDH1Q==
X-ME-Sender: <xms:HMRDYhzh0T1XezhrvifAHHQfwzdFYDhbBMKJI4WfOmpVCdeEoPFb7w>
    <xme:HMRDYhQdYvhinWi7fGKXhohm43yBesFTCjzBefB_S-AFIvwsx4DMpm_kPSFN7XZ3z
    uDpCqa2VpOgJIlKaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeiuddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdetnhgu
    rhgvficulfgvfhhfvghrhidfuceorghnughrvgifsegrjhdrihgurdgruheqnecuggftrf
    grthhtvghrnhephefhfeekgfekudevheffheeihedujeefjeevjeefudfgfeeutdeuvdeh
    hfevueffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvgifsegrjhdrihgurdgruh
X-ME-Proxy: <xmx:HMRDYrWxtgV-KcAQ8jnfMzUeVuhbjp7xH1-qtw8YBiJkXQhfPxSHag>
    <xmx:HMRDYji0MaBmJToABMobp0w4ra_jbrBMqEPtH7QonZM7IoH65Qni8g>
    <xmx:HMRDYjDQ98zUNkD_m-VF7CpB0qjZ2sfNBpi_72XrSH7w790m4AFiwg>
    <xmx:HcRDYvtSfNYU-QqciXVTT8xfpuicNJ2cHHrYDo8MiwpQmMzKzyR8zg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 32214F6043F; Tue, 29 Mar 2022 22:44:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4911-g925b585eab-fm-20220323.003-g925b585e
Mime-Version: 1.0
Message-Id: <489d851e-be29-44a3-bf56-78be33d585f2@www.fastmail.com>
In-Reply-To: <20220329161949.19762-1-potin.lai@quantatw.com>
References: <20220329161949.19762-1-potin.lai@quantatw.com>
Date:   Wed, 30 Mar 2022 13:14:22 +1030
From:   "Andrew Jeffery" <andrew@aj.id.au>
To:     "Potin Lai" <potin.lai@quantatw.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "Russell King" <linux@armlinux.org.uk>,
        "David Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, "Joel Stanley" <joel@jms.id.au>
Cc:     "Patrick Williams" <patrick@stwcx.xyz>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: mdio: aspeed: Add Clause 45 support
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 30 Mar 2022, at 02:49, Potin Lai wrote:
> Add Clause 45 support for Aspeed mdio driver.
>
> Signed-off-by: Potin Lai <potin.lai@quantatw.com>
> ---
>  drivers/net/mdio/mdio-aspeed.c | 122 ++++++++++++++++++++++++---------
>  1 file changed, 88 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
> index e2273588c75b..aa2b678b2381 100644
> --- a/drivers/net/mdio/mdio-aspeed.c
> +++ b/drivers/net/mdio/mdio-aspeed.c
> @@ -21,6 +21,10 @@
>  #define   ASPEED_MDIO_CTRL_OP		GENMASK(27, 26)
>  #define     MDIO_C22_OP_WRITE		0b01
>  #define     MDIO_C22_OP_READ		0b10
> +#define     MDIO_C45_OP_ADDR		0b00
> +#define     MDIO_C45_OP_WRITE		0b01
> +#define     MDIO_C45_OP_PREAD		0b10
> +#define     MDIO_C45_OP_READ		0b11
>  #define   ASPEED_MDIO_CTRL_PHYAD	GENMASK(25, 21)
>  #define   ASPEED_MDIO_CTRL_REGAD	GENMASK(20, 16)
>  #define   ASPEED_MDIO_CTRL_MIIWDATA	GENMASK(15, 0)
> @@ -39,34 +43,35 @@ struct aspeed_mdio {
>  	void __iomem *base;
>  };
> 
> -static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
> +static int aspeed_mdio_ctrl_reg(struct mii_bus *bus, u8 st, u8 op, u8 phyad,

It's a bit of a nit-pick, but this function name talks about something
it impacts rather than something it does. What do you think of
`aspeed_mdio_op()`?

Less of a nitpick, this patch does three things:

1. Distills the aspeed_mdio_ctrl_reg() function from from the
   aspeed_mdio_{read,write}() functions

2. Introduces the additional function indirection for C22 vs C45 reads

3. Adds the C45 support.

I think it'd be easier to review if it was broken into three separate
patches along the lines of the above. I'm finding the hunks hard to
concentrate on as they are.

Andrew
