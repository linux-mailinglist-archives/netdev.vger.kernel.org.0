Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E303F1304ED
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 23:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgADW1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 17:27:55 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38857 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgADW1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 17:27:55 -0500
Received: by mail-ed1-f67.google.com with SMTP id i16so44537353edr.5
        for <netdev@vger.kernel.org>; Sat, 04 Jan 2020 14:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fSzMDQ9miq6OEDMg9OC1ehyNfqVuZnj+bJNAuikpp4A=;
        b=e+N1oU3S7y3hWkjdQ0OOySIh8fM0jEmfGW2LlZCdMV5iKlA8Pfpq3rdfEz+jaOTVSy
         aJmcVTHq14WUbHo2607DHokZcwNhNSD99D76N3EwFVtNM0pF4mffCKJXki3p2b+oQWUn
         hU7wlxSBsfSuADEc0Cr029Tr4zG1mcspgcsMj5p+j/5/6excSQj1mdC7fehaheHsOG7F
         GawMQbOwEyaMu9hhw7woC3pSLiZQs0zOvBFwpordc67vNUbakFgGiym5MvclGLa98GPZ
         iIRZHzIuildAcTg3D8URNGoTdbzdPiibzm9Y1I7ICe9TTupF/jk/7/0SwoOn7AzfD4op
         KXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fSzMDQ9miq6OEDMg9OC1ehyNfqVuZnj+bJNAuikpp4A=;
        b=GTDbrMdPVs1sV5JmtC/LSwjhQjm1GyOTUXkiyx+3g0ZdvDuksZEVU0uXUaFGbp5LKQ
         5PEsRdaBsUTdB6W5ECj71f/VLLFCqiXYUFkTn1yFD+bZ1B4d4ncrFKzzb5CSIn2vJyMM
         xucPwjp9z44mEYWr7cxsSQ+WVb61O4hgS3Hpj/v/xCxdiv24j3YEYNDXMBDBjn4aN48a
         2wT2NIdS5KSCRtSQSWUr8zpAGMHRis/mBeFTBpW2K79eUm70Ux0a04k4StZGT/Lgx3bk
         g9ZgW/hgPXi/WV+bch9L6sd4NWJ0Kr41JNvOzRly6Vc6JBrE503HkuKOUoFlKHJfnCQ1
         L7wA==
X-Gm-Message-State: APjAAAUdsvlhDemBb4UmTTSEG1r3txuutLJA9cIg4WGYECypSdBRi5e2
        dknauqil34zkbzqJPgcke3A0IJAWM6PMoF8quUY=
X-Google-Smtp-Source: APXvYqwxlY1ngs1NSaXJ0Ur11tCsnhTtetOfdx5QQMmbtRM90BmUS1mBxEVX2mEiwlPA0EOny+E0+crkrkE3JKr8nCA=
X-Received: by 2002:a17:906:19d0:: with SMTP id h16mr93934507ejd.70.1578176873909;
 Sat, 04 Jan 2020 14:27:53 -0800 (PST)
MIME-Version: 1.0
References: <20200104161335.27662-1-andrew@lunn.ch> <CA+h21hoxY=4L53JGFmRTx5=CGbjY0pNpTSKd=ynDLdP_-CTO5g@mail.gmail.com>
 <20200104220455.GC27771@lunn.ch>
In-Reply-To: <20200104220455.GC27771@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 5 Jan 2020 00:27:42 +0200
Message-ID: <CA+h21hqFZhkAHrnUSDJXBAgu9n_F7v=D5q0K5AoPA9eZOF_yoQ@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Preserve priority went setting
 CPU port.
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Chris Healy <Chris.Healy@zii.aero>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 Jan 2020 at 00:05, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Jan 04, 2020 at 08:56:12PM +0200, Vladimir Oltean wrote:
> > Hi Andrew,
> >
> > Is there a typo in the commit message? (went -> when)
>
> Yep. Thanks for pointing it out.
>
> >
> > On Sat, 4 Jan 2020 at 18:16, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > The 6390 family uses an extended register to set the port connected to
> > > the CPU. The lower 5 bits indicate the port, the upper three bits are
> > > the priority of the frames as they pass through the switch, what
> > > egress queue they should use, etc. Since frames being set to the CPU
> > > are typically management frames, BPDU, IGMP, ARP, etc set the priority
> > > to 7, the reset default, and the highest.
> > >
> > > Fixes: 33641994a676 ("net: dsa: mv88e6xxx: Monitor and Management tables")
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > > ---
> >
> > Offtopic: Does the switch look at VLAN PCP for these frames at all, or
> > is the priority fixed to the value from this register?
>
> I _think_ it is fixed. But this is just for "management"
> frames. Normal data frames heading to the CPU because of MAC address
> learning should have all the normal QoS operations the switch supports
> to determining their priority.
>
> > >  drivers/net/dsa/mv88e6xxx/global1.c | 5 +++++
> > >  drivers/net/dsa/mv88e6xxx/global1.h | 1 +
> > >  2 files changed, 6 insertions(+)
> > >
> > > diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
> > > index 120a65d3e3ef..ce03f155e9fb 100644
> > > --- a/drivers/net/dsa/mv88e6xxx/global1.c
> > > +++ b/drivers/net/dsa/mv88e6xxx/global1.c
> > > @@ -360,6 +360,11 @@ int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port)
> > >  {
> > >         u16 ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST;
> > >
> > > +       /* Use the default high priority for manegement frames sent to
> >
> > management
>
> Humm. What happened to my spell checker?
>
> > > +        * the CPU.
> > > +        */
> > > +       port |= MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI;
> > > +
> > >         return mv88e6390_g1_monitor_write(chip, ptr, port);
> > >  }
> > >
> > > diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
> > > index bc5a6b2bb1e4..5324c6f4ae90 100644
> > > --- a/drivers/net/dsa/mv88e6xxx/global1.h
> > > +++ b/drivers/net/dsa/mv88e6xxx/global1.h
> > > @@ -211,6 +211,7 @@
> > >  #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST         0x2000
> > >  #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST          0x2100
> > >  #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST             0x3000
> > > +#define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI     0x00e0
> >
> > I suppose this could be more nicely expressed as
> > MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI(x)    ((x) << 5 &
> > GENMASK(7, 5)), in case somebody wants to change it from 7?
>
> It could be. But i'm not aware of any suitable existing API to
> configure this. So i went KISS and used the hard coded value.
>

No, I mean it's absolutely reasonable for the default value of the
traffic class for management traffic to be 7 rather than 0, if it's
fixed (and it's not surprising that this is the out-of-reset default).
I was just making an argument for that "7" to be more explicit for
code lurkers who don't have access to Marvell documentation...
According to your answer above, the sja1105 hardware is very similar
in behavior (its knob is called HOSTPRIO and that driver hardcodes it
to 7 too, which makes sense). It's just that the similarity is far
from obvious if you define
MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI as 0x00e0 (my 2
cents). Had I known that Peridot does behave so similar in this
regard, I would have thought twice about attempting to create a
driver-specific devlink param for this setting [0]:

https://www.spinics.net/lists/netdev/msg614039.html

>           Andrew

Regards,
-Vladimir
