Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E7E49CC12
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 15:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242025AbiAZOQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 09:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbiAZOQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 09:16:13 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A36C06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 06:16:12 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id c36so43064233uae.13
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 06:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=24sUfwbscwaSS1v34BS4ZqD0wKMzP9W3ynvkxLp+q7A=;
        b=gTPeTHWahFdxiWoNawVGnQRFGBASr9fBJuikPpOrLvvhH2vzZ+2+pPy8Z57VxahUAL
         8bsxCmvMj2LrgZaTqWye/dFd0NkhDIDI9rFWVU23DtW5AADN9tFyUl33P3/f/bOXpRkg
         pb4C/pmYTbSE3SSnsvAdW57nQM1zCNCqDfrfw+7fu7Vq2icotD3VMoRVqlNJcURPzr1p
         n9YcYrPLwHikLJ6ZOS4z94p/rk+iihdno/27NnfIg9Wadbjp2aJ/m2/+wCih0QLMPhua
         uVSinWvM5n1gzig7XrwbBkUEf/RzeDoQJiQB0pt2RLUpiBxO6IvHgCBoHf5kylBB/7No
         tOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=24sUfwbscwaSS1v34BS4ZqD0wKMzP9W3ynvkxLp+q7A=;
        b=QKDmleS7F/xMFvQmQ20hDMlqtWGPbSRPi65BhCcK6soIEpfzXxV1t/RSxojgiA5W4x
         +OIW9n+Ay0T+HRshWXunrALdZbXRzpZyqNoddhv3+kY0A8pA/PGNX0MzQH4qPa+UqtCH
         m2wP+E/LEWcGXLAN5jwiD2meiC+IXW7ZIntZPDvPYOs7bMyG2N6PrbOF+xxK0EBlN0Zi
         1FkSTpDVGlj7i/W1ZLSKHwb4v8DEZ4ZUOwtBf2PH+vD8zoDap9DmShLVTviCfIcx9/6e
         pP/v7Yn3+4maCB8tybBstzCAlvKRSuXV8cZkMlM3FkWSnPb+82DvHGX942irJqrE/hMO
         OKVA==
X-Gm-Message-State: AOAM531du2H3Efd3TW1jCPdI30eZc3MgvoYohGCiGS+UXCI9ZQnKSwwy
        qVmCBwlq146wSv4IgaZI5ol9TnxCdAw=
X-Google-Smtp-Source: ABdhPJzVGbhFRko+6uajCml/hGGd7jLbyQLiYl7KNoma/qu7QCenkySYUul6Lao03/p7ri3EV2kcdA==
X-Received: by 2002:a67:1081:: with SMTP id 123mr9001031vsq.69.1643206571938;
        Wed, 26 Jan 2022 06:16:11 -0800 (PST)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id k20sm295808vsg.14.2022.01.26.06.16.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 06:16:11 -0800 (PST)
Received: by mail-ua1-f51.google.com with SMTP id w21so43065878uan.7
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 06:16:11 -0800 (PST)
X-Received: by 2002:a67:ea17:: with SMTP id g23mr4599918vso.35.1643206570833;
 Wed, 26 Jan 2022 06:16:10 -0800 (PST)
MIME-Version: 1.0
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <20220124080215.265538-2-konstantin.meskhidze@huawei.com> <CA+FuTSf4EjgjBCCOiu-PHJcTMia41UkTh8QJ0+qdxL_J8445EA@mail.gmail.com>
 <0934a27a-d167-87ea-97d2-b3ac952832ff@huawei.com>
In-Reply-To: <0934a27a-d167-87ea-97d2-b3ac952832ff@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 26 Jan 2022 09:15:34 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc8ZAeaHWVYf-zmn6i5QLJysYGJppAEfb7tRbtho7_DKA@mail.gmail.com>
Message-ID: <CA+FuTSc8ZAeaHWVYf-zmn6i5QLJysYGJppAEfb7tRbtho7_DKA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] landlock: TCP network hooks implementation
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     mic@digikod.net, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, netfilter@vger.kernel.org,
        yusongping@huawei.com, artem.kuzin@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 3:06 AM Konstantin Meskhidze
<konstantin.meskhidze@huawei.com> wrote:
>
>
>
> 1/25/2022 5:17 PM, Willem de Bruijn =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Mon, Jan 24, 2022 at 3:02 AM Konstantin Meskhidze
> > <konstantin.meskhidze@huawei.com> wrote:
> >>
> >> Support of socket_bind() and socket_connect() hooks.
> >> Current prototype can restrict binding and connecting of TCP
> >> types of sockets. Its just basic idea how Landlock could support
> >> network confinement.
> >>
> >> Changes:
> >> 1. Access masks array refactored into 1D one and changed
> >> to 32 bits. Filesystem masks occupy 16 lower bits and network
> >> masks reside in 16 upper bits.
> >> 2. Refactor API functions in ruleset.c:
> >>      1. Add void *object argument.
> >>      2. Add u16 rule_type argument.
> >> 3. Use two rb_trees in ruleset structure:
> >>      1. root_inode - for filesystem objects
> >>      2. root_net_port - for network port objects
> >>
> >> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> >
> >> +static int hook_socket_connect(struct socket *sock, struct sockaddr *=
address, int addrlen)
> >> +{
> >> +       short socket_type;
> >> +       struct sockaddr_in *sockaddr;
> >> +       u16 port;
> >> +       const struct landlock_ruleset *const dom =3D landlock_get_curr=
ent_domain();
> >> +
> >> +       /* Check if the hook is AF_INET* socket's action */
> >> +       if ((address->sa_family !=3D AF_INET) && (address->sa_family !=
=3D AF_INET6))
> >> +               return 0;
> >
> > Should this be a check on the socket family (sock->ops->family)
> > instead of the address family?
>
> Actually connect() function checks address family:
>
> int __inet_stream_connect(... ,struct sockaddr *uaddr ,...) {
> ...
>         if (uaddr) {
>                 if (addr_len < sizeof(uaddr->sa_family))
>                 return -EINVAL;
>
>                 if (uaddr->sa_family =3D=3D AF_UNSPEC) {
>                         err =3D sk->sk_prot->disconnect(sk, flags);
>                         sock->state =3D err ? SS_DISCONNECTING :
>                         SS_UNCONNECTED;
>                 goto out;
>                 }
>         }
>
> ...
> }

Right. My question is: is the intent of this feature to be limited to
sockets of type AF_INET(6) or to addresses?

I would think the first. Then you also want to catch operations on
such sockets that may pass a different address family. AF_UNSPEC is
the known offender that will effect a state change on AF_INET(6)
sockets.

> >
> > It is valid to pass an address with AF_UNSPEC to a PF_INET(6) socket.
> > And there are legitimate reasons to want to deny this. Such as passing
> > a connection to a unprivileged process and disallow it from disconnect
> > and opening a different new connection.
>
> As far as I know using AF_UNSPEC to unconnect takes effect on
> UDP(DATAGRAM) sockets.
> To unconnect a UDP socket, we call connect but set the family member of
> the socket address structure (sin_family for IPv4 or sin6_family for
> IPv6) to AF_UNSPEC. It is the process of calling connect on an already
> connected UDP socket that causes the socket to become unconnected.
>
> This RFC patch just supports TCP connections. I need to check the logic
> if AF_UNSPEC provided in connenct() function for TCP(STREAM) sockets.
> Does it disconnect already established TCP connection?
>
> Thank you for noticing about this issue. Need to think through how
> to manage it with Landlock network restrictions for both TCP and UDP
> sockets.

AF_UNSPEC also disconnects TCP.

> >
> >> +
> >> +       socket_type =3D sock->type;
> >> +       /* Check if it's a TCP socket */
> >> +       if (socket_type !=3D SOCK_STREAM)
> >> +               return 0;
> >> +
> >> +       if (!dom)
> >> +               return 0;
> >> +
> >> +       /* Get port value in host byte order */
> >> +       sockaddr =3D (struct sockaddr_in *)address;
> >> +       port =3D ntohs(sockaddr->sin_port);
> >> +
> >> +       return check_socket_access(dom, port, LANDLOCK_ACCESS_NET_CONN=
ECT_TCP);
> >> +}
> > .
