Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D2A68AFAD
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 13:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBEMNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 07:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjBEMNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 07:13:30 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4461C330;
        Sun,  5 Feb 2023 04:13:29 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id n28-20020a05600c3b9c00b003ddca7a2bcbso6887862wms.3;
        Sun, 05 Feb 2023 04:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kAAmRt3jcfod+Fg8h7tuu5DlJvKnp6xC/dkRDO8nz/M=;
        b=I742z+RfnbvkgojmdXHbNkCvUNyrzvuV8qFacugqAkmBnWyXxul8+MCM/G+0cUnXAp
         ShRg9Z0RJH1C1oqVCEJIXGRt6/ha1KkKCcqKqQD5B/Z+4SazsCHBUq6OHHiMgN7nr/ZZ
         fBmTHSaofkSRnuDNo/6y5Y3BDskFPBtu5R5dzlj0ke7ZECG1L3KyL+kGgelGv/gXTWWU
         C/xsPbrGwjX72WfFzEkCFgSlivkWysoeF0TsiW66mkq/9meYv1EXPfffMoRpA4yFkRAf
         tNoxkT5tjbCeiDA61zl48eMvxjpJ/2RU+OvGmO/oC6h9zHCinwlZVbvpBJCgyR/R++nf
         uCkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kAAmRt3jcfod+Fg8h7tuu5DlJvKnp6xC/dkRDO8nz/M=;
        b=Mdb/5XdyBLTd5UzHeA0RbTTp+t5n7JbPGZkAN+TnQtdYFIEW+n7NERCa3VaRFhVL4T
         dKz2GsX59JBdR3vaiFlom1dHdiQ2wM6gP4xT7AW7bQFNOMqaCMtKi1qdeBRJgstkkv9F
         I2IP+zVfXyb36t4CTH9RYLwnzLlg8bh29lf6mLTltbRU6BKYSjy0ZXt1cyOkIAXJ0p6i
         +YEQFb8p2gwoECYieMss2U7hLVKPR8/feEj2dmw22cIDU/o5URvC81Hm0yCXNdANJtVf
         1io7+JSzz9Wmx9Pfi9JWz4sRT5cOmwtAbqTgddxvuoJ1aEyZNnxuTVZJsxuTD5GaVUq1
         EXUQ==
X-Gm-Message-State: AO0yUKUy+lMifARk/s3OAXw/oNNWBfsUI/wFFS05mo2QNWLyMdsmJWlc
        2O0NoB/hy+bMxplr4qVfOjI=
X-Google-Smtp-Source: AK7set9bkIfJteTm9JoUtPZPOtkDJ5gNgWAED7jQCuTbU8Em/dyiZifnw4V+m+TvJbbNc/fKEoAiaw==
X-Received: by 2002:a05:600c:2286:b0:3df:fbc7:5b10 with SMTP id 6-20020a05600c228600b003dffbc75b10mr1668757wmf.0.1675599207357;
        Sun, 05 Feb 2023 04:13:27 -0800 (PST)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id hg15-20020a05600c538f00b003df7b40f99fsm10949027wmb.11.2023.02.05.04.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Feb 2023 04:13:26 -0800 (PST)
Date:   Sun, 5 Feb 2023 14:13:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 9/9] net: dsa: mt7530: use external PCS driver
Message-ID: <20230205121324.a7ah2upjpzij5rsc@skbuf>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <cover.1675407169.git.daniel@makrotopia.org>
 <677a5e37aab97a4f992d35c41329733c5f3082fb.1675407169.git.daniel@makrotopia.org>
 <677a5e37aab97a4f992d35c41329733c5f3082fb.1675407169.git.daniel@makrotopia.org>
 <20230203221915.tvg4rrjv5cnkshuf@skbuf>
 <Y95zaIJbCj3QIdqC@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y95zaIJbCj3QIdqC@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 04, 2023 at 03:02:00PM +0000, Daniel Golle wrote:
> Hi Vladimir,
> 
> thank you for the review!
> 
> On Sat, Feb 04, 2023 at 12:19:15AM +0200, Vladimir Oltean wrote:
> > On Fri, Feb 03, 2023 at 07:06:53AM +0000, Daniel Golle wrote:
> > > @@ -2728,11 +2612,14 @@ mt753x_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
> > >  
> > >  	switch (interface) {
> > >  	case PHY_INTERFACE_MODE_TRGMII:
> > > +		return &priv->pcs[port].pcs;
> > >  	case PHY_INTERFACE_MODE_SGMII:
> > >  	case PHY_INTERFACE_MODE_1000BASEX:
> > >  	case PHY_INTERFACE_MODE_2500BASEX:
> > > -		return &priv->pcs[port].pcs;
> > > +		if (!mt753x_is_mac_port(port))
> > > +			return ERR_PTR(-EINVAL);
> > 
> > What is the reason for returning ERR_PTR(-EINVAL) to mac_select_pcs()?
> 
> The SerDes PCS units are only available for port 5 and 6. The code
> should make sure that the corresponding interface modes are only used
> on these two ports, so a BUG_ON(!mt753x_is_mac_port(port)) would also
> do the trick, I guess. However, as dsa_port_phylink_mac_select_pcs may
> also return ERR_PTR(-EOPNOTSUPP), returning ERR_PTR(-EINVAL) felt like
> the right thing to do in that case.
> Are you suggesting to use BUG_ON() instead or rather return
> ERR_PTR(-EOPNOTSUPP)?

I was not suggesting anything, I was just asking why the inconsistency
exists between the handling of SERDES protocols on ports != 5 or 6
(return ERR_PTR(-EINVAL)), and the handling of unknown PHY modes
(return NULL). If you don't want to convey any special message, then
returning NULL to phylink should be sufficient to say there is no PCS.
The driver already ensures that phylink validation fails with wrong PHY
mode on wrong port due to the way in which it populates supported_interfaces
in mt7531_mac_port_get_caps().

Also, no BUG_ON() for the reasons Andrew pointed out.

> > > +		return priv->sgmii_pcs[port - 5];
> > 
> > How about putting the pcs pointer in struct mt7530_port?
> 
> There are only two SerDes units available, only for port 5 and port 6.
> Hence I wouldn't want to allocate additional unused sizeof(void*) for
> ports 0 to 4.

I asked the question fully knowing that there will be no more than 2
ports with a non-NULL PCS pointer. There's a time and place for
(premature) optimizations, but I don't think that the control path of a
switch is one particular place that comes at the top. Between
priv->ports[port].sgmii_pcs and priv->sgmii_pcs[port - 5], my personal
sensibilities for simple and maintainable code would always choose the
former. However I'm not going to cling onto this. Whichever way you prefer.

> > > +	for (i = 0; i < 2; ++i)
> > 
> > There is no ++i in this driver and there are 11 i++, so please be
> > consistent with what exists.
> 
> As most likely in all cases a pre-increment is sufficient and less
> resource consuming than a post-increment operation we should consider
> switching them all to ++i instead of i++.
> I will anyway use i++ in v2 for now.

And what would you suggest is the difference in the compiled code between
"for (i = 0; i < n; i++)" and "for (i = 0; i < n; ++i)"?
