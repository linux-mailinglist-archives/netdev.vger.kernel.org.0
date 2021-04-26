Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CCD36BBF8
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 01:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhDZXMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 19:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbhDZXMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 19:12:17 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA07C061574;
        Mon, 26 Apr 2021 16:11:35 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 130so23190711ybd.10;
        Mon, 26 Apr 2021 16:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CPYnxk6L4FHxs/fWVyMKAn+lpl/tH2wnXHBMgeYKd/A=;
        b=Z7yZfeG48GTsv3tCFxLE8hSu798CTwjySsCGZXBSDDO9uKg+h9G4LYGcAPwFc+XVNl
         +iGw7/4GjwGhp1qNIMABgpQAWwigrMrioeQVkbzqyuT9AUes3AM3n9cWwNt6YWjNimIY
         s7u7OXn2WgNx1bqGmjLIYH8rsBERWKRc2ntD32ka5aRMEsAToKyPN5xIWGvqxFbMUhTT
         zJfkupwcni1O33GMsrweMOGeTQjm/kI4irt+uOttrOs3tV/FUxEeKXtWbf8yuAv1lMmO
         Fl5Ie/cqkcG5xeMtT/WwVk0OqBCVWV+kzYGlViVnJyAvIt4++AuQs4eOsC7Jbua/mNsI
         PszA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CPYnxk6L4FHxs/fWVyMKAn+lpl/tH2wnXHBMgeYKd/A=;
        b=Ja6URyf3hhyuk1IoHr4+ZfOK1kzC0cjB9q00lpJURUcrUhodAaIqE4lOPbgHp+Z66P
         jKUv6xr9izSS+XE4MUtUMEaxj3Zt9mkJUIAlaxiOi2+2CusLKC8/s1GmzD88Wv6kv8kO
         s1j9Ml/NKZi8qELh3P6JfLjigFLQIJ7d0sh8Q5LTJc6tyFCfvvSq/7l0b6BB3NOkSVqT
         hKgcLaFXF/Iw7ha//dvdGZzj51pLuanq+61Bz3oA9RelQRpobarWn/t+erhspmyYFfjO
         UNnaIa2yMayp+ObCGK7nr5rCfihXb+W60uUfab4r0oum6OEqVSEHhepkbJhxygEGEh3d
         jLzA==
X-Gm-Message-State: AOAM530fBLW0VpGsFS1l3vSfKwasfxjxIhb3GjHJZy0Cz/3TwbeyfsXy
        u2ZHMYhJ/8hVLYujQ9IUfOWJN8kt/lwAm+pKTgFB3PgB
X-Google-Smtp-Source: ABdhPJz/wVA1V9cjT+nfmrGcwlQwq/MB+CbcRlBEPDC6LTsNXIHrHVUM01PfpucxLSmW47lW2yRdfYFz+vHJsnKnw98=
X-Received: by 2002:a25:2441:: with SMTP id k62mr27542430ybk.347.1619478694789;
 Mon, 26 Apr 2021 16:11:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210423185357.1992756-3-andrii@kernel.org> <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com>
 <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
 <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com> <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
 <CAEf4BzadCR+QFy4UY8NSVFjGJF4CszhjjZ48XeeqrfX3aYTnkA@mail.gmail.com>
 <CAADnVQKo+efxMvgrqYqVvUEgiz_GXgBVOt4ddPTw_mLuvr2HUw@mail.gmail.com>
 <CAEf4BzZifOFHr4gozUuSFTh7rTWu2cE_-L4H1shLV5OKyQ92uw@mail.gmail.com>
 <CAADnVQ+h78QijAjbkNqAWn+TAFxrd6vE=mXqWRcy815hkTFvOw@mail.gmail.com>
 <CAEf4BzZOmCgmbYDUGA-s5AF6XJFkT1xKinY3Jax3Zm2OLNmguA@mail.gmail.com> <20210426223449.5njjmcjpu63chqbb@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210426223449.5njjmcjpu63chqbb@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 16:11:23 -0700
Message-ID: <CAEf4BzYZX9YJcoragK20cvQvr_tPTWYBQSRh7diKc1KoCtu4Dg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during linking
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 3:34 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 26, 2021 at 08:44:04AM -0700, Andrii Nakryiko wrote:
> >
> > >
> > > > Static maps are slightly different, because we use SEC() which marks
> > > > them as used, so they should always be present.
> > >
> > > yes. The used attribute makes the compiler keep the data,
> > > but it can still inline it and lose the reference in the .text.
> >
> > At least if the map is actually used with helpers (e.g.,
> > bpf_map_lookup_elem(&map, ...)) it would be invalid for compiler to do
> > anything crazy with that map reference, because compiler has no
> > visibility into what opaque helpers do with that memory. So I don't
> > think it can alias multiple maps, for instance. So I think static maps
> > should be fine.
>
> Yeah. That makes sense.
>
> > See above about passing a pointer to map into black box functions. I'd
> > bet that the compiler can't merge together two different references at
> > least because of that.
> >
> > For static maps, btw, just like for static functions and vars, there
> > is no symbol, it's an offset into .maps section. We use that offset to
> > identify the map itself.
>
> Ok. Sounds like there is a desire to expose both static and static volatile
> into skeleton.
> Sure, but let's make it such the linking step doesn't change the skeleton.
> Imagine a project that using single .bpf.c file and skeleton.
> It grows and wants to split itself into multiple .bpf.c.
> If such split would change the skeleton generated var/map names
> it would be annoying user experience.

It's surely not ideal, but it's a one-time step and only when user is
ready to switch to linker, so I don't see it as such a big problem.

>
> I see few options to avoid that:
> - keeping the btf names as-is during linking
> The final .o can have multiple vars and maps with the same name.
> The skeleton gen can see the name collision and disambiguate them.
> Here I think it's important to give users a choice. Blindly appending
> file name is not ideal.
> How to express it cleanly in .bpf.c? I don't know. SEC() would be a bit
> ugly. May be similar to core flavors? ___1 and ___2 ? Also not ideal.

___1 vs ___2 doesn't tell you which file you are accessing static
variable from, you need to go and figure out the order of linking. If
you look at bpf_linker__add_file() API, it has opts->object_name which
allows you to specify what should be used as <prefix>__. Sane default
seems to be the object name derived from filename, but it's possible
to override this. To allow end-users customize we can extend bpftool
to allow users to specify this. One way I was thinking would be
something like

bpftool gen object my_obj1.o=my_prefix1 my_obj2.o=my_prefix2

If user doesn't want prefixing (e.g., when linking multi-file BPF
library into a single .o) they would be able to disable this as:

bpftool gen object lib_file1.o= lib_file2.o= and so on

> - another option is to fail skeleton gen if names conflict.
> This way the users wold be able to link just fine and traditonal C style
> linker behavior will be preserved, but if the user wants a skeleton
> then the static map names across .bpf.c files shouldn't conflict.
> imo that's reasonable restriction.

There are two reasons to use static:
1. hide it from BPF code in other files (compilation units)
2. allow name conflicts (i.e., not care about anyone else accidentally
defining static variable with the same name)

I think both are important and I wouldn't want to give up #2. It
basically says: "no other file should interfere with my state neither
through naming or hijacking my state". Obviously it's impossible to
guard from user-space interference due to how BPF maps/progs are
visible to user-space, so those guarantees are mostly about BPF code
side.

Name prefixing only affects BPF skeleton generation and user-space use
of those static variables, both of which are highly-specific use
patterns "bridging two worlds", BPF and user-space. So I think it's
totally reasonable to specify that such variables will have naming
prefixes. Especially that BPF static variables inside functions
already use similar naming conventions and are similarly exposed in
BPF skeleton.

> - maybe adopt __hidden for vars and maps? Only not hidden (which is default now)
> would be seen in skeleton?

This is similar to the above, it gives up the ability to not care
about naming so much, because everything is forced to be global.
