Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9412D1727
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 18:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgLGRJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 12:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgLGRJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 12:09:09 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922D8C061793
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 09:08:29 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id j12so5691628ilk.3
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 09:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FlhGNWpS22xLUGKrJatq55XtV5toXtuojAseVebppu8=;
        b=HdRPRrYrSDnmq/ahfD99mdFa/qe6Oyzn6f4ejYGmZlfU8Awio4uVs5FIAM7wZYy2Zj
         iY0kTn1S0zRGVX4ZfsX4xUpZQcInG5lX1OMTVzYXdEmen3LU9wU6j0/egWHQhRgZ26r1
         7TAgfjtJP8gwCKNE1FxfMzqbNxtKgoqEYbkq3kNsypGUFRqYoKTKOjHQ5FCg2uYQ0zSD
         4FY8WNk62/dh1mD14FYsOf5Ol9hpnlSm1QHrYudQ2scq31BisH8PWoq7Odo5CVgkgnAT
         J/LtrPOS1auGOYYrFP1T28r51M6A/7RD6q1u42KYbu25YzrIOcfcfZbTFQmVcXsW0GEI
         RJug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FlhGNWpS22xLUGKrJatq55XtV5toXtuojAseVebppu8=;
        b=pPs0XvuWlEUar+JawDMP1f7VhAyMZT+A7tdjt4upeNrJBXwEg+u2Ju7W9Wc62PuXt8
         xtUteQaFBSKglAQO63lqWNlMDbv48WJx6TxeGk+W32VnLDGD22ay2m0AsLd6TrvRpeVe
         Cqi/JnhjInxiLGptS+f/6mXK+gQ59RbO3yKLqE6OwMG83NzX9vCE9Rq6zfIGUwu+DddT
         3q53LtMUuDoYF5mg1Qt6IcgUP0OMKt7LUTu36O2RvRz597l2BDEw5oMS+KXzme+0UtYK
         OCPeZZBqBwMJRpUckgF5aZ2cNLr8eXxidKYmemIVzeSCyc6ZKtBfU21lW2W1e1588h05
         sDWg==
X-Gm-Message-State: AOAM531c2pExjTyePiHqz3SrekaZVT2gyMBfQc1jk7CHhQiD9pkBZfD8
        vufdwM10bLuWU3ifpgVxEOO5rJZC1VHiHuLaTa9reg==
X-Google-Smtp-Source: ABdhPJxZoprTgJ/zoAkaqxE80HVu5mdJfTr8iMHjsECJjCToguvOCG/DQyilTIFpQQ6JH/lJp0j6M+dxMicwQkzpir8=
X-Received: by 2002:a92:da82:: with SMTP id u2mr22213097iln.137.1607360908670;
 Mon, 07 Dec 2020 09:08:28 -0800 (PST)
MIME-Version: 1.0
References: <20201204180622.14285-1-abuehaze@amazon.com> <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
 <CANn89iJgJQfOeNr9aZHb+_Vozgd9v4S87Kf4iV=mKhuPDGLkEg@mail.gmail.com>
 <3F02FF08-EDA6-4DFD-8D93-479A5B05E25A@amazon.com> <CANn89iL_5QFGQLzxxLyqfNMGiV2wF4CbkY==x5Sh5vqKOTgFtw@mail.gmail.com>
 <781BA871-5D3D-4C89-9629-81345CC41C5C@amazon.com> <CANn89iK1G-YMWo07uByfUwrrK8QPvQPeFrRG1vJhB_OhJo7v2A@mail.gmail.com>
 <CADVnQymROUn6jQdPKxNr_Uc3KMqjX4t0M6=HC6rDxmZzZVv0=Q@mail.gmail.com>
In-Reply-To: <CADVnQymROUn6jQdPKxNr_Uc3KMqjX4t0M6=HC6rDxmZzZVv0=Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Dec 2020 18:08:17 +0100
Message-ID: <CANn89iJyw+EYiXLz_mYQQxdqnZn=vhmj9fj=0Qz0doyzZCsMnQ@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning
 initialisation for high latency connections
To:     Neal Cardwell <ncardwell@google.com>
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

On Mon, Dec 7, 2020 at 5:34 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Mon, Dec 7, 2020 at 11:23 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Dec 7, 2020 at 5:09 PM Mohamed Abuelfotoh, Hazem
> > <abuehaze@amazon.com> wrote:
> > >
> > >     >Since I can not reproduce this problem with another NIC on x86, =
I
> > >     >really wonder if this is not an issue with ENA driver on PowerPC
> > >     >perhaps ?
> > >
> > >
> > > I am able to reproduce it on x86 based EC2 instances using ENA  or  X=
en netfront or Intel ixgbevf driver on the receiver so it's not specific to=
 ENA, we were able to easily reproduce it between 2 VMs running in virtual =
box on the same physical host considering the environment requirements I me=
ntioned in my first e-mail.
> > >
> > > What's the RTT between the sender & receiver in your reproduction? Ar=
e you using bbr on the sender side?
> >
> >
> > 100ms RTT
> >
> > Which exact version of linux kernel are you using ?
>
> Thanks for testing this, Eric. Would you be able to share the MTU
> config commands you used, and the tcpdump traces you get? I'm
> surprised that receive buffer autotuning would work for advmss of
> around 6500 or higher.

autotuning might be delayed by one RTT, this does not match numbers
given by Mohamed (flows stuck in low speed)

autotuning is an heuristic, and because it has one RTT latency, it is
crucial to get proper initial rcvmem values.

People using MTU=3D9000 should know they have to tune tcp_rmem[1]
accordingly, especially when using drivers consuming one page per
incoming MSS.


(mlx4 driver only uses ome 2048 bytes fragment for a 1500 MTU packet.
even with MTU set to 9000)

I want to state again that using 536 bytes as a magic value makes no
sense to me.


For the record, Google has increased tcp_rmem[1] when switching to a bigger=
 MTU.

The reason is simple : If we intend to receive 10 MSS, we should allow
for 90000 bytes of payload, or tcp_rmem[1] set to 180,000
Because of autotuning latency, doubling the value is advised : 360000

Another problem with kicking autotuning too fast is that it might
allow bigger sk->sk_rcvbuf values even for small flows, opening more
surface to malicious attacks.

I _think_ that if we want to allow admins to set high MTU without
having to tune tcp_rmem[], we need something different than current
proposal.
