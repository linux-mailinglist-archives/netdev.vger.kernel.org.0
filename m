Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F4D22F1B6
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 16:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbgG0OQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 10:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730839AbgG0OQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 10:16:19 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B024CC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 07:16:18 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id s9so9104393lfs.4
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 07:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pesu-pes-edu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xXHUq+GPzg8FK4S6+EdRbVWjybtJrgatUKy7SXDL+iQ=;
        b=fbHGlTFf6UiyosFji1yVJnin+2GpGhwuMIPQk7R8Cqngdmtmmg1w4zzgLnMdEpBEuT
         Mmt2zAwdmQpGxnKbdugxOngK/qljcak+sVw4DgmLFFotPEWfxXneTVPUzftqhVUQwMq5
         n/q6XExE/jCJ4L0yjPt6zNXF7WVpGxZk4m7mPEllW6Xt4Gi1DwdFlkIS3j/nJAwpJYLX
         7xEYVflxmjWCSY/WVFfbArZ+84/KIb/+Cgx28PsngTO9BIhoCfA9UOzGEf0ETh97unxY
         91VoWjO1fCd54WjlybfBQlCDiyAFK6DD8wnnYSFjibzBCsXJwd/jihIBgjO/PA2TTceg
         Caug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xXHUq+GPzg8FK4S6+EdRbVWjybtJrgatUKy7SXDL+iQ=;
        b=FV92d64Y5h/4gVv8yMMM2lKYhUokj+UYdaTBTF61UCYKzUkJlaLB7DEtibJyVRjC8+
         wkL0La8yS68Qd2+DFCry4wKLHljEyNYHX8jsrAybRibIM1CNQtw44+rCN7P2sBhbfW+b
         U0mGPvDPVZHiNW7r2cujxSrcCAgzyFULXfOfOhRg3DLj3t09c5fHu+v6t/5M2sy3wwB3
         EgBHPym1zft13mE2KZuc2k05saf71a+d425hp4b0l/gFyYrIedpIRr9RO7TFkM6R+RL1
         fHBvcRfjK02sPZXPIWiBZh2fwYzAGGnPGL5OWVcCvTi5BBvZ5wBMPYHhkLwwTyJFdG3n
         HWHA==
X-Gm-Message-State: AOAM5322IrNGj9tGQ7ZwdOXBh2YBySYXgk2rnXKsgUzpfT2CS8eSEBUr
        Qu3vVL7GZDs1MoXIoksKxfPVaGce+DnnHLmQry3vrg==
X-Google-Smtp-Source: ABdhPJxBBdhHhJDhPI/I8NlecIrpo2ELWEx0rUO4NX/elZOnTncGFz78jyf4SCcCXLSNshfYOoEt/z0QAG9tUI0/pPM=
X-Received: by 2002:ac2:4144:: with SMTP id c4mr11891945lfi.118.1595859377115;
 Mon, 27 Jul 2020 07:16:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200727131057.7a3of3hhsld4ng5t@pesu.pes.edu> <20200727132256.GA3933866@kroah.com>
In-Reply-To: <20200727132256.GA3933866@kroah.com>
From:   B K Karthik <bkkarthik@pesu.pes.edu>
Date:   Mon, 27 Jul 2020 19:46:05 +0530
Message-ID: <CAAhDqq2N6nTHpz_CNTwh-ZRK-rQO0uUXO41iOouKn690R494Ww@mail.gmail.com>
Subject: Re: [PATCH] net: tipc: fix general protection fault in tipc_conn_delete_sub
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 6:53 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jul 27, 2020 at 06:40:57PM +0530, B K Karthik wrote:
> > fix a general protection fault in tipc_conn_delete_sub
> > by checking for the existance of con->server.
> > prevent a null-ptr-deref by returning -EINVAL when
> > con->server is NULL
> >
> > general protection fault, probably for non-canonical address 0xdffffc0000000014: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x00000000000000a0-0x00000000000000a7]
> > CPU: 1 PID: 113 Comm: kworker/u4:3 Not tainted 5.6.0-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Workqueue: tipc_send tipc_conn_send_work
> > RIP: 0010:tipc_conn_delete_sub+0x54/0x440 net/tipc/topsrv.c:231
> > Code: 48 c1 ea 03 80 3c 02 00 0f 85 f0 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 18 48 8d bd a0 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c0 03 00 00 48 c7 c0 34 0b 8a 8a 4c 8b a5 a0 00
> > RSP: 0018:ffffc900012d7b58 EFLAGS: 00010206
> > RAX: dffffc0000000000 RBX: ffff8880a8269c00 RCX: ffffffff8789ca01
> > RDX: 0000000000000014 RSI: ffffffff8789a059 RDI: 00000000000000a0
> > RBP: 0000000000000000 R08: ffff8880a8d88380 R09: fffffbfff18577a8
> > R10: fffffbfff18577a7 R11: ffffffff8c2bbd3f R12: dffffc0000000000
> > R13: ffff888093d35a18 R14: ffff8880a8269c00 R15: ffff888093d35a00
> > FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000000000076c000 CR3: 000000009441d000 CR4: 00000000001406e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  tipc_conn_send_to_sock+0x380/0x560 net/tipc/topsrv.c:266
> >  tipc_conn_send_work+0x6f/0x90 net/tipc/topsrv.c:304
> >  process_one_work+0x965/0x16a0 kernel/workqueue.c:2266
> >  worker_thread+0x96/0xe20 kernel/workqueue.c:2412
> >  kthread+0x388/0x470 kernel/kthread.c:268
> >  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > Modules linked in:
> > ---[ end trace 2c161a84be832606 ]---
> > RIP: 0010:tipc_conn_delete_sub+0x54/0x440 net/tipc/topsrv.c:231
> > Code: 48 c1 ea 03 80 3c 02 00 0f 85 f0 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 18 48 8d bd a0 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c0 03 00 00 48 c7 c0 34 0b 8a 8a 4c 8b a5 a0 00
> > RSP: 0018:ffffc900012d7b58 EFLAGS: 00010206
> > RAX: dffffc0000000000 RBX: ffff8880a8269c00 RCX: ffffffff8789ca01
> > RDX: 0000000000000014 RSI: ffffffff8789a059 RDI: 00000000000000a0
> > RBP: 0000000000000000 R08: ffff8880a8d88380 R09: fffffbfff18577a8
> > R10: fffffbfff18577a7 R11: ffffffff8c2bbd3f R12: dffffc0000000000
> > R13: ffff888093d35a18 R14: ffff8880a8269c00 R15: ffff888093d35a00
> > FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000020800000 CR3: 0000000091b8e000 CR4: 00000000001406e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> > Reported-and-tested-by: syzbot+55a38037455d0351efd3@syzkaller.appspotmail.com
> > Signed-off-by: B K Karthik <bkkarthik@pesu.pes.edu>
> > ---
> >  net/tipc/topsrv.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
> > index 1489cfb941d8..6c8d0c6bb112 100644
> > --- a/net/tipc/topsrv.c
> > +++ b/net/tipc/topsrv.c
> > @@ -255,6 +255,9 @@ static void tipc_conn_send_to_sock(struct tipc_conn *con)
> >       int count = 0;
> >       int ret;
> >
> > +     if (!con->server)
> > +             return -EINVAL;
>
> What is wrong with looking at the srv local variable instead?
>
> And how is server getting set to NULL and this function still being
> called?

tipc_conn_send_work makes a call to connected() which just returns con
&& test_bit(CF_CONNECTED, &con->flags)
maybe we can add this check to the implementation of connection() if
you agree, but I found this solution to be fairly simpler because I'm
not sure where else connected() is being used, and I did not want to
introduce redundant function calls.

Yes we can replace con->server with the local variable srv. Extremely
sorry, I hadn't noticed it earlier.

please let me know if i've wrongly understood any of these.
thanks,

karthik
