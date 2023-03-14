Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364956BA074
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjCNULN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjCNULL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:11:11 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5426B168A0;
        Tue, 14 Mar 2023 13:11:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id DBCB8604F7;
        Tue, 14 Mar 2023 21:11:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1678824665; bh=5kcXTSkgYUUoUVIK1nOhMOEpYpLIqELNd1sc4GcGIb8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Uy5z9Pd9Nz6e9EC4hOcz1EBxaJHqkyFXQsqNW28LxXIOZoU6iS5//89VcrC9kfXO8
         5Qr2tOUbc0QZ/E+ba2MQD0r0YvJftdQQfhOhY+xZBBH8oC5tgWfnwGwoaQvF2CZgju
         wYbfYEeGKEAa+1E0+/C4eRjUjeqKi7JC2AViMI79y8cwiIOAQyxW0TqgXd6vARvJRD
         IWDsLPg6wz7wxLNorcrnwYSqCOiOdUiIHMsuNeVkdqrfYEjn0zs8IDwPImkk9fJm3Q
         Rvgl7DXqJCscGrxCgoYh7mWZRB5WkYtx8Jyhcb+Ij09BwIqvRg0vqf4OP0T05V1GS/
         WfVmcTHxknkew==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TeKHyCoNftv9; Tue, 14 Mar 2023 21:11:02 +0100 (CET)
Received: from [192.168.1.4] (unknown [77.237.109.125])
        by domac.alu.hr (Postfix) with ESMTPSA id 9BF0F604F3;
        Tue, 14 Mar 2023 21:11:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1678824662; bh=5kcXTSkgYUUoUVIK1nOhMOEpYpLIqELNd1sc4GcGIb8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cWDFELt/X0fIYp7BqlRDJtvTSy5w1LXiuDLQoox8bmZqYwWqmfkozc+jaJR1ePAMJ
         7Rpz7Jhzj01wMtR9h7+bSEXOnaDjXlCG+z7+kMxku0VqC1M1JYRHCSpH1k8XEqudgt
         XgV8/WQvW0tbhOdJjJ83cgw9QII10txxFhEYTjr065hzAl1fKQt1Pw2LV3Ygm2NJGd
         ouf4jsgI2Kvgn5iAFjgEIt1cxNbCJrW2ZTgLcfYJgwR+drAsqm9hP43SGLTueAKA4l
         tzL5/b/AP3HSh1DnFnrbR2LRzSpR2aQakHm6PS+/Xy7SB9KlLEs07ZuMWfv+Inw1CH
         fyzHtY9bk92vg==
Message-ID: <910f9616-fdcc-51bd-786d-8ecc9f4b5179@alu.unizg.hr>
Date:   Tue, 14 Mar 2023 21:10:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: BUG: selftest/net/tun: Hang in unregister_netdevice
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org
References: <a0734a6b-9491-b43a-6dff-4d3498faee2e@alu.unizg.hr>
 <d7a64812-73db-feb2-e6d6-e1d8c09a6fed@alu.unizg.hr>
 <27769d34-521c-f0ef-b6c2-6bd452e4f9bf@alu.unizg.hr>
 <CANn89iKi67YScgt5R0nHNAobjnSubBK6KsR9Ryoqu5ai4Opyrw@mail.gmail.com>
Content-Language: en-US, hr
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <CANn89iKi67YScgt5R0nHNAobjnSubBK6KsR9Ryoqu5ai4Opyrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14. 03. 2023. 17:02, Eric Dumazet wrote:
> On Tue, Mar 14, 2023 at 9:01 AM Mirsad Todorovac
> <mirsad.todorovac@alu.unizg.hr> wrote:
> 
>> After a while, kernel message start looping:
>>
>>   kernel:unregister_netdevice: waiting for tap0 to become free. Usage count = 3
>>
>> Message from syslogd@pc-mtodorov at Mar 14 16:57:15 ...
>>   kernel:unregister_netdevice: waiting for tap0 to become free. Usage count = 3
>>
>> Message from syslogd@pc-mtodorov at Mar 14 16:57:24 ...
>>   kernel:unregister_netdevice: waiting for tap0 to become free. Usage count = 3
>>
>> Message from syslogd@pc-mtodorov at Mar 14 16:57:26 ...
>>   kernel:unregister_netdevice: waiting for tap0 to become free. Usage count = 3
>>
>> This hangs processes until very late stage of shutdown.
>>
>> I can confirm that CONFIG_DEBUG_{KOBJECT,KOBJECT_RELEASE}=y were the only changes
>> to .config in between builds.
>>
>> Best regards,
>> Mirsad
>>
> 
> Try adding in your config
> 
> CONFIG_NET_DEV_REFCNT_TRACKER=y
> CONFIG_NET_NS_REFCNT_TRACKER=y
> 
> Thanks.

Not at all.

According to the info here: https://cateee.net/lkddb/web-lkddb/NET_DEV_REFCNT_TRACKER.html
no kerenel param was needed.

I have got the same hang, and additional debug information appears to be this
(in /var/log/messages):

Mar 14 20:58:20 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
Mar 14 20:58:20 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:20 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
Mar 14 20:58:20 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
Mar 14 20:58:20 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
Mar 14 20:58:20 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:20 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:20 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:20 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:20 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:20 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:20 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
Mar 14 20:58:20 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
Mar 14 20:58:20 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
Mar 14 20:58:20 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:20 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:20 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:20 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:20 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:20 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
Mar 14 20:58:20 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:20 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
Mar 14 20:58:20 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
Mar 14 20:58:20 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
Mar 14 20:58:20 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:20 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:20 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:20 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:20 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:20 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:20 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
Mar 14 20:58:20 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
Mar 14 20:58:20 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
Mar 14 20:58:20 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:20 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:20 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:20 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:20 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:30 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
Mar 14 20:58:30 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:30 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
Mar 14 20:58:30 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
Mar 14 20:58:30 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
Mar 14 20:58:30 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:30 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:30 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:30 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:30 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:30 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:30 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
Mar 14 20:58:30 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
Mar 14 20:58:30 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
Mar 14 20:58:30 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:30 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:30 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:30 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:30 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:30 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
Mar 14 20:58:30 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:30 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
Mar 14 20:58:30 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
Mar 14 20:58:30 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
Mar 14 20:58:30 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:30 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:30 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:30 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:30 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:30 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:30 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
Mar 14 20:58:30 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
Mar 14 20:58:30 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
Mar 14 20:58:30 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:30 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:30 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:30 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:30 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:40 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
Mar 14 20:58:40 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:40 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
Mar 14 20:58:40 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
Mar 14 20:58:40 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
Mar 14 20:58:40 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:40 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:40 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:40 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:40 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:40 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:40 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
Mar 14 20:58:40 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
Mar 14 20:58:40 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
Mar 14 20:58:40 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:40 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:40 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:40 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:40 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:40 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
Mar 14 20:58:40 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:40 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
Mar 14 20:58:40 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
Mar 14 20:58:40 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
Mar 14 20:58:40 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:40 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:40 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:40 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:40 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:40 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:40 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
Mar 14 20:58:40 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
Mar 14 20:58:40 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
Mar 14 20:58:40 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:40 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:40 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:40 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:40 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:50 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
Mar 14 20:58:50 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:50 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
Mar 14 20:58:50 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
Mar 14 20:58:50 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
Mar 14 20:58:50 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:50 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:50 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:50 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:50 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:50 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:50 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
Mar 14 20:58:50 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
Mar 14 20:58:50 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
Mar 14 20:58:50 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:50 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:50 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:50 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:50 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:50 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
Mar 14 20:58:50 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:50 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
Mar 14 20:58:50 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
Mar 14 20:58:50 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
Mar 14 20:58:50 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:50 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:50 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:50 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:50 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:50 pc-mtodorov kernel: leaked reference.
Mar 14 20:58:50 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
Mar 14 20:58:50 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
Mar 14 20:58:50 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
Mar 14 20:58:50 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:58:50 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:58:50 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:58:50 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:58:50 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:58:57 pc-mtodorov kernel: kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
Mar 14 20:59:00 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
Mar 14 20:59:00 pc-mtodorov kernel: leaked reference.
Mar 14 20:59:00 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
Mar 14 20:59:00 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
Mar 14 20:59:00 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
Mar 14 20:59:00 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:59:00 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:59:00 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:59:00 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:59:00 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:59:00 pc-mtodorov kernel: leaked reference.
Mar 14 20:59:00 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
Mar 14 20:59:00 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
Mar 14 20:59:00 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
Mar 14 20:59:00 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:59:00 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:59:00 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:59:00 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:59:00 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:59:01 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
Mar 14 20:59:01 pc-mtodorov kernel: leaked reference.
Mar 14 20:59:01 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
Mar 14 20:59:01 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
Mar 14 20:59:01 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
Mar 14 20:59:01 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:59:01 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:59:01 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:59:01 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:59:01 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:59:01 pc-mtodorov kernel: leaked reference.
Mar 14 20:59:01 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
Mar 14 20:59:01 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
Mar 14 20:59:01 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
Mar 14 20:59:01 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:59:01 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:59:01 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:59:01 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:59:01 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:59:10 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
Mar 14 20:59:10 pc-mtodorov kernel: leaked reference.
Mar 14 20:59:10 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
Mar 14 20:59:10 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
Mar 14 20:59:10 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
Mar 14 20:59:10 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:59:10 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:59:10 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:59:10 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:59:10 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:59:10 pc-mtodorov kernel: leaked reference.
Mar 14 20:59:10 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
Mar 14 20:59:10 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
Mar 14 20:59:10 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
Mar 14 20:59:10 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:59:10 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:59:10 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:59:10 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:59:10 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:59:11 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
Mar 14 20:59:11 pc-mtodorov kernel: leaked reference.
Mar 14 20:59:11 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
Mar 14 20:59:11 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
Mar 14 20:59:11 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
Mar 14 20:59:11 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:59:11 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:59:11 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:59:11 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:59:11 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
Mar 14 20:59:11 pc-mtodorov kernel: leaked reference.
Mar 14 20:59:11 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
Mar 14 20:59:11 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
Mar 14 20:59:11 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
Mar 14 20:59:11 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
Mar 14 20:59:11 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
Mar 14 20:59:11 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
Mar 14 20:59:11 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
Mar 14 20:59:11 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
[root@pc-mtodorov marvin]# 

I see those "leaked reference" lines are being printed here:
https://elixir.bootlin.com/linux/v6.3-rc2/source/lib/ref_tracker.c#L55

However, it is beyond the scope of my knowledge to track the actual leak.

Hope this helps.

Best regards,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

