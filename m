Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88237368537
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238183AbhDVQvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:51:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20878 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhDVQvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 12:51:18 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MGnqxH014269;
        Thu, 22 Apr 2021 09:50:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=iFr04GAN4D5agnqqXnFWCQhau40v+cw8X7wDcjqlCi8=;
 b=rF50CATTDLAT5xg1zSj33zpt+bQqn/XbUGMQZOEzFtvF6dLolXYypncnxXiIAdRybHrl
 6krs9lxf7b9RuwfWNvFqEzLKkY5zOX9/t1eN3lD4oxKbIKZfS96Au66ECGLd9ipah3Iv
 DvZdPF4C9Zyx9SA+OCl7ckdjn2zWk3gma3s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3831khunc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 09:50:30 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 09:50:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vt9G2cApOW8q1h/n5sZMBx5F0Oq6Jn/tlP2NUrrPY7P1TxuVDIb+gD8P/9G1qKlyb0MG2MjfT0PgbhQlWJnFuN1fgcyLcMRmHRHuuSARgzOsfXH5BviVjau7pg8TV1k58ToPTbf3wA/6gStTA2/Oo+B6FtUEtEMTrMh8USqlJgqoveZ5KX6rM+wKpIvbuss3Uj+OIewAkvQ+zP20DCMF5n15SOjvNdpmaXQ+7PfCAvYblkkaQDcF2N5Qp25GBLjZxRDMLd+HjG+UAiq3SjKagdopM+RZM0c2TQa0i4hlqc6RqYBSNWaMUM9maB8wIsR5UDTFEpY32hwUkDNemmvxOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFr04GAN4D5agnqqXnFWCQhau40v+cw8X7wDcjqlCi8=;
 b=Ydwqm0SPZ6rg3TvGerdVK1HyLVR/7FxlUNv5mIJEJCQY9M7dUDQ+mdmke6FeqGkfhAUEObPpS6ILHiK1SrTp27Yxi3l1RlSRKVCTAMT/spiKBkRmqGVLnbbUGwQGnoIdkjUmWh9s/j8lD5/idR1FNkjRXUR5XLiTMexjnsvfRUVWsOBo/1m8Wkd2PzxHFKkr30rd3MWMrbBQ4rF48GDmqa6Gj+CMwGKo2G89MyajECQzNCZ1NtCHjowzzc8i1CBuW3b7Ue4Zu2BKAxILrxyTEPgvKp1UxtJ9EkvFldSC8KlAX9KOnJNuMtXdQ6n8HJWBjb5ByqObJ9sVP5O0qCGUlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4418.namprd15.prod.outlook.com (2603:10b6:806:195::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 22 Apr
 2021 16:50:28 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 16:50:28 +0000
Subject: Re: [PATCH v2 bpf-next 10/17] libbpf: tighten BTF type ID rewriting
 with error checking
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-11-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c9f1cab3-2aba-bbfb-25bd-6d23f7191a5d@fb.com>
Date:   Thu, 22 Apr 2021 09:50:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-11-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:427c]
X-ClientProxiedBy: CO2PR05CA0108.namprd05.prod.outlook.com
 (2603:10b6:104:1::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::16ea] (2620:10d:c090:400::5:427c) by CO2PR05CA0108.namprd05.prod.outlook.com (2603:10b6:104:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Thu, 22 Apr 2021 16:50:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e158c4b8-0884-440d-0bf5-08d905aebbc9
X-MS-TrafficTypeDiagnostic: SA1PR15MB4418:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4418ADD9C7FE8A36C37D159DD3469@SA1PR15MB4418.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r3M2cD0Dkk2sGj9oU4I++QeZwQ2MtMNHlYVshUVQFwjSo5v9EqvSB4CPmpDpDizhUNVZPE4UgUW+1q0qCHNbmMi6w5MPaSA5U9VQCekWSNBTLEC1NrSUh1jkUHeAH6kjyItoBv9dU5FyRQDDPIkzQBnK0pQx3Uxk/HfK7MkxSb791Lh9+tFrvImdmu2JsMdcUfhqToQ8lgs/fasM7p+e7Qx+tFvk4IW2A0VvuB+mrAWaWQpTzD1K2jAUAf/fjIOAPvR1rkSlL/cIAWl0KRLzZ2MUDJ23hFna/tmdRp3G+aazIIClTaoaA5Nd4rbDbHZ2a5lilNVQbCs1QgyZJ1gBFAdhJF0N7I5zAvZTOxylqyY0LiDoGtg2VYEqLr6889u44YIlJMCZ8l00m0hJgK8xgKD+W0kX0+8DmkAYr94OeblaJpyeeMLemPwosq6kZjEUNpteLFLZGfbRGeE0JP+eEZLRrK40FzzJyFGk64kBISHmqkCK18tghp6SGuOU4t4jnTTzMSYa536ODKYxIzeA/46BOkBktxoGuApi0G+lUoFcW/OQRaDm2SqgOdQl2g3g9O+U54ZCFxN0piHzFIA9DU4UH3NsPfuVzamQmMEvGFv3P7Q9XnKqDMR4ByiNXkNmT6P6ZVslAzycDYBGJax0va84s+SsMxA9rZgLJH7ItvwjW8jUwCiZjiAagtHQHBFu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(346002)(39860400002)(366004)(2906002)(478600001)(5660300002)(52116002)(53546011)(36756003)(38100700002)(4326008)(316002)(8936002)(16526019)(66946007)(66556008)(66476007)(8676002)(31696002)(6486002)(86362001)(186003)(31686004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OXBLeGl5eURpQTNKMjdHeE1USlF3ZDh5NTFxUkF4RUtPQ0FBWkcwOUhOVW1n?=
 =?utf-8?B?SUxwZzZEM1NRSWR5YTVha2RLd3RlS2R4ZVNzRDZOYmE5dThBZnYwVXR4WUIx?=
 =?utf-8?B?RWZHTktBOUVrOWw3WkYyd3ZKbnMrVEZETjdxODgzcEdrWWxwK24vRldHVDlq?=
 =?utf-8?B?SGJjYlNPV3NqUWVWenppdkpiZmw2M1ZpNlFJSm9scC9iOGtRQnQrNFpLYjJY?=
 =?utf-8?B?NjhZTGhsMFZBZjNsYW1RaTA2U1FaZ0tXbUQ2REh3VmNNTVNtclZIMFlKVnA0?=
 =?utf-8?B?ZnB2cE9DL0p6N0Rsd0FRTStnVm5SbE4rSmpzQTdGelhYWEk4Nk1pWGRyMm12?=
 =?utf-8?B?WjhnWEZacnVwWFJSK0JFTWFGVzhnTUhDTGJCU0hTOURmZXIyZ01MRWxNa0or?=
 =?utf-8?B?V0NmQkFGQkpXbkltamJ4WHZpcXp0SU8wL0xTOS9CYWd1eHFyR0dhTE4zblZi?=
 =?utf-8?B?YktZQitzSFE3bi8xSHlaOXVYaElZR215VVlGY29HVTl3enF2VGhYZGN1aEZz?=
 =?utf-8?B?NmxOOU4yNW4xYWVsZjIrVjhvRGpxRzArTGJUSkl4aWYzZEFEeUZjR2RHOVlB?=
 =?utf-8?B?M0VBa3Q3M0N0alBVcUp4MElrZ2hxZklJMjVtNjNTNm93K0Y0K3dBd3F5aXF4?=
 =?utf-8?B?ZHBWdWtKSmZobFhqYzJVbHRORXNIMHJFNGZIYzlQb2hCVGprYi9ranZlSXZt?=
 =?utf-8?B?R0VJRWxJQlppT2lGWk8wMlBOVkRsWGtQTkFRSTVYbVRSR2dxeHZlN2JBand4?=
 =?utf-8?B?blJBVmZvcHJXbi9mM1laWXA2b2tZS0ExN3ZKYzFmbytmM2pSc2pxdUI0MHRm?=
 =?utf-8?B?QVdkYmd4b01Zbm9zRU5jRm5UZ2R5d0loS1I3WjJTK09pQ0NHTDZEK2g3NmZL?=
 =?utf-8?B?VkJvbHRKUk85d20yc3YvdFhQSXI2QU1xdkRGRHdnNTh1VEtDWjlCQ09NQVZw?=
 =?utf-8?B?OXhadGg4NnlXWXZ2SEE5emFyaWJoTnNKQnJTNlEwQjk3QlRIZnRZNDR3ZnY1?=
 =?utf-8?B?aEY2b3lzdFFHb25sM3pFZG1JYWZKYUdNZUdObFRMYkd3MFV4SHNGcmE4R0VS?=
 =?utf-8?B?L1MxWUNmQ3Q5cEh4UVdIU2lKZ3oydXUrWFdTZ0oxcjVHUm4vZ0hGemhvV2Fp?=
 =?utf-8?B?dFgrM2E3YmdGblpTWTNJYWJNeG5RSllxUmtyM0t5ZjJ5eVI0ZVR0SGVmVi9p?=
 =?utf-8?B?SHdJTnBVb2tPdU9RaklBSmtONU9mQytSNWEwVHM2dFg4aFAvMFZWcjlnRTBq?=
 =?utf-8?B?bXhER3QvYzJmTTQ1ZU9WYUplMFU4M0pJMm5waXJ5T2tWM004QldjRmRqQUFZ?=
 =?utf-8?B?RjduQTlSTWRJQkJTUE9odm1XQVczOUUycjRqOUdBMHFNam9XbC9CN1h2dWJr?=
 =?utf-8?B?ZUFGQXdUazIvbnlaUDdOYmtBUVM4VFliYWthMnFRZ3d3RGFqc29FamdKamVU?=
 =?utf-8?B?aEx1UW9oY3dYWjhUOUU0UThaTXE2elRSUHFJN2t4RnloVzE4aEQzNFE3VEgy?=
 =?utf-8?B?NHNQTDIzR1lwQ0g2RDdjUUo1TDdWMVkzR1EzaEJhT1ovKzdQWU1zdEg5WHVy?=
 =?utf-8?B?UldsZjFXRzJGcGFZcXd6VjlXZS9GeVAvOXBSRk9TTVE5cklJeVNIYnl6OVow?=
 =?utf-8?B?eTc1Z1JycGJ3T1MvRUhWYmJsOEo1bU8zOWhaNTl0SXNuWmo4M2hobCtaR0Va?=
 =?utf-8?B?NjM3U2lMallYWUpZM3ZqN0FBcWEvcnh6T3pzaUNNRTZzOVByMHJnUE5kSTVZ?=
 =?utf-8?B?T01ZTmZ2dkl0TmpkY1RIS0VBUmhzOWVtYjcrZmZjdUttVVdiU2xXcUtSem9k?=
 =?utf-8?Q?HbEVvKDYUgoIi6sUZ8L2PDy+XiM7DBJQpXJBQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e158c4b8-0884-440d-0bf5-08d905aebbc9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 16:50:28.3338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6f0QjB8YF40TLghCWo5QySYh+v3td0HpnLkOKg2mT7X3aB+AhlrFY2l/bGMModWq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4418
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: z0NIAzd-4tvOM02EU_SKWqRpAKG7cl69
X-Proofpoint-GUID: z0NIAzd-4tvOM02EU_SKWqRpAKG7cl69
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_11:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104220126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> It should never fail, but if it does, it's better to know about this rather
> than end up with nonsensical type IDs.

So this is defensive programming. Maybe do another round of
audit of the callers and if you didn't find any issue, you
do not need to check not-happening condition here?

> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>   tools/lib/bpf/linker.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> index 283249df9831..d5dc1d401f57 100644
> --- a/tools/lib/bpf/linker.c
> +++ b/tools/lib/bpf/linker.c
> @@ -1423,6 +1423,15 @@ static int linker_fixup_btf(struct src_obj *obj)
>   static int remap_type_id(__u32 *type_id, void *ctx)
>   {
>   	int *id_map = ctx;
> +	int new_id = id_map[*type_id];
> +
> +	if (*type_id == 0)
> +		return 0;
> +
> +	if (new_id == 0) {
> +		pr_warn("failed to find new ID mapping for original BTF type ID %u\n", *type_id);
> +		return -EINVAL;
> +	}
>   
>   	*type_id = id_map[*type_id];
>   
> 
