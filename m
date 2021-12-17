Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36687479645
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 22:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhLQV3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 16:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhLQV3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 16:29:39 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642C4C06173E
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 13:29:39 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id s1so2376035vks.9
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 13:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sS2Tx3qqz7Li8BP/fRubzm0Ncwq+oKY/TagJZ69ZPYA=;
        b=hRMpnddSPOcq8yc7gN/zxE2pwePua3qK/x60WhZrFmB6XnueKn06n3aceN+aZ5AlhS
         bppJe+bF0O4DwtzvJa9Ua5p8ilySKCXbctZ/oZL18nreSttYRMlIiyJ+X84jw//yNw9l
         IIuPcblPABvRVIAeCzZdB+3ZlKv24ftymr7mvGRqbrtGYJOYAT4HDtfPzmnbmgamMAUP
         ynKmnEcc6qF4tQR2uHPUDsTbjcbkfZFou8dVDEhijzND6ylYBw6v6Fh40OuiODpwVAS4
         Nus9NaKIhnBboEXtqylCe4N2bQpE/RIYo5ScPQmg75E3BVQ12jWyHiWdgtWesNuBdr7g
         XOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sS2Tx3qqz7Li8BP/fRubzm0Ncwq+oKY/TagJZ69ZPYA=;
        b=7IqtFY+aMcj9B7nARi2YSz3P/XrelT94iYkClQihXVFcSUdZynrquctLwcz/yfFCKL
         pWOWv0Dct9ifL745KDFsovh34bxXFQDCz2PDcQ/qZiKwKZ7mSmddTn7NYzfZZHiqmI/C
         FKUrAWm/jjeIgr7yiK9QMa2GT7wrt+0Xpv0JnzEh6Y/hobjUac4FY3gWvGH8ORe4Ovh0
         CoKjuAP3blpgZam9/KN3o13H7pTaW7t/yLQeo8CUEyonq0MwaoY7EmjZWxgtQihmPH64
         7RXPIAntGOATkivLmPvlIB3YTLNV6UUFAs6YaB3L0KpBkGGSH1OXQW8RB40zNaq9UMIb
         LRQg==
X-Gm-Message-State: AOAM533EuiFe74zyqL37fo9MxPecuknCxJy8WIUifG2K/D1f17806ZcY
        aBfpw297LNZMvZPR7mLqGgxKprKKcTM=
X-Google-Smtp-Source: ABdhPJw9XSjQAaEKN3MuxHjAx/Ik/6kbdyhbo8YxD7B0GiXVUmjgBxV4P5dmMXhwHo+o+26pUG4jog==
X-Received: by 2002:a05:6122:b64:: with SMTP id h4mr2264140vkf.21.1639776578467;
        Fri, 17 Dec 2021 13:29:38 -0800 (PST)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com. [209.85.221.180])
        by smtp.gmail.com with ESMTPSA id x34sm1120152uac.12.2021.12.17.13.29.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 13:29:37 -0800 (PST)
Received: by mail-vk1-f180.google.com with SMTP id m200so2389070vka.6
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 13:29:37 -0800 (PST)
X-Received: by 2002:a05:6122:130f:: with SMTP id e15mr2169281vkp.14.1639776577209;
 Fri, 17 Dec 2021 13:29:37 -0800 (PST)
MIME-Version: 1.0
References: <20211210072123.386713-1-konstantin.meskhidze@huawei.com>
 <b50ed53a-683e-77cf-9dc2-f4ae1b5fa0fd@digikod.net> <12467d8418f04fbf9fd4a456a2a999f1@huawei.com>
 <b535d1d4-3564-b2af-a5e8-3ba6c0fa86c9@digikod.net> <c8588051-8795-9b8a-cb36-f5440b590581@digikod.net>
In-Reply-To: <c8588051-8795-9b8a-cb36-f5440b590581@digikod.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 17 Dec 2021 16:29:00 -0500
X-Gmail-Original-Message-ID: <CA+FuTSd8RxC9UGfJZA99p3CMxAQhESR_huXYScgwJWGonwbxOw@mail.gmail.com>
Message-ID: <CA+FuTSd8RxC9UGfJZA99p3CMxAQhESR_huXYScgwJWGonwbxOw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Landlock network PoC implementation
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
        yusongping <yusongping@huawei.com>,
        Artem Kuzin <artem.kuzin@huawei.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 4:38 AM Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> =
wrote:
>
> New discussions and RFCs should also include netdev and netfilter
> mailing lists. For people new to Landlock, the goal is to enable
> unprivileged processes (and then potentially malicious ones) to limit
> their own network access (i.e. create a security sandbox for themselves).
>
> Thinking more about network access control for Landlock use case, here
> are better suggestions:
>
> On 14/12/2021 12:51, Micka=C3=ABl Sala=C3=BCn wrote:
> >
> > On 14/12/2021 04:49, Konstantin Meskhidze wrote:
> >> Hi Micka=D1=91l.
> >> I've been thinking about your reply:
> >>
> >>> 4. Kernel objects.
> >>> For filesystem restrictions inodes objects are used to tie landlock
> >>> rules.
> >>> But for socket operations it's preferred to use task_struct object of
> >>> a process, cause sockets' inodes are created just after
> >>> security_socket_create() hook is called, and if its needed to have
> >>> some restriction rule for creating sockets, this rule can't be tied
> >>> to a socket inode cause there is no any has been created at the hook'=
s
> >>> catching moment, see the sock_create_lite() function below:
> >>
> >> - For the file system, we use inodes to identify hierarchies. We can't
> >> - safely rely on stateless objects (e.g. path strings) because the fil=
e
> >> - system changes, and then the rules must change with it.
> >>
> >> - To identify network objects (from the user point of view), we can re=
ly
> >> - on stateless rule definitions because they may be absolute (i.e. IP
> >> - address), e.g. sandbox process creating a new connection or
> >> receveing an
> >> - UDP packet. It is not be the case with UNIX socket if they are come
> >> from
> >> - a path (i.e. inode) though. In this case we'll have to use the exist=
ing
> >> - file system identification mechanism and probably extend the current=
 FS
> >> - access rights.
> >> - A sandbox is a set of processes handled as "subjects". Generic inet
> >> - rules should not be tied to processes (for now) but on
> >> subnets/protocols.
> >>
> >> In current Landlock version inodes are the objects to tie rules to.
> >> For network you are saying that we can rely on stateless rule
> >> definitions and
> >> rules should be tied to subnets/protocols, not to processes'
> >> task_struct objects.
> >> Cause Landlock architecture requires all rules to be tied to a differe=
nt
> >> kernel objects, and when LSM hooks are caught there must be search
> >> procedure completed in a ruleset's red-black tree structure:
> >>     kernel_object -> landlock_object <- landlock_rule
> >> <-----landlock_ruleset
> >>
> >> What kind of kernel objects do you mean by subnets/protocols?
> >> Do you suggest using sockets' inodes in this case or using network rul=
es
> >> without to be tied to any kernel object?
> >
> > The subnets/protocols is the definition provided when creating a rule
> > (i.e. the object from the user point of view), but the kernel may relie=
s
> > on other internal representations. I guess datagram packets would need
> > to be matched against IP/port everytime they are received by a sandboxe=
d
> > process, but tagging sockets or their underlying inodes for stream
> > connections make sense.
> >
> > I don't have experience in the network LSM hooks though, any input is
> > welcome.
> >
> >>     socket_inode -> landlock_object <- landlock_rule
> >> <-----landlock_ruleset
> >>              OR
> >>     landlock_object <- landlock_rule <-----landlock_ruleset
> >>
> >> -----Original Message-----
> >> From: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> >> Sent: Monday, December 13, 2021 4:30 PM
> >> To: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> >> Cc: linux-security-module@vger.kernel.org; yusongping
> >> <yusongping@huawei.com>; Artem Kuzin <artem.kuzin@huawei.com>
> >> Subject: Re: [RFC PATCH 0/2] Landlock network PoC implementation
> >>
> >> Hi Konstantin,
> >>
> >> On 10/12/2021 08:21, Konstantin Meskhidze wrote:
>
> [...]
>
> >>
> >> To sum up, for IPv4 restrictions, we need a new rule type identified
> >> with LANDLOCK_RULE_NET_CIDR4. This will handle a new
> >> struct landlock_net_cidr4_attr {
> >>       __u64 allowed_access;
> >>       __u32 address; // IPv4
> >>       __u8 prefix; // From 0 to 32
> >>       __u8 type; // SOCK_DGRAM, SOCK_STREAM
> >>       __u16 port;
> >> } __attribute__((packed));
> >> // https://datatracker.ietf.org/doc/html/rfc4632
>
> IP addresses (and subnets) should not be part of a rule, at least for
> now. Indeed, IP addresses are tied either to the system architecture
> (e.g. container configuration), the local network or Internet, hence
> moving targets not controlled by application developers. Moreover, from
> a kernel point of view, it is more complex to check and handle subnets,
> which are most of the time tied to the Netfilter infrastructure, not
> suitable for Landlock because of its unprivileged nature.
>
> On the other side, protocols such as TCP and their associated ports are
> normalized and are tied to an application semantic (e.g. TCP/443 for HTTP=
S).
>
> There is other advantages to exclude subnets from this type of rules for
> now (e.g. they could be composed with protocols/ports), but that may
> come later.
>
> I then think that a first MVP to bring network access control support to
> Landlock should focus only on TCP and related ports (i.e. services). I
> propose to not use my previous definition of landlock_net_cidr4_attr but
> to have a landlock_net_service_attr instead:
>
> struct landlock_net_service_attr {
>      __u64 allowed_access; // LANDLOCK_NET_*_TCP
>      __u16 port;
> } __attribute__((packed));
>
> This attribute should handle IPv4 and IPv6 indistinguishably.
>
> [...]
>
> >>
> >> Accesses/suffixes should be:
> >> - CREATE
> >> - ACCEPT
> >> - BIND
> >> - LISTEN
> >> - CONNECT
> >> - RECEIVE (RECEIVE_FROM and SEND_TO should not be needed)
> >> - SEND
> >> - SHUTDOWN
> >> - GET_OPTION (GETSOCKOPT)
> >> - SET_OPTION (SETSOCKOPT)
>
> For now, the only access rights should be LANDLOCK_ACCESS_NET_BIND_TCP
> and LANDLOCK_ACCESS_NET_CONNECT_TCP (tie to two LSM hooks with struct
> sockaddr).
>
> These attribute and access right changes reduce the scope of the network
> access control and make it simpler but still really useful. Datagram
> (e.g. UDP, which could add BIND_UDP and SEND_UDP) sockets will be more
> complex to restrict correctly and should then come in another patch
> series, once TCP is supported.

Thanks for cc:ing the netdev list. I miss some of context, assume that
limits are configured on a socket basis.

One practical use-case I had for voluntary relinquish of privileges:
do not allow connect AF_UNSPEC. This is a little-used feature that
allows an already established connection to disconnect and create a
new connection. Without this option, it is possible for a privileged
process to create connections and hand those off to a less privileged
process. Also, do not allow listen calls, to avoid elevating a socket
to a listener.
