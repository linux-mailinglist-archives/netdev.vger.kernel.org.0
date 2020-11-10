Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555F42ACACE
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbgKJB6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgKJB6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 20:58:35 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20FEC0613CF;
        Mon,  9 Nov 2020 17:58:35 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id c80so12552250oib.2;
        Mon, 09 Nov 2020 17:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DC8+tLhb9a8fMLxHpLtJ9VTDmC950bus6WDTnMhq6EI=;
        b=Folh9NIKyaT4XVyUdc3Fy7l3SM0kW87zCzcF2vWHUeKWkjONGj1ZsU01wfRvmexy/l
         Zrs1R90AN+JFbX3uoghO0qcRYwfIrapfe+PtnKWC8HIfGzD7x+y6NG5RGZIJADh7jbVk
         jwnS/R1VTEYVllDo1hrGkhv9U8zoc6R6yvSVWWYUJNTpIS9llzZJwcC7O+qMSZrnund6
         reTwOawFmbM+X0h0CyVZKFoHTlAl/iKmmTf9n4OT+71cMCcbLsWesPA/TqSAUfCJPO6K
         0RKY137HHkNCZaAKi0nk23mtWagLh2Sv/k1L6fYRrohOkFG9kicrWWlrrDB1jmWEZaN+
         dMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DC8+tLhb9a8fMLxHpLtJ9VTDmC950bus6WDTnMhq6EI=;
        b=kYQBppqdpXesT1zcRforDGOvl52PDDEDY72DGYtcLnZ4pH+GMzk5DzrLrF4yjXT2bT
         sgcGUOXc52gQExF4SqC0/vyo922AMkd20PSuplK8nEwTh5JeN51ji6TyC+jcoKtly1pz
         PTmESRajb6xsYSTth3lCzKctL501MpadLaneM7oP7UR4lo5WW88x1l6qy6uf+2ask+7B
         74v/LtLh1/hL/McpjR6xm+Y6D91wDDnULW6oQ8Zy7HLIdWwByudOER+UM5hC5DpI67LI
         WLESLjxrltt8IqGuDjvDwDPkVrDzizfoZpJnV15Y8vY5Y8y8vRReEUm/5fw1ZRDrY6vi
         Rokg==
X-Gm-Message-State: AOAM5322w2/F5Ura0I4vkZaMPiv7hRdxZfo2e5LD6AKfX4iTRvkq2a36
        BQ4YZSkypn0qvpwE3xEABjnS6xx48TqDLeSklM8=
X-Google-Smtp-Source: ABdhPJyndzSrsy63dd3cPba+mThUF2ZBAEHKGVYrvxzYJ06ov8mkQrwaX8KAh9RlKx1oHXZ1WMa3JWGAtFB8/wtc95Q=
X-Received: by 2002:aca:ec97:: with SMTP id k145mr1373199oih.163.1604973515290;
 Mon, 09 Nov 2020 17:58:35 -0800 (PST)
MIME-Version: 1.0
References: <20201107122617.55d0909c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <222b9c1b-9d60-22f3-6097-8abd651cc192@gmail.com> <CAD=hENdP8sJrBZ7uDEWtatZ3D6bKQY=wBKdM5NQ79xveohAnhQ@mail.gmail.com>
 <20201109102518.6b3d92a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109102518.6b3d92a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Tue, 10 Nov 2020 09:58:24 +0800
Message-ID: <CAD=hENcAc8TZSeW1ba_BDiT7M7+HeyWUHSVwnFQjOi6vk5TPMQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] RDMA/rxe: Fetch skb packets from ethernet layer
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 2:25 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 8 Nov 2020 13:27:32 +0800 Zhu Yanjun wrote:
> > On Sun, Nov 8, 2020 at 1:24 PM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
> > > On Thu, 5 Nov 2020 19:12:01 +0800 Zhu Yanjun wrote:
> > >
> > > In the original design, in rx, skb packet would pass ethernet
> > > layer and IP layer, eventually reach udp tunnel.
> > >
> > > Now rxe fetches the skb packets from the ethernet layer directly.
> > > So this bypasses the IP and UDP layer. As such, the skb packets
> > > are sent to the upper protocals directly from the ethernet layer.
> > >
> > > This increases bandwidth and decreases latency.
> > >
> > > Signed-off-by: Zhu Yanjun <yanjunz@nvidia.com>
> > >
> > >
> > > Nope, no stealing UDP packets with some random rx handlers.
> >
> > Why? Is there any risks?
>
> Are there risks in layering violations? Yes.
>
> For example - you do absolutely no protocol parsing,

Protocol parsing is in rxe driver.

> checksum validation, only support IPv4, etc.

Since only ipv4 is supported in rxe, if ipv6 is supported in rxe, I
will add ipv6.

>
> Besides it also makes the code far less maintainable, rx_handler is a

This rx_handler is also used in openvswitch and bridge.

Zhu Yanjun

> singleton, etc. etc.
>
> > > The tunnel socket is a correct approach.
