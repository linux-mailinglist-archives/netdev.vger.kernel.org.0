Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C93367818
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 05:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhDVDsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 23:48:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20350 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234670AbhDVDsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 23:48:52 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M3jj9Z008165;
        Wed, 21 Apr 2021 20:48:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ukbGfH29OG2SgrVawLx/PQcsnIS9TW1FnIMUT9ZVXis=;
 b=I+1nk0xgQECXmLyB5OK+AUi20gMgygZnsJH3gse+N7HvOkl7+pOIJKrXT2hLY0cgQO+9
 077gAIKV3+lOfL5EPnEv1htLFPhktcAvHD1dJ6PUDcmIQ8MZjiZXc4EZWc0lxilkbY+G
 vjvWSt7NOOm49/HZ4f3sXhT9XmBTPnF/LVA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 382726rh64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Apr 2021 20:48:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 20:48:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWhVe8fCPVJYyc5ej9jf5Adhpz7trliy2LJUFqvzXae6jxlZV4gN+RoJgDiQ+ReMGz+yw9j7FUj5ThUQF4RyyezcY9HjywAyEy4sAQPCPhtBwK5O14iECU/rs8dZ28EzAs4T0EbYlnGwqDdKzzZaUu5nvYDbOWPD8DZ24UzO2WFdpaI9133An+F9oOgNibs4fOwA9P6UoUoNqNhnPNhlt5QqbC6vLKLH+b5hxGfIxA/X3A8LVikUNuTmWFt+zlQSNGLFEF06s36Ef1nsxc7liUk5UWnKrtXMWjjBWyvbUwLsg8HN777OHcpRBhO3uAjMrAOQfUnDL/tcQcJ3hqMKYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukbGfH29OG2SgrVawLx/PQcsnIS9TW1FnIMUT9ZVXis=;
 b=aTabWdxeedtm3V1L8FE14HqfxCe1i3PxtXVn1BCfPnE8QSbcHbz2SffBihMyzT+1UuDxFTqINEmtgYX7KH7LBP2Mo2jVQy8YgvBTKGsfLt5kcH6iGBEpYLD9xQmfTMUAcowcGmYPTMMKTi7eCTjo1gT7dQHGpB+TS+2YBaUP/8JZqErg0lZ3PjX901aBTR4xXmn5Ak823WaLA8wXnHKrO+fCVAlr+nJeIx5BPAypxIY4/aG3qO9Whm3CDi2nzP/ZKfvne8n2Je5PVWCMb4qSbCUrY/TDOxnfZEQHqSpAR6lY8CRZnlLon0QNwGisz29LKuhwuISafsMon9F0nRJ1nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2253.namprd15.prod.outlook.com (2603:10b6:805:20::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 03:48:00 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 03:48:00 +0000
Subject: Re: [PATCH v2 bpf-next 03/17] libbpf: suppress compiler warning when
 using SEC() macro with externs
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-4-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c9367c9d-527c-ba50-bb28-59abad9f5009@fb.com>
Date:   Wed, 21 Apr 2021 20:47:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-4-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6133]
X-ClientProxiedBy: MWHPR10CA0012.namprd10.prod.outlook.com (2603:10b6:301::22)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::16ea] (2620:10d:c090:400::5:6133) by MWHPR10CA0012.namprd10.prod.outlook.com (2603:10b6:301::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 03:47:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9b429ca-0da7-4a52-b185-08d905416ca8
X-MS-TrafficTypeDiagnostic: SN6PR15MB2253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2253CFC6E4752905D8F44D9BD3469@SN6PR15MB2253.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gu/+fOMpnwzM3GvVeD2rmQpYSL2PFqzbIY7XgvzuK1g84e1qqcPHeY6zDI8eZO+YcZwhdOKiqCg9uBcTq3P3+GNGGMri5aN34xcg7JbBpL4uddAjNrwid9f5CC7MpIqpbfaXasLkgN9jADFpfNiQkXzcOAuyYogOzVgFeatYyYTV0ju+irLNCjyXnwu9YdROqc7jvX6s1FXaC1c8ckFvLRl3F7DBogrSrSlOjCVUa/gn9iplX41hpIXRlSSJK4S8nZzXhk1sI27C7Tad/XsCPG3uyUMHoeqH9uLLxYEojLOoGZ3xklTkSTbWe0gJ4PsIA5+amCmgmsIouR+SImkTdo9qIpCc9G2cOOdLNrw3XAIuFhDpQ3XK0U3Fm3fDETseZMLXgVrb4SOBqVzdli1fv+gQ7D2LSQCc6SmDe3JUDldbcCrrgCTUJmnyhxMJDT0OFEKVi3NgoXpfS369t6u9HU4HDzaBAekgzAwXuWUcSlUZca0B9hyO/PMD3qm73RrjIhcFpcVP6b3aj5TkUI9/gSuI9168LWgdnBK65/HPivGRyWnqU/e9a0X84Fz3PqeCDdD3GWwA8UewjZKKoG7Mc3ihrRnhfL5uvXZ/5EIUX3qLYC9nCG1BfCGsh/iwOOViF2AJCd1mWWCwoxoJk3t6xe2pKafn/4Fqm1fSTyezzf4N90Iy/WA9pRX52CqqjIkp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(39860400002)(396003)(66556008)(186003)(316002)(38100700002)(16526019)(4326008)(83380400001)(52116002)(6486002)(2906002)(2616005)(86362001)(8676002)(31686004)(5660300002)(31696002)(53546011)(66946007)(36756003)(478600001)(66476007)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VTZ6L3VzbUh4eGFibEFOdHJjNlRiZ3ZZdWFwcUIvZi9rYlBlc1dWNFNiclFY?=
 =?utf-8?B?OFdDSGc3ZVEyM0RKUUhGcUwydG9uVythL0cxOXBNeENVZG94VGV5WE1EUW5S?=
 =?utf-8?B?eTBIdGVsMW9tUnMxQnZTd0Z5LzFXNVNNZ211cVF2WDhpRitjN0JUR3VDL1B1?=
 =?utf-8?B?SnMxN2lkNlBuWTNJaENKb0RuODZmSCtPTHJ2RTZHZk1xc29mekRRSU5YSnNQ?=
 =?utf-8?B?aHRWNXozaGROcHd3VnZzVUpNc1JLTE5PSEZRUjFtaEhoeG1mVk4xdnZIQzVo?=
 =?utf-8?B?SThHNXVuOFUxWFE5MFhUeHJXUGRNWTNrTmRMVTdNK0JsSFkzM3I0NGJld0Ra?=
 =?utf-8?B?aG4yMVVhTG9ESE1ETTlQajUxdVFtampLeWw3N0c0ZlRxTE1HVHV0MUdoM01y?=
 =?utf-8?B?R3Z2MlJiQ1BEM1h2QnUvckNVR05HSmNKd21wMmRYbEFyMWlFekwvQUtxaTJl?=
 =?utf-8?B?RlJRd3FSd08vemhzK2p3dXpENnY1WUQ5b2FlRk1vMXd3Uy9LditDd055Qm9U?=
 =?utf-8?B?dDVHY2lvSEhFOGJUVUVpZUNhSDZrMTZEME91dnJFRVlTc2RLeFh1aUY2cWVT?=
 =?utf-8?B?OEl2T1lWY0ZoeGNsQUpUTjNVMEZ6Nit4eStNTkZXaVJvVEJtSWJrYlhLdks0?=
 =?utf-8?B?ckUyRkxNa0JQYzFWcVErUVltVnRGQlozN3RSY3lSYVp6SHlxUFRRZHVqNVhI?=
 =?utf-8?B?aWJscXdEVUR1dUNQZGRxYkxKUStDUW1JN2NhRCt0ekQxcGN0OEVZc0tvSjJM?=
 =?utf-8?B?M05ZemhBTFg3ekExcGZ2MGEvbllrNmpQcFdPTUYvVW56M0QyZk5HMzlEekl4?=
 =?utf-8?B?MXJ6cXo2bWZLNnpDL2x5RjdySjlCTWFZaDBFTFN0ck1PY0ZLdmhrYldZTWZR?=
 =?utf-8?B?LzU0UFVHZ2s0NjlOU0dPMStQNEJOTlNoaWVVWEVVdEp3ZlA4ZWRodTJKNHI4?=
 =?utf-8?B?ZkdtYWlBcCtzL2x1U01idnpaZTJnK1NubkFxZHVsaFF2bmpxNlVpOFNoV0Zk?=
 =?utf-8?B?anNtcEc1RGZRK0kxeGg5Z3U4V1d1NDQxQXpWV3UxNU1jZnJibjJJSmVVK2x5?=
 =?utf-8?B?MGZjSTBNK2ZzOUpqV1JoZzNOeVpRV2RDb2dxUDFOZWw4SlFlUklnYmNjamdi?=
 =?utf-8?B?TzRJYkVPOHlQbTcxZE52akNadHh4bGhuSDZXb3pma0tCS1IyQ2ZZRnJKcW5U?=
 =?utf-8?B?MW9zdDdMd2M5TjNwVkdSbWxJMC9UN085cG5ZZEFTaVZKczVBR0xxTmpxR2U1?=
 =?utf-8?B?MTVFQmlzK0phMUYxb1FSeUFrd0Rab0gvTnBheDBSWStjbWE3Q0NkM1hiWnJs?=
 =?utf-8?B?eHliWmQvWVBlK0kzZVpXUkpZaU1Ca0N6dk1vb3RwVU1ZdVZRTXRYZGZnK3FI?=
 =?utf-8?B?YkVXSUJaU28rRzJjbjMrQWN4TzE4Snp2VkFaQW4rcW5WcGJJS21PeUowemVI?=
 =?utf-8?B?d1dRQUJFem9RK0JGT2E4Wkx2bThFV2FMY0pSQzNWMDNsWWFlWEl2K29BQllK?=
 =?utf-8?B?MnJKbnRFTE9PNXpaSWFyOVJXT0hOQ3ZWeWRmVGdMMUtoMlpmdzFOS042cURk?=
 =?utf-8?B?N0kzNnpGTTdZQVRvS1JaTHVKc3JJTWdXZjYrT29OUFR1d1JoNG1Gb0VVdzY2?=
 =?utf-8?B?c285NmsxUW00eXBKTWY4TmhiVTN4dnI1TDV1YkpuVnI2N1ltckg2Q095T1VD?=
 =?utf-8?B?SENGNjI3bWJxaWlLdXQyZldXMERiR3ZSb25oRnBSUGlnN2hmTlE2Uld2Y2dl?=
 =?utf-8?B?Y2ZsUE5KeGsxWmk1RWNzQkQ4VHI1Tnc5K1hza2RKandBcGJneGs0NlJhV2pz?=
 =?utf-8?Q?aWLGILQgGffMV7l5RmWqZn/Gqp+8jhRd59XY8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b429ca-0da7-4a52-b185-08d905416ca8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 03:48:00.4723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HVFLoQN8rFCnm0WauzGZGeOwsPKHQo1XWnwo6NhVZ8z5QZD+kgsd26jOQLNVf/3h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2253
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: UMcuUXRZS0dUrur1lXC4pDpQyhXDrTMq
X-Proofpoint-GUID: UMcuUXRZS0dUrur1lXC4pDpQyhXDrTMq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_08:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104220032
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> When used on externs SEC() macro will trigger compilation warning about
> inapplicable `__attribute__((used))`. That's expected for extern declarations,
> so suppress it with the corresponding _Pragma.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Ack with some comments below.
Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/lib/bpf/bpf_helpers.h | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index b904128626c2..75c7581b304c 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -25,9 +25,16 @@
>   /*
>    * Helper macro to place programs, maps, license in
>    * different sections in elf_bpf file. Section names
> - * are interpreted by elf_bpf loader
> + * are interpreted by libbpf depending on the context (BPF programs, BPF maps,
> + * extern variables, etc).
> + * To allow use of SEC() with externs (e.g., for extern .maps declarations),
> + * make sure __attribute__((unused)) doesn't trigger compilation warning.
>    */
> -#define SEC(NAME) __attribute__((section(NAME), used))
> +#define SEC(name) \
> +	_Pragma("GCC diagnostic push")					    \
> +	_Pragma("GCC diagnostic ignored \"-Wignored-attributes\"")	    \
> +	__attribute__((section(name), used))				    \
> +	_Pragma("GCC diagnostic pop")					    \

The 'used' attribute is mostly useful for static variable/functions
since otherwise if not really used, the compiler could delete them
freely. The 'used' attribute does not really have an impact on
global variables regardless whether they are used or not in a particular
compilation unit. We could drop 'used' here and selftests should still
work. The only worry is that if people define something like
    static int _version SEC("version") = 1;
    static char _license[] SEC("license") = "GPL";
Removing 'used' may cause failure.

Since we don't want to remove 'used', then adding _Pragma to silence
the warning is a right thing to do here.

>   
>   /* Avoid 'linux/stddef.h' definition of '__always_inline'. */
>   #undef __always_inline
> 
