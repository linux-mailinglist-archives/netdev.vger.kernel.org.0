Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A033DD743
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbhHBNhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbhHBNhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:37:41 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4C2C06175F;
        Mon,  2 Aug 2021 06:37:31 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id yk17so23258069ejb.11;
        Mon, 02 Aug 2021 06:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gAubNaCc6MGo7TazzDJB4gHZhx/A0VFDTdQVyNabQ64=;
        b=J72IMZBT3gYFPverBOYLtMZKu5twJ4JMH4sgSMwt66TnAt8zqsoUfHRm0aEMDgxfbT
         Dxd+LcSr6wqtdexJxFMH7is3npbYbF9t1l/aqfFKh5DHncrixQR31vAdnBsq9r35Xkyu
         u5m1OzQiYA4liF93ilBKbCGLnNCXStL0i4upjYYHkqGWXZykfxCAs9GXhDRDCttfBocl
         W1YTaU32sqZFbLNfB2OlS+pK/ykLmwtbF0AwguwGAZr4avULxeTOLhxpUwFqCS0aOJwY
         OLxkmfEqtP73p4Ar5hdrw48iG9C1yl+szcytyDC9XGVWpYC8yKxHGara/+WPBFeI+LJH
         Uqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gAubNaCc6MGo7TazzDJB4gHZhx/A0VFDTdQVyNabQ64=;
        b=KrhQKHQSPfRt87SuNQRvL1SMy7/wuPCpbJbMFz0+aKA9oR/EMmvjcwuOt6SO0RGK08
         UQQEdt3LoH7Q5mr4QerPwMgfeE2rT4VKxc0n1cf2E3+tEF9jHMCMgfeRbHFMkjHSF9Wn
         K+a1Hx/DqLGQFzC5QcI+osgfiEYRnvbnrk9HU4tvjrKMYuojhwaXwuqvtkAbMCrJ5J25
         CO6iG7UoKmLB2jJe9wGzb03xLyYZv2V+Jw2IW3jAjtvlP9Q9yMbkqMB3o3wcV4IO+pyd
         Auwl9zZJ+knU1KnOAfD8yVFeBoBQUOnXf2Iu74tokVD69Ygptm5GbNkL3C+/jNTMCarB
         RNWg==
X-Gm-Message-State: AOAM5322LeiGqhpx5++YWkxEP3w1ibgXZ6dvB8o+8+FHiYEe8Fr2tWd5
        KZ9Bf5xxC/ofwQdqXORCz0A=
X-Google-Smtp-Source: ABdhPJzoCEB+sYxtiFX4DD/kp+Jo34BUgt+d5MQidmmpjrzOKypZzMm10lWxCnVwZQVq8sJW4n2ENQ==
X-Received: by 2002:a17:906:c2d7:: with SMTP id ch23mr14919940ejb.298.1627911449596;
        Mon, 02 Aug 2021 06:37:29 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id x12sm3410080edv.96.2021.08.02.06.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:37:28 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Mon, 2 Aug 2021 16:37:27 +0300
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net
Subject: Re: [PATCH] net: convert fib_treeref from int to refcount_t
Message-ID: <20210802133727.bml3be3tpjgld45j@skbuf>
References: <20210729071350.28919-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729071350.28919-1-yajun.deng@linux.dev>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 03:13:50PM +0800, Yajun Deng wrote:
> refcount_t type should be used instead of int when fib_treeref is used as
> a reference counter,and avoid use-after-free risks.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>

Hi,

Unfortunately, with this patch applied I get into the following WARNINGs
when booting over NFS:


[    5.042532] ------------[ cut here ]------------
[    5.047184] refcount_t: addition on 0; use-after-free.
[    5.052324] WARNING: CPU: 7 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0xa4/0x150
[    5.060500] Modules linked in:
[    5.063544] CPU: 7 PID: 1 Comm: swapper/0 Not tainted 5.14.0-rc3-00864-g10b91fc2a425 #957
[    5.071709] Hardware name: NXP Layerscape LX2160ARDB (DT)
[    5.077095] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[    5.083090] pc : refcount_warn_saturate+0xa4/0x150
[    5.087869] lr : refcount_warn_saturate+0xa4/0x150
[    5.092649] sp : ffff80001009b880
[    5.095951] x29: ffff80001009b880 x28: 0000000000000000 x27: ffff56018121b800
[    5.103077] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
[    5.110202] x23: 000000000100007f x22: ffffb6084ff072d8 x21: ffffb6084ff07000
[    5.117327] x20: 0000000000000001 x19: ffff56018121b880 x18: 0000000000000001
[    5.124451] x17: 0000000000000001 x16: 0000000000000019 x15: 0000000000000030
[    5.131577] x14: 0000000000000000 x13: ffffb6084fbb34c8 x12: 000000000000068a
[    5.138701] x11: 000000000000022e x10: ffffb6084fc0b4c8 x9 : 00000000fffff000
[    5.145827] x8 : ffffb6084fbb34c8 x7 : ffffb6084fc0b4c8 x6 : 0000000000000000
[    5.152951] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000ffffffff
[    5.160076] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff560180248000
[    5.167201] Call trace:
[    5.169635]  refcount_warn_saturate+0xa4/0x150
[    5.174067]  fib_create_info+0xc00/0xc90
[    5.177982]  fib_table_insert+0x8c/0x620
[    5.181893]  fib_magic.isra.0+0x110/0x11c
[    5.185891]  fib_add_ifaddr+0xb8/0x190
[    5.189629]  fib_inetaddr_event+0x8c/0x140
[    5.193714]  blocking_notifier_call_chain+0x70/0xac
[    5.198582]  __inet_insert_ifa+0x224/0x310
[    5.202667]  inetdev_event+0x54c/0x75c
[    5.206404]  raw_notifier_call_chain+0x58/0x80
[    5.210836]  call_netdevice_notifiers_info+0x58/0xac
[    5.215789]  __dev_notify_flags+0x50/0xcc
[    5.219788]  dev_change_flags+0x50/0x6c
[    5.223612]  ip_auto_config+0x1a8/0xe84
[    5.227437]  do_one_initcall+0x50/0x1b0
[    5.231262]  kernel_init_freeable+0x218/0x29c
[    5.235609]  kernel_init+0x28/0x130
[    5.239088]  ret_from_fork+0x10/0x18
[    5.242651] ---[ end trace b5c781c0b33f84b6 ]---
[    5.247276] ------------[ cut here ]------------
[    5.251890] refcount_t: saturated; leaking memory.
[    5.256679] WARNING: CPU: 7 PID: 1 at lib/refcount.c:22 refcount_warn_saturate+0x78/0x150
[    5.264846] Modules linked in:
[    5.267889] CPU: 7 PID: 1 Comm: swapper/0 Tainted: G        W         5.14.0-rc3-00864-g10b91fc2a425 #957
[    5.277441] Hardware name: NXP Layerscape LX2160ARDB (DT)
[    5.282826] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[    5.288820] pc : refcount_warn_saturate+0x78/0x150
[    5.293599] lr : refcount_warn_saturate+0x78/0x150
[    5.298378] sp : ffff80001009b880
[    5.301681] x29: ffff80001009b880 x28: 0000000000000000 x27: ffff56018121b900
[    5.308806] x26: 0000000000000000 x25: ffff56018121b800 x24: 0000000000000000
[    5.315930] x23: 000000000100007f x22: ffffb6084ff072d8 x21: ffffb6084ff07000
[    5.323055] x20: 0000000000000001 x19: ffffb6084fe657c0 x18: 0000000000000000
[    5.330180] x17: 0000000000000001 x16: 0000000000000019 x15: 0000000000000030
[    5.337304] x14: 0000000000000000 x13: ffffb6084fbb34c8 x12: 0000000000000702
[    5.344429] x11: 0000000000000256 x10: ffffb6084fc0b4c8 x9 : 00000000fffff000
[    5.351554] x8 : ffffb6084fbb34c8 x7 : ffffb6084fc0b4c8 x6 : 0000000000000000
[    5.358678] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000ffffffff
[    5.365802] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff560180248000
[    5.372927] Call trace:
[    5.375361]  refcount_warn_saturate+0x78/0x150
[    5.379793]  fib_create_info+0xb70/0xc90
[    5.383704]  fib_table_insert+0x8c/0x620
[    5.387616]  fib_magic.isra.0+0x110/0x11c
[    5.391614]  fib_add_ifaddr+0x114/0x190
[    5.395438]  fib_inetaddr_event+0x8c/0x140
[    5.399522]  blocking_notifier_call_chain+0x70/0xac
[    5.404389]  __inet_insert_ifa+0x224/0x310
[    5.408473]  inetdev_event+0x54c/0x75c
[    5.412210]  raw_notifier_call_chain+0x58/0x80
[    5.416642]  call_netdevice_notifiers_info+0x58/0xac
[    5.421594]  __dev_notify_flags+0x50/0xcc
[    5.425593]  dev_change_flags+0x50/0x6c
[    5.429417]  ip_auto_config+0x1a8/0xe84
[    5.433241]  do_one_initcall+0x50/0x1b0
[    5.437064]  kernel_init_freeable+0x218/0x29c
[    5.441410]  kernel_init+0x28/0x130
[    5.444887]  ret_from_fork+0x10/0x18
[    5.448450] ---[ end trace b5c781c0b33f84b7 ]---
[    5.453084] ------------[ cut here ]------------
[    5.457695] refcount_t: underflow; use-after-free.
[    5.462481] WARNING: CPU: 7 PID: 1 at lib/refcount.c:28 refcount_warn_saturate+0xf8/0x150
[    5.470648] Modules linked in:
[    5.473690] CPU: 7 PID: 1 Comm: swapper/0 Tainted: G        W         5.14.0-rc3-00864-g10b91fc2a425 #957
[    5.483243] Hardware name: NXP Layerscape LX2160ARDB (DT)
[    5.488628] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[    5.494622] pc : refcount_warn_saturate+0xf8/0x150
[    5.499401] lr : refcount_warn_saturate+0xf8/0x150
[    5.504180] sp : ffff80001009b9e0
[    5.507481] x29: ffff80001009b9e0 x28: 00000000ffffffef x27: 000000007f000001
[    5.514607] x26: ffff560182d06020 x25: ffff80001009baf8 x24: ffff56018146f0b0
[    5.521731] x23: ffff56018121b800 x22: 0000000000000020 x21: ffffb6084ff07000
[    5.528856] x20: ffffb6084ff072d8 x19: ffff56018121b800 x18: 0000000000000000
[    5.535980] x17: 0000000000000001 x16: 0000000000000019 x15: 0000000000000030
[    5.543105] x14: 0000000000000000 x13: ffffb6084fbb34c8 x12: 000000000000077a
[    5.550230] x11: 000000000000027e x10: ffffb6084fc0b4c8 x9 : 00000000fffff000
[    5.557354] x8 : ffffb6084fbb34c8 x7 : ffffb6084fc0b4c8 x6 : 0000000000000000
[    5.564479] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000ffffffff
[    5.571604] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff560180248000
[    5.578728] Call trace:
[    5.581162]  refcount_warn_saturate+0xf8/0x150
[    5.585594]  fib_release_info+0x190/0x1d0
[    5.589592]  fib_table_insert+0x108/0x620
[    5.593590]  fib_magic.isra.0+0x110/0x11c
[    5.597588]  fib_add_ifaddr+0xb8/0x190
[    5.601325]  fib_netdev_event+0xd4/0x1cc
[    5.605236]  raw_notifier_call_chain+0x58/0x80
[    5.609669]  call_netdevice_notifiers_info+0x58/0xac
[    5.614621]  __dev_notify_flags+0x50/0xcc
[    5.618619]  dev_change_flags+0x50/0x6c
[    5.622443]  ip_auto_config+0x1a8/0xe84
[    5.626267]  do_one_initcall+0x50/0x1b0
[    5.630091]  kernel_init_freeable+0x218/0x29c
[    5.634437]  kernel_init+0x28/0x130
[    5.637914]  ret_from_fork+0x10/0x18
[    5.641477] ---[ end trace b5c781c0b33f84b8 ]---


-Ioana
