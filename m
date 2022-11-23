Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D911263656B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238815AbiKWQJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238816AbiKWQJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:09:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70936C4C0F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 08:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669219720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mo9Cu02IrQqnqkR8eRuBSSZhf6FA5DQgEMy2KAnXWBA=;
        b=AV8Bonsu2txNrFl3MN9lTD5vCdQSr+ly5DFgikVl2AqewCh9F0zUTZu+jV23uupYwzvnwj
        szjWPyrU06UCDtSDQPWZy9UPLz5s8VYGsbNLzbREOdPXLPjZODiwYLarFopZNZIBQUtElm
        feXiJ9jxb6DdokLt911xhX2gtLr7g4M=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-365-b-W3fVINMrurejh7MosUjg-1; Wed, 23 Nov 2022 11:08:39 -0500
X-MC-Unique: b-W3fVINMrurejh7MosUjg-1
Received: by mail-pf1-f199.google.com with SMTP id v16-20020a62a510000000b005745a58c197so1123591pfm.23
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 08:08:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mo9Cu02IrQqnqkR8eRuBSSZhf6FA5DQgEMy2KAnXWBA=;
        b=4AK4u7TXpvhP1S/0Q/huGcH+KDn3BW/wIW4pjcnm7o2areZqLXo8ri1Ia/Wp1pkbpb
         E963kfbkpslylAYfWSivfe7salqSP1kgqc1WVamQVo6XAxBOnmLJiZhEokNZlJOwBxvO
         UWuBO0+Z62tsEL+pRd8KAakbD4/E5sfpg+3Mqti7WJarB04H4jxCxW+3Jf0zltvSWken
         +qIsy8tqgRaPK2I4YzQOLLdyuk69QNTyUHEnW2ZjID4gjd2sxyzoskve3/JUyYKCbTih
         10nK1OKoIstkf6Z0PnykdgGsfUMUOBiL48xcVTU/Q3B/ZtEa/P9wyg5qZjJ2WFfr48AQ
         jnxQ==
X-Gm-Message-State: ANoB5pmAhaKSi5Mtfhvq5zATHFu/EQ1ubWhZ0Qsr+onNMxW4BvifBEZn
        VDUQbi+PKvBXv5adPbWNke8Fgmzdm143opBMPcRwF7Dzeei0mRUveHnPYeUzByUgG3DNtTYFf1r
        NRuGoTXcl4hNWGcsv
X-Received: by 2002:a17:902:cf4b:b0:186:7a1d:b6ee with SMTP id e11-20020a170902cf4b00b001867a1db6eemr14339715plg.67.1669219716699;
        Wed, 23 Nov 2022 08:08:36 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6B1IjustAmXf1Mi4oCGfNiJDTbaeAzSvE594fNxzIXzV56SldvQdCxHnUGbv3jQagXoCnXtg==
X-Received: by 2002:a17:902:cf4b:b0:186:7a1d:b6ee with SMTP id e11-20020a170902cf4b00b001867a1db6eemr14339673plg.67.1669219716324;
        Wed, 23 Nov 2022 08:08:36 -0800 (PST)
Received: from localhost ([240d:1a:c0d:9f00:4f2f:926a:23dd:8588])
        by smtp.gmail.com with ESMTPSA id n5-20020a170902e54500b001893e8ffa34sm2237343plf.97.2022.11.23.08.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 08:08:35 -0800 (PST)
Date:   Thu, 24 Nov 2022 01:08:31 +0900 (JST)
Message-Id: <20221124.010831.156785940884442572.syoshida@redhat.com>
To:     jasowang@redhat.com
Cc:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+106f9b687cd64ee70cd1@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] net: tun: Fix use-after-free in tun_detach()
From:   Shigeru Yoshida <syoshida@redhat.com>
In-Reply-To: <88643033-45e1-3078-cb41-d7255ef874ad@redhat.com>
References: <20221123.031005.476714651315933198.syoshida@redhat.com>
        <CANn89iKQVvaHN+QXxmvk+Cm2vauHNcPRyh3ee_F=JH8coUQnnA@mail.gmail.com>
        <88643033-45e1-3078-cb41-d7255ef874ad@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 28.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

On Wed, 23 Nov 2022 12:20:47 +0800, Jason Wang wrote:
> 
> 在 2022/11/23 02:47, Eric Dumazet 写道:
>> On Tue, Nov 22, 2022 at 10:10 AM Shigeru Yoshida <syoshida@redhat.com>
>> wrote:
>>> Hi Eric,
>>>
>>> On Mon, 21 Nov 2022 08:47:17 -0800, Eric Dumazet wrote:
>>>> On Sun, Nov 20, 2022 at 1:02 AM Shigeru Yoshida <syoshida@redhat.com>
>>>> wrote:
>>>>> syzbot reported use-after-free in tun_detach() [1].  This causes call
>>>>> trace like below:
>>>>>
>>>>> ==================================================================
>>>>> BUG: KASAN: use-after-free in notifier_call_chain+0x1ee/0x200
>>>>> kernel/notifier.c:75
>>>>> Read of size 8 at addr ffff88807324e2a8 by task syz-executor.0/3673
>>>>>
>>>>> CPU: 0 PID: 3673 Comm: syz-executor.0 Not tainted
>>>>> 6.1.0-rc5-syzkaller-00044-gcc675d22e422 #0
>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine,
>>>>> BIOS Google 10/26/2022
>>>>> Call Trace:
>>>>>   <TASK>
>>>>>   __dump_stack lib/dump_stack.c:88 [inline]
>>>>>   dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>>>>>   print_address_description mm/kasan/report.c:284 [inline]
>>>>>   print_report+0x15e/0x461 mm/kasan/report.c:395
>>>>>   kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
>>>>>   notifier_call_chain+0x1ee/0x200 kernel/notifier.c:75
>>>>>   call_netdevice_notifiers_info+0x86/0x130 net/core/dev.c:1942
>>>>>   call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
>>>>>   call_netdevice_notifiers net/core/dev.c:1997 [inline]
>>>>>   netdev_wait_allrefs_any net/core/dev.c:10237 [inline]
>>>>>   netdev_run_todo+0xbc6/0x1100 net/core/dev.c:10351
>>>>>   tun_detach drivers/net/tun.c:704 [inline]
>>>>>   tun_chr_close+0xe4/0x190 drivers/net/tun.c:3467
>>>>>   __fput+0x27c/0xa90 fs/file_table.c:320
>>>>>   task_work_run+0x16f/0x270 kernel/task_work.c:179
>>>>>   exit_task_work include/linux/task_work.h:38 [inline]
>>>>>   do_exit+0xb3d/0x2a30 kernel/exit.c:820
>>>>>   do_group_exit+0xd4/0x2a0 kernel/exit.c:950
>>>>>   get_signal+0x21b1/0x2440 kernel/signal.c:2858
>>>>>   arch_do_signal_or_restart+0x86/0x2300 arch/x86/kernel/signal.c:869
>>>>>   exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
>>>>>   exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
>>>>>   __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
>>>>>   syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
>>>>>   do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>>>>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>>
>>>>> The cause of the issue is that sock_put() from __tun_detach() drops
>>>>> last reference count for struct net, and then notifier_call_chain()
>>>>> from netdev_state_change() accesses that struct net.
>>>>>
>>>>> This patch fixes the issue by calling sock_put() from tun_detach()
>>>>> after all necessary accesses for the struct net has done.
>>>>>
>>>>> Fixes: 83c1f36f9880 ("tun: send netlink notification when the device
>>>>> is modified")
>>>>> Reported-by: syzbot+106f9b687cd64ee70cd1@syzkaller.appspotmail.com
>>>>> Link:
>>>>> https://syzkaller.appspot.com/bug?id=96eb7f1ce75ef933697f24eeab928c4a716edefe
>>>>> [1]
>>>>> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
>>>>> ---
>>>>> v2:
>>>>> - Include symbolic stack trace
>>>>> - Add Fixes and Reported-by tags
>>>>> v1:
>>>>> https://lore.kernel.org/all/20221119075615.723290-1-syoshida@redhat.com/
>>>>> ---
>>>>>   drivers/net/tun.c | 6 +++++-
>>>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>> index 7a3ab3427369..ce9fcf4c8ef4 100644
>>>>> --- a/drivers/net/tun.c
>>>>> +++ b/drivers/net/tun.c
>>>>> @@ -686,7 +686,6 @@ static void __tun_detach(struct tun_file *tfile,
>>>>> bool clean)
>>>>>                  if (tun)
>>>>>                          xdp_rxq_info_unreg(&tfile->xdp_rxq);
>>>>>                  ptr_ring_cleanup(&tfile->tx_ring, tun_ptr_free);
>>>>> -               sock_put(&tfile->sk);
>>>>>          }
>>>>>   }
>>>>>
>>>>> @@ -702,6 +701,11 @@ static void tun_detach(struct tun_file *tfile,
>>>>> bool clean)
>>>>>          if (dev)
>>>>>                  netdev_state_change(dev);
>>>>>          rtnl_unlock();
>>>>> +
>>>>> +       if (clean) {
>>>> Would you mind explaining (a comment would be nice) why this barrier
>>>> is needed ?
>>> I thought that tfile is accessed with rcu_lock(), so I put
>>> synchronize_rcu() here.  Please let me know if I misunderstand the
>>> concept of rcu (I'm losing my confidence...).
>>>
>> Addin Jason for comments.
>>
>> If an RCU grace period was needed before commit 83c1f36f9880 ("tun:
>> send netlink notification when the device is modified"),
>> would we need another patch ?
> 
> 
> I think we don't need another synchronization here. __tun_detach() has
> already done the necessary synchronization when it tries to modify
> tun->tfiles array and tfile->tun.

Thank you so much for your comment.  I'll prepare v3 patch to remove
calling synchronize_rcu().

Thanks,
Shigeru

> Thanks
> 
> 
>>
>> Also sock_flag(sk, SOCK_RCU_FREE) would probably be better than adding
>> a synchronize_rcu() (if again a grace period is needed)
>>
>>
>>
>>> Thanks,
>>> Shigeru
>>>
>>>> Thanks.
>>>>
>>>>> +               synchronize_rcu();
>>>>> +               sock_put(&tfile->sk);
>>>>> +       }
>>>>>   }
>>>>>
>>>>>   static void tun_detach_all(struct net_device *dev)
>>>>> --
>>>>> 2.38.1
>>>>>
> 

