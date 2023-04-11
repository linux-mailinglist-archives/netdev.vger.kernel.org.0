Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFB16DDBCA
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjDKNMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDKNMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:12:20 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724264495
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:12:19 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-94a34c2bc67so156691666b.2
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681218738;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vc+tc9PRcrEvzFy6v0KRaC+rw069dlv9u0rsptn2BDQ=;
        b=ISmD+TyYN/oxRwWJlU1bvHhSe+GrNrnuOw5jgxe8Py7iV4yJ9UflyGBR9CxryHFLQP
         U4l/kMr7papPfh3kwCRBP+U2R74bItsUA6vuwDJMr5RpB9tZaBmXKRu9TTuFuSWVKVdL
         OJxRXLSuDDVpTACAzOMGUbsSHI1ujQt+XVWnXTn1qtuYRVwv+Bd7FE7a/JqSvQNfng2b
         kwGSGOMaCqR/R1TT/+YFCekgLyjOslEjgA5X2vQC1hTTiAfB34k0fBHraVjql/DXGLtd
         xdxYvbPGfX2gjqNP/t61+5vhObKJcWLHpAkuUx6ziFsuX3bOXli27SXr5hiwsKNz5+Gx
         my5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681218738;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vc+tc9PRcrEvzFy6v0KRaC+rw069dlv9u0rsptn2BDQ=;
        b=QB27DS21pPf4t/OaOaeFq4aoeFmqoVGO4V+IRlUH01dK53bs5ZITdKl88j0Q36mn7S
         Y0cSEpOMssToMgWE9RgKipVSkr3vop65ienT2Fx/NC4GAGfVFk8y03US7cfUzjKM12iY
         f+tT5IOg+XwlJffQ8oItaNqYejVa5AwWizELamrMaEjuHzfz1gr0T52Mtz7DTRHJ+Z6R
         vnnnuC0PmLxodotAxyGZhWQcnOU5k8F++3183cYdap+ZzgOx7ozVFdiq1TGDw90QhLqP
         keHeGaVKoDSUxe8V/5YpzQ+DsTibric+9WfPVDGn8DWvvchxV0KW2vL8H9lB5fmvXmLy
         0I+g==
X-Gm-Message-State: AAQBX9duDr6vQGl+v7dbLNRJXiHUuS7IW2pSeC8F5q7YaZqSxN64jbYa
        zyBbMj/MqgsbpiSMnuh5gfo=
X-Google-Smtp-Source: AKy350Z12M0v2DNy1pqDsyz3JmbVYxB6oKJYyQUJccrFf5yhYM7L5tjIArtg3KdTeiFrIR/t7fFf3Q==
X-Received: by 2002:a05:6402:1005:b0:504:af14:132d with SMTP id c5-20020a056402100500b00504af14132dmr2577788edu.13.1681218737742;
        Tue, 11 Apr 2023 06:12:17 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ch11-20020a0564021bcb00b00504d04c939fsm55250edb.59.2023.04.11.06.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 06:12:17 -0700 (PDT)
Date:   Tue, 11 Apr 2023 16:12:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: FWD: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: Make
 flow control, speed, and duplex on CPU port configurable
Message-ID: <20230411131215.gt3lxq7ldaox3cfd@skbuf>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
 <20230411085626.GA19711@pengutronix.de>
 <ZDUlu4JEQaNhKJDA@shell.armlinux.org.uk>
 <20230411111609.jhfcvvxbxbkl47ju@skbuf>
 <ZDVJhN4vyK9ldurD@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDVJhN4vyK9ldurD@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 12:50:28PM +0100, Russell King (Oracle) wrote:
> On Tue, Apr 11, 2023 at 02:16:09PM +0300, Vladimir Oltean wrote:
> > On Tue, Apr 11, 2023 at 10:17:47AM +0100, Russell King (Oracle) wrote:
> > > Since we can't manually control the tx and rx pause enables, I think
> > > the only sensible way forward with this would be to either globally
> > > disable pause on the device, and not report support for any pause
> > > modes,
> > 
> > This implies restarting autoneg on all the other switch ports when one
> > port's flow control mode is changed?
> 
> From my reading of these global register descriptions, no it doesn't,
> and even if we did restart aneg, it would have no overall system effect
> because the advertisements for each port haven't been changed. It's
> mad hardware.
> 
> What I was meaning above is that we configure the entire switch to
> either do autonegotiated flow control at setup time, or we configure
> the switch to never do flow control.

I was thinking you were suggesting to also modify the advertisement in
software from those other ports to 00 when the flow control was forced
off on one. Otherwise (it seems you weren't), I think it's a bit
counter-productive to configure the switch to never do flow control,
when the only problem seems to be with the forced modes but autoneg is fine.

> > I don't object to documenting that manually forcing flow control off is
> > broken and leaving it at that (and the way to force it off would be to
> > not advertise any of the 2 bits).
> > 
> > But why advertise only 11 (Asym_Pause | Pause) when the PHYs integrated
> > here have the advertisement configurable (presumably also through the
> > micrel.c PHY driver)? They would advertise in accordance with ethtool, no?
> > 
> > I may have missed something.
> 
> I think you have. I'm only talking about the ability to control flow
> control manually via ethtool -A. Changing it via the advertisement
> (ethtool -s) would still work.

That part was understood.
