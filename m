Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927952DCCD6
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 08:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgLQHNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 02:13:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:59248 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbgLQHNS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 02:13:18 -0500
IronPort-SDR: kvm8tsI0EyuFkWyVx/qz/FupV9VdV2Lxk/RVcEqEVjVUoKhvNsg9SPyctmSM4Q/GmBMrT4g6Xt
 HTcK8a7DZQLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="162252227"
X-IronPort-AV: E=Sophos;i="5.78,426,1599548400"; 
   d="scan'208";a="162252227"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 23:12:36 -0800
IronPort-SDR: 5Zfia1INRsXjGay5F2bdewOdEaKE5g0chA4V2oJ3TSGqGBK8f1ypgrNIkTdH8Ldx5ELwnj453R
 ayg7+6QgdEKQ==
X-IronPort-AV: E=Sophos;i="5.78,426,1599548400"; 
   d="scan'208";a="369636444"
Received: from bruennej-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.33.70])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 23:12:32 -0800
Subject: Re: memory leak in xskq_create
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000002aca2e05b659af04@google.com>
 <20201216181135.GA94576@PWN>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <0a6cb67b-c24a-07e3-819b-820f3be9e3cd@intel.com>
Date:   Thu, 17 Dec 2020 08:12:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201216181135.GA94576@PWN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-12-16 19:11, Peilin Ye wrote:
> Hi all,
> 
> On Sun, Dec 13, 2020 at 06:53:10AM -0800, syzbot wrote:
>> BUG: memory leak
>> unreferenced object 0xffff88810f897940 (size 64):
>>    comm "syz-executor991", pid 8502, jiffies 4294942194 (age 14.080s)
>>    hex dump (first 32 bytes):
>>      7f 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00  ................
>>      00 a0 37 0c 81 88 ff ff 00 00 00 00 00 00 00 00  ..7.............
>>    backtrace:
>>      [<00000000639d0dd1>] xskq_create+0x23/0xd0 include/linux/slab.h:552
>>      [<00000000b680b035>] xsk_init_queue net/xdp/xsk.c:508 [inline]
>>      [<00000000b680b035>] xsk_setsockopt+0x1c4/0x590 net/xdp/xsk.c:875
>>      [<000000002b302260>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2132
>>      [<00000000ae03723e>] __do_sys_setsockopt net/socket.c:2143 [inline]
>>      [<00000000ae03723e>] __se_sys_setsockopt net/socket.c:2140 [inline]
>>      [<00000000ae03723e>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2140
>>      [<0000000005c2b4a0>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>      [<0000000003db140f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> I have tested the following diff locally against syzbot's reproducer,
> and sent a patch to it [1] for testing.  I will send a real patch here
> tomorrow if syzbot is happy about it.  Please see explanation below.
>

Hi Peilin Ye!

Thanks for taking a look! Magnus has already addressed this problem in
another patch [1].


Cheers,
Björn



[1] 
https://lore.kernel.org/bpf/20201214085127.3960-1-magnus.karlsson@gmail.com/
