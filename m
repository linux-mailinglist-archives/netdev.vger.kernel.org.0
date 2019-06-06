Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25493380E4
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfFFWfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:35:02 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36795 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFWfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:35:02 -0400
Received: by mail-qt1-f194.google.com with SMTP id u12so151614qth.3;
        Thu, 06 Jun 2019 15:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bOVE+jOrxCKVuPWywpTIeCbFCvu7FzWRnVzKwaQlDWk=;
        b=iye5u7k/wgiF1zYIii7X0ePRYbRdzX5KpXeMNU2pgR730SGckd+97alZ7luCjU8c4G
         wge35sfMDThX04Ic5k1gn/u+LMp8pV43SMCcimSs+w0DkvvJdeE2HNGpUhP8Kg5OpR0q
         jI+qiLNzM7TsbiPHQ5fSHKtMGevM4jq6CwgGi8iihynmXad+eR0rkRJrMSrV5kMw3XyH
         MqDsVm0bEYUDgeqLIEin+nSPTWVS1zBYiJ3r5j3yGVDqart2Rpd9U67zC+fwnwKr5ZJb
         QpxV1N+SFe9mE6AoXNtFQdEvqsLB7zbdh792zXY7pu7ijI1J6U53SKuCt3SvBe/brYob
         G+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bOVE+jOrxCKVuPWywpTIeCbFCvu7FzWRnVzKwaQlDWk=;
        b=MMOrkn5W8cmd1D9+XMeP/7W2EHnsJMKOY7/CaqILpqhC6SE7WtlFz75Ade0RK5fs1B
         ySpvm053Qex+L6IINVeB4k4BctJBRKb1LjngKkpJkafFKu62/Z/CpYHGgRLiSIbiJnQY
         PGECUysgGPLVkkXt7Wp2dwgVeaaAkiU8kFUUUXzoQ/WZSpOqt5vsuCbcWgueRwDh5zjQ
         rSLNrGBUaUsUpDB/WO0IRlaGIqYDd3/daU+EPyNV1roAzxVpuV9T/WGMgb3s2Cws9Tka
         E43jCFMX1D/YHqhYVRESNtF/EB9/qiU49vHjzijGV9o8/lsobtOYBzmQGlo8g+qRLmVX
         phSg==
X-Gm-Message-State: APjAAAWnYD3kJ9cRHtpTHgZWSC9IsuNtoDByDgoeEPfAUp6lJsZ6vQKr
        ARGhrfGDkELqvstcbuKyt1R/hqBspn/nPGVAlZm1y+tw
X-Google-Smtp-Source: APXvYqwgo3FHWF5X+iU8z6ytVkONar9zFTH3AHJ9n4IIQyt2Hx5dJ5Y9sXvcEx8YLoYK9XW3YuZp2c+qJmXsdPbk9Ek=
X-Received: by 2002:ac8:2a63:: with SMTP id l32mr23163084qtl.117.1559860501098;
 Thu, 06 Jun 2019 15:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-1-andriin@fb.com> <20190531202132.379386-7-andriin@fb.com>
 <CACAyw99wD+7mXXeger6WoBTTu3aYHDW8EJV9_tP7MfXOnT0ODg@mail.gmail.com>
In-Reply-To: <CACAyw99wD+7mXXeger6WoBTTu3aYHDW8EJV9_tP7MfXOnT0ODg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 6 Jun 2019 15:34:50 -0700
Message-ID: <CAEf4BzamSjSa-7ddzyVsqygbtT6WSwsWpCFGX-4Rav4Aev8UsA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Lorenz Bauer <lmb@cloudflare.com>
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

On Thu, Jun 6, 2019 at 9:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Thanks for sending this RFC! For me, the biggest draw is that map-in-map
> would be so much nicer to use, plus automatic dumping of map values.
>
> Others on the thread have raised this point already: not everybody lives
> on the bleeding edge or can control all of their dependencies. To me this means
> that having a good compatibility story is paramount. I'd like to have very clear
> rules how the presence / absence of fields is handled.

I think that discussion was more about selftests being switched to
BTF-defined maps rather than BPF users having to switch to latest
compiler. struct bpf_map_def is still supported for those who can't
use clang that supports BTF_KIND_VAR/BTF_KIND_DATASEC.
So I don't think this enforces anyone to switch compiler, but
certainly incentivizes them :)

>
> For example:
> - Fields that are present but not understood are an error. This makes
> sense because
>   the user can simply omit the field in their definition if they do
> not use it. It's also necessary
>   to preserve the freedom to add new fields in the future without
> risking user breakage.

So you are arguing for strict-by-default behavior. It's fine by me,
but exactly that strict-by-default behavior is the problem with BTF
extensivility, that you care a lot about. You are advocating for
skipping unknown BTF types (if it was possible), which is directly
opposite to strict-by-default behavior. I have no strong preference
here, but given amount of problem (and how many times we missed this
problem in the past) w/ introducing new BTF feature and then
forgetting about doing something for older kernels, kind of makes me
lean towards skip-and-log behavior. But I'm happy to support both
(through flags) w/ strict by default.

> - If libbpf adds support for a new field, it must be optional. Seems
> like this is what current
>   map extensions already do, so maybe a no-brainer.

Yeah, of course.

>
> Somewhat related to this: I really wish that BTF was self-describing,
> e.g. possible
> to parse without understanding all types. I mentioned this in another
> thread of yours,
> but the more we add features where BTF is required the more important it becomes
> IMO.

I relate, but have no new and better solution than previously
discussed :) We should try to add new stuff to .BTF.ext as much as
possible, which is self-describing.

>
> Finally, some nits inline:
>
> On Fri, 31 May 2019 at 21:22, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > The outline of the new map definition (short, BTF-defined maps) is as follows:
> > 1. All the maps should be defined in .maps ELF section. It's possible to
> >    have both "legacy" map definitions in `maps` sections and BTF-defined
> >    maps in .maps sections. Everything will still work transparently.
>
> I'd prefer using a new map section "btf_maps" or whatever. No need to
> worry about code that deals with either type.

We do use new map section. Its ".maps" vs "maps". Difference is
subtle, but ".maps" looks a bit more "standardized" than "btf_maps" to
me (and hopefully, eventually no one will use "maps" anymore :) ).

>
> > 3. Key/value fields should be **a pointer** to a type describing
> >    key/value. The pointee type is assumed (and will be recorded as such
> >    and used for size determination) to be a type describing key/value of
> >    the map. This is done to save excessive amounts of space allocated in
> >    corresponding ELF sections for key/value of big size.
>
> My biggest concern with the pointer is that there are cases when we want
> to _not_ use a pointer, e.g. your proposal for map in map and tail calling.
> There we need value to be a struct, an array, etc. The burden on the user
> for this is very high.

Well, map-in-map is still a special case and whichever syntax we go
with, it will need to be of slightly different syntax to distinguish
between those cases. Initialized maps fall into similar category,
IMHO.

Embedding full value just to capture type info/size is unacceptable,
as we have use cases that cause too big ELF size increase, which will
prevent users from switching to this.

>
> > 4. As some maps disallow having BTF type ID associated with key/value,
> >    it's possible to specify key/value size explicitly without
> >    associating BTF type ID with it. Use key_size and value_size fields
> >    to do that (see example below).
>
> Why not just make them use the legacy map?

For completeness' sake at the least. E.g., what if you want to use
map-in-map, where inner map is stackmap or something like that, which
requires key_size/value_size? I think we all agree that it's better if
application uses just one style, instead of a mix of both, right?
Btw, for map cases where map key can be arbitrary, but value is FD or
some other opaque value, libbpf can automatically "derive" value size
and still capture key type. I haven't done that, but it's very easy to
do (and also we can keep adding per-map-type checks/niceties, to help
users understand what's wrong with their map definition, instead of
getting EINVAL from kernel on map creation).

>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
