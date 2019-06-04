Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314CA351FC
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfFDVgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:36:40 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:39567 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfFDVgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:36:40 -0400
Received: by mail-it1-f193.google.com with SMTP id j204so402885ite.4
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3IiwAKofoqXEe0KtLFJibzUduMTU1RvwutK//Jj46Bg=;
        b=sgxWmjoDCVtQnrZhG/NtALYkKwzyomxB8wM3uTCbA8pt3Kpxr8jQkx2FVZSfMklmhT
         X9PP1DJoLo8pOcMG5tEUtqAe4hE/RCBGdxIxB+L6nRqdUHtpeR2D7GYn6CTxL7Cj/xlR
         gTOhEFT34KM/VNcnEUmy6r+05l+YmNiD7LHTompnpImywqimW0+5blUmsLYU3uLQeSls
         P8X2hlDCpxa5ILYWtUrm2v1UQuueKoTa4bB7jPk74U7Za0X2KavCT+p5H37uJMGNVYpL
         nrQg9ntaAPA1nmHOy2dZTAskFNyjVznheRB8y4/aAWfwp64ysmuHcu+uMcgbrgOgyIhA
         Em5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3IiwAKofoqXEe0KtLFJibzUduMTU1RvwutK//Jj46Bg=;
        b=r3sN963Yqs+u1hSZbGy5MI5OhP7487oyAWqTbc4I5q3LyPF/JfIA6j0B+N1ZxhMIr6
         C9/vPhsebQDB9RpLUv0mEzaVimmMCVkjCNa+E/4yVgord/ryzrQfnbTfrxmG18EwdJ4N
         RucX2NGAZ3ZtpAaJ/p6zPIP8TNcSDPoCWhxTarteBJZFSMwvYo+MhhhhNCpah499YU7B
         bW05c4RwQA1rhYzhAN0X8Hmp9Fp1Kp3cXZ8C6lw5uuS+4S1Pw8jmwaKjC+YJHlbR0N7W
         gpVHPBSlGm9IbrvxvvbsxBpaeRambnnsOXRu7YvCiOM/UMYWco+MEk30LlKmWJD90HDn
         OmQw==
X-Gm-Message-State: APjAAAXxm4iE/zwzMAm09YksKVckP41zRuKClyeWoy+AKfHYVA6P6qMK
        imwLnV1LPszaFOxntRYSUgqKJ/8QYPLIVJHWd2rfdw==
X-Google-Smtp-Source: APXvYqzl6UO6kj6kZf/tZxwrB2QQo3LYmKQKH8eo1LPfGeE/OBga5xUaxPxcX0ikrotgjWcyed5e65AWREYEDqtV644=
X-Received: by 2002:a24:6e55:: with SMTP id w82mr20792804itc.17.1559684199001;
 Tue, 04 Jun 2019 14:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
 <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com> <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
 <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com> <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
 <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com> <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
 <453565b0-d08a-be96-3cd7-5608d4c21541@gmail.com> <20190604052929.4mlxa5sswm46mwrq@kafai-mbp.dhcp.thefacebook.com>
 <c7fb6999-16a2-001d-8e9a-ac44ed9e9fa2@gmail.com> <20190604210619.kq5jnkinak7izn2u@kafai-mbp.dhcp.thefacebook.com>
 <0c307c47-4cde-1e55-8168-356b2ef30298@gmail.com>
In-Reply-To: <0c307c47-4cde-1e55-8168-356b2ef30298@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 4 Jun 2019 14:36:27 -0700
Message-ID: <CAEA6p_AAP10bXOQPfOqY253H7BQYgksP_iDXDi-RKguLcKh0SA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     David Ahern <dsahern@gmail.com>
Cc:     Martin Lau <kafai@fb.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 2:13 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/4/19 3:06 PM, Martin Lau wrote:
> > On Tue, Jun 04, 2019 at 02:17:28PM -0600, David Ahern wrote:
> >> On 6/3/19 11:29 PM, Martin Lau wrote:
> >>> On Mon, Jun 03, 2019 at 07:36:06PM -0600, David Ahern wrote:
> >>>> On 6/3/19 6:58 PM, Martin Lau wrote:
> >>>>> I have concern on calling ip6_create_rt_rcu() in general which seems
> >>>>> to trace back to this commit
> >>>>> dec9b0e295f6 ("net/ipv6: Add rt6_info create function for ip6_pol_route_lookup")
> >>>>>
> >>>>> This rt is not tracked in pcpu_rt, rt6_uncached_list or exception bucket.
> >>>>> In particular, how to react to NETDEV_UNREGISTER/DOWN like
> >>>>> the rt6_uncached_list_flush_dev() does and calls dev_put()?
> >>>>>
> >>>>> The existing callers seem to do dst_release() immediately without
> >>>>> caching it, but still concerning.
> >>>>
> >>>> those are the callers that don't care about the dst_entry, but are
> >>>> forced to deal with it. Removing the tie between fib lookups an
> >>>> dst_entry is again the right solution.
> >>> Great to know that there will be a solution.  It would be great
> >>> if there is patch (or repo) to show how that may look like on
> >>> those rt6_lookup() callers.
> >>
> >> Not 'will be', 'there is' a solution now. Someone just needs to do the
> >> conversions and devise the tests for the impacted users.
> > I don't think everyone will convert to the new nexthop solution
> > immediately.
> >
> > How about ensuring the existing usage stays solid first?
>
> Use of nexthop objects has nothing to do with separating fib lookups
> from dst_entries, but with the addition of fib6_result it Just Works.
>
> Wei converted ipv6 to use exception caches instead of adding them to the
> FIB.
>
> I converted ipv6 to use separate data structures for fib entries, added
> direct fib6 lookup functions and added fib6_result. See the
> net/core/filter.c.
>
> The stage is set for converting users.
>
> For example, ip6_nh_lookup_table does not care about the dst entry, only
> the fib entry. This converts it:
>
> static int ip6_nh_lookup_table(struct net *net, struct fib6_config *cfg,
>                                const struct in6_addr *gw_addr, u32 tbid,
>                                int flags, struct fib6_result *res)
> {
>         struct flowi6 fl6 = {
>                 .flowi6_oif = cfg->fc_ifindex,
>                 .daddr = *gw_addr,
>                 .saddr = cfg->fc_prefsrc,
>         };
>         struct fib6_table *table;
>         struct rt6_info *rt;
>
>         table = fib6_get_table(net, tbid);
>         if (!table)
>                 return -EINVAL;
>
>         if (!ipv6_addr_any(&cfg->fc_prefsrc))
>                 flags |= RT6_LOOKUP_F_HAS_SADDR;
>
>         flags |= RT6_LOOKUP_F_IGNORE_LINKSTATE;
>
>         fib6_table_lookup(net, table, cfg->fc_ifindex, fl6, res, flags);
>         if (res.f6i == net->ipv6.fib6_null_entry)
>                 return -ENETUNREACH;
>
>         fib6_select_path(net, &res, fl6, oif, false, NULL, flags);
>
>         return 0;
> }

I do agree with Martin that ip6_create_rt_rcu() seems to be dangerous
as the dst cache created by this func does not get tracked anywhere
and it is up to the user to not cache it for too long.
But I think David, what you are suggesting is:
instead of trying to convert ip6_create_rt_rcu() to use the pcpu_dst
logic, completely get rid of the calling to ip6_create_rt_rcu(), and
directly return f6i in those cases to the caller. Is that correct?
