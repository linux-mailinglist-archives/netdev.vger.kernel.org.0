Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F781CEC48
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 07:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgELFG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 01:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725814AbgELFG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 01:06:27 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069F5C061A0C;
        Mon, 11 May 2020 22:06:25 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t16so4863903plo.7;
        Mon, 11 May 2020 22:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TuFwHRptP2jx0mxGuLs4rYfZbAlEVBTR8uJy3i2eUzA=;
        b=mv1RFNN1DSCilavRnZQAhady427j3CVcCenk3mBQgCkNz8VbqqhDgoWvYIBJSbDBea
         EvHCIRnnzwAIlHX5gIOG3bK7sUb6hHeDgXRrUrpyIDS5Ko+M+vrk/mNRqb/dzuVymkHL
         Jt50jXWIRqaSrv9EVQebLW1/YoF5tXmRlyXNkzZVniwnJDcQBMt2A1F1OdL8kmG4JbF1
         88A4BkeW6V67xZND0vCYXBR8ajSF13j+4HwDdF4Y3U80D7IEW7CHt914MJ2IzOI6f3hi
         VMybEpxTo+Hu/ZQ0dxUnUYFfJxLXiiBg8sw3QjQ0kEKRY/7OhjUefrsa7lWMVH4tPKnr
         aYmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TuFwHRptP2jx0mxGuLs4rYfZbAlEVBTR8uJy3i2eUzA=;
        b=kjTD+qh/wo0PIC0Lzt2VpGdoMAMl7TKpBZIxaxn2+yc47SIoaSSZ0O4Vq+rYy6Uy75
         nwACog+0v6fXMk/v2btfU48K0NjqyZY2cUQkqMIIgTmjIPjwo0b0kisdpICZSKrWYumW
         5s4Wq+7xI+KJCLhUv3lvZxt2avuSIK4pTZ96VEbn545mcjhJ1ZxAkiI+r9gjnth35+IT
         l5DHnDsdunp3g4nIdfwBbrVduOwMfDKEcc5BVtxzHZkUz5G67MqxJao+sli6NssJB255
         GwRdptG8lNEJLvGaZlwPSG/wDYTTVDs+IIMP0uVT6aEkNnaYr0J83FogxUN1cC1kfxxn
         iF6g==
X-Gm-Message-State: AGi0PuZKAmi+QC18x5pzZMuCn5SdzwWq7rGXzIT/PQ5oXAKsTBGOWwMQ
        ae7RMc47oYxJqF+LEBIG3A==
X-Google-Smtp-Source: APiQypLJnFoYCp0H0Yhv8vaiQI3bTHwL/VtNXvGeqW5PDvBFLLVcrwBds2wgvhy1P7W1CxfsYEGNCA==
X-Received: by 2002:a17:90a:589:: with SMTP id i9mr25748522pji.156.1589259985314;
        Mon, 11 May 2020 22:06:25 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2402:3a80:cf2:a0bc:89fb:f860:f992:54ab])
        by smtp.gmail.com with ESMTPSA id b9sm10616950pfp.12.2020.05.11.22.06.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 May 2020 22:06:24 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Tue, 12 May 2020 10:36:16 +0530
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Qian Cai <cai@lca.pw>, Amol Grover <frextrite@gmail.com>,
        syzbot <syzbot+761cff389b454aa387d2@syzkaller.appspotmail.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: linux-next boot error: WARNING: suspicious RCU usage in
 ip6mr_get_table
Message-ID: <20200512050616.GA9585@madhuparna-HP-Notebook>
References: <00000000000003dc8f05a50b798e@google.com>
 <CACT4Y+bzRtZdLSzHTp-kJZo4Qg7QctXNVEY9=kbAzfMck9XxAA@mail.gmail.com>
 <DB6FF2E0-4605-40D1-B368-7D813518F6F7@lca.pw>
 <20200507232402.GB2103@madhuparna-HP-Notebook>
 <20200512112847.3b15d182@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512112847.3b15d182@canb.auug.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 11:28:47AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Fri, 8 May 2020 04:54:02 +0530 Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com> wrote:
> >
> > On Thu, May 07, 2020 at 08:50:55AM -0400, Qian Cai wrote:
> > > 
> > >   
> > > > On May 7, 2020, at 5:32 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> > > > 
> > > > On Thu, May 7, 2020 at 11:26 AM syzbot
> > > > <syzbot+761cff389b454aa387d2@syzkaller.appspotmail.com> wrote:  
> > > >> 
> > > >> Hello,
> > > >> 
> > > >> syzbot found the following crash on:
> > > >> 
> > > >> HEAD commit:    6b43f715 Add linux-next specific files for 20200507
> > > >> git tree:       linux-next
> > > >> console output: https://syzkaller.appspot.com/x/log.txt?x=16f64370100000
> > > >> kernel config:  https://syzkaller.appspot.com/x/.config?x=ef9b7a80b923f328
> > > >> dashboard link: https://syzkaller.appspot.com/bug?extid=761cff389b454aa387d2
> > > >> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > >> 
> > > >> Unfortunately, I don't have any reproducer for this crash yet.
> > > >> 
> > > >> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > >> Reported-by: syzbot+761cff389b454aa387d2@syzkaller.appspotmail.com  
> > > > 
> > > > 
> > > > +linux-next for linux-next boot breakage  
> > > 
> > > Amol, Madhuparna, Is either of you still working on this?
> > >   
> > > >> =============================
> > > >> WARNING: suspicious RCU usage
> > > >> 5.7.0-rc4-next-20200507-syzkaller #0 Not tainted
> > > >> -----------------------------
> > > >> net/ipv6/ip6mr.c:124 RCU-list traversed in non-reader section!!
> > > >>  
> > I had some doubt in this one, I have already mailed the maintainers,
> > waiting for their reply.
> 
> This is blocking syzbot testing of linux-next ... are we getting
> anywhere?  Will a patch similar to the ipmr.c one help here?
>
Hi Stephen,

There are some discussions going on about the ipmr.c patch, I guess even
ip6mr can be fixed in a similar way. Let me still confirm once.

Thank you,
Mahuparna

> -- 
> Cheers,
> Stephen Rothwell


