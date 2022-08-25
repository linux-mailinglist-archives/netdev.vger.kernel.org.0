Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25F85A1D05
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243882AbiHYXUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243473AbiHYXUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:20:12 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B9B26AF7
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 16:20:11 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id d5so12442wms.5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 16:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=euDQ0vrJp+rShUuElD29thuo7rdwKdtGzimujeCiDFg=;
        b=ju5G5j7otQhLMteRP/Idhs1jAjG0AYp12tWnPcydd2V403pxSI21Q9Y9iYcDfXEPOx
         np6rBXiJHgm3cOhRelYZnMbVZyfXPNyqJXdi4iB+A3iHiMGqMLu/6lujyauQdpfxxi+K
         xjPgRz0c/1jPgqoehKIBmC7NzT8o5BX8zArrRrKbdxi1PPKu53pNOjBqhsWjKvbZVhbi
         xOWSZ7uSf6lL7UWRKGfDkHCwAZF+oL0cnqIJrsPD0h+0tk/0tD0KiHxpp5Zgashp8Z4q
         lxqrQJA+qqXO6oIW9tPAgt+KCZhLY6Oe/4tbzOzWZBNwKd81qmVd5LqQp+/qAfd8VwQW
         vr/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=euDQ0vrJp+rShUuElD29thuo7rdwKdtGzimujeCiDFg=;
        b=jMnD96i0do3EK/VlhPretGx/Bcs8QBAuFIRrFn4BbpGlPRdGM0msSmUo1DU2WNfI1a
         z8UwiNvjAAOjnUjOu3GrW+apDb8bx/AfjaRguaFTI3a3PnMAOQdAUJwsU+2tyOy4JgBE
         Qi4oMMW7+oBDrFVP6C2yX5v/ROao7w+rbBka1rTfm7e6DAhzOkMPBap/4evU4RmkE+1w
         XW8G6M/PcBqeDr99SevaWK8AlraEPUll4SCxn45MhWCdVGkSJtdDAlBKnFOsZtChtqBI
         Qsn+BTKd/ttnt/acAqE/iHa21h7GGAiVeMh6uIvmTEt9jvd38OR3+zDGlNehXR46Rzt8
         tKGQ==
X-Gm-Message-State: ACgBeo19CqUzchB0Agr3zx/Mv5aSbjPBw/Ps+hg/Cr/BX0A785f0c5XL
        dE/H8H8y2yYEd+MV6CS58ZUMQCyCJPZod5SLuWo8Vw==
X-Google-Smtp-Source: AA6agR4uguH//xHSLQkoIAgbNbmZpzII5tdUKt1kz7y7Q68TP3XJkF0V9wf4YTtVxdsZIEZ4pjk+3BWGpT4ldDuXm0Y=
X-Received: by 2002:a05:600c:224c:b0:3a6:7234:551 with SMTP id
 a12-20020a05600c224c00b003a672340551mr3532845wmm.27.1661469609514; Thu, 25
 Aug 2022 16:20:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220825213905.1817722-1-haoluo@google.com> <CAEf4BzaQOj3QqEbKKXhgUmWMF3gef-8+a-dYoe_t4=g+cM2KaQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaQOj3QqEbKKXhgUmWMF3gef-8+a-dYoe_t4=g+cM2KaQ@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Thu, 25 Aug 2022 16:19:33 -0700
Message-ID: <CAJD7tkZAE_Kx9z2cXnrheFfEtSZJn4VFczhkVEb3VdcP2o_H+g@mail.gmail.com>
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

On Thu, Aug 25, 2022 at 2:56 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Aug 25, 2022 at 2:39 PM Hao Luo <haoluo@google.com> wrote:
> >
> > As suggested by Andrii, add 'CGROUP' to cgroup_iter_order. This fix is
> > divided into two patches. Patch 1/2 fixes the commit that introduced
> > cgroup_iter. Patch 2/2 fixes the selftest that uses the
> > cgroup_iter_order. This is because the selftest was introduced in a
>
> but if you split rename into two patches, you break selftests build
> and thus potentially bisectability of selftests regressions. So I
> think you have to keep both in the same patch.

I thought fixes to commits still in bpf-next would get squashed. Would
you mind elaborating why we don't do this?

>
> With that:
>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
>
> > different commit. I tested this patchset via the following command:
> >
> >   test_progs -t cgroup,iter,btf_dump
> >
> > Hao Luo (2):
> >   bpf: Add CGROUP to cgroup_iter order
> >   selftests/bpf: Fix test that uses cgroup_iter order
> >
> >  include/uapi/linux/bpf.h                      | 10 +++---
> >  kernel/bpf/cgroup_iter.c                      | 32 +++++++++----------
> >  tools/include/uapi/linux/bpf.h                | 10 +++---
> >  .../selftests/bpf/prog_tests/btf_dump.c       |  2 +-
> >  .../prog_tests/cgroup_hierarchical_stats.c    |  2 +-
> >  .../selftests/bpf/prog_tests/cgroup_iter.c    | 10 +++---
> >  6 files changed, 33 insertions(+), 33 deletions(-)
> >
> > --
> > 2.37.2.672.g94769d06f0-goog
> >
