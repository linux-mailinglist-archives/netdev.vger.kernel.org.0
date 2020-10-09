Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B2B2890BC
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390400AbgJISZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731198AbgJISZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:25:45 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652B7C0613D2;
        Fri,  9 Oct 2020 11:25:45 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id n142so7935191ybf.7;
        Fri, 09 Oct 2020 11:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w3/V6yYsXysnNEFkgRPOGNYEt9gqSHP3Qv8pHd7z8Qk=;
        b=RaQdeI5DQhI8g2OSPSu/tKAN/N1NdbHZUE99pa2rYvW7NXP7eemMRpxFFHrhofsjgO
         scfmFP66S2N4M/7yqNXAHfpLRDyxxxhk0O4rLcab/v1+jngA5txF2YfiF5VfmxooYgN4
         +hBCS8hz0MMvNWNUjXkAtXgoMeKcpgNmN5FM70yem/Ep+EDKzQkGOoTwYBTmME7c366l
         tYYLFa35Be05jVLuZN9KsooD2xFQXNywO27t0Uop976zwJQMBishJ1JTYjnXalGT+r3I
         dP5d8jCrQjRg8yEyXhpPZE4iQhEDU3PAhBJZL3KqJ756OivWegXAXqF9VCRQA9rewoJh
         njQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w3/V6yYsXysnNEFkgRPOGNYEt9gqSHP3Qv8pHd7z8Qk=;
        b=WJ4tABxPyhxdaab5l/mTmtZc+Z4pvGlcu8ENsKLK9B6FzRyzO9m6rrwhPgP3bqV/31
         dZbtPBaRpRjb6G5t7bURaYdoBwgY3RwHgTUZfJdz+jlJV64UyzJiQvJC6w5xShtC+lg0
         rwPHhIdmG0UW0fJyIPDXJT3pvnbKOF6wDc1VCsVWNK71EBN8+9dkfZRj8YZssNkm+5r/
         iDmNLGo3sfTuiq6BELSWrsJHXfhVS0y2sdkVWb9NCc93iTbyqHBfeByAz4EMzgpe6hHn
         UVrFHJ/JZFxQ0lgX9fSNGaOuvJEk12ki2k+E/yFRnoi3MT/3ur3J/yY4QjQ3vFt6Q71B
         aOIg==
X-Gm-Message-State: AOAM531e8XquEs+18KZONdCgOgL4p0gBzqb/By33h933obcHuwoGBwng
        CL56eHYODUiWg7RolX5+k5o+u+uAEFRb/imlJ0I=
X-Google-Smtp-Source: ABdhPJxzumGlc1qUke2IisC0XwV8peRFq/+4oHxa4WpCThvnQiVrWuKLb3sjD+g1Lp4CMcBCNHYiS3N5o8eY0f7VyAg=
X-Received: by 2002:a25:2687:: with SMTP id m129mr18817284ybm.425.1602267944674;
 Fri, 09 Oct 2020 11:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201009160353.1529-1-danieltimlee@gmail.com> <20201009160353.1529-4-danieltimlee@gmail.com>
In-Reply-To: <20201009160353.1529-4-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 9 Oct 2020 11:25:33 -0700
Message-ID: <CAEf4Bzai3y8yHcYAnSBhZ3Wa8nvDcsUw=1o5S-xn42DwPKUndQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] samples: bpf: refactor XDP kern program maps
 with BTF-defined map
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 9:04 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Most of the samples were converted to use the new BTF-defined MAP as
> they moved to libbpf, but some of the samples were missing.
>
> Instead of using the previous BPF MAP definition, this commit refactors
> xdp_monitor and xdp_sample_pkts_kern MAP definition with the new
> BTF-defined MAP format.
>
> Also, this commit removes the max_entries attribute at PERF_EVENT_ARRAY
> map type. The libbpf's bpf_object__create_map() will automatically
> set max_entries to the maximum configured number of CPUs on the host.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/xdp_monitor_kern.c     | 60 +++++++++++++++---------------
>  samples/bpf/xdp_sample_pkts_kern.c | 14 +++----
>  samples/bpf/xdp_sample_pkts_user.c |  1 -
>  3 files changed, 36 insertions(+), 39 deletions(-)
>

[...]

> --- a/samples/bpf/xdp_sample_pkts_kern.c
> +++ b/samples/bpf/xdp_sample_pkts_kern.c
> @@ -5,14 +5,12 @@
>  #include <bpf/bpf_helpers.h>
>
>  #define SAMPLE_SIZE 64ul
> -#define MAX_CPUS 128
> -
> -struct bpf_map_def SEC("maps") my_map = {
> -       .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> -       .key_size = sizeof(int),
> -       .value_size = sizeof(u32),
> -       .max_entries = MAX_CPUS,
> -};
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> +       __type(key, int);
> +       __type(value, u32);


this actually will generate unnecessary libbpf warnings, because
PERF_EVENT_ARRAY doesn't support BTF types for key/value. So use
__uint(key_size, sizeof(int)) and __uint(value_size, sizeof(u32))
instead.

> +} my_map SEC(".maps");
>
>  SEC("xdp_sample")
>  int xdp_sample_prog(struct xdp_md *ctx)
> diff --git a/samples/bpf/xdp_sample_pkts_user.c b/samples/bpf/xdp_sample_pkts_user.c
> index 991ef6f0880b..4b2a300c750c 100644
> --- a/samples/bpf/xdp_sample_pkts_user.c
> +++ b/samples/bpf/xdp_sample_pkts_user.c
> @@ -18,7 +18,6 @@
>
>  #include "perf-sys.h"
>
> -#define MAX_CPUS 128
>  static int if_idx;
>  static char *if_name;
>  static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> --
> 2.25.1
>
