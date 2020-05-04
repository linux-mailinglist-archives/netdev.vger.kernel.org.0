Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011AF1C4727
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgEDTkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDTkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:40:52 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E17C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 12:40:52 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d16so14625728edq.7
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 12:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G6A0Q+uoLys/Rzun70bN1hx7UWBp/vddiodbKw/2ZRo=;
        b=gUmXHwoRoHciBIb0jFG7+l0ub81Lu95cmMs+kA9kyHBi0C+gOzIv9OJk/LdSxp08W+
         kEXl5LgbU88if2iIzTY3Gu/XhJ6kG7SVyeWQramf2nTVVWsaGkrWDOR1qFtGCJEE8myX
         p9VKDHJtHMf6vQ6+GzpPzi+bX4vSJTzDjMlPGlqkbGuV8lm0O/7MaY1Dyvk/1VOSTxMF
         qEvxb0MwCutZAo7gV8UFzEtNzcybyLawqOiQfWiXX5j9gHyeO+fVLtkx40hLLDmlKtdG
         slmIkH3L74q6oBlezPFzsjvZZ0AWwKx+catGjlE3pCHWJj8oU/c4StHMUBU01x5/BsPL
         8eSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G6A0Q+uoLys/Rzun70bN1hx7UWBp/vddiodbKw/2ZRo=;
        b=qlHZ7rPdV+eLyxoe6lJC+MO2oHxC/V6IjCGHdmM1ZbuRWAs4t7NWHHGPXW9NqYdhjc
         POHEm+4K8qiqsXd3ql8PD5/t2rwY2jxci8cyhwFy2bojyczevbWQsTtXueYSw0pSOJ6F
         CFy25B9XluzwJa5QxDHZ1WPHfYvE0NPAOXyckianwYAxKwIYYhPEeGlQj1+D58blJPy9
         8Z+1smawo45DIWRVgakrLhsdZBIkp99epiC5Wqp7R+h+KUTUbrDdd5MA9+/o0PfGQuFb
         rMYi024XRkGikFxJ98eRb2vrYtHiUbn2u1Y4I3ddMt0c0QidKaYb4KZnjNv9EQH5O8cl
         JQVA==
X-Gm-Message-State: AGi0PubT/cpRY7rV5CIrdfigETf7pFVVNNkmc3FnHQ9iB7zLo3CM/+OM
        aI1D/qzjU16/VjmiHE3s7xQDBDQjRcBESS5+zrU=
X-Google-Smtp-Source: APiQypKQptpA6R4MAKKLanEYpDgZ58dzJvOsms2SAs9s/6OngnWF2Yfz2qERwJoFlXX2lCU9vyrhZoz2eb0TPTEksCc=
X-Received: by 2002:a50:a2e5:: with SMTP id 92mr16440856edm.139.1588621250909;
 Mon, 04 May 2020 12:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200503211035.19363-1-olteanv@gmail.com> <20200503211035.19363-5-olteanv@gmail.com>
 <20200504141913.GB941102@t480s.localdomain> <20200504142302.GD941102@t480s.localdomain>
 <CA+h21howxs23VkvTVk3BiepQz7Z1vXgRiE1w+F1eeHYqYZmLpA@mail.gmail.com> <20200504152428.GB950689@t480s.localdomain>
In-Reply-To: <20200504152428.GB950689@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 4 May 2020 22:40:40 +0300
Message-ID: <CA+h21hpJCN6ud6bvJpF-P7by0upDVEqZBZbyzb3-wCVJkiWs=w@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] net: dsa: sja1105: support flow-based
 redirection via virtual links
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        Christian Herber <christian.herber@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        vlad@buslov.dev, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 May 2020 at 22:24, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> Hi Vladimir,
>
> On Mon, 4 May 2020 21:38:26 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > Hi Vivien,
> >
> > On Mon, 4 May 2020 at 21:23, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> > >
> > > On Mon, 4 May 2020 14:19:13 -0400, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> > > > Hi Vladimir,
> > > >
> > > > On Mon,  4 May 2020 00:10:33 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > > +           case FLOW_ACTION_REDIRECT: {
> > > > > +                   struct dsa_port *to_dp;
> > > > > +
> > > > > +                   if (!dsa_slave_dev_check(act->dev)) {
> > > > > +                           NL_SET_ERR_MSG_MOD(extack,
> > > > > +                                              "Destination not a switch port");
> > > > > +                           return -EOPNOTSUPP;
> > > > > +                   }
> > > > > +
> > > > > +                   to_dp = dsa_slave_to_port(act->dev);
> > > >
> > > > Instead of exporting two DSA core internal functions, I would rather expose
> > > > a new helper for drivers, such as this one:
> > > >
> > > >     struct dsa_port *dsa_dev_to_port(struct net_device *dev)
> > > >     {
> > > >         if (!dsa_slave_dev_check(dev))
> > > >             return -EOPNOTSUPP;
> > >
> > > Oops, NULL, not an integer error code, but you get the idea of public helpers.
> > >
> > > >
> > > >         return dsa_slave_to_port(dev);
> > > >     }
> > > >
> > > > The naming might not be the best, this helper could even be mirroring-specific,
> > > > I didn't really check the requirements for this functionality yet.
> > > >
> > > >
> > > > Thank you,
> > > >
> > > >       Vivien
> >
> > How about
> >
> > int dsa_slave_get_port_index(struct net_device *dev)
> > {
> >     if (!dsa_slave_dev_check(dev))
> >         return -EINVAL;
> >
> >     return dsa_slave_to_port(dev)->index;
> > }
> > EXPORT_SYMBOL_GPL(dsa_slave_get_port_index);
> >
> > also, where to put it? slave.c I suppose?
>
> dsa.c is the place for private implementation of public functions. "slave"
> is a core term, no need to expose it. Public helpers exposed in dsa.h usually
> scope the dsa_switch structure and an optional port index. mv88e6xxx allows
> mirroring an external device port,

For mirroring an entire port (via tc-matchall), the tc structures are
already parsed by DSA core and a simple API is given to drivers. The
discussion we're having is for flow-based mirroring (via tc-flower)
where that is not the case.

> so dsa_port would be preferred, but this
> can wait. So I'm thinking about implementing the following:
>
> net/dsa/dsa.c:
>
> int dsa_to_port_index(struct dsa_switch *ds, struct net_device *dev)

But let's assume for a second that mv88e6xxx supports flow-based
mirroring/redirection too.
Aren't we limiting ourselves uselessly here, by requiring the caller
to pass a ds pointer just to perform validation on it? I think it's a
valid use case to want to support cross-chip mirroring/redirection
sometime in the future. Both sja1105 and mv88e6xxx support that kind
of setup, you just need to set the destination port to
dsa_towards_port() in case the dp->ds found by dsa_slave_to_port does
not coincide with ours. But surprise, using the syntactic sugar API
we're introducing here, we'd get -EINVAL and we would have to somehow
try again and guess with a ds pointer we don't have.

> {
>     struct dsa_port *dp;
>
>     if (!dsa_slave_dev_check(dev))
>         return -ENODEV;
>
>     dp = dsa_slave_to_port(dev);
>
>     if (dp->ds != ds)
>         return -EINVAL;
>
>     return dp->index;
> }
>
> include/net/dsa.h:
>
> int dsa_to_port_index(struct dsa_switch *ds, struct net_device *dev);
>
>
> What do you think?

I'm actually not convinced about this idea. I think the function that
should be called should be named dsa_slave_to_port, and it should
return a struct dsa_port. Quite conveniently, that function already
exists. I'm not actually sure what are the issues of exposing the
existing functions.

>
>         Vivien

Thanks,
-Vladimir
