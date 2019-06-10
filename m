Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31ACA3BE2C
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389736AbfFJVPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:15:35 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44733 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfFJVPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:15:35 -0400
Received: by mail-qk1-f196.google.com with SMTP id w187so6306169qkb.11
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=l2JMKZKqJmt1NYrjuUGS6Z1wyAQvv+M3r7FpXksFsu0=;
        b=P01o7/CyE0Rw9M8rddLa6fZDYq4EqYVEq9Y+U5d1MuCne5xChO4Rts6eYRS5oBtiTj
         UOS8ungEBQXgID1THIU1g09p70V7rFqZYSNJxqqleBcgFzf+0s+wmAeSoQvj+q/wbxIV
         N9NMVWboMuDu4KDRffQuiSdfnMk6dUByiJYDc5F5TCxt9fid9XWazlnWH+dHJqoD5yn4
         t5mo1vNIbQs5YrrDRfYmi3Dv2euQsp0QxyU3wVH0jDMDIfyX8rzB5sKOLq10cFozAB8m
         hxEGA6k3ijJ/6qWfCGDkLJ06IOXFGqgGPPLNMAqEK+CTXYherPI/Kb/nF8b327861vCD
         8IzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=l2JMKZKqJmt1NYrjuUGS6Z1wyAQvv+M3r7FpXksFsu0=;
        b=AMaviMKJP/weC5y/unlVGYNbOJs4JaX09Ny57LcXEca8CEcPUGSXeJtZOWFOtJDyEf
         /Iq9/+5YY2wXBNisCWDczOdO8k2YBIYNAHciTMXbt0mWKXv/JJO75kS20vko2b5zBCDv
         87Fd8zRvCHPYsvwRyVvA/LbscYMiM/h4DM9HzP/Xg5hCJ0EdkRfNWGCnCfjw32geA/L1
         wsOgqZM3pEGip9CkGS7Y3DFYy8w1Oy2IRKHXASBaGxmoaVJcGV/LmwcDq5l+uQWp22ts
         GNx7kBokKO4wSygbTaPHEBJ3MORYpgBwZiumNoZITkJS49fMODO4Y1DmxpNgMigUDDhU
         FODA==
X-Gm-Message-State: APjAAAV/VafKA6pmgIuxeUcqm/QXmb+vNlsV4Xd9LCykifMcbruVV8Lp
        Q+NK3ldR1hrBO70VecejN6r/kw==
X-Google-Smtp-Source: APXvYqzIcyo2eKKD5mhWVSqH4qkao2VO+MhIwV3sqIDvD7B8da1+hvqTTiGBb34ZaECWyUGizxSilg==
X-Received: by 2002:a37:670e:: with SMTP id b14mr55596090qkc.216.1560201334079;
        Mon, 10 Jun 2019 14:15:34 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x40sm1281024qta.20.2019.06.10.14.15.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 14:15:33 -0700 (PDT)
Date:   Mon, 10 Jun 2019 14:15:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: explicit maps. Was: [RFC PATCH bpf-next 6/8] libbpf: allow
 specifying map definitions using BTF
Message-ID: <20190610141528.38c71524@cakuba.netronome.com>
In-Reply-To: <b9798871-3b0e-66ce-903d-c9a587651abc@fb.com>
References: <20190531202132.379386-1-andriin@fb.com>
        <20190531202132.379386-7-andriin@fb.com>
        <20190531212835.GA31612@mini-arch>
        <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
        <20190603163222.GA14556@mini-arch>
        <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
        <20190604010254.GB14556@mini-arch>
        <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
        <20190604042902.GA2014@mini-arch>
        <20190604134538.GB2014@mini-arch>
        <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com>
        <3ff873a8-a1a6-133b-fa20-ad8bc1d347ed@iogearbox.net>
        <CAEf4BzYr_3heu2gb8U-rmbgMPu54ojcdjMZu7M_VaqOyCNGR5g@mail.gmail.com>
        <9d0bff7f-3b9f-9d2c-36df-64569061edd6@fb.com>
        <20190606171007.1e1eb808@cakuba.netronome.com>
        <4553f579-c7bb-2d4c-a1ef-3e4fbed64427@fb.com>
        <20190606180253.36f6d2ae@cakuba.netronome.com>
        <b9798871-3b0e-66ce-903d-c9a587651abc@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jun 2019 01:17:13 +0000, Alexei Starovoitov wrote:
> On 6/6/19 6:02 PM, Jakub Kicinski wrote:
> > On Fri, 7 Jun 2019 00:27:52 +0000, Alexei Starovoitov wrote:  
> >> the solution we're discussing should solve BPF_ANNOTATE_KV_PAIR too.
> >> That hack must go.  
> > 
> > I see.
> >   
> >> If I understood your objections to Andrii's format is that
> >> you don't like pointer part of key/value while Andrii explained
> >> why we picked the pointer, right?
> >>
> >> So how about:
> >>
> >> struct {
> >>     int type;
> >>     int max_entries;
> >>     struct {
> >>       __u32 key;
> >>       struct my_value value;
> >>     } types[];
> >> } ...  
> > 
> > My objection is that k/v fields are never initialized, so they're
> > "metafields", mixed with real fields which hold parameters - like
> > type, max_entries etc.  
> 
> I don't share this meta fields vs real fields distinction.
> All of the fields are meta.
> Kernel implementation of the map doesn't need to hold type and
> max_entries as actual configuration fields.
> The map definition in c++ would have looked like:
> bpf::hash_map<int, struct my_value, 1000, NO_PREALLOC> foo;
> bpf::array_map<struct my_value, 2000> bar;
> 
> Sometime key is not necessary. Sometimes flags have to be zero.
> bpf syscall api is a superset of all fiels for all maps.
> All of them are configuration and meta fields at the same time.
> In c++ example there is really no difference between
> 'struct my_value' and '1000' attributes.
> 
> I'm pretty sure bpf will have C++ front-end in the future,
> but until then we have to deal with C and, I think, the map
> definition should be the most natural C syntax.
> In that sense what you're proposing with extern:
> > extern struct my_key my_key;
> > extern int type_int;
> > 
> > struct map_def {
> >      int type;
> >      int max_entries;
> >      void *btf_key_ref;
> >      void *btf_val_ref;
> > } = {
> >      ...
> >      .btf_key_ref = &my_key,
> >      .btf_val_ref = &type_int,
> > };  
> 
> is worse than
> 
> struct map_def {
>        int type;
>        int max_entries;
>        int btf_key;
>        struct my_key btf_value;
> };
> 
> imo explicit key and value would be ideal,
> but they take too much space. Hence pointers
> or zero sized array:
> struct {
>       int type;
>       int max_entries;
>       struct {
>         __u32 key;
>         struct my_value value;
>       } types[];
> };

It is a C syntax problem, I do agree with you that it works well for
templates.  The map_def structure holds parameters, and we can't take
a type as a value in C.  Hence the types[] in your proposal - you could
as well call them ghost_fields[] :)

> I think we should also consider explicit map creation.
> 
> Something like:
> 
> struct my_map {
>    __u32 key;
>    struct my_value value;
> } *my_hash_map, *my_pinned_hash_map;
> 
> struct {
>     __u64 key;
>    struct my_map *value;
> } *my_hash_of_maps;
> 
> struct {
>    struct my_map *value;
> } *my_array_of_maps;
> 
> __init void create_my_maps(void)
> {
>    bpf_create_hash_map(&my_hash_map, 1000/*max_entries*/);
>    bpf_obj_get(&my_pinned_hash_map, "/sys/fs/bpf/my_map");
>    bpf_create_hash_of_maps(&my_hash_of_maps, 1000/*max_entries*/);
>    bpf_create_array_of_maps(&my_array_of_maps, 20);
> }
> 
> SEC("cgroup/skb")
> int bpf_prog(struct __sk_buff *skb)
> {
>    struct my_value *val;
>    __u32 key;
>    __u64 key64;
>    struct my_map *map;
> 
>    val = bpf_map_lookup(my_hash_map, &key);
>    map = bpf_map_lookup(my_hash_of_maps, &key64);
> }
> 
> '__init' section will be compiled by llvm into bpf instructions
> that will be executed in users space by libbpf.
> The __init prog has to succeed otherwise prog load fails.
> 
> May be all map pointers should be in a special section to avoid
> putting them into datasec, but libbpf should be able to figure that
> out without requiring user to specify the .map section.
> The rest of global vars would go into special datasec map.
> 
> No llvm changes necessary and BTF is available for keys and values.
> 
> libbpf can start with simple __init and eventually grow into
> complex init procedure where maps are initialized,
> prog_array is populated, etc.
> 
> Thoughts?

I like it! :)
