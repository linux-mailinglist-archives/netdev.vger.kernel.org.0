Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114602B1D4E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 15:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgKMO0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 09:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgKMO0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 09:26:08 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134A1C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 06:26:08 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id r17so10875244ljg.5
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 06:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ln2GRUjVpnDT7Mk6GOzURXdFa3B/qNPKtgBr91rF3Y8=;
        b=tBEUGg9mecjA80Anvmx5G0cnS3JhF+nrBAgNq8A7GEABsExzx8u7CEy1tE7KB673Ob
         0D8D0KxoBWNju8L7t2wh0WQmIgOD5kNLR28B+TMsRYAFxujTKUhOA8BE17PdrEaOZrTV
         HOkHak+nfp0rmg81FkGTT6TulZ7Fwpx2QWwoMT1dPgKGK396xpO55OmiOqsm4P6tc3D2
         FPCfHVkq8JieYeEGg7McqGQWUuf+0caHRsX6IJS9hGkp+MxTzsaSwX51E0o/vgCYkWR/
         A1oNWf2GG0eKp2EAySUL4ewDqMKyA3xIs5jNX23DlffWOm00az+YbVSHheYyIPAUoFlB
         DPHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ln2GRUjVpnDT7Mk6GOzURXdFa3B/qNPKtgBr91rF3Y8=;
        b=S2GQDjNklrTIG5GR04pH9EeKqahtOo1p21ViAYvoWa++fdKl7WUpy/MSF09UPnAAtb
         LMHiciMfisUpVc/ODzrM6JmTEbfiS7utWPa87h+NO/O7hvSf1FGVw9xtjmfMDS3J1NXv
         hmfumuyDttSHBSmoaG0a8YxcQPAvSEF5wz8/GMwqAW3AYX7M/m15Var81qbTENQTkjZa
         HqwipYtbVNkcB/qSIH09JvWhwDgfHecIVSs+CJ/NVqg+rjbvll/5nAhT//J5wtscC9dX
         nIuH6Ea2IKOSqxgeZzP0bwpfzpejO1acLo7zT2hmqByX0VX/UczyENXcUS56GYp2lae8
         fYmQ==
X-Gm-Message-State: AOAM5322lCHimxrd8U9Qcp1sCy2DHE4ATPTrj2rsKmHlmKcJia58MyYu
        MtJx+gL5MOPQbqkQRAmQbAoW+R1OGJrgjTyyDmPg7A==
X-Google-Smtp-Source: ABdhPJwkPUF84yhwtEnH94fDYeqbMfMK/HGN5BYBm0wdW+/BUUCDcuunRtEs6TRfAqG8/TsftGMFH2eLdYT8KvwO1u4=
X-Received: by 2002:a2e:240e:: with SMTP id k14mr1220850ljk.332.1605277565218;
 Fri, 13 Nov 2020 06:26:05 -0800 (PST)
MIME-Version: 1.0
References: <20201112221543.3621014-1-guro@fb.com> <20201112221543.3621014-2-guro@fb.com>
 <20201113095632.489e66e2@canb.auug.org.au> <20201113002610.GB2934489@carbon.dhcp.thefacebook.com>
 <20201113030456.drdswcndp65zmt2u@ast-mbp> <20201112191825.1a7c3e0d50cc5e375a4e887c@linux-foundation.org>
 <CAADnVQ+evkBCakrfEUqEvZ2Th=6xUGA2uTzdb_hwpaU9CPdj8Q@mail.gmail.com> <20201113040151.GA2955309@carbon.dhcp.thefacebook.com>
In-Reply-To: <20201113040151.GA2955309@carbon.dhcp.thefacebook.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Fri, 13 Nov 2020 06:25:53 -0800
Message-ID: <CALvZod5QtfNgtoTq2owEDvnEG4EfciNo14QYkdhembo9783nCA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 01/34] mm: memcontrol: use helpers to read
 page's memcg data
To:     Roman Gushchin <guro@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 8:02 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Thu, Nov 12, 2020 at 07:25:48PM -0800, Alexei Starovoitov wrote:
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
> Yes, they are self-contained and don't depend on any patches in the mm tree.
>

The patch "mm, kvm: account kvm_vcpu_mmap to kmemcg" in mm tree
depends on that series.
