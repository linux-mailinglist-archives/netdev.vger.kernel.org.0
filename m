Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D192890D1
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390429AbgJISaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388240AbgJISaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:30:01 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11219C0613D2;
        Fri,  9 Oct 2020 11:30:01 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id b142so7934608ybg.9;
        Fri, 09 Oct 2020 11:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wPYR1XCw2CHMtKERpHn+P66N/lX3Kc4UU6HrVKuMVLg=;
        b=cBdWPln7Bzz/a9GnOWgIBN6QkUjaH5CSD3bi3K/WZfh3LcHuOVPunpURPyg5qiKQQ2
         B4MzAMZU7fWXHSHhImCOsNkYeRQyiS2LN+/O+kyXhcyrG1FRu7MAtuyIZ1f91aZtSirg
         eO6lG8vJI15ObWRevYcTW+VYpPt+XFxLOlLzrpfslqDZkeXo30g2IN8lPEURBIKt8azh
         k7+Dy0LsPCgjEFhXJvBRy0vC71FGiqrCLQiUJ7uAN8pvtiqkGGONrAYPTjhvq+8eImXb
         5Ca9N3GELpUVfC74hup7MXbEzH0OhdQxNu/kh18GX8l1mX0zlFCD5lLMZzm8rOGK5Qql
         f8dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wPYR1XCw2CHMtKERpHn+P66N/lX3Kc4UU6HrVKuMVLg=;
        b=pru5Qc7cXqO5gaHSCeztGQVyIPudf2SL1UN+vxs6ysPk0wocS5pukzD4Ld/ZbhdpgE
         4IR3n44Z2Kt4yLbm3mMg+wZSAIPpzzx+ddgGduEoy3osEJEtyziU/pOU7fyFQImH1o88
         bjzQNqpAufdARRXniQ+9uxFGcAqelSKuAquK1Q7dDA4LPYEKildZFYtIMb1KuMTjLHPK
         Q7kXykj7k62PR0I0JMGTMPLPTLuOzxLyi+IgIZjtLAm5r9d1aaWyCDdFHFRjiytOfYsK
         b6RGkgLqWu/+9RlaxoiiH1Ug5GDVwlQeGUnRKtk/hxFmE/yDUU5XNAm1td5D2E3aBONv
         J+TQ==
X-Gm-Message-State: AOAM532VX8eCfsCJdfYGxjdSWXYiPPoEDOLliisnpjeFreqDX8hDsL02
        dtxCIS0D6h15Yw97e5ciG5ri0EgiINq5slhnSEY=
X-Google-Smtp-Source: ABdhPJzc7KQ0asHvWNhe0QOPDN5Aazv4uob54x6oPwpVHbmE04qba53tCDqGfjODwq0oNJNwrCMNuVeCkOYPalmE7u8=
X-Received: by 2002:a25:2d41:: with SMTP id s1mr18499463ybe.459.1602268200350;
 Fri, 09 Oct 2020 11:30:00 -0700 (PDT)
MIME-Version: 1.0
References: <20201009160353.1529-1-danieltimlee@gmail.com>
In-Reply-To: <20201009160353.1529-1-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 9 Oct 2020 11:29:49 -0700
Message-ID: <CAEf4BzZJgsd3OkcgULc7_Hxhg_ZcSmp+XT0e--8EMkz9_+5Qxg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] samples: bpf: Refactor XDP programs with libbpf
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
> To avoid confusion caused by the increasing fragmentation of the BPF
> Loader program, this commit would like to convert the previous bpf_load
> loader with the libbpf loader.
>
> Thanks to libbpf's bpf_link interface, managing the tracepoint BPF
> program is much easier. bpf_program__attach_tracepoint manages the
> enable of tracepoint event and attach of BPF programs to it with a
> single interface bpf_link, so there is no need to manage event_fd and
> prog_fd separately.
>
> And due to addition of generic bpf_program__attach() to libbpf, it is
> now possible to attach BPF programs with __attach() instead of
> explicitly calling __attach_<type>().
>
> This patchset refactors xdp_monitor with using this libbpf API, and the
> bpf_load is removed and migrated to libbpf. Also, attach_tracepoint()
> is replaced with the generic __attach() method in xdp_redirect_cpu.
> Moreover, maps in kern program have been converted to BTF-defined map.
>
> Daniel T. Lee (3):
>   samples: bpf: Refactor xdp_monitor with libbpf
>   samples: bpf: Replace attach_tracepoint() to attach() in
>     xdp_redirect_cpu
>   samples: bpf: refactor XDP kern program maps with BTF-defined map
>
>  samples/bpf/Makefile                |   4 +-
>  samples/bpf/xdp_monitor_kern.c      |  60 ++++++------
>  samples/bpf/xdp_monitor_user.c      | 144 +++++++++++++++++++++-------
>  samples/bpf/xdp_redirect_cpu_user.c | 138 +++++++++++++-------------
>  samples/bpf/xdp_sample_pkts_kern.c  |  14 ++-
>  samples/bpf/xdp_sample_pkts_user.c  |   1 -
>  6 files changed, 211 insertions(+), 150 deletions(-)
>
> --
> 2.25.1
>

Thanks for this clean up, Daniel! It's great! I left a few nits here
and there in the appropriate patches.

There still seem to be a bunch of users of bpf_load.c, which would be
nice to get rid of completely. But before you go do that, consider
integrating BPF skeleton into samples/bpf Makefile. That way instead
of all those look ups of maps/programs by name, you'd be writing a
straightforward skel->maps.my_map and similar short and non-failing
code. This should make the overall time spent on conversion much
smaller (and more pleasant, IMO).

You've dealt with a lot of samples/bpf reworking, so it should be too
hard for you to figure out the best way to do this, but check
selftests/bpf's Makefile, if you need some ideas. Or just ask for
help. Thanks!
