Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528C5589FA9
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 19:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbiHDREM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 13:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiHDREL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 13:04:11 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFBE18368
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 10:04:10 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id m2so410659pls.4
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 10:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=G7OundpY9MzdKI4/Nm3i9+xMqdqDOIyzcwusNmWfl7w=;
        b=FoBAwJBeusHjNjB4pKUYUH/E5jbwqtM6GKMCsrbyHpfKprfCIs4noQ7f3TOJcXUqsd
         Qq0BIArG42eNims68M1EWsUD0m4SdV0flgN2iJ/b96b1GvwkH3uGJC92qeVbspZPCLC8
         8Bj3tgSGAqRuNDeZZgF63ncHeFlaB+GaS9k6QuHDaE8CmO4R5kkw24Ppue5jJyG9zIX6
         xNzbYlC7KArpspSLyL0NwYPYj6lUprhrLTe2freE/hnupZ/wP3MhGDNrz2NTs1P6n4fJ
         HEzrf+G6/AMs9Rsjahr+mk9lI9zZeEAezUGz2uJAjJr1jXRszuu05Isxc4t5Bi5TdplS
         ddKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=G7OundpY9MzdKI4/Nm3i9+xMqdqDOIyzcwusNmWfl7w=;
        b=I6eNJp4P5v9WWDUU9dK2sjlBCXq70ONy0Kx36Sl9t/w4v2KlyZUjcencv20XNVJA6U
         vG5dyecgJel1sKnKD7uaOE5oGpAflnvNZCOfPPQ8Pjz8xbnzCI+Wy4KJb/tlWze/VKie
         bNmX1xdEkORSrCoVDYwXXfQAxi7RSibaw9IAuIoCl9CPBLSus3zO1TYQC6VBkE32drzZ
         kBu04t4xqi2uHZtZuLXgEHiPkxkOUGJ4TaVYJmxiq1F37K7WPU71CbR6vKM8WDiEC2bw
         hEQbLmioUXpZLG5TiFr8GT09Y3NuTweskviTRfvn2NhtgPpj7Qje5jQh1AH5CjJe7uiD
         07+A==
X-Gm-Message-State: ACgBeo0klr+hXf880slbEUzAXGEOh//VAaB7GjNTuYWU2Oid/L2EoTVM
        plB8JEt5hbYaJyN+3fZG1HA6WRXuf94i8WBrfkggSg==
X-Google-Smtp-Source: AA6agR4y9VFDGwknlmiB4uYhHfZvRr8ai/hlUeiGukA3k/oisphhz14+PzCSOFR0g4fOPnAQJx8ofee7QgEISUGVHAk=
X-Received: by 2002:a17:90b:388e:b0:1f5:40d4:828d with SMTP id
 mu14-20020a17090b388e00b001f540d4828dmr3180442pjb.31.1659632649460; Thu, 04
 Aug 2022 10:04:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220803204601.3075863-1-kafai@fb.com> <20220803204736.3082620-1-kafai@fb.com>
 <YusFLu+OvcAIq1xr@google.com> <20220804000417.gmaqry4ecgjlpcvf@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220804000417.gmaqry4ecgjlpcvf@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 4 Aug 2022 10:03:58 -0700
Message-ID: <CAKH8qBsaXW4atjU984B1rjmK1OqUYNZZPDYFszDUs+O=ptju2Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 15/15] selftests/bpf: bpf_setsockopt tests
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 5:04 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Aug 03, 2022 at 04:30:54PM -0700, sdf@google.com wrote:
> > > +struct sock_common {
> > > +   unsigned short  skc_family;
> > > +   unsigned long   skc_flags;
> > > +   unsigned char   skc_reuse:4;
> > > +   unsigned char   skc_reuseport:1;
> > > +   unsigned char   skc_ipv6only:1;
> > > +   unsigned char   skc_net_refcnt:1;
> > > +} __attribute__((preserve_access_index));
> > > +
> > > +struct sock {
> > > +   struct sock_common      __sk_common;
> > > +   __u16                   sk_type;
> > > +   __u16                   sk_protocol;
> > > +   int                     sk_rcvlowat;
> > > +   __u32                   sk_mark;
> > > +   unsigned long           sk_max_pacing_rate;
> > > +   unsigned int            keepalive_time;
> > > +   unsigned int            keepalive_intvl;
> > > +} __attribute__((preserve_access_index));
> > > +
> > > +struct tcp_options_received {
> > > +   __u16 user_mss;
> > > +} __attribute__((preserve_access_index));
> >
> > I'm assuming you're not using vmlinux here because it doesn't bring
> > it most of the defines? Should we add missing stuff to bpf_tracing_net.h
> > instead?
> Ah, actually my first attempt was to use vmlinux.h and had
> all defines ready for addition to bpf_tracing_net.h.
>
> However, I hit an issue in reading bitfield.  It is why the
> bitfield in the tcp_sock below is sandwiched between __u32.
> I think it is likely LLVM and/or CO-RE related. Yonghong is
> helping to investigate it.
>
> In the mean time, I define those mini struct here.
> Once the bitfield issue is resolved, we can go back to
> use vmlinux.h.

Oh, interesting :-)

> > > +struct ipv6_pinfo {
> > > +   __u16                   recverr:1,
> > > +                           sndflow:1,
> > > +                           repflow:1,
> > > +                           pmtudisc:3,
> > > +                           padding:1,
> > > +                           srcprefs:3,
> > > +                           dontfrag:1,
> > > +                           autoflowlabel:1,
> > > +                           autoflowlabel_set:1,
> > > +                           mc_all:1,
> > > +                           recverr_rfc4884:1,
> > > +                           rtalert_isolate:1;
> > > +}  __attribute__((preserve_access_index));
> > > +
> > > +struct inet_sock {
> > > +   /* sk and pinet6 has to be the first two members of inet_sock */
> > > +   struct sock             sk;
> > > +   struct ipv6_pinfo       *pinet6;
> > > +} __attribute__((preserve_access_index));
> > > +
> > > +struct inet_connection_sock {
> > > +   __u32                     icsk_user_timeout;
> > > +   __u8                      icsk_syn_retries;
> > > +} __attribute__((preserve_access_index));
> > > +
> > > +struct tcp_sock {
> > > +   struct inet_connection_sock     inet_conn;
> > > +   struct tcp_options_received rx_opt;
> > > +   __u8    save_syn:2,
> > > +           syn_data:1,
> > > +           syn_fastopen:1,
> > > +           syn_fastopen_exp:1,
> > > +           syn_fastopen_ch:1,
> > > +           syn_data_acked:1,
> > > +           is_cwnd_limited:1;
> > > +   __u32   window_clamp;
> > > +   __u8    nonagle     : 4,
> > > +           thin_lto    : 1,
> > > +           recvmsg_inq : 1,
> > > +           repair      : 1,
> > > +           frto        : 1;
> > > +   __u32   notsent_lowat;
> > > +   __u8    keepalive_probes;
> > > +   unsigned int            keepalive_time;
> > > +   unsigned int            keepalive_intvl;
> > > +} __attribute__((preserve_access_index));
> > > +
> > > +struct socket {
> > > +   struct sock *sk;
> > > +} __attribute__((preserve_access_index));
> > > +
> > > +struct loop_ctx {
> > > +   void *ctx;
> > > +   struct sock *sk;
> > > +};
> > > +
> > > +static int __bpf_getsockopt(void *ctx, struct sock *sk,
> > > +                       int level, int opt, int *optval,
> > > +                       int optlen)
> > > +{
> > > +   if (level == SOL_SOCKET) {
> > > +           switch (opt) {
> > > +           case SO_REUSEADDR:
> > > +                   *optval = !!(sk->__sk_common.skc_reuse);
> > > +                   break;
> > > +           case SO_KEEPALIVE:
> > > +                   *optval = !!(sk->__sk_common.skc_flags & (1UL << 3));
> > > +                   break;
> > > +           case SO_RCVLOWAT:
> > > +                   *optval = sk->sk_rcvlowat;
> > > +                   break;
> >
> > What's the idea with the options above? Why not allow them in
> > bpf_getsockopt instead?
> I am planning to refactor the bpf_getsockopt also,
> so trying to avoid adding more dup code at this point
> while they can directly be read from sk through PTR_TO_BTF_ID.
>
> btw, since we are on bpf_getsockopt(), do you still see a usage on
> bpf_getsockopt() for those 'integer-value' optnames that can be
> easily read from the sk pointer ?

Writing is still done via bpf_setsockopt, so having the same interface
to read the settings seems useful?




> > > +           case SO_MARK:
> > > +                   *optval = sk->sk_mark;
> > > +                   break;
> >
> > SO_MARK should be handled by bpf_getsockopt ?
> Good point, will remove SO_MARK case.
>
> Thanks for the review!
