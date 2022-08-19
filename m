Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E32E599473
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 07:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346086AbiHSFYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 01:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346032AbiHSFYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 01:24:43 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF61D598A;
        Thu, 18 Aug 2022 22:24:42 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id q74so2594274iod.9;
        Thu, 18 Aug 2022 22:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=fSjWEqS+nzaDnc5WYuCrEYkIrPzGz/UPSsWeAxzHMno=;
        b=Vg7kzCyU4V2Zh2vbfVjatiWUhBCqKnLn+l1sd0bxdhUFjhdqBz/E40nfa48VPO8btm
         r6JUhnsHWJgg6uNPvRFH7fxlUHohFLuNMJ5fHFdAJLWdd9GWfBHG0wRI9dVMEzUXRdty
         w811GOf+JOaMpa9OOPumyH7L4Jay7HW3shBIgQWsXk046fNoqw/uKYlgRfkidLlHiCGW
         1jed6vpp4ckJwj4sTB8qO94f64jOTXPDli1T/9/qMZhSInhYTeCj1meQ0gOTYPUatOPD
         FqBkJ/9/YBZucKSlM7a6Swbgso+WC+aUah5ayiz8H/tIvrIfqj0yfxfs1e6loMZ9wZwj
         XOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=fSjWEqS+nzaDnc5WYuCrEYkIrPzGz/UPSsWeAxzHMno=;
        b=nSMYQnCrrx6VVR2YGLIUjXizG5pnHb4u7r8+bq7MxLxwMvIBU+olAO2WyDnVOJoPZ4
         s0ivqY42aR/eBmUk5CmA8HUq9DU6igq94UAv64kzrrZxKbSlrEX16+PE3qpWkZdReepI
         MT0xT9cM3hkSCPTyTblR89KjhHRAmOFTxybre0Hkt6n3++HGbqQxnPLr00wrHjKCaX0s
         OlpjwmWc3gHW5AVmQvXj0Gg5KRjJiKFgcRxwRPmLec98UV17sD0VTCzdbtQd7Zgp8yT+
         ghFVsrQA0TpXYxM/foX6wzxlTDZXYSbrNlZmh89ewg2NLvVtxNzz+yalOB7Gb0WtAI/W
         Zn7Q==
X-Gm-Message-State: ACgBeo1ceMSZJ1KDzSlJT3lJn33wn+xALxK12Vsf9tfnzwdsPu+hRWXa
        /W3HX3lBgTImL7pwuBO6NPg+nbJtOLWG5XmHM30=
X-Google-Smtp-Source: AA6agR5GkEF2VS/TVRe7RgWcdbul3ujPU9FHutffAdiUQr4H+JrKdIH2s1A+PgaPtffJZVN4+hDW1Q2FbdAERppX73c=
X-Received: by 2002:a05:6602:2d8b:b0:688:ece0:e1da with SMTP id
 k11-20020a0566022d8b00b00688ece0e1damr2718327iow.18.1660886681832; Thu, 18
 Aug 2022 22:24:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220818165906.64450-1-toke@redhat.com> <Yv68pgkL++uD0a6e@google.com>
In-Reply-To: <Yv68pgkL++uD0a6e@google.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 19 Aug 2022 07:24:06 +0200
Message-ID: <CAP01T75Q8JhX-EQVp_3C9YAxybptUBmuwALsxAaDZObYuQ8KCw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] A couple of small refactorings of BPF
 program call sites
To:     sdf@google.com
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 at 00:29, <sdf@google.com> wrote:
>
> On 08/18, Toke H=EF=BF=BDiland-J=EF=BF=BDrgensen wrote:
> > Stanislav suggested[0] that these small refactorings could be split out
> > from the
> > XDP queueing RFC series and merged separately. The first change is a sm=
all
> > repacking of struct softnet_data, the others change the BPF call sites =
to
> > support full 64-bit values as arguments to bpf_redirect_map() and as th=
e
> > return
> > value of a BPF program, relying on the fact that BPF registers are alwa=
ys
> > 64-bit
> > wide to maintain backwards compatibility.
>
> > Please see the individual patches for details.
>
> > [0]
> > https://lore.kernel.org/r/CAKH8qBtdnku7StcQ-SamadvAF=3D=3DDRuLLZO94yOR1=
WJ9Bg=3DuX1w@mail.gmail.com
>
> Looks like a nice cleanup to me:
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
>
> Can you share more on this comment?
>
> /* For some architectures, we need to do modulus in 32-bit width */
>
> Some - which ones? And why do they need it to be 32-bit?

It was a fix for i386, I saw a kernel test robot error when it was
sitting in Toke's tree.
See https://lore.kernel.org/all/202203140800.8pr81INh-lkp@intel.com.

Once bpf_prog_run_clear_cb starts returning a 64-bit value, we now
need to save it in 32-bit before doing the modulus.

>
> > Kumar Kartikeya Dwivedi (1):
> >    bpf: Use 64-bit return value for bpf_prog_run
>
> > Toke H=EF=BF=BDiland-J=EF=BF=BDrgensen (2):
> >    dev: Move received_rps counter next to RPS members in softnet data
> >    bpf: Expand map key argument of bpf_redirect_map to u64
>
> >   include/linux/bpf-cgroup.h | 12 +++++-----
> >   include/linux/bpf.h        | 16 ++++++-------
> >   include/linux/filter.h     | 46 +++++++++++++++++++------------------=
-
> >   include/linux/netdevice.h  |  2 +-
> >   include/uapi/linux/bpf.h   |  2 +-
> >   kernel/bpf/cgroup.c        | 12 +++++-----
> >   kernel/bpf/core.c          | 14 ++++++------
> >   kernel/bpf/cpumap.c        |  4 ++--
> >   kernel/bpf/devmap.c        |  4 ++--
> >   kernel/bpf/offload.c       |  4 ++--
> >   kernel/bpf/verifier.c      |  2 +-
> >   net/bpf/test_run.c         | 21 +++++++++--------
> >   net/core/filter.c          |  4 ++--
> >   net/packet/af_packet.c     |  7 ++++--
> >   net/xdp/xskmap.c           |  4 ++--
> >   15 files changed, 80 insertions(+), 74 deletions(-)
>
> > --
> > 2.37.2
>
