Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2E41761B9
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgCBSAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:00:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCBSAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:00:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022Hs4BF082955;
        Mon, 2 Mar 2020 17:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YRsOs8UtvLJRJRm9CbEjtxPq7z+8aNBpSFEMh7HhU+Q=;
 b=xoS0LtVWKHjtLcx/X5V8doFbcySP9BPSNiUSRiIqqsN5mD7k7Jto1rdYiy//BqwtTa4M
 AMVtatFrmSDdji2QZIEBaP2WwLG1pWQfm5sP81Y+H0M8LAVWu2pz7huH30tnfLna819O
 g4xNIWmMgHf7l7yACtw0Yr48miiAvdUQi9g1eepCCpRp/RTODhuVMwn+Q7lgDFYzgODk
 6FYb/mfEmq/L2d5/yoLACFrKeJGTMZV3fRpHFlb/3co01G3mUxA1mOcNiAYRQckHVUWC
 gg0OY1Wmao3EUQnC8h3hJdAxtQPuzrb4ZPZtqYIyBJ9NWg0JcIj7kBLi8xRw4TpMh5/n ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yffwqhbet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Mar 2020 17:59:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 022HqbJf062058;
        Mon, 2 Mar 2020 17:59:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2yg1rg2xpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 02 Mar 2020 17:59:47 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 022Hxk0k095166;
        Mon, 2 Mar 2020 17:59:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2yg1rg2xmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Mar 2020 17:59:46 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 022HxiAu028691;
        Mon, 2 Mar 2020 17:59:44 GMT
Received: from [10.209.227.41] (/10.209.227.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Mar 2020 09:59:44 -0800
Subject: Re: general protection fault in rds_ib_add_one
To:     Hillf Danton <hdanton@sina.com>
Cc:     =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>,
        syzbot <syzbot+274094e62023782eeb17@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        syzkaller-bugs@googlegroups.com,
        Andy Grover <andy.grover@oracle.com>
References: <20200224103913.2776-1-hdanton@sina.com>
 <20200225044734.14680-1-hdanton@sina.com>
 <b35981ca-f565-0169-5f99-35d67828d0b7@oracle.com>
 <E8CFF16A-4C5C-46B8-9F6E-8406765591A7@oracle.com>
 <20200302025120.13936-1-hdanton@sina.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <133f282f-8e13-0452-20d5-e06fdce3809c@oracle.com>
Date:   Mon, 2 Mar 2020 09:59:42 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200302025120.13936-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9548 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003020118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/20 6:51 PM, Hillf Danton wrote:
> 
> On Sun, 1 Mar 2020 11:55:25 -0800 Santosh Shilimkar wrote:
>>
>> On 3/1/20 9:46 AM, Håkon Bugge wrote:
>>>
>>> I would strongly advice this fix to be applied to the define itself,
>>> so the fix will be made for all 4 calls as well. Aka:
>>>
>>> #define ibdev_to_node(ibdev) (ibdev)->dev.parent ? dev_to_node((ibdev)->dev.parent) : NUMA_NO_NODE
>>>
>> Indeed.
>>
>> Hillf, Can you please spin V2 with it ?
>>
> 
> ---8<---
> Subject: [PATCH v2] net/rds: fix gpf in rds_ib_add_one
> From: Hillf Danton <hdanton@sina.com>
> 
> The devoted syzbot reported a gpf.
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000086: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000430-0x0000000000000437]
> CPU: 0 PID: 8852 Comm: syz-executor043 Not tainted 5.6.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:dev_to_node include/linux/device.h:663 [inline]
> RIP: 0010:rds_ib_add_one+0x81/0xe50 net/rds/ib.c:140
> Code: b7 a8 06 00 00 4c 89 f0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 f7 e8 0e e4 1d fa bb 30 04 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 f0 0a 00 00 8b 1b 48 c7 c0 28 0c 09 89 48
> RSP: 0018:ffffc90003087298 EFLAGS: 00010202
> RAX: 0000000000000086 RBX: 0000000000000430 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> RBP: ffffc900030872f0 R08: ffffffff87964c3c R09: ffffed1014fd109c
> R10: ffffed1014fd109c R11: 0000000000000000 R12: 0000000000000000
> R13: dffffc0000000000 R14: ffff8880a7e886a8 R15: ffff8880a7e88000
> FS:  0000000000c3d880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f0318ed0000 CR3: 00000000a3167000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>    add_client_context+0x482/0x660 drivers/infiniband/core/device.c:681
>    enable_device_and_get+0x15b/0x370 drivers/infiniband/core/device.c:1316
>    ib_register_device+0x124d/0x15b0 drivers/infiniband/core/device.c:1382
>    rxe_register_device+0x3f6/0x530 drivers/infiniband/sw/rxe/rxe_verbs.c:1231
>    rxe_add+0x1373/0x14f0 drivers/infiniband/sw/rxe/rxe.c:302
>    rxe_net_add+0x79/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:539
>    rxe_newlink+0x31/0x90 drivers/infiniband/sw/rxe/rxe.c:318
>    nldev_newlink+0x403/0x4a0 drivers/infiniband/core/nldev.c:1538
>    rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
>    rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
>    rdma_nl_rcv+0x701/0xa20 drivers/infiniband/core/netlink.c:259
>    netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>    netlink_unicast+0x766/0x920 net/netlink/af_netlink.c:1328
>    netlink_sendmsg+0xa2b/0xd40 net/netlink/af_netlink.c:1917
>    sock_sendmsg_nosec net/socket.c:652 [inline]
>    sock_sendmsg net/socket.c:672 [inline]
>    ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2343
>    ___sys_sendmsg net/socket.c:2397 [inline]
>    __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
>    __do_sys_sendmsg net/socket.c:2439 [inline]
>    __se_sys_sendmsg net/socket.c:2437 [inline]
>    __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2437
>    do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> 
> It's fixed by falling back to NUMA_NO_NODE if needed while setting up
> device at some cost of runtime dip in performance.
> 
> Reported-by: syzbot <syzbot+274094e62023782eeb17@syzkaller.appspotmail.com>
> Fixes: e4c52c98e049 ("RDS/IB: add _to_node() macros for numa and use {k,v}malloc_node()")
> Cc: Andy Grover <andy.grover@oracle.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> Signed-off-by: Hillf Danton <hdanton@sina.com>
> ---
> 
Thanks Hillf !!
