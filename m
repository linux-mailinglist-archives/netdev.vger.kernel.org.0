Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C455FBD29
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 23:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJKVqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 17:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiJKVqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 17:46:19 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9221C83078
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 14:46:16 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3321c2a8d4cso139891887b3.5
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 14:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GEulKj1nvbXZ7IVsn+EVhi4AIwqT69+jjpsn03kd5IY=;
        b=r/akqXUHOBpJVDopdfgX0yH8mUPO8OxzRVF+sjnkC2yri/Bk1mzjoXy9AjwBkvecJ/
         5Pt75yW4vzCj9lMG+cU8frap/YNl0+wwr56qzb0Bf5X5rVD+Kh67GvfgNlcqUTbSvU2H
         YUs10+BVyb+CSost7spt0d5uM5si1+2SZhaM08F0iY8Rg52/QJy0KKebL94bxnsHqFiR
         VPhxoF7WzWVBWAdJYWJJ88PDMTqGvP/3FpoflxDoWkI9lVfSiqZ+YuleISPXiB7croTP
         OAfuywoO/SvF3CZBesbOg8f3GQYmlkvt4gzhGPqcOlMR9XWnHBx+ujq6gihKHuhqBFfl
         K8Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GEulKj1nvbXZ7IVsn+EVhi4AIwqT69+jjpsn03kd5IY=;
        b=1+KnOD7/0g/qQ8+MhDxiCB7Hug1pyPPBLYz+VYHwkio/Obqdf7PZJX/AifclFcIm7N
         e1Hc4bqK8bp2ThoLSAh3S5q+j2wa+KLxpC0YSqrhhinYFP/CKnJG1Vwy1FgBPKjSL6fL
         xQs9RmY7Hct2N9cwC4f6HkpjLi5cfpYAWEWOgRo10fFOpCdC0DZ7r1MBHwi6DfXEvhXh
         Hd1dXUg0WN3S4HaUFV67v+FZz10RbM4w3jHeLhG/+y4OV6ULC5rMWO2bakOL0WwjzE0L
         ffXaMsp3XOnTjVEs1EPEumq5OucIkSSN/ZTMl7nl7De1QurIK25xOnVwcOtXB8NWGwV6
         yq1w==
X-Gm-Message-State: ACrzQf0wJyAYuGjqysRWrCdIyfXYh9QxlF7tShRL2xOxYkICGKNTg7xQ
        KjAD9WzsBbZkyWTewrpO4+ZtMUMf/FC4IlaMAF2l2Q==
X-Google-Smtp-Source: AMsMyM7G/c+mnlbxsc/J6zdbP58DXiKakRAksS2NWRu5HbdIQr/J+gDs9p0cN8yWY810Sj8qmp8r+qjLLIlfysyZ5y8=
X-Received: by 2002:a81:9202:0:b0:35e:face:a087 with SMTP id
 j2-20020a819202000000b0035efacea087mr24119129ywg.55.1665524775333; Tue, 11
 Oct 2022 14:46:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220908011022.45342-1-kuniyu@amazon.com> <166370042183.20640.3960141192085780845.git-patchwork-notify@kernel.org>
In-Reply-To: <166370042183.20640.3960141192085780845.git-patchwork-notify@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 11 Oct 2022 14:46:03 -0700
Message-ID: <CANn89iLXMup0dRD_Ov79Xt8N9FM0XdhCHEN05sf3eLwxKweM6w@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 0/6] tcp: Introduce optional per-netns ehash.
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, kuni1840@gmail.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 12:00 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This series was applied to netdev/net-next.git (master)
> by Jakub Kicinski <kuba@kernel.org>:
>
> On Wed, 7 Sep 2022 18:10:16 -0700 you wrote:
> > The more sockets we have in the hash table, the longer we spend looking
> > up the socket.  While running a number of small workloads on the same
> > host, they penalise each other and cause performance degradation.
> >
> > The root cause might be a single workload that consumes much more
> > resources than the others.  It often happens on a cloud service where
> > different workloads share the same computing resource.
> >
> > [...]
>
> Here is the summary with links:
>   - [v6,net-next,1/6] tcp: Clean up some functions.
>     https://git.kernel.org/netdev/net-next/c/08eaef904031
>   - [v6,net-next,2/6] tcp: Don't allocate tcp_death_row outside of struct netns_ipv4.
>     https://git.kernel.org/netdev/net-next/c/e9bd0cca09d1
>   - [v6,net-next,3/6] tcp: Set NULL to sk->sk_prot->h.hashinfo.
>     https://git.kernel.org/netdev/net-next/c/429e42c1c54e
>   - [v6,net-next,4/6] tcp: Access &tcp_hashinfo via net.
>     https://git.kernel.org/netdev/net-next/c/4461568aa4e5
>   - [v6,net-next,5/6] tcp: Save unnecessary inet_twsk_purge() calls.
>     https://git.kernel.org/netdev/net-next/c/edc12f032a5a
>   - [v6,net-next,6/6] tcp: Introduce optional per-netns ehash.
>     https://git.kernel.org/netdev/net-next/c/d1e5e6408b30
>
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
>
>

Note that this series is causing issues.

BUG: KASAN: use-after-free in tcp_or_dccp_get_hashinfo
include/net/inet_hashtables.h:181 [inline]
BUG: KASAN: use-after-free in reqsk_queue_unlink+0x320/0x350
net/ipv4/inet_connection_sock.c:913
Read of size 8 at addr ffff88807545bd80 by task syz-executor.2/8301

CPU: 1 PID: 8301 Comm: syz-executor.2 Not tainted
6.0.0-syzkaller-02757-gaf7d23f9d96a #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 09/22/2022
Call Trace:
<IRQ>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
print_address_description mm/kasan/report.c:317 [inline]
print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
tcp_or_dccp_get_hashinfo include/net/inet_hashtables.h:181 [inline]
reqsk_queue_unlink+0x320/0x350 net/ipv4/inet_connection_sock.c:913
inet_csk_reqsk_queue_drop net/ipv4/inet_connection_sock.c:927 [inline]
inet_csk_reqsk_queue_drop_and_put net/ipv4/inet_connection_sock.c:939 [inline]
reqsk_timer_handler+0x724/0x1160 net/ipv4/inet_connection_sock.c:1053
call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
expire_timers kernel/time/timer.c:1519 [inline]
__run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
__run_timers kernel/time/timer.c:1768 [inline]
run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
__do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
invoke_softirq kernel/softirq.c:445 [inline]
__irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1107
</IRQ>

We forgot to make sure there were no TCP_NEW_SYN_RECV sockets in the
hash tables before deleting the hash tables.

Probably inet_twsk_purge() (when called when
et->ipv4.tcp_death_row.hashinfo->pernet is true)
also needs to remove all TCP_NEW_SYN_RECV request sockets.
