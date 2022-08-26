Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7535A1E84
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 04:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244715AbiHZCFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 22:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244687AbiHZCFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 22:05:20 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E37BB015
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 19:05:18 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e20so132052wri.13
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 19:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Kzixri34zypG42ufXkKog0/vGiEDa4wFdROo3hsMZ/I=;
        b=Qf1dx/wjrJ5w+gBl9YpLh+MGBOaHIqba8h2ReNzk5Iw9C/ioKt0zwxnw4HpuyVKWZ0
         ACuuzxk/Ifn982l6uN/T+CISfy7JW0V01msa/MQK4g2ij4HSK9sVosgNuYV0KZsvcYuG
         evyM5usTgCmfVcXQNLx4wbI7Nurz0r7g2qtdG57zf0rQsNoLaIaL+YUnDzFxFHmHa0bD
         io2Nq1FMQ+UmYeWk+uPsDtaycgz6qgOrMzLzgyS2BD5DDHtsxmZBvqiXHXwNbMKA8/af
         tzdfNDJlmh6B/0NAE2DSb2jYCrbFVEYR5QDx52z9xGeufUxGBuBiy25vgGCeh37FVSsv
         M6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Kzixri34zypG42ufXkKog0/vGiEDa4wFdROo3hsMZ/I=;
        b=d9wKnFSjtIJeoeKGSUWwTokLMyVdjZrH9/48i2bhgAZ6bYNdhuUZRKBTVU7tUhrZku
         rv4BPIPsBOtCYFf70b4IHJiig130v4+AVxvRoohi5lS0d4mHba9cOYVFBPvre/N045cH
         pNyxu84vtBhO8elUl4617n7qcKig7gSSh7QAOUuVBtL4TTj7STAbomW37kMV3l7o/3Yn
         pWeIypjJtSB1APag4uupcZduKYa0qjPDDATISA59+pQJZsAvitw+vag0mv9tWGTeeVkY
         djVl8gmGJpe0rkP11x117t/kyqvRc5STvfBM8HWzW8WacYQpheOzEZqnwqy8RixPMT4f
         OmfA==
X-Gm-Message-State: ACgBeo0Sf0bD1fm5+tiyRGeJB1ccuj3XoSZ424KdJazq0uh285eoRa0B
        xlpjODY+nm1RPF6axy9iKaMiZpVaUKRU1WPZtNFVzA==
X-Google-Smtp-Source: AA6agR4Ugwz397FI+I8x41LSLn8JIR47ZZMDM2UyhPLb74Ha1bezzv8NYyzzY+3+TInTJK5pDILVQNdolvy37VNbY8Q=
X-Received: by 2002:a5d:6d0c:0:b0:225:4ff9:7e67 with SMTP id
 e12-20020a5d6d0c000000b002254ff97e67mr3663872wrq.534.1661479516896; Thu, 25
 Aug 2022 19:05:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220825213905.1817722-1-haoluo@google.com> <CAEf4BzaQOj3QqEbKKXhgUmWMF3gef-8+a-dYoe_t4=g+cM2KaQ@mail.gmail.com>
 <CAJD7tkZAE_Kx9z2cXnrheFfEtSZJn4VFczhkVEb3VdcP2o_H+g@mail.gmail.com> <CAEf4BzbMUNo6gj+DJcnvixiMoVr-LX9JZuJbe0Txp71sZJ_F=g@mail.gmail.com>
In-Reply-To: <CAEf4BzbMUNo6gj+DJcnvixiMoVr-LX9JZuJbe0Txp71sZJ_F=g@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Thu, 25 Aug 2022 19:04:40 -0700
Message-ID: <CAJD7tkaRiG-ntPKvpy+9g7Rj+c5TF-EcsaaKH4dfVAV=1rdKFQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] Add CGROUP prefix to cgroup_iter_order
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 7:03 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Aug 25, 2022 at 4:20 PM Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > On Thu, Aug 25, 2022 at 2:56 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Thu, Aug 25, 2022 at 2:39 PM Hao Luo <haoluo@google.com> wrote:
> > > >
> > > > As suggested by Andrii, add 'CGROUP' to cgroup_iter_order. This fix is
> > > > divided into two patches. Patch 1/2 fixes the commit that introduced
> > > > cgroup_iter. Patch 2/2 fixes the selftest that uses the
> > > > cgroup_iter_order. This is because the selftest was introduced in a
> > >
> > > but if you split rename into two patches, you break selftests build
> > > and thus potentially bisectability of selftests regressions. So I
> > > think you have to keep both in the same patch.
> >
> > I thought fixes to commits still in bpf-next would get squashed. Would
> > you mind elaborating why we don't do this?
> >
>
> We don't amend follow up fixes into original commits and preserve history.

Got it. Thanks Andrii.

>
> > >
> > > With that:
> > >
> > > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> > >
> > > > different commit. I tested this patchset via the following command:
> > > >
> > > >   test_progs -t cgroup,iter,btf_dump
> > > >
> > > > Hao Luo (2):
> > > >   bpf: Add CGROUP to cgroup_iter order
> > > >   selftests/bpf: Fix test that uses cgroup_iter order
> > > >
> > > >  include/uapi/linux/bpf.h                      | 10 +++---
> > > >  kernel/bpf/cgroup_iter.c                      | 32 +++++++++----------
> > > >  tools/include/uapi/linux/bpf.h                | 10 +++---
> > > >  .../selftests/bpf/prog_tests/btf_dump.c       |  2 +-
> > > >  .../prog_tests/cgroup_hierarchical_stats.c    |  2 +-
> > > >  .../selftests/bpf/prog_tests/cgroup_iter.c    | 10 +++---
> > > >  6 files changed, 33 insertions(+), 33 deletions(-)
> > > >
> > > > --
> > > > 2.37.2.672.g94769d06f0-goog
> > > >
