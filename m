Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1B1161EE0
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 03:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgBRCNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 21:13:38 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:39462 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgBRCNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 21:13:38 -0500
Received: by mail-yw1-f66.google.com with SMTP id h126so8757482ywc.6
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 18:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jWKJ+dIsYQqjWAHkaxFZJBX7G8AHXc41+SsOecz36q8=;
        b=R3JVzKR1cxYleFxtwCWP6AhoaVw+Wf7yryosjBgKLU/mqC45EZTQakNhPoRQIqO/cr
         LUnwwqlObmu8QQA/wemGu+ecS7yUB0MUMw0S9jqCARzDjvgSxeGu4AhlG4HECsFnjwVT
         NLidkAGdX5q33XnCbOabLVCiczmQ9SiSq4YKB6oj8YjqJJhonvNwkCHRFCOA0NDjpfw9
         IWm22iLRe0sgr3366ArFyTK2ZgTVTZGKoW/7qsHiIWz4lMePuOryH/RYvGtitLAD5PmH
         ywf5qDpfTiO84PKQswtGYBJNVcvc7F30yoxZAtscNdLvnWM/PqS6wbekirH3xRXydA2s
         k3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jWKJ+dIsYQqjWAHkaxFZJBX7G8AHXc41+SsOecz36q8=;
        b=EnhlCdb6HDNvjNYJPNNfSwjfKWKJIPda7XOlt5JuQ3QOzRjtsRUHMhV5q08wkOJtah
         lK5DlqFScbM6NI1gqk9lqZtEJ/bO7AAor5ZLDxhJeBZQZ7qfCQ3RaAKjzGleRVfZDUhn
         HE2qywiptoF/4UUd4R+A5rVGtfODPLeRg+LLCZC+0aCjLXjVJwy7zVvBvWqd4+NDLzWn
         xAG1k0fuEvZXJ9v6TECvuX8xVuk/+bmRhojZfTfWhhjG0p11BpHkmxkJFGMwrvSmGHAr
         GjawCO7tyWsWANC9xL/cqgNoWCGzxVf0Pf64OCO1Vt3dVkwqlJG/S+i4Jiyw29UBuP4p
         KyWA==
X-Gm-Message-State: APjAAAXqNSTsGQyMS1eAC5FIte/DCc+0h89//wAVoR8YSh+dGqX9mPwP
        Lkga3WuBf09yivG26cX30jVvtyu8
X-Google-Smtp-Source: APXvYqx/1J8ISSRvaaPs6gSTjHcuYrwgUl3s2j0dUr2ENITRZUqSWbT8oM1JnQ+7JkFswcX8rzh2KQ==
X-Received: by 2002:a0d:f243:: with SMTP id b64mr15158804ywf.265.1581992016381;
        Mon, 17 Feb 2020 18:13:36 -0800 (PST)
Received: from mail-yw1-f51.google.com (mail-yw1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id q130sm1104837ywg.52.2020.02.17.18.13.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 18:13:35 -0800 (PST)
Received: by mail-yw1-f51.google.com with SMTP id i126so8756432ywe.7
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 18:13:35 -0800 (PST)
X-Received: by 2002:a81:6588:: with SMTP id z130mr13717985ywb.355.1581992015093;
 Mon, 17 Feb 2020 18:13:35 -0800 (PST)
MIME-Version: 1.0
References: <CAN_72e2m8ZYTu1wsqHabvHct8d0Ftf6VHrh-ZGJNR0-Bpa2cyw@mail.gmail.com>
 <CA+FuTSdB8nAohzbKKS3aGifRB4iJx_tFKTPaD_0MSAPLxRdrSg@mail.gmail.com> <5e0fe3fd-5922-af43-2bbb-46d237858e89@gmail.com>
In-Reply-To: <5e0fe3fd-5922-af43-2bbb-46d237858e89@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 17 Feb 2020 18:12:54 -0800
X-Gmail-Original-Message-ID: <CA+FuTSeq5fkUruH8OPeV1kBAV9p-unD3i8WfcHZK+-6wf8p03w@mail.gmail.com>
Message-ID: <CA+FuTSeq5fkUruH8OPeV1kBAV9p-unD3i8WfcHZK+-6wf8p03w@mail.gmail.com>
Subject: Re: [BISECTED] UDP socket bound to addr_any receives no data after disconnect
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Pavel Roskin <plroskin@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 5:24 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 2/17/20 3:20 PM, Willem de Bruijn wrote:
> > On Sun, Feb 16, 2020 at 10:53 AM Pavel Roskin <plroskin@gmail.com> wrote:
> >>
> >> Hello,
> >>
> >> I was debugging a program that uses UDP to serve one client at a time.
> >> It stopped working on newer Linux versions. I was able to bisect the
> >> issue to commit 4cdeeee9252af1ba50482f91d615f326365306bd, "net: udp:
> >> prefer listeners bound to an address". The commit is present in Linux
> >> 5.0 but not in 4.20. Linux 5.5.4 is still affected.
> >>
> >> From reading the commit description, it doesn't appear that the effect
> >> is intended. However, I found that the issue goes away if I bind the
> >> socket to the loopback address.
> >>
> >> I wrote a demo program that shows the problem:
> >>
> >> server binds to 0.0.0.0:1337
> >> server connects to 127.0.0.1:80
> >> server disconnects
> >> client connects to 127.0.0.1:1337
> >> client sends "hello"
> >> server gets nothing
> >>
> >> Load a 4.x kernel, and the server would get "hello". Likewise, change
> >> "0.0.0.0" to "127.0.0.1" and the problem goes away.
> >>
> >> IPv6 has the same issue. I'm attaching programs that demonstrate the
> >> issue with IPv4 and IPv6. They print "hello" on success and hang
> >> otherwise.
> >
> > Thanks for the report with reproducers. That's very helpful.
> >
> > Before the patch, __udp4_lib_lookup looks into the hslot table hashed
> > only by destination port.
> >
> > After the patch, it goes to hslot2, hashed by dport and daddr. Before
> > the connect and disconnect calls, the server socket is hashed on
> > INADDR_ANY.
> >
> > The connect call changes inet_rcv_saddr and calls sk_prot->rehash to
> > move the socket to the hslot hashed on its saddr matching the new
> > destination.
> >
> > The disconnect call reverts inet_rcv_saddr to INADDR_ANY, but lacks a
> > rehash. The following makes your ipv4 test pass:
> >
> > @@ -1828,8 +1828,11 @@ int __udp_disconnect(struct sock *sk, int flags)
> >         inet->inet_dport = 0;
> >         sock_rps_reset_rxhash(sk);
> >         sk->sk_bound_dev_if = 0;
>
> BTW, any idea why sk_bound_dev_if is cleared ?
>
> This looks orthogonal to a disconnect.

Agreed. But it seems to go back to at least 2003.

>
> > -       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> > +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK)) {
> >                 inet_reset_saddr(sk);
> > +               if (sk->sk_prot->rehash)
> > +                       sk->sk_prot->rehash(sk);
> > +       }
>
> Note that we might call sk->sk_prot->unhash(sk) right after this point,
> so maybe avoid a rehash unless really needed.
>
> if (!(sk->sk_userlocks & SOCK_BINDPORT_LOCK)) {
>         sk->sk_prot->unhash(sk);
>         inet->inet_sport = 0;
> }

Ah yes, thanks.
