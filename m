Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3902B5338
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 21:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgKPUul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 15:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgKPUuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 15:50:40 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C48C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 12:50:39 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id t33so16940135ybd.0
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 12:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0JeT0HXX+zhMk5lweI6yKEAQu5jGiaoPRe65JVqJoX0=;
        b=vQbwfucNQVI3Pwei5LwkFKifkBm3rf6/DXGO359WzQExQVXBYmwWJ1uvEuyyqTTMZR
         jMH3d728HXxvHCdM0LwJJC4NyFqPThutqYYKQ56uZPY/GJvmhiiys236ehg9PIBZHyDA
         N1CusWnoFQuA8g38wqaUhsR3PRsv6+zqaxBkh9Z/injYr58KBGu/K+Z0iXiIDAOAoGwL
         +eWYGbo6qAhLyy3L9VmtLjRw5mAdPZH4nBUgpGhRrkVZ+c1QQdeZtzTFKo86yJ+zS7PK
         u2Tq9GXoyJw+Ir0DWdKARwb/iJR9tQvDkMhhJYfswleEE3oRzTdxsU9DjPhM8qqsiD1X
         r9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0JeT0HXX+zhMk5lweI6yKEAQu5jGiaoPRe65JVqJoX0=;
        b=nryD0ke+7dsYvpL0ow+nYsQvH5ix2t160C9dGp9thqqhclGW1reBtJHtevd5tN09Ng
         PTwdGtn5GzxF3XMo8DtC9T4D0yq4dzl5IbCNfECbAUq5ct48Axboceb5uKDMed4CJr4y
         5vIBGbyY/P6fi9fEEweG2XLDs7H0qYcaEHazjZHk/2DtZFyw09JM8YkfPpcKfDi2pe/e
         yYdadkPgUiadiOHY+mYV2KsyGABxh21qxnGAdCzpu9yiuY+qdMIpaJWFpVDJFPrjzV7F
         UtEd+FU/v6t6P1d14u6Gm3PQazn6q81M5bvg6z0l4JPRx1wd35lpl5gxwM6CxWvt6s6U
         6FGA==
X-Gm-Message-State: AOAM533LC60XQq7b6lmE3tZkTwH2v5lLyH+t0QgvckHHD+L84Yzy/vCM
        ZW1LRVyEhR0eu/xzcHw1LHNrfuxpQr+GsLoQQhTXpw==
X-Google-Smtp-Source: ABdhPJxM9mEaua2abN9MM6LiFRqmHar5GSpW8Nxrphhv/xblL2WYVY+b0j3Af83zmQMktghNJLUNGoTFidzVNbhZeV4=
X-Received: by 2002:a25:e7ce:: with SMTP id e197mr25781866ybh.305.1605559838073;
 Mon, 16 Nov 2020 12:50:38 -0800 (PST)
MIME-Version: 1.0
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com> <20201116121711.1e7bb04c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116121711.1e7bb04c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Mon, 16 Nov 2020 12:50:22 -0800
Message-ID: <CAF2d9jjs9WF9JXzBGxrHEgAiFhS1qyDya+5WRZBHoxosAu5F4A@mail.gmail.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be controlled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 12:17 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 16 Nov 2020 12:02:48 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=
=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=
=A4=B0) wrote:
> > On Sat, Nov 14, 2020 at 10:17 AM Jakub Kicinski <kuba@kernel.org> wrote=
:
> > > On Wed, 11 Nov 2020 12:43:08 -0800 Jian Yang wrote:
> > > > From: Mahesh Bandewar <maheshb@google.com>
> > > >
> > > > Traditionally loopback devices comes up with initial state as DOWN =
for
> > > > any new network-namespace. This would mean that anyone needing this
> > > > device (which is mostly true except sandboxes where networking in n=
ot
> > > > needed at all), would have to bring this UP by issuing something li=
ke
> > > > 'ip link set lo up' which can be avoided if the initial state can b=
e set
> > > > as UP. Also ICMP error propagation needs loopback to be UP.
> > > >
> > > > The default value for this sysctl is set to ZERO which will preserv=
e the
> > > > backward compatible behavior for the root-netns while changing the
> > > > sysctl will only alter the behavior of the newer network namespaces=
.
> >
> > > Any reason why the new sysctl itself is not per netns?
> > >
> > Making it per netns would not be very useful since its effect is only
> > during netns creation.
>
> I must be confused. Are all namespaces spawned off init_net, not the
> current netns the process is in?
The namespace hierarchy is maintained in user-ns while we have per-ns
sysctls hanging off of a netns object and we don't have parent (netns)
reference when initializing newly created netns values. One can copy
the current value of the settings from root-ns but I don't think
that's a good practice since there is no clear way to affect those
values when the root-ns changes them. Also from the isolation
perspective (I think) it's better to have this behavior (sysctl
values) stand on it's own i.e. have default values and then alter
values on it's own without linking to any other netns values.
