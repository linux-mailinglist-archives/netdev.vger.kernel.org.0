Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFD9643092
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbiLESkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiLESjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:39:43 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B710722B35;
        Mon,  5 Dec 2022 10:35:10 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id fc4so564867ejc.12;
        Mon, 05 Dec 2022 10:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K0Pz7z9Of4EXIWcqlWFyc4frtFe9XDNLDU6rlxGKy64=;
        b=gH5C4Dx7Fn/K58xCRUqDMImP3lfARcST7X9QQ70IVAzCCijzqJkzYWRjbBLHxZ/sH+
         C9TXzumfbru/sp/PaqODIb5QkUUY8K0HKI6VREyeQVsTT0Nqgpo3WirixuDxy60ZHy3h
         Pvm4wm8uE0zdQYtbU/T44TQpZjxc9lOCIfb/sZmgP+LZAlpuF/D9ZI5lfcEeYv4pc3JF
         R0vSKQPgvNcopkYSVToyhvF6iyrINuRgGOddC9mLmYkdyTw5C27UuUN+NB6bEKUBxPOl
         pZNFyjZ9ECCb02O4bl/0sPRoPz2VdOANWu3XYUm4NgdhVU1Iq/q9JLkmYqe3aRuEtBHq
         eOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K0Pz7z9Of4EXIWcqlWFyc4frtFe9XDNLDU6rlxGKy64=;
        b=1iRkSvYTcmSI3cxquFiTKtvuohJOsnuYw16Wt2LEA1SXg9bBT/nyiIObt5KDpceE2G
         xlkX+c43JnmqOZaz5xFRCpBgdUhgeqnOhHpRWr+oD3ULBMxMd/r4Z9TbpXO1dgnwL6R4
         GfCbKU8MDW6qCc0zlDfyvptawNEhnnrC6Jl8KB3Mk4eZRjSxzuPSy/f+2+lHQwJUx0Rm
         lBuC1UMfB6/BCNgQQCuPRp9TAUiVegHJNU84JdDFDxm1Gmk6qxkRyG/zccY3+6UO3qZn
         DLmSb1dsaf2iYMI6cn71sKVPwGtdVPJMTqEpz2yTldchOxDaZto1eHA+KquaqxOp2qbR
         TYjg==
X-Gm-Message-State: ANoB5pl4v4cyGED/3+oRyd+SGmOb4lpclABRvTQsWntO4mT/DlF9LhCo
        H/lXwWX78F+Je4zDtdIVDm9HsHygMEvexnAA
X-Google-Smtp-Source: AA0mqf5JgdtOy64lEsSGxkVOg6fJkLgntjMSHlgtwIfPGR8N4yp4br4I1QNSL3EdPT/5ddS6sHSVGg==
X-Received: by 2002:a17:906:7f09:b0:7c0:b3a8:a5f9 with SMTP id d9-20020a1709067f0900b007c0b3a8a5f9mr16379127ejr.154.1670265309253;
        Mon, 05 Dec 2022 10:35:09 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id g15-20020a170906348f00b007bf86800a0asm6440907ejb.28.2022.12.05.10.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 10:35:08 -0800 (PST)
Date:   Mon, 5 Dec 2022 19:35:18 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v3 net-next 1/4] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y4455r631my4LNIU@gvm01>
References: <d53ffecdde8d3950a24155228a3439f2c9b10b9b.1670259123.git.piergiorgio.beruto@gmail.com>
 <Y44y05M+6NGod+4x@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y44y05M+6NGod+4x@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 06:05:07PM +0000, Russell King (Oracle) wrote:
> On Mon, Dec 05, 2022 at 06:17:37PM +0100, Piergiorgio Beruto wrote:
> > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > index e5b6cb1a77f9..99e3497b6aa1 100644
> > --- a/drivers/net/phy/phy.c
> > +++ b/drivers/net/phy/phy.c
> > @@ -543,6 +543,40 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
> >  }
> >  EXPORT_SYMBOL(phy_ethtool_get_stats);
> >  
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
> > +
> >  /**
> >   * phy_start_cable_test - Start a cable test
> >   *
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 716870a4499c..f248010c403d 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -3262,6 +3262,9 @@ static const struct ethtool_phy_ops phy_ethtool_phy_ops = {
> >  	.get_sset_count		= phy_ethtool_get_sset_count,
> >  	.get_strings		= phy_ethtool_get_strings,
> >  	.get_stats		= phy_ethtool_get_stats,
> > +	.get_plca_cfg		= phy_ethtool_get_plca_cfg,
> > +	.set_plca_cfg		= phy_ethtool_set_plca_cfg,
> > +	.get_plca_status	= phy_ethtool_get_plca_status,
> >  	.start_cable_test	= phy_start_cable_test,
> >  	.start_cable_test_tdr	= phy_start_cable_test_tdr,
> >  };
> 
> From what I can see, none of the above changes need to be part of
> patch 1 - nothing in the rest of the patch requires these members to be
> filled in, since you explicitly test to see whether they are before
> calling them.
My apologies, in my understanding of this process (which is new to me)
the idea of dividing the patches into smaller parts is to facilitate the
review. It was not clear to me that the single patches had to be
self-consistent also from a formal perspective. I was assuming that a
patchset can be accepted or rejected as a whole. Is this the case, or
can you accept only a subset of patches in a set?

In short, I did this because I -thought- it would help the reader
understanding what the intention of the change would be. If this is not
the case, fair enough, I'll not do this in the future.

> 
> So, rather than introducing docbook stubs and stub functions that
> do nothing, marked with "TODO" comments, just merge these changes
> above with patch 3, where you actually populate these functions.
Clear. Do you want me to regenerate the patches into a v4 or do you
think we can move forward with v3 anyway?

> Also, why do they need to be exported to modules? From what I can see,
> the only user of these functions is phy_device.c, which is part of
> the same module as phy.c where the functions live, meaning that they
> don't need to be exported.
I did this because similar functions in the same file are all exported
to modules (e.g. phy_config_aneg, phy_speed_down, phy_start_cable_test).
Therefore, I assumed the intention was to let modules (maybe out-of-tree
modules?) make use of these functions. If you think we should not do
this, would kindly explain why for example the phy_start_cable_test is
exported? I'm really asking because I'm trying to learn the rationales
behind the architectural choices that I see here.

> 
> It's also surely wrong to introduce stubs that return success but
> do nothing.
No doubt it would be wrong if the patch can be integrated regardless of
the other patches in the same set.

> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
