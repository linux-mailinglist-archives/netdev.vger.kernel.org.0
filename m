Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AA04CAD6
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 11:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfFTJ2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 05:28:05 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38003 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbfFTJ2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 05:28:05 -0400
Received: by mail-oi1-f193.google.com with SMTP id v186so1648949oie.5
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 02:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PmHWG4qMmWEGCOF+kdqEk3VRt4YU2iablP4KfL7mAEw=;
        b=MjJEWHVuMucicTQDHG/57dvSgYokPHQjo4P7x2IS2BhfDe83rJewRx0pPvgnLRPMhD
         gNDagD9UZu95PX+UVoQexWt0qHIPG765pdJ83AfAhmniVjgc+8lkJ1+mWJm+zMxORR5D
         EULNDf5hx67aBZ0o9Wk+wZOPTP39USccZe8AE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PmHWG4qMmWEGCOF+kdqEk3VRt4YU2iablP4KfL7mAEw=;
        b=hgrQUqVshTCJoMN1/jSQDyR1lLy7aNDPUQSH6umz7mmVhQ/vl1VplX3hAfgMGgMSeZ
         rHeUfqRTVFpb9u9o8Pjvi5LW+vXHjhtU2MfoPzRh8YWUMrQRH+6jVj68DJil9KLVLsiG
         CKjCW9G/Yumb1AsMt7tookwNIYGt/QLQJG+8LKM8PBnyWtB1QN9Ib/Ag0RyiIMjcinBi
         f5AeyJMROeTo+Ocmuuxc3Kf0KeYsZShDrKC+X3AY+dYp9Qy0zfph4KaK6OBZl99HViXG
         CwKbqotgNP3Pw5vwEDmOtd3jKGcS2l1HtnNvGwUnATD7DldrRUM4zyp/x7dT9lb6nxiI
         qNdw==
X-Gm-Message-State: APjAAAVYRugIXXyC/SAuX+U7t5xD+Zuk9W65Ig6m9b0vUBDTqWPjIqRT
        KiH58elhNLpSApv3cbRKQUybOPcD6KjH5jBdOYiPYQ==
X-Google-Smtp-Source: APXvYqwhYi5HxRDKe0OHNu8Mys7NdMy75GnitIl3Wx9yZw71NUc7iY9rlm5FUfPiMOdf0emDnBB3CpCYDgThmfiu4tU=
X-Received: by 2002:aca:55d8:: with SMTP id j207mr5251042oib.78.1561022884464;
 Thu, 20 Jun 2019 02:28:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-1-andriin@fb.com> <20190531202132.379386-7-andriin@fb.com>
 <CACAyw99wD+7mXXeger6WoBTTu3aYHDW8EJV9_tP7MfXOnT0ODg@mail.gmail.com>
 <CAEf4BzamSjSa-7ddzyVsqygbtT6WSwsWpCFGX-4Rav4Aev8UsA@mail.gmail.com>
 <CACAyw9_Yr=pmvCRYsVHoQBrH7qBwmcaXZezmqafwJTxaCmDf6A@mail.gmail.com> <CAEf4Bzbpm0pSvXU8gfSTL2xECTDb+Z9HKKO2Y-Ap=L6VTWL9MQ@mail.gmail.com>
In-Reply-To: <CAEf4Bzbpm0pSvXU8gfSTL2xECTDb+Z9HKKO2Y-Ap=L6VTWL9MQ@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 20 Jun 2019 10:27:52 +0100
Message-ID: <CACAyw98hwj5hpT00P5JiW3V+QPdyddKfN_yQj=okXvg89eTgsA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jun 2019 at 22:00, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > In my mind, BPF loaders should be able to pass through BTF to the kernel
> > as a binary blob as much as possible. That's why I want the format to
> > be "self describing". Compatibility then becomes a question of: what
> > feature are you using on which kernel. The kernel itself can then still be
> > strict-by-default or what have you.
>
> That would work in ideal world, where kernel is updated frequently
> (and BTF is self-describing, which it is not). In practice, though,
> libbpf is far more up-to-date and lends its hand on "sanitizing" .BTF
> from kernel-unsupported features (so far we manage to pull this off
> very reasonably). If you have a good proposal how to make .BTF
> self-describing, that would be great!

I think sanitizing is going to become a problem, but we've been around
that argument a few times :)

Making .BTF self describing need at least adding length to certain fields,
as I mentioned in another thread. Plus an interface to interrogate the
kernel about a loaded BTF blob.

> > I agree with you, the syntax probably has to be different. I'd just like it to
> > differ by more than a "*" in the struct definition, because that is too small
> > to notice.
>
> So let's lay out how it will be done in practice:
>
> 1. Simple map w/ custom key/value
>
> struct my_key { ... };
> struct my_value { ... };
>
> struct {
>     __u32 type;
>     __u32 max_entries;
>     struct my_key *key;
>     struct my_value *value;
> } my_simple_map BPF_MAP = {
>     .type = BPF_MAP_TYPE_ARRAY,
>     .max_entries = 16,
> };
>
> 2. Now map-in-map:
>
> struct {
>     __u32 type;
>     __u32 max_entries;
>     struct my_key *key;
>     struct {
>         __u32 type;
>         __u32 max_entries;
>         __u64 *key;
>         struct my_value *value;
>     } value;
> } my_map_in_map BPF_MAP = {
>     .type = BPF_MAP_TYPE_HASH_OF_MAPS,
>     .max_entries = 16,
>     .value = {
>         .type = BPF_MAP_TYPE_ARRAY,
>         .max_entries = 100,
>     },
> };
>
> It's clearly hard to misinterpret inner map definition for a custom
> anonymous struct type, right?

That's not what I'm concerned about. My point is: sometimes you
have to use a pointer, sometimes you don't. Every user has to learn this.
Chance is, they'll probably get it wrong first. Is there a way to give a
reasonable error message for this?

> > I kind of assumed that BTF support for those maps would at some point
> > appear, maybe I should have checked that.
>
> It will. Current situation with maps not supporting specifying BTF for
> key and/or value looks more like a bug, than feature and we should fix
> that. But even if we fix it today, kernels are updated much slower
> than libbpf, so by not supporting key_size/value_size, we force people
> to get stuck with legacy bpf_map_def for a really long time.

OK.

I'll go and look at the newest revision of the patch set now :o)

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
