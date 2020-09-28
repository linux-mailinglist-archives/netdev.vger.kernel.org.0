Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7191527A926
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgI1H4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbgI1H4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:56:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B717C0613CE;
        Mon, 28 Sep 2020 00:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DPKsOe4ba3eqRNFOJkwafyOb5NNcsVGyhf7wFCh0JJw=; b=crzRZ5WE98TMTp3swk6K9/gew2
        eWzYPuFqMWumU2/LErko7uRcEiknFwK7OYsi/Gt/XY7BdqDoC4AFLoFtR+zV5EukB9GMm0Z8HmTLd
        jDWdTSKcNee3YEyx2Ojiu3xEUCmSiTpCxmG9hbXydK94ZsXL/OK+grfCw1mTpttMxSg1DfaT4xKy/
        qIXuO6Cl445qklZk1tO6FLfkb0IKz5oGeI/KMOmQSh+EKLKsTeH4++YfYiYO2soPWeWt4w3MZjjex
        ZMg5Y4I8p24h/fu+ZTCVfdeFTIFL+BySja4xStflWqWAzrC3X3v0C04LeV5TPK6CFJU7WblHKK9Ky
        QfJOXdeg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kMo18-00042K-K7; Mon, 28 Sep 2020 07:56:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 64C04303F45;
        Mon, 28 Sep 2020 09:56:12 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 206F720BCC934; Mon, 28 Sep 2020 09:56:12 +0200 (CEST)
Date:   Mon, 28 Sep 2020 09:56:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+62ebe501c1ce9a91f68c@syzkaller.appspotmail.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, hawk@kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Johannes Berg <johannes.berg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        netdev <netdev@vger.kernel.org>, petrm@mellanox.com,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: WARNING in print_bfs_bug
Message-ID: <20200928075612.GB2594@hirez.programming.kicks-ass.net>
References: <000000000000d73b12059608812b@google.com>
 <000000000000568a9105963ad7ac@google.com>
 <CACT4Y+YBi=5Q0tpND7FKU1j1YNy1Pe+Xkgc+c_Xtf_L_pyAcqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YBi=5Q0tpND7FKU1j1YNy1Pe+Xkgc+c_Xtf_L_pyAcqg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 27, 2020 at 10:57:24AM +0200, Dmitry Vyukov wrote:
> On Thu, Oct 31, 2019 at 9:39 PM syzbot
> <syzbot+62ebe501c1ce9a91f68c@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has found a reproducer for the following crash on:
> >
> > HEAD commit:    49afce6d Add linux-next specific files for 20191031
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11eea36ce00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3c5f119b33031056
> > dashboard link: https://syzkaller.appspot.com/bug?extid=62ebe501c1ce9a91f68c
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c162f4e00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131b5eb8e00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+62ebe501c1ce9a91f68c@syzkaller.appspotmail.com
> 
> This is another LOCKDEP-related top crasher. syzkaller finds just this
> one (see below).
> I think we need to disable LOCKDEP temporary until this and other
> LOCKDEP issues are resolved. I've filed
> https://github.com/google/syzkaller/issues/2140 to track
> disabling/enabling.

There is a potential patch for it:

  https://lkml.kernel.org/r/20200917080210.108095-1-boqun.feng@gmail.com

Let me try and digest it.
