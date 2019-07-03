Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49EFA5E887
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 18:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGCQO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 12:14:57 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36934 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfGCQO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 12:14:57 -0400
Received: by mail-io1-f67.google.com with SMTP id e5so1742347iok.4;
        Wed, 03 Jul 2019 09:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=kdryzXbCbzDfJP4dXE/8MzkyDavCGnlKuzeemQ+TiVE=;
        b=vRHm7wc6IwyVzI2KJ1/ggfLsbkwNF8TjNgYG+YcJ55vtYJpAszIaXwG9bj+pky/Tqy
         ajI2asAuUI549bMqf5wx6RVq3CruOC02zkqF/N8/q3/sBExo90alnQjzH+pRJlq7IEMX
         hLKi8MaZHDlX2+9DduXJWGH8Scck5b2Ix9tzTRtXwttLFjuTTNiDYLMDYzdbX/f1j+ev
         LuxFa7xWqsJtEDdm8+2d7mpN8EYcu9zOvWhBQ9sIPp7EtZ46TTFY1UorwIO86+FUNZ5g
         XXA2X5HyLgq0gjbWLzgrjc/xnJIV/bRvvjyriGwWmr/uVgUuKMTkKMVeH3jV1vgTSAjW
         tcbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=kdryzXbCbzDfJP4dXE/8MzkyDavCGnlKuzeemQ+TiVE=;
        b=Q8XEy1P6o4GIQJza7LoOCUs26PHmn0wBZbMvNEPNlN3BOhqDtCUCuW5g6+SOv3ZauN
         H60L4n6g6xJC75RFTLu9NerLfwwFE8xyGkuAN1HMhOS/MMmpVkak2oLNdHQXaKU+WVKK
         VBgXl2gnS16xQOhq2K1s59bmiYxOrriHtP64nu0RIwkhRjAF8R8cW5rDAztdtbW5BC9s
         dGylt2j3X/qY9tR6r6TOScqk0I+MWXjituCdxgC5RznUXX0jRR3sIasjW9PvNfs8Iugk
         lzvJtZXmEydEtvnoszbraPH2VC8oD/+WSkIfGpqL6d+TeyiI5mBFo2zQBNoshj3NlG8q
         85Sw==
X-Gm-Message-State: APjAAAWp3prJNV2jYztSgMxk7Dxffmt0VdyUBzGO77brxrWefW4XS9jj
        9dVeh3zmBAoaYSrfRci3ZOgWz2/QAcY=
X-Google-Smtp-Source: APXvYqwUX87x3z0i6i3URdkVyW37nBeRT9KQ8nLzY5lOnThla46DeABRo/y5QORYPGb+8UyyWVhMeg==
X-Received: by 2002:a5d:9c46:: with SMTP id 6mr30163372iof.6.1562170495847;
        Wed, 03 Jul 2019 09:14:55 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n17sm2240193iog.63.2019.07.03.09.14.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 09:14:54 -0700 (PDT)
Date:   Wed, 03 Jul 2019 09:14:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+d88a977731a9888db7ba@syzkaller.appspotmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Dave Watson <davejwatson@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5d1cd47644b45_8ce2b1bd49125c4ed@john-XPS-13-9370.notmuch>
In-Reply-To: <20190703154543.GA21629@sol.localdomain>
References: <20190703064307.13740-1-hdanton@sina.com>
 <20190703144000.GH17978@ZenIV.linux.org.uk>
 <20190703152334.GI17978@ZenIV.linux.org.uk>
 <20190703154543.GA21629@sol.localdomain>
Subject: Re: kernel panic: corrupted stack end in dput
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Biggers wrote:
> [+bpf and tls maintainers]
> 
> On Wed, Jul 03, 2019 at 04:23:34PM +0100, Al Viro wrote:
> > On Wed, Jul 03, 2019 at 03:40:00PM +0100, Al Viro wrote:
> > > On Wed, Jul 03, 2019 at 02:43:07PM +0800, Hillf Danton wrote:
> > > 
> > > > > This is very much *NOT* fine.
> > > > > 	1) trylock can fail from any number of reasons, starting
> > > > > with "somebody is going through the hash chain doing a lookup on
> > > > > something completely unrelated"
> > > > 
> > > > They are also a red light that we need to bail out of spiraling up
> > > > the directory hierarchy imho.
> > > 
> > > Translation: "let's leak the reference to parent, shall we?"
> > > 
> > > > > 	2) whoever had been holding the lock and whatever they'd
> > > > > been doing might be over right after we get the return value from
> > > > > spin_trylock().
> > > > 
> > > > Or after we send a mail using git. I don't know.
> > > > 
> > > > > 	3) even had that been really somebody adding children in
> > > > > the same parent *AND* even if they really kept doing that, rather
> > > > > than unlocking and buggering off, would you care to explain why
> > > > > dentry_unlist() called by __dentry_kill() and removing the victim
> > > > > from the list of children would be safe to do in parallel with that?
> > > > >
> > > > My bad. I have to walk around that unsafety.
> > > 
> > > WHAT unsafety?  Can you explain what are you seeing and how to
> > > reproduce it, whatever it is?
> > 
> > BTW, what makes you think that it's something inside dput() itself?
> > All I see is that at some point in the beginning of the loop body
> > in dput() we observe a buggered stack.
> > 
> > Is that the first iteration through the loop?  IOW, is that just
> > the place where we first notice preexisting corruption, or is
> > that something the code called from that loop does?  If it's
> > a stack overflow, I would be very surprised to see it here -
> > dput() is iterative and it's called on a very shallow stack in
> > those traces.
> > 
> > What happens if you e.g. turn that
> > 	dput(dentry);
> > in __fput() into
> > 	rcu_read_lock(); rcu_read_unlock(); // trigger the check
> > 	dput(dentry);
> > 
> > and run your reporducer?
> > 
> 
> Please don't waste your time on this, it looks like just another report from the
> massive memory corruption in BPF and/or TLS.  Look at reproducer:
> 
> bpf$MAP_CREATE(0x0, &(0x7f0000000280)={0xf, 0x4, 0x4, 0x400, 0x0, 0x1}, 0x3c)
> socket$rxrpc(0x21, 0x2, 0x800000000a)
> r0 = socket$inet6_tcp(0xa, 0x1, 0x0)
> setsockopt$inet6_tcp_int(r0, 0x6, 0x13, &(0x7f00000000c0)=0x100000001, 0x1d4)
> connect$inet6(r0, &(0x7f0000000140), 0x1c)
> bpf$MAP_CREATE(0x0, &(0x7f0000000000)={0x5}, 0xfffffffffffffdcb)
> bpf$MAP_CREATE(0x2, &(0x7f0000003000)={0x3, 0x0, 0x77fffb, 0x0, 0x10020000000, 0x0}, 0x2c)
> setsockopt$inet6_tcp_TCP_ULP(r0, 0x6, 0x1f, &(0x7f0000000040)='tls\x00', 0x4)
> 
> It's the same as like 20 other syzbot reports.

There is a missing synchronize_rcu we need to add and we have a race
between map_free and tls close at the moment. The race cuases us to
incorrectly set the sk->prot pointers when tls socket is closed in
this case. I've added a hook to the ULP side now that should let
the map_free reset the saved sk->prot pointers on the TLS side and
am testing this now.

The 20 syzbot reports appear to all be due to these two issues.
This has nothing to do with dput().

Thanks,
John

> 
> - Eric


