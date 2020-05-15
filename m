Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF1D1D5CAE
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 01:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgEOXPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 19:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgEOXPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 19:15:24 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FD2C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 16:15:24 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id g185so4400865qke.7
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 16:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zda0se5EPNWyu6FaiGlTbS/ViJlKVE/yoHPKjIywqeY=;
        b=n0vrGGC8Rnek4CCPMjpI/Iy8Bi0tOtZgI8Atiu0hjiJRRzgE0NhLl3c0Iixfr7XIce
         GzA7qN4P2ELJvlVJ75P0TRUgx4upHnqxetOg6HXh+mJ7Qc7jsFW4zSLlVWx7vgW4cVzq
         2/v7PgTb/SwxOchaP6SwRJtAHM9PnGbp0U3rjCK/AFeFIveQMi4wEr0LVfByyH1xpmgK
         2Tj5SkHCWK6Zl2lZnsuqvmWInOESzjoriLcp0nx6bMfH0OAUSfDfraNs1L1ekoTE4S6w
         1808926r3+ODMNohwCjCIxXptiiI+v+z3CZx6fMiqkd8HIpX0AsC4KBeaSFzKyu5e68p
         B1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zda0se5EPNWyu6FaiGlTbS/ViJlKVE/yoHPKjIywqeY=;
        b=LQmSmMBYry+ApcM6wGBSM3ZC8wHTVT4ScP6fRor4kRwT4HxHoXJwaWjBPI+823htzZ
         lE6qz4FvQN0m+KeO+yQ2+22U5sXAqJTaTVVpeMykdgUPDU/De2mQ3cCURXYxcbm6VDxN
         Laixtpijg4i51158ZebIIDymfHWRAyXpFlPrHMx5JDDOph/ksqZ0EM66iKruqvNQOcAQ
         f2ZykU/p41Xq1X96i7vkAthFznsVWbGMMg+HK6aXWra+apm+rvJoCghfeYEiTv+lKL9C
         EnOFhoQadCPw0dqxEIOkr56+5WTdj0S0qV/vf77vzN/LEJhtZP0PDT0bbCg56vZkJlzc
         cdGw==
X-Gm-Message-State: AOAM530z79aSo+txFn7lgryXfLD3AoQp2rrvO9CNBlhVdB+HPiEPcd6q
        CAApKy2UlTEN4ZJ+Zzp48A4=
X-Google-Smtp-Source: ABdhPJzoW0IfsCJb3k3qIYZDSaBcDYk13utUhqvZPj6cc2Ztc+DheirD6bWIYPC5lCO8cIVkP7B+5A==
X-Received: by 2002:a37:4e05:: with SMTP id c5mr5895303qkb.232.1589584523325;
        Fri, 15 May 2020 16:15:23 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d014:7501:8ef2:43d? ([2601:282:803:7700:d014:7501:8ef2:43d])
        by smtp.googlemail.com with ESMTPSA id h134sm2695589qke.6.2020.05.15.16.15.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 16:15:22 -0700 (PDT)
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
To:     John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        daniel@iogearbox.net, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <5ebf1d9cdc146_141a2acf80de25b892@john-XPS-13-9370.notmuch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2148cc16-4988-5866-cb64-0a4f3d290a23@gmail.com>
Date:   Fri, 15 May 2020 17:15:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <5ebf1d9cdc146_141a2acf80de25b892@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/20 4:54 PM, John Fastabend wrote:
> Hi David,
> 
> Another way to set up egress programs that I had been thinking about is to
> build a prog_array map with a slot per interface then after doing the
> redirect (or I guess the tail call program can do the redirect) do the
> tail call into the "egress" program.
> 
> From a programming side this would look like,
> 
> 
>   ---> ingress xdp bpf                BPF_MAP_TYPE_PROG_ARRAY
>          redirect(ifindex)            +---------+
>          tail_call(ifindex)           |         |
>                       |               +---------+
>                       +-------------> | ifindex | 
>                                       +---------+
>                                       |         |
>                                       +---------+
> 
> 
>          return XDP_REDIRECT
>                         |
>                         +-------------> xdp_xmit
> 
> 
> The controller would then update the BPF_MAP_TYPE_PROG_ARRAY instead of
> attaching to egress interface itself as in the series here. I think it
> would only require that tail call program return XDP_REDIRECT so the
> driver knows to follow through with the redirect. OTOH the egress program
> can decide to DROP or PASS as well. The DROP case is straight forward,
> packet gets dropped. The PASS case is interesting because it will cause
> the packet to go to the stack. Which may or may not be expected I guess.
> We could always lint the programs or force the programs to return only
> XDP_REDIRECT/XDP_PASS from libbpf side.
> 
> Would there be any differences from my example and your series from the
> datapath side? I think from the BPF program side the only difference
> would be return codes XDP_REDIRECT vs XDP_PASS. The control plane is
> different however. I don't have a good sense of one being better than
> the other. Do you happen to see some reason to prefer native xdp egress
> program types over prog array usage?

host ingress to VM is one use case; VM to VM on the same host is another.

> 
> From performance side I suspect they will be more or less equivalant.
> 
> On the positive side using a PROG_ARRAY doesn't require a new attach
> point. A con might be right-sizing the PROG_ARRAY to map to interfaces?
> Do you have 1000's of interfaces here? Or some unknown number of

1000ish is probably the right ballpark - up to 500 VM's on a host each
with a public and private network connection. From there each interface
can have their own firewall (ingress and egress; most likely VM unique
data, but to be flexible potentially different programs e.g., blacklist
vs whitelist). Each VM will definitely have its own network data - mac
and network addresses, and since VMs are untrusted packet validation in
both directions is a requirement.

With respect to lifecycle management of the programs and the data,
putting VM specific programs and maps on VM specific taps simplifies
management. VM terminates, taps are deleted, programs and maps
disappear. So no validator thread needed to handle stray data / programs
from the inevitable cleanup problems when everything is lumped into 1
program / map or even array of programs and maps.

To me the distributed approach is the simplest and best. The program on
the host nics can be stupid simple; no packet parsing beyond the
ethernet header. It's job is just a traffic demuxer very much like a
switch. All VM logic and data is local to the VM's interfaces.


> interfaces? I've had building resizable hash/array maps for awhile
> on my todo list so could add that for other use cases as well if that
> was the only problem.
> 
> Sorry for the late reply it took me a bit of time to mull over the
> patches.
> 
> Thanks,
> John
> 

