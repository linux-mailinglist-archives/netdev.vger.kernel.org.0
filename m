Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A03558ED6F
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 15:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiHJNfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 09:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiHJNfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 09:35:36 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFE543E51
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 06:35:35 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id dc19so27686069ejb.12
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 06:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=tBU+emZT1UQ9Em7lgQad4v8PopJDYpaoNqIJ7SDDf+4=;
        b=V/v3r4WoTz3AQQ+88R4bBxZShHrmfoHrfspTVDkfUAECnAl99isqRlvEwsz+9Y3+vB
         pqopA6/xryH1yQygGrX4HvkZ5W8jwJhRngPe26rALQXhp2rL5hr9ztfA038Ii+tOBTW0
         xfLg2Q5ikEZGz5ry+rXufH1lREVzMSyjDiv/jHENxbCeHkCDw/YB5N4Dkbjy6XAph3cF
         jbS0gy0lCqQopEEJtNrnWOjdimpYkYNfqI5ImT2vGeiIlC+fYlxchZlWln0RKCDN+qPP
         T9wSx1PBf93kX45ee+kNF9GqCaQZNSk7J4VBnOroFMn6IPYD+tDj7ydyGiIwm2LnbCvm
         pM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tBU+emZT1UQ9Em7lgQad4v8PopJDYpaoNqIJ7SDDf+4=;
        b=QfH18wDwQteN+PxesxJgpPtVA65IEj0LtQ6j33nfNPx4cF+0tLwTMhqe8ll8yu3Gyr
         JIDwcXEBP01Jmw6rHTURZXRuWd5Rpsbdws9ec9WF3NRxVJ3ftTpxowa1kwIj4cBolxoo
         kwQMkfuQdhj/87pEMf9VXInI7u6oG2gpOSHFNisqa/EKCpSdavEBTo/7ABs8UfjdYakT
         DnmbaB8H0K4CFzgWyC1xTO3ocF9bHhNkj/7pYTLKBD9r+u98P9fVEUd+px2annUw36Yn
         zWBqEvpibLCI0xJ5HSeh60y1liS7bAAKBWqQ1Ob96Huxjyjbnq+QnrbbwOSjjLHsmp9k
         MLrA==
X-Gm-Message-State: ACgBeo2O/Rw2Ay/Pd87xW4Mgs1POVrEdv8EracPmuZ1r3E5e9ozlDcC8
        STUvUpZuLuoKrshkWYNrYRfvR8lTPSU=
X-Google-Smtp-Source: AA6agR7u59gVZ7JBYZFDqrlLxDWSvU6lKMMmcVzr8iI2Sz3DUfDjHn44H/ZB6Vxw7fEFXNkUc+5n5A==
X-Received: by 2002:a17:906:8b81:b0:733:183b:988e with SMTP id nr1-20020a1709068b8100b00733183b988emr1039494ejc.457.1660138533934;
        Wed, 10 Aug 2022 06:35:33 -0700 (PDT)
Received: from skbuf ([188.27.185.133])
        by smtp.gmail.com with ESMTPSA id b10-20020a17090636ca00b00718e4e64b7bsm2324919ejc.79.2022.08.10.06.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:35:33 -0700 (PDT)
Date:   Wed, 10 Aug 2022 16:35:31 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6060: report max mtu 1536
Message-ID: <20220810133531.wia2oznylkjrgje2@skbuf>
References: <20220810082745.1466895-1-saproj@gmail.com>
 <20220810100818.greurtz6csgnfggv@skbuf>
 <CABikg9zb7z8p7tE0H+fpmB_NSK3YVS-Sy4sqWbihziFdPBoL+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9zb7z8p7tE0H+fpmB_NSK3YVS-Sy4sqWbihziFdPBoL+Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 03:00:20PM +0300, Sergei Antonov wrote:
> > >       val = addr[0] << 8 | addr[1];
> > >
> > >       /* The multicast bit is always transmitted as a zero, so the switch uses
> > > @@ -212,6 +211,11 @@ static int mv88e6060_setup(struct dsa_switch *ds)
> > >       return 0;
> > >  }
> > >
> > > +static int mv88e6060_port_max_mtu(struct dsa_switch *ds, int port)
> > > +{
> > > +     return MV88E6060_MAX_MTU;
> > > +}
> >
> > Does this solve any problem? It's ok for the hardware MTU to be higher
> > than advertised. The problem is when the hardware doesn't accept what
> > the stack thinks it should.
> 
> I need some time to reconstruct the problem. IIRC there was an attempt
> to set MTU 1504 (1500 + a switch overhead), but can not reproduce it
> at the moment.

What kernel are you using? According to Documentation/process/maintainer-netdev.rst,
you should test the patches you submit against the master branch from one of
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
or
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
depending on whether it's a new feature or if it fixes a problem.

Currently, both net and net-next contain the same thing (we are in a
merge window so net-next will not progress until kernel 6.0-rc1 is cut),
which is that dsa_slave_change_mtu() will not do anything because of
this:

	if (!ds->ops->port_change_mtu)
		return -EOPNOTSUPP;

(which mv88e6060 does not implement)

So I am slightly doubtful that anyone attempts an MTU change for this
switch, as you say.

The DSA master (host port, not switch), on the other hand, is a
different story. Its MTU is updated to 1504 by dsa_master_setup().

> > You're the first person to submit a patch on mv88e6060 that I see.
> > Is there a board with this switch available somewhere? Does the driver
> > still work?
> 
> Very nice to get your feedback. Because, yes, I am working with a
> device which has mv88e6060, it is called MOXA NPort 6610.
> 
> The driver works now. There was one problem which I had to workaround.
> Inside my device only ports 2 and 5 are used, so I initially wrote in
> .dts:
>         switch@0 {
>                 compatible = "marvell,mv88e6060";
>                 reg = <16>;

reg = <16> for switch@0? Something is wrong, probably switch@0.

> 
>                 ports {
>                         #address-cells = <1>;
>                         #size-cells = <0>;
> 
>                         port@2 {
>                                 reg = <2>;
>                                 label = "lan2";
>                         };
> 
>                         port@5 {
>                                 reg = <5>;
>                                 label = "cpu";
>                                 ethernet = <&mac1>;
>                         };
>                 };
>         };
> and the driver crashed in mv88e6060_setup_port() on a null pointer.
> Two workarounds are possible:
> 1. Describe ports 0, 1, 3, 4 in .dts too.

No, it should work with just port@2 and port@5 defined.

> 2. Insert this code at the beginning of mv88e6060_setup_port():
> if(!dsa_is_cpu_port(priv->ds, p) && !dsa_to_port(priv->ds, p)->cpu_dp)
>     return 0;
> 'cpu_dp' was the null pointer the driver crashed at.

You mean here:

			(dsa_is_cpu_port(priv->ds, p) ?
			 dsa_user_ports(priv->ds) :
			 BIT(dsa_to_port(priv->ds, p)->cpu_dp->index)));

Yes, this is a limitation that has been made worse by blind code
conversions (nobody seems to have the hardware or to know someone who
does; I've been tempted to delete the driver a few times or at least to
move it to staging, because of the unrealistically long delays until
someone chirps that something is broken for it, even when it obviously is).
The driver assumes that if the port isn't a CPU port, it's a user port.
That's clearly false.

You can probably put this at the beginning of mv88e6060_setup_port():

	if (dsa_is_unused_port(priv->ds, p))
		return 0;

The bug seems to have been introduced by commit 0abfd494deef ("net: dsa:
use dedicated CPU port"), because, although before we'd be uselessly
programming the port VLAN for a disabled port, now in doing so, we
dereference a NULL pointer.

FWIW, in case there is ever a need to backport, the vintage-correct fix
would be to use something like this:

	if (!dsa_port_is_valid(priv->ds->ports[p]))
		return 0;

but in that case the process is:
- send patch against current "net" tree
- wait until patch is queued up for "linux-stable" and backported as far
  as possible
- email will be sent that patch failed to apply to the still-maintained
  LTS branches as far as the Fixes: tag required (this is why it is
  important to populate the Fixes: tag correctly)
- reply to that email with a manually backported patch, just for that
  stable tree (linux-4.14.y etc)

> 
> One more observation. Generating and setting a random MAC in
> mv88e6060_setup_addr() is not necessary - the switch works without it
> (at least in my case).

The GLOBAL_MAC address that the switch uses there will be used as MAC SA
in PAUSE frames (802.3 flow control). Not clear if you were aware of
that fact when saying that the switch "works without it". In other words,
if you make a change in that area, I expect that flow control is what
you test, and not, say, ping.

It's true that some other switches use a MAC SA of 00:00:00:00:00:00 for
PAUSE frames (ocelot_init_port) and this hasn't caused a problem for them.
I don't know if the 6060 supports this mode. If it does, it's worth a shot.
