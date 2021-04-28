Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716CA36D35B
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 09:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbhD1Hmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 03:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhD1Hmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 03:42:49 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222C5C061574;
        Wed, 28 Apr 2021 00:42:04 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id lr7so14170966pjb.2;
        Wed, 28 Apr 2021 00:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Vplq7VQABgKTTqEmWaOC7n13jU2sKYjrPpnmA+TaV4=;
        b=p8bUi3sf5+RLC8fZLrJ/Sc//ayqTXPNd7xBkYxONhCsznzSxggOdEhanOx9Xr15Zlb
         w5GjnBuyPO5hc/7BgFNgDh9MMpfuqSQYHAU5nA2ycCfvzV35M83LihQJTO20x2tAIA0J
         SdlK/0o7DEblQ55RrtFnLG3DuqwMk9NsepAOp399XJJPdCnSjCWPcDvfMp2qbNKw/ZR0
         CNSAW2KEGJnLcNWv1xSWYmAaPaaVY/77zl/+afxwpVvRhrdg9Ux46kbWWPoKvuCbTU5n
         /cw5HmtGUOoBFlQsvBcxqwm4khXv2IfUR85NjKqGhhYonjnO3ri95by+vhduQqo2vAQz
         bQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Vplq7VQABgKTTqEmWaOC7n13jU2sKYjrPpnmA+TaV4=;
        b=FSlj+ilVxK1GUvwU3/UAJJRUveu9wVF+4SUxQ9t9z9+ync6fE93NFPwqHGx851Rqct
         65b3v2HuP2SzSUbEo8SxuRTbSpNOY8d43DhCVPzhGT4qulOX0AQnCGf+xSFj5Liqz2bM
         wsV0Ol5DpIXg0YwM4D+oZP0PvsqbHjkyceFCpj3C3ByuVVttpjS8yX/w3SMq9w/nwwhM
         KjC458MFq1FTB+VneV3tUs4ehx9knxAvKTMwvgAVqHxpgNJZxPYdAsYLQCLpZsW765jr
         143V6Q8Y/VRrIad0995GlRaW3vP/o3g9+A+KVuZc+BGN4T9QiS8DGcoKdxwL8XUTpx9Z
         rRig==
X-Gm-Message-State: AOAM532A8rsI6ZkMqzt2x/ztwzbz6sEFZi5mSccAToaveiS8+/dVaPff
        nFr2Y/i6PY6Ttz2l1dGAntM05vBmYxhwJvza7xY=
X-Google-Smtp-Source: ABdhPJxP+JfqeNexU/rHuvpt+oJNy4tuQQCNB/dKRKOxvwqbf4PigBJCenGLpswBoQ0v/puyVsHwABFGcNF6g3sVN+M=
X-Received: by 2002:a17:90a:a613:: with SMTP id c19mr2608425pjq.117.1619595723640;
 Wed, 28 Apr 2021 00:42:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617885385.git.lorenzo@kernel.org> <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
 <YIhXxmXdjQdrrPbT@lore-desk>
In-Reply-To: <YIhXxmXdjQdrrPbT@lore-desk>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 28 Apr 2021 09:41:52 +0200
Message-ID: <CAJ8uoz3=RiTLf_MY-8=hZpib8ds8HJFraVpjJs_K0QEzjfbEhA@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer support
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        sameehj@amazon.com, John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 8:28 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> [...]
>
> > Took your patches for a test run with the AF_XDP sample xdpsock on an
> > i40e card and the throughput degradation is between 2 to 6% depending
> > on the setup and microbenchmark within xdpsock that is executed. And
> > this is without sending any multi frame packets. Just single frame
> > ones. Tirtha made changes to the i40e driver to support this new
> > interface so that is being included in the measurements.
> >
> > What performance do you see with the mvneta card? How much are we
> > willing to pay for this feature when it is not being used or can we in
> > some way selectively turn it on only when needed?
>
> Hi Magnus,
>
> Today I carried out some comparison tests between bpf-next and bpf-next +
> xdp_multibuff series on mvneta running xdp_rxq_info sample. Results are
> basically aligned:
>
> bpf-next:
> - xdp drop ~ 665Kpps
> - xdp_tx   ~ 291Kpps
> - xdp_pass ~ 118Kpps
>
> bpf-next + xdp_multibuff:
> - xdp drop ~ 672Kpps
> - xdp_tx   ~ 288Kpps
> - xdp_pass ~ 118Kpps
>
> I am not sure if results are affected by the low power CPU, I will run some
> tests on ixgbe card.

Thanks Lorenzo. I made some new runs, this time with i40e driver
changes as a new data point. Same baseline as before but with patches
[1] and [2] applied. Note
that if you use net or net-next and i40e, you need patch [3] too.

The i40e multi-buffer support will be posted on the mailing list as a
separate RFC patch so you can reproduce and review.

Note, calculations are performed on non-truncated numbers. So 2 ns
might be 5 cycles on my 2.1 GHz machine since 2.49 ns * 2.1 GHz =
5.229 cycles ~ 5 cycles. xdpsock is run in zero-copy mode so it uses
the zero-copy driver data path in contrast with xdp_rxq_info that uses
the regular driver data path. Only ran the busy-poll 1-core case this
time. Reported numbers are the average over 3 runs.

multi-buffer patches without any driver changes:

xdpsock rxdrop 1-core:
i40e: -4.5% in throughput / +3 ns / +6 cycles
ice: -1.5% / +1 ns / +2 cycles

xdp_rxq_info -a XDP_DROP
i40e: -2.5% / +2 ns / +3 cycles
ice: +6% / -3 ns / -7 cycles

xdp_rxq_info -a XDP_TX
i40e: -10% / +15 ns / +32 cycles
ice: -9% / +14 ns / +29 cycles

multi-buffer patches + i40e driver changes from Tirtha:

xdpsock rxdrop 1-core:
i40e: -3% / +2 ns / +3 cycles

xdp_rxq_info -a XDP_DROP
i40e: -7.5% / +5 ns / +9 cycles

xdp_rxq_info -a XDP_TX
i40e: -10% / +15 ns / +32 cycles

Would be great if someone could rerun a similar set of experiments on
i40e or ice then
report.

[1] https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210419/024106.html
[2] https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210426/024135.html
[3] https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210426/024129.html

> Regards,
> Lorenzo
>
> >
> > Thanks: Magnus
> >
> > > Eelco Chaudron (4):
> > >   bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
> > >   bpd: add multi-buffer support to xdp copy helpers
> > >   bpf: add new frame_length field to the XDP ctx
> > >   bpf: update xdp_adjust_tail selftest to include multi-buffer
> > >
> > > Lorenzo Bianconi (10):
> > >   xdp: introduce mb in xdp_buff/xdp_frame
> > >   xdp: add xdp_shared_info data structure
> > >   net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
> > >   xdp: add multi-buff support to xdp_return_{buff/frame}
> > >   net: mvneta: add multi buffer support to XDP_TX
> > >   net: mvneta: enable jumbo frames for XDP
> > >   net: xdp: add multi-buff support to xdp_build_skb_from_fram
> > >   bpf: move user_size out of bpf_test_init
> > >   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
> > >   bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
> > >     signature
> > >
> > >  drivers/net/ethernet/marvell/mvneta.c         | 182 ++++++++++--------
> > >  include/linux/filter.h                        |   7 +
> > >  include/net/xdp.h                             | 105 +++++++++-
> > >  include/uapi/linux/bpf.h                      |   1 +
> > >  net/bpf/test_run.c                            | 109 +++++++++--
> > >  net/core/filter.c                             | 134 ++++++++++++-
> > >  net/core/xdp.c                                | 103 +++++++++-
> > >  tools/include/uapi/linux/bpf.h                |   1 +
> > >  .../bpf/prog_tests/xdp_adjust_tail.c          | 105 ++++++++++
> > >  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 127 ++++++++----
> > >  .../bpf/progs/test_xdp_adjust_tail_grow.c     |  17 +-
> > >  .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++-
> > >  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   3 +-
> > >  13 files changed, 767 insertions(+), 159 deletions(-)
> > >
> > > --
> > > 2.30.2
> > >
