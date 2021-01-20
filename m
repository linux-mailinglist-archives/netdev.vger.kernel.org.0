Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C622FDBD2
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 22:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387457AbhATVK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 16:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729280AbhATVHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 16:07:14 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A43C061575;
        Wed, 20 Jan 2021 13:06:33 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id o19so36066392lfo.1;
        Wed, 20 Jan 2021 13:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bD0Y2/R9ILpESAFdsBEs4WGwWlwfFTXpzZ+PoX1/gaA=;
        b=s7hwLd/8t0d+W5hiqnmCy3pBNiytoBhaptMNf0qmjq3rTfoTkjbJ3t+dIrHji26XSV
         IetAugs+aV5iIwODDEC/p9tZBWXj0a239Lqi/Yp1F3X/isXfXsKZLP2DeHlYNJyhpKqj
         4PvLhrtmU7Jp/nuy5agwmRTg0D13gXE3XN1LljyZVLXjIf1qzk/AeVOq6qd6tzmSCDXP
         jrzzy8rfwI0Q1Ieq8+4tOVQOnq63VPj7ohG+ua+CIFp3ak/ERFk8lkplK7V/h7p47J7J
         lO9rtka3QBd2ty80ZFcll7bwGV2PO+1A0SnswBvkRauwsnWghziwTxReP3059nRRvUSu
         RP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bD0Y2/R9ILpESAFdsBEs4WGwWlwfFTXpzZ+PoX1/gaA=;
        b=k4n1GzyIDeYl84IWCGl7pbAB2NSAS2N8KQE47E0082upgR3vj9gQ8+iiuoexdiWC2a
         pfap92KbGkB8hV4vhSmT9mjl/VLvLMSt3Xe34ONsCmLYf0Y4DNlAGyP/UIFbXqWqSCs0
         hI6XO9avcdyEVylwBymrVV3Q9P4difmi/B6MOhTVyKVZaU/GDUVQUt86Ur5wmvxesty8
         97XNxf6/VwPNZChA+qpCLh4rR+lOwoinXio2farDKvHbfJIyhgWKYR7fkyDztazmesj/
         ao4E/AfWPFYnOMrM05oDp9SnP270iePSRRgXt5LPkPl0ngUnhwup+/T17pa1j2iQtVqD
         B7Lg==
X-Gm-Message-State: AOAM531PC8OUbYGMY5CBTwqfgqTnn1H89+X3RLGjv5eE0dLT8bM2AapO
        KChaqQhJihw6lXaIl8XTfu9dOlZ+ZwwhpngyCCxdDYZP
X-Google-Smtp-Source: ABdhPJyjAKnCebQ1r+HQXfjxSLhMk7pLVtTkwnbB1FyFFj9ExhPUPzWIenr6O/zz7eo299M7bOGbNStpIuAVgoYnzPA=
X-Received: by 2002:a19:8447:: with SMTP id g68mr3228482lfd.539.1611176792193;
 Wed, 20 Jan 2021 13:06:32 -0800 (PST)
MIME-Version: 1.0
References: <afb4e544-d081-eee8-e792-a480364a6572@mildred.fr>
In-Reply-To: <afb4e544-d081-eee8-e792-a480364a6572@mildred.fr>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 20 Jan 2021 13:06:21 -0800
Message-ID: <CAADnVQJnX-+9u--px_VnhrMTPB=O9Y0LH9T7RJbqzfLchbUFvg@mail.gmail.com>
Subject: Re: More flexible BPF socket inet_lookup hooking after listening
 sockets are dispatched
To:     =?UTF-8?Q?Shanti_Lombard_n=C3=A9e_Bouchez=2DMongard=C3=A9?= 
        <shanti20210120@mildred.fr>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cc-ing the right folks

On Wed, Jan 20, 2021 at 12:30 PM Shanti Lombard n=C3=A9e Bouchez-Mongard=C3=
=A9
<shanti20210120@mildred.fr> wrote:
>
> Hello,
>
> I believe this is my first time here, so please excuse me for mistakes.
> Also, please Cc me on answers.
>
> Background : I am currently investigating putting network services on a
> machine without using network namespace but still keep them isolated. To
> do that, I allocated a separate IP address (127.0.0.0/8 for IPv4 and ULA
> prefix below fd00::/8 for IPv6) and those services are forced to listen
> to this IP address only. For some, I use seccomp with a small utility I
> wrote at <https://github.com/mildred/force-bind-seccomp>. Now, I still
> want a few selected services (reverse proxies) to listed for public
> address but they can't necessarily listen with INADDR_ANY because some
> other services might listen on the same port on their private IP. It
> seems SO_REUSEADDR can be used to circumvent this on BSD but not on
> Linux. After much research, I found Cloudflare recent contribution
> (explained here <https://blog.cloudflare.com/its-crowded-in-here/>)
> about inet_lookup BPF programs that could replace INADDR_ANY listening.
>
> The inet_lookup BPF programs are hooking up in socket selection code for
> incoming packets after connected packets are dispatched to their
> respective sockets but before any new connection is dispatched to a
> listening socket. This is well explained in the blog post.
>
> However, I believe that being able to hook up later in the process could
> have great use cases. With its current position, the BPF program can
> override any listening socket too easily. It can also be surprising for
> administrators used to the socket API not understanding why their
> listening socket does not receives any packet.
>
> Socket selection process (in net/ipv4/inet_hashtables.c function
> __inet_lookup_listener):
>
> - A: look for already connected sockets (before __inet_lookup_listener)
> - B: look for inet_lookup BPF programs
> - C: look for listening sockets specifying address and port
> - D: here, provide another inet_lookup BPF hook
> - E: look for sockets listening using INADDR_ANY
> - F: here, provide another inet_lookup BPF hook
>
> In position D, a BPF program could implement socket listening like
> INADDR_ANY listening would do but without the limitation that the port
> must not be listened on by another IP address
>
> In position F, a BPF program could redirect new connection attempts to a
> socket of its choice, allowing any connection attempt to be intercepted
> if not catched before by an already listening socket.
>
> The suggestion above would work for my use case, but there is another
> possibility to make the same use cases possible : implement in BPF (or
> allow BPF to call) the C and E steps above so the BPF program can
> supplant the kernel behavior. I find this solution less elegant and it
> might not work well in case there are multiple inet_lookup BPF programs
> installed.
>
> With this e-mail I wanted to spawn a discussion around that and possibly
> take on the implementation. I never did any kernel development before
> but you must start by something, and I believe this is a rather simple
> improvement (duplicate already existing hooking, just a little bit lower
> in the function). I might not be able to deliver this very quickly
> either because I have limited time for this and I need to learn kernel
> development but I'm ready to take on this task.
>
> Thank you for your time
>
> Shanti
>
>
