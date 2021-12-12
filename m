Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5661E471BEF
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 18:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhLLRnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 12:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhLLRnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 12:43:40 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E04C061714;
        Sun, 12 Dec 2021 09:43:40 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id w1so45059049edc.6;
        Sun, 12 Dec 2021 09:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=6jxZy8xRYInsG7E/UoONSM9RRsHHm/g+EMAdabMpAxM=;
        b=YwDOA7i5jM1IT7TxtFcLcTnF1cWD7C3s9WgDYoymUFcOBNl1w/yBV3RHrJgj65yITK
         AMWrqkuRZaSr1oorpgjXvmya0hwD+4TFxxmMbyKKW7A3hgsGnBlVwp+1OC5QfyJlWpq6
         XsMXQfzdBvPg8Ab2kWIqMXBv5yZzcUn3CTKQKUWWeBW5VmTp6ptJZwqdDJpXTUDUOweE
         7c13noAts2K2sM15eji92TnvAJsYcECD76QfuRHbnrXaewg6ipyWuFDBTBDIH4BAEq9a
         +fmQp3NxYwgu+EjxJqN6wO8tj5Rln5AWao0IilSCnJCHDlFVcV2tqfVlD1qrIWbATlOj
         f4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=6jxZy8xRYInsG7E/UoONSM9RRsHHm/g+EMAdabMpAxM=;
        b=63kwbL+H/PE4IbvEg1RJcO9VkU5NYFp/5v74GYuxGEBetwUqd/Jxt2SczDuQCnf/R3
         rWeJHidVopjwgUprNbc9yG2Qxru/fgFTgSUZ+c0gWLb57FX9uRtjmp6ReOofoD5YXrAl
         1IpQlMrb15MfqAosrPT9442097R6qKudRq4kKIVAvwsSsL+S8E1JCtYLlyx0CLW/6/6T
         /BwoW5XDw1HolO2rYC5zdYa0vvFR7U16CKmxx+kWJQAygiX6Ng7DTUtlUVk3blm7X+3z
         tCQUsEpky1eIZM+/lbfm1gnXGFZA3BQXXudRVPKR9pYRDDdMi4Vwgn9QbC9HzdtIKNBA
         MHsg==
X-Gm-Message-State: AOAM5319xRhc9mTpi2fbmHr4z5y6SyFFP7xs3xRFtVD7q5ty/XtnV+wI
        1Yx4zHgYnUjqQ2jmTMN3j3M=
X-Google-Smtp-Source: ABdhPJzEGsb9Jzf6AEu87WbaSw6dU8Hoz+BD/advDsQL6t88U1Pv2oQsw0ChmJlaESIV16ugwxueew==
X-Received: by 2002:a05:6402:3595:: with SMTP id y21mr57667583edc.332.1639331018425;
        Sun, 12 Dec 2021 09:43:38 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id de37sm4601824ejc.60.2021.12.12.09.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 09:43:38 -0800 (PST)
Message-ID: <61b634ca.1c69fb81.ebe5f.24cf@mx.google.com>
X-Google-Original-Message-ID: <YbY0xzp5RgMrJ6lL@Ansuel-xps.>
Date:   Sun, 12 Dec 2021 18:43:35 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH v4 15/15] net: dsa: qca8k: cache lo and hi
 for mdio write
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
 <20211211195758.28962-16-ansuelsmth@gmail.com>
 <8ceaa6c1-9840-17b4-73f8-1a7f665e430f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ceaa6c1-9840-17b4-73f8-1a7f665e430f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 08:04:42PM -0800, Florian Fainelli wrote:
> 
> 
> On 12/11/2021 11:57 AM, Ansuel Smith wrote:
> >  From Documentation, we can cache lo and hi the same way we do with the
> > page. This massively reduce the mdio write as 3/4 of the time we only
> > require to write the lo or hi part for a mdio write.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >   drivers/net/dsa/qca8k.c | 49 ++++++++++++++++++++++++++++++++++++-----
> >   1 file changed, 44 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 375a1d34e46f..b109a74031c6 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -94,6 +94,48 @@ qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
> >   	*page = regaddr & 0x3ff;
> >   }
> > +static u16 qca8k_current_lo = 0xffff;
> 
> Let's assume I have two qca8k switches in my system on the same or a
> different MDIO bus, is not the caching supposed to be a per-qca8k switch
> instance thing?
>

Also another user made me notice this... This problem is present from
when the driver was implemented and I think with the assumption that
only one switch was present in the device. We actually found SoC with 2
qca8k switch.
I will add a patch to move these stuff (and the cache page variable) in
the qca8k priv.

> > +
> > +static int
> > +qca8k_set_lo(struct mii_bus *bus, int phy_id, u32 regnum, u16 lo)
> > +{
> > +	int ret;
> > +
> > +	if (lo == qca8k_current_lo) {
> > +		// pr_info("SAME LOW");
> 
> Stray debugging left.
> 

Sorry.

> > +		return 0;
> > +	}
> > +
> > +	ret = bus->write(bus, phy_id, regnum, lo);
> > +	if (ret < 0)
> > +		dev_err_ratelimited(&bus->dev,
> > +				    "failed to write qca8k 32bit lo register\n");
> > +
> > +	qca8k_current_lo = lo;
> > +	return 0;
> > +}
> > +
> > +static u16 qca8k_current_hi = 0xffff;
> > +
> > +static int
> > +qca8k_set_hi(struct mii_bus *bus, int phy_id, u32 regnum, u16 hi)
> > +{
> > +	int ret;
> > +
> > +	if (hi == qca8k_current_hi) {
> > +		// pr_info("SAME HI");
> 
> Likewise
> -- 
> Florian

-- 
	Ansuel
