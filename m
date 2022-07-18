Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D1657889F
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiGRRkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiGRRkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:40:45 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A4B248D3;
        Mon, 18 Jul 2022 10:40:44 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h17so18188094wrx.0;
        Mon, 18 Jul 2022 10:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=B7t6Z+KScEG7B7EtQB+fI3ykSaQfX1vJt5xsFWWEB8U=;
        b=hiPMUUhaWfgECtGSw7ZZdoCjsktidt0Ejy+OKRvrFZmi+kcVODqnbpZMB2ZU4iVBbj
         A2o813+Q+YGTj9d9ByaZjlrnE361FryRojm4tW6ZPub62k7HndDUcshNOm7k9BpPFWtu
         YodOd8+1r/1IKE49rskAGpXAnVz0lwX+Av3se+kKC4/gYrBcEyW2n7/Ipl6umUcFldtb
         Tn6E+WEV8Ci2wXLPnJeD3eH/BLIXRYCfRLdPharzpyF07qAI17BQxPXPxgf4yCXOB34H
         /bahQ/Cl1GDksDis1w7te1aHHyq3JNWFYB2fANxNtre4J1EdVZRon7dLT75PG3Xc9AS3
         rKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=B7t6Z+KScEG7B7EtQB+fI3ykSaQfX1vJt5xsFWWEB8U=;
        b=zRWqsnqw/ZXdU9E3UvZMUUzmSoN0qR4GUMHEISsJEseVYeu7cO0fQ6QwarE1gl0eVw
         XYJqEw0k9zrVZENcV/QxUaOxoayueGG3jx8yhjv0C9yAiZn4HJBFBr+fkrmZwkg1w0ux
         OXZqzn1VO7W8eQg13ZvJNjEzIs1NVsE1UdNmE4qSUkY38jimucwbfXZINaZFqdDAT0F1
         5QTli5Ef8G3kODNKb4BDkwTbR1cM2dvFtre7bIdYJMt5W3kkA6Z9Oh5Ql9vsKgyDVNud
         rq3l8VuH+WrAawqw0NCYI9Z1csPLz3aTgyALSc/cdBtzCkabwqLWZR0zK+sF+x8TRVRI
         M0fw==
X-Gm-Message-State: AJIora/bPpIjiDZOBKdpuPkY6i0GAFX34P9asq8dvbeviGtGtH38+LN7
        GS4/oEB/R8siTm9PucUVgIs=
X-Google-Smtp-Source: AGRyM1vgwM6R4nadc+Qn4B53/WRiVn12IPM1eaPMoxFHyf5yoR7eRzYn8isFgp5QHtV7QkawfEPSWg==
X-Received: by 2002:a05:6000:1545:b0:21d:8f3e:a0bd with SMTP id 5-20020a056000154500b0021d8f3ea0bdmr24323750wry.697.1658166042434;
        Mon, 18 Jul 2022 10:40:42 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id v1-20020adfebc1000000b0021b98d73a4esm11475318wrn.114.2022.07.18.10.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:40:42 -0700 (PDT)
Message-ID: <62d59b1a.1c69fb81.a5458.8e4e@mx.google.com>
X-Google-Original-Message-ID: <YtWXF8rXLBDmp1R6@Ansuel-xps.>
Date:   Mon, 18 Jul 2022 19:23:35 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/4] net: dsa: qca8k: code split for qca8k
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <62d57362.1c69fb81.33c2d.59a9@mx.google.com>
 <20220718173504.jliiboqbw6bjr2l4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718173504.jliiboqbw6bjr2l4@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 08:35:04PM +0300, Vladimir Oltean wrote:
> On Mon, Jul 18, 2022 at 04:46:20PM +0200, Christian Marangi wrote:
> > On Sat, Jul 16, 2022 at 07:49:54PM +0200, Christian Marangi wrote:
> > > This is posted as an RFC as it does contain changes that depends on a
> > > regmap patch. The patch is here [1] hoping it will get approved.
> > > 
> > > If it will be NACKed, I will have to rework this and revert one of the
> > > patch that makes use of the new regmap bulk implementation.
> > >
> > 
> > The regmap patch that this series depends on has been accepted but needs
> > some time to be put in linux-next. Considering the comments from the
> > code move, is it urgent to have the changes done or we can wait for the
> > regmap patch to get applied?
> > 
> > (this was asked from the regmap maintainer so here is the question)
> 
> If I understand correctly, what you're saying is that the regmap_bulk_read()
> change from patch 2/4 (net: dsa: qca8k: convert to regmap read/write API)
> won't work correctly without the regmap dependency, and would introduce
> a regression in the driver, right?
>

Yes you are correct.

> If so, I would prefer getting the patches merged linearly and not in
> parallel, in other words either Mark provides a branch to pull into
> net-next or you wait until the merge window opens and then closes, which
> means a couple of weeks.
> 
> The fact that in linux-next things would work isn't enough, since on
> net-next they would still be broken.
> 

Ok, so I have to keep the qca8k special function. Is it a problem if I
keep the function and than later make the conversion when we have the
regmap dependency merged?

> > > Anyway, this is needed ad ipq4019 SoC have an internal switch that is
> > > based on qca8k with very minor changes. The general function is equal.
> > > 
> > > Because of this we split the driver to common and specific code.
> > > 
> > > As the common function needs to be moved to a different file to be
> > > reused, we had to convert every remaining user of qca8k_read/write/rmw
> > > to regmap variant.
> > > We had also to generilized the special handling for the ethtool_stats
> > > function that makes use of the autocast mib. (ipq4019 will have a
> > > different tagger and use mmio so it could be quicker to use mmio instead
> > > of automib feature)
> > > And we had to convert the regmap read/write to bulk implementation to
> > > drop the special function that makes use of it. This will be compatible
> > > with ipq4019 and at the same time permits normal switch to use the eth
> > > mgmt way to send the entire ATU table read/write in one go.
> > > 
> > > (the bulk implementation could not be done when it was introduced as
> > > regmap didn't support at times bulk read/write without a bus)
> > > 
> > > [1] https://lore.kernel.org/lkml/20220715201032.19507-1-ansuelsmth@gmail.com/

-- 
	Ansuel
