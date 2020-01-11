Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F9E138374
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 21:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731048AbgAKUFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 15:05:51 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39148 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731024AbgAKUFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 15:05:51 -0500
Received: by mail-ot1-f68.google.com with SMTP id 77so5372033oty.6;
        Sat, 11 Jan 2020 12:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RzLAmnWojqhB0ggAnVmy3XDm4YXkG89pVF+3MJfjq+k=;
        b=J6yfN0yZdMfSeKfWuWTCloM4SeKNElZNgH0ScURo8VCfx8w6OVM+2NHkhTIyy7hV3v
         23kL30Ysw/ocnzNixqYt4Z3aLe1+Cx8yhFfa1B0vBa6/4Nm845TW9r7W0Ol/J7DEuDJe
         NlaVgz4wuIQRt6b/Nl49ODmDQ3x/YYv48YwHeGdfnFZGUFLr1py4+d9+JI+vT0ZZdUkR
         h7gF14nBmokY6Ofiifcopo4B/3s8TS2ZkMiTXRrfYnk9IHU8gf6sLrhnBOKXaglu/gqw
         JLyY5T/Dq3O+TX7dTEWIEXFQIIGHhas0stWKEHkcuDjnhhwD485u54cxNt9NBEJjH8d6
         4hQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RzLAmnWojqhB0ggAnVmy3XDm4YXkG89pVF+3MJfjq+k=;
        b=IATrJRK7jSobIOwHS39eajRQCqGaxvksCZ2CA8LZE0/I5y37oBQTrB0zdOLmkYoTC/
         Ljvo0k5I1oFgVVYyI0lsqZBXsmNXy0JNY4tVe70T6kQuiygpYvL0U/zArMbYVzgfeEzo
         9JGC83HmpX3tn6HOSRxhSjJ0zr3sNxLE8eOG59ZJUbnOPps9X9uKqWgozJXK6tJQT9r3
         VXAGlv/mqsdN8oLSUlOvmDcR34J8jrU2hjIfdI1EXSTzILOwAWhNWRCGBXlKq9k8QbMu
         PNZ2w+5WrcGzqfb8kZReYD4aJ0pMwKB1T9s24iGKu/LANoGXk9uPQIAp9MPeuoU9R76m
         Wghg==
X-Gm-Message-State: APjAAAWg1ALfeJok9Vn074eMqeM7lTLVe2wCMuyHSK8wns+XAMR7Oyxd
        eykj6tVR4JX1N+LAMsy4HOB3nSr1DLHLNG8kgyULdsy/ESM=
X-Google-Smtp-Source: APXvYqyq8O1inMb9ME/lNTTckosy6SSrdg9FQGcee0wMhb3QH+HwX+cVwS4BAAMlj+1dDjbvM5u9kZmdN9ykFqXVPfk=
X-Received: by 2002:a9d:da2:: with SMTP id 31mr7465141ots.319.1578773150191;
 Sat, 11 Jan 2020 12:05:50 -0800 (PST)
MIME-Version: 1.0
References: <000000000000af1c5b059be111e5@google.com>
In-Reply-To: <000000000000af1c5b059be111e5@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 11 Jan 2020 12:05:38 -0800
Message-ID: <CAM_iQpVHAKqA51tm5LjbOZnUd6Zdb9MsRyAoCsYt0acXDQA=gw@mail.gmail.com>
Subject: Re: general protection fault in xt_rateest_put
To:     syzbot <syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 10:05 AM syzbot
<syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    e69ec487 Merge branch 'for-linus' of git://git.kernel.org/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1239f876e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
> dashboard link: https://syzkaller.appspot.com/bug?extid=91bdd8eece0f6629ec8b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13dbd58ee00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15eff9e1e00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com
>
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 10213 Comm: syz-executor519 Not tainted 5.5.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
> RIP: 0010:net_generic include/net/netns/generic.h:45 [inline]
> RIP: 0010:xt_rateest_put+0xa1/0x440 net/netfilter/xt_RATEEST.c:77
> Code: 85 87 01 fb 45 84 f6 0f 84 68 02 00 00 e8 37 86 01 fb 49 8d bd 68 13
> 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f
> 85 6c 03 00 00 4d 8b b5 68 13 00 00 e8 29 bf ed fa
> RSP: 0018:ffffc90001cd7940 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: ffff8880a779f700 RCX: ffffffff8673a332
> RDX: 000000000000026d RSI: ffffffff8673a0b9 RDI: 0000000000001368
> RBP: ffffc90001cd7970 R08: ffff8880a96b2240 R09: ffffed1015d0703d
> R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: 000000000000002d
> R13: 0000000000000000 R14: 0000000000000001 R15: ffffffff8673a470
> FS:  00000000016ce880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055cd48aff140 CR3: 0000000096982000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   xt_rateest_tg_destroy+0x72/0xa0 net/netfilter/xt_RATEEST.c:175
>   cleanup_entry net/ipv4/netfilter/arp_tables.c:509 [inline]
>   translate_table+0x11f4/0x1d80 net/ipv4/netfilter/arp_tables.c:587
>   do_replace net/ipv4/netfilter/arp_tables.c:981 [inline]
>   do_arpt_set_ctl+0x317/0x650 net/ipv4/netfilter/arp_tables.c:1461

This looks odd, the head commit e69ec487 comes after commit
1b789577f655060d98d20ed0c6f9fbd469d6ba63 which is supposed
to fix this...
