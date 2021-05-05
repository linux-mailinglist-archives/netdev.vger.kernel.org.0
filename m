Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C304373348
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhEEAqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhEEAp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 20:45:59 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C67BC061574;
        Tue,  4 May 2021 17:45:04 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id gx5so184536ejb.11;
        Tue, 04 May 2021 17:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iiaOAZWtdWY7MmcOdxDV6JZvYqkmK0vWafjCHkI22BY=;
        b=OcwmoX1Xl638v3TZOJLTOXPohHOx3ASbkHUuwdH53PvA686PbCkJEF/6rfu1x51u7H
         zfgblAwxu++rOiQSCt7dM/9RNfA38T4exRQgUBsOBJZ35ahvzvmpSv3+WHdJiNqbRFnW
         Mh1Lg+arBnshLkozd3kVTq7tvt6YPPpxI/aFjNd4SKqROUj/gHRheUOjiy+0OEfDct96
         c6iKenJ/2lkWfQ8HEvZ+Q8Be/WRSGS7PhrMQ9rOdMCw72oPf0Wkk7mWr/e+7Hyv5/W4J
         UhljI5e0BDy5jrhEPDG0nKGchThhxA3+PA8y/MR32LUrRrTgmh2qxTeUzJeBdRllwjCB
         PkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iiaOAZWtdWY7MmcOdxDV6JZvYqkmK0vWafjCHkI22BY=;
        b=VYXp0ivnb554QJFzcqskD72sWThZlMkoTmJPGvEPSrmi7LkbnxyseM45lPa0KJnb8y
         5wBR4ceOydR4Ue9cJua1eWVsoQGxeYmoqh1FZlPAMxuBkBZ29+NI/iZSW0uDL/v23wHS
         dRi6kJp0cQrSJebQbUviPvOOOCkpHlNtC8K84mJCDeA7bsYZn6ObS4zMw9GHzS8VzcOA
         YgZrxhVWeDtOzYYlmtgSqE9HUT5IAkxXRXczszVI87nnM35bOR0cMun8nRncAig1p7Nd
         dNmuzs6Z2qr4BVjfcZnAX3DlaPdq3+qo84WRPlCOrJD02ZHEIYMn9pVM61gvy74cdfU+
         w2Bw==
X-Gm-Message-State: AOAM531+b1sudGLmIvR7PxyOrWjlpx4C0dNEzHuv+Vwqtj8pxK7T2lWh
        hIXZBJgBkfqhPAJkIO2xshc=
X-Google-Smtp-Source: ABdhPJy8Yf1sL0nRCxjSNmlauL7CCtdwUDMrpg3yo/eH9Plv5hJvkMElgwZQ4UxmtliPgW6o1FbweQ==
X-Received: by 2002:a17:906:8693:: with SMTP id g19mr21449038ejx.270.1620175502782;
        Tue, 04 May 2021 17:45:02 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id k9sm15800944edv.69.2021.05.04.17.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 17:45:02 -0700 (PDT)
Date:   Wed, 5 May 2021 02:44:50 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 05/20] net: dsa: qca8k: handle error with
 qca8k_read operation
Message-ID: <YJHqgnMLEI1gQZBm@Ansuel-xps.localdomain>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-5-ansuelsmth@gmail.com>
 <YJHof4mwG7xYRc8f@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJHof4mwG7xYRc8f@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 02:36:15AM +0200, Andrew Lunn wrote:
> On Wed, May 05, 2021 at 12:28:59AM +0200, Ansuel Smith wrote:
> > qca8k_read can fail. Rework any user to handle error values and
> > correctly return.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 90 +++++++++++++++++++++++++++++++----------
> >  1 file changed, 69 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 411b42d38819..cde68ed6856b 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -146,12 +146,13 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
> >  static u32
> >  qca8k_read(struct qca8k_priv *priv, u32 reg)
> >  {
> > +	struct mii_bus *bus = priv->bus;
> >  	u16 r1, r2, page;
> >  	u32 val;
> >  
> >  	qca8k_split_addr(reg, &r1, &r2, &page);
> >  
> > -	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
> > +	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> >  
> >  	val = qca8k_set_page(priv->bus, page);
> >  	if (val < 0)
> > @@ -160,8 +161,7 @@ qca8k_read(struct qca8k_priv *priv, u32 reg)
> >  	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
> >  
> >  exit:
> > -	mutex_unlock(&priv->bus->mdio_lock);
> > -
> > +	mutex_unlock(&bus->mdio_lock);
> >  	return val;
> 
> This change does not have anything to do with the commit message.
> 
> >  }

Will split in another patch.

> >  
> > @@ -226,8 +226,13 @@ static int
> >  qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
> >  {
> >  	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
> > +	int ret;
> >  
> > -	*val = qca8k_read(priv, reg);
> > +	ret = qca8k_read(priv, reg);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	*val = ret;
> >  
> >  	return 0;
> >  }
> > @@ -280,15 +285,17 @@ static int
> >  qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
> >  {
> >  	unsigned long timeout;
> > +	u32 val;
> >  
> >  	timeout = jiffies + msecs_to_jiffies(20);
> >  
> >  	/* loop until the busy flag has cleared */
> >  	do {
> > -		u32 val = qca8k_read(priv, reg);
> > -		int busy = val & mask;
> > +		val = qca8k_read(priv, reg);
> > +		if (val < 0)
> > +			continue;
> >  
> > -		if (!busy)
> > +		if (!(val & mask))
> >  			break;
> >  		cond_resched();
> 
> Maybe there is a patch doing this already, but it would be good to
> make use of include/linux/iopoll.h
> 

Will check if I can find something to replace this.

> >  qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
> >  {
> > -	int ret;
> > +	int ret, ret_read;
> >  
> >  	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
> >  	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
> > -	if (ret >= 0)
> > -		qca8k_fdb_read(priv, fdb);
> > +	if (ret >= 0) {
> > +		ret_read = qca8k_fdb_read(priv, fdb);
> > +		if (ret_read < 0)
> > +			return ret_read;
> > +	}
> >  
> >  	return ret;
> >  }
> 
> This is oddly structured. Why not:
> 
> qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
> {
> 	int ret;
> 
> 	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
> 
> 	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
> 	if (ret < 0)
> 		return ret;
> 
> 	return qca8k_fdb_read(priv, fdb);
> }
> 

It's late here and I could be wrong...
Doesn't your suggested code change the original function return value?
In the original function we returned qca8k_fdb_access, isn't wrong to
return qca8k_fdb_read on success? Or the function was wrong from the
start?

> 	Andrew
