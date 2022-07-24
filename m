Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5911757F78E
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiGXW6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGXW6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:58:35 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8921BE16;
        Sun, 24 Jul 2022 15:58:32 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id z23so17373641eju.8;
        Sun, 24 Jul 2022 15:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=0Ujyb+cHtuDhHKBmBhbr2ZgxoS1aSoOS99TpINCt7Rs=;
        b=G0WiTFq6zXNFCBHp7515WNCxLbnwgmBZb8xw4m8jpyHHj/jI+JAwdaUjHOapq8ImOo
         1/TgwyCmBtRtFpCS445LKNFHc0mPyNZJFd+oCKZKgVLgzGS/vlS1wHhCur9q/lOC/4BE
         h39RqbwWdnUZIKCsJpsgSBY7ziq25e/OQrsQdZJbKw9qgCmfYl2dEcqZ43ZxSqtFPGmY
         pY3LlEJbVKMDGD+ZSD1o0c8d60jpni4Q6UIJKfWlZgG/2h59otb4XkvtOc34OtNRoAi3
         EqbTgGIQQHGm2FtWO667FXCK6JeQxpXDYY9rgwh4OK+VD/njh3zu5Q/QIeCiUH4rSTVy
         Zotg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=0Ujyb+cHtuDhHKBmBhbr2ZgxoS1aSoOS99TpINCt7Rs=;
        b=SbzijMk6eEiLQJevEH70zjymn4muUfEuwZCfhdk//ax4bZIsAVwu3te+IFf9otkNx8
         AwIU+f9Cks/BQu+QKFr3tijrTma8x9GnMSU2gf81XsdpzAJ8qcUKLa29sj8aYMHEbHXV
         n7GegoXXbnlclv9Q8WWP7QSxRPbGkDv+8FUcbPl7/QNnWVHPuyPl8/UeRCQZuzP551La
         9L+tflTQ2qD86NR1b1YugdPM3IGl9Dq/hOchwPL2uMkwHUYHIufA3UemU+REamnSF0jf
         r82pebz5Yb28FxGP2OZgMrRGGSm4EwmdIrFdV9qMTZFSi4HdTKbACAMOSQWMZiRA6bq8
         PtNg==
X-Gm-Message-State: AJIora/ay23vC01wAm3ON7xn7mDB2ZRR5abyJHvGpJPKzNTKmwM4AdQW
        oyk/Z2E4dYiiDQgeKpI+7f4=
X-Google-Smtp-Source: AGRyM1tBNAXYky8X7LQiWnumEwQDFqDXi8hKAt90PhheAj1yKuUWN4Yr0RK+IMQm8jlrO5K+PoaQYg==
X-Received: by 2002:a17:907:94ce:b0:72f:2cfa:b7b7 with SMTP id dn14-20020a17090794ce00b0072f2cfab7b7mr7666480ejc.630.1658703511257;
        Sun, 24 Jul 2022 15:58:31 -0700 (PDT)
Received: from Ansuel-xps. (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.gmail.com with ESMTPSA id b27-20020a17090630db00b0072af843c794sm4639886ejb.43.2022.07.24.15.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:58:30 -0700 (PDT)
Message-ID: <62ddce96.1c69fb81.fdc52.a203@mx.google.com>
X-Google-Original-Message-ID: <Yt2rIXs2ONyjY1GT@Ansuel-xps.>
Date:   Sun, 24 Jul 2022 22:27:13 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 01/14] net: dsa: qca8k: cache match data to
 speed up access
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
 <20220724223031.2ceczkbov6bcgrtq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724223031.2ceczkbov6bcgrtq@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 01:30:31AM +0300, Vladimir Oltean wrote:
> On Sat, Jul 23, 2022 at 04:18:32PM +0200, Christian Marangi wrote:
> > Using of_device_get_match_data is expensive. Cache match data to speed
> 
> 'is expensive' sounds like it's terribly expensive. It's just more than
> it needs to be.
>

Ok will reword.

> > up access and rework user of match data to use the new cached value.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca/qca8k.c | 28 ++++++++++------------------
> >  drivers/net/dsa/qca/qca8k.h |  1 +
> >  2 files changed, 11 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
> > index 1cbb05b0323f..212b284f9f73 100644
> > --- a/drivers/net/dsa/qca/qca8k.c
> > +++ b/drivers/net/dsa/qca/qca8k.c
> > @@ -3168,6 +3155,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
> >  	if (ret)
> >  		return ret;
> >  
> > +	/* Cache match data in priv struct.
> > +	 * Match data is already checked in read_switch_id.
> > +	 */
> > +	priv->info = of_device_get_match_data(priv->dev);
> > +
> 
> So why don't you set priv->info right before calling qca8k_read_switch_id(),
> then?
> 

The idea was to make the read_switch_id a function to check if the
switch is compatible... But yhea now that i think about it doesn't
really make sense.

(Just for reference I just sent v4 as I got a report from kernel test
bot... it's really just this series with a change in 0002 patch that set
the struct for ops as a pointer... didn't encounter this with gcc but it
seems kernel test bot use some special config...)

> >  	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
> >  	if (!priv->ds)
> >  		return -ENOMEM;
> > diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
> > index ec58d0e80a70..0b990b46890a 100644
> > --- a/drivers/net/dsa/qca/qca8k.h
> > +++ b/drivers/net/dsa/qca/qca8k.h
> > @@ -401,6 +401,7 @@ struct qca8k_priv {
> >  	struct qca8k_mdio_cache mdio_cache;
> >  	struct qca8k_pcs pcs_port_0;
> >  	struct qca8k_pcs pcs_port_6;
> > +	const struct qca8k_match_data *info;
> >  };
> >  
> >  struct qca8k_mib_desc {
> > -- 
> > 2.36.1
> > 
> 

-- 
	Ansuel
