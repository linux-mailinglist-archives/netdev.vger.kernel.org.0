Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D224F6495F3
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 20:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiLKTDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 14:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiLKTDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 14:03:19 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EF5656B;
        Sun, 11 Dec 2022 11:03:15 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id n20so23065567ejh.0;
        Sun, 11 Dec 2022 11:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OJYkZK17fSFZmwI2lANwtunZ1tOqp7l0sH+dJ/GZPLE=;
        b=Otjr6eWv5A4zvqPLdBGRGD0sL1ka90sPjAgEW2qqDCL6K2ZAnqp/BnqOoKuCJifHKg
         ymX/NHnHZ1RfJK2Zb6rZtN7D1KJ+vhynZ6UZ8R+qsPuk4ElBDP7hcraNYV9cU6KJrHKz
         4CnIox4apskEZ4MvCSR0KOHHDsff+2wKSbN0BJ6Y2wiV4KUJz5P+mPIYbJ3zGhmHFHmD
         Ej1ApLW4s3YjW2e+qmZ9SUiK1pmI1hCWzYz4OPhbh03+UypfghbkDU704qAdbNpo6oh1
         Rm/agflxCy2PfFdXqT6Pve/F2rIISC24PI0TK6RlfVWpcLtiPgba66JOzOB3jKSzuGlC
         vLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OJYkZK17fSFZmwI2lANwtunZ1tOqp7l0sH+dJ/GZPLE=;
        b=FoqcR4EnL6iCI1GkstlxMNrEseCeq+tun2bbMQfnMGpvWXt4ixg1ExC15ElEXialYc
         0o+3jC9EPt4AYmR33WjtFZO5hYbWiOD+XcJV+jV5QGmNoGi9NI1ekT9BDMVPAX/fBHOK
         mJfvBs05eOdBC/3v/MjJDW/yDEU7NNwCHmiR1+gxFQpJz4fk7YSRFT8TNb82d4rU5+hq
         dKawvYY2VKg1JriPyhTx3TjvDnocZlstfDre2eSwQ2F6BXASHVUocB9H81x1oEOs6jbn
         wcDkAcfgVM3/0yGfM4ZasGkVnNwLHIIpZt/aK+tjYTcgGMJ6SrlqIr97O72TCPODJxjI
         lnSA==
X-Gm-Message-State: ANoB5plPZTzSP95EUX1K3001iWABKv03JOFRBZoDhNGo1nR5JxIrhx0V
        yeNHrXze+GSPGUhmLxWOHg4=
X-Google-Smtp-Source: AA0mqf6iwFbgBWZI6e1MZSm3uM2mtwUnD2vCIkJmN0dK9B4YCgugScq+ajomJGvMF+ZXYlc/maUNPQ==
X-Received: by 2002:a17:906:46c3:b0:78d:f455:30f8 with SMTP id k3-20020a17090646c300b0078df45530f8mr10989706ejs.32.1670785393682;
        Sun, 11 Dec 2022 11:03:13 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id j12-20020a170906050c00b007c0d4d3a0c1sm2359644eja.32.2022.12.11.11.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 11:03:13 -0800 (PST)
Date:   Sun, 11 Dec 2022 20:03:15 +0100
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
Message-ID: <Y5Ypc5fDP3Cbi+RZ@gvm01>
References: <cover.1670712151.git.piergiorgio.beruto@gmail.com>
 <75cb0eab15e62fc350e86ba9e5b0af72ea45b484.1670712151.git.piergiorgio.beruto@gmail.com>
 <Y5XL2fqXSRmDgkUQ@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5XL2fqXSRmDgkUQ@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 11, 2022 at 12:23:53PM +0000, Russell King (Oracle) wrote:
> On Sat, Dec 10, 2022 at 11:46:39PM +0100, Piergiorgio Beruto wrote:
> > This patch adds the required connection between netlink ethtool and
> > phylib to resolve PLCA get/set config and get status messages.
> > 
> > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > ---
> >  drivers/net/phy/phy.c        | 175 +++++++++++++++++++++++++++++++++++
> >  drivers/net/phy/phy_device.c |   3 +
> >  include/linux/phy.h          |   7 ++
> >  3 files changed, 185 insertions(+)
> > 
> > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > index e5b6cb1a77f9..40d90ed2f0fb 100644
> > --- a/drivers/net/phy/phy.c
> > +++ b/drivers/net/phy/phy.c
> > @@ -543,6 +543,181 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
> >  }
> >  EXPORT_SYMBOL(phy_ethtool_get_stats);
> >  
> > +/**
> > + * phy_ethtool_get_plca_cfg - Get PLCA RS configuration
> > + *
> 
> You shouldn't have an empty line in the comment here
I was trying to follow the style of this file. All other functions start
like this, including an empty line. Do you want me to:
a) follow your indication and leave all other functions as they are?
b) Change all functions docs to follow your suggestion?
c) leave it as-is?

Please, advise.

> 
> > + * @phydev: the phy_device struct
> > + * @plca_cfg: where to store the retrieved configuration
> 
> Maybe have an empty line, followed by a bit of text describing what this
> function does and the return codes it generates?
Again, I was trying to follow the style of the docs in this file.
Do you still want me to add a description here?

> 
> > + */
> > +int phy_ethtool_get_plca_cfg(struct phy_device *phydev,
> > +			     struct phy_plca_cfg *plca_cfg)
> > +{
> > +	int ret;
> > +
> > +	if (!phydev->drv) {
> > +		ret = -EIO;
> > +		goto out;
> > +	}
> > +
> > +	if (!phydev->drv->get_plca_cfg) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	memset(plca_cfg, 0xFF, sizeof(*plca_cfg));
> > +
> > +	mutex_lock(&phydev->lock);
> 
> Maybe move the memset() and mutex_lock() before the first if() statement
> above? 
Once more, all other functions in this file take the mutex -after-
checking for phydev->drv and checking the specific function. Therefore,
I assumed that was a safe thing to do. If not, should we fix all of
these functions in this file?

> Maybe the memset() should be done by plca_get_cfg_prepare_data()?
I put the memset there when the function was exported. Since we're not
exporting it anymore, we can put it in the _prepare() function in plca.c
as you suggest. I just wonder if there is a real advantage in doing
this?

> Wouldn't all implementations need to memset this to 0xff?
It actually depends on what these implementations are trying to achieve.
I would say, likely yes, but not necessairly.

> 
> Also, lower-case 0xff please.
Done.

> 
> > +	ret = phydev->drv->get_plca_cfg(phydev, plca_cfg);
> > +
> > +	if (ret)
> > +		goto out_drv;
> > +
> > +out_drv:
> 
> This if() and out_drv label seems unused (although with the above
> suggested change, you will need to move the "out" label here.)
Noted, thanks.
> 
> > +	mutex_unlock(&phydev->lock);
> > +out:
> > +	return ret;
> > +}
> > +
> > +/**
> > + * phy_ethtool_set_plca_cfg - Set PLCA RS configuration
> > + *
> > + * @phydev: the phy_device struct
> > + * @extack: extack for reporting useful error messages
> > + * @plca_cfg: new PLCA configuration to apply
> > + */
> > +int phy_ethtool_set_plca_cfg(struct phy_device *phydev,
> > +			     const struct phy_plca_cfg *plca_cfg,
> > +			     struct netlink_ext_ack *extack)
> > +{
> > +	int ret;
> > +	struct phy_plca_cfg *curr_plca_cfg = 0;
> 
> Unnecessary initialiser. Also, reverse Christmas-tree please.
Oops, that was not intentional. Fixed.

> > +
> > +	if (!phydev->drv) {
> > +		ret = -EIO;
> > +		goto out;
> > +	}
> > +
> > +	if (!phydev->drv->set_plca_cfg ||
> > +	    !phydev->drv->get_plca_cfg) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	curr_plca_cfg = kmalloc(sizeof(*curr_plca_cfg), GFP_KERNEL);
> 
> What if kmalloc() returns NULL?
Fixed, returning -ENOMEM now.

> 
> > +	memset(curr_plca_cfg, 0xFF, sizeof(*curr_plca_cfg));
> > +
> > +	mutex_lock(&phydev->lock);
> 
> Consider moving the above three to the beginning of the function so
> phydev->drv is checked under the mutex.
Same discussion as before. No other functions in this file do this. Let
me know how would you like to see this fixed.

> > +
> > +	ret = phydev->drv->set_plca_cfg(phydev, plca_cfg);
> > +	if (ret)
> > +		goto out_drv;
> 
> Unnecessary if() statement.
Yup, fixed.

> > +	ret = phydev->drv->get_plca_status(phydev, plca_st);
> > +
> > +	if (ret)
> > +		goto out_drv;
> 
> And here.
Fixed.


Please, let me know how to proceed.
Thanks again for your kind review.

Piergiorgio
