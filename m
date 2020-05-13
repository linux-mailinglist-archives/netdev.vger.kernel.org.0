Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D027D1D19FF
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732176AbgEMP4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729467AbgEMP4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:56:31 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72ADBC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 08:56:31 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n17so14635598ejh.7
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 08:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zf1/JRN2qsTnsb6+yBa3rqmwkw343vwkl6yqHeqqd8E=;
        b=tuLj3Er2day5B1URtjg5TF4zz4uKsBDSnJaUNsD3VEcA1jC8n0B0FRFtm54Vf0yRm5
         G140i3B+B1nwTMmcNHoWaRpMcfUy9a7y6HVL2vCjqmfMsLd927+tIgWkt2sjS33qTN2f
         r5PagN3UDK/gwy9a7XnJX+c40vkCTEGtpz4fQQ45LDAtCA8K3pwuAIjQ9+WQBsE2wnEM
         aQzW2DyOjGUpiZGfjW+xv8wiW/9Mmvuv4q28kNGRB0WfuxWYKCvCLEcpd8GMUH8l8SMb
         1Y1O20yLscuarqKsVGP3kjbTywmmYPEGcI/QWET1CxMChp9yVrwaGxqlbi3cbqiSLIKU
         O6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zf1/JRN2qsTnsb6+yBa3rqmwkw343vwkl6yqHeqqd8E=;
        b=PcN+8OiSNJuMRKz+5hUhlEFqi7xPBSYuupejyjlM0pSWRFkCQDYMEqlVWt1okvUjMZ
         vhFmFD5osEp6Dg/DznR/usFSKAZD0ocGixXadR+MUyqmG1coCiSFvWRbEVz3y20Cougb
         QPbguojOgprFIgUg80EwkeXWVsz9Ii8jh6TejgwbXOvmkKHF/e5eRNQQGDwj7gYrcfy2
         ZvtDgCEzpzeDDgYCAUVyPJbtSUsyZQUsyJs0aoimaXdHwrDHbYKo/akUZvgdkWRxko/J
         zcgUTJjbYaSlMRLYwSy+EeAjnsZlksTaloQaXQdZH5H8OO5CMBASVeOU7F+BRLkzv+Yu
         oHPA==
X-Gm-Message-State: AGi0PuZCRGBl+8ljcF8V6ic8oxvUfbKk11O7QV72HvGuPoUr7PoOLo4Y
        WuptV4WZMSQnMHs5z8XS2bJI3cBYIH6tdf0HcOxssimQ
X-Google-Smtp-Source: APiQypICPC841GX7dK9FJs1Zg9ql7b8TNhHoYnJ2BQWfsxQjRKiG6vVQ1qv4sxay5dEnYPclp9vdjK+3d7xCGDeoPNE=
X-Received: by 2002:a17:906:78c:: with SMTP id l12mr21361188ejc.189.1589385390136;
 Wed, 13 May 2020 08:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200503052220.4536-1-xiyou.wangcong@gmail.com>
 <20200503052220.4536-2-xiyou.wangcong@gmail.com> <CAMArcTVQO8U_kU1EHxCDsjdfGn-y_keAQ3ScjJmPAeya+B8hHQ@mail.gmail.com>
In-Reply-To: <CAMArcTVQO8U_kU1EHxCDsjdfGn-y_keAQ3ScjJmPAeya+B8hHQ@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 13 May 2020 18:56:19 +0300
Message-ID: <CA+h21hqu=J5RH3UkYBt7=uxWNYvXWegFsbMnf3PoWyVHTpRPrQ@mail.gmail.com>
Subject: Re: [Patch net-next v2 1/2] net: partially revert dynamic lockdep key changes
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong, Taehee,

On Mon, 4 May 2020 at 21:45, Taehee Yoo <ap420073@gmail.com> wrote:
>
> On Sun, 3 May 2020 at 14:22, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
>
> Hi Cong,
> Thank you for this work!
>
> > This patch reverts the folowing commits:
> >
> > commit 064ff66e2bef84f1153087612032b5b9eab005bd
> > "bonding: add missing netdev_update_lockdep_key()"
> >
> > commit 53d374979ef147ab51f5d632dfe20b14aebeccd0
> > "net: avoid updating qdisc_xmit_lock_key in netdev_update_lockdep_key()"
> >
> > commit 1f26c0d3d24125992ab0026b0dab16c08df947c7
> > "net: fix kernel-doc warning in <linux/netdevice.h>"
> >
> > commit ab92d68fc22f9afab480153bd82a20f6e2533769
> > "net: core: add generic lockdep keys"
> >
> > but keeps the addr_list_lock_key because we still lock
> > addr_list_lock nestedly on stack devices, unlikely xmit_lock
> > this is safe because we don't take addr_list_lock on any fast
> > path.
> >
> > Reported-and-tested-by: syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com
> > Cc: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Taehee Yoo <ap420073@gmail.com>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>
> Acked-by: Taehee Yoo <ap420073@gmail.com>
>
> Thank you,
> Taehee Yoo

I have a platform with the following layout:

      Regular NIC
       |
       +----> DSA master for switch port
               |
               +----> DSA master for another switch port

After changing DSA back to static lockdep class keys, I get this splat:

[   13.361198] ============================================
[   13.366524] WARNING: possible recursive locking detected
[   13.371851] 5.7.0-rc4-02121-gc32a05ecd7af-dirty #988 Not tainted
[   13.377874] --------------------------------------------
[   13.383201] swapper/0/0 is trying to acquire lock:
[   13.388004] ffff0000668ff298
(&dsa_slave_netdev_xmit_lock_key){+.-.}-{2:2}, at:
__dev_queue_xmit+0x84c/0xbe0
[   13.397879]
[   13.397879] but task is already holding lock:
[   13.403727] ffff0000661a1698
(&dsa_slave_netdev_xmit_lock_key){+.-.}-{2:2}, at:
__dev_queue_xmit+0x84c/0xbe0
[   13.413593]
[   13.413593] other info that might help us debug this:
[   13.420140]  Possible unsafe locking scenario:
[   13.420140]
[   13.426075]        CPU0
[   13.428523]        ----
[   13.430969]   lock(&dsa_slave_netdev_xmit_lock_key);
[   13.435946]   lock(&dsa_slave_netdev_xmit_lock_key);
[   13.440924]
[   13.440924]  *** DEADLOCK ***
[   13.440924]
[   13.446860]  May be due to missing lock nesting notation
[   13.446860]
[   13.453668] 6 locks held by swapper/0/0:
[   13.457598]  #0: ffff800010003de0
((&idev->mc_ifc_timer)){+.-.}-{0:0}, at: call_timer_fn+0x0/0x400
[   13.466593]  #1: ffffd4d3fb478700 (rcu_read_lock){....}-{1:2}, at:
mld_sendpack+0x0/0x560
[   13.474803]  #2: ffffd4d3fb478728 (rcu_read_lock_bh){....}-{1:2},
at: ip6_finish_output2+0x64/0xb10
[   13.483886]  #3: ffffd4d3fb478728 (rcu_read_lock_bh){....}-{1:2},
at: __dev_queue_xmit+0x6c/0xbe0
[   13.492793]  #4: ffff0000661a1698
(&dsa_slave_netdev_xmit_lock_key){+.-.}-{2:2}, at:
__dev_queue_xmit+0x84c/0xbe0
[   13.503094]  #5: ffffd4d3fb478728 (rcu_read_lock_bh){....}-{1:2},
at: __dev_queue_xmit+0x6c/0xbe0
[   13.512000]
[   13.512000] stack backtrace:
[   13.516369] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
5.7.0-rc4-02121-gc32a05ecd7af-dirty #988
[   13.530421] Call trace:
[   13.532871]  dump_backtrace+0x0/0x1d8
[   13.536539]  show_stack+0x24/0x30
[   13.539862]  dump_stack+0xe8/0x150
[   13.543271]  __lock_acquire+0x1030/0x1678
[   13.547290]  lock_acquire+0xf8/0x458
[   13.550873]  _raw_spin_lock+0x44/0x58
[   13.554543]  __dev_queue_xmit+0x84c/0xbe0
[   13.558562]  dev_queue_xmit+0x24/0x30
[   13.562232]  dsa_slave_xmit+0xe0/0x128
[   13.565988]  dev_hard_start_xmit+0xf4/0x448
[   13.570182]  __dev_queue_xmit+0x808/0xbe0
[   13.574200]  dev_queue_xmit+0x24/0x30
[   13.577869]  neigh_resolve_output+0x15c/0x220
[   13.582237]  ip6_finish_output2+0x244/0xb10
[   13.586430]  __ip6_finish_output+0x1dc/0x298
[   13.590709]  ip6_output+0x84/0x358
[   13.594116]  mld_sendpack+0x2bc/0x560
[   13.597786]  mld_ifc_timer_expire+0x210/0x390
[   13.602153]  call_timer_fn+0xcc/0x400
[   13.605822]  run_timer_softirq+0x588/0x6e0
[   13.609927]  __do_softirq+0x118/0x590
[   13.613597]  irq_exit+0x13c/0x148
[   13.616918]  __handle_domain_irq+0x6c/0xc0
[   13.621023]  gic_handle_irq+0x6c/0x160
[   13.624779]  el1_irq+0xbc/0x180
[   13.627927]  cpuidle_enter_state+0xb4/0x4d0
[   13.632120]  cpuidle_enter+0x3c/0x50
[   13.635703]  call_cpuidle+0x44/0x78
[   13.639199]  do_idle+0x228/0x2c8
[   13.642433]  cpu_startup_entry+0x2c/0x48
[   13.646363]  rest_init+0x1ac/0x280
[   13.649773]  arch_call_rest_init+0x14/0x1c
[   13.653878]  start_kernel+0x490/0x4bc

Unfortunately I can't really test DSA behavior prior to patch
ab92d68fc22f ("net: core: add generic lockdep keys"), because in
October, some of these DSA drivers were not in mainline.
Also I don't really have a clear idea of how nesting should be
signalled to lockdep.
Do you have any suggestion what might be wrong?

Thanks,
-Vladimir
