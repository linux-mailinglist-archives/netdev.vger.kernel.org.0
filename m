Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C36217463A
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 11:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgB2Kgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 05:36:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34488 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726809AbgB2Kgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 05:36:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582972599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RDYLfoajUtcMGok5Fz92y6j9P6OnpHWHxc3oSfYGXeY=;
        b=gJIkoQr10tLiMaEnyQw4prxMYV7kTDV54c5DyuLP7hvC9okx8OMKB/7d3ueZ+RQ9yNp5YE
        TgMxyOHhhdFCoWr9aCes1423su6js+HijMzCZd9+ZSqqNSPbF4dscIKU41xxU/mbOSNgWp
        tF/NZmw6DcR3T02By+vItT2+Al9PyE4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-CfuT3lpQNQ2dr6hjBTvzyA-1; Sat, 29 Feb 2020 05:36:36 -0500
X-MC-Unique: CfuT3lpQNQ2dr6hjBTvzyA-1
Received: by mail-wr1-f71.google.com with SMTP id n12so2675632wrp.19
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 02:36:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RDYLfoajUtcMGok5Fz92y6j9P6OnpHWHxc3oSfYGXeY=;
        b=IMPebip0Ct4kWlrRVOsBIPY+AL9wGOMjtArvU/Ldkdafi2846feCh6qL35Dowb3Fny
         Aw3gLR85SiSgR3+nX9JhJXu2/aWIPyrz9q+JBFHNMlK4bsRc9H++B2QvqqCYQUSMIJML
         qmDFa25LrfjxgbWcuSrs3FNeTxjW9BtFSSxBbTT+sv2+7X3SwGgwXFIjlJ5QULjwBK8o
         lEpesS65DPBmPBjOahZRF0f29DNWE7q9dWcd59pU0OqUUBoi9zgDHW1hvmYniJPfTkIi
         q8is6iQBsjzVO+qWjigDNo0F/5XpRFTWhaaM+X43M9VSTs0dyheUw0PIVLrceH80XpNz
         sxUA==
X-Gm-Message-State: APjAAAVNfZBX2M0+OuWqh8LIeaT3ao+ZUxSNEXvXw11X4MYYI0bputS8
        V976lNrNjf+H9yf822paZaL7lvaYDAQ2UCSfbRoWqKy0HF/y0gM+Kd8sbkSdYQO7a86p+hXxOnT
        VKqc5uRnSuHDkqKJq
X-Received: by 2002:a5d:5148:: with SMTP id u8mr10708892wrt.132.1582972594854;
        Sat, 29 Feb 2020 02:36:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqw+ZxU54fL8fQW30AZ8mkUBbQNdEK9GVbxsjxYs5GyYFeJvmnNCemb624Y4krRUG3vlvih5GQ==
X-Received: by 2002:a5d:5148:: with SMTP id u8mr10708866wrt.132.1582972594561;
        Sat, 29 Feb 2020 02:36:34 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id y7sm4767404wrl.26.2020.02.29.02.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 02:36:33 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E2F66180362; Sat, 29 Feb 2020 11:36:31 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ctakshak@fb.com
Subject: Re: [PATCH RFC] Userspace library for handling multiple XDP programs on an interface
In-Reply-To: <20200228221519.GE51456@rdna-mbp>
References: <158289973977.337029.3637846294079508848.stgit@toke.dk> <20200228221519.GE51456@rdna-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 29 Feb 2020 11:36:31 +0100
Message-ID: <87v9npu1cg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrey Ignatov <rdna@fb.com> writes:

> The main challenges I see for applying this approach in fb case is the
> need to recreate the dispatcher every time a new program has to be
> added.
>
> Imagine there there are a few containers and every container wants to
> run an application that attaches XDP program to the "dispatcher" via
> freplace. Every application may have a "priority" reserved for it, but
> recreating the dispatcher may have race condition, for example:

Yeah, I did realise this is potentially racy, but so is any loading of
XDP programs right now (i.e., two applications can both try loading a
single XDP program at the same time, and end up stomping on each others'
feet). So we'll need to solve that in any case. I've managed to come up
with two possible ways to solve this:

1. Locking: Make it possible for a process to temporarily lock the
XDP program loaded onto an interface so no other program can modify it
until the lock is released.

2. A cmpxchg operation: Add a new field to the XDP load netlink message
containing an fd of the old program that the load call is expecting to
replace. I.e., instead of attach(ifindex, prog_fd, flags), you have
attach(ifindex, prog_fd, old_fd, flags). The kernel can then check that
the old_fd matches the program currently loaded before replacing
anything, and reject the operation otherwise.

With either of these mechanisms it should be possible for userspace to
do the right thing if the kernel state changes underneath it. I'm
leaning towards (2) because I think it is simpler to implement and
doesn't require any new state be kept in the kernel. The drawback is
that it may lead to a lot of retries if many processes are trying to
load their programs at the same time. Some data would be good here: How
often do you expect programs to be loaded/unloaded in your use case?

As for your other suggestion:

> Also I see at least one other way to do it w/o regenerating dispatcher
> every time:
>
> It can be created and attached once with "big enough" number of slots,
> for example with 100 and programs may use use their corresponding slot
> to freplace w/o regenerating the dispatcher. Having those big number of
> no-op slots should not be a big deal from what I understand and kernel
> can optimize it.

I thought about having the dispatcher stay around for longer, and just
replacing more function slots as new programs are added/removed. The
reason I didn't go with this is the following: Modifying the dispatcher
while it is loaded means that the modifications will apply to traffic on
the interface immediately. This is fine for simple add/remove of a
single program, but it limits which operations you can do atomically.
E.g., you can't switch the order of two programs, or add or remove more
than one, in a way that is atomic from the PoV of the traffic on the
interface.

Since I expect that we will need to support atomic operations even for
these more complex cases, that means we'll need to support rebuilding
the dispatcher anyway, and solving the race condition problem for that.
And once we've done that, the simple add/remove in the existing
dispatcher becomes just an additional code path that we'll need to
maintain, so why bother? :)

I am also not sure it's as simple as you say for the kernel to optimise
a more complex dispatcher: The current dead code elimination relies on
map data being frozen at verification time, so it's not applicable to
optimising a dispatcher as it is being changed later. Now, this could
probably be fixed and/or we could try doing clever tricks with the flow
control in the dispatcher program itself. But again, why bother if we
have to support the dispatcher rebuild mode of operation anyway?

I may have missed something, of course, so feel free to point out if you
see anything wrong with my reasoning above!

> This is the main thing so far, I'll likely provide more feedback when
> have some more time to read the code ..

Sounds good! You're already being very helpful, so thank you! :)

-Toke

