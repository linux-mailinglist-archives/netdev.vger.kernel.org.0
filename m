Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C0D20FAEB
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 19:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbgF3RoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 13:44:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40044 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726554AbgF3RoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 13:44:05 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05UHi0o2019793;
        Tue, 30 Jun 2020 10:44:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vuvBDUlrN+2uQDGTO2qlVs1+v5jlBE6SJaWshXgEjck=;
 b=JELdGRwzx/g9orcZ1dEuK0/JB7rMuImhBuYN7OLGzknkQKXppLtHyVst8bcivdSnfxD3
 UWHvfBCeSMku6grO5fMQpXIgoADIUE1TWd7c4+ogxZiY6ulZjr1GpHHK3ecitUqvL5D3
 Q9lG4xcwCKPomgCgj+O9Y0FUJxAVvp7hr68= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31xntbu7h3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jun 2020 10:44:04 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 10:43:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+eroFLRxHqE6D5oqR4T/5diN4Rvh4BPoqZZZ6BovCBlEdDrfE8R67wDERJqRDoP1xjMh4YMwNqeuebnB5+YcjiNcimN6RyIpJsAQK3BLB6PrvNRUka+Odl5uOrY2nQvwZ4HxJoomC3RmKD75WW/gLHwRoPHReciIFcpa/Z4sN8/gDNPEnotM4kIwjs23XLhkXLgvSvLc/oZu7hRHdBbBNXyhEU7loWRro0SSMYLDDcefemz2lWAG7+y8HsVRqfJtOTqtEh6tDK8qaMvCUiMk5if81C57gYXr9XmDhmrYvzHILhbtZTuavAysVb6VtxEsrEafSzQZuBM/96cqnvS7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuvBDUlrN+2uQDGTO2qlVs1+v5jlBE6SJaWshXgEjck=;
 b=YACd9EFFmyI21az/dLhVzsoUUmzJBF12PrWI51n5h4ld5jsh8d9V1S2PK4pNuKvSP0W5/Oc3riKm/zHUm9eYKtluLTOnUZAVNxMKj3mZNfLG9WkALjp9NAWarw+EaX4fdzmu7I8HzjgLHKEFGMk2ZymOvrzXEpPP16yMTJZe2mjTgWYGXFTvkEz2e0qhpJwLRZI/+mx4mU4UkK7dN/83G3Sd6dd0ecLf30YxvkqxInTvZ3whYA/XKMOg5KeHRoESVPc6kY35xhQ1wntug8XbYZgkLTZQBiekC+0ANyoiZGCc6UvKW7BzlnRPuYN55pHbYlTPSMYYhbtZalE0lF2eNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuvBDUlrN+2uQDGTO2qlVs1+v5jlBE6SJaWshXgEjck=;
 b=db3XqQBcOyhgt94ihiI0cT9KRyaDLL+8/Rd3osUXrxDutEV6eBZZGJdndT8wr3OtSVi/2cGbKdyw9tpDE+4gVEOi8zdSu4JhOnlh1yLjvNnVxxfU56utMoheXKFOv32b8zwBu3lDz58gOlZixNOj3HhpV11fnKREtvVq3uZ3XDo=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2695.namprd15.prod.outlook.com (2603:10b6:a03:150::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Tue, 30 Jun
 2020 17:43:57 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 17:43:57 +0000
Subject: Re: [PATCH bpf-next] bpf, netns: Fix use-after-free in pernet
 pre_exit callback
To:     Jakub Sitnicki <jakub@cloudflare.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-team@cloudflare.com>
References: <20200630164541.1329993-1-jakub@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <12bcae81-dae2-4480-fd27-21508912a06f@fb.com>
Date:   Tue, 30 Jun 2020 10:43:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200630164541.1329993-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0068.namprd02.prod.outlook.com
 (2603:10b6:a03:54::45) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::15c2] (2620:10d:c090:400::5:c3b5) by BYAPR02CA0068.namprd02.prod.outlook.com (2603:10b6:a03:54::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 17:43:56 +0000
X-Originating-IP: [2620:10d:c090:400::5:c3b5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2b097a1-0cf7-474f-8765-08d81d1d2a33
X-MS-TrafficTypeDiagnostic: BYAPR15MB2695:
X-Microsoft-Antispam-PRVS: <BYAPR15MB26957EB74FB2BAB166B9C9FCD36F0@BYAPR15MB2695.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HIAfP+u89Bw750EXL52ImusDmrdujP9D9qfydrpN3pBrr19OXApbKJ+C56Rtyoh0KjSsve8TW2LluZSwVuStyhjIZQXexb2JcyRYgooE+0hQoTpOXgdqXHcN03kSKFu1zXdmyR6F7Ty4JbEAV9ayBFX72vOmEI9iGRWUtFxMiBZrAHgfiyfnOfSjlLM+JajnHN5+Xsj+p2c/51vLHo/aVrLIpvixpkuITBJi31OeMYlgfdSHQovxHDPzqFguW+a1U85Sgpgdge3EmcU6I5bChC5KGuXSn3ODVbK8DiGacdbAzYJEOhk0uDPyODAUVTb0f7oRuQ3LzgAK86UQL2zZmZfNlr+ZlKFR+HTPq+GU/J3jGIFJuwToPpChd6+Yvgu2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(346002)(376002)(396003)(136003)(366004)(31686004)(2616005)(16526019)(186003)(53546011)(52116002)(6486002)(86362001)(36756003)(31696002)(8676002)(5660300002)(478600001)(316002)(4326008)(83380400001)(8936002)(66946007)(2906002)(66476007)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SrInRFaBKHOoWIl2ofVr5PZJrTgl3dRvFAQj7g0dGE23Lv3FhvLpS9/kFSl4IhYNsVvjRA8yrwYGSaIgr2gSQa0pvZDddHLLl3KXe0HMs0TWjDvKXe4X0W8KAaKfdeU7T/m8Zqy7aoKDK72xownOMq0fGLZn4JLTBL7LMWisBxWXkIXqiUWqIUNzUMBm8/Er0dbopFH6MteKELXhSUCL4SUNGNgE9i/R93J5GLa5tCZoSm4eOA365WlIaXzNNaXz1KzNzWe/Wh9NkytI1HqVzAUEhXIE3yaTFUgaHr7OMUCyRiHKQfREYij1lIUGChCpNm3Uea9j4Y9yMMlCI3cYb4uK3JSKKfoKRLj6fIdh14F1rprCyDefV2yg1AXoisfZ4fm/4YW5DA06LZO9BeH2EBlcAx3LsdYS/wZFmUFFOs5RqOgtANhDHDzzyDXiT772QCgW6/Fv+RgqtT2u2qLONg6jrMVuycrQPkUCpbbmNP3FMvO8eY3xokpF8D5+ZD8vKyG5fZiLEpkSHUh+qijqtw==
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b097a1-0cf7-474f-8765-08d81d1d2a33
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 17:43:57.4221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jU9kfhEVno15mln+bzA91352rj/azd9Kq4Eji+qwOgIC43Wl3Z2NSus3XQRq9xzy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2695
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxscore=0 clxscore=1015
 bulkscore=0 spamscore=0 suspectscore=2 impostorscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/20 9:45 AM, Jakub Sitnicki wrote:
> Iterating over BPF links attached to network namespace in pre_exit hook is
> not safe, even if there is just one. Once link gets auto-detached, that is
> its back-pointer to net object is set to NULL, the link can be released and
> freed without waiting on netns_bpf_mutex, effectively causing the list
> element we are operating on to be freed.
> 
> This leads to use-after-free when trying to access the next element on the
> list, as reported by KASAN. Bug can be triggered by destroying a network
> namespace, while also releasing a link attached to this network namespace.
> 
> | ==================================================================
> | BUG: KASAN: use-after-free in netns_bpf_pernet_pre_exit+0xd9/0x130
> | Read of size 8 at addr ffff888119e0d778 by task kworker/u8:2/177
> |
> | CPU: 3 PID: 177 Comm: kworker/u8:2 Not tainted 5.8.0-rc1-00197-ga0c04c9d1008-dirty #776
> | Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> | Workqueue: netns cleanup_net
> | Call Trace:
> |  dump_stack+0x9e/0xe0
> |  print_address_description.constprop.0+0x3a/0x60
> |  ? netns_bpf_pernet_pre_exit+0xd9/0x130
> |  kasan_report.cold+0x1f/0x40
> |  ? netns_bpf_pernet_pre_exit+0xd9/0x130
> |  netns_bpf_pernet_pre_exit+0xd9/0x130
> |  cleanup_net+0x30b/0x5b0
> |  ? unregister_pernet_device+0x50/0x50
> |  ? rcu_read_lock_bh_held+0xb0/0xb0
> |  ? _raw_spin_unlock_irq+0x24/0x50
> |  process_one_work+0x4d1/0xa10
> |  ? lock_release+0x3e0/0x3e0
> |  ? pwq_dec_nr_in_flight+0x110/0x110
> |  ? rwlock_bug.part.0+0x60/0x60
> |  worker_thread+0x7a/0x5c0
> |  ? process_one_work+0xa10/0xa10
> |  kthread+0x1e3/0x240
> |  ? kthread_create_on_node+0xd0/0xd0
> |  ret_from_fork+0x1f/0x30
> |
> | Allocated by task 280:
> |  save_stack+0x1b/0x40
> |  __kasan_kmalloc.constprop.0+0xc2/0xd0
> |  netns_bpf_link_create+0xfe/0x650
> |  __do_sys_bpf+0x153a/0x2a50
> |  do_syscall_64+0x59/0x300
> |  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> |
> | Freed by task 198:
> |  save_stack+0x1b/0x40
> |  __kasan_slab_free+0x12f/0x180
> |  kfree+0xed/0x350
> |  process_one_work+0x4d1/0xa10
> |  worker_thread+0x7a/0x5c0
> |  kthread+0x1e3/0x240
> |  ret_from_fork+0x1f/0x30
> |
> | The buggy address belongs to the object at ffff888119e0d700
> |  which belongs to the cache kmalloc-192 of size 192
> | The buggy address is located 120 bytes inside of
> |  192-byte region [ffff888119e0d700, ffff888119e0d7c0)
> | The buggy address belongs to the page:
> | page:ffffea0004678340 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
> | flags: 0x2fffe0000000200(slab)
> | raw: 02fffe0000000200 ffffea00045ba8c0 0000000600000006 ffff88811a80ea80
> | raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
> | page dumped because: kasan: bad access detected
> |
> | Memory state around the buggy address:
> |  ffff888119e0d600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> |  ffff888119e0d680: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> | >ffff888119e0d700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> |                                                                 ^
> |  ffff888119e0d780: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> |  ffff888119e0d800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> | ==================================================================
> 
> Remove the "fast-path" for releasing a link that got auto-detached by a
> dying network namespace to fix it. This way as long as link is on the list
> and netns_bpf mutex is held, we have a guarantee that link memory can be
> accessed.
> 
> An alternative way to fix this issue would be to safely iterate over the
> list of links and ensure there is no access to link object after detaching
> it. But, at the moment, optimizing synchronization overhead on link release
> without a workload in mind seems like an overkill.
> 
> Fixes: 7233adc8b69b ("bpf, netns: Keep a list of attached bpf_link's")
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Acked-by: Yonghong Song <yhs@fb.com>
