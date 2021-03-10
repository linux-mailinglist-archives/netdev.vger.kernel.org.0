Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07A43335D7
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 07:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhCJGeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 01:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhCJGdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 01:33:44 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1128CC06174A;
        Tue,  9 Mar 2021 22:33:44 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id p10so14532190ils.9;
        Tue, 09 Mar 2021 22:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=d7j56O+AP6z0Wt0kPU2x6eUkYTCUAhE00c4uQsHOcp0=;
        b=k3nhBR3gTpiXgo5I6LneSZp5JjmQB/u78IKER/tNNgYcdGdSHbkHVzJ6C2LHfnf+Qg
         TpgZHgV4MF7E0li4uHq03X1a70R/RP/59YJZCY8eK6PIJALmSQudsrvX6YlZfPrYvxbk
         j70OzMi1CqprfXj5VUoGE1IzmjZ559OaoihEKVZom6gztkPNjC5MKhn+UVnYTfViwcOw
         L/0osomfxb1sx0XgZomfU3YP4E3wDqYC68S5H51nFp7HyY/IHwmyy2o5Xk3x+1LkHKaF
         05ZH5ft+LPk0/zhyz439vsN3xxqr2M0Asiw9fw7eeivxH4KCNwtBUwKWk4Ph6rZAHW3K
         xhyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=d7j56O+AP6z0Wt0kPU2x6eUkYTCUAhE00c4uQsHOcp0=;
        b=Ofqi6uC0Kxb24ycfMGKetiKAjeYJEwy9/MpnRHMWVKXMZ3ZjU1EGry4VsW1lTj9DC2
         pWMU3CKAVEqX5u73Gg2bvvlEz/e4jsWTYNtf10qsuIOlH/zF8/XDa916aFc85lJUQUXq
         xQfj68MPsJYdbpi610wNNAZYjBWubFAm3rgCiVhnDhyhk5DnOAsy7zPFp6waZo4uvyBW
         NUb5KZSehNHmns+/X1uX28TXK1P+82XyTUFz4qGA4LLJkyxk9FfL2mJGLbOnyjb9NJcg
         ASbvhh8/3Ik0Q0ZVtYRriL4Pb0WuLpHaNpPc8EXRmZ30eKbYv+WcleqLH+sulpqfesLF
         TvAw==
X-Gm-Message-State: AOAM533xyhI5IxIYc4TRMUoaKnOGOK+sP/P1brjgbJenaeNSME0zpMdm
        CfUZmd93+WGgWQIpsM2e2H8=
X-Google-Smtp-Source: ABdhPJxbwiaRXDJANg5eZOp2SLJNN/5SaK2agTPiILalawFZP85BDnxCI+z0vJKCY/gIzWEjFNNW6A==
X-Received: by 2002:a05:6e02:1545:: with SMTP id j5mr1570499ilu.296.1615358023552;
        Tue, 09 Mar 2021 22:33:43 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id g6sm8827851ilj.28.2021.03.09.22.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 22:33:42 -0800 (PST)
Date:   Tue, 09 Mar 2021 22:33:35 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <6048683f3a39a_2daf52086e@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpV5vJn5ORbhodinEYP7vV9tGbXwDN2Nw+TLqUNnp5ENcg@mail.gmail.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-3-xiyou.wangcong@gmail.com>
 <CACAyw9-SjsNn4_J1KDXuFh1nd9Hr-Mo+=7S-kVtooJwdi1fodQ@mail.gmail.com>
 <CAM_iQpXqE9qJ=+zKA6H1Rq=KKgm8LZ=p=ZtvrrH+hfSrTg+zxw@mail.gmail.com>
 <CAM_iQpXXUv1FV8DQ85a2fs08JCfKHHt-fAWYbV0TTWmwUZ-K5Q@mail.gmail.com>
 <6042cc5f4f65a_135da20824@john-XPS-13-9370.notmuch>
 <CAM_iQpUr7cvuXXdtYN9_MQPYy_Tfi88fBGSo3c8RRpMFBr55Og@mail.gmail.com>
 <6042e114a1c9e_135da20839@john-XPS-13-9370.notmuch>
 <CAM_iQpV5vJn5ORbhodinEYP7vV9tGbXwDN2Nw+TLqUNnp5ENcg@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/9] sock: introduce sk_prot->update_proto()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Fri, Mar 5, 2021 at 5:55 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >

[...]

> > > // tcp_bpf_prots->unhash == sock_map_unhash
> > > sk_psock_restore_proto();
> > > // Now  tcp_bpf_prots->unhash is inet_unhash
> > > ...
> > > sk_psock_update_proto();
> > > // sk->sk_proto is now tcp_bpf_prots again,
> > > // so its ->unhash now is inet_unhash
> > > // but it should be sock_map_unhash here
> >
> > Right, we can fix this on the TLS side. I'll push a fix shortly.
> 
> Are you still working on this? If kTLS still needs it, then we can
> have something like this:

Testing a fix now I will flush it out tomorrow. The below is not
really correct either it just moves the issue so it only impacts
TLS.

> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 8edbbf5f2f93..5eb617df7f48 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -349,8 +349,8 @@ static inline void sk_psock_update_proto(struct sock *sk,
>  static inline void sk_psock_restore_proto(struct sock *sk,
>                                           struct sk_psock *psock)
>  {
> -       sk->sk_prot->unhash = psock->saved_unhash;
>         if (inet_csk_has_ulp(sk)) {
> +               sk->sk_prot->unhash = psock->saved_unhash;
>                 tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
>         } else {
>                 sk->sk_write_space = psock->saved_write_space;
> 
> 
> Thanks.
