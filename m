Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3642F8660
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 02:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfKLBa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 20:30:26 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53007 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfKLBaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 20:30:25 -0500
Received: by mail-wm1-f66.google.com with SMTP id l1so1309054wme.2
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 17:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8B2NZ4PfR61JzfugaxVIwYxo10Xu/i9sEhzmQqu6MqE=;
        b=Q4Xi9fjijjroN9+pFk/k+GO3xcSUmBu9dZVChvtk6BNLEHYBIkFEbdY1wnd5TT8VIU
         pbcq9Uzai87oBpR6pMdr+OZtaRFoDLf4QZcUkJqQ5A3W6CC3pc1g5eWpRcxLvX/WilVF
         /o0MF0NX3GnFDxcz2OuTRW9PD1N9FYytxhxiGYqrbbxcFtN9N7R0LHeJ172SHyzLihSb
         DhX5BL5hOMVpFNkUKar4DzdHX9VxiFdQcrilPFtmGAwAjmTPpV0G3P+IkptojbdHRL5L
         aVWG4OfL3nUbNTcdcfBWfVwJmOBB+URAWBoDBZiXRBbl96ASEPdG4Xj4+Ekk/S4zloBa
         W+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8B2NZ4PfR61JzfugaxVIwYxo10Xu/i9sEhzmQqu6MqE=;
        b=LGXKRgewjdGC1SslDYzrdwtqlX23jYOo4nSZX7CK/ezK9kbw7SISG3zE6xHvlsZOzu
         fIRzEQb6WazjSrAejAbGY8dB7OzAIN11IqpTpMKxbgYOjAV/+D0t6o41SHz6B/tQqQe9
         +gdy3NUqHcrOk7jJM1PSMW47DrUXRHaCdJE1N7NvzoM6tv/jbjE1hoThhiiNg6ogxzjc
         fCp29H5DA0vb8RCHsxpV0TiT14HQzqDB0rBANZ8qYCcQT57aGPUg7Gpc/kchSJHCL9CU
         eybrD8FBoVnznu2kir2c2nV6fo7Vc+NcfE9CEuIpHu897DI4eMI0uQavNwgTnKpeFKme
         Dw2g==
X-Gm-Message-State: APjAAAVVxcm780rUAxO4qN0E+0fi71bGYiVLfT0E2DacwIwhP0atHjSE
        nv3XxySSLG/ryzY2wmZYirQ/uiVEcTLag9Ve33entA==
X-Google-Smtp-Source: APXvYqyHsOIfQh0ZE+Iewpa2QCk0jqORNL5kDnw68XZLcijkVuKb2lUFQzIHPnj+mD3ll8zMo9bzEqsY90vIJmgBNTM=
X-Received: by 2002:a05:600c:2383:: with SMTP id m3mr1474407wma.66.1573522221235;
 Mon, 11 Nov 2019 17:30:21 -0800 (PST)
MIME-Version: 1.0
References: <20191107132755.8517-1-jonas@norrbonn.se> <20191107132755.8517-2-jonas@norrbonn.se>
 <CAF2d9jjRLZ07Qx0NJ9fi1iUpHn+qYEJ+cacKgBmeZ2FvZLObEQ@mail.gmail.com>
 <fff51fa7-5c42-7fa7-6208-d911b18bd91e@norrbonn.se> <CAF2d9jib=Qdn9uB=kKn4CTbqvqOiGs+FGh4427=o+UySLf=BwA@mail.gmail.com>
 <7a2038c8-d3a6-2144-f11d-965394d1b420@norrbonn.se>
In-Reply-To: <7a2038c8-d3a6-2144-f11d-965394d1b420@norrbonn.se>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Mon, 11 Nov 2019 17:29:52 -0800
Message-ID: <CAF2d9jiLcLHUrNveQRFyv_SpV+LVW+aUpMAD_MArd8wzeZnUWA@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] rtnetlink: allow RTM_SETLINK to reference other namespaces
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     nicolas.dichtel@6wind.com, linux-netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 9, 2019 at 6:17 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Hi Mahesh,
>
> Thanks for the detailed response.  It provided valuable insight.
>
> On 08/11/2019 19:55, Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=
=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) wrote:
> > Hi Jonas, thanks for the response.
> >
> > On Fri, Nov 8, 2019 at 12:20 AM Jonas Bonn <jonas@norrbonn.se> wrote:
> >>
> >> Hi Mahesh,
> >>
> >> On 07/11/2019 21:36, Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=
=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) wro=
te:
> >>> On Thu, Nov 7, 2019 at 5:30 AM Jonas Bonn <jonas@norrbonn.se> wrote:
> >>>>
> >>>>
> >>>> +       /* A hack to preserve kernel<->userspace interface.
> >>>> +        * It was previously allowed to pass the IFLA_TARGET_NETNSID
> >>>> +        * attribute as a way to _set_ the network namespace.  In th=
is
> >>>> +        * case, the device interface was assumed to be in the  _cur=
rent_
> >>>> +        * namespace.
> >>>> +        * If the device cannot be found in the target namespace the=
n we
> >>>> +        * assume that the request is to set the device in the curre=
nt
> >>>> +        * namespace and thus we attempt to find the device there.
> >>>> +        */
> >>> Could this bypasses the ns_capable() check? i.e. if the target is
> >>> "foo" but your current ns is bar. The process may be "capable" is foo
> >>> but the interface is not found in foo but present in bar and ends up
> >>> modifying it (especially when you are not capable in bar)?
> >>
> >> I don't think so.  There was never any capable-check for the "current"
> >> namespace so there's no change in that regard.
>
> I was wrong on this point.  There IS a capable-check for the "current"
> net.  The code to create interfaces in 'other' namespaces was already in
> place before my patch and that code does the right thing with respect to
> checking NS capabilities on the "destination" and "link" nets.
>
> My patch is mostly just accounting for the "setlink" aspect of NEWLINK
> where the device already exists in a foreign namespace and needs to be
> searched for there.  Even in that code path, all the ns-capable checks
> are in place and the behaviour is the same as before.
>
> >>
> > not having capable-check seems wrong as we don't want random
> > not-capable processes to alter settings. However, it may be at the API
> > entry level, which will provide necessary protection (haven't
> > checked!). Having said that, this could be bad for the stuff that you
> > are implementing since I could be in "foo" and attempting to change
> > "bar". For this I must be capable in "bar" but the top-level capable
> > check will by default check me in "foo" as well which is not required
> > and could potentially block me from performing legal operation in
> > "bar".
> >
> > Not saying this is a problem, but without having an implementation to
> > use this would be hard to try. You would most likely have a way to
> > verify this, so please check it.
>
> The above shouldn't be an issue with the current implementation.
>
> >
> >> I do think there is an issue with this hack that I can't see any
> >> workaround for.  If the user specifies an interface (by name or index)
> >> for another namespace that doesn't exist, there's a potential problem =
if
> >> that name/index happens to exist in the "current" namespace.  In that
> >> case, one many end up inadvertently modifying the interface in the
> >> current namespace.  I don't see how to avoid that while maintaining th=
e
> >> backwards compatibility.
> >>
> > This could very well be the case always for single digit ifindex
> > values. (We recently suffered a local scare because of something very
> > similar).
> >
> >> My absolute preference would be to drop this compat-hack altogether.
> >> iproute2 doesn't use a bare TARGET_NETNSID in this manner (for changin=
g
> >> namespaces) and I didn't find any other users by a quick search of oth=
er
> >> prominent Netlink users:  systemd, network-manager, connman.  This
> >> compat-hack is there for the _potential ab-user_ of the interface, not
> >> for any known such.
> >>
> > what is forcing you keeping you keeping / implementing this hack? I
> > would also prefer simple solution without creating a potential problem
> > / vulnerability (problem: potentially modifying unintended interface,
> > vulnerability: potentially allow changing without proper credentials;
> > both not proven but are possibilities) down the line. One possibility
> > is to drop the compatibility hack and keep it as a backup if something
> > breaks / someone complains.
>
> OK, this would be my preference, too.  If we can work on the assumption
> that this isn't actually providing compatibility for anybody in
> practice, then we can drop it.  With that, the potential problem of
> inadvertently modifying the wrong device disappears.  There's no problem
> of being able to access a namespace that one isn't capable in, but
> leaving a hole through which the user may end up doing something
> unexpected is pretty ugly.
>
> I'll remove this and repost the series.
>
sgtm

thanks,
--mahesh..

> Thanks for your insight into this issue.  It was helpful.
>
> /Jonas
