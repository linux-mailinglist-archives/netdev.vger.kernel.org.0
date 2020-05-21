Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178BB1DDAC2
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 01:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbgEUXKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 19:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730626AbgEUXKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 19:10:48 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A86C061A0E;
        Thu, 21 May 2020 16:10:48 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id fb16so3917507qvb.5;
        Thu, 21 May 2020 16:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p/aF26seQljYORhJ0HyexPHN0vOT6pIrtEo4pm2qaCI=;
        b=U31Lsq+9BddttXAABUOBU3fCeB9qEFps+ao/8amscsm3b4DOMilpPpO6/nrC7eCCjl
         o3Fz3GhLN5QJWF+Ib/dLftNPyGiu4qevHNpviulLZMl/SQXPMb7dzSp5bqLPED3xMjaP
         MoCQ+DsdlQ8Y2HRsWApHJi6B51hq1CUxGSzHxB4MeAWouU5KY8Tn6uMzEOr2juneykqr
         ZEAlJXYOluGeN48i1Hl7K1tz9l3EHoqyeEZ91k1JdfW3FsikGD89ViYNAyLeyId2JzNc
         w4iXGzRvg4uzZYwh3cArGkaIa4yhdj5AFOxJTdS5DECKBwVYAu6HIvEjLRVyTxehZhS0
         hmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p/aF26seQljYORhJ0HyexPHN0vOT6pIrtEo4pm2qaCI=;
        b=DR5HOWOLDyANoEFLkraHa8Fn6/GbHavUBAuN5LjOj45kH6MSIfr/jsSjO55/C3RMCp
         8kSyCZIRE6r4zhybSlHvnYs4PmnzWwebMgPw1vbWtowjZtQkDLmXMZuSEv7QuxeVCv3Q
         ZR/1d2azHZhGbKU86rolukyJoUBMolhK/VeFhnSKz2TcJ94vNoP/YoCU2YlsNet3Yoko
         yF4fkU+VgI5h1LqIE5JMriHz8bLMe0/KTkesHMOzVNvBKznh3NqFdxnQr+6DfhpHaWV3
         F/o510YQTbK1wEQjlOD/bjY62IpGimHDJ7RaMA1UmzHkC02FqvgQFwuGMZSeTw9eK7Du
         rp2A==
X-Gm-Message-State: AOAM532ktegyndF7A+ENWn4i9YVI5gxt53qNLH6yFf3hn7OpV67SNRVQ
        AUEWzLLGQtpuKFhJtwe+Q3l96S9JGZY3QBNBP4k=
X-Google-Smtp-Source: ABdhPJxgIMnMS6hT70glg3oViZC/lVRml7We+N4A2gDIGeo5yl2cMnku/v8+OYBUREQgG50JFxuDf2ecRx79GYdNFHI=
X-Received: by 2002:a0c:a892:: with SMTP id x18mr1044146qva.247.1590102647585;
 Thu, 21 May 2020 16:10:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200521191752.3448223-1-kafai@fb.com> <CAEf4BzYQmUCbQ-PB2UR5n=WEiCHU3T3zQcQCnjvqCew6rmjGLg@mail.gmail.com>
 <20200521225939.7nmw7l5dk3wf557r@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200521225939.7nmw7l5dk3wf557r@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 May 2020 16:10:36 -0700
Message-ID: <CAEf4BzZyhT6D6F2A+cN6TKvLFoH5GU5QVEVW7ZkG+KQRgJC-1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] bpf: Allow inner map with different max_entries
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 3:59 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, May 21, 2020 at 03:39:10PM -0700, Andrii Nakryiko wrote:
> > On Thu, May 21, 2020 at 12:18 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This series allows the outer map to be updated with inner map in different
> > > size as long as it is safe (meaning the max_entries is not used in the
> > > verification time during prog load).
> > >
> > > Please see individual patch for details.
> > >
> >
> > Few thoughts:
> >
> > 1. You describe WHAT, but not necessarily WHY. Can you please
> > elaborate in descriptions what motivates these changes?
> There are cases where people want to update a bigger size
> inner map.  I will update the cover letter.
>
> > 2. IMO, "capabilities" is word that way too strongly correlates with
> > Linux capabilities framework, it's just confusing. It's also more of a
> > property of a map type, than what map is capable of, but it's more
> > philosophical distinction, of course :)
> Sure. I can rename it to "property"
>
> > 3. I'm honestly not convinced that patch #1 qualifies as a clean up. I
> > think one specific check for types of maps that are not compatible
> > with map-in-map is just fine. Instead you are spreading this bit flags
> > into a long list of maps, most of which ARE compatible.
> but in one place and at the same time a new map type is added to
> bpf_types.h
>
> > It's just hard
> > to even see which ones are not compatible. I like current way better.
> There are multiple cases that people forgot to exclude a new map
> type from map-in-map in the first attempt and fix it up later.
>
> During the map-in-map implementation, this same concern was raised also
> about how to better exclude future map type from map-in-map since
> not all people has used map-in-map and it is easy to forget during
> review.  Having it in one place in bpf_types.h will make this
> more obvious in my opinion.  Patch 1 is an attempt to address
> this earlier concern in the map-in-map implementation.

Ok, just invert the condition and list only types that **are** allowed
inside map-in-map. If someone forgot to add it to map-in-map check, it
can be done later when someone needs it. The point is that we have a
check and a list in one place, close to where it matters, instead of
tracing where the value of ->capabilities comes from. Finding that in
bpf_types.h is not easy and not obvious, unfortunately, and is very
distant from where it's actually checked.


>
> > 4. Then for size check change, again, it's really much simpler and
> > cleaner just to have a special case in check in bpf_map_meta_equal for
> > cases where map size matters.
> It may be simpler but not necessary less fragile for future map type.
>
> I am OK for removing patch 1 and just check for a specific
> type in patch 2 but I think it is fragile for future map
> type IMO.

Well, if we think that the good default needs to be to check size,
then similar to above, explicitly list stuff that *does not* follow
the default, i.e., maps that don't want max_elements verification. My
point still stands.

>
> > 5. I also wonder if for those inner maps for which size doesn't
> > matter, maybe we should set max_elements to zero when setting
> > inner_meta to show that size doesn't matter? This is minor, though.
> >
> >
> > > Martin KaFai Lau (3):
> > >   bpf: Clean up inner map type check
> > >   bpf: Relax the max_entries check for inner map
> > >   bpf: selftests: Add test for different inner map size
> > >
> > >  include/linux/bpf.h                           | 18 +++++-
> > >  include/linux/bpf_types.h                     | 64 +++++++++++--------
> > >  kernel/bpf/btf.c                              |  2 +-
> > >  kernel/bpf/map_in_map.c                       | 12 ++--
> > >  kernel/bpf/syscall.c                          | 19 +++++-
> > >  kernel/bpf/verifier.c                         |  2 +-
> > >  .../selftests/bpf/prog_tests/btf_map_in_map.c | 12 ++++
> > >  .../selftests/bpf/progs/test_btf_map_in_map.c | 31 +++++++++
> > >  8 files changed, 119 insertions(+), 41 deletions(-)
> > >
> > > --
> > > 2.24.1
> > >
