Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2FCA88BF
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbfIDOYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:24:11 -0400
Received: from mail-yb1-f174.google.com ([209.85.219.174]:42353 "EHLO
        mail-yb1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729803AbfIDOYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 10:24:10 -0400
Received: by mail-yb1-f174.google.com with SMTP id z2so7345690ybp.9
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 07:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TqbBjT4kT1qbUGCyGDy3gjE7dsSWpZE/WioNquc8cYk=;
        b=nN3mXX9O02lU74x6iAcOX9lm/BJgMJDYXqlZhB+1zJdCZCcXY2BTz99PYIRUgrSC83
         9pxO00s/b8ppfz42ybmQuxcWp0upklK/TFl+2l7n9vDjiV9KekW7Nsk9y/1UbRmA+JHT
         eypAezLQOiN0ts5n9E4Mk66/BYH0ZDxvNNu9W9clf9vcv/zu7JPX3P57Jt0L532Fkii6
         0vejTsLaE40gWeJjgVHn9EZsU5igwbfn8cSx6ri9j/AeYRJF3CW/FZkpFylfVmnT3w0q
         V2qky4k8t1v3Yi7RbPOawtzlGCkbAFOGzX7BmJI8UIQUVx1wLSO4bUWd8XBgCCgMJE3Z
         7bQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TqbBjT4kT1qbUGCyGDy3gjE7dsSWpZE/WioNquc8cYk=;
        b=i0e6zVRmWNdgh025NB/WXZs8m4jeBg4fXHi1RIcUYE5uaPC0se92qL9i0U+sFzXXs/
         lNrbj5uVlinJyLECCmlknk8TYNxb7T/ghSAd5CENqO7mpQLF+m/VZVm+sCgX+9wv8lNg
         tLcQoMyKoQJHEWDpgnHkUIVEpkyO6nI+nJ22kgNlGMxWK5s0vUnc55HbVvC2XE+QqKL2
         rXvV39xmHs7710KwF2a04xTrQLKOxE1kURuTYr2d8qw+Aralw0SH5zc68IotqMp6Fz6+
         HN09AOeuVJguffktqBJGpZISWxOnT3mC8n3UE+p9qMFcPtxMw66z6JuCXKNtbKqnTv5F
         OZyA==
X-Gm-Message-State: APjAAAVGLQbMunuqJvgQhBXZ4Tn4Uf/cgwJh1rlbMezQsJHll/5foTnz
        bY7QSrysLTcgdc1McCSa6bIKU3mQ
X-Google-Smtp-Source: APXvYqyttR+fT5B3VkhIrI0/Ihv/HJWfdINVQaUvM2CrYDEla4IlgOLYlzE/VPEuozvmcF/x58xDew==
X-Received: by 2002:a25:c242:: with SMTP id s63mr28043715ybf.79.1567607049057;
        Wed, 04 Sep 2019 07:24:09 -0700 (PDT)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id r9sm4333918ywl.108.2019.09.04.07.24.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2019 07:24:07 -0700 (PDT)
Received: by mail-yw1-f50.google.com with SMTP id x64so4201309ywg.3
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 07:24:06 -0700 (PDT)
X-Received: by 2002:a81:554b:: with SMTP id j72mr6376895ywb.190.1567607046119;
 Wed, 04 Sep 2019 07:24:06 -0700 (PDT)
MIME-Version: 1.0
References: <010601d53bdc$79c86dc0$6d594940$@net> <20190716070246.0745ee6f@hermes.lan>
 <01db01d559e5$64d71de0$2e8559a0$@net> <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
 <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com> <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com>
 <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com>
 <00aa01d5630b$7e062660$7a127320$@net> <4242994D-E2CF-499A-848A-7B14CE536E33@raytheon.com>
 <c3b83305-82a5-f3c8-2602-1aed2e9b51ca@gmail.com>
In-Reply-To: <c3b83305-82a5-f3c8-2602-1aed2e9b51ca@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 4 Sep 2019 10:23:29 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdV0mAZ+-GzikjTJWMxW70q4DLSKAaKu8hXMeoFCoWSWg@mail.gmail.com>
Message-ID: <CA+FuTSdV0mAZ+-GzikjTJWMxW70q4DLSKAaKu8hXMeoFCoWSWg@mail.gmail.com>
Subject: Re: Is bug 200755 in anyone's queue??
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Mark KEATON <mark.keaton@raytheon.com>,
        Steve Zabele <zabele@comcast.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        "shum@canndrew.org" <shum@canndrew.org>,
        "vladimir116@gmail.com" <vladimir116@gmail.com>,
        "saifi.khan@strikr.in" <saifi.khan@strikr.in>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "on2k16nm@gmail.com" <on2k16nm@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 4, 2019 at 8:23 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 9/4/19 2:00 PM, Mark KEATON wrote:
> > Hi Willem,
> >
> > I am the person who commented on the original bug report in bugzilla.
> >
> > In communicating with Steve just now about possible solutions that main=
tain the efficiency that you are after, what would you think of the followi=
ng:  keep two lists of UDP sockets, those connected and those not connected=
, and always searching the connected list first.
>
> This was my suggestion.
>
> Note that this requires adding yet another hash table, and yet another lo=
okup
> (another cache line miss per incoming packet)
>
> This lookup will slow down DNS and QUIC servers, or any application solel=
y using not connected sockets.

Exactly.

The only way around it that I see is to keep the single list and
optionally mark a struct reuseport_sock as having no connected
members, in which case the search can break on the first reuseport
match, as it does today.

"
On top of the main patch it requires something like

@@ -22,6 +22,7 @@ struct sock_reuseport {
        /* ID stays the same even after the size of socks[] grows. */
        unsigned int            reuseport_id;
        bool                    bind_inany;
+       unsigned int             connected;
        struct bpf_prog __rcu   *prog;          /* optional BPF sock select=
or */
        struct sock             *socks[0];      /* array of sock pointers *=
/
 };

@@ -73,6 +74,15 @@ int __ip4_datagram_connect(struct sock *sk, struct
sockaddr *uaddr, int addr_len
        sk_set_txhash(sk);
        inet->inet_id =3D jiffies;

+       if (rcu_access_pointer(sk->sk_reuseport_cb)) {
+               struct sock_reuseport *reuse;
+
+               rcu_read_lock();
+               reuse =3D rcu_dereference(sk->sk_reuseport_cb);
+               reuse->connected =3D 1;
+               rcu_read_unlock();
+       }
+
        sk_dst_set(sk, &rt->dst);
        err =3D 0;
"

plus a way for reuseport_select_sock to communicate that. Probably a
variant __reuseport_select_sock with an extra argument.

As for BPF: the example I pointed out does read ip addresses and uses
a BPF map for socket selection. But as that feature is new with 4.19
it is probably moot for this purpose, as we are targeting a fix that
can be backported to 4.19 stable.
