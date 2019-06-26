Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C42C57451
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 00:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfFZWbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 18:31:33 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:32861 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfFZWbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 18:31:33 -0400
Received: by mail-qt1-f196.google.com with SMTP id w40so402235qtk.0;
        Wed, 26 Jun 2019 15:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1vmyR6e3j7gv9jCv+242q6EyeiqeIh/lmq7cYKwtFbQ=;
        b=SHM+ELpzjzYllwEprCcVGXHmToZCm72nVeIzttAMWY79wYM8CA2ntgjrRaFhH/DXlx
         UxqEy+S3JjTbIowrDWFJUKZqlQk3ZbhJl5JBwcC2vcF5zqTJCkTfYp19+B9Bj4h4y0QN
         2YIHw7IFC04RKpf8hyCeLRSYk6SCNU7Ni86R6b7yMZ7BOYrQxC6ZnhqsL1ijNChuwzH1
         qK1OE31tHNDyVHRjeHWVZcKG1XdrHd/4Jcn2VRrJRYvoVSRDwaVemcq2LA5IkQ8nsSz2
         Gr/WTVYp+XQHbSMRl3Ke0+5mPlvc+pNG6Tzhqu/3qfPlB1nyg5aB/t8tS63Na3uWrmin
         La+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1vmyR6e3j7gv9jCv+242q6EyeiqeIh/lmq7cYKwtFbQ=;
        b=Bpa7Ug3gBugY185tm7gKnYUv06SNLDBZRRRNBC2JXugr7O1Yyk3GVC4NMV1llbdbJh
         2DrZqyWHC1LeGs2kggelMwo9/Ft9K8r3cVdbFg7yLfbBeCfOBG0/JF6+uKyBq8cebSYz
         jydcEr257ovQF3pn9I2mReNYDTpJkJKC99puxafzf9xQKKEual2P8QU8GSNjb0iegALk
         z7H9D8iKhYLup6kG8F6b0N+e2OtJcJjr/g4KvQazW8fIb1wYNNFddTHrWUFlohN1hLuJ
         W89mXcAHeRJNs3avjounA5ZkyX70hfwOn+A+joL//D3XmBotFagtNMBsFsp+Z2wPlf3w
         DOmg==
X-Gm-Message-State: APjAAAVyV3U4kjM6g43R3aAbZeVdsAoo9FmFLNBk1yG3HdhXU3R/vMMf
        yE24zzcdVwhAizeoN0j0guIqNC0ItjCPnfwKGx8=
X-Google-Smtp-Source: APXvYqw5h9UZLxBvanVtR5QRBOdqDGzw8OpXbcBmy969J0MYTZV3wd2tVRzettw7lASytj9rPD0LobTq1lL7khvtoIQ=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr260429qty.141.1561588292336;
 Wed, 26 Jun 2019 15:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190626061235.602633-1-andriin@fb.com> <20190626061235.602633-3-andriin@fb.com>
 <3E535E64-3FD8-4B3D-BBBB-033057084319@fb.com>
In-Reply-To: <3E535E64-3FD8-4B3D-BBBB-033057084319@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 Jun 2019 15:31:20 -0700
Message-ID: <CAEf4BzZuQoN5PZv+223OZZORhDNxx_ZK8pCgS2R3p=aTLFRfNw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/3] libbpf: auto-set PERF_EVENT_ARRAY size to
 number of CPUs
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 11:57 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jun 25, 2019, at 11:12 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > For BPF_MAP_TYPE_PERF_EVENT_ARRAY typically correct size is number of
> > possible CPUs. This is impossible to specify at compilation time. This
> > change adds automatic setting of PERF_EVENT_ARRAY size to number of
> > system CPUs, unless non-zero size is specified explicitly. This allows
> > to adjust size for advanced specific cases, while providing convenient
> > and logical defaults.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > tools/lib/bpf/libbpf.c | 17 ++++++++++++++++-
> > 1 file changed, 16 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index c74cc535902a..8f2b8a081ba7 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -2114,6 +2114,7 @@ static int
> > bpf_object__create_maps(struct bpf_object *obj)
> > {
> >       struct bpf_create_map_attr create_attr = {};
> > +     int nr_cpus = 0;
> >       unsigned int i;
> >       int err;
> >
> > @@ -2136,7 +2137,21 @@ bpf_object__create_maps(struct bpf_object *obj)
> >               create_attr.map_flags = def->map_flags;
> >               create_attr.key_size = def->key_size;
> >               create_attr.value_size = def->value_size;
> > -             create_attr.max_entries = def->max_entries;
> > +             if (def->type == BPF_MAP_TYPE_PERF_EVENT_ARRAY &&
> > +                 !def->max_entries) {
> > +                     if (!nr_cpus)
> > +                             nr_cpus = libbpf_num_possible_cpus();
> > +                     if (nr_cpus < 0) {
> > +                             pr_warning("failed to determine number of system CPUs: %d\n",
> > +                                        nr_cpus);
> > +                             return nr_cpus;
>
> I think we need to goto err_out here.

Absolutely, good catch, thanks!

>
> Thanks,
> Song
>
