Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65AA2C8F4E
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 21:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbgK3UhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 15:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbgK3UhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 15:37:23 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD74C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:36:43 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id qw4so14372663ejb.12
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zrsbyLjmEosf6VtQ8tH03AfMWawGL3ES5MWGalf6svU=;
        b=Jrz7DRbtwLvRmbbiyJn9ErwhSphgFJVoNcvkRAGd+x8mlXaEECcL8L9VwgEiDwTqTz
         VCId5HXn7ZM56ShoG1j6JMyTP5qPAIxaEg2hBegIxLBugchdojqf2jBfq1C1pQQvDYYi
         F/+4u007bi982XKst4oxWl20I4tcMoS3hnS6qboJuSI+V3/G4zaGITfc4Wo/GxdFL8Z6
         FmdkgB2qrMHPwX7kauUaq+4RwKSS6NTdLA+403iKlFcIq2f8yRg3BHQFMk0N78M+muvx
         lThYPCUyUqmG3e3zul1/1msKd/MKGAZ640rSuFisKFfgomULHl3zXMSwkL7bYNZCbFqw
         R9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zrsbyLjmEosf6VtQ8tH03AfMWawGL3ES5MWGalf6svU=;
        b=QkruA+e7FN1UVuWaw3JJzlarJwLzk45IR5mH47Z5ABhauuquomvNvPHiOFkpVUhTtS
         8lXH/P410tx7lKs6shndvR9eOvarMfN10AnRfYy8JhU1M28FoGxvAv8GkLBnPcw5yaqd
         KoMNPuBNhgmideI4b3Jtf+MPgclSx5q62V1whjEFrr7uP/Isr69qJi9QyD25125XXLXq
         n9NFNWk0/PXlCLmmSKq3wWONHE/fHKbdZjV80n6WvvitevPZiTAWp1XGhykiWAfg5ie7
         VQ5oV0xu5RiJfRxW2fpHY/WypoMygL/v9h/JjAcLB/G+I1+AJy/N3DOxu2NOvXwRQb5a
         y7Vg==
X-Gm-Message-State: AOAM530BnlVIwSMCmlLOVUoVQCaCs0KSZj99uR8ceK+adkjiWT1FTYf2
        94/9jdzPExC33Kt0T3rNIpU=
X-Google-Smtp-Source: ABdhPJzsh/N4n38BwqzC2XpM08gEu6vGvTq+JtMugJMBO3eU02mQ/yg48OlAHa3Og4aCPFAUDF2tfQ==
X-Received: by 2002:a17:906:4944:: with SMTP id f4mr22449858ejt.231.1606768602067;
        Mon, 30 Nov 2020 12:36:42 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id x15sm9531197edj.91.2020.11.30.12.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 12:36:41 -0800 (PST)
Date:   Mon, 30 Nov 2020 22:36:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
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
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201130203640.3vspyoswd5r5n3es@skbuf>
References: <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf>
 <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
 <20201130190348.ayg7yn5fieyr4ksy@skbuf>
 <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
 <20201130194617.kzfltaqccbbfq6jr@skbuf>
 <20201130122129.21f9a910@hermes.local>
 <20201130202626.cnwzvzc6yhd745si@skbuf>
 <CANn89i+H9dVgVE0NbucHizZX2une+bjscjcCT+ZvVNj5YFHYpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+H9dVgVE0NbucHizZX2une+bjscjcCT+ZvVNj5YFHYpg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 09:29:15PM +0100, Eric Dumazet wrote:
> On Mon, Nov 30, 2020 at 9:26 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Mon, Nov 30, 2020 at 12:21:29PM -0800, Stephen Hemminger wrote:
> > > if device is in a private list (in bond device), the way to handle
> > > this is to use dev_hold() to keep a ref count.
> >
> > Correct, dev_hold is a tool that can also be used. But it is a tool that
> > does not solve the general problem - only particular ones. See the other
> > interesting callers of dev_get_stats in parisc, appldata, net_failover.
> > We can't ignore that RTNL is used for write-side locking forever.
>
> dev_base_lock is used to protect the list of devices (eg for /proc/net/devices),
> so this will need to be replaced by something. dev_hold() won't
> protect the 'list' from changing under us.

Yes, so as I was saying. I was thinking that I could add another locking
mechanism, such as struct net::netdev_lists_mutex or something like that.
A mutex does not really have a read-side and a write-side, but logically
speaking, this one would. So as long as I take this mutex from all places
that also take the write-side of dev_base_lock, I should get equivalent
semantics on the read side as if I were to take the RTNL mutex. I don't
even need to convert all instances of RTNL-holding, that could be spread
out over a longer period of time. It's just that I can hold this new
netdev_lists_mutex in new code that calls for_each_netdev and friends,
and doesn't otherwise need the RTNL.

Again, the reason why I opened this thread was that I wanted to get rid
of dev_base_lock first, before I introduced the struct net::netdev_lists_mutex.
