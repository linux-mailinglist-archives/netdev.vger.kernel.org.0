Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F04328A046
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 13:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730321AbgJJLsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 07:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbgJJKUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 06:20:02 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8B1C0613E1;
        Sat, 10 Oct 2020 02:56:05 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e22so16612819ejr.4;
        Sat, 10 Oct 2020 02:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VR/tQHvJwBGuUu8JsJE9tUxiX1G5oEfON4+74b7xloE=;
        b=aKfWe9sQ2EhbomX3OoQsQ5kk5LwyBcn3Znd1S+SsiJ9XQD0JEojmwv1efkWq1RB5AB
         gMsu5JI4EFqEOKht2wEqtLttpT13VVUpTVxtEGa1goF+GRBGyoJV3caU5hUnJc+N8FYt
         4nqelkdQ/3Npr4BAirZZO8gJ4WdIGf+6Eh9nqj4nJk7KBPgMEVaWz0YdexP6FobC5Qqn
         61UQTZlotYDo2EKneuMkLSSaaqqG60d3kvm+954yODnEwsWN4q7U4YgVQFWM+VJOsIAq
         fYNWBQ8gcgS4Es/yiA1NvN87ZTeJaxfTkOmnxRo3zSxpV976K9cCdt1ReUidUVZ3/MuY
         itnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VR/tQHvJwBGuUu8JsJE9tUxiX1G5oEfON4+74b7xloE=;
        b=s1wQZT7tCErCTBWilbVAM/WSW/sChwyctvpf0AbYmFmyHKRJI5QvX5dw1XuskEUQMb
         rWsTGPlI8+hFVkS3OQGSvzoFP0bWDsTIkDyA2EhO4PlGZHJBG6geXPE0tKlZvt910hc4
         Onug4LPbNVMsll5+YBa4Kqz081aEgm+1wk3pRZuK22N9ofoWSjwQdohDo6qxZNzPF3SW
         5cFzd2GPOsCqky3bi5lYRSzKSKKGS98rkqugO4mN4ji8sP2JNkVcpy7gIdSuTuqJ7aQP
         AvXcpwl4ncWDCeiX5bzEZzDeerr8Ir3youhXyXOgq5y8ExMbtI77RHfzy2tfzL+EBo0L
         YkWw==
X-Gm-Message-State: AOAM530J8YQBjX3gQi5tizAv/TkhKifZO66xtdwFikzR7InzccZTlKUx
        uNl0J3M8fUKqknjP2WKqn8GcO38kChHxj4VjlA==
X-Google-Smtp-Source: ABdhPJwZykUG0Thgw1Kayj5L/BQM/DvuxDe82XXX7C6oeM+gqc8HOJie+y57a4eYTKEntKRM6UoqdmvFo2YOoCqYjj0=
X-Received: by 2002:a17:906:590d:: with SMTP id h13mr18186970ejq.226.1602323764107;
 Sat, 10 Oct 2020 02:56:04 -0700 (PDT)
MIME-Version: 1.0
References: <20201009160353.1529-1-danieltimlee@gmail.com> <20201009160353.1529-4-danieltimlee@gmail.com>
 <CAEf4Bzai3y8yHcYAnSBhZ3Wa8nvDcsUw=1o5S-xn42DwPKUndQ@mail.gmail.com>
In-Reply-To: <CAEf4Bzai3y8yHcYAnSBhZ3Wa8nvDcsUw=1o5S-xn42DwPKUndQ@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 10 Oct 2020 18:55:49 +0900
Message-ID: <CAEKGpzgPepj2c=tvwgwH93OLDvq_GCDjGeoh_w3VCFwUuE=HPA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] samples: bpf: refactor XDP kern program maps
 with BTF-defined map
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Sat, Oct 10, 2020 at 3:25 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Oct 9, 2020 at 9:04 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Most of the samples were converted to use the new BTF-defined MAP as
> > they moved to libbpf, but some of the samples were missing.
> >
> > Instead of using the previous BPF MAP definition, this commit refactors
> > xdp_monitor and xdp_sample_pkts_kern MAP definition with the new
> > BTF-defined MAP format.
> >
> > Also, this commit removes the max_entries attribute at PERF_EVENT_ARRAY
> > map type. The libbpf's bpf_object__create_map() will automatically
> > set max_entries to the maximum configured number of CPUs on the host.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/xdp_monitor_kern.c     | 60 +++++++++++++++---------------
> >  samples/bpf/xdp_sample_pkts_kern.c | 14 +++----
> >  samples/bpf/xdp_sample_pkts_user.c |  1 -
> >  3 files changed, 36 insertions(+), 39 deletions(-)
> >
>
> [...]
>
> > --- a/samples/bpf/xdp_sample_pkts_kern.c
> > +++ b/samples/bpf/xdp_sample_pkts_kern.c
> > @@ -5,14 +5,12 @@
> >  #include <bpf/bpf_helpers.h>
> >
> >  #define SAMPLE_SIZE 64ul
> > -#define MAX_CPUS 128
> > -
> > -struct bpf_map_def SEC("maps") my_map = {
> > -       .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> > -       .key_size = sizeof(int),
> > -       .value_size = sizeof(u32),
> > -       .max_entries = MAX_CPUS,
> > -};
> > +
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> > +       __type(key, int);
> > +       __type(value, u32);
>
>
> this actually will generate unnecessary libbpf warnings, because
> PERF_EVENT_ARRAY doesn't support BTF types for key/value. So use
> __uint(key_size, sizeof(int)) and __uint(value_size, sizeof(u32))
> instead.
>

Thanks for the great review!
I'll fix it right away and send the next version of patch.


> > +} my_map SEC(".maps");
> >
> >  SEC("xdp_sample")
> >  int xdp_sample_prog(struct xdp_md *ctx)
> > diff --git a/samples/bpf/xdp_sample_pkts_user.c b/samples/bpf/xdp_sample_pkts_user.c
> > index 991ef6f0880b..4b2a300c750c 100644
> > --- a/samples/bpf/xdp_sample_pkts_user.c
> > +++ b/samples/bpf/xdp_sample_pkts_user.c
> > @@ -18,7 +18,6 @@
> >
> >  #include "perf-sys.h"
> >
> > -#define MAX_CPUS 128
> >  static int if_idx;
> >  static char *if_name;
> >  static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> > --
> > 2.25.1
> >
