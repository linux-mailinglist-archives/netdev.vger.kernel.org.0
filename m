Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886DF112A76
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 12:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLDLr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 06:47:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727452AbfLDLr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 06:47:57 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB4BftS3112233
        for <netdev@vger.kernel.org>; Wed, 4 Dec 2019 06:47:56 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wnsquyrnt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 06:47:56 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <ubraun@linux.ibm.com>;
        Wed, 4 Dec 2019 11:47:54 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 4 Dec 2019 11:47:50 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB4BlnWn36503584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Dec 2019 11:47:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D14E74C044;
        Wed,  4 Dec 2019 11:47:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 901574C040;
        Wed,  4 Dec 2019 11:47:49 +0000 (GMT)
Received: from oc5311105230.ibm.com (unknown [9.152.224.131])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Dec 2019 11:47:49 +0000 (GMT)
Subject: Re: WARNING: refcount bug in smc_release (2)
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+96d3f9ff6a86d37e44c8@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kgraul@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <20191201122517.18720-1-hdanton@sina.com>
From:   Ursula Braun <ubraun@linux.ibm.com>
Date:   Wed, 4 Dec 2019 12:47:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191201122517.18720-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120411-4275-0000-0000-0000038B1234
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120411-4276-0000-0000-0000389EB3AD
Message-Id: <e943de9d-a81a-e709-e228-64eaddc328da@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_03:2019-12-04,2019-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912040094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/1/19 1:25 PM, Hillf Danton wrote:
> 
> On Sat, 30 Nov 2019 20:37:09 -0800
>>
>> syzbot has found a reproducer for the following crash on:
>>
>> HEAD commit:    32ef9553 Merge tag 'fsnotify_for_v5.5-rc1' of git://git.ke..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=15f6d82ae00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ff560c3de405258c
>> dashboard link: https://syzkaller.appspot.com/bug?extid=96d3f9ff6a86d37e44c8
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> userspace arch: i386
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b57336e00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=149e357ae00000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+96d3f9ff6a86d37e44c8@syzkaller.appspotmail.com
>>
>> ------------[ cut here ]------------
>> refcount_t: underflow; use-after-free.
>> WARNING: CPU: 1 PID: 9807 at lib/refcount.c:28  
>> refcount_warn_saturate+0x1dc/0x1f0 lib/refcount.c:28
>> Kernel panic - not syncing: panic_on_warn set ...
>> CPU: 1 PID: 9807 Comm: syz-executor293 Not tainted 5.4.0-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
>> Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0x197/0x210 lib/dump_stack.c:118
>>   panic+0x2e3/0x75c kernel/panic.c:221
>>   __warn.cold+0x2f/0x3e kernel/panic.c:582
>>   report_bug+0x289/0x300 lib/bug.c:195
>>   fixup_bug arch/x86/kernel/traps.c:174 [inline]
>>   fixup_bug arch/x86/kernel/traps.c:169 [inline]
>>   do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
>>   do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
>>   invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
>> RIP: 0010:refcount_warn_saturate+0x1dc/0x1f0 lib/refcount.c:28
>> Code: e9 d8 fe ff ff 48 89 df e8 c1 5a 24 fe e9 85 fe ff ff e8 e7 08 e7 fd  
>> 48 c7 c7 a0 6f 4f 88 c6 05 60 b8 a4 06 01 e8 53 bd b7 fd <0f> 0b e9 ac fe  
>> ff ff 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 55 48
>> RSP: 0018:ffff888093c97998 EFLAGS: 00010286
>> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: ffffffff815e4316 RDI: ffffed1012792f25
>> RBP: ffff888093c979a8 R08: ffff8880a04d4380 R09: ffffed1015d26621
>> R10: ffffed1015d26620 R11: ffff8880ae933107 R12: 0000000000000003
>> R13: 0000000000000000 R14: ffff8880a118d380 R15: ffff88809427e558
>>   refcount_sub_and_test include/linux/refcount.h:261 [inline]
>>   refcount_dec_and_test include/linux/refcount.h:281 [inline]
>>   sock_put include/net/sock.h:1728 [inline]
>>   smc_release+0x445/0x520 net/smc/af_smc.c:202
>>   __sock_release+0xce/0x280 net/socket.c:591
>>   sock_close+0x1e/0x30 net/socket.c:1269
>>   __fput+0x2ff/0x890 fs/file_table.c:280
>>   ____fput+0x16/0x20 fs/file_table.c:313
>>   task_work_run+0x145/0x1c0 kernel/task_work.c:113
>>   exit_task_work include/linux/task_work.h:22 [inline]
>>   do_exit+0x8e7/0x2ef0 kernel/exit.c:797
>>   do_group_exit+0x135/0x360 kernel/exit.c:895
>>   get_signal+0x47c/0x24f0 kernel/signal.c:2734
>>   do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
>>   exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:160
>>   prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
>>   syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
>>   do_syscall_32_irqs_on arch/x86/entry/common.c:352 [inline]
>>   do_fast_syscall_32+0xbbd/0xe16 arch/x86/entry/common.c:408
>>   entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
> 
> Prevent repeated release using cmpxchg and the sock_hold/put pair is
> cut off as a bonus cleanup (which would go in another seperate one if
> necessary).
> 

Thanks, Hilff, for this cmpxchg() idea. We keep it in mind, but analyzing
possible scenarios of the C reproducer I detected an errorneous duplicate
refcount decrease possibility for the combination of non-blocking connect()
and FASTOPEN_KEY setsockopt(). I am working on a fix.

Thus I assume the syzbot problem is not caused by a repeated release.

Kind regards, Ursula

> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -172,10 +172,9 @@ static int smc_release(struct socket *so
>  	struct smc_sock *smc;
>  	int rc = 0;
>  
> -	if (!sk)
> -		goto out;
> +	if (!sk || sk != cmpxchg(&sock->sk, sk, NULL))
> +		return 0;
>  
> -	sock_hold(sk); /* sock_put below */
>  	smc = smc_sk(sk);
>  
>  	/* cleanup for a dangling non-blocking connect */
> @@ -198,9 +197,7 @@ static int smc_release(struct socket *so
>  	sock->sk = NULL;
>  	release_sock(sk);
>  
> -	sock_put(sk); /* sock_hold above */
>  	sock_put(sk); /* final sock_put */
> -out:
>  	return rc;
>  }
>  
> 

