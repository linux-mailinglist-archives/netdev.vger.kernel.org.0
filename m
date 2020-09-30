Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE49227F568
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbgI3Wrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730981AbgI3Wrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 18:47:47 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1D2C061755;
        Wed, 30 Sep 2020 15:47:47 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id a2so2542753ybj.2;
        Wed, 30 Sep 2020 15:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V53pYBoeL0lti3WNoiCSqcgVN4avIqyPRLADudNGDUI=;
        b=h2BkJtsLjBmgNaerEiHle7mdaDdaC8rnZdKVOs+UdW9H8kh4wBA4WCNJD3jBek1nyc
         CceeI1KmcexZZzAeOajgv53qE8q2V4CM4XQppSDMBbrhK9YKMTdypUBTbERX0LSAMfli
         N6rPx+pPAXcDrhR/lIB0OIS12SSNwOwEs1BR+tKMOhQcvAhx1o8egib6H8YPzBobuYFP
         f+eo6ioZy9XTPVav3qErNRrZVzZ6VXwltwDJeh6/XUZ3x3p544LXrJUFZ4jmKOjzEXR1
         sx7u23ewuV8gAAtLeQys2dlTLFwMEvVztYWqZ/QyA3GC+QpnRXp4HPmD3m+f555msAIt
         0hHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V53pYBoeL0lti3WNoiCSqcgVN4avIqyPRLADudNGDUI=;
        b=sIgrPZVuuQD1NrWp5QaPQTZXN8x8W0hikSK5FBYK5+EICPJKtSGgAU0XZhhcFnnoVP
         vYkj3HOcbOLkUUZin2ovwHBY3unc+hzrRFmMFDFEVv4Rd2MzFcGgRkOcm2tYRkdAW9ja
         Z5AlnT17BjDzokavrYnw5/RRmLnaY39Ueyru3Ikb/EOEpKNe3O+O7Jl7O2WE+eDzP9Sv
         PKbT35HofsPaKlIUWIJTAawbAu9KHGqO/tqxKyHBEyIPfkinQFXL6KIfvn3xOtw26PD9
         /1mjeXS9HrKLyrM97kzJ9OtXr+gHvAtzQySb0lv57y+kqso5by1KONxLh2NFXMm4w+iO
         72Xw==
X-Gm-Message-State: AOAM533CB/xPsO8F1mBYTY0Z7/ZAxrz+sQwivgoAm9m6XUQ2pSeHgM6q
        zOCNNLeZdNIL+D4YS+fgl+n7myGa9zWPnHx5nL4=
X-Google-Smtp-Source: ABdhPJyvlkGwl9jjF1T/3gB6YOKm14/6htikytPIZII13Yk//3N9Ed7zDbYtJvhYNlk8eHoNMzKs6huwGwDmSWjwB14=
X-Received: by 2002:a25:2687:: with SMTP id m129mr6510414ybm.425.1601506066465;
 Wed, 30 Sep 2020 15:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200929232843.1249318-1-andriin@fb.com> <20200930000329.bfcrg6qqvmbmlawk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYByimHd+FogxVHdq2-L_GLjdGEa_ku7p_c1V-hpyJrWA@mail.gmail.com>
 <20200930031809.lto7v7e7vtyivjon@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYBccn5eMNeTZDgU62kokkdTEK3wv5422_kDky3c_KWHw@mail.gmail.com> <20200930212907.mzg3g5522x3oobco@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200930212907.mzg3g5522x3oobco@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 30 Sep 2020 15:47:35 -0700
Message-ID: <CAEf4Bzas1UPV_eDOJAu_rsMFegQrjNbPpovCmyjaa=cnDq1jxA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] libbpf: add raw BTF type dumping
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 2:29 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Sep 30, 2020 at 11:22:50AM -0700, Andrii Nakryiko wrote:
> >
> > If you are saying it should emit it in Go format, Rust format, or
> > other language-specific way, then sure,
>
> Yes. that's what I'm saying. cloudflare and cilium are favoring golang.
> Hopefully they can adopt skeleton when it's generated in golang.
> It would probably mean some support from libbpf and vmlinux.go
> Which means BTF dumping in golang.

Yes, if they were to adopt the skeleton approach, we'd need some sort
of BTF-to-Go struct dumping. But as for vmlinux.h, keep in mind that
that thing is supposed to be only included from the BPF side, which so
far is always pure C (apart from RedBPF approach of compiling Rust
code into BPF code). I don't think we want to have BPF-side code
written in Go?

>
> > maybe, but it sure won't
> > re-use C-specific logic of btf_dump__dump_type() as is, because it is
> > C language specific. For Go there would be different logic, just as
> > for any other language.
>
> sure. that's fine.
>
> > And someone will have to implement it (and
> > there would need to be a compelling use case for that, of course). And
> > it will be a different API, or at least a generic API with some enum
> > specifying "format" (which is the same thing, really, but inferior for
> > customizability reasons).
>
> yes. New or reusing api doesn't matter much.
> The question is what dumpers libbpf provides.
>
> > But JSON is different from that. It's just a more machine-friendly
> > output of textual low-level BTF dump. It could have been BSON or YAML,
> > but I hope you don't suggest to emit in those formats as well.
>
> why not. If libbpf does more than one there is no reason to restrict.

just extra code and maintenance burden without clear benefits, that's
the only reason

>
> >
> > > I don't think that text and json formats bring much value comparing to C,
> > > so I would be fine with C only.
> >
> > Noted. I disagree and find it very useful all the time, it's pretty
> > much the only way I look at BTF. C output is not complete: it doesn't
> > show functions, data sections and variables. It's not a replacement
> > for raw BTF dump.
>
> Ok, but it's easy to add dumping of these extra data into vmlinux.h
> They can come inside /* */ or as 'extern'.
> So C output can be complete and suitable for selftest's strcmp.

yeah, comments might work to "augment" vmlinux.h. There is still the
question of output type ordering, it's not always a single unique
ordering, which makes it harder to use for testing arbitrary BTFs. I
was very careful with existing BTF dump tests to ensure the order of
types is unique, but as a general case that's not true.

E.g., these two are equivalent:

struct a;

struct b { struct a *a; };

struct a { struct b *b; };

And:

struct b;

struct a { struct b *b; };

struct b { struct a *a; };

>
> > Regardless, feel free to drop patches #2 and #3, but patch #1 fixes
> > real issue, so would be nice to land it anyways. Patch #4 adds test
> > for changes in patch #1. Let me know if you want me to respin with
> > just those 2 patches.
>
> Applied 1 and 4. I was waiting to patchwork bot to notice this partial

thanks!

> application, but looks like it's not that smart... yet.

software, maybe some day :)
