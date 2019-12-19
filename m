Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7431258A4
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfLSAjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 19:39:20 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:37537 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfLSAjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 19:39:20 -0500
Received: by mail-qv1-f68.google.com with SMTP id f16so1542787qvi.4;
        Wed, 18 Dec 2019 16:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0gGy9mmhKv4XmPMG4iklEGqIvuan5dYk915e0Jrphy8=;
        b=VgIZJcKNUqUNsrYubaPqFIEE3wO21YBmkw1xz07UmUQW78NPZ0Krwv1e+NXbL2nA3n
         cuwNj+15/YsThQa0e/2oRt8khvIwfI9Mbeni/qM3uh5IOhqS5vCNIuGGi/m3EJDuTmkp
         BRq9JYYrRGYysbUVRQsAHe644pbw06OwzN9TBjzBDHhB9UHiCxdErwpz7UI4C7WTpa/L
         9k3951Gf+ovQMx2BA7zmU0wb4jKyqJrBc1abY+lOtWqGzG+muUKI9mUKuVqY8uWPVY9D
         B/iCEI1TdmbOzRmwwtl2zThjPQbIsKzmuvUVQ46josErDU2wxRqoU7D3y5EFMcUbTO67
         5ZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0gGy9mmhKv4XmPMG4iklEGqIvuan5dYk915e0Jrphy8=;
        b=HDuMIZsirAd00KrHkNJOj/vgnrWZZjY6c2jHBKVZbDYhGhqdAxwNcNAu/puDzZrciR
         Gp9ypMxfCBLoDhfn+KwOT/qMuBdZEANFAcSS48KRF/6bcIl6+Thfzu4UzghTO1iZ9ZYS
         tL/3DvdFnv+2Mjp7K/IfQHb3MjipJnpJNCeYrVSkDduWy/+WhwbPhlge+5BhDsR7cEW6
         v8BB8uPvXuOOKDS0uF2OafwuyzI+Fujz2mfUTpx/PrPLKA5TqzfMYd+F4reAWTWb5AyW
         DOAeqNh9WDu8jSOtqlS6BJHyV50N5slAyaUj8IXb4P10tjwg/abcUHpGm5qnhjOInm3Z
         YRjg==
X-Gm-Message-State: APjAAAUZHlvizxa8ihnahgq9pR1jFy2enF2V5p09l7gDxu80UFmzQ3FK
        uOkViL0PmSs7SBFa66y/wmmAJYhlmbifzBEopAM=
X-Google-Smtp-Source: APXvYqySchnU3zPsoisoStXlAIhMkEE9zMdxXIZvj8J/5HxHHXlX5fkZJZ3mf5TKmaP/UZugboJHLT9uq1tb9sQPtWA=
X-Received: by 2002:ad4:514e:: with SMTP id g14mr5269010qvq.196.1576715959301;
 Wed, 18 Dec 2019 16:39:19 -0800 (PST)
MIME-Version: 1.0
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218121132.4023f4f1@carbon>
 <CAJ+HfNgKsPN7V9r=N=hDoVb23-nk3q=y+Nv4jB3koPw0+4Zw9A@mail.gmail.com> <20191218130346.1a346606@carbon>
In-Reply-To: <20191218130346.1a346606@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Dec 2019 16:39:08 -0800
Message-ID: <CAEf4BzZab=FvCuvKOKsj0M5RRoGuuXW2ME5EoDuqT8sJOd2Xtg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] Simplify xdp_do_redirect_map()/xdp_do_flush_map()
 and XDP maps
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 4:04 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Wed, 18 Dec 2019 12:39:53 +0100
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
>
> > On Wed, 18 Dec 2019 at 12:11, Jesper Dangaard Brouer <brouer@redhat.com=
> wrote:
> > >
> > > On Wed, 18 Dec 2019 11:53:52 +0100
> > > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> > >
> > > >   $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_map0
> > > >
> > > >   Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
> > > >   XDP-cpumap      CPU:to  pps            drop-pps    extra-info
> > > >   XDP-RX          20      7723038        0           0
> > > >   XDP-RX          total   7723038        0
> > > >   cpumap_kthread  total   0              0           0
> > > >   redirect_err    total   0              0
> > > >   xdp_exception   total   0              0
> > >
> > > Hmm... I'm missing some counters on the kthread side.
> > >
> >
> > Oh? Any ideas why? I just ran the upstream sample straight off.
>
> Looks like it happened in commit: bbaf6029c49c ("samples/bpf: Convert
> XDP samples to libbpf usage") (Cc Maciej).
>
> The old bpf_load.c will auto attach the tracepoints... for and libbpf
> you have to be explicit about it.

... or you can use skeleton, which will auto-attach them as well,
provided BPF program's section names follow expected naming
convention. So it might be a good idea to try it out.

>
> Can I ask you to also run a test with --stress-mode for
> ./xdp_redirect_cpu, to flush out any potential RCU race-conditions
> (don't provide output, this is just a robustness test).
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
