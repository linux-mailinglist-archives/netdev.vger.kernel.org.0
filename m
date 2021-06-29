Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252703B6C74
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 04:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhF2C1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 22:27:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8476 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231194AbhF2C1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 22:27:38 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T2OZcd007444;
        Mon, 28 Jun 2021 19:24:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dzbdgeYSJc+kmW5H1lbzrNSgKJU4//J6Co/7LyXWcrE=;
 b=G0/v4tA834HsxU+ztWx/4nq6h18EjAJ5RN5mkbRW3mlFb0vrUPYWhWondIIVH1xUNJh8
 2vL5GWdwkPsdnSWP3qU+2xHNSuqkCbKPtkcp5fv3ibeEbNOGPn0ZDEy2m9N73JzLjrf9
 TAlfGQXoDjrgQTMxYjyW48mGdA9h7EQx8Bg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39em08jnq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Jun 2021 19:24:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 19:24:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3RnmqEY42LaXQTLm9/kEgrHeoiHItG0n0MebHkNPji1O81YJbIduoiueCfOe2No4qE6RIjbLXuwsbEX+NkAnnNHzwi5zRF0cOXPShoNXJCfj4mX5T4gZsZjEfcDhUKjigTsG3EqyukXwKACKW4EuJW+6F0SdtyecfvEsYu+OIHnsUw6pt8JqADH25ZT6A0aG+7MXKAYiJpalONmwhm9pAOHzRA2IvGrM3LbEsRrIbn10TzeviYIu2n1q0GlGau08R5iE8vlbycOlk7c/pHApaBMqmxUCfIeFVuRCElVoSbuCp9MK7RBF7HA16/g705XWBlQNNveXMPG6VpMWhnZig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzbdgeYSJc+kmW5H1lbzrNSgKJU4//J6Co/7LyXWcrE=;
 b=FGZs/D6g3GWKlEq4b4oeL++tvbfj61Ng+YxXfq1ee+J35qXT/DNJJKutNSld+wHPn1GRfWfGkzCKuCZiSLqBNGYRKyEbjxf5GIjVBSwbuyJf18sOu/+LDEyhtUAzBiOH11INflmEDGqlejBTgW+zu899oHjOgwV1g0N7M7RRyZhsPL1PHJH9+db9JG6EBWglhH6DXlUsVbY4P9LU0ttD129zPyH1H5UxcLBhQuVfZZSh8tzdzhVR+U1FHbx5d+vPqg2n3uwMMTF17aw8hsbGusTFiGzoS7YEw7AJmpomn8LhLW9IskeAVCCl4uxaHnShtRNS5rrxPtX+tCuVjtVy6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4500.namprd15.prod.outlook.com (2603:10b6:806:19b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Tue, 29 Jun
 2021 02:24:32 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 02:24:32 +0000
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <davem@davemloft.net>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com>
 <fd30895e-475f-c78a-d367-2abdf835c9ef@fb.com>
 <20210629014607.fz5tkewb6n3u6pvr@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bcc2f155-129d-12f1-1e3d-c741c746df10@fb.com>
Date:   Mon, 28 Jun 2021 19:24:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210629014607.fz5tkewb6n3u6pvr@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:b3c6]
X-ClientProxiedBy: MWHPR04CA0071.namprd04.prod.outlook.com
 (2603:10b6:300:6c::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1a57] (2620:10d:c090:400::5:b3c6) by MWHPR04CA0071.namprd04.prod.outlook.com (2603:10b6:300:6c::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 02:24:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d641b0e-38c2-47cb-4436-08d93aa5076e
X-MS-TrafficTypeDiagnostic: SA1PR15MB4500:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4500135244AAD5896CC1E113D3029@SA1PR15MB4500.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AGBDtJKxexnbJKLLapGLMJC+oUXMH7lSf5NPmJmOChtBmFT/F/RpSs4qrQf7FqqTs87pyumnxQkJbZHbiox0lbElo6GiqLJlbVFiK+MSyXLFjl81MauGGu4QMiBo35nwBuU3luFfhDvB2A28f82qddsHal+VP8Bj0Z1FeiL+FgsAkcv+05k1LXU7xcqqRjZXZsenkc6giL6a7FNVmqE0jy9kVJgzmMbkZftTRlWAYFOhNmTzac9p4iAJ5DFnBpB0R7tJ0pZbhwW2Jxnx5qwXU2ZbJtqi82gQy5vjSZDUN/g2DbOLIAfRLw3qfHadqYVuH8RgQrhaurbTjnHydkTdMZUGL+DLA2aSFLFKjfDp9tXa87RuLsvt51MRVyfb95r6O9b+/nDSmGwTCpH0vUT3F9iVmjpFQvANcGe11lSG6d3pA1uMJGUtX5dv5Rycva32CoxONK/9XKNr0sPIMvm8szkv9GQgp01TDV8XUFrt/76Q/9/x2LM3imKcfLVZXfzz0Evl7PNid5MbwcUFMbnmykox16WS0xyzUwhJt0NYVac1TA4PvoiIEI5NE7LQfIcUtkEpaougnGDcCmQlf2oRVIE6GbfK0eV8jkUIJYg2XEUpLKcj6b50yygki3LyqHhELz1ugMg2dO5uraFV68OAsleU1AbXTosD8UsAdiCIkp2iAJwUhJvnJ3lP0YWvBYIU/dpc+VHiTtFMNkc2/dHWABCen5KjH5kX0FwoVAqPozg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(66946007)(6486002)(31696002)(8676002)(36756003)(2616005)(66556008)(53546011)(6666004)(478600001)(2906002)(5660300002)(66476007)(16526019)(6916009)(316002)(8936002)(4326008)(38100700002)(83380400001)(52116002)(31686004)(186003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGw0NStwTm5VK2tXZWZrMHRKN3BIbHBCN2k2c3hzTFZja2MrSVduOGtsS0lp?=
 =?utf-8?B?YXcwdVg3andNMmx0U0FCNTVLRktPZ041R01CcUc5UFdKOS9DaklxSFZtcnZz?=
 =?utf-8?B?N0dSdDU3dXhoQnFPNkZiNWVpTzVZakZpZ1ZxNFVmOHRPTkI2Tk5oNlZldlFP?=
 =?utf-8?B?SjFUbVVxT21TNlpSNHc2bnJRVDF2ZWZ3UnB2KzdNYSt0d0xHdkZNRE5kck1Y?=
 =?utf-8?B?RmxaQVVRTEd4bFdOWWkzeGprUmhVOUQvTllzeGtIenc2U1dhYW5ZTVczRUJL?=
 =?utf-8?B?ODdpb1lRZzNtZGtZSE5FZUl3dlluOUdZa0ZZelJicWlhbVk5S1VjWUhMbHFH?=
 =?utf-8?B?bDUvQ3dZYndRSmFuem1oK1BDKzJBMmhJRm1CZTkwUzY1aFMxUGNiS09ldGFx?=
 =?utf-8?B?YzdSYjN0RWVHYm1GRUxXSGJ5ZHFIUzlrU0t2TjlTZHUrTEkrQW91eC9ITGNO?=
 =?utf-8?B?ZjBrVmZMQnc4NDY5aEJyOTlzQTY0SjRNTWRzZURkVU1WaFI4U2d5NFB4YUlw?=
 =?utf-8?B?Y1VReWJJaXRmRENDOWlOVW0rUUZzQ2xIcFcwTUV1clIzR1c5bHFSaEJyVSs3?=
 =?utf-8?B?bHorYWpBd3Q4WUZqdVVERm5VZHNmUjU2eEZYNGswRzRMamZQOTZqZi9MVUxD?=
 =?utf-8?B?STVGbDJKVk5wOWtudFE3RXZ6Ui9ocXowS2lpVkxacEQ5NU1sVi9SR3BKckpv?=
 =?utf-8?B?SDJpa0drRHJob3VyTkUzZ0syLzBWeTJBd01WSFlpSlFsendwNENyWHlZMjVn?=
 =?utf-8?B?MU90YUlNTVNjODJYTkpqWUdDSkNMZnhqcm9pVHJVNlI1a3V5MjkxU3duUDFW?=
 =?utf-8?B?a1pUNHNneTBFSlJkNWtzWEZWUE0zeExqZ3kwWTVBYWNDZ1dST1dSQXNRdWNV?=
 =?utf-8?B?d0U2MlFDalRrTXhZZll4aDV3dWxyWENzK0ZWYnVSN0J3L3FybGp0cFpvOW44?=
 =?utf-8?B?OU01WkprWitMWXhRWWYzV0duTXZCUE41eE1CclJhcHRwZW5URXRTd1E1TTQ3?=
 =?utf-8?B?SEVkcFIvSUc2eGx2THcwR0RoL0lFbUpVb21GOThTcEZTbWNHbGJyUWtxYWpy?=
 =?utf-8?B?WWtqMzU3dTEvc3pUdzFJMFJQRkJwOE9DUitNVFVEdDFPYVRydzdhUTlOMWJk?=
 =?utf-8?B?cUJoS2xtdzlDVnVlbklHSWFPKzZRMXZDVmY0YTd0QjR2ZncrK1pGangrTG94?=
 =?utf-8?B?ZVRQWnBzNm1tSHhWNzlXVWJZOEFDQ2ZQajJhVC9yb1FEaFMzVnQ2bExaSWZr?=
 =?utf-8?B?aGtvcUJEWTJMTUc4ZFZRRk50QVU2d0N6MXVtS2RicnhoODlRYW1NT2tJWmdJ?=
 =?utf-8?B?NktZOXFWK25VdUZzZ2xVdWliVjZIcmZaOUdVWnBjTHBMQUFBTnMxeDZ3QUdR?=
 =?utf-8?B?SGpGc0pHbTl6TzR4aEhzVm02VWpLOEV3Sk1qY0NxNmVaeFE1a0NGa3pMa2cy?=
 =?utf-8?B?L0FXZUFFKy9DMStNTXVLWmt4YnJReU5STVVwOU1OOGNCS0xKaVh5ZDFiQW9X?=
 =?utf-8?B?UnU4WXhTOHJxUXZBd2FkdklscWNyRHFjRENkQ055ZGFLN1hKZUdDWFpxNmp5?=
 =?utf-8?B?VWNNWmhWS3RWMm5EamVjakt0OVNKTFRzZm9iVzdTUENDNFBuNi9keEd1eWJo?=
 =?utf-8?B?TUZCSm50VlRZZ2tHdlEwTE9NZ3JRMFV1NVhGejM5RjlRTTVWWVZTdm04Q1FU?=
 =?utf-8?B?N3FLMDRaaTRXYTNyR2RESlg0OWdHNlZ3VzdEcUFZZ2lpWXdmaVZ2LzJSSDdy?=
 =?utf-8?B?T2pDL01SUndYNlNhNTcvNDJyUnJ5ZTVUVGNjVm9ZRW5CbTAwbkx0TkZKRFVL?=
 =?utf-8?B?ZXlzeHQyREFoWjdDamtvQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d641b0e-38c2-47cb-4436-08d93aa5076e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 02:24:31.9367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: irg9E/nQBrOnMej6AHHy/jEw6b7QhfxGPu4n1DuX8kX4k3wowjLC2nLdeiytpbdd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4500
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 4WGDF5jd48bevYQefngYOyzzFfLl6vja
X-Proofpoint-ORIG-GUID: 4WGDF5jd48bevYQefngYOyzzFfLl6vja
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-28_14:2021-06-25,2021-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290016
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/21 6:46 PM, Alexei Starovoitov wrote:
> On Fri, Jun 25, 2021 at 09:54:11AM -0700, Yonghong Song wrote:
>>
>>
>> On 6/23/21 7:25 PM, Alexei Starovoitov wrote:
>>> From: Alexei Starovoitov <ast@kernel.org>
>>>
>>> Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
>>> in hash/array/lru maps as a regular field and helpers to operate on it:
>>>
>>> // Initialize the timer.
>>> // First 4 bits of 'flags' specify clockid.
>>> // Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
>>> long bpf_timer_init(struct bpf_timer *timer, int flags);
>>>
>>> // Arm the timer to call callback_fn static function and set its
>>> // expiration 'nsec' nanoseconds from the current time.
>>> long bpf_timer_start(struct bpf_timer *timer, void *callback_fn, u64 nsec);
>>>
>>> // Cancel the timer and wait for callback_fn to finish if it was running.
>>> long bpf_timer_cancel(struct bpf_timer *timer);
>>>
>>> Here is how BPF program might look like:
>>> struct map_elem {
>>>       int counter;
>>>       struct bpf_timer timer;
>>> };
>>>
>>> struct {
>>>       __uint(type, BPF_MAP_TYPE_HASH);
>>>       __uint(max_entries, 1000);
>>>       __type(key, int);
>>>       __type(value, struct map_elem);
>>> } hmap SEC(".maps");
>>>
>>> static int timer_cb(void *map, int *key, struct map_elem *val);
>>> /* val points to particular map element that contains bpf_timer. */
>>>
>>> SEC("fentry/bpf_fentry_test1")
>>> int BPF_PROG(test1, int a)
>>> {
>>>       struct map_elem *val;
>>>       int key = 0;
>>>
>>>       val = bpf_map_lookup_elem(&hmap, &key);
>>>       if (val) {
>>>           bpf_timer_init(&val->timer, CLOCK_REALTIME);
>>>           bpf_timer_start(&val->timer, timer_cb, 1000 /* call timer_cb2 in 1 usec */);
>>>       }
>>> }
>>>
>>> This patch adds helper implementations that rely on hrtimers
>>> to call bpf functions as timers expire.
>>> The following patches add necessary safety checks.
>>>
>>> Only programs with CAP_BPF are allowed to use bpf_timer.
>>>
>>> The amount of timers used by the program is constrained by
>>> the memcg recorded at map creation time.
>>>
>>> The bpf_timer_init() helper is receiving hidden 'map' argument and
>>> bpf_timer_start() is receiving hidden 'prog' argument supplied by the verifier.
>>> The prog pointer is needed to do refcnting of bpf program to make sure that
>>> program doesn't get freed while the timer is armed. This apporach relies on
>>> "user refcnt" scheme used in prog_array that stores bpf programs for
>>> bpf_tail_call. The bpf_timer_start() will increment the prog refcnt which is
>>> paired with bpf_timer_cancel() that will drop the prog refcnt. The
>>> ops->map_release_uref is responsible for cancelling the timers and dropping
>>> prog refcnt when user space reference to a map reaches zero.
>>> This uref approach is done to make sure that Ctrl-C of user space process will
>>> not leave timers running forever unless the user space explicitly pinned a map
>>> that contained timers in bpffs.
>>>
>>> The bpf_map_delete_elem() and bpf_map_update_elem() operations cancel
>>> and free the timer if given map element had it allocated.
>>> "bpftool map update" command can be used to cancel timers.
>>>
>>> The 'struct bpf_timer' is explicitly __attribute__((aligned(8))) because
>>> '__u64 :64' has 1 byte alignment of 8 byte padding.
>>>
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>> ---
>>>    include/linux/bpf.h            |   3 +
>>>    include/uapi/linux/bpf.h       |  55 +++++++
>>>    kernel/bpf/helpers.c           | 281 +++++++++++++++++++++++++++++++++
>>>    kernel/bpf/verifier.c          | 138 ++++++++++++++++
>>>    kernel/trace/bpf_trace.c       |   2 +-
>>>    scripts/bpf_doc.py             |   2 +
>>>    tools/include/uapi/linux/bpf.h |  55 +++++++
>>>    7 files changed, 535 insertions(+), 1 deletion(-)
>>>
>> [...]
>>> @@ -12533,6 +12607,70 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
>>>    			continue;
>>>    		}
>>> +		if (insn->imm == BPF_FUNC_timer_init) {
>>> +			aux = &env->insn_aux_data[i + delta];
>>> +			if (bpf_map_ptr_poisoned(aux)) {
>>> +				verbose(env, "bpf_timer_init abusing map_ptr\n");
>>> +				return -EINVAL;
>>> +			}
>>> +			map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
>>> +			{
>>> +				struct bpf_insn ld_addrs[2] = {
>>> +					BPF_LD_IMM64(BPF_REG_3, (long)map_ptr),
>>> +				};
>>> +
>>> +				insn_buf[0] = ld_addrs[0];
>>> +				insn_buf[1] = ld_addrs[1];
>>> +			}
>>> +			insn_buf[2] = *insn;
>>> +			cnt = 3;
>>> +
>>> +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
>>> +			if (!new_prog)
>>> +				return -ENOMEM;
>>> +
>>> +			delta    += cnt - 1;
>>> +			env->prog = prog = new_prog;
>>> +			insn      = new_prog->insnsi + i + delta;
>>> +			goto patch_call_imm;
>>> +		}
>>> +
>>> +		if (insn->imm == BPF_FUNC_timer_start) {
>>> +			/* There is no need to do:
>>> +			 *     aux = &env->insn_aux_data[i + delta];
>>> +			 *     if (bpf_map_ptr_poisoned(aux)) return -EINVAL;
>>> +			 * for bpf_timer_start(). If the same callback_fn is shared
>>> +			 * by different timers in different maps the poisoned check
>>> +			 * will return false positive.
>>> +			 *
>>> +			 * The verifier will process callback_fn as many times as necessary
>>> +			 * with different maps and the register states prepared by
>>> +			 * set_timer_start_callback_state will be accurate.
>>> +			 *
>>> +			 * There is no need for bpf_timer_start() to check in the
>>> +			 * run-time that bpf_hrtimer->map stored during bpf_timer_init()
>>> +			 * is the same map as in bpf_timer_start()
>>> +			 * because it's the same map element value.
>>
>> I am puzzled by above comments. Maybe you could explain more?
>> bpf_timer_start() checked whether timer is initialized with timer->timer
>> NULL check. It will proceed only if a valid timer has been
>> initialized. I think the following scenarios are also supported:
>>    1. map1 is shared by prog1 and prog2
>>    2. prog1 call bpf_timer_init for all map1 elements
>>    3. prog2 call bpf_timer_start for some or all map1 elements.
>> So for prog2 verification, bpf_timer_init() is not even called.
> 
> Right. Such timer sharing between two progs is supported.
>>From prog2 pov the bpf_timer_init() was not called, but it certainly
> had to be called by this or ther other prog.
> I'll rephrase the last paragraph.

okay.

> 
> While talking to Martin about the api he pointed out that
> callback_fn in timer_start() doesn't achieve the full use case
> of replacing a prog. So in the next spin I'll split it into
> bpf_timer_set_callback(timer, callback_fn);
> bpf_timer_start(timer, nsec);
> This way callback and prog can be replaced without resetting
> timer expiry which could be useful.

I took a brief look for patch 4-6 and it looks okay. But since
you will change helper signatures I will hold and check next
revision instead.

BTW, does this mean the following scenario will be supported?
   prog1: bpf_timer_set_callback(time, callback_fn)
   prog2: bpf_timer_start(timer, nsec)
so here prog2 can start the timer which call prog1's callback_fn?

> 
> Also Daniel and Andrii reminded that cpu pinning would be next
> feature request. The api extensibility allows to add it in the future.
> I'm going to delay implementing it until bpf_smp_call_single()
> implications are understood.

Do we need to any a 'flags' parameter for bpf_timer_start() helper
so we can encode target cpu in 'flags'?
