Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B9F3A2131
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFJAPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:15:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13706 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFJAPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 20:15:20 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A08FLd004056;
        Wed, 9 Jun 2021 17:13:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QnBFOLbcLsEDDCWDODXadVG6uDFscHeP1nZJigHDZyg=;
 b=XJspad4bqS4YSx/chbRdDr5ot5tasjo7zFdnKxqDevPTDRYfmhPMShelilKGofubAKDK
 YYGMdZzlwcC28Ds+qsSvqHc4ReXq8gf0oc2EYSAAT9yPyKGVCYQqJyn7wU+RJ118TS2E
 qD4OI9n3Ze0iJE+hN5FG/ZT5AB9PeoNXi2E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 392rvqe0cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Jun 2021 17:13:12 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:13:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFATPpzXssfhtI5kPtRblgigrp7WDC6kztUQXYoDSE7cIi7C5QOuxYBZqyQzOk9y0rnQspn0SRDwe84jgFriKMNmwpkOZ1KPITI7pLUEXLmiF5LzI/cyvI1lcMDk9NVgedWUIvc341x5j79BEqpocOhJV7nW+Ns9Xl3wRvN1FVC8RqWMXGWU+ot7FrA+MIG+zZwHiA8q0aGNgDKc6aozC0Pz0oe6bktfER3C/0xCymbh8x9rUnZQnI9wrhdpiCRkuwUG1Bps5UJjqhop1P3CxBm+xXCGp/73HPIM97XwFx6pJLaFmRaTEMKS7bkWV24pJ7sdViPosIGlyPKN7BwjXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnBFOLbcLsEDDCWDODXadVG6uDFscHeP1nZJigHDZyg=;
 b=W6jCkICEoYqBgUeI6FQlhxzQ0dS6SztyDAzCjtnB3MvCeVADpMXRHC0XJwahtd3Cvlomr70CtZPCKoDK+CUBpza3jknQFlwJ376GMTMkcDY87T0HcwcLI3jD1ZNL7wI9cbXo5+fCxrnkubHRzIkguDjWIO1ZGd8mvCLK7kIJjPaz8JW0aWPqn6bndMST+3RdorIoODs4fKxiPJfczcJZkGrfkXvaizvn+rY7yo3xgWETkGDy9MhG4AhTAphz6N5hqeCUqKuaKt90DFrwxsShzaXLIGdPn2FsZLND6poyeWzz8ILeFVZ7v3cEMqJNJjL4LyRqOfLL8iD/RKlZc6yQpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4919.namprd15.prod.outlook.com (2603:10b6:806:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Thu, 10 Jun
 2021 00:13:10 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 00:13:10 +0000
Subject: Re: [PATCH bpf 0/2] bpf fix for mixed tail calls and subprograms
To:     John Fastabend <john.fastabend@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <maciej.fijalkowski@intel.com>
References: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
 <588e062e-f1aa-6bc5-8011-380be7bf1176@fb.com>
 <60c0e99991232_986212085a@john-XPS-13-9370.notmuch>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <406c07f4-5137-930d-935b-14e493d2651b@fb.com>
Date:   Wed, 9 Jun 2021 17:13:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <60c0e99991232_986212085a@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:92ff]
X-ClientProxiedBy: BYAPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:a03:54::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11dd] (2620:10d:c090:400::5:92ff) by BYAPR02CA0051.namprd02.prod.outlook.com (2603:10b6:a03:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 00:13:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67687be3-4220-4522-a449-08d92ba487cd
X-MS-TrafficTypeDiagnostic: SA1PR15MB4919:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB491947975C305822EED025A7D3359@SA1PR15MB4919.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hGa45nowUZyHeIQPV3KM3SzevnzCU91fQ4+yF+jQlikxL1NAJCe2TseyZ3/jfGj822TDsr1yCvDLdiX+LZ5acHSWYfFQS0welkDjWapA1v6LU92y7p2Ky7C0zmme/mRRE6JPdj6IitLAzQtnSjc/e70o6O0avY4AQFAL4sXIqfqcNX8kDLpkv90xXt/MUWzK5eXdwLsuvdXbT/5jkK+g3shz8fS6Beme9ffPTdX4UG7l7sK4nQwM+w3J6U8O35ciufqXtAdGVWibjqRLuKXY0bVDt+rHcWlnUjbNAaak4l21y6CeS0qcz+J1Vt2nr/JoyHL/F/FgednkPxszpaLc92UFbAZ1qaK5Sn4rRg8x3DHbPotAcxrA84FM95Wh8HM0KsM4VuMTYQCk1G13fE51wXTVBUCxeunhFpTJgW5VjsdslQr73EiX8Hwpzqxsrz+sM+U3OE/nz24XwV5bHJ6YaAwqynQociiEf4BTFgOCvtWOnTQpu+ImTLEFJ2SKZbpT0sFc6l5cxcTIiGKU0zCjKKAvUiKOeWjbMNdBBTQhvjg634n7bMBdFQkhDRyA6SB5AKxZTOeu7lp7VaiDvprE7KtL6tzUoDvcisykHIEKl/yLm2g1EIRBFxYFjznZSzXG6BObqM63Z318wExHxN8YZcPee7nW7Ss0dsDqlx/le8+EZj3qKnzurMp2A+sfR8WC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(2616005)(4326008)(6636002)(316002)(8676002)(6486002)(83380400001)(186003)(52116002)(53546011)(38100700002)(478600001)(8936002)(16526019)(86362001)(66946007)(66476007)(66556008)(36756003)(31696002)(5660300002)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWZkV0NZNUJkaEFBMWVqRVE5MGs5a0lVTmhtWTZwYVBHY2x4OEJQSXR3R1JT?=
 =?utf-8?B?SEZ2MS9mM1hGaURlVS9PYm0rT0ExTXhubEEwV1JCTzAyTUZoV1R4NFNjaDJ0?=
 =?utf-8?B?cmhtMmloTFRRMUdlbTMwK0Q4WlBXQkJBODlsMzRIY3JVQy83dm4wWUNGdmVl?=
 =?utf-8?B?WCt2QUxPLzJqNVEzQTl5RGpVVFB6cEpCYXhaWHp4MkdjVWEwZjBWYW9Ed1pF?=
 =?utf-8?B?NWYzSlBucnQ2WDZJQ3lzZTBwcHZkU2ZCdituSkx5ekxEbVBEMmt6U1hlNHNL?=
 =?utf-8?B?c3RHMWxxUmdZTWpmSnlEVStSOHduN1M2SURoMGZtejZjQTRkclVZenpIWnZ5?=
 =?utf-8?B?Yzc3bnBKLzZncDA2MjVoSGVUUDdnY29Cc3RTVCtaVWUrTFZHYnkrbUMvY0x2?=
 =?utf-8?B?U3cxUHhEUHQreWdaLzR0MjBUeXZnMzNqMCs5Qi9oM1RMc04rUW5qOUl4Ulcz?=
 =?utf-8?B?OW9zQS9pWmpwajBXNGdvbVRmb2lWTmtGdUFrTFFpemNUZEdXb3NmL0lkYmJO?=
 =?utf-8?B?OWxYMUpJU0ExQWMvemsxeG5CcTdFRGJFeW9kVG1ROVdpNnZqYjhwVFlWMjN4?=
 =?utf-8?B?MUp0MWNBVCtmMVQrYnNvR0JxNHFVWVp2bE5XZ2k3UnJjQVdRUDk2ckYzenIz?=
 =?utf-8?B?WGIrclNkQU5zTUtZODI0TGdrUm8zSkRBZGNXOHRoeVczTDgreCt2Umpwanow?=
 =?utf-8?B?am1KTmRHVGNjYzZ3UTJKdE1tZmh0RlpOUkVSSVhEVHkxYXBqSXhqS3hTazNm?=
 =?utf-8?B?RlhnU2Y2WjBJZVRvTFlBV1RDd0UzZ29JS0tGRnBZaEhTVnMyNk9KMEw4M3RY?=
 =?utf-8?B?dGNWNzJ1SlIvNS9HTFQreUpsblZjQk9sS0JUQmdiV09MejBPMnJzMzB2Kzcr?=
 =?utf-8?B?d3M0R3dqaDBYOW5qUFBDSUJkOVQ4ZlFqNEEvV0txQkMxSkJ2c1RTRzBoTS9X?=
 =?utf-8?B?dkcrWVBVM3dwZGxQNmlrTi94WjVnbUljMnRzd2d3K1JNQkJVWk1lVGtRSi9K?=
 =?utf-8?B?aXlTTTB5dml0czNhMU5BR2lYbXpIRG1ub2RvcFFjMnNJd3pxVktmYTd4aGZG?=
 =?utf-8?B?NFZLK3F2UmEzWXNBeEExWUphUUcyaVk3QVB6Rzk1WE1aWnZ2aVZtTC9zR0R5?=
 =?utf-8?B?Q1R3VWpYd2NrdVd5eDB3YldsNnpEenBjUm1IbUlYcnZZc3VBQ2puY3dwZjZN?=
 =?utf-8?B?S0VhcWMyRzl1WUpIckFpaXFPMjBtdWI5dHU1T00vWmtwR0hvTkZNZWdJUEdm?=
 =?utf-8?B?NWxZdkpvcGRwRVVSSjl2VkJucFlHeHVwcHBhSmhBR3lQb2VlejNGNys3VHZD?=
 =?utf-8?B?Yy9RanB3Y2VKUDRLek9TaWRySm9aemZSKzVjdUtPNGMrN01GQUtMRjhzWHZi?=
 =?utf-8?B?VnVNUWgyVmdtOXpySkNFMnpRS3RhWG5EbWxPZlI4SmJTU3ltMkd2dTQ2bC9w?=
 =?utf-8?B?YUN2QnRNOTNNc2xCR0Z1ZGhXYUxFdjJpaVRoOWxESFl0ZVYyWUozMEtydlh2?=
 =?utf-8?B?RXRzak5ndEVvTHVsckZHeU14bUtBd29aNzdJOWxscDRtS3VnNTJWU2NsOG5G?=
 =?utf-8?B?YWsyOFFWb1ZYMUliQzVWTk9ZOXdUZ1ZhT0lCMklmWXNwamhwdUMwaGJzUVJ6?=
 =?utf-8?B?Umg0cDJKYThxNnFrYzE1ZzUrTThHNHZqQXJIMDV5V0tCZ0JTZHpvczFDTHZ6?=
 =?utf-8?B?TWg1M2c1WDdrVkxjcStieUdSUituZmFlL2hLRVlhNndpWWFpVjJYc1BQU21W?=
 =?utf-8?B?MzRpanhVREwxZTViUWF4UWxmU2hwMDBCNXBHV1NuTytDVXVuLzVERHpaN3ZT?=
 =?utf-8?Q?JW3ruCQFQ1zzeJMGS+WLpX+nJf6gYP/VcGt3c=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67687be3-4220-4522-a449-08d92ba487cd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 00:13:10.3707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: huj5a6SG14ZTb2UfQ2neKoYskbMhY6TB7bEcrtT97xQluwXwVhGPxRr/z8X5EQbw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4919
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: WlaklHOyiwRNK9Fsx4bPHeAwDHkQ4ZHw
X-Proofpoint-ORIG-GUID: WlaklHOyiwRNK9Fsx4bPHeAwDHkQ4ZHw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_07:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/21 9:17 AM, John Fastabend wrote:
> Yonghong Song wrote:
>>
>>
>> On 6/8/21 12:29 PM, John Fastabend wrote:
>>> We recently tried to use mixed programs that have both tail calls and
>>> subprograms, but it needs the attached fix. Also added a small test
>>> addition that will cause the failure without the fix.
>>>
>>> Thanks,
>>> John
>>>
>>> ---
>>>
>>> John Fastabend (2):
>>>         bpf: Fix null ptr deref with mixed tail calls and subprogs
>>>         bpf: selftest to verify mixing bpf2bpf calls and tailcalls with insn patch
>>>
>>>
>>>    .../selftests/bpf/progs/tailcall_bpf2bpf4.c     | 17 +++++++++++++++++
>>>    1 file changed, 17 insertions(+)
>>
>> Don't know what happens. Apparently, the first patch made changes
>> in kernel/bpf/verifier.c, but it didn't show up in the above.
> 
> Agh its how I applied the patches and cover-letter :/ I moved them between
> trees (bpf-next -> bpf) and lost the diff. I can resubmit if anyone
> cares.

You don't need to resubmit just because of this. This cover letter
may not be merged eventually.
