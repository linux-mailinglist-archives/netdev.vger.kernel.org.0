Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23481578E75
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 01:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbiGRXtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 19:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiGRXth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 19:49:37 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC87A1B3;
        Mon, 18 Jul 2022 16:49:36 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o8so8032907wms.2;
        Mon, 18 Jul 2022 16:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=iLn0NXzz1qwy3ndOt3BUE/qAWam0rAznbncz7Idd7u0=;
        b=EwHX62FR5PBoHoMNkxDGBQ9xqeb8Duy6XJV7m30tw9SE+rrILmN4qsxcbldWLqDPDh
         I8oP9o9+eEN1HaRTg+5alh2uyCZoSpXnc1xutwIn3gS71q/iQwwnWyqXvs7XazqV0ZEQ
         7y4GD9U3n77FjhkyDaCiTy8enH8+lerrxEJM3Wkie9+ZyZkbz2r3walRN8LaK2HgrQOn
         3v/IylMlheXP41F2ivpmT7PrY0+y0lGNOpqC19alcskaczy5M1iFDMWH5ac6lAIiwutJ
         jMGq1ywY6G/nuAukt+NuIGc939HKim5Q+8scPH2F4E7wZ1is1TxlTu8jqGQZnT4Y0Gkl
         S/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=iLn0NXzz1qwy3ndOt3BUE/qAWam0rAznbncz7Idd7u0=;
        b=q/Q75KOXLRHJYRZodBkwZS5oeHX/L8qglEHVhNhrzekuXmDJ7HIWnyUZWfRMjay0gz
         2sZ5s5MSSEr0oXCQ/nvfI1wWwcSQpdoNflIyU8Y2j5ybLiRwHoGZdGMzgdRX3VA9ojXb
         7sOTpklIMeNW0vpvYA6wkjGJAI0nw5rWGPBtfbypXdUdBfnVJC/YKepdg80/4vU6mIqN
         xDUboPHhiPWAx7iEiaSibjeboFYDBQnOAhV2EQmb9trZs5gTJryy0Zrc5YOySX9T1n0q
         lNGJtz4vD9GLsLgvhMhHQ4KPVnx48haz7iAWBQBcIBaLkvVgJb1k/6C/sZAvMUiiKfZj
         jteA==
X-Gm-Message-State: AJIora/tmqXxtq9zoFUmsViA4gz1QaqsShnbuPutKc96QIxAoh2PLTuY
        wVk/YdO9kMZF/5TcQr95R+U=
X-Google-Smtp-Source: AGRyM1vpuY6NLmRwScV7Ht0S7G8Ziutg6kU35pYhwKGbR320qhadWYQLFHpQjUrQSnqrepUhxTQqqA==
X-Received: by 2002:a1c:f716:0:b0:3a1:8f0e:66b4 with SMTP id v22-20020a1cf716000000b003a18f0e66b4mr28371963wmh.140.1658188175212;
        Mon, 18 Jul 2022 16:49:35 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id o17-20020a05600c4fd100b003a305c0ab06sm15975926wmq.31.2022.07.18.16.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 16:49:34 -0700 (PDT)
Message-ID: <62d5f18e.1c69fb81.35e7.46fe@mx.google.com>
X-Google-Original-Message-ID: <YtXtir8U4/bTR5SJ@Ansuel-xps.>
Date:   Tue, 19 Jul 2022 01:32:26 +0200
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
References: <20220716174958.22542-2-ansuelsmth@gmail.com>
 <20220718180452.ysqaxzguqc3urgov@skbuf>
 <62d5a291.1c69fb81.e8ebe.287f@mx.google.com>
 <20220718184017.o2ogalgjt6zwwhq3@skbuf>
 <62d5ad12.1c69fb81.2dfa5.a834@mx.google.com>
 <20220718193521.ap3fc7mzkpstw727@skbuf>
 <62d5b8f5.1c69fb81.ae62f.1177@mx.google.com>
 <20220718203042.j3ahonkf3jhw7rg3@skbuf>
 <62d5daa7.1c69fb81.111b1.97f2@mx.google.com>
 <20220718234358.27zv5ogeuvgmaud4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718234358.27zv5ogeuvgmaud4@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:43:58AM +0300, Vladimir Oltean wrote:
> On Mon, Jul 18, 2022 at 11:54:44PM +0200, Christian Marangi wrote:
> > On Mon, Jul 18, 2022 at 11:30:42PM +0300, Vladimir Oltean wrote:
> > > On Mon, Jul 18, 2022 at 09:30:58PM +0200, Christian Marangi wrote:
> > > > Tell me if I got this wrong.
> > > > 
> > > > The suggestion was to move the struct dsa_switch_ops to qca8k.h and add
> > > > in the specific code probe the needed ops to add to the generic
> > > > struct...
> > > 
> > > The declaration yes; the definition to qca8k-common.c. See for example
> > > where felix_switch_ops is, relative to felix_vsc9959.c, seville_vsc9953.c
> > > (users), felix.h (declaration), and felix.c (definition). Or how
> > > mv88e6xxx_switch_ops does things and still supports a gazillion of switches.
> > 
> > Mhh I checked the example and they doesn't seems to be useful from my
> > problem. But I think it's better to discuss this to the patch directly
> > so you can better understand whay I intended with having dsa_switch_ops
> > set to const.
> 
> So you don't modify the common dsa_switch_ops from the switch-specific
> probe path, but rather, from the common dsa_switch_ops method, you call
> a second function pointer.
> 
> static void felix_phylink_validate(struct dsa_switch *ds, int port,
> 				   unsigned long *supported,
> 				   struct phylink_link_state *state)
> {
> 	struct ocelot *ocelot = ds->priv;
> 	struct felix *felix = ocelot_to_felix(ocelot);
> 
> 	if (felix->info->phylink_validate)
> 		felix->info->phylink_validate(ocelot, port, supported, state);
> }

Ohhh ok now it makes sense.

If the ops is not supported should I return -ENOSUPP?
Example some ops won't be supported like the get_phy_flags or
connect_tag_protocol for example.

Anyway the series is ready, I was just pushing it... At the end it's 23
patch big... (I know you will hate me but at least it's reviewable)

My solution currently was this...

	ops = devm_kzalloc(&mdiodev->dev, sizeof(*ops), GFP_KERNEL);
	if (!ops)
		return -ENOMEM;

	/* Copy common ops */
	memcpy(ops, &qca8k_switch_ops, sizeof(*ops));

	/* Setup specific ops */
	ops->get_tag_protocol = qca8k_get_tag_protocol;
	ops->setup = qca8k_setup;
	ops->phylink_get_caps = qca8k_phylink_get_caps;
	ops->phylink_mac_select_pcs = qca8k_phylink_mac_select_pcs;
	ops->phylink_mac_config = qca8k_phylink_mac_config;
	ops->phylink_mac_link_down = qca8k_phylink_mac_link_down;
	ops->phylink_mac_link_up = qca8k_phylink_mac_link_up;
	ops->get_phy_flags = qca8k_get_phy_flags;
	ops->master_state_change = qca8k_master_change;
	ops->connect_tag_protocol = qca8k_connect_tag_protocol;

	/* Assign the final ops */
	priv->ds->ops = ops;

Will wait your response on how to hanle ops that are not supported.
(I assume dsa checks if an ops is declared and not if it does return
ENOSUPP, so this is my concern your example)

-- 
	Ansuel
