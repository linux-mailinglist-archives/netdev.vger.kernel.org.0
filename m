Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AEB307A3A
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhA1QC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbhA1QC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:02:26 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D22DC061573;
        Thu, 28 Jan 2021 08:01:45 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id 7so5951053wrz.0;
        Thu, 28 Jan 2021 08:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d9IlkAMk8Th9ISjpUc1brh9UDt65jJ31UqzcU91W4Ac=;
        b=lwqyAIUayqSNsqRmra08DYvroRPZqx+2h17NEMo2XjUxwjzTqnGT1dJJoEKlpWhDb3
         L/JajqZ/CqUrEyueO65pheGoEuvZPEzWj7XT4VRprutZdKvyTShjcsemmlsyeOWXYL8C
         WRyEs3GI+2vyxbhRa0cVQ+zE/MjKJC8yhcU+mLC64p0lgnBwzANN085QT4XpPJh5BSVu
         GTS2Xh43d25RO4BTYW4ZGkxDHbLHxba+A11a0hSwoA8kkFULnN839pbu+z9ZzQ4nKVYI
         JOBsQrHYia+HfQKjrBO0p+r59LbYjCYTtoCcNqTaroLER0hiX7UYilN1MnaDigyIOq68
         0UiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d9IlkAMk8Th9ISjpUc1brh9UDt65jJ31UqzcU91W4Ac=;
        b=mRu/uQd/NNARAf523j63l2pQn8hCZY+/7hGDxiN3rlsFBF++8FCc9p/zi99Mwtvowd
         i63vvzmSNE4LWJhJeZo1JB5KuhOAhS0vm2m9I8WfpelfLhktNyTng3u5QJwSem3KvRdx
         6SruUcubi71XGo47Z5JPeoYdMrbYBrMssERQP5YCqumOV9Hs/jB7Rg7GrtAZx1hRm/xK
         GRc5BAp/nsl0kU2GB3IQTRh1+ky4dRL3pC7YGe2YU1YjaU3W0ilp9DlmMo8M1RvVD61V
         RI+JTgDt6JkLTsxQeYs8dtXhJL7pT3x+1pn6hCdBUx0zZct9hySw1IPI8B+4sS2GPArH
         NlcA==
X-Gm-Message-State: AOAM531Oss1AGgNhnx2bqtu4uWAsDFK65gDolRuDQ7AENLwdBbSN+uuC
        EZOOPxOxs72WS6+oNIlbRPJyT8VoPIw=
X-Google-Smtp-Source: ABdhPJxFsAR7smS2WSSjDYw/TSctnMXqDlL4WnZAqiSabG3s8RhV0kO3gkKfXHW+M8rkDvM2xvMYNw==
X-Received: by 2002:a5d:55c3:: with SMTP id i3mr16740986wrw.190.1611849704031;
        Thu, 28 Jan 2021 08:01:44 -0800 (PST)
Received: from [192.168.1.37] (lfbn-ann-1-346-224.w86-200.abo.wanadoo.fr. [86.200.64.224])
        by smtp.gmail.com with ESMTPSA id i8sm7811065wry.90.2021.01.28.08.01.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 08:01:42 -0800 (PST)
Subject: Re: [PATCH] netdevsim: init u64 stats for 32bit hardware
To:     Dmitry Vyukov <dvyukov@google.com>, Hillf Danton <hdanton@sina.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot <syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20210128024316.1425-1-hdanton@sina.com>
 <CACT4Y+Z8NwmvuqynuFO8XFk4sdeTLi9Bn5RWt3xWU_Vb+z+hAA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2cfd53f0-2a38-4550-a354-a8967736298a@gmail.com>
Date:   Thu, 28 Jan 2021 17:01:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CACT4Y+Z8NwmvuqynuFO8XFk4sdeTLi9Bn5RWt3xWU_Vb+z+hAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/28/21 8:23 AM, Dmitry Vyukov wrote:
> On Thu, Jan 28, 2021 at 3:43 AM Hillf Danton <hdanton@sina.com> wrote:
>>
>> Init the u64 stats in order to avoid the lockdep prints on the 32bit
>> hardware like
> 
> FTR this is not just to avoid lockdep prints, but also to prevent very
> real stalls in production.

Are you sure ?

> u64_stats_init initializes seqlock, if the uninitialized
> selock->sequence would be odd, the kernel will stall.

Normally the whole netdev structure is zeroed when allocated,
this is done in alloc_netdev_mqs()

p = kvzalloc(alloc_size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);

So unless kvzalloc() has been changed recently to inject random data
instead of 0, this bug is really about lockdep only.

> 
> Maintainers, please send this upstream on your earliest convenience,
> this breaks all 32-bit arches for testing purposes.
> 
> Thanks
> 
>>  INFO: trying to register non-static key.
>>  the code is fine but needs lockdep annotation.
>>  turning off the locking correctness validator.
>>  CPU: 0 PID: 4695 Comm: syz-executor.0 Not tainted 5.11.0-rc5-syzkaller #0
>>  Hardware name: ARM-Versatile Express
>>  Backtrace:
>>  [<826fc5b8>] (dump_backtrace) from [<826fc82c>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:252)
>>  [<826fc814>] (show_stack) from [<8270d1f8>] (__dump_stack lib/dump_stack.c:79 [inline])
>>  [<826fc814>] (show_stack) from [<8270d1f8>] (dump_stack+0xa8/0xc8 lib/dump_stack.c:120)
>>  [<8270d150>] (dump_stack) from [<802bf9c0>] (assign_lock_key kernel/locking/lockdep.c:935 [inline])
>>  [<8270d150>] (dump_stack) from [<802bf9c0>] (register_lock_class+0xabc/0xb68 kernel/locking/lockdep.c:1247)
>>  [<802bef04>] (register_lock_class) from [<802baa2c>] (__lock_acquire+0x84/0x32d4 kernel/locking/lockdep.c:4711)
>>  [<802ba9a8>] (__lock_acquire) from [<802be840>] (lock_acquire.part.0+0xf0/0x554 kernel/locking/lockdep.c:5442)
>>  [<802be750>] (lock_acquire.part.0) from [<802bed10>] (lock_acquire+0x6c/0x74 kernel/locking/lockdep.c:5415)
>>  [<802beca4>] (lock_acquire) from [<81560548>] (seqcount_lockdep_reader_access include/linux/seqlock.h:103 [inline])
>>  [<802beca4>] (lock_acquire) from [<81560548>] (__u64_stats_fetch_begin include/linux/u64_stats_sync.h:164 [inline])
>>  [<802beca4>] (lock_acquire) from [<81560548>] (u64_stats_fetch_begin include/linux/u64_stats_sync.h:175 [inline])
>>  [<802beca4>] (lock_acquire) from [<81560548>] (nsim_get_stats64+0xdc/0xf0 drivers/net/netdevsim/netdev.c:70)
>>  [<8156046c>] (nsim_get_stats64) from [<81e2efa0>] (dev_get_stats+0x44/0xd0 net/core/dev.c:10405)
>>  [<81e2ef5c>] (dev_get_stats) from [<81e53204>] (rtnl_fill_stats+0x38/0x120 net/core/rtnetlink.c:1211)
>>  [<81e531cc>] (rtnl_fill_stats) from [<81e59d58>] (rtnl_fill_ifinfo+0x6d4/0x148c net/core/rtnetlink.c:1783)
>>  [<81e59684>] (rtnl_fill_ifinfo) from [<81e5ceb4>] (rtmsg_ifinfo_build_skb+0x9c/0x108 net/core/rtnetlink.c:3798)
>>  [<81e5ce18>] (rtmsg_ifinfo_build_skb) from [<81e5d0ac>] (rtmsg_ifinfo_event net/core/rtnetlink.c:3830 [inline])
>>  [<81e5ce18>] (rtmsg_ifinfo_build_skb) from [<81e5d0ac>] (rtmsg_ifinfo_event net/core/rtnetlink.c:3821 [inline])
>>  [<81e5ce18>] (rtmsg_ifinfo_build_skb) from [<81e5d0ac>] (rtmsg_ifinfo+0x44/0x70 net/core/rtnetlink.c:3839)
>>  [<81e5d068>] (rtmsg_ifinfo) from [<81e45c2c>] (register_netdevice+0x664/0x68c net/core/dev.c:10103)
>>  [<81e455c8>] (register_netdevice) from [<815608bc>] (nsim_create+0xf8/0x124 drivers/net/netdevsim/netdev.c:317)
>>  [<815607c4>] (nsim_create) from [<81561184>] (__nsim_dev_port_add+0x108/0x188 drivers/net/netdevsim/dev.c:941)
>>  [<8156107c>] (__nsim_dev_port_add) from [<815620d8>] (nsim_dev_port_add_all drivers/net/netdevsim/dev.c:990 [inline])
>>  [<8156107c>] (__nsim_dev_port_add) from [<815620d8>] (nsim_dev_probe+0x5cc/0x750 drivers/net/netdevsim/dev.c:1119)
>>  [<81561b0c>] (nsim_dev_probe) from [<815661dc>] (nsim_bus_probe+0x10/0x14 drivers/net/netdevsim/bus.c:287)
>>  [<815661cc>] (nsim_bus_probe) from [<811724c0>] (really_probe+0x100/0x50c drivers/base/dd.c:554)
>>  [<811723c0>] (really_probe) from [<811729c4>] (driver_probe_device+0xf8/0x1c8 drivers/base/dd.c:740)
>>  [<811728cc>] (driver_probe_device) from [<81172fe4>] (__device_attach_driver+0x8c/0xf0 drivers/base/dd.c:846)
>>  [<81172f58>] (__device_attach_driver) from [<8116fee0>] (bus_for_each_drv+0x88/0xd8 drivers/base/bus.c:431)
>>  [<8116fe58>] (bus_for_each_drv) from [<81172c6c>] (__device_attach+0xdc/0x1d0 drivers/base/dd.c:914)
>>  [<81172b90>] (__device_attach) from [<8117305c>] (device_initial_probe+0x14/0x18 drivers/base/dd.c:961)
>>  [<81173048>] (device_initial_probe) from [<81171358>] (bus_probe_device+0x90/0x98 drivers/base/bus.c:491)
>>  [<811712c8>] (bus_probe_device) from [<8116e77c>] (device_add+0x320/0x824 drivers/base/core.c:3109)
>>  [<8116e45c>] (device_add) from [<8116ec9c>] (device_register+0x1c/0x20 drivers/base/core.c:3182)
>>  [<8116ec80>] (device_register) from [<81566710>] (nsim_bus_dev_new drivers/net/netdevsim/bus.c:336 [inline])
>>  [<8116ec80>] (device_register) from [<81566710>] (new_device_store+0x178/0x208 drivers/net/netdevsim/bus.c:215)
>>  [<81566598>] (new_device_store) from [<8116fcb4>] (bus_attr_store+0x2c/0x38 drivers/base/bus.c:122)
>>  [<8116fc88>] (bus_attr_store) from [<805b4b8c>] (sysfs_kf_write+0x48/0x54 fs/sysfs/file.c:139)
>>  [<805b4b44>] (sysfs_kf_write) from [<805b3c90>] (kernfs_fop_write_iter+0x128/0x1ec fs/kernfs/file.c:296)
>>  [<805b3b68>] (kernfs_fop_write_iter) from [<804d22fc>] (call_write_iter include/linux/fs.h:1901 [inline])
>>  [<805b3b68>] (kernfs_fop_write_iter) from [<804d22fc>] (new_sync_write fs/read_write.c:518 [inline])
>>  [<805b3b68>] (kernfs_fop_write_iter) from [<804d22fc>] (vfs_write+0x3dc/0x57c fs/read_write.c:605)
>>  [<804d1f20>] (vfs_write) from [<804d2604>] (ksys_write+0x68/0xec fs/read_write.c:658)
>>  [<804d259c>] (ksys_write) from [<804d2698>] (__do_sys_write fs/read_write.c:670 [inline])
>>  [<804d259c>] (ksys_write) from [<804d2698>] (sys_write+0x10/0x14 fs/read_write.c:667)
>>  [<804d2688>] (sys_write) from [<80200060>] (ret_fast_syscall+0x0/0x2c arch/arm/mm/proc-v7.S:64)
>>
>> Fixes: 83c9e13aa39a ("netdevsim: add software driver for testing offloads")
>> Reported-by: syzbot+e74a6857f2d0efe3ad81@syzkaller.appspotmail.com
>> Tested-by: Dmitry Vyukov <dvyukov@google.com>
>> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Cc: Simon Horman <simon.horman@netronome.com>
>> Cc: Quentin Monnet <quentin.monnet@netronome.com>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Signed-off-by: Hillf Danton <hdanton@sina.com>
>> ---
>>
>> --- a/drivers/net/netdevsim/netdev.c
>> +++ b/drivers/net/netdevsim/netdev.c
>> @@ -296,6 +296,7 @@ nsim_create(struct nsim_dev *nsim_dev, s
>>         dev_net_set(dev, nsim_dev_net(nsim_dev));
>>         ns = netdev_priv(dev);
>>         ns->netdev = dev;
>> +       u64_stats_init(&ns->syncp);
>>         ns->nsim_dev = nsim_dev;
>>         ns->nsim_dev_port = nsim_dev_port;
>>         ns->nsim_bus_dev = nsim_dev->nsim_bus_dev;
>> --
>>
>> --
>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20210128024316.1425-1-hdanton%40sina.com.
