Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0FB2B51D4
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 21:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbgKPUDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 15:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgKPUDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 15:03:05 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F018C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 12:03:05 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id o144so7892004ybg.7
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 12:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MNn7sk5UxmFd4DMhglM6JZ+45NOSZ5Kymw6p2rpGzzs=;
        b=SvxBSN0maQAf0s4piezz3KCSrqR9stNnRIpRngcapdKFOsKpXk1tPvISYpSXQW2GpO
         Kug25nw868gu1kEyBlSX02Tqdnt4/Z31DwgnZdNu1GtMK+TW6reBLrjI+Ga7HFNajmHG
         J9Cuk5kvpo4d+XWqy5Ym6k1xGtWH4nxoBBh0a5m6RGrxJz4F0ubEsMnMcRRIemZXuCXJ
         CQguOQlYzpquq6jrSolC2Tt4hxyFxvPOk1LaWUn2xYhOY/qfKed6sWfnTRtjkCAOuAiV
         J+ouQNlUbjWMrJSVpA54LuNyclwjGglvYQC12HwSD722XCdrTwEd3x+juSOd4UwxUuVU
         mnyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MNn7sk5UxmFd4DMhglM6JZ+45NOSZ5Kymw6p2rpGzzs=;
        b=hRRCoUHejZsrwqfQUCM74AoJOgd5uYQUJ7Ri81NFN2YcJIQ1VEpks6tjZVdundAMPb
         Tkku7CkiZ5B3xdukYAmGV97v4c5Jz4zLkoUcrOuFDZfOUc7jehbh5oTCDHCnGIerpc/b
         sMgRwfqs6UPzA6sWmR5JxyOdEGbbW+zahCc4XLWGFdCLYqeCyXHvkAc3yvPGENJXcBBN
         hSrFcGVVl/hXqRLb9PqFfeAiQ9zQTcFHZJKO5v37WDVEsivkql799l7WefqrzyuAVkXw
         FzGzCv9qHqOnPDqkPC4H58MLkULbP4LeI1Oacb9+vS3afdconSsH/OIS/4/KtPRe+8fc
         VYSA==
X-Gm-Message-State: AOAM531sjuWtFxefrM9bT+Cto1WTbVK16OOjtG/YyJJZ+uiaRUuRmskE
        HNjjGcmzT/uVm3vv8jgXOt6sGzRgRQw4kqaR+cCGJocNxIg=
X-Google-Smtp-Source: ABdhPJyHeTLUFHPVqAr72fUgCrpmNmrVCZwfzEgPhm+RPAa+iIHB0YPoVUJ+KIQzzihSRT3YqbdR0fyTNoP8zBZVVjc=
X-Received: by 2002:a25:848e:: with SMTP id v14mr18611324ybk.153.1605556984434;
 Mon, 16 Nov 2020 12:03:04 -0800 (PST)
MIME-Version: 1.0
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com> <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Mon, 16 Nov 2020 12:02:48 -0800
Message-ID: <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be controlled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 10:17 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 11 Nov 2020 12:43:08 -0800 Jian Yang wrote:
> > From: Mahesh Bandewar <maheshb@google.com>
> >
> > Traditionally loopback devices comes up with initial state as DOWN for
> > any new network-namespace. This would mean that anyone needing this
> > device (which is mostly true except sandboxes where networking in not
> > needed at all), would have to bring this UP by issuing something like
> > 'ip link set lo up' which can be avoided if the initial state can be set
> > as UP. Also ICMP error propagation needs loopback to be UP.
> >
> > The default value for this sysctl is set to ZERO which will preserve the
> > backward compatible behavior for the root-netns while changing the
> > sysctl will only alter the behavior of the newer network namespaces.
>
> Any reason why the new sysctl itself is not per netns?
>
Making it per netns would not be very useful since its effect is only
during netns creation.

> > +netdev_loopback_state
> > +---------------------
>
> loopback_init_state ?
>
That's fine, thanks for the suggestion.

> > +Controls the loopback device initial state for any new network namespaces. By
> > +default, we keep the initial state as DOWN.
> > +
> > +If set to 1, the loopback device will be brought UP during namespace creation.
> > +This will only apply to all new network namespaces.
> > +
> > +Default : 0  (for compatibility reasons)
> > +
> >  netdev_max_backlog
> >  ------------------
> >
> > diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
> > index a1c77cc00416..76dc92ac65a2 100644
> > --- a/drivers/net/loopback.c
> > +++ b/drivers/net/loopback.c
> > @@ -219,6 +219,13 @@ static __net_init int loopback_net_init(struct net *net)
> >
> >       BUG_ON(dev->ifindex != LOOPBACK_IFINDEX);
> >       net->loopback_dev = dev;
> > +
> > +     if (sysctl_netdev_loopback_state) {
> > +             /* Bring loopback device UP */
> > +             rtnl_lock();
> > +             dev_open(dev, NULL);
> > +             rtnl_unlock();
> > +     }
>
> The only concern I have here is that it breaks notification ordering.
> Is there precedent for NETDEV_UP to be generated before all pernet ops
> ->init was called?
I'm not sure if any and didn't see any issues in our usage / tests.
I'm not even sure anyone is watching/monitoring for lo status as such.
