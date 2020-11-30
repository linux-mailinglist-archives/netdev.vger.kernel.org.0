Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FF62C8931
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgK3QSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727243AbgK3QSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 11:18:21 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C7CC0613D6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 08:17:35 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id lt17so22908616ejb.3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 08:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kYkPuL9GlnXGub5oypPWNVCVWSUH0M/T34e+O98VB4s=;
        b=su5xjkeLP9kKNUx3nOasdTgwLq06Wsf29p4GXhzSORYciggHEz77TXkL4fNLuJqTcZ
         9ciKLvPJvvk8Cz+zlbkVrC8jo4omcFcjyWQZIYSlwWjl7ICb4Aiq7Fri65Y8erbM4XBd
         JUU3zaoyTPf3ECxOMiVcaOin3ByMDs4epeM5d5s9ukTus8T3IBK6lCn00H/sA0JJSwwl
         sPTHLQmR58UUOhbDK1tfmcqJxWfQjMtSDBByOOC0tCQSkaReqBG0s1LJD9MJXJSa3kuE
         OvpsiCPlFSwLqlJ7ZO0+o2QGjNOQu9eUI/o2rrRL69Lv7ATzgTO2C+YgFubHRoA6t+o+
         LDAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kYkPuL9GlnXGub5oypPWNVCVWSUH0M/T34e+O98VB4s=;
        b=h3ZSBQZ3vHkcdcxKSLMHYGLVHBNhzIZmD40JrBv4qcgihXQwbaGxtNhXmxLkqCqt9Z
         U/GoWBXUfZ6i93SQumjP5xiMWNhUmEW1QqO9W6Nn8rtNsLOMPI5+RDx42lv4sdfMmToU
         rysWHAob7YznLroTshcgtPjzK/CssdH+whZ3sU7xemn4UzKui7zxo7YjYpXyvtpY/kf9
         ZtqBzclvOuzRGRxZ4wlWZttwqUYrZnsaLQFKnjAlpwUQRO8JgYNoidhIUZV1DMkZ+pdh
         rV16/QY8ZeifMRm6GTfQyGDTxF4INI8PFmDiOcvqDJhHWBQcFAF1Lemu+UpaZXkkGCA/
         tWKA==
X-Gm-Message-State: AOAM531JoP1pRcq2gvHUWfzJBMNwya+YGVRLAU6jhei+J0y6s6kh7DZw
        isWDNENaQak+rETlXM6JhixHfX9YmPtRQOoeduaXVw==
X-Google-Smtp-Source: ABdhPJzSGozq00C4XGuB0NdGHdeM8ADvnY2iASJbH8SFqybL5yAl7kkyvxnrcEwZkbhjs46UpHMVRHXDxfyH6Amx++c=
X-Received: by 2002:a17:906:40d3:: with SMTP id a19mr10781898ejk.98.1606753053317;
 Mon, 30 Nov 2020 08:17:33 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com>
 <4bb2cb8a-c3ef-bfa9-7b04-cb2cca32d3ee@samba.org> <CAM1kxwhUcXLKU=2hCVaBngOKRL_kgMX4ONy9kpzKW+ZBZraEYw@mail.gmail.com>
 <5d71d36c-0bfb-a313-07e8-0e22f7331a7a@samba.org> <CAM1kxwh1A3Fh6g7C=kxr67JLF325Cw5jY6CoL6voNhboV1wsVw@mail.gmail.com>
 <12153e6a-37b1-872f-dd82-399e255eef5d@samba.org> <CACSApvZW-UN9_To0J-bO6SMYKJgF9oFvsKk14D-7Tx4zzc8JUw@mail.gmail.com>
 <ebaa91f1-57c7-6c75-47a9-7e21360be2af@samba.org> <CACSApvboyVGOmFKdQLpJd+0fnOAfMvgUwpzRXqLbdSJWMQYmyg@mail.gmail.com>
In-Reply-To: <CACSApvboyVGOmFKdQLpJd+0fnOAfMvgUwpzRXqLbdSJWMQYmyg@mail.gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Mon, 30 Nov 2020 16:17:22 +0000
Message-ID: <CAM1kxwgaWxhJ7RQT3rMaRow8yUQjM_5=rZkv88+-heaiB_2hjA@mail.gmail.com>
Subject: Re: [RFC 0/1] whitelisting UDP GSO and GRO cmsgs
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Luke Hsiao <lukehsiao@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jann Horn <jannh@google.com>, Arjun Roy <arjunroy@google.com>,
        netdev <netdev@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this being the list of UDP options.. i think we're good here? I'll put
together a new patch.

https://github.com/torvalds/linux/blob/b65054597872ce3aefbc6a666385eabdf9e288da/include/uapi/linux/udp.h#L30

/* UDP socket options */
#define UDP_CORK 1 /* Never send partially complete segments */
#define UDP_ENCAP 100 /* Set the socket to accept encapsulated packets */
#define UDP_NO_CHECK6_TX 101 /* Disable sending checksum for UDP6X */
#define UDP_NO_CHECK6_RX 102 /* Disable accpeting checksum for UDP6 */
#define UDP_SEGMENT 103 /* Set GSO segmentation size */
#define UDP_GRO 104 /* This socket can receive UDP GRO packets */

On Mon, Nov 30, 2020 at 3:15 PM Soheil Hassas Yeganeh <soheil@google.com> wrote:
>
> On Mon, Nov 30, 2020 at 10:05 AM Stefan Metzmacher <metze@samba.org> wrote:
> >
> > Hi Soheil,
> >
> > > Thank you for CCing us.
> > >
> > > The reason for PROTO_CMSG_DATA_ONLY is explained in the paragraph
> > > above in the commit message.  PROTO_CMSG_DATA_ONLY is basically to
> > > allow-list a protocol that is guaranteed not to have the privilege
> > > escalation in https://crbug.com/project-zero/1975.  TCP doesn't have
> > > that issue, and I believe UDP doesn't have that issue either (but
> > > please audit and confirm that with +Jann Horn).
> > >
> > > If you couldn't find any non-data CMSGs for UDP, you should just add
> > > PROTO_CMSG_DATA_ONLY to inet dgram sockets instead of introducing
> > > __sys_whitelisted_cmsghdrs as Stefan mentioned.
> >
> > Was there a specific reason why you only added the PROTO_CMSG_DATA_ONLY check
> > in __sys_recvmsg_sock(), but not in __sys_sendmsg_sock()?
>
> We only needed this for recvmsg(MSG_ERRQUEUE) to support transmit
> zerocopy.  So, we took a more conservative approach and didn't add it
> for sendmsg().
>
> I believe it should be fine to add it for TCP sendmsg, because for
> SO_MARK we check the user's capability:
>
> if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
>           return -EPERM;
>
> I believe udp_sendmsg() is sane too and I cannot spot any issue there.
>
> > metze
> >
> >
> >
