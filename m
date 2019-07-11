Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A80A65462
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 12:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfGKKRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 06:17:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728072AbfGKKRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 06:17:22 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BAGw9V066183
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 06:17:21 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tp2c2jeh5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 06:17:20 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Thu, 11 Jul 2019 11:17:18 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 11 Jul 2019 11:17:15 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BAHEfO48431252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 10:17:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39D15AE055;
        Thu, 11 Jul 2019 10:17:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3C38AE057;
        Thu, 11 Jul 2019 10:17:13 +0000 (GMT)
Received: from [9.152.222.58] (unknown [9.152.222.58])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jul 2019 10:17:13 +0000 (GMT)
Subject: Re: general protection fault in inet_accept
To:     syzbot <syzbot+2e9616288940d15a6476@syzkaller.appspotmail.com>,
        davem@davemloft.net, Ursula Braun <ubraun@linux.ibm.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000006e1bbe0570bea62e@google.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Date:   Thu, 11 Jul 2019 12:17:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0000000000006e1bbe0570bea62e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071110-0016-0000-0000-00000291AE50
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071110-0017-0000-0000-000032EF6CD4
Message-Id: <2962f9c2-e69d-f2cf-fa34-f68f00abbfd9@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=942 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110123
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: net/smc: propagate file from SMC to TCP socket

On 11/07/2018 21:57, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    0026129c8629 rhashtable: add restart routine in rhashtable..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=10ed430c400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b88de6eac8694da6
> dashboard link: https://syzkaller.appspot.com/bug?extid=2e9616288940d15a6476
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+2e9616288940d15a6476@syzkaller.appspotmail.com
> 
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN
> CPU: 1 PID: 27 Comm: kworker/1:1 Not tainted 4.18.0-rc3+ #5
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events smc_tcp_listen_work
> RIP: 0010:inet_accept+0xf2/0x9f0 net/ipv4/af_inet.c:734
> Code: 84 d2 74 09 80 fa 03 0f 8e 93 07 00 00 48 8d 78 28 41 c7 46 80 ea ff ff ff 48 ba 00 00 00 00 00 fc ff df 48 89 f9 48 c1 e9 03 <80> 3c 11 00 0f 85 94 07 00 00 48 b9 00 00 00 00 00 fc ff df 48 8b
> RSP: 0018:ffff8801d94574b0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000005
> RDX: dffffc0000000000 RSI: ffffffff86751b46 RDI: 0000000000000028
> RBP: ffff8801d9457598 R08: ffff8801d9448700 R09: ffffed00367a0f6f
> R10: ffffed00367a0f6f R11: ffff8801b3d07b7b R12: ffff8801b3d07ac0
> R13: ffff8801d94574f0 R14: ffff8801d9457570 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30220000 CR3: 00000001d711f000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  kernel_accept+0x136/0x310 net/socket.c:3251
>  smc_clcsock_accept net/smc/af_smc.c:701 [inline]
>  smc_tcp_listen_work+0x222/0xef0 net/smc/af_smc.c:1114
>  process_one_work+0xc73/0x1ba0 kernel/workqueue.c:2153
>  worker_thread+0x189/0x13c0 kernel/workqueue.c:2296
>  kthread+0x345/0x410 kernel/kthread.c:240
>  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:412
> Modules linked in:
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> ---[ end trace 0d34e5471cc130cb ]---
> RIP: 0010:inet_accept+0xf2/0x9f0 net/ipv4/af_inet.c:734
> Code: 84 d2 74 09 80 fa 03 0f 8e 93 07 00 00 48 8d 78 28 41 c7 46 80 ea ff ff ff 48 ba 00 00 00 00 00 fc ff df 48 89 f9 48 c1 e9 03 <80> 3c 11 00 0f 85 94 07 00 00 48 b9 00 00 00 00 00 fc ff df 48 8b
> RSP: 0018:ffff8801d94574b0 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000005
> RDX: dffffc0000000000 RSI: ffffffff86751b46 RDI: 0000000000000028
> RBP: ffff8801d9457598 R08: ffff8801d9448700 R09: ffffed00367a0f6f
> R10: ffffed00367a0f6f R11: ffff8801b3d07b7b R12: ffff8801b3d07ac0
> R13: ffff8801d94574f0 R14: ffff8801d9457570 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8801daf00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30220000 CR3: 0000000008e6a000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with syzbot.
> 
> 
> 

-- 
Karsten

(I'm a dude)

