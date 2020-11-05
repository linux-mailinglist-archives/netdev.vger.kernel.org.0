Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1F12A87AD
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731994AbgKEUCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgKEUCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:02:12 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8BEC0613D2;
        Thu,  5 Nov 2020 12:02:11 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id s8so241224yba.13;
        Thu, 05 Nov 2020 12:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=udVwxBNsvKUw3DCoDlT/tDwBRfFzbjspcHdw9VbomcA=;
        b=sszfEsdVDR1JBVKcM+EE2/YwkBb8gOLdDmXQ6t6TBWWd6pYGZfe6KQh7Fq3ZuS8Tvu
         cqqeMReq0aUoo59A9WFgbON3SL+ZXJac4D4+GZpF/rRAj/cdwbW314hQr8BlkrGevuxm
         p+xaBCsF/n5Kqln97gT2mxjq29cc88mTdgf/SAooM9gJLZsc15v8ujjg4njTEIdDg9/Z
         /eeWnKaiszuxkEv8EThSPfv/ASg1uCqyZtIPtxshS+8Q+Sj0fItwO07y6Ih6vFMc98hF
         KTQYFrvllxvaT9csA6iDjDdL2/dmSUgQgkRw2Uacqx5XUViYqP2UJ0SKb2nE+8TeSZ/8
         QW0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=udVwxBNsvKUw3DCoDlT/tDwBRfFzbjspcHdw9VbomcA=;
        b=JWfQvr0UwCe4mDzYYdqyVmPGjCGNcPCMsveLoZoy0VvG+9PQvzJnsKB75mrJqv07BL
         X59mo6OZVFKE/1hrYziEjRDZ2GNYuGLV841K8pDSB4UCedIGS86UwRMmk1oc+GCUf2a5
         THSAel+Ta8oyp6f9/sXK4UJOzoWgfwIxn0kRAzv7uXhycIVT7F0/fAJ7jqdIu8BFAjtR
         ucdvQF0hMSB0ZWO2X3i2CzEdCmxvoZ/WahYFf7nbYA6uOzxSYEmiBpxM+eAFKlxHIUot
         XgfqGausIzMyjnCMcBs5DP2m+vW0gDdyvE9xld2C2ZY/RSVy7TeEsSl3g+ehiSIMKJdS
         WvWw==
X-Gm-Message-State: AOAM5330uqIHnSRWQuMfGEkJHeFndSLfdHRGtbQPzWQUcoBzvPMUWz/K
        Qxqo1XPTX15rhIwCeF0aYxOfHXa7QYImEuXTSn8yYloaKhvn3A==
X-Google-Smtp-Source: ABdhPJzRfCJFw4QvXNHBGnPZ62bA9KTRZwf5QIKct3cWnV0zwZbQ7qkXFfXLU72jBMKjpX8n9SpnMSQrCqRC6qF2/os=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr6010804ybe.403.1604606531156;
 Thu, 05 Nov 2020 12:02:11 -0800 (PST)
MIME-Version: 1.0
References: <20201105043402.2530976-1-andrii@kernel.org> <20201105105254.27c84b78@carbon>
 <CAEf4BzYOcQt1dv2f5UmVqCGWJVqM95DoUAumH+sRuXW3rzejMg@mail.gmail.com> <105c48d56a550af6e0008b4b5867eb51764d41c9.camel@nvidia.com>
In-Reply-To: <105c48d56a550af6e0008b4b5867eb51764d41c9.camel@nvidia.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Nov 2020 12:02:00 -0800
Message-ID: <CAEf4Bza0HE-gJRt8kJWEu+i96aRDuroNVfPD6Od6+juoyv4CiQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/11] libbpf: split BTF support
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "brouer@redhat.com" <brouer@redhat.com>,
        "aspsk2@gmail.com" <aspsk2@gmail.com>, "ast@fb.com" <ast@fb.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 11:38 AM Saeed Mahameed <saeedm@nvidia.com> wrote:
>
> On Thu, 2020-11-05 at 11:16 -0800, Andrii Nakryiko wrote:
> > > > This split approach is necessary if we are to have a reasonably-
> > > > sized kernel
> > > > module BTFs. By deduping each kernel module's BTF individually,
> > > > resulting
> > > > module BTFs contain copies of a lot of kernel types that are
> > > > already present
> > > > in vmlinux BTF. Even those single copies result in a big BTF size
> > > > bloat. On my
> > > > kernel configuration with 700 modules built, non-split BTF
> > > > approach results in
> > > > 115MBs of BTFs across all modules. With split BTF deduplication
> > > > approach,
> > > > total size is down to 5.2MBs total, which is on part with vmlinux
> > > > BTF (at
> > > > around 4MBs). This seems reasonable and practical. As to why we'd
> > > > need kernel
> > > > module BTFs, that should be pretty obvious to anyone using BPF at
> > > > this point,
> > > > as it allows all the BTF-powered features to be used with kernel
> > > > modules:
> > > > tp_btf, fentry/fexit/fmod_ret, lsm, bpf_iter, etc.
> > > I love to see this work going forward.
> >
> >
> > Thanks.
> >
> >
> >
> > > My/Our (+Saeed +Ahern) use-case is for NIC-driver kernel modules.
> > > I
> > > want drivers to define a BTF struct that describe a meta-data area
> > > that
> > > can be consumed/used by XDP, also available during xdp_frame to SKB
> > > transition, which happens in net-core. So, I hope BTF-IDs are also
> > > "available" from core kernel code?
> >
> >
> > I'll probably need a more specific example to understand what exactly
> >
> > you are asking and how you see everything working together, sorry.
> >
> >
>
> BTF-IDs can be made available for kernel/drivers, I've wrote a small
> patch for this a while ago.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/commit/?h=topic/xdp_metadata3&id=6c1cb83629226889d6fadd3ba694e827fca3e247
>
> So the basic use case is that :
> 1- driver kernel/registers a BTF format (one or more).

This is now not needed, it happens automatically for module BTF.

> 2- Userland queries driver's registered BTF to be able understand the
> kernel/driver buffers format.

Here the module might need to know its BTF's ID, in addition to BTF
type ID. Or maybe it doesn't. User-space tools can just access BTF
from /sys/kernel/btf/module_name and use provided BTF type ID to dump
whatever is necessary.

>
> driver example of using this infrastructure:
> https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/commit/?h=topic/xdp_metadata3&id=9c24657d6cb3a7852c2e948dc9782f3f39b60104

This, thankfully, won't be needed, you'll just have a normal C struct
and it will be just present in module's BTF.

>
> User Queries driver's XDP metadata BTF format:
> https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/commit/?h=topic/xdp_metadata3&id=6a117e2d9196f58de7cf067741e84ec242af27f6

For this we need support for BTF_ID macro for modules. As I said, it's
pretty easy to add, but feel free to contribute this once the basic
infra lands.

>
> Dump it as C header style
> https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/commit/?h=topic/xdp_metadata3&id=
> 8bd99626879bff28379707ac3a2c3bb94fd5b410

This is available as libbpf-provided API now (see btf_dump APIs). And
bpftool has support to dump all BTF types as C definitions as well.
You might want to do something a bit more targeted, but that's
details.

>
> And then use it in your XDP program to parse packets meta data passed
> from this specific driver. ( i mean no real parsing is required, you
> just point to the meta data buffer with the metadata btf formatted C
> strucuter).
>
>
> >
> > If you are asking about support for using BTF_ID_LIST() macro in a
> >
> > kernel module, then right now we don't call resolve_btfids on
> > modules,
> >
> > so it's not supported there yet. It's trivial to add, but we'll
> >
> > probably need to teach resolve_btfids to understand split BTF. We can
> >
> > do that separately after the basic "infra" lands, though.
>
>
