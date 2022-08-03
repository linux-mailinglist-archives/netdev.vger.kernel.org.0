Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862A9589163
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 19:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237942AbiHCR2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 13:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbiHCR2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 13:28:51 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537B854CBD;
        Wed,  3 Aug 2022 10:28:49 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a7so19730826ejp.2;
        Wed, 03 Aug 2022 10:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=agVoYt1VG5qsMQ9JYe4JEPFq+nuCJIK9+LPfhBj53cg=;
        b=mcqU+cFDb27B3ksX+sdAGZ9R4qRKk2EcQHiEk0aiCDPJ5Ghvp+1/dJXh+wa0uViODF
         3RmjmZ4RhcnMZM3w3Y9R7+Oo7ALZhIeTCUewVnrkxDMJ+w+M4gf+fpU3gaUsS86Ab+8+
         KgQrrrYaKGRD6s38WF7btIYxvfGSszab1QFeQx/br5hfhFrh4gxqSpS1wyAlMm8ZeLRe
         9inX9f1ePtR60pexvKMBT+g8YaBgCTCIrKxwlZh2ZZJhYWXJ1ggCiJy60Df4BRjYnr9G
         mJSJPMsthIUioUyWDxAexsEPzcKQeJoyrjdO6M07WRkahcsjg4Cq6ACsEuqj9QOucgD4
         IjTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=agVoYt1VG5qsMQ9JYe4JEPFq+nuCJIK9+LPfhBj53cg=;
        b=QPujIHVF7Ub0F4tbHyp9qc5RrcEZYsvhVdPsqHKpqrRcStK7otuo6z0eZ23RLwcAWV
         SbQ1evl9Q/O+bSg3FlAUKuR+GFccPMFpgJJako2NMGt31fzJB+M91dNveZItGDAhbwWJ
         w98NFmjohCW9dGc1CHgRuPy+O/rY88cTXHGRsyBsvba2+9XBrKRoc/xuoJEUYSbt9fs1
         WabsoM3LYT42539Lr8Y5iL8mJzpw1Wha+O9yXUVkloqoD/jf9TfwsPUgtWkFMUjSPlJ2
         Akvf1qUICsrWoyuIgKA+LC2NRssuciZxH0M4yV65FLJShjyfWQmT+k6qrBpUFzJKwxld
         t3tQ==
X-Gm-Message-State: AJIora/p7PHeHnosAk09fChU2JeHbkjDbZlOxl0JN8X6VQUfTex4T+Ld
        maacD2h8k24JnnXlK36PQa7Y1oaZ5HlbHa0JD5k=
X-Google-Smtp-Source: AGRyM1tS8tV2I7KwfPPQYk0TciS595GLvnZoTg76Ou7VlivRU6mTt7rU080/yE1hfXDvUXtzCSgoIYWqBtqbN+sL2P0=
X-Received: by 2002:a17:907:6e1d:b0:72f:20ad:e1b6 with SMTP id
 sd29-20020a1709076e1d00b0072f20ade1b6mr21346463ejc.545.1659547727748; Wed, 03
 Aug 2022 10:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220606103734.92423-1-kurt@linutronix.de> <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
 <875ylc6djv.ffs@tglx> <c166aa47-e404-e6ee-0ec5-0ead1923f412@redhat.com>
 <CAADnVQKqo1XfrPO8OYA1VpArKHZotuDjGNtxM0AftUj_R+vU7g@mail.gmail.com>
 <87pmhj15vf.fsf@kurt> <CAADnVQ+aDn9ku8p0M2yaPQb_Qi3CxkcyhHbcKTq8y2hrDP5A8Q@mail.gmail.com>
 <87edxxg7qu.fsf@kurt>
In-Reply-To: <87edxxg7qu.fsf@kurt>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 3 Aug 2022 10:28:36 -0700
Message-ID: <CAEf4BzZtraeLSP4wcNk7t4sqDK6t2HVoo57nkUhVVLNCWe=JfA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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

On Tue, Aug 2, 2022 at 11:29 PM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> On Tue Aug 02 2022, Alexei Starovoitov wrote:
> > On Tue, Aug 2, 2022 at 12:06 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
> >>
> >> Hi Alexei,
> >>
> >> On Tue Jun 07 2022, Alexei Starovoitov wrote:
> >> > Anyway I guess new helper bpf_ktime_get_tai_ns() is ok, since
> >> > it's so trivial, but selftest is necessary.
> >>
> >> So, I did write a selftest [1] for testing bpf_ktime_get_tai_ns() and
> >> verifying that the access to the clock works. It uses AF_XDP sockets and
> >> timestamps the incoming packets. The timestamps are then validated in
> >> user space.
> >>
> >> Since AF_XDP related code is migrating from libbpf to libxdp, I'm
> >> wondering if that sample fits into the kernel's selftests or not. What
> >> kind of selftest are you looking for?
> >
> > Please use selftests/bpf framework.
> > There are plenty of networking tests in there.
> > bpf_ktime_get_tai_ns() doesn't have to rely on af_xdp.
>
> OK.
>
> > It can be skb based.
>
> Something like this?
>
> +++ b/tools/testing/selftests/bpf/prog_tests/check_tai.c
> @@ -0,0 +1,57 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2022 Linutronix GmbH */
> +
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +
> +#include <time.h>
> +#include <stdint.h>
> +
> +#define TAI_THRESHOLD  1000000000ULL /* 1s */
> +#define NSEC_PER_SEC   1000000000ULL
> +
> +static __u64 ts_to_ns(const struct timespec *ts)
> +{
> +       return ts->tv_sec * NSEC_PER_SEC + ts->tv_nsec;
> +}
> +
> +void test_tai(void)
> +{
> +       struct __sk_buff skb = {
> +               .tstamp = 0,
> +               .hwtstamp = 0,
> +       };
> +       LIBBPF_OPTS(bpf_test_run_opts, topts,
> +               .data_in = &pkt_v4,
> +               .data_size_in = sizeof(pkt_v4),
> +               .ctx_in = &skb,
> +               .ctx_size_in = sizeof(skb),
> +               .ctx_out = &skb,
> +               .ctx_size_out = sizeof(skb),
> +       );
> +       struct timespec now_tai;
> +       struct bpf_object *obj;
> +       int ret, prog_fd;
> +
> +       ret = bpf_prog_test_load("./test_tai.o",
> +                                BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);

it would be best to rely on BPF skeleton, please see other tests
including *.skel.h, thanks

> +       if (!ASSERT_OK(ret, "load"))
> +               return;
> +       ret = bpf_prog_test_run_opts(prog_fd, &topts);
> +       ASSERT_OK(ret, "test_run");
> +
> +       /* TAI != 0 */
> +       ASSERT_NEQ(skb.tstamp, 0, "tai_ts0_0");
> +       ASSERT_NEQ(skb.hwtstamp, 0, "tai_ts0_1");
> +
> +       /* TAI is moving forward only */
> +       ASSERT_GT(skb.hwtstamp, skb.tstamp, "tai_forward");
> +
> +       /* Check for reasoneable range */
> +       ret = clock_gettime(CLOCK_TAI, &now_tai);
> +       ASSERT_EQ(ret, 0, "tai_gettime");
> +       ASSERT_TRUE((ts_to_ns(&now_tai) - skb.hwtstamp) < TAI_THRESHOLD,
> +                   "tai_range");
> +
> +       bpf_object__close(obj);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_tai.c b/tools/testing/selftests/bpf/progs/test_tai.c
> new file mode 100644
> index 000000000000..34ac4175e29d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_tai.c
> @@ -0,0 +1,17 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2022 Linutronix GmbH */
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +SEC("tc")
> +int save_tai(struct __sk_buff *skb)
> +{
> +       /* Save TAI timestamps */
> +       skb->tstamp = bpf_ktime_get_tai_ns();
> +       skb->hwtstamp = bpf_ktime_get_tai_ns();
> +
> +       return 0;
> +}
