Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4041E2C2067
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 09:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbgKXIuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 03:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgKXIuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 03:50:51 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E569C0613CF;
        Tue, 24 Nov 2020 00:50:51 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id i13so4611374oou.11;
        Tue, 24 Nov 2020 00:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QtB6qjotqftlE39hX7pTDQRbsm5nvyoVLxcn1kHhN78=;
        b=Rcgx3XRfMEI5U/7u7EWon6wJ7aY80kzh7/L+DM/1WIQ/32dy0bG9d1vw5NuSJxZdsu
         oJDFruI5+lbrLh0Vp+1q2avn8oEfXEg1NkoXkE9suPyBldG2CjqBhiAwQLuJYIO8pMW4
         2E4p1inaASx2Q22PFH622/pwGF5od+JTAGBlZAcUgkNfEAsWi8oBWMD3Z7268t2xw+L1
         iL4A1/xUpex9qjLGNiJOBXH7qsH/0ZhBvqvTSvhrbJtBrDUZtph+Urs8i3oOwtgQd6L/
         WOiT9nPTbhEbIdL4PIO03k5pAcidSKk2lzysafIHjAPS+Y8L7xjyBAH4RxWACHIjhpJK
         QxRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QtB6qjotqftlE39hX7pTDQRbsm5nvyoVLxcn1kHhN78=;
        b=TNkLUOWfiSWm4XvkqLuQ3YWZguOrJTKXeaqB20u/dMeUgmzu9gdLLq6vjnORaP9vl6
         iBpLQVEbFczxg/FMMU8WHQt1zzuRFX5PUSqfWgFurIVd5CctKnrVUg7GBIppQ9RlHrUv
         cezCU9lCcBNZz5tNclT1QECfG0RcM2RQgZpC4SGSLZe845QJjjo3JfEYIx19uDmOrGIG
         6AzAu52kMAtHuZY33SNlfyCcneyi1OwlQ/ZSjeos+NetJavXQaAWRy2o59ToatV5JzId
         0uoJgEv4jgG0O6demOfdUdYParKooY6ZZKmqQtIeLgQC3PefXcA0+5YSUxceZcmsQfuh
         WpLA==
X-Gm-Message-State: AOAM531uJCPgdUHLxkKEfi6JU/ujnV2u7SGDHkn58e3zZDikaT1uosbm
        kYqgKTT6GWHuH3Rj5So6UWpgmfFWJSjBI0l4nA==
X-Google-Smtp-Source: ABdhPJxygbgRDeioO9f5+LORwBxcmJ9hKAvOjntJC1FdvSPWGwGtG7gYcJcPOkG4eVsre7hB+gB9HNgogOfOSbvi0y4=
X-Received: by 2002:a4a:928a:: with SMTP id i10mr2414948ooh.47.1606207850706;
 Tue, 24 Nov 2020 00:50:50 -0800 (PST)
MIME-Version: 1.0
References: <20201119150617.92010-1-danieltimlee@gmail.com>
 <20201119150617.92010-2-danieltimlee@gmail.com> <20201121023405.tchtyadco4x45sf3@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201121023405.tchtyadco4x45sf3@kafai-mbp.dhcp.thefacebook.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 24 Nov 2020 17:50:34 +0900
Message-ID: <CAEKGpzifL18heCuioO8Qoei6a3epkrZcM=Av6qwdi2w1faTkKg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/7] samples: bpf: refactor hbm program with libbpf
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the late reply.

On Sat, Nov 21, 2020 at 11:34 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Nov 19, 2020 at 03:06:11PM +0000, Daniel T. Lee wrote:
> [ ... ]
>
> >  static int run_bpf_prog(char *prog, int cg_id)
> > [ ... ]
> >       if (!outFlag)
> > -             type = BPF_CGROUP_INET_INGRESS;
> > -     if (bpf_prog_attach(bpfprog_fd, cg1, type, 0)) {
> > -             printf("ERROR: bpf_prog_attach fails!\n");
> > -             log_err("Attaching prog");
> > +             bpf_program__set_expected_attach_type(bpf_prog, BPF_CGROUP_INET_INGRESS);
> > +
> > +     link = bpf_program__attach_cgroup(bpf_prog, cg1);
> > +     if (libbpf_get_error(link)) {
> > +             fprintf(stderr, "ERROR: bpf_program__attach_cgroup failed\n");
> > +             link = NULL;
> Again, this is not needed.  bpf_link__destroy() can
> handle both NULL and error pointer.  Please take a look
> at the bpf_link__destroy() in libbpf.c
>
> > +             goto err;
> > +     }
> > [ ... ]

> > @@ -398,10 +400,10 @@ static int run_bpf_prog(char *prog, int cg_id)
> >  err:
> >       rc = 1;
> >
> > -     if (cg1)
> > -             close(cg1);
> > +     bpf_link__destroy(link);
> > +     close(cg1);
> >       cleanup_cgroup_environment();
> > -
> > +     bpf_object__close(obj);
> The bpf_* cleanup condition still looks wrong.
>
> I can understand why it does not want to cleanup_cgroup_environment()
> on the success case because the sh script may want to run test under this
> cgroup.
>
> However, the bpf_link__destroy(), bpf_object__close(), and
> even close(cg1) should be done in both success and error
> cases.
>
> The cg1 test still looks wrong also.  The cg1 should
> be init to -1 and then test for "if (cg1 == -1)".

Thanks for pointing this out.
I'll remove NULL initialize and fix this on the next patch.


--
Best,
Daniel T. Lee
