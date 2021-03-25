Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AD63486EE
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 03:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbhCYC3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 22:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239499AbhCYC2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 22:28:47 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774DDC06174A;
        Wed, 24 Mar 2021 19:28:43 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id f19so426848ion.3;
        Wed, 24 Mar 2021 19:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UvS3KB/EM5kPn3926ZA2eghzsu/UwvCjZqmmfQbNVgE=;
        b=tsmv3LPcYi4KGh40ThEQnN04O7Qhc+4Yiis7LQBH9BEuR2AhHJH/ETB4qHJo76W9rE
         Fzn4NgbG9QtGoaTYkwIz0gIxIM6Co24qsoUimtY1w4m5HXFsxBA76C2iNUhMvKzRqNoo
         rxjv6I07dSxYrNi33RbljO2UzLOQtHYS8OFagqJwJpcooQKeHrY5UBtxF3xLLtcDRrml
         tG+TSuYzXDmRESyCF4RFm5LW5T8eFe/C+uKcMWS/hLE5zaDAtPmENPdA7ghELyeRL2Bx
         M4NAjK9Y9yPa9b7Gv5htaGO9SeUBvuXftwgB9ZfpKmeac/3LR3EanQb/vXZPBbODExzb
         Pr7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UvS3KB/EM5kPn3926ZA2eghzsu/UwvCjZqmmfQbNVgE=;
        b=AcP0KBcAg3w8y6LCnxdpSsYtdZdHj2CHzbFe94orbaOcgrTwTz+/QGme1i8WSimEGE
         oyIkHUkiPpopNFGDXt6nnQ3+tEa6RPqAMIzRu7cil9WlbBEp7rFNwkJm00qmJ/MR1q6j
         tihkoM2Bq2hUDJgUX5+ZWIjsrVZrQZSRCZ1nvOPzkn+lWzJ4KA1xzktlYrMa1uI0HL2a
         goGfARUGvt0Gzfne02T4i5+LUUlGLjnpR1sZ6EJmoC/EhKvcZozYQjRlug5ZfU293Etb
         RYnBHyjsxbQf3X/WV+In+wvOCjStI7ckCKmHH/EufFLTlz4pWXITOxyYuStyz25T2wcw
         d5pg==
X-Gm-Message-State: AOAM530h5bUQCd2zkK02AuAuFZkZ8fWjgG1UuSlww6aoU6xSIyuVZijb
        GFKH0JaMg1JqsPnuR9LtfFs=
X-Google-Smtp-Source: ABdhPJwu7ez9+UPPgyMagJMw54rMck2sWWn32dc567L+9CKkSUh8ki3wR0eLsQQ352T6vDpaRDbvOw==
X-Received: by 2002:a6b:8b0e:: with SMTP id n14mr4798702iod.199.1616639322977;
        Wed, 24 Mar 2021 19:28:42 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id e13sm2016971ilr.0.2021.03.24.19.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 19:28:42 -0700 (PDT)
Date:   Wed, 24 Mar 2021 19:28:35 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <605bf553d16f_64fde2081@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpUNUE8cmyNaALG1dZtCfJGah2pggDNk-eVbyxexnA4o_g@mail.gmail.com>
References: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
 <161661956953.28508.2297266338306692603.stgit@john-Precision-5820-Tower>
 <CAM_iQpUNUE8cmyNaALG1dZtCfJGah2pggDNk-eVbyxexnA4o_g@mail.gmail.com>
Subject: Re: [bpf PATCH 1/2] bpf, sockmap: fix sk->prot unhash op reset
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Wed, Mar 24, 2021 at 1:59 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > index 47b7c5334c34..ecb5634b4c4a 100644
> > --- a/net/tls/tls_main.c
> > +++ b/net/tls/tls_main.c
> > @@ -754,6 +754,12 @@ static void tls_update(struct sock *sk, struct proto *p,
> >
> >         ctx = tls_get_ctx(sk);
> >         if (likely(ctx)) {
> > +               /* TLS does not have an unhash proto in SW cases, but we need
> > +                * to ensure we stop using the sock_map unhash routine because
> > +                * the associated psock is being removed. So use the original
> > +                * unhash handler.
> > +                */
> > +               WRITE_ONCE(sk->sk_prot->unhash, p->unhash);
> >                 ctx->sk_write_space = write_space;
> >                 ctx->sk_proto = p;
> 
> It looks awkward to update sk->sk_proto inside tls_update(),
> at least when ctx!=NULL.

hmm. It doesn't strike me as paticularly awkward but OK.

> 
> What is wrong with updating it in sk_psock_restore_proto()
> when inet_csk_has_ulp() is true? It looks better to me.

It could be wrong if inet_csk_has_ulp has an unhash callback
already assigned. But, because we know inet_csk_has_ulp()
really means is_tls_attached() it would be fine.

> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 6c09d94be2e9..da5dc3ef0ee3 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -360,8 +360,8 @@ static inline void sk_psock_update_proto(struct sock *sk,
>  static inline void sk_psock_restore_proto(struct sock *sk,
>                                           struct sk_psock *psock)
>  {
> -       sk->sk_prot->unhash = psock->saved_unhash;
>         if (inet_csk_has_ulp(sk)) {
> +               sk->sk_prot->unhash = psock->sk_proto->unhash;
>                 tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
>         } else {
>                 sk->sk_write_space = psock->saved_write_space;
> 
> 
> sk_psock_restore_proto() is the only caller of tcp_update_ulp()
> so should be equivalent.

Agree it is equivalent. I don't mind moving the assignment around
if folks think its nicer.

> 
> Thanks.
