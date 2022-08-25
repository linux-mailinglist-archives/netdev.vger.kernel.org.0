Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5FA5A1BD6
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241418AbiHYWAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244048AbiHYWAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:00:49 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A585070F
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 15:00:47 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id s1so2076346qvn.11
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 15:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=pZQ/2nHQhIrhPnU1bKwTlnrZA3djIkob/YiqxMhnkcg=;
        b=mAdzoUW7wW6FM0q0jbONT8uA9l3acX/GFHpJ7wC6WDxytlS0wUPjpaO4famr4o6UGI
         bRb7F3jg1uTrWwJkvILebhbpdBg1kwY8Y4GY1zaNauGK7UZ0WtYg76kz9OxYmQ1y/p24
         jE+mSSjJCthamtLl8RK3mgfcNE9Ri9yEuMGDJr/9jPm8NrkDcOCYXQEP2+Z/EEoO+lcD
         npjYu58k2kZ/rDc0WXISd/Hqpc69fiMaHu9gC9mefIdF6UB/RJbA9gKRVpO/SnanWqKF
         jkI11Vue+dQ0K3za7FLXgIm8E+oOsfrgmcGEOYBgAkyuy4+HL49apMopNpTMFkLJJrDi
         afbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=pZQ/2nHQhIrhPnU1bKwTlnrZA3djIkob/YiqxMhnkcg=;
        b=jPD3CgmJHhotAiTBxexiiRIUyoiIwSr5+cruYq+J1uQCuCTwE7nZVwkY0SrOnnlAOP
         +O0I84UbubgU8+Nk4/ElTOdJVz9xtgCB3cg1JLH6paRygUqeOcAyjGVL25cGrLpXJLlm
         iFNBV5atdeJc2D911d+G5OU5nRUUlWT5m0UOfvio1bNo7Lu7g93oslGUZeWm3M5YBsEv
         TQxT4bGaXScds6b7fnpZ7MGiAjNIBfDEHcQrAtaiDoUxLszdGvoqEdVzJWv7Nkl8Csbn
         dmfLnOog8tEiHTxVowar3CVzQvu3GNLHwyZs9z5+BYUcX2/3lyc0cl90Y4xJq1bbyNwi
         fxdA==
X-Gm-Message-State: ACgBeo1zhhC4NKEphNt37Uj33V8qpV/IbvZ//UnjDI8FyRNd+ozV3qEx
        Vrf6dEkEZ2mBivI3ZYkEYGgo1Zx1yjDuTC9I9Qhk+a2zuE3GXw==
X-Google-Smtp-Source: AA6agR6XGAhoPsEzWX90e7VRQZdeYxFMQQX4NeTgsf+duYJt3Y7B9gdEI/cnVtfnEfrD3kJVO1DJUXmAHc0T+c4Bkpw=
X-Received: by 2002:a0c:b31a:0:b0:473:8062:b1b4 with SMTP id
 s26-20020a0cb31a000000b004738062b1b4mr5569946qve.85.1661464847009; Thu, 25
 Aug 2022 15:00:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220825213905.1817722-1-haoluo@google.com> <CAEf4BzaQOj3QqEbKKXhgUmWMF3gef-8+a-dYoe_t4=g+cM2KaQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaQOj3QqEbKKXhgUmWMF3gef-8+a-dYoe_t4=g+cM2KaQ@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Thu, 25 Aug 2022 15:00:36 -0700
Message-ID: <CA+khW7j-OZmr3ax03CwRvtyvEMYafaWPfkiwLRe2HQcPscWkug@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] Add CGROUP prefix to cgroup_iter_order
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
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
>
> With that:
>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
>

Yeah. I wasn't sure what to do. Then we need bundle this fix with
those two commits together. Will squash the commits into one and send
a v2.

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
