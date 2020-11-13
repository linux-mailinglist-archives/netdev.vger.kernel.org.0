Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229D02B1500
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 05:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgKMEIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 23:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgKMEIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 23:08:37 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8062C0613D1;
        Thu, 12 Nov 2020 20:08:36 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id i17so7944298ljd.3;
        Thu, 12 Nov 2020 20:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AZbl5qbJ0BQUlrCyYeuRH2WHBnTTfBroCA0v71gGPzM=;
        b=EAwjbLbLZtio+We3R3VZRYvj8d2ngKxaxveWpWwYrnIPLKEbhUj/0vqLWp5jnUYW+K
         cVDEscUOGKWvkEYFY9uhr2jSdDq63oW0LI5gNdQmWW32+K8JRM0PYphZUGBqSL7UGY4h
         vULs8BPfNjVBoconwBuxls9FBcRDCuTkW6N42c6oEiqFu+JFbxPOr1ma1jX9Yf1MuNch
         r7WOaw8GfAC6fmCG9KaDBXDGs9yooxLs2rAcITKbQKh+gawvPYDmmNZEKMNVPlepDaRO
         8hgGhJRxKj2i9pNPdj3vA37kKT2po4d/CbXci9GlI3kx+13ohgyL3632NnFDamlYw5tz
         my/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AZbl5qbJ0BQUlrCyYeuRH2WHBnTTfBroCA0v71gGPzM=;
        b=clBT98iKKL2/uut+5bCrgiPT8CEiZshNniXBqAyiws7g0bH5zXsFnk35jTHYZoHjvi
         NoPh5bg37v9dQVn3y5i60MMgmUwBawMo1yF7TLrIiJE928Kr4GXTPcdlhZbMwABsduRt
         r8cjcERhyYQR6K1upOIjUVAPCY8r1yavl77DZmOVUmYPuu41ik0FGl5JFw64HbKamuEf
         8/vsd5FOxoN8xDWhdZJpzCtYebrnsIlD38Q49D0kDBzEU27MQrspjy+yj7UgqvGOJZbO
         bbGy19go0ChuFr28s3ta6UUcE9tbr/L1qXWPz7zJr/FFJf9Fgz+DHdleBuiuHuvzPtTu
         sOuw==
X-Gm-Message-State: AOAM532Af6ueC+xQlP5ziFaRYARkhIgdN+49Uv0tFnz3jjfL+2oiGUWK
        ziaqDvfGVbE4tOBlGGngZD5lcqiIqcpgAyn2mM4=
X-Google-Smtp-Source: ABdhPJzn7EMs1Itqci9FPcfCt6upEFH2ibkruLV6wZMffSYb9PRpRtA0Cdmdo18qJ8tzhz+H0mO+bfL6S2Reiaq5dhs=
X-Received: by 2002:a2e:86c5:: with SMTP id n5mr213289ljj.450.1605240513968;
 Thu, 12 Nov 2020 20:08:33 -0800 (PST)
MIME-Version: 1.0
References: <20201112221543.3621014-1-guro@fb.com> <20201112221543.3621014-2-guro@fb.com>
 <20201113095632.489e66e2@canb.auug.org.au> <20201113002610.GB2934489@carbon.dhcp.thefacebook.com>
 <20201113030456.drdswcndp65zmt2u@ast-mbp> <20201112191825.1a7c3e0d50cc5e375a4e887c@linux-foundation.org>
 <CAADnVQ+evkBCakrfEUqEvZ2Th=6xUGA2uTzdb_hwpaU9CPdj8Q@mail.gmail.com> <20201112194047.ea7c95e2876931fc57ae1cee@linux-foundation.org>
In-Reply-To: <20201112194047.ea7c95e2876931fc57ae1cee@linux-foundation.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 12 Nov 2020 20:08:22 -0800
Message-ID: <CAADnVQJ43nehf_KHeVFp7Ef2Fzu5xuWj4UMUMAbr+4dAE+qSdg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 01/34] mm: memcontrol: use helpers to read
 page's memcg data
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Roman Gushchin <guro@fb.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 7:40 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 12 Nov 2020 19:25:48 -0800 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Thu, Nov 12, 2020 at 7:18 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > On Thu, 12 Nov 2020 19:04:56 -0800 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >
> > > > On Thu, Nov 12, 2020 at 04:26:10PM -0800, Roman Gushchin wrote:
> > > > >
> > > > > These patches are not intended to be merged through the bpf tree.
> > > > > They are included into the patchset to make bpf selftests pass and for
> > > > > informational purposes.
> > > > > It's written in the cover letter.
> > > > ...
> > > > > Maybe I had to just list their titles in the cover letter. Idk what's
> > > > > the best option for such cross-subsystem dependencies.
> > > >
> > > > We had several situations in the past releases where dependent patches
> > > > were merged into multiple trees. For that to happen cleanly from git pov
> > > > one of the maintainers need to create a stable branch/tag and let other
> > > > maintainers pull that branch into different trees. This way the sha-s
> > > > stay the same and no conflicts arise during the merge window.
> > > > In this case sounds like the first 4 patches are in mm tree already.
> > > > Is there a branch/tag I can pull to get the first 4 into bpf-next?
> > >
> > > Not really, at present.  This is largely by design, although it does cause
> > > this problem once or twice a year.
> > >
> > > These four patches:
> > >
> > > mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
> > > mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
> > > mm-introduce-page-memcg-flags.patch
> > > mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
> > >
> > > are sufficiently reviewed - please pull them into the bpf tree when
> > > convenient.  Once they hit linux-next, I'll drop the -mm copies and the
> > > bpf tree maintainers will then be responsible for whether & when they
> > > get upstream.
> >
> > That's certainly an option if they don't depend on other patches in the mm tree.
> > Roman probably knows best ?
>
> That should be OK.  They apply and compile ;)

Awesome. Thank you both for confirming.
Will take them as soon as the rest of the set is reviewed.
