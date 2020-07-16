Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCE6222EFD
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgGPX2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:28:36 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:52831 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgGPX2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594942115; x=1626478115;
  h=date:from:to:cc:message-id:references:mime-version:
   content-transfer-encoding:in-reply-to:subject;
  bh=jYMN3GJrGjA7ojiGUc+ciVEe93zlOhFmaxfZs4H/WZY=;
  b=CHvFu9x4aRdUKkXtuJr/sCaaPOIvvBw5lbeI5XKuYT77IU/yOhPn0zYg
   Ryg8to0wLRWW6aANijYpezhU6jAr8c45jWkLLa09JiUIXOMm37WnPm2ZW
   4vtzqPHAA4qLcDGbGPBPU+L5JoE+sYGC2w1U2mOvh2SSGsaF9lLu81B9i
   E=;
IronPort-SDR: l3hkHaieLfP9aicaua6dk5DKRxOesNbvVEFYq8ruQ20zrMR0yFNnemTS5j3jWHYSO5I6275xJA
 fwBryLxen1ag==
X-IronPort-AV: E=Sophos;i="5.75,360,1589241600"; 
   d="scan'208";a="59225594"
Subject: Re: [PATCH v2 00/11] Fix PM hibernation in Xen guests
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 16 Jul 2020 23:28:33 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 0DA0EA2021;
        Thu, 16 Jul 2020 23:28:31 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jul 2020 23:28:13 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jul 2020 23:28:12 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 16 Jul 2020 23:28:13 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id CEA575697F; Thu, 16 Jul 2020 23:28:12 +0000 (UTC)
Date:   Thu, 16 Jul 2020 23:28:12 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Message-ID: <20200716232812.GA26338@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1593665947.git.anchalag@amazon.com>
 <324020A7-996F-4CF8-A2F4-46957CEA5F0C@amazon.com>
 <c6688a0c-7fec-97d2-3dcc-e160e97206e6@oracle.com>
 <20200715194933.GA17938@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <6145a0d9-fd4e-a739-407e-97f7261eecd8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6145a0d9-fd4e-a739-407e-97f7261eecd8@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 04:49:57PM -0400, Boris Ostrovsky wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 7/15/20 3:49 PM, Anchal Agarwal wrote:
> > On Mon, Jul 13, 2020 at 03:43:33PM -0400, Boris Ostrovsky wrote:
> >> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> >>
> >>
> >>
> >> On 7/10/20 2:17 PM, Agarwal, Anchal wrote:
> >>> Gentle ping on this series.
> >>
> >> Have you tested save/restore?
> >>
> > No, not with the last few series. But a good point, I will test that and get
> > back to you. Do you see anything specific in the series that suggests otherwise?
> 
> 
> root@ovs104> xl save pvh saved
> Saving to saved new xl format (info 0x3/0x0/1699)
> xc: info: Saving domain 3, type x86 HVM
> xc: Frames: 1044480/1044480  100%
> xc: End of stream: 0/0    0%
> root@ovs104> xl restore saved
> Loading new save file saved (new xl fmt info 0x3/0x0/1699)
>  Savefile contains xl domain config in JSON format
> Parsing config from <saved>
> xc: info: Found x86 HVM domain from Xen 4.13
> xc: info: Restoring domain
> xc: info: Restore successful
> xc: info: XenStore: mfn 0xfeffc, dom 0, evt 1
> xc: info: Console: mfn 0xfefff, dom 0, evt 2
> root@ovs104> xl console pvh
> [  139.943872] ------------[ cut here ]------------
> [  139.943872] kernel BUG at arch/x86/xen/enlighten.c:205!
> [  139.943872] invalid opcode: 0000 [#1] SMP PTI
> [  139.943872] CPU: 0 PID: 11 Comm: migration/0 Not tainted 5.8.0-rc5 #26
> [  139.943872] RIP: 0010:xen_vcpu_setup+0x16d/0x180
> [  139.943872] Code: 4a 8b 14 f5 40 c9 1b 82 48 89 d8 48 89 2c 02 8b 05
> a4 d4 40 01 85 c0 0f 85 15 ff ff ff 4a 8b 04 f5 40 c9 1b 82 e9 f4 fe ff
> ff <0f> 0b b8 ed ff ff ff e9 14 ff ff ff e8 12 4f 86 00 66 90 66 66 66
> [  139.943872] RSP: 0018:ffffc9000006bdb0 EFLAGS: 00010046
> [  139.943872] RAX: 0000000000000000 RBX: ffffc9000014fe00 RCX:
> 0000000000000000
> [  139.943872] RDX: ffff88803fc00000 RSI: 0000000000016128 RDI:
> 0000000000000000
> [  139.943872] RBP: 0000000000000000 R08: 0000000000000000 R09:
> 0000000000000000
> [  139.943872] R10: ffffffff826174a0 R11: ffffc9000006bcb4 R12:
> 0000000000016120
> [  139.943872] R13: 0000000000016120 R14: 0000000000016128 R15:
> 0000000000000000
> [  139.943872] FS:  0000000000000000(0000) GS:ffff88803fc00000(0000)
> knlGS:0000000000000000
> [  139.943872] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  139.943872] CR2: 00007f704be8b000 CR3: 000000003901a004 CR4:
> 00000000000606f0
> [  139.943872] Call Trace:
> [  139.943872]  ? __kmalloc+0x167/0x260
> [  139.943872]  ? xen_manage_runstate_time+0x14a/0x170
> [  139.943872]  xen_vcpu_restore+0x134/0x170
> [  139.943872]  xen_hvm_post_suspend+0x1d/0x30
> [  139.943872]  xen_arch_post_suspend+0x13/0x30
> [  139.943872]  xen_suspend+0x87/0x190
> [  139.943872]  multi_cpu_stop+0x6d/0x110
> [  139.943872]  ? stop_machine_yield+0x10/0x10
> [  139.943872]  cpu_stopper_thread+0x47/0x100
> [  139.943872]  smpboot_thread_fn+0xc5/0x160
> [  139.943872]  ? sort_range+0x20/0x20
> [  139.943872]  kthread+0xfe/0x140
> [  139.943872]  ? kthread_park+0x90/0x90
> [  139.943872]  ret_from_fork+0x22/0x30
> [  139.943872] Modules linked in:
> [  139.943872] ---[ end trace 74716859a6b4f0a8 ]---
> [  139.943872] RIP: 0010:xen_vcpu_setup+0x16d/0x180
> [  139.943872] Code: 4a 8b 14 f5 40 c9 1b 82 48 89 d8 48 89 2c 02 8b 05
> a4 d4 40 01 85 c0 0f 85 15 ff ff ff 4a 8b 04 f5 40 c9 1b 82 e9 f4 fe ff
> ff <0f> 0b b8 ed ff ff ff e9 14 ff ff ff e8 12 4f 86 00 66 90 66 66 66
> [  139.943872] RSP: 0018:ffffc9000006bdb0 EFLAGS: 00010046
> [  139.943872] RAX: 0000000000000000 RBX: ffffc9000014fe00 RCX:
> 0000000000000000
> [  139.943872] RDX: ffff88803fc00000 RSI: 0000000000016128 RDI:
> 0000000000000000
> [  139.943872] RBP: 0000000000000000 R08: 0000000000000000 R09:
> 0000000000000000
> [  139.943872] R10: ffffffff826174a0 R11: ffffc9000006bcb4 R12:
> 0000000000016120
> [  139.943872] R13: 0000000000016120 R14: 0000000000016128 R15:
> 0000000000000000
> [  139.943872] FS:  0000000000000000(0000) GS:ffff88803fc00000(0000)
> knlGS:0000000000000000
> [  139.943872] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  139.943872] CR2: 00007f704be8b000 CR3: 000000003901a004 CR4:
> 00000000000606f0
> [  139.943872] Kernel panic - not syncing: Fatal exception
> [  139.943872] Shutting down cpus with NMI
> [  143.927559] Kernel Offset: disabled
> root@ovs104>
>
I think I may have found a bug. There were no issues with V1 version  that I
send however, there were issues with V2. I tested both series and found xl
save/restore to be working in V1 but not in V2. I should have tested it.
Anyways, looks the issue is coming from executing syscore ops registered for
hibernation use case during call to xen_suspend. 
I remember your comment from earlier where you did ask why we need to
check xen_suspend mode xen_syscore_suspend [patch-004] and I removed that based
on my theoretical understanding of your suggestion that since lock_system_sleep() lock
is taken, we cannot initialize hibernation. I skipped to check the part in the
code where during xen_suspend(), all registered syscore_ops suspend callbacks are
called. Hence the ones registered for PM hibernation will also be called.
With no check there on suspend mode, it fails to return from the function and
they never should be executed in case of xen suspend.
I will revert a part of that check in Patch-004 from V1 and send an updated patch with
the fix.

Thanks,
Anchal
