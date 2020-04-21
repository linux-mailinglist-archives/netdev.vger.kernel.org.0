Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122991B2966
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgDUOZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726691AbgDUOZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 10:25:06 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C324C061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 07:25:06 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l3so7423113edq.13
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 07:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=72ffQ5ODb8U0vC6vg6y9VRJ/3CN/DrqEKm/QWUNdrgo=;
        b=W99e/F1xFPVSJT6YNzNr0WtrOxze5S3cghoAQWUbFJ1z3Ltwxub6ql3VJyrWFyZpCo
         ozAWthD3w7dtr0cDYMz9bIQXsyq9Bdcr3/71B0duWofprRfmpd/KnEK44uiwib+vDK7V
         eL+29yEWRZcnobR7ZnAI+1+I20d3Qx7wS3tSvxdHm22VhsgyTDCDhXDcL1XGov5nstAc
         9328wHpmT3U/CwOvMwnnAaKXn6nnnm5PP7mRnLJc2q7BcxJIRyuGpAIyUHR9QMoBLNEA
         ooJYfD7QHOPciz0XuBbMuiMIBJNxvBNV7+jzr+lopTIlphuXk8JXoU0IA0ASYg/9eVvm
         idWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=72ffQ5ODb8U0vC6vg6y9VRJ/3CN/DrqEKm/QWUNdrgo=;
        b=p42WonnEjWQxO9dE0a+RZnUf38bz+utnGmhtQgYxIe5mOKyJo8sKwDX7vtXH9XQT9V
         TQrODL2Xdsb7HL4TUAjserZrjzksleU0eeWxSexBzRw9eR9m6Y1B6wi/UpJsjjPM4TOX
         q4+ytMOfZqO3rPybXtucOVvP+x4K3bfIs5+EXh7VUdGdJmfiyNWAV7L+m0OZGbCCWqyv
         Q0c3XR6iLeJCqL5mRKA4MPkgzl6enrVtruDjGSYKW5x4krqBo2GF7F+P3mTULzjrpOmJ
         FuLHeWiAj2JGklv11KdA9c5JgYrTLWC5aFn2Kv/9YnsHkM+8c1mgwcF7/QMWKjFrehtM
         5iFA==
X-Gm-Message-State: AGi0PuZFLZ/Y8/PxVcvhdSY66m3hJCv98umwf3Uv0h0XInGnVadwvaKL
        T14vaChUi6l0bWKBYAE6fZxagadjU3DX+mccJtA=
X-Google-Smtp-Source: APiQypJiZbTvyqj7dENEVhVlLta/tXzIuMsgGj+Fee5VxUqjtS/WpB5JA4IwsgmUkGjc3aItLEZrqfoPg/knlTFeFEY=
X-Received: by 2002:a50:aca3:: with SMTP id x32mr19488760edc.368.1587479104876;
 Tue, 21 Apr 2020 07:25:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200421123110.13733-1-olteanv@gmail.com> <20200421123110.13733-2-olteanv@gmail.com>
 <20200421133321.GD937199@lunn.ch> <CA+h21hrXJf1vm-5b3O7zQciznKF-jGSTpe_v6Mgtv8dXNOCt7g@mail.gmail.com>
 <20200421140653.GA933345@lunn.ch>
In-Reply-To: <20200421140653.GA933345@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 21 Apr 2020 17:24:54 +0300
Message-ID: <CA+h21hq4deLKEp80Kt4Gboxon4MLsOYaXPk6Tz2JBAH0yF2q9Q@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: dsa: be compatible with DSA masters with
 max_mtu of 1500 or less
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Apr 2020 at 17:06, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Apr 21, 2020 at 04:42:41PM +0300, Vladimir Oltean wrote:
> > Hi Andrew,
> >
> > On Tue, 21 Apr 2020 at 16:33, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Tue, Apr 21, 2020 at 03:31:09PM +0300, Vladimir Oltean wrote:
> > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > > It would be ideal if the DSA switch ports would support an MTU of 1500
> > > > bytes by default, same as any other net device. But there are 2 cases of
> > > > issues with trying to do that:
> > > >
> > > > - Drivers that are legitimately MTU-challenged and don't support
> > > >   anything larger than ETH_DATA_LEN. A very quick search shows that
> > > >   sungem.c is one such example - there may be many others.
> > > >
> > > > - Drivers that simply don't populate netdev->max_mtu. In that case, it
> > > >   seems that the ether_setup function sets dev->max_mtu to a default
> > > >   value of ETH_DATA_LEN. And due to the above cases which really are
> > > >   MTU-challenged, we can't really make any guesses.
> > > >
> > > > So for these cases, if the max_mtu of the master net_device is lower
> > > > than 1500, use that (minus the tagger overhead) as the max MTU of the
> > > > switch ports.
> > >
> > > I don't like this. I suspect this will also break in subtle ways.
> > >
> > > Please go back to the original behaviour. Make the call to request the
> > > minimum needed for DSA.
> >
> > In what sense "minimum needed"? It is minimum needed. If
> > master->max_mtu is 1500, the MTU will be set to 1496.
>
> Ah, sorry. This is the slave. I was thinking it was the master.
>
> We have always assumed the slave can send normal sized frames,
> independent of what the master supports. This is just a follow on from
> the fact we ignore errors setting the MTU on the master for the DSA
> overhead for normal size frames. So don't set the MTU to 1496, leave
> it at 1500. For all working boards out in the wild, 1500 will work.
>
>          Andrew

Does iperf3 TCP work on your Vybrid board with the master MTU equal to
the slave MTU equal to 1500 (without IP fragmentation, that is)? If it
does, ok, this patch can maybe be dropped.

qca7000 doesn't support packets larger than 1500 MTU either, neither
does broadcom b44, and neither do probably more adapters which I
didn't find now.

Why would I not limit the MTU to 1496 if the master's max_mtu is 1500?
Just to provoke more warnings in people's logs? I just don't want to
have further issue reports, but I am basically reading your reply as
"don't try to be correct". If you don't like this behavior for FEC,
you can set its max_mtu since it doesn't do that by itself.

Thanks,
-Vladimir
