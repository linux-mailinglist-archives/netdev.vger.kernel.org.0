Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1537C1147F2
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 21:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbfLEUHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 15:07:39 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:44644 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729145AbfLEUHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 15:07:37 -0500
Received: by mail-yb1-f194.google.com with SMTP id j6so1986297ybc.11
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 12:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m1aI+cWn+pN+koI1rkc/tO0Oxhn3zWCujvYJiTDdw/U=;
        b=PmZHoUoc56jE+kMHXtSTDMLYKfmvaZbnf0wOkHA1zKpJEJIt1hDzJVNdQxS0YvopSB
         hpCZOER0sF/J1ONzolUPdg5WUkrvaWQHevLV2e0q8QlDtcGJgvCaFWfz2m8j5Oo7Xk8A
         3UTP5Db8KsGSJbOOzUE8cDeLmyk7i1LSbDxqoP7Ut2+Q1wiggZCISGCy2UtLAd2tsnFf
         /KUuPENslh6DuxthrE+T2nDhZsK78ZuqiZgAKTb1tNDziUYiixjhp+RIvOTJ20ggSD1i
         D9DRyb2XP0pGvT9A9UW9UwjJkRqukJcZvpjDJoVK5XJg6e0jFWqlwf19GWOYQ7q+vUSh
         M+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m1aI+cWn+pN+koI1rkc/tO0Oxhn3zWCujvYJiTDdw/U=;
        b=FR7om4jj++gsxrwhgIMFfDOW9YlAs65HLDH4Dfnwc1LEgLdkNMiGr2pMDgnEgIrWZp
         Ts/WbpCgENVb4ukltbRcf1y1K4DIaCCprb4jFesinpNJssyX/UWaorPq4ok7Pu3EK6ht
         rsHiTzhAPw3Fab5wGGS0EQQYyBNzcbIFkK2y9a1ZwtKmO7BNnHSB0IGQ1GaAQIdb17Lh
         XwkYuVV/CSr7FVw4u5ZvySLZ058wZjRLxsLiFi0r4+FIOH03hbZ0O2edKx6T2TRJNsN6
         Bb26jlRFcHe3UFrOdstz9S61fgrO1ajNExd1Hn6FX6P8RdzeUj8SO0B04tI19dSp/wdl
         I8Hg==
X-Gm-Message-State: APjAAAWSH6gAeABmyOZWSK9wCwREcXF7vV6iK9hU8QiOWSiOzREj3sT1
        Bd1c5DDPry9Q0TMKUDmIZNCMJ26M
X-Google-Smtp-Source: APXvYqzgJtyx3vqYkN64YiPurIVjO41U46CZ3iMOeWYw+2ScbSNr1PFz6GUWRGEc6fhV8xGNG8OMSA==
X-Received: by 2002:a25:7452:: with SMTP id p79mr7663559ybc.462.1575576454971;
        Thu, 05 Dec 2019 12:07:34 -0800 (PST)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id i81sm5040383ywa.103.2019.12.05.12.07.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 12:07:33 -0800 (PST)
Received: by mail-yb1-f173.google.com with SMTP id o63so2023581ybc.0
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 12:07:32 -0800 (PST)
X-Received: by 2002:a25:bc0a:: with SMTP id i10mr7880662ybh.83.1575576452064;
 Thu, 05 Dec 2019 12:07:32 -0800 (PST)
MIME-Version: 1.0
References: <20191204.165528.1483577978366613524.davem@davemloft.net>
 <20191205064118.8299-1-vvidic@valentin-vidic.from.hr> <20191205113411.5e672807@cakuba.netronome.com>
In-Reply-To: <20191205113411.5e672807@cakuba.netronome.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 5 Dec 2019 15:06:55 -0500
X-Gmail-Original-Message-ID: <CA+FuTSe=GSP41GG+QYKEmQ0eDUEoFeQ+oGAsgGJEZTe=hJq4Tw@mail.gmail.com>
Message-ID: <CA+FuTSe=GSP41GG+QYKEmQ0eDUEoFeQ+oGAsgGJEZTe=hJq4Tw@mail.gmail.com>
Subject: Re: [PATCH v3] net/tls: Fix return values to avoid ENOTSUPP
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 5, 2019 at 2:34 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu,  5 Dec 2019 07:41:18 +0100, Valentin Vidic wrote:
> > ENOTSUPP is not available in userspace, for example:
> >
> >   setsockopt failed, 524, Unknown error 524
> >
> > Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
>
> > diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> > index 0683788bbef0..cd91ad812291 100644
> > --- a/net/tls/tls_device.c
> > +++ b/net/tls/tls_device.c
> > @@ -429,7 +429,7 @@ static int tls_push_data(struct sock *sk,
> >
> >       if (flags &
> >           ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST))
> > -             return -ENOTSUPP;
> > +             return -EOPNOTSUPP;
> >
> >       if (unlikely(sk->sk_err))
> >               return -sk->sk_err;
> > @@ -571,7 +571,7 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
> >       lock_sock(sk);
> >
> >       if (flags & MSG_OOB) {
> > -             rc = -ENOTSUPP;
> > +             rc = -EOPNOTSUPP;
>
> Perhaps the flag checks should return EINVAL? Willem any opinions?

No strong opinion. Judging from do_tcp_sendpages MSG_OOB is a
supported flag in general for sendpage, so signaling that the TLS
variant cannot support that otherwise valid request sounds fine to me.

>
> >               goto out;
> >       }
> >
> > @@ -1023,7 +1023,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
> >       }
> >
> >       if (!(netdev->features & NETIF_F_HW_TLS_TX)) {
> > -             rc = -ENOTSUPP;
> > +             rc = -EOPNOTSUPP;
> >               goto release_netdev;
> >       }
> >
> > @@ -1098,7 +1098,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
> >       }
> >
> >       if (!(netdev->features & NETIF_F_HW_TLS_RX)) {
> > -             rc = -ENOTSUPP;
> > +             rc = -EOPNOTSUPP;
> >               goto release_netdev;
> >       }
> >
> > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > index bdca31ffe6da..5830b8e02a36 100644
> > --- a/net/tls/tls_main.c
> > +++ b/net/tls/tls_main.c
> > @@ -496,7 +496,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
> >       /* check version */
> >       if (crypto_info->version != TLS_1_2_VERSION &&
> >           crypto_info->version != TLS_1_3_VERSION) {
> > -             rc = -ENOTSUPP;
> > +             rc = -EINVAL;
>
> This one I think Willem asked to be EOPNOTSUPP OTOH.

Indeed (assuming no one disagrees). Based on the same rationale: the
request may be valid, it just cannot be accommodated (yet).
