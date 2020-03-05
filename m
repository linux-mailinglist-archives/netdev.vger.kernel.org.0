Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC22E17A3A3
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 12:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgCELFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 06:05:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56798 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725880AbgCELFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 06:05:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583406330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5NbMjAjfqmwFcQtN3QgY76hhfj66R2EMybjcy19Lm8I=;
        b=Wa1RB4y+YSNzSQuj1deks4wnhqkGNOZGa61eQLQGFfsxAQnMeaUJgAYosHw1E9wb0r0mDN
        /NXe8cag/yEa5AFuadHOlERb11L5mbw5+OIRyG9XU6A7PBVjfO3paRfMJKnsorkxoQE7t0
        ffHRMsTdWmy5/9cgPnG1c7Nf0CYgthY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-sdO4zj0AMwugU_eJh_Nqxg-1; Thu, 05 Mar 2020 06:05:26 -0500
X-MC-Unique: sdO4zj0AMwugU_eJh_Nqxg-1
Received: by mail-wm1-f69.google.com with SMTP id w3so1433429wmg.4
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 03:05:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5NbMjAjfqmwFcQtN3QgY76hhfj66R2EMybjcy19Lm8I=;
        b=tfXSF0DjuTyKSiAiTJkuDwd/DAzPDI8fyAUcVuZYQYinmx2+X5SiSkuKVxmbWnJkDb
         HkuXoBIC8KobzUkmF1dTU+5nO0RiwihoCDvu90CZMf43f6BrhMm35GDmfwrSzw8FlDnL
         g8h45aWPezGjcwZYaLWFEUW5cKlgwmFEEgCck3iQrSoIXxwzUdFST8iiBKDlyxoO1/b9
         G+s7xjmYDvoOLhQ9Q8ZUso96R0S6sirbei7kBFBgM8ZOu/2rQvzGX9J9xOelHb4e8Wfc
         Z2LyYB3W6vFXacRSbWRGIBvN2SFdpScIsD5aoE/yhE+r+ho8Rf57Y2akjctmJtfmxcqe
         V4vA==
X-Gm-Message-State: ANhLgQ0dX5Ju//2lS0XZQzJcDP9Qgo1f9HzhvzhAJ+azRv50YKsF8RmT
        dbJ9PqLn4wAQFSvigkwGdehUcQi5QKcxZh4+fpjDyoXU7WqPmpAVP9J7IifIZN7HvflPe/PJGFe
        AKfR4NcXZJYioLEj5
X-Received: by 2002:a5d:6948:: with SMTP id r8mr7356280wrw.73.1583406325443;
        Thu, 05 Mar 2020 03:05:25 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuAzQekKvGVJsRQMKX0DZku9jQA7VBEISgAFfEH1M1k2Pe1lXtqbPQwNZt5D3FdV0eMl+R8jQ==
X-Received: by 2002:a5d:6948:: with SMTP id r8mr7356251wrw.73.1583406325186;
        Thu, 05 Mar 2020 03:05:25 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id y7sm9040828wmd.1.2020.03.05.03.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 03:05:24 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BDE5D18034F; Thu,  5 Mar 2020 12:05:23 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel abstraction
In-Reply-To: <20200305001620.204c292e@cakuba.hsd1.ca.comcast.net>
References: <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net> <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com> <87pndt4268.fsf@toke.dk> <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net> <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com> <87k1413whq.fsf@toke.dk> <20200304043643.nqd2kzvabkrzlolh@ast-mbp> <20200304114000.56888dac@kicinski-fedora-PC1C0HJN> <20200304204506.wli3enu5w25b35h7@ast-mbp> <20200304132439.6abadbe3@kicinski-fedora-PC1C0HJN> <20200305010706.dk7zedpyj5pb5jcv@ast-mbp> <20200305001620.204c292e@cakuba.hsd1.ca.comcast.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 05 Mar 2020 12:05:23 +0100
Message-ID: <87tv332hak.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 4 Mar 2020 17:07:08 -0800, Alexei Starovoitov wrote:
>> > Maybe also the thief should not have CAP_ADMIN in the first place?
>> > And ask a daemon to perform its actions..  
>> 
>> a daemon idea keeps coming back in circles.
>> With FD-based kprobe/uprobe/tracepoint/fexit/fentry that problem is gone,
>> but xdp, tc, cgroup still don't have the owner concept.
>> Some people argued that these three need three separate daemons.
>> Especially since cgroups are mainly managed by systemd plus container
>> manager it's quite different from networking (xdp, tc) where something
>> like 'networkd' might makes sense.
>> But if you take this line of thought all the ways systemd should be that
>> single daemon to coordinate attaching to xdp, tc, cgroup because
>> in many cases cgroup and tc progs have to coordinate the work.
>
> The feature creep could happen, but Toke's proposal has a fairly simple
> feature set, which should be easy to cover by a stand alone daemon.
>
> Toke, I saw that in the library discussion there was no mention of 
> a daemon, what makes a daemon solution unsuitable?

Quoting from the last discussion[0]:

> - Introducing a new, separate code base that we'll have to write, support
>   and manage updates to.
> 
> - Add a new dependency to using XDP (now you not only need the kernel
>   and libraries, you'll also need the daemon).
> 
> - Have to duplicate or wrap functionality currently found in the kernel;
>   at least:
>   
>     - Keeping track of which XDP programs are loaded and attached to
>       each interface (as well as the "new state" of their attachment
>       order).
> 
>     - Some kind of interface with the verifier; if an app does
>       xdpd_rpc_load(prog), how is the verifier result going to get back
>       to the caller?
> 
> - Have to deal with state synchronisation issues (how does xdpd handle
>   kernel state changing from underneath it?).
> 
> While these are issues that are (probably) all solvable, I think the
> cost of solving them is far higher than putting the support into the
> kernel. Which is why I think kernel support is the best solution :)

The context was slightly different, since this was before we had
freplace support in the kernel. But apart from the point about the
verifier, I think the arguments still stand. In fact, now that we have
that, we don't even need userspace linking, so basically a daemon's only
task would be to arbitrate access to the XDP hook? In my book,
arbitrating access to resources is what the kernel is all about...

-Toke

[0] https://lore.kernel.org/bpf/m/874l07fu61.fsf@toke.dk

