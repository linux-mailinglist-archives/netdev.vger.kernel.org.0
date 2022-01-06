Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C54486D43
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 23:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245173AbiAFWgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 17:36:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14866 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245167AbiAFWgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 17:36:03 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 206M45K1023482;
        Thu, 6 Jan 2022 14:36:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=t2TGCG9J+lEH6MEqGybQK2J0obRVElXoWorZrJ5lGA0=;
 b=N3TNm28lmF+2LWo105vTqKXgEgLsEbKN1b3lLV/kqRjuPsSH9UEwe+pbpPG1aypdXD8f
 bmSOHLCp7sn629PASgdjGJ0d9zjuSJaPDw+EMggdTkpiRgbf5UYF+/lxfxpQNBd/NkHT
 l9hZPAg82/ILosVDo/Cu/sWgDQw8OJQ8EPU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3de4wj1v33-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 06 Jan 2022 14:36:00 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 6 Jan 2022 14:35:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEO2Hz1pzdGBsGslpocaHTUUXXN8X9uJZLJLrvXThDfAaC6lQxnEi1yM9GiIxn6cJAVwDE5MjGURIjdE7HgxeP5k7Sd2hUGeUF5zEwPmxVxODc25cR4ZKYmywj+2MUsZ4geNwO/KxBQuekaHgyvFitHRtFywdogdt7D7BKOihdTnb3CovFOxjXy4z5i0VDDVbkvqZ7GXqCJVscJ7XIBKtadboW5DcnEUnySYQztSR3/ZSlkOMwoxOrn86YFIS5AUAPbou3mNtT2x2z4MgjtHe1htzG14ABFrrJxSSls/An5a/NYmCurSQI/3ATi4VeafO8WXzWrXzmaS1BXXyNN46w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2TGCG9J+lEH6MEqGybQK2J0obRVElXoWorZrJ5lGA0=;
 b=b8AHRKFEs1Ur822GH6kb7gRBO6pLlHE8QyhbZVWMmV/RqcoLpsT5rSbqwOVdBH7+FT9YDYs6usiMndUqj3WreEhVaUFFG/VkfI8vnJPCfhew3JGfUTEUSoPyt0toHgGK1mYfGE1AzAP2SAK92eUSmE2vpYzpfXCZN8o9C7reiUvWTpe4DmboCyuzeYCzr+R4LLscqJ0bikcmodWc6janlMMLbO1HoCb9T4yClXz8OIY+LnQkceQLjrlHYgFMvolIjmF0onFzU27FbRGqoOWeZv5TdD7LjD7HzG9dnwst9+U+H2U3RuCgcXRpid4vD675GJ9+Jp/kzeb4+ziULfqV7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2335.namprd15.prod.outlook.com (2603:10b6:805:24::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 22:35:57 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ede3:677f:b85c:ac29]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ede3:677f:b85c:ac29%4]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 22:35:56 +0000
Message-ID: <ebcc1c48-a164-d23a-7e4b-0ac5bbc8fedf@fb.com>
Date:   Thu, 6 Jan 2022 14:35:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Content-Language: en-US
To:     "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        Martin KaFai Lau <kafai@fb.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maze@google.com" <maze@google.com>
References: <20211222022737.7369-1-quic_twear@quicinc.com>
 <1bb2ac91-d47c-82c2-41bd-cad0cc96e505@fb.com>
 <BYAPR02MB52384D4B920EE2DB7C6D0F89AA7D9@BYAPR02MB5238.namprd02.prod.outlook.com>
 <20211222235045.j2o5szilxtl3yqzx@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB52388E60A9E9BA148CBA9299AA449@BYAPR02MB5238.namprd02.prod.outlook.com>
 <20211229210549.ocscvmftojxcqq3x@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB52388A3420C7FBC0B79894CFAA4B9@BYAPR02MB5238.namprd02.prod.outlook.com>
 <2e3a072c-2734-0d54-d0c3-833a75b509bf@fb.com>
 <BYAPR02MB5238358FFC983C910FCA595EAA4C9@BYAPR02MB5238.namprd02.prod.outlook.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <BYAPR02MB5238358FFC983C910FCA595EAA4C9@BYAPR02MB5238.namprd02.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:303:8f::27) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaf5f236-c77f-4aa1-186f-08d9d164e7d4
X-MS-TrafficTypeDiagnostic: SN6PR15MB2335:EE_
X-Microsoft-Antispam-PRVS: <SN6PR15MB23353E037F4E5F4408F56EEAD34C9@SN6PR15MB2335.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RD8yEE1YEopZ2+RWtLgKJQRS08hFr68lm5pjqEsAN8Ri9q6M/Wi1g6apJScaGmcMOBjB5p2NEGnf823XqulkibjqmJTvzeyR8bWdaPdAZQ9/7lLzDkbSZUTnTBjbiT6hwOkMQrBtoQ8MNSF94oOw/GlvinJ1ahLze4Af+MFoic1YZJ/J60j1WW82M1UXu6dQVQcJ9BPl9UHy3VA0fLEPQCci8qcsxGICrLNitsuok61U9/piwzkzFXlL5unLrBbbJKedCNldTjd+v7Qab4zR0EfXLN/HHNV6BwskIS0svyIRAydHj6y4uz0w6nsibTC+hSjTqub00GmL/Dg3iYKQcy6GPl9O6MAzEFmRhV4X2E1vq0paXq6as4CBfdbwVz/PNsxf7/moEE/GzFgZJemUzwFFv4e8kTFEbq9DvymndiUv88s57yZseJO0gYLEshosb3bI5XecbQuTyaPPkD4VO2lwaMh8gTisDWOzJK/YVMUKOwYvrLJGZlAiqcM10VwFmlyJjeYcoG/3j0Qbk/LKKuKGrXB6q4zGbi9BXQgy67UzaXrgNIsTzojk0Xr6nMYU5fHU8I1sV9g8IbeTPh1ZWp8HvbIt1IHr1TfF51tawoWKTqjh/VAZiEa8Y30E2uVFKsXQnYkKYRutP2xf6dn1wwY8OxB+52Bo3fdKQfz/dYZUP4wV1UrllZYDDWyTFcYEgADTE+RK+ksB4wnawjbMwjuIMgXO1lEXg+dIzHM66KM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(66946007)(186003)(8676002)(36756003)(66476007)(6666004)(110136005)(66556008)(2906002)(31696002)(508600001)(31686004)(8936002)(6512007)(54906003)(5660300002)(4326008)(53546011)(6506007)(6636002)(83380400001)(316002)(86362001)(38100700002)(52116002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFloUFNJeDl3aGRwT2ZkNVVHTXNXd2VkOTFRTmE3VHEyNnZQZ0kzdHZNM0dE?=
 =?utf-8?B?bGIrcXFOdnpKMG5RQVlWMjYrbG9XZkhUK2pCWVNQRGd4RldjVWQ3RXg5RCtY?=
 =?utf-8?B?Y3V1UnhxaFlscGdGTUNqSjgwV09ULzE3OWZQU2VSTzZZMlAxTy91TmRBQmJz?=
 =?utf-8?B?YTYrOVBldlMzcUV1cGpYUEJ4Z3M5akhqYnJ1V3VNY1dnb0tVMWowT2c2ejdN?=
 =?utf-8?B?Vk9xQ0U4L3NVczFnSXBURHB5RURZMFp5ejZkT0pzVHQ1OWhHR29ud1lLMFFS?=
 =?utf-8?B?Q3N3WlMvY1dvekdhcTJaS1g3elpXS0o3UW5RakNpYzlJZFhCcWVHZlo3bFgx?=
 =?utf-8?B?YWZ6blJoN211MDlmUm5HL1JveGxIQmZPVXpIcWdCWVB4MDNpN05BRjRhMmMx?=
 =?utf-8?B?QStycDZReDFJU0V1aVQ5bkFTZXNtN0RHdTQybzhpaDJJaCswb1NjMFlNNVYw?=
 =?utf-8?B?MXBPb0IrUCt0TXM4a2FLcjdCdE51RWNsWkt5VmpQemlOMVFpU2dIMzhYWkVo?=
 =?utf-8?B?U0IvckEzK1ZaYmlTeUJDdml4cXYxdnJib2hrTldqUVZKaXRGbW9scjhubjJq?=
 =?utf-8?B?dGZqd2VxTG5wZlhxYzRvWDRrUS9nRUNHL0JabU0zWXU1c0NMaWIyTUVya0pJ?=
 =?utf-8?B?bHJvcnNJbVBBVDdPcWpMWEwrWXEzZ0FRam5OemhndVR6TlI5UTRkQkY0RVJW?=
 =?utf-8?B?WGJoVUpQK2JuOWU1ZG9McEhVdHBlZUdxMDRRQktzOVE2VUVoMEgvWVdkZDk5?=
 =?utf-8?B?bWh5N201Y29wUHI3aVBhNjVuY3JjTjBxcnRlWDZuUVVoTHdXaTlJYUNYRWtC?=
 =?utf-8?B?L0w4N3huRW5MUVpxK21lNkFmS2FIUWJTZU5GWnlKWkY2VDBtVTdXSElWUnNq?=
 =?utf-8?B?cEV3ekdwRVNSV0dVNEpmQnZ6aHI1T3ROZW92T2hkeGFBbHBRQWpHZVlpZXc3?=
 =?utf-8?B?NXdlWTNLMFRZZXdoSUZZQ1lZcGFQN0lYa1NhSlM2YzBMMTRNaHptcm5IZldE?=
 =?utf-8?B?MEYwVTAxNEdxd2VkSjB6MU5RbzZVSmtFSllOSlQ4WGVndTdKKytpTzUwU0lh?=
 =?utf-8?B?NU5yMWRNa29hZHpNeC9OUFR0TGlTaVRkMFByKzJWUFY5RnJreFZPaGlqakpO?=
 =?utf-8?B?VTErT2E5WGNMSU1ITlNaZlRXQTgxR1pBK0U4czNJRlhGMTl0SE1ndlV5MXh4?=
 =?utf-8?B?VEZsZnZKSVd6NTROTXNjOXZzMUthaWtaczluL1hLb0NoejRGMlMwWVJ4V3Nj?=
 =?utf-8?B?aXJ1MWVFM0xkUm81ZXJlNzFkdXlFdWdBTXpvb3VNRExzNklueXJsbGl3dDZP?=
 =?utf-8?B?QWxFNjB2Z3ZpODFZL2ZiT1FyeFlKU0xaNTZMc0lvdXhHdG9PTHBKcUt4b1lB?=
 =?utf-8?B?REdwc1lpaHVPdEdyRFBnZG1PMEhNTzE1REE4R3lLYkY0d3VvVHorWmQwSFFV?=
 =?utf-8?B?dWVtaFZITVR3U0lFei84a3ZLOTNuU3hieXBOU1dkbno0VmQxNURhRTNxV1h4?=
 =?utf-8?B?d2N3TG9PeDlXOHphTE1SQzJuSmRNU25KTXIvQUh4ejZRdnpOL0t2aDhyaE1R?=
 =?utf-8?B?TTZxQStYMGY5M3RqcGdITlllOEVqeUpHSU5DRzU3cGJ1UGtBTWVKRXpBeUYr?=
 =?utf-8?B?TE9LVDF2OXl2YkQvMDl4OWkyY3VkMjJNTXcvZ1Z5T0dZczNQQ0c4a29sMjdk?=
 =?utf-8?B?bXo1YlBQeXZOd0Y3Z3Uvc3FDc3ZQanNIZnFJQVY1RmNWbE5ab1RIY1dnQjk0?=
 =?utf-8?B?SU5JU1JFL0oyOE5XS2RCQ2NPK0hOQTZUekdxMGFBRHpVOEd5anU4cTJMeFNm?=
 =?utf-8?B?SXAxcGRmTURnVHFQdkg2Z0huUy8rbVpzMXhLQzlUYVJqbXBiUVhGeHVCRnox?=
 =?utf-8?B?MitxeURqTlhDQzdCYXlsMHc5a0dqdHRFaHgreXdJaW9TaWZ4UVZvMjJ4SVFO?=
 =?utf-8?B?Y01BUEJtNzVZSGJGTWVTRHJCQkR2TWgvZ3QyQUx6dXVLRHNDZkc3dUlYbS95?=
 =?utf-8?B?a1pibTZjNWJ6RVJHL2IwSVovR0cwM2NFUldqZTd1N1RlUnlyVmFzZXBhVTNi?=
 =?utf-8?B?RlBOcnJleVZIZzZxZmF4a29FTTJsNDVZMkc0MnZBQTBzNElHUlIyY0FZaHJN?=
 =?utf-8?Q?rSvr6iAAjHBuRaMV20Zwar7Fa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf5f236-c77f-4aa1-186f-08d9d164e7d4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 22:35:56.8351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yovpbxy8bvH9rHEg8GmbqY+8Zmwgi9xRXiTEVYtcXp3nEUPxjcYwqkllDOp1EEna
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2335
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: G8wkoe7v-EUFpEeRs_fieabNwZf8lZpU
X-Proofpoint-GUID: G8wkoe7v-EUFpEeRs_fieabNwZf8lZpU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-06_10,2022-01-06_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 suspectscore=0 adultscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201060137
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/6/22 9:18 AM, Tyler Wear (QUIC) wrote:
> 
> 
>> -----Original Message-----
>> From: Yonghong Song <yhs@fb.com>
>> Sent: Wednesday, January 5, 2022 11:51 PM
>> To: Tyler Wear (QUIC) <quic_twear@quicinc.com>; Martin KaFai Lau <kafai@fb.com>
>> Cc: netdev@vger.kernel.org; bpf@vger.kernel.org; maze@google.com
>> Subject: Re: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
>>
>> WARNING: This email originated from outside of Qualcomm. Please be wary of any links or attachments, and do not enable macros.
>>
>> On 1/4/22 4:27 PM, Tyler Wear (QUIC) wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: Martin KaFai Lau <kafai@fb.com>
>>>> Sent: Wednesday, December 29, 2021 1:06 PM
>>>> To: Tyler Wear <twear@quicinc.com>
>>>> Cc: Yonghong Song <yhs@fb.com>; Tyler Wear (QUIC)
>>>> <quic_twear@quicinc.com>; netdev@vger.kernel.org;
>>>> bpf@vger.kernel.org; maze@google.com
>>>> Subject: Re: [PATCH] Add skb_store_bytes() for
>>>> BPF_PROG_TYPE_CGROUP_SKB
>>>>
>>>> WARNING: This email originated from outside of Qualcomm. Please be wary of any links or attachments, and do not enable
>> macros.
>>>>
>>>> On Wed, Dec 29, 2021 at 06:29:05PM +0000, Tyler Wear wrote:
>>>>> Unable to run any bpf tests do to errors below. These occur with and without the new patch. Is this a known issue?
>>>>> Is the new test case required since bpf_skb_store_bytes() is already a tested function for other prog types?
>>>>>
>>>>> libbpf: failed to find BTF for extern 'bpf_testmod_invalid_mod_kfunc'
>>>>> [18] section: -2
>>>>> Error: failed to open BPF object file: No such file or directory
>>>>> libbpf: failed to find BTF info for global/extern symbol 'my_tid'
>>>>> Error: failed to link
>>>>> '/local/mnt/workspace/linux-stable/tools/testing/selftests/bpf/linke
>>>>> d_
>>>>> funcs1.o': Unknown error -2 (-2)
>>>>> libbpf: failed to find BTF for extern 'bpf_kfunc_call_test1' [27]
>>>>> section: -2
>>>> tools/testing/selftests/bpf/README.rst has details on these.
>>>>
>>>> Ensure the llvm and pahole are up to date.
>>>> Also take a look at the "Testing patches" and "LLVM" section in Documentation/bpf/bpf_devel_QA.rst.
>>>
>>> This will also require adding the l3/l4_ csum_replace() api's then. Adding the csum_replace() to a cgroup test case results in the
>> below error during bpf program validation:
>>> "BPF_LD_[ABS|IND] instructions not allowed for this program type"
>>
>> I saw you posted a new patch, so it seems you have resolved this BPF_LD_[ABS|IND] issue. Do you know what is the reason for this
>> verification error? Here, the program type is cgroup_skb which should not mess up with BPF_LD_[ABS|IND] which is mostly for classic
>> bpf to extended bpf conversion. Did I miss anything here?
>>
> 
> Was an issue with using bpf_legacy.h to load bytes.

Okay, I see. that makes sense. The helper bpf_skb_load_bytes() is the 
way to go.
