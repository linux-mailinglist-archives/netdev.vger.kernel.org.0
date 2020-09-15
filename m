Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD8F26B030
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgIOWEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgIOWD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:03:28 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A900C061788
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 15:03:17 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id g72so6029017qke.8
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 15:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lImUIif1n8cBB0bKcX9LH+MkHbSgbzjwXMS0j6OhnaE=;
        b=IFrtkdnH6jjt1bb2TOXNW8Q0T3RI6vk9C9kqInbxvF2qhQESPdggFaza8Nykc2PDLN
         x5Nz7+Aw3222BMiUTy3t6b8uhpUf+y0HrdpGAe8NojsRGFGeTakA1Xu2E8f4DGSJxfuJ
         y89rn20nSjWH8gVy1xGtoCDVtMOEdsv6Tnq8oOVlDq1Jy5/ZDsYRTHOdOmeqX1KrhNzd
         UmUc8Axcv0ldSx58qKRp3CL2cNghLX5/AB0v6zvF2aXumCokSB6P7R3mYGrEw73xRuXz
         NLAvB4jZh+/721TP5tDagpfWi+EqGAoXVOZXntcNgMSO3ZInii4XrxuyKtLr57r61sVt
         l1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lImUIif1n8cBB0bKcX9LH+MkHbSgbzjwXMS0j6OhnaE=;
        b=Gozo4rQ1p20zKJ133fMe0IIrCmTUWgG8I5OFCHIuO/OHa4k+3MgWcVDawEwc9BwxaZ
         ll9F08kh0B2fgbVjxr2NZgHVtoyUUC32sG4hdfN2GWVwa6wjFDQEIErZ2mD0XP+pvAbK
         0qxC4SU8X8vvmymqNWSiY/AuLBtDr9eMdiXfo7+GuKi1lZCACLu/nD/dG/GYcsVuv1cV
         KovrIQcgEpPyzS9UV9VNwrveWGyM6pPxHWVKG+3zum39jOEDGdD5oSpkv6eXRUYAes3g
         WgG7kkZwRm4qWkbMsEkb/+JfXdZRU7vp5bDWB4lqyvKTDoJd7io1mZjoULbvF3YHtqTf
         NEvA==
X-Gm-Message-State: AOAM530yqhiKOyfL02vz69n4hwgDD33fIKH794/fUWk3kbXx/l8koEyw
        MuGJKEow+nR5mEql6B9qZLSk750pMD+Gwf97SH2Ub4Kw9x4=
X-Google-Smtp-Source: ABdhPJxVnBBDB4MLjqFZ0gEG1oDU1Hdb4YInmJJoSXBz+1UjcNfRKHK7sQ5xVjQPOfA7quLfVZUeqg3k2/du3pWj/Ko=
X-Received: by 2002:a37:6248:: with SMTP id w69mr18906009qkb.448.1600207396118;
 Tue, 15 Sep 2020 15:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200914183615.2038347-1-sdf@google.com> <20200914183615.2038347-4-sdf@google.com>
 <CAEf4BzbW46kyE3pVm1fGXkXV+ZW9ScoYAGdMuTkgCNHP-dpiuQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbW46kyE3pVm1fGXkXV+ZW9ScoYAGdMuTkgCNHP-dpiuQ@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 15 Sep 2020 15:03:05 -0700
Message-ID: <CAKH8qBvY-0Qb+x3czVgwFyBWuDS8eLfQVaLmD8V7W7pWhv5DQg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/5] libbpf: Add BPF_PROG_BIND_MAP syscall and
 use it on .rodata section
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 4:28 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Sep 14, 2020 at 11:37 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > +       if (!kernel_supports(FEAT_GLOBAL_DATA))
> > +               return 0;
>
> TBH, I don't think this check is needed, and it's actually coupling
> two independent features together. probe_prog_bind_map() probes
> PROG_BIND_MAP, it has nothing to do with global data itself. It's all
> cached now, so there is no problem with that, it just feels unclean.
> If someone is using .rodata and the kernel doesn't support global
> data, we'll fail way sooner. On the other hand, if there will be
> another use case where PROG_BIND_MAP is needed for something else, why
> would we care about global data support? I know that in the real world
> it will be hard to find a kernel with PROG_BIND_MAP and no global data
> support, due to the latter being so much older, but still, unnecessary
> coupling.
>
> Would be nice to follow up and remove this, thanks.
Agreed, will respin, thanks!
