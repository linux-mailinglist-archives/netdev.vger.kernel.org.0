Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C49114857
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 21:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbfLEUqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 15:46:09 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42725 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730348AbfLEUqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 15:46:09 -0500
Received: by mail-lj1-f193.google.com with SMTP id e28so5125084ljo.9
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 12:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8cyCc55gZLfBZi6qHxanVdv40xMR1/UD2QUcttolUfA=;
        b=e/WCgfFKLXKeMP8B0eieYwfRKnR3bNByH5Wt2Na9dfSWOj+AobBbuhEvat4zrtA3wR
         RwvsiJPia1pEaEIiXl5QtDNJFMsrVPzcBkLj675tNeVMsTRNfCLqc26fO3hf8F15jBvN
         PoXoXLaERjPsYpZuiEAJTizz6M/2Vjw/5aTrXGabVb78ihDvfFWuL0De571QLUI2Ck3Y
         DGQ+t2icfIynwhrUdvoDcV5EA8sAdF/vN+k0iz88Nw83WCfze92GF5UXyNE9svNheZho
         Yr8C0wFqIGrwSAAeBO/ApI+3R+Jo9k+g+F8rJ+6a+69SJ2njxE5Z/dDzCyQH3eCqFipG
         dkeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8cyCc55gZLfBZi6qHxanVdv40xMR1/UD2QUcttolUfA=;
        b=rJUU2w2WYa7nw0alQSbYeOI2FYrd8mA0szJsZaQdfyErOk/CSbXiOkEAnIaaITtp4k
         r9lCWEl7sj2tAYbvPzZCZiujgwguk6y4jl60mMoiNIh5NTiDkTbpO7Lz+sM3YWWMdrVh
         r/c8U/jlufg/Jqa5iO7+SyiL+Rm+kwfNlFZCJlWTcI63bpvBlIYR59OvF5jPEcxdVNXM
         jwxlAgwa0MeY/ymluAIOm46+QVzwCpd3joQ03VRHcS2yGtvZCWJGTPuA+CD7IZg6YG4P
         bXOK4znWL9YKFB70zNHGiEyYlJSb8CEGul2I6d/A2LjZlVUtPsDBTGtrkmajrBUqxXgq
         RggA==
X-Gm-Message-State: APjAAAV+8krmfmzgQOXD4ydl8R8/UHL8ber/0V7esUBQQ7md/vX5suwG
        FSx8De0kWzntNESkOhTCuIzGzA==
X-Google-Smtp-Source: APXvYqzvHwRSD2mB3TiNwn5l/6wFgxrgKCh+PXfV76p0uNtgVFYaLuYVqrDv879O/JwfoezsT0WeIw==
X-Received: by 2002:a2e:85c9:: with SMTP id h9mr6821870ljj.155.1575578767355;
        Thu, 05 Dec 2019 12:46:07 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m18sm5693241ljg.3.2019.12.05.12.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 12:46:07 -0800 (PST)
Date:   Thu, 5 Dec 2019 12:45:59 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Valentin =?UTF-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] net/tls: Fix return values to avoid ENOTSUPP
Message-ID: <20191205124559.1cbba55f@cakuba.netronome.com>
In-Reply-To: <20191205204343.GA20116@valentin-vidic.from.hr>
References: <20191204.165528.1483577978366613524.davem@davemloft.net>
        <20191205064118.8299-1-vvidic@valentin-vidic.from.hr>
        <20191205113411.5e672807@cakuba.netronome.com>
        <CA+FuTSe=GSP41GG+QYKEmQ0eDUEoFeQ+oGAsgGJEZTe=hJq4Tw@mail.gmail.com>
        <20191205204343.GA20116@valentin-vidic.from.hr>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Dec 2019 21:43:43 +0100, Valentin Vidi=C4=87 wrote:
> > > On Thu,  5 Dec 2019 07:41:18 +0100, Valentin Vidic wrote: =20
> > > > ENOTSUPP is not available in userspace, for example:
> > > >
> > > >   setsockopt failed, 524, Unknown error 524
> > > >
> > > > Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr> =20
> > > =20
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
> > > > +             rc =3D -EOPNOTSUPP; =20
> > >
> > > Perhaps the flag checks should return EINVAL? Willem any opinions? =20
> >=20
> > No strong opinion. Judging from do_tcp_sendpages MSG_OOB is a
> > supported flag in general for sendpage, so signaling that the TLS
> > variant cannot support that otherwise valid request sounds fine to me. =
=20
>=20
> I based these on the description from the sendmsg manpage, but you decide:
>=20
> EOPNOTSUPP
>     Some bit in the flags argument is inappropriate for the socket type.
>=20
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
> > > > +             rc =3D -EINVAL; =20
> > >
> > > This one I think Willem asked to be EOPNOTSUPP OTOH. =20
> >=20
> > Indeed (assuming no one disagrees). Based on the same rationale: the
> > request may be valid, it just cannot be accommodated (yet). =20
>=20
> In this case other checks in the same function like crypto_info->cipher_t=
ype
> return EINVAL, so I used the same here.

Thanks for explaining, in that case:

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
