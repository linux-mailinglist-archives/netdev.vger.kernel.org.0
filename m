Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC60641A84
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 03:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiLDCtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 21:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiLDCtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 21:49:08 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FD01A392;
        Sat,  3 Dec 2022 18:49:07 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id gu23so20052562ejb.10;
        Sat, 03 Dec 2022 18:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cmNBc2t4SdHGKPr81Ywa2Y2Yv+nCKDCklrkrKWhSahA=;
        b=Q40r0IsVsa55+/t2AjeJV3Q3vUniLmakgKRAtaTNGiZkSm6/81SWSL/BnCxVI77+8b
         FevrNo4KZfro9qITUzKkwgfYzlzeh1DPtEpiQXuoJBnkrlBqG3ms3nWwhtNIDx7DRUL2
         Jr913puMpUjO2QgCzCAB2lsZjn5AMO0oUuyrWVObrCSJhh3LRd3cHKIfzM2sB0e0wWkt
         uuGmftl/4ToaylwxA/iPYm4mV8CiGED9iFpUxkWoTJs1XbZcYjlCnrvkt+o2SMFyCLYR
         Fn/Es4uBeqc15bgms7lkLYYfq3L4+XEOTi5WeLCir7wLV9ndbWZBYe4KYtUY+Px4FRtE
         eaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cmNBc2t4SdHGKPr81Ywa2Y2Yv+nCKDCklrkrKWhSahA=;
        b=kT4C9PpBzP+YxawuBSR0I21eYeWj73k0TZqDPMpAplyVD3fZaELmn54H987ejfX9jk
         wB6P0tr4XzCyRB0eS+qGGS3o0A63DPuLqqiQLqBhz+XWXzqvWlW+Xtuqvd0WYYaEdOuX
         ng3boYBM4GrkZw2T1TWwLIxtcUspGAzUfXp9ppS6XqYzVPawnPBeKZNKb1vVw6gyd9Y+
         KXRugaWj6GV+MZUhJ9ULxsE++Qctf8OAe0fo5HYoYDFSWfX7gvK2T4AG5k5J5/bXfw/P
         5OoKlP3IyMm5wpQiRk2gSIAsEDNq0gpk7ItTXlt/TVbsrtsDrUkFViKfDWGYR+hFOmzx
         hysQ==
X-Gm-Message-State: ANoB5pnlAi/GlI1RxO77cGfpgESV/JjWiesu14Yxi5YxukwxtzvjrsUT
        M6sOp5z6QMlKEPT7fGJqFzA=
X-Google-Smtp-Source: AA0mqf6FbmJK9mViw5mGcIfJ3GOYQMHEhJrgsZoqXneOcsFvLDVy8m1T3wXSG9HpNmKubFQEp/M1Ww==
X-Received: by 2002:a17:906:4c92:b0:78d:ad29:396f with SMTP id q18-20020a1709064c9200b0078dad29396fmr65524645eju.165.1670122146015;
        Sat, 03 Dec 2022 18:49:06 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id dm17-20020a05640222d100b00461aca1c7b6sm4746761edb.6.2022.12.03.18.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 18:49:05 -0800 (PST)
Date:   Sun, 4 Dec 2022 03:49:12 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 1/4] net/ethtool: Add netlink interface for the
 PLCA RS
Message-ID: <Y4wKqIGUntE+QGnS@gvm01>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <7209a794f6bee74fbfd76178000fd548d95c52ad.1670119328.git.piergiorgio.beruto@gmail.com>
 <c1fd8c0b-76d9-a15c-a3e9-3bd89a6dfabc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1fd8c0b-76d9-a15c-a3e9-3bd89a6dfabc@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Randy,
thank you for your feedback. Although I have worked on the kernel for
quite some time now, I'm pretty new to this process.

Please, see my answers interleaved.

On Sat, Dec 03, 2022 at 06:37:13PM -0800, Randy Dunlap wrote:
> Hi--
> 
> On 12/3/22 18:30, Piergiorgio Beruto wrote:
> > Add support for configuring the PLCA Reconciliation Sublayer on
> > multi-drop PHYs that support IEEE802.3cg-2019 Clause 148 (e.g.,
> > 10BASE-T1S). This patch adds the appropriate netlink interface
> > to ethtool.
> > 
> > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > ---
> 
> 
> > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > index e5b6cb1a77f9..99e3497b6aa1 100644
> > --- a/drivers/net/phy/phy.c
> > +++ b/drivers/net/phy/phy.c
> > @@ -543,6 +543,40 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
> >  }
> >  EXPORT_SYMBOL(phy_ethtool_get_stats);
> >  
> 
> What is the meaning of all these empty kernel-doc comment blocks?
> Why are they here?
> Please delete them.
These functions are placeholders that I've used to have the kernel
compile. The next patch amends those functions and adds the proper
kernel-doc.

Do you want me to just remove the kernel-doc and leave the functions
TODO? Or would you like me to merge patches 1 and 2?

I did this to split the work into smaller, logically isolated and
compiling commits. Please, let me know if I did that wrong.
 
> > +/**
> > + *
> > + */
> > +int phy_ethtool_get_plca_cfg(struct phy_device *dev,
> > +			     struct phy_plca_cfg *plca_cfg)
> > +{
> > +	// TODO
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(phy_ethtool_get_plca_cfg);
> > +
> > +/**
> > + *
> > + */
> > +int phy_ethtool_set_plca_cfg(struct phy_device *dev,
> > +			     struct netlink_ext_ack *extack,
> > +			     const struct phy_plca_cfg *plca_cfg)
> > +{
> > +	// TODO
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(phy_ethtool_set_plca_cfg);
> > +
> > +/**
> > + *
> > + */
> > +int phy_ethtool_get_plca_status(struct phy_device *dev,
> > +				struct phy_plca_status *plca_st)
> > +{
> > +	// TODO
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(phy_ethtool_get_plca_status);
> 
> Thanks.
> -- 
> ~Randy
Thank you and kind regards,
   Piergiorgio
