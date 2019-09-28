Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB794C114C
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 18:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfI1QbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 12:31:15 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35241 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1QbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 12:31:15 -0400
Received: by mail-qk1-f194.google.com with SMTP id w2so4450307qkf.2;
        Sat, 28 Sep 2019 09:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DB3lQTaHiF44p47TOLBQdbutu/YNcs/2oWSngvnk8pM=;
        b=BkNbvMUWm+1v+GJKK/5n80GdlEIXTDF7ipkukdFUhaxLqVuNVjM4GJQMuEuT5lw9jv
         wVIIHDuEEukWKNTfybDkWbo+eJs8OmFMUCbnfZTO6d6zR2D0EqQ4HwYKEXFnLG8LUjZI
         8k5KlJ1vgNYcXWm/ESrUwlhqdZHE0zl5LJ64G0bGKqNWAPtmA8WDUJvtENuN/0dDgbaD
         yoRcYCzvFL6EAJmnDEKiwUbXlMSrxkSnoLctv1yWKQ5OOJEhfDVntYfClFsxMhcFkf4T
         k1LjIxYxdg7KZiXwlaiD5ey9+0WR7GBP+3Qkj0Mk0ec8P2iPWneN81RNt0tvvkAL8q5q
         8bRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DB3lQTaHiF44p47TOLBQdbutu/YNcs/2oWSngvnk8pM=;
        b=j23WPbi9/2DdZz+bH2lxPHpJZiwsCzKYSHqpQ0ijmU57JNu1S43L77HmKaYxoG17mv
         yQMvx4Hvlk/N0e35vFkxR0AiHWBoFkxXC+ACCEXWbGRGcslK7pg2axqAWOAAoW4MMPDS
         Hhl6QixU4hnazVL9CMKPZuUph9rNOH+xtfyvSQRFthoo0zWu2Ftv3JEQO8/JVLQQb1VH
         PISASEpwKOk2GwAodPZFktRhyU4qJNORglUqjt9o/6m72gbK/pDdk/nY0YucFiLh3Xf3
         yMzWVYb+99h+itCtD3BOuSeVsuqOZbzwkF4qKLHqkuHbaY3yzB3IjnTwm77QxYGtJT3w
         DHKA==
X-Gm-Message-State: APjAAAV++vmPydLuK9GvesuhO5RBtG+33BNKG/VFIuaKrWrUPORo/0fc
        lC1rKo7iUFfmkVMuCIEfxFG8xukl7OBwG90jKms=
X-Google-Smtp-Source: APXvYqxPZIX6lsapPAClIPustCCQwbJ123lj6HXH5AwejPDFpsGykc/XCrlmUoXQQxThTWzkY9Q1Kx19iDKAdsj7q0A=
X-Received: by 2002:ae9:dc87:: with SMTP id q129mr10643759qkf.92.1569688273738;
 Sat, 28 Sep 2019 09:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190928063033.1674094-1-andriin@fb.com> <alpine.LRH.2.20.1909281202530.5332@dhcp-10-175-218-65.vpn.oracle.com>
In-Reply-To: <alpine.LRH.2.20.1909281202530.5332@dhcp-10-175-218-65.vpn.oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 28 Sep 2019 09:31:03 -0700
Message-ID: <CAEf4BzYTQbVVUiQOHEcjL8mZ=iJBSGHFRNxoayRpaMw5ys+iDw@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: count present CPUs, not theoretically possible
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 28, 2019 at 4:20 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Fri, 27 Sep 2019, Andrii Nakryiko wrote:
>
> > This patch switches libbpf_num_possible_cpus() from using possible CPU
> > set to present CPU set. This fixes issues with incorrect auto-sizing of
> > PERF_EVENT_ARRAY map on HOTPLUG-enabled systems.
> >
> > On HOTPLUG enabled systems, /sys/devices/system/cpu/possible is going to
> > be a set of any representable (i.e., potentially possible) CPU, which is
> > normally way higher than real amount of CPUs (e.g., 0-127 on VM I've
> > tested on, while there were just two CPU cores actually present).
> > /sys/devices/system/cpu/present, on the other hand, will only contain
> > CPUs that are physically present in the system (even if not online yet),
> > which is what we really want, especially when creating per-CPU maps or
> > perf events.
> >
> > On systems with HOTPLUG disabled, present and possible are identical, so
> > there is no change of behavior there.
> >
>
> Just curious - is there a reason for not adding a new libbpf_num_present_cpus()
> function to cover this  case, and switching to using that in various places?

The reason is that libbpf_num_possible_cpus() is useless on HOTPLUG
systems and never worked as intended. If you rely on this function to
create perf_buffer and/or PERF_EVENT_ARRAY, it will simply fail due to
specifying more CPUs than are present. I didn't want to keep adding
new APIs for no good reason, while also leaving useless ones, so I
fixed the existing API to behave as expected. It's unfortunate that
name doesn't match sysfs file we are reading it from, of course, but
having people to choose between libbpf_num_possible_cpus() vs
libbpf_num_present_cpus() seems like even bigger problem, as
differences are non-obvious.

The good thing, it won't break all the non-HOTPLUG systems for sure,
which seems to be the only cases that are used right now (otherwise
someone would already complain about broken
libbpf_num_possible_cpus()).

>
> Looking at the places libbpf_num_possible_cpus() is called in libbpf
>
> - __perf_buffer__new(): this could just change to use the number of
>   present CPUs, since perf_buffer__new_raw() with a cpu_cnt in struct
>   perf_buffer_raw_ops
>
> - bpf_object__create_maps(), which is called via bpf_oject__load_xattr().
>   In this case it seems like switching to num present makes sense, though
>   it might make sense to add a field to struct bpf_object_load_attr * to
>   allow users to explicitly set another max value.

I believe more knobs is not always better for API. Plus, adding any
field to those xxx_xattr structs is an ABI breakage and requires
adding new APIs, so I don't think this is good enough reason to add
new flag. See discussion in another thread about this whole API design
w/ current attributes and ABI consequences of adding anything new to
them.

>
> This would give the desired default behaviour, while still giving users
> a way of specifying the possible number. What do you think? Thanks!

BTW, if user wants to override the size of maps, they can do it easily
either in map definition or programmatically after bpf_object__open,
but before bpf_object__load, so there is no need for flags, it's all
easily achievable with existing API.

>
> Alan
>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index e0276520171b..45351c074e45 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -5899,7 +5899,7 @@ void bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear)
> >
> >  int libbpf_num_possible_cpus(void)
> >  {
> > -     static const char *fcpu = "/sys/devices/system/cpu/possible";
> > +     static const char *fcpu = "/sys/devices/system/cpu/present";
> >       int len = 0, n = 0, il = 0, ir = 0;
> >       unsigned int start = 0, end = 0;
> >       int tmp_cpus = 0;
> > --
> > 2.17.1
> >
> >
