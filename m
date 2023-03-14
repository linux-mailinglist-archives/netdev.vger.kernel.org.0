Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BC86BA3C5
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 00:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCNXyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 19:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCNXyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 19:54:40 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57555305DA;
        Tue, 14 Mar 2023 16:54:38 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id cy23so68786563edb.12;
        Tue, 14 Mar 2023 16:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678838077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mAZ5ukYUSwT73w04Gdv7MLpeKiUPI+p42LWPIdR13G4=;
        b=at+V50fHULln961ayaPRxDQLV7n4Rxf5ixqyOU6xhWztkibehJKHmpLCd4kRZsNyUN
         HIdXGWPgUmjKm+kIYhjaPUOfMNnPxPSRFuwYJK/xjUqUr6k9SeBCCEW7ZD7PbWzj1+gm
         0GYlPmxcUFz9wGGAoa/4qvh6fwKCVvnPNC3WpUo3WxK8t2Ue/qatJLFu77zuSTSz2d+2
         LxLTV6TliJE4SzDbjIdYKf84JVG/qLpQ1UZFK0+wGWq5EUFDBUjk7OEqe2KBAPI+wH9c
         8yzovwWSJNlDhs4BSuxnf8znq2mRKu4CBFgpTR5iX7/Pb2kHHGUicGq2Ghrb0kcqO5V9
         28Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678838077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mAZ5ukYUSwT73w04Gdv7MLpeKiUPI+p42LWPIdR13G4=;
        b=7VO4Y1Lrjq79j8aCBVKDvspehS4eDcZuABfD9z+KCRnhvShSBGk71LzLV0I34t0wky
         Sj1ppTQrciTUIE5ALZAD+XrX3H7guxLk4Wxmj41pYeYxtHuv/CY1CT+lQ6OfORhMidRx
         maYdzAps5jEULPmQiwsj1QghgkIp66I6MLhzFtFqOSZ93N8anWtizP5+GKzP52ewpASz
         BEPL/ooNPF2tiJctXoDMJ/Ekaa+K8T/0bsFSSu8pmZqbNdRudpM1IDOBcJC8yGEAce7o
         0bsSLnrtPrP7FNmF8lfSLSecx9hBhyijFiVvLKmQtxuelxyeqFi1Ghht34TYasgFCwPP
         7VOQ==
X-Gm-Message-State: AO0yUKWjAethmNgfQVOjQ/2h1KWU4MOdW1GuToFKa/Iwcv/6dCHrR02+
        yxeDTKPqejI4xpuFYfrlVYdqBvFVDJHU0sFLta0=
X-Google-Smtp-Source: AK7set/+ykfWKcDhnxxb9CPRmRf/cFyW3ticqdzPpXQsLaWnIxNlEzz+8iPv1e6OcXgzm9hcrNLPhHYcTXD6vibd+lk=
X-Received: by 2002:a50:d509:0:b0:4fb:f19:87f with SMTP id u9-20020a50d509000000b004fb0f19087fmr431586edi.3.1678838076688;
 Tue, 14 Mar 2023 16:54:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
 <ca1385b5-b3f8-73f3-276c-a2a08ec09aa0@intel.com> <CAADnVQJDz3hBEJ7kohXJ4HUZWZdbRRamfJbrZ6KUaRubBKQmfA@mail.gmail.com>
In-Reply-To: <CAADnVQJDz3hBEJ7kohXJ4HUZWZdbRRamfJbrZ6KUaRubBKQmfA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Mar 2023 16:54:25 -0700
Message-ID: <CAADnVQ+B_JOU+EpP=DKhbY9yXdN6GiRPnpTTXfEZ9sNkUeb-yQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/4] xdp: recycle Page Pool backed skbs built
 from XDP frames
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 11:52=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Mar 14, 2023 at 4:58=E2=80=AFAM Alexander Lobakin
> <aleksander.lobakin@intel.com> wrote:
> >
> >   All error logs:
> >   libbpf: prog 'trace_virtqueue_add_sgs': BPF program load failed: Bad
> > address
> >   libbpf: prog 'trace_virtqueue_add_sgs': -- BEGIN PROG LOAD LOG --
> >   The sequence of 8193 jumps is too complex.
> >   verification time 77808 usec
> >   stack depth 64
> >   processed 156616 insns (limit 1000000) max_states_per_insn 8
> > total_states 1754 peak_states 1712 mark_read 12
> >   -- END PROG LOAD LOG --
> >   libbpf: prog 'trace_virtqueue_add_sgs': failed to load: -14
> >   libbpf: failed to load object 'loop6.bpf.o'
> >   scale_test:FAIL:expect_success unexpected error: -14 (errno 14)
> >   #257     verif_scale_loop6:FAIL
> >   Summary: 288/1766 PASSED, 21 SKIPPED, 1 FAILED
> >
> > So, xdp_do_redirect, which was previously failing, now works fine. OTOH=
,
> > "verif_scale_loop6" now fails, but from what I understand from the log,
> > it has nothing with the series ("8193 jumps is too complex" -- I don't
> > even touch program-related stuff). I don't know what's the reason of it
> > failing, can it be some CI issues or maybe some recent commits?
>
> Yeah. It's an issue with the latest clang.
> We don't have a workaround for this yet.
> It's not a blocker for your patchset.
> We didn't have time to look at it closely.

I applied the workaround for this test.
It's all green now except s390 where it fails with

test_xdp_do_redirect:PASS:prog_run 0 nsec
test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
test_xdp_do_redirect:FAIL:pkt_count_tc unexpected pkt_count_tc: actual
220 !=3D expected 9998
test_max_pkt_size:PASS:prog_run_max_size 0 nsec
test_max_pkt_size:PASS:prog_run_too_big 0 nsec
close_netns:PASS:setns 0 nsec
#289 xdp_do_redirect:FAIL
Summary: 270/1674 PASSED, 30 SKIPPED, 1 FAILED

Alex,
could you please take a look at why it's happening?

I suspect it's an endianness issue in:
        if (*metadata !=3D 0x42)
                return XDP_ABORTED;
but your patch didn't change that,
so I'm not sure why it worked before.
