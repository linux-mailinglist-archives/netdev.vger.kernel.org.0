Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9DE8F54D9
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbfKHSzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:55:31 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52671 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387476AbfKHSz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:55:29 -0500
Received: by mail-wm1-f67.google.com with SMTP id c17so7225798wmk.2
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 10:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rSeEzJJFL2J46kppo+eAa64DAYEYghhg+PgDA1kJZ2g=;
        b=FoNjF029RF5QDxb2sTGkwafqxS7YPNOhJGn3vNt7RzmZDJi4By/FaCgouK1Hs2vi2N
         yCV/rw4mygjkOCRUrQclgCUnJd7eITqD/r/NGybiUNmuKS3gXnMLXPBo8O5CRzMrxjZp
         9cwmybzUPhjMRGqjHvkiKogdVp5hd2XHXlEtv0w4c+Uvxac/xrFToxgkmJ9MZL0ypFrD
         Mhy6/Upn3gfAWw5k1jvf/4uhN4QoUrK8v5vSe9MdT0X1wn3QVXSO8HxNhX7O0ij3LZ8C
         XzB01wbuh+xKD9uidorsG/pt2KouHgAFqMRbWRmnY0WOUHIRCb2jHQxDqvnBn8xOjNXD
         h+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rSeEzJJFL2J46kppo+eAa64DAYEYghhg+PgDA1kJZ2g=;
        b=aXNfSutQgiVIkvRFe2exEbRlQb2RpTgOGNxLYR7r/Bz/u0PPkcWtr680Fl0R5JxNhc
         E5MUcmyIgb1x9NDrVRA01obEeUxcxGWtXkAWaIb3sRBKCWXVF183QEgn4e1VdRvPombz
         GWGjtYuL+8lyzZRSVHuyy8M0RhhktdTCmQm0iiqvDTEbCvR73lOthuP0o9ZWdBSBy4/U
         fU3rlnY49pXIII57T76bIz+O/GosM+aeaaIdNuptTT1xTHycprIXRzcHwcozNxXZVYj5
         5Ua/WKaCG92C+znbL/k94eh6Jp5+ZTOXT8+ptqTxS8rw8n6krNFDB0ruaAmn9MggXfps
         P6Tg==
X-Gm-Message-State: APjAAAUbYAEb8Dte9gUgY2enNGADPE8tU2d0oQlQ29IvobyTMn15P9Zz
        bPVj2tjZH/V+ZvXrhHGlQti/vjlxc3d1cCl1zM629A==
X-Google-Smtp-Source: APXvYqx1sV9NeDd9gC1bR8P1X0KmTK0PSsreI7qP6v07YzIVs7h5mC+t6A5x/F/jVQE5cG7uGCTWzfqEWNx7BCj6GtU=
X-Received: by 2002:a05:600c:2295:: with SMTP id 21mr9059047wmf.85.1573239326290;
 Fri, 08 Nov 2019 10:55:26 -0800 (PST)
MIME-Version: 1.0
References: <20191107132755.8517-1-jonas@norrbonn.se> <20191107132755.8517-2-jonas@norrbonn.se>
 <CAF2d9jjRLZ07Qx0NJ9fi1iUpHn+qYEJ+cacKgBmeZ2FvZLObEQ@mail.gmail.com> <fff51fa7-5c42-7fa7-6208-d911b18bd91e@norrbonn.se>
In-Reply-To: <fff51fa7-5c42-7fa7-6208-d911b18bd91e@norrbonn.se>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Fri, 8 Nov 2019 10:55:09 -0800
Message-ID: <CAF2d9jib=Qdn9uB=kKn4CTbqvqOiGs+FGh4427=o+UySLf=BwA@mail.gmail.com>
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

Hi Jonas, thanks for the response.

On Fri, Nov 8, 2019 at 12:20 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Hi Mahesh,
>
> On 07/11/2019 21:36, Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=
=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) wrote:
> > On Thu, Nov 7, 2019 at 5:30 AM Jonas Bonn <jonas@norrbonn.se> wrote:
> >>
> >>
> >> +       /* A hack to preserve kernel<->userspace interface.
> >> +        * It was previously allowed to pass the IFLA_TARGET_NETNSID
> >> +        * attribute as a way to _set_ the network namespace.  In this
> >> +        * case, the device interface was assumed to be in the  _curre=
nt_
> >> +        * namespace.
> >> +        * If the device cannot be found in the target namespace then =
we
> >> +        * assume that the request is to set the device in the current
> >> +        * namespace and thus we attempt to find the device there.
> >> +        */
> > Could this bypasses the ns_capable() check? i.e. if the target is
> > "foo" but your current ns is bar. The process may be "capable" is foo
> > but the interface is not found in foo but present in bar and ends up
> > modifying it (especially when you are not capable in bar)?
>
> I don't think so.  There was never any capable-check for the "current"
> namespace so there's no change in that regard.
>
not having capable-check seems wrong as we don't want random
not-capable processes to alter settings. However, it may be at the API
entry level, which will provide necessary protection (haven't
checked!). Having said that, this could be bad for the stuff that you
are implementing since I could be in "foo" and attempting to change
"bar". For this I must be capable in "bar" but the top-level capable
check will by default check me in "foo" as well which is not required
and could potentially block me from performing legal operation in
"bar".

Not saying this is a problem, but without having an implementation to
use this would be hard to try. You would most likely have a way to
verify this, so please check it.

> I do think there is an issue with this hack that I can't see any
> workaround for.  If the user specifies an interface (by name or index)
> for another namespace that doesn't exist, there's a potential problem if
> that name/index happens to exist in the "current" namespace.  In that
> case, one many end up inadvertently modifying the interface in the
> current namespace.  I don't see how to avoid that while maintaining the
> backwards compatibility.
>
This could very well be the case always for single digit ifindex
values. (We recently suffered a local scare because of something very
similar).

> My absolute preference would be to drop this compat-hack altogether.
> iproute2 doesn't use a bare TARGET_NETNSID in this manner (for changing
> namespaces) and I didn't find any other users by a quick search of other
> prominent Netlink users:  systemd, network-manager, connman.  This
> compat-hack is there for the _potential ab-user_ of the interface, not
> for any known such.
>
what is forcing you keeping you keeping / implementing this hack? I
would also prefer simple solution without creating a potential problem
/ vulnerability (problem: potentially modifying unintended interface,
vulnerability: potentially allow changing without proper credentials;
both not proven but are possibilities) down the line. One possibility
is to drop the compatibility hack and keep it as a backup if something
breaks / someone complains.

thanks,
--mahesh..

> >
> >> +       if (!dev && tgt_net) {
> >> +               net =3D sock_net(skb->sk);
> >> +               if (ifm->ifi_index > 0)
> >> +                       dev =3D __dev_get_by_index(net, ifm->ifi_index=
);
> >> +               else if (tb[IFLA_IFNAME])
> >> +                       dev =3D __dev_get_by_name(net, ifname);
> >> +       }
>
>
> /Jonas
