Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB22E3BAD60
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 16:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhGDO0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 10:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhGDO0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 10:26:07 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C902EC061574;
        Sun,  4 Jul 2021 07:23:31 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id d25so20836175lji.7;
        Sun, 04 Jul 2021 07:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QQ8fC3U+eQ17Py3JW08RD2kurLesfxRQvTbMCtXVzs0=;
        b=lFj2gCQtpzO2v4b4TQA/U/dVHMs9HBcgVJQf3aQyLhxla/3sVVQl2fZc9She+PqJ2t
         nZr2trYKndPkajerKuGbNCXbprLCEcFxujWcVwS7gu7lCw3GYbR68NQHc0ScGrUMnxUO
         VW8RC+8nSeo2LAguLo0oU9/eWpgnyuVOU1LG1J7E+YSXAKEn1MhiBSrj4fnN8vXg5rDq
         1BKDtmu/M/BUNyo7PAdf73pWaS5PhEArGeLD2isWjjBsMNES2y5GPAAvmMXmS2TDwofC
         5o7DC+VSVwE12k+YdL5uQlkwfk3pMWESNRnlUNpb/ILsCJZwXZvVdThZ3Br+Pk3HiNg/
         Qtuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QQ8fC3U+eQ17Py3JW08RD2kurLesfxRQvTbMCtXVzs0=;
        b=DjGGc15f1UGpzA7RVp3H9+aruzyd+DP6s8268soc5EK1HnMaxZnJJRnd9cUEgYShiL
         WBEI3rH0cSiwp9Zah9RQJO7AnTIL5OBZtsoL3baC21r5A7fj8cQdcwHk5sL+DqxNlpmD
         3z4RYm8lkM4ZGR9UwDl5Zr/CQotPiL7MSJwr2rHR1lOmRwUNyR9Ll8+1vTkEy8TmNhd6
         RFRY1TJOIQnt6JU1bcJ+CgfQP1UXj3PL2COT8Teh+VweU/Vno/RBG5tbjmYm1nmcM6wd
         GvA6iGm+VjdyLYNM94pxmNR6NVZ8tNtOLkCFy2rEOEiyJ0VJZSlIcsnz75hmh5HDK6l6
         sdHw==
X-Gm-Message-State: AOAM532Z2ueos4xvjj1P04nzym1HxI6HuclF9ZliHLxABBtLS6+3hT2P
        keIMifwRwqKfQ7gngpuVBuibzWhGA4FEFN1esP8=
X-Google-Smtp-Source: ABdhPJxCrhfQ6AaOo8v7uQm676Z3bkpNTlt4bvtRG3QiQ1g4Sgx6Ttp0wb/lHgOpo9F5gxNZO1jBK/OtojkPkWKNIOA=
X-Received: by 2002:a2e:87d1:: with SMTP id v17mr7596782ljj.258.1625408610199;
 Sun, 04 Jul 2021 07:23:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
 <20210701192044.78034-3-alexei.starovoitov@gmail.com> <20210702062343.dblrnycfwzjch6py@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210702062343.dblrnycfwzjch6py@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 4 Jul 2021 07:23:19 -0700
Message-ID: <CAADnVQL=BXwNUSjjj8t0B6yenC32-Me_B7BLsLv9pfOeg5mkfg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/9] bpf: Add map side support for bpf timers.
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 11:23 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Jul 01, 2021 at 12:20:37PM -0700, Alexei Starovoitov wrote:
> [ ... ]
>
> > +static void htab_free_prealloced_timers(struct bpf_htab *htab)
> > +{
> > +     u32 num_entries = htab->map.max_entries;
> > +     int i;
> > +
> > +     if (likely(!map_value_has_timer(&htab->map)))
> > +             return;
> > +     if (htab_has_extra_elems(htab))
> > +             num_entries += num_possible_cpus();
> > +
> > +     for (i = 0; i < num_entries; i++) {
> > +             struct htab_elem *elem;
> > +
> > +             elem = get_htab_elem(htab, i);
> > +             bpf_timer_cancel_and_free(elem->key +
> > +                                       round_up(htab->map.key_size, 8) +
> > +                                       htab->map.timer_off);
> > +             cond_resched();
> > +     }
> > +}
> > +
> [ ... ]
>
> > +static void htab_free_malloced_timers(struct bpf_htab *htab)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < htab->n_buckets; i++) {
> > +             struct hlist_nulls_head *head = select_bucket(htab, i);
> > +             struct hlist_nulls_node *n;
> > +             struct htab_elem *l;
> > +
> > +             hlist_nulls_for_each_entry(l, n, head, hash_node)
> It is called from map_release_uref() which is not under rcu.
> Either a bucket lock or rcu_read_lock is needed here.

yeah. rcu_read_lock should do it.

> Another question, can prealloc map does the same thing
> like here (i.e. walk the buckets) during map_release_uref()?

you mean instead of for (i = 0; i < num_entries; i++) ?
It can, but it's slower than for loop and there was already a precedent
with similar loop to free per-cpu bits.
