Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F08B2D1B56
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgLGUxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:53:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51204 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727301AbgLGUxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 15:53:37 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B7KmxaY031836;
        Mon, 7 Dec 2020 12:52:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=DewL07eobBucxBKNeOJhngHrWZOgHI9/u5RBOA7Yv4I=;
 b=TOJ4VWXZM4AuiT5g64r8qWj0b6nURLlCthPUf4iFzheL5XelTKn+TfDBfLIXwWxpOjji
 xurfBzrzFVS+GzOW1Jw80qz53yAQogw+eMsJxF9ADPuRwuHLZWM+YhzyHxC4Ms1QEWmd
 n0Lo1zcPWRhxGamQ+v+zG9Gy6k9VSxSDRjA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 358u4d9ar5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Dec 2020 12:52:36 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 12:52:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1CTm+qs4deJD6xSmk7BW0SibboMpOSDJWseslgwd+fL2a9xoZnYFmLD+xzEfqwwz0+elRaF0sIJYEYYrqXIjO+zpEgFqsp/N7YoiPtCDnr2cLJtz3wiLQF+j6EJizyuxZBFgZZMLWkbc9lPaj6OL3cVJo85ui2Svx61TesrezAVKB6JKDzpOId0w7Wg26eb5043k7VQgQfWsS2sLsBp/NaSkkRMugpC7VsI8QcZTMOBRPM7FgiHq3Cmt+wVBmoVMj83vwSKq8zYMOoO++X5PfuTKJvQ6prFNDeXvusHcPXGI9kjGwH8zdKnEMDSV0JBoAxE3sZEpHzmB2ooehKwSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DewL07eobBucxBKNeOJhngHrWZOgHI9/u5RBOA7Yv4I=;
 b=F5M51fK8Fni87vCSqbuC1eUZIdHaTtc5g3lCvuy2vL01Q/5IGMmFCcz4ODzOVQIjsVQtctbayPsdogu5Tsm0EjQbkwVWQZLRnf0f/GyP4naRu8kDAft1crbfran3lC/jfqm4/wNL0QGzT42TzMCVcNqGaBtJvMGwT69KvlOruyAJh6qajoefMIbEWdOb1mbvERoOdQnokYBlUvYVub0Mms7FKbE6i/zNlPEDmPtGGDYKx2Kteo/2engUSUvdGPucYt17Pd29cEzRbP3dU/PIAKke/XqBdeCyFeX2dIijCAo0ws5uUqlye9DUFDsIW5au7NfKF8he6s0FwqpH00zoLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DewL07eobBucxBKNeOJhngHrWZOgHI9/u5RBOA7Yv4I=;
 b=HsUSOSEv1QSl1WD4AVNpNYkelL2Grg4tJawNoO1TRq5AE/4uKnft0LNWDZYCNt2qrYh9eoDAOZR+bkHzjyww72QTFBQQUXDRWyats2ksSWXlp9JoXV6POV1AzyGGxCvmSSTf967kl7NlTtJ4w8zGiMW+yfkpTcVPd1ijJAtm8bo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY5PR15MB3684.namprd15.prod.outlook.com (2603:10b6:a03:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Mon, 7 Dec
 2020 20:52:32 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%6]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 20:52:32 +0000
Date:   Mon, 7 Dec 2020 12:52:27 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH bpf-next] bpf: avoid overflows involving hash elem_size
Message-ID: <20201207205227.GD2238414@carbon.dhcp.thefacebook.com>
References: <20201207182821.3940306-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207182821.3940306-1-eric.dumazet@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:f5f]
X-ClientProxiedBy: CO2PR04CA0118.namprd04.prod.outlook.com
 (2603:10b6:104:7::20) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:f5f) by CO2PR04CA0118.namprd04.prod.outlook.com (2603:10b6:104:7::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Mon, 7 Dec 2020 20:52:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbf64a52-b32d-4273-e60b-08d89af204ec
X-MS-TrafficTypeDiagnostic: BY5PR15MB3684:
X-Microsoft-Antispam-PRVS: <BY5PR15MB3684AAB4DA81DB37FDB47994BECE0@BY5PR15MB3684.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+goCVWx16cFdWh6abM5p+tGk0bCmCFNRytGXb9vX2nUvYFVHusEHviKPebTGIdjCdQW822/oSLQYwbCTnRxuhgmI1wltMvCQ02SKrwpgVVl7tW6iZCf89ejBjK6lWr884eUPzC+kUV3FanZDfmLLdFUtesv7YzlYh3FhPSE0A0EG8JofqBI+T2239b1WRVcJOuDgujs9q7XczW1UD223LMZaJmusuK23fd9ZqK7Zgxf7vHpm4G5sA1hKlF2xjig+T/2nOrAWXz2U9p2sqIi7tc8WqkLKUXo3NldTWt2QS1Mng+hCzZpJjEb1imK5cmc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(376002)(346002)(396003)(1076003)(186003)(8676002)(2906002)(55016002)(6506007)(6666004)(4326008)(66556008)(33656002)(8936002)(66476007)(7696005)(316002)(16526019)(6916009)(5660300002)(9686003)(66946007)(478600001)(54906003)(86362001)(52116002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cOrOYffpTAKspSHBK0h3bs0KoZglP+9eqbOVWSQue+qcwCAfb70P7QlVSKVw?=
 =?us-ascii?Q?JK2WtQqr9bZuT8Tl8vgG9peK2QBECnYTp5h+Yo3HwvipNcu+NnNUvyxzhi03?=
 =?us-ascii?Q?54dKM3SW7/PWSXaOb4tk7s4rJaFpnTyXeJ35ayLzWIWvcqd3H4IckafCxMZx?=
 =?us-ascii?Q?xQuDyWcQF+RcDGWGOhFNHSTFvFs9to49j+7l8ldvVWyrCqmJgX6DD4k/od6+?=
 =?us-ascii?Q?DGI3uN0+muyZHdbL4yMOvjlm8BM0IsHKxm9EWZwsSrgfzbSwF//7q31tBC/4?=
 =?us-ascii?Q?brG77xmGanvm5v6JCsTUQWVcSoxKJv1/mCWPs8u32DZi4QHJfrAJhujoKWXj?=
 =?us-ascii?Q?laHLOCigbvQQkVn5bm1p2i0FCz0EwxNeeNpBJykQVdB229hQxOsPAPCFCtDO?=
 =?us-ascii?Q?l8GGR+7aA8xKeYyvlN6VZmzU8xc7RqIiIiApYQZ6g1hp3N84X1tLs7a+waOh?=
 =?us-ascii?Q?spp9DZ7WIFzivgSdJfGH2RlvKekW1Qu3C3uaPvRkL0lFcXbNZaZJ+SWAWgiJ?=
 =?us-ascii?Q?raO7Rx1hq37DaA1VcL6cbXIdesV4Jo0FqyxPcuVFq21EbYqrYnSGNBRLhbl8?=
 =?us-ascii?Q?T9jnRS04Zp8duukTvsF2yRhdZC8Yv8ac6Kn082mlutUOX0c3sV4BkAwlLR45?=
 =?us-ascii?Q?8WRcVTcrGSSgOxPaMF8jkM8RvC0kg27/Qiz7TXid7JfFPaSWVUgNye2CbOEb?=
 =?us-ascii?Q?qHhYb5v3qIr2PKLRygFLZsVxY0Y2Rj4SGuDyOmi9YSr3KXGAe+5hhWtzSu9Z?=
 =?us-ascii?Q?JU5HbX9G63yJnBPs66mc8Elc17Zf/I4PlZmTIA8VtWkLseOBc+3zJFmTdm80?=
 =?us-ascii?Q?c5bcGNRzCm/TWGLf3s9C7GY9+ggIfmOsH1DFS5eDQjwglPY235trW1UfxTyR?=
 =?us-ascii?Q?+AiWHWTsMSM0XnJjqjUax7AbLHYbJxy6OWJ3HpxFUb2N6MFM0kzJPYlM7FwC?=
 =?us-ascii?Q?F/3dzS3X8qwvTVGM8nuu15vXgoCqje/M9aYK0RCorQzxRn6AxJ+bmWLCSygl?=
 =?us-ascii?Q?47AEDskqMXKb7kX/o53gnjj75g=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 20:52:32.7223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf64a52-b32d-4273-e60b-08d89af204ec
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffBYMafSBe5F/S4dHTceEbMLMbcZ8gZpQZ4aBFKSlxSU1bE5A9U0rHLLYTYciX6P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3684
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_16:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 mlxscore=0
 adultscore=0 impostorscore=0 suspectscore=1 mlxlogscore=923
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070134
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 10:28:21AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Use of bpf_map_charge_init() was making sure hash tables would not use more
> than 4GB of memory.
> 
> Since the implicit check disappeared, we have to be more careful
> about overflows, to support big hash tables.
> 
> syzbot triggers a panic using :
> 
> bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_LRU_HASH, key_size=16384, value_size=8,
>                      max_entries=262200, map_flags=0, inner_map_fd=-1, map_name="",
>                      map_ifindex=0, btf_fd=-1, btf_key_type_id=0, btf_value_type_id=0,
>                      btf_vmlinux_value_type_id=0}, 64) = ...
> 
> BUG: KASAN: vmalloc-out-of-bounds in bpf_percpu_lru_populate kernel/bpf/bpf_lru_list.c:594 [inline]
> BUG: KASAN: vmalloc-out-of-bounds in bpf_lru_populate+0x4ef/0x5e0 kernel/bpf/bpf_lru_list.c:611
> Write of size 2 at addr ffffc90017e4a020 by task syz-executor.5/19786
> 
> CPU: 0 PID: 19786 Comm: syz-executor.5 Not tainted 5.10.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0x5/0x4c8 mm/kasan/report.c:385
>  __kasan_report mm/kasan/report.c:545 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
>  bpf_percpu_lru_populate kernel/bpf/bpf_lru_list.c:594 [inline]
>  bpf_lru_populate+0x4ef/0x5e0 kernel/bpf/bpf_lru_list.c:611
>  prealloc_init kernel/bpf/hashtab.c:319 [inline]
>  htab_map_alloc+0xf6e/0x1230 kernel/bpf/hashtab.c:507
>  find_and_alloc_map kernel/bpf/syscall.c:123 [inline]
>  map_create kernel/bpf/syscall.c:829 [inline]
>  __do_sys_bpf+0xa81/0x5170 kernel/bpf/syscall.c:4336
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45deb9
> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fd93fbc0c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000001a40 RCX: 000000000045deb9
> RDX: 0000000000000040 RSI: 0000000020000280 RDI: 0000000000000000
> RBP: 000000000119bf60 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf2c
> R13: 00007ffc08a7be8f R14: 00007fd93fbc19c0 R15: 000000000119bf2c
> 
> Fixes: 755e5d55367a ("bpf: Eliminate rlimit-based memory accounting for hashtab maps")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Roman Gushchin <guro@fb.com>
> ---

Good catch, thank you!

Acked-by: Roman Gushchin <guro@fb.com>

It looks like there are a couple more places like this, I'll check them and send
a separate patch.

Thanks!
