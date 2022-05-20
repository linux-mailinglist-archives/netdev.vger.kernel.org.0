Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B99B52F07A
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351568AbiETQWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351561AbiETQW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:22:27 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75016880E5
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:22:25 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id i82-20020a1c3b55000000b00397391910d5so1109916wma.1
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bjaDfTjNjVz/SbOEUnF6116tTFdw40JCACUWy4Rzd00=;
        b=CUimscD556QNqMqV+xYba0rAb4oAPMOkHHNz4TO/YMXfpIhax9wHrnHTHQZZ/LPsw1
         AJEd9m6BlqPgC3oP3sgzDYBr+BdwLeBPYBWX5OBiOc3HA2KGXK9MhBiC9h0lnQHTkwXN
         6F+bomH6KGvgdvoB3mzrO1Usq/2hSh08TnBv3K4XtM9mKd1pah9ldWXDpc00Ht9mBtfj
         EsTKBMwRHHah2adPkBATBaquEQ+VAUFrC0XjT8R8Ix+drV3dwJGTVrNJEEMhnWFhPR/G
         h78Sv4jvL2Wm8fn/i+Yqt4FiRIgnKi0FtM0TzFoNKVWvEizgyH70nObYsg9vhsS9EEyu
         cuXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bjaDfTjNjVz/SbOEUnF6116tTFdw40JCACUWy4Rzd00=;
        b=AFTFOEl7qimZ+S/g3PeXE4Dw/agENd5w6YYtR5bqNOKGdWcVAt306lf3it+2XW253j
         +rpfHDF9ZjwMyB7yf3FqEQdzwrTI/CKpbnJ+Sg2RDstW1b5sHaipznEncz9blYWcXydH
         cfZB0xd9ZSD9mCmj2seDP9ZaKFHOvndTklQDWXSur7fVMahWXHeM5FtJq8TdQWN6wexF
         UlnLQ+cE1k1ViIAh63T8VI4HmzWGpMNr8Xw/UrRdrml+DEDWZeyTVavr4hGkTHMxIQvG
         m4lhny2a1g1KwkDnYkPp9sYv5n1Sj2hxyQxKHN1kfAWf8PMDHYzM9kuoTO9U8hBuo/nf
         etHg==
X-Gm-Message-State: AOAM533XyXzZOrZjL3YLS/5aTwqU3fewQ1zsgj1w9ispQS8nmk0mRh3v
        x9OInojCbaAPv2SQbfOZqPn8SA==
X-Google-Smtp-Source: ABdhPJwyrjRrl1pRJOXcD/ZxX/b6aNoppYHNwBmANoOFCHdxW309zTNVlzgBpydLHJTXIeVAaGKCyg==
X-Received: by 2002:a05:600c:1151:b0:394:6816:d4f2 with SMTP id z17-20020a05600c115100b003946816d4f2mr9499857wmz.195.1653063743840;
        Fri, 20 May 2022 09:22:23 -0700 (PDT)
Received: from [10.44.2.26] (84-199-106-91.ifiber.telenet-ops.be. [84.199.106.91])
        by smtp.gmail.com with ESMTPSA id e30-20020adfa45e000000b0020c5253d8e6sm2817547wra.50.2022.05.20.09.22.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 09:22:23 -0700 (PDT)
Message-ID: <4deccb83-79c4-5276-3183-d6e6ffa3ec53@tessares.net>
Date:   Fri, 20 May 2022 18:22:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next] tcp_ipv6: set the drop_reason in the right place
Content-Language: en-GB
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        flyingpeng@tencent.com, imagedong@tencent.com,
        benbjiang@tencent.com
References: <20220520021347.2270207-1-kuba@kernel.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20220520021347.2270207-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 20/05/2022 04:13, Jakub Kicinski wrote:
> Looks like the IPv6 version of the patch under Fixes was
> a copy/paste of the IPv4 but hit the wrong spot.
> It is tcp_v6_rcv() which uses drop_reason as a boolean, and
> needs to be protected against reason == 0 before calling free.
> tcp_v6_do_rcv() has a pretty straightforward flow.

Thank you for the patch!

It looks like this fixes an issue our MPTCP CI detected recently:

https://github.com/multipath-tcp/mptcp_net-next/issues/277


Just in case someone else had this issue on their side, here is the call
trace we had:


[ 1256.803388] WARNING: CPU: 1 PID: 0 at net/core/skbuff.c:775
kfree_skb_reason (net/core/skbuff.c:775 (discriminator 1))
[ 1256.804398] Modules linked in: nft_tproxy nf_tproxy_ipv6
nf_tproxy_ipv4 nft_socket nf_socket_ipv4 nf_socket_ipv6 nf_tables sch_netem
[ 1256.805815] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.18.0-rc6 #201
[ 1256.806590] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.13.0-1ubuntu1.1 04/01/2014
[ 1256.807680] RIP: 0010:kfree_skb_reason (net/core/skbuff.c:775
(discriminator 1))
[ 1256.808245] Code: 99 77 75 b2 0f 1f 44 00 00 eb ab 48 8d bf dc 00 00
00 b8 ff ff ff ff f0 0f c1 85 dc 00 00 00 83 f8 01 74 83 85 c0 7e 06 5d
c3 <0f> 0b eb 81 be 03 00 00 00 5d e9 11 98 ac ff c3 0f 1f 44 00 00 48
[ 1256.810639] RSP: 0018:ffffa46c000c8d10 EFLAGS: 00010286
[ 1256.811382] RAX: 00000000ffffffff RBX: ffff9a6903226a00 RCX:
ffff9a6902f96c00
[ 1256.812262] RDX: 00000000000002c0 RSI: 0000000000000000 RDI:
ffff9a69054d36e8
[ 1256.812712] RBP: ffff9a69054d36e8 R08: ffff9a69032b2580 R09:
00000000851b0660
[ 1256.813153] R10: 0000000000000000 R11: ffff9a69032b2500 R12:
ffff9a69032b2500
[ 1256.813594] R13: ffff9a6902f96cec R14: ffff9a6902f96d14 R15:
0000000000000001
[ 1256.814082] FS:  0000000000000000(0000) GS:ffff9a697dd00000(0000)
knlGS:0000000000000000
[ 1256.814607] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1256.814975] CR2: 000056011bdca008 CR3: 0000000002a78000 CR4:
0000000000350ee0
[ 1256.815419] Call Trace:
[ 1256.815611]  <IRQ>
[ 1256.815761] tcp_v6_rcv (net/ipv6/tcp_ipv6.c:1767)
[ 1256.816014] ? ip6_route_input (include/linux/skbuff.h:1305)
[ 1256.816315] ip6_protocol_deliver_rcu (net/ipv6/ip6_input.c:438)
[ 1256.816646] ip6_input_finish (include/linux/rcupdate.h:726)
[ 1256.816921] ip6_input (include/linux/netfilter.h:307)
[ 1256.817153] ipv6_rcv (net/ipv6/ip6_input.c:309)
[ 1256.817379] ? internal_add_timer (kernel/time/timer.c:612)
[ 1256.817685] __netif_receive_skb_one_core (net/core/dev.c:5484)
[ 1256.818044] process_backlog (include/linux/rcupdate.h:726)
[ 1256.818317] __napi_poll (net/core/dev.c:6489)
[ 1256.818568] net_rx_action (net/core/dev.c:6558)
[ 1256.818828] __do_softirq (arch/x86/include/asm/jump_label.h:27)
[ 1256.819049] irq_exit_rcu (kernel/softirq.c:432)
[ 1256.819284] sysvec_apic_timer_interrupt
(arch/x86/kernel/apic/apic.c:1097 (discriminator 14))
[ 1256.819586]  </IRQ>
[ 1256.819721]  <TASK>
[ 1256.819855] asm_sysvec_apic_timer_interrupt
(arch/x86/include/asm/idtentry.h:645)


With your patch, I no longer hit the WARN locally even after ~50
executions of "mptcp_connect.sh -m mmap" test.

Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
