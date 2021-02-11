Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575143182CE
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 01:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhBKAxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 19:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbhBKAxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 19:53:10 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C10C06174A;
        Wed, 10 Feb 2021 16:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=yv1+O/uHfzIBsPuoTfwkhqPfAsKUlTuB4wwNfLpf8ho=; b=b4sYtAv7sYUrxCItJpHcs6Zup8
        Fde9m3Aq5bgFvavX8anZJ17mWxmeDqk8ClpPvkhKuOhyMBrZOjKmvPDJd55EUloyIMdIhFHXsPk4o
        h+xDpXo8TCbQmr5Hd1kWjOP32S0+EDt72Lf7L9pFem2Jn7dgeATveajW0GDf0blCbBPhHOwjfXUXH
        RWRCBWAnVaoZtFM1Yuyi+QMa6ZweG1BArJf8okcjlfByFGkVjF0BEsceFLYr/KFneniuJ2VmEotlh
        Nq2I4mgUgzpVQDGlHlIX9mDUKR4mIGZ9ljEGyL+Js3+/o/z5KeUu63PmIecJ3EU0XLOqqqnaYub8M
        rrWayVyw==;
Received: from [2601:1c0:6280:3f0::cf3b]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lA0DX-0002Kq-U6; Thu, 11 Feb 2021 00:52:24 +0000
Subject: Re: UBSAN: shift-out-of-bounds in xprt_do_reserve
To:     syzbot <syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com>,
        anna.schumaker@netapp.com, bfields@fieldses.org,
        chuck.lever@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        trond.myklebust@hammerspace.com
References: <0000000000000f622105baf14335@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <258ca358-d4ea-2bc0-9b0d-1d659eec04f7@infradead.org>
Date:   Wed, 10 Feb 2021 16:52:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <0000000000000f622105baf14335@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/21 5:24 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    dd86e7fa Merge tag 'pci-v5.11-fixes-2' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=105930c4d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=266a5362c89c8127
> dashboard link: https://syzkaller.appspot.com/bug?extid=f3a0fa110fd630ab56c8
> compiler:       Debian clang version 11.0.1-2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ba3038d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15cf0d64d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com

#syz dup: UBSAN: shift-out-of-bounds in xprt_calc_majortimeo

> ================================================================================
> UBSAN: shift-out-of-bounds in net/sunrpc/xprt.c:658:14
> shift exponent 536870976 is too large for 64-bit type 'unsigned long'
> CPU: 1 PID: 8411 Comm: syz-executor902 Not tainted 5.11.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x137/0x1be lib/dump_stack.c:120
>  ubsan_epilogue lib/ubsan.c:148 [inline]
>  __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
>  xprt_calc_majortimeo net/sunrpc/xprt.c:658 [inline]
>  xprt_init_majortimeo net/sunrpc/xprt.c:686 [inline]


-- 
~Randy

