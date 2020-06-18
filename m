Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16641FFBE5
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgFRTkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgFRTkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 15:40:17 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931AFC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 12:40:16 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id w16so7667642ejj.5
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 12:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y/v5aKcfxhXMPWHtTiMG+KUzT2efX4Xpu97e2NX9mxU=;
        b=OcJ0NLaBDtBR4yS/qmcMRMCrMt2wHUqO1I2v7BTwEvymkC980+/3XfAsVhXqh9191V
         4v+O9SIvTuVLaIrbOJDlwJA/P0qGCwS7S6jMIJ2g8YYLrIrQMhv65db9SuXvdyTHlw4m
         FBvu6isQiGoFZJXyYr4baHW0Vvx/idQQ4hJ+oi7V4QH5Vpwzc36fhcKbWxdRL+6px+iZ
         9/7L+9iZMUqqvT/QWsU873I/Q8CEwg46zTUyq262zOPmyLwKJhI0sN+dLEZM+w95084t
         IGiUgKfyRl2BFFynFxcgTsT67FZNa+2KyC0EMA1nFrmjpEFV971iHBAQbM/ivHJp1O+0
         ZRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y/v5aKcfxhXMPWHtTiMG+KUzT2efX4Xpu97e2NX9mxU=;
        b=WWy7RT+wHtPXPWn27aOElJbLvZHM2ugtr6opb/yyY0Qq5Wx47ylpqAzwE0D4tMBO5C
         nBTUrJ85cQxJYHhIwYj8j6PhFsBZgqt+2oOrmwSpb0Fhc05+pnQ9IPSqj9n/qZsWMbcw
         RVbrCusVFHzb5U1hjAKLTRMuH5Lrf+SwsvzhjPTH73s1Ck3s69D4ZQISAsshl9wSzGC1
         C1AJ46pJA531qQQD2SkO7YGuqWx61V4xEkGwuEpCL/KU8qwD5Lrr8WlsrBJuAb96YrVr
         32LdTtUuNs52qdedlvEkWPZPnRb31dKDJwkZ9i4oGnUqsviJUEINxKo74Y4nwSJ6b2SW
         KchA==
X-Gm-Message-State: AOAM533dDZmil50nsVejAWRioTIGrDcTtkyWUXklxAVV75t6Siap1j/+
        0WfVUxPiG9Q5u51N0FSUEtnQX8g439fFZbk3BIQ=
X-Google-Smtp-Source: ABdhPJz0l++t+ak1XhAE/2pdjH2fQsMvtm4sVKYjQfcG7iUGNnNwxkfXXygteB6RnNd93zOTUi11yxEZH0mS+785BcI=
X-Received: by 2002:a17:906:2e50:: with SMTP id r16mr244218eji.305.1592509215172;
 Thu, 18 Jun 2020 12:40:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 18 Jun 2020 22:40:03 +0300
Message-ID: <CA+h21hr_epEqWukZMQmZ2ecS9Y0yvX9mzR3g3OA39rg_96FfnQ@mail.gmail.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong, Taehee,

On Tue, 9 Jun 2020 at 00:54, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> The dynamic key update for addr_list_lock still causes troubles,
> for example the following race condition still exists:
>
> CPU 0:                          CPU 1:
> (RCU read lock)                 (RTNL lock)
> dev_mc_seq_show()               netdev_update_lockdep_key()
>                                   -> lockdep_unregister_key()
>  -> netif_addr_lock_bh()
>
> because lockdep doesn't provide an API to update it atomically.
> Therefore, we have to move it back to static keys and use subclass
> for nest locking like before.
>
> In commit 1a33e10e4a95 ("net: partially revert dynamic lockdep key
> changes"), I already reverted most parts of commit ab92d68fc22f
> ("net: core: add generic lockdep keys").
>
> This patch reverts the rest and also part of commit f3b0a18bb6cb
> ("net: remove unnecessary variables and callback"). After this
> patch, addr_list_lock changes back to using static keys and
> subclasses to satisfy lockdep. Thanks to dev->lower_level, we do
> not have to change back to ->ndo_get_lock_subclass().
>
> And hopefully this reduces some syzbot lockdep noises too.
>
> Reported-by: syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com
> Cc: Taehee Yoo <ap420073@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  drivers/net/bonding/bond_main.c               |  2 --
>  drivers/net/bonding/bond_options.c            |  2 --
>  drivers/net/hamradio/bpqether.c               |  2 ++
>  drivers/net/macsec.c                          |  5 ++++
>  drivers/net/macvlan.c                         | 13 ++++++--
>  drivers/net/vxlan.c                           |  4 +--
>  .../net/wireless/intersil/hostap/hostap_hw.c  |  3 ++
>  include/linux/netdevice.h                     | 12 +++++---
>  net/8021q/vlan_dev.c                          |  8 +++--
>  net/batman-adv/soft-interface.c               |  2 ++
>  net/bridge/br_device.c                        |  8 +++++
>  net/core/dev.c                                | 30 ++++++++++---------
>  net/core/dev_addr_lists.c                     | 12 ++++----
>  net/core/rtnetlink.c                          |  1 -
>  net/dsa/master.c                              |  4 +++
>  net/netrom/af_netrom.c                        |  2 ++
>  net/rose/af_rose.c                            |  2 ++
>  17 files changed, 76 insertions(+), 36 deletions(-)
>

It's me with the stacked DSA devices again:

[   11.424642] ============================================
[   11.429967] WARNING: possible recursive locking detected
[   11.435295] 5.8.0-rc1-00133-g923e4b5032dd-dirty #208 Not tainted
[   11.441319] --------------------------------------------
[   11.446646] dhcpcd/323 is trying to acquire lock:
[   11.451362] ffff000066dd4268
(&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at:
dev_mc_sync+0x44/0x90
[   11.460713]
[   11.460713] but task is already holding lock:
[   11.466561] ffff00006608c268
(&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at:
dev_mc_sync+0x44/0x90
[   11.475905]
[   11.475905] other info that might help us debug this:
[   11.482450]  Possible unsafe locking scenario:
[   11.482450]
[   11.488386]        CPU0
[   11.490833]        ----
[   11.493280]   lock(&dsa_master_addr_list_lock_key/1);
[   11.498347]   lock(&dsa_master_addr_list_lock_key/1);
[   11.503413]
[   11.503413]  *** DEADLOCK ***
[   11.503413]
[   11.509349]  May be due to missing lock nesting notation
[   11.509349]
[   11.516158] 3 locks held by dhcpcd/323:
[   11.520001]  #0: ffffdbd1381dda18 (rtnl_mutex){+.+.}-{3:3}, at:
rtnl_lock+0x24/0x30
[   11.527688]  #1: ffff00006614b268 (_xmit_ETHER){+...}-{2:2}, at:
dev_set_rx_mode+0x28/0x48
[   11.535987]  #2: ffff00006608c268
(&dsa_master_addr_list_lock_key/1){+...}-{2:2}, at:
dev_mc_sync+0x44/0x90
[   11.545766]
[   11.545766] stack backtrace:
[   11.564098] Call trace:
[   11.566549]  dump_backtrace+0x0/0x1e0
[   11.570220]  show_stack+0x20/0x30
[   11.573544]  dump_stack+0xec/0x158
[   11.576955]  __lock_acquire+0xca0/0x2398
[   11.580886]  lock_acquire+0xe8/0x440
[   11.584469]  _raw_spin_lock_nested+0x64/0x90
[   11.588749]  dev_mc_sync+0x44/0x90
[   11.592159]  dsa_slave_set_rx_mode+0x34/0x50
[   11.596438]  __dev_set_rx_mode+0x60/0xa0
[   11.600369]  dev_mc_sync+0x84/0x90
[   11.603778]  dsa_slave_set_rx_mode+0x34/0x50
[   11.608057]  __dev_set_rx_mode+0x60/0xa0
[   11.611989]  dev_set_rx_mode+0x30/0x48
[   11.615745]  __dev_open+0x10c/0x180
[   11.619240]  __dev_change_flags+0x170/0x1c8
[   11.623432]  dev_change_flags+0x2c/0x70
[   11.627279]  devinet_ioctl+0x774/0x878
[   11.631036]  inet_ioctl+0x348/0x3b0
[   11.634532]  sock_do_ioctl+0x50/0x310
[   11.638202]  sock_ioctl+0x1f8/0x580
[   11.641698]  ksys_ioctl+0xb0/0xf0
[   11.645019]  __arm64_sys_ioctl+0x28/0x38
[   11.648951]  el0_svc_common.constprop.0+0x7c/0x180
[   11.653753]  do_el0_svc+0x2c/0x98
[   11.657075]  el0_sync_handler+0x9c/0x1b8
[   11.661005]  el0_sync+0x158/0x180

Could you please share some suggestions?

Thanks,
-Vladimir
