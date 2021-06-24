Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D883B2753
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 08:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhFXGTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 02:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhFXGTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 02:19:51 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688D8C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 23:17:31 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id bm25so11823233qkb.0
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 23:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gpCoMJNcwo6BKQ1tLaUlLybi9fJgrUjAD4JF+W4r3lg=;
        b=sNr3SNpmAo1kxL1IKJAIsx/vaGJNMJ+BN+8n+0MOxiF1CEd3Qf+nV9+q8tSr9Hd02l
         xdK5UkMUTrMW6imUhODbCsht8K0hT8ez4nSJfgcuZNKK9FURaoSgVXSF4yg4syBiKvgC
         GvGxPsRacmv6tT4ZId31zIBn+h8ClmmSvA/2CzBRSd+mKoxLbAO1igqm96SPU9Yikj5Q
         /eqSQXqP5X99erLLJ+i1yIJiy0f+2UQH7MdTTcyqsEPC6uZQYI/DCTNyoZGIQe79Hh0V
         rPsj15Qf37Oh+sLCrdVCdrmgCKCNqFXGAj6hZ6MbxGwDiZhRkKKrGYStQIMVEt1npki8
         ltYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gpCoMJNcwo6BKQ1tLaUlLybi9fJgrUjAD4JF+W4r3lg=;
        b=pJ7VbVpNFFNAvZAiHaWTJ0nU2zpBRva0nTm66q2ZN/lFkqNYWfSI0EOBFzBa3P94lc
         hQuIs0UM3D4HfzeXECSWV9rl/0yp66VupQgoZro1+9jHNvky416pI9LudCkea21QGgU0
         D6e36LMAK/pgVkt4FLaAU0eObkTnWQANfhhgyvZcH6+lPfnKzGCIJrv1xYb1pzVCKYlm
         dWZfTJB7mpyzgPmT9VqkMQmQGLIFZFTITxuS84xsRXIGYk+MF/C4afGJ5hCPRy6vQ1Qb
         nUIjH8sp1Rj+j0A43zw+2wNm68yCDRBSXwGMGogZ4epnIOEPc/VutR3f3obfDWeBGN+d
         geWg==
X-Gm-Message-State: AOAM533bd6mCTHf1nddO4sfFhKUgkOqXujxrAdu2PT2H4BjOetv1LPTQ
        8sQQi9EIoFsOk+SQ0l/T+K6Y5YIoJLO3OoHPWYX3zw==
X-Google-Smtp-Source: ABdhPJzJm0Vd4Kck8UenE+ylHTWGX8ozBrgBq4586l62wheY8gYTHLERpu4nbaeHlpd4gJW3e4mB+XNZW7iB6BkXTJE=
X-Received: by 2002:a25:e911:: with SMTP id n17mr2742830ybd.48.1624515450316;
 Wed, 23 Jun 2021 23:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210623192837.13792eae@gmail.com> <0000000000008a8f9c05c571668c@google.com>
In-Reply-To: <0000000000008a8f9c05c571668c@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 24 Jun 2021 08:17:18 +0200
Message-ID: <CACT4Y+YqOot7SqTXmTJZ3qD16ZBtbOMbKSCseHHzes-DzsPPzw@mail.gmail.com>
Subject: Re: [syzbot] WARNING: zero-size vmalloc in corrupted
To:     syzbot <syzbot+c2f6f09fe907a838effb@syzkaller.appspotmail.com>
Cc:     Pavel Skripkin <paskripkin@gmail.com>, akpm@linux-foundation.org,
        coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 6:28 PM syzbot
<syzbot+c2f6f09fe907a838effb@syzkaller.appspotmail.com> wrote:
>
> > On Wed, 23 Jun 2021 19:19:28 +0300
> > Pavel Skripkin <paskripkin@gmail.com> wrote:
> >
> >> On Wed, 23 Jun 2021 02:15:23 -0700
> >> syzbot <syzbot+c2f6f09fe907a838effb@syzkaller.appspotmail.com> wrote:
> >>
> >> > Hello,
> >> >
> >> > syzbot found the following issue on:
> >> >
> >> > HEAD commit:    13311e74 Linux 5.13-rc7
> >> > git tree:       upstream
> >> > console output:
> >> > https://syzkaller.appspot.com/x/log.txt?x=15d01e58300000 kernel
> >> > config:  https://syzkaller.appspot.com/x/.config?x=42ecca11b759d96c
> >> > dashboard link:
> >> > https://syzkaller.appspot.com/bug?extid=c2f6f09fe907a838effb syz
> >> > repro:
> >> > https://syzkaller.appspot.com/x/repro.syz?x=14bb89e8300000 C
> >> > reproducer:
> >> > https://syzkaller.appspot.com/x/repro.c?x=17cc51b8300000
> >> >
> >> > The issue was bisected to:
> >> >
> >> > commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
> >> > Author: Florian Westphal <fw@strlen.de>
> >> > Date:   Wed Apr 21 07:51:08 2021 +0000
> >> >
> >> >     netfilter: arp_tables: pass table pointer via nf_hook_ops
> >> >
> >> > bisection log:
> >> > https://syzkaller.appspot.com/x/bisect.txt?x=13b88400300000 final
> >> > oops:
> >> > https://syzkaller.appspot.com/x/report.txt?x=10788400300000 console
> >> > output: https://syzkaller.appspot.com/x/log.txt?x=17b88400300000
> >> >
> >>
> >> This one is similar to previous zero-size vmalloc, I guess :)
> >>
> >> #syz test
> >> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> >> master
> >>
> >>
> >
> > Hah, I didn't notice that this one is already fixed by me. But the
> > patch is in the media tree, it's not upstreamed yet:
> >
> > https://git.linuxtv.org/media_tree.git/commit/?id=c680ed46e418e9c785d76cf44eb33bfd1e8cf3f6
> >
> > So,
> >
> > #syz dup: WARNING: zero-size vmalloc in dvb_dmx_init
>
> Can't dup bug to a bug in different reporting (upstream->internal).Please dup syzbot bugs only onto syzbot bugs for the same kernel/reporting.

I think we can say:

#syz dup: WARNING in __vmalloc_node_range
https://syzkaller.appspot.com/bug?id=3c558412597cc402fd7fbb250ca30d04d46c8c60

as that was the original bug report.
