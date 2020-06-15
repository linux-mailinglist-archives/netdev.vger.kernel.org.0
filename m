Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0C81F92A2
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 11:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgFOJEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 05:04:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47334 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729118AbgFOJEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 05:04:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592211888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eqCxKohGvLbDOAcYvRzfZ70rZCgIvTAgDpyXvxo9QZw=;
        b=X9smWnv25C8p5JraZ9INKucP8FIcuvRE+CRPPpc2ttP5Jw7zwff7qh0RPlfH54+8vvEXYK
        c6NhifnXDbX11IipZ/oto5z054DzRMrQ0R+rquNAxnkFUwEjAzzmFviK5FKjRMZNP/V798
        l1edXyjGpr4xNignNRKd8Td8X0wTHrY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-jZ6dKkFoNCa9cpw7986UBQ-1; Mon, 15 Jun 2020 05:04:39 -0400
X-MC-Unique: jZ6dKkFoNCa9cpw7986UBQ-1
Received: by mail-ej1-f70.google.com with SMTP id ch1so7472721ejb.18
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 02:04:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eqCxKohGvLbDOAcYvRzfZ70rZCgIvTAgDpyXvxo9QZw=;
        b=FQpYKGhDMFmVCIaf6BuMkmFKfiXSZnev9Fs/voBDpXdWv3osW4CPblVZPg0GgYE6x+
         NM0BrWEMTEx/mq4BhHKSOq5CjwkW1tS6Z3Clu9a3NL+eBueDfeHuQeG3kC+u3EgMmIRO
         BRRcV1xtiH+ChTiMxudAC+JFg5zMxwZWtKuQz7EM+ylImms2Mmw1iBQi53EroL4DCIs7
         0KVd+6ku/bqGuXaTkR7zCHbcXbYd3I4VTquVyzzB7fnHN5PfNnYVZjFRPyEMLQzXg6+q
         F99SKJ2YaPJJ/X8Ypj48nbNIULnHtbO+taIfB7fidvbnB1xht82dH/WboKicwcc6sbOL
         xHJw==
X-Gm-Message-State: AOAM530EKrjEw2XL6+dYzmagP3psju5lQ6HjwpVyaW2nTKyAfgSzf3qk
        8B7AVKvk/cN53A0jYPnHGz31+7flFFQEAcxyHt+ZAD07wps9vWo20X+WTSSNI7+pQ61691zTRiT
        /O1EQxAIrP4Pwz7qV
X-Received: by 2002:a50:f094:: with SMTP id v20mr22603484edl.77.1592211878395;
        Mon, 15 Jun 2020 02:04:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQV9d8O1teV5U813ms9N4ToB2nzLDvlhioQHU+f4HBdn9vWHWBNEJsAmukYldRqTxWeB+HPA==
X-Received: by 2002:a50:f094:: with SMTP id v20mr22603450edl.77.1592211878095;
        Mon, 15 Jun 2020 02:04:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z10sm8653487ejb.9.2020.06.15.02.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 02:04:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9883D1814F7; Mon, 15 Jun 2020 11:04:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: Re: [RFC PATCH bpf-next 8/8] tools/bpftool: show PIDs with FDs open against BPF map/prog/link/btf
In-Reply-To: <20200613221419.GB7488@kernel.org>
References: <20200612223150.1177182-1-andriin@fb.com> <20200612223150.1177182-9-andriin@fb.com> <20200613034507.wjhd4z6dsda3pz7c@ast-mbp> <CAEf4BzaHVRxkiDbTGashiuakXFBRYvDsQmJ0O08xFijKXiAwSg@mail.gmail.com> <20200613221419.GB7488@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 15 Jun 2020 11:04:34 +0200
Message-ID: <87pna01yzh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnaldo Carvalho de Melo <acme@kernel.org> writes:

> Em Fri, Jun 12, 2020 at 10:57:59PM -0700, Andrii Nakryiko escreveu:
>> On Fri, Jun 12, 2020 at 8:45 PM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>> >
>> > On Fri, Jun 12, 2020 at 03:31:50PM -0700, Andrii Nakryiko wrote:
>> > > Add bpf_iter-based way to find all the processes that hold open FDs against
>> > > BPF object (map, prog, link, btf). Add new flag (-o, for "ownership", given
>> > > -p is already taken) to trigger collection and output of these PIDs.
>> > >
>> > > Sample output for each of 4 BPF objects:
>> > >
>> > > $ sudo ./bpftool -o prog show
>> > > 1992: cgroup_skb  name egress_alt  tag 9ad187367cf2b9e8  gpl
>> > >         loaded_at 2020-06-12T14:18:10-0700  uid 0
>> > >         xlated 48B  jited 59B  memlock 4096B  map_ids 2074
>> > >         btf_id 460
>> > >         pids: 913709,913732,913733,913734
>> > > 2062: cgroup_device  tag 8c42dee26e8cd4c2  gpl
>> > >         loaded_at 2020-06-12T14:37:52-0700  uid 0
>> > >         xlated 648B  jited 409B  memlock 4096B
>> > >         pids: 1
>> > >
>> > > $ sudo ./bpftool -o map show
>> > > 2074: array  name test_cgr.bss  flags 0x400
>> > >         key 4B  value 8B  max_entries 1  memlock 8192B
>> > >         btf_id 460
>> > >         pids: 913709,913732,913733,913734
>> > >
>> > > $ sudo ./bpftool -o link show
>> > > 82: cgroup  prog 1992
>> > >         cgroup_id 0  attach_type egress
>> > >         pids: 913709,913732,913733,913734
>> > > 86: cgroup  prog 1992
>> > >         cgroup_id 0  attach_type egress
>> > >         pids: 913709,913732,913733,913734
>> >
>> > This is awesome.
>
> Indeed.
>  
>> Thanks.
>> 
>> >
>> > Why extra flag though? I think it's so useful that everyone would want to see
>
> Agreed.
>  
>> No good reason apart from "being safe by default". If turned on by
>> default, bpftool would need to probe for bpf_iter support first. I can
>> add probing and do this by default.
>
> I think this is the way to go.

+1

And also +1 on the awesomeness of this feature! :)

-Toke

