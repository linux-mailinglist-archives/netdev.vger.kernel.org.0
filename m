Return-Path: <netdev+bounces-8204-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59BE17231B1
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B36F28145F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C3AB261CE;
	Mon,  5 Jun 2023 20:47:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9F9323E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 20:47:08 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569FDFD;
	Mon,  5 Jun 2023 13:47:05 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id 335C65FD21;
	Mon,  5 Jun 2023 23:47:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1685998022;
	bh=9ATC+GxW8KMEIiHiF6ecJMk0sOenmSubs/SZ/yQ2/y0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
	b=K9EnAk+J1wH+cYPUXAMNufinG+iVezeNRNWTqHdXbSzRlA6+zhToK67+XSsWRyesN
	 K6nuQFG2JC6hnCSryQInquMb02IFsXO41w/tLq7Gv6QmBEBBOYpic4xPL+nOl6HfLV
	 0ljgDI6MBVPlBQCTgHCz18HWMhVBdz8eUbwA9OZiWa9GZJsQ/pr2tVknUq7VdAq2bZ
	 3jGtUwiQKnBogUUuAFQMbk2H4GM6D0vH2c21u5/50TmWB0QitQHkm61Zn1cl7cuugC
	 PQzUMc1A0HIZDRmMQg/1AW8SOB/y0VBBFCYOpBUWFeyS1xFViBcl9cn/wxXNxM5+QG
	 KzNrDwusABegQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Mon,  5 Jun 2023 23:46:58 +0300 (MSK)
Message-ID: <2830ac58-fd77-7e5f-5565-eb47dd027d81@sberdevices.ru>
Date: Mon, 5 Jun 2023 23:42:06 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
To: Bobby Eshleman <bobby.eshleman@bytedance.com>, Stefan Hajnoczi
	<stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, "Michael S.
 Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "K. Y.
 Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei
 Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Bryan Tan
	<bryantan@vmware.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-hyperv@vger.kernel.org>, Bobby Eshleman
	<bobby.eshleman@bytedance.com>, Jiang Wang <jiang.wang@bytedance.com>
From: Arseniy Krasnov <avkrasnov@sberdevices.ru>
Subject: Re: [PATCH RFC net-next v3 0/8] virtio/vsock: support datagrams
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/05 17:23:00 #21436105
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Bobby!

Thanks for this patchset, really interesting!

I applied it on head:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d20dd0ea14072e8a90ff864b2c1603bd68920b4b

And tried to run ./vsock_test (client in the guest, server in the host), I had the following crash:

Control socket connected to 192.168.1.1:12345.                          
0 - SOCK_STREAM connection reset...                                     
[    8.050215] BUG: kernel NULL pointer derefer                         
[    8.050960] #PF: supervisor read access in kernel mode               
[    8.050960] #PF: error_code(0x0000) - not-present page               
[    8.050960] PGD 0 P4D 0                                              
[    8.050960] Oops: 0000 [#1] PREEMPT SMP PTI                          
[    8.050960] CPU: 0 PID: 109 Comm: vsock_test Not tainted 6.4.0-rc3-gd707c220a700
[    8.050960] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14
[    8.050960] RIP: 0010:static_key_count+0x0/0x20                      
[    8.050960] Code: 04 4c 8b 46 08 49 29 c0 4c 01 c8 4c 89 47 08 89 0e 89 56 04 4f
[    8.050960] RSP: 0018:ffffa9a1c021bdc0 EFLAGS: 00010202              
[    8.050960] RAX: ffffffffac309880 RBX: ffffffffc02fc140 RCX: 0000000000000000
[    8.050960] RDX: ffff9a5eff944600 RSI: 0000000000000000 RDI: 0000000000000000
[    8.050960] RBP: ffff9a5ec2371900 R08: ffffa9a1c021bd30 R09: ffff9a5eff98e0c0
[    8.050960] R10: 0000000000001000 R11: 0000000000000000 R12: ffffa9a1c021be80
[    8.050960] R13: 0000000000000000 R14: 0000000000000002 R15: ffff9a5ec1cfca80
[    8.050960] FS:  00007fa9bf88c5c0(0000) GS:ffff9a5efe400000(0000) knlGS:00000000
[    8.050960] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033        
[    8.050960] CR2: 0000000000000000 CR3: 00000000023e0000 CR4: 00000000000006f0
[    8.050960] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    8.050960] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    8.050960] Call Trace:                                              
[    8.050960]  <TASK>                                                  
[    8.050960]  once_deferred+0xd/0x30                                  
[    8.050960]  vsock_assign_transport+0xa2/0x1b0 [vsock]               
[    8.050960]  vsock_connect+0xb4/0x3a0 [vsock]                        
[    8.050960]  ? var_wake_function+0x60/0x60                           
[    8.050960]  __sys_connect+0x9e/0xd0                                 
[    8.050960]  ? _raw_spin_unlock_irq+0xe/0x30                         
[    8.050960]  ? do_setitimer+0x128/0x1f0                              
[    8.050960]  ? alarm_setitimer+0x4c/0x90                             
[    8.050960]  ? fpregs_assert_state_consistent+0x1d/0x50              
[    8.050960]  ? exit_to_user_mode_prepare+0x36/0x130                  
[    8.050960]  __x64_sys_connect+0x11/0x20                             
[    8.050960]  do_syscall_64+0x3b/0xc0                                 
[    8.050960]  entry_SYSCALL_64_after_hwframe+0x4b/0xb5                
[    8.050960] RIP: 0033:0x7fa9bf7c4d13                                 
[    8.050960] Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 48
[    8.050960] RSP: 002b:00007ffdf2d96cc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000a
[    8.050960] RAX: ffffffffffffffda RBX: 0000560c305d0020 RCX: 00007fa9bf7c4d13
[    8.050960] RDX: 0000000000000010 RSI: 00007ffdf2d96ce0 RDI: 0000000000000004
[    8.050960] RBP: 0000000000000004 R08: 0000560c317dc018 R09: 0000000000000000
[    8.050960] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[    8.050960] R13: 0000560c305ccc2d R14: 00007ffdf2d96ce0 R15: 00007ffdf2d96d70
[    8.050960]  </TASK>  


I guess crash is somewhere near:

old_info->transport->release(vsk); in vsock_assign_transport(). May be my config is wrong...

Thanks, Arseniy

