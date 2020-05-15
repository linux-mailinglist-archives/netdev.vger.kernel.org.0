Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9341D5C93
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgEOWya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgEOWya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:54:30 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B043C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 15:54:30 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k6so4483273iob.3
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 15:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UwywWpUvfDMy0tbb+1CM8eZr8kn9MsRvh8oH3h9JojI=;
        b=W6U20lqStZIKmXKKpkeFxeVhUm06mbLuJGyNqS4CCC0EkTjUhr1hxSF4DvtPnxy9xB
         3XMwCU/Bdxymf9W8ZXL6746DzZXL3pJW2Z7nAQs2Py9beCbbZdYpQVCb6dhvs1IMwuy8
         kw0VSQ9ezvd/rxaz7IOjGD54ECWyXqNuOAEejFrQjTOkQeIf4E97yH4X3nrUXohd7VbK
         GvB86EFCAiyjnzOM0UceQkLQKeDgd/2a/EZlsqHvV719KAJNVMC2ZPyyhH9iH1uWxvyy
         jqccy+TOSm+msHHsF4k9yqGugFVal0H7G79Uwvpfa9r7AQzjXpfeOBL0PR1FD8gUTfrh
         IcqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UwywWpUvfDMy0tbb+1CM8eZr8kn9MsRvh8oH3h9JojI=;
        b=Lcmz7YRCVspgMZcu9V6yglxU7pZ1ula6VKNarZ4te6O8qt5+Vlgw7dl3q2yex6kTWQ
         MZCnfpQBckIlv/3A7i7b+FS/+/Bqoixy/v++vMFCJDfg8ihZFckVBQgZOhw/uRFwK4DO
         X+2WMn5HGW8Zyy69recTBaoQiMI1Vk4mdgYAYFjhlM+gLdWKGHvgaNQW0W2DorONT5wA
         n0H8CW1YBnwHgk+gC6dyqlYHUTEnp+tkDf4WvHZY5e/F0ND5mdURsxhle7A0JqDuug3Z
         5AESQ+Sul+xwBnXllBCGyVJS9ynNquoFQ5orMWWjtTKTk1RxgqfY445YXH6atNoAYa98
         uWEg==
X-Gm-Message-State: AOAM53174rrpkr94nLLYe/UWJUN6qc3W4masty8mS63upd41LDA96wnz
        aJf55Jb5B5a/fwPbJlnk0jI=
X-Google-Smtp-Source: ABdhPJydI6zufdMMdzxD2534iyOUhpNnDjxW/kJW8axEPm+F7wOdGcnzPKXaPuiHOvoYPRhDmQrK7Q==
X-Received: by 2002:a5e:cb4d:: with SMTP id h13mr3083095iok.141.1589583269355;
        Fri, 15 May 2020 15:54:29 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b21sm903283ill.19.2020.05.15.15.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 15:54:28 -0700 (PDT)
Date:   Fri, 15 May 2020 15:54:20 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Message-ID: <5ebf1d9cdc146_141a2acf80de25b892@john-XPS-13-9370.notmuch>
In-Reply-To: <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk>
 <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern wrote:
> On 5/13/20 4:43 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > I don't like this. I makes the egress hook asymmetrical with the ingr=
ess
> > hook (ingress hook sees all traffic, egress only some of it). If the
> > performance hit of disabling GSO is the concern, maybe it's better to=

> > wait until we figure out how to deal with that (presumably by
> > multi-buffer XDP)?
> =

> XDP is for accelerated networking. Disabling a h/w offload feature to
> use a s/w feature is just wrong. But it is more than just disabling GSO=
,
> and multi-buffer support for XDP is still not going to solve the
> problem. XDP is free form allowing any packet modifications - pushing
> and popping headers - and, for example, that blows up all of the skb
> markers for mac, network, transport and their inner versions. Walking
> the skb after an XDP program has run to reset the markers does not make=

> sense. Combine this with the generic xdp overhead (e.g., handling skb
> clone and linearize), and the whole thing just does not make sense.
> =

> We have to accept there a lot of use cases / code paths that simply can=

> not be converted to work with both skbs and xdp_frames. The qdisc code
> is one example. This is another. Requiring a tc program for the skb pat=
h
> is an acceptable trade off.

Hi David,

Another way to set up egress programs that I had been thinking about is t=
o
build a prog_array map with a slot per interface then after doing the
redirect (or I guess the tail call program can do the redirect) do the
tail call into the "egress" program.

From a programming side this would look like,


  ---> ingress xdp bpf                BPF_MAP_TYPE_PROG_ARRAY
         redirect(ifindex)            +---------+
         tail_call(ifindex)           |         |
                      |               +---------+
                      +-------------> | ifindex | =

                                      +---------+
                                      |         |
                                      +---------+


         return XDP_REDIRECT
                        |
                        +-------------> xdp_xmit


The controller would then update the BPF_MAP_TYPE_PROG_ARRAY instead of
attaching to egress interface itself as in the series here. I think it
would only require that tail call program return XDP_REDIRECT so the
driver knows to follow through with the redirect. OTOH the egress program=

can decide to DROP or PASS as well. The DROP case is straight forward,
packet gets dropped. The PASS case is interesting because it will cause
the packet to go to the stack. Which may or may not be expected I guess.
We could always lint the programs or force the programs to return only
XDP_REDIRECT/XDP_PASS from libbpf side.

Would there be any differences from my example and your series from the
datapath side? I think from the BPF program side the only difference
would be return codes XDP_REDIRECT vs XDP_PASS. The control plane is
different however. I don't have a good sense of one being better than
the other. Do you happen to see some reason to prefer native xdp egress
program types over prog array usage?

From performance side I suspect they will be more or less equivalant.

On the positive side using a PROG_ARRAY doesn't require a new attach
point. A con might be right-sizing the PROG_ARRAY to map to interfaces?
Do you have 1000's of interfaces here? Or some unknown number of
interfaces? I've had building resizable hash/array maps for awhile
on my todo list so could add that for other use cases as well if that
was the only problem.

Sorry for the late reply it took me a bit of time to mull over the
patches.

Thanks,
John=
