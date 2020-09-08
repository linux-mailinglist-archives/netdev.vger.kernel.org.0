Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF6C262546
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgIICi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgIICiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:38:52 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532C9C061573;
        Tue,  8 Sep 2020 19:38:50 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id j11so1331536ejk.0;
        Tue, 08 Sep 2020 19:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c0LG+vk1ojJvbaF+oWlNIKJX2tMsE657ayPjppgcqDA=;
        b=tQLUGce1kM+Ambd5UX5C/U6nBufPVlR1fZEO0J8r+c4VUfQqLYRYZzkU5le65aXAAo
         PxzcQiqBISVYM+ZxB1i5ZNKU5/vj5XWW9oaHgMMIpaVeoEo/3aG7XXCmVhbvPNJFBYzr
         dGvLlKYwIaRAtoBAjYKQWrhspgWbIn5IJ64CRArRRFxReQoxSvD2yE2xosst2MIAJFik
         H2N29P0T3JVU1OKFuB/t0HEPHBj2Veex8gUexQ9DpjkbSUYP0SEswKiEfcN1XFCZIXm9
         XROCc4dlNnHzViVm7VvMf27Y3/KU8ic3zIJ3AZ6pbRpuRkG0iVUC/vIYNXPGhZ32Gm7v
         eLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c0LG+vk1ojJvbaF+oWlNIKJX2tMsE657ayPjppgcqDA=;
        b=TjnUTrT9jq38jgWvvp4Ywk33EBJuj4aSKNXxNUKOpXQ4xaRdNe0IBgOsQRdLwhTNEk
         MnjAKtffS493+u0MQNImkV/cyBsSGIXeB2ST/+R5yq5li4Jtln/mAbCz31tSTlTd34/T
         fMZiemveJFNPkryc6brLLKGw+kKL4b/lxEFffMyvSbU39aoKRtJYCfbwszmj4xDer9h9
         vv5rGqG7DusETMi9y2xmKqd6MOr9I2dMfzVfC25xDxF445bCy1a7+bU0K6letgYln04v
         HaP7TCK4ixGfVpbJQ0Z7KJfMz2mYH2YU/m3T8WzQiDVKYa1+RUMy2+1WpubqUC5F/4DF
         sVlw==
X-Gm-Message-State: AOAM531zYqKQjYl4HPXUH5LHGJXVA/sEBCk9DnwqZtdG5DIdT+b9UDQI
        L3Ja3ZW4GUpDEHPpM6xTFzBJr0DH5EV7/hCy/Gdkc/AyKw==
X-Google-Smtp-Source: ABdhPJx0uyCHYlMDgFzFnM942bI3iP0KfOS+PYYCVHo6EXx0kCmCLrNmfIYzA8A8Dorbvk9Y8qQHNedt9iLULOYEIdA=
X-Received: by 2002:a17:906:9491:: with SMTP id t17mr1432099ejx.227.1599619129060;
 Tue, 08 Sep 2020 19:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200905154137.24800-1-danieltimlee@gmail.com> <CAEf4BzZ+tGgeqpPiKmChRYQ7FH==3AHXUK5V+Sy2tjZiO58u+w@mail.gmail.com>
In-Reply-To: <CAEf4BzZ+tGgeqpPiKmChRYQ7FH==3AHXUK5V+Sy2tjZiO58u+w@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 9 Sep 2020 02:38:26 +0900
Message-ID: <CAEKGpzhxyrNkRQ5Feu-DH8j4s+sMUCfGD-+JuYEv1rjS5_qcyg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples: bpf: refactor xdp_sample_pkts_kern with
 BTF-defined map
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 8:24 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sat, Sep 5, 2020 at 8:41 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Most of the samples were converted to use the new BTF-defined MAP as
> > they moved to libbbpf, but some of the samples were missing.
> >
> > Instead of using the previous BPF MAP definition, this commit refactors
> > xdp_sample_pkts_kern MAP definition with the new BTF-defined MAP format.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/xdp_sample_pkts_kern.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/samples/bpf/xdp_sample_pkts_kern.c b/samples/bpf/xdp_sample_pkts_kern.c
> > index 33377289e2a8..b15172b7d455 100644
> > --- a/samples/bpf/xdp_sample_pkts_kern.c
> > +++ b/samples/bpf/xdp_sample_pkts_kern.c
> > @@ -7,12 +7,12 @@
> >  #define SAMPLE_SIZE 64ul
> >  #define MAX_CPUS 128
> >
> > -struct bpf_map_def SEC("maps") my_map = {
> > -       .type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
> > -       .key_size = sizeof(int),
> > -       .value_size = sizeof(u32),
> > -       .max_entries = MAX_CPUS,
> > -};
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> > +       __uint(key_size, sizeof(int));
> > +       __uint(value_size, sizeof(u32));
> > +       __uint(max_entries, MAX_CPUS);
>
> if you drop max_entries property, libbpf will set it to the maximum
> configured number of CPUs on the host, which is what you probably
> want. Do you might sending v2 without MAX_CPUS (check if macro is
> still used anywhere else). Thanks!
>

Thanks for your time and effort for the review.

I'll check and send the next version of patch.


> > +} my_map SEC(".maps");
> >
> >  SEC("xdp_sample")
> >  int xdp_sample_prog(struct xdp_md *ctx)
> > --
> > 2.25.1
> >

-- 
Best,
Daniel T. Lee
