Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A820A95C42
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfHTK3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:29:04 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40015 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729181AbfHTK3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 06:29:03 -0400
Received: by mail-ed1-f66.google.com with SMTP id h8so5719572edv.7
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 03:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rflUU7aj6dJIKugE4/tsf9uiGNBMO7PF7YydLueErAs=;
        b=uxxZ9bQWKU2637nxkPmQue+ejypdjsAdwkdhkoFpxApdvZFI0c8VhPzUSt6Sr58thX
         vyzrR5M08lLYha3Ygcajdu3PC0jdcpziBLOCkpywPEUcnhx7vt0PsjnrxkOxgTQkRSrP
         dPc+oMyzrU6efN3hMfF38o5IOreGsimNHiHOzfJmjufLXiHQgKoNId7IMV+9BL+yb0wN
         3t/bzoyHKcXFK/fpRbClNiEUQWAqjvHlC+lmgXgYvjQaNDbeSqhJXW84JxkVsomA0z9d
         1owsUIgm96I87fH2ByUPEqwxyvOwutiajIXZpN60MgfHXNAWZ8seMEDjeFZWsyDq+csD
         qT6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rflUU7aj6dJIKugE4/tsf9uiGNBMO7PF7YydLueErAs=;
        b=W0B8xkSiM5KuNGiLpDpTAMdJ6hMLTTi8vcckbtkCq4F1Sredv/Ow2YnSG3EmolYJTZ
         HUdxUamY6bAvp2q3nVHo8Vxu72MVaG3SOVDkBvBXOe0yos2ZctKXARTlULN0szSyIhF/
         u+4U1AmWwarAs9wSF/KTrHp255vW3UG7xS6aEpxlmlZEgAVDqXyLgtplAQZjGqr89OBZ
         TjZORpEq24n81KJzPmVknX6xuqBFUCgxU4Gkmvlrrv2A04FjE+JRycyqacsF+MI5mv0s
         n1rKywno8w+69J//9hencX0UtTVxHeVIIC9piOEd9H1XfwNNS+fdpq8T3nrcQ8abXkBo
         WIaA==
X-Gm-Message-State: APjAAAWJzjhLPZ2d9PUjjDTc1lMXn4iu8w/pTXU9tfqa6ocfxspx6Epe
        KABPWozaQFO8Pt7jylz86zRrm3HqHPqcXLPMtAL90OewG1Y=
X-Google-Smtp-Source: APXvYqx+omguGlJ/FLH0aL6RkWHF12CzLRqTn8zKPG2Jv1j7dTs0UvQKCZYJOpzktyRju2A7gB8CBUYzzrK7xB4zyJo=
X-Received: by 2002:a17:906:504e:: with SMTP id e14mr22474235ejk.204.1566296941983;
 Tue, 20 Aug 2019 03:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190820000002.9776-1-olteanv@gmail.com> <20190820000002.9776-7-olteanv@gmail.com>
 <bf0c064e-6304-ba31-8f45-3a6226ed8939@gmail.com>
In-Reply-To: <bf0c064e-6304-ba31-8f45-3a6226ed8939@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 20 Aug 2019 13:28:51 +0300
Message-ID: <CA+h21hody3hu_6UE9gU4dQ5+BP5HnUi=uw0PDdvtgPjTrbpKbw@mail.gmail.com>
Subject: Re: [PATCH net-next 6/6] net: dsa: tag_8021q: Restore bridge pvid
 when enabling vlan_filtering
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Tue, 20 Aug 2019 at 06:33, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 8/19/2019 5:00 PM, Vladimir Oltean wrote:
> > The bridge core assumes that enabling/disabling vlan_filtering will
> > translate into the simple toggling of a flag for switchdev drivers.
> >
> > That is clearly not the case for sja1105, which alters the VLAN table
> > and the pvids in order to obtain port separation in standalone mode.
> >
> > So, since the bridge will not call any vlan operation through switchdev
> > after enabling vlan_filtering, we need to ensure we're in a functional
> > state ourselves.
> >
> > Hence read the pvid that the bridge is aware of, and program that into
> > our ports.
>
> That is arguably applicable with DSA at large and not just specifically
> for tag_8021q.c no? Is there a reason why you are not seeking to solve
> this on a more global scale?
>

Perhaps because I don't have a good feel for what are other DSA
drivers' struggles with restoring the pvid, even after re-reading the
"What to do when a bridge port gets its pvid deleted?" thread.
I understand b53 has a similar need, and for that purpose maybe you
can EXPORT_SYMBOL_GPL(dsa_port_restore_pvid) and use it, but
otherwise, what is the more global scale?

> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  net/dsa/tag_8021q.c | 32 +++++++++++++++++++++++++++++++-
> >  1 file changed, 31 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
> > index 67a1bc635a7b..6423beb1efcd 100644
> > --- a/net/dsa/tag_8021q.c
> > +++ b/net/dsa/tag_8021q.c
> > @@ -93,6 +93,33 @@ int dsa_8021q_rx_source_port(u16 vid)
> >  }
> >  EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
> >
> > +static int dsa_port_restore_pvid(struct dsa_switch *ds, int port)
> > +{
> > +     struct bridge_vlan_info vinfo;
> > +     struct net_device *slave;
> > +     u16 pvid;
> > +     int err;
> > +
> > +     if (!dsa_is_user_port(ds, port))
> > +             return 0;
> > +
> > +     slave = ds->ports[port].slave;
> > +
> > +     err = br_vlan_get_pvid(slave, &pvid);
> > +     if (err < 0) {
> > +             dev_err(ds->dev, "Couldn't determine bridge PVID\n");
> > +             return err;
> > +     }
> > +
> > +     err = br_vlan_get_info(slave, pvid, &vinfo);
> > +     if (err < 0) {
> > +             dev_err(ds->dev, "Couldn't determine PVID attributes\n");
> > +             return err;
> > +     }
> > +
> > +     return dsa_port_vid_add(&ds->ports[port], pvid, vinfo.flags);
> > +}
> > +
> >  /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
> >   * front-panel switch port (here swp0).
> >   *
> > @@ -223,7 +250,10 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
> >               return err;
> >       }
> >
> > -     return 0;
> > +     if (!enabled)
> > +             err = dsa_port_restore_pvid(ds, port);
> > +
> > +     return err;
> >  }
> >  EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
> >
> >
>
> --
> Florian

Regards,
-Vladimir
