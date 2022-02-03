Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D5A4A8C4D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353717AbiBCTMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353676AbiBCTMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:12:45 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35E1C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 11:12:45 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id g14so11895938ybs.8
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 11:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LHoUcqZDNLQWbA/SuTbZ6VDZ9Oq8v1QDc+oOx2szl/s=;
        b=guYLeqbWR2XTAtsSodVuanfsfLK2OVZclBeEeHhcvWnOcFO5iL1Y4OJZVFO2bTo83l
         QL2zYA+ovS1DC/UCP00Fgc7ZHLBsRVueFtTsCnGRRvOaNcyLD3KxWBPB2cXHfHNEaviV
         86o33Qv6bkQUJaxcVA2BY0Hm0bQ8KTHFrU3t4bey6AoK7YYB+c4vYx0nrG5eRk6skV/K
         rarqhT29n8J8KRodgOaTmadXskyOEce3/dLy/jnoHev5it6tShNHZrZGHQx6saciS8kN
         I2HET4XE0yed9Lc9io9cL17egK3+IWXTTKeTybjD0Qz9mUhGdtq2TyUo360031FgoZbN
         MIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LHoUcqZDNLQWbA/SuTbZ6VDZ9Oq8v1QDc+oOx2szl/s=;
        b=5qsTegmdONhvaxx1ReCxwa1T7joz/HFeklmiHci9Hm+4NdP/R7V6Fa5M3pAWxeDHaQ
         neh/EvOkF/Fbpn9rHzSw/PRSTC/h7/iYlJF0h0lgdIEDizZc0chOX7cwcXru0BMAiq/b
         HkxEKu1hhFoCiRHC6C4OXvDQZXhEBKaydDZ0qv4rgQPMP/UYg9ok7sA9xYVdq4u91MJL
         whJfvqM/pFPwN79xy3nyaiwkQInU3L7Jb0UAICKmiSIbfhu2/7IiNj97YdV+QTxVZKea
         kaVZOoXHQ6g8OdIMt4D64/nKxQ7WtpGigxQDdDoQuxbO+FG5NcsHmwjyUYMsh84sFxu5
         6W7w==
X-Gm-Message-State: AOAM531ufYcYFsotBu7LzKeRSogLnl5i3gWtsjhAI4tE6WdKOD0mDnj6
        ay9uuuYmVm4MYwSCPxYI3D5sRz1N5L3ToPFYJOVhFA==
X-Google-Smtp-Source: ABdhPJwvMhoWAqP+EK7vMFQ4hl3zFKKVnknTeXK3KI1XmAnEYdN5g63Fd3bu7XiudUVHQB5HctH5fbdusi4qvwuoz5U=
X-Received: by 2002:a25:4f41:: with SMTP id d62mr48504949ybb.156.1643915564561;
 Thu, 03 Feb 2022 11:12:44 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-2-eric.dumazet@gmail.com> <20220203083407.523721a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iKd-M6Ry+K7m+n5Voo641K7S24qm27SwrP4VAAchVPT4A@mail.gmail.com> <20220203105842.60c25d46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220203105842.60c25d46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 11:12:33 -0800
Message-ID: <CANn89i+q5rYm0QgHSHjmEH09DH3XGQ7N9uNvuiV_zu6LsE4m5w@mail.gmail.com>
Subject: Re: [PATCH net-next 01/15] net: add netdev->tso_ipv6_max_size attribute
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 10:58 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 3 Feb 2022 08:56:56 -0800 Eric Dumazet wrote:
> > On Thu, Feb 3, 2022 at 8:34 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed,  2 Feb 2022 17:51:26 -0800 Eric Dumazet wrote:
> > > > From: Eric Dumazet <edumazet@google.com>
> > > >
> > > > Some NIC (or virtual devices) are LSOv2 compatible.
> > > >
> > > > BIG TCP plans using the large LSOv2 feature for IPv6.
> > > >
> > > > New netlink attribute IFLA_TSO_IPV6_MAX_SIZE is defined.
> > > >
> > > > Drivers should use netif_set_tso_ipv6_max_size() to advertize their limit.
> > > >
> > > > Unchanged drivers are not allowing big TSO packets to be sent.
> > >
> > > Many drivers will have a limit on how many buffer descriptors they
> > > can chain, not the size of the super frame, I'd think. Is that not
> > > the case? We can't assume all pages but the first and last are full,
> > > right?
> >
> > In our case, we have a 100Gbit Google NIC which has these limits:
> >
> > - TX descriptor has a 16bit field filled with skb->len
> > - No more than 21 frags per 'packet'
> >
> > In order to support BIG TCP on it, we had to split the bigger TCP packets
> > into smaller chunks, to satisfy both constraints (even if the second
> > constraint is hardly hit once you chop to ~60KB packets, given our 4K
> > MTU)
> >
> > ndo_features_check() might help to take care of small oddities.
>
> Makes sense, I was curious if we can do more in the core so that fewer
> changes are required in the drivers. Both so that drivers don't have to
> strip the header and so that drivers with limitations can be served
> pre-cooked smaller skbs.

I have on my plate to implement a helper to split 'big GRO/TSO' packets
into smaller chunks. I have avoided doing it in our Google NIC driver,
to avoid extra sk_buff/skb->head allocations for each BIG TCP packet.

Yes, core networking stack could use it.

> I wonder how many drivers just assumed MAX_SKB_FRAGS will never
> change :S What do you think about a device-level check in the core
> for number of frags?

I guess we could do this if the CONFIG_MAX_SKB_FRAGS > 17
