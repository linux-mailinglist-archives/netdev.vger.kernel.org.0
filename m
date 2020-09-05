Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9DF25E73E
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 13:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgIELXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 07:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgIELSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 07:18:54 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F692C061244;
        Sat,  5 Sep 2020 04:18:49 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id d189so9065427oig.12;
        Sat, 05 Sep 2020 04:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u0IiXGtqdVhPBP8lypoHpnMMZjPnrNzat1vDiguO3/w=;
        b=imojGsDfX9o3sISaUmP+ekDfe+wEkw4hcXh16I+lmcZFsLPw3eJV+66Ao9Mho2M2R0
         lo0xZnnlGf7tHHVmHqPmAWF5xQFGMMDZLYTcgpWAFltwCvPnqtKNybQidOiwkBkpKE20
         sL0l9Zsl9niBUAQYRF2HrD/4Y9RaU/meyHtysjANHaaoNExpNlH+2KNekwuYJnVzohdv
         0FdS1yGaijCUKFVbZeoKZEki/WCDEHY4pOjsBQO5aRq7Lo6bA8K07rS3hGUosIEewXWO
         BtMxAJu+XnIBHymTHmyPIWnHIrBr5H3T2PR4u/QIQvm/b3N6bxSzJBN4PN/p2cm7z3OZ
         XhWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u0IiXGtqdVhPBP8lypoHpnMMZjPnrNzat1vDiguO3/w=;
        b=QAG06Ryjv8AgYE9m7XSh2pAzq9iE6lE/hjEHrKlmslHq/f0aftP49129kWtCQpxJVi
         lucl0kA/1/3R76iV3B0LN2ShGeCu4Bko010LpLCIyWB6lwlM2XFSNRI2RXTyORxDWcit
         kH+6iQgT2WJTfa/dImEJGah2J42N2sqk0e0fZ6kC8vmk/BAxJTp6O1WjaX6XD246HXGs
         USGBcd3nx44tBXp+pn0yC5efBVQFF2SMmeuuymyPl8dWU58AKfA6MBtTQ/VSzr3qonFV
         rUCKcbLx0niu2OZFki0RvS+RjL4O4p5Ii3FsSzMqYuIdHcwXIHEA8JsLUWgshPyhZObH
         E7TQ==
X-Gm-Message-State: AOAM530pPCZ98vFnn64RsjwcR6/MjUL8Dq+MYQe5FypPjGF3Iq9qRFk1
        lImtrIiyqK+0y5MutLZ6QAza/WZ+laghxz3jklU=
X-Google-Smtp-Source: ABdhPJxTEHXBi2TidmZO09UM27LyyZZJr1CpyAZVOQPu6doAHTWAtUKAU5t7KV7Jtyne2NYAfEovB0V/pV4K50na/J8=
X-Received: by 2002:a54:4688:: with SMTP id k8mr7804768oic.163.1599304728501;
 Sat, 05 Sep 2020 04:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200904162154.GA24295@wunner.de> <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
In-Reply-To: <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Sat, 5 Sep 2020 13:18:37 +0200
Message-ID: <CAF90-WhWpiAPcpU81P3cPTUmRD-xGkuZ9GZA8Q3cPN7RQKhXeA@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Fri, Sep 4, 2020 at 11:14 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
[...]
>
> Its trivial to achieve with tc/BPF on the existing egress hook today. Probably
> takes less time than to write up this mail ...
>
> root@x:~/x# cat foo.c
>
> #include <linux/bpf.h>
> #include <linux/if_ether.h>
> #include <arpa/inet.h>
>
> #ifndef __section
> # define __section(NAME)                \
>     __attribute__((section(NAME), used))
> #endif
>
> #define ETH_P_KUNBUSGW  0x419C
>
> #define PASS    0
> #define DROP    2
>
> int foo(struct __sk_buff *skb)
> {
>         void *data_end = (void *)(long)skb->data_end;
>         void *data = (void *)(long)skb->data;
>         struct ethhdr *eth = data;
>
>         if (data + sizeof(*eth) > data_end)
>                 return DROP;
>
>         return eth->h_proto == htons(ETH_P_KUNBUSGW) ? PASS : DROP;
> }
>
> char __license[] __section("license") = "";
>
> root@x:~/x# clang -target bpf -Wall -O2 -c foo.c -o foo.o
> root@x:~/x# ip link add dev foo type dummy
> root@x:~/x# ip link set up dev foo
> root@x:~/x# tc qdisc add dev foo clsact
> root@x:~/x# tc filter add dev foo egress bpf da obj foo.o sec .text
>
> There we go, attached to the device on existing egress. Double checking it
> does what we want:
>
> root@x:~/x# cat foo.t
> {
>     0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
>     0xbb, 0xbb, 0xbb, 0xbb, 0xbb, 0xbb,
>     0x41, 0x9c
> }
> root@x:~/x# trafgen -i foo.t -o foo -n 1 -q
> root@x:~/x# tcpdump -i foo
> [...]
> 22:43:42.981112 bb:bb:bb:bb:bb:bb (oui Unknown) > aa:aa:aa:aa:aa:aa (oui Unknown), ethertype Unknown (0x419c), length 14:
>
> root@x:~/x# cat bar.t
> {
>     0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xaa,
>     0xbb, 0xbb, 0xbb, 0xbb, 0xbb, 0xbb,
>     0xee, 0xee
> }
> root@x:~/x# trafgen -i bar.t -o foo -n 1 -q
> root@x:~/x# tcpdump -i foo
> [... nothing/filtered ...]
>

Something like this seems more trivial to me:

table netdev mytable {
    chain mychain {
        type filter hook egress device "eth0" priority 100; policy drop;
        meta protocol != 0x419C accept
    }
}

Cheers.
