Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21715355B68
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhDFSat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhDFSas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 14:30:48 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938A7C06174A;
        Tue,  6 Apr 2021 11:30:39 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q10so11001979pgj.2;
        Tue, 06 Apr 2021 11:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tYEAc5f8IrKWybOHKKXYknBBsCGloqHPfGVqP4uyOq4=;
        b=tzQYxxkKDesNFQnUgUyMW/mntPTEKtC/yV60rKHXt1rcmtc+6QZo+2651Fxtbfoa6Z
         PfZB+qoAwxhHriCbUMQqNzgNWPMAqMpRB5LjJtljUe48RC69x7IrnnZdn+CcwnmQq9Gy
         AVskt4P4lgVBdKZQiQdU1gs4ULbvvSpt7b32f+9bp0IuK1sBZTzp6A3dlLftAOhwxX7e
         8PEc73/+AVKQrn4XF3A/b636sy85MRfpzpiZZRVbXDHFHCVe1uhZgBy/kr4bt46DB40f
         2qbza1AvOya8bwpcvm9tFsRO8i4O2G8Io1dDvDDoXaBC1t85d31Dl5fCBObIxIu5YQIH
         Y2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tYEAc5f8IrKWybOHKKXYknBBsCGloqHPfGVqP4uyOq4=;
        b=TRrrGEzgWMEw0GpOq8rbzpZDJCad+ipBLNKwJVdbFFto79JqhU3jhMdgIk/lYH/XO0
         UNeY7SXYrRUNlrvgtou5jpKFbobUSt+t+SQvYc8bpLjFT9oeDmVkLlJc1nJgV0HYjJkx
         5y06ZjWsfniO1sQF4u5nuVkR+nPamCiGozlk69owqdHfRuuASEhp95jLbhbgNZTL8M9s
         C161ZPZSewGFHw3Uf5tNswv0Hg7kR5jRnmN1Ry3FtidgwY/zQxGoFaQN5nR0lmZ00Cf9
         i/EEgXnjas2XFc4o1Qdm10TNnfJ7KrfgJ209ACT+QaAFpWEHrczm/U+Ye1HEhSpOvSdy
         92dg==
X-Gm-Message-State: AOAM530akIQXqb5Un4E6gvWhCyXuxfGtn+ByEyGdho4qgVcZA8TQk0Gp
        B8dNtNcYeAdNhQSYv9H4kUQR4teZiOFqB8jCtMTbFUmx7wr5/hdm
X-Google-Smtp-Source: ABdhPJyWjdkd0q5esQyOaGfxBWuHxIAj9iw+OMlzSFBEj8MDqJ3190uuJYC5tGc60AznjG68lSxW+2OgOhNPxhXE2G4=
X-Received: by 2002:a63:2ec7:: with SMTP id u190mr28452586pgu.18.1617733839166;
 Tue, 06 Apr 2021 11:30:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-11-xiyou.wangcong@gmail.com> <1aeb42b4-c0fe-4a25-bd73-00bc7b7de285@gmail.com>
In-Reply-To: <1aeb42b4-c0fe-4a25-bd73-00bc7b7de285@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 6 Apr 2021 11:30:28 -0700
Message-ID: <CAM_iQpVd8s0yqMLOR2B5uBxKFzWWZYoZ20WAN2MjcVEiiHX++A@mail.gmail.com>
Subject: Re: [Patch bpf-next v8 10/16] sock: introduce sk->sk_prot->psock_update_sk_prot()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 5, 2021 at 1:25 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 3/31/21 4:32 AM, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Currently sockmap calls into each protocol to update the struct
> > proto and replace it. This certainly won't work when the protocol
> > is implemented as a module, for example, AF_UNIX.
> >
> > Introduce a new ops sk->sk_prot->psock_update_sk_prot(), so each
> > protocol can implement its own way to replace the struct proto.
> > This also helps get rid of symbol dependencies on CONFIG_INET.
>
> [...]
>
>
> >
> > -struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
> > +int tcp_bpf_update_proto(struct sock *sk, bool restore)
> >  {
> > +     struct sk_psock *psock = sk_psock(sk);
>
> I do not think RCU is held here ?
>
> sk_psock() is using rcu_dereference_sk_user_data()

Right, I just saw the syzbot report. But here we already have
the writer lock of sk_callback_lock, hence RCU read lock here
makes no sense to me. Probably we just have to tell RCU we
already have sk_callback_lock.

Thanks.
