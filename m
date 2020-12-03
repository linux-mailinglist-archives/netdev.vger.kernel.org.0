Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C50F2CDC98
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 18:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbgLCRmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 12:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgLCRmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 12:42:10 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F83C061A4E
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 09:41:24 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id s8so2728421wrw.10
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 09:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XHrW8mjy1C0a9goFULp/hny7Gv2kJDAvY8hVIvI9pdE=;
        b=iNhxhJDr8zcLFJdo0nG8hI4Yje5IWbV1RsJWPOtN8lmmRZj+2E48OZf3p4m+ghPHOQ
         knUBCWWS+lEBzmxtvBSZJ7x3/qMedAcTNsYMQYqfS9CBRi4wSBtFNEly3arwLunEzj9S
         VmHUtdlT67f3WnhIzb+406smRoWv/Pj9st1mL08CQpkECGuySGtSOu9mcvVz1EOBn7/s
         U5F1mRfkgpTMNc/dEW45LibT23/L4G9ugbXgB/RZxQ64mZV4ZAA2G4nkasNcfmkU7XRp
         zjwI8Iv4eg0GUWdxFuYiXTOw1T0NFri/vA4BeiGN128wBKnFICfMDPAWpcSJLvKR9Gi9
         +tcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XHrW8mjy1C0a9goFULp/hny7Gv2kJDAvY8hVIvI9pdE=;
        b=KwaxmtDslUnSCY98T6NAo3XJKsKXgq43arrLcK+ZmYZ8g/qVhVQD21vcehmh/9KWnb
         kM2EPkcCdoW5X/0VtIZI9YP3dX3VyrKmc9YBukx3/1jrdYhFnDhgBjaduwQNajJXbOWs
         bDW8Ofiz/5nntDEEfPW1yO8tr22FxNwbrQgFqZemiIT5aI+9ky4vPmY/ajavcV444V6I
         /j6wkoM+wqLtgJvFTIwJQWwwbXfhfJX4LOmikBcXNplTUOZhGCxH6/6azAcX9o9a7JE5
         vJCw2a9cyPAcFaz58vCcgKNOMJT8YK9IoE2xb+e8g2rxLtqs6kdz5DK+T/7t/8fn66gy
         ak1A==
X-Gm-Message-State: AOAM5304xkY77iAoKC9AzFM6nbnpYGrIf3OO8UPqBxNJAKWuIKXp6Due
        YRGuuqKSoxVHtRpDnszwTu+aHQ==
X-Google-Smtp-Source: ABdhPJy5QgCmT/tXl4xio8pvab8y51XBju05TrTuWDH+RCpfqPtZ66iNHn4mNUM/k0ZXVIhD+oXncg==
X-Received: by 2002:a05:6000:105:: with SMTP id o5mr348769wrx.164.1607017283176;
        Thu, 03 Dec 2020 09:41:23 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:15:13:f693:9fff:fef4:2449])
        by smtp.gmail.com with ESMTPSA id b14sm233781wrx.35.2020.12.03.09.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 09:41:22 -0800 (PST)
Date:   Thu, 3 Dec 2020 18:41:16 +0100
From:   Marco Elver <elver@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Jann Horn <jannh@google.com>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com>
Subject: Re: WARNING in sk_stream_kill_queues (5)
Message-ID: <X8kjPIrLJUd8uQIX@elver.google.com>
References: <000000000000b4862805b54ef573@google.com>
 <X8kLG5D+j4rT6L7A@elver.google.com>
 <CANn89iJWD5oXPLgtY47umTgo3gCGBaoy+XJfXnw1ecES_EXkCw@mail.gmail.com>
 <CANpmjNOaWbGJQ5Y=qC3cA31-R-Jy4Fbe+p=OBG5O2Amz8dLtLA@mail.gmail.com>
 <CANn89iKWf1EVZUuAHup+5ndhxvOqGopq53=vZ9yeok=DnRjggg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKWf1EVZUuAHup+5ndhxvOqGopq53=vZ9yeok=DnRjggg@mail.gmail.com>
User-Agent: Mutt/2.0.2 (2020-11-20)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 05:42PM +0100, Eric Dumazet wrote:
> On Thu, Dec 3, 2020 at 5:34 PM Marco Elver <elver@google.com> wrote:
> >
> > On Thu, 3 Dec 2020 at 17:27, Eric Dumazet <edumazet@google.com> wrote:
> > > On Thu, Dec 3, 2020 at 4:58 PM Marco Elver <elver@google.com> wrote:
> > > >
> > > > On Mon, Nov 30, 2020 at 12:40AM -0800, syzbot wrote:
> > > > > Hello,
> > > > >
> > > > > syzbot found the following issue on:
> > > > >
> > > > > HEAD commit:    6147c83f Add linux-next specific files for 20201126
> > > > > git tree:       linux-next
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=117c9679500000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=9b91566da897c24f
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=7b99aafdcc2eedea6178
> > > > > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103bf743500000
> > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167c60c9500000
> > > > >
> > > > > The issue was bisected to:
> > > > >
> > > > > commit 145cd60fb481328faafba76842aa0fd242e2b163
> > > > > Author: Alexander Potapenko <glider@google.com>
> > > > > Date:   Tue Nov 24 05:38:44 2020 +0000
> > > > >
> > > > >     mm, kfence: insert KFENCE hooks for SLUB
> > > > >
> > > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13abe5b3500000
> > > > > final oops:     https://syzkaller.appspot.com/x/report.txt?x=106be5b3500000
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=17abe5b3500000
> > > > >
> > > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > > Reported-by: syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com
> > > > > Fixes: 145cd60fb481 ("mm, kfence: insert KFENCE hooks for SLUB")
> > > > >
> > > > > ------------[ cut here ]------------
> > > > > WARNING: CPU: 0 PID: 11307 at net/core/stream.c:207 sk_stream_kill_queues+0x3c3/0x530 net/core/stream.c:207
> > > > [...]
> > > > > Call Trace:
> > > > >  inet_csk_destroy_sock+0x1a5/0x490 net/ipv4/inet_connection_sock.c:885
> > > > >  __tcp_close+0xd3e/0x1170 net/ipv4/tcp.c:2585
> > > > >  tcp_close+0x29/0xc0 net/ipv4/tcp.c:2597
> > > > >  inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
> > > > >  __sock_release+0xcd/0x280 net/socket.c:596
> > > > >  sock_close+0x18/0x20 net/socket.c:1255
> > > > >  __fput+0x283/0x920 fs/file_table.c:280
> > > > >  task_work_run+0xdd/0x190 kernel/task_work.c:140
> > > > >  exit_task_work include/linux/task_work.h:30 [inline]
> > > > >  do_exit+0xb89/0x29e0 kernel/exit.c:823
> > > > >  do_group_exit+0x125/0x310 kernel/exit.c:920
> > > > >  get_signal+0x3ec/0x2010 kernel/signal.c:2770
> > > > >  arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
> > > > >  handle_signal_work kernel/entry/common.c:144 [inline]
> > > > >  exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
> > > > >  exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:198
> > > > >  syscall_exit_to_user_mode+0x36/0x260 kernel/entry/common.c:275
> > > > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > >
> > > > I've been debugging this and I think enabling KFENCE uncovered that some
> > > > code is assuming that the following is always true:
> > > >
> > > >         ksize(kmalloc(S)) == ksize(kmalloc(S))
> > > >
> > >
> > >
> > > I do not think we make this assumption.
> > >
> > > Each skb tracks the 'truesize' which is populated from __alloc_skb()
> > > using ksize(allocated head) .
> > >
> > > So if ksize() decides to give us random data, it should be still fine,
> > > because we use ksize(buff) only once at alloc skb time, and record the
> > > value in skb->truesize
> > >  (only the socket buffer accounting would be off)
> >
> > Good, thanks for clarifying. So something else must be off then.
> 
> Actually we might have the following assumption :
> 
> buff = kmalloc(size, GFP...)
> if (buff)
>    ASSERT(ksize(buff) >= size)
> 
> So obviously ksize() should not be completely random ;)

One more experiment -- simply adding

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -207,7 +207,21 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	 */
 	size = SKB_DATA_ALIGN(size);
 	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	size = 1 << kmalloc_index(size); /* HACK */
 	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);


also got rid of the warnings. Something must be off with some value that
is computed in terms of ksize(). If not, I don't have any explanation
for why the above hides the problem.

Thanks,
-- Marco
