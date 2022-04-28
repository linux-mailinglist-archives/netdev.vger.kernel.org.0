Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B94513C97
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 22:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351728AbiD1UYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 16:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbiD1UYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 16:24:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EF092D08;
        Thu, 28 Apr 2022 13:21:29 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJfhRx027236;
        Thu, 28 Apr 2022 13:21:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=E8EaDl4g6S/hoLnaSE8lZW/uC0jcOheyW5mUpW4HA/Q=;
 b=eNO/U8NebNzoH6mqmaME75d+UpfY+cwWJfgDIc6Zcph7CWtOLMUakjOlfyyu18mZuiAP
 +M3F9Lgl0It2Oj46lapRwf5uUSVvTEfQJmap+3c9aZQCnnA1JG0Yr2jwoKL58rhxM2Na
 jLsR8V0SUuMDL1TlcaUXHShQGyeZgJa1BaY= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fqghnpm7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:21:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=By+nCFacXUS0LWUWelBU9dV85LP1zE4MlY9lbS/i4gdMADoJHJZIlogk0p2RzTbLkYfy8+sZzBtIQsLjP49rxM70qbBQHPk0SzhvDiJN+Z7/LQm7ragwymIesW1HUQMdVE094fFgqJ+2NdlqAoHOAWiac3CUTj2SGySe7NaMgLrenJY3RLZ54S9ZiMumEn6H4TMEPTfh6dGDAH9LFmM2204nFmLIWvsVtCzET0e19LOE9/Rpve9i32xumwRA5qBHm+aYlLCmkE9nWoqdMli9AaNHY1pgMZ470anMufcoz1oye9ejdLAuMYAIbteRMdaPPI1AsgwjnGHIAK4gTqRf5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E8EaDl4g6S/hoLnaSE8lZW/uC0jcOheyW5mUpW4HA/Q=;
 b=iBfIRBBAsZA8fpHP9in1RzBTYXwIaODe38M3Gbqr50E1PAk6/DAAuDJ66hV2Qupk/so1B6oAdsHDntTQEQdBCRD7lsdZNze3qgr/rvxJRklGSpdu34kJzrB3SNyfDcN06/XeQGCNzw29+nt8V388ahSlc0KCniHPxvXp+jT6tN2wllvs9b0H8ZcZR/nGbh9e5xkdXWwqNtiVH5GGirhw7LooduBBGoyomjOiq63bgwRVuzTJ2E7VgsFm8Iomi0aNOfXP2JXmW/8MpOSqvHfxUdZze9tds+ICwxX12wold/L/UAHtU69RroCknb6M5V+TFWJQ8UE1ftrU3PCoK1k2Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH0PR15MB4926.namprd15.prod.outlook.com (2603:10b6:510:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 28 Apr
 2022 20:21:09 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 20:21:09 +0000
Message-ID: <93d0646e-eee7-fb55-ac1c-c1d6282af652@fb.com>
Date:   Thu, 28 Apr 2022 13:21:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: Extend batch operations for
 map-in-map bpf-maps
Content-Language: en-US
To:     Takshak Chahande <ctakshak@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     andrii@kernel.org, ast@kernel.org, ndixit@fb.com, kafai@fb.com,
        andriin@fb.com, daniel@iogearbox.net
References: <20220425184149.1173545-1-ctakshak@fb.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220425184149.1173545-1-ctakshak@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:a03:331::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d89f845-0003-4049-2ad4-08da2954a155
X-MS-TrafficTypeDiagnostic: PH0PR15MB4926:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB49266EC98FBFF407EDB21D69D3FD9@PH0PR15MB4926.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MDnja2ERjTY9VWCtUkdqFdbLRvvGENH9U48c14Iebn71VwobwQY5a9Fm0U6IXHd6tRGENlKHGPnUYSrtaypgx8EcTN59HmvKuvTOsKiInwnWsmDvajcgvQqfdfUktM1tj+FDd0/Rhp7pcnuPFGVxI6u81eLhy/Bag+VQv+U8LaeuuLBH4nVDKTrUmmlVVbqPSOMGCOwrMdnWhqXzMjvh/OsC5rJjGqhomDOVQMtNlZ5G2KvVpOfMO5ucgLWADmKO4yqZAiAGR9xElb/M0Hah/N4SWc4BhSZCaeCIYgoOG33IaRshuF157Ecf755vhCT1hZ1w3bXmwekJ6ScqYAVaz6PWnsrkrQIlHIKus4ZD6uKhe5rWvNvB2WqgusZWV3WjiWnS36QKk49cGf4g/Tw++zTTNqqT5dNjZyj2dIMSf1Wdmk5R8LFVyZ4YQvipHkWFTbiL9LhOdJoQvB716AGonfe++pGtyZAbni3DFnwotuDZqG25IYddpqa8zDZnJo/wdAkXj0ywH5BFqmN87FaFzfvFb2hCyqqHeU1VZraalwdeww3pT7jhws9BDtaVXpXrlOe3L1oncVHdmsfLfj0h6E1C589CkL/PgnrnvX0aMfnWjN8o6mRdaOVKJ3zOBB5MhpWa8++VtAcdHWVKq6dZv3qCi2puMvO1aUuQWpO/BugveQdfnOyDy38D3LkNACDk/IlDhHBYJmZ1qm1RW3fzOHgTn4VyPA1YnQ6X6/r6IzA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(38100700002)(186003)(8936002)(8676002)(4326008)(5660300002)(36756003)(2906002)(31686004)(6506007)(6666004)(6512007)(52116002)(66476007)(2616005)(6486002)(66946007)(53546011)(66556008)(86362001)(508600001)(316002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YW9nd0M2R2E5MUVrVC9OekM3MmgwRXlQVm9JYkNVci9Ib1hyK2hlc2ZQQVc3?=
 =?utf-8?B?elRqUVpkdFp4Z09GRkp4ZEtRRGNpNmFRc1dVNG5temZsamozRUhkcmdKK3FQ?=
 =?utf-8?B?aURyam5yYnV1NExnTytLZnRTdlJ3Mjc3OG5IZGRaYnVMR2xmTlp2ZlMwaW9h?=
 =?utf-8?B?czdvaHdIN1pIU2syRjhFYlJ0TlFsUEk0bDNIN1h1TjFIOFdBeCtVNFdhNkFM?=
 =?utf-8?B?Q3RJOUt1SlJWVmxRajJVdVpvNE5TVHo3czNndEJ1ZTlqNE1jTGtlNVpUSG14?=
 =?utf-8?B?c0hLS1hOd2Nzb0pmQTZ2Zzd5K2FHcGNxNk5XNTEvTFNxRlZ5VHFJWWlqZ3Jk?=
 =?utf-8?B?MEZUMUJISmhpZ3ova1FiOEQvRUxCRks1cWhjL1BTVnVsSitUZUgrMWpZeEM5?=
 =?utf-8?B?QXl5U2tyU205SmxlK2k3VHdibTJPK3VaWFRIdzFtK3dWM2pLSHZyZWFMTTV2?=
 =?utf-8?B?TDJLU1MvWkROTGxpTUlJSERpMEtxOVRvZ1dWY2FIUnhxTWlrQWNjcmk1Q21u?=
 =?utf-8?B?Q3AyOGsxMWtXdTA4U0p6ckJIWGlCZjJ1R1NnOW1LY1UzcmhtdC9GdlUwNkdz?=
 =?utf-8?B?bGp6ZUU0eEFYUDdBeEdIUjhvaDMyY1hZNndBVldpRzVhLytFSUpXVThUcW40?=
 =?utf-8?B?VWszdDZOUCttQ01BeDR2VTJXbXB2YVcyb3hBMmc1cnk1TndRMmdXWDd2eU5O?=
 =?utf-8?B?NHFxQTZoSlkvZHo2Uk5xMUNjMjBuWVh3dFlkYXFiWHJ1ODdWQ2RKVkxiM2lO?=
 =?utf-8?B?ZzRvenRVRWJneEljeUpkYkFMNXVOTXU3U2VxOUlvQWsvRkFTYllGZjF1OTlu?=
 =?utf-8?B?NEYzOHhYd0Z0Q0sxUEZ4c3lzVll0RS9EOWk4NmFUc1NyNUZWWDdDdFNsRUNz?=
 =?utf-8?B?TnpXK3VHWSt6cjVtQ2RjVGlQM1QvcnljZk5CcGpYdEI0enBUa3dHamxJaUFC?=
 =?utf-8?B?MXVyS0JudUNrbndMNks1bEsrZ0Vpc2w3cWxUenN0ay91TEhFdHlYeHEvcExT?=
 =?utf-8?B?bWVtZnJ0bkJYQUUzejRhVVNNS1Z0K2V5bGc3MzBYV1NyRGl1UXlXc2V6ckxE?=
 =?utf-8?B?NDh0RVhxSEJ4bGdiMDczM29DU0h3YXdMeHBLZnRDa3E3cW5OU2krR2M2TlNF?=
 =?utf-8?B?bFRXT01ydVNqTk5UNFRSbzJlU21pNldlOFRqYytuUlRoMDdlZGhjUGpBUVh0?=
 =?utf-8?B?UHFudUh0NVZobU9QVTZ2NDdrMVdnQkVjSzZWTUdzUXR3TlFYdkpUQ3AzSmNU?=
 =?utf-8?B?dWZpSUNBbDdGQ0k5b1NBQlpKQkVYMmFNZTlJS0QzSlRrUzIrTFc1WFNlN3ly?=
 =?utf-8?B?cC95bVQwTC9FNXhzeGVzYitVM1ZEWExoQTliVW5RRS9WN3hFT1BIelZLbDVH?=
 =?utf-8?B?SUlneTVhaGtVV1J2cHN6bk9uclBIN1NSeDZHck1iek9PbUNYMmNrTnlpQkt2?=
 =?utf-8?B?aU9KWjVTWjNBZ214WmlPR2tGZ2wzRE8rTDJNdCtDUnZLWTREOS9WNWZ4bTJ1?=
 =?utf-8?B?YXNYSmc5K2I4VWJmWlVmaDh6R1hxNHJUZ3VnQmtObmJHckxyUDJZTjdSQ083?=
 =?utf-8?B?TE41VW5LVEFzckkyTGxob3c4WFZFQ000TlMxVCtIU1Rqa0VRdHBBd2dGSUpp?=
 =?utf-8?B?TVM2aWpPQXU5M1RvQVl3VEFFNGNjdHMvQ1JZSmFQYkVJY21ZTjEvV3BZUmdS?=
 =?utf-8?B?TWJ1UTkrcm9hSXBKUVB0dnpPcDIrOGhCVVREaGUzRHZ5S0hTb0FzcVNPcVlj?=
 =?utf-8?B?b3k3OU1peGt5bFMycjJ2VTdYekQ5Zm4rZmdha0gvSS81VzZtQWNmeHcyOXZS?=
 =?utf-8?B?RnFwMDhSZ0oxQnB1WkFwbmdiUXJkcVZhQnErN2pWT3VCRHFaV1hzS251NDJQ?=
 =?utf-8?B?eHNmZ3MwZ25mMi9TL3VPQ0h4TDduTUhPdEpLWmJ4WFUyb2NRM2ozcm9vMzZN?=
 =?utf-8?B?UnVGaVU1U2g2VWw1YzlUWDBWV21HRW5OZGlvSjg2V2RJc1U5dDM5TTV5bDVP?=
 =?utf-8?B?WFM1aGcydWxyeUJvbEpwVFNJNzFuZUpsc3NZOStkSHVFNWFRNG9abzQ2VU1S?=
 =?utf-8?B?NjNUWjQ3Z2F0V2FoYkVWb3dSdU03N2l2bE1rQUhMSTNxU1pEbCswUGRTTTBB?=
 =?utf-8?B?UFJtRTdpc0R2YU5tVkEzMGlrMGpuc2xqeE5nKzBGT0xnc1NER1hOVHlCaEpU?=
 =?utf-8?B?MlZxeEh2eXFEVmdFeitpUEYwenpBMjhWOE9kckovQ3hEa05LL01kQ2I0blNa?=
 =?utf-8?B?T2Q5K3IvbWpxZ1lzeWJla0RJdXgwT1dpZURxbXFOUWU4WEd2Mmc0TGpGeDRa?=
 =?utf-8?B?U1h5Q0tZeHByOHVnQldDNkVSbDhJTlp0WW9zdWpXWStaQ25IVUxnOXNBS0k5?=
 =?utf-8?Q?4IsdLjS7/EMXdT4Q=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d89f845-0003-4049-2ad4-08da2954a155
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 20:21:09.3613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQnvMLgm/dVAxya3C1A8hSCniaYLkJ6k4HaixRfi+cJ2d213/M0gPdiuvYoQtg3P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4926
X-Proofpoint-GUID: 2Vt3TkwqYFpPZqth_tZh0soBmuEU0z_p
X-Proofpoint-ORIG-GUID: 2Vt3TkwqYFpPZqth_tZh0soBmuEU0z_p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_04,2022-04-28_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/25/22 11:41 AM, Takshak Chahande wrote:
> This patch extends batch operations support for map-in-map map-types:
> BPF_MAP_TYPE_HASH_OF_MAPS and BPF_MAP_TYPE_ARRAY_OF_MAPS
> 
> A usecase where outer HASH map holds hundred of VIP entries and its
> associated reuse-ports per VIP stored in REUSEPORT_SOCKARRAY type
> inner map, needs to do batch operation for performance gain.
> 
> This patch leverages the exiting generic functions for most of the batch
> operations. As map-in-map's value contains the actual reference of the inner map,
> for BPF_MAP_TYPE_HASH_OF_MAPS type, it needed an extra step to fetch the
> map_id from the reference value.
> 
> selftests are added in next patch that has v1->v3 changes
> 
> Signed-off-by: Takshak Chahande <ctakshak@fb.com>

Ack with a minor issue below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   kernel/bpf/arraymap.c |  2 ++
>   kernel/bpf/hashtab.c  | 12 ++++++++++--
>   2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 7f145aefbff8..f0852b6617cc 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -1344,6 +1344,8 @@ const struct bpf_map_ops array_of_maps_map_ops = {
>   	.map_fd_put_ptr = bpf_map_fd_put_ptr,
>   	.map_fd_sys_lookup_elem = bpf_map_fd_sys_lookup_elem,
>   	.map_gen_lookup = array_of_map_gen_lookup,
> +	.map_lookup_batch = generic_map_lookup_batch,
> +	.map_update_batch = generic_map_update_batch,
>   	.map_check_btf = map_check_no_btf,
>   	.map_btf_name = "bpf_array",
>   	.map_btf_id = &array_of_maps_map_btf_id,
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index c68fbebc8c00..fd537bfba84c 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -139,7 +139,7 @@ static inline bool htab_use_raw_lock(const struct bpf_htab *htab)
>   
>   static void htab_init_buckets(struct bpf_htab *htab)
>   {
> -	unsigned i;
> +	unsigned int i;
>   
>   	for (i = 0; i < htab->n_buckets; i++) {
>   		INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
> @@ -1594,7 +1594,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>   	void __user *uvalues = u64_to_user_ptr(attr->batch.values);
>   	void __user *ukeys = u64_to_user_ptr(attr->batch.keys);
>   	void __user *ubatch = u64_to_user_ptr(attr->batch.in_batch);
> -	u32 batch, max_count, size, bucket_size;
> +	u32 batch, max_count, size, bucket_size, map_id;
>   	struct htab_elem *node_to_free = NULL;
>   	u64 elem_map_flags, map_flags;
>   	struct hlist_nulls_head *head;
> @@ -1719,6 +1719,13 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>   			}
>   		} else {
>   			value = l->key + roundup_key_size;
> +			if (map->map_type == BPF_MAP_TYPE_HASH_OF_MAPS) {
> +				struct bpf_map **inner_map = value;

Please leave a blank line here between var declaration and actual codes.

> +				 /* Actual value is the id of the inner map */
> +				map_id = map->ops->map_fd_sys_lookup_elem(*inner_map);
> +				value = &map_id;
> +			}
> +
>   			if (elem_map_flags & BPF_F_LOCK)
>   				copy_map_value_locked(map, dst_val, value,
>   						      true);
> @@ -2425,6 +2432,7 @@ const struct bpf_map_ops htab_of_maps_map_ops = {
>   	.map_fd_sys_lookup_elem = bpf_map_fd_sys_lookup_elem,
>   	.map_gen_lookup = htab_of_map_gen_lookup,
>   	.map_check_btf = map_check_no_btf,
> +	BATCH_OPS(htab),
>   	.map_btf_name = "bpf_htab",
>   	.map_btf_id = &htab_of_maps_map_btf_id,
>   };
