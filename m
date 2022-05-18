Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED09052C235
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 20:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbiERSXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 14:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbiERSXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 14:23:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0863C14CDCF;
        Wed, 18 May 2022 11:23:44 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IHDVGu021734;
        Wed, 18 May 2022 11:23:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GJSuUxtPceadpW9HwO23psWefZ6xHsG5CmpPSPn5cQA=;
 b=FU+ANXOcivRQp/bj/ZpO5g4MdMte6j3SELTQJo9S6vk9+pTPeKAKtzFddC5Kj1vsXb86
 if5pUKLUUWFMQRku2R/6Hii5Y5OGPZK4FLqAE2eh1WdxPcWmRfeTD8Szv0nSdHwbgvPb
 PRhmrp1D5Km2hNRcenV/AeIbia2f0gG+Qio= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4d82208p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 11:23:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V83+YF3lSGLqP9KGRCQNZCVrhDgj6MdMChhPa9gaK+kzOnVJBlDhGvroT6okgBfuBaCEAN8OqHcuXqLjacbhctTxueiXiXX6xNgiEpzb7jZiWRfNXuwwarz3mk6hWKZ4mucw1dRB48oeA+Eru/E3gKVqg6G45GTv13/6PJGHzT9suM+Es6eJjZWjpF367o8Gc+YzaCmaatVa4CYqWl4196sguzkkKtb7wa2wvkCeUHz0EC3Jb1FjtV2kgIWexgIIM5TWBuzE5WUHNgtCJ2TOao5gSxlwlo/zyffmep+bXGRLhvIr5GzeruhXcq4bBsE2d0tScClgKjpWkikbASmZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJSuUxtPceadpW9HwO23psWefZ6xHsG5CmpPSPn5cQA=;
 b=eBSpymi1YvLD4JhQGXKM58jKGnSlW2JucsyIvWTpHrAVF95xamOb06enCM9nz7wmftDAsTsVGsW4VjHlCEWuHZnBAmRxtEKHGpdv7xsYoj/k3HRECtSsEbawiVKfle3szUGg6UjDRW03Gq4GDoNBgvcEigmpvnCCO9YQJtV82GXX+AHKTgGES2JN5sx2g5l9z8fW+zq1SVWJSoHMMoS0fFNMfAKzEPqzZ5P/CD+jLeMTlkRCTOXtChSWmTQfH8t9g/UocY+7zgwQAEQrrjiSeWUlFPI/VWSNwKFddIgZ28cZoVNIg3uEZm32eye7oKBFzwtr2wVB4bAUcZX1/6xm2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MN2PR15MB2653.namprd15.prod.outlook.com (2603:10b6:208:122::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 18:23:15 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 18:23:15 +0000
Message-ID: <05413ff9-3b4b-6100-be54-95c613072fa9@fb.com>
Date:   Wed, 18 May 2022 11:23:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v3 bpf-next 1/5] bpf: Add support for forcing kfunc args
 to be referenced
Content-Language: en-US
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com
References: <cover.1652870182.git.lorenzo@kernel.org>
 <7addba8ead6d590c9182020c03c7696ba5512036.1652870182.git.lorenzo@kernel.org>
 <8912c7c2-9396-f7d8-74e2-a2560fbaad56@fb.com>
 <20220518180613.su37c23ckgc5irmu@apollo.legion>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220518180613.su37c23ckgc5irmu@apollo.legion>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0099.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::14) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96cf8e13-af8e-4dd9-b3e1-08da38fb7932
X-MS-TrafficTypeDiagnostic: MN2PR15MB2653:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB2653D81A895144324ADE9E2AD3D19@MN2PR15MB2653.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /j1aHLeiI8IHj7KdGcsvI6NT3yqgfkNTqYcExQiHazrZQxN9KvvmLJCtGwS6W1OhLSWSg7mO8QXqfLau85dYSN63XZgrdDhkUba62QMDh4KF0bRXZYpqOGOxr3C8WuWoZy9gilLToDUOkELO5Pijjb3IpVQQHuCFPSQkUS2IWSdrAbD2dVv/JSvZfpv6x4fjAxkcdRQN/gAYS1djc1ms40pU8bmvavvqBaojymV9QH/8qvquDLXJ2ptv/v5PSd/sMiLAHJZRL3Jnat6VE5ScmZi0EYJppVSrXBqBPFDV4KFkzMMb+yAKNSRzkwibFTwcKBoe01K42D56PVyIG170pdSBb/AodqzM2ABPdRsjM/Ma+J7YX4ADVJeZm5DwIov/ROeraFvC2r8KgxEIhunJ660L4cLYxYcSwvTD/fz+96MBU0QXkpHuXL01UqNH5nIisbWvnXJ3XLbSy6zLF5cBOBv1ZMd74crObJc9ud0FeRncHooQCKkSHh7idMy86JNdhwUVZf0opI+0h0RQqb31y1HFmxE5nkSBgvx3pS5hVfh5PO7QskEaUBPNK9YYq4ztHg/uwGsKkXo6fUhPfjvl3sf6dIRQJe+VbR0I70kmfwyMm4eF9JcSM12DF+pGShANWlyjHKYEikBsrBhblcV3ivVxNjuobIT7dr/dasH1I4+LVsrYwSMfaS/cXh3PPXOOBkmb1naMBMG6EjgsubbFPX6obc/n8Pn0PDHpDeaRQ4twI5zwd5jc5ZoKFLy+OSpu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(8676002)(4326008)(66556008)(66476007)(53546011)(6666004)(83380400001)(2616005)(316002)(86362001)(5660300002)(7416002)(8936002)(6486002)(2906002)(6506007)(52116002)(36756003)(31686004)(186003)(6512007)(38100700002)(31696002)(508600001)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NE9tTURtdGxMei9CNG0zMUFpRFBmcDFFMzVVMXVTRjVJSlJsK3JKRnhNWE5B?=
 =?utf-8?B?c2Z6ejJObGtiWmQzUm1QOFFqLzRnNXN2cmY1bEtRdFlaZEpQb0VDOU5DdHNO?=
 =?utf-8?B?cmJaT0J5eHY3Z3dSVVE5TCsyT0s5Vm00TGxEMVdqaFN1YVNuYjB5TG4xM0N4?=
 =?utf-8?B?aG00NHB0M0FoQXl3S3lMaEVOVlV5eFBTL1BFY0Q3SzdoczVzTlJER0s4dFE4?=
 =?utf-8?B?QmN3cERJN0wzRENwVFk0ZzgxQWp4cklXbEtGaTFWV1A2SFJiWFhTakh1OVpw?=
 =?utf-8?B?ZFJ2WE1JQks5YXZNU3FDakpBK3YwcEhVQmhsbmpMVm91cFRmLzFNYmFuSDJp?=
 =?utf-8?B?NU1yN2Y2QUlOZGhJMW5YL0lFK2tORTNkWm5nZnkvNHFncDJVZW4va2MvUlMr?=
 =?utf-8?B?Uyt2UEtXcDVGWUN6VFBtQnllczFNcDhOQXQyeEtidUFwaXF1VzlVSERYczMz?=
 =?utf-8?B?c2lxSGNPMCt5NDliMlhNL3ZZLzJLTjhuQWIvR2xPTXRYQlRLaXZHOUtrUE1Q?=
 =?utf-8?B?MWQ1MEVlNUFTYkFKdzNpQVdIR3NPbEtna2dNby9OMllHV2VtNVVGc2NqUmJp?=
 =?utf-8?B?LzYxUTI0aGJvLytITXhGakF4Z3cycEorT1ZXbDFYZGIxSkFmTVA2TTV6TlFt?=
 =?utf-8?B?cEg2OHBGY0FId0xiVjZWMTVqK0E4NTArU2lNdVFzUG1MdVA5VFlDd25DS0xZ?=
 =?utf-8?B?TnVxQTlGaVZ2SnBmdlRVSnpyclFLeS9xTE9wSGdhS0plRVhTSXhyZk4rdU0x?=
 =?utf-8?B?ZXNyNlhkQkc5Q2hzamdqR2p6SDhNOUxVKy9zM2dWUE13UWdXSGxxanFlb1Uw?=
 =?utf-8?B?YnJvMHh3a05HdlQ4T3VoVjZyZjVmR0ZZeW1YMjdTTG43a2hIbzAzaE9mNit2?=
 =?utf-8?B?aEZ6cFQrUzZBN0g3VUZSWExaSmgwbW9hT0lTcW05V1JGVVZUOUFUSW41emdl?=
 =?utf-8?B?NUdaTHkwSlZiMzVsRk1DS21nRlpsc25Sa2ZVeElLQkhrclBqcndzbDlxZVdW?=
 =?utf-8?B?V1c5cHlHQWR1bHQ4VG1mY1M1K2ZHN2JOcnM5ZmxnUVdGL3E3ZS81c2FSZkFv?=
 =?utf-8?B?QTF6R0JWR241UWkrL0NLUi91azhOQWJNZi81OFQzSzVSakx3NGpxcnVRdGk1?=
 =?utf-8?B?THZxUFRvK2FucEgzQTU2OW9NMnBNOXVMYk1kbzBOcWdpWkZqWWYrbHVlR1Z2?=
 =?utf-8?B?NkJvejFYWnQwZm0wUExaSjMraVN2Yk43K2xjS1V4SEthUFpKMjJ4VmpydFpV?=
 =?utf-8?B?eEZuUjhySW5Yd2ZyUW1oQ3FVZUJoaDNZRmZYR2t3cnJXekpVRTcwdjJScE5H?=
 =?utf-8?B?NENoV1Zpalg1dXM5VTNMTGdFbS9ZVjRJZjNhWDFRZWlkMWFnMUtPWTB1RTg2?=
 =?utf-8?B?bnJkbjJvSnNyUEtnU21UU1NySGlmYmFCcWRnV1dKSFZhM1RwelorMHRseE9v?=
 =?utf-8?B?V3RQcWFydkJVdThsRkhxcVV5NmNTSlVndWhWZEZ1RU9rMGg5ZllqRTcvZEwy?=
 =?utf-8?B?RDB5bWVRYTJONWwrR3ZVMkxtWnFWZmxNaXFEUWZPZTFFK3ptZlNLekpnVWlo?=
 =?utf-8?B?SzhjbTNPRWdmcWRPOWN6UGwzNFE4ZW0xempFZ2NpbWI5dGFvWmxmSUxZbUZ0?=
 =?utf-8?B?NU9OV05ZTFVJL3U1Z0pOeHVRdkwzeCsrUzlWUGFsTnk2TDRXcVlCRWcyOElV?=
 =?utf-8?B?VmlYTkN6bnpvdUxkT0FiOTAwNDdKajBOMElFWFkvU1ZYYThtQXFDb2lFZzNW?=
 =?utf-8?B?VnphMk50L2F4R29uVVhIYWN5L2IyRzYrOVRwajZ0bWxvTzJBUkZoK3dMeDFX?=
 =?utf-8?B?UjVlN0x3SDg3MjdlY2JkYkN5aHJMdEM1eCtuUytkNXZJaGtnYnJLNkpLMFpC?=
 =?utf-8?B?a0pZdExTZkIxT3hrYS9Ld1h0OVVhQW92RWtKakVKSTNCWFdUZ3VQRGRrRml3?=
 =?utf-8?B?dGl3Mk5SNkc4Vng2SHZSVkJzMTlVSUg1b1ZxdEJxcG9PbkU0czVJb2cvelk0?=
 =?utf-8?B?QUhHT2V1K3FxRmZjTTNMaVhIUU9lWmVHQWtTVkJlTkxoWVBCRFI2ZE5lZmpF?=
 =?utf-8?B?U3AycTVWWW1RZWk2VzhNTG5WSmh5Z0VZUWVqZGYwUHJLTVFHa1hLSTRvbWtW?=
 =?utf-8?B?d3VyZDUyRkRScmFFVHZ3L2I4S0pKdHZrRGdQRnpRdkRoaDljRFArczY3VTM1?=
 =?utf-8?B?SGtSYkVpaDhaTGpvSlJNcVNxRG9ncUVVS2h5dFE5UjBEVUFRQ3YweWN5TWJt?=
 =?utf-8?B?UzdWU1lJSmRsNnRlSmxTNVo0NFYvd1haRkF5RzFIYVhEZGJSSmZyWkZoYitE?=
 =?utf-8?B?UkwvQ1V0SXJlWTFxUXZjSHBlSVFtOGU0RXJ6b0xXQzhsV3ZaazF6TUFxR0Jh?=
 =?utf-8?Q?FTCfiLhGhUAGgXXs=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96cf8e13-af8e-4dd9-b3e1-08da38fb7932
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 18:23:14.9065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oShj1j8aSCGpDAcNtL+/ns+gqlr0E0xESBXXWiT6OYSuNUU5WslO6//R6Nt1/1xe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2653
X-Proofpoint-GUID: Qr9SVfLbBIhap7UXplJLTAQ0UbWTU60U
X-Proofpoint-ORIG-GUID: Qr9SVfLbBIhap7UXplJLTAQ0UbWTU60U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/22 11:06 AM, Kumar Kartikeya Dwivedi wrote:
> On Wed, May 18, 2022 at 11:28:12PM IST, Yonghong Song wrote:
>>
>>
>> On 5/18/22 3:43 AM, Lorenzo Bianconi wrote:
>>> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>>>
>>> Similar to how we detect mem, size pairs in kfunc, teach verifier to
>>> treat __ref suffix on argument name to imply that it must be a
>>> referenced pointer when passed to kfunc. This is required to ensure that
>>> kfunc that operate on some object only work on acquired pointers and not
>>> normal PTR_TO_BTF_ID with same type which can be obtained by pointer
>>> walking. Release functions need not specify such suffix on release
>>> arguments as they are already expected to receive one referenced
>>> argument.
>>>
>>> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> ---
>>>    kernel/bpf/btf.c   | 40 ++++++++++++++++++++++++++++++----------
>>>    net/bpf/test_run.c |  5 +++++
>>>    2 files changed, 35 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>>> index 2f0b0440131c..83a354732d96 100644
>>> --- a/kernel/bpf/btf.c
>>> +++ b/kernel/bpf/btf.c
>>> @@ -6021,18 +6021,13 @@ static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
>>>    	return true;
>>>    }
>>> -static bool is_kfunc_arg_mem_size(const struct btf *btf,
>>> -				  const struct btf_param *arg,
>>> -				  const struct bpf_reg_state *reg)
>>> +static bool btf_param_match_suffix(const struct btf *btf,
>>> +				   const struct btf_param *arg,
>>> +				   const char *suffix)
>>>    {
>>> -	int len, sfx_len = sizeof("__sz") - 1;
>>> -	const struct btf_type *t;
>>> +	int len, sfx_len = strlen(suffix);
>>>    	const char *param_name;
>>> -	t = btf_type_skip_modifiers(btf, arg->type, NULL);
>>> -	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
>>> -		return false;
>>> -
>>>    	/* In the future, this can be ported to use BTF tagging */
>>>    	param_name = btf_name_by_offset(btf, arg->name_off);
>>>    	if (str_is_empty(param_name))
>>> @@ -6041,12 +6036,31 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
>>>    	if (len < sfx_len)
>>>    		return false;
>>>    	param_name += len - sfx_len;
>>> -	if (strncmp(param_name, "__sz", sfx_len))
>>> +	if (strncmp(param_name, suffix, sfx_len))
>>>    		return false;
>>>    	return true;
>>>    }
>>> +static bool is_kfunc_arg_ref(const struct btf *btf,
>>> +			     const struct btf_param *arg)
>>> +{
>>> +	return btf_param_match_suffix(btf, arg, "__ref");
>>
>> Do we also need to do btf_type_skip_modifiers and to ensure
>> the type after skipping modifiers are a pointer type?
>> The current implementation should work for
>> bpf_kfunc_call_test_ref(), but with additional checking
>> we may avoid some accidental mistakes.
>>
> 
> The point where this check happens, arg[i].type is already known to be a pointer
> type, after skipping modifiers.

Okay, maybe we can add a comment here like
	/* the arg has been verified as a pointer */
But anyway, this is minor.

Acked-by: Yonghong Song <yhs@fb.com>

> 
>>> +}
>>> +
>>> +static bool is_kfunc_arg_mem_size(const struct btf *btf,
>>> +				  const struct btf_param *arg,
>>> +				  const struct bpf_reg_state *reg)
>>> +{
>>> +	const struct btf_type *t;
>>> +
>>> +	t = btf_type_skip_modifiers(btf, arg->type, NULL);
>>> +	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
>>> +		return false;
>>> +
>>> +	return btf_param_match_suffix(btf, arg, "__sz");
>>> +}
>>> +
>>>    static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>>>    				    const struct btf *btf, u32 func_id,
>>>    				    struct bpf_reg_state *regs,
>>> @@ -6115,6 +6129,12 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>>>    			return -EINVAL;
>>>    		}
>>> +		/* Check if argument must be a referenced pointer */
>>> +		if (is_kfunc && is_kfunc_arg_ref(btf, args + i) && !reg->ref_obj_id) {
>>> +			bpf_log(log, "R%d must be referenced\n", regno);
>>> +			return -EINVAL;
>>> +		}
>>> +
>>>    		ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
>>>    		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
>>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>>> index 4d08cca771c7..adbc7dd18511 100644
>>> --- a/net/bpf/test_run.c
>>> +++ b/net/bpf/test_run.c
>>> @@ -690,6 +690,10 @@ noinline void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
>>>    {
>>>    }
>>> +noinline void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p__ref)
>>> +{
>>> +}
>>> +
>>>    __diag_pop();
>> [...]
> 
> --
> Kartikeya
