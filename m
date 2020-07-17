Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A872246D7
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 01:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgGQXOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 19:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQXOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 19:14:05 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F555C0619D2;
        Fri, 17 Jul 2020 16:14:05 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id u25so6954936lfm.1;
        Fri, 17 Jul 2020 16:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dGmiULhYl/fNrpxWY/ulmrSaJW+Yqopf/LVE6O+Tb2c=;
        b=S9wFclrsHhdQQJ/4PPRIZlBQIg2cqINSBN6VJSLjFrbvNXv22dp4zpJTOJltZ9R+Cb
         PP9H6ykeEHdM8Feuew94dJglk/vmcYjFs/g2/sFlZsJnovizGYefYA6/ZtHnt0RzVb1O
         EV8vPJWjDZZI2JTfs/S7qadSmihU2r75fSONQ0c8JZVn0uiD6TwumQHUfc5vLWlz9M4a
         zW6WSY/cPEH7chJy0kxYD8CdbyiL6J954K4qmib4Nw/FGSDNNyeFAEHGnem8jOOIS0IC
         En763Z86G2LrCr+Bz2Sm46jl59ZR2+8iOj2C5rEfHHuDlwhSaTOX4WIj217RvwX8pxtx
         zg3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dGmiULhYl/fNrpxWY/ulmrSaJW+Yqopf/LVE6O+Tb2c=;
        b=O6UZ93yWlZE5tezvKMIWdq3kXQpMIRU7J6uXZBiWYb+AJinXVR+6nr+UTr+rz087z1
         JAJnxKaOZVOT9VjlNFedWQeEBg5QD9lGwrcaWY53ObBfbCJe2MWvxII4L6Uhf9F/YB+H
         UdvtOnhVPeepGzMn4wPGrviTNxohr7+2300Ge5VZ7sEhj3ItGfdCAgXijilf8/9+DbV3
         zzM4bwamBo5/a0p5i/mluml5hlGqUjxNSfko/gcCMgZTVMF5II/AWB+aOqV7W6arjw7M
         qe7bQTISPRk4gKJlzivN3gn8r6I1EZ4K9p2EhK3pV1H0lW7VjBFAZOSv63DfyvOpAC1e
         NaQg==
X-Gm-Message-State: AOAM530QknvDwN/EKcRi7B7DOrPhzey5hT58wLcXn+2CkbRGhFIYDRe8
        Vs2gK8rRB5sgxu8Msg24y0Qw32PXtj9wlV38Yye3tg==
X-Google-Smtp-Source: ABdhPJw3d1hwRVRLVpmmORslOuDKg2SNBpWFDRGzULbKACI9fXMsg2AnH0Hl/sT+kdTXs7THCrZkJl6BETH1Eflj2lU=
X-Received: by 2002:a05:6512:49d:: with SMTP id v29mr5682338lfq.134.1595027643706;
 Fri, 17 Jul 2020 16:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1594734381.git.lorenzo@kernel.org> <20200717120013.0926a74e@toad>
 <20200717110136.GA1683270@localhost.localdomain> <20200717171333.3fe979e6@toad>
 <20200717191259.GB633625@localhost.localdomain>
In-Reply-To: <20200717191259.GB633625@localhost.localdomain>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 17 Jul 2020 16:13:52 -0700
Message-ID: <CAADnVQ+2yY4DUYVb+S1XtKycMZqhM0uDDEYoesKBgo1r_qK4nw@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 0/9] introduce support for XDP programs in CPUMAP
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        lorenzo.bianconi@redhat.com, David Ahern <dsahern@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 12:13 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > On Fri, 17 Jul 2020 13:01:36 +0200
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >
>
> [...]
>
> >
> > HTH,
> > -jkbs
>
> Hi Jakub,
>
> can you please test the patch below when you have some free cycles? It fixes
> the issue in my setup.
>
> Regards,
> Lorenzo
>
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 4c95d0615ca2..f1c46529929b 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -453,24 +453,27 @@ __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u32 cpu, int map_id)
>         rcpu->map_id = map_id;
>         rcpu->value.qsize  = value->qsize;
>
> +       if (fd > 0 && __cpu_map_load_bpf_program(rcpu, fd))
> +               goto free_ptr_ring;
> +
>         /* Setup kthread */
>         rcpu->kthread = kthread_create_on_node(cpu_map_kthread_run, rcpu, numa,
>                                                "cpumap/%d/map:%d", cpu, map_id);
>         if (IS_ERR(rcpu->kthread))
> -               goto free_ptr_ring;
> +               goto free_prog;
>
>         get_cpu_map_entry(rcpu); /* 1-refcnt for being in cmap->cpu_map[] */
>         get_cpu_map_entry(rcpu); /* 1-refcnt for kthread */
>
> -       if (fd > 0 && __cpu_map_load_bpf_program(rcpu, fd))
> -               goto free_ptr_ring;
> -
>         /* Make sure kthread runs on a single CPU */
>         kthread_bind(rcpu->kthread, cpu);
>         wake_up_process(rcpu->kthread);
>
>         return rcpu;
>
> +free_prog:
> +       if (rcpu->prog)
> +               bpf_prog_put(rcpu->prog);
>  free_ptr_ring:
>         ptr_ring_cleanup(rcpu->queue, NULL);
>  free_queue:

Please send it as a proper patch.
