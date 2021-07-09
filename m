Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E90C3C1FCC
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 09:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhGIHDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 03:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhGIHDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 03:03:13 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA1CC0613DD;
        Fri,  9 Jul 2021 00:00:30 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id c28so20781159lfp.11;
        Fri, 09 Jul 2021 00:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UMuCvwIEyC2/SQfkOhMDs6Rgn07ioKFQMFhgb6LDuUk=;
        b=bfYFMG6telRFvQWphNcx50h6aUNzvO7reACm8NSchtbMdoSp749e4XXqg4tpzflU6O
         +oUomqRSz81MYkbhPraMPLo8RwIa20XZdJUa13+d0SHCVPiXpjqhrW/fu7cc72dRZ20x
         bU6yBj0e1gJvs9vc874M3FV28rUWyzh/ANXfaNNS6CTr9KsQnGZnfDxwmDKz9VAx+279
         cupj7pO8fRjCHnwywElMRkXuVLGmw4+UYvpwjYSEf7rPowbkjxyLGAoobpMbWs4AA+S2
         DFebUY1j4YmPTJC55JlFoKGOs549ZhqexaByB+YBuTfOTqt0HuT1b+vt06ty0kpqZjFj
         UEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UMuCvwIEyC2/SQfkOhMDs6Rgn07ioKFQMFhgb6LDuUk=;
        b=dpJEkXo23Zp843VlVMlgqMP4U3n9fk0JczpLRCgP3tMYQacJmYYHxpxrka74yUAFAv
         y1Xdi1NpuBpaW0CBpxTagEeplugQFJk1yG4Qs3XnrHAPpEJvcnwW+vtSR5AethXckiD1
         cDJypd0eVPV875rSeu8gMTYlNn0vajq9a37ZAhCOVf8O2FeZYpNIYwo1g8yC5e587hnl
         mWLqfSLfMP3d9byPkeIft16Gqa5NfGDE28TmvTHT7I4TU/xypbiLl2V8c+BcE/GA6kKU
         1iBR4wb/4osXcHiZ0cD45UTsnCdeC7bW19HsLhR4J8SgrnaLzwKZLVdIpayGQEENuq8n
         9fOw==
X-Gm-Message-State: AOAM533CHr5nKJDb/66aO/I9mAmDqhy4D+UQp8U00UKi7Bm00htq5bkH
        FB5V4fhFlEmzQSd2i1OnuvG1Cxf72ouvLtvXZXw=
X-Google-Smtp-Source: ABdhPJwxdWDFz/OQSnLV0gQ9tFMg7AvoBCqz6X4xk2DtvOu3ofKDTSgSijrutwMyOWzMq6Y5hdzrzEvvyzrNMUXrOfA=
X-Received: by 2002:a19:5016:: with SMTP id e22mr24852606lfb.539.1625814027686;
 Fri, 09 Jul 2021 00:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
 <20210708011833.67028-5-alexei.starovoitov@gmail.com> <20210709015119.l5kxp5kao24bjft7@kafai-mbp.dhcp.thefacebook.com>
 <20210709035223.s2ni6phkdajhdg2i@ast-mbp.dhcp.thefacebook.com> <20210709060442.55py42lmbwfzd4zx@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210709060442.55py42lmbwfzd4zx@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 9 Jul 2021 00:00:16 -0700
Message-ID: <CAADnVQKUEsW8kF4iJP_RF07wX2z06wz9yJ1h-CY9si70XzhsDA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 04/11] bpf: Add map side support for bpf timers.
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

On Thu, Jul 8, 2021 at 11:04 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Jul 08, 2021 at 08:52:23PM -0700, Alexei Starovoitov wrote:
> > On Thu, Jul 08, 2021 at 06:51:19PM -0700, Martin KaFai Lau wrote:
> > > > +
> > > >  /* Called when map->refcnt goes to zero, either from workqueue or from syscall */
> > > >  static void array_map_free(struct bpf_map *map)
> > > >  {
> > > > @@ -382,6 +402,7 @@ static void array_map_free(struct bpf_map *map)
> > > >   if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
> > > >           bpf_array_free_percpu(array);
> > > >
> > > > + array_map_free_timers(map);
> > > array_map_free() is called when map->refcnt reached 0.
> > > By then, map->usercnt should have reached 0 before
> > > and array_map_free_timers() should have already been called,
> > > so no need to call it here again?  The same goes for hashtab.
> >
> > Not sure it's that simple.
> > Currently map->usercnt > 0 check is done for bpf_timer_set_callback only,
> > because prog refcnting is what matters to usercnt and map_release_uref scheme.
> > bpf_map_init doesn't have this check because there is no circular dependency
> > prog->map->timer->prog to worry about.
> > So after usercnt reached zero the prog can still do bpf_timer_init.
> Ah. right. missed the bpf_timer_init().
>
> > I guess we can add usercnt > 0 to bpf_timer_init as well.
> > Need to think whether it's enough and the race between atomic64_read(usercnt)
> > and atomic64_dec_and_test(usercnt) is addressed the same way as the race
> > in set_callback and cancel_and_free. So far looks like it. Hmm.
> hmm... right, checking usercnt > 0 seems ok.
> When usercnt is 0, it may be better to also error out instead of allocating
> a timer that cannot be used.
>
> I was mostly thinking avoiding changes in map_free could make future map
> support a little easier.

ok. let me try with usercnt>0 in bpf_timer_init.

> >
> > >
> > > > +static void htab_free_malloced_timers(struct bpf_htab *htab)
> > > > +{
> > > > + int i;
> > > > +
> > > > + rcu_read_lock();
> > > > + for (i = 0; i < htab->n_buckets; i++) {
> > > > +         struct hlist_nulls_head *head = select_bucket(htab, i);
> > > > +         struct hlist_nulls_node *n;
> > > > +         struct htab_elem *l;
> > > > +
> > > > +         hlist_nulls_for_each_entry(l, n, head, hash_node)
> > > May be put rcu_read_lock/unlock() in the loop and do a
> > > cond_resched() in case the hashtab is large.
> Just recalled cond_resched_rcu() may be cleaner, like:
>
> static void htab_free_malloced_timers(struct bpf_htab *htab)
> {
>         int i;
>
>         rcu_read_lock();
>         for (i = 0; i < htab->n_buckets; i++) {
>                 /* ... */
>                 hlist_nulls_for_each_entry_rcu(l, n, head, hash_node)
>                         check_and_free_timer(htab, l);
>                 cond_resched_rcu();

ahh. I didn't know about this flavor. Will give it a shot.
Thanks!

>         }
>         rcu_read_unlock();
> }
>
