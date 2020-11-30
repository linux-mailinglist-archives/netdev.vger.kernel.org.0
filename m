Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057702C8F5B
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 21:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgK3Unz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 15:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbgK3Uny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 15:43:54 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEADC0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:43:14 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id z136so13266574iof.3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NN7qCLH+ioDlVPhLhLTDRihtM+rcV1qS2YtJCru7tDc=;
        b=K+088g+4xXKgRTEM+s6k6NI3jZmizS81qswCwS7Wl9PfCPWNjVnMyz3MRqqzGhwVLz
         EI/BAw4ozkDr7M93N7jRVcVvDMndIZYRpp7SeVfYp5yGfrxoCSQqFk8+2sFlTzh660+o
         f/2UUpJMA7uSKVtbyxOHQRTjfTh4XvU0a9swTxr54cGsnntFjpF8mc4Gsv+bsIpIFXzv
         TXS6SKSQjhrMVx0AmidPibVGMMFmYUXxR2eaUh9LhyPmuS+Qa+ggKx6Tey0zoKdBtvLy
         UR16CQw9kBugofkkPgiFu4JnWkAT7T26Y/GXOSlW36Bmx2ISlAXig117wdR83p2czVfQ
         PL/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NN7qCLH+ioDlVPhLhLTDRihtM+rcV1qS2YtJCru7tDc=;
        b=fXnF5CXLJllg8GZ++UwtqeEg9wqHUgyajnGBVXVJYUD/6mNBER6NnzbviCL6tyRtZ/
         gDXcmK8gui0fqS3Sw06RlkYpj3SJ+4sTNgE0k41FSp2U28buLqxvuEfjbSquiZy8bhCF
         XKOiz7carfl4lWRNC5ojgd1+KatVSVFW8Z7umsAZLhPMDH3V32vG6xmJ1YObI/nqESzB
         AWL0UwVaNqJ4FKTkOy3p78sZEgK9kvdxOnTWe4RokztO9fS+aOJ/Ba48BQjrHkf7yv8V
         wf6LO7dZHeakInKhmDGbn/hcQndojU/0DlHwZafd+aJnNDTPWWBtoN4tqvQIatKHXTL7
         Izog==
X-Gm-Message-State: AOAM532JXqfhy9TdJgImBVMboNfJ4ev5VYgGcrmWBA/9x3Y1vZL6NFaL
        NVflNxX43r6gW929F199muJR+UmQ+s3+Qg5BayKOlQ==
X-Google-Smtp-Source: ABdhPJyu6cjRXWWY6QnX0lI71IMLUzG5BRq3vkfwUgvABAj4MHVlWzseuovt1jqu2RD+osXDIz/u8b5vUzra+SMEkDY=
X-Received: by 2002:a6b:f309:: with SMTP id m9mr15677622ioh.99.1606768993640;
 Mon, 30 Nov 2020 12:43:13 -0800 (PST)
MIME-Version: 1.0
References: <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf> <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
 <20201130190348.ayg7yn5fieyr4ksy@skbuf> <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
 <20201130194617.kzfltaqccbbfq6jr@skbuf> <20201130122129.21f9a910@hermes.local>
 <20201130202626.cnwzvzc6yhd745si@skbuf> <CANn89i+H9dVgVE0NbucHizZX2une+bjscjcCT+ZvVNj5YFHYpg@mail.gmail.com>
 <20201130203640.3vspyoswd5r5n3es@skbuf>
In-Reply-To: <20201130203640.3vspyoswd5r5n3es@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 30 Nov 2020 21:43:01 +0100
Message-ID: <CANn89iJ1+P_ihPwyHGwCpkeu1OAj=gf+MAnyWmZvyMg4uMfodw@mail.gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 9:36 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Nov 30, 2020 at 09:29:15PM +0100, Eric Dumazet wrote:
> > On Mon, Nov 30, 2020 at 9:26 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Mon, Nov 30, 2020 at 12:21:29PM -0800, Stephen Hemminger wrote:
> > > > if device is in a private list (in bond device), the way to handle
> > > > this is to use dev_hold() to keep a ref count.
> > >
> > > Correct, dev_hold is a tool that can also be used. But it is a tool that
> > > does not solve the general problem - only particular ones. See the other
> > > interesting callers of dev_get_stats in parisc, appldata, net_failover.
> > > We can't ignore that RTNL is used for write-side locking forever.
> >
> > dev_base_lock is used to protect the list of devices (eg for /proc/net/devices),
> > so this will need to be replaced by something. dev_hold() won't
> > protect the 'list' from changing under us.
>
> Yes, so as I was saying. I was thinking that I could add another locking
> mechanism, such as struct net::netdev_lists_mutex or something like that.
> A mutex does not really have a read-side and a write-side, but logically
> speaking, this one would. So as long as I take this mutex from all places
> that also take the write-side of dev_base_lock, I should get equivalent
> semantics on the read side as if I were to take the RTNL mutex. I don't
> even need to convert all instances of RTNL-holding, that could be spread
> out over a longer period of time. It's just that I can hold this new
> netdev_lists_mutex in new code that calls for_each_netdev and friends,
> and doesn't otherwise need the RTNL.
>
> Again, the reason why I opened this thread was that I wanted to get rid
> of dev_base_lock first, before I introduced the struct net::netdev_lists_mutex.

Understood, but really dev_base_lock can only be removed _after_ we
convert all usages
to something else (mutex based, and preferably not the global RTNL)

Focusing on dev_base_lock seems a distraction really.
