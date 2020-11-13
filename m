Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1152B14AE
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgKMD0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKMD0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 22:26:01 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C88C0613D1;
        Thu, 12 Nov 2020 19:26:01 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id y16so8961735ljh.0;
        Thu, 12 Nov 2020 19:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U5FpYADtIYALgZoE+kVuMMQ+y3SY9Pf75a4z51dOshs=;
        b=YBelQveZAC0DyHbmZtd7aH+D6mDI2uFaGKR0wNazXzP7elQxXmGYZNu5GpqcxCv1NV
         Vv4IUEYSb5R6ryUq9RiIvP76vkBAxYeRjQ0Ypk38N/xHSW57NFSLq/Aojgc8dc+p8FYl
         oB1JaWleSP5AH5Xx3JcvV5dCFJrWLu4jYCOwrlfOfyArZKAT7sVaNUg+FRVTky7K0N5K
         iXcXIIdofrzc08j8q9MmJqEMs9B60u6gk51Zlx/iZxxhmK2wQrm+KfziUux3Wc0BCMPy
         3y6mAaUaPEqsT3l68zvuHX4KEifPGtJxooPwkfRufL+Jon7YTxVxEG0x2EdUvxAWsOVz
         ENig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U5FpYADtIYALgZoE+kVuMMQ+y3SY9Pf75a4z51dOshs=;
        b=V3zzo9551hIVQQyIojnWYS6ZGp+NLu3CE01ltRHcCwcHfyxz4NdKIGH6xZASOeZxtO
         NZrM9fyae+zFsZeZB2OwKiOl3z3I5ZdcbsXvgGAAJqF8E9gxxMAoFuhIHrguMiA4vp3S
         ltUBH8qJj8ke6Jw3G2Sy7L24dH0B8ot0wKwKuN0DlcbS1/H7xVqlt1aia5gcwMVOX/pE
         iDQOe5/qzZsVFKADLPIz3ibupy/XOYf+uZIwza0f1fJ97eV6ggI6ByF8Xj0N0xIDGu+a
         fspNjM9aVbMAs0G0fiJN5Qxgxs11P4MQeROsZVavm5tKyoaFwf0FLIv5Ng3IXbtV1PEt
         uaaw==
X-Gm-Message-State: AOAM533rz3D2Aef2onJSl4ZCxzQ5uGlfIcGIqUE/NjdB0n+4bFOVyjE+
        /KqhFheATDXWNzmGbWfCKk0IqqCzIBMH4l25gSo=
X-Google-Smtp-Source: ABdhPJzYPzhQebU/TBmdwHHrBYR9QYjxYNHbq+mq/qxiyZoquBpClro2B4t6QDEbfu4QWTzKDOsDA9Mgt+hy27M8Zks=
X-Received: by 2002:a05:651c:1205:: with SMTP id i5mr152605lja.283.1605237959980;
 Thu, 12 Nov 2020 19:25:59 -0800 (PST)
MIME-Version: 1.0
References: <20201112221543.3621014-1-guro@fb.com> <20201112221543.3621014-2-guro@fb.com>
 <20201113095632.489e66e2@canb.auug.org.au> <20201113002610.GB2934489@carbon.dhcp.thefacebook.com>
 <20201113030456.drdswcndp65zmt2u@ast-mbp> <20201112191825.1a7c3e0d50cc5e375a4e887c@linux-foundation.org>
In-Reply-To: <20201112191825.1a7c3e0d50cc5e375a4e887c@linux-foundation.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 12 Nov 2020 19:25:48 -0800
Message-ID: <CAADnVQ+evkBCakrfEUqEvZ2Th=6xUGA2uTzdb_hwpaU9CPdj8Q@mail.gmail.com>
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

On Thu, Nov 12, 2020 at 7:18 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 12 Nov 2020 19:04:56 -0800 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Thu, Nov 12, 2020 at 04:26:10PM -0800, Roman Gushchin wrote:
> > >
> > > These patches are not intended to be merged through the bpf tree.
> > > They are included into the patchset to make bpf selftests pass and for
> > > informational purposes.
> > > It's written in the cover letter.
> > ...
> > > Maybe I had to just list their titles in the cover letter. Idk what's
> > > the best option for such cross-subsystem dependencies.
> >
> > We had several situations in the past releases where dependent patches
> > were merged into multiple trees. For that to happen cleanly from git pov
> > one of the maintainers need to create a stable branch/tag and let other
> > maintainers pull that branch into different trees. This way the sha-s
> > stay the same and no conflicts arise during the merge window.
> > In this case sounds like the first 4 patches are in mm tree already.
> > Is there a branch/tag I can pull to get the first 4 into bpf-next?
>
> Not really, at present.  This is largely by design, although it does cause
> this problem once or twice a year.
>
> These four patches:
>
> mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
> mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
> mm-introduce-page-memcg-flags.patch
> mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch
>
> are sufficiently reviewed - please pull them into the bpf tree when
> convenient.  Once they hit linux-next, I'll drop the -mm copies and the
> bpf tree maintainers will then be responsible for whether & when they
> get upstream.

That's certainly an option if they don't depend on other patches in the mm tree.
Roman probably knows best ?
