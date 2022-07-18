Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE1F578E6B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 01:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiGRXoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 19:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGRXoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 19:44:04 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1580BBE35;
        Mon, 18 Jul 2022 16:44:03 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id m16so17424037edb.11;
        Mon, 18 Jul 2022 16:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kPb3YhbMUdbkmuU1gFasWy9cyqgwnfL3etorBN1mb+M=;
        b=mTDamWof7J8gAVA6krQo9+JK1EZADqe0PLEUnSqzy13GRBuimv8LxommTWQEEyb9EN
         uNIHvtYemDvlVa9Z02815G0UT6BAtM0OK/Qki859UWnFQiLvJ0W32eaOs8oJb0H8X6LB
         p3KzeVyKOOT1/eSGKnsB7MIyqhlWuYryf9+r0KYHo5Ox4dELoNlQsOPaY4fndblMPl3k
         mObhgKmJsJY8xoVJFs/OL8eithvoc0zK81rLxUkh16ov12tozMafTQ6q48/HEUSlvkEr
         C05NMzLCGB4XrtDSv/CCNAlaP8vElMMNeTnpzX+X9Nrq8FoWiNco7weM+VjHCI72Mg8R
         lNXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kPb3YhbMUdbkmuU1gFasWy9cyqgwnfL3etorBN1mb+M=;
        b=5mPiC4uW7YiXNf5nPA0JjWEMPAPavk4Yt8REm4GndkmNW93Vb1CruUsrx/7jwG4Knx
         P5H5JsJt+f7ADpA7ZDoXv9wwQfZv0f00bUVla1C9K2N0HHzIlY8DG2Fho6j7bwW5bIN8
         hZcyk4JOkMJKgu9u6nHfTstU+LowuzDYGCbjrWiJNeyaL+Pm/PLh7xrdLB7lN7ZbQk9f
         rv7EINXPSeQSqf/vgH/LKdkoiNIGzqjrVxLYrHnTZK22UeHVlWR68PMAYnOM1+JqfmOF
         35llzBjPXZXTHUH88qtFyq7bZ7ghB4/zaUpAOIPG9JY5J/GjKiNdXKbR8AtwvwkdBae2
         FAjQ==
X-Gm-Message-State: AJIora+OGdDfTb01XNCBgihGdyB1Xn+zz9951JP3/xgmuviCEb3cMXTV
        g+IoDk7l/iCuQFtASpV3QR4=
X-Google-Smtp-Source: AGRyM1sPviCrBegbjjhEiOWO6V6gOvvD6bB0qzZWiuBbzJ2G9YDV2Ldc4Vt6HuH3wA1VNerR6aXdxw==
X-Received: by 2002:aa7:c0c7:0:b0:43a:79b9:5cd1 with SMTP id j7-20020aa7c0c7000000b0043a79b95cd1mr39325013edp.282.1658187841458;
        Mon, 18 Jul 2022 16:44:01 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id d24-20020a50fb18000000b0043585bb803fsm9405069edq.25.2022.07.18.16.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 16:44:00 -0700 (PDT)
Date:   Tue, 19 Jul 2022 02:43:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
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
Message-ID: <20220718234358.27zv5ogeuvgmaud4@skbuf>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-2-ansuelsmth@gmail.com>
 <20220718180452.ysqaxzguqc3urgov@skbuf>
 <62d5a291.1c69fb81.e8ebe.287f@mx.google.com>
 <20220718184017.o2ogalgjt6zwwhq3@skbuf>
 <62d5ad12.1c69fb81.2dfa5.a834@mx.google.com>
 <20220718193521.ap3fc7mzkpstw727@skbuf>
 <62d5b8f5.1c69fb81.ae62f.1177@mx.google.com>
 <20220718203042.j3ahonkf3jhw7rg3@skbuf>
 <62d5daa7.1c69fb81.111b1.97f2@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62d5daa7.1c69fb81.111b1.97f2@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 11:54:44PM +0200, Christian Marangi wrote:
> On Mon, Jul 18, 2022 at 11:30:42PM +0300, Vladimir Oltean wrote:
> > On Mon, Jul 18, 2022 at 09:30:58PM +0200, Christian Marangi wrote:
> > > Tell me if I got this wrong.
> > > 
> > > The suggestion was to move the struct dsa_switch_ops to qca8k.h and add
> > > in the specific code probe the needed ops to add to the generic
> > > struct...
> > 
> > The declaration yes; the definition to qca8k-common.c. See for example
> > where felix_switch_ops is, relative to felix_vsc9959.c, seville_vsc9953.c
> > (users), felix.h (declaration), and felix.c (definition). Or how
> > mv88e6xxx_switch_ops does things and still supports a gazillion of switches.
> 
> Mhh I checked the example and they doesn't seems to be useful from my
> problem. But I think it's better to discuss this to the patch directly
> so you can better understand whay I intended with having dsa_switch_ops
> set to const.

So you don't modify the common dsa_switch_ops from the switch-specific
probe path, but rather, from the common dsa_switch_ops method, you call
a second function pointer.

static void felix_phylink_validate(struct dsa_switch *ds, int port,
				   unsigned long *supported,
				   struct phylink_link_state *state)
{
	struct ocelot *ocelot = ds->priv;
	struct felix *felix = ocelot_to_felix(ocelot);

	if (felix->info->phylink_validate)
		felix->info->phylink_validate(ocelot, port, supported, state);
}
