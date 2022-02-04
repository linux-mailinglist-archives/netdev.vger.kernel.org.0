Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383324A9EBC
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377419AbiBDSOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:14:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22596 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350695AbiBDSOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:14:40 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 214H6x8M018543;
        Fri, 4 Feb 2022 10:14:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KcfeN//q6Ekr1osIwWjntzjd66gkVSErX/Iyn5aQ48I=;
 b=rD/Ty4NQ4evHlj8pvwQk92vG2BiEwvnyQ1P/cDEaoj2uUz+RNXnj7i2903tuYvPuyP0E
 DH2Ku+Bhg8q/CuO4/0uStb6P++T6kD2H6JQWjHzmr9VhdcYDTyEBSFGvYJlwVEuMFufO
 dtlgK+XBHhXc4tvOIeZtBGky5n6M3Bss9WQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e0u7vcfcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Feb 2022 10:14:22 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Feb 2022 10:14:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XvWJMRceY3a2vsmKQyls15BvyOPSm8yY2zZgxN2B2RNPLVRExsRRReDyRQ3R554cKnK5AVBBrArPrE4yOM0i5pXdyy80Pt6N0v4TleAcTg1x7F0Z1/XQJAhQgrXzLIPCYg+Afjw61FhWcVtQVBkPvCk7flKANvvB3xgk/IgnbNzoDzvzfgEJja4hs3G3gOpItrU3M3vfL3rNKMBQwkB0zvAkrnS5SScq3XaSakAOpCfTym/2judSLUyXnPx9cNOpXOb+fCT5hSDeqM1ghHNeQfr+j8ZNeQX3nMGDVdPwLwpxZ+OdPM04WOWGgMP8FP2JZeaV9IaRbhXW0aTsWM8tLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KcfeN//q6Ekr1osIwWjntzjd66gkVSErX/Iyn5aQ48I=;
 b=ghPohs9h4brC16ZVpmx7x2BdUrtyu75lraSIUt4MWykwXgovEeJwc11r+uTNQlSE3t1GB1kIOsar1frC9mLlQ/dH1YOgeKFejDaag7URdFgVU+xvu16wm3JgcgIXv23KhfftveOhzT4AZ3ClSlMtp9C5S6vF9uVyGWGPtjH14gWshm7SK9mhYFO5fWQvh7y4VF7WAyZ2rUY2qiFE58uaSgx0a9hcNACWK5XACloSnWz8/TVZwRhuMZd4ZN04EOoTwrF0q+HpqXerEq/i685ZHeOUIejNZ79G4bcQNqH3Kw0Rje8O2NIRF7Xj1aJT19DXYbd7cmuvL39EOocB9PJ6Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BLAPR15MB4067.namprd15.prod.outlook.com (2603:10b6:208:271::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Fri, 4 Feb
 2022 18:14:20 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0%6]) with mapi id 15.20.4951.014; Fri, 4 Feb 2022
 18:14:19 +0000
Message-ID: <15f829a2-8556-0545-7408-3fca66eb38b7@fb.com>
Date:   Fri, 4 Feb 2022 10:14:16 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next] selftest/bpf: check invalid length in
 test_xdp_update_frags
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC:     Lorenzo Bianconi <lorenzo@kernel.org>, <bpf@vger.kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <brouer@redhat.com>,
        <toke@redhat.com>, <andrii@kernel.org>, <netdev@vger.kernel.org>
References: <aff68ca785cae86cd6263355010ceaff24daee1f.1643982947.git.lorenzo@kernel.org>
 <c3858f6b-43d5-18ef-2fc8-b58c13c12b05@fb.com> <Yf1nxMWEWy4DSwgN@lore-desk>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <Yf1nxMWEWy4DSwgN@lore-desk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0281.namprd03.prod.outlook.com
 (2603:10b6:303:b5::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40bbf3d3-7529-47f7-0386-08d9e80a29a1
X-MS-TrafficTypeDiagnostic: BLAPR15MB4067:EE_
X-Microsoft-Antispam-PRVS: <BLAPR15MB4067B11BE070AA78C7A40B62D3299@BLAPR15MB4067.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gE24rWExDmHDYcLoDNPNAqDANc5fVW22hzn9iX1KJj4RPJpo8jWWp2Hnf99yOnd2HWVpqRd+njuPyqdXzcwImywPdFMAtF5YpEk87gpR6Rljf8eNs07f3IuaQTums02sAIpGpSs2dblr/Z33gk0aHcW7Id+IDA1pbWC++o5uQFbHfCvHqH+umIMp8Y+CDAChOUa8M7y/UtkRiscpQXzeFJOxND621RIDgJ36Pxwscvwc5RUODsYR2r0Yp2Puwp0JbyKKckMGn8o9niK4EJffhcHSy4DtRMTLB3/RhcA+WLoj/optPDPZzOiqj7wxRyfthzqZU0xufNwGfpaLrWQw+LkXB9yV7JieJmJKgjxu+v5piXvmnBxUbS9/4Wj+w9hhtHfl+MiyaIeDU7myhLTCguRIe1jFpc7SlIxK+m7U8h0vfvRyoHGwFNbfrr/n97zBfhvJ+IWrVnQFXiKaTJCG8/CxJDSZrFiX2R4CzFOG8bFH+Gh8NB/trOqbs2KyDliRYLIs1R8cfjruF6esLG+njMCgSFNwHk7XmoyXEXaKXCmhOtEEF8Sj7eTY4k7T8gicT5yYR6f2ld+wHIZxTjJ8DsdqlNSk9Ja5L5XieOJyuGNviwN8i+wCXrqfnIAZpbqZItrndIIFQnCE9a5jnGMGxVK9waIlKq0376Ztxf3l8vanPTTRRBZj0+8KR9RFVirzydLNjuCk7xfC5SZa1XiMhvuGBHOP9L6bnr/G8PI86fAYJSuxN14s/hdB7uEdxdVJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(186003)(6486002)(8936002)(4326008)(2906002)(31696002)(52116002)(2616005)(6506007)(31686004)(6666004)(6512007)(66946007)(8676002)(53546011)(316002)(6916009)(508600001)(36756003)(38100700002)(86362001)(5660300002)(83380400001)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aktjdlJKRE5rZHJibDJpakNQZE5rMGRhNVQ4UmpQVHdnZHJkQ0x0bXM2UW43?=
 =?utf-8?B?eUJDRmRFZTU1NFRTWkxPYytkRDYxR09McUM3SWVOM0gySjhaQitobzJIRmFD?=
 =?utf-8?B?UkU4ZzNlejgrS3EyaGNnMjQ3VWpQK1ZEQytQdTB3aGpDeXpQZkJ1UXNXM3VH?=
 =?utf-8?B?c1FwRkV4S0Y1NkdncVVYZm00NDRLallka1oraEtSS0FSd281K2JtNlBvZFYv?=
 =?utf-8?B?VDMyUzFtZDNiRm5NOVdmbUFON2VKbFVNa1MxVmJlaUtXajhxRmxqV0ZVNEZ2?=
 =?utf-8?B?enhIMnU1VktJZlFXWjcvN0RxMVZ6ek9WU0pnQ2duaXplS3JPc0laZkcrM0Ri?=
 =?utf-8?B?bW1tV0JyS05NRjNEUndFNCt1QWgrT2xMd3RFZlowZVczbStNU0I5b3J2dExC?=
 =?utf-8?B?RTJYMm1HVkNhS3YyRDJEZnl0K1ovZlVUWE9kSEp1UDBtK3plSmIvVG9qKzlp?=
 =?utf-8?B?NmJKOFdIaTNXdzBVUThSNDI0Sll6QWNVSjBBMFYxTVdldXVqM1NQcE1KemxD?=
 =?utf-8?B?WmdlWUZoR2NtU0F2QVVteGJQbE52aWVBbXIyNjdtVXFVMjFuRlFmcHU5WFNH?=
 =?utf-8?B?Ly8wUmpPN0piY1JRMUNxL05aVEljLzRWd014d2JKaHAwcjFoYVFFa3BPWTBC?=
 =?utf-8?B?aWxRYTVOL3hzejNTS29KQlh0MjVWMHVGcnl5d29OMHZqazQxK2p0SW5GQXh2?=
 =?utf-8?B?clhqYWYyUkNXRVkwWjIyQ3ZMWXJpMmJSVFN4QWpoRUpKVU9qR3BLZHJ0ek5r?=
 =?utf-8?B?SjBJZmFQdTFPU0k1Y2xDN2VOVjlhRUVGc1Vkd3hpcDdvZEoweEhLL3VJdW9T?=
 =?utf-8?B?OCthaEV0NlV4MStDV29NMXpVejBRUjZNQkJ1U0FkYWZNM1FZSEtjZnBvWjg4?=
 =?utf-8?B?b3pNZGJBSmMvNkVHY3dhMXV1cVdDd1VoeUVtSGpYbFU0cVV1MTdUQTRrQ3A1?=
 =?utf-8?B?cUMydDFkU09GUUd1WXBmV292Skp3bVVOY1F1N0RQZml5WEYrYVl3VnRWWGly?=
 =?utf-8?B?MDNwbzFsRVNYMWlqejU0ajBqOFlCSmRVTy9KSjc0a0JWcXZ2R0k3TCt4SWJL?=
 =?utf-8?B?a21TU0dySG5QTTJVYThoTHAvMk9VMUd0SE15akFocWV5dTdURkw1b2dUK1lJ?=
 =?utf-8?B?YmZrVVoxTzYzU2tWTTJ6M1padjJPd1ZFQWtKT2wxek1BT2ZlRTlZZEV4dVVG?=
 =?utf-8?B?dlIyZHI5dm42OUM4aFdVZVYwYUZZMk9ta2NwbTNhTUsvRUNoVUU0ZE45VFkx?=
 =?utf-8?B?TlBoU2NXdk1FWDVNeDNjdXdaMTRmZVQ3V3c4YU1zc3laMDNxVHFxWjBMTzRG?=
 =?utf-8?B?d3hsUzl1NVVmUmhEYTl3akN2bG9rRkpZOWE2Uk5vKzZYcHNOVEtuSXdhZXdl?=
 =?utf-8?B?QVErZjdSOEs4V0grTTFvWEZrUUF3Y1cyWFhuRHNhSHNTdElUanRLVEZNUzB4?=
 =?utf-8?B?blk0U0hNYnBNdU8ybmI0VjBYenRacEJqWnJ6bHdyZjY4WitYUVdHWVVva1NS?=
 =?utf-8?B?M3hBUlk4L25RdnJLR0RIc1ZOVk12cWRCMnlNMmlkYjhNaXhwWVM0U3hyS0pP?=
 =?utf-8?B?QWhZMm1YWmsxMUoxdmRqTkxCMmJDaHBUVU9Md00yR2ZNMGFxblBobmlrUWJT?=
 =?utf-8?B?RkdrVlFXTkJnTWsxTkRpRy8yVHVBOGNvNGVJem0ra2czQTRBeHpjSnp3eG5V?=
 =?utf-8?B?dG92VENnWG14L1kzbGNhc3gydnRsY0hiaEtoZ1prZjZJRXRmQnlaODlhQmlU?=
 =?utf-8?B?bVdBdmVOQUJTRnUwOHpic3ZjMGkyNUZENkQ1RzJLOEk3MGpod212Z3M0c1BE?=
 =?utf-8?B?bVM4ZHlSNEJlbnRKV2pUbnhMS1Q2TENYN1I0dEVHY3pwZkpxcFF5Rm5FOVAv?=
 =?utf-8?B?RkRlVi9EeVdRTmgvdzZlZHNZMzNsU1VocXh3V3d0M2NjeTRsNWdWbUxLemZx?=
 =?utf-8?B?MFZLKy9pdWFVcmduRjh2cHFOalpEREVRZXFEOHFvcWNnMXF5RVM3cVRIN216?=
 =?utf-8?B?U0hJektYOVJtOTV4YTU1dFQwWmcyTENQTG5DeDE4S3JEbEhQRnZsQ1Rpc1pL?=
 =?utf-8?B?bEdXQnNncHp0M1p4NFR5N2VFSW9wb082dzl1Q2hucktPbDE3SENPd0FZcmto?=
 =?utf-8?Q?YcSp/Nd/gPtXvEi5/4kpifbWo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 40bbf3d3-7529-47f7-0386-08d9e80a29a1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 18:14:19.6308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: prUFvVvwIVe9H4cUUG+axhhKUnd865bleDQICN1EqjdQKJdwqtl3rLFNvIQXLnxh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB4067
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: aq0OekLv7kwg6Uwiinxy44rre2dN5xnf
X-Proofpoint-ORIG-GUID: aq0OekLv7kwg6Uwiinxy44rre2dN5xnf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 bulkscore=0 phishscore=0 mlxlogscore=958 impostorscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202040100
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/22 9:52 AM, Lorenzo Bianconi wrote:
>>
>>
>> On 2/4/22 5:58 AM, Lorenzo Bianconi wrote:
>>> Update test_xdp_update_frags adding a test for a buffer size
>>> set to (MAX_SKB_FRAGS + 2) * PAGE_SIZE. The kernel is supposed
>>> to return -ENOMEM.
>>>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> ---
>>>    .../bpf/prog_tests/xdp_adjust_frags.c         | 37 ++++++++++++++++++-
>>>    1 file changed, 36 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
>>> index 134d0ac32f59..61d5b585eb15 100644
>>> --- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
>>> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
>>> @@ -5,11 +5,12 @@
>>>    void test_xdp_update_frags(void)
>>>    {
>>>    	const char *file = "./test_xdp_update_frags.o";
>>> +	int err, prog_fd, max_skb_frags, buf_size, num;
>>>    	struct bpf_program *prog;
>>>    	struct bpf_object *obj;
>>> -	int err, prog_fd;
>>>    	__u32 *offset;
>>>    	__u8 *buf;
>>> +	FILE *f;
>>>    	LIBBPF_OPTS(bpf_test_run_opts, topts);
>>>    	obj = bpf_object__open(file);
>>> @@ -99,6 +100,40 @@ void test_xdp_update_frags(void)
>>>    	ASSERT_EQ(buf[7621], 0xbb, "xdp_update_frag buf[7621]");
>>>    	free(buf);
>>> +
>>> +	/* test_xdp_update_frags: unsupported buffer size */
>>> +	f = fopen("/proc/sys/net/core/max_skb_frags", "r");
>>> +	if (!ASSERT_OK_PTR(f, "max_skb_frag file pointer"))
>>> +		goto out;
>>
>> In kernel, the nr_frags checking is against MAX_SKB_FRAGS,
>> but if /proc/sys/net/core/max_skb_flags is 2 or more less
>> than MAX_SKB_FRAGS, the test won't fail, right?
> 
> yes, you are right. Should we use the same definition used in
> include/linux/skbuff.h instead? Something like:
> 
> if (65536 / page_size + 1 < 16)
> 	max_skb_flags = 16;
> else
> 	max_skb_flags = 65536/page_size + 1;

The maximum packet size limit 64KB won't change anytime soon.
So the above should work. Some comments to explain why using
the above formula will be good.

> 
> Regards,
> Lorenzo
> 
>>
>>> +
>>> +	num = fscanf(f, "%d", &max_skb_frags);
>>> +	fclose(f);
>>> +
>>> +	if (!ASSERT_EQ(num, 1, "max_skb_frags read failed"))
>>> +		goto out;
>>> +
>>> +	/* xdp_buff linear area size is always set to 4096 in the
>>> +	 * bpf_prog_test_run_xdp routine.
>>> +	 */
>>> +	buf_size = 4096 + (max_skb_frags + 1) * sysconf(_SC_PAGE_SIZE);
>>> +	buf = malloc(buf_size);
>>> +	if (!ASSERT_OK_PTR(buf, "alloc buf"))
>>> +		goto out;
>>> +
>>> +	memset(buf, 0, buf_size);
>>> +	offset = (__u32 *)buf;
>>> +	*offset = 16;
>>> +	buf[*offset] = 0xaa;
>>> +	buf[*offset + 15] = 0xaa;
>>> +
>>> +	topts.data_in = buf;
>>> +	topts.data_out = buf;
>>> +	topts.data_size_in = buf_size;
>>> +	topts.data_size_out = buf_size;
>>> +
>>> +	err = bpf_prog_test_run_opts(prog_fd, &topts);
>>> +	ASSERT_EQ(err, -ENOMEM, "unsupported buffer size");
>>> +	free(buf);
>>>    out:
>>>    	bpf_object__close(obj);
>>>    }
>>
