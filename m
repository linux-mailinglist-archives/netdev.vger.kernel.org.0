Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B3F3C1DEF
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 05:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhGIDzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 23:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhGIDzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 23:55:11 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2B5C061574;
        Thu,  8 Jul 2021 20:52:27 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j3so2395239plx.7;
        Thu, 08 Jul 2021 20:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=933ngImnubW0i5YE0IZwdp68C/wUlndDFrZQz1HK78Q=;
        b=ubuBjSH/lrhQ1ttUw8TuKIDOXnALBAAAM8VtON4NB6Hi8u+hBEKpBWjv7e60gSXfic
         CeB88gZkpx4uVKoq4JSOHEX3qQat4YQkAF9YDveGK4v4PlVftmrrHKc+EcOfoIc1e/aO
         f4VlFFXT2SkLrzLreyjpo1WbEwo+p2VLFlYCEJfyXIZaRNnWw2AU+nBwSdJHQ7OZ3gZi
         oH+YRwzow76OeOGFltUxLkdi8JqckqWPNH+aepfZ4S7qP8c5t7jsr+HZsbMm3Tfl0eZg
         u+QL5cxGiZPUxkbQcpiiTQE0ufZP1M3EwMWG3BTNGLa/jv1ym/ePpF2iigtd+vzRKKzp
         CZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=933ngImnubW0i5YE0IZwdp68C/wUlndDFrZQz1HK78Q=;
        b=cDPwNh9aeYKE3TH4xKv8sIdZYbK/fNKDWH3mV3uXXHKY9qtgH7tO+Y7N2ZNZHILKK+
         yTfnkgYxwgEXOgFcV97U5olritHlzu4/qpO3A9Jl1Gd9lsggFNjGQ71OTZJ23wpctoow
         Kh4qXEp5AzFKoqDEiwR45ZnuUmgsh48Pvocwc2LnC/srVAbwEfL1erlsxjTRjr3MO7hN
         PtAcbnpYiZgaLn0U5p1fPlKnhXde6Mj/MaUK0OOSHvXNbILpBZLNdVCgvvygU2xeFKBn
         eqB2lWzKUTZ0orR0zr9SeoECKEjNiMhh9aw8thuOYtSA/lgmik0q5cD96X5Aha6qKELZ
         VlKw==
X-Gm-Message-State: AOAM532inBMUiMD63IUDuAW8jySPZA/gIar6sjLLPEvtWYhd7LOPqEfC
        9ZB/qQTSfrhM470qyMQ7WEo=
X-Google-Smtp-Source: ABdhPJyaZbu0fDad7HXlZQNS49bi0IjWFywLyqUQ//ZAqlIljGytX4NmYtByDuMwvBuPuL+x1ovpKw==
X-Received: by 2002:a17:902:9a02:b029:118:307e:a9dd with SMTP id v2-20020a1709029a02b0290118307ea9ddmr28642826plp.47.1625802747374;
        Thu, 08 Jul 2021 20:52:27 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:7cf7])
        by smtp.gmail.com with ESMTPSA id m9sm4034413pfk.20.2021.07.08.20.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 20:52:26 -0700 (PDT)
Date:   Thu, 8 Jul 2021 20:52:23 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v5 bpf-next 04/11] bpf: Add map side support for bpf
 timers.
Message-ID: <20210709035223.s2ni6phkdajhdg2i@ast-mbp.dhcp.thefacebook.com>
References: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
 <20210708011833.67028-5-alexei.starovoitov@gmail.com>
 <20210709015119.l5kxp5kao24bjft7@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709015119.l5kxp5kao24bjft7@kafai-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 06:51:19PM -0700, Martin KaFai Lau wrote:
> > +
> >  /* Called when map->refcnt goes to zero, either from workqueue or from syscall */
> >  static void array_map_free(struct bpf_map *map)
> >  {
> > @@ -382,6 +402,7 @@ static void array_map_free(struct bpf_map *map)
> >  	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
> >  		bpf_array_free_percpu(array);
> >  
> > +	array_map_free_timers(map);
> array_map_free() is called when map->refcnt reached 0.
> By then, map->usercnt should have reached 0 before
> and array_map_free_timers() should have already been called,
> so no need to call it here again?  The same goes for hashtab.

Not sure it's that simple.
Currently map->usercnt > 0 check is done for bpf_timer_set_callback only,
because prog refcnting is what matters to usercnt and map_release_uref scheme.
bpf_map_init doesn't have this check because there is no circular dependency
prog->map->timer->prog to worry about.
So after usercnt reached zero the prog can still do bpf_timer_init.
I guess we can add usercnt > 0 to bpf_timer_init as well.
Need to think whether it's enough and the race between atomic64_read(usercnt)
and atomic64_dec_and_test(usercnt) is addressed the same way as the race
in set_callback and cancel_and_free. So far looks like it. Hmm.

> > +static int btf_find_field(const struct btf *btf, const struct btf_type *t,
> > +			  const char *name, int sz, int align)
> > +{
> > +
> > +	if (__btf_type_is_struct(t))
> > +		return btf_find_struct_field(btf, t, name, sz, align);
> > +	else if (btf_type_is_datasec(t))
> > +		return btf_find_datasec_var(btf, t, name, sz, align);
> iiuc, a global struct bpf_timer is not supported.  I am not sure
> why it needs to find the timer in datasec here. or it meant to error out
> and potentially give a verifier log?  I don't see where is the verifier
> reporting error though.

yes. Initially I coded it up to support timers in the global data, but
later Andrii convinced me that single global timer could be surprising to
users unless I hack it up in libbpf to create a bunch of global data maps
one map for each timer and teach libbpf to avoid doing mmap on them.
That's too hacky and can be done later.
So the datasec parsing code stayed only to have a meaningful error
in the verifier if the user wrote a program with global timer.
Without this code the verifier error:
 24: (85) call bpf_timer_init#169
 map 'my_test.bss' is not a struct type or bpf_timer is mangled
With:
 24: (85) call bpf_timer_init#169
 timer pointer in R1 map_uid=0 doesn't match map pointer in R2 map_uid=0
Imo that's much clearer. Since to use global bpf_timer_init() the
user would have to pass some map value in R2
and it wouldn't match the timer in R1.
So I prefer to keep this btf_find_datasec_var() code.

> 
> > +static void htab_free_malloced_timers(struct bpf_htab *htab)
> > +{
> > +	int i;
> > +
> > +	rcu_read_lock();
> > +	for (i = 0; i < htab->n_buckets; i++) {
> > +		struct hlist_nulls_head *head = select_bucket(htab, i);
> > +		struct hlist_nulls_node *n;
> > +		struct htab_elem *l;
> > +
> > +		hlist_nulls_for_each_entry(l, n, head, hash_node)
> need the _rcu() variant here.

argh. right.

> May be put rcu_read_lock/unlock() in the loop and do a
> cond_resched() in case the hashtab is large.

Feels a bit like premature optimization. delete_all_elements()
loop right above is doing similar work without cond_resched.
I don't mind cond_resched. I just don't see how to cleanly add it
without breaking rcu_read_lock and overcomplicating the code.
