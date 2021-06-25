Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306B63B495A
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 21:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFYTss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 15:48:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15368 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229712AbhFYTsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 15:48:47 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PJdlxk003652;
        Fri, 25 Jun 2021 12:46:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5jhqFIB1oOFhkLOUxSP3QsfXcOSi21rTMUvY8vVUr1U=;
 b=cwQEeBh+zAcaz1qfA7g/l6o/r/8iS5KRucqo/2I6AQjf9NMUV2vsOJpapE2EYyAiaLv+
 0RQSni6rXpj1ELsxmRKJBwJ4Q7oOWGFlppxPzMwH2ikDy9UIjuU8cAw0ez3d7u77aLXv
 UbIAowAjc8NpEeGDGldpG+zbPche37Mb1uo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39d24nxgk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Jun 2021 12:46:11 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 12:46:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFgetaflC3u8wgV2Cl0DF76Jpb/ZxrfOVH0f2P3RvLqATsB9+f9wcXtq3LlIfYbvmJPWMISL2Z5f4jL/BaSvxn2eY1sbqdBQrCbkkZmSth3kTLQdXDHXS8rK5uk7elnJBY211XaJHzOEvPS13J4tjYtFhvl7MZUZd4C6qy+M2xNklkTxPNlov26tji0S7jPdmScCc8ZKjfwZ9tZF8iBg3s2u0MtUUhQdH26eUI7knxY1J5N1qbPwRiJOVWHKMX0L3Aip9PDG6cxJZ5sB4Mwd9krykvuvIy0PJT/MpltGH3S7vQu8Gaty4UgGYBiFOnWsGEuALnPcDFFuXkKTNHzQgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jhqFIB1oOFhkLOUxSP3QsfXcOSi21rTMUvY8vVUr1U=;
 b=edJFWGMYRQqNmuXGIFWsF4ltc9VkSr6MTqMrI5Jg7ZI3SyZ4GEWzIUR2iY3twyYI2qjFmRHbQnvVf1ECGfFRCjJ6PsM6AAAzXLgflSpZf5DJQT0yYzuxsRpNcl5ShioNIRJ+H5Z7E/EHrnBputyGd+s5gE2kxtoqU/pdtRtJubM39sImAP9ac0asWEBPbLll8bYe2Q7LXLtxpb2yYaqvJ8w6Z8/Pw1NHAaMZHI9Fbd59siwifHV59U1yTIfg/FIUu4fpVapvSSDFTsWRf/3aoBFxzjIFg78hE73n8TbY2kT0GIQgbSfEWOk/AM3Owmb6nkYNyfGNTKe0PcJx9v3NUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2287.namprd15.prod.outlook.com (2603:10b6:805:23::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Fri, 25 Jun
 2021 19:46:07 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 19:46:07 +0000
Subject: Re: [PATCH v3 bpf-next 2/8] bpf: Add map side support for bpf timers.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-3-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2c523078-cb24-e1ca-2439-27be37cfe90b@fb.com>
Date:   Fri, 25 Jun 2021 12:46:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210624022518.57875-3-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4ed3]
X-ClientProxiedBy: MW4PR03CA0242.namprd03.prod.outlook.com
 (2603:10b6:303:b4::7) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1328] (2620:10d:c090:400::5:4ed3) by MW4PR03CA0242.namprd03.prod.outlook.com (2603:10b6:303:b4::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Fri, 25 Jun 2021 19:46:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13343d71-53cb-4b36-e6d2-08d93811dfce
X-MS-TrafficTypeDiagnostic: SN6PR15MB2287:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2287CF79AC9AA8CACFECD766D3069@SN6PR15MB2287.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YH0rPXS5tOzNb6C/84hHY4Lby07dyS2oWt6AKz9WVtfYKv7dlMmqYyjdELmgjpxmITwZs/AiRz21xMCh+SAfVMfEsQvuB9L/0+CwMQu53Zy0loJ5W7TxpDFCbqVNl7aVEQxiXoAsdATRY4rW0hh422AJG8IQOGyJXbGi6T4fxPzWdRVZ8flsEs+ObHFh5UyWY0/PbGkB3McRHtAdNzkGoOocz+2BMACD+HxJWB4ae71JZnyeDg2wn50XpIsNOXGmMLROatp6V1YtZQOAxIIzooLEBBRYU6pQWwMDOwOmldRJ3LSECkYyLJFbVAS7IrbW54RmoqABt0GFJBkddFyw0FNBJtEOSinPfnCYS+3VevLfXzIRJdBTNeHSWa/dF9vF/99Im7RRQXLq0taCxb4HuGhGICdpaUsk9k4o7Ylj9HW88qni3NjX7LeJzXiQsqxYnskW4+1hrUwgsUumkRFhzXB/h+1OXuL0OqZpLLxaUCfZa8mlrNh9B2rZUFJx/IYj1eauODS9BHRNDVWl6yVrpJuMZ255+k4ILHQgAf5INdB5eebvlCremwGbTwS6Bz/Z0SSIXW6jUTDoMdOq+0PkQF4xHn90UoRm57QFCf6eAi5KcHyiz8ubKYna6q2Y2ZwHgxgikUhuUTaq5buiiX/bvyv4Qc3+l7J8WlCbN4igBuNKzDr15mVJmbNTMQY66tKlIj/VI3YYlj3oA4884g87R2otyjWdklvHXGJE2x/PGgckO84kbM/5vZqzw4jkjNdy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(478600001)(6486002)(83380400001)(2616005)(8676002)(86362001)(2906002)(36756003)(66476007)(16526019)(52116002)(5660300002)(53546011)(66556008)(186003)(38100700002)(31696002)(6666004)(66946007)(31686004)(316002)(4326008)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkQ5a2hNQU94SDc2QzVweVVBYTNDWlVuMEhoWWRPdlJ0S0lzTEZzQ1BHdGdz?=
 =?utf-8?B?Ris5cEN0RkxsdjRha0xoQTQ0cXBJSVFpWUhYM3NiZXVkTVZmRUdtcDlSRi9B?=
 =?utf-8?B?dmxVWVJGQTBzMytyL0cxTkVvUTN6MjFGbGJYZjEwMVc2b2s2L2Q5TXVpM3cr?=
 =?utf-8?B?bnB3eks4YjJ5enl4emtSSVBYOUlIMnB6YTczSkhuVEdCRnBRVHdwaytuUEJZ?=
 =?utf-8?B?Y1FoMEVqU3drRWNIWDNaNVhyYVJpZlVDaE9kcHZDTE9JWDRNRE44azd4Qm5l?=
 =?utf-8?B?SW5iSisrbURBTFlLOHc0MFdSbGh5TmhlRmw1YnVGaDdVcE0wTzNOa1FTNkVw?=
 =?utf-8?B?cllaVHVMb0prV0tVcmw4VzBTOUJIdk5mODFZdXk3QkFjWjdmaGRqMWlsRURO?=
 =?utf-8?B?aFVqS014RWlnMUZoNWxwd2FzOTA2VEdpSzlxVVhMeW14YmdzWXR4V1UyMm1R?=
 =?utf-8?B?anVjSnJsMVNsZ0lYSG04a2ZSdUxzcW9rSnhjRHp2YWRKeDRDVXBXZzE2Lzdp?=
 =?utf-8?B?dmxKTUYweDQzdnd6cjRCK3h4WjhIdEFFZGVqMXc0cHF0Z1AreU4xVGhnVW53?=
 =?utf-8?B?dFlxd21MSUo3UThxUGtZa2NEQ3owUVZnU1FKcEFJa2REY0h1Mmh4UFk2cFJo?=
 =?utf-8?B?WUl6ZkJheW14eEE5WWVrZWF5ZmRkQzcwNHF6NTJBdWN6c25QSDNHcmN3UXFq?=
 =?utf-8?B?YUdudTRqaWJDQ0RySlFmS1RqaGlTSXAxTnMwVkxsKzhFY284UmJYVTlFV1BF?=
 =?utf-8?B?bEYvTkhpUlp6UkQ2U2EvcG9MYTA2alJGV3VVYW1TUUFRWW5IazF0NnlhWU5r?=
 =?utf-8?B?bnVVeXJWQWRpSkdZNTJLd3RBNUR0Y2tOK2pVMW53a2hVTTJoZHlUc29VL3hV?=
 =?utf-8?B?djdraWt6L1ltQkZmcjU0S043SktKZVk1cUpvMnNXdnduWmZRdWpUcHJIWTdw?=
 =?utf-8?B?YUd4c25mZCtmWGxKSWUwTGFDQWZMSlF6dnJUdzM1RlkrN1lyR1F5ZUtkTVYw?=
 =?utf-8?B?UjI3OWxTRTg0SXViNnExM3FjTVdkNG9kZVVoMTF4ZmM3UUZWVVpxSmlyK01Z?=
 =?utf-8?B?ZFozRmt2WHNVQUFkdEQ4RWlxQytab1FIdllicHdyeGpPbXVvSENpMm5lSTRO?=
 =?utf-8?B?VzNuK0N3ZGplY2h3c2pkUVo4UHFncVFxbGhTVFBTbU8zYlN1SnlTSWl5SXo2?=
 =?utf-8?B?Z0ZyNzJXQlZOaERJdmcwSjRaTTAvTkNLSzNjZVhVNCtuMEJHWGRlNFhLbFhB?=
 =?utf-8?B?RmtKU1RmQmd6aElwOG9GRVgrNUk4Q1Rkclk4Z0VFZE5SUlNaY0NpaDlzcVFB?=
 =?utf-8?B?TTlBVjg0NVViMi9ueGVnb0c0bHY4SkJKcnJ5T1A5bTRoSzZNalFlT1Vwd2FO?=
 =?utf-8?B?Ulc5R01TeWtrKzM0N2JTK2xEZ0M3YzdXaWM0SVJIalBEVnpFa0x1djllR2lQ?=
 =?utf-8?B?ekJiVVVKUXlFSjZyTS9US00xT1RQWGxuR1EzeFo4SStqVC9yL25JUTZOYXdi?=
 =?utf-8?B?bHZSN00xOVFKTExiaGlmcyt1dXRJdERQWDhzWml4UmZiS3ZjSk1SelNpQ3lH?=
 =?utf-8?B?bnhSTjhyYWxuejk2WVBxVDNSNldNMkZtZFd5VkxXSVpudWQrNzJNVm4rNjBP?=
 =?utf-8?B?b29xZ0k5V1M0YlE5aDdaemlOK09YdXM4d1R6Yi9HSHV4d1dqU2ptdTJBTkFQ?=
 =?utf-8?B?dnd0ZjBnNXpmd2NYTjh0ZjNsSTY1LzBuUnVYcWYvb3dhOWx4UEc4VGc4ZzdI?=
 =?utf-8?B?VUkrd2pOQWhjRmVwR2JtZXZQUitKeWZlcFJIcG1iaitpY3pFQ2NwWmQ0LzFS?=
 =?utf-8?Q?1mHs5pGz0Hf9GiHLLKOBkS+Z0imnXAcSS60xE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13343d71-53cb-4b36-e6d2-08d93811dfce
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 19:46:07.1413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13ubNK1JeDHAw4R7O1Y7TbjjYbChnn9DZvs2u6icCrt941oGFkoGADkaYLQAudND
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2287
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: VeY4mZIumKPyUsVQrVly2fkCYzHzIjc-
X-Proofpoint-ORIG-GUID: VeY4mZIumKPyUsVQrVly2fkCYzHzIjc-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_07:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 adultscore=0 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/21 7:25 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Restrict bpf timers to array, hash (both preallocated and kmalloced), and
> lru map types. The per-cpu maps with timers don't make sense, since 'struct
> bpf_timer' is a part of map value. bpf timers in per-cpu maps would mean that
> the number of timers depends on number of possible cpus and timers would not be
> accessible from all cpus. lpm map support can be added in the future.
> The timers in inner maps are supported.
> 
> The bpf_map_update/delete_elem() helpers and sys_bpf commands cancel and free
> bpf_timer in a given map element.
> 
> Similar to 'struct bpf_spin_lock' BTF is required and it is used to validate
> that map element indeed contains 'struct bpf_timer'.
> 
> Make check_and_init_map_value() init both bpf_spin_lock and bpf_timer when
> map element data is reused in preallocated htab and lru maps.
> 
> Teach copy_map_value() to support both bpf_spin_lock and bpf_timer in a single
> map element. There could be one of each, but not more than one. Due to 'one
> bpf_timer in one element' restriction do not support timers in global data,
> since global data is a map of single element, but from bpf program side it's
> seen as many global variables and restriction of single global timer would be
> odd. The sys_bpf map_freeze and sys_mmap syscalls are not allowed on maps with
> timers, since user space could have corrupted mmap element and crashed the
> kernel. The maps with timers cannot be readonly. Due to these restrictions
> search for bpf_timer in datasec BTF in case it was placed in the global data to
> report clear error.
> 
> The previous patch allowed 'struct bpf_timer' as a first field in a map
> element only. Relax this restriction.
> 
> Refactor lru map to s/bpf_lru_push_free/htab_lru_push_free/ to cancel and free
> the timer when lru map deletes an element as a part of it eviction algorithm.
> 
> Make sure that bpf program cannot access 'struct bpf_timer' via direct load/store.
> The timer operation are done through helpers only.
> This is similar to 'struct bpf_spin_lock'.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

I didn't find major issues. Only one minor comment below. I do a race
during map_update where updated map elements will have timer removed
but at the same time the timer might still be used after update. But
irq spinlock should handle this properly.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   include/linux/bpf.h        | 44 ++++++++++++-----
>   include/linux/btf.h        |  1 +
>   kernel/bpf/arraymap.c      | 22 +++++++++
>   kernel/bpf/btf.c           | 77 ++++++++++++++++++++++++------
>   kernel/bpf/hashtab.c       | 96 +++++++++++++++++++++++++++++++++-----
>   kernel/bpf/local_storage.c |  4 +-
>   kernel/bpf/map_in_map.c    |  1 +
>   kernel/bpf/syscall.c       | 21 +++++++--
>   kernel/bpf/verifier.c      | 30 ++++++++++--
>   9 files changed, 251 insertions(+), 45 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 72da9d4d070c..90e6c6d1404c 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -198,24 +198,46 @@ static inline bool map_value_has_spin_lock(const struct bpf_map *map)
>   	return map->spin_lock_off >= 0;
>   }
>   
> -static inline void check_and_init_map_lock(struct bpf_map *map, void *dst)
> +static inline bool map_value_has_timer(const struct bpf_map *map)
>   {
> -	if (likely(!map_value_has_spin_lock(map)))
> -		return;
> -	*(struct bpf_spin_lock *)(dst + map->spin_lock_off) =
> -		(struct bpf_spin_lock){};
> +	return map->timer_off >= 0;
>   }
>   
> -/* copy everything but bpf_spin_lock */
> +static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
> +{
> +	if (unlikely(map_value_has_spin_lock(map)))
> +		*(struct bpf_spin_lock *)(dst + map->spin_lock_off) =
> +			(struct bpf_spin_lock){};
> +	if (unlikely(map_value_has_timer(map)))
> +		*(struct bpf_timer *)(dst + map->timer_off) =
> +			(struct bpf_timer){};
> +}
> +
[...]
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 6f6681b07364..e85a5839ffe8 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -228,6 +228,28 @@ static struct htab_elem *get_htab_elem(struct bpf_htab *htab, int i)
>   	return (struct htab_elem *) (htab->elems + i * (u64)htab->elem_size);
>   }
>   
> +static void htab_free_prealloced_timers(struct bpf_htab *htab)
> +{
> +	u32 num_entries = htab->map.max_entries;
> +	int i;
> +
> +	if (likely(!map_value_has_timer(&htab->map)))
> +		return;
> +	if (!htab_is_percpu(htab) && !htab_is_lru(htab))

Is !htab_is_percpu(htab) needed? I think we already checked
if map_value has timer it can only be hash/lruhash/array?

> +		/* htab has extra_elems */
> +		num_entries += num_possible_cpus();
> +
> +	for (i = 0; i < num_entries; i++) {
> +		struct htab_elem *elem;
> +
> +		elem = get_htab_elem(htab, i);
> +		bpf_timer_cancel_and_free(elem->key +
> +					  round_up(htab->map.key_size, 8) +
> +					  htab->map.timer_off);
> +		cond_resched();
> +	}
> +}
> +
[...]
