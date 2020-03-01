Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCCD4174EC4
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 18:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgCARrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 12:47:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56868 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgCARrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 12:47:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 021Hc7ah005040;
        Sun, 1 Mar 2020 17:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=gph7e8gp1DtyYE0PNV0oR7nEwLjw56isUcNnpDl2Y10=;
 b=lKLgQkhQvKyspf6k3pG/WSd6GGKKjK2ElIGcAnXfrga2ZRGdUZPtr2CLLdgXzrXDVMfu
 WQwXMGv/BmRXyYEmwHVbLTrPf1JK2KtmwLl+DczkGihQ84S487P1D4aYun/4Q6YOEBIq
 n090LHYesIEZvF5q5hw090oRGXC+vxlUS67v8wmN/xvQJJQQpbEbeb0JJ1P0OsOhg99Q
 Xq2KrdIcZPh4IKf3NuAqE57F1UwbzmCAXKQClWtjAqzkPhZNmwU+Z6bRLgEzZk/TKrmB
 lp5CrihNVXEhd5gWCIa+KgsgeXR7jHZ61qeO+X1nPMReQ73FoPoAZon/LODLdCFbiSPc sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yffwqc3fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Mar 2020 17:46:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 021HkdwW113634;
        Sun, 1 Mar 2020 17:46:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2yg1rc485f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 01 Mar 2020 17:46:48 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 021HklCF113736;
        Sun, 1 Mar 2020 17:46:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yg1rc483y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Mar 2020 17:46:47 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 021HkhV3019713;
        Sun, 1 Mar 2020 17:46:43 GMT
Received: from [192.168.10.144] (/51.175.209.121)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 01 Mar 2020 09:46:43 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: general protection fault in rds_ib_add_one
From:   =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
In-Reply-To: <b35981ca-f565-0169-5f99-35d67828d0b7@oracle.com>
Date:   Sun, 1 Mar 2020 18:46:39 +0100
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+274094e62023782eeb17@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        syzkaller-bugs@googlegroups.com,
        Andy Grover <andy.grover@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E8CFF16A-4C5C-46B8-9F6E-8406765591A7@oracle.com>
References: <20200224103913.2776-1-hdanton@sina.com>
 <20200225044734.14680-1-hdanton@sina.com>
 <b35981ca-f565-0169-5f99-35d67828d0b7@oracle.com>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9547 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1011 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003010138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 25 Feb 2020, at 19:05, santosh.shilimkar@oracle.com wrote:
>=20
>=20
>=20
> On 2/24/20 8:47 PM, Hillf Danton wrote:
>> On Mon, 24 Feb 2020 09:51:01 -0800 Santosh Shilimkar wrote:
>>> On 2/24/20 2:39 AM, Hillf Danton wrote:
>>>>=20
>>>> Fall back to NUMA_NO_NODE if needed.
>> [...]
>>>>=20
>>> This seems good. Can you please post it as properly formatted patch =
?
> Thanks !!
>=20
>> ---8<---
>> Subject: [PATCH] net/rds: fix gpf in rds_ib_add_one
>> From: Hillf Danton <hdanton@sina.com>
>> The devoted syzbot posted a gpf report.
>> general protection fault, probably for non-canonical address =
0xdffffc0000000086: 0000 [#1] PREEMPT SMP KASAN
>> KASAN: null-ptr-deref in range =
[0x0000000000000430-0x0000000000000437]
>> CPU: 0 PID: 8852 Comm: syz-executor043 Not tainted =
5.6.0-rc2-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 01/01/2011
>> RIP: 0010:dev_to_node include/linux/device.h:663 [inline]
>> RIP: 0010:rds_ib_add_one+0x81/0xe50 net/rds/ib.c:140
>> Code: b7 a8 06 00 00 4c 89 f0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 =
f7 e8 0e e4 1d fa bb 30 04 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 8a =
04 28 84 c0 0f 85 f0 0a 00 00 8b 1b 48 c7 c0 28 0c 09 89 48
>> RSP: 0018:ffffc90003087298 EFLAGS: 00010202
>> RAX: 0000000000000086 RBX: 0000000000000430 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
>> RBP: ffffc900030872f0 R08: ffffffff87964c3c R09: ffffed1014fd109c
>> R10: ffffed1014fd109c R11: 0000000000000000 R12: 0000000000000000
>> R13: dffffc0000000000 R14: ffff8880a7e886a8 R15: ffff8880a7e88000
>> FS:  0000000000c3d880(0000) GS:ffff8880aea00000(0000) =
knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f0318ed0000 CR3: 00000000a3167000 CR4: 00000000001406f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  add_client_context+0x482/0x660 drivers/infiniband/core/device.c:681
>>  enable_device_and_get+0x15b/0x370 =
drivers/infiniband/core/device.c:1316
>>  ib_register_device+0x124d/0x15b0 =
drivers/infiniband/core/device.c:1382
>>  rxe_register_device+0x3f6/0x530 =
drivers/infiniband/sw/rxe/rxe_verbs.c:1231
>>  rxe_add+0x1373/0x14f0 drivers/infiniband/sw/rxe/rxe.c:302
>>  rxe_net_add+0x79/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:539
>>  rxe_newlink+0x31/0x90 drivers/infiniband/sw/rxe/rxe.c:318
>>  nldev_newlink+0x403/0x4a0 drivers/infiniband/core/nldev.c:1538
>>  rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
>>  rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
>>  rdma_nl_rcv+0x701/0xa20 drivers/infiniband/core/netlink.c:259
>>  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>>  netlink_unicast+0x766/0x920 net/netlink/af_netlink.c:1328
>>  netlink_sendmsg+0xa2b/0xd40 net/netlink/af_netlink.c:1917
>>  sock_sendmsg_nosec net/socket.c:652 [inline]
>>  sock_sendmsg net/socket.c:672 [inline]
>>  ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2343
>>  ___sys_sendmsg net/socket.c:2397 [inline]
>>  __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
>>  __do_sys_sendmsg net/socket.c:2439 [inline]
>>  __se_sys_sendmsg net/socket.c:2437 [inline]
>>  __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2437
>>  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
>>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> It's fixed by falling back to NUMA_NO_NODE if needed while allocating
>> memory slices for send/recv rings at some cost of dip in performance.
>> Reported-by: syzbot =
<syzbot+274094e62023782eeb17@syzkaller.appspotmail.com>
>> Fixes: e4c52c98e049 ("RDS/IB: add _to_node() macros for numa and use =
{k,v}malloc_node()")
>> Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>> Cc: Andy Grover <andy.grover@oracle.com>
>> Signed-off-by: Hillf Danton <hdanton@sina.com>
>> ---
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>=20
>> --- a/net/rds/ib.c
>> +++ b/net/rds/ib.c
>> @@ -137,7 +137,8 @@ static void rds_ib_add_one(struct ib_dev
>>  		return;
>>    	rds_ibdev =3D kzalloc_node(sizeof(struct rds_ib_device), =
GFP_KERNEL,
>> -				 ibdev_to_node(device));
>> +				 device->dev.parent ?
>> +				 ibdev_to_node(device) : NUMA_NO_NODE);

I would strongly advice this fix to be applied to the define itself, so =
the fix will be made for all 4 calls as well. Aka:

#define ibdev_to_node(ibdev) (ibdev)->dev.parent ? =
dev_to_node((ibdev)->dev.parent) : NUMA_NO_NODE


Thxs, H=C3=A5kon




>>  	if (!rds_ibdev)
>>  		return;
>>  --

