Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5634648CD5B
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 22:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiALVCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 16:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiALVCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 16:02:12 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBFAC06173F;
        Wed, 12 Jan 2022 13:02:12 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id t24so14923324edi.8;
        Wed, 12 Jan 2022 13:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e8RxVqNZoNNOaNjzrM6qnb33u+GPv3V5PwxC/EGtQ0E=;
        b=KXUqNknUHT8kH4z6Gw49/xtBmjDBUXH7046vJwefzQiqv+aiaUWBIoOBSNbbUCeXO+
         6ww45E6q4oEL5rn1VOU5/XRlXsAxee+TB5CGctyhBDJKUzyXyM+cuNYTTy5ypspG4U/+
         sFbus82VkJJIMZ/6NCHrCQxaKW/RVFGjsttPijhzgGgYmzeQ8o54RezmURVK3DexdnVT
         vl9ozL6sovZW8UDjiuJg/hLS2cBQfWGw4WylzD0b9aiR0pK/JjR/OxCkLjQd8inMfEBw
         N1SKZ85vr2sxj96HZb6weopBBkWsWivrCx1C03oOKMOW7rCpy4QQ8o/sh9hfzmFtiGKi
         Mq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e8RxVqNZoNNOaNjzrM6qnb33u+GPv3V5PwxC/EGtQ0E=;
        b=ZgYpuQRDpsk9gcVvOn/H0upnDNxqwfgtC3pI31XC3Qa3kdnA9/JiYA59pUBEzSBfo1
         tFy9G3GOgI49cmQ7MvbeUdrLpb/+pxIWv12ot2yTBKb/GFjOOLTaku0EIjTBg58LMVc3
         IuDihGeOuNy/YM8/5/a27I70uDKXzNf7Hzdjd0fg+T0Uaoi3IRQ+YoBNDngzrPsJnUXQ
         0Ohk1Ahdrt6Qk9huwpEsrMvXU08rv40MAaU1wWw5ONTWzD424sMb5j4ktfECbmzJhAsr
         Bt2W9Gbv8v1Z/oj1nF/1BlNgF9Mnkwq+N/PtnkBcfn9mkFRIoHfSdoQH5e0FmztENvdk
         hSIA==
X-Gm-Message-State: AOAM530C2hkMtxpVnQvMelqIteIjnZGiwDpqFRJ++ZCU33qUkzqPfZUF
        Z4jpClYCVgSP/q8O3yEa8DUu4ylcq2zUQ2qktSU=
X-Google-Smtp-Source: ABdhPJz/WIe5yi8yiW2BB2Me/bO/Q13ESLxz27yznc1H1Ynjbbmth1JNWlXr4qaPxUlXsmyYr77eQFgdbHDZBwchBy8=
X-Received: by 2002:a05:6402:1159:: with SMTP id g25mr1370051edw.28.1642021330489;
 Wed, 12 Jan 2022 13:02:10 -0800 (PST)
MIME-Version: 1.0
References: <20220111192952.49040-1-ivan@cloudflare.com>
In-Reply-To: <20220111192952.49040-1-ivan@cloudflare.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 12 Jan 2022 13:01:58 -0800
Message-ID: <CAA93jw6HKLh857nuh2eX2N=siYz5wwQknMaOtpkqLzpfWTGhuA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tcp: bpf: Add TCP_BPF_RCV_SSTHRESH for bpf_setsockopt
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     bpf@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 11:59 AM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> This patch adds bpf_setsockopt(TCP_BPF_RCV_SSTHRESH) to allow setting
> rcv_ssthresh value for TCP connections. Combined with increased
> window_clamp via tcp_rmem[1], it allows to advertise initial scaled
> TCP window larger than 64k. This is useful for high BDP connections,
> where it allows to push data with fewer roundtrips, reducing latency.

I would not use the word "latency" in this way, I would just say
potentially reducing
roundtrips...

and potentially massively increasing packet loss, oversaturating
links, and otherwise
hurting latency for other applications sharing the link, including the
application
that advertised an extreme window like this.

This overall focus tends to freak me out somewhat, especially when
faced with further statements that cloudflare is using an initcwnd of 250!?=
??

The kind of damage just IW10 can do to much slower bandwidth
connections has to be
experienced to be believed.

https://tools.ietf.org/id/draft-gettys-iw10-considered-harmful-00.html

>
> For active connections the larger window is advertised in the first
> non-SYN ACK packet as the part of the 3 way handshake.
>
> For passive connections the larger window is advertised whenever
> there's any packet to send after the 3 way handshake.
>
> See: https://lkml.org/lkml/2021/12/22/652
>
> Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
> ---
>  include/uapi/linux/bpf.h       | 1 +
>  net/core/filter.c              | 6 ++++++
>  tools/include/uapi/linux/bpf.h | 1 +
>  3 files changed, 8 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 791f31dd0abe..36ebf87278bd 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5978,6 +5978,7 @@ enum {
>         TCP_BPF_SYN             =3D 1005, /* Copy the TCP header */
>         TCP_BPF_SYN_IP          =3D 1006, /* Copy the IP[46] and TCP head=
er */
>         TCP_BPF_SYN_MAC         =3D 1007, /* Copy the MAC, IP[46], and TC=
P header */
> +       TCP_BPF_RCV_SSTHRESH    =3D 1008, /* Set rcv_ssthresh */
>  };
>
>  enum {
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2e32cee2c469..aafb6066b1a6 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4904,6 +4904,12 @@ static int _bpf_setsockopt(struct sock *sk, int le=
vel, int optname,
>                                         return -EINVAL;
>                                 inet_csk(sk)->icsk_rto_min =3D timeout;
>                                 break;
> +                       case TCP_BPF_RCV_SSTHRESH:
> +                               if (val <=3D 0)
> +                                       ret =3D -EINVAL;
> +                               else
> +                                       tp->rcv_ssthresh =3D min_t(u32, v=
al, tp->window_clamp);
> +                               break;
>                         case TCP_SAVE_SYN:
>                                 if (val < 0 || val > 1)
>                                         ret =3D -EINVAL;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
> index 791f31dd0abe..36ebf87278bd 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -5978,6 +5978,7 @@ enum {
>         TCP_BPF_SYN             =3D 1005, /* Copy the TCP header */
>         TCP_BPF_SYN_IP          =3D 1006, /* Copy the IP[46] and TCP head=
er */
>         TCP_BPF_SYN_MAC         =3D 1007, /* Copy the MAC, IP[46], and TC=
P header */
> +       TCP_BPF_RCV_SSTHRESH    =3D 1008, /* Set rcv_ssthresh */
>  };
>
>  enum {
> --
> 2.34.1
>


--=20
I tried to build a better future, a few times:
https://wayforward.archive.org/?site=3Dhttps%3A%2F%2Fwww.icei.org

Dave T=C3=A4ht CEO, TekLibre, LLC
