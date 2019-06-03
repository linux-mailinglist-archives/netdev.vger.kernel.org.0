Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA9A32D64
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 12:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfFCKC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 06:02:56 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42938 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFCKC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 06:02:56 -0400
Received: by mail-ed1-f67.google.com with SMTP id z25so65999edq.9;
        Mon, 03 Jun 2019 03:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=367tjLqmrbfhNkAABHcK0QMmDaaghOywvCw3Tj7l6Uw=;
        b=RFS8Bn2Klx2iiJKovzQUkNmwHkcTRuYfn/XQK2SfpBEBx+wIjnIXIhxVgmmlB8wlGH
         G4bFtz0NjtapKugBXxAygj1TeXbUBrcJZy5MTLg1LGCDVf/A/cwXsgVx7H3KN/2QgyBX
         WHXUbpoefeAQXHevaTN9LRXVUziI7qhPpe/EmPmBJhqx2+998YlQCwv1OCMuqR+k5hQI
         4JgeQr/kQATseR59QpK7gqC+ZPvsm+i2F4nTXSgi892HDULCA0E1OjRiso8jIV/FIzL7
         91Ccx3mdwBlkgnxWyoJlhygG9GHe7n5rJrDhcP04IdNl8ba2ID0ya4qmfv+8j8P5FiM/
         O41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=367tjLqmrbfhNkAABHcK0QMmDaaghOywvCw3Tj7l6Uw=;
        b=DcnNbSv3VWoBhxZWxAlhcRdzDxy+tOBzoRQhnCrHHHCO2oxIt9fIQsSJsTu5MbMoz2
         hLfQmdOiL2vr6HcwCDuCAtl9lmm4lO7QVcFgcxiELR/Uf/hYWwiFj79zyTgWI3kXWsFL
         kxZTjI63OMcF/9xRFlIL49YCZ+vqZQ+UZxj2OWwCGLzD+GRwrYl8MifhYKQ3FY5cUQPk
         XEK6XjrZcKuu9poRx3fm3WmZGeeRAAn5zkVBofOlyVg4De7nX8ocxoKqUXuE2xnn+6UU
         g/FsK76HztzWrlgUkDsFXXwu3MNgpiDWfk1P6qi5QXpTLnD2snZZlO5v36iumDziUa2j
         jToQ==
X-Gm-Message-State: APjAAAW8SAmpfPjrpS5n6lJ6B87h8Dqis3tnfTgiTyha7GD+pEcUmIjS
        pW3HCQAVs/NBG8fPpPj8VTmMeZnsmqusRLqSZmI=
X-Google-Smtp-Source: APXvYqyUtzOFs/GJBzchqlUSLwD+zSN8nLxTdVGyUPbZYObIQKMiB/3/xYkXr1lzvZaWFfkLmNbakesNJ3dJ5+W16Lo=
X-Received: by 2002:aa7:da4b:: with SMTP id w11mr19778176eds.36.1559556174689;
 Mon, 03 Jun 2019 03:02:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190602213926.2290-1-olteanv@gmail.com> <20190602213926.2290-3-olteanv@gmail.com>
 <20190603010740.GI19081@lunn.ch>
In-Reply-To: <20190603010740.GI19081@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 3 Jun 2019 13:02:43 +0300
Message-ID: <CA+h21hrb5YBnMJe728ers9MZqLbuP8MTdV_4WOKJkOi0owJggg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 02/10] net: dsa: Add teardown callback for drivers
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 at 04:07, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Jun 03, 2019 at 12:39:18AM +0300, Vladimir Oltean wrote:
> > This is helpful for e.g. draining per-driver (not per-port) tagger
> > queues.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> > Changes in v2:
> >
> > Patch is new.
> >
> >  include/net/dsa.h | 1 +
> >  net/dsa/dsa2.c    | 3 +++
> >  2 files changed, 4 insertions(+)
> >
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index a7f36219904f..4033e0677be4 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -361,6 +361,7 @@ struct dsa_switch_ops {
> >                                                 int port);
> >
> >       int     (*setup)(struct dsa_switch *ds);
> > +     void    (*teardown)(struct dsa_switch *ds);
> >       u32     (*get_phy_flags)(struct dsa_switch *ds, int port);
> >
> >       /*
> > diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> > index b70befe8a3c8..5bd3e9a4c709 100644
> > --- a/net/dsa/dsa2.c
> > +++ b/net/dsa/dsa2.c
> > @@ -407,6 +407,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
> >
> >  static void dsa_switch_teardown(struct dsa_switch *ds)
> >  {
> > +     if (ds->ops->teardown)
> > +             ds->ops->teardown(ds);
> > +
> >       if (ds->slave_mii_bus && ds->ops->phy_read)
> >               mdiobus_unregister(ds->slave_mii_bus);
> >
>
> Hi Vladimir
>
> If we want to keep with symmetric with dsa_switch_setup(), this
> teardown should be added after dsa_switch_unregister_notifier() and
> before devlink_unregister().
>
>        Andrew

True.

-Vladimir
