Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A4A2F77A6
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 12:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbhAOL3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 06:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbhAOL3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 06:29:55 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399D6C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 03:29:14 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id p22so9117665edu.11
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 03:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L5wD3Bc8rS1j2y8BCWxcwi5Uh9TSBj1p2F5PvmQCRLY=;
        b=m/FOsOpDp4qI6VPZZ5SXZ+W2uNL1964lpOqPPksAkAUEY4mKfHkHmsSpmb57u8MLI5
         VhjOFQMhJ2VuVJbb0mIKN2kJcZTAf2dRvbMHBRApWK5evuEpwNjtrkDdnY1W5IaTbiCh
         N3LfJQpSqSZvnHeWzCZ+jkLh0fy5ggfBzjv+mD5kPogDUMM3Z6ev5Jn3tHGsByJXk/Fk
         +20jv3+j6OsDOILMBICKRCJbiGN8c/oT3NpCo8zd/e1qtUyw23sYCQ0O/01CrdKlqSce
         /ZIi2HnSoTY5jHeEDERS//oI4ZTJczVqmUcz1aAKQjq02WUhfWraoRG9ehxfcfEFAxyM
         ECvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L5wD3Bc8rS1j2y8BCWxcwi5Uh9TSBj1p2F5PvmQCRLY=;
        b=OLxD/Oafcd0VszaMl3E8stSN/q24Pi9hmkXVZlsu279WR+fGxk7dtljK20QRWxWUIO
         0ke2P8uIW2c+vU2dmUOAYRf54dXjg4aGLnYAaOrV6vjry6ZSaLoexZbL0FEHV240FEZD
         Px9rClDcNtGBS3NJYOanqMuKejuvSSWx5EZ4pTGytG3zanEmYRbLs9iXLw2kfhneN01D
         cpMiQr92RBSoo2vOrbgAkDh2GYKpczWK3Ufulf4YDxaP3zC/B3+9aJVnRnppnWrESKqd
         pHd7BIzN0RcKyH6fOg1ZaI2Pha3ehtSSYmFjYmwL3DL248nERbdMWq5cGj5fCsNh5vZH
         sMKQ==
X-Gm-Message-State: AOAM533C0lm6mkAggNnli30Qn3t6fYQOLlwj1+heuCny5HAJM0kaE0ya
        kFaLl8Jypk648I6S8TQUZEk=
X-Google-Smtp-Source: ABdhPJwmZmloc9H9bNUGUrnWWz8j6xu3IE0Z6xbRhxZukl1vhSThGgKUQqd/mSw0/XCpC8MrNNlXfA==
X-Received: by 2002:a05:6402:b79:: with SMTP id cb25mr9052752edb.346.1610710152911;
        Fri, 15 Jan 2021 03:29:12 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id 38sm916254edq.62.2021.01.15.03.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 03:29:12 -0800 (PST)
Date:   Fri, 15 Jan 2021 13:29:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Only allow LAG offload
 on supported hardware
Message-ID: <20210115112911.glhs4lxygpqddrm3@skbuf>
References: <20210115105834.559-1-tobias@waldekranz.com>
 <20210115105834.559-3-tobias@waldekranz.com>
 <20210115111523.64itmntrl2ykn43x@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115111523.64itmntrl2ykn43x@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 01:15:23PM +0200, Vladimir Oltean wrote:
> On Fri, Jan 15, 2021 at 11:58:34AM +0100, Tobias Waldekranz wrote:
> > There are chips that do have Global 2 registers, and therefore trunk
>                        ~~
>                        do not
> > mapping/mask tables are not available. Additionally Global 2 register
> > support is build-time optional, so we have to make sure that it is
> > compiled in.
> > 
> > Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> > ---
> >  drivers/net/dsa/mv88e6xxx/chip.c | 4 ++++
> >  drivers/net/dsa/mv88e6xxx/chip.h | 9 +++++++++
> >  2 files changed, 13 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> > index dcb1726b68cc..c48d166c2a70 100644
> > --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > @@ -5385,9 +5385,13 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
> >  				      struct net_device *lag,
> >  				      struct netdev_lag_upper_info *info)
> >  {
> > +	struct mv88e6xxx_chip *chip = ds->priv;
> >  	struct dsa_port *dp;
> >  	int id, members = 0;
> >  
> > +	if (!mv88e6xxx_has_lag(chip))
> > +		return false;
> > +
> >  	id = dsa_lag_id(ds->dst, lag);
> >  	if (id < 0 || id >= ds->num_lag_ids)
> >  		return false;
> > diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> > index 3543055bcb51..333b4fab5aa2 100644
> > --- a/drivers/net/dsa/mv88e6xxx/chip.h
> > +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> > @@ -662,6 +662,15 @@ static inline bool mv88e6xxx_has_pvt(struct mv88e6xxx_chip *chip)
> >  	return chip->info->pvt;
> >  }
> >  
> > +static inline bool mv88e6xxx_has_lag(struct mv88e6xxx_chip *chip)
> > +{
> > +#if (defined(CONFIG_NET_DSA_MV88E6XXX_GLOBAL2))
> > +	return chip->info->global2_addr != 0;
> > +#else
> > +	return false;
> > +#endif
> > +}
> > +
> 
> Should we also report ds->num_lag_ids = 0 if !mv88e6xxx_has_lag()?
> 
> >  static inline unsigned int mv88e6xxx_num_databases(struct mv88e6xxx_chip *chip)
> >  {
> >  	return chip->info->num_databases;
> > -- 
> > 2.17.1
> > 

Actually in mv88e6xxx_detect there is this:

	err = mv88e6xxx_g2_require(chip);
	if (err)
		return err;


#else /* !CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */

static inline int mv88e6xxx_g2_require(struct mv88e6xxx_chip *chip)
{
	if (chip->info->global2_addr) {
		dev_err(chip->dev, "this chip requires CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 enabled\n");
		return -EOPNOTSUPP;
	}

	return 0;
}

#endif

So CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 is optional only if you use chips
that don't support the global2 area. Otherwise it is mandatory. So I
would update the commit message to not say "Additionally Global 2
register support is build-time optional", because it doesn't matter.

So I would simplify it to:

static inline bool mv88e6xxx_has_lag(struct mv88e6xxx_chip *chip)
{
	return !!chip->info->global2_addr;
}
