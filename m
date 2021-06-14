Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6D23A6C74
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 18:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhFNQyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 12:54:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44142 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234348AbhFNQyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 12:54:07 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EGiAUV006529;
        Mon, 14 Jun 2021 09:51:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ra9IMH9nctf9LJEYcuG3eueMO+fWwnNgTxazXfdBPqI=;
 b=VTpi5FuTSME6lLPoNkTPXh6pZZXcMxSTufaI2HjbjzJfSjETHKO2jy+hxa7m4SXZNy7U
 cqRk7BWPEHqyHS5eEFAnu2HQSdkjt+rGRKGR7wUJ+u8WdYHTSl4alhChCkC/RUKZNfkI
 FOi7yWtPxJ/C88KMRjVVg8Pn0igVYRifshA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 396a8eraqt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Jun 2021 09:51:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 14 Jun 2021 09:51:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKrD+AoM4YMeZ70/QletEmMw8T7zMFr26iCXrItxIM7gixUdBgH1G82E1qkazRqBt+z3Ork3BBD74yKC6e9haVYVyPuinI5/a3epI0FoqMbh8TacNW+IQ9qQHHWb1+rzEZeiiah76nlNBkhV+y5BXH/HMNXAAIrFzyU5pgghiV07++to7wJ2GRX5/5CYldV+jvc15aPaJrVvesA8AcRLm34+kp9Am6W9VDDB2PnQS4megdksy8hrRQyQzvUfs3ZmTxZKm6op8MnSRMEcv1HxflgagsOYQK0fED0VpX23abVtihGqQ57hte1OMvQEZ+b/mDgqgNj8dGaMXgnQCD00eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ra9IMH9nctf9LJEYcuG3eueMO+fWwnNgTxazXfdBPqI=;
 b=FumQgxH1b7zNy/55QVcfrGbDWKhoCU6c4+LxyH7IXbXynzzL5FechmxpZJH0TD4HWXokCmU7qTdkhjuQd687rDILT362qualvdZax9ri6OhiIRx9DTk8GMvpaCj8fFppSJ4bM6nbLs1UTMVghxCchqL7dx81/21n6DMd3F4GEeVcOCfGT+DdcWCnEikfCry6FG1qKAEhZxIuVwJZ21m5sA08GuUT603V2dwsn6EjsnPwSwgF/tvgYQ6kw1XIwFOmTNSFUWT+M+qoTfN8dqyZdH5X11j+LWxQUp/r8xzm3PP7enHQ1nR5n4IVIbUOWnYNokGV7J2XDpSyBpnuD1ZmOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4224.namprd15.prod.outlook.com (2603:10b6:806:f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Mon, 14 Jun
 2021 16:51:40 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 16:51:40 +0000
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9b23b2c6-28b2-3ab3-4e8b-1fa0c926c4d2@fb.com>
Date:   Mon, 14 Jun 2021 09:51:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210611042442.65444-2-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:cc89]
X-ClientProxiedBy: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::100b] (2620:10d:c090:400::5:cc89) by BYAPR02CA0055.namprd02.prod.outlook.com (2603:10b6:a03:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Mon, 14 Jun 2021 16:51:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 320af870-da2a-4910-b0b4-08d92f54aea6
X-MS-TrafficTypeDiagnostic: SN7PR15MB4224:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN7PR15MB4224335A9AD83A34C123D8B7D3319@SN7PR15MB4224.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKz0a7lieWZHZB6/ewyG1h7JqsnhaENWhLum1llvVaYxSzkLt9GdI3l1HpSML/yokRd4dNQ25Jj05JF/fiGhimEZnKxkScxr0NL4MQkrFhjSETp7N7eTvthl6jd+3I4fSJ99jGexoleUno+LdymGHPK6BslSg8VCblEbjGuyR0bgnf9SXskdDTm2Vll9+k1k4fMpRAelfUaroJqAEXAGAweOkdRAG58I0O3iBOHS7Q2OUfue5zjP1i+Z+udGk4WZj3HDMJuACzDN1l4kOydNXOiRgeC0bKAtRCtuny6hgbtXIdxuCaGXGjcvhWimagWtPQ3mKa80qW6vpa2O/BNI7tioYLDAQJEjtJ8n2a/7sstcWtpP3zsmgd2/uOwHBJ26Fk/oNuseUCCHmmIYLUQ8o3aVaJhLiknOo2IJgMyXateUV/TmZg8brrV+c553TM5rtHkkZD6JEIXmjKtED7Qm/6ktGIWRdEBOFcBgn0389/mDaFmmTPfZNhHWdIS3jVGKiEkpbSGfDv8eDnZ+vE7SqCz25qJKteCL/XxSxachOXiUQzN4zXRmlYLIAFGG+O8CN9dHlyXek38EiiPaMTsIjVCrVeJ0AHFYJ7dQhMZvsF6PPERC9J840cekrI+gopZ4+Gn9HL86d6Rc9gjeaCWX+vFJS0x9YgNgV/8rystdFkJzmneF57M5UA1oeDA9RhYd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(38100700002)(2906002)(30864003)(16526019)(53546011)(186003)(316002)(2616005)(478600001)(83380400001)(4326008)(5660300002)(66946007)(66556008)(66476007)(6486002)(52116002)(36756003)(31696002)(8936002)(31686004)(8676002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2VLUjUyNGhDSzZSam5ndWlUS0hROGFTcDhFM0IyY3ZIeVJHK1p1OHVMR3Zj?=
 =?utf-8?B?ZVh2Z1ZjYjdNb1E2cHhWZ0p4Vkd4VmpDbDRDc05IWGZ5RzlMYnRjM2NGM2lH?=
 =?utf-8?B?R2NydVBnYk5yYStYSHRkNjRZeUFqejA1a1NobVVaUEQrT1Q0TFlRNjYyZk02?=
 =?utf-8?B?ZTNOZXk2R2F1NHNLS3plMWpaS0xkNlFHQzc1YnBSZTdUVDB2NXI4dTNXMGZu?=
 =?utf-8?B?bXFSUVRiVUdxeWJDcHRvY2srcmZuZ2l2RGVsSkpxYzJOTW9UK0ZnbUc3S2lQ?=
 =?utf-8?B?VkVFaFRrbENRcUlXdkdOZzZRR0ZObXl5WXJmVFBmWlBTQmZaZ0JYRllXS0J1?=
 =?utf-8?B?TWZwUW5pT25aNlJObVQ3OVNIblpyNVhuTGVaT2Ezci9TKzZGaWtXM0tvN0s2?=
 =?utf-8?B?UE16ZGJVcnpUMkJDTTQ3Q3pXSVBWTnZMMWFCUEVrYzRyWTFiWmRJWlRqLzd6?=
 =?utf-8?B?ZzZrQWxMRlppUFpuVWVzMjEwVjNWdGFjTlNXSFRTZUxWSVJ1WmNyZGFyQkhT?=
 =?utf-8?B?YlJ0MFFyeHpnNTVqTCtKdzVIRThScE02K1c4WEkvU0hqdlBOZDROV2ZaL1Uv?=
 =?utf-8?B?VVBpQURpQURBeTdxM29NRktNaWNvZ0VBdnN3SktvdWFYWEQ4ZWluYk9kUTZ6?=
 =?utf-8?B?bWZGQU1vVkltTWxjSW1YZ2lNTDRmaWF6SFRHR09IenJCSDRqWFRFTlk0MHdG?=
 =?utf-8?B?anhWWlR4NDE4RUQvNG9RRG5rQk0zbUczcmF5SVRqbGhvTFYvbEIyeXh2K09p?=
 =?utf-8?B?RnFqamtvcnZqSS95L2dNbzY1S2wxQ2hSZFhIcW91TUY4NlJpSTVRb2kxSkht?=
 =?utf-8?B?UVZXTWJUY2ZsMStwR3JaT0V2ZS9HS2Y2SVhERkY4Mm9VYUQwZFdRMlBOaXpV?=
 =?utf-8?B?azFsVGw5TzhPSXUvQ3NMcVNDamVRNjJvYVR4d2JCUm9ad3AwUFFHcHMrMzlj?=
 =?utf-8?B?STdTY1FiV1NEQTY5eDI4bktTTFkydUp5eEUvdnA3YkllR2hKWCtKVkFzU0I4?=
 =?utf-8?B?K1VCTW9UMjQxaFBJT242WEo3U1dIS0pvZ3I2bk5ITnE4My9iWXV4dnhHUU9Z?=
 =?utf-8?B?UEVBaFhoMFZsRDZkZ21PamJwb0hkdS9OZ1JkcW0ycERkbHBzMFR4TDM4dVcx?=
 =?utf-8?B?VlBzK3o1VlpwWFdIQXgwV0NFakV6UHpvZTNCUzYybGpNVGRZT0s5NmNibWgw?=
 =?utf-8?B?VzJ6cUZWdGJJZUVxenhVNDVJYmkyUm1LUFNXY2U3dFF1ZkZJckUrU0pNSFZR?=
 =?utf-8?B?ZlNtb0JWUHJUU2hVelFNdWQ2UngyaWRQVC9udnRmTzVnVTRqZmxtY0U1eHJh?=
 =?utf-8?B?bkpwb2NlK3llQjl2aUF5aEJPajNDZTVDcGFsZFB1WDFrS3dNbytuN0Y5dVk3?=
 =?utf-8?B?N1ZSemd4eFBKWmlVREczbUtTb0grUEhCTjkzUG9PeGxMdUFOS1JETXBtMXFE?=
 =?utf-8?B?OXdINFRGY1NLN0lXdjlIOGNmeVFSRDVYM0R1SjcrcHYyRDVhbkZSd3l3bTF4?=
 =?utf-8?B?eC9VUEhDQllzOHIvOExJMHM1ZW1qZEYzYW1YUWhyR1U1YVA0YzlXeFVQTVJv?=
 =?utf-8?B?LzVDTGRsWUJWRzJpWTgyb0pMUWJpYmxhMFlmWVdxcDhCSVBZbXRXSE5adUl1?=
 =?utf-8?B?em5RMTFNbnJGVEladVRrWTRYUDY0YXc4UlducU9CclFacThEVkFiNzNZdWgw?=
 =?utf-8?B?eE5keDE4MXBDaFVTSmtXN0E3clhNbUxIeXpmK3Z4aGU5djJjYURFcDZwNm5i?=
 =?utf-8?B?cjIrV1o0d25FVkVYTnFPV0JHWTloMk4vNDl0aG5vbEVINTM4OGUzRmNPQTNt?=
 =?utf-8?B?Q2N0dlozY3lKVi9zem9SQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 320af870-da2a-4910-b0b4-08d92f54aea6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 16:51:40.5233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: voTG54jiokMdIUYotpoEpNuaJsVjTtcOtDCh6ihkEJ5Mg9s3C7P8yVfqD1oBzdzY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4224
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: _hU-4ZNpey0TnFJEGEvqRtSPE-WTpqb9
X-Proofpoint-ORIG-GUID: _hU-4ZNpey0TnFJEGEvqRtSPE-WTpqb9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_10:2021-06-14,2021-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106140106
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/10/21 9:24 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
> in hash/array/lru maps as regular field and helpers to operate on it:
> 
> // Initialize the timer to call 'callback_fn' static function
> // First 4 bits of 'flags' specify clockid.
> // Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
> long bpf_timer_init(struct bpf_timer *timer, void *callback_fn, int flags);
> 
> // Start the timer and set its expiration 'nsec' nanoseconds from the current time.
> long bpf_timer_start(struct bpf_timer *timer, u64 nsec);
> 
> // Cancel the timer and wait for callback_fn to finish if it was running.
> long bpf_timer_cancel(struct bpf_timer *timer);
> 
> Here is how BPF program might look like:
> struct map_elem {
>      int counter;
>      struct bpf_timer timer;
> };
> 
> struct {
>      __uint(type, BPF_MAP_TYPE_HASH);
>      __uint(max_entries, 1000);
>      __type(key, int);
>      __type(value, struct map_elem);
> } hmap SEC(".maps");
> 
> static int timer_cb(void *map, int *key, struct map_elem *val);
> /* val points to particular map element that contains bpf_timer. */
> 
> SEC("fentry/bpf_fentry_test1")
> int BPF_PROG(test1, int a)
> {
>      struct map_elem *val;
>      int key = 0;
> 
>      val = bpf_map_lookup_elem(&hmap, &key);
>      if (val) {
>          bpf_timer_init(&val->timer, timer_cb, CLOCK_REALTIME);
>          bpf_timer_start(&val->timer, 1000 /* call timer_cb2 in 1 usec */);
>      }
> }
> 
> This patch adds helper implementations that rely on hrtimers
> to call bpf functions as timers expire.
> The following patch adds necessary safety checks.
> 
> Only programs with CAP_BPF are allowed to use bpf_timer.
> 
> The amount of timers used by the program is constrained by
> the memcg recorded at map creation time.
> 
> The bpf_timer_init() helper is receiving hidden 'map' and 'prog' arguments
> supplied by the verifier. The prog pointer is needed to do refcnting of bpf
> program to make sure that program doesn't get freed while timer is armed.
> 
> The bpf_map_delete_elem() and bpf_map_update_elem() operations cancel
> and free the timer if given map element had it allocated.
> "bpftool map update" command can be used to cancel timers.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>   include/linux/bpf.h            |   2 +
>   include/uapi/linux/bpf.h       |  40 ++++++
>   kernel/bpf/helpers.c           | 227 +++++++++++++++++++++++++++++++++
>   kernel/bpf/verifier.c          | 109 ++++++++++++++++
>   kernel/trace/bpf_trace.c       |   2 +-
>   scripts/bpf_doc.py             |   2 +
>   tools/include/uapi/linux/bpf.h |  40 ++++++
>   7 files changed, 421 insertions(+), 1 deletion(-)
> 
[...]
> +
> +static enum hrtimer_restart bpf_timer_cb(struct hrtimer *timer)
> +{
> +	struct bpf_hrtimer *t = container_of(timer, struct bpf_hrtimer, timer);
> +	struct bpf_prog *prog = t->prog;
> +	struct bpf_map *map = t->map;
> +	void *key;
> +	u32 idx;
> +	int ret;
> +
> +	/* bpf_timer_cb() runs in hrtimer_run_softirq. It doesn't migrate and
> +	 * cannot be preempted by another bpf_timer_cb() on the same cpu.
> +	 * Remember the timer this callback is servicing to prevent
> +	 * deadlock if callback_fn() calls bpf_timer_cancel() on the same timer.
> +	 */
> +	this_cpu_write(hrtimer_running, t);
> +	if (map->map_type == BPF_MAP_TYPE_ARRAY) {
> +		struct bpf_array *array = container_of(map, struct bpf_array, map);
> +
> +		/* compute the key */
> +		idx = ((char *)t->value - array->value) / array->elem_size;
> +		key = &idx;
> +	} else { /* hash or lru */
> +		key = t->value - round_up(map->key_size, 8);
> +	}
> +
> +	ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)map,
> +					    (u64)(long)key,
> +					    (u64)(long)t->value, 0, 0);
> +	WARN_ON(ret != 0); /* Next patch disallows 1 in the verifier */

I didn't find that next patch disallows callback return value 1 in the 
verifier. If we indeed disallows return value 1 in the verifier. We
don't need WARN_ON here. Did I miss anything?

> +
> +	/* The bpf function finished executed. Drop the prog refcnt.
> +	 * It could reach zero here and trigger free of bpf_prog
> +	 * and subsequent free of the maps that were holding timers.
> +	 * If callback_fn called bpf_timer_start on this timer
> +	 * the prog refcnt will be > 0.
> +	 *
> +	 * If callback_fn deleted map element the 't' could have been freed,
> +	 * hence t->prog deref is done earlier.
> +	 */
> +	bpf_prog_put(prog);
> +	this_cpu_write(hrtimer_running, NULL);
> +	return HRTIMER_NORESTART;
> +}
> +
> +BPF_CALL_5(bpf_timer_init, struct bpf_timer_kern *, timer, void *, cb, int, flags,
> +	   struct bpf_map *, map, struct bpf_prog *, prog)
> +{
> +	clockid_t clockid = flags & (MAX_CLOCKS - 1);
> +	struct bpf_hrtimer *t;
> +	int ret = 0;
> +
> +	BUILD_BUG_ON(MAX_CLOCKS != 16);
> +	if (flags >= MAX_CLOCKS ||
> +	    /* similar to timerfd except _ALARM variants are not supported */
> +            (clockid != CLOCK_MONOTONIC &&
> +             clockid != CLOCK_REALTIME &&
> +             clockid != CLOCK_BOOTTIME))
> +		return -EINVAL;
> +	____bpf_spin_lock(&timer->lock);
> +	t = timer->timer;
> +	if (t) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +	/* allocate hrtimer via map_kmalloc to use memcg accounting */
> +	t = bpf_map_kmalloc_node(map, sizeof(*t), GFP_ATOMIC, NUMA_NO_NODE);
> +	if (!t) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	t->callback_fn = cb;
> +	t->value = (void *)timer /* - offset of bpf_timer inside elem */;
> +	t->map = map;
> +	t->prog = prog;
> +	hrtimer_init(&t->timer, clockid, HRTIMER_MODE_REL_SOFT);
> +	t->timer.function = bpf_timer_cb;
> +	timer->timer = t;
> +out:
> +	____bpf_spin_unlock(&timer->lock);
> +	return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_timer_init_proto = {
> +	.func		= bpf_timer_init,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_TIMER,
> +	.arg2_type	= ARG_PTR_TO_FUNC,
> +	.arg3_type	= ARG_ANYTHING,
> +};
> +
> +BPF_CALL_2(bpf_timer_start, struct bpf_timer_kern *, timer, u64, nsecs)
> +{
> +	struct bpf_hrtimer *t;
> +	int ret = 0;
> +
> +	____bpf_spin_lock(&timer->lock);
> +	t = timer->timer;
> +	if (!t) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	if (!hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer))
> +		/* If the timer wasn't active or callback already executing
> +		 * bump the prog refcnt to keep it alive until
> +		 * callback is invoked (again).
> +		 */
> +		bpf_prog_inc(t->prog);

I am not 100% sure. But could we have race condition here?
    cpu 1: running bpf_timer_start() helper call
    cpu 2: doing hrtimer work (calling callback etc.)

Is it possible that
   !hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer)
may be true and then right before bpf_prog_inc(t->prog), it becomes 
true? If hrtimer_callback_running() is called, it is possible that
callback function could have dropped the reference count for t->prog,
so we could already go into the body of the function
__bpf_prog_put()?

static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
{
         if (atomic64_dec_and_test(&prog->aux->refcnt)) {
                 perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
                 bpf_audit_prog(prog, BPF_AUDIT_UNLOAD);
                 /* bpf_prog_free_id() must be called first */
                 bpf_prog_free_id(prog, do_idr_lock);
                 __bpf_prog_put_noref(prog, true);
         }
}


> +	hrtimer_start(&t->timer, ns_to_ktime(nsecs), HRTIMER_MODE_REL_SOFT);
> +out:
> +	____bpf_spin_unlock(&timer->lock);
> +	return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_timer_start_proto = {
> +	.func		= bpf_timer_start,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_TIMER,
> +	.arg2_type	= ARG_ANYTHING,
> +};
> +
> +BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
> +{
> +	struct bpf_hrtimer *t;
> +	int ret = 0;
> +
> +	____bpf_spin_lock(&timer->lock);
> +	t = timer->timer;
> +	if (!t) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	if (this_cpu_read(hrtimer_running) == t) {
> +		/* If bpf callback_fn is trying to bpf_timer_cancel()
> +		 * its own timer the hrtimer_cancel() will deadlock
> +		 * since it waits for callback_fn to finish
> +		 */
> +		ret = -EDEADLK;
> +		goto out;
> +	}
> +	/* Cancel the timer and wait for associated callback to finish
> +	 * if it was running.
> +	 */
> +	if (hrtimer_cancel(&t->timer) == 1) {

Again, could we have race here between bpf program and hrtimer_cancel()?

> +		/* If the timer was active then drop the prog refcnt,
> +		 * since callback will not be invoked.
> +		 */
> +		bpf_prog_put(t->prog);
> +		ret = 1;
> +	}
> +out:
> +	____bpf_spin_unlock(&timer->lock);
> +	return ret;
> +}
> +
> +static const struct bpf_func_proto bpf_timer_cancel_proto = {
> +	.func		= bpf_timer_cancel,
> +	.gpl_only	= true,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_TIMER,
> +};
> +
> +/* This function is called by delete_element in htab and lru maps
> + * and by map_free for array, lru, htab maps.
> + */
> +void bpf_timer_cancel_and_free(void *val)
> +{
> +	struct bpf_timer_kern *timer = val;
> +	struct bpf_hrtimer *t;
> +
> +	____bpf_spin_lock(&timer->lock);
> +	t = timer->timer;
> +	if (!t)
> +		goto out;
> +	/* Cancel the timer and wait for callback to complete if it was
> +	 * running. Only individual delete_element in htab or lru maps can
> +	 * return 1 from hrtimer_cancel.
> +	 * The whole map is destroyed when its refcnt reaches zero.
> +	 * That happens after bpf prog refcnt reaches zero.
> +	 * bpf prog refcnt will not reach zero until all timers are executed.
> +	 * So when maps are destroyed hrtimer_cancel will surely return 0.
> +	 * In such case t->prog is a pointer to freed memory.
> +	 *
> +	 * When htab or lru is deleting individual element check that
> +	 * bpf_map_delete_elem() isn't trying to delete elem with running timer.
> +	 * In such case don't call hrtimer_cancel() (since it will deadlock)
> +	 * and don't call hrtimer_try_to_cancel() (since it will just return -1).
> +	 * Instead free the timer and set timer->timer = NULL.
> +	 * The subsequent bpf_timer_start/cancel() helpers won't be able to use it.
> +	 * In preallocated maps it's safe to do timer->timer = NULL.
> +	 * The memory could be reused for another element while current timer
> +	 * callback can still do bpf_timer_init() on it.
> +	 * In non-preallocated maps timer->timer = NULL will happen after
> +	 * callback completes, since prog execution is an RCU critical section.
> +	 */
> +	if (this_cpu_read(hrtimer_running) != t &&
> +	    hrtimer_cancel(&t->timer) == 1)
> +		bpf_prog_put(t->prog);
> +	kfree(t);
> +	timer->timer = NULL;
> +out:
> +	____bpf_spin_unlock(&timer->lock);
> +}
> +
>   const struct bpf_func_proto bpf_get_current_task_proto __weak;
>   const struct bpf_func_proto bpf_probe_read_user_proto __weak;
>   const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
> @@ -1051,6 +1272,12 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>   		return &bpf_per_cpu_ptr_proto;
>   	case BPF_FUNC_this_cpu_ptr:
>   		return &bpf_this_cpu_ptr_proto;
> +	case BPF_FUNC_timer_init:
> +		return &bpf_timer_init_proto;
> +	case BPF_FUNC_timer_start:
> +		return &bpf_timer_start_proto;
> +	case BPF_FUNC_timer_cancel:
> +		return &bpf_timer_cancel_proto;
>   	default:
>   		break;
>   	}
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 1de4b8c6ee42..44ec9760b562 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4656,6 +4656,35 @@ static int process_spin_lock(struct bpf_verifier_env *env, int regno,
>   	return 0;
>   }
>   
> +static int process_timer_func(struct bpf_verifier_env *env, int regno,
> +			      struct bpf_call_arg_meta *meta)
> +{
> +	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
> +	bool is_const = tnum_is_const(reg->var_off);
> +	struct bpf_map *map = reg->map_ptr;
> +	u64 val = reg->var_off.value;
> +
> +	if (!is_const) {
> +		verbose(env,
> +			"R%d doesn't have constant offset. bpf_timer has to be at the constant offset\n",
> +			regno);
> +		return -EINVAL;
> +	}
> +	if (!map->btf) {
> +		verbose(env, "map '%s' has to have BTF in order to use bpf_timer\n",
> +			map->name);
> +		return -EINVAL;
> +	}
> +	if (val) {
> +		/* This restriction will be removed in the next patch */
> +		verbose(env, "bpf_timer field can only be first in the map value element\n");
> +		return -EINVAL;
> +	}
> +	WARN_ON(meta->map_ptr);

Could you explain when this could happen?

> +	meta->map_ptr = map;
> +	return 0;
> +}
> +
>   static bool arg_type_is_mem_ptr(enum bpf_arg_type type)
>   {
>   	return type == ARG_PTR_TO_MEM ||
> @@ -4788,6 +4817,7 @@ static const struct bpf_reg_types percpu_btf_ptr_types = { .types = { PTR_TO_PER
>   static const struct bpf_reg_types func_ptr_types = { .types = { PTR_TO_FUNC } };
>   static const struct bpf_reg_types stack_ptr_types = { .types = { PTR_TO_STACK } };
>   static const struct bpf_reg_types const_str_ptr_types = { .types = { PTR_TO_MAP_VALUE } };
> +static const struct bpf_reg_types timer_types = { .types = { PTR_TO_MAP_VALUE } };
>   
[...]
