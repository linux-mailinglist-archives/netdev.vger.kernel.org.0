Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B08649B73
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 10:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiLLJvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 04:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiLLJvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 04:51:18 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CB6E8B;
        Mon, 12 Dec 2022 01:51:17 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ud5so26518301ejc.4;
        Mon, 12 Dec 2022 01:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xRLw3ci+jVSm6Pto+1wJzGhpqlvsP+sUcPR5KZniM2k=;
        b=o6mUCOxo7yUptJhvZS0CkqKMUC8IQSsOIgF2bFo+1MuMU/77QLQ5YhoS6iRi8jbC4V
         txINZjFMFvS0y0lpF9hj0ic3HHlkk+ABu77JxRTifHHo+JCWU2VAw4Kf3fDdERBhZDAj
         7i3ARLW5C450hOP8oaYInn0NoFRJkKD3A4O5HvY7ff2v+UkPD1ox8wFRzMkoOMOMT8o2
         N2TY4tM7n9BCNA7SdwV5FRcu41yNXgqcOMsx+zLU63+JmGKUQ235zsRWRTp3lvRAcs7p
         WoOON4ck9F+h0DbAn4sSpzgzqDp5Ehfm8pH3YoGo9pxoKvYqagqj3wyi120Pgkq6lDAi
         obbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRLw3ci+jVSm6Pto+1wJzGhpqlvsP+sUcPR5KZniM2k=;
        b=e+AFM+FY4G9L/bJf2+OmCZCxGqe704PH+MD1EgggStCMN0RKkMaTxA69P2XSNp2VYk
         6neRwddUHESjgKse8XPY/3VlteOWvsq5oefmu/PDGlj6J/kgTTaVjB6XAxzHJcW24gXu
         /fiW9Vu31sCTm34ecmUgLY2PBaOrZ45sSvSzuy1CYENp4JT2R0GzDHfGfHiXyTOjQiXI
         kDu05pJ+Bk+/tlnvwF6huPGK/ZZXriQXEnZB2adj/jTDHpwIXxYvNnNsdXxxV1qYjbTa
         W7EaTvIifRFbAtVnSCj/X0wn3Fdwk+q/lMsREHwKNqdOsMasbjpu0Q7ZkqvibtnYQtew
         Oblw==
X-Gm-Message-State: ANoB5pkVMn+UCmY5qJ3Zejmf82Pw2tP3vOR1xAvDa+OdtP5seu1tucrL
        Mb5wSUUwXLFXS9Qk1aZsgL8=
X-Google-Smtp-Source: AA0mqf6m18rUw5lQi9XeBRRQPIyrYnCcCkC+fw5nCS6A+/UwtQmkMWyzLdS49WPRTnLVxD4F2t2fOA==
X-Received: by 2002:a17:906:3716:b0:7c0:bbab:22e5 with SMTP id d22-20020a170906371600b007c0bbab22e5mr12345412ejc.16.1670838675673;
        Mon, 12 Dec 2022 01:51:15 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id l2-20020a1709063d2200b007c07b23a79bsm3053076ejf.213.2022.12.12.01.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 01:51:15 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:51:18 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v6 net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <Y5b5lsUfZqeNBSss@gvm01>
References: <cover.1670712151.git.piergiorgio.beruto@gmail.com>
 <75cb0eab15e62fc350e86ba9e5b0af72ea45b484.1670712151.git.piergiorgio.beruto@gmail.com>
 <Y5XL2fqXSRmDgkUQ@shell.armlinux.org.uk>
 <Y5Ypc5fDP3Cbi+RZ@gvm01>
 <Y5Y+xu4Rk6ptCERg@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5Y+xu4Rk6ptCERg@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 11, 2022 at 08:34:14PM +0000, Russell King (Oracle) wrote:
> On Sun, Dec 11, 2022 at 08:03:15PM +0100, Piergiorgio Beruto wrote:
> > On Sun, Dec 11, 2022 at 12:23:53PM +0000, Russell King (Oracle) wrote:
> > > On Sat, Dec 10, 2022 at 11:46:39PM +0100, Piergiorgio Beruto wrote:
> > > > This patch adds the required connection between netlink ethtool and
> > > > phylib to resolve PLCA get/set config and get status messages.
> > > > 
> > > > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > > > ---
> > > >  drivers/net/phy/phy.c        | 175 +++++++++++++++++++++++++++++++++++
> > > >  drivers/net/phy/phy_device.c |   3 +
> > > >  include/linux/phy.h          |   7 ++
> > > >  3 files changed, 185 insertions(+)
> > > > 
> > > > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > > > index e5b6cb1a77f9..40d90ed2f0fb 100644
> > > > --- a/drivers/net/phy/phy.c
> > > > +++ b/drivers/net/phy/phy.c
> > > > @@ -543,6 +543,181 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
> > > >  }
> > > >  EXPORT_SYMBOL(phy_ethtool_get_stats);
> > > >  
> > > > +/**
> > > > + * phy_ethtool_get_plca_cfg - Get PLCA RS configuration
> > > > + *
> > > 
> > > You shouldn't have an empty line in the comment here
> > I was trying to follow the style of this file. All other functions start
> > like this, including an empty line. Do you want me to:
> > a) follow your indication and leave all other functions as they are?
> > b) Change all functions docs to follow your suggestion?
> > c) leave it as-is?
> > 
> > Please, advise.
> 
> Please see Documentation/doc-guide/kernel-doc.rst
> 
> "Function parameters
> ~~~~~~~~~~~~~~~~~~~
> 
> Each function argument should be described in order, immediately following
> the short function description.  Do not leave a blank line between the
> function description and the arguments, nor between the arguments."
> 
> Note the last sentence - there should _not_ be a blank line, so please
> follow this for new submissions. I don't think we care enough to fix
> what's already there though.
Fair enough, I'll change this. However, I would suggest to write these
kind of rules (about following the new style vs keeping consistency with
what it's there already) to help newcomers like me understanding what
the policy actually is. I got different opinions about that.

> 
> > 
> > > 
> > > > + * @phydev: the phy_device struct
> > > > + * @plca_cfg: where to store the retrieved configuration
> > > 
> > > Maybe have an empty line, followed by a bit of text describing what this
> > > function does and the return codes it generates?
> > Again, I was trying to follow the style of the docs in this file.
> > Do you still want me to add a description here?
> 
> Convention is a blank line - as illustrated by the general format
> in the documentation file I refer to above.
Okay.

> > 
> > > 
> > > > + */
> > > > +int phy_ethtool_get_plca_cfg(struct phy_device *phydev,
> > > > +			     struct phy_plca_cfg *plca_cfg)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	if (!phydev->drv) {
> > > > +		ret = -EIO;
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	if (!phydev->drv->get_plca_cfg) {
> > > > +		ret = -EOPNOTSUPP;
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	memset(plca_cfg, 0xFF, sizeof(*plca_cfg));
> > > > +
> > > > +	mutex_lock(&phydev->lock);
> > > 
> > > Maybe move the memset() and mutex_lock() before the first if() statement
> > > above? 
> > Once more, all other functions in this file take the mutex -after-
> > checking for phydev->drv and checking the specific function. Therefore,
> > I assumed that was a safe thing to do. If not, should we fix all of
> > these functions in this file?
> 
> This is a review comment I've made already, but you seem to have ignored
> it. Please ensure that new contributions are safe. Yes, existing code
> may not be, and that's something we should fix, but your contribution
> should at least be safer than the existing code.
> 
Russle, I did not actually ignore your comment. Looking back at the
history, you were commenting on the functions in plca.c and we were
talking about the global rtnl lock.

So here what it looks to me:
1. in a previous version of the patchset, the phy_ethtool_*_plca_*
functions were exported, therefore the phydev lock had to be acquired as
you cannot say from which context exactly these could be called.

2. After your comments about NOT exporting these functions, I believe we
can safely assume these are called only from plca.c (ethtool interface).

3. As you can see all of these functions are called with the rtnl lock
being held from ethtool.

Therefore... do we really need to take the phydev mutex at all?
Do we really need to perform (again) checks against phydev being not
NULL and such?

I would suggest to just remove all of these checks and the phydev mutex
locking, unless you see any reason for whcih we should take it.

Thoughts?


> > > Wouldn't all implementations need to memset this to 0xff?
> > It actually depends on what these implementations are trying to achieve.
> > I would say, likely yes, but not necessairly.
> 
> Why wouldn't they want this initialisation, given that the use of
> negative values means "not implemented" - surely we want common code
> to indicate everything is not implemented until something writes to
> the parameter?
> 
> What if an implementation decides to manually initialise each member
> to -1 and then someone adds an additional field later (e.g. for that
> 0x0A) ?
Fair enough, as I said, this makes sesne to me, I just wanted to be sure
we agree on the purpose.

I moved the memset to the upper layers.

Thanks!
Piergiorgio
