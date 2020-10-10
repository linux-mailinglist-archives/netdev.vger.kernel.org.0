Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B6628A3C1
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731693AbgJJW4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731526AbgJJTyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:54:15 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1126C0613E1;
        Sat, 10 Oct 2020 03:41:57 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id h24so16657620ejg.9;
        Sat, 10 Oct 2020 03:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q0R9T/xjTYd8YM1YuxiZqhLetAqKvDe7d2GoM9PR4T0=;
        b=QLOPe1HNq4PEN+NYyq7WP9uqLahgeN1ZUq4Dy1Z5YB2717pWaU116qSqtBP5gWtwuX
         iXm2mmdyj7BtZ83XwyBCsct0JfWKT2HdKa/W7J62k+YxrfNi2csKsgO1uHZpetuE/ADt
         trFRpuz+GhuY+/DBqFeVjrs2lLCbh4vC9zI14W2HmFlBD2dzLXZAYuO3xOc8TLZrEoh3
         XLhI7T/3q3kTv4XcyxRw4xQ0XGJl3+eA05NFuu33bXbmfwJjiOTozgctGXzDUExd7mZh
         DLHvXuEf6b50uTVioTINBLS9DR7eNU21Z1Tp9pFbvGs3K1jmBGLhzzRjEfYu1PjuXeJ4
         dAJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q0R9T/xjTYd8YM1YuxiZqhLetAqKvDe7d2GoM9PR4T0=;
        b=KZnD/0XfIhfUQ7f+vN60F4GQym4cOVo5y1HVFlUq5yPPsvItlfSQrfHQk6M1lyssLJ
         oiIrGQBvu7ffWfQ7tcUTblzJl49parD8/TMySPvj/MDOqSz6Ci5tuLCO6lflGFKMkCa5
         CmtV2e98kx7gnDLO4AAr4eJmOKaLiUU12opQ3nIWq9VeXGchqntrYVHztAwWcuCYNVN7
         uNY66iqfbrhBzvJNzQXBsHlDsnJW0Ny0AVNAeTimjRqrx80iyA7GuUPqVwpAljwQsFwy
         HwOVVlvmH4h3kdh1uiQRQpay2q18s1EIiy7MTP5mVwBbkTYrHyRRX/Hox7RbUGSANofY
         TsbA==
X-Gm-Message-State: AOAM532ES8O3Fpki6VHlp+ygkkib2iSQxfyGupcrE9DXwl6yiKC7epmv
        w5FdZYC/ZdC+ZZhbG7CiC5rRd/Y2w4Br4y23IA==
X-Google-Smtp-Source: ABdhPJxKQoe78oDHWUDRuuqNUY3mYbvskdCUa+EYsPSOxWECTTDGnY31Y9b1FI8blNFliUzOHoPf0wwesiMAmREOV28=
X-Received: by 2002:a17:906:f89:: with SMTP id q9mr18365181ejj.337.1602326516525;
 Sat, 10 Oct 2020 03:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <20201009160353.1529-1-danieltimlee@gmail.com> <CAEf4BzZJgsd3OkcgULc7_Hxhg_ZcSmp+XT0e--8EMkz9_+5Qxg@mail.gmail.com>
In-Reply-To: <CAEf4BzZJgsd3OkcgULc7_Hxhg_ZcSmp+XT0e--8EMkz9_+5Qxg@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 10 Oct 2020 19:41:40 +0900
Message-ID: <CAEKGpzjakqueq9B8eziCB1iv24j3Qs+YDqZBtbO6GSqJoOUBEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] samples: bpf: Refactor XDP programs with libbpf
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

On Sat, Oct 10, 2020 at 3:30 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Oct 9, 2020 at 9:04 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > To avoid confusion caused by the increasing fragmentation of the BPF
> > Loader program, this commit would like to convert the previous bpf_load
> > loader with the libbpf loader.
> >
> > Thanks to libbpf's bpf_link interface, managing the tracepoint BPF
> > program is much easier. bpf_program__attach_tracepoint manages the
> > enable of tracepoint event and attach of BPF programs to it with a
> > single interface bpf_link, so there is no need to manage event_fd and
> > prog_fd separately.
> >
> > And due to addition of generic bpf_program__attach() to libbpf, it is
> > now possible to attach BPF programs with __attach() instead of
> > explicitly calling __attach_<type>().
> >
> > This patchset refactors xdp_monitor with using this libbpf API, and the
> > bpf_load is removed and migrated to libbpf. Also, attach_tracepoint()
> > is replaced with the generic __attach() method in xdp_redirect_cpu.
> > Moreover, maps in kern program have been converted to BTF-defined map.
> >
> > Daniel T. Lee (3):
> >   samples: bpf: Refactor xdp_monitor with libbpf
> >   samples: bpf: Replace attach_tracepoint() to attach() in
> >     xdp_redirect_cpu
> >   samples: bpf: refactor XDP kern program maps with BTF-defined map
> >
> >  samples/bpf/Makefile                |   4 +-
> >  samples/bpf/xdp_monitor_kern.c      |  60 ++++++------
> >  samples/bpf/xdp_monitor_user.c      | 144 +++++++++++++++++++++-------
> >  samples/bpf/xdp_redirect_cpu_user.c | 138 +++++++++++++-------------
> >  samples/bpf/xdp_sample_pkts_kern.c  |  14 ++-
> >  samples/bpf/xdp_sample_pkts_user.c  |   1 -
> >  6 files changed, 211 insertions(+), 150 deletions(-)
> >
> > --
> > 2.25.1
> >
>
> Thanks for this clean up, Daniel! It's great! I left a few nits here
> and there in the appropriate patches.
>
> There still seem to be a bunch of users of bpf_load.c, which would be
> nice to get rid of completely. But before you go do that, consider
> integrating BPF skeleton into samples/bpf Makefile. That way instead
> of all those look ups of maps/programs by name, you'd be writing a
> straightforward skel->maps.my_map and similar short and non-failing
> code. This should make the overall time spent on conversion much
> smaller (and more pleasant, IMO).
>
> You've dealt with a lot of samples/bpf reworking, so it should be too
> hard for you to figure out the best way to do this, but check
> selftests/bpf's Makefile, if you need some ideas. Or just ask for
> help. Thanks!

Thanks for the great feedback!

Thank you for letting me know about the BPF features that I can apply.
Currently, I'm not familiar with the BPF skeleton yet, but I'll take a good
look at the BPF skeleton to apply it in a more advanced form.

Thank you for your time and effort for the review.

-- 
Best,
Daniel T. Lee
