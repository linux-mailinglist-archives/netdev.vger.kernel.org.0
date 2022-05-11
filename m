Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAD3522814
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 02:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbiEKADX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 20:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiEKADW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 20:03:22 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5694517D3A0;
        Tue, 10 May 2022 17:03:21 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id z26so459468iot.8;
        Tue, 10 May 2022 17:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E9IShPzmirrnxjaf4QbXtujfHtRgLcfxaPODBOBzEOM=;
        b=YW2+p5g1ZLTIauXt3MvyO7yeNTvxCVRBAQ7S0rZmroSuBeECRUvYckp3MuO4+DAlDk
         yv2+4e9EMqitLerTuKHukBOtW21KHeg1ErrkD0aKPQzxv6rQ79T0Fq/ukTBD+wYSDqT/
         StUjKNN4tQDfcGvO9rbWwpqVtchNZs1w3tRzIZUglFE8XD5EtVhE9Iy6+S1A9hUYPJ5n
         qHHII1YX+HQgNRTO6zb1Xi6gyKrcFECvWAX8Eaqq6Np6sHn3JYeFI9/Vhf+Ft+QiffsV
         2KPtOe+P80S98LcfU9XgIu8OCPPqeaasZ+ZmY+UHT++EaY6aFJnnx9WJGt1LsU4fYDfW
         AUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E9IShPzmirrnxjaf4QbXtujfHtRgLcfxaPODBOBzEOM=;
        b=aGtmyAngbG+kr+l466u6A2kGgajhyLsqR70SGpc4r8RtKG20bCfn4zHQEOGad2OGkC
         F6RKmLWXYwb91a88uqVHgbiJ3cJnM+pNQKstcmVufsHDolOmWneDYQ7XSBsj25Jvwyrt
         K9CFZgklBuFkGPXq1nZOtGoJhtE2henJb6oGtYqVyVaNCXu49lS4VcCSrBdOUMTtUHTc
         ugQi6oCMpCtJYN68wfcBeDa1okw/dDOjew6L0mtrtM+/uCOM5poRgtLG9FCeQkWQeaeR
         CNkYSru2EgdgpcwkfCY3Rvbliy5GoezZmpMscKaAIvuM5lAc2vRntlbSYfcKEC1dtPv+
         PahA==
X-Gm-Message-State: AOAM532SJdtZBcLeHnApIKr9iR6Z9YQ+9Z9/ItNKGiZkoU+ArRPbjcrD
        bsOeULka1u9l7w7SY3V/aS0A0+Q3lw0k7tnkkdA=
X-Google-Smtp-Source: ABdhPJz8wXN2eT/5ZI1rqf3pVWXxV7su1egOJGb8lzC4G5vEMVz1JbF84JjCOxY593xUFZzMAwjlLZhAfV9AW1n+87c=
X-Received: by 2002:a05:6602:248f:b0:65a:fb17:7a6b with SMTP id
 g15-20020a056602248f00b0065afb177a6bmr5476735ioe.79.1652227400674; Tue, 10
 May 2022 17:03:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220503171437.666326-1-maximmi@nvidia.com> <20220503171437.666326-4-maximmi@nvidia.com>
 <CAEf4BzYDfNuF4QL37ZLjR5--zimpycZsjzXhq6ao79_05+OOiA@mail.gmail.com> <1eaebd1b-6933-20c9-1371-0429703bab2f@nvidia.com>
In-Reply-To: <1eaebd1b-6933-20c9-1371-0429703bab2f@nvidia.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 May 2022 17:03:09 -0700
Message-ID: <CAEf4Bzag0JBN0bHsPTb-YHZ+sBB3LTSvp8PjtftAvMkdVNWKmA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 3/5] bpf: Add helpers to issue and check SYN
 cookies in XDP
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 12:20 PM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> On 2022-05-07 00:19, Andrii Nakryiko wrote:
> > On Tue, May 3, 2022 at 10:15 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> >>
> >> The new helpers bpf_tcp_raw_{gen,check}_syncookie_ipv{4,6} allow an XDP
> >> program to generate SYN cookies in response to TCP SYN packets and to
> >> check those cookies upon receiving the first ACK packet (the final
> >> packet of the TCP handshake).
> >>
> >> Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
> >> listening socket on the local machine, which allows to use them together
> >> with synproxy to accelerate SYN cookie generation.
> >>
> >> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> >> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> >> ---
> >>   include/net/tcp.h              |   1 +
> >>   include/uapi/linux/bpf.h       |  78 ++++++++++++++++++++++
> >>   net/core/filter.c              | 118 +++++++++++++++++++++++++++++++++
> >>   net/ipv4/tcp_input.c           |   3 +-
> >>   scripts/bpf_doc.py             |   4 ++
> >>   tools/include/uapi/linux/bpf.h |  78 ++++++++++++++++++++++
> >>   6 files changed, 281 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/net/tcp.h b/include/net/tcp.h
> >> index 94a52ad1101c..45aafc28ce00 100644
> >> --- a/include/net/tcp.h
> >> +++ b/include/net/tcp.h
> >> @@ -432,6 +432,7 @@ u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
> >>                           struct tcphdr *th, u32 *cookie);
> >>   u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
> >>                           struct tcphdr *th, u32 *cookie);
> >> +u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss);
> >>   u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
> >>                            const struct tcp_request_sock_ops *af_ops,
> >>                            struct sock *sk, struct tcphdr *th);
> >> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >> index 4dd9e34f2a60..5e611d898302 100644
> >> --- a/include/uapi/linux/bpf.h
> >> +++ b/include/uapi/linux/bpf.h
> >> @@ -5156,6 +5156,80 @@ union bpf_attr {
> >>    *             if not NULL, is a reference which must be released using its
> >>    *             corresponding release function, or moved into a BPF map before
> >>    *             program exit.
> >> + *
> >> + * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th, u32 th_len)
> >> + *     Description
> >> + *             Try to issue a SYN cookie for the packet with corresponding
> >> + *             IPv4/TCP headers, *iph* and *th*, without depending on a
> >> + *             listening socket.
> >> + *
> >> + *             *iph* points to the IPv4 header.
> >> + *
> >> + *             *th* points to the start of the TCP header, while *th_len*
> >> + *             contains the length of the TCP header (at least
> >> + *             **sizeof**\ (**struct tcphdr**)).
> >> + *     Return
> >> + *             On success, lower 32 bits hold the generated SYN cookie in
> >> + *             followed by 16 bits which hold the MSS value for that cookie,
> >> + *             and the top 16 bits are unused.
> >> + *
> >> + *             On failure, the returned value is one of the following:
> >> + *
> >> + *             **-EINVAL** if *th_len* is invalid.
> >> + *
> >> + * s64 bpf_tcp_raw_gen_syncookie_ipv6(struct ipv6hdr *iph, struct tcphdr *th, u32 th_len)
> >> + *     Description
> >> + *             Try to issue a SYN cookie for the packet with corresponding
> >> + *             IPv6/TCP headers, *iph* and *th*, without depending on a
> >> + *             listening socket.
> >> + *
> >> + *             *iph* points to the IPv6 header.
> >> + *
> >> + *             *th* points to the start of the TCP header, while *th_len*
> >> + *             contains the length of the TCP header (at least
> >> + *             **sizeof**\ (**struct tcphdr**)).
> >> + *     Return
> >> + *             On success, lower 32 bits hold the generated SYN cookie in
> >> + *             followed by 16 bits which hold the MSS value for that cookie,
> >> + *             and the top 16 bits are unused.
> >> + *
> >> + *             On failure, the returned value is one of the following:
> >> + *
> >> + *             **-EINVAL** if *th_len* is invalid.
> >> + *
> >> + *             **-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
> >> + *
> >> + * int bpf_tcp_raw_check_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th)
> >
> > Note that all existing helpers that just return error or 0 on success
> > return long. Please use long for consistency.
>
> OK. There are some existing helpers that return int, though:
> bpf_inode_storage_delete, bpf_get_retval, bpf_set_retval. They should
> probably be fixed by someone as well.
>

Yep, they probably should, thanks for pointing missed cases out!

> >> + *     Description
> >> + *             Check whether *iph* and *th* contain a valid SYN cookie ACK
> >> + *             without depending on a listening socket.
> >> + *
> >> + *             *iph* points to the IPv4 header.
> >> + *
> >> + *             *th* points to the TCP header.
> >> + *     Return
> >> + *             0 if *iph* and *th* are a valid SYN cookie ACK.
> >> + *
> >> + *             On failure, the returned value is one of the following:
> >> + *
> >> + *             **-EACCES** if the SYN cookie is not valid.
> >> + *
> >> + * int bpf_tcp_raw_check_syncookie_ipv6(struct ipv6hdr *iph, struct tcphdr *th)
> >
> > same
> >
> >> + *     Description
> >> + *             Check whether *iph* and *th* contain a valid SYN cookie ACK
> >> + *             without depending on a listening socket.
> >> + *
> >> + *             *iph* points to the IPv6 header.
> >> + *
> >> + *             *th* points to the TCP header.
> >> + *     Return
> >> + *             0 if *iph* and *th* are a valid SYN cookie ACK.
> >> + *
> >> + *             On failure, the returned value is one of the following:
> >> + *
> >> + *             **-EACCES** if the SYN cookie is not valid.
> >> + *
> >> + *             **-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
> >
> > [...]
>
