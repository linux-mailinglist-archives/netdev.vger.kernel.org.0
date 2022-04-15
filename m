Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D2E5028C0
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 13:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352642AbiDOLQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 07:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243960AbiDOLQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 07:16:52 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32266317;
        Fri, 15 Apr 2022 04:14:23 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bh17so14857860ejb.8;
        Fri, 15 Apr 2022 04:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iqdH5UiLsv6UeLY6oEOmNp0m4M4oujojHbWLiR5cnI8=;
        b=pu2zTa7Lt8ykU28mYDQiHbknMgYIcDrr2CE8dRCcGUlGimnUFz6IS5ORwdYAS7YIGc
         WqVqP8i51VvRxieY/2EN99NKpJeoMp17kg8XikFpY1m4ZBv0IlqJFiYcLQ28pJv10dEK
         9snweG9BOj9jKxPnKOglzTQ6g6Uww439sA/4+niF9fXOZtCjq5Z0iNjMl6uK2XV8Ikct
         1dH6VZA8/q91j7u8ogLnXX/MGqtB9VL4iGZkiawtziHHdsHlxDE3eSQF7v2A7TIHC9Ol
         GBEn8rNFtKa4E39LK+pVreFSLKvh/9LfbqM5/frEF2jFNuGFLcwTYqnJD+ayRapbZSt6
         nOkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iqdH5UiLsv6UeLY6oEOmNp0m4M4oujojHbWLiR5cnI8=;
        b=Hi7jqnBoKyIAo/pJu4FO+RKA3dDs5JU6O4L6jC9N12glz4ZXSIGUzECw2yWvQ8REGw
         ty6gA6IKFiySeNjNu5cVjax9DwDrKYOqyz0dIKIyp9VGGWZ5BQxbtoEZv4DHjHP4WQAv
         DcaBhpSC+OWOaNdYevzPIL2lGIexKnkRi8oo8sXKz7AkA1BRt6NXOrzW0q3wNDTSWSSw
         jQWx0jWobOfJRqnM5+g297i7jwmgkCGC2S+/1zmRuh4QKPWpl3yDNBegUaxwAP2oUewe
         oVvRJURFKnivsQepZ6BlM1H4G/nmksDD2wh9qg8lHUgNwm2XiN9ZL2F/7gjMEvZjKLVb
         ETrw==
X-Gm-Message-State: AOAM5311iPjT4CgNVN+IheX9D5d3YHKxj/dR+nxgbBRgk6CgZ4S5sxTT
        DZ9w+j2tXG4qkq6ioEQ06ME=
X-Google-Smtp-Source: ABdhPJyGmZ7vhU0nEBy4AMQsMyvBPHolXCSl7aXfUYkEX8oNrhdyHe4PiG5sQNwfOMDSWe8I7SWFnQ==
X-Received: by 2002:a17:906:478c:b0:6df:6b35:156d with SMTP id cw12-20020a170906478c00b006df6b35156dmr5782904ejc.578.1650021262296;
        Fri, 15 Apr 2022 04:14:22 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id o22-20020a170906289600b006e44a0c1105sm1584130ejd.46.2022.04.15.04.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 04:14:21 -0700 (PDT)
Date:   Fri, 15 Apr 2022 14:14:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <20220415111419.twrlknxuto4pri63@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-7-clement.leger@bootlin.com>
 <20220414144709.tpxiiaiy2hu4n7fd@skbuf>
 <20220415113453.1a076746@fixe.home>
 <20220415105503.ztl4zhoyua2qzelt@skbuf>
 <YllQtjybAOF/ePfG@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YllQtjybAOF/ePfG@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 12:02:14PM +0100, Russell King (Oracle) wrote:
> On Fri, Apr 15, 2022 at 01:55:03PM +0300, Vladimir Oltean wrote:
> > I meant that for a DSA switch driver is mandatory to call dsa_switch_shutdown()
> > from your ->shutdown method, otherwise subtle things break, sorry for being unclear.
> > 
> > Please blindly copy-paste the odd pattern that all other DSA drivers use
> > in ->shutdown and ->remove (with the platform_set_drvdata(dev, NULL) calls),
> > like a normal person :)
> 
> Those platform_set_drvdata(, NULL) calls should be killed - the
> driver model will set the driver data to NULL after ->remove has
> been called - so having drivers also setting the driver data to
> NULL is mere duplication.

I can see why you say that, but the reverse is not true.
A driver can be removed from a device after said device has been shut
down, and DSA does things in dsa_unregister_switch() and in
dsa_switch_shutdown() that are incompatible with each other, so either
one or the other should be called, but not both.
The platform_set_drvdata(dev, NULL) from the ->remove path may be
redundant for the reason you mentioned, but it doesn't really hurt
anything, really (it's a pointer assignment), and perhaps would lead to
even more confusion (why are we setting the drvdata to NULL from
->shutdown but not also from ->remove?).

> The only case it would matter is if someone is looking up the device
> and then accessing the driver data - and one would hope that's done
> with appropriate locking or other guarantees (e.g. driver can never
> be unbound once the driver data has been set.)

No, this isn't what is happening.
