Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2963B6C44
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 03:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhF2BwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 21:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhF2BwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 21:52:15 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143C2C061574;
        Mon, 28 Jun 2021 18:49:48 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o3so4913314plg.4;
        Mon, 28 Jun 2021 18:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KnzfoR8PfylEtMMt30YhhaxPxHQRos4iH9CSd1tmCZo=;
        b=ilJrmOGHgeeUL1ALjdECLiIqHfMAzEDtcLEBA0UN3fqqh5h8ZJJbiK/E8KbKqq+LNp
         6pcZpaH1ksGJ/cdCZJ9327VwyEg6VLaKtcIMw7k+J22kbEf/+b5S8kkozIGD429VXY48
         zw3JXC3aFlb6aBG3N1eHD/Py0VmoxHodNSdlr6OusRz0aZ3In83hDFKqaie66xjtceqe
         f0SD47nLLHRdIvHvlfuE14P/O2R2shVrEcFAGX2wtatb4BaO9jrhyPRUJaLvVWjQyaFO
         DO07+huZuZ32tbYi/L2ewKE/W/bomJSJ/DIHaM251yW+9PWCdZ8FEVtmDS0yFxftz6Ui
         ffpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KnzfoR8PfylEtMMt30YhhaxPxHQRos4iH9CSd1tmCZo=;
        b=RYuTsOFpfClt49wAcUHumnFvJZ2kI8F0IBI5OAtcIrerw4FT62Yin9NMpSH+OgP1Tv
         cBV6QFX71ZRE2VldCnlpvEvUOqhltpNmIVRdsBPPjQhIGAVJP6vFm0iiCTW4r/IclCvG
         PcD/gzUws1H9bpH02ePdy9iR862SLDOT+2y3kzgQP5kV3f1mDqZHS8/6xp44QcOzXIKG
         HkVK1w3hYM/y9AwTP/KZJnrC8bQRs5KDJCNh4j7hb1APJIn5DMI4bgmog3wH9GdlJGG6
         9jMsP1IblesQ/NjW2+kGvQYv+e1q83UtDblwJGwJ+mFuue47z7HOEby/wR5LOyamdANL
         8GRg==
X-Gm-Message-State: AOAM5328PGb8jqRs8gWdp+bcIY1MnJqixhryNjww0NkePflFrYI5goNB
        T6N1kKdKc4b3T+Jz/FERpgA=
X-Google-Smtp-Source: ABdhPJz2kdMvin8HurBj1rZfqix3BAM4qIUou9Ke20tRYFXSStoVirxnITF6PXgH50FUVT+fyNL6fA==
X-Received: by 2002:a17:903:208a:b029:125:8b69:53a1 with SMTP id d10-20020a170903208ab02901258b6953a1mr25515055plc.17.1624931387625;
        Mon, 28 Jun 2021 18:49:47 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:45ad])
        by smtp.gmail.com with ESMTPSA id k20sm856319pji.3.2021.06.28.18.49.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jun 2021 18:49:47 -0700 (PDT)
Date:   Mon, 28 Jun 2021 18:49:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 2/8] bpf: Add map side support for bpf timers.
Message-ID: <20210629014944.ctdhv7jjooxpv636@ast-mbp.dhcp.thefacebook.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-3-alexei.starovoitov@gmail.com>
 <2c523078-cb24-e1ca-2439-27be37cfe90b@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c523078-cb24-e1ca-2439-27be37cfe90b@fb.com>
User-Agent: NeoMutt/20180223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 12:46:03PM -0700, Yonghong Song wrote:
> 
> 
> On 6/23/21 7:25 PM, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> > 
> > Restrict bpf timers to array, hash (both preallocated and kmalloced), and
> > lru map types. The per-cpu maps with timers don't make sense, since 'struct
> > bpf_timer' is a part of map value. bpf timers in per-cpu maps would mean that
> > the number of timers depends on number of possible cpus and timers would not be
> > accessible from all cpus. lpm map support can be added in the future.
> > The timers in inner maps are supported.
> > 
> > The bpf_map_update/delete_elem() helpers and sys_bpf commands cancel and free
> > bpf_timer in a given map element.
> > 
> > Similar to 'struct bpf_spin_lock' BTF is required and it is used to validate
> > that map element indeed contains 'struct bpf_timer'.
> > 
> > Make check_and_init_map_value() init both bpf_spin_lock and bpf_timer when
> > map element data is reused in preallocated htab and lru maps.
> > 
> > Teach copy_map_value() to support both bpf_spin_lock and bpf_timer in a single
> > map element. There could be one of each, but not more than one. Due to 'one
> > bpf_timer in one element' restriction do not support timers in global data,
> > since global data is a map of single element, but from bpf program side it's
> > seen as many global variables and restriction of single global timer would be
> > odd. The sys_bpf map_freeze and sys_mmap syscalls are not allowed on maps with
> > timers, since user space could have corrupted mmap element and crashed the
> > kernel. The maps with timers cannot be readonly. Due to these restrictions
> > search for bpf_timer in datasec BTF in case it was placed in the global data to
> > report clear error.
> > 
> > The previous patch allowed 'struct bpf_timer' as a first field in a map
> > element only. Relax this restriction.
> > 
> > Refactor lru map to s/bpf_lru_push_free/htab_lru_push_free/ to cancel and free
> > the timer when lru map deletes an element as a part of it eviction algorithm.
> > 
> > Make sure that bpf program cannot access 'struct bpf_timer' via direct load/store.
> > The timer operation are done through helpers only.
> > This is similar to 'struct bpf_spin_lock'.
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> 
> I didn't find major issues. Only one minor comment below. I do a race
> during map_update where updated map elements will have timer removed
> but at the same time the timer might still be used after update. But
> irq spinlock should handle this properly.

Right. It's safe from kernel pov. But non-atomic from bpf prog pov.
If one prog doing map_update_elem() it replaced the other fields
except timer, but the other fields are also not atomic.
So not a new concern for bpf authors.

> Acked-by: Yonghong Song <yhs@fb.com>
> 
> > ---
> >   include/linux/bpf.h        | 44 ++++++++++++-----
> >   include/linux/btf.h        |  1 +
> >   kernel/bpf/arraymap.c      | 22 +++++++++
> >   kernel/bpf/btf.c           | 77 ++++++++++++++++++++++++------
> >   kernel/bpf/hashtab.c       | 96 +++++++++++++++++++++++++++++++++-----
> >   kernel/bpf/local_storage.c |  4 +-
> >   kernel/bpf/map_in_map.c    |  1 +
> >   kernel/bpf/syscall.c       | 21 +++++++--
> >   kernel/bpf/verifier.c      | 30 ++++++++++--
> >   9 files changed, 251 insertions(+), 45 deletions(-)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 72da9d4d070c..90e6c6d1404c 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -198,24 +198,46 @@ static inline bool map_value_has_spin_lock(const struct bpf_map *map)
> >   	return map->spin_lock_off >= 0;
> >   }
> > -static inline void check_and_init_map_lock(struct bpf_map *map, void *dst)
> > +static inline bool map_value_has_timer(const struct bpf_map *map)
> >   {
> > -	if (likely(!map_value_has_spin_lock(map)))
> > -		return;
> > -	*(struct bpf_spin_lock *)(dst + map->spin_lock_off) =
> > -		(struct bpf_spin_lock){};
> > +	return map->timer_off >= 0;
> >   }
> > -/* copy everything but bpf_spin_lock */
> > +static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
> > +{
> > +	if (unlikely(map_value_has_spin_lock(map)))
> > +		*(struct bpf_spin_lock *)(dst + map->spin_lock_off) =
> > +			(struct bpf_spin_lock){};
> > +	if (unlikely(map_value_has_timer(map)))
> > +		*(struct bpf_timer *)(dst + map->timer_off) =
> > +			(struct bpf_timer){};
> > +}
> > +
> [...]
> > diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> > index 6f6681b07364..e85a5839ffe8 100644
> > --- a/kernel/bpf/hashtab.c
> > +++ b/kernel/bpf/hashtab.c
> > @@ -228,6 +228,28 @@ static struct htab_elem *get_htab_elem(struct bpf_htab *htab, int i)
> >   	return (struct htab_elem *) (htab->elems + i * (u64)htab->elem_size);
> >   }
> > +static void htab_free_prealloced_timers(struct bpf_htab *htab)
> > +{
> > +	u32 num_entries = htab->map.max_entries;
> > +	int i;
> > +
> > +	if (likely(!map_value_has_timer(&htab->map)))
> > +		return;
> > +	if (!htab_is_percpu(htab) && !htab_is_lru(htab))
> 
> Is !htab_is_percpu(htab) needed? I think we already checked
> if map_value has timer it can only be hash/lruhash/array?

Technically not, but it's good to keep this part the same as
in prealloc_init(). I'll refactor these two checks into a small
helper function and will use in both places.
