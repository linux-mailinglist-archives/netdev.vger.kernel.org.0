Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC9039E78D
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhFGTht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:37:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6710 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230351AbhFGTht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 15:37:49 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 157JXh8d025169;
        Mon, 7 Jun 2021 12:35:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SNSiZ7ml1rNZC9cGXRzPGoJDElq5y3M8JneoHYqOTl4=;
 b=FgQX/XiMUjW2SZ1B+liBgBWobyXHflj12O3gh167v69apGTjVbe6FOb5GmL6K7PMGVjJ
 lnemiN9ZG6xXXGVVnLEf2pBsO06SfXY3l/zeB7lblcjC9Utmlzzyu/DVf3M3J1n8yD3L
 KqYrHlczzI16EW4vbkjbAj6xbEZo0DMk140= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 391rhygffb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Jun 2021 12:35:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 12:35:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhhCFFIPsmTTr3n1aIe9s+/VfYOryOuJxdlMb2KtJKYTh5ZVuXPkxUJo3L9tNcKq3gOGT9ZKg4SFdaFViaSWG6RnlFF5L6JakUz1g9iN96ReJPNh4lI8d/bWymSqfx85W0G7D6tRIgVNpzeyxvU2iokc5hWH2h+Pqr+cbqnRzCMXiW3PrsIHdcxjsP4V/sdxXmsZZo+4mEpaFoFtq+qOLe0YcW/8M+qT0krm8TDWSgZYkRV5FTFyUQ+cmM6wG/aX4+njn4+rP0TfI3UoS6sHyUQO+qLrzT0CV5O4AtBMMu5IwO14IU6GEf1YsBkWcmw/ImUY798Pe4Zo6nOXgzbdpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNSiZ7ml1rNZC9cGXRzPGoJDElq5y3M8JneoHYqOTl4=;
 b=N4/Du3qmFNT634QCSr8BaJQhBuLL3yYFygLcj2W4JqS2NEQvm2XTn9EleT7GweHVsCGBFPcVVI+pFaqkur44cn7EZkTdQu1+a1EkjOJLWgQucpC4hoCdtx4e4FwA9M3NdATxlL4f31Y4rcLClNurvs8EILw/MoMsh0wSL1JhcyX+vjhJGC7/hSCXWSj6Mju9JzMTkt6vCkWoX2PF3mqqrcGBSrVMwuPwKew/dCI6zxro3Qq7L99leomtDekACEQHEHlOXTf0m25m98fGOppTQNu1Algyv8ZzYqKsc6zfxe2K13oscOVAnxZdErt9SsJZa/P+secma7uk28WzrQuk+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB5029.namprd15.prod.outlook.com (2603:10b6:806:1d8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 19:35:12 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 19:35:12 +0000
Subject: Re: [PATCH 11/19] bpf: Add support to load multi func tracing program
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-12-jolsa@kernel.org>
 <db5c591c-c5f2-9bcc-28bf-f5890c2cf61c@fb.com> <YL5jCPZhmMxfFy26@krava>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <72b9258d-9a1f-2dab-ec59-f8a8a60d7653@fb.com>
Date:   Mon, 7 Jun 2021 12:35:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <YL5jCPZhmMxfFy26@krava>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:db22]
X-ClientProxiedBy: SJ0PR13CA0064.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::9) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1097] (2620:10d:c090:400::5:db22) by SJ0PR13CA0064.namprd13.prod.outlook.com (2603:10b6:a03:2c4::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.12 via Frontend Transport; Mon, 7 Jun 2021 19:35:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c7f3bdd-774b-45f1-b0a5-08d929eb5e3d
X-MS-TrafficTypeDiagnostic: SA1PR15MB5029:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB5029D864ABB592BF62145DF5D3389@SA1PR15MB5029.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Rvaxs6p9PpqudT5VtZWjPUdjIVCpVL0NEdKQ4BReFtVcdhg6vf4WIcyzGo4npcXJH3nxSWKoZ7pTTyDKTv2P5OyE2h4etw2jbG+aX0wcprJB53L7i78iMgi9mhp6yDfm1IG1LBPSGZ0BJsXwt00jhNfIyC+D6O0p8ZK3DOxB/NCoxDVC+5G0FBJTjr86QJcngWWiAqIm9rA+NdRQcmALKPgtk5DXGmg73N+InuRtfAexlXorjrnnnR+kYzQa4BORfzjEbGQZTcFML81wP8+HD84nnlB4vr5IVuJKrZboDsZkdykn7z/welPi6AjQX0cUZnCV9UKUkpRDP2jFqjMX86IwQhcoGKjVEzwUvZA8J98efBDH/o7pI4+DJcyAMVvk3zZayQIPwfEXABq1p1noQGTNXHJ3xTGQQJguVuXb2tJTTfj9DTacO5Llw+64/hVazgX9LXAP4d/Jpj7iVH6h/xrzQZn30EMjk53NIRnclPxZKJu1a45gMBa4vhkGmtKN7brIX2qE6TIjgsQui/5fN6Hk6CkSeP70IVOscWu+UhjayDWMpdzHq2e9WY461EM40JJMLxuWtYmXfj1KJfqdEt8D21swNNJSLx5ILS0upt/xZ87TJcE1miiquGo6OS6djN0HOU66/tviuz4Ep7HgVDloF04x15Orgar66a98ZjbNXVCX4c9JiFptXteyJy8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(396003)(39860400002)(5660300002)(54906003)(66946007)(16526019)(6486002)(38100700002)(186003)(4326008)(83380400001)(7416002)(53546011)(6916009)(52116002)(66476007)(8676002)(66556008)(2616005)(316002)(31696002)(36756003)(2906002)(31686004)(8936002)(86362001)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bWdYdGxhSTFtZERwdjdoQ0VTTXBWOUJNdEFFY1FUeDhrVGN5WVBEcXVsWTRh?=
 =?utf-8?B?RkU4bUtMaGt0c2hDSXAzMzRmcGhPVndqMmQ1K21hWERjNnZtdE9jY29tTHIw?=
 =?utf-8?B?a2FPZTZ1QVV0RGFqSXBkekZ6N3c3dCs4MHFxQXZHMkQxQVBWRUNGRkxCWVpN?=
 =?utf-8?B?bk5HV1NSejY5bnRXcUtPNXcwSmhSVFhYcDVESm9ERitVMWdsMEhuUnV1c2xG?=
 =?utf-8?B?dUlPV0p6elUzMnA0UC9ZUmtpR0xQZ0JFRXVhVWVQd2JLbVZjdWxJYWlkSGpz?=
 =?utf-8?B?SzM3TzFMNDVZNWk0YXhSRkZZR2NyS1F5ZzNEclFJdENkR3FsNnBuZzRkYXFR?=
 =?utf-8?B?RkRRT2xlNkdhK0NsZVUyNGxSSmhxRTBsVTFrK1VtWTNnQXZnbWFNU2l6YVRW?=
 =?utf-8?B?MTRlRGx5a0piVmhLTU43d3c2UG9YTGhrYnAyMGtYcGJzMVlqWkw2SnljYmVp?=
 =?utf-8?B?bVNiSTJ5MFhYcUVkTkRIT2tUQVJvYVdBL1kzemYzaExtNkdBUGJtQXBzTFFz?=
 =?utf-8?B?NzhYcFlESFRXWlR6b2lMcWpTN05Ccmg3K2pCWHZjTjVSNjB5VkpJbndhTEVU?=
 =?utf-8?B?OW85dGFxRG90MS9HeS9TMEIyOGlSbEpLS21MN0QyV3JZOXRMekRBZUpVcFJI?=
 =?utf-8?B?VmhuSy9IdnpBZmNzUTMvektHL1RrUUJEYnloRzdyU2RDd0VubzFLRVZLbFBV?=
 =?utf-8?B?OVV4TWJiSTgwbW1hVER2aGNpbVFpblpJRDFaTldTQ29vaFQvOXBubGVscFdk?=
 =?utf-8?B?cWRUblRBUEUwWVlFV1EwUDhJNHU5UlErU0lrZnFCWW50QXRjNlJSdi9kSkhs?=
 =?utf-8?B?ZEtwWWZhTWlDYkxWZElTLzNVYkhPVEd5eHVoL0laakY1c3FIMzVWQytvZVkr?=
 =?utf-8?B?aG82d1cvRGRzajAwZ1RnYlpQazlncW1Mb015aWg1NWFNTzFNV0tmT09uSlYr?=
 =?utf-8?B?ZFZlNVJHajU3MnNGNnR0RmxVVndzWnMwQzdyS3JPTjkxRm5sb2drN3JPbDVp?=
 =?utf-8?B?d1BHM1N1dERuOXRPaEFxWWhxWk9yY1pZbGliR0VkTE1PeDYxQjNHVi9Rb0VN?=
 =?utf-8?B?cFEybkdCUHBTUTI5K1J2eUVsYXBMZjE4dVYwNmhQWHBLMDk2RW9Sa1JDaFpl?=
 =?utf-8?B?RE1kdnkraUlLMzh6bUVWaTdXY1c2S0gvQUk5enRSWlZTbVdZZzBnd0hpN0xm?=
 =?utf-8?B?OEl3OCtSL3IvL1FadFY1STBmWTE3RkdUaS85Wkd5UWt0bExsUGFrY09qd1pk?=
 =?utf-8?B?ZklrVkN6cHAwREIwVndHeW1vUjRCajl1OW9IT2VJMUxGZE1LOURqNlJqVHZp?=
 =?utf-8?B?NEs0alh5UzRneklYM042bEsySGltbHV4bG5yaW9GU1ZnQTc0LzNzSHB1bkhF?=
 =?utf-8?B?Vjl1Z0kxMXhrNnNJSDdtM255OHE0UnljeHZ5YVZPdmZoNEFPQUZsNklPYWtJ?=
 =?utf-8?B?b01NN1dIamI0WVBTdGNhZlRCckxFOFBTN0k0cHVYS2p6ekNnR1VIVkV2U1dn?=
 =?utf-8?B?U3p3MkM2OVVoOEdtQlZISTVzVFR4VDd1WEpOWm56bmR0Smp4YldvSllYYitU?=
 =?utf-8?B?WkdCUi9mMW44QzFQTDA4bktmc3dKWFliWUZ0aW1qUllWbC9kSmRqQlRpRmlj?=
 =?utf-8?B?bTJEVktpY3BUYzMxMExtZmNiY3FYbFFvaGlWclVUS0MxMkNmcXhxZE0ycURt?=
 =?utf-8?B?cTNuS3dhS0NrNjEramVHSzUvdXZYbDJGcmlRUG5oU2VzTk5rbXlrODN4ZWZS?=
 =?utf-8?B?N3ZXWlpLV0ppVHdoU1c2SlF4RjZKcEdHQktIKzNmTXpJUjNjUDI5djdvd0V2?=
 =?utf-8?Q?A8kmId14r9TyOZ5rANyTu7tm3nMCCdLffCLtk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7f3bdd-774b-45f1-b0a5-08d929eb5e3d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 19:35:12.6659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSKC6PAb/aFCVyn2HWuJZoEqB5tjlMZaBu6zZGY7R2FyT/eeLP0IMAcWTvwD4jRY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5029
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: rTnFxjcrLVmt9fEFQAHlDGmWLg5cpkaY
X-Proofpoint-ORIG-GUID: rTnFxjcrLVmt9fEFQAHlDGmWLg5cpkaY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_14:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106070132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/21 11:18 AM, Jiri Olsa wrote:
> On Sun, Jun 06, 2021 at 08:56:47PM -0700, Yonghong Song wrote:
>>
>>
>> On 6/5/21 4:10 AM, Jiri Olsa wrote:
>>> Adding support to load tracing program with new BPF_F_MULTI_FUNC flag,
>>> that allows the program to be loaded without specific function to be
>>> attached to.
>>>
>>> The verifier assumes the program is using all (6) available arguments
>>
>> Is this a verifier failure or it is due to the check in the
>> beginning of function arch_prepare_bpf_trampoline()?
>>
>>          /* x86-64 supports up to 6 arguments. 7+ can be added in the future
>> */
>>          if (nr_args > 6)
>>                  return -ENOTSUPP;
> 
> yes, that's the limit.. it allows the traced program to
> touch 6 arguments, because it's the maximum for JIT
> 
>>
>> If it is indeed due to arch_prepare_bpf_trampoline() maybe we
>> can improve it instead of specially processing the first argument
>> "ip" in quite some places?
> 
> do you mean to teach JIT to process more than 6 arguments?

Yes. Not sure how hard it is. If it is doable with reasonable 
complexity, I think it will be worth it as it will benefit this
case to avoid special tweaks of the first argument, but also
benefit other cases e.g., attaching to a kernel function with
7 or more arguments.

> 
>>
>>> as unsigned long values. We can't add extra ip argument at this time,
>>> because JIT on x86 would fail to process this function. Instead we
>>> allow to access extra first 'ip' argument in btf_ctx_access.
>>>
>>> Such program will be allowed to be attached to multiple functions
>>> in following patches.
>>>
>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>> ---
>>>    include/linux/bpf.h            |  1 +
>>>    include/uapi/linux/bpf.h       |  7 +++++++
>>>    kernel/bpf/btf.c               |  5 +++++
>>>    kernel/bpf/syscall.c           | 35 +++++++++++++++++++++++++++++-----
>>>    kernel/bpf/verifier.c          |  3 ++-
>>>    tools/include/uapi/linux/bpf.h |  7 +++++++
>>>    6 files changed, 52 insertions(+), 6 deletions(-)
>>>
[...]
