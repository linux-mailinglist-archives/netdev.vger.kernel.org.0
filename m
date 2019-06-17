Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B565947DE5
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 11:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbfFQJH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 05:07:26 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46978 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbfFQJHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 05:07:25 -0400
Received: by mail-ot1-f66.google.com with SMTP id z23so8528863ote.13
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 02:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0U1z/nmUiL9l+lfI3wEX3iWZxtd/accR9HWtzjIm1lE=;
        b=Bp+dUsspDr9660OEwgxvrCF0u2KqhhZahAZ+dk8bHvnjQdQ2K4X8gbhz7vksSjmqT5
         foVLOyytN5sU/5Vae1f6/pZUZSMy+H3gofUP70ciCmtXIw1r97r2bJ1m9nCbFZ6q3Fnf
         pzV2mn1C3N415/q4NM/Up/3oHLwgoeauIG464=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0U1z/nmUiL9l+lfI3wEX3iWZxtd/accR9HWtzjIm1lE=;
        b=rkFjiXglDil2muHTjlPbZh62zcv+NmghRvHIX9L3Zg+a3bluxIccJkGVrepJ0KPIYs
         /9gMd2n7u86V+hZFWmscAt1xRDgbRdM8vxCQBymHCUEoIdkpSGBHF/fqsacWUwW75zFZ
         uk4dEE1TeGL75zuAqo/ZUWmn7lSk4egfOuZ6USuUpn8VTT3CpK2HuiPBWUPeGEcbunrk
         4Tnm4OlvQq2nIVQN3q5w2piMB2TjlZmatS76n1cJdtZmo9FM9OHRNLrYFakiUwKGBxXR
         Ignfhdc9SGXNGGft3Om3oB3BHouhK+Jbmq2xxw5qLF/dms8H+xrkX1UWLBgHiShNW0rG
         P9NQ==
X-Gm-Message-State: APjAAAWqd1X2xvvqqVccn1P4Vlu5CcKJJJOUvl6YSFuUPStWU0/+d3Wa
        Nlv3swROh99I/glkMW9sYwNFsmqaGxDIwPxhEz9Zkw==
X-Google-Smtp-Source: APXvYqx0jVhIMtzsNuehae9G5y0W/bBlllBUBCFFpCHWEPs44xIJQSh48LEJKXCtFLr8HGBHVAuoyafYjLFCsHkJTxw=
X-Received: by 2002:a9d:28:: with SMTP id 37mr50868435ota.289.1560762444540;
 Mon, 17 Jun 2019 02:07:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-1-andriin@fb.com> <20190531202132.379386-7-andriin@fb.com>
 <CACAyw99wD+7mXXeger6WoBTTu3aYHDW8EJV9_tP7MfXOnT0ODg@mail.gmail.com> <CAEf4BzamSjSa-7ddzyVsqygbtT6WSwsWpCFGX-4Rav4Aev8UsA@mail.gmail.com>
In-Reply-To: <CAEf4BzamSjSa-7ddzyVsqygbtT6WSwsWpCFGX-4Rav4Aev8UsA@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 17 Jun 2019 10:07:13 +0100
Message-ID: <CACAyw9_Yr=pmvCRYsVHoQBrH7qBwmcaXZezmqafwJTxaCmDf6A@mail.gmail.com>
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

On Thu, 6 Jun 2019 at 23:35, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jun 6, 2019 at 9:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > Thanks for sending this RFC! For me, the biggest draw is that map-in-map
> > would be so much nicer to use, plus automatic dumping of map values.
> >
> > Others on the thread have raised this point already: not everybody lives
> > on the bleeding edge or can control all of their dependencies. To me this means
> > that having a good compatibility story is paramount. I'd like to have very clear
> > rules how the presence / absence of fields is handled.
>
> I think that discussion was more about selftests being switched to
> BTF-defined maps rather than BPF users having to switch to latest
> compiler. struct bpf_map_def is still supported for those who can't
> use clang that supports BTF_KIND_VAR/BTF_KIND_DATASEC.
> So I don't think this enforces anyone to switch compiler, but
> certainly incentivizes them :)
>
> >
> > For example:
> > - Fields that are present but not understood are an error. This makes
> > sense because
> >   the user can simply omit the field in their definition if they do
> > not use it. It's also necessary
> >   to preserve the freedom to add new fields in the future without
> > risking user breakage.
>
> So you are arguing for strict-by-default behavior. It's fine by me,
> but exactly that strict-by-default behavior is the problem with BTF
> extensivility, that you care a lot about. You are advocating for
> skipping unknown BTF types (if it was possible), which is directly
> opposite to strict-by-default behavior. I have no strong preference
> here, but given amount of problem (and how many times we missed this
> problem in the past) w/ introducing new BTF feature and then
> forgetting about doing something for older kernels, kind of makes me
> lean towards skip-and-log behavior. But I'm happy to support both
> (through flags) w/ strict by default.

In my mind, BPF loaders should be able to pass through BTF to the kernel
as a binary blob as much as possible. That's why I want the format to
be "self describing". Compatibility then becomes a question of: what
feature are you using on which kernel. The kernel itself can then still be
strict-by-default or what have you.

>
> > - If libbpf adds support for a new field, it must be optional. Seems
> > like this is what current
> >   map extensions already do, so maybe a no-brainer.
>
> Yeah, of course.
>
> >
> > Somewhat related to this: I really wish that BTF was self-describing,
> > e.g. possible
> > to parse without understanding all types. I mentioned this in another
> > thread of yours,
> > but the more we add features where BTF is required the more important it becomes
> > IMO.
>
> I relate, but have no new and better solution than previously
> discussed :) We should try to add new stuff to .BTF.ext as much as
> possible, which is self-describing.
>
> >
> > Finally, some nits inline:
> >
> > On Fri, 31 May 2019 at 21:22, Andrii Nakryiko <andriin@fb.com> wrote:
> > >
> > > The outline of the new map definition (short, BTF-defined maps) is as follows:
> > > 1. All the maps should be defined in .maps ELF section. It's possible to
> > >    have both "legacy" map definitions in `maps` sections and BTF-defined
> > >    maps in .maps sections. Everything will still work transparently.
> >
> > I'd prefer using a new map section "btf_maps" or whatever. No need to
> > worry about code that deals with either type.
>
> We do use new map section. Its ".maps" vs "maps". Difference is
> subtle, but ".maps" looks a bit more "standardized" than "btf_maps" to
> me (and hopefully, eventually no one will use "maps" anymore :) ).

Phew, spotting that difference is night impossible IMO.

>
> >
> > > 3. Key/value fields should be **a pointer** to a type describing
> > >    key/value. The pointee type is assumed (and will be recorded as such
> > >    and used for size determination) to be a type describing key/value of
> > >    the map. This is done to save excessive amounts of space allocated in
> > >    corresponding ELF sections for key/value of big size.
> >
> > My biggest concern with the pointer is that there are cases when we want
> > to _not_ use a pointer, e.g. your proposal for map in map and tail calling.
> > There we need value to be a struct, an array, etc. The burden on the user
> > for this is very high.
>
> Well, map-in-map is still a special case and whichever syntax we go
> with, it will need to be of slightly different syntax to distinguish
> between those cases. Initialized maps fall into similar category,
> IMHO.

I agree with you, the syntax probably has to be different. I'd just like it to
differ by more than a "*" in the struct definition, because that is too small
to notice.

>
> Embedding full value just to capture type info/size is unacceptable,
> as we have use cases that cause too big ELF size increase, which will
> prevent users from switching to this.
>
> >
> > > 4. As some maps disallow having BTF type ID associated with key/value,
> > >    it's possible to specify key/value size explicitly without
> > >    associating BTF type ID with it. Use key_size and value_size fields
> > >    to do that (see example below).
> >
> > Why not just make them use the legacy map?
>
> For completeness' sake at the least. E.g., what if you want to use
> map-in-map, where inner map is stackmap or something like that, which
> requires key_size/value_size? I think we all agree that it's better if
> application uses just one style, instead of a mix of both, right?

I kind of assumed that BTF support for those maps would at some point
appear, maybe I should have checked that.

> Btw, for map cases where map key can be arbitrary, but value is FD or
> some other opaque value, libbpf can automatically "derive" value size
> and still capture key type. I haven't done that, but it's very easy to
> do (and also we can keep adding per-map-type checks/niceties, to help
> users understand what's wrong with their map definition, instead of
> getting EINVAL from kernel on map creation).
>
> >
> > --
> > Lorenz Bauer  |  Systems Engineer
> > 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
> >
> > www.cloudflare.com



-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
