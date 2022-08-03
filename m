Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09E5589167
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 19:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238129AbiHCRaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 13:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbiHCRaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 13:30:07 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDD9558EC;
        Wed,  3 Aug 2022 10:30:06 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a7so19736288ejp.2;
        Wed, 03 Aug 2022 10:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=U7nJWoGM/ebcYWkwdDIue8qTiA80fkgvIER+SYbZjPE=;
        b=WAG6eTdmnBbOaXUB+TGhPwZIc+XdJ8IuMYPZoYNl50YDJJ7HTmYzEQRV+04jPWfinn
         lo0wuNvgf6IEQ9aMu79X6mP/4XECOjxg13mM9k5hQQ1gohaORpml5qBg7gIiSmhkT5sP
         tIxkVXAmzjhvlHSLm6AiB5h7XX8g4O11GbZwgsyn7dvHecz7ZWK5j0heZf2zPWtcsMHP
         YtbIPj8EXWSYvaffthlKYO78WQ5OmhpoS0m6tRWZ868s/ZxCeDzoSmAVzHhCUpu35ovy
         8sW0PHdzgAQLj3QGyNo+1/L58oo7wCzVJwu7yNTWiR9r546uya/tLnK4aNHnqqEUksw2
         CnwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=U7nJWoGM/ebcYWkwdDIue8qTiA80fkgvIER+SYbZjPE=;
        b=soGVBBN/6R1VbS8quleFaDkGw8VybTy8OLI/wQ5cl4Aweg7E31vIB2PrE1+8qQOPm9
         JYfiBt9qz0+1ga9UF+QzGbEgpeoIK1kt6OiwLQJ7vhd0kDkRCNLxFRVBd7q1k9ha1/14
         BMRlvPlApLUjt1DKagtA2mgeaBPFQ47SeDQYVv5z4/be3Tq9Jh8NnxQ8/OlBTmQcMZQN
         X/Qz62RWttKM56XPFCEpWkpzYjjZJRs+XLRa9dAXF7OK+7Ow5gDn52d7+7EfFHQf8aD5
         k6yufKNvM8VRdzCuLGznAJWVA+jhXpFKcV2OeKlXaIqw+/BijNsfzsuBPQMmBCedONoN
         PiAg==
X-Gm-Message-State: AJIora8t2PD6+9f+ixrXERDlARUVKbMUx4HxUi33Yvd9FlvDqpPP0xZ4
        nLOfZKGHGOCwofzouJAtA0kBwRrXbR8026rD18E=
X-Google-Smtp-Source: AGRyM1v/yzAj7I0pvfA4lKVAuo8DXdPbWdkBAa1p9kg6fg3uu5iY78xqCz4WLFBwKe4xcfz4v5qkNpw63IaQDJC5/nI=
X-Received: by 2002:a17:906:3f51:b0:712:3945:8c0d with SMTP id
 f17-20020a1709063f5100b0071239458c0dmr20080647ejj.302.1659547804487; Wed, 03
 Aug 2022 10:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220606103734.92423-1-kurt@linutronix.de> <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
 <875ylc6djv.ffs@tglx> <c166aa47-e404-e6ee-0ec5-0ead1923f412@redhat.com>
 <CAADnVQKqo1XfrPO8OYA1VpArKHZotuDjGNtxM0AftUj_R+vU7g@mail.gmail.com>
 <87pmhj15vf.fsf@kurt> <CAADnVQ+aDn9ku8p0M2yaPQb_Qi3CxkcyhHbcKTq8y2hrDP5A8Q@mail.gmail.com>
 <87edxxg7qu.fsf@kurt> <Yuo/0hVGQcpTPxZD@boxer>
In-Reply-To: <Yuo/0hVGQcpTPxZD@boxer>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 3 Aug 2022 10:29:53 -0700
Message-ID: <CAEf4BzYSzOnJ9_76RFu7e6o_Q2JEen+F-GZbzaW86yh5xnM3Qw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 2:29 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Wed, Aug 03, 2022 at 08:29:29AM +0200, Kurt Kanzenbach wrote:
> > On Tue Aug 02 2022, Alexei Starovoitov wrote:
> > > On Tue, Aug 2, 2022 at 12:06 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
> > >>
> > >> Hi Alexei,
> > >>
> > >> On Tue Jun 07 2022, Alexei Starovoitov wrote:
> > >> > Anyway I guess new helper bpf_ktime_get_tai_ns() is ok, since
> > >> > it's so trivial, but selftest is necessary.
> > >>
> > >> So, I did write a selftest [1] for testing bpf_ktime_get_tai_ns() and
> > >> verifying that the access to the clock works. It uses AF_XDP sockets and
> > >> timestamps the incoming packets. The timestamps are then validated in
> > >> user space.
> > >>
> > >> Since AF_XDP related code is migrating from libbpf to libxdp, I'm
> > >> wondering if that sample fits into the kernel's selftests or not. What
> > >> kind of selftest are you looking for?
> > >
> > > Please use selftests/bpf framework.
> > > There are plenty of networking tests in there.
> > > bpf_ktime_get_tai_ns() doesn't have to rely on af_xdp.
> >
> > OK.
> >
> > > It can be skb based.
>
> FWIW there is xskxceiver and libbpf's xsk part in selftests/bpf framework,
> so your initial work should be fine in there. Personally I found both
> (AF_XDP and SKB one, below) tests valuable.

test_progs is always tested on each patch/patch set. xskxceiver can
potentially break without anyone noticing for a while. So having
something like this in test_progs is much better.

>
> Later on, if we add a support to xskxceiver for loading external BPF progs
> then your sample would just become another test case in there.
>
> >
> > Something like this?
> >
> > +++ b/tools/testing/selftests/bpf/prog_tests/check_tai.c
> > @@ -0,0 +1,57 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (C) 2022 Linutronix GmbH */
> > +
> > +#include <test_progs.h>
> > +#include <network_helpers.h>
> > +
> > +#include <time.h>
> > +#include <stdint.h>
> > +
> > +#define TAI_THRESHOLD        1000000000ULL /* 1s */
> > +#define NSEC_PER_SEC 1000000000ULL
> > +
> > +static __u64 ts_to_ns(const struct timespec *ts)
> > +{
> > +     return ts->tv_sec * NSEC_PER_SEC + ts->tv_nsec;
> > +}
> > +
> > +void test_tai(void)
> > +{
> > +     struct __sk_buff skb = {
> > +             .tstamp = 0,
> > +             .hwtstamp = 0,
> > +     };
> > +     LIBBPF_OPTS(bpf_test_run_opts, topts,
> > +             .data_in = &pkt_v4,
> > +             .data_size_in = sizeof(pkt_v4),
> > +             .ctx_in = &skb,
> > +             .ctx_size_in = sizeof(skb),
> > +             .ctx_out = &skb,
> > +             .ctx_size_out = sizeof(skb),
> > +     );
> > +     struct timespec now_tai;
> > +     struct bpf_object *obj;
> > +     int ret, prog_fd;
> > +
> > +     ret = bpf_prog_test_load("./test_tai.o",
> > +                              BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
> > +     if (!ASSERT_OK(ret, "load"))
> > +             return;
> > +     ret = bpf_prog_test_run_opts(prog_fd, &topts);
> > +     ASSERT_OK(ret, "test_run");
> > +
> > +     /* TAI != 0 */
> > +     ASSERT_NEQ(skb.tstamp, 0, "tai_ts0_0");
> > +     ASSERT_NEQ(skb.hwtstamp, 0, "tai_ts0_1");
> > +
> > +     /* TAI is moving forward only */
> > +     ASSERT_GT(skb.hwtstamp, skb.tstamp, "tai_forward");
> > +
> > +     /* Check for reasoneable range */
> > +     ret = clock_gettime(CLOCK_TAI, &now_tai);
> > +     ASSERT_EQ(ret, 0, "tai_gettime");
> > +     ASSERT_TRUE((ts_to_ns(&now_tai) - skb.hwtstamp) < TAI_THRESHOLD,
> > +                 "tai_range");
> > +
> > +     bpf_object__close(obj);
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/test_tai.c b/tools/testing/selftests/bpf/progs/test_tai.c
> > new file mode 100644
> > index 000000000000..34ac4175e29d
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_tai.c
> > @@ -0,0 +1,17 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (C) 2022 Linutronix GmbH */
> > +
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +char _license[] SEC("license") = "GPL";
> > +
> > +SEC("tc")
> > +int save_tai(struct __sk_buff *skb)
> > +{
> > +     /* Save TAI timestamps */
> > +     skb->tstamp = bpf_ktime_get_tai_ns();
> > +     skb->hwtstamp = bpf_ktime_get_tai_ns();
> > +
> > +     return 0;
> > +}
>
>
