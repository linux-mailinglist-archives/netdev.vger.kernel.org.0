Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842F915202F
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 19:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgBDSGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 13:06:13 -0500
Received: from ma1-aaemail-dr-lapp02.apple.com ([17.171.2.68]:60252 "EHLO
        ma1-aaemail-dr-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727355AbgBDSGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 13:06:13 -0500
Received: from pps.filterd (ma1-aaemail-dr-lapp02.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp02.apple.com (8.16.0.27/8.16.0.27) with SMTP id 014I24OA014731;
        Tue, 4 Feb 2020 10:06:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : date : from :
 to : cc : subject : message-id : references : mime-version : content-type
 : in-reply-to; s=20180706;
 bh=lNgQb1UhzFYTVYGl2krVP245ZrxITuG/kEiT9jXWpUU=;
 b=sr7N33cJi1kEetnSP/l5TM86WxYqETqzoyxyqBU9s4bEbJ+bHZeEtBmGPs7g9a37aZdL
 5AYXjIMl8X4J7NQS3NEEKCKF79J7Xb9omZmdoP19/TtgCP0uYoJniIYEAwYV47Dwpgga
 r52m9gxwuU4i+aXbGcWUpSeJMnkPOmrml0c74wmmo0N83uEOysPHCctrQBzmVDO27Vbu
 9zGqEOxj6D8qCkNABPlsjgLDC5x8734/i5/3REjD5AK0Ey//AkAjvMA+Oqzz+LMW+Lg+
 qIw7xKPV8izqnf/2MGfBwC78n72K2B2nk5wW6RflUq8RUYLNWsNmIBRT+xn3q4VTcweg lQ== 
Received: from rn-mailsvcp-mta-lapp04.rno.apple.com (rn-mailsvcp-mta-lapp04.rno.apple.com [10.225.203.152])
        by ma1-aaemail-dr-lapp02.apple.com with ESMTP id 2xw6vy48tb-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 04 Feb 2020 10:06:05 -0800
Received: from nwk-mmpp-sz09.apple.com
 (nwk-mmpp-sz09.apple.com [17.128.115.80]) by
 rn-mailsvcp-mta-lapp04.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.1.20190704 64bit (built Jul  4
 2019)) with ESMTPS id <0Q5600PM4VM2XJJ0@rn-mailsvcp-mta-lapp04.rno.apple.com>;
 Tue, 04 Feb 2020 10:06:02 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz09.apple.com by
 nwk-mmpp-sz09.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q5600600UTDCY00@nwk-mmpp-sz09.apple.com>; Tue,
 04 Feb 2020 10:06:02 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 8ebbce1cad3882733c414095541cac94
X-Va-E-CD: e1e3fb5ed01ea10f29d1a59de909f167
X-Va-R-CD: d703191147a13c16905fb13b3e7ca23b
X-Va-CD: 0
X-Va-ID: f5fbfcb1-c4ff-4c00-8bd8-fc9817c1eae1
X-V-A:  
X-V-T-CD: 8ebbce1cad3882733c414095541cac94
X-V-E-CD: e1e3fb5ed01ea10f29d1a59de909f167
X-V-R-CD: d703191147a13c16905fb13b3e7ca23b
X-V-CD: 0
X-V-ID: 77b184eb-a022-4d15-9fd9-c88fa1e87659
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-02-04_06:,, signatures=0
Received: from localhost ([17.234.127.62]) by nwk-mmpp-sz09.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q56005ADVLT7Q60@nwk-mmpp-sz09.apple.com>; Tue,
 04 Feb 2020 10:05:54 -0800 (PST)
Date:   Tue, 04 Feb 2020 10:05:53 -0800
From:   Christoph Paasch <cpaasch@apple.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] mptcp: fix use-after-free on tcp fallback
Message-id: <20200204180553.GG33105@MacBook-Pro-64.local>
References: <20200204171230.618-1-fw@strlen.de>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20200204171230.618-1-fw@strlen.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-02-04_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/02/20 - 18:12:30, Florian Westphal wrote:
> When an mptcp socket connects to a tcp peer or when a middlebox interferes
> with tcp options, mptcp needs to fall back to plain tcp.
> Problem is that mptcp is trying to be too clever in this case:
> 
> It attempts to close the mptcp meta sk and transparently replace it with
> the (only) subflow tcp sk.
> 
> Unfortunately, this is racy -- the socket is already exposed to userspace.
> Any parallel calls to send/recv/setsockopt etc. can cause use-after-free:
> 
> BUG: KASAN: use-after-free in atomic_try_cmpxchg include/asm-generic/atomic-instrumented.h:693 [inline]
> CPU: 1 PID: 2083 Comm: syz-executor.1 Not tainted 5.5.0 #2
>  atomic_try_cmpxchg include/asm-generic/atomic-instrumented.h:693 [inline]
>  queued_spin_lock include/asm-generic/qspinlock.h:78 [inline]
>  do_raw_spin_lock include/linux/spinlock.h:181 [inline]
>  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
>  _raw_spin_lock_bh+0x71/0xd0 kernel/locking/spinlock.c:175
>  spin_lock_bh include/linux/spinlock.h:343 [inline]
>  __lock_sock+0x105/0x190 net/core/sock.c:2414
>  lock_sock_nested+0x10f/0x140 net/core/sock.c:2938
>  lock_sock include/net/sock.h:1516 [inline]
>  mptcp_setsockopt+0x2f/0x1f0 net/mptcp/protocol.c:800
>  __sys_setsockopt+0x152/0x240 net/socket.c:2130
>  __do_sys_setsockopt net/socket.c:2146 [inline]
>  __se_sys_setsockopt net/socket.c:2143 [inline]
>  __x64_sys_setsockopt+0xba/0x150 net/socket.c:2143
>  do_syscall_64+0xb7/0x3d0 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> While the use-after-free can be resolved, there is another problem:
> sock->ops and sock->sk assignments are not atomic, i.e. we may get calls
> into mptcp functions with sock->sk already pointing at the subflow socket,
> or calls into tcp functions with a mptcp meta sk.
> 
> Remove the fallback code and call the relevant functions for the (only)
> subflow in case the mptcp socket is connected to tcp peer.
> 
> Reported-by: Christoph Paasch <cpaasch@apple.com>
> Diagnosed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/mptcp/protocol.c | 76 ++++----------------------------------------
>  1 file changed, 6 insertions(+), 70 deletions(-)

Tested-by: Christoph Paasch <cpaasch@apple.com>

