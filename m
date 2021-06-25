Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0143B479A
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 18:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhFYQ4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 12:56:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6702 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230031AbhFYQ4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 12:56:52 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PGnHI6014858;
        Fri, 25 Jun 2021 09:54:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=UP4O3duOvBX/N1ezlKr4bGQGPhJfYJ8MFMUoS6cYD00=;
 b=awOVR+PY1Znp8GFOd3GTgx0yCAW1Gnny5cRVfG0/N3eFbclUEXjpC01DvFro+kZpuk7y
 5dBSx8xh9CDCRoXFgDw3Fp4kypk9LazvX4U2Brh9KopEn5GXZDqRQopAXc2qmwn8IRw7
 ihkjjz/ufhg1b/BmwuUwQ9wCoogPfKnnsSM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39d23jdhk3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Jun 2021 09:54:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 09:54:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxNVt0k6vRmvk/YaClRltr1u5461jw+02vchVeDtKCoXKMLvgmrtL7JV1uoc8gtL8EoBBxUstyZdCqQIUZq+Zjmf/qNxpsubqXMgNYRnTeMvAMS0QVaINFw/ecUCt3PVDHIMPojAcmBV9V6+fFFsZ3WJNXSDUyfNWd9My3UtnUh2Yt+tmY5TfTI8Q2WM6I6JcBXP35Rfki/D6IPCIuoD+0p6C/WNnLo890W8XZ2+qMWC4zRirUCWHDESm5y4qojGj2ZixRxCzx98q5ugNn29RSehDrYVsmkVAeFjE5qo/UNWOvfjHt4+0uswbeDO/+PIrtKo+RgO6Zqz5oXtk2+wjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UP4O3duOvBX/N1ezlKr4bGQGPhJfYJ8MFMUoS6cYD00=;
 b=S+F5oe20pNTNt5I0ZeqAXjQ7CLBguxxC0PGVsZj21tmynHEq0Z5NYOZzBo044SQAJnDyh5Lm/ZVMG1Vnik9qU+O86tmsAANz2+PMWUSrYhGjjGKnwH+pk9fHDVmFaO2w+oIFkTRQrypF56WU9E0rT4B1GxtCFGMjm30zV8R4J1bBntg+Dp17RbPFf8RLbHElD68URgx4OXXnwzEDquaepVZZ9vD+nb3Hd2HlozieXnUsfO8iGdzyZBYwrKjzIyOFyaoWDRocYy2LqJv6QR6QehOnKHj+tOX1M/rD9nAMF7m3BPBs2toWXe7ce3zZ607nc3Yz/EUuCWJLLZYdT2Qyfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3789.namprd15.prod.outlook.com (2603:10b6:806:8e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Fri, 25 Jun
 2021 16:54:14 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 16:54:14 +0000
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fd30895e-475f-c78a-d367-2abdf835c9ef@fb.com>
Date:   Fri, 25 Jun 2021 09:54:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210624022518.57875-2-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4ed3]
X-ClientProxiedBy: BY5PR20CA0034.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::47) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1328] (2620:10d:c090:400::5:4ed3) by BY5PR20CA0034.namprd20.prod.outlook.com (2603:10b6:a03:1f4::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Fri, 25 Jun 2021 16:54:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f7955d9-6449-406f-08af-08d937f9dd0e
X-MS-TrafficTypeDiagnostic: SA0PR15MB3789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB37891538DDCCD02F2A51C9AFD3069@SA0PR15MB3789.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pI4KX+e3v6Y7zBquUpMmiUfyyQe3gVcxYZwOJ9nkNLOqcPGVaDUg0F17u0Y9PIk1hx4pnAZUIRK1W+qz/NM2zjr99vgnqADeaDNsGdA8KFwu65MUzHxKhBmpu8FZFyPvFhFyoeo6zP19oE2a8ApbPS7htw+Ef16/pEtNOgHeIedE0iz9JHUi7/eI6ciR+jxygZgxrnxQ30wNk/lDknEfDlRscXzQglXKfNtw1SRqxv7R//acAeL0LOpzhe8EqnE/Qoi97AH8p0nQyPhKlwlOpfaTWhfDeoRz4Q8OjjaIR+CNl1XScUhcR8JGOEm1CZAYH3PxoNTibhAhKIg9DUsyY2wW3HXvDd3LoD5a5D6+LF4jc8j4Qy8G2xcshkyF/5fVGM8V8Y7zLOoyqcVihE4iEL+4p1rJCtQRmhNxRD/5UZRtl8qlDGdacYF1XfXV++q+eQy1SRlynBXEsWtTAdvdn0adDRiB9LQu5ola3WyUNthSK51AD+6c5dObQUx/UJzCSLWUxa6iYGavnd9n3H12chdVrZ/YLVutpsTReKOwBMGZZ3x16TlVH/v14CFZwHz67nKaT/2DTaorWXPBwAKVxerjBe+pthxX3H0BwZZ2lvCpjMLEGONGbV5T9B3CsG+Bk7SCF2jUIuK6Rki0XhTykI1ZyKAeur8uYsNGKMMk4Vt4/dOqPE68ozaSiEAhTFtt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(52116002)(86362001)(6486002)(53546011)(5660300002)(2616005)(6666004)(31696002)(316002)(38100700002)(8936002)(16526019)(186003)(478600001)(8676002)(4326008)(36756003)(31686004)(66476007)(66556008)(83380400001)(66946007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlZwK3ZtZVlrWjY2YWJMVlVrTFpRZHMvWm1CSEVWb2syV0lQTnR2bEN4MGNp?=
 =?utf-8?B?OCtSVS9waHEvSGVVbWlUWklZNGc4blRVSUk5MWREWEptc21XVWM1TnUrSzho?=
 =?utf-8?B?cVhjRnBralNxTVFydFR1dWk5MlFRek1XT09VQlRaZEpVcU1salQxdGRjdUpu?=
 =?utf-8?B?aTNUb04rcXBaeEtxV242clE5TVk3YjdNVGV2cUxVaVNBV0FUUUpLZmI3NUNj?=
 =?utf-8?B?b3FybWhialZob05RMmRsL1ZwNS9Fc0lRWWdueTVvcm1xTHFOS3owNm11QStS?=
 =?utf-8?B?ditNUUZNZko1dkVKcTU4QW1DeXRVblZsbVNJS0x1cVdCOWhTcTYxV0Racnk3?=
 =?utf-8?B?TGpnZTEzSnZuOExlVU1ZOWUwR3N2aTZySnV0NHRveHNTenIwSTcxT0ZhWWZv?=
 =?utf-8?B?ZDJTV1oyekppTGZqc1ozTTA1Zk1oQTZXQVk5dHJhUGhPMVlqRGxZZkJZbzVN?=
 =?utf-8?B?WnFtSEVwMHRGRXJNUVprTnhkNkpJaGl3U3gyTjV5KzNlbWY3MzRBanNDMDhP?=
 =?utf-8?B?ejl4ak53em80clhSUSs4UytBSjM0YVJoYzU1a3k4ZWxlWmtlNkorNStwcHd0?=
 =?utf-8?B?bkVGT3hwRVh6VXRMdEtMSTc4U1Z2aUVwb24zdkdZRmwyVEVSWlkxRkxiWk5H?=
 =?utf-8?B?WCtBWWVGTmVEQjkyNmF2M1JERnFob0d0cVhaZFloSHY1MjFoYWFQdFhFUTNj?=
 =?utf-8?B?SGtxZ0VSbjFoSjBHWFlCV0pOaEFuWEoycDQvNmg5NU9RM01ENi9MN0hHbFJU?=
 =?utf-8?B?cjVNRCtsK2hhaytqM2xabmxtSnRMWEhaY20yZzAwVGhQZnVPQnFBdEtkQk90?=
 =?utf-8?B?MmxtOEZpS2JmS3FvbjRORG1Id0lXSENVd1RjKzZDaWJWV29SbFMyRFIwMnZ4?=
 =?utf-8?B?dFRudTBIU3JkR3paaUNZVEhtQ0J0MnhlQ2JIeGZvcldJbjRpa01hbU1VdTZU?=
 =?utf-8?B?S3lqKzJFai9XY2JjbFg0WnM5R3lCZUhOYngvcnhhUXBmelAzZkVmdjZiMkVN?=
 =?utf-8?B?dXAxUUVYR3J2d3V2QmdNMENSVENjZ3hnQjhPSWNFY3BrUVB2M0VlZWhua3RH?=
 =?utf-8?B?SWI3bEhvWWl2dy9GenowZlJvZE1TZG9pbFhXMU9vUWM5bG1oZlRLNHRvekRQ?=
 =?utf-8?B?R1ZJOGNvRHp3YkNSemhiVDhhWWl2ZEIvTFB3WUN5cmhrdlhMS2Y0ZFcxeWRD?=
 =?utf-8?B?UEh4bDV1eUVGVHpObGtnUFRMYjFLV2RLRGVTZ0NrQWxzaUc5NGdZOUpZWmVO?=
 =?utf-8?B?dVBkSE9rOWtPbjg3VEhVQ0VWdmpBbytrcm4yMGlIM2owT0lZMzFCN1A3MWN4?=
 =?utf-8?B?MkZvdWI2SWJub1VnZHRoaWNXVHNHdTlDYk9QMnY0ZVRUM0pjekF5Z0k4blRa?=
 =?utf-8?B?UkR5YUo2bnJrMzRHckxnb25MT2FybmJ3K2ZONTZDeEtPNjRNWlJ4QVR4WUNS?=
 =?utf-8?B?SVNHeWFPZTh4VXhneE53cWF6aWg3ckV2dStjSXR2NWdvZXZWbnVmQXN2ejhi?=
 =?utf-8?B?QjAzMHpsRzNac1V0NXIwbFVVZWZvUVJCWVQrVWFHd1J4Zy9DZ3dlUW1LQjFV?=
 =?utf-8?B?NVFqSk5xUzJjb0NmNzUxNnNNRGNNTU84ZlhUeFVpNWMxUFVuYWJXY2R4akFi?=
 =?utf-8?B?c0dzc2dCOTRDZHE0L21FK2t5dmhjUXpTSVR6NExqaWg4UU9neTJlSkJCUjN1?=
 =?utf-8?B?bjdhVFVocXYxbk92akhDV0N0TjNlOWdOdWphdHNjeFJ2Q1ozSmNGSHBWdXZr?=
 =?utf-8?B?eVYvRjc1N0RqNWljaC9FakNwOWkwUHBKckV6UFkrSUwrdG5KRkFtcmRrVCtZ?=
 =?utf-8?Q?+h9ovfrU37Q/Ap0PB40NmEv9Rf4U0lpHNBYgU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f7955d9-6449-406f-08af-08d937f9dd0e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 16:54:14.5754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GzIm/qZoc+/dFrOmOmrOBQECpYjRiliWEFcnurDyphHtuFzzrIdp0G7QmBYX79ZP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3789
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 83m_eh5SP34xIC1V_ENTODJgHOlLXdZY
X-Proofpoint-GUID: 83m_eh5SP34xIC1V_ENTODJgHOlLXdZY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_06:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250100
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/21 7:25 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
> in hash/array/lru maps as a regular field and helpers to operate on it:
> 
> // Initialize the timer.
> // First 4 bits of 'flags' specify clockid.
> // Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
> long bpf_timer_init(struct bpf_timer *timer, int flags);
> 
> // Arm the timer to call callback_fn static function and set its
> // expiration 'nsec' nanoseconds from the current time.
> long bpf_timer_start(struct bpf_timer *timer, void *callback_fn, u64 nsec);
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
>          bpf_timer_init(&val->timer, CLOCK_REALTIME);
>          bpf_timer_start(&val->timer, timer_cb, 1000 /* call timer_cb2 in 1 usec */);
>      }
> }
> 
> This patch adds helper implementations that rely on hrtimers
> to call bpf functions as timers expire.
> The following patches add necessary safety checks.
> 
> Only programs with CAP_BPF are allowed to use bpf_timer.
> 
> The amount of timers used by the program is constrained by
> the memcg recorded at map creation time.
> 
> The bpf_timer_init() helper is receiving hidden 'map' argument and
> bpf_timer_start() is receiving hidden 'prog' argument supplied by the verifier.
> The prog pointer is needed to do refcnting of bpf program to make sure that
> program doesn't get freed while the timer is armed. This apporach relies on
> "user refcnt" scheme used in prog_array that stores bpf programs for
> bpf_tail_call. The bpf_timer_start() will increment the prog refcnt which is
> paired with bpf_timer_cancel() that will drop the prog refcnt. The
> ops->map_release_uref is responsible for cancelling the timers and dropping
> prog refcnt when user space reference to a map reaches zero.
> This uref approach is done to make sure that Ctrl-C of user space process will
> not leave timers running forever unless the user space explicitly pinned a map
> that contained timers in bpffs.
> 
> The bpf_map_delete_elem() and bpf_map_update_elem() operations cancel
> and free the timer if given map element had it allocated.
> "bpftool map update" command can be used to cancel timers.
> 
> The 'struct bpf_timer' is explicitly __attribute__((aligned(8))) because
> '__u64 :64' has 1 byte alignment of 8 byte padding.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>   include/linux/bpf.h            |   3 +
>   include/uapi/linux/bpf.h       |  55 +++++++
>   kernel/bpf/helpers.c           | 281 +++++++++++++++++++++++++++++++++
>   kernel/bpf/verifier.c          | 138 ++++++++++++++++
>   kernel/trace/bpf_trace.c       |   2 +-
>   scripts/bpf_doc.py             |   2 +
>   tools/include/uapi/linux/bpf.h |  55 +++++++
>   7 files changed, 535 insertions(+), 1 deletion(-)
> 
[...]
> @@ -12533,6 +12607,70 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
>   			continue;
>   		}
>   
> +		if (insn->imm == BPF_FUNC_timer_init) {
> +			aux = &env->insn_aux_data[i + delta];
> +			if (bpf_map_ptr_poisoned(aux)) {
> +				verbose(env, "bpf_timer_init abusing map_ptr\n");
> +				return -EINVAL;
> +			}
> +			map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
> +			{
> +				struct bpf_insn ld_addrs[2] = {
> +					BPF_LD_IMM64(BPF_REG_3, (long)map_ptr),
> +				};
> +
> +				insn_buf[0] = ld_addrs[0];
> +				insn_buf[1] = ld_addrs[1];
> +			}
> +			insn_buf[2] = *insn;
> +			cnt = 3;
> +
> +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
> +			if (!new_prog)
> +				return -ENOMEM;
> +
> +			delta    += cnt - 1;
> +			env->prog = prog = new_prog;
> +			insn      = new_prog->insnsi + i + delta;
> +			goto patch_call_imm;
> +		}
> +
> +		if (insn->imm == BPF_FUNC_timer_start) {
> +			/* There is no need to do:
> +			 *     aux = &env->insn_aux_data[i + delta];
> +			 *     if (bpf_map_ptr_poisoned(aux)) return -EINVAL;
> +			 * for bpf_timer_start(). If the same callback_fn is shared
> +			 * by different timers in different maps the poisoned check
> +			 * will return false positive.
> +			 *
> +			 * The verifier will process callback_fn as many times as necessary
> +			 * with different maps and the register states prepared by
> +			 * set_timer_start_callback_state will be accurate.
> +			 *
> +			 * There is no need for bpf_timer_start() to check in the
> +			 * run-time that bpf_hrtimer->map stored during bpf_timer_init()
> +			 * is the same map as in bpf_timer_start()
> +			 * because it's the same map element value.

I am puzzled by above comments. Maybe you could explain more?
bpf_timer_start() checked whether timer is initialized with timer->timer 
NULL check. It will proceed only if a valid timer has been
initialized. I think the following scenarios are also supported:
   1. map1 is shared by prog1 and prog2
   2. prog1 call bpf_timer_init for all map1 elements
   3. prog2 call bpf_timer_start for some or all map1 elements.
So for prog2 verification, bpf_timer_init() is not even called.

> +			 */
> +			struct bpf_insn ld_addrs[2] = {
> +				BPF_LD_IMM64(BPF_REG_4, (long)prog),
> +			};
> +
> +			insn_buf[0] = ld_addrs[0];
> +			insn_buf[1] = ld_addrs[1];
> +			insn_buf[2] = *insn;
> +			cnt = 3;
> +
> +			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
> +			if (!new_prog)
> +				return -ENOMEM;
> +
> +			delta    += cnt - 1;
> +			env->prog = prog = new_prog;
> +			insn      = new_prog->insnsi + i + delta;
> +			goto patch_call_imm;
> +		}
> +
>   		/* BPF_EMIT_CALL() assumptions in some of the map_gen_lookup
>   		 * and other inlining handlers are currently limited to 64 bit
>   		 * only.
[...]
