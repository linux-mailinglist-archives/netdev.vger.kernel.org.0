Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8AB25AC6AA
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 23:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiIDVfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 17:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiIDVfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 17:35:06 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D5D17067;
        Sun,  4 Sep 2022 14:35:03 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id p16so13552101ejb.9;
        Sun, 04 Sep 2022 14:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date;
        bh=XvzNtn9ky9vTYx0e7IV7VY2mf2Ne8bG8PsdvE3HzZyI=;
        b=cxnEI8xRF8+DSgAuy4E/jJwR6BpcO/8kOmw9n0o/wN7xD4x/j6lKIR10qRYBNvA5NO
         +a1h5XKGSvgvgXt8ePebs99aexXCF/aBBYfRTKXmcLIdqb2tH6eJNGkVlOv1zk4emLWh
         P9GFi8IC1glIFhu1Ts4QKlsCWDt7TxRYoiAHLGr0ZluuD1fp15zhC3WlUN99jeOGrNFg
         TJaTHailfBfLSy9BNljN7n59X7+fhOSbZfG6TaNSc0QWVzbdkqhWyvCizBOhYzy0DcHx
         j9jBIbFb45aFdwtH0rwA9A0NBRgO+dVvb8gZ0/o2fTJ8tALbfqDb64VcaAQ7/C5h0clc
         n2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=XvzNtn9ky9vTYx0e7IV7VY2mf2Ne8bG8PsdvE3HzZyI=;
        b=r2gcW/hW6eamusuJqo+s3SLmOpZXFZN2NsKsS2TR92Jymv+hHLIa9ktDopIkEqT9hO
         61Jy+11bCekrmXJQGxOag7gBzaestIwqgoFUaoMPAofBZnkGSS8voZIAcstL8FNlythO
         /G9D4cdPGF8zmJ6TrF8Bd0HJIbV1rw7bEX7qjEW8inwWE6FV380ws+YauNNz/kubzGaZ
         SyiuVUBqWU0MmIa/HPkiQYoYl5XIVZOTQDBE1FLOqQkwwly6VpBFB0Y/elp6QhfMhuWi
         iEEhge1VReCcGukiqACBH4+Oh8OTR8bLUFx4ifkCjwffnpbeQEyqxIJ0PmXYumrXcdnc
         PusQ==
X-Gm-Message-State: ACgBeo1SVsYWGW/3GNA/5vXsgzm45qb4/kuthi1BRjXYfKwgEgUEThUa
        4Ae3wcrdt1qztuJdp0QYPsrasS/mq5Y=
X-Google-Smtp-Source: AA6agR5fZ0ae2yJbaFSZDJ4vQiCkVAAFWg8uoLPv96/kW6v8cgzPFyMTymtw7GIlmkgDVMG+I8N5Rw==
X-Received: by 2002:a17:906:8a68:b0:741:56b2:af42 with SMTP id hy8-20020a1709068a6800b0074156b2af42mr26382327ejc.488.1662327301711;
        Sun, 04 Sep 2022 14:35:01 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id 8-20020a170906328800b0073dbaeb50f6sm4112150ejw.169.2022.09.04.14.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Sep 2022 14:35:01 -0700 (PDT)
Message-ID: <63151a05.170a0220.aa1b5.6cd8@mx.google.com>
X-Google-Original-Message-ID: <YxUaAn8PYhNgroQA@Ansuel-xps.>
Date:   Sun, 4 Sep 2022 23:34:58 +0200
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
>     Andrew

I'm working on v3.
I manage to make everything work with 16 bit. (It was set as the max reg
for this switch is 0x16ac)

Anyway on second look, this change is necessary and I think split this
in another patch would be redundant and problematic. (for backporting
purpose and to correctly write a sane commit description)

The regmap bulk implementation take as the 4th arg the count of reg to
read/write. Current implementation instead take the actual size of the
array. So I think this has to be changed in the bulk conversion patch.

I can split it but it will be something like

qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, 
		 QCA8K_ATU_TABLE_SIZE * sizeof(u32));

and on the bulk conversion commit I have to drop it again to 

regmap_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg,
                 QCA8K_ATU_TABLE_SIZE);

Seems a bad thing to make a change and than fix that change on the next
commit.

Will wait for a response about this and propose v3 with what is the
correct approach.

-- 
	Ansuel
