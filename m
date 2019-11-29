Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA3610D195
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 07:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfK2Gv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 01:51:28 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44720 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfK2Gv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 01:51:26 -0500
Received: by mail-lj1-f194.google.com with SMTP id c19so3750609lji.11
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 22:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=JZMvL0f6siu2EQR8xtwLFxytk4Sky8T02TEnanj5WMo=;
        b=ju2/6J8MAWR+QKWt0ApegWwS8bHPDr7cYHcJ3eD1WZ1UI/5nCGcVDaN8sj+KUzxOC+
         lvvg8GqZSVZfEN6Kno4+vUFXUH2d+AhPi2WHGOTZUef4bH3aBtdWRB+VpWvG1SKP/0aC
         Lxp2634iyPvBTgIUJP8t1igGhTvGmXcP5k+8kwd0y4HImmY/gqywGTsWaqWRGZo6RJ2X
         BxKb/HNG05JQ8R8jg9W8WhK5icrCzj/wcuIMYtrijfBhUkn4GU45FglRK0Z6uJA0J9Xb
         aOpB8OfxW3rUNfCprTkg303IYzwSpvVk2i2rG/ZrUPqZWc0IVHKtuoz8HMBeElmaI0Wm
         x39Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=JZMvL0f6siu2EQR8xtwLFxytk4Sky8T02TEnanj5WMo=;
        b=jABotoPLxPeomph0dRI0u1mu7SIdjYYDXEhTUB5z5XGCDT6RHjwR90aqsK7HHVlN7q
         givAJ1SXSWDtyIf8mK8wp22GWcsAXwf/rwvFJ584Vk8CTFJMXmz0Wde04bTQbVT0ibHc
         KfxxHMuBDQ7SbGtCACunR0f/lnSL97WX6GNQywtO5G1COJZVwNTr5EwWeTaje1efKMl2
         B+Z4MLObnjRYuTagnSe2x2/OJ9mfoGVEbf4WhHkObOJnHs9kBoB+atapQ1hRuq4wjOFG
         mTHG4/cTy/oSTa+jE71Xr1KzgTk6vm4NF4FKeVLPTPWO/NWrZlvwI2S0E+4vlhh5co4u
         QhBA==
X-Gm-Message-State: APjAAAVYRm8V6oYMy1dzGG0OZg4l5zztUfXQSRFymxZISIiCwNmG8Gob
        7rPBnOXUZmQh3X+9Hye4gvMRbA==
X-Google-Smtp-Source: APXvYqytx8SUPD0LF/dqNkmIXB8Bkom44b0URpZauegEHJU3geOQQ8bX2n8oF2qbOen8UOjp4PbDUQ==
X-Received: by 2002:a2e:b4da:: with SMTP id r26mr920707ljm.153.1575010281110;
        Thu, 28 Nov 2019 22:51:21 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id x64sm4504893ljb.39.2019.11.28.22.51.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Nov 2019 22:51:20 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        YueHaibing <yuehaibing@huawei.com>, Julian Anastasov <ja@ssi.bg>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, Hulk Robot <hulkci@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
References: <0000000000007d22100573d66078@google.com>
        <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg>
        <ace19af4-7cae-babd-bac5-cd3505dcd874@I-love.SAKURA.ne.jp>
Date:   Fri, 29 Nov 2019 08:51:19 +0200
In-Reply-To: <ace19af4-7cae-babd-bac5-cd3505dcd874@I-love.SAKURA.ne.jp>
        (Tetsuo Handa's message of "Thu, 28 Nov 2019 18:56:21 +0900")
Message-ID: <87eexrqioo.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> Hello people involved in commit a3e23f719f5c4a38 ("net-sysfs: call dev_hold if kobject_init_and_add success")
> and commit b8eb718348b8fb30 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject").
>
> syzbot is reporting that unregister_netdevice() hangs due to underflowing
> device refcount when kobject_init_and_add() failed due to -ENOMEM.
>
> ----------
> 11:25:02 executing program 3 (fault-call:5 fault-nth:2):
> r0 = openat$tun(0xffffffffffffff9c, &(0x7f0000000100)='/dev/net/tun\x00', 0x0, 0x0)
> ioctl$TUNSETIFF(r0, 0x400454ca, &(0x7f0000000000)={'vet\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbdh\x00', 0x43732e5398416f1a})
> ioctl$TUNSETQUEUE(r0, 0x400454d9, &(0x7f00000000c0)={'\x00', 0x400})
> r1 = openat$tun(0xffffffffffffff9c, &(0x7f0000000080)='/dev/net/tun\x00', 0x0, 0x0)
> ioctl$TUNSETIFF(r1, 0x400454ca, &(0x7f0000000000)={'vet\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbdh\x00', 0x43732e5398416f1a})
> ioctl$TUNSETQUEUE(r0, 0x400454d9, &(0x7f0000000040)={'lo\x00', 0x200})
> ----------
>
> ----------
> [   60.043899] IPVS: ftp: loaded support on port[0] = 21
> [   60.275782] chnl_net:caif_netlink_parms(): no params data found
> [   60.305039] bridge0: port 1(bridge_slave_0) entered blocking state
> [   60.305551] bridge0: port 1(bridge_slave_0) entered disabled state
> [   60.306366] device bridge_slave_0 entered promiscuous mode
> [   60.311776] bridge0: port 2(bridge_slave_1) entered blocking state
> [   60.312032] bridge0: port 2(bridge_slave_1) entered disabled state
> [   60.312858] device bridge_slave_1 entered promiscuous mode
> [   60.336705] bond0: (slave bond_slave_0): Enslaving as an active interface with an up link
> [   60.338321] bond0: (slave bond_slave_1): Enslaving as an active interface with an up link
> [   60.357851] team0: Port device team_slave_0 added
> [   60.359250] team0: Port device team_slave_1 added
> [   60.522829] device hsr_slave_0 entered promiscuous mode
> [   60.651798] device hsr_slave_1 entered promiscuous mode
> [   60.790287] netdevsim netdevsim0 netdevsim0: renamed from eth0
> [   60.854953] netdevsim netdevsim0 netdevsim1: renamed from eth1
> [   60.911733] netdevsim netdevsim0 netdevsim2: renamed from eth2
> [   60.974063] netdevsim netdevsim0 netdevsim3: renamed from eth3
> [   61.109590] bridge0: port 2(bridge_slave_1) entered blocking state
> [   61.109922] bridge0: port 2(bridge_slave_1) entered forwarding state
> [   61.110384] bridge0: port 1(bridge_slave_0) entered blocking state
> [   61.110556] bridge0: port 1(bridge_slave_0) entered forwarding state
> [   61.151643] 8021q: adding VLAN 0 to HW filter on device bond0
> [   61.156692] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
> [   61.164101] bridge0: port 1(bridge_slave_0) entered disabled state
> [   61.190521] bridge0: port 2(bridge_slave_1) entered disabled state
> [   61.230466] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
> [   61.283759] 8021q: adding VLAN 0 to HW filter on device team0
> [   61.364323] IPv6: ADDRCONF(NETDEV_CHANGE): bridge_slave_0: link becomes ready
> [   61.366383] bridge0: port 1(bridge_slave_0) entered blocking state
> [   61.366568] bridge0: port 1(bridge_slave_0) entered forwarding state
> [   61.367033] IPv6: ADDRCONF(NETDEV_CHANGE): bridge_slave_1: link becomes ready
> [   61.367556] bridge0: port 2(bridge_slave_1) entered blocking state
> [   61.367727] bridge0: port 2(bridge_slave_1) entered forwarding state
> [   61.372342] IPv6: ADDRCONF(NETDEV_CHANGE): team_slave_0: link becomes ready
> [   61.377760] IPv6: ADDRCONF(NETDEV_CHANGE): team_slave_1: link becomes ready
> [   61.381755] IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_0: link becomes ready
> [   61.383474] IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_1: link becomes ready
> [   61.386511] IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
> [   61.405483] 8021q: adding VLAN 0 to HW filter on device batadv0
> [   61.408968] IPv6: ADDRCONF(NETDEV_CHANGE): team0: link becomes ready
> [   61.412478] IPv6: ADDRCONF(NETDEV_CHANGE): vxcan1: link becomes ready
> [   61.414712] IPv6: ADDRCONF(NETDEV_CHANGE): vxcan0: link becomes ready
> [   61.466051] FAULT_INJECTION: forcing a failure.
>                name failslab, interval 1, probability 0, space 0, times 1
> [   61.468544] CPU: 6 PID: 6365 Comm: syz-executor Not tainted 5.4.0+ #223
> [   61.469778] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/29/2019
> [   61.473052] Call Trace:
> [   61.475277]  dump_stack+0x163/0x1d5
> [   61.476597]  should_fail+0x655/0x740
> [   61.477847]  ? fault_create_debugfs_attr+0x170/0x170
> [   61.479192]  ? ___might_sleep+0x1de/0x500
> [   61.480520]  __should_failslab+0xde/0x130
> [   61.481834]  should_failslab+0x9/0x14
> [   61.483145]  kmem_cache_alloc+0x28e/0x770
> [   61.484448]  ? memcpy+0x45/0x50
> [   61.486397]  ? kstrdup+0x59/0x70
> [   61.488702]  __kernfs_new_node+0xde/0x6f0
> [   61.490999]  ? kernfs_dop_revalidate+0x380/0x380
> [   61.493038]  ? __put_user_ns+0x60/0x60
> [   61.495621]  ? mark_lock+0x11f/0xc60
> [   61.497768]  ? put_dec+0xc0/0xc0
> [   61.499926]  kernfs_new_node+0x97/0x110
> [   61.501971]  kernfs_create_dir_ns+0x4d/0x150
> [   61.504019]  sysfs_create_dir_ns+0x13b/0x2a0
> [   61.505973]  ? sysfs_create_mount_point+0xb0/0xb0
> [   61.507978]  ? rwlock_bug.part.2+0x90/0x90
> [   61.509917]  ? lock_acquire+0x19f/0x3f0
> [   61.511893]  ? __kasan_check_read+0x11/0x20
> [   61.513887]  ? do_raw_spin_unlock+0x54/0x260
> [   61.515829]  kobject_add_internal+0x223/0x9a0
> [   61.517825]  kobject_init_and_add+0xff/0x170
> [   61.519811]  ? kset_create_and_add+0x180/0x180
> [   61.521849]  ? lock_acquire+0x19f/0x3f0
> [   61.523865]  ? rtnl_lock+0x17/0x20
> [   61.525787]  netdev_queue_update_kobjects+0xeb/0x370
> [   61.527816]  netif_set_real_num_tx_queues+0x188/0x740
> [   61.530219]  ? mutex_lock_io_nested+0x14b0/0x14b0
> [   61.532255]  tun_attach+0x4bd/0x1250
> [   61.534231]  ? lock_acquire+0x19f/0x3f0
> [   61.536130]  __tun_chr_ioctl+0x6fd/0x3b50
> [   61.537960]  ? tun_flow_update+0xba0/0xba0
> [   61.539709]  ? __kasan_check_read+0x11/0x20
> [   61.541376]  ? mark_lock+0x11f/0xc60
> [   61.543057]  ? _kstrtoull+0x11c/0x1c0
> [   61.544725]  ? __kasan_check_read+0x11/0x20
> [   61.546556]  ? __lock_acquire+0xc5c/0x3b30
> [   61.548282]  ? __kasan_check_read+0x11/0x20
> [   61.550033]  ? mark_lock+0x11f/0xc60
> [   61.551749]  ? __kasan_check_read+0x11/0x20
> [   61.553502]  ? __lock_acquire+0xc5c/0x3b30
> [   61.555247]  ? __fget+0x31c/0x4d0
> [   61.556976]  ? tun_chr_compat_ioctl+0x50/0x50
> [   61.558743]  tun_chr_ioctl+0x2a/0x40
> [   61.560255]  ? tun_chr_ioctl+0x2a/0x40
> [   61.562490]  do_vfs_ioctl+0x1a2/0x1150
> [   61.564138]  ? rcu_read_lock_held+0x9c/0xb0
> [   61.565830]  ? ioctl_preallocate+0x1e0/0x1e0
> [   61.567495]  ? __fget+0x33e/0x4d0
> [   61.569168]  ? do_dup2+0x4d0/0x4d0
> [   61.570928]  ? fput_many+0xe6/0x150
> [   61.572618]  ? fput+0x1a/0x20
> [   61.574382]  ? security_file_ioctl+0x81/0xb0
> [   61.576049]  ksys_ioctl+0x94/0xb0
> [   61.577783]  __x64_sys_ioctl+0x73/0xb0
> [   61.579526]  do_syscall_64+0xde/0x6c0
> [   61.581302]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [   61.583010] RIP: 0033:0x45a729
> [   61.584734] Code: bd b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> [   61.590407] RSP: 002b:00007f25d540ec88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [   61.592488] RAX: ffffffffffffffda RBX: 000000000071bf00 RCX: 000000000045a729
> [   61.594552] RDX: 0000000020000040 RSI: 00000000400454d9 RDI: 0000000000000003
> [   61.596829] RBP: 00007f25d540eca0 R08: 0000000000000000 R09: 0000000000000000
> [   61.598540] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f25d540f6d4
> [   61.600278] R13: 00000000004ac5a5 R14: 00000000006ee8a0 R15: 0000000000000005
> [   61.655323] kobject_add_internal failed for tx-1 (error: -12 parent: queues)
> [   71.760970] unregister_netdevice: waiting for vet to become free. Usage count = -1
> [   82.028434] unregister_netdevice: waiting for vet to become free. Usage count = -1
> [   92.140031] unregister_netdevice: waiting for vet to become free. Usage count = -1
> ----------
>
> Worrisome part is that tun_attach() calls tun_set_real_num_queues() at the end of tun_attach()
> but tun_set_real_num_queues() is not handling netif_set_real_num_tx_queues() failure.
> That is, tun_attach() is returning success even if netdev_queue_update_kobjects() from
> netif_set_real_num_tx_queues() failed.
>
>   static void tun_set_real_num_queues(struct tun_struct *tun)
>   {
>           netif_set_real_num_tx_queues(tun->dev, tun->numqueues);
>           netif_set_real_num_rx_queues(tun->dev, tun->numqueues);
>   }
>
> And I guess that ignoring that failure causes clean-up function to drop a refcount
> which was not held by initialization function. Applying below diff seems to avoid
> this problem. Please check.
>
> ----------
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index ae3bcb1540ec..562d06c274aa 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1459,14 +1459,14 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
>  	struct kobject *kobj = &queue->kobj;
>  	int error = 0;
>  
> +	dev_hold(queue->dev);
> +
>  	kobj->kset = dev->queues_kset;
>  	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
>  				     "tx-%u", index);
>  	if (error)
>  		goto err;
>  
> -	dev_hold(queue->dev);
> -
>  #ifdef CONFIG_BQL
>  	error = sysfs_create_group(kobj, &dql_group);
>  	if (error)

I think this is workaround for the issue you pointed out above. I'll
guess we need to implement proper error handling for
netif_set_real_num_tx_queues to avoid this regression. I was a bit concerned
there is something relying netdev_queue_add_kobject and
rx_queue_add_kobject not freeing the reference. This was
it... Reproducer here would help.

> ----------
>
> ----------
> [   64.482925] IPVS: ftp: loaded support on port[0] = 21
> [   64.684701] chnl_net:caif_netlink_parms(): no params data found
> [   64.757440] bridge0: port 1(bridge_slave_0) entered blocking state
> [   64.757596] bridge0: port 1(bridge_slave_0) entered disabled state
> [   64.760043] device bridge_slave_0 entered promiscuous mode
> [   64.761799] bridge0: port 2(bridge_slave_1) entered blocking state
> [   64.762025] bridge0: port 2(bridge_slave_1) entered disabled state
> [   64.793334] device bridge_slave_1 entered promiscuous mode
> [   64.818373] bond0: (slave bond_slave_0): Enslaving as an active interface with an up link
> [   64.822950] bond0: (slave bond_slave_1): Enslaving as an active interface with an up link
> [   64.843403] team0: Port device team_slave_0 added
> [   64.844859] team0: Port device team_slave_1 added
> [   64.933830] device hsr_slave_0 entered promiscuous mode
> [   64.972990] device hsr_slave_1 entered promiscuous mode
> [   65.048057] netdevsim netdevsim0 netdevsim0: renamed from eth0
> [   65.113612] netdevsim netdevsim0 netdevsim1: renamed from eth1
> [   65.191758] netdevsim netdevsim0 netdevsim2: renamed from eth2
> [   65.262611] netdevsim netdevsim0 netdevsim3: renamed from eth3
> [   65.339507] bridge0: port 2(bridge_slave_1) entered blocking state
> [   65.339821] bridge0: port 2(bridge_slave_1) entered forwarding state
> [   65.340340] bridge0: port 1(bridge_slave_0) entered blocking state
> [   65.340514] bridge0: port 1(bridge_slave_0) entered forwarding state
> [   65.486729] 8021q: adding VLAN 0 to HW filter on device bond0
> [   65.545043] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
> [   65.567266] bridge0: port 1(bridge_slave_0) entered disabled state
> [   65.592695] bridge0: port 2(bridge_slave_1) entered disabled state
> [   65.631471] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
> [   65.656557] 8021q: adding VLAN 0 to HW filter on device team0
> [   65.660768] IPv6: ADDRCONF(NETDEV_CHANGE): veth0_to_bridge: link becomes ready
> [   65.661411] IPv6: ADDRCONF(NETDEV_CHANGE): bridge_slave_0: link becomes ready
> [   65.661949] bridge0: port 1(bridge_slave_0) entered blocking state
> [   65.662127] bridge0: port 1(bridge_slave_0) entered forwarding state
> [   65.693984] IPv6: ADDRCONF(NETDEV_CHANGE): veth1_to_bridge: link becomes ready
> [   65.697297] IPv6: ADDRCONF(NETDEV_CHANGE): bridge_slave_1: link becomes ready
> [   65.701488] bridge0: port 2(bridge_slave_1) entered blocking state
> [   65.703895] bridge0: port 2(bridge_slave_1) entered forwarding state
> [   65.706370] IPv6: ADDRCONF(NETDEV_CHANGE): veth0_to_bond: link becomes ready
> [   65.724296] hsr0: Slave A (hsr_slave_0) is not up; please bring it up to get a fully working HSR network
> [   65.728690] hsr0: Slave B (hsr_slave_1) is not up; please bring it up to get a fully working HSR network
> [   65.777203] IPv6: ADDRCONF(NETDEV_CHANGE): veth1_to_bond: link becomes ready
> [   65.782476] IPv6: ADDRCONF(NETDEV_CHANGE): veth0_to_team: link becomes ready
> [   65.785989] IPv6: ADDRCONF(NETDEV_CHANGE): team_slave_0: link becomes ready
> [   65.789006] IPv6: ADDRCONF(NETDEV_CHANGE): veth1_to_team: link becomes ready
> [   65.796973] IPv6: ADDRCONF(NETDEV_CHANGE): team_slave_1: link becomes ready
> [   65.801313] IPv6: ADDRCONF(NETDEV_CHANGE): veth0_to_hsr: link becomes ready
> [   65.804748] IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_0: link becomes ready
> [   65.807939] IPv6: ADDRCONF(NETDEV_CHANGE): veth1_to_hsr: link becomes ready
> [   65.811874] IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_1: link becomes ready
> [   65.814814] IPv6: ADDRCONF(NETDEV_CHANGE): team0: link becomes ready
> [   65.824311] IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
> [   65.835888] 8021q: adding VLAN 0 to HW filter on device batadv0
> [   65.840711] IPv6: ADDRCONF(NETDEV_CHANGE): vxcan1: link becomes ready
> [   65.843289] IPv6: ADDRCONF(NETDEV_CHANGE): vxcan0: link becomes ready
> [   66.055083] FAULT_INJECTION: forcing a failure.
>                name failslab, interval 1, probability 0, space 0, times 1
> [   66.058933] CPU: 1 PID: 6375 Comm: syz-executor Not tainted 5.4.0+ #224
> [   66.060904] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/29/2019
> [   66.065868] Call Trace:
> [   66.068993]  dump_stack+0x163/0x1d5
> [   66.071611]  should_fail+0x655/0x740
> [   66.074082]  ? fault_create_debugfs_attr+0x170/0x170
> [   66.076772]  ? ___might_sleep+0x1de/0x500
> [   66.079324]  __should_failslab+0xde/0x130
> [   66.082540]  should_failslab+0x9/0x14
> [   66.084806]  kmem_cache_alloc+0x28e/0x770
> [   66.087262]  ? memcpy+0x45/0x50
> [   66.089712]  ? kstrdup+0x59/0x70
> [   66.092133]  __kernfs_new_node+0xde/0x6f0
> [   66.094512]  ? kernfs_dop_revalidate+0x380/0x380
> [   66.096934]  ? __put_user_ns+0x60/0x60
> [   66.099303]  ? mark_lock+0x11f/0xc60
> [   66.101585]  ? put_dec+0xc0/0xc0
> [   66.104388]  kernfs_new_node+0x97/0x110
> [   66.106537]  kernfs_create_dir_ns+0x4d/0x150
> [   66.108622]  sysfs_create_dir_ns+0x13b/0x2a0
> [   66.110584]  ? sysfs_create_mount_point+0xb0/0xb0
> [   66.112769]  ? rwlock_bug.part.2+0x90/0x90
> [   66.114866]  ? lock_acquire+0x19f/0x3f0
> [   66.116925]  ? __kasan_check_read+0x11/0x20
> [   66.118888]  ? do_raw_spin_unlock+0x54/0x260
> [   66.120909]  kobject_add_internal+0x223/0x9a0
> [   66.122835]  kobject_init_and_add+0xff/0x170
> [   66.124860]  ? kset_create_and_add+0x180/0x180
> [   66.126944]  ? lock_acquire+0x19f/0x3f0
> [   66.129143]  ? rtnl_lock+0x17/0x20
> [   66.131087]  netdev_queue_update_kobjects+0x118/0x390
> [   66.133028]  ? __kasan_check_read+0x11/0x20
> [   66.134944]  netif_set_real_num_tx_queues+0x188/0x740
> [   66.137012]  ? mutex_lock_io_nested+0x14b0/0x14b0
> [   66.139043]  tun_attach+0x4bd/0x1250
> [   66.140950]  ? lock_acquire+0x19f/0x3f0
> [   66.142870]  __tun_chr_ioctl+0x6fd/0x3b50
> [   66.144724]  ? tun_flow_update+0xba0/0xba0
> [   66.146532]  ? __kasan_check_read+0x11/0x20
> [   66.148821]  ? mark_lock+0x11f/0xc60
> [   66.150635]  ? _kstrtoull+0x11c/0x1c0
> [   66.152399]  ? __kasan_check_read+0x11/0x20
> [   66.154056]  ? __lock_acquire+0xc5c/0x3b30
> [   66.155701]  ? __kasan_check_read+0x11/0x20
> [   66.157438]  ? mark_lock+0x11f/0xc60
> [   66.159265]  ? __kasan_check_read+0x11/0x20
> [   66.161032]  ? __lock_acquire+0xc5c/0x3b30
> [   66.162885]  ? __fget+0x31c/0x4d0
> [   66.164619]  ? tun_chr_compat_ioctl+0x50/0x50
> [   66.166104]  tun_chr_ioctl+0x2a/0x40
> [   66.167538]  ? tun_chr_ioctl+0x2a/0x40
> [   66.169199]  do_vfs_ioctl+0x1a2/0x1150
> [   66.170969]  ? rcu_read_lock_held+0x9c/0xb0
> [   66.172735]  ? ioctl_preallocate+0x1e0/0x1e0
> [   66.174487]  ? __fget+0x33e/0x4d0
> [   66.176170]  ? do_dup2+0x4d0/0x4d0
> [   66.177866]  ? fput_many+0xe6/0x150
> [   66.179520]  ? fput+0x1a/0x20
> [   66.181176]  ? security_file_ioctl+0x81/0xb0
> [   66.182909]  ksys_ioctl+0x94/0xb0
> [   66.184452]  __x64_sys_ioctl+0x73/0xb0
> [   66.186169]  do_syscall_64+0xde/0x6c0
> [   66.187908]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [   66.189678] RIP: 0033:0x45a729
> [   66.191328] Code: bd b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> [   66.196839] RSP: 002b:00007f08f9987c88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [   66.198849] RAX: ffffffffffffffda RBX: 000000000071bf00 RCX: 000000000045a729
> [   66.200876] RDX: 0000000020000040 RSI: 00000000400454d9 RDI: 0000000000000003
> [   66.202947] RBP: 00007f08f9987ca0 R08: 0000000000000000 R09: 0000000000000000
> [   66.204491] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f08f99886d4
> [   66.205688] R13: 00000000004ac5a5 R14: 00000000006ee8a0 R15: 0000000000000005
> [   66.277453] kobject_add_internal failed for tx-1 (error: -12 parent: queues)
> [   67.499501] syz-executor (6368) used greatest stack depth: 23704 bytes left
> [   70.237146] tipc: TX() has been purged, node left!
> [   75.794671] device bridge_slave_1 left promiscuous mode
> [   75.797354] bridge0: port 2(bridge_slave_1) entered disabled state
> [   75.861863] device bridge_slave_0 left promiscuous mode
> [   75.864646] bridge0: port 1(bridge_slave_0) entered disabled state
> [   79.752910] device hsr_slave_0 left promiscuous mode
> [   79.841067] device hsr_slave_1 left promiscuous mode
> [   79.939879] team0 (unregistering): Port device team_slave_1 removed
> [   79.963767] team0 (unregistering): Port device team_slave_0 removed
> [   79.985156] bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
> [   80.090348] bond0 (unregistering): (slave bond_slave_0): Releasing backup interface
> [   80.352617] bond0 (unregistering): Released all slaves
> ----------
