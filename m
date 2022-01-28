Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BECD4A0000
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 19:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244313AbiA1SRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 13:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbiA1SRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 13:17:31 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40008C061714;
        Fri, 28 Jan 2022 10:17:31 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d1so6797105plh.10;
        Fri, 28 Jan 2022 10:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VoffFS2DVxXcJh7lt5JKMy7SMJP+JOI5UQCY5v8WCWU=;
        b=A0t53+zcq6rO2TvUISaESwNw61vkJPvaeR0ifHXSV9JAJpEqaYAah0iAd6nZIaxw3H
         iybqGIIcTnpE4R6P2KsrrKtLCYa5LLRFvFYSo8VUFkG1TlbPnh+BpvVkpqoTkCUKtNHh
         3Nbfryg0MlMcM3JhozQWxoSECsqPSDTFAREKEKNw+EhlMSMCLBN6igufB5taIJfArLvj
         HFJpZ2qfvt8vwRQaklB437JPXLeOCZO+HPu0FGf2jIlE/TMzCZ34F9T49M90wj4B+n/q
         YbEjCG9QfNCkUBt73MyirAd/zmAy4fW0mP3IoQj3mXVXuTcIMuHrsx6dB9viZPwEn3WS
         nGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VoffFS2DVxXcJh7lt5JKMy7SMJP+JOI5UQCY5v8WCWU=;
        b=7X+v5DMJmjim3edbnaXsnXUNOUG3SCQGRXv9rmg10y1V8JhsDHno+0kDDX9r5+2KFP
         FyUQnUqk6u9WqMMjB8xJ+M2qP+CJPCjCZerDtxiYEe/Tt6vklqbSHOgtnGH0g99T1/4M
         oy2IgP+DNfMkZ7mLvdwcbia5UiRpd/mOoEdvXNoya/I2VJ+GAbgvNhOY88V34BajEt4k
         0e4fzf0eKui8PEQaBIM+omC0zsCS0Vr7bOfUKjoXp5OqvXAFDtYlnwnK6TVvXqlqKbDl
         oW+YLD71N41/daVG+uZHaVERAIFW8qdhDfD+LgC0YCGjHlQPEb6M+biLCIpGIcmqseTC
         yJ7Q==
X-Gm-Message-State: AOAM5310eoMIx9kMG5rvKTdy3uFJ7hwHylo8uLJIqoyTJRp/EvOU2Qc7
        Z6+tQwS/wXXH/BR1uksdQKO0jr3hBU2R2hWpklQ=
X-Google-Smtp-Source: ABdhPJxRbfCiqhuF7/K8EYdJRPITkxDQynz1wKfzxLlzGrrW4sNw5FCseAgJPW0mzCxTGeXRH37ivwxe9u7Q8GSdlvc=
X-Received: by 2002:a17:902:d4c5:: with SMTP id o5mr9991186plg.116.1643393850711;
 Fri, 28 Jan 2022 10:17:30 -0800 (PST)
MIME-Version: 1.0
References: <20220127172448.155686-1-jakub@cloudflare.com> <20220127172448.155686-2-jakub@cloudflare.com>
In-Reply-To: <20220127172448.155686-2-jakub@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 28 Jan 2022 10:17:19 -0800
Message-ID: <CAADnVQ+96ORKkbUA-Y7xiYV=TxSTh=p78f+t8TR4SN=YBMoEPA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Make dst_port field in struct bpf_sock
 16-bit wide
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 9:24 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Menglong Dong reports that the documentation for the dst_port field in
> struct bpf_sock is inaccurate and confusing. From the BPF program PoV, the
> field is a zero-padded 16-bit integer in network byte order. The value
> appears to the BPF user as if laid out in memory as so:
>
>   offsetof(struct bpf_sock, dst_port) + 0  <port MSB>
>                                       + 8  <port LSB>
>                                       +16  0x00
>                                       +24  0x00
>
> 32-, 16-, and 8-bit wide loads from the field are all allowed, but only if
> the offset into the field is 0.
>
> 32-bit wide loads from dst_port are especially confusing. The loaded value,
> after converting to host byte order with bpf_ntohl(dst_port), contains the
> port number in the upper 16-bits.
>
> Remove the confusion by splitting the field into two 16-bit fields. For
> backward compatibility, allow 32-bit wide loads from offsetof(struct
> bpf_sock, dst_port).
>
> While at it, allow loads 8-bit loads at offset [0] and [1] from dst_port.
>
> Reported-by: Menglong Dong <imagedong@tencent.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/uapi/linux/bpf.h | 3 ++-
>  net/core/filter.c        | 9 ++++++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4a2f7041ebae..027e84b18b51 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5574,7 +5574,8 @@ struct bpf_sock {
>         __u32 src_ip4;
>         __u32 src_ip6[4];
>         __u32 src_port;         /* host byte order */
> -       __u32 dst_port;         /* network byte order */
> +       __be16 dst_port;        /* network byte order */
> +       __u16 zero_padding;

I was wondering can we do '__u16 :16' here ?

Should we do the same for bpf_sk_lookup->remote_port as well
for consistency?

Thanks for the idea and the patches!
