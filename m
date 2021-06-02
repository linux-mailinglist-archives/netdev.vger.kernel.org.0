Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BC039910C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 19:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhFBRFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:05:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42458 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFBRFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 13:05:04 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id BE28F641FC;
        Wed,  2 Jun 2021 19:02:12 +0200 (CEST)
Date:   Wed, 2 Jun 2021 19:03:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     syzbot <syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] general protection fault in nft_set_elem_expr_alloc
Message-ID: <20210602170317.GA18869@salvia>
References: <000000000000ef07b205c3cb1234@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <000000000000ef07b205c3cb1234@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 09:37:26AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    6850ec97 Merge branch 'mptcp-fixes-for-5-13'
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1355504dd00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=770708ea7cfd4916
> dashboard link: https://syzkaller.appspot.com/bug?extid=ce96ca2b1d0b37c6422d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1502d517d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12bbbe13d00000
> 
> The issue was bisected to:
> 
> commit 05abe4456fa376040f6cc3cc6830d2e328723478
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Wed May 20 13:44:37 2020 +0000
> 
>     netfilter: nf_tables: allow to register flowtable with no devices
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10fa1387d00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=12fa1387d00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=14fa1387d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ce96ca2b1d0b37c6422d@syzkaller.appspotmail.com
> Fixes: 05abe4456fa3 ("netfilter: nf_tables: allow to register flowtable with no devices")
> 
> general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
> CPU: 1 PID: 8438 Comm: syz-executor343 Not tainted 5.13.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:nft_set_elem_expr_alloc+0x17e/0x280 net/netfilter/nf_tables_api.c:5321
> Code: 48 c1 ea 03 80 3c 02 00 0f 85 09 01 00 00 49 8b 9d c0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 70 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 d9 00 00 00 48 8b 5b 70 48 85 db 74 21 e8 9a bd

It's a real bug. Bisect is not correct though.

I'll post a patch to fix it. Thanks.
