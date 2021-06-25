Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A90F3B3CA7
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 08:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhFYG2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 02:28:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28994 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230097AbhFYG17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 02:27:59 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15P6NDib030921;
        Thu, 24 Jun 2021 23:25:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QtEa7V7ds3GDvFZVWsu+3axUDSBMd0jghLtlY4WnnQU=;
 b=N1/vaXz7fMI+STb8PPYrQDKDLqxSInWR+oQGWQmNvXclzRxyQBzDnosUJWOMixARGZdP
 G91tk27uwZ7VMsQDi1u5xHY+AS76loTw2qqB6PZPOPRg/9CyaNJmNEax/Eo0o2ezk5sl
 4xrJmgm9VST7qJe+dWetnu2i/R6bskIFrcQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39d23ja5qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 24 Jun 2021 23:25:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 24 Jun 2021 23:25:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTBFvK4OdQvT9Rn6njzQEDGD1c1lueZM0TmgeqG1ScwDi3hIV4zz6tET0cN1x9+XGh9sPmlrG3N4AQnzisXqLQPOTi9M9jtgOmMeWbaMFvHHUfc60xoFwdVr0pBxv3+r+Kx5XIHq6Vd/sqendkGb/XmpuobaADcducEqi4+cDj3ew1RWUt3dGePaCTgUSlEJLYjMefSWKXbI5JzsW7rkJxCC0HhFo7rYiYUKHvpekcLHdqcMGfdoNQZmUqJ6Dbq9Om1Jzi7rMBIl7cJRdXXr4xsMMbPUEjSolhzZw02Whm0nun2XVubxTtxh46zQcyw3I2dV5mFAtIARfRJMBX/6cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QtEa7V7ds3GDvFZVWsu+3axUDSBMd0jghLtlY4WnnQU=;
 b=lclo0Zux8vuU9x219dd3v6unskyfyG6/06+HdGiW5aPrNoYzVitu4ZNCDxuPuIpK2yoiOEzNGiwPJqLYE4qW2CVkCXrU1EPkdEJ580rSrnBkQ3N3s2OzEFtsolocXiDcw4l9lREuDL6JPQ5zyygl93mAKVPZReKM+BvCP/aFZXKYce+VEVavUaRb1+rskms8oHkndk99irNDLZBSSDxFLxedloGTwW+IsY4s3mFXuE5xFNKbMI87Qb006gAc+FDNGYHuVv6FahfU1hrjUWFl/8ckF2LJP9RAfxWW8h/JtK60nD/cap5GO0ZH7HHyF5XQbuP6akHFsNOhz2RVP+8OTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2061.namprd15.prod.outlook.com (2603:10b6:805:e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Fri, 25 Jun
 2021 06:25:16 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4264.020; Fri, 25 Jun 2021
 06:25:16 +0000
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4bf664bc-aad0-ef80-c745-af01fed8757a@fb.com>
Date:   Thu, 24 Jun 2021 23:25:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210624022518.57875-2-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:52b7]
X-ClientProxiedBy: CO2PR04CA0109.namprd04.prod.outlook.com
 (2603:10b6:104:7::11) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1328] (2620:10d:c090:400::5:52b7) by CO2PR04CA0109.namprd04.prod.outlook.com (2603:10b6:104:7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Fri, 25 Jun 2021 06:25:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8b6c8d5-cf71-4642-cefe-08d937a1ff1d
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2061:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB2061904450744A7C8B713211D3069@SN6PR1501MB2061.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dRWZ2M2xjBBagnvJX6Az15Kr7lYKHxwMwjt2jMdjNHHDRZQr2JhX0DfRXbFkmPA5fD68g3f8hyDvzfVpO7aDgmMqk0GB2B+9w9/E3ROZvSVkZcE1H9htAzovMZuqKU+Ff4zq47unD9I5r/VV/mgZ1fkGZffFiVOG2ByZ01izzQpMPMh0qsy+Vlf12s1wNaXmyOn6omPU+sQ2tWooP8EVLi9E5MV/JIdXGRf0ksWhR0HqLzwQ/OIAG9d17ZbFQiYWCgJmnlNa02a78HSNsR+XdiPAK03e0XgnRkSkW/wUPhEsOYUlGy3m1GpVVSrB8lCnUY7ThlqA5RtKq+1ezYXD1IL5CoB9/oX1rmwfYB6JYoyYvoiBzs/amY6gAy5aGWEO1PHqtBSGJ34qSD9Tw4tOCwgboTdOUZWhq/oUEe8sALF+VUEJJtu2f5LCBW/eXfkFVmdghYJ5QSQIGJk+nS40uSiIOw8ccgNPVU5DV0q13HgiaP3dE3xNHM0xzMoWUcHyB5D07UDuvfQG+K55AkDgSC28nXnOyaZVGtDCCbMiu7hKfWR1IFOWKMnKNPpy+z8upE3eDXGmJOAgs382ocSjsrG/LbIS2+rpWTpLZcC/Q7CmevvTMaTkfakiFTTGNlVvGgz7MYyiKQoFYIbVavF4iDTColPks9FKNNYhdDEDqUdQEcz3Yj22t3r9PHqJojuP+e/Di56KH55YamhSaaWckQEB5R/QRrzpGDUIn5Pac3I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(31696002)(8676002)(53546011)(83380400001)(6486002)(31686004)(66476007)(478600001)(6666004)(52116002)(66556008)(66946007)(2616005)(38100700002)(4326008)(2906002)(16526019)(36756003)(316002)(5660300002)(186003)(86362001)(8936002)(30864003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azUxd3ZSaG80cEI0dVJhNHM4TnhBMVRDeDNwOWJjbGJuWHdEWUlwWW8zeDNx?=
 =?utf-8?B?NFFQMk1uMG10dzN6QnZoZTIzb0lnQXQ3emNvMGtCb29IMGViWEI3cWZrb0VU?=
 =?utf-8?B?SkFsS2Q3NDVqd2hOMnZjSGQwbTZLUlpaclh6aTMzdVRpemdjUTQ0OVM2emJY?=
 =?utf-8?B?dWlrU3MzUExPMzZzR3hBdGlJVWpqTGZiVWZTa0pDeWwwNm5JMnkxRzQ2ZGky?=
 =?utf-8?B?ZklCYjZWbkNJNTdXdFJDWVZ5bjRFZWROK1hlYXVEclRNMUlndUdScDhpOE42?=
 =?utf-8?B?dkRwbWx5d3dkcy9KaWw4ekJ3ZDFsd3IxT0RQdFVkQTRPMFMvWDlLd2ZiR0lK?=
 =?utf-8?B?QUdBSkMramF2V1YvM1FLc2QxcEJRbUNSWnRDZkE4MHJGVTFlZk9heWFqSEc5?=
 =?utf-8?B?UGM4bTBmVFlQY21QMlRSdW9pQ0RSK09xbXB6NnNzbEp6VEFGYkttRTdDQjlM?=
 =?utf-8?B?WGRiOURiUFZMZytOazJ2c0t2NnBHTFNhMTNrMTkrWnVPaTRmNGNJYmpPZHBw?=
 =?utf-8?B?Nll3c1Z5VERzaUQ3THJiamM3Qkx2YWFpelpvWERlUFZkWVhJSzFqaDYvS21N?=
 =?utf-8?B?UXVoUjBkbjlHV3UyeEhWRjhSMnhvaDdlM1lSeFB1Qi96QitpZUN1MTFvNk5L?=
 =?utf-8?B?a0l6RzZIb2plbk5PUWxNZmt4bjFyUnNzODdROFNMWDNMRGV6SzNRRUorUEVL?=
 =?utf-8?B?YWdjOWNSdmNKZEN5Q0xGN05NUC9tME9Xc2Z6cW1CbUl1Zjg5YjJjb0dCeElh?=
 =?utf-8?B?MlRIVVBlSmQ1Y3ZrSUt6THF6cTZQRjEzakhlMHZPZFAxMXV1ZUlSclRBT0x4?=
 =?utf-8?B?enlxeU1tQ3RENG5XLzljTUhkbDdQTWdyTHRYM1psc3diek03NnEwMTJIUnZy?=
 =?utf-8?B?RENrd1ZRNVhFUWcyeHR3emcxQ01WOEdkbCtaa2R1UE54TDRHcUZBQUwzRUhk?=
 =?utf-8?B?WG5QeERDdlNiakUwaHdObWI3TlorWFNxeHpMVThROGlCM1Y1bUJtcDVPK2hS?=
 =?utf-8?B?cmp1TDNyQVpVRDBzemhZRUNGZ3NNNWpuZk9lZFlISlZNN0lyY3BDbjl0M24x?=
 =?utf-8?B?SkJCcFV0U3UyZHEwelFBT1VCSnY2LzVzbkFDUG1RSFI0amcyMG52MEVoMlEy?=
 =?utf-8?B?ZHM1em1BVHdqYmdtZWZyYXZRNkVaZ0R1b3I5YldNcWtXZ1lPaktXOFpFTUVF?=
 =?utf-8?B?VkNBVkFwTis5MnUwT3FyRnNCa0tWVlpKQ2xBc2JTZWpaNGtHWm1FVlg0bW1M?=
 =?utf-8?B?akZ0dkpGMG5xWC95NTFVUU1YK2IyTmdtVS9Lc0JxRGZRM0RJTmFlc1NUWUFO?=
 =?utf-8?B?YWs3L04xSTQ2NVl4L2ZOWXIzUzVHOEVNTWp5eTg4YkpCM3EwM0twRVlRQjlW?=
 =?utf-8?B?eWljeUpiN1h3ZnB4SkxqRWw3R1NZR1ROdkJnc2U3NzIzdDhaMHVZSEk1elpX?=
 =?utf-8?B?cW1ZVVFIeWpmY0hGaXFncld1TENmRkN4Vno4b0diNDY5cSs5dGdFWWQ5WDJV?=
 =?utf-8?B?SGMrZzh2YVJveG9DczNzaiswbWFSaitBQ20vNHpFVE5MMXR4dXpSdXJXUzBR?=
 =?utf-8?B?ZEd4Zk1oRmVYajUyd1FCeGNGa29mSzdTMVhiUjkwN2FrY1o3SElpdGZGUDBW?=
 =?utf-8?B?b015cnhsbENWdjBHaW1veHNLaEJOTGZhL2Q0aXRmZm41c0F6c3Q2SHJoTnI1?=
 =?utf-8?B?V0kxcFZSVVBUUHo5V2tNbFFsR2hwVEU5VDRUMHFnNE4wT2RvT1pIZldsR2RL?=
 =?utf-8?B?Z09Uc096eXlhUEM3Wm00S1NvMkRVY1NWMWVjdFFVSkFIZnlhOHluN0I0d1or?=
 =?utf-8?B?aXFXUHFjcTN6OWRQcnBEdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b6c8d5-cf71-4642-cefe-08d937a1ff1d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 06:25:16.0470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5pyuyJIXmbk30v1Z/kgo1gFPoZXlC3WaLLt+2TsWl9cAdTHEoov9vZojLqCcFy1i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2061
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: gslwGGHDAwdpV2IP4hFVLm2eQGzUA4Js
X-Proofpoint-GUID: gslwGGHDAwdpV2IP4hFVLm2eQGzUA4Js
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_02:2021-06-24,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250036
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/21 7:25 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
> in hash/array/lru maps as a regular field and helpers to operate on it:
> 
> // Initialize the timer.
> // First 4 bits of 'flags' specify clockid.
> // Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
> long bpf_timer_init(struct bpf_timer *timer, int flags);
> 
> // Arm the timer to call callback_fn static function and set its
> // expiration 'nsec' nanoseconds from the current time.
> long bpf_timer_start(struct bpf_timer *timer, void *callback_fn, u64 nsec);
> 
> // Cancel the timer and wait for callback_fn to finish if it was running.
> long bpf_timer_cancel(struct bpf_timer *timer);
> 
> Here is how BPF program might look like:
> struct map_elem {
>      int counter;
>      struct bpf_timer timer;
> };
> 
> struct {
>      __uint(type, BPF_MAP_TYPE_HASH);
>      __uint(max_entries, 1000);
>      __type(key, int);
>      __type(value, struct map_elem);
> } hmap SEC(".maps");
> 
> static int timer_cb(void *map, int *key, struct map_elem *val);
> /* val points to particular map element that contains bpf_timer. */
> 
> SEC("fentry/bpf_fentry_test1")
> int BPF_PROG(test1, int a)
> {
>      struct map_elem *val;
>      int key = 0;
> 
>      val = bpf_map_lookup_elem(&hmap, &key);
>      if (val) {
>          bpf_timer_init(&val->timer, CLOCK_REALTIME);
>          bpf_timer_start(&val->timer, timer_cb, 1000 /* call timer_cb2 in 1 usec */);
>      }
> }
> 
> This patch adds helper implementations that rely on hrtimers
> to call bpf functions as timers expire.
> The following patches add necessary safety checks.
> 
> Only programs with CAP_BPF are allowed to use bpf_timer.
> 
> The amount of timers used by the program is constrained by
> the memcg recorded at map creation time.
> 
> The bpf_timer_init() helper is receiving hidden 'map' argument and
> bpf_timer_start() is receiving hidden 'prog' argument supplied by the verifier.
> The prog pointer is needed to do refcnting of bpf program to make sure that
> program doesn't get freed while the timer is armed. This apporach relies on

apporach -> approach

> "user refcnt" scheme used in prog_array that stores bpf programs for
> bpf_tail_call. The bpf_timer_start() will increment the prog refcnt which is
> paired with bpf_timer_cancel() that will drop the prog refcnt. The
> ops->map_release_uref is responsible for cancelling the timers and dropping
> prog refcnt when user space reference to a map reaches zero.
> This uref approach is done to make sure that Ctrl-C of user space process will
> not leave timers running forever unless the user space explicitly pinned a map
> that contained timers in bpffs.
> 
> The bpf_map_delete_elem() and bpf_map_update_elem() operations cancel
> and free the timer if given map element had it allocated.
> "bpftool map update" command can be used to cancel timers.
> 
> The 'struct bpf_timer' is explicitly __attribute__((aligned(8))) because
> '__u64 :64' has 1 byte alignment of 8 byte padding.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>   include/linux/bpf.h            |   3 +
>   include/uapi/linux/bpf.h       |  55 +++++++
>   kernel/bpf/helpers.c           | 281 +++++++++++++++++++++++++++++++++
>   kernel/bpf/verifier.c          | 138 ++++++++++++++++
>   kernel/trace/bpf_trace.c       |   2 +-
>   scripts/bpf_doc.py             |   2 +
>   tools/include/uapi/linux/bpf.h |  55 +++++++
>   7 files changed, 535 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index f309fc1509f2..72da9d4d070c 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -168,6 +168,7 @@ struct bpf_map {
>   	u32 max_entries;
>   	u32 map_flags;
>   	int spin_lock_off; /* >=0 valid offset, <0 error */
> +	int timer_off; /* >=0 valid offset, <0 error */
>   	u32 id;
>   	int numa_node;
>   	u32 btf_key_type_id;
> @@ -221,6 +222,7 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
>   }
>   void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
>   			   bool lock_src);
> +void bpf_timer_cancel_and_free(void *timer);
>   int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size);
>   
>   struct bpf_offload_dev;
> @@ -314,6 +316,7 @@ enum bpf_arg_type {
>   	ARG_PTR_TO_FUNC,	/* pointer to a bpf program function */
>   	ARG_PTR_TO_STACK_OR_NULL,	/* pointer to stack or NULL */
>   	ARG_PTR_TO_CONST_STR,	/* pointer to a null terminated read-only string */
> +	ARG_PTR_TO_TIMER,	/* pointer to bpf_timer */
>   	__BPF_ARG_TYPE_MAX,
>   };
>   
[...]
> +
> +static DEFINE_PER_CPU(struct bpf_hrtimer *, hrtimer_running);
> +
> +static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
> +{
> +	struct bpf_hrtimer *t = container_of(hrtimer, struct bpf_hrtimer, timer);
> +	struct bpf_map *map = t->map;
> +	void *value = t->value;
> +	struct bpf_timer_kern *timer = value + map->timer_off;
> +	struct bpf_prog *prog;
> +	void *callback_fn;
> +	void *key;
> +	u32 idx;
> +	int ret;
> +
> +	____bpf_spin_lock(&timer->lock);

I think we may still have some issues.
Case 1:
   1. one bpf program is running in process context,
      bpf_timer_start() is called and timer->lock is taken
   2. timer softirq is triggered and this callback is called

Case 2:
   1. this callback is called, timer->lock is taken
   2. a nmi happens and some bpf program is called (kprobe, tracepoint,
      fentry/fexit or perf_event, etc.) and that program calls
      bpf_timer_start()

So we could have deadlock in both above cases?

> +	/* callback_fn and prog need to match. They're updated together
> +	 * and have to be read under lock.
> +	 */
> +	prog = t->prog;
> +	callback_fn = t->callback_fn;
> +
> +	/* wrap bpf subprog invocation with prog->refcnt++ and -- to make
> +	 * sure that refcnt doesn't become zero when subprog is executing.
> +	 * Do it under lock to make sure that bpf_timer_start doesn't drop
> +	 * prev prog refcnt to zero before timer_cb has a chance to bump it.
> +	 */
> +	bpf_prog_inc(prog);
> +	____bpf_spin_unlock(&timer->lock);
> +
> +	/* bpf_timer_cb() runs in hrtimer_run_softirq. It doesn't migrate and
> +	 * cannot be preempted by another bpf_timer_cb() on the same cpu.
> +	 * Remember the timer this callback is servicing to prevent
> +	 * deadlock if callback_fn() calls bpf_timer_cancel() on the same timer.
> +	 */
> +	this_cpu_write(hrtimer_running, t);

This is not protected by spinlock, in bpf_timer_cancel() and
bpf_timer_cancel_and_free(), we have spinlock protected read, so
there is potential race conditions if callback function and 
helper/bpf_timer_cancel_and_free run in different context?

> +	if (map->map_type == BPF_MAP_TYPE_ARRAY) {
> +		struct bpf_array *array = container_of(map, struct bpf_array, map);
> +
> +		/* compute the key */
> +		idx = ((char *)value - array->value) / array->elem_size;
> +		key = &idx;
> +	} else { /* hash or lru */
> +		key = value - round_up(map->key_size, 8);
> +	}
> +
> +	ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
> +					 (u64)(long)key,
> +					 (u64)(long)value, 0, 0);
> +	WARN_ON(ret != 0); /* Next patch moves this check into the verifier */
> +	bpf_prog_put(prog);
> +
> +	this_cpu_write(hrtimer_running, NULL);
> +	return HRTIMER_NORESTART;
> +}
> +
> +BPF_CALL_3(bpf_timer_init, struct bpf_timer_kern *, timer, u64, flags,
> +	   struct bpf_map *, map)
> +{
> +	clockid_t clockid = flags & (MAX_CLOCKS - 1);
> +	struct bpf_hrtimer *t;
> +	int ret = 0;
> +
> +	BUILD_BUG_ON(MAX_CLOCKS != 16);
> +	BUILD_BUG_ON(sizeof(struct bpf_timer_kern) > sizeof(struct bpf_timer));
> +	BUILD_BUG_ON(__alignof__(struct bpf_timer_kern) != __alignof__(struct bpf_timer));
> +
> +	if (flags >= MAX_CLOCKS ||
> +	    /* similar to timerfd except _ALARM variants are not supported */
> +	    (clockid != CLOCK_MONOTONIC &&
> +	     clockid != CLOCK_REALTIME &&
> +	     clockid != CLOCK_BOOTTIME))
> +		return -EINVAL;
> +	____bpf_spin_lock(&timer->lock);
> +	t = timer->timer;
> +	if (t) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +	/* allocate hrtimer via map_kmalloc to use memcg accounting */
> +	t = bpf_map_kmalloc_node(map, sizeof(*t), GFP_ATOMIC, NUMA_NO_NODE);
> +	if (!t) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	t->value = (void *)timer - map->timer_off;
> +	t->map = map;
> +	t->prog = NULL;
> +	t->callback_fn = NULL;
> +	hrtimer_init(&t->timer, clockid, HRTIMER_MODE_REL_SOFT);
> +	t->timer.function = bpf_timer_cb;
> +	timer->timer = t;
> +out:
> +	____bpf_spin_unlock(&timer->lock);
> +	return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_timer_init_proto = {
> +	.func		= bpf_timer_init,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_TIMER,
> +	.arg2_type	= ARG_ANYTHING,
> +};
> +
> +BPF_CALL_4(bpf_timer_start, struct bpf_timer_kern *, timer, void *, callback_fn,
> +	   u64, nsecs, struct bpf_prog *, prog)
> +{
> +	struct bpf_hrtimer *t;
> +	struct bpf_prog *prev;
> +	int ret = 0;
> +
> +	____bpf_spin_lock(&timer->lock);
> +	t = timer->timer;
> +	if (!t) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	prev = t->prog;
> +	if (prev != prog) {
> +		if (prev)
> +			/* Drop pref prog refcnt when swapping with new prog */

pref -> prev

> +			bpf_prog_put(prev);

Maybe we want to put the above two lines with {}?

> +		/* Dump prog refcnt once.
> +		 * Every bpf_timer_start() can pick different callback_fn-s
> +		 * within the same prog.
> +		 */
> +		bpf_prog_inc(prog);
> +		t->prog = prog;
> +	}
> +	t->callback_fn = callback_fn;
> +	hrtimer_start(&t->timer, ns_to_ktime(nsecs), HRTIMER_MODE_REL_SOFT);
> +out:
> +	____bpf_spin_unlock(&timer->lock);
> +	return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_timer_start_proto = {
> +	.func		= bpf_timer_start,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_TIMER,
> +	.arg2_type	= ARG_PTR_TO_FUNC,
> +	.arg3_type	= ARG_ANYTHING,
> +};
> +
> +static void drop_prog_refcnt(struct bpf_hrtimer *t)
> +{
> +	struct bpf_prog *prog = t->prog;
> +
> +	if (prog) {
> +		/* If timer was armed with bpf_timer_start()
> +		 * drop prog refcnt.
> +		 */
> +		bpf_prog_put(prog);
> +		t->prog = NULL;
> +		t->callback_fn = NULL;
> +	}
> +}
> +
> +BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
> +{
> +	struct bpf_hrtimer *t;
> +	int ret = 0;
> +
> +	____bpf_spin_lock(&timer->lock);
> +	t = timer->timer;
> +	if (!t) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	if (this_cpu_read(hrtimer_running) == t) {
> +		/* If bpf callback_fn is trying to bpf_timer_cancel()
> +		 * its own timer the hrtimer_cancel() will deadlock
> +		 * since it waits for callback_fn to finish
> +		 */
> +		ret = -EDEADLK;
> +		goto out;
> +	}
> +	/* Cancel the timer and wait for associated callback to finish
> +	 * if it was running.
> +	 */
> +	ret = hrtimer_cancel(&t->timer);
> +	drop_prog_refcnt(t);
> +out:
> +	____bpf_spin_unlock(&timer->lock);
> +	return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_timer_cancel_proto = {
> +	.func		= bpf_timer_cancel,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_TIMER,
> +};
> +
> +/* This function is called by map_delete/update_elem for individual element.
> + * By ops->map_release_uref when the user space reference to a map reaches zero
> + * and by ops->map_free when the kernel reference reaches zero.
> + */
> +void bpf_timer_cancel_and_free(void *val)
> +{
> +	struct bpf_timer_kern *timer = val;
> +	struct bpf_hrtimer *t;
> +
> +	/* Performance optimization: read timer->timer without lock first. */
> +	if (!READ_ONCE(timer->timer))
> +		return;
> +
> +	____bpf_spin_lock(&timer->lock);
> +	/* re-read it under lock */
> +	t = timer->timer;
> +	if (!t)
> +		goto out;
> +	/* Cancel the timer and wait for callback to complete if it was running.
> +	 * Check that bpf_map_delete/update_elem() wasn't called from timer callback_fn.
> +	 * In such case don't call hrtimer_cancel() (since it will deadlock)
> +	 * and don't call hrtimer_try_to_cancel() (since it will just return -1).
> +	 * Instead free the timer and set timer->timer = NULL.
> +	 * The subsequent bpf_timer_start/cancel() helpers won't be able to use it,
> +	 * since it won't be initialized.
> +	 * In preallocated maps it's safe to do timer->timer = NULL.
> +	 * The memory could be reused for another map element while current
> +	 * callback_fn can do bpf_timer_init() on it.
> +	 * In non-preallocated maps bpf_timer_cancel_and_free and
> +	 * timer->timer = NULL will happen after callback_fn completes, since
> +	 * program execution is an RCU critical section.
> +	 */
> +	if (this_cpu_read(hrtimer_running) != t)
> +		hrtimer_cancel(&t->timer);

We could still have race conditions here when 
bpf_timer_cancel_and_free() runs in process context and callback in
softirq context. I guess we might be okay.

But if bpf_timer_cancel_and_free() in nmi context, not 100% sure
whether we have issues or not.

> +	drop_prog_refcnt(t);
> +	kfree(t);
> +	timer->timer = NULL;
> +out:
> +	____bpf_spin_unlock(&timer->lock);
> +}
> +
>   const struct bpf_func_proto bpf_get_current_task_proto __weak;
>   const struct bpf_func_proto bpf_probe_read_user_proto __weak;
>   const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
> @@ -1055,6 +1330,12 @@ bpf_base_func_proto(enum bpf_func_id func_id)
[...]
