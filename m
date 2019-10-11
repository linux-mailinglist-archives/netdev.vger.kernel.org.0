Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B32D43E6
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 17:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfJKPMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 11:12:22 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34790 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfJKPMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 11:12:22 -0400
Received: by mail-lj1-f194.google.com with SMTP id j19so10220788lja.1;
        Fri, 11 Oct 2019 08:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+1ypOR9fZA4lK0XmIF+p9uuR9SMEDVTW7L0xDQwfOfI=;
        b=jm+bx9/q/ioKZOdw2XGXOjjcH1GmMTp4LFxIbat9a+vh/MpLrqoGJTv/CI2EngbYxK
         sj/uEd3k5DSLnd3Km2fK9oICh410C29fiaBA4W4/zXRIWr1KpBKD9Ic7YYVta7yp3YBA
         86xIid8ulN3JjBBjRwT4ICWXCYlrVUmHFjI5is9YTasblknqR/IO+7tDgDmQztlNiEzi
         02pLHhZDzPpOCl2lg/KSt5hdV6DWpoqkDtdj4Ouz3aG+MN6CqH2f7EMU2/viDp1zu9iU
         LCan+qndJN4GxU72ZnCFDn+kocUAU1sG+NH59SEvgYEjCA/xDtrzUgNaTweVrVVHbim7
         j9FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+1ypOR9fZA4lK0XmIF+p9uuR9SMEDVTW7L0xDQwfOfI=;
        b=iv/9TKnkg6uGE/+1Vhe8gc0aMiD7UcGAlq3AAp5Y7iQWg7ARDQFz5HIW1oydGUnrF2
         BO/0YgtPcOD3nCobkRc0yW8i3MJW5LPa4aMq5T1jgp+PebMMeBOTWOa1xxYrVFUMwRX0
         dqcCIXmoPdNuo+WMJH//LJ+plQ52UjqenxwChHvODAdiaBn4zGOHjsekYy4yltZAXEmi
         iPYNL5l1zhVcLw+st32YKnixaYnTDuyBrXXUopS2F5Fhq41R515mK2emhEGOduka16dd
         4XCdYfG6jZG+2tqrVqpGnye1D4UTdrWjlb9nNVCaFjh7IFb4FrnEUNe0KniDhNlHPc1m
         XoQA==
X-Gm-Message-State: APjAAAXDlyUbHu9xiFw1B1xaG2b6DQsxsr5ulOQxEE3iRF6ZD70Byh6Q
        3BG9GUKKWaYMjd5+v3veNUMBjP3eIKX3sPZuMfs=
X-Google-Smtp-Source: APXvYqz0LPu+wPH8jBZSVzpaolRLdSgVVQw+WRtDn3tslIV/n+p9hir0bkcXgYqEC/6nIFdtHBrAjQYmc+zg7TXtF9g=
X-Received: by 2002:a2e:9bc1:: with SMTP id w1mr4215737ljj.136.1570806738540;
 Fri, 11 Oct 2019 08:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000056268e05737dcb95@google.com> <0000000000007d22100573d66078@google.com>
 <063a57ba-7723-6513-043e-ee99c5797271@I-love.SAKURA.ne.jp>
In-Reply-To: <063a57ba-7723-6513-043e-ee99c5797271@I-love.SAKURA.ne.jp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 11 Oct 2019 08:12:06 -0700
Message-ID: <CAADnVQJ7BZMVSt9on4updWrWsFWq6b5J1qEGwTdGYV+BLqH7tg@mail.gmail.com>
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 3:15 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> Hello.
>
> I noticed that syzbot is reporting that refcount incremented by bpf(BPF_MAP_UPDATE_ELEM)
> syscall is not decremented when unregister_netdevice() is called. Is this a BPF bug?

Jesper, Toke,
please take a look.

> Kernel: 9e208aa06c2109b45eec6be049a8e47034748c20 on linux.git
> Config: https://syzkaller.appspot.com/text?tag=KernelConfig&x=73c2aace7604ab7
> Reproducer: https://syzkaller.appspot.com/text?tag=ReproC&x=1215afaf600000
> Debug printk patch:
> ----------------------------------------
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 9eda1c31d1f7..542a47fe6998 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3732,10 +3732,7 @@ void netdev_run_todo(void);
>   *
>   * Release reference to device to allow it to be freed.
>   */
> -static inline void dev_put(struct net_device *dev)
> -{
> -       this_cpu_dec(*dev->pcpu_refcnt);
> -}
> +extern void dev_put(struct net_device *dev);
>
>  /**
>   *     dev_hold - get reference to device
> @@ -3743,10 +3740,7 @@ static inline void dev_put(struct net_device *dev)
>   *
>   * Hold reference to device to keep it from being freed.
>   */
> -static inline void dev_hold(struct net_device *dev)
> -{
> -       this_cpu_inc(*dev->pcpu_refcnt);
> -}
> +extern void dev_hold(struct net_device *dev);
>
>  /* Carrier loss detection, dial on demand. The functions netif_carrier_on
>   * and _off may be called from IRQ context, but it is caller
> diff --git a/net/core/dev.c b/net/core/dev.c
> index bf3ed413abaf..21f82aa92fad 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8968,8 +8968,8 @@ static void netdev_wait_allrefs(struct net_device *dev)
>                 refcnt = netdev_refcnt_read(dev);
>
>                 if (refcnt && time_after(jiffies, warning_time + 10 * HZ)) {
> -                       pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
> -                                dev->name, refcnt);
> +                       pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d %px\n",
> +                                dev->name, refcnt, dev);
>                         warning_time = jiffies;
>                 }
>         }
> @@ -9930,3 +9930,24 @@ static int __init net_dev_init(void)
>  }
>
>  subsys_initcall(net_dev_init);
> +
> +
> +void dev_put(struct net_device *dev)
> +{
> +       this_cpu_dec(*dev->pcpu_refcnt);
> +       if (!strcmp(dev->name, "bridge_slave_0")) {
> +               printk("dev_put: %px %d", dev, netdev_refcnt_read(dev));
> +               dump_stack();
> +       }
> +}
> +EXPORT_SYMBOL(dev_put);
> +
> +void dev_hold(struct net_device *dev)
> +{
> +       if (!strcmp(dev->name, "bridge_slave_0")) {
> +               printk("dev_hold: %px %d", dev, netdev_refcnt_read(dev));
> +               dump_stack();
> +       }
> +       this_cpu_inc(*dev->pcpu_refcnt);
> +}
> +EXPORT_SYMBOL(dev_hold);
> ----------------------------------------
>
> ----------------------------------------
> Oct 11 14:33:06 ubuntu kernel: [  114.251175][ T8866] dev_hold: ffff888091fd2000 100
> Oct 11 14:33:06 ubuntu kernel: [  114.251185][ T8866] CPU: 3 PID: 8866 Comm: a.out Not tainted 5.4.0-rc2+ #217
> Oct 11 14:33:06 ubuntu kernel: [  114.251199][ T8866] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
> Oct 11 14:33:06 ubuntu kernel: [  114.251208][ T8866] Call Trace:
> Oct 11 14:33:06 ubuntu kernel: [  114.251232][ T8866]  dump_stack+0x154/0x1c5
> Oct 11 14:33:06 ubuntu kernel: [  114.251253][ T8866]  dev_hold+0x73/0x80
> Oct 11 14:33:06 ubuntu kernel: [  114.251267][ T8866]  dev_get_by_index+0x1b3/0x2d0
> Oct 11 14:33:06 ubuntu kernel: [  114.251280][ T8866]  __dev_map_alloc_node+0x1c7/0x360
> Oct 11 14:33:06 ubuntu kernel: [  114.251299][ T8866]  dev_map_hash_update_elem+0x485/0x670
> Oct 11 14:33:06 ubuntu kernel: [  114.251320][ T8866]  __do_sys_bpf+0x35d6/0x38c0
> Oct 11 14:33:06 ubuntu kernel: [  114.251337][ T8866]  ? bpf_prog_load+0x1470/0x1470
> Oct 11 14:33:06 ubuntu kernel: [  114.251351][ T8866]  ? do_wp_page+0x3c8/0x1310
> Oct 11 14:33:06 ubuntu kernel: [  114.251364][ T8866]  ? finish_mkwrite_fault+0x300/0x300
> Oct 11 14:33:06 ubuntu kernel: [  114.251381][ T8866]  ? find_held_lock+0x35/0x1e0
> Oct 11 14:33:06 ubuntu kernel: [  114.251397][ T8866]  ? __do_page_fault+0x504/0xb60
> Oct 11 14:33:06 ubuntu kernel: [  114.251413][ T8866]  ? lock_downgrade+0x900/0x900
> Oct 11 14:33:06 ubuntu kernel: [  114.251426][ T8866]  ? __pmd_alloc+0x410/0x410
> Oct 11 14:33:06 ubuntu kernel: [  114.251446][ T8866]  ? __kasan_check_write+0x14/0x20
> Oct 11 14:33:06 ubuntu kernel: [  114.251457][ T8866]  ? up_read+0x1b6/0x7a0
> Oct 11 14:33:06 ubuntu kernel: [  114.251471][ T8866]  ? down_read_nested+0x480/0x480
> Oct 11 14:33:06 ubuntu kernel: [  114.251494][ T8866]  ? do_syscall_64+0x26/0x6a0
> Oct 11 14:33:06 ubuntu kernel: [  114.251507][ T8866]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
> Oct 11 14:33:06 ubuntu kernel: [  114.251515][ T8866]  ? do_syscall_64+0x26/0x6a0
> Oct 11 14:33:06 ubuntu kernel: [  114.251528][ T8866]  __x64_sys_bpf+0x73/0xb0
> Oct 11 14:33:06 ubuntu kernel: [  114.251541][ T8866]  do_syscall_64+0xde/0x6a0
> Oct 11 14:33:06 ubuntu kernel: [  114.251559][ T8866]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> (...snipped...)
> Oct 11 14:33:10 ubuntu kernel: [  117.459637][ T9584] dev_hold: ffff888091fd2000 200
> Oct 11 14:33:10 ubuntu kernel: [  117.459644][ T9584] CPU: 4 PID: 9584 Comm: a.out Not tainted 5.4.0-rc2+ #217
> Oct 11 14:33:10 ubuntu kernel: [  117.459652][ T9584] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
> Oct 11 14:33:10 ubuntu kernel: [  117.459656][ T9584] Call Trace:
> Oct 11 14:33:10 ubuntu kernel: [  117.459669][ T9584]  dump_stack+0x154/0x1c5
> Oct 11 14:33:10 ubuntu kernel: [  117.459682][ T9584]  dev_hold+0x73/0x80
> Oct 11 14:33:10 ubuntu kernel: [  117.459695][ T9584]  dev_get_by_index+0x1b3/0x2d0
> Oct 11 14:33:10 ubuntu kernel: [  117.459706][ T9584]  __dev_map_alloc_node+0x1c7/0x360
> Oct 11 14:33:10 ubuntu kernel: [  117.459720][ T9584]  dev_map_hash_update_elem+0x485/0x670
> Oct 11 14:33:10 ubuntu kernel: [  117.459749][ T9584]  __do_sys_bpf+0x35d6/0x38c0
> Oct 11 14:33:10 ubuntu kernel: [  117.459762][ T9584]  ? bpf_prog_load+0x1470/0x1470
> Oct 11 14:33:10 ubuntu kernel: [  117.459769][ T9584]  ? do_wp_page+0x3c8/0x1310
> Oct 11 14:33:10 ubuntu kernel: [  117.459778][ T9584]  ? finish_mkwrite_fault+0x300/0x300
> Oct 11 14:33:10 ubuntu kernel: [  117.459787][ T9584]  ? find_held_lock+0x35/0x1e0
> Oct 11 14:33:10 ubuntu kernel: [  117.459797][ T9584]  ? __do_page_fault+0x504/0xb60
> Oct 11 14:33:10 ubuntu kernel: [  117.459807][ T9584]  ? lock_downgrade+0x900/0x900
> Oct 11 14:33:10 ubuntu kernel: [  117.459814][ T9584]  ? __pmd_alloc+0x410/0x410
> Oct 11 14:33:10 ubuntu kernel: [  117.459828][ T9584]  ? __kasan_check_write+0x14/0x20
> Oct 11 14:33:10 ubuntu kernel: [  117.459835][ T9584]  ? up_read+0x1b6/0x7a0
> Oct 11 14:33:10 ubuntu kernel: [  117.459846][ T9584]  ? down_read_nested+0x480/0x480
> Oct 11 14:33:10 ubuntu kernel: [  117.459862][ T9584]  ? do_syscall_64+0x26/0x6a0
> Oct 11 14:33:10 ubuntu kernel: [  117.459871][ T9584]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
> Oct 11 14:33:10 ubuntu kernel: [  117.459878][ T9584]  ? do_syscall_64+0x26/0x6a0
> Oct 11 14:33:10 ubuntu kernel: [  117.459891][ T9584]  __x64_sys_bpf+0x73/0xb0
> Oct 11 14:33:10 ubuntu kernel: [  117.459901][ T9584]  do_syscall_64+0xde/0x6a0
> Oct 11 14:33:10 ubuntu kernel: [  117.459911][ T9584]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> (...snipped...)
> Oct 11 14:33:26 ubuntu kernel: [  134.146838][T13860] dev_hold: ffff888091fd2000 850
> Oct 11 14:33:26 ubuntu kernel: [  134.146847][T13860] CPU: 4 PID: 13860 Comm: a.out Not tainted 5.4.0-rc2+ #217
> Oct 11 14:33:26 ubuntu kernel: [  134.146853][T13860] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
> Oct 11 14:33:26 ubuntu kernel: [  134.146859][T13860] Call Trace:
> Oct 11 14:33:26 ubuntu kernel: [  134.146872][T13860]  dump_stack+0x154/0x1c5
> Oct 11 14:33:26 ubuntu kernel: [  134.146885][T13860]  dev_hold+0x73/0x80
> Oct 11 14:33:26 ubuntu kernel: [  134.146893][T13860]  dev_get_by_index+0x1b3/0x2d0
> Oct 11 14:33:26 ubuntu kernel: [  134.146903][T13860]  __dev_map_alloc_node+0x1c7/0x360
> Oct 11 14:33:26 ubuntu kernel: [  134.146918][T13860]  dev_map_hash_update_elem+0x485/0x670
> Oct 11 14:33:26 ubuntu kernel: [  134.146932][T13860]  __do_sys_bpf+0x35d6/0x38c0
> Oct 11 14:33:26 ubuntu kernel: [  134.146944][T13860]  ? bpf_prog_load+0x1470/0x1470
> Oct 11 14:33:26 ubuntu kernel: [  134.146953][T13860]  ? do_wp_page+0x3c8/0x1310
> Oct 11 14:33:26 ubuntu kernel: [  134.146964][T13860]  ? finish_mkwrite_fault+0x300/0x300
> Oct 11 14:33:26 ubuntu kernel: [  134.146975][T13860]  ? find_held_lock+0x35/0x1e0
> Oct 11 14:33:26 ubuntu kernel: [  134.146985][T13860]  ? __do_page_fault+0x504/0xb60
> Oct 11 14:33:26 ubuntu kernel: [  134.146994][T13860]  ? lock_downgrade+0x900/0x900
> Oct 11 14:33:26 ubuntu kernel: [  134.147002][T13860]  ? __pmd_alloc+0x410/0x410
> Oct 11 14:33:26 ubuntu kernel: [  134.147017][T13860]  ? __kasan_check_write+0x14/0x20
> Oct 11 14:33:26 ubuntu kernel: [  134.147024][T13860]  ? up_read+0x1b6/0x7a0
> Oct 11 14:33:26 ubuntu kernel: [  134.147033][T13860]  ? down_read_nested+0x480/0x480
> Oct 11 14:33:26 ubuntu kernel: [  134.147048][T13860]  ? do_syscall_64+0x26/0x6a0
> Oct 11 14:33:26 ubuntu kernel: [  134.147056][T13860]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
> Oct 11 14:33:26 ubuntu kernel: [  134.147063][T13860]  ? do_syscall_64+0x26/0x6a0
> Oct 11 14:33:26 ubuntu kernel: [  134.147074][T13860]  __x64_sys_bpf+0x73/0xb0
> Oct 11 14:33:26 ubuntu kernel: [  134.147084][T13860]  do_syscall_64+0xde/0x6a0
> Oct 11 14:33:26 ubuntu kernel: [  134.147095][T13860]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> (...snipped...)
> Oct 11 14:33:41 ubuntu kernel: [  148.384539][ T4514] unregister_netdevice: waiting for bridge_slave_0 to become free. Usage count = 850 ffff888091fd2000
> ----------------------------------------
>
