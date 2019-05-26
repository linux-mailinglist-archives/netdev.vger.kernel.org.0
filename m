Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A892A788
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 03:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfEZBOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 21:14:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60740 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbfEZBOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 21:14:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:Cc:References:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7/ZQW4RY6N/SCiGHJiH7tMvUe16KWpR/oqQ5piByqa0=; b=nTfQLat9KeFOqASu0pTE/Gx4pk
        6IBWtWzJiZkaRE3nO94dgKXNTTS1TaRPi/YYEBoagxTr2gRde3AfNE2jtjATPyfNkx287IrYjCJxM
        ZsjmWOnBCzDxmkHCZKqMrb/i28NgA1CliDVfgx1SCW2G0TfFJbkK7Cp7scaHauxKrwu8qGYHzQrDy
        OtKfPaKUyqnwcLVl4f3Rpk2KfP+nxN3y+pN1+icImnr9yvttOFHPPHwiHqaLJy/iGOjf2H42B3+jE
        sBEnhptTc5b4L2XIhoILeSRyj+w1PuAxzs+0BkxI7Ln3Ch0vv7eHrki5CtlbtMBwnJIeWQYkJZwN1
        /UsajNow==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hUhkN-0000IO-T3; Sun, 26 May 2019 01:14:48 +0000
Subject: Re: Linux 5.1.5 (a regression: kernel BUG at lib/list_debug.c:29!)
To:     "rwarsow@gmx.de" <rwarsow@gmx.de>, linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f3c89197-90dc-240b-d96b-aa1286af756a@gmx.de>
Cc:     Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5b3f9ac3-a0b4-5b7a-ac7d-d643a2b5963f@infradead.org>
Date:   Sat, 25 May 2019 18:14:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f3c89197-90dc-240b-d96b-aa1286af756a@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/25/19 1:37 PM, rwarsow@gmx.de wrote:
> hallo
> 
> I today I got a regression
> 
> see the attached dmesg
> 
> -- 
> 
> Ronald


[adding netdev + TIPC maintainers]


[    4.953673] ------------[ cut here ]------------
[    4.953674] kernel BUG at lib/list_debug.c:29!
[    4.953678] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[    4.953680] CPU: 3 PID: 1437 Comm: (t-daemon) Not tainted 5.1.5_MY #1
[    4.953681] Hardware name: MSI MS-7A72/B250 PC MATE (MS-7A72), BIOS 3.90 07/05/2018
[    4.953685] RIP: 0010:__list_add_valid.cold+0x26/0x3f
[    4.953686] Code: 00 00 00 c3 4c 89 c1 48 c7 c7 28 dc 5e ab e8 0e 80 b4 ff 0f 0b 48 89 f2 4c 89 c1 48 89 fe 48 c7 c7 d8 dc 5e ab e8 f7 7f b4 ff <0f> 0b 48 89 d1 4c 89 c6 4c 89 ca 48 c7 c7 80 dc 5e ab e8 e0 7f b4
[    4.953687] RSP: 0018:ffffb18ec22ffd88 EFLAGS: 00010246
[    4.953689] RAX: 0000000000000058 RBX: ffffffffab8f5f00 RCX: 0000000000000000
[    4.953690] RDX: 0000000000000000 RSI: ffff96b11eed5548 RDI: 00000000ffffffff
[    4.953690] RBP: ffffffffab8f6090 R08: 0000000000000366 R09: 0000000000000003
[    4.953691] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffffab8f6090
[    4.953692] R13: 0000000000000036 R14: ffff96b119564c00 R15: 0000000000000000
[    4.953693] FS:  00007f4f879bc980(0000) GS:ffff96b11eec0000(0000) knlGS:0000000000000000
[    4.953694] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.953695] CR2: 000055ed16dfe800 CR3: 0000000459802005 CR4: 00000000003606e0
[    4.953696] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.953697] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    4.953697] Call Trace:
[    4.953701]  proto_register+0x13b/0x1f0
[    4.953704]  tipc_socket_init+0x13/0x40
[    4.953707]  tipc_init_net+0xa5/0x130
[    4.953709]  ops_init+0x35/0x100
[    4.953711]  setup_net+0xc4/0x1e0
[    4.953712]  copy_net_ns+0xbd/0x180
[    4.953715]  create_new_namespaces+0x113/0x1e0
[    4.953716]  unshare_nsproxy_namespaces+0x50/0xa0
[    4.953719]  ksys_unshare+0x186/0x350
[    4.953721]  __x64_sys_unshare+0x9/0x10
[    4.953722]  do_syscall_64+0x50/0x160
[    4.953725]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    4.953726] RIP: 0033:0x7f4f88a04e4b
[    4.953728] Code: 73 01 c3 48 8b 0d 3d 40 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 40 0c 00 f7 d8 64 89 01 48
[    4.953729] RSP: 002b:00007ffc7f4d2088 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
[    4.953730] RAX: ffffffffffffffda RBX: 000055ed16eeab10 RCX: 00007f4f88a04e4b
[    4.953731] RDX: 0000000000000000 RSI: 00007ffc7f4d1ff0 RDI: 0000000040000000
[    4.953732] RBP: 00007ffc7f4d2270 R08: 00007ffc7f4d2074 R09: 0000000000000001
[    4.953732] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000fffffff5
[    4.953733] R13: 0000000000000000 R14: 000055ed16fcf2f0 R15: 0000000000000000
[    4.953735] Modules linked in: kvm_intel kvm irqbypass iTCO_wdt iTCO_vendor_support i915 video intel_gtt
[    4.953739] ---[ end trace 40639449ef1b96be ]---



Full log is at https://lore.kernel.org/lkml/f3c89197-90dc-240b-d96b-aa1286af756a@gmx.de/T/#u



-- 
~Randy
