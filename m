Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487259F3D1
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 22:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbfH0UMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 16:12:18 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36100 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730839AbfH0UMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 16:12:17 -0400
Received: by mail-qt1-f193.google.com with SMTP id z4so367936qtc.3
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 13:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BkZIfmKZ7qzT0/Q98A2MpbsT7hkDc5a1un54X3X6iBY=;
        b=nJhYBdc8MTQ/bmYv05s4tR+VuVWiEu3RS+H58f9PqTo+QX/BCcCnXTUecm64r1sTgE
         7NAxgLbhS+OvQ6AdVC+Sift3RvjjeBRIbDZL+KcRN1Olpt3FUGdRyhk6mRHnmLIVP3PP
         v4/uDVMWFU28cAV5IMArPgkc1lat1SiTW8IVf72eoMmZ0Kx+D/5MN5XYK3EL4uv97qdL
         XPOw019DIJahaVadM8hKoJdm1XXayH6zxzT3eOZVgaPcvzoPXggHpTw7BcbA88M+CseC
         Atv2jO85PRB7PhcpLSMatOELhVseZ7Iq+Q0iu0xSZ12SRzfA77tPs0OgyLWe2uT+KuuM
         d6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BkZIfmKZ7qzT0/Q98A2MpbsT7hkDc5a1un54X3X6iBY=;
        b=QkD6ZmB5FVT5VI6c2HE0Tf2qy6del+cG/2e4wH1CzxEnsqZdRBGnyro0tkiVpJyM85
         bGKuA32BM8ai0G8jGz4wcEeEnM1Ij+7dP1gZ8JUCuWa2bJRDYCUb75DVBmXbhoD0YXde
         vyDsGqPeRV/hqDVDAlVfHXENVJ34jYe2FzuFpVw76vuKIKSur0p6CIP35wUpsapQKdZq
         BYmNux0W0lVEGS7FxrLsCx3GekYtfjaRnSVpV3X+fV2H+7IPTkkpgM47xooUtZCFE2rM
         0pa2o7QytmzTJPlRo2QYrKaJK+dWSCOdSnN+0C4gUcnQtKz2xOR1EhqFbaIAM2US0bhe
         J3DA==
X-Gm-Message-State: APjAAAWP2GVI4zAE/pPhFAGuLau+tQnRlKv3VIvl88bWSP259kJXW7N5
        X149XgJfvwgYkvqAhOwEDyf92g==
X-Google-Smtp-Source: APXvYqwqlWIGIWvpy5/f8fYmogPINRbnGzcIQ8VA4zmB7qImfGYvICCMRTDbbZMdWyXzI8jgs8DZ9Q==
X-Received: by 2002:ac8:7959:: with SMTP id r25mr700399qtt.208.1566936736033;
        Tue, 27 Aug 2019 13:12:16 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id p32sm56327qtb.67.2019.08.27.13.12.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 13:12:15 -0700 (PDT)
Message-ID: <1566936733.5576.16.camel@lca.pw>
Subject: Re: [PATCH] net/mlx5: fix a -Wstringop-truncation warning
From:   Qian Cai <cai@lca.pw>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Date:   Tue, 27 Aug 2019 16:12:13 -0400
In-Reply-To: <21994e7e141ee5453c6814de025e083eeb651127.camel@mellanox.com>
References: <1566590183-9898-1-git-send-email-cai@lca.pw>
         <21994e7e141ee5453c6814de025e083eeb651127.camel@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-08-26 at 21:11 +0000, Saeed Mahameed wrote:
> On Fri, 2019-08-23 at 15:56 -0400, Qian Cai wrote:
> > In file included from ./arch/powerpc/include/asm/paca.h:15,
> >                  from ./arch/powerpc/include/asm/current.h:13,
> >                  from ./include/linux/thread_info.h:21,
> >                  from ./include/asm-generic/preempt.h:5,
> >                  from
> > ./arch/powerpc/include/generated/asm/preempt.h:1,
> >                  from ./include/linux/preempt.h:78,
> >                  from ./include/linux/spinlock.h:51,
> >                  from ./include/linux/wait.h:9,
> >                  from ./include/linux/completion.h:12,
> >                  from ./include/linux/mlx5/driver.h:37,
> >                  from
> > drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h:6,
> >                  from
> > drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c:33:
> > In function 'strncpy',
> >     inlined from 'mlx5_fw_tracer_save_trace' at
> > drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c:549:2,
> >     inlined from 'mlx5_tracer_print_trace' at
> > drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c:574:2:
> > ./include/linux/string.h:305:9: warning: '__builtin_strncpy' output
> > may
> > be truncated copying 256 bytes from a string of length 511
> > [-Wstringop-truncation]
> >   return __builtin_strncpy(p, q, size);
> >          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > Fix it by using the new strscpy_pad() since the commit 458a3bf82df4
> > ("lib/string: Add strscpy_pad() function") which will always
> > NUL-terminate the string, and avoid possibly leak data through the
> > ring
> > buffer where non-admin account might enable these events through
> > perf.
> > 
> > Fixes: fd1483fe1f9f ("net/mlx5: Add support for FW reporter dump")
> > Signed-off-by: Qian Cai <cai@lca.pw>
> 
> 
> Hi Qian and thanks for your patch,
> 
> We already have a patch that handles this issue, please check it out:
> https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/commit/?h=net-
> next-mlx5
> 

That commit will make "struct mlx5_fw_tracer" too large and trigger a warning in
__alloc_pages_nodemask(),

        /*
         * There are several places where we assume that the order value is sane
         * so bail out early if the request is out of bound.
         */
        if (unlikely(order >= MAX_ORDER)) {
                WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
                return NULL;
        }

[   98.339576][  T914] WARNING: CPU: 0 PID: 914 at mm/page_alloc.c:4705
__alloc_pages_nodemask+0x441/0x1bb0
[   98.349174][  T914] Modules linked in: smartpqi(+) scsi_transport_sas tg3
mlx5_core(+) libphy firmware_class dm_mirror dm_region_hash dm_log dm_mod
efivarfs
[   98.363495][  T914] CPU: 0 PID: 914 Comm: kworker/0:2 Not tainted 5.3.0-rc6-
next-20190827+ #14
[   98.372243][  T914] Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385
Gen10, BIOS A40 07/10/2019
[   98.381627][  T914] Workqueue: events work_for_cpu_fn
[   98.386720][  T914] RIP: 0010:__alloc_pages_nodemask+0x441/0x1bb0
[   98.392917][  T914] Code: 17 00 00 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d
c3 89 85 3c fe ff ff bb 01 00 00 00 e9 96 fd ff ff 81 e7 00 20 00 00 75 02 <0f>
0b 48 c7 85 50 fe ff ff 00 00 00 00 eb 82 31 d2 be 36 12 00 00
[   98.412740][  T914] RSP: 0018:ffff88853418f948 EFLAGS: 00010246
[   98.418704][  T914] RAX: 0000000000000000 RBX: ffffffff9571a860 RCX:
1ffff110a6831f3e
[   98.426652][  T914] RDX: 0000000000000000 RSI: 000000000000000b RDI:
0000000000000000
[   98.434661][  T914] RBP: ffff88853418fb58 R08: ffffed1108808465 R09:
ffffed1108808465
[   98.442613][  T914] R10: ffffed1108808464 R11: ffff888844042323 R12:
0000000000000000
[   98.450548][  T914] R13: 000000000000000b R14: 0000000000000000 R15:
0000000000000001
[   98.458434][  T914] FS:  0000000000000000(0000) GS:ffff888844000000(0000)
knlGS:0000000000000000
[   98.467350][  T914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   98.473911][  T914] CR2: 0000555c64680148 CR3: 0000000550412000 CR4:
00000000003406b0
[   98.481838][  T914] Call Trace:
[   98.485011][  T914]  ? find_next_bit+0x2c/0xa0
[   98.489490][  T914]  ? __kasan_check_write+0x14/0x20
[   98.494506][  T914]  ? graph_lock+0xb8/0x120
[   98.498811][  T914]  ? __free_zapped_classes+0x740/0x740
[   98.504239][  T914]  ? gfp_pfmemalloc_allowed+0xc0/0xc0
[   98.509504][  T914]  ? __kasan_check_read+0x11/0x20
[   98.514443][  T914]  ? register_lock_class+0x5ef/0x960
[   98.519624][  T914]  ? rcu_read_lock_sched_held+0xac/0xe0
[   98.525152][  T914]  ? rcu_read_lock_any_held.part.5+0x20/0x20
[   98.531130][  T914]  ? find_next_bit+0x2c/0xa0
[   98.535610][  T914]  alloc_pages_current+0x9c/0x110
[   98.540638][  T914]  kmalloc_order+0x22/0x70
[   98.544943][  T914]  kmalloc_order_trace+0x23/0x100
[   98.550072][  T914]  mlx5_fw_tracer_create+0x51/0x870 [mlx5_core]
[   98.556213][  T914]  ? __mutex_init+0x94/0xa0
[   98.560744][  T914]  ? mlx5_init_rl_table+0x144/0x210 [mlx5_core]
[   98.566929][  T914]  mlx5_load_one+0x199/0x980 [mlx5_core]
[   98.572637][  T914]  init_one+0x494/0x760 [mlx5_core]
[   98.577771][  T914]  ? mlx5_pci_resume+0xd0/0xd0 [mlx5_core]
[   98.583574][  T914]  local_pci_probe+0x7a/0xc0
[   98.588054][  T914]  ? pci_dma_configure+0xa0/0xa0
[   98.592938][  T914]  work_for_cpu_fn+0x2e/0x50
[   98.597416][  T914]  process_one_work+0x53b/0xa70
[   98.602220][  T914]  ? pwq_dec_nr_in_flight+0x170/0x170
[   98.607485][  T914]  ? move_linked_works+0x113/0x150
[   98.612497][  T914]  worker_thread+0x363/0x5b0
[   98.616976][  T914]  kthread+0x1df/0x200
[   98.620932][  T914]  ? process_one_work+0xa70/0xa70
[   98.625847][  T914]  ? kthread_park+0xd0/0xd0
[   98.630240][  T914]  ret_from_fork+0x22/0x40
