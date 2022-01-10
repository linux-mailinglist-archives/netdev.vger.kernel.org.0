Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFED84897E4
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 12:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245004AbiAJLu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 06:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245016AbiAJLtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 06:49:16 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBB0C061748;
        Mon, 10 Jan 2022 03:49:16 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n6tAQ-0007FN-Bf; Mon, 10 Jan 2022 12:48:50 +0100
Date:   Mon, 10 Jan 2022 12:48:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+e163f2ff7c3f7efd8203@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, alobakin@pm.me, andrii@kernel.org, ast@kernel.org,
        atenart@kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        bpf@vger.kernel.org, coreteam@netfilter.org, daniel@iogearbox.net,
        davem@davemloft.net, fw@strlen.de, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kadlec@netfilter.org, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lukas@wunner.de, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, songliubraving@fb.com, sven@narfation.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: [syzbot] WARNING: suspicious RCU usage in __dev_queue_xmit
Message-ID: <20220110114850.GD317@breakpoint.cc>
References: <000000000000ca1d2005d537ebac@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000ca1d2005d537ebac@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+e163f2ff7c3f7efd8203@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4c375272fb0b Merge branch 'net-add-preliminary-netdev-refc..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=164749a9b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2b8e24e3a80e3875
> dashboard link: https://syzkaller.appspot.com/bug?extid=e163f2ff7c3f7efd8203
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11493641b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ac6aceb00000

> include/linux/netfilter_netdev.h:97 suspicious rcu_dereference_check() usage!

#syz fix: netfilter: egress: avoid a lockdep splat
