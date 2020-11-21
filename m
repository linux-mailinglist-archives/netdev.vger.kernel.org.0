Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C987E2BBB05
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 01:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgKUAbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 19:31:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46196 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728849AbgKUAbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 19:31:36 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AL0S8FM017854;
        Fri, 20 Nov 2020 16:31:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tOo5WlmbtuwEDbnX6eygq7b3+RWkTjVgRWCZH/8ezdM=;
 b=YVAHkzzvWwenhJQYc+M6KsBrjjVPcTX2Roe0dfXdVb8XDbjeRLRvJqkN9gFfP0xqDiyC
 k0kHc1YzZA90KTINU7nBdGLIQGTu/t9GIFoCUaxnRZ65yo48PvloHpfQ9p7grIEg/AtJ
 Gen6+LAvFIpJCe8JQRiYM8A6kHLfUOysiUc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wthf26cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 16:31:17 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 16:31:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoaZd0oh92uRn+PBTReyP2wRaNz2BeJ6KSgnlzJ6mBUqQwMU331y41s6V701u1xr6teACK4TyNXjIgQjRtLAQFL0xuO6Elel8Lu198DER/iyFpM+7J6b/1ZVC/TcAdebWykioFsesMBWYRQpDnGN70qG74Jl2hUwe3obvh2xNpTpoEbulor4WDxO9m6F1BasRoiN+t1o+PmrcbfuQ3MrzVa1OA/geRO0vdYlqszmDNGfmxqymEohCTTj0lbDalgaVwVvkOM7eUV+Z4cMeC7TggPEdy76oet7t2Mb+3zxZODVqAOHK+5034OHG53i9JQmmqQaXN+RGS4loQShN71rZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOo5WlmbtuwEDbnX6eygq7b3+RWkTjVgRWCZH/8ezdM=;
 b=THZNP4pIt16TqcvWUduj7en7oUROsoTtNmrSyD/AudgOZSRh0MGTfxJFmIN5o/zXak3a3yYxpQ6QctetqV5ibFKmWSFEaYwwNu1YpqWfotta0WADJ+daqWEJuoGR9nj9fUd981oy+7KoZnmYb4/qkzfvmnv2ls6IF70icUzMi9DGyZSWG2QIPFvXxf8HIJByZoR0R2WaxRvIjcZ3jFF4nKqTLDKaw1psbdo4vw53ktf3IOeLL3iob1cDjFyA6JDLHJG2U9Ymf+MvtS+9J5GIWs4Xoj17B9GVNnF7xkz0ExbRP8Ugo3r3EhzcFtPwtbe5mQWFMwmlcUADCeTCurPLCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOo5WlmbtuwEDbnX6eygq7b3+RWkTjVgRWCZH/8ezdM=;
 b=XcUQBrOGn/f6XnRom6g8P5+H3DBayh+Y3x0yf8I7tRgaUycz4M4+Xq+lRh/OsjX8tMoc2BnsE0OidmgHcoP8WVU2/rbeSf72VhnDuzWD5yZNGdhbuZ3bqeKCA6GHlDF2x27TuGz54kTg58c0sJepMrF0qnhikUyjAu98Yyw9zxw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Sat, 21 Nov
 2020 00:31:15 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%6]) with mapi id 15.20.3564.035; Sat, 21 Nov 2020
 00:31:15 +0000
Subject: Re: [PATCH bpf-next v2 0/5] selftests/bpf: xsk selftests
To:     Weqaar Janjua <weqaar.janjua@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <magnus.karlsson@gmail.com>, <bjorn.topel@intel.com>
CC:     Weqaar Janjua <weqaar.a.janjua@intel.com>, <shuah@kernel.org>,
        <skhan@linuxfoundation.org>, <linux-kselftest@vger.kernel.org>,
        <anders.roxell@linaro.org>, <jonathan.lemon@gmail.com>
References: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <586d63b4-1828-f633-a4ff-88e4e23d164a@fb.com>
Date:   Fri, 20 Nov 2020 16:31:11 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
In-Reply-To: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:7609]
X-ClientProxiedBy: MW4PR03CA0388.namprd03.prod.outlook.com
 (2603:10b6:303:114::33) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1688] (2620:10d:c090:400::5:7609) by MW4PR03CA0388.namprd03.prod.outlook.com (2603:10b6:303:114::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Sat, 21 Nov 2020 00:31:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f55c5e34-7102-46c6-a7e1-08d88db4c0e4
X-MS-TrafficTypeDiagnostic: BYAPR15MB2566:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2566FF70B442A9EE92D0383FD3FE0@BYAPR15MB2566.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:580;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XJ5QGccC4MpE4gKQXX6E99mxbeBkH8qV9+1gKOB8N+pwlkvjsrL31QdLcJCD6DGMs5JqmjzoxxAcdwMubLiMb9WX4s0RF9BNyuRohUhbbNGPhV7ypNY5aZLDGSOSUHLMCQW+h0Zqi17c2LcGHTC7YQO0myRABd8G08lTxZLF6F8dFWJ6z+wjpfvt6gZgFRwLgzy7zxZfO0KWLCnE7xGq0WZeE+miRIMREyV2DUrjlILZPchRJYc0CkxV5nhWvsOQF20Y4zPdCUtWJFmkLZSTsMuMO58zdJsIPZs3DXIjeGS0qRg3nKQ7hpw/d0Sto+EOEcwPpYk80b04JSmWu1crrMcORiAm/KRJPDZOo3Kfgwd0WqktW1r4kFiA1xfdtci6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(376002)(366004)(346002)(8676002)(5660300002)(53546011)(4326008)(16526019)(186003)(2616005)(31696002)(86362001)(6486002)(8936002)(83380400001)(45080400002)(7416002)(2906002)(36756003)(478600001)(66946007)(31686004)(66476007)(52116002)(316002)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: bybN8EBpf77RNeH+gQTya37RQtKmtH+kehsGh7kd51w84D5IG5IEbAZHGn9/B/2seZUQRnMkTumUwqyHV6z6PDI4BqcVl2ZkBjU0YTnoE1lZO5c/KxkWFXF7U0H+dHKmiexXLrpPSmkC3DX4Qwid3vsRX/2gm+e6ljUHZiVKJee0aSTseo5/IPltOeI3QDP7ye0RovMeK8ls3QRDq/b2U2qZ4kvtQOweiuaroF40LVmr8DP+DUP4rwdUQ4K/EH4ZjALyvMeUJHFDVZvyAJnOUTARIYgWy9lgIGAjCQLemm+ouyZuxkECqEcKqpH//vcwGkXvvAUv8RCqcG3VWdL0JketZqoYnSDMO9mRVuv5+kqCPj8JM3uahN5h16IxgnMQOGXKRy2VfHMajw64iCm6k+sTCz/1HRsODrdJCWU8pFH8WrnxWz2aZl9u/eQq9VcOBWMHuiZ+RKXoQINisM8HkFiy2X7cchpPy3r3W4t+0hL7xgEOO3/H1bUbdu7dQpXGNns3cLt18EYZ5q0HB1m4qEm0rdvFTMspVXVXr0Jby40r2D0ypu1n/c8wBxnawZEz6np53kMS5+N0r8XlMzyjZtq4RXjNCm58i1VJ5VaLxcDmyRxonzAE5G9dW8s0gDRgoIuSxUBw64w/y9o8SnqwEZ91utsbjGDtqEquwamKzKXIOO8MynxxWtuI/MYxtd5+X68dO8a6zawXRGtzR1a9jbZsdi+sA0B39i58t6/+FZnSshb8TRcYNliy6jRkCpUFVGtAncLiWAy5nsGmD6GX0YOjjJQJO+MNsq8zJFlZAR9CuWjvhc6Jd/gqgi9sLxeHx+frURKegz1ugzPcQTJWDKXElMXN16J0mE4KLmYIgo1dp0gOWFX3L3IQqleo5bFmKglW91M3FEmqdylzCq6rwAUuptcWdDJtVMsw+UkNPNs=
X-MS-Exchange-CrossTenant-Network-Message-Id: f55c5e34-7102-46c6-a7e1-08d88db4c0e4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2020 00:31:15.2330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UdUyBhjMmvyJk610bG/v/CcrpCfu3s9CRlp6QWtrQ8purq11GJZrjzXdVPOdvIu2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_17:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011210002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/20/20 5:00 AM, Weqaar Janjua wrote:
> This patch set adds AF_XDP selftests based on veth to selftests/bpf.
> 
> # Topology:
> # ---------
> #                 -----------
> #               _ | Process | _
> #              /  -----------  \
> #             /        |        \
> #            /         |         \
> #      -----------     |     -----------
> #      | Thread1 |     |     | Thread2 |
> #      -----------     |     -----------
> #           |          |          |
> #      -----------     |     -----------
> #      |  xskX   |     |     |  xskY   |
> #      -----------     |     -----------
> #           |          |          |
> #      -----------     |     ----------
> #      |  vethX  | --------- |  vethY |
> #      -----------   peer    ----------
> #           |          |          |
> #      namespaceX      |     namespaceY
> 
> These selftests test AF_XDP SKB and Native/DRV modes using veth Virtual
> Ethernet interfaces.
> 
> The test program contains two threads, each thread is single socket with
> a unique UMEM. It validates in-order packet delivery and packet content
> by sending packets to each other.
> 
> Prerequisites setup by script test_xsk_prerequisites.sh:
> 
>     Set up veth interfaces as per the topology shown ^^:
>     * setup two veth interfaces and one namespace
>     ** veth<xxxx> in root namespace
>     ** veth<yyyy> in af_xdp<xxxx> namespace
>     ** namespace af_xdp<xxxx>
>     * create a spec file veth.spec that includes this run-time configuration
>       that is read by test scripts - filenames prefixed with test_xsk_
>     *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
>         conflict with any existing interface
> 
> The following tests are provided:
> 
> 1. AF_XDP SKB mode
>     Generic mode XDP is driver independent, used when the driver does
>     not have support for XDP. Works on any netdevice using sockets and
>     generic XDP path. XDP hook from netif_receive_skb().
>     a. nopoll - soft-irq processing
>     b. poll - using poll() syscall
>     c. Socket Teardown
>        Create a Tx and a Rx socket, Tx from one socket, Rx on another.
>        Destroy both sockets, then repeat multiple times. Only nopoll mode
> 	  is used
>     d. Bi-directional Sockets
>        Configure sockets as bi-directional tx/rx sockets, sets up fill
> 	  and completion rings on each socket, tx/rx in both directions.
> 	  Only nopoll mode is used
> 
> 2. AF_XDP DRV/Native mode
>     Works on any netdevice with XDP_REDIRECT support, driver dependent.
>     Processes packets before SKB allocation. Provides better performance
>     than SKB. Driver hook available just after DMA of buffer descriptor.
>     a. nopoll
>     b. poll
>     c. Socket Teardown
>     d. Bi-directional Sockets
>     * Only copy mode is supported because veth does not currently support
>       zero-copy mode
> 
> Total tests: 8
> 
> Flow:
> * Single process spawns two threads: Tx and Rx
> * Each of these two threads attach to a veth interface within their
>    assigned namespaces
> * Each thread creates one AF_XDP socket connected to a unique umem
>    for each veth interface
> * Tx thread transmits 10k packets from veth<xxxx> to veth<yyyy>
> * Rx thread verifies if all 10k packets were received and delivered
>    in-order, and have the right content
> 
> v2 changes:
> * Move selftests/xsk to selftests/bpf
> * Remove Makefiles under selftests/xsk, and utilize selftests/bpf/Makefile
> 
> Structure of the patch set:
> 
> Patch 1: This patch adds XSK Selftests framework under selftests/bpf
> Patch 2: Adds tests: SKB poll and nopoll mode, and mac-ip-udp debug
> Patch 3: Adds tests: DRV poll and nopoll mode
> Patch 4: Adds tests: SKB and DRV Socket Teardown
> Patch 5: Adds tests: SKB and DRV Bi-directional Sockets

I just want to report that after applying the above 5 patches
on top of bpf-next commit 450d060e8f75 ("bpftool: Add {i,d}tlb_misses 
support for bpftool profile"), I hit the following error with below 
command sequences:

  $ ./test_xsk_prerequisites.sh
  $ ./test_xsk_skb_poll.sh
# Interface found: ve1480
# Interface found: ve9258
# NS switched: af_xdp9258
1..1
# Interface [ve9258] vector [Rx]
# Interface [ve1480] vector [Tx]
# Sending 10000 packets on interface ve1480
[  331.741244] ------------[ cut here ]------------
[  331.741741] kernel BUG at net/core/skbuff.c:1621!
[  331.742265] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  331.742837] CPU: 0 PID: 1883 Comm: xdpxceiver Not tainted 5.10.0-rc3+ 
#1037
[  331.743468] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.9.3
-1.el7.centos 04/01/2014
[  331.744300] RIP: 0010:pskb_expand_head+0x27b/0x310
[  331.744747] Code: df e8 69 fc ff ff e9 ab fe ff ff 44 2b 6c 24 04 44 
01 ab d0
  00 00 00 48 83 c4 08 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 0b <0f> 
0b be 02
  00 00 00 e8 89 4e ad ff 8b 83 bc 00 00 00 48 03 83 c0
[  331.746414] RSP: 0018:ffffbae4c0003d08 EFLAGS: 00010202
[  331.746892] RAX: 000000000000013f RBX: ffff9e0a8367ad00 RCX: 
0000000000000a20
[  331.747534] RDX: 0000000000000002 RSI: 0000000000000100 RDI: 
ffff9e0a8367ad00
[  331.748192] RBP: ffffbae4c00b2000 R08: 0000000000000001 R09: 
000000000000000e
[  331.748834] R10: ffffbae4c0003eb8 R11: 00000000ef974e19 R12: 
ffff9e0a86ecf000
[  331.749472] R13: 0000000000000001 R14: ffff9e0a8367ad00 R15: 
ffff9e0a8367ad00
[  331.750119] FS:  00007ff0806c5e00(0000) GS:ffff9e0abae00000(0000) 
knlGS:00000
00000000000
[  331.750848] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  331.751379] CR2: 00007ff0806c01d8 CR3: 0000000106e00006 CR4: 
0000000000370ef0
[  331.752022] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  331.752665] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  331.753307] Call Trace:
[  331.753535]  <IRQ>
[  331.753736]  do_xdp_generic.part.157+0xa3/0x550
[  331.754151]  __netif_receive_skb_core+0x67e/0x12b0
[  331.754588]  ? process_backlog+0x86/0x250
[  331.754961]  ? __netif_receive_skb_one_core+0x3c/0xa0
[  331.755419]  __netif_receive_skb_one_core+0x3c/0xa0
[  331.755865]  process_backlog+0xf5/0x250
[  331.756215]  net_rx_action+0x144/0x440
[  331.756559]  __do_softirq+0xe4/0x493
[  331.756894]  asm_call_irq_on_stack+0x12/0x20
[  331.757282]  </IRQ>
[  331.757478]  ? dev_direct_xmit+0x1e8/0x230
[  331.757856]  do_softirq_own_stack+0x81/0xa0
[  331.758244]  do_softirq.part.16+0x3c/0x80
[  331.758611]  __local_bh_enable_ip+0xda/0xe0
[  331.758995]  dev_direct_xmit+0x20d/0x230
[  331.759356]  __xsk_sendmsg+0x314/0x3d0
[  331.759704]  sock_sendmsg+0x5b/0x60
[  331.760025]  __sys_sendto+0xf1/0x160
[  331.760355]  ? lockdep_hardirqs_on+0xbf/0x130
[  331.760759]  ? syscall_enter_from_user_mode+0x1c/0x50
[  331.761216]  __x64_sys_sendto+0x24/0x30
[  331.761563]  do_syscall_64+0x33/0x40
[  331.761895]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  331.762357] RIP: 0033:0x7ff08c8b9633
[  331.762689] Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 
34 c3 48
  83 ec 08 e8 1b f7 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 
8b 3c 24
  48 89 c2 e8 61 f7 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[  331.764356] RSP: 002b:00007ff0806c55c0 EFLAGS: 00000293 ORIG_RAX: 
00000000000
0002c
[  331.765038] RAX: ffffffffffffffda RBX: 00007ff0780009b0 RCX: 
00007ff08c8b9633
[  331.765684] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
0000000000000008
[  331.766324] RBP: 0000000000000040 R08: 0000000000000000 R09: 
0000000000000000
[  331.766969] R10: 0000000000000040 R11: 0000000000000293 R12: 
0000000000000040
[  331.767608] R13: 0000000000000040 R14: 0000000000000000 R15: 
0000000000cd4030
[  331.768261] Modules linked in:
[  331.768596] ---[ end trace d9ca37a7957928dd ]---
[  331.769126] RIP: 0010:pskb_expand_head+0x27b/0x310
[  331.769678] Code: df e8 69 fc ff ff e9 ab fe ff ff 44 2b 6c 24 04 44 
01 ab d0
  00 00 00 48 83 c4 08 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 0b <0f> 
0b be 02
  00 00 00 e8 89 4e ad ff 8b 83 bc 00 00 00 48 03 83 c0
[  331.771459] RSP: 0018:ffffbae4c0003d08 EFLAGS: 00010202
[  331.772043] RAX: 000000000000013f RBX: ffff9e0a8367ad00 RCX: 
0000000000000a20
[  331.772784] RDX: 0000000000000002 RSI: 0000000000000100 RDI: 
ffff9e0a8367ad00
[  331.773526] RBP: ffffbae4c00b2000 R08: 0000000000000001 R09: 
000000000000000e
[  331.774293] R10: ffffbae4c0003eb8 R11: 00000000ef974e19 R12: 
ffff9e0a86ecf000
[  331.775049] R13: 0000000000000001 R14: ffff9e0a8367ad00 R15: 
ffff9e0a8367ad00
[  331.775901] FS:  00007ff0806c5e00(0000) GS:ffff9e0abae00000(0000) 
knlGS:00000
00000000000
[  331.776809] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  331.777455] CR2: 00007ff0806c01d8 CR3: 0000000106e00006 CR4: 
0000000000370ef0
[  331.778232] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  331.778989] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  331.779739] Kernel panic - not syncing: Fatal exception in interrupt
[  331.780523] Kernel Offset: 0xb800000 from 0xffffffff81000000 
(relocation rang
e: 0xffffffff80000000-0xffffffffbfffffff)
[  331.781488] ---[ end Kernel panic - not syncing: Fatal exception in 
interrupt
  ]---

In any case, kernel should not panic. You or somebody familiar with xsk
may want to take a look.

> 
> Thanks: Weqaar
> 
> Weqaar Janjua (5):
>    selftests/bpf: xsk selftests framework
>    selftests/bpf: xsk selftests - SKB POLL, NOPOLL
>    selftests/bpf: xsk selftests - DRV POLL, NOPOLL
>    selftests/bpf: xsk selftests - Socket Teardown - SKB, DRV
>    selftests/bpf: xsk selftests - Bi-directional Sockets - SKB, DRV
> 
>   tools/testing/selftests/bpf/Makefile          |   15 +-
>   .../bpf/test_xsk_drv_bidirectional.sh         |   23 +
>   .../selftests/bpf/test_xsk_drv_nopoll.sh      |   20 +
>   .../selftests/bpf/test_xsk_drv_poll.sh        |   20 +
>   .../selftests/bpf/test_xsk_drv_teardown.sh    |   20 +
>   .../selftests/bpf/test_xsk_prerequisites.sh   |  127 ++
>   .../bpf/test_xsk_skb_bidirectional.sh         |   20 +
>   .../selftests/bpf/test_xsk_skb_nopoll.sh      |   20 +
>   .../selftests/bpf/test_xsk_skb_poll.sh        |   20 +
>   .../selftests/bpf/test_xsk_skb_teardown.sh    |   20 +
>   tools/testing/selftests/bpf/xdpxceiver.c      | 1056 +++++++++++++++++
>   tools/testing/selftests/bpf/xdpxceiver.h      |  158 +++
>   tools/testing/selftests/bpf/xsk_env.sh        |   28 +
>   tools/testing/selftests/bpf/xsk_prereqs.sh    |  119 ++
>   14 files changed, 1664 insertions(+), 2 deletions(-)
[...]
