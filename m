Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69565A3810
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 16:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbiH0OI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 10:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiH0OI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 10:08:56 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AE94CA13;
        Sat, 27 Aug 2022 07:08:55 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id se27so85384ejb.8;
        Sat, 27 Aug 2022 07:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc;
        bh=rcZ0EJz/DZ5UPTdwT1hf/oXKDrkeM8iU7bV5Fxp9rVs=;
        b=gMmJAfApDcc2tbDqdTK4gN0SPqrwHP7kn/WLRYMHv2QDH8R4Y6isrCWtWNAZaXJ2vN
         i5ZlKDDwkkr1jgJO8+GXtWk7qdMXDebJr3fMP1kuWUU+/H/a+dARzfecG6eIC0AmPnct
         qNpjdO4hApLGqV+gCBGYv5KGnvqqGdI0Z9PzWZ1d91Wi2D1LBhJEYWmuyOWZrK7fABAp
         jSp+TsOcU2ZuWt+08hliP5YClZ4/ds5p9mNhU0cQZeIelHrvC6+XS557tcwjyAzWM5G2
         q+s1P6Wg9tD75r5c0BKzcs/TJv0SBkM1qF1nAjSAPIJPwKVpk1oiP5JlaObd/thKQ415
         rDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc;
        bh=rcZ0EJz/DZ5UPTdwT1hf/oXKDrkeM8iU7bV5Fxp9rVs=;
        b=tFU4SRgpAtyoUoyknmnHmMsaZqx3ZGKi9Ag6RBSbqo4s0x27m83WiIdd5KdjGpVioH
         1cVrM6Zgac2Ke3L9Wn3BQhe4VZpXw/8N6d+eOOH0t28pMhqKEKcedjYTppneuWau3p5w
         1p3ZQ23wcTHxDTQi7MIQE6Uu3M/9WM+xasGAM9sprt1HghB74fUrqmu2oImshE34/Js+
         4jmQbKGzG/LYBuASunSmwfDhq5GmPF9cDU7NXuoUcIUXpJmV6vQ4ce3n5nXF81Iuhlml
         3LFJ514mRVeNEtWHxj/gSuNC2540D7MyUQrjPNAd8w9O3vEZmxdUrRkzjiFZ/NxAqpu2
         aFLA==
X-Gm-Message-State: ACgBeo3WvaFloempKhFZXtypzU8atPXNlI2GiL0arnzf6eDi/KQaDrA6
        JnuywqIvMpZLMuGNd41TgaE=
X-Google-Smtp-Source: AA6agR5FNEmEpppTO8dkBIN+2n4WN5v8pjhuitQGlxoGWr6DOKQBdWl9exSh0/id5aOjeIyXq4hSNw==
X-Received: by 2002:a17:907:7f0b:b0:731:b81a:1912 with SMTP id qf11-20020a1709077f0b00b00731b81a1912mr8263133ejc.8.1661609333624;
        Sat, 27 Aug 2022 07:08:53 -0700 (PDT)
Received: from Ansuel-xps. (host-95-247-89-207.retail.telecomitalia.it. [95.247.89.207])
        by smtp.gmail.com with ESMTPSA id v12-20020a1709060b4c00b0073d7b876621sm2056584ejg.205.2022.08.27.07.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Aug 2022 07:08:53 -0700 (PDT)
Message-ID: <630a2575.170a0220.be4f4.6683@mx.google.com>
X-Google-Original-Message-ID: <YwogsmL18rdNydIq@Ansuel-xps.>
Date:   Sat, 27 Aug 2022 15:48:34 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [net-next PATCH v2] net: dsa: qca8k: convert to regmap
 read/write API
References: <20220827114918.8863-1-ansuelsmth@gmail.com>
 <YwojiJdIsz/qL1XC@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwojiJdIsz/qL1XC@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 27, 2022 at 04:00:40PM +0200, Andrew Lunn wrote:
> >  static struct regmap_config qca8k_regmap_config = {
> > -	.reg_bits = 16,
> > +	.reg_bits = 32,
> 
> Does this change really allow you to access more registers? 
>

I could be confused but I think the value was wrong from the start. (the
driver is a bit old and the regmap config struct was very wrong at
times)
This should declare how wide is each address right?

If this is the case then at times who declared the regmap config was
confused by the fact that the mdio is limited to 16 bits and require
special handling.

This is not problematic for the bits ops but is problematic for the bulk
ops as they base the calculation on these values.

Or I could be totally wrong... Anyway without this change the wrong
address is passed to the bulk ops so it's necessary (and for the said
reason, the value was wrong from the start)

> >  	.val_bits = 32,
> >  	.reg_stride = 4,
> >  	.max_register = 0x16ac, /* end MIB - Port6 range */
> > -	.reg_read = qca8k_regmap_read,
> > -	.reg_write = qca8k_regmap_write,
> > +	.read = qca8k_bulk_read,
> > +	.write = qca8k_bulk_write,
> >  	.reg_update_bits = qca8k_regmap_update_bits,
> >  	.rd_table = &qca8k_readable_table,
> >  	.disable_locking = true, /* Locking is handled by qca8k read/write */
> >  	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
> > +	.max_raw_read = 16, /* mgmt eth can read/write up to 4 bytes at times */
> > +	.max_raw_write = 16,
> 
> I think the word 'bytes' in the comment is wrong. I assume you can
> access 4 registers, each register is one 32-bit work in size.
> 

Yes you are right. Any suggestion on how to improve? 

> >  static int qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
> >  {
> > -	u32 reg[3];
> > +	u32 reg[QCA8K_ATU_TABLE_SIZE];
> >  	int ret;
> >  
> >  	/* load the ARL table into an array */
> > -	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
> > +	ret = regmap_bulk_read(priv->regmap, QCA8K_REG_ATU_DATA0, reg,
> > +			       QCA8K_ATU_TABLE_SIZE);
> >  	if (ret)
> >  		return ret;
> 
> Please split the 3 -> QCA8K_ATU_TABLE_SIZE change out into a patch of
> its own.
> 
> Ideally you want lots of small, obviously correct patches. A change
> which replaces 3 for QCA8K_ATU_TABLE_SIZE should be small and
> obviously correct, meaning it is quick and easy to review, and makes
> the more complex to review change smaller and also simpler to review.
> 

Will split in v3 hoping I get some feedback from Mark and you.

>     Andrew

-- 
	Ansuel
