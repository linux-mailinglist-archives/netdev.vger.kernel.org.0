Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BCF4AC4F4
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 17:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344659AbiBGQHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 11:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386496AbiBGQBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:01:14 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F45C0401CF
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 08:01:13 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id n14so8061150vkk.6
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 08:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7K869A6tEFT6j5avj9Nj8LDlCMczRFWKyU/2tyGK1kg=;
        b=bfJhPXpMHTfixkAHAc2h5hRg2WTUb0AFw8vVXRv/GLK9oMUvLT+lc8CgeaBk72GAhU
         gOBvl8PP58+eaq4V1EH5KAF5/X1bvUH3FPUWoXsw1EsoXJZmnI5Ct44M6u7wZrWsCelT
         a+hwnLXRW+nhzhwhhsNSIQSfNC4uTN1btW7hyxDLJOOl/2nNG8mp2kL8io6UdpmKDhAw
         W9V4geLA4PP3GpUfggHxQEft1snCW6I29Yrxm9JVZ+inRGMs76eDKx23jOWUXchoMTlR
         az2v0eGoJATSj+ujSbpG/hyprtRJ5cYzx9I9QpraghdP4D0mP1b3ox5F4MPxcLjMD8EI
         AfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7K869A6tEFT6j5avj9Nj8LDlCMczRFWKyU/2tyGK1kg=;
        b=ZcUa1SlBYB/kAD66VYcwOu9qljuEHK6+TP+xVQ4xdddgEXkzxp2jC6mUB680fql55F
         r2YpnOMakocp6Z+9e0+1BnpuKZ4w9mDNzrIWdP/ZEUUGhYzcx4RKosxDwFx+eFr4Y3jF
         /dYAgVYjghcGg2Q2F8fDSLU9SXwSxSijYr015HvF5voEBOZXH6C1NFWCX/j0jNq989EK
         3xZtq3/x2cMqdqCdwcYwml+0zgh7JWOug3S3/06oLlBPE8WxpwY2hyc4mjRSnOlqAbru
         x+JoTcdwl8IxRLEl0TXCp2uUFkNOlfx1sHw8H/b0dDXrsY3N7lFmqkauohHttd5+UIH3
         pIJw==
X-Gm-Message-State: AOAM531020jd5vqZtEa+EFRy8FgRvVpRgPAuBubPB6J3TnmG7nslOElM
        CR+ZD1J23keNNIBAX97VZAK8Zb2ADjg=
X-Google-Smtp-Source: ABdhPJyora8O8XpcUrMePLdfSKKoDHKhEynDJgkFFtcekmkGyEoa/8jn7N9z9/YcRprmupCUv80QJQ==
X-Received: by 2002:a05:6122:17a5:: with SMTP id o37mr134036vkf.25.1644249672135;
        Mon, 07 Feb 2022 08:01:12 -0800 (PST)
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com. [209.85.221.175])
        by smtp.gmail.com with ESMTPSA id w188sm2336436vsb.32.2022.02.07.08.01.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 08:01:11 -0800 (PST)
Received: by mail-vk1-f175.google.com with SMTP id n14so8061128vkk.6
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 08:01:11 -0800 (PST)
X-Received: by 2002:a05:6122:130e:: with SMTP id e14mr149451vkp.26.1644249671186;
 Mon, 07 Feb 2022 08:01:11 -0800 (PST)
MIME-Version: 1.0
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <20220124080215.265538-2-konstantin.meskhidze@huawei.com> <CA+FuTSf4EjgjBCCOiu-PHJcTMia41UkTh8QJ0+qdxL_J8445EA@mail.gmail.com>
 <0934a27a-d167-87ea-97d2-b3ac952832ff@huawei.com> <CA+FuTSc8ZAeaHWVYf-zmn6i5QLJysYGJppAEfb7tRbtho7_DKA@mail.gmail.com>
 <d84ed5b3-837a-811a-6947-e857ceba3f83@huawei.com> <CA+FuTSeVhLdeXokyG4x__HGJyNOwsSicLOb4NKJA-gNp59S5uA@mail.gmail.com>
 <0d33f7cd-6846-5e7e-62b9-fbd0b28ecea9@digikod.net> <91885a8f-b787-62ff-1abb-700641f7c2cb@huawei.com>
In-Reply-To: <91885a8f-b787-62ff-1abb-700641f7c2cb@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 7 Feb 2022 11:00:34 -0500
X-Gmail-Original-Message-ID: <CA+FuTScaoby-=xRKf_Dz3koSYHqrMN0cauCg4jMmy_nDxwPADA@mail.gmail.com>
Message-ID: <CA+FuTScaoby-=xRKf_Dz3koSYHqrMN0cauCg4jMmy_nDxwPADA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] landlock: TCP network hooks implementation
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 12:51 AM Konstantin Meskhidze
<konstantin.meskhidze@huawei.com> wrote:
>
>
>
> 2/1/2022 3:33 PM, Micka=C3=ABl Sala=C3=BCn =D0=BF=D0=B8=D1=88=D0=B5=D1=82=
:
> >
> > On 31/01/2022 18:14, Willem de Bruijn wrote:
> >> On Fri, Jan 28, 2022 at 10:12 PM Konstantin Meskhidze
> >> <konstantin.meskhidze@huawei.com> wrote:
> >>>
> >>>
> >>>
> >>> 1/26/2022 5:15 PM, Willem de Bruijn =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>> On Wed, Jan 26, 2022 at 3:06 AM Konstantin Meskhidze
> >>>> <konstantin.meskhidze@huawei.com> wrote:
> >>>>>
> >>>>>
> >>>>>
> >>>>> 1/25/2022 5:17 PM, Willem de Bruijn =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >>>>>> On Mon, Jan 24, 2022 at 3:02 AM Konstantin Meskhidze
> >>>>>> <konstantin.meskhidze@huawei.com> wrote:
> >>>>>>>
> >>>>>>> Support of socket_bind() and socket_connect() hooks.
> >>>>>>> Current prototype can restrict binding and connecting of TCP
> >>>>>>> types of sockets. Its just basic idea how Landlock could support
> >>>>>>> network confinement.
> >>>>>>>
> >>>>>>> Changes:
> >>>>>>> 1. Access masks array refactored into 1D one and changed
> >>>>>>> to 32 bits. Filesystem masks occupy 16 lower bits and network
> >>>>>>> masks reside in 16 upper bits.
> >>>>>>> 2. Refactor API functions in ruleset.c:
> >>>>>>>        1. Add void *object argument.
> >>>>>>>        2. Add u16 rule_type argument.
> >>>>>>> 3. Use two rb_trees in ruleset structure:
> >>>>>>>        1. root_inode - for filesystem objects
> >>>>>>>        2. root_net_port - for network port objects
> >>>>>>>
> >>>>>>> Signed-off-by: Konstantin Meskhidze
> >>>>>>> <konstantin.meskhidze@huawei.com>
> >>>>>>
> >>>>>>> +static int hook_socket_connect(struct socket *sock, struct
> >>>>>>> sockaddr *address, int addrlen)
> >>>>>>> +{
> >>>>>>> +       short socket_type;
> >>>>>>> +       struct sockaddr_in *sockaddr;
> >>>>>>> +       u16 port;
> >>>>>>> +       const struct landlock_ruleset *const dom =3D
> >>>>>>> landlock_get_current_domain();
> >>>>>>> +
> >>>>>>> +       /* Check if the hook is AF_INET* socket's action */
> >>>>>>> +       if ((address->sa_family !=3D AF_INET) &&
> >>>>>>> (address->sa_family !=3D AF_INET6))
> >>>>>>> +               return 0;
> >>>>>>
> >>>>>> Should this be a check on the socket family (sock->ops->family)
> >>>>>> instead of the address family?
> >>>>>
> >>>>> Actually connect() function checks address family:
> >>>>>
> >>>>> int __inet_stream_connect(... ,struct sockaddr *uaddr ,...) {
> >>>>> ...
> >>>>>           if (uaddr) {
> >>>>>                   if (addr_len < sizeof(uaddr->sa_family))
> >>>>>                   return -EINVAL;
> >>>>>
> >>>>>                   if (uaddr->sa_family =3D=3D AF_UNSPEC) {
> >>>>>                           err =3D sk->sk_prot->disconnect(sk, flags=
);
> >>>>>                           sock->state =3D err ? SS_DISCONNECTING :
> >>>>>                           SS_UNCONNECTED;
> >>>>>                   goto out;
> >>>>>                   }
> >>>>>           }
> >>>>>
> >>>>> ...
> >>>>> }
> >>>>
> >>>> Right. My question is: is the intent of this feature to be limited t=
o
> >>>> sockets of type AF_INET(6) or to addresses?
> >>>>
> >>>> I would think the first. Then you also want to catch operations on
> >>>> such sockets that may pass a different address family. AF_UNSPEC is
> >>>> the known offender that will effect a state change on AF_INET(6)
> >>>> sockets.
> >>>
> >>>    The intent is to restrict INET sockets to bind/connect to some por=
ts.
> >>>    You can apply some number of Landlock rules with port defenition:
> >>>          1. Rule 1 allows to connect to sockets with port X.
> >>>          2. Rule 2 forbids to connect to socket with port Y.
> >>>          3. Rule 3 forbids to bind a socket to address with port Z.
> >>>
> >>>          and so on...
> >>>>
> >>>>>>
> >>>>>> It is valid to pass an address with AF_UNSPEC to a PF_INET(6) sock=
et.
> >>>>>> And there are legitimate reasons to want to deny this. Such as
> >>>>>> passing
> >>>>>> a connection to a unprivileged process and disallow it from
> >>>>>> disconnect
> >>>>>> and opening a different new connection.
> >>>>>
> >>>>> As far as I know using AF_UNSPEC to unconnect takes effect on
> >>>>> UDP(DATAGRAM) sockets.
> >>>>> To unconnect a UDP socket, we call connect but set the family
> >>>>> member of
> >>>>> the socket address structure (sin_family for IPv4 or sin6_family fo=
r
> >>>>> IPv6) to AF_UNSPEC. It is the process of calling connect on an alre=
ady
> >>>>> connected UDP socket that causes the socket to become unconnected.
> >>>>>
> >>>>> This RFC patch just supports TCP connections. I need to check the
> >>>>> logic
> >>>>> if AF_UNSPEC provided in connenct() function for TCP(STREAM) socket=
s.
> >>>>> Does it disconnect already established TCP connection?
> >>>>>
> >>>>> Thank you for noticing about this issue. Need to think through how
> >>>>> to manage it with Landlock network restrictions for both TCP and UD=
P
> >>>>> sockets.
> >>>>
> >>>> AF_UNSPEC also disconnects TCP.
> >>>
> >>> So its possible to call connect() with AF_UNSPEC and make a socket
> >>> unconnected. If you want to establish another connection to a socket
> >>> with port Y, and if there is a landlock rule has applied to a process
> >>> (or container) which restricts to connect to a socket with port Y, it
> >>> will be banned.
> >>> Thats the basic logic.
> >>
> >> Understood, and that works fine for connect. It would be good to also
> >> ensure that a now-bound socket cannot call listen. Possibly for
> >> follow-on work.
> >
> > Are you thinking about a new access right for listen? What would be the
> > use case vs. the bind access right?
> > .
>
>   If bind() function has already been restricted so the following
> listen() function is automatically banned. I agree with Micka=D1=91l abou=
t
> the usecase here. Why do we need new-bound socket with restricted listeni=
ng?

The intended use-case is for a privileged process to open a connection
(i.e., bound and connected socket) and pass that to a restricted
process. The intent is for that process to only be allowed to
communicate over this pre-established channel.

In practice, it is able to disconnect (while staying bound) and
elevate its privileges to that of a listening server:

static void child_process(int fd)
{
        struct sockaddr addr =3D { .sa_family =3D AF_UNSPEC };
        int client_fd;

        if (listen(fd, 1) =3D=3D 0)
                error(1, 0, "listen succeeded while connected");

        if (connect(fd, &addr, sizeof(addr)))
                error(1, errno, "disconnect");

        if (listen(fd, 1))
                error(1, errno, "listen");

        client_fd =3D accept(fd, NULL, NULL);
        if (client_fd =3D=3D -1)
                error(1, errno, "accept");

        if (close(client_fd))
                error(1, errno, "close client");
}

int main(int argc, char **argv)
{
        struct sockaddr_in6 addr =3D { 0 };
        pid_t pid;
        int fd;

        fd =3D socket(PF_INET6, SOCK_STREAM, 0);
        if (fd =3D=3D -1)
                error(1, errno, "socket");

        addr.sin6_family =3D AF_INET6;
        addr.sin6_addr =3D in6addr_loopback;

        addr.sin6_port =3D htons(8001);
        if (bind(fd, (void *)&addr, sizeof(addr)))
                error(1, errno, "bind");

        addr.sin6_port =3D htons(8000);
        if (connect(fd, (void *)&addr, sizeof(addr)))
                error(1, errno, "connect");

        pid =3D fork();
        if (pid =3D=3D -1)
                error(1, errno, "fork");

        if (pid)
                wait(NULL);
        else
                child_process(fd);

        if (close(fd))
                error(1, errno, "close");

        return 0;
}

It's fine to not address this case in this patch series directly, of
course. But we should be aware of the AF_UNSPEC loophole.
