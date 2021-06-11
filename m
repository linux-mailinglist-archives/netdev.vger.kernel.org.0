Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8E43A4AE5
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 00:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhFKWO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 18:14:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230350AbhFKWO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 18:14:26 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 15BLteOG004694;
        Fri, 11 Jun 2021 15:12:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vRKcyDufqbVBospO+QIzoajVdpluDHKaT8AHEKD0UqA=;
 b=qHZx6Q03aDz4GCVPTj6QSTR6Rr1Jz+I0HLbPvdB8MWEHnUC0d/up9Y8b9S/nyIdVy6hj
 qNRZjsj1U6T5p3zEwJP+Nunj+xijdw/J8htV2xqjpviXcUcEOvzIPmBKRzN66D1mCLyB
 W3ySCSp9/JCLz47pYm36TN4nL1WUD5mjgmc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 393scmyues-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 11 Jun 2021 15:12:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 15:12:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5RYyjJsB83AXnBNnJLSK1crpI4J/wBMVKmwjpJSPmwefXCRNsgugS1LI2a4X8j2qKFgBhf6aUDXJUl0rP4vwTet6+srTYHzTYtV9EHU/2csYy23Ta6xZZlN0VTbsO7gHr39FRNTLMuXZ3ik4aIAhI6gJGPjgn+3Gg6yniSMO2KdZukoACnJr/61rkWRcb2oducBtGpnOTS9y0fp1YcbBkle5fGOsHLhdpzUrwkIbV4ByUTrXfQLJL0mRUzuQ7/JF8TO7wL/bcYWVhQr4JoWuaOn5D79aI9thYpdbp1/xBMx3VaxeuYPXXbWDGB4fVMxLjrbuNr19wQgKcm/lAnhsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRKcyDufqbVBospO+QIzoajVdpluDHKaT8AHEKD0UqA=;
 b=dfdmh8eWOyavJZPm7ifmpd9oSlaw+qn9Ci0HeytL/UdXQTrLTg9MnecwZJ0E1/qSp2jD8VIDbO+g+pN9VCOZcqXvjcbcjRk92tiGwMIPPQU+sc8PRyTficee43SefXNtS917JPa4FruQUI4Z1xGBH3/MwQjwws8sGsbPcyLzcYWPkiwxjc8fm9oNn1YSMz1HcatsdaouOrabYu7Ey0Zj7o7hwrfJPDYU5oNXF5PvzY/xvykwO7MfayWJFU2Dich2ZMZfVem1hpzahuIO/c96er/F5SwPHldIbMuS5jyBZP10SVozqC3qXQWuAcMqzMTmPRl9OotYeOeRQr0Bz7hdbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB4016.namprd15.prod.outlook.com (2603:10b6:806:84::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 22:12:09 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.024; Fri, 11 Jun 2021
 22:12:09 +0000
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f36d19e7-cc6f-730b-cf13-d77e1ce88d2f@fb.com>
Date:   Fri, 11 Jun 2021 15:12:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210611042442.65444-2-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:f260]
X-ClientProxiedBy: BY5PR17CA0026.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::39) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::19e3] (2620:10d:c090:400::5:f260) by BY5PR17CA0026.namprd17.prod.outlook.com (2603:10b6:a03:1b8::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 22:12:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea1bfa1e-c81c-4811-6480-08d92d25f46f
X-MS-TrafficTypeDiagnostic: SA0PR15MB4016:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB40169D1A2235E47220226267D3349@SA0PR15MB4016.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hy1uLwDx+U/Bb8gx7RiDtUID0eZO1Zx5ju4BEkw3+pgZFBfC+6HH8Yo9HeSZj6IFefK35W3UgjFBTX/dVBTxaNx9a1Pu2XB9rGiBVEr4Z4qVIW9vOIXPCA5SC97J+18H+FKLQE0yDFUheBdkyPqfGOf1fDDFEySD6fzlljCUtvmFV1m7ITc3m/uAMz6E+azNJ8jbQJarBnuZ+OOwCIqMz+bgoaKY+p+cFXlIcBhpDfFa1EcrDvn+QCL8r2uJ5K18Mt2ekPACu+A0BvzMAl8oj0uqddVYZuQhZjE4xVotSXBLkO3JHdWFyUkizRWKguhtKxuVl7+SoCIChYp5LIHrVOJ2qFnF3L+Y25CZTWVKah3dCFvDSnoRvLbi4t3U/n/ScKZramMuicOPI+eA+qyl+SxkdIVXy6A9PBnr4fVvlANpHfV64kZzMLhE3OQR3UDHUAS5FtQbJpwJAImP5SzJP4jqW1hEJgN0XD/41DNHD4HDtWAxgr1N4px923QnonZ4WDXAjlhqdSZO8WvGLWPUTKap5LyK/rRYQ9v8k50e9rC43LaAxPjK8wt8zJC0E3dv+pcSgigpxgalssSvtvsFzAn29AARIFUv43JgTrtru4vY2C1ZZn0gQjKDfl5oQa8I3Lj9udQQ42MdVZYBebi2U6NdmHVQdfbqMelCOHyjsiurSn9/cmiGvl3gn4qsrljL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(8936002)(31696002)(86362001)(8676002)(6486002)(316002)(38100700002)(53546011)(4326008)(16526019)(186003)(5660300002)(66556008)(83380400001)(66476007)(66946007)(31686004)(36756003)(6666004)(2906002)(478600001)(52116002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnJkdUdtT0VxZmZNVDU0MXlBQXZCd1F1VVV6ZEhKaTQ2SmZvR2pydDNoUXE5?=
 =?utf-8?B?SGlKK2JOMEh4ZndtaVFEQU53L0JmWm1KVmpOU0lYMGlUa2Z1dEgvOE03cmVI?=
 =?utf-8?B?RE81NWlHM1pmbTkyaGNkUzhzNUIzektaM2Qwb3RtNXBVWUtqV290YXhGRVJR?=
 =?utf-8?B?WE1WY2RQSEczTkhuajBxVVI5RDhuaGNJaXdjMlpOekxnNVNidXIzOXFTT0lJ?=
 =?utf-8?B?K0VyVDMzS3RCd0RIcE41MzZuVDhpWU5Sck5KbjduK05ldFQxL3dJQVVydHEr?=
 =?utf-8?B?cHNMWk5zcmZvUE1aczNzYkw1bVlxbGdmNHZtbnl0Q1VVTWJiRnU0T09EREJD?=
 =?utf-8?B?TmROdzIrZkNDTGlpZ1hETzVaODZHNDNwa2Z0M2pVdVVvQXNZY3diazg1R1Qv?=
 =?utf-8?B?eFFqRTN6Q1krVlQyNWNzMGlLa2dQdUN6czFqaWo0QXZMZ3JUMlU3UitlK0I1?=
 =?utf-8?B?Z3FYNmp3SkRReEVscDBDZHlFblpaMTdiMVBubWk3bm9VU3pmOWs4L0hULzE2?=
 =?utf-8?B?djZ2bXhsT21KSEdvV29qak5YN2MxN214bWpHMVlONkF5aEtxaWVlSkY3Vm9N?=
 =?utf-8?B?eFpFRE9NUmM0WTlKdlpRazErcDJUcWE1bS9HR3liRUErSjFkeEJuTVFINUdB?=
 =?utf-8?B?bmFzeWt3QWpucURualBRamphdk16ZXFmcmVQc1kwaEhBRzc1VFhOVjZIbmRl?=
 =?utf-8?B?UlJPRWRabmhuTHBoU0huSng5czlueXprMmxTRm1YVm5maUhUL0RQSlJDREYx?=
 =?utf-8?B?SGl0T3ZmZEVUb0JIb0ZkTnRwSDlvWCtGWFNlU0pja3I5NGVXd1p5MkdmWEN6?=
 =?utf-8?B?dVcvSE8ydEp5SXdEaFhBZFZLSlhtc2JIelgvRXFjQ0kvU2tWWUN6UXQ4akh6?=
 =?utf-8?B?blc3SEw1bVhUUm0rVUdRc0pLNmE3dllmT05ZT0RSUmR2Nzh0b0FuVmNCTUpH?=
 =?utf-8?B?RVd4M3dsbldkWDlaRWw0Zy9Zd2crL3JxWW41K3J6aE9iQ3crQnNQV251ekZq?=
 =?utf-8?B?WVlpTkFsTEx6VFNyYW1scUVQNXRMQUphcnQ0WmxHM1J2OUkvYllIT3ZRc1dr?=
 =?utf-8?B?cE1HRjdqRWJ6VXFkU3VKVGZzKythbDR3RkpOTWJlanNoMUR1YVJEOE94dEdG?=
 =?utf-8?B?VFN4Ujdsc2d3elRJREljcjJ2djVDZUxBRkhYTmRCN2ZrekFiU1craG12ZG5y?=
 =?utf-8?B?RUdkcS9oOElORk9TRWd2ZldpOXk1aUVIV0VxWkwyKzFwMGYzZjYvcDJESFFP?=
 =?utf-8?B?YTRaS3p3YnNBZ09UK0NBazV1dzA5Y3UweUY1K2FMeUxhOTRUTzVoQXMzWmUr?=
 =?utf-8?B?NmlINExlZEFsM2tpRXhld2hpSDlqRXlKN1JBUnhCQ3R4aU1GYTNWenYwaWlr?=
 =?utf-8?B?RDc2NWJBcnZyVkJhZHRuY25zSjRhRGtWRzFKNzFRaTJPaDE0ekc1Znh5dWRt?=
 =?utf-8?B?UURFc2FVbXdQdkpoQVVWNytBa085N0VoVDhIQ0VZbHY5T2VQS1NrQ3JCREVE?=
 =?utf-8?B?MSsvT0tkY2ZHWDh5WnE1cXk4dDBESFF5UktyVlVNNkRTMG5KUkl3VXVuRE9q?=
 =?utf-8?B?d2NiZ2FCSXdQUjVnZlFRNlZrU3NWSmVnamZacFpIZW9vZUFkb2xoamFLa0Zu?=
 =?utf-8?B?TGQ2RDdSbW1FQnFXYXZ6V0JQM2s0TzlxNzZlaXozNDk5OVIwVHBKVUlXL1ll?=
 =?utf-8?B?Z2dCVEpibEdwSmxMUDYwVWJEMW1jZFNQSnZiaTlqYWlTdkhKR3ByT1RjR3Qz?=
 =?utf-8?B?cTFOMmp6WE1aMUZER1VmTVBPc0tRSVpzLzlHTk5XZk8rdFR4bnlmZ0lmMDV5?=
 =?utf-8?B?U3RmNVIrL1o2Mk05RnFRQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea1bfa1e-c81c-4811-6480-08d92d25f46f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 22:12:08.8976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mO2hiNgdkJJzRVIwZDAYHcjZmB/W4oMMoiA72LjKADa3EakJQj5O9XSxgTJkaxON
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4016
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: _Zpn9DZOLCEwJfKRScAKIRir9882CNnO
X-Proofpoint-ORIG-GUID: _Zpn9DZOLCEwJfKRScAKIRir9882CNnO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_06:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110137
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
>   
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 2c1ba70abbf1..d25bbcdad8e6 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4778,6 +4778,38 @@ union bpf_attr {
>    * 		Execute close syscall for given FD.
>    * 	Return
>    * 		A syscall result.
> + *
> + * long bpf_timer_init(struct bpf_timer *timer, void *callback_fn, int flags)
> + *	Description
> + *		Initialize the timer to call *callback_fn* static function.
> + *		First 4 bits of *flags* specify clockid. Only CLOCK_MONOTONIC,
> + *		CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
> + *		All other bits of *flags* are reserved.
> + *	Return
> + *		0 on success.
> + *		**-EBUSY** if *timer* is already initialized.
> + *		**-EINVAL** if invalid *flags* are passed.
> + *
> + * long bpf_timer_start(struct bpf_timer *timer, u64 nsecs)
> + *	Description
> + *		Start the timer and set its expiration N nanoseconds from the
> + *		current time. The timer callback_fn will be invoked in soft irq
> + *		context on some cpu and will not repeat unless another
> + *		bpf_timer_start() is made. In such case the next invocation can
> + *		migrate to a different cpu.
> + *	Return
> + *		0 on success.
> + *		**-EINVAL** if *timer* was not initialized with bpf_timer_init() earlier.
> + *
> + * long bpf_timer_cancel(struct bpf_timer *timer)
> + *	Description
> + *		Cancel the timer and wait for callback_fn to finish if it was running.
> + *	Return
> + *		0 if the timer was not active.
> + *		1 if the timer was active.
> + *		**-EINVAL** if *timer* was not initialized with bpf_timer_init() earlier.
> + *		**-EDEADLK** if callback_fn tried to call bpf_timer_cancel() on its own timer
> + *		which would have led to a deadlock otherwise.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -4949,6 +4981,9 @@ union bpf_attr {
>   	FN(sys_bpf),			\
>   	FN(btf_find_by_name_kind),	\
>   	FN(sys_close),			\
> +	FN(timer_init),			\
> +	FN(timer_start),		\
> +	FN(timer_cancel),		\
>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> @@ -6061,6 +6096,11 @@ struct bpf_spin_lock {
>   	__u32	val;
>   };
>   
> +struct bpf_timer {
> +	__u64 :64;
> +	__u64 :64;
> +};
> +
>   struct bpf_sysctl {
>   	__u32	write;		/* Sysctl is being read (= 0) or written (= 1).
>   				 * Allows 1,2,4-byte read, but no write.
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 544773970dbc..3a693d451ca3 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -985,6 +985,227 @@ const struct bpf_func_proto bpf_snprintf_proto = {
>   	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
>   };
>   
> +struct bpf_hrtimer {
> +	struct hrtimer timer;
> +	struct bpf_map *map;
> +	struct bpf_prog *prog;
> +	void *callback_fn;
> +	void *value;
> +};
> +
> +/* the actual struct hidden inside uapi struct bpf_timer */
> +struct bpf_timer_kern {
> +	struct bpf_hrtimer *timer;
> +	struct bpf_spin_lock lock;
> +};

Looks like in 32bit system, sizeof(struct bpf_timer_kern) is 64
and sizeof(struct bpf_timer) is 128.

struct bpf_spin_lock {
         __u32   val;
};

struct bpf_timer {
	__u64 :64;
	__u64 :64;
};

Checking the code, we may not have issues as structure
"bpf_timer" is only used to reserve spaces and
map copy value routine handles that properly.

Maybe we can still make it consistent with
two fields in bpf_timer_kern mapping to
two fields in bpf_timer?

struct bpf_timer_kern {
	__bpf_md_ptr(struct bpf_hrtimer *, timer);
	struct bpf_spin_lock lock;
};

> +
> +static DEFINE_PER_CPU(struct bpf_hrtimer *, hrtimer_running);
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
[...]
