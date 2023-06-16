Return-Path: <netdev+bounces-11297-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92324732716
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:09:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FA321C20EA3
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 06:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AEBE10E4;
	Fri, 16 Jun 2023 06:09:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3297C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 06:09:34 +0000 (UTC)
X-Greylist: delayed 1138 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Jun 2023 23:09:32 PDT
Received: from mxout70.expurgate.net (mxout70.expurgate.net [194.37.255.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C6718D
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 23:09:31 -0700 (PDT)
Received: from [127.0.0.1] (helo=localhost)
	by relay.expurgate.net with smtp (Exim 4.92)
	(envelope-from <prvs=4545299912=ms@dev.tdt.de>)
	id 1qA2Ll-000CbM-0I; Fri, 16 Jun 2023 07:50:21 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
	by relay.expurgate.net with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ms@dev.tdt.de>)
	id 1qA2Lk-0004iX-2l; Fri, 16 Jun 2023 07:50:20 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
	by securemail.tdt.de (Postfix) with ESMTP id 8A7BA240049;
	Fri, 16 Jun 2023 07:50:19 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
	by securemail.tdt.de (Postfix) with ESMTP id 03DF9240040;
	Fri, 16 Jun 2023 07:50:19 +0200 (CEST)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
	by mail.dev.tdt.de (Postfix) with ESMTP id 61399303C8;
	Fri, 16 Jun 2023 07:50:18 +0200 (CEST)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Jun 2023 07:50:18 +0200
From: Martin Schiller <ms@dev.tdt.de>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net: lapbether: only support ethernet devices
Organization: TDT AG
In-Reply-To: <20230614161802.2715468-1-edumazet@google.com>
References: <20230614161802.2715468-1-edumazet@google.com>
Message-ID: <b5fad6a3fa34760feb9192b697887ac7@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.17
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 151534::1686894620-574D7361-4D9A49C9/0/0

On 2023-06-14 18:18, Eric Dumazet wrote:
> It probbaly makes no sense to support arbitrary network devices
> for lapbether.
> 
> syzbot reported:
> 
> skbuff: skb_under_panic: text:ffff80008934c100 len:44 put:40
> head:ffff0000d18dd200 data:ffff0000d18dd1ea tail:0x16 end:0x140
> dev:bond1
> kernel BUG at net/core/skbuff.c:200 !
> Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 5643 Comm: dhcpcd Not tainted 
> 6.4.0-rc5-syzkaller-g4641cff8e810 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 05/25/2023
> pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : skb_panic net/core/skbuff.c:196 [inline]
> pc : skb_under_panic+0x13c/0x140 net/core/skbuff.c:210
> lr : skb_panic net/core/skbuff.c:196 [inline]
> lr : skb_under_panic+0x13c/0x140 net/core/skbuff.c:210
> sp : ffff8000973b7260
> x29: ffff8000973b7270 x28: ffff8000973b7360 x27: dfff800000000000
> x26: ffff0000d85d8150 x25: 0000000000000016 x24: ffff0000d18dd1ea
> x23: ffff0000d18dd200 x22: 000000000000002c x21: 0000000000000140
> x20: 0000000000000028 x19: ffff80008934c100 x18: ffff8000973b68a0
> x17: 0000000000000000 x16: ffff80008a43bfbc x15: 0000000000000202
> x14: 0000000000000000 x13: 0000000000000001 x12: 0000000000000001
> x11: 0000000000000201 x10: 0000000000000000 x9 : f22f7eb937cced00
> x8 : f22f7eb937cced00 x7 : 0000000000000001 x6 : 0000000000000001
> x5 : ffff8000973b6b78 x4 : ffff80008df9ee80 x3 : ffff8000805974f4
> x2 : 0000000000000001 x1 : 0000000100000201 x0 : 0000000000000086
> Call trace:
> skb_panic net/core/skbuff.c:196 [inline]
> skb_under_panic+0x13c/0x140 net/core/skbuff.c:210
> skb_push+0xf0/0x108 net/core/skbuff.c:2409
> ip6gre_header+0xbc/0x738 net/ipv6/ip6_gre.c:1383
> dev_hard_header include/linux/netdevice.h:3137 [inline]
> lapbeth_data_transmit+0x1c4/0x298 drivers/net/wan/lapbether.c:257
> lapb_data_transmit+0x8c/0xb0 net/lapb/lapb_iface.c:447
> lapb_transmit_buffer+0x178/0x204 net/lapb/lapb_out.c:149
> lapb_send_control+0x220/0x320 net/lapb/lapb_subr.c:251
> lapb_establish_data_link+0x94/0xec
> lapb_device_event+0x348/0x4e0
> notifier_call_chain+0x1a4/0x510 kernel/notifier.c:93
> raw_notifier_call_chain+0x3c/0x50 kernel/notifier.c:461
> __dev_notify_flags+0x2bc/0x544
> dev_change_flags+0xd0/0x15c net/core/dev.c:8643
> devinet_ioctl+0x858/0x17e4 net/ipv4/devinet.c:1150
> inet_ioctl+0x2ac/0x4d8 net/ipv4/af_inet.c:979
> sock_do_ioctl+0x134/0x2dc net/socket.c:1201
> sock_ioctl+0x4ec/0x858 net/socket.c:1318
> vfs_ioctl fs/ioctl.c:51 [inline]
> __do_sys_ioctl fs/ioctl.c:870 [inline]
> __se_sys_ioctl fs/ioctl.c:856 [inline]
> __arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:856
> __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
> invoke_syscall+0x98/0x2c0 arch/arm64/kernel/syscall.c:52
> el0_svc_common+0x138/0x244 arch/arm64/kernel/syscall.c:142
> do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:191
> el0_svc+0x4c/0x160 arch/arm64/kernel/entry-common.c:647
> el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:665
> el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
> Code: aa1803e6 aa1903e7 a90023f5 947730f5 (d4210000)
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Martin Schiller <ms@dev.tdt.de>
> ---
>  drivers/net/wan/lapbether.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
> index
> d62a904d2e422d7e48cf67cba829df0568e99b01..56326f38fe8a30f45e88cdce7efd43e18041e52a
> 100644
> --- a/drivers/net/wan/lapbether.c
> +++ b/drivers/net/wan/lapbether.c
> @@ -384,6 +384,9 @@ static int lapbeth_new_device(struct net_device 
> *dev)
> 
>  	ASSERT_RTNL();
> 
> +	if (dev->type != ARPHRD_ETHER)
> +		return -EINVAL;
> +
>  	ndev = alloc_netdev(sizeof(*lapbeth), "lapb%d", NET_NAME_UNKNOWN,
>  			    lapbeth_setup);
>  	if (!ndev)

Reviewed-by: Martin Schiller <ms@dev.tdt.de>

