Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45B781246A1
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 13:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLRMSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 07:18:23 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38186 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfLRMSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 07:18:22 -0500
Received: by mail-qt1-f193.google.com with SMTP id n15so1772913qtp.5;
        Wed, 18 Dec 2019 04:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9SbLIPt1twIa7fqW6yKEFytGs3p1PVhXbihgXlQIz9I=;
        b=HD9orLfvlNLujZcNgZV1JgDHpZALJi51J2pd4nhdAvHiJ7UAeEq4/5IyjKwxBuNr7L
         bqiQQAheBHxqHohf5ES2l1fd0Wqg4YQQbOp1RgJvqy8iA3F94j9m6x18Mt1tUVtMZ4nx
         YoV4xk8ObWwnrrnJ927nViIABVhJ8lim85Q4moYXDVEgBBecoiv7G6E/QCf6wXbGDCmA
         hBynUcMUq55E+W71nmWfXWmc9U7l18lwxxSi+Hb6woxzPvfEDaqaGq59nPrAI5KMDS5n
         vX7jYnZySvnAlv3J8q7quVcqeUm1Hs4NPSbogyS/Sj26Am7R8mbsVLoehcsibSunfuuE
         hDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9SbLIPt1twIa7fqW6yKEFytGs3p1PVhXbihgXlQIz9I=;
        b=uPeRN1nLVU0bxzNrjLsGGW0RB/tX6aJlBzI5OLpnAmRR5NvA4oCJJzpRfgrdspGxOF
         ffu0soIMJaAq9FXaRFR0UCLT2cdy23yN3+/01Zjhj9EOPUWzQZ1NIEdf6Lbu+qnzmaqz
         BxtwwiZHHxwfxDkrGtVJwc2yZWyg/gS5uWnHaLxTOT2hFDECHqmItA5ne2inwe6cSVT4
         IgnOOGe/1omObRB1DdCIZ69JgXL2L+685OPnFl8t9IE/EG2fn9Q86NijBBBSEpuT+3m1
         QV+AR3fnP6mRRRuE3bX7bixy5scqnXM+x1h9TrsovaoQlTCQZyGA/5pF9s0rFmcE8iR6
         NEFw==
X-Gm-Message-State: APjAAAX/kqK5BIp0rKC4nHDuYyunypH272EOSXWa3CuzxJiu1JX9Faes
        FnRHvK1/0Z5lF5TlmZ2eYWjSyE41OAxnMEnIanQ=
X-Google-Smtp-Source: APXvYqz38eqyQGWWg2kdaURmi27j+qBIQ3C6EWLj+kuOdaC5r9YMIinNVBg6dVfd5o8YHUvSq4qI43G12joKR9eT8/w=
X-Received: by 2002:ac8:34b5:: with SMTP id w50mr1874307qtb.107.1576671501245;
 Wed, 18 Dec 2019 04:18:21 -0800 (PST)
MIME-Version: 1.0
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218121132.4023f4f1@carbon>
 <CAJ+HfNgKsPN7V9r=N=hDoVb23-nk3q=y+Nv4jB3koPw0+4Zw9A@mail.gmail.com> <20191218130346.1a346606@carbon>
In-Reply-To: <20191218130346.1a346606@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 18 Dec 2019 13:18:10 +0100
Message-ID: <CAJ+HfNi+hAKY+yyW=p+xzbc=0AGu4DcmyTBGmnJFBjQnC7Nb4Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] Simplify xdp_do_redirect_map()/xdp_do_flush_map()
 and XDP maps
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
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

On Wed, 18 Dec 2019 at 13:04, Jesper Dangaard Brouer <brouer@redhat.com> wr=
ote:
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
>
> Can I ask you to also run a test with --stress-mode for
> ./xdp_redirect_cpu, to flush out any potential RCU race-conditions
> (don't provide output, this is just a robustness test).
>

Sure! Other than that, does the command line above make sense? I'm
blasting UDP packets to core 20, and the idea was to re-route them to
22.


Bj=C3=B6rn
