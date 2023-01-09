Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA296625C3
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbjAIMlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjAIMlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:41:22 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C34DED8;
        Mon,  9 Jan 2023 04:41:21 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id c17so12263984edj.13;
        Mon, 09 Jan 2023 04:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JGewXTLqSFz0s2fQ/uiqIpRGEfPE9NdhCOeAHQbwGQ4=;
        b=niw7LwOoXihZAh8slgQZqcziXoVi78Vi+LO4SGwAlxnMerGgKYyKrD7KNQ6i5NAmhM
         BGS4Z6cn31pJ6astgoj9Y3UwY0GdTwvwTBpNxSrW2N9UdXD+R/Sv1VTszs6TLG+q2gZd
         0S+vZSl0qR7C6vpZhXvDk9hWPJJLITkm6aA0U6S6wQnP03t0vYb5y2QPilAz18Sr5zZU
         5HEdF3cqTQ5SVv8GSqVb8TpcUw6KYbG8tUWh/aF52RGJ7gmHyAc1G3jpwlDTKQhHNkVt
         +GpGqybeJWI3IzbVIhdRfniC78iIe8dc2p5rNazLHzJfAuO0dkMJ+b1vBtbXAhHF/21g
         akiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JGewXTLqSFz0s2fQ/uiqIpRGEfPE9NdhCOeAHQbwGQ4=;
        b=tBcm8oW1ehgbe3JufCFMO4X76YIMscami/BnpEs4PaX0KofhGszsdWX+o4hjpvGVaa
         /2dRjbhL8xxW8CcgHMO8MprmzQFe6eV1/S4DsB8iAwlqMftAujx3XDZ8d7J/+OOo3+Yb
         dn860Ug3bPqUrG2W17c4PWSu16ZJMIZDDncWkjiIyaj3tVuO2tFem2pbo9ztgS2Y2wpL
         EuBwzGho9WyH2fX2LWFGbarGHonGQKQJaGV1kjS8OnAwSzJbV0ApEPzExgYR9NQbupZL
         SokMV4+oZMgs3IeLsyI4MQ4FwW+AX3qDjKajQIP//raQQhpoykvQa2JEeHZikY+EHJei
         TTnw==
X-Gm-Message-State: AFqh2krC9psBl/ESU7dmdKOA0YQIDOWq+BGxrdc3/TPoKJ7PKgkwq1to
        KRRRbHuS+OK4ElqDVl57pcnF0AcA8rtCLg==
X-Google-Smtp-Source: AMrXdXtozY8/sv9/RZyH7AHeqkHau1dX6bYb3YdTbSW3LGoOzTXLWxtDsVajIZDFvgbgxNFh6NQyOA==
X-Received: by 2002:a05:6402:3ce:b0:481:f14d:fda5 with SMTP id t14-20020a05640203ce00b00481f14dfda5mr51894230edw.39.1673268079446;
        Mon, 09 Jan 2023 04:41:19 -0800 (PST)
Received: from skbuf ([188.27.185.38])
        by smtp.gmail.com with ESMTPSA id j17-20020a17090623f100b00770812e2394sm1668190ejg.160.2023.01.09.04.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 04:41:18 -0800 (PST)
Date:   Mon, 9 Jan 2023 14:41:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH RFC net-next v2 03/12] net: mdio: mdiobus_register:
 update validation test
Message-ID: <20230109124116.tqsnhh6xvg6e4m4l@skbuf>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-3-ddb37710e5a7@walle.cc>
 <Y7P/45Owf2IezIpO@shell.armlinux.org.uk>
 <37247c17e5e555dddbc37c3c63a2cadb@walle.cc>
 <Y7SqCRkYkhQCLs8z@shell.armlinux.org.uk>
 <0584195b863b361a4f5c1e27e6c270b3@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0584195b863b361a4f5c1e27e6c270b3@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 01:35:29PM +0100, Michael Walle wrote:
> Hi Russell,
> 
> Am 2023-01-03 23:19, schrieb Russell King (Oracle):
> > On Tue, Jan 03, 2023 at 11:21:08AM +0100, Michael Walle wrote:
> > > Am 2023-01-03 11:13, schrieb Russell King (Oracle):
> > > > On Wed, Dec 28, 2022 at 12:07:19AM +0100, Michael Walle wrote:
> > > > > +	if (!bus || !bus->name)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	/* An access method always needs both read and write operations */
> > > > > +	if ((bus->read && !bus->write) ||
> > > > > +	    (!bus->read && bus->write) ||
> > > > > +	    (bus->read_c45 && !bus->write_c45) ||
> > > > > +	    (!bus->read_c45 && bus->write_c45))
> > > >
> > > > I wonder whether the following would be even more readable:
> > > >
> > > > 	if (!bus->read != !bus->write || !bus->read_c45 != !bus->write_c45)
> > > 
> > > That's what Andrew had originally. But there was a comment from
> > > Sergey [1]
> > > which I agree with. I had a hard time wrapping my head around that,
> > > so I
> > > just listed all the possible bad cases.
> > 
> > The only reason I suggested it was because when looked at your code,
> > it also took several reads to work out what it was trying to do!
> > 
> > Would using !!bus->read != !!bus->write would help or make it worse,
> > !!ptr being the more normal way to convert something to a boolean?
> 
> IMHO that makes it even harder. But I doubt we will find an expression
> that will work for everyone. I'll go with your suggestion/Andrew's first
> version in the next iteration.

I think the double negation conveys the intention better than the simple
one, actually (maybe even xor instead of != ?). In terms of readability
I think I prefer the way the patch is written right now, but if you keep
the comment, the double negation should be pretty easy to swallow too.
