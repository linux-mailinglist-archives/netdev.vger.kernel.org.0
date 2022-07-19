Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C60957A3EC
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 18:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237994AbiGSQFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 12:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiGSQFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 12:05:45 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC802494F;
        Tue, 19 Jul 2022 09:05:43 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JErlGt016697;
        Tue, 19 Jul 2022 09:05:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BdTlGYbzJIPMmpTiyFJ34X0S9J3G6PTD486dzSp8W18=;
 b=j6LprSNFqi1wf5SaU7Hd2c6F6jZNwvTqXyZ1WFgITCCqzXJ6e6wArC5Vs2G7Dg898tv8
 TPlyB5lzH3HYrH6LjIZWyqWh+NtktP8PTtAJfQqHlXMZ66ePqBEmE+5PaAtQvU7nQ6j5
 DYiuJb08jhIcLXSvYQXdrRjMAGYO/nmOy2c= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hdxsarjbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 09:05:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/3N9VzxK4C/r9Mvk35zluLrO1EMnN05vId79UINKdnp0Iov7KuIsfsAa0rQ4IAPhvsk9I5GRYwGCIPSpytJfB2FqeC4Oj6GhL4lOqJvz82Xo+0oGwCP9T5CYpZ6Ed5b8hs9bQqJcWtd7E0NomSMplq192cfQOHD7ZeBjZok2S3euOU8NaXN2MyzUt/N69aliAgbhM5ImZPUPYgHIo1FYeNfMyymdgT8a/D9VmC+X3PlBtGlkqEisLhWse02JFmGzHz1rcqgIdZszFx4e3TgQH/ZJXNJzMlw74ubwMwieUv0pVUpzTFVC1On4r8Q3Y98kzKNZfm1DTO5EqJX06XO8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BdTlGYbzJIPMmpTiyFJ34X0S9J3G6PTD486dzSp8W18=;
 b=eFS57SLdUKf2FswRrmAYEP7QFuSYMKyVusuvI/CQLY+Q7jEXpBFMH1GpEjOnCKNcO+kjkBjfFVzPQlATn66K5fvFRHgJ4lj7Nfuhehx9cOi94jhwoUxM1WSEQhmFYnuMuTQee7TFPSpTDJNh+mLdRj+SYNv4Tdzh3td0l4iGxG+tfVBIwYR+tG+ppZAzos3AqQr2+7Bq3A7PLQhnCXPxWAV4nZKwRIH3qdXJggOMOtOUOQEltu+T+ArpoiU32zeyZVu05nf138oxYuyChy5p1G6VT8d4p6ftHvkm+t9ag3Delt2pW5WjPaUxlYacEMLXBzYk13AiH8UZncBULDgpiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB3097.namprd15.prod.outlook.com (2603:10b6:5:13d::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 16:05:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 16:05:11 +0000
Message-ID: <d244394a-bea9-bced-fc9e-ffbc096631ed@fb.com>
Date:   Tue, 19 Jul 2022 09:05:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v6 05/23] bpf/verifier: allow kfunc to return an
 allocated mem
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-6-benjamin.tissoires@redhat.com>
 <7fc49373-55df-c7fd-4a73-c2cf8a62748d@fb.com>
 <CAO-hwJKwX2LW8wuFzQbWm-ttwqocNBc-evgpn2An-D-92osw0Q@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAO-hwJKwX2LW8wuFzQbWm-ttwqocNBc-evgpn2An-D-92osw0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:207:3c::35) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9445ba1-9eaf-4410-5aed-08da69a0758f
X-MS-TrafficTypeDiagnostic: DM6PR15MB3097:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRo2wa1CswZ1edeZvjb/WmjPCXkrjdXQkWaC4+X8O8uLY6iKPVeOxfXB+0n3y0D9lxlUPVNQwVRJxOcmF6LyT4KS4ztj4zZ0ELK02JVNwXeGPe4/ZUkI099AStMc9zjNNoyBzs4ROAN2Y5w8pxVs21My7PFXck0gPfBX8x5xJqc2CcBVtyVX2bjuk7YaCux1yRWSCZA87xTotUzHC4eAOUBRWVEFpbE8I/VwHJXjw//9qBg+fwtL46q8EtosWt7oEAXL6aBF8bA+tujvN5s0ws97w278e6KQkEU+nPaioiGvM3c+aTRhWChGGB1HIdmnOTCsgv3yEzAkoCAiDkaPk5IGVPAP0XGRjJQfUYFTKOI5mrPAYIl9X1fQzV8gIJ9gKxUgYzmTjSzi8Mt+jT9Jyy6dqoWmG6YhbvK1R9qvTTB2D5vCDK+BtaahBlXdXZpRzOvviJE7IU5xNzpRJsfAHImupT0A4cF5q86n2hzug9D2ZuQpbYT5KSiLEsH/LcNhRBacGCRVdZwbOWxSTPJZCxrnzLLo6tTA0trmPMGY0L8gCkrl9JmxlkCnu5WJwwm/hQ5C6qbX+noGx7y2WTdu0fkiYEW1IKjwcAuIK11wOPESjmP81M3bD2oDAhbzehNm1eiHLMnkOuiQw2v0ysWjgSDVmcilxzKcvKHIm8qxYB8DgMYH4Kgy6Q25riC2xcNEcr/i23kvSy+j/XL1ZUSaRJB0ruru2GArWUFcH6kXfUCSx2uqkOwC5Qa0a4Jr64RLEK5ZuMNUuPeL21KtFZo0D0a3KvWHaZES/5EB0yFgoczgquo7JPhWn92W/+Kc0aAXGvFqYvKztX1qr9n2nLPtJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(31686004)(186003)(6916009)(8676002)(54906003)(316002)(66556008)(66476007)(38100700002)(36756003)(66946007)(31696002)(83380400001)(8936002)(86362001)(2616005)(5660300002)(6486002)(53546011)(6506007)(2906002)(6666004)(4326008)(6512007)(7416002)(478600001)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGYvcDJlSkovM3VIS0MwQmEyM0dHM0wxWnUwekZIQVh4M3lvcittRDRQRThF?=
 =?utf-8?B?ZmJBeG1iWWJPWkN2a0JJdE03Umg2cFBhWEhocEp1Zy81TjhsTFdrN1VCQ0xn?=
 =?utf-8?B?VkhRTTZXTVltQmJ4YmdiVHZrZGhmZ2w1RG1DNlVlMnRnbjZKdU9LM1N2NG8w?=
 =?utf-8?B?MVBDQU9jOTBUSDNqaW1udXNLZXhpWGNyZXNRYVVsakpRaWRYdmhnMW1MTGo5?=
 =?utf-8?B?TWdxZTArcXpzVFBZT1F4d2RiblYzbTAwY24wd3JtQmpBdG5YWGdhNU9ZL0xh?=
 =?utf-8?B?U0pBZ25HYTBsQXNneDVUdGE1aWMwUGtyMjNHWmZpWW1NL0owdktVQWlmUmhS?=
 =?utf-8?B?S0x0MUtDanV5WDFWdnNqM3A4emxzd3kzYjhyUE13OEh1WERPeDdNemlaTWht?=
 =?utf-8?B?UnArbXdiUzZhOWtsMVRSMm85RGYvbnRMYkI1MjN3dU9pc3p1Uzh4NEJ4ayt3?=
 =?utf-8?B?WUVLTlhReHFvdk1ZNG1YSEZIK1Yrd3NJaHIxOFBLTkZKTTZrbXhjZmJWVWxH?=
 =?utf-8?B?SXFjdzhPK2Y5ZG9HOXRwRjJIVEJzVlI3SlZteU4wMFprTmVIRUJRKzRIYndP?=
 =?utf-8?B?T20yZDFpSWRmMkk2TGJLTXdCRGRXZkFjZW00MUNjUGJOQ2cyUXlnZGkzemdW?=
 =?utf-8?B?bDZKWHpsQXdiMDZEcXN6TlJGV0xpNkNDODd5OUJTc2E4T2FkT3pSVktaVHlJ?=
 =?utf-8?B?K3NzeHhyNnoxTWN1TUdHSGFXUHN0QVkxNXlQbGs0bWNjekZGVnNhdzRKYytl?=
 =?utf-8?B?Y3RiM1VsaXVScjhQSTBFSEdOamZwNUs1ZlNIWU9wYkVocUtPemdrVnhVd2Iz?=
 =?utf-8?B?K21ZRmhCdDhoUjlMWk1RWlVubStVeWhFMGhQZ0s5ZVk5L3JyRC93a2JIMkdH?=
 =?utf-8?B?YWE1NDdEZHFqL3VIVklPWm9RVHd1NXYwcm5rSHlDcjJPRFlGMms2QXl6U0RP?=
 =?utf-8?B?aEdHdi9KRXo2U0VSNFpTYnVnYytaMndUaWpxblVZMjRUdVMzYjdmZkFITU5W?=
 =?utf-8?B?eXRFVEN6ajZ6NmR2V2NRMkJxV0dMVEpndHlwbll3RGJXZ1ZMR01FS0NERFE4?=
 =?utf-8?B?SGZiWGdOckVta2dReXNpTEprODYrY3NlcndJR3FFa0N2T3lTNWhXdEdWdWxn?=
 =?utf-8?B?SHpINUFCTkpUZStJd2pjMmZ2YkJ3alhDQTZwTVI2eTNjdk1zNDN2UWZtK1Ix?=
 =?utf-8?B?WG1oeEZKWThUTnR3a21pUjhqclBqcEcwcUs5cGZySUJvRHpSSWVUR2l4U1BZ?=
 =?utf-8?B?d1R5a3ROMnZScmRadEd1dG04WTcrblB0Yk9kNWJRNmZPSlVNNmtmdTYyN2R2?=
 =?utf-8?B?M0VwTkw2QS9TVFJuWkJ1ZW1LUnR1Z1RQYWtNMGtlR09jemc5QVRNR1NHOG9W?=
 =?utf-8?B?ZnpmVWJYVTJoZmVtMGhKUmUzMVk4UmdYNnFteXBRdm5WYUNuRkFRMERybUxD?=
 =?utf-8?B?dXlKL1RETCszMDJCZk1wTlh2emNmbE53aGVOekZrZ2NJazN6bDdDT1VpUDhJ?=
 =?utf-8?B?R2VCUDZYVDVlZnFlV01heDZNeGIwMnB2U2U2MkFDUkVjRncvYWdpMCtyYkV3?=
 =?utf-8?B?ZnpYR2NOU09sM3pFTjloRTRacDh3dmxtS0JVSkVlNUZWaDB1aFgwdEhHUWhl?=
 =?utf-8?B?NFJKZnM5cUZTQVM4ZHBwNnZHUjhxS3ZLQ3NLTkt4bDF2UzVZc2dlWlo0MWtt?=
 =?utf-8?B?NTBadGxpRHI4K0cveG43Kzl3bW1GUDZQSG1HVTN3blpVUytuTFI5QS8xYkxB?=
 =?utf-8?B?cFJjY2xUbVh5ejhJaWw2SVlrcVdQaFJlOVdaVVBoYW5TcG5uSTFQV1puUE9W?=
 =?utf-8?B?b2Rhc1JxclE1aVRNR1RydFNhRnNvbGpLaGZkejF1aGNPZEk0ZEZWK0dYdCtl?=
 =?utf-8?B?eVFhT0ZQQjVhbWVXRjlvZWxwZmpvMFJkRld5Y1FyNnFEb0hhN1pYZ09iZ1ZG?=
 =?utf-8?B?b2FSMndDSDM1em44NVdubWhwQnFKKzNCVkZnUWxnemxnTHVvR2RNZFhPcWlP?=
 =?utf-8?B?TTdWV21ad1VocDRKR1pSMzFCcTFpZlgxM1hCNnNKSklBNGE5em4rbHVNSXE5?=
 =?utf-8?B?eFMzZjBSM3h3ZDBJUUlPYmhWY0paMW81alk0Z0pIcGZaVTk5N0htYWIrVUNF?=
 =?utf-8?B?NTdLZTZxS0V5S2k2UjRqUkR2V3FoU1VSaWJhaW9HVDZEZzVkcVpoSndjZ3Rh?=
 =?utf-8?B?YWc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9445ba1-9eaf-4410-5aed-08da69a0758f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 16:05:11.5921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7MyZDxdUXiXrg6r8vpqlNBxekLqsvd3Dbn6URv8e4+FKH6Yk7j7SxvHc/++LcrDp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3097
X-Proofpoint-GUID: gi9qHIe46GZMPY6R9GNY5oQ_ho-foFVl
X-Proofpoint-ORIG-GUID: gi9qHIe46GZMPY6R9GNY5oQ_ho-foFVl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_04,2022-07-19_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/22 7:36 AM, Benjamin Tissoires wrote:
> On Sat, Jul 16, 2022 at 6:29 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 7/12/22 7:58 AM, Benjamin Tissoires wrote:
>>> When a kfunc is not returning a pointer to a struct but to a plain type,
>>> we can consider it is a valid allocated memory assuming that:
>>> - one of the arguments is either called rdonly_buf_size or
>>>     rdwr_buf_size
>>> - and this argument is a const from the caller point of view
>>>
>>> We can then use this parameter as the size of the allocated memory.
>>>
>>> The memory is either read-only or read-write based on the name
>>> of the size parameter.
>>
>> If I understand correctly, this permits a kfunc like
>>      int *kfunc(..., int rdonly_buf_size);
>>      ...
>>      int *p = kfunc(..., 20);
>> so the 'p' points to a memory buffer with size 20.
> 
> Yes, exactly.
> 
>>
>> This looks like a strange interface although probably there
>> is a valid reason for this as I didn't participated in
>> earlier discussions.
> 
> Well, the point is I need to be able to access a memory region that
> was allocated dynamically. For drivers, the incoming data can not
> usually be bound to a static value, and so we can not have the data
> statically defined in the matching struct.
> So this allows defining a kfunc to return any memory properly
> allocated and owned by the device.

Okay, thanks for explanation.

> 
>>
>>>
>>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>>>
>>> ---
>>>
>>> changes in v6:
>>> - code review from Kartikeya:
>>>     - remove comment change that had no reasons to be
>>>     - remove handling of PTR_TO_MEM with kfunc releases
>>>     - introduce struct bpf_kfunc_arg_meta
>>>     - do rdonly/rdwr_buf_size check in btf_check_kfunc_arg_match
>>>     - reverted most of the changes in verifier.c
>>>     - make sure kfunc acquire is using a struct pointer, not just a plain
>>>       pointer
>>>     - also forward ref_obj_id to PTR_TO_MEM in kfunc to not use after free
>>>       the allocated memory
>>>
>>> changes in v5:
>>> - updated PTR_TO_MEM comment in btf.c to match upstream
>>> - make it read-only or read-write based on the name of size
>>>
>>> new in v4
>>> ---
>>>    include/linux/bpf.h   | 10 ++++++-
>>>    include/linux/btf.h   | 12 ++++++++
>>>    kernel/bpf/btf.c      | 67 ++++++++++++++++++++++++++++++++++++++++---
>>>    kernel/bpf/verifier.c | 49 +++++++++++++++++++++++--------
>>>    4 files changed, 121 insertions(+), 17 deletions(-)
>>>
[...]
