Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D7831FD6
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 17:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfFAPsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 11:48:01 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41156 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfFAPsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 11:48:00 -0400
Received: by mail-qt1-f193.google.com with SMTP id s57so4693537qte.8;
        Sat, 01 Jun 2019 08:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jnDetmrENIxs3LtOFD/826Chw2+m/gYK9iycOoO55tI=;
        b=dH7Pa4KJv3p4ZkRySjerWQi76tFlvwluzIGoZRDEcFf/UX+i4OvW2dANlNiLgg+Q4Q
         bUnOzvSNxUrU4z9GXls9nnt37PbakzxCizoU2acdy6UWTXuXrri9/mBawKGXRR4e7M+T
         vm/596h6BlXJb2+jDNKx5YEvv2C9LD0upcku0ABixYYTysG982EFsaS/3T1upDXY772Q
         HmRCW+2pMM00DM1kNJbWszzKAOZSwyw8Mvv798ih5M30nhzs0d5tmrFHzRi/HwBZJN7g
         5ogejoHU+oeEba0agLx+zJNdZIA/uMIiBau+xI9DlmZ5QBBciBVIGJKM/PB2aLfAkO8w
         LHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jnDetmrENIxs3LtOFD/826Chw2+m/gYK9iycOoO55tI=;
        b=mao2pD1EaFmu90trXsv/j6RYRcx5beVNjDe0BuEW5MROuwqj7yAp6MXtFSYN0jMSLK
         4EnNL3eeIcUFz1ma09qvGPf3MmAWphO8h+ujDFodSTnyOuCV/teNTFWgumKvhfPyzA2L
         3sjouTmt4OLYXC2zZCSrql6YXebtg2go/6d6A4d0swrMxkEnDKxlxhu0FRppP/Sky+gY
         C7uqUPQpMjVJI+/AFIAETvy8O+0GwSs6kxhJ8AVFMkv+Ua3O3nKFCHhhdYGUVI5opiMX
         +WazMYlwGjs5Uu/zfMZSXz6tdHVy4jYeY0N/bOXdBalx3m5eV/dRaKoNv2dGNEp3b5mn
         VaSQ==
X-Gm-Message-State: APjAAAWjgYavej8cMeauphTWfsP/L49FPWU56yxNFwIbnbB0zSpBXltL
        Cz3oeooy7zK2h1gYFL2LfLs=
X-Google-Smtp-Source: APXvYqwSyxHtVh1pXMw9BNOXZpNpHLZfFdKZ9Uv0KAGzjug/Yn3GOLxaN+CPe5k+5KzfgbazCToD0Q==
X-Received: by 2002:a0c:d78c:: with SMTP id z12mr12863103qvi.244.1559404078816;
        Sat, 01 Jun 2019 08:47:58 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.32])
        by smtp.gmail.com with ESMTPSA id j26sm6409797qtj.70.2019.06.01.08.47.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 01 Jun 2019 08:47:58 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id F3D7DC085E; Sat,  1 Jun 2019 12:47:53 -0300 (-03)
Date:   Sat, 1 Jun 2019 12:47:53 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+6ad9c3bd0a218a2ab41d@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Subject: Re: memory leak in sctp_send_reset_streams
Message-ID: <20190601154753.GG3713@localhost.localdomain>
References: <20190601122615.16872-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601122615.16872-1-hdanton@sina.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 08:26:15PM +0800, Hillf Danton wrote:
> 
> Hi

Hi,

> 
> On Fri, May 31, 2019 at 02:18:06PM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    036e3431 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=153cff12a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=8f0f63a62bb5b13c
> > dashboard link: https://syzkaller.appspot.com/bug?extid=6ad9c3bd0a218a2ab41d
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12561c86a00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b76fd8a00000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+6ad9c3bd0a218a2ab41d@syzkaller.appspotmail.com
> > 
> > executing program
> > executing program
> > executing program
> > executing program
> > executing program
> > BUG: memory leak
> > unreferenced object 0xffff888123894820 (size 32):
> >    comm "syz-executor045", pid 7267, jiffies 4294943559 (age 13.660s)
> >    hex dump (first 32 bytes):
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >    backtrace:
> >      [<00000000c7e71c69>] kmemleak_alloc_recursive
> > include/linux/kmemleak.h:55 [inline]
> >      [<00000000c7e71c69>] slab_post_alloc_hook mm/slab.h:439 [inline]
> >      [<00000000c7e71c69>] slab_alloc mm/slab.c:3326 [inline]
> >      [<00000000c7e71c69>] __do_kmalloc mm/slab.c:3658 [inline]
> >      [<00000000c7e71c69>] __kmalloc+0x161/0x2c0 mm/slab.c:3669
> >      [<000000003250ed8e>] kmalloc_array include/linux/slab.h:670 [inline]
> >      [<000000003250ed8e>] kcalloc include/linux/slab.h:681 [inline]
> >      [<000000003250ed8e>] sctp_send_reset_streams+0x1ab/0x5a0 net/sctp/stream.c:302
> >      [<00000000cd899c6e>] sctp_setsockopt_reset_streams net/sctp/socket.c:4314 [inline]
> >      [<00000000cd899c6e>] sctp_setsockopt net/sctp/socket.c:4765 [inline]
> >      [<00000000cd899c6e>] sctp_setsockopt+0xc23/0x2bf0 net/sctp/socket.c:4608
> >      [<00000000ff3a21a2>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3130
> >      [<000000009eb87ae7>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
> >      [<00000000e0ede6ca>] __do_sys_setsockopt net/socket.c:2089 [inline]
> >      [<00000000e0ede6ca>] __se_sys_setsockopt net/socket.c:2086 [inline]
> >      [<00000000e0ede6ca>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
> >      [<00000000c61155f5>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
> >      [<00000000e540958c>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > BUG: memory leak
> > unreferenced object 0xffff888123894980 (size 32):
> >    comm "syz-executor045", pid 7268, jiffies 4294944145 (age 7.800s)
> >    hex dump (first 32 bytes):
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >    backtrace:
> >      [<00000000c7e71c69>] kmemleak_alloc_recursive
> > include/linux/kmemleak.h:55 [inline]
> >      [<00000000c7e71c69>] slab_post_alloc_hook mm/slab.h:439 [inline]
> >      [<00000000c7e71c69>] slab_alloc mm/slab.c:3326 [inline]
> >      [<00000000c7e71c69>] __do_kmalloc mm/slab.c:3658 [inline]
> >      [<00000000c7e71c69>] __kmalloc+0x161/0x2c0 mm/slab.c:3669
> >      [<000000003250ed8e>] kmalloc_array include/linux/slab.h:670 [inline]
> >      [<000000003250ed8e>] kcalloc include/linux/slab.h:681 [inline]
> >      [<000000003250ed8e>] sctp_send_reset_streams+0x1ab/0x5a0 net/sctp/stream.c:302
> >      [<00000000cd899c6e>] sctp_setsockopt_reset_streams net/sctp/socket.c:4314 [inline]
> >      [<00000000cd899c6e>] sctp_setsockopt net/sctp/socket.c:4765 [inline]
> >      [<00000000cd899c6e>] sctp_setsockopt+0xc23/0x2bf0 net/sctp/socket.c:4608
> >      [<00000000ff3a21a2>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3130
> >      [<000000009eb87ae7>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
> >      [<00000000e0ede6ca>] __do_sys_setsockopt net/socket.c:2089 [inline]
> >      [<00000000e0ede6ca>] __se_sys_setsockopt net/socket.c:2086 [inline]
> >      [<00000000e0ede6ca>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
> >      [<00000000c61155f5>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
> >      [<00000000e540958c>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > 
> > 
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this bug, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> > 
> The following tiny change is prepared based on the info listed above and I want
> to know if it works for you.
> 
> thanks
> Hillf
> ------->8---
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 93ed078..d3e2f03 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -310,6 +310,7 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
> 
> 	if (out && !sctp_stream_outq_is_empty(stream, str_nums, nstr_list)) {
> 		retval = -EAGAIN;
> +		kfree(nstr_list);

Yes it does. Thanks Hillf.

> 		goto out;
> 	}
> 
> --
> 
