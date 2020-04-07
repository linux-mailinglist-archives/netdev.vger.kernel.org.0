Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE3B1A0548
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 05:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDGD3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 23:29:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38747 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgDGD3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 23:29:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so2169372wre.5;
        Mon, 06 Apr 2020 20:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Z3mTP8Wsofeqj6eOKfo8X83UZpmewwXdpeVvoGsbXc=;
        b=KDxKD1NSLbHiR+T2DgjXusnla18HONVDru2o0v5qMd1QBTrct4egupXxjZoZVfRAQc
         My+kMw+EEUWxcXpKIp9ragW1gjCQjPTealcpHEKYEDpsFXlePiTy+X82dvBmKEPf8dxK
         bLyMJz/jkRLlz4wJ+kZZVRXd18FX1HtH6Ln01Wkx1o91bknOK56zp2UiZxSPB79Qetz9
         9B3rF+TmbadjWwWwIbKrIEANspIbt7LgdO2CnxDGwngdA44j0RH8z/MQn+kb/a1f8KVR
         qE4rePuYpM6NSrKbCwQvspHfH1N45JUrG7/eFkaxe2LcMiIPbaUhvSpdiwyOb6v7QoVa
         YFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Z3mTP8Wsofeqj6eOKfo8X83UZpmewwXdpeVvoGsbXc=;
        b=TnB5rojW15MHb+rgoeI07c0hsmHKfs0ULnhxqOBkuAhg5QITDtA9k482T20SYLNrC8
         45xmBf7edQKYBnkQKFoJYEpTUw7YNdld3FW9v6LuWR83g7GES15rsbRHQ//B23Ti94iX
         8g5rMiTIbXJJjArvO212hdrCRuy9YAQcnUqMjhWbaeEHRQkxps7tyvc021CO1ZZPQoH2
         0iRJEhadEYAO0ICxMq7oU98foP5hPk/BZDnKqZQQYVbiZ8flCAff6rvc7ciU9xd/qkc6
         zmbrgtVJMHatzrTG/THhUKVOLgHKFlHBP/lqOvxksY88f5aC27h/IzNgIuS31cOJ+uDO
         +PXw==
X-Gm-Message-State: AGi0PuYLjbFMdKHxw5V9WvzPS9zAs2JSjZXw3Ps0FhFZhUtd/MsgFeiU
        7gcALIpTxrNoHEcAr5xso3bSYgm/m8r+uzLPDOw=
X-Google-Smtp-Source: APiQypJc5wzHV8b8oB1iMtufPCXXLROO/oTv+sc1ncZBC0vZi0TRCxhNkA1nLErvWPLhLHsugRbmf4g1AU+O+alKc1o=
X-Received: by 2002:a5d:53d1:: with SMTP id a17mr226459wrw.41.1586230185306;
 Mon, 06 Apr 2020 20:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200407023512.GA25005@ubuntu> <20200407030504.GX23230@ZenIV.linux.org.uk>
 <20200407031318.GY23230@ZenIV.linux.org.uk>
In-Reply-To: <20200407031318.GY23230@ZenIV.linux.org.uk>
From:   Yun Levi <ppbuk5246@gmail.com>
Date:   Tue, 7 Apr 2020 12:29:34 +0900
Message-ID: <CAM7-yPQas7hvTVLa4U80t0Em0HgLCk2whLQa4O3uff5J3OYiAA@mail.gmail.com>
Subject: Re: [PATCH] netns: dangling pointer on netns bind mount point.
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Eric Dumazet <edumazet@google.com>,
        Li RongQing <lirongqing@baidu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes.berg@intel.com>,
        David Howells <dhowells@redhat.com>, daniel@iogearbox.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actually I confirm that Kernel Panic on 4.19 version.
But I couldn't check main line not yet. Below is the one of the panic
log what i've experienced

Internal error: Oops: 96000004 [#1] SMP 2020-03-14T15:35
Modules linked in: hsl_linux_helper(O) saswifmod(O) asrim(O)
linux_bcm_knet(O) linux_user_bde(O) linux_kernel_bde(O)
ds_peripheral(O) m_vlog(O) m_scontrol(O)
CPU: 2 PID: 5966 Comm: c.EQMD_ASYNC Tainted: G W O 4.19.26 NOS
Hardware name: LS1046A RDB Board (DT)
pstate: 60000005 (nZCv daif -PAN -UAO) :44
pc : sock_prot_inuse_add+0x10/0x20
 lr : netlink_release+0x30c/0x5a8
sp : ffff0000244c3b20
x29: ffff0000244c3b20 x28: ffff8008774ea000
x27: ffff800865b093d0 x26: ffff800865b09000
x25: ffff800863580c00 x24: ffff00001892f000
x23: ffff80086514ba00 x22: ffff000018acd000
x21: ffff0000189ae000 x20: ffff00001892a000
x19: ffff0000088bfb2c x18: 0000000000000400
x16: 0000000000000000 x15: 0000000000000400
x14: 0000000000000400  x13: 0000000000000000
x12: 0000000000000001 x11: 000000000000a949
x10: 0000000000062d05 x9 : 0000000000000027
x8 : ffff800877120280 x7 : 0000000000000200
x6 : ffff800865b092e8 x5 : ffff0000244c3ae0
x4 : 0000000000000000 x3 : 0000800866e9a000
x2 : 00000000ffffffff x1 : 0000000000000000
x0 : 0000000000000000
Process c.EQMD_ASYNC (pid: 5966, stack limit = 0x0000000088e20a05)
Call trace:
sock_prot_inuse_add+0x10/0x20
__sock_release+0x44/0xc0
sock_close+0x14/0x20
__fput+0x8c/0x1b8
____fput+0xc/0x18
task_work_run+0xa8/0xd8
do_exit+0x2e4/0xa50
do_group_exit+0x34/0xc8
get_signal+0xd4/0x600
do_signal+0x174/0x268
do_notify_resume+0xcc/0x110
work_pending+0x8/0x10
Code: b940c821 f940c000 d538d083 8b010800 (b8606861) ---[ end trace
0b98c9ccbfd9f6fd ]---
Date/Time : 02-14-0120 06:35:47 Kernel panic - not syncing: Fatal
exception in interrupt SMP: stopping secondary CPUs Kernel Offset:
disabled CPU features: 0x0,21806000 Memory Limit: none

What I saw is when I try to bind on some mount point to
/proc/{pid}/ns/net which made by child process, That's doesn't
increase the netns' refcnt.
And when the child process's going to exit, it frees the netns But
Still bind mount point's inode's private data point to netns which was
freed by child when it exits.

Thank you for your reviewing But I also confirm that problem on mainline too.

And sorry to my fault.


On Tue, Apr 7, 2020 at 12:13 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Tue, Apr 07, 2020 at 04:05:04AM +0100, Al Viro wrote:
>
> > Could you post a reproducer, preferably one that would trigger an oops
> > on mainline?
>
> BTW, just to make sure - are we talking about analysis of existing
> oops, or is it "never seen it happen, but looks like it should be
> triggerable" kind of situation?
