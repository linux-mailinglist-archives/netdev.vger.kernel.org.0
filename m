Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685815A1E7E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 04:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244667AbiHZCDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 22:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244651AbiHZCDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 22:03:18 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2983CAC83;
        Thu, 25 Aug 2022 19:03:16 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id m1so457346edb.7;
        Thu, 25 Aug 2022 19:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9EgT7+sSPiTYWPr9b+oWvfezXK6YiJhJIgl4/Hn+Ap4=;
        b=RrW3j1im3HWeri6Mix5m5sujVq1KbzucVZSMIDVaZ2jLd29swg40n944O42CYvcV4W
         lf25TUd/2XbOXaPoRH1HKwmdq0I/SPVsed7dpauPnYwTX8xHigXNogkPk1jCj04WCp8m
         Msd6zQUekVgHR8MdQzqotsEq03k8mqke09VW+0SuIUYftuvGGOZ/zgdsPJ8+UCAU5s0H
         Y/OfsTkbLVVn4Ck0F9+dyURwu+zYQwuu/NjmVy+mN0gd9nu2QUvK9eTphHU+QYR77Qoc
         h0c3YCkg8+oMpefiqr7zUg8VqYo3Bot4h/0gEHuhSHB9NdboeVfYVp6lAtAF3L4j8Rwj
         8FrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9EgT7+sSPiTYWPr9b+oWvfezXK6YiJhJIgl4/Hn+Ap4=;
        b=IXRR+DJaTyQvFNScEdZHUTB1HRdlzd8BQfF9Oo2coqM/569BSXapeIK8DE3oTpFFNd
         km8/f4rletoZNiEdHK1fCAbP1NRIBPtWBz+Egn+ezDQjLID0OJ6Z7LWWT+3Oyv0+pYgd
         lWTVZuSKKk8+M34lXOi4U57lRV3mFDavfjlK/7pL7bn2gFTvE06CHl8CJ1GEs+1sJqIP
         OQjik+QmileAVgN4kYvg6KCWO/3RlBI1ys2R8Iorf0LsZ6/c7tupfc/d2j1z329wiSdV
         /rakgPV+X3PRJPVOO/oi/1664gSMDlFeLZjzihPFWdfvRBnR20y9IPs8M6XM7WlKNwGv
         3XQQ==
X-Gm-Message-State: ACgBeo1BOIv+mrAC8VMTw/I4f1LRmejPIyzJqRirO2s3b2GORJXwHV8n
        IBs4tJl7fz2Fkx/NSktIDBDuVCpEsGo5kXhUBII=
X-Google-Smtp-Source: AA6agR5XguDIy9h+0nX1vI83YX7Vk1ZKTHuVBeVEsTLmmLXy/Zx4Q/WlaZogfq3iro5Mx+6Atm+nzhDptIs36y5ve2Q=
X-Received: by 2002:aa7:df01:0:b0:445:f7b3:cd4 with SMTP id
 c1-20020aa7df01000000b00445f7b30cd4mr5119924edy.232.1661479395460; Thu, 25
 Aug 2022 19:03:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220825213905.1817722-1-haoluo@google.com> <CAEf4BzaQOj3QqEbKKXhgUmWMF3gef-8+a-dYoe_t4=g+cM2KaQ@mail.gmail.com>
 <CAJD7tkZAE_Kx9z2cXnrheFfEtSZJn4VFczhkVEb3VdcP2o_H+g@mail.gmail.com>
In-Reply-To: <CAJD7tkZAE_Kx9z2cXnrheFfEtSZJn4VFczhkVEb3VdcP2o_H+g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 25 Aug 2022 19:03:04 -0700
Message-ID: <CAEf4BzbMUNo6gj+DJcnvixiMoVr-LX9JZuJbe0Txp71sZJ_F=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] Add CGROUP prefix to cgroup_iter_order
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Hao Luo <haoluo@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 4:20 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Thu, Aug 25, 2022 at 2:56 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Aug 25, 2022 at 2:39 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > As suggested by Andrii, add 'CGROUP' to cgroup_iter_order. This fix is
> > > divided into two patches. Patch 1/2 fixes the commit that introduced
> > > cgroup_iter. Patch 2/2 fixes the selftest that uses the
> > > cgroup_iter_order. This is because the selftest was introduced in a
> >
> > but if you split rename into two patches, you break selftests build
> > and thus potentially bisectability of selftests regressions. So I
> > think you have to keep both in the same patch.
>
> I thought fixes to commits still in bpf-next would get squashed. Would
> you mind elaborating why we don't do this?
>

We don't amend follow up fixes into original commits and preserve history.

> >
> > With that:
> >
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> >
> > > different commit. I tested this patchset via the following command:
> > >
> > >   test_progs -t cgroup,iter,btf_dump
> > >
> > > Hao Luo (2):
> > >   bpf: Add CGROUP to cgroup_iter order
> > >   selftests/bpf: Fix test that uses cgroup_iter order
> > >
> > >  include/uapi/linux/bpf.h                      | 10 +++---
> > >  kernel/bpf/cgroup_iter.c                      | 32 +++++++++----------
> > >  tools/include/uapi/linux/bpf.h                | 10 +++---
> > >  .../selftests/bpf/prog_tests/btf_dump.c       |  2 +-
> > >  .../prog_tests/cgroup_hierarchical_stats.c    |  2 +-
> > >  .../selftests/bpf/prog_tests/cgroup_iter.c    | 10 +++---
> > >  6 files changed, 33 insertions(+), 33 deletions(-)
> > >
> > > --
> > > 2.37.2.672.g94769d06f0-goog
> > >
