Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379432FE88B
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbhAULRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729925AbhAULPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 06:15:33 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5398C061575
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:14:37 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id g3so2037317ejb.6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=nBP2VfV4oa1iJyfM51a4xj6vNn8XwpiH4pVkXS0RoXQ=;
        b=vpwAMIrSjYdRvxVQWmTm9HbTiDVfGQsfzNDdZ4Bg7xI+evoRc24MEFJu/FJQK0IcX8
         Q1l2f+5+n62a5UJIdkYDpTHhI22lPuQQY8SuHVFmmHdpeV/vC45zL2mD8U7Q54ThCAbk
         OvuogOjgfWAZv06wUCeOh7LqVjDqqzwOp4Fpg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=nBP2VfV4oa1iJyfM51a4xj6vNn8XwpiH4pVkXS0RoXQ=;
        b=Y9BEvyVzaX+Pzu50wtK5pZBEXYMG5ZJ9lATB0rQe1BHZqnzYmdLBS/7pHOH7/7kaOe
         /W3p2gR3p6JcngYeReYmppJF8vpVy9UrK6rjQWobKHcqwjmEtaPtL+glnYlgljaGvNjE
         9FI2BBICwIP9j5DKYMkQ4DyQFZOgpE+Njm5WvwBJnBK266SbjYR6K6s1HwV6iPuqWpUV
         VmQr0aQQYCuJWgY8JMipiJNeQHYgSCPdAPe0zcDxdquo/UHJRX33dnXEJxr4G3zNP/5A
         RJD73LhNjEETHDFDrvqNovM85sogoAIQDNuDcJaZ27WVEr8usP6a1owbc2n40s/tOlk6
         Qodg==
X-Gm-Message-State: AOAM53193wSksh3dz8EsadDh2F61+wFzV3qhh7WnPngyFdMkPXTM44hF
        fYa46ox0JZMaDoAhpCqKn9Zq2Q==
X-Google-Smtp-Source: ABdhPJydRY8ZoGgatPHI1EQSkuLDcDXfldj8WxypqW3YPCpegsaeG8IVlBQF9dqGCtW2q7a9VdusTw==
X-Received: by 2002:a17:906:110a:: with SMTP id h10mr4539949eja.190.1611227676443;
        Thu, 21 Jan 2021 03:14:36 -0800 (PST)
Received: from cloudflare.com (83.24.5.113.ipv4.supernova.orange.pl. [83.24.5.113])
        by smtp.gmail.com with ESMTPSA id j25sm2637309edy.13.2021.01.21.03.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 03:14:35 -0800 (PST)
References: <afb4e544-d081-eee8-e792-a480364a6572@mildred.fr>
 <CAADnVQJnX-+9u--px_VnhrMTPB=O9Y0LH9T7RJbqzfLchbUFvg@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Shanti Lombard =?utf-8?Q?n=C3=A9e_Bouchez-Mongard=C3=A9?= 
        <shanti20210120@mildred.fr>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: More flexible BPF socket inet_lookup hooking after listening
 sockets are dispatched
In-reply-to: <CAADnVQJnX-+9u--px_VnhrMTPB=O9Y0LH9T7RJbqzfLchbUFvg@mail.gmail.com>
Date:   Thu, 21 Jan 2021 12:14:34 +0100
Message-ID: <87r1me4k4l.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 10:06 PM CET, Alexei Starovoitov wrote:
> cc-ing the right folks
>
> On Wed, Jan 20, 2021 at 12:30 PM Shanti Lombard n=C3=A9e Bouchez-Mongard=
=C3=A9
> <shanti20210120@mildred.fr> wrote:
>>
>> Hello,
>>
>> I believe this is my first time here, so please excuse me for mistakes.
>> Also, please Cc me on answers.
>>
>> Background : I am currently investigating putting network services on a
>> machine without using network namespace but still keep them isolated. To
>> do that, I allocated a separate IP address (127.0.0.0/8 for IPv4 and ULA
>> prefix below fd00::/8 for IPv6) and those services are forced to listen
>> to this IP address only. For some, I use seccomp with a small utility I
>> wrote at <https://github.com/mildred/force-bind-seccomp>. Now, I still
>> want a few selected services (reverse proxies) to listed for public
>> address but they can't necessarily listen with INADDR_ANY because some
>> other services might listen on the same port on their private IP. It
>> seems SO_REUSEADDR can be used to circumvent this on BSD but not on
>> Linux. After much research, I found Cloudflare recent contribution
>> (explained here <https://blog.cloudflare.com/its-crowded-in-here/>)
>> about inet_lookup BPF programs that could replace INADDR_ANY listening.

There is also documentation in the kernel:

https://www.kernel.org/doc/html/latest/bpf/prog_sk_lookup.html

>> The inet_lookup BPF programs are hooking up in socket selection code for
>> incoming packets after connected packets are dispatched to their
>> respective sockets but before any new connection is dispatched to a
>> listening socket. This is well explained in the blog post.
>>
>> However, I believe that being able to hook up later in the process could
>> have great use cases. With its current position, the BPF program can
>> override any listening socket too easily. It can also be surprising for
>> administrators used to the socket API not understanding why their
>> listening socket does not receives any packet.
>>
>> Socket selection process (in net/ipv4/inet_hashtables.c function
>> __inet_lookup_listener):
>>
>> - A: look for already connected sockets (before __inet_lookup_listener)
>> - B: look for inet_lookup BPF programs
>> - C: look for listening sockets specifying address and port
>> - D: here, provide another inet_lookup BPF hook
>> - E: look for sockets listening using INADDR_ANY
>> - F: here, provide another inet_lookup BPF hook
>>
>> In position D, a BPF program could implement socket listening like
>> INADDR_ANY listening would do but without the limitation that the port
>> must not be listened on by another IP address
>>
>> In position F, a BPF program could redirect new connection attempts to a
>> socket of its choice, allowing any connection attempt to be intercepted
>> if not catched before by an already listening socket.

Existing hook is placed before regular listening/unconnected socket
lookup to prevent port hijacking on the unprivileged range.

>> The suggestion above would work for my use case, but there is another
>> possibility to make the same use cases possible : implement in BPF (or
>> allow BPF to call) the C and E steps above so the BPF program can
>> supplant the kernel behavior. I find this solution less elegant and it
>> might not work well in case there are multiple inet_lookup BPF programs
>> installed.

Having a BPF helper available to BPF sk_lookup programs that looks up a
socket by packet 4-tuple and netns ID in tcp/udp hashtables sounds
reasonable to me. You gain the flexibility that you describe without
adding code on the hot path.

[...]
