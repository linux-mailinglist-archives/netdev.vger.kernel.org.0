Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1C13A0579
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhFHVFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:05:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233998AbhFHVFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 17:05:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623186210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wgwzQeYzF2U3DxVcbwq7elji6MiiyMu51zrQBJinESg=;
        b=iqZP0IosOiopGTHE3uVc/njVZz5oq3YMHajMaczjzhUCn9gIvBe4p+rRsnvPKINqqKAiYK
        zNJNKj0MPvG+CfbtcQ/vZnJWWcLtHW1y0RHZwLYc4j640zWXduyjeFV8TQPJ/srLo8uORa
        CKVd5ZU2hqPs0JLIcyihXe815Kr8ZNI=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-V-U75yoQNX-MLDGVZPsjKg-1; Tue, 08 Jun 2021 17:03:28 -0400
X-MC-Unique: V-U75yoQNX-MLDGVZPsjKg-1
Received: by mail-il1-f200.google.com with SMTP id d7-20020a056e020c07b02901d77a47ab82so16104446ile.19
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 14:03:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wgwzQeYzF2U3DxVcbwq7elji6MiiyMu51zrQBJinESg=;
        b=ud9zsHqD7OTB5EBSfnprDiTFSYslezwSqGJ39snFX0P33UsIC8vNzITiDEuqaxNiYl
         +NKsNxwukJmAhbs1vozlh1DhJS1TPNDooqj/7NbyPYUMW62MvbRb6g4quN4cE/EfkhH8
         Kn/rD5jzNGDxtaQognSUg68kN3QrhL1ngl3dPqvBBGk69BvsL08OHb7c/haxnj+5Ub8y
         eR91qao5jvxSjrPbgcNV7BjsdaO+lbZ3/hfZg+8hnzbSFlfp7I+6oqrj6TTKF1IHmZ4I
         5bHRKnwGhFQdtKNMzvq029iXfhj2Lj4fT25XZuEfkQbRqidNiVO3q1iqdbwlC6hBzymi
         WAcw==
X-Gm-Message-State: AOAM530KCKkexkIoShy1Oe+TYqRxkNlGW8WbDVkv3VVB9m68Ug3C1fyy
        lXjbiOYl4fjrQtX9UaD7KiSYQ6Cw9NpKJf/oC9DuOYao8MEz/1h2JzqanpqWQ2WAEz6qQTUje+e
        gd8ikfsOxQu5C62bQP6Vb+NAZiTddS/jN
X-Received: by 2002:a5d:948f:: with SMTP id v15mr20684491ioj.28.1623186207676;
        Tue, 08 Jun 2021 14:03:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwfNmW3upGXJ5Dve4Ej9WBccBXA4QinwdWTxjQZOfwjWS64lkmPpJPrRs/IwQ0cW8sqNkKdXyXf3uAs6HhDcY=
X-Received: by 2002:a5d:948f:: with SMTP id v15mr20684477ioj.28.1623186207488;
 Tue, 08 Jun 2021 14:03:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
 <87pmwxsjxm.fsf@suse.com> <CAH2r5msMBZ5AYQcfK=-xrOASzVC0SgoHdPnyqEPRcfd-tzUstw@mail.gmail.com>
 <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org>
In-Reply-To: <35352ef0-86ed-aaa5-4a49-b2b08dc3674d@samba.org>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 8 Jun 2021 17:03:16 -0400
Message-ID: <CAK-6q+g3_9g++wQGbhzBhk2cp=0fb3aVL9GoAoYNPq6M4QnCdQ@mail.gmail.com>
Subject: Re: quic in-kernel implementation?
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jun 8, 2021 at 3:36 AM Stefan Metzmacher <metze@samba.org> wrote:
...
>
> > 2) then switch focus to porting a smaller C userspace implementation of
> > QUIC to Linux (probably not msquic since it is larger and doesn't
> > follow kernel style)
> > to kernel in fs/cifs  (since currently SMB3.1.1 is the only protocol
> > that uses QUIC,
> > and the Windows server target is quite stable and can be used to test against)> 3) use the userspace upcall example from step 1 for
> > comparison/testing/debugging etc.
> > since we know the userspace version is stable
>
> With having the fuse-like socket before it should be trivial to switch
> between the implementations.

So a good starting point would be to have such a "fuse-like socket"
component? What about having a simple example for that at first
without having quic involved. The kernel calls some POSIX-like socket
interface which triggers a communication to a user space application.
This user space application will then map everything to a user space
generated socket. This would be a map from socket struct
"proto/proto_ops" to user space and vice versa. The kernel application
probably can use the kernel_FOO() (e.g. kernel_recvmsg()) socket api
directly then. Exactly like "fuse" as you mentioned just for sockets.

I think two veth interfaces can help to test something like that,
either with a "fuse-like socket" on the other end or an user space
application. Just doing a ping-pong example.

Afterwards we can look at how to replace the user generated socket
application with any $LIBQUIC e.g. msquic implementation as second
step.

- Alex

