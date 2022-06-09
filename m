Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C076A5448D5
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 12:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241585AbiFIK1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 06:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241555AbiFIK1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 06:27:03 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256CA1FD9F2;
        Thu,  9 Jun 2022 03:27:01 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzFNP-000DEf-LE; Thu, 09 Jun 2022 12:26:55 +0200
Received: from [2a02:168:f656:0:d16a:7287:ccf0:4fff] (helo=localhost.localdomain)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nzFNP-0007Xo-6F; Thu, 09 Jun 2022 12:26:55 +0200
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 corrupted (2)
To:     syzbot <syzbot+efe1afd49d981d281ae4@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, jakub@cloudflare.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, wangyufen@huawei.com, yhs@fb.com
References: <000000000000124e9105e0fbe047@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fd735658-4d75-85be-28f1-0df389c9cf73@iogearbox.net>
Date:   Thu, 9 Jun 2022 12:26:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <000000000000124e9105e0fbe047@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26567/Thu Jun  9 10:06:06 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/22 6:01 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    03c312cc5f47 Add linux-next specific files for 20220608
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=155a4b73f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a0a0f5184fb46b
> dashboard link: https://syzkaller.appspot.com/bug?extid=efe1afd49d981d281ae4
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168d9ebff00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=125c6e5ff00000
> 
> The issue was bisected to:
> 
> commit d8616ee2affcff37c5d315310da557a694a3303d
> Author: Wang Yufen <wangyufen@huawei.com>
> Date:   Tue May 24 07:53:11 2022 +0000
> 
>      bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues

Wang, please take a look and fix. Thanks!

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=138a4b57f00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=104a4b57f00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=178a4b57f00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+efe1afd49d981d281ae4@syzkaller.appspotmail.com
> Fixes: d8616ee2affc ("bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues")
> 
> BUG: sleeping function called from invalid context at kernel/workqueue.c:3010
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3611, name: syz-executor124
> preempt_count: 201, expected: 0
> RCU nest depth: 0, expected: 0
> 3 locks held by syz-executor124/3611:
>   #0: ffff888073295c10 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:742 [inline]
>   #0: ffff888073295c10 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:649
>   #1: ffff888073ff1ab0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1691 [inline]
>   #1: ffff888073ff1ab0 (sk_lock-AF_INET6){+.+.}-{0:0}, at: tcp_close+0x1e/0xc0 net/ipv4/tcp.c:2908
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

