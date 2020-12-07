Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDE22D164A
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgLGQet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgLGQes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:34:48 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E609EC061793
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 08:34:02 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id w18so7870938vsk.12
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 08:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o/DtfijALD2g5Nx6U5RyBf5K19aIZpTx6Lezd9276b0=;
        b=L2LXbdf4t7st2CFnH8cc90+6ihSe/uHXFKUaoqxOW3IWgjiYpQqpgoVRpj/4LGlLnC
         xruVNubc31f1rwlfX/0NMX88upIuvgRNgI17Kg1zkMUSidoKpTQ6luc5cTJ15K2qLIDr
         PdATwyU2lrX86Yjrwvq4kCl2QvVX8wIKmEoGMir35m4LPM6+pT1JU7bwrF3A6pJVF7vL
         xa7MhNj0qJnUZGWr9eeCg3qogLS/jE5y4oeYx2AmdqxpAIPM46DM9p4pDGgfEsuBn8hP
         QRWax5vBJGAt7hSeGJNo+egSoINvAWUbdy0megzN+Czk3DYqURDcA0uJCB7dhjY6M1uW
         OxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o/DtfijALD2g5Nx6U5RyBf5K19aIZpTx6Lezd9276b0=;
        b=RKlyqZohLyxjQqMDZJ5jN0GtH+CSkNeBrt/HZmMZB8CouxpPBFtayIJ1YjD18T9/e6
         kMQl1BQaeWpNaNvl3GWvpKGKK/Pme5CkJCH9lX++/WlxTVq8brAW2rexkGuX1phRMdeF
         uYu2FQmiFFmD0Z/d5/0O+hHW5C7KFGhFFEONI5nhdil78BleJoYxJE5qMHfufJSidMfC
         3rWdc7WFbSMNWG9iAa5jVG5xWdliUqZetWt9T4aWCmP10c+1osfzqmIcilryhCgIRwn1
         pfjfS0DvcvUp7uY/nqQAgvnomrwOMOMpdhEFPe8C1mxGWSSChDHtuW7gv915G+rTJqM4
         M7MA==
X-Gm-Message-State: AOAM532SL1WOQBZG9fsqLDvinX8qLN4+rih657148rigEqhEXWSoTgtQ
        E4dUn9JS381qKIASCA1W0z6ncbqdBi8w5MAEJfdhxA==
X-Google-Smtp-Source: ABdhPJxV4rbu4d9mkLKYYi6mlLJKyHzo94VKtoDQuaCMVPtQ9zLfd9WZXhsn2ZapvXnVIfpuzrxqAikn7Uach7EyNy0=
X-Received: by 2002:a67:cd9a:: with SMTP id r26mr12848920vsl.52.1607358841676;
 Mon, 07 Dec 2020 08:34:01 -0800 (PST)
MIME-Version: 1.0
References: <20201204180622.14285-1-abuehaze@amazon.com> <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
 <CANn89iJgJQfOeNr9aZHb+_Vozgd9v4S87Kf4iV=mKhuPDGLkEg@mail.gmail.com>
 <3F02FF08-EDA6-4DFD-8D93-479A5B05E25A@amazon.com> <CANn89iL_5QFGQLzxxLyqfNMGiV2wF4CbkY==x5Sh5vqKOTgFtw@mail.gmail.com>
 <781BA871-5D3D-4C89-9629-81345CC41C5C@amazon.com> <CANn89iK1G-YMWo07uByfUwrrK8QPvQPeFrRG1vJhB_OhJo7v2A@mail.gmail.com>
In-Reply-To: <CANn89iK1G-YMWo07uByfUwrrK8QPvQPeFrRG1vJhB_OhJo7v2A@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 7 Dec 2020 11:33:44 -0500
Message-ID: <CADVnQymROUn6jQdPKxNr_Uc3KMqjX4t0M6=HC6rDxmZzZVv0=Q@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning
 initialisation for high latency connections
To:     Eric Dumazet <edumazet@google.com>
Cc:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "weiwan@google.com" <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 11:23 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Dec 7, 2020 at 5:09 PM Mohamed Abuelfotoh, Hazem
> <abuehaze@amazon.com> wrote:
> >
> >     >Since I can not reproduce this problem with another NIC on x86, I
> >     >really wonder if this is not an issue with ENA driver on PowerPC
> >     >perhaps ?
> >
> >
> > I am able to reproduce it on x86 based EC2 instances using ENA  or  Xen=
 netfront or Intel ixgbevf driver on the receiver so it's not specific to E=
NA, we were able to easily reproduce it between 2 VMs running in virtual bo=
x on the same physical host considering the environment requirements I ment=
ioned in my first e-mail.
> >
> > What's the RTT between the sender & receiver in your reproduction? Are =
you using bbr on the sender side?
>
>
> 100ms RTT
>
> Which exact version of linux kernel are you using ?

Thanks for testing this, Eric. Would you be able to share the MTU
config commands you used, and the tcpdump traces you get? I'm
surprised that receive buffer autotuning would work for advmss of
around 6500 or higher.

thanks,
neal
