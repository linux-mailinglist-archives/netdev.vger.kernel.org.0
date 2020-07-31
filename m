Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B62A2348C7
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 17:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387616AbgGaP5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 11:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgGaP5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 11:57:41 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C03C061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 08:57:41 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id z17so10620500ill.6
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 08:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LkwiBvNLTx8n7MhzzdDaiavRIGjiDc67DNZgPaIqd0Q=;
        b=oAKWZAmJ0ytmNAkYu1LbOIynlNPXhIeKqdCp/NBgyqaf5/IYgKjQ96/c9SEkAVteQf
         y0BD9cE1eHWUAs3gC8hrL9hzG5ZNEqLQ8Rg9OIqwnAAwZ/c1sm53gN6+D2rxbQdw/NTD
         k0ATS6Fs78CxIniBmidwztc9cKwKhS+KsvNIDpSFF0NAx4YGgfp8+ZrjX2j49mb+Cw9x
         lNVS1qMg9uH8btD5al8ttU0mnfrYrM3f/sXNggiQ1Izh0wb9LPv6yCROcHF0RFw/9kEQ
         u1fQbdxrLqN0S8pd/Vkp2sE7E3W3lbqDLutliuW/guNfzR50QSYC5VBJr6YV1DSala7Z
         U3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LkwiBvNLTx8n7MhzzdDaiavRIGjiDc67DNZgPaIqd0Q=;
        b=PthtXcKDtxWWFPCMKAmhyWsoXATisEZegYhuk8eLtfdt1+w6tBuVMpmg7i7Yafw7FF
         vSxu/9JxwWDR9kHRi6dUjXp1pNLmqO8MBvU6ZM2tpRvFSOcaZXjeXZ2E+b3vZs2x+U2C
         1WPFM3Ze6+yq3aA+3/kh/kA7/1UoACRUcXYd8UmFuiDPZGB9Sij+0gbYAQpv7yxvhGgv
         c3dSuhWb1HXl9HALCedResANl3sKx05q5gMJfTfD2ZFoC/5bbvGcuUBWO9y0x/xGMQrd
         49weH71pU68kzuIgHfvr8W5UNI7qqA40h6be3VskqRxCv2x0/CrSbvC63KZC6FG6zc2l
         MXPQ==
X-Gm-Message-State: AOAM530TrB9i2I4fpBSke/oEL6YHjqmU2CT9KWc/rNsi7B98nhhRdAER
        ficLGZ8J7cLz/ElL2waObcPUW6tF+MEYpr8NDkcsmw==
X-Google-Smtp-Source: ABdhPJwqaXuRJGXbdmmvKYn28W36zqHecly+krGJre4YT4gom4v6oAVRLZJILO8UlpgqBlXIMBJEiiwfjgJaDoluEpg=
X-Received: by 2002:a05:6e02:88:: with SMTP id l8mr4455173ilm.69.1596211060447;
 Fri, 31 Jul 2020 08:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200730205657.3351905-1-kafai@fb.com> <20200730205704.3352619-1-kafai@fb.com>
In-Reply-To: <20200730205704.3352619-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Jul 2020 08:57:29 -0700
Message-ID: <CANn89iK8h8x6oVZ0O0P+3gs1NyxfX0F--+Gw4CjOBhHE0NxqqA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/9] tcp: Use a struct to represent a saved_syn
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 1:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The TCP_SAVE_SYN has both the network header and tcp header.
> The total length of the saved syn packet is currently stored in
> the first 4 bytes (u32) of an array and the actual packet data is
> stored after that.
>
> A latter patch will add a bpf helper that allows to get the tcp header

s/latter/later/

> alone from the saved syn without the network header.  It will be more
> convenient to have a direct offset to a specific header instead of
> re-parsing it.  This requires to separately store the network hdrlen.
> The total header length (i.e. network + tcp) is still needed for the
> current usage in getsockopt.  Although this total length can be obtained
> by looking into the tcphdr and then get the (th->doff << 2), this patch
> chooses to directly store the tcp hdrlen in the second four bytes of
> this newly created "struct saved_syn".  By using a new struct, it can
> give a readable name to each individual header length.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>


> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index a018bafd7bdf..6c38ca9de17e 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6598,13 +6598,14 @@ static void tcp_reqsk_record_syn(const struct sock *sk,
>  {
>         if (tcp_sk(sk)->save_syn) {
>                 u32 len = skb_network_header_len(skb) + tcp_hdrlen(skb);
> -               u32 *copy;
> -
> -               copy = kmalloc(len + sizeof(u32), GFP_ATOMIC);
> -               if (copy) {
> -                       copy[0] = len;
> -                       memcpy(&copy[1], skb_network_header(skb), len);
> -                       req->saved_syn = copy;
> +               struct saved_syn *saved_syn;
> +
> +               saved_syn = kmalloc(len + sizeof(*saved_syn), GFP_ATOMIC);

Please use
                  saved_syn = kmalloc(struct_size(saved_syn, data,
len), GFP_ATOMIC)

This will avoid yet another trivial patch in the future.

> +               if (saved_syn) {
> +                       saved_syn->network_hdrlen = skb_network_header_len(skb);
> +                       saved_syn->tcp_hdrlen = tcp_hdrlen(skb);
> +                       memcpy(saved_syn->data, skb_network_header(skb), len);
> +                       req->saved_syn = saved_syn;
>                 }
>         }
>  }
> --
> 2.24.1
>
