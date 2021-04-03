Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70003535F2
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 01:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbhDCXs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 19:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbhDCXsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 19:48:55 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B282BC061756;
        Sat,  3 Apr 2021 16:48:50 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ap14so12126989ejc.0;
        Sat, 03 Apr 2021 16:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KaKARgWuxTwlkppdVccis1BMVVCVCv4wnEn6AAlkMvQ=;
        b=bV6mo24MkR5Vjt2jpDr/R3eI1lkwj9D855nBHgYnTvdXDYxoyaLquVtX2+Xp+oQuol
         2ll79TTdNOSBzxUKXbiKH3H9foZW0DpOEQF9+0DK+TY/jaUeTKgW/G47b5hZdO+GGfjJ
         KjLIhfQezmwaUtI1OTflICfAYo8i2GvJ/8zcJTOSXgB86ucIR7DeVvFa1OvuD8Tgt+fY
         qH98yUJFDsG5EXD24crX6AiY/2NqJ5YPNtvuw0BjIRUBNW5gdKxM6o5yppfk0Q3bD9YR
         X7Cb5/Puom3g44GMHEdWvprNjgnhlSVoLF+9p8INc4NYY4B6+5jLhi9wDk3O4PxToElv
         C8Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KaKARgWuxTwlkppdVccis1BMVVCVCv4wnEn6AAlkMvQ=;
        b=hKh9KyL6RvCaS6Q8i7ls383gIWNGZUo6wwyrz/2utpuT9FX08aQCZ7a82xgulu/llL
         zP7neYDxtc6bf/ANrThKGLiDnfm+YwXuxPG7Wgx1s+sScijE/X/knqYtEqa2I9gVFIkg
         r7whPlfmjvYH3ByBx0TvIsjfJSeawK6lHus9D+o8el75b5wxNBByR9TyaWZoLeEMy708
         k2DVWon/lzCDUfSfMtK2xS/Vx/Tg/Ok0c2aPqGjxrPVZAtrzTnLDz4sMSE0Lutfl1pvb
         u1a8Yt/hgiGRPrCgGJ0+HhCNX4Xf81Dj0vd0Vctl7aofKeB5iP7MyfT2+Vs+oNAw31cJ
         F1Aw==
X-Gm-Message-State: AOAM533+0noLjjtnZNp3r3eef/XADf+hk1UPVN11Cx9OpKk85syeNNnX
        TLKjdAuespy9rMWUB95E5QU=
X-Google-Smtp-Source: ABdhPJz+wEQSSijU464niYswj3Jge9/J9JNiiGO5gK3B8k6o6FfMxa0YZORd3vLVlOHvHzudgWF+bA==
X-Received: by 2002:a17:907:929:: with SMTP id au9mr20842655ejc.28.1617493729399;
        Sat, 03 Apr 2021 16:48:49 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r13sm7858082edy.3.2021.04.03.16.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 16:48:48 -0700 (PDT)
Date:   Sun, 4 Apr 2021 02:48:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v1 5/9] net: dsa: qca: ar9331: add forwarding
 database support
Message-ID: <20210403234847.jceg4ubljdq3g7n5@skbuf>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-6-o.rempel@pengutronix.de>
 <YGiI3JtqU7Ezlbxb@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGiI3JtqU7Ezlbxb@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 05:25:16PM +0200, Andrew Lunn wrote:
> > +static int ar9331_sw_port_fdb_rmw(struct ar9331_sw_priv *priv,
> > +				  const unsigned char *mac,
> > +				  u8 port_mask_set,
> > +				  u8 port_mask_clr)
> > +{
> > +	port_mask = FIELD_GET(AR9331_SW_AT_DES_PORT, f2);
> > +	status = FIELD_GET(AR9331_SW_AT_STATUS, f2);
> > +	if (status > 0 && status < AR9331_SW_AT_STATUS_STATIC) {
> > +		dev_err_ratelimited(priv->dev, "%s: found existing dynamic entry on %x\n",
> > +				    __func__, port_mask);
> > +
> > +		if (port_mask_set && port_mask_set != port_mask)
> > +			dev_err_ratelimited(priv->dev, "%s: found existing dynamic entry on %x, replacing it with static on %x\n",
> > +					    __func__, port_mask, port_mask_set);
> > +		port_mask = 0;
> > +	} else if (!status && !port_mask_set) {
> > +		return 0;
> > +	}
> 
> As a generate rule of thumb, use rate limiting where you have no
> control of the number of prints, e.g. it is triggered by packet
> processing, and there is potentially a lot of them, which could DOS
> the box by a remote or unprivileged attacker.
> 
> FDB changes should not happen often. Yes, root my be able to DOS the
> box by doing bridge fdb add commands in a loop, but only root should
> be able to do that.

+1
The way I see it, rate limiting should only be done when the user can't
stop the printing from spamming the console, and they just go "argh,
kill it with fire!!!" and throw the box away. As a side note, most of
the time when I can't stop the kernel from printing in a loop, the rate
limit isn't enough to stop me from wanting to throw the box out the
window, but I digress.

> Plus, i'm not actually sure we should be issuing warnings here. What
> does the bridge code do in this case? Is it silent and just does it,
> or does it issue a warning?

:D

What Oleksij doesn't know, I bet, is that he's using the bridge bypass
commands:

bridge fdb add dev lan0 00:01:02:03:04:05

That is the deprecated way of managing FDB entries, and has several
disadvantages such as:
- the bridge software FDB never gets updated with this entry, so other
  drivers which might be subscribed to DSA's FDB (imagine a non-DSA
  driver having the same logic as our ds->assisted_learning_on_cpu_port)
  will never see these FDB entries
- you have to manage duplicates yourself

The correct way to install a static bridge FDB entry is:

bridge fdb add dev lan0 00:01:02:03:04:05 master static

That will error out on duplicates for you.

From my side I would even go as far as deleting the bridge bypass
operations (.ndo_fdb_add and .ndo_fdb_del). The more integration we add
between DSA and the bridge/switchdev, the worse it will be when users
just keep using the bridge bypass. To start that process, I guess we
should start emitting a deprecation warning and then pull the trigger
after a few kernel release cycles.

> > +
> > +	port_mask_new = port_mask & ~port_mask_clr;
> > +	port_mask_new |= port_mask_set;
> > +
> > +	if (port_mask_new == port_mask &&
> > +	    status == AR9331_SW_AT_STATUS_STATIC) {
> > +		dev_info(priv->dev, "%s: no need to overwrite existing valid entry on %x\n",
> > +				    __func__, port_mask_new);
> 
> This one should probably be dev_dbg().

Or deleted, along with the overwrite logic.
