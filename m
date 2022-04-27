Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B675123BD
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 22:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbiD0USu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 16:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236780AbiD0USm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 16:18:42 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3174E84EEF;
        Wed, 27 Apr 2022 13:14:40 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id e3so702039ios.6;
        Wed, 27 Apr 2022 13:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ne5W1jl8ZQ5pF6vAj6IUMgGo18NaVhIeguEIXDbd2o8=;
        b=Cn9K5kfzFMXWtUVQxHHAK4sohDP0R2qHINuGY9UbQAzIkJGG4ZZvD+WhwAFaHvmOS6
         Dik70kbgWP060dHwvbvbGaRYeRA+hDd0yfAks5RORwxLDwlEgHq6JW2/ZCiDCrnUVdVs
         CIDxsID+djjG+/IDIopSjc9z3WR2R6Lh88o5eYrCGwjiHeo0dZ/X2Qt5KVF4Z6zVSVQC
         +Z6PC+qYsdUfkH7kVz8rr7iEJKKfLLWO0fy8mJ5FMWKaCiCxw0fE5r2czIBrbgmB9r6p
         +A3AdueFYov+QFv7o3nc1nyPnlgDROfo9gr+tjOJ1dpBiytaf1vHVRRl2jufd8ysxsgB
         q06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ne5W1jl8ZQ5pF6vAj6IUMgGo18NaVhIeguEIXDbd2o8=;
        b=XGCK+gA0rfLQMTB72LQChtBjisP+nc7Q2SQoQtQxwWkyOe/NPgS96/TCuaTgdSzH8T
         AEAjQv1gpjgNpqasEO211oRKFMpd9JtdB1ZmmIdQsZ2Uc+RKL8XsdpztY0cO0V8AnS0Z
         EQMEy6TqGhKef6bcMLez4swwiRrItu0qwlZ75gmMUBKD+i/vkmDqvRmW2gl8oldN7TPy
         lb4Zly9byzDjw+7B9fke1orVVIantTeWHPMQFautMSNrmGYFrNYyy9eMSzzwaZVelKt1
         EkSnhlbc3spoPIHwsyfKOG/alRvbdlYfQ22Paezx446eGTt2fKcTB8c2crTuXTDk5X30
         /hzg==
X-Gm-Message-State: AOAM532epgnhbgQdajJyCWRyF8IRQBx9FzPd5zAsIAqx3Wwb+DVH6y4V
        6fqNamdUd2SMk6v0/63e2EvVjHj2zqWkLD5KFpc=
X-Google-Smtp-Source: ABdhPJyCkFKMqugLmtpKdYimmeczmgI4swW4aDz397PE29zY+Ay5aOtGoqczSMeJ3qQRo3MpXAdJsmKPWPmP4zRsBXg=
X-Received: by 2002:a05:6638:16c9:b0:328:5569:fe94 with SMTP id
 g9-20020a05663816c900b003285569fe94mr13309490jat.145.1651090479611; Wed, 27
 Apr 2022 13:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220425184149.1173545-1-ctakshak@fb.com> <20220425184149.1173545-2-ctakshak@fb.com>
In-Reply-To: <20220425184149.1173545-2-ctakshak@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 13:14:28 -0700
Message-ID: <CAEf4BzYp=cjjq2q0LN-ePYADtL0-J_EnbnAJoPGwKYKXX2JjWw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/2] selftests/bpf: handle batch operations
 for map-in-map bpf-maps
To:     Takshak Chahande <ctakshak@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, ndixit@fb.com,
        Martin Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 11:42 AM Takshak Chahande <ctakshak@fb.com> wrote:
>
> This patch adds up test cases that handles 4 combinations:
> a) outer map: BPF_MAP_TYPE_ARRAY_OF_MAPS
>    inner maps: BPF_MAP_TYPE_ARRAY and BPF_MAP_TYPE_HASH
> b) outer map: BPF_MAP_TYPE_HASH_OF_MAPS
>    inner maps: BPF_MAP_TYPE_ARRAY and BPF_MAP_TYPE_HASH
>
> v2->v3:
> - Handled transient ENOSPC correctly, bug was found in BPF CI (Daniel)
>
> v1->v2:
> - Fixed no format arguments error (Andrii)
>
> Signed-off-by: Takshak Chahande <ctakshak@fb.com>
> ---

Is there any extra benefit in putting these test under test_maps
instead of test_progs? test_progs has better "testing infra", it's
easier to isolate and debug tests, skip them or run just the ones you
want, better logging, better ASSERT_xxx() macros for testing, etc.

I see that you create a fixed amount of inner maps, etc. It's all
actually simpler to do in test_progs using BPF-side code. See other
examples under progs/ that show how to create and initialize
map-in-maps.


>  .../bpf/map_tests/map_in_map_batch_ops.c      | 239 ++++++++++++++++++
>  1 file changed, 239 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c
>

[...]

> +static int create_outer_map(enum bpf_map_type map_type, __u32 inner_map_fd)
> +{
> +       int outer_map_fd;
> +
> +       LIBBPF_OPTS(bpf_map_create_opts, attr);

LIBBPF_OPTS() is declaring a variable, it should go together with
other variables

> +       attr.inner_map_fd = inner_map_fd;
> +       outer_map_fd = bpf_map_create(map_type, "outer_map", sizeof(__u32),
> +                                     sizeof(__u32), OUTER_MAP_ENTRIES,
> +                                     &attr);
> +       CHECK(outer_map_fd < 0,
> +             "outer bpf_map_create()",
> +             "map_type=(%d), error:%s\n",
> +             map_type, strerror(errno));
> +
> +       return outer_map_fd;
> +}
> +

[...]

> +static void _map_in_map_batch_ops(enum bpf_map_type outer_map_type,
> +                                 enum bpf_map_type inner_map_type)
> +{
> +       __u32 *outer_map_keys, *inner_map_fds;
> +       __u32 max_entries = OUTER_MAP_ENTRIES;
> +       __u32 value_size = sizeof(__u32);
> +       int batch_size[2] = {5, 10};
> +       __u32 map_index, op_index;
> +       int outer_map_fd, ret;
> +       DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,

nit: prefere shorter LIBBPF_OPTS(). as for zero initialization of
elem_flags and flags, they are zero-initialized by default by
LIBBPF_OPTS, so you can just drop two lines below

> +                           .elem_flags = 0,
> +                           .flags = 0,
> +       );
> +
> +       outer_map_keys = calloc(max_entries, value_size);
> +       inner_map_fds = calloc(max_entries, value_size);
> +       create_inner_maps(inner_map_type, inner_map_fds);
> +

[...]
