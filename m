Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F4157895B
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbiGRSMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGRSMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:12:36 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97472AF0;
        Mon, 18 Jul 2022 11:12:35 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a5so18224509wrx.12;
        Mon, 18 Jul 2022 11:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=iKgz5HYD7TFDPFVyTqtEWCyD0yOQ178dQj4rZKDV1YY=;
        b=Ah5RZMOlt87ELVbk1I/O8fy2OxJlPFXRk/IrcOh/Wz3IXnN8iZJFWbMwLOcko/hckR
         bDLMEG57KiuFBSHG7QC63lPvCMCfcyd70/LIO3GnIcfoXlAqpUDcLXqhSGYoH1Lzmvvi
         AXz/lJz1Uct/R3ma98/V8zq+SgydsppId9Eyrh/YN257n5nywVqTFWtOVUsEjCwAFm7k
         Xe7rcdJIQDuKed+6mEAutGcIWkKD97EnFlO+QK9aAW71ZfFYwkkKahG1yZFnD5MgQB2i
         OmCzgi23iK6OBFAqrjegIskHLlU5bNi3iDEDHcNrMHyTbSvo6RCXH43cZuW9MgB/dtWp
         gCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=iKgz5HYD7TFDPFVyTqtEWCyD0yOQ178dQj4rZKDV1YY=;
        b=iQs/LPoBWwgs8VxcMNOw1oV0X1GxdgZ2gqbcxvdgRswLPuBb+luhqhQO31rOjjhDEb
         jzlo0dYOID5PHm8pyrnnfSKDfDajavztR88ClPrvQuHH9+E/ZlTEjWGtEZVAMdeHa/iN
         BQpvIxbz7ZXOH/MIXt2XQfZsElTcENGUZxxQ2wRA3X1XHBSnGOCKoqL2ZhI6RkOJlYjK
         iXnzFeI57YoiYmimtvyV8323s2RG/BVJ63k3YwTXpW+H9QCrJ1pm51neH+WlZWWBSgsH
         2mg39hJhBV43b8dp7+fFpI7OdiuQYEhd/mG3N/qComkkiQdUjUaPLIB58UWWLFJe4uTf
         J/2Q==
X-Gm-Message-State: AJIora/RbedI2oeEk5m6pvBp7RKMvfv0ahgTD3Msnca2iq92BmkhR+E7
        GAzYOzlPpf4oTROL/Z8j1e6YPK8lG/8=
X-Google-Smtp-Source: AGRyM1tVeiYd2s1dPEAG1WjzeTG9mnUtBurUFfzaeY4XGsU97lvCHhw+h6e0lLKUrnKHjRVcIzMsrA==
X-Received: by 2002:adf:e68d:0:b0:21d:6d20:5175 with SMTP id r13-20020adfe68d000000b0021d6d205175mr24142240wrm.494.1658167954135;
        Mon, 18 Jul 2022 11:12:34 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id m6-20020a7bcb86000000b003a2d6f26babsm15753141wmi.3.2022.07.18.11.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 11:12:33 -0700 (PDT)
Message-ID: <62d5a291.1c69fb81.e8ebe.287f@mx.google.com>
X-Google-Original-Message-ID: <YtWejjCgvoSw3dxp@Ansuel-xps.>
Date:   Mon, 18 Jul 2022 19:55:26 +0200
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
Subject: Re: [net-next RFC PATCH 1/4] net: dsa: qca8k: drop
 qca8k_read/write/rmw for regmap variant
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-2-ansuelsmth@gmail.com>
 <20220718180452.ysqaxzguqc3urgov@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718180452.ysqaxzguqc3urgov@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 09:04:52PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 16, 2022 at 07:49:55PM +0200, Christian Marangi wrote:
> > In preparation for code split, drop the remaining qca8k_read/write/rmw
> > and use regmap helper directly.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca/qca8k.c | 206 +++++++++++++++++-------------------
> >  1 file changed, 95 insertions(+), 111 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
> > index 1cbb05b0323f..2d34e15c2e6f 100644
> > --- a/drivers/net/dsa/qca/qca8k.c
> > +++ b/drivers/net/dsa/qca/qca8k.c
> > @@ -184,24 +184,6 @@ qca8k_set_page(struct qca8k_priv *priv, u16 page)
> >  	return 0;
> >  }
> >  
> > -static int
> > -qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
> > -{
> > -	return regmap_read(priv->regmap, reg, val);
> > -}
> > -
> > -static int
> > -qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
> > -{
> > -	return regmap_write(priv->regmap, reg, val);
> > -}
> > -
> > -static int
> > -qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
> > -{
> > -	return regmap_update_bits(priv->regmap, reg, mask, write_val);
> > -}
> > -
> 
> Could you please explain slowly to me why this change is needed? I don't get it.
> Can't qca8k_read(), qca8k_write() and qca8k_rmw() be part of qca8k-common.c?

Sure.
When the regmap conversion was done at times, to limit patch delta it
was suggested to keep these function. This was to not get crazy with
eventual backports and fixes.

The logic here is:
As we are moving these function AND the function will use regmap api
anyway, we can finally drop them and user the regmap api directly
instead of these additional function.

When the regmap conversion was done, I pointed out that in the future
the driver had to be split in specific and common code and it was said
that only at that times there was a good reason to make all these
changes and drop these special functions.

Now these function are used by both setup function for qca8k and by
common function that will be moved to a different file.


If we really want I can skip the dropping of these function and move
them to qca8k common code.

An alternative is to keep them for qca8k specific code and migrate the
common function to regmap api.

So it's really a choice of drop these additional function or keep using
them for the sake of not modifying too much source.

Hope it's clear now the reason of this change.

-- 
	Ansuel
