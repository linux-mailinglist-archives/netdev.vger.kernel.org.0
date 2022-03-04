Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F964CDD2E
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 20:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiCDTOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 14:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiCDTOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 14:14:12 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA341E64DA
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 11:13:21 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id z30so5927632ybi.2
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 11:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HXzrJD0OmTYShw29TAfpEJ2cxFlRxUgURS85fde12k8=;
        b=HADK//Y+s4k4magvCJGvnMyBYFxhrSL0KgTboxOdie2vQKjTPQMm0AmzqRi9XbGLw2
         h/g/ChnfJ3ifUzNbkA71Sag9pkpoL6xoykPldv8UuuRExMH1WLPy/Zz1/k/rlXJvV/Kt
         JRmLob52cIfOS9ZSOMto7TWqypIXv/RTnmq9jrrj4ZFvc5R0/fHG+f/7iOzc79mT2p8W
         URi/DAIKwy/kq1Hrp5/ux915G447wqZH6MZ1NKlqnV93kP+R+A/SDPpnfTORV0rRHVxE
         smt4z4S6XYJhNOTYk1ZdA/xSeB/c+JAabJLPcT4tQdCMUnbC/kQ4sQwMy/UVpqMrBvLe
         6Drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HXzrJD0OmTYShw29TAfpEJ2cxFlRxUgURS85fde12k8=;
        b=1m2/liQxHpzk5yIAaOuiEg8hIrlHENpm8/OJ5IEybT9Rv1QhGXzgqYAkESLKAdnEcy
         /1MtjXou+G8PkOFgk6uk5jrIslXcFHdb7f/b0JbHFDljAqOI5qguf9DFtrXn47Wl5DGB
         JS6cFzWRDhB8Z0WevIterMVmCHNJO+fFHY4HpWO2CXeZl0gjY9ObLfJGlO5qOPsdHyLT
         ZIf5NP7W/T86FR6JDR3RgeSi81PDJ04ZyehNjyqLvn4uwN/0fJ37GPjkpyelmYtQ9j+Y
         rnmncSn7GLr68EGxy99gyJFKFphMXZcj9nNK5hHE/xCQVZGgcc7nNivi/UPy/8KorUKS
         WgJw==
X-Gm-Message-State: AOAM533B3Z5AS91PuYWugc7W7H/jaUEkqtlMQyWZp2Z0IDiPgC4NQf+4
        LeO/hrqpbFKRyt9kPdVvSiuHjGN7dtO3ezFh39XDzQ==
X-Google-Smtp-Source: ABdhPJzH86RBmbwkFZwlUQWDuRWqcdVZtL3NB9z1DZIE67PwptjmynrcZFRfPO7sIRPdnI1ZHJ7UQbZ/mA+XU/WoTzs=
X-Received: by 2002:a5b:7c6:0:b0:60b:a0ce:19b with SMTP id t6-20020a5b07c6000000b0060ba0ce019bmr38892398ybq.407.1646421200009;
 Fri, 04 Mar 2022 11:13:20 -0800 (PST)
MIME-Version: 1.0
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-9-eric.dumazet@gmail.com> <726720e6-cd28-646c-1ba3-576a258ae02e@kernel.org>
 <f478bb059d701b774b3d457eb5934f142a6044e8.camel@gmail.com>
 <CANn89i+qJmD9At7otrptkCpnqVUCNi6wXNYnKiwJ1jnse5qNgg@mail.gmail.com> <ea73ca6cb4569847d5f2b2a3a5e1f88d78ba1c1a.camel@gmail.com>
In-Reply-To: <ea73ca6cb4569847d5f2b2a3a5e1f88d78ba1c1a.camel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Mar 2022 11:13:08 -0800
Message-ID: <CANn89iK-treGphHqA-052DMSuuL_-ubdnhBUcpptqT_gnJyovw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 08/14] ipv6: Add hop-by-hop header to
 jumbograms in ip6_output
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 11:00 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, 2022-03-04 at 09:09 -0800, Eric Dumazet wrote:
> > On Fri, Mar 4, 2022 at 7:48 AM Alexander H Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Thu, 2022-03-03 at 21:33 -0700, David Ahern wrote:
> > > > On 3/3/22 11:16 AM, Eric Dumazet wrote:
> > > > > From: Coco Li <lixiaoyan@google.com>
> > > > >
> > > > > Instead of simply forcing a 0 payload_len in IPv6 header,
> > > > > implement RFC 2675 and insert a custom extension header.
> > > > >
> > > > > Note that only TCP stack is currently potentially generating
> > > > > jumbograms, and that this extension header is purely local,
> > > > > it wont be sent on a physical link.
> > > > >
> > > > > This is needed so that packet capture (tcpdump and friends)
> > > > > can properly dissect these large packets.
> > > > >
> > > >
> > > >
> > > > I am fairly certain I know how you are going to respond, but I will ask
> > > > this anyways :-) :
> > > >
> > > > The networking stack as it stands today does not care that skb->len >
> > > > 64kB and nothing stops a driver from setting max gso size to be > 64kB.
> > > > Sure, packet socket apps (tcpdump) get confused but if the h/w supports
> > > > the larger packet size it just works.
> > > >
> > > > The jumbogram header is getting adding at the L3/IPv6 layer and then
> > > > removed by the drivers before pushing to hardware. So, the only benefit
> > > > of the push and pop of the jumbogram header is for packet sockets and
> > > > tc/ebpf programs - assuming those programs understand the header
> > > > (tcpdump (libpcap?) yes, random packet socket program maybe not). Yes,
> > > > it is a standard header so apps have a chance to understand the larger
> > > > packet size, but what is the likelihood that random apps or even ebpf
> > > > programs will understand it?
> > > >
> > > > Alternative solutions to the packet socket (ebpf programs have access to
> > > > skb->len) problem would allow IPv4 to join the Big TCP party. I am
> > > > wondering how feasible an alternative solution is to get large packet
> > > > sizes across the board with less overhead and changes.
> > >
> > > I agree that the header insertion and removal seems like a lot of extra
> > > overhead for the sake of correctness. In the Microsoft case I am pretty
> > > sure their LSOv2 supported both v4 and v6. I think we could do
> > > something similar, we would just need to make certain the device
> > > supports it and as such maybe it would make sense to implement it as a
> > > gso type flag?
> > >
> > > Could we handle the length field like we handle the checksum and place
> > > a value in there that we know is wrong, but could be used to provide
> > > additional data? Perhaps we could even use it to store the MSS in the
> > > form of the length of the first packet so if examined, the packet would
> > > look like the first frame of the flow with a set of trailing data.
> > >
> >
> > I am a bit sad you did not give all this feedback back in August when
> > I presented BIG TCP.
> >
>
> As I recall, I was thinking along the same lines as what you have done
> here, but Dave's question about including IPv4 does bring up an
> interesting point. And the Microsoft version supported both.

Yes, maybe they added metadata for that, and decided to let packet capture
in the dark, or changed tcpdump/wireshark to fetch/use this metadata ?

This was the first thing I tried one year ago, and eventually gave up,
because this was a no go for us.

Then seeing HBH Jumbo support being added recently in tcpdump,
I understood we could finally get visibility, and started BIG TCP using this.

I guess someone might add extra logic to allow ipv4 BIG TCP, if they
really need it,
I will not object to it.

>
> > We did a lot of work in the last 6 months to implement, test all this,
> > making sure this worked.
> >
> > I am not sure I want to spend another 6 months implementing what you suggest.
>
> I am not saying we have to do this. I am simply stating a "what if"
> just to gauge this approach. You could think of it as thinking out
> loud, but in written form.

Understood.

BTW I spent time adding a new gso_type flag, but also gave up because we have
no more room in features_t type.

Solving features_t exhaustion alone is a delicate topic.


>
> > For instance, input path will not like packets larger than 64KB.
> >
> > There is this thing trimming padding bytes, you probably do not want
> > to mess with this.
>
> I had overlooked the fact that this is being used on the input path,
> the trimming would be an issue. I suppose the fact that the LSOv2
> didn't have an Rx counterpart would be one reason for us to not
> consider the IPv4 approach.
>
