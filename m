Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F7751E0FD
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 23:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444404AbiEFVXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 17:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245548AbiEFVXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 17:23:23 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C5266AED;
        Fri,  6 May 2022 14:19:35 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id e3so9404011ios.6;
        Fri, 06 May 2022 14:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O89+Pj0R1K87sBA0p/6SiTAciUfgGWsngXnY3NHvp2I=;
        b=IFAlHwq1kcOb6ePWBdOk3f+48m38l479DGoupQW0Az6OAkUt5HreCPyvV5Cz4+gsoO
         3pDvHm3tje2xst6tErTi7D0NOpl+elks9n7e9m6cL/99jUkeFnshZxnpTX1fD9He3/pv
         x7pf/Ld1+uYbPqGyF2UH2BfvslAKhGD0fgW6fURiacffTzsJw5ITNC/Tq3ccYnSgD3C9
         Q+BH3FR6Ugudje3KusvIRzeVr+UMLsNKSV8pt1NLJhjZ94x9MLkx+JR17EjS/DZBVz5K
         CBfYfLyRH6K+OJeq4Gbkm31Vd+HDEBGrHsN1HPMoamQVeDdxn4ueW7OT1SuIqoDZMiCO
         3/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O89+Pj0R1K87sBA0p/6SiTAciUfgGWsngXnY3NHvp2I=;
        b=HxZyMqK7WBtzHuWpFhXFNPTwAI4RnlVuaE/LTCyPsvu5ZMC1pWkAn7z4Yt8mqFKvsX
         I7MlYMhSsx1XzTLHCx/F5Y+nUcxm6T6er5ygkYuS711NsBBhjOGaC5ReHNJtQsQUyYMq
         jTn7mSM01qEaghnmkHSOAUiJ1/iuImGSymsglGjfwYqhoRRLEfC41v/lA/dhObwbQQq+
         J0CcMonQs0ESg55tjdlvPg+CAIN62pqJjVdgljrZwhYW9NABV27KZKqLz2HMwDfJuDe+
         HSsnQZWd1JQndPrEl/1rPR5Bswbz/Vya3GhWZs4L9piozFfLTga0Gei6L+FfKKiwaFIp
         zgLg==
X-Gm-Message-State: AOAM533s6wgoJy6WKvNQS8vaFO2g7ZsNC2lmEQ3uKBx82M0C+sx+qZFq
        ifXaxE3c4sUxdd0bhONxSL0xEFHG9QLpPvGqrDk=
X-Google-Smtp-Source: ABdhPJxnBYHF81qMhqTjdrgq7ehU0fLwrNURNssgOXIZPgEdwFeQG2SfZgRHWy90PQiibuqfnbNIBqqk/Nd0bbUbfxU=
X-Received: by 2002:a05:6638:16d6:b0:32b:a283:a822 with SMTP id
 g22-20020a05663816d600b0032ba283a822mr2322177jat.145.1651871974324; Fri, 06
 May 2022 14:19:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220503171437.666326-1-maximmi@nvidia.com> <20220503171437.666326-4-maximmi@nvidia.com>
In-Reply-To: <20220503171437.666326-4-maximmi@nvidia.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 May 2022 14:19:23 -0700
Message-ID: <CAEf4BzYDfNuF4QL37ZLjR5--zimpycZsjzXhq6ao79_05+OOiA@mail.gmail.com>
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

On Tue, May 3, 2022 at 10:15 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> The new helpers bpf_tcp_raw_{gen,check}_syncookie_ipv{4,6} allow an XDP
> program to generate SYN cookies in response to TCP SYN packets and to
> check those cookies upon receiving the first ACK packet (the final
> packet of the TCP handshake).
>
> Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
> listening socket on the local machine, which allows to use them together
> with synproxy to accelerate SYN cookie generation.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  include/net/tcp.h              |   1 +
>  include/uapi/linux/bpf.h       |  78 ++++++++++++++++++++++
>  net/core/filter.c              | 118 +++++++++++++++++++++++++++++++++
>  net/ipv4/tcp_input.c           |   3 +-
>  scripts/bpf_doc.py             |   4 ++
>  tools/include/uapi/linux/bpf.h |  78 ++++++++++++++++++++++
>  6 files changed, 281 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 94a52ad1101c..45aafc28ce00 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -432,6 +432,7 @@ u16 tcp_v4_get_syncookie(struct sock *sk, struct iphdr *iph,
>                          struct tcphdr *th, u32 *cookie);
>  u16 tcp_v6_get_syncookie(struct sock *sk, struct ipv6hdr *iph,
>                          struct tcphdr *th, u32 *cookie);
> +u16 tcp_parse_mss_option(const struct tcphdr *th, u16 user_mss);
>  u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
>                           const struct tcp_request_sock_ops *af_ops,
>                           struct sock *sk, struct tcphdr *th);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4dd9e34f2a60..5e611d898302 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5156,6 +5156,80 @@ union bpf_attr {
>   *             if not NULL, is a reference which must be released using its
>   *             corresponding release function, or moved into a BPF map before
>   *             program exit.
> + *
> + * s64 bpf_tcp_raw_gen_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th, u32 th_len)
> + *     Description
> + *             Try to issue a SYN cookie for the packet with corresponding
> + *             IPv4/TCP headers, *iph* and *th*, without depending on a
> + *             listening socket.
> + *
> + *             *iph* points to the IPv4 header.
> + *
> + *             *th* points to the start of the TCP header, while *th_len*
> + *             contains the length of the TCP header (at least
> + *             **sizeof**\ (**struct tcphdr**)).
> + *     Return
> + *             On success, lower 32 bits hold the generated SYN cookie in
> + *             followed by 16 bits which hold the MSS value for that cookie,
> + *             and the top 16 bits are unused.
> + *
> + *             On failure, the returned value is one of the following:
> + *
> + *             **-EINVAL** if *th_len* is invalid.
> + *
> + * s64 bpf_tcp_raw_gen_syncookie_ipv6(struct ipv6hdr *iph, struct tcphdr *th, u32 th_len)
> + *     Description
> + *             Try to issue a SYN cookie for the packet with corresponding
> + *             IPv6/TCP headers, *iph* and *th*, without depending on a
> + *             listening socket.
> + *
> + *             *iph* points to the IPv6 header.
> + *
> + *             *th* points to the start of the TCP header, while *th_len*
> + *             contains the length of the TCP header (at least
> + *             **sizeof**\ (**struct tcphdr**)).
> + *     Return
> + *             On success, lower 32 bits hold the generated SYN cookie in
> + *             followed by 16 bits which hold the MSS value for that cookie,
> + *             and the top 16 bits are unused.
> + *
> + *             On failure, the returned value is one of the following:
> + *
> + *             **-EINVAL** if *th_len* is invalid.
> + *
> + *             **-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
> + *
> + * int bpf_tcp_raw_check_syncookie_ipv4(struct iphdr *iph, struct tcphdr *th)

Note that all existing helpers that just return error or 0 on success
return long. Please use long for consistency.

> + *     Description
> + *             Check whether *iph* and *th* contain a valid SYN cookie ACK
> + *             without depending on a listening socket.
> + *
> + *             *iph* points to the IPv4 header.
> + *
> + *             *th* points to the TCP header.
> + *     Return
> + *             0 if *iph* and *th* are a valid SYN cookie ACK.
> + *
> + *             On failure, the returned value is one of the following:
> + *
> + *             **-EACCES** if the SYN cookie is not valid.
> + *
> + * int bpf_tcp_raw_check_syncookie_ipv6(struct ipv6hdr *iph, struct tcphdr *th)

same

> + *     Description
> + *             Check whether *iph* and *th* contain a valid SYN cookie ACK
> + *             without depending on a listening socket.
> + *
> + *             *iph* points to the IPv6 header.
> + *
> + *             *th* points to the TCP header.
> + *     Return
> + *             0 if *iph* and *th* are a valid SYN cookie ACK.
> + *
> + *             On failure, the returned value is one of the following:
> + *
> + *             **-EACCES** if the SYN cookie is not valid.
> + *
> + *             **-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.

[...]
