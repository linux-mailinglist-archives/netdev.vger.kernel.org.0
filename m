Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C331C234F56
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 03:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgHABvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 21:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgHABvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 21:51:07 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7266C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 18:51:07 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id l17so33479224iok.7
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 18:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+o3AgCpxMtrBebaqaOiOmaCLQNjS+75EXg+gA69bYsU=;
        b=m5bvcn7EulfDu77eMGHEhhmIKynAH4S4cxX1WizkDEQLi7ebAM+WpiZN+c6uEYZxly
         GwRFJ/Fvk5NrICTMG5fK0s6ch7Y4CpU75iZipXYVBMg7pIy4EJNGH2z5Ge1cd34z17uG
         FRUjH4pyw47kvtP86xaPq/JTYYLzdx8sU7XAZWawiDWWtJ/JURyoK2LctqLpr2hTqNMr
         49Jri0jE0PpULcR96YnhCLl59dM4rD2KrPfH1Yh+R7JoZUuD44G6VQ9lSws0aC+6CAtY
         G34sCt2PzbEVioOZp90v6SZsrlt1HqvtujCEpXsk41fRSdFBu6zGuG5CIr0e3kUz3Lqq
         kHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+o3AgCpxMtrBebaqaOiOmaCLQNjS+75EXg+gA69bYsU=;
        b=okPYM1CDW3rZMB1r+1/xV6l7DPYSr1Y1Gogho6n2KhDNlxg2D6WmWIKka113cHAfHp
         Mxv7wytJA5t63ZMXJhLudM/aYtnfDkoTzNsBTzR4g40b/2lvlD0ePAIrby5izxSxzUJj
         2NFnlH2lkhSzrAnY7k2VtH5F4td2psQ3g0WRZ+rjHYKCNdKyvgwohNYSaA9gDmS+HoOJ
         vXHCxzNFqnvQfysmgWl4YwWT2oD06vkmpc37Z6xvOQAQR+euQKcGlGdfq/WrBbiTMYpu
         N8dRUOu2UrOPPzeWiqlZfEwGGrXBxGMweNHa77Bshqql1mohUgdaHmyNcR+XpGEIWAaq
         TmRQ==
X-Gm-Message-State: AOAM530QIvoml46EDlLozDpb8hzeqpHglF6FriFB9cXCWP9sv7oAyG9i
        beanp8Re9uvc5oFnuYCzyewUDwfpfqO1YXjWkHgd5/MJpZg=
X-Google-Smtp-Source: ABdhPJwbSR+A4m9teBh1zvECoKqS+B3QtUiMTHWD/3657cqdFQwYjjKhIdzk+VFNAYb9TpZD5UUEtKm9nOoT+JHG+aI=
X-Received: by 2002:a5d:8143:: with SMTP id f3mr6224410ioo.157.1596246666557;
 Fri, 31 Jul 2020 18:51:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200730192558.25697-1-fw@strlen.de> <20200730192558.25697-8-fw@strlen.de>
In-Reply-To: <20200730192558.25697-8-fw@strlen.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Jul 2020 18:50:55 -0700
Message-ID: <CANn89iLwjROZXEx2KQi7JGKFtZxzTWXEN+PfuVb43Gasr-fT3w@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 7/9] mptcp: enable JOIN requests even if
 cookies are in use
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>,
        mathew.j.martineau@linux.intel.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 12:26 PM Florian Westphal <fw@strlen.de> wrote:
>
> JOIN requests do not work in syncookie mode -- for HMAC validation, the
> peers nonce and the mptcp token (to obtain the desired connection socket
> the join is for) are required, but this information is only present in the
> initial syn.
>
> So either we need to drop all JOIN requests once a listening socket enters
> syncookie mode, or we need to store enough state to reconstruct the request
> socket later.
>
> This adds a state table (1024 entries) to store the data present in the
> MP_JOIN syn request and the random nonce used for the cookie syn/ack.
>
> When a MP_JOIN ACK passed cookie validation, the table is consulted
> to rebuild the request socket from it.
>
> An alternate approach would be to "cancel" syn-cookie mode and force
> MP_JOIN to always use a syn queue entry.
>
> However, doing so brings the backlog over the configured queue limit.
>
> v2: use req->syncookie, not (removed) want_cookie arg
>
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv4/syncookies.c  |   6 ++
>  net/mptcp/Makefile     |   1 +
>  net/mptcp/ctrl.c       |   1 +
>  net/mptcp/protocol.h   |  20 +++++++
>  net/mptcp/subflow.c    |  14 +++++
>  net/mptcp/syncookies.c | 132 +++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 174 insertions(+)
>  create mode 100644 net/mptcp/syncookies.c
>
> diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
> index 54838ee2e8d4..11b20474be83 100644
> --- a/net/ipv4/syncookies.c
> +++ b/net/ipv4/syncookies.c
> @@ -212,6 +212,12 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
>                 refcount_set(&req->rsk_refcnt, 1);
>                 tcp_sk(child)->tsoffset = tsoff;
>                 sock_rps_save_rxhash(child, skb);
> +
> +               if (tcp_rsk(req)->drop_req) {
> +                       refcount_set(&req->rsk_refcnt, 2);
> +                       return child;
> +               }
> +


Hey, what happened to CONFIG_MPTCP=n ?

net/ipv4/syncookies.c: In function 'tcp_get_cookie_sock':
net/ipv4/syncookies.c:216:19: error: 'struct tcp_request_sock' has no
member named 'drop_req'
  216 |   if (tcp_rsk(req)->drop_req) {
      |                   ^~
net/ipv4/syncookies.c: In function 'cookie_tcp_reqsk_alloc':
net/ipv4/syncookies.c:289:27: warning: unused variable 'treq'
[-Wunused-variable]
  289 |  struct tcp_request_sock *treq;
      |                           ^~~~
make[3]: *** [scripts/Makefile.build:280: net/ipv4/syncookies.o] Error 1
make[3]: *** Waiting for unfinished jobs....
