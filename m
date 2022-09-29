Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8255EED4C
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 07:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiI2FiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 01:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiI2FiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 01:38:02 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3591612B481
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 22:38:01 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-353fbfa727cso4142957b3.4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 22:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=vz0fRDjbJOjYUQ/nlWZ1qBnLntPF4vStJr0Z5e5Tnq8=;
        b=h94bEFgNvlJwIfmXpBOWEDdZoe1CpIvw4ojjnjZMeDnk5xYQl5RafvRKLupXItRsHW
         ymWTLCS8WG11OdHv42Szl8hxYxzs9ddimiZSUbMMx7OyRZXMZrJofn/kmZ/Juc5zF3v8
         DdY5oT8PrA4yWVWMgVaicDo7dciGnEGSN4JCcHRONtkNzy0knrFGbML3Au0YiwCFXzig
         3S/3CFmNoy4WdgFg0p4h0gq5TL9iODevq3bkGJlaU0IJqUK/CJHFrqyeGtaRNewTHZec
         x5RIPhCH0e8CgIzseJD5VM31Iw+TOazgrcZZ3b+Ed1bj+86TecWawOEWFJ+A5yVcnxCb
         NtSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vz0fRDjbJOjYUQ/nlWZ1qBnLntPF4vStJr0Z5e5Tnq8=;
        b=2zrT6TwbrvvmoSuhsPrR2KC5bYjy53sA8sFz9N6fH2DMV0Eib4r5cr5QsT34SEHns1
         CY7q1jf7G0zcBW/gzLKNyv1nh0YQ7cIM6gWWp1CPLECpeFFleNoxbaRYnAoMyxRWd5LT
         /Lq7wkEc7gLjUrGpBa3qqEVxUmI6oY5CBd6jiLkO/V8g1gxVDepFTI5+dk3vHnt4BPKA
         S/PVzQ/CN+MyjaQiANHSgicj9VJ2smxIeamDEwXWNbeg+A/kdDbx21OR/6QhOUQ+TmMZ
         EsJGvlrr7xAzACYHBCzZbK0sit2xyxtXwOiMdSmdxBNZEeYOXbczfPKHuJva/QmF97Wx
         XVSg==
X-Gm-Message-State: ACrzQf1tje2hvtX6bBfCNM0NemvyOHdC5lyoQvKQGLfiPLfL9fXBSm5F
        uhqXT4q0box6+oE430yMyXdpNPrVlZJZySQQ0Nh07Q==
X-Google-Smtp-Source: AMsMyM5Bho2c+hRKT+OulkCUqFdDNTJiJRVsTyA6NryhEowp5N4Er5EgNzU2U4Mif9DS1KuMsOJnGhCYGqRTTNiJxOw=
X-Received: by 2002:a0d:e244:0:b0:351:ce09:1b13 with SMTP id
 l65-20020a0de244000000b00351ce091b13mr1414430ywe.332.1664429880178; Wed, 28
 Sep 2022 22:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220923224453.2351753-1-kafai@fb.com> <20220923224518.2353383-1-kafai@fb.com>
 <CANn89iLf+=AmMntTqy0HyOfbv6PASLsT+E4PhXMAX+xU1Zh2Yg@mail.gmail.com> <e529a40f-4c77-834e-3ac8-b58763b58993@linux.dev>
In-Reply-To: <e529a40f-4c77-834e-3ac8-b58763b58993@linux.dev>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 28 Sep 2022 22:37:49 -0700
Message-ID: <CANn89i+7G7kkN5mG=tEOd4xHAV7LyLQ7yj2a4hjsGb1_gFQ82A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/5] bpf: tcp: Stop bpf_setsockopt(TCP_CONGESTION)
 in init ops to recur itself
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 10:31 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 9/28/22 7:04 PM, Eric Dumazet wrote:
> > On Fri, Sep 23, 2022 at 3:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >>
> >> From: Martin KaFai Lau <martin.lau@kernel.org>
> >>
> >> When a bad bpf prog '.init' calls
> >> bpf_setsockopt(TCP_CONGESTION, "itself"), it will trigger this loop:
> >>
> >> .init => bpf_setsockopt(tcp_cc) => .init => bpf_setsockopt(tcp_cc) ...
> >> ... => .init => bpf_setsockopt(tcp_cc).
> >>
> >> It was prevented by the prog->active counter before but the prog->active
> >> detection cannot be used in struct_ops as explained in the earlier
> >> patch of the set.
> >>
> >> In this patch, the second bpf_setsockopt(tcp_cc) is not allowed
> >> in order to break the loop.  This is done by using a bit of
> >> an existing 1 byte hole in tcp_sock to check if there is
> >> on-going bpf_setsockopt(TCP_CONGESTION) in this tcp_sock.
> >>
> >> Note that this essentially limits only the first '.init' can
> >> call bpf_setsockopt(TCP_CONGESTION) to pick a fallback cc (eg. peer
> >> does not support ECN) and the second '.init' cannot fallback to
> >> another cc.  This applies even the second
> >> bpf_setsockopt(TCP_CONGESTION) will not cause a loop.
> >>
> >> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> >> ---
> >>   include/linux/tcp.h |  6 ++++++
> >>   net/core/filter.c   | 28 +++++++++++++++++++++++++++-
> >>   2 files changed, 33 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> >> index a9fbe22732c3..3bdf687e2fb3 100644
> >> --- a/include/linux/tcp.h
> >> +++ b/include/linux/tcp.h
> >> @@ -388,6 +388,12 @@ struct tcp_sock {
> >>          u8      bpf_sock_ops_cb_flags;  /* Control calling BPF programs
> >>                                           * values defined in uapi/linux/tcp.h
> >>                                           */
> >> +       u8      bpf_chg_cc_inprogress:1; /* In the middle of
> >> +                                         * bpf_setsockopt(TCP_CONGESTION),
> >> +                                         * it is to avoid the bpf_tcp_cc->init()
> >> +                                         * to recur itself by calling
> >> +                                         * bpf_setsockopt(TCP_CONGESTION, "itself").
> >> +                                         */
> >>   #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) (TP->bpf_sock_ops_cb_flags & ARG)
> >>   #else
> >>   #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) 0
> >> diff --git a/net/core/filter.c b/net/core/filter.c
> >> index 96f2f7a65e65..ac4c45c02da5 100644
> >> --- a/net/core/filter.c
> >> +++ b/net/core/filter.c
> >> @@ -5105,6 +5105,9 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk, int optname,
> >>   static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
> >>                                        int *optlen, bool getopt)
> >>   {
> >> +       struct tcp_sock *tp;
> >> +       int ret;
> >> +
> >>          if (*optlen < 2)
> >>                  return -EINVAL;
> >>
> >> @@ -5125,8 +5128,31 @@ static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
> >>          if (*optlen >= sizeof("cdg") - 1 && !strncmp("cdg", optval, *optlen))
> >>                  return -ENOTSUPP;
> >>
> >> -       return do_tcp_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
> >> +       /* It stops this looping
> >> +        *
> >> +        * .init => bpf_setsockopt(tcp_cc) => .init =>
> >> +        * bpf_setsockopt(tcp_cc)" => .init => ....
> >> +        *
> >> +        * The second bpf_setsockopt(tcp_cc) is not allowed
> >> +        * in order to break the loop when both .init
> >> +        * are the same bpf prog.
> >> +        *
> >> +        * This applies even the second bpf_setsockopt(tcp_cc)
> >> +        * does not cause a loop.  This limits only the first
> >> +        * '.init' can call bpf_setsockopt(TCP_CONGESTION) to
> >> +        * pick a fallback cc (eg. peer does not support ECN)
> >> +        * and the second '.init' cannot fallback to
> >> +        * another.
> >> +        */
> >> +       tp = tcp_sk(sk);
> >> +       if (tp->bpf_chg_cc_inprogress)
> >> +               return -EBUSY;
> >> +
> >
> > Is the socket locked (and owned by current thread) at this point ?
> > If not, changing bpf_chg_cc_inprogress would be racy.
>
> Yes, the socket is locked and owned.  There is a sock_owned_by_me check earlier
> in _bpf_setsockopt().

Good to know. Note a listener can be cloned without socket lock being held.

In order to avoid surprises, I would clear bpf_chg_cc_inprogress in
tcp_create_openreq_child()
