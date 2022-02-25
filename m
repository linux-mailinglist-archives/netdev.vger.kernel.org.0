Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4934C4172
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbiBYJ3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbiBYJ3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:29:33 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF21179A29
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:29:00 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id t14so6531761ljh.8
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1OS5DwpzVMQ4GoS13e78Fb63GgbhSJaZpM/mf/n4DU=;
        b=TxzKq1BL/ngRBCpJLEpTliwUKSILFlT9k0He/AxQIwi26tVKJ+vo/Y4lPPEmcucZLd
         GLAechaTFO4s41XFhWesHqNebBM3DG3QiAFZfPX7qJBQ8p6JUrWFAloMi+g3oFkVsTj0
         nkaFJHDY7A9e0DIi7ukqIMRjB51x0revysn1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N1OS5DwpzVMQ4GoS13e78Fb63GgbhSJaZpM/mf/n4DU=;
        b=Svtt+NFnRpq1tR5nMVeTXZxdWI00A0CcHDw4o2Jj+Y7uQeIfa/ibj7QfJjrLw6tXIX
         UtDwn0ndoNDk9oXnRbexJyORRGf0w/jgl6XgESaffHhnvwidDETSepsthhQYH7JHncV2
         rI1peN/RhLqAPvOIoClwwOLWF8ydzX/RV55toURBggynXyh8EUUp86JtwfNcCRUmGfg2
         lQbwo1eKwV58dHLa+66PsO5O3TYJ7aVi6DggMN0oysyQ9bPnC7EE6CnsPq4YLJbmr+MY
         96cTB4ZYne6LYN7KScnuLLpOVTZvSyNi19aZKlSeHhLt3ybEfSkhRa4/dinmo1Vtitbh
         Lh/Q==
X-Gm-Message-State: AOAM530koTGuiqmKMI69m062epyBFx93KdrXHIavbRLQuiUyuJDoUqjl
        fcYbxwOaPy6Rv9l2kzImaBZFs9TCOg6lbx1ai3L82Q==
X-Google-Smtp-Source: ABdhPJymxVEabR9tQNJpiB3pY4r2uaQqveoefDP2bm8WxK/gtDhNpOr/PiPXAqimTAKX0zO+06f2LajryBJ6Q5bfa5Y=
X-Received: by 2002:a05:651c:c7:b0:246:12a0:25e2 with SMTP id
 7-20020a05651c00c700b0024612a025e2mr4596421ljr.471.1645781338360; Fri, 25 Feb
 2022 01:28:58 -0800 (PST)
MIME-Version: 1.0
References: <20220218234536.9810-1-dmichail@fungible.com> <20220218234536.9810-5-dmichail@fungible.com>
 <Yhfq1N7ce/adhmN9@lunn.ch> <CAOkoqZmTc6y=qn8WeFmcupPOncCmSSEMgbXPUtR80zyRhn=qdA@mail.gmail.com>
 <YhiKo8FBHZfeHNXw@lunn.ch>
In-Reply-To: <YhiKo8FBHZfeHNXw@lunn.ch>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Fri, 25 Feb 2022 01:28:46 -0800
Message-ID: <CAOkoqZm-jUuYTX_qrZOGS5Fgx=2t2He-7TUzvvn2hMLkFPBEBg@mail.gmail.com>
Subject: Re: [PATCH net-next v7 4/8] net/funeth: ethtool operations
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 11:52 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Feb 24, 2022 at 04:57:36PM -0800, Dimitris Michailidis wrote:
> > On Thu, Feb 24, 2022 at 12:30 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > +static void fun_link_modes_to_ethtool(u64 modes,
> > > > +                                   unsigned long *ethtool_modes_map)
> > > > +{
> > > > +#define ADD_LINK_MODE(mode) \
> > > > +     __set_bit(ETHTOOL_LINK_MODE_ ## mode ## _BIT, ethtool_modes_map)
> > > > +
> > > > +     if (modes & FUN_PORT_CAP_AUTONEG)
> > > > +             ADD_LINK_MODE(Autoneg);
> > > > +     if (modes & FUN_PORT_CAP_1000_X)
> > > > +             ADD_LINK_MODE(1000baseX_Full);
> > > > +     if (modes & FUN_PORT_CAP_10G_R) {
> > > > +             ADD_LINK_MODE(10000baseCR_Full);
> > > > +             ADD_LINK_MODE(10000baseSR_Full);
> > > > +             ADD_LINK_MODE(10000baseLR_Full);
> > > > +             ADD_LINK_MODE(10000baseER_Full);
> > > > +     }
> > >
> > > > +static unsigned int fun_port_type(unsigned int xcvr)
> > > > +{
> > > > +     if (!xcvr)
> > > > +             return PORT_NONE;
> > > > +
> > > > +     switch (xcvr & 7) {
> > > > +     case FUN_XCVR_BASET:
> > > > +             return PORT_TP;
> > >
> > > You support twisted pair, so should you also have the BaseT_FULL link
> > > modes above?
> >
> > I agree with that but FW currently doesn't report BASE-T speeds in its
> > port capabilities and the link modes are based on them. Looks simple to fix
> > but needs future FW.
>
> Maybe you should drop PORT_TP until you do have the firmware fixed?

FW can report a port as BASET regardless of anything the driver
does, and it needs to be translated into something ethtool understands.
If the driver doesn't use PORT_TP what would it be then?

> > > > +static int fun_set_pauseparam(struct net_device *netdev,
> > > > +                           struct ethtool_pauseparam *pause)
> > > > +{
> > > > +     struct funeth_priv *fp = netdev_priv(netdev);
> > > > +     u64 new_advert;
> > > > +
> > > > +     if (fp->port_caps & FUN_PORT_CAP_VPORT)
> > > > +             return -EOPNOTSUPP;
> > > > +     /* Forcing PAUSE settings with AN enabled is unsupported. */
> > > > +     if (!pause->autoneg && (fp->advertising & FUN_PORT_CAP_AUTONEG))
> > > > +             return -EOPNOTSUPP;
> > >
> > > This seems wrong. You don't advertise you cannot advertise. You simply
> > > don't advertise. It could just be you have a bad variable name here?
> >
> > advertising & FUN_PORT_CAP_AUTONEG means that AN is enabled, and
> > when this bit is off AN is disabled.
>
> So, i was correct, the name of the variable is not so good. Maybe
> fp->advertising need splitting into two, fp->cap_enabled for
> capabilities of the firmware that are enabled, and fp->advertising for
> what is actually been advertised to the link partner?

There are two fields currently: port_caps is the RO capabilities field, and
advertising are the settings we are asking FW to use. Some of them may be
used in AN and advertised to the partner, FW will sort that out. The variable
may have different name and there may be more than one but eventually all
the settings need to be passed to FW as one value. It made sense to maintain
them as one value all the way. Keep in mind these settings are not consumed
by a port and need not be sensible for a port. The consumer is FW.
And while there is a close relationship these settings do not fully match what
a link partner receives in case of AN.

>      Andrew
