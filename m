Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F52455281C
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 01:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346332AbiFTXUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 19:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347441AbiFTXUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 19:20:24 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C811729C96
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 16:15:57 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id n15so1890090ljg.8
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 16:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ACcSzE4sPLh5igtp0kQduOVThK6iLFRZoulI2hJyWco=;
        b=hShbXi9DeSIHJxr+LGTJrhcvHPOZYClup9h4zZQerQLWfESumk+PhHCCBam/CMpvRJ
         5bBT9guyuQnzWc1vSirHQAoaeft8QqzvUKg59HcEPdeWmPxk6+TBQNTHmJI/CcZnOOTb
         41rx2/+SDo6OdOPZz0d7aUUIiGAztoc4AlLyC5AG+bsYY9OqMTwxk/xTCmZSQHx9uSzC
         nw9WuGQBkIXofSjXKRBxuPSVk9sH5ShOAPxPZC/5BgS8Py/6pt4J71gCMsNvUKQUPXu1
         ZWyJezWdAv4pOHlg9+C52rlpSWnf9Q4Zv7pUeOTycQ+IXRGK9+2CwzscY+Aqr3ckXrhh
         2H7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ACcSzE4sPLh5igtp0kQduOVThK6iLFRZoulI2hJyWco=;
        b=RFt43KQQFtoWHcG3/l2MMJb6cXFSRLuFghjXP3uDVCUUZQWudxGkv4b4/z9slAfXN1
         6A0roeeQSk0C1k7WMFAhImWi95GF/fhqCv05TG5k0+cMOg+QeXaFFt4me5O23M9gNLLv
         gWdoM6RBh3dGhPsU1g40y0ynl1vsAvN4OMjB+I0qjUjt9GGnla1VE+IriWHzFJtcl89t
         IZDJJvHyZF0nstIExwl1FhB4TKg9j/jSYAVtSvjGqnJBJeES438LJ7PJ6ILAkTltA4sn
         XKA8Iu23+40aO26M1iuLiBONHVPoAVRCAedYQJgvG3Pmeh/rrhwpGJernkp6DQ3QKMCZ
         b74Q==
X-Gm-Message-State: AJIora+mtOMHz0hemndSDt+F8JcocGIUvwXpWDJcatznGmsLC6j/3V+9
        TTvizikhq+aFBaXXnFNvIY8ekUGoMbm2qnBGEhySmA==
X-Google-Smtp-Source: AGRyM1sE12HnNhpR1KVDp6n2mWSnlh9HTDHWREjZfUtW1jyI38GV0tjpSD0HNkOrkRRHVPH++wwxuj7ukTc3vy6rLdE=
X-Received: by 2002:a2e:9581:0:b0:24f:2dc9:6275 with SMTP id
 w1-20020a2e9581000000b0024f2dc96275mr12615993ljh.486.1655766955772; Mon, 20
 Jun 2022 16:15:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <20220620150225.1307946-6-mw@semihalf.com>
 <YrCyeCe8sSd42Oni@smile.fi.intel.com>
In-Reply-To: <YrCyeCe8sSd42Oni@smile.fi.intel.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 21 Jun 2022 01:15:45 +0200
Message-ID: <CAPv3WKcscyUdoTpf1KS_fsS7G0oPr-WqMMAHdJ_T550J0X2LeA@mail.gmail.com>
Subject: Re: [net-next: PATCH 05/12] net: core: switch to fwnode_find_net_device_by_node()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        vivien.didelot@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 20 cze 2022 o 19:46 Andy Shevchenko
<andriy.shevchenko@linux.intel.com> napisa=C5=82(a):
>
> On Mon, Jun 20, 2022 at 05:02:18PM +0200, Marcin Wojtas wrote:
> > A helper function which allows getting the struct net_device pointer
> > associated with a given device tree node can be more generic and
> > also support alternative hardware description. Switch to fwnode_
> > and update the only existing caller in DSA subsystem.
>
> ...
>
> > +static int fwnode_dev_node_match(struct device *dev, const void *data)
> >  {
> >       for (; dev; dev =3D dev->parent) {
> > -             if (dev->of_node =3D=3D data)
>
> > +             if (dev->fwnode =3D=3D data)
>
>
> We have a helper in device/bus.h (?) device_match_fwnode().
>

That's true, thanks.

> >                       return 1;
> >       }
>
> But this all sounds like a good candidate to be generic. Do we have more =
users
> in the kernel of a such?
>

Do you mean fwnode_dev_node_match? I haven't noticed. Indeed, it may
be worth to move this one to drivers/base/property.c - what do you
think?

Thanks,
Marcin
