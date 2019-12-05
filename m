Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 733E811489E
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 22:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbfLEV0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 16:26:55 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:37163 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfLEV0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 16:26:55 -0500
Received: by mail-yw1-f65.google.com with SMTP id 4so1835071ywx.4
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 13:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gT1ClJrzlicYHNnv+GE3TcH0cs8/Jr/m+AGF+oufN9g=;
        b=SUz/4ExNWxtOEv7we2Vo0pS6UW+Sb9Enu/Wvb3u5aLbJUm/zSQMNcjZK3Tb1mt3BMU
         HkCXtN9ZIcSVfyvPe/61CyGcsurAKs92zacPWZ/BOxlM2tz2zn6/6qToOCtUeGbzV7Ex
         MCi6ebiMfr/UWN++SqkSKYDPeiNkE0ww0hJsLO4dBdxrqqkjpEoa2Sj3T8CcsJgETYp4
         oR5moE+naiQ+KaFj96+WoDDZWv/a9aXcmGuBy5MtsZYKWA0+N+xW1Z7C8Zz0aUdOzXAq
         r2MiFcJkaax1UFkybfI6qhVGKtnurdH+SSqwf9Z16QQL9R2prxUCfh9aPd9z4iOnobt2
         fjIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gT1ClJrzlicYHNnv+GE3TcH0cs8/Jr/m+AGF+oufN9g=;
        b=rCJzGRpDDtjGB5oilnUFi12f6KB0KoO4aJq9e7HesojjYMWCBOVZPGQXZn75MJw+K/
         B35PIr9hmxpX8u3+1yTbMJlCnKw5swzAR1YY1eZ/TjZmE2cPV+hpibwWC+HGnYJt6Woq
         XppeZvhXx21TunNdq7stQgGI/G6a3VoD3a0TEB+4H1IUzJrOpNUrMTro7Tin3jD5kaSQ
         IVTIKXyFYmkOoGRQo7dXI2bS4ahbZYzkIJvxaAcRHbWQESzOt+BIF0bqTYqgnsOS7vM5
         jAgX5qtZOg9OG5t7uIq5GrsAWQ4rN7d2oQ+0YREdQ57UOtQXs4K8YFBABys3DCsZhRP1
         f8RQ==
X-Gm-Message-State: APjAAAVRGVr3ma0Wgp4Uc74kkQur19wipNuyjbnj1kDlRMToVdCBeMxH
        tkvJceqDZDAJ49ZxOHGXfjavxg5Y
X-Google-Smtp-Source: APXvYqy34jdb0vad1d1VMtekeRcSc3qxGLRkfCm0ZZkNzQplNGLD9z7jTn0O/G2WzXVdI1G9XQfJLw==
X-Received: by 2002:a0d:e3c5:: with SMTP id m188mr7014736ywe.184.1575581212650;
        Thu, 05 Dec 2019 13:26:52 -0800 (PST)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id n18sm5256090ywd.50.2019.12.05.13.26.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 13:26:51 -0800 (PST)
Received: by mail-yw1-f49.google.com with SMTP id l14so1846350ywh.1
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 13:26:51 -0800 (PST)
X-Received: by 2002:a0d:e886:: with SMTP id r128mr7567719ywe.357.1575581210643;
 Thu, 05 Dec 2019 13:26:50 -0800 (PST)
MIME-Version: 1.0
References: <20191204.165528.1483577978366613524.davem@davemloft.net>
 <20191205064118.8299-1-vvidic@valentin-vidic.from.hr> <20191205113411.5e672807@cakuba.netronome.com>
 <CA+FuTSe=GSP41GG+QYKEmQ0eDUEoFeQ+oGAsgGJEZTe=hJq4Tw@mail.gmail.com> <20191205204343.GA20116@valentin-vidic.from.hr>
In-Reply-To: <20191205204343.GA20116@valentin-vidic.from.hr>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 5 Dec 2019 16:26:14 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeu-ouuT37d9r40o62=_PcGBUmE_HaOAr9EsNPzpTw=ag@mail.gmail.com>
Message-ID: <CA+FuTSeu-ouuT37d9r40o62=_PcGBUmE_HaOAr9EsNPzpTw=ag@mail.gmail.com>
Subject: Re: [PATCH v3] net/tls: Fix return values to avoid ENOTSUPP
To:     =?UTF-8?Q?Valentin_Vidi=C4=87?= <vvidic@valentin-vidic.from.hr>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 5, 2019 at 3:44 PM Valentin Vidi=C4=87
<vvidic@valentin-vidic.from.hr> wrote:
>
> On Thu, Dec 05, 2019 at 03:06:55PM -0500, Willem de Bruijn wrote:
> > On Thu, Dec 5, 2019 at 2:34 PM Jakub Kicinski
> > <jakub.kicinski@netronome.com> wrote:
> > >
> > > On Thu,  5 Dec 2019 07:41:18 +0100, Valentin Vidic wrote:
> > > > ENOTSUPP is not available in userspace, for example:
> > > >
> > > >   setsockopt failed, 524, Unknown error 524
> > > >
> > > > Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
> > >
> > > > diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> > > > index 0683788bbef0..cd91ad812291 100644
> > > > --- a/net/tls/tls_device.c
> > > > +++ b/net/tls/tls_device.c
> > > > @@ -429,7 +429,7 @@ static int tls_push_data(struct sock *sk,
> > > >
> > > >       if (flags &
> > > >           ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_N=
OTLAST))
> > > > -             return -ENOTSUPP;
> > > > +             return -EOPNOTSUPP;
> > > >
> > > >       if (unlikely(sk->sk_err))
> > > >               return -sk->sk_err;
> > > > @@ -571,7 +571,7 @@ int tls_device_sendpage(struct sock *sk, struct=
 page *page,
> > > >       lock_sock(sk);
> > > >
> > > >       if (flags & MSG_OOB) {
> > > > -             rc =3D -ENOTSUPP;
> > > > +             rc =3D -EOPNOTSUPP;
> > >
> > > Perhaps the flag checks should return EINVAL? Willem any opinions?
> >
> > No strong opinion. Judging from do_tcp_sendpages MSG_OOB is a
> > supported flag in general for sendpage, so signaling that the TLS
> > variant cannot support that otherwise valid request sounds fine to me.
>
> I based these on the description from the sendmsg manpage, but you decide=
:
>
> EOPNOTSUPP
>     Some bit in the flags argument is inappropriate for the socket type.

Interesting. That is a narrower interpretation than asm-generic/errno.h

  #define EOPNOTSUPP      95      /* Operation not supported on
transport endpoint */

which is also the string that strerror() generates.

>
> > > > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > > > index bdca31ffe6da..5830b8e02a36 100644
> > > > --- a/net/tls/tls_main.c
> > > > +++ b/net/tls/tls_main.c
> > > > @@ -496,7 +496,7 @@ static int do_tls_setsockopt_conf(struct sock *=
sk, char __user *optval,
> > > >       /* check version */
> > > >       if (crypto_info->version !=3D TLS_1_2_VERSION &&
> > > >           crypto_info->version !=3D TLS_1_3_VERSION) {
> > > > -             rc =3D -ENOTSUPP;
> > > > +             rc =3D -EINVAL;
> > >
> > > This one I think Willem asked to be EOPNOTSUPP OTOH.
> >
> > Indeed (assuming no one disagrees). Based on the same rationale: the
> > request may be valid, it just cannot be accommodated (yet).
>
> In this case other checks in the same function like crypto_info->cipher_t=
ype
> return EINVAL, so I used the same here.

That makes sense.

I think there is a fundamental difference between, say, passing an
argument of incorrect length (optlen < sizeof(..)) and asking for a
possibly unsupported cipher mode. But consistency trumps that.

I don't mean to drag this out by bike-shedding.

Happy to defer to maintainers on whether the errno on published code
can and should be changed, which is the more fundamental issue than
the exact errno.

FWIW, I also did not see existing openssl and gnutls callers test the
specific errno. The calls just fail on any setsockopt return value -1.
