Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C9246AAAC
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352422AbhLFVsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352344AbhLFVsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:48:00 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D60C061359
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 13:44:31 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id w1so48657634edc.6
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 13:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BDuNr3Xl3cOM2Tr3+t/Ii0XwKeHElvWmUAMJAR9yWDM=;
        b=EJ24oIt006Tvm+sSjuey01fN2AMCiDQ2E/oB4ZMQjf8N9XpM+mN+H2p1FzPHMcitB4
         C4w3nUxBiDd7E3p7tguD4vWN/w4ceZ6L7n7pjgP0zxAmEeWqUbVxHYIBdjbSS0wjzHVI
         I1a+++C7x8GQeBfDAQlRE+srv7sR5V3N9I0pD86hwpJhjprPw/pCwZlEs2yKHEpYP64Y
         F67aWkBFUzOOV95Ckw6UxAKemUTipSSPLENht12dojRHdYtacFHr2Nr96dciOYL8UZZN
         kTTvnDUDDTKvCONinD547Rv8PLxeca0uk3F+XQK24xBELQtD/VQXNG+llUAJzc4Bo5S7
         2n1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BDuNr3Xl3cOM2Tr3+t/Ii0XwKeHElvWmUAMJAR9yWDM=;
        b=N+pPMi0+DVU1T/xPA6iJaewUUvtXQ8iLoWYNUekRvZKXO2tXmBc6hLhRlgipRehhio
         st2pSfLTySeQJmkUtuVZdkxTmstzap/Rc2jGMBwEAlggpGLVeZEkRUXYzkLYGBdqw2V2
         gcQKGzdkttD15vvSY2B/v9qFdqzhZAQwv9houCdDFSKiLlomKqsD/q/fb5xpqJnjZSyD
         bphHfR8O/7TdkJNNR57M/FxyXxesfczdp11jfOrAD79xzBZEIVJOnA2S8KNFXbQaHPN6
         CU5Zb4F8xePhXONvpnTd2Qyn1ZzIXm0Bc4U1SyONhVkNbwwFNvh/O56oT0QPPs4h9nvM
         Z/mw==
X-Gm-Message-State: AOAM530IJCiQ/KzazJQEUQBDxowmPePmqW/ffqaaCqcgVfwMNlsfNiRT
        zuHQRJAs04RoXNF/CBFNx1M=
X-Google-Smtp-Source: ABdhPJwsT4O2xjbBJ3Sqg2j/QNDCr9x63Bf4CCKuaxMILxDTufNyhD3NWS+nPAWhfweLg7vM4Zt6dA==
X-Received: by 2002:a17:906:f856:: with SMTP id ks22mr47140228ejb.367.1638827069982;
        Mon, 06 Dec 2021 13:44:29 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id hb10sm7526623ejc.9.2021.12.06.13.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 13:44:29 -0800 (PST)
Date:   Mon, 6 Dec 2021 23:44:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211206214428.qaavetaml2thggqo@skbuf>
References: <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
 <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5qSoNhJRiSif/U@lunn.ch>
 <20211206200111.3n4mtfz25fglhw4y@skbuf>
 <Ya5wFvijUQVwvat7@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya5wFvijUQVwvat7@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 08:18:30PM +0000, Russell King (Oracle) wrote:
> > If we're going to impersonate phylink we could at least provide the same
> > arguments as phylink will.
> 
> What is going on here in terms of impersonation is entirely reasonable.
> 
> The only things in this respect that phylink guarantees are:
> 
> 1) The MAC/PCS configuration will not be substantially reconfigured
>    unless a call to mac_link_down() was made if a call to mac_link_up()
>    was previously made.

The wording here is unclear. Did you mean "When the MAC/PCS configuration
is substantially reconfigured and the last call was a mac_link_up(), a
follow-up call to mac_link_down() will also be made"?

And what do you mean by "substantially reconfigured"?
phylink_major_config called from the paths that aren't phylink_mac_initial_config
(because that happens with no preceding call to either mac_link_down or
mac_link_up), right?

> 2) The arguments to mac_link_down() will be the same as the preceeding
>    mac_link_up() call - in other words, the "mode" and "interface".

Does this imply that "there will always be a preceding mac_link_up to
every mac_link_down call"? Because if it does imply that, DSA violates it.

> Phylink does *not* guarantee that a call to mac_link_up() or
> mac_config() will have the same "mode" as a preceeding call to
> mac_link_down(), in the same way that "interface" is not guaranteed.
> This has been true for as long as we've had SFPs that need to switch
> between MLO_AN_INBAND and MLO_AN_PHY - e.g. because the PHY doesn't
> supply in-band information.
> 
> So, this has uncovered a latent bug in the Marvell DSA code - and
> that is that mac_config() needs to take care of the forcing state
> after completing its configuration as I suggested in my previous
> reply.
> 
> There is also the question whether the automatic fetching of PHY
> status information by the hardware should be regarded as a form of
> in-band by phylink, even though it isn't true in-band - but from
> the software point of view, the PPU's automatic fetching is not
> materially different from what happens with SGMII.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
