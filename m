Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A42471D1B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 18:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388033AbfGWQsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 12:48:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55918 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729558AbfGWQsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 12:48:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6NGixTG079378;
        Tue, 23 Jul 2019 16:48:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=0k+/VhUSJCBvIEErGxSDSu9OEsPxw7IWedO9ub/ft4g=;
 b=ZTatqs53drFPYCkG2EplnewuIn4yWB+e+tzgIv3weY9q3UQ/ekeeMDY/VTWIJAXW7bkf
 hPCjKoSbquyZuwfgUaUmvjUI/TeLPBacCFO4v0IiwbhZTkg29LQM8Af+SOpP/VRLBKuR
 QRKhf8+9QsEvr7PWVfC7fDaz/1V7yc1+/ZJ/a/fawZxZq3KvdnOpY9fYK04pmahFn1D6
 TViLAsfqLeT8BU+G+viCFNexf5aAK//BOqPc/Thq+VROlcxnVb5jjYdYkLzSPkX79sZ1
 95GaDl9xHbwoBxvXEYcwNeEaxfuykaUv+Cz6LLN2bJ2dVFO9ECUC19USe3gyGc//eNLy 5Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tx61br0h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jul 2019 16:48:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6NGhs9t082996;
        Tue, 23 Jul 2019 16:48:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2tx60x82ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jul 2019 16:48:03 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6NGkwYC090557;
        Tue, 23 Jul 2019 16:48:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tx60x82u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jul 2019 16:48:03 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6NGm2Mn021476;
        Tue, 23 Jul 2019 16:48:02 GMT
Received: from [10.209.243.59] (/10.209.243.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jul 2019 09:48:02 -0700
Subject: Re: memory leak in rds_send_probe
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <000000000000ad1dfe058e5b89ab@google.com>
 <CACT4Y+a7eGJpsrenA-0RbWmwktDj5+XV4xaTeU+fiL5KXNbrqg@mail.gmail.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <8a1b7a3e-0022-c101-7745-206c3d1a044e@oracle.com>
Date:   Tue, 23 Jul 2019 09:48:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CACT4Y+a7eGJpsrenA-0RbWmwktDj5+XV4xaTeU+fiL5KXNbrqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907230169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/19 9:19 AM, Dmitry Vyukov wrote:
> On Tue, Jul 23, 2019 at 6:18 PM syzbot
> <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    c6dd78fc Merge branch 'x86-urgent-for-linus' of git://git...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14be98c8600000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8de7d700ea5ac607
>> dashboard link: https://syzkaller.appspot.com/bug?extid=5134cdf021c4ed5aaa5f
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145df0c8600000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170001f4600000
> 
> +net/rds/message.c maintainers
> 
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com
>>
>> BUG: memory leak
>> unreferenced object 0xffff8881234e9c00 (size 512):

Thanks for reporting. We will look into it.

>>     comm "kworker/u4:2", pid 286, jiffies 4294948041 (age 7.750s)
>>     hex dump (first 32 bytes):
>>       01 00 00 00 00 00 00 00 08 9c 4e 23 81 88 ff ff  ..........N#....
>>       08 9c 4e 23 81 88 ff ff 18 9c 4e 23 81 88 ff ff  ..N#......N#....
>>     backtrace:
>>       [<0000000032e378fa>] kmemleak_alloc_recursive
>> /./include/linux/kmemleak.h:43 [inline]
>>       [<0000000032e378fa>] slab_post_alloc_hook /mm/slab.h:522 [inline]
>>       [<0000000032e378fa>] slab_alloc /mm/slab.c:3319 [inline]
>>       [<0000000032e378fa>] __do_kmalloc /mm/slab.c:3653 [inline]
>>       [<0000000032e378fa>] __kmalloc+0x16d/0x2d0 /mm/slab.c:3664
>>       [<0000000015bc9536>] kmalloc /./include/linux/slab.h:557 [inline]
>>       [<0000000015bc9536>] kzalloc /./include/linux/slab.h:748 [inline]
>>       [<0000000015bc9536>] rds_message_alloc+0x3e/0xc0 /net/rds/message.c:291
>>       [<00000000a806d18d>] rds_send_probe.constprop.0+0x42/0x2f0
>> /net/rds/send.c:1419
>>       [<00000000794a00cc>] rds_send_pong+0x1e/0x23 /net/rds/send.c:1482
>>       [<00000000b2a248d0>] rds_recv_incoming+0x27e/0x460 /net/rds/recv.c:343
>>       [<00000000ea1503db>] rds_loop_xmit+0x86/0x100 /net/rds/loop.c:96
>>       [<00000000a9857f5a>] rds_send_xmit+0x524/0x9a0 /net/rds/send.c:355
>>       [<00000000557b0101>] rds_send_worker+0x3c/0xd0 /net/rds/threads.c:200
>>       [<000000004ba94868>] process_one_work+0x23f/0x490
>> /kernel/workqueue.c:2269
>>       [<00000000e793f811>] worker_thread+0x195/0x580 /kernel/workqueue.c:2415
>>       [<000000003ee8c1a1>] kthread+0x13e/0x160 /kernel/kthread.c:255
>>       [<000000004cd53c81>] ret_from_fork+0x1f/0x30
>> /arch/x86/entry/entry_64.S:352
>>
>>
>>
>> ---
>> This bug is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this bug report. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> syzbot can test patches for this bug, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
>>
>> --
>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000ad1dfe058e5b89ab%40google.com.
