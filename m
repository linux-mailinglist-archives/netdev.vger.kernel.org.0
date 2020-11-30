Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D13D2C895D
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgK3QWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgK3QWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 11:22:15 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C740C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 08:21:35 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id x22so18993824wmc.5
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 08:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6o+tTuRWUftSik6GCGw8PaA9/bP4unYZlgapimV10cE=;
        b=CHxhyjjtBrM1bZN2TVbDcL8qeErZNUNi+SafUYP7Kg7+NIqXNes+kEG8k64ix56b4N
         ixyeYLmzpaZnPyuwDwYnEs/vBGQu5WCq58s24emZtL52HCgLd8OZLtEcy6gOoMHn/8bq
         YwXW/Ldz+lY7ks7Ykz03gNe4Fx7jWA+8nEOEUF41eXwH+LHLMe4OIN3+oGsHuz3p13xC
         2EOoSGXwJRQtHT9RVtK4RFsGVnIWJ8HwKey/GMt8GxScAzwuDko61/tgmaeOHyiittTN
         65on2y2qJy/VNcLc9OAKEsYqkqWdiqymNA6+u/CgVEZJpZaHY5cZY/1lTZ/oJJTeTJRz
         3eLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6o+tTuRWUftSik6GCGw8PaA9/bP4unYZlgapimV10cE=;
        b=gp4Sk4dMzcRYkUPgtiBZKMTzOaY+Xb78BYFGaV6iw9t3eBY35Xv/mq2zQIv3fQ+YMD
         kBWQJ+yXYYI5sjoe5SbTJnjZnEUpNP1DJfNPyJ1SlqIT0uT0ZA0o+W6mhHAS4gv4xXjn
         Oh2pi80yyZeCqk6QXBy4TNNtIwmB0r4rwnUXkuA+50jfgbwbpVZDq7ti3l2IcE3/77Pj
         Z2HtEQYsdFKOs5fFHv9yLbqZt3PwPPJm1U+SGvmKnAo7w/CRUfNiwf1NfmfHCy5Za/He
         b8wE327YD2Sf/lPxNov6RyDp0U1a2/TkS5iXhTZEOQkTIhP04x4nFwGYKCAtzkZXoPNI
         NTEQ==
X-Gm-Message-State: AOAM532wBXjtpbJ9fZ1T+bmP0UNitxfw+d1gMXmmFn8NhVvyVT0ChPSB
        C1GExt8WNG7OC4BSZBaexvjO8gt1igxLxc1kuJW4fw==
X-Google-Smtp-Source: ABdhPJwWHSeE36NOVxA+spSuXFIKBttCccBgfvUU3aPgrGSxETENnvC3eMIep1GgiEHsgEfrx+9QF6OQNlnFBNIaPiA=
X-Received: by 2002:a7b:c8da:: with SMTP id f26mr2909267wml.50.1606753293781;
 Mon, 30 Nov 2020 08:21:33 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com>
 <4bb2cb8a-c3ef-bfa9-7b04-cb2cca32d3ee@samba.org> <CAM1kxwhUcXLKU=2hCVaBngOKRL_kgMX4ONy9kpzKW+ZBZraEYw@mail.gmail.com>
 <5d71d36c-0bfb-a313-07e8-0e22f7331a7a@samba.org> <CAM1kxwh1A3Fh6g7C=kxr67JLF325Cw5jY6CoL6voNhboV1wsVw@mail.gmail.com>
 <12153e6a-37b1-872f-dd82-399e255eef5d@samba.org> <CACSApvZW-UN9_To0J-bO6SMYKJgF9oFvsKk14D-7Tx4zzc8JUw@mail.gmail.com>
 <ebaa91f1-57c7-6c75-47a9-7e21360be2af@samba.org> <CACSApvboyVGOmFKdQLpJd+0fnOAfMvgUwpzRXqLbdSJWMQYmyg@mail.gmail.com>
 <CAM1kxwgaWxhJ7RQT3rMaRow8yUQjM_5=rZkv88+-heaiB_2hjA@mail.gmail.com>
In-Reply-To: <CAM1kxwgaWxhJ7RQT3rMaRow8yUQjM_5=rZkv88+-heaiB_2hjA@mail.gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 30 Nov 2020 11:20:57 -0500
Message-ID: <CACSApvbqLnkZfHh-utMSDvwwjDMP9D2U9XLqUSsLuC6qS8-OSA@mail.gmail.com>
Subject: Re: [RFC 0/1] whitelisting UDP GSO and GRO cmsgs
To:     Victor Stewart <v@nametag.social>
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

On Mon, Nov 30, 2020 at 11:17 AM Victor Stewart <v@nametag.social> wrote:
>
> this being the list of UDP options.. i think we're good here? I'll put
> together a new patch.
>
> https://github.com/torvalds/linux/blob/b65054597872ce3aefbc6a666385eabdf9e288da/include/uapi/linux/udp.h#L30
>
> /* UDP socket options */
> #define UDP_CORK 1 /* Never send partially complete segments */
> #define UDP_ENCAP 100 /* Set the socket to accept encapsulated packets */
> #define UDP_NO_CHECK6_TX 101 /* Disable sending checksum for UDP6X */
> #define UDP_NO_CHECK6_RX 102 /* Disable accpeting checksum for UDP6 */
> #define UDP_SEGMENT 103 /* Set GSO segmentation size */
> #define UDP_GRO 104 /* This socket can receive UDP GRO packets */

That is not sufficient proof, because in udp_sendmsg() we also call
ip_cmsg_send() in udp_sendmsg(), and  ip_cmsg_recv_offset() in
udp_recvmsg().  That said, I have audited them and I think they are
sane.

Jann, what do you think?

> On Mon, Nov 30, 2020 at 3:15 PM Soheil Hassas Yeganeh <soheil@google.com> wrote:
> >
> > On Mon, Nov 30, 2020 at 10:05 AM Stefan Metzmacher <metze@samba.org> wrote:
> > >
> > > Hi Soheil,
> > >
> > > > Thank you for CCing us.
> > > >
> > > > The reason for PROTO_CMSG_DATA_ONLY is explained in the paragraph
> > > > above in the commit message.  PROTO_CMSG_DATA_ONLY is basically to
> > > > allow-list a protocol that is guaranteed not to have the privilege
> > > > escalation in https://crbug.com/project-zero/1975.  TCP doesn't have
> > > > that issue, and I believe UDP doesn't have that issue either (but
> > > > please audit and confirm that with +Jann Horn).
> > > >
> > > > If you couldn't find any non-data CMSGs for UDP, you should just add
> > > > PROTO_CMSG_DATA_ONLY to inet dgram sockets instead of introducing
> > > > __sys_whitelisted_cmsghdrs as Stefan mentioned.
> > >
> > > Was there a specific reason why you only added the PROTO_CMSG_DATA_ONLY check
> > > in __sys_recvmsg_sock(), but not in __sys_sendmsg_sock()?
> >
> > We only needed this for recvmsg(MSG_ERRQUEUE) to support transmit
> > zerocopy.  So, we took a more conservative approach and didn't add it
> > for sendmsg().
> >
> > I believe it should be fine to add it for TCP sendmsg, because for
> > SO_MARK we check the user's capability:
> >
> > if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
> >           return -EPERM;
> >
> > I believe udp_sendmsg() is sane too and I cannot spot any issue there.
> >
> > > metze
> > >
> > >
> > >
