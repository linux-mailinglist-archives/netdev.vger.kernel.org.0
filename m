Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E958232C492
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443593AbhCDAPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835364AbhCCSC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 13:02:56 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92C8C061761;
        Wed,  3 Mar 2021 10:02:14 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b15so4655955pjb.0;
        Wed, 03 Mar 2021 10:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=riT8H9mkRmeNcLBWbSj2xaZmnz2sd8uAAZFerEUss6s=;
        b=k1gnZmFqNvFY8zVbQ32Zn5q2brrM0eH8QoPKRenrLl2BH2BTZ8/1vKNyl684SUvKyg
         YkPThbwsEuVfiYX5KPAXQPMqBTelBOICznZasCzaLPHV8kRXPL0rhEMESIG3pNhPTbJu
         ITd7S1mppRDGjytyIwf4dPyn4m8H9Y5URMnxi5xI5NzzSkdxbNfTux8+UamyFtXskBYA
         vD2VyK3NPkr0ohdgJjTxNtcG4IMrEGOjE8jagdf8CaDwkxrEwiD8atx5REm3QjZSqsFE
         ANkzBvEOX6lcvYAcAJci17liTfwprAT+pW+NlyvvyDqamjPzaXlIl2186SuFw8wUTvla
         13Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=riT8H9mkRmeNcLBWbSj2xaZmnz2sd8uAAZFerEUss6s=;
        b=Q1PnQcs6+E2J/64ny0waF9nUYlqIkI/75/v6UBT5oIr9QzZg6YDbtCQnSEFdvTHlcT
         c967P4QRH9wFsMZ5DxykEfbqMPkZ6zZHt/1dkdjMFdoutYq14xADPPwuT4zAXFktaHQv
         osyreCuOP9QmXPlbbZ/uYSC2Gy7uupHTa54EQOR2Dd/6HBgpc2x5HuBFfdO73IDlMKw5
         reO4X8w5I7l1A+wIVamjqdDbEAn33Xwm733yF9g9fBlDeotmnheYN8YtObkF+JoE8QBr
         YjMEWmsccLHBoKm7DU5FNNLKvyfU38+txJSuO05aLkHq/nPSeTStjE4unZpmOGRSXspl
         nBwQ==
X-Gm-Message-State: AOAM533wl3s2fsHi2wofqMdEZ9HsX2F1B3t2MWB8Gctus8E50755LHLU
        y7HCqd7/1Q19e8v9Ql/lbUqzAFyNrhGJslChXD4=
X-Google-Smtp-Source: ABdhPJxChESi3gq2KT4ebgmcbnDgLAefshrcjnbzPI82IR+wLj0D4J+RABD8jY2B9Kz8OICufwN6k+adfr4qbtan3pQ=
X-Received: by 2002:a17:90a:8594:: with SMTP id m20mr278590pjn.215.1614794534192;
 Wed, 03 Mar 2021 10:02:14 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-9-xiyou.wangcong@gmail.com> <258c3229-1e60-20d9-e93f-9655ae969b6e@fb.com>
In-Reply-To: <258c3229-1e60-20d9-e93f-9655ae969b6e@fb.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 3 Mar 2021 10:02:02 -0800
Message-ID: <CAM_iQpXM+kyi=LFe0YygYuVE7kcApVGJ9f2A-D=ST2nFPusttg@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 8/9] sock_map: update sock type checks for UDP
To:     Yonghong Song <yhs@fb.com>
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

On Tue, Mar 2, 2021 at 10:37 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 3/1/21 6:37 PM, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Now UDP supports sockmap and redirection, we can safely update
> > the sock type checks for it accordingly.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >   net/core/sock_map.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index 13d2af5bb81c..f7eee4b7b994 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -549,7 +549,10 @@ static bool sk_is_udp(const struct sock *sk)
> >
> >   static bool sock_map_redirect_allowed(const struct sock *sk)
> >   {
> > -     return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
> > +     if (sk_is_tcp(sk))
> > +             return sk->sk_state != TCP_LISTEN;
> > +     else
> > +             return sk->sk_state == TCP_ESTABLISHED;
>
> Not a networking expert, a dump question. Here we tested
> whether sk_is_tcp(sk) or not, if not we compare
> sk->sk_state == TCP_ESTABLISHED, could this be
> always false? Mostly I missed something, some comments
> here will be good.

No, dgram sockets also use TCP_ESTABLISHED as a valid
state. I know its name looks confusing, but it is already widely
used in networking:

net/appletalk/ddp.c:    sk->sk_state = TCP_ESTABLISHED;
net/appletalk/ddp.c:            if (sk->sk_state != TCP_ESTABLISHED)
net/appletalk/ddp.c:            if (sk->sk_state != TCP_ESTABLISHED)
net/ax25/af_ax25.c:     sk->sk_state    = TCP_ESTABLISHED;
net/ax25/af_ax25.c:             case TCP_ESTABLISHED: /* connection
established */
net/ax25/af_ax25.c:     if (sk->sk_state == TCP_ESTABLISHED &&
sk->sk_type == SOCK_SEQPACKET) {
net/ax25/af_ax25.c:             sk->sk_state   = TCP_ESTABLISHED;
net/ax25/af_ax25.c:     if (sk->sk_state != TCP_ESTABLISHED && (flags
& O_NONBLOCK)) {
net/ax25/af_ax25.c:     if (sk->sk_state != TCP_ESTABLISHED) {
net/ax25/af_ax25.c:             if (sk->sk_state != TCP_ESTABLISHED) {
net/ax25/af_ax25.c:             if (sk->sk_state != TCP_ESTABLISHED) {
net/ax25/af_ax25.c:             if (sk->sk_state != TCP_ESTABLISHED) {
net/ax25/af_ax25.c:     if (sk->sk_type == SOCK_SEQPACKET &&
sk->sk_state != TCP_ESTABLISHED) {
net/ax25/ax25_ds_in.c:                  ax25->sk->sk_state = TCP_ESTABLISHED;
net/ax25/ax25_in.c:             make->sk_state = TCP_ESTABLISHED;
net/ax25/ax25_std_in.c:                         ax25->sk->sk_state =
TCP_ESTABLISHED;
net/caif/caif_socket.c: CAIF_CONNECTED          = TCP_ESTABLISHED,
net/ceph/messenger.c:   case TCP_ESTABLISHED:
net/ceph/messenger.c:           dout("%s TCP_ESTABLISHED\n", __func__);
net/core/datagram.c:        !(sk->sk_state == TCP_ESTABLISHED ||
sk->sk_state == TCP_LISTEN))
...

Hence, I believe it is okay to use it as it is, otherwise we would need
to comment on every use of it. ;)

Thanks.
