Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6324DE757
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 10:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242637AbiCSJw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 05:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbiCSJw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 05:52:57 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAB92BA3C7
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 02:51:36 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id u17-20020a6be311000000b00648f92b7b8cso6715749ioc.23
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 02:51:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=jhZ9LHXLcGgNvRmAI0911k++ThQT7lxCqrZCQddaBZY=;
        b=3U05Qx5S1lCuLiYXKUUuJZpq2Oz4ZVWaZHllcpcV6afwGR+rjFuPiLepJqa9tU1e5n
         AH/CQ/JyAPdw7prpEND3vNoKKBA0+IaHK+7SDgOlU5Qe0Y+egV5eitCurNTdwiRKvQMW
         mW1cDx9ZBPdIkfj1jW3uTIPi/KMvRntOKVXTMqxOC1yETNFmF6yz0IMc6ZjsJPcuRCoE
         0RfWVZQwjuCtSxDhZep4O/XGWNq+8zRLKmqwBgtPOj2tcnm1LD0oXyxEw2cMWi9NVIAz
         Q+DBnD+Ak9Y3CCrRlx6DHDA5O8gYSTjmlVvS6301c8YdYbriXpABgvwGfWJjQ8yZlgky
         grsA==
X-Gm-Message-State: AOAM532mpQCug9sM+WsJC8HPNLPfcSFGaPZ5hnZ8KUxDcaVWlHdD5kdq
        yJEKY9NzM5ZuI9eXkx6OXtmq6/2UiMpUavZU/+csBSiwxHhK
X-Google-Smtp-Source: ABdhPJyaDVo0K+O/GWqYBRU07/OPALXzlx64ZzzabnjvFrobjoQsxOlqdJCi6PQBORUrTzMFqxkWYKS2OuTAz8Qjr72m14pxrGjA
MIME-Version: 1.0
X-Received: by 2002:a92:7d0a:0:b0:2c6:4310:8390 with SMTP id
 y10-20020a927d0a000000b002c643108390mr6341320ilc.93.1647683495657; Sat, 19
 Mar 2022 02:51:35 -0700 (PDT)
Date:   Sat, 19 Mar 2022 02:51:35 -0700
In-Reply-To: <20220319095121.2517-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000760a6205da8f35e5@google.com>
Subject: Re: [syzbot] net-next test error: WARNING in __napi_schedule
From:   syzbot <syzbot+fb57d2a7c4678481a495@syzkaller.appspotmail.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     bigeasy@linutronix.de, hdanton@sina.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, 18 Mar 2022 16:36:19 -0700
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    e89600ebeeb1 af_vsock: SOCK_SEQPACKET broken buffer test
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=134d43d5700000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ef691629edb94d6a
>> dashboard link: https://syzkaller.appspot.com/bug?extid=fb57d2a7c4678481a495
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+fb57d2a7c4678481a495@syzkaller.appspotmail.com
>> 
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 1133 at net/core/dev.c:4268 ____napi_schedule net/core/dev.c:4268 [inline]
>> WARNING: CPU: 0 PID: 1133 at net/core/dev.c:4268 __napi_schedule+0xe2/0x440 net/core/dev.c:5878
>> Modules linked in:
>> CPU: 0 PID: 1133 Comm: kworker/0:3 Not tainted 5.17.0-rc8-syzkaller-02525-ge89600ebeeb1 #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Workqueue: wg-crypt-wg0 wg_packet_decrypt_worker
>> RIP: 0010:____napi_schedule net/core/dev.c:4268 [inline]
>> RIP: 0010:__napi_schedule+0xe2/0x440 net/core/dev.c:5878
>> Code: 74 4a e8 31 16 47 fa 31 ff 65 44 8b 25 47 c5 d0 78 41 81 e4 00 ff 0f 00 44 89 e6 e8 98 19 47 fa 45 85 e4 75 07 e8 0e 16 47 fa <0f> 0b e8 07 16 47 fa 65 44 8b 25 5f cf d0 78 31 ff 44 89 e6 e8 75
>> RSP: 0018:ffffc900057d7c88 EFLAGS: 00010093
>> RAX: 0000000000000000 RBX: ffff88801e680748 RCX: 0000000000000000
>> RDX: ffff88801ccb0000 RSI: ffffffff8731aa92 RDI: 0000000000000003
>> RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000001
>> R10: ffffffff8731aa88 R11: 0000000000000000 R12: 0000000000000000
>> R13: ffff8880b9c00000 R14: 000000000003adc0 R15: ffff88801e118ec0
>> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007fdaa5c65300 CR3: 0000000070af4000 CR4: 00000000003506f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  <TASK>
>>  napi_schedule include/linux/netdevice.h:465 [inline]
>>  wg_queue_enqueue_per_peer_rx drivers/net/wireguard/queueing.h:204 [inline]
>>  wg_packet_decrypt_worker+0x408/0x5d0 drivers/net/wireguard/receive.c:510
>>  process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
>>  worker_thread+0x657/0x1110 kernel/workqueue.c:2454
>>  kthread+0x2e9/0x3a0 kernel/kthread.c:377
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>>  </TASK>
>
> See if what was added in fbd9a2ceba5c ("net: Add lockdep asserts to ____napi_schedule().")
> makes sense given irq disabled.
>
> Hillf
>
> #syz test: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/  e89600ebeeb1

This crash does not have a reproducer. I cannot test it.

>
> --- x/net/core/dev.c
> +++ y/net/core/dev.c
> @@ -4265,8 +4265,8 @@ static inline void ____napi_schedule(str
>  {
>  	struct task_struct *thread;
>  
> -	lockdep_assert_softirq_will_run();
>  	lockdep_assert_irqs_disabled();
> +	lockdep_assert_softirq_will_run();
>  
>  	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
>  		/* Paired with smp_mb__before_atomic() in
> --
