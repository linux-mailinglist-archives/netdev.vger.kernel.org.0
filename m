Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DB92F2443
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405447AbhALAZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404175AbhAKXl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:41:29 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9206EC061795
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 15:40:49 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id n3so637160pjm.1
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 15:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O4eq9/zEyU5m5jpTuAyODmcjX40raNxTqujZe3if79c=;
        b=c/L9d7/6p3lK+C7PYADOMc/selaFxjJFNQO3SuEIL0GWo5lcf5phUuJRXq9b+3VOVT
         0X9lhQS1bUt5j2gpIkwfjxxJ6rwW3FM080HKLTDn9MTShuIuDKTbKHkPqiLt1a2J3Fzj
         82jjNSBnTI+Qt7X1ubTxKytxv7sGSlKxkf27oMMleybTddEYYuQc/r8G22FL8l80mulz
         XMpQN4sVGEIwbd1RvGFuq2EasQwh+EAjBzsrWePIMJsp/XnyDkoddXHMpn4dbXctdpnl
         n9bvadqndXirwmxQeZRfZ2NgiYJE3OfbvacfFN3PbE8MSx5eCU3USvqYNeqMZ5nCzzYN
         Gf7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=O4eq9/zEyU5m5jpTuAyODmcjX40raNxTqujZe3if79c=;
        b=ofkA1UYP6GTlZCRo3GZqyoe/55JXFqbOIFfbUR0JpaR1g3qgd1Ijc9BKhg7cihqfWa
         /GKEf+VYOXkX/A3PL9cnuqP75lyu99aTTrQzBgil8Q4P6LA8t2GTvivRtaYuTw4ESDe7
         YTx08cvwcUi0TCXNiz9DX/io/P2G5tXWsoE22UBtX5StuMcdXPCcWxAVSd+RRe7BvbWg
         6Q81zAvPLtUzeaNlTvTywNm5/RoTd1nfibiluwnCA3yosvvWx5fcponX5JH3PQ5nU1U9
         cWwlz3MCcdr/Y6nm5BLvuYUATfxDqAUij87509A1A4eDd4vU+bKzD5Yy+JlFGuh8veuG
         +img==
X-Gm-Message-State: AOAM530vF32YvmWeHUgN/ejtl2nQfodREBuHBZLZs/bsKfFLhBNS7tNI
        DT+NmjFw2CA6h/i7Ucd7hDk=
X-Google-Smtp-Source: ABdhPJx78ChPX1gnbLIcbdVlYy0L2RhbQDCXVMj2aSObGjcb7yk+uGPthHqvg5jS6u9DwblXTF0CqA==
X-Received: by 2002:a17:90a:c789:: with SMTP id gn9mr641228pjb.101.1610408448931;
        Mon, 11 Jan 2021 15:40:48 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q12sm874646pgj.24.2021.01.11.15.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 15:40:48 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: unbind all switches from tree when DSA
 master unbinds
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com
References: <20210111230943.3701806-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <3ec90588-2e42-e9ca-8565-252667ca5fb4@gmail.com>
Date:   Mon, 11 Jan 2021 15:40:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210111230943.3701806-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 3:09 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently the following happens when a DSA master driver unbinds while
> there are DSA switches attached to it:
> 
> $ echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 392 at net/core/dev.c:9507
> Call trace:
>  rollback_registered_many+0x5fc/0x688
>  unregister_netdevice_queue+0x98/0x120
>  dsa_slave_destroy+0x4c/0x88
>  dsa_port_teardown.part.16+0x78/0xb0
>  dsa_tree_teardown_switches+0x58/0xc0
>  dsa_unregister_switch+0x104/0x1b8
>  felix_pci_remove+0x24/0x48
>  pci_device_remove+0x48/0xf0
>  device_release_driver_internal+0x118/0x1e8
>  device_driver_detach+0x28/0x38
>  unbind_store+0xd0/0x100
> 
> Located at the above location is this WARN_ON:
> 
> 	/* Notifier chain MUST detach us all upper devices. */
> 	WARN_ON(netdev_has_any_upper_dev(dev));
> 
> Other stacked interfaces, like VLAN, do indeed listen for
> NETDEV_UNREGISTER on the real_dev and also unregister themselves at that
> time, which is clearly the behavior that rollback_registered_many
> expects. But DSA interfaces are not VLAN. They have backing hardware
> (platform devices, PCI devices, MDIO, SPI etc) which have a life cycle
> of their own and we can't just trigger an unregister from the DSA
> framework when we receive a netdev notifier that the master unregisters.
> 
> Luckily, there is something we can do, and that is to inform the driver
> core that we have a runtime dependency to the DSA master interface's
> device, and create a device link where that is the supplier and we are
> the consumer. Having this device link will make the DSA switch unbind
> before the DSA master unbinds, which is enough to avoid the WARN_ON from
> rollback_registered_many.
> 
> Note that even before the blamed commit, DSA did nothing intelligent
> when the master interface got unregistered either. See the discussion
> here:
> https://lore.kernel.org/netdev/20200505210253.20311-1-f.fainelli@gmail.com/
> But this time, at least the WARN_ON is loud enough that the
> upper_dev_link commit can be blamed.
> 
> The advantage with this approach vs dev_hold(master) in the attached
> link is that the latter is not meant for long term reference counting.
> With dev_hold, the only thing that will happen is that when the user
> attempts an unbind of the DSA master, netdev_wait_allrefs will keep
> waiting and waiting, due to DSA keeping the refcount forever. DSA would
> not access freed memory corresponding to the master interface, but the
> unbind would still result in a freeze. Whereas with device links,
> graceful teardown is ensured. It even works with cascaded DSA trees.
> 
> $ echo 0000:00:00.2 > /sys/bus/pci/drivers/fsl_enetc/unbind
> [ 1818.797546] device swp0 left promiscuous mode
> [ 1819.301112] sja1105 spi2.0: Link is Down
> [ 1819.307981] DSA: tree 1 torn down
> [ 1819.312408] device eno2 left promiscuous mode
> [ 1819.656803] mscc_felix 0000:00:00.5: Link is Down
> [ 1819.667194] DSA: tree 0 torn down
> [ 1819.711557] fsl_enetc 0000:00:00.2 eno2: Link is Down
> 
> This approach allows us to keep the DSA framework absolutely unchanged,
> and the driver core will just know to unbind us first when the master
> goes away - as opposed to the large (and probably impossible) rework
> required if attempting to listen for NETDEV_UNREGISTER.
> 
> As per the documentation at Documentation/driver-api/device_link.rst,
> specifying the DL_FLAG_AUTOREMOVE_CONSUMER flag causes the device link
> to be automatically purged when the consumer fails to probe or later
> unbinds. So we don't need to keep the consumer_link variable in struct
> dsa_switch.
> 
> Fixes: 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA master to get rid of lockdep warnings")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Much nicer than dev_hold() indeed tested it and it works quite nicely in
exposing use after free bugs, on net-next/master I get the below warning
which I have not yet investigated whether it is legit or if this is ARM
32-bit's young KASAN days that are still make us find bugs that are not
bugs, cross checking with an ARM64 build right now.

# echo 9300000.ethernet > unbind
[   61.352514]
==================================================================
[   61.359856] BUG: KASAN: use-after-free in
devlink_nl_port_fill+0x578/0x7a8
[   61.366847] Read of size 4 at addr c7cf00a8 by task sh/249
[   61.372413]
[   61.373945] CPU: 1 PID: 249 Comm: sh Not tainted
5.11.0-rc2-g4b0dc83b4219 #132
[   61.381272] Hardware name: Broadcom STB (Flattened Device Tree)
[   61.387264] Backtrace:
[   61.389768] [<c10fd504>] (dump_backtrace) from [<c10fd7b4>]
(show_stack+0x20/0x24)
[   61.397498]  r7:c27d6f00 r6:40040093 r5:00000000 r4:c27d6f00
[   61.403226] [<c10fd794>] (show_stack) from [<c11047b8>]
(dump_stack+0xbc/0xe0)
[   61.410588] [<c11046fc>] (dump_stack) from [<c0462624>]
(print_address_description.constprop.2+0x3c/0x2e4)
[   61.420440]  r10:cbf6b500 r9:cb9a39e0 r8:cb9a3ac0 r7:00000000
r6:c0eb59d0 r5:ed6b8580
[   61.428372]  r4:c7cf00a8 r3:00000100
[   61.432003] [<c04625e8>] (print_address_description.constprop.2) from
[<c0462b28>] (kasan_report+0x1a4/0x1c0)
[   61.442106]  r8:cb9a3ac0 r7:00000000 r6:c0eb59d0 r5:00000004 r4:c7cf00a8
[   61.448883] [<c0462984>] (kasan_report) from [<c0463514>]
(__asan_load4+0x6c/0xbc)
[   61.456615]  r7:c7c1c860 r6:c7c1c864 r5:b8734730 r4:c7c1c83c
[   61.462345] [<c04634a8>] (__asan_load4) from [<c0eb59d0>]
(devlink_nl_port_fill+0x578/0x7a8)
[   61.470930] [<c0eb5458>] (devlink_nl_port_fill) from [<c0eb5e20>]
(devlink_port_notify+0x80/0x12c)
[   61.480057]  r10:00000003 r9:c7c1c8f8 r8:00000000 r7:c7bc1200
r6:00000008 r5:cbf6b500
[   61.487984]  r4:c7c1c83c
[   61.490566] [<c0eb5da0>] (devlink_port_notify) from [<c0eb6558>]
(devlink_port_unregister+0x5c/0x108)
[   61.499949]  r7:c7bbe378 r6:c7bc12b4 r5:c7c1c8dc r4:c7c1c83c
[   61.505678] [<c0eb64fc>] (devlink_port_unregister) from [<c0feef60>]
(dsa_switch_teardown.part.3+0x188/0x18c)
[   61.515785]  r9:c7c1c8f8 r8:00000000 r7:c7bbe378 r6:c7bbe348
r5:c7bbe340 r4:c7c1c800
[   61.523621] [<c0feedd8>] (dsa_switch_teardown.part.3) from
[<c0fef00c>] (dsa_tree_teardown_switches+0xa8/0xc4)
[   61.533827]  r9:c2824140 r8:c7bc381c r7:c7bc370c r6:c7bbe340
r5:c7bc381c r4:c7c1c800
[   61.541663] [<c0feef64>] (dsa_tree_teardown_switches) from
[<c0fef2cc>] (dsa_unregister_switch+0x124/0x250)
[   61.551597]  r7:c7bc370c r6:c7bc3814 r5:c7bbe340 r4:c7bc3800
[   61.557328] [<c0fef1a8>] (dsa_unregister_switch) from [<c0ba2f8c>]
(bcm_sf2_sw_remove+0x98/0x13c)
[   61.566388]  r10:00000003 r9:c2824140 r8:c387f844 r7:c387f848
r6:c7bb8e40 r5:c7bd3c88
[   61.574315]  r4:c7bd3c40
[   61.576895] [<c0ba2ef4>] (bcm_sf2_sw_remove) from [<c0a57ae8>]
(platform_remove+0x44/0x5c)
[   61.585333]  r7:c387f848 r6:c287aaf4 r5:c387f810 r4:c287aaf4
[   61.591063] [<c0a57aa4>] (platform_remove) from [<c0a54930>]
(device_release_driver_internal+0x150/0x254)
[   61.600807]  r5:c387e810 r4:c387f810
[   61.604438] [<c0a547e0>] (device_release_driver_internal) from
[<c0a4d040>] (device_links_unbind_consumers+0xf8/0x12c)
[   61.615327]  r9:c83ec9e8 r8:c2820bc0 r7:c387c810 r6:00000004
r5:c387c870 r4:c387f810
[   61.623162] [<c0a4cf48>] (device_links_unbind_consumers) from
[<c0a54864>] (device_release_driver_internal+0x84/0x254)
[   61.634053]  r10:c6de5c30 r9:cbc1d510 r8:c2824190 r7:c387c848
r6:c287db34 r5:c33dd010
[   61.641984]  r4:c387c810 r3:00000000
[   61.645614] [<c0a547e0>] (device_release_driver_internal) from
[<c0a54a88>] (device_driver_detach+0x30/0x34)
[   61.655631]  r9:cbc1d510 r8:c2824190 r7:c387c810 r6:00000011
r5:c287db34 r4:c387c810
[   61.663466] [<c0a54a58>] (device_driver_detach) from [<c0a514d8>]
(unbind_store+0x90/0x134)
[   61.671974]  r5:c287db34 r4:c2824140
[   61.675605] [<c0a51448>] (unbind_store) from [<c0a50108>]
(drv_attr_store+0x50/0x5c)
[   61.683510]  r9:cbc1d510 r8:cbc17b80 r7:00000011 r6:cbc17b80
r5:c6e19400 r4:c0a51448
[   61.691347] [<c0a500b8>] (drv_attr_store) from [<c055a0e4>]
(sysfs_kf_write+0x90/0x9c)
[   61.699427]  r7:c6e19400 r6:c6de5c30 r5:00000011 r4:c0a500b8
[   61.705156] [<c055a054>] (sysfs_kf_write) from [<c055885c>]
(kernfs_fop_write+0x178/0x2b4)
[   61.713594]  r9:cbc1d510 r8:cb9a3f20 r7:00000000 r6:00000000
r5:cbc1d500 r4:00000011
[   61.721430] [<c05586e4>] (kernfs_fop_write) from [<c0471aa0>]
(vfs_write+0x19c/0x644)
[   61.729431]  r10:00000000 r9:000e95b0 r8:cb9a3ea0 r7:cb9a3f20
r6:c05586e4 r5:cbf5a500
[   61.737357]  r4:b87347b4
[   61.739938] [<c0471904>] (vfs_write) from [<c04721a8>]
(ksys_write+0xd4/0x170)
[   61.747324]  r10:000e95b0 r9:00000000 r8:00000000 r7:cbf5a500
r6:c2606d48 r5:cbf5a500
[   61.755250]  r4:b87347e0
[   61.757832] [<c04720d4>] (ksys_write) from [<c047225c>]
(sys_write+0x18/0x1c)
[   61.765121]  r10:00000004 r9:cb9a0000 r8:c0200228 r7:00000004
r6:aec27d60 r5:000e95b0
[   61.773048]  r4:00000011
[   61.775629] [<c0472244>] (sys_write) from [<c0200060>]
(ret_fast_syscall+0x0/0x2c)
[   61.783341] Exception stack(0xcb9a3fa8 to 0xcb9a3ff0)
[   61.788480] 3fa0:                   00000011 000e95b0 00000001
000e95b0 00000011 00000001
[   61.796776] 3fc0: 00000011 000e95b0 aec27d60 00000004 00000011
000a7f7a 000c21b4 00000000
[   61.805064] 3fe0: 00000000 b66eda2c aeb5744c aebaf810
[   61.810185]
[   61.811715] Allocated by task 31:
[   61.815085]  kasan_save_stack+0x24/0x48
[   61.819001]  ____kasan_kmalloc.constprop.0+0x98/0xac
[   61.824056]  __kasan_kmalloc+0x10/0x14
[   61.827882]  __kmalloc+0x16c/0x2dc
[   61.831355]  kvmalloc_node+0x40/0x8c
[   61.835006]  alloc_netdev_mqs+0x5c/0x50c
[   61.839012]  dsa_slave_create+0x110/0x9c8
[   61.843102]  dsa_register_switch+0xdb0/0x13a4
[   61.847548]  b53_switch_register+0x47c/0x6dc
[   61.851906]  bcm_sf2_sw_probe+0xaa4/0xc98
[   61.855996]  platform_probe+0x90/0xf4
[   61.859741]  really_probe+0x184/0x728
[   61.863481]  driver_probe_device+0xa4/0x278
[   61.867745]  __device_attach_driver+0xe8/0x148
[   61.872274]  bus_for_each_drv+0x108/0x158
[   61.876361]  __device_attach+0x190/0x234
[   61.880362]  device_initial_probe+0x1c/0x20
[   61.884628]  bus_probe_device+0xdc/0xec
[   61.888540]  deferred_probe_work_func+0xd4/0x11c
[   61.893242]  process_one_work+0x420/0x8f8
[   61.897341]  worker_thread+0x4fc/0x91c
[   61.901174]  kthread+0x21c/0x22c
[   61.904478]  ret_from_fork+0x14/0x20
[   61.908125]  0x0
[   61.910014]
[   61.911543] Freed by task 249:
[   61.914652]  kasan_save_stack+0x24/0x48
[   61.918567]  kasan_set_track+0x30/0x38
[   61.922393]  kasan_set_free_info+0x30/0x3c
[   61.926575]  ____kasan_slab_free+0xec/0x110
[   61.930840]  __kasan_slab_free+0x14/0x18
[   61.934842]  kfree+0xbc/0x2a8
[   61.937877]  kvfree+0x34/0x38
[   61.940913]  netdev_freemem+0x30/0x34
[   61.944661]  netdev_release+0x48/0x50
[   61.948400]  device_release+0x5c/0x100
[   61.952234]  kobject_put+0x14c/0x2d8
[   61.955888]  put_device+0x20/0x24
[   61.959284]  free_netdev+0x170/0x194
[   61.962935]  dsa_slave_destroy+0xac/0xb0
[   61.966936]  dsa_port_teardown.part.2+0xa0/0xb4
[   61.971558]  dsa_tree_teardown_switches+0x50/0xc4
[   61.976354]  dsa_unregister_switch+0x124/0x250
[   61.980887]  bcm_sf2_sw_remove+0x98/0x13c
[   61.984977]  platform_remove+0x44/0x5c
[   61.988810]  device_release_driver_internal+0x150/0x254
[   61.994129]  device_links_unbind_consumers+0xf8/0x12c
[   61.999266]  device_release_driver_internal+0x84/0x254
[   62.004497]  device_driver_detach+0x30/0x34
[   62.008762]  unbind_store+0x90/0x134
[   62.012411]  drv_attr_store+0x50/0x5c
[   62.016145]  sysfs_kf_write+0x90/0x9c
[   62.019885]  kernfs_fop_write+0x178/0x2b4
[   62.023975]  vfs_write+0x19c/0x644
[   62.027452]  ksys_write+0xd4/0x170
[   62.030930]  sys_write+0x18/0x1c
[   62.034232]  ret_fast_syscall+0x0/0x2c
[   62.038056]  0xb66eda2c
[   62.040557]
[   62.042085] The buggy address belongs to the object at c7cf0000
[   62.042085]  which belongs to the cache kmalloc-2k of size 2048
[   62.054030] The buggy address is located 168 bytes inside of
[   62.054030]  2048-byte region [c7cf0000, c7cf0800)
[   62.064583] The buggy address belongs to the page:
[   62.069435] page:17c208db refcount:1 mapcount:0 mapping:00000000
index:0x0 pfn:0x47cf0
[   62.077462] head:17c208db order:3 compound_mapcount:0 compound_pincount:0
[   62.084334] flags: 0x4010200(slab|head)
[   62.088271] raw: 04010200 00000000 00000100 00000122 c3001800
00000000 00080008 00000000
[   62.096464] raw: ffffffff 00000001
[   62.099922] page dumped because: kasan: bad access detected
[   62.105562]
[   62.107089] Memory state around the buggy address:
[   62.111947]  c7ceff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   62.118558]  c7cf0000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   62.125168] >c7cf0080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   62.131770]                           ^
[   62.135667]  c7cf0100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   62.142278]  c7cf0180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   62.148880]
==================================================================
[   62.156183] Disabling lock debugging due to kernel taint
[   62.162744] DSA: tree 0 torn down
[   62.171251] brcm-systemport 9300000.ethernet eth0: Link is Down

PS: I realize that I never responded to my RFC but I believe that with a
cascaded switch what you were seeing was consistent in that to fully
unbind all the DSA peripherals you would have to unbind from the deepest
level all the way down to the DSA master.
-- 
Florian
