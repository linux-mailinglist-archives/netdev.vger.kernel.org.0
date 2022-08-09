Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E366E58D151
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 02:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244714AbiHIAUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 20:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244705AbiHIAUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 20:20:39 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21D525CF;
        Mon,  8 Aug 2022 17:20:37 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id k26so19541547ejx.5;
        Mon, 08 Aug 2022 17:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=nIlY/B2wpUmWSlONORtqotpuUOicf3PK4NcK3e+GsKw=;
        b=pVVUE/R4uaOiN+usJ5CgWlkbEXNcClHan/YNXEPQ45K7vuwJoOACk+2hUJacb5TGP4
         90nRnnsAEtIYt77hdhjrD5auMoEJUTOID6+tRdgR2VglgFBDhmoBbW+9kj4RyIMBJ2oW
         c4UKjvE0JJPZhfp/C1DfGPXeq4geRk+tWz35S6nyhtOc/wfKG7DtVg/lwBtvpU8Mp2oV
         3LQeuxK5aIVA5zDri8hUqz7oL2JwUeS7LCcTRUwtgbUFldrcP2vhn4+3ByKwStosQj6P
         uiACrsbCdP+rMGdPtAm/IIxEao8A+AP4t8hUgWnIGv6Ftdt/C7e0edmbJQzOhyUNTtp1
         dA+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=nIlY/B2wpUmWSlONORtqotpuUOicf3PK4NcK3e+GsKw=;
        b=wS0qFXgViyK6d0Yghj7+K/kuMB3VMGfimyTZT339v/KngovLqOfbn9uD5fIAnyMaOW
         +dla7hslyOpZMZKukvmzLqAhz2I1pbXhxDiLKh7mzbhJrgcZOjGF6hAYTqYcaF3IsMOd
         hNo922XtutaMJ231rC3wp1yg0pZXwA7xNFOq22tXfTAaaBXhFQS0ibxim7e7F5hoQICG
         xiMndtVUn0Nl64oyCMl3oVG0dFjGd530vXoAHW6F+YsS7QU9eDj98a5cmauq3t0rZf7y
         yjYYKdaz9puhQ3WNut56XFi/eCup4PTaevZyQLZ1pUz3M4JjO8jIU8To5Gkx81qxZbwv
         Ofgw==
X-Gm-Message-State: ACgBeo2XiUYpgGO+Pdy0bxJssqSBpSrBGGND+vM5OX+40GIeASMm88U/
        upBFm8om4wFm0Bg1BZ/5UtDDmlmlXQsrV3W7tvw=
X-Google-Smtp-Source: AA6agR7YW0sk/drWrEDcW1dQ6HauykrXclm23T5l1Pz9QmsGKYI+5EiztmO1uirVj/3nyGU333I70TjBkwGbTlgq84c=
X-Received: by 2002:a17:907:6890:b0:731:41a9:bb03 with SMTP id
 qy16-20020a170907689000b0073141a9bb03mr6899544ejc.302.1660004436238; Mon, 08
 Aug 2022 17:20:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220805214821.1058337-1-haoluo@google.com> <20220805214821.1058337-6-haoluo@google.com>
In-Reply-To: <20220805214821.1058337-6-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Aug 2022 17:20:25 -0700
Message-ID: <CAEf4BzarAHuR7mOeHToNiNMc03QnR=74cxt_h5LRymf1U6HevQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 5/8] selftests/bpf: Test cgroup_iter.
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
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

On Fri, Aug 5, 2022 at 2:49 PM Hao Luo <haoluo@google.com> wrote:
>
> Add a selftest for cgroup_iter. The selftest creates a mini cgroup tree
> of the following structure:
>
>     ROOT (working cgroup)
>      |
>    PARENT
>   /      \
> CHILD1  CHILD2
>
> and tests the following scenarios:
>
>  - invalid cgroup fd.
>  - pre-order walk over descendants from PARENT.
>  - post-order walk over descendants from PARENT.
>  - walk of ancestors from PARENT.
>  - walk from PARENT in the default order, which is pre-order.
>  - process only a single object (i.e. PARENT).
>  - early termination.
>
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../selftests/bpf/prog_tests/cgroup_iter.c    | 237 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
>  .../testing/selftests/bpf/progs/cgroup_iter.c |  39 +++
>  3 files changed, 283 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c
>

[...]
