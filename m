Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E60656948F
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbiGFVh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbiGFVh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:37:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69275243;
        Wed,  6 Jul 2022 14:37:56 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266L6jVu018381;
        Wed, 6 Jul 2022 14:37:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=XX6kf2j2rPfykWxM38mOYpW3pPysmCibPlkgvt5Fqnk=;
 b=Bt4HEIA5V9GHcmcASVwkOpKV3L27JYIHdwwy5hIOyV8arJiy9PRiMTF2LoVHP4YXauJh
 Q0DJ28+1qaeqWtWe9C/vqzJzRVKJ7MqHB3qOJKlRTI0mkRHzxQwj3h5yBUdo/NFp8q39
 YjeX25xHKg8iF/epqNNXfpKiYxh3G3EyVwY= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h4uaqh7t5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 14:37:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8nRfxUOnYK0DeN8P2+68vaGbjwq6GCyRq/iCuD1XMovcsRDXeUdgPpid4FTHgtgbrhPMThxEowsqXOPqbESRgOM3JoMzyNS/+yYAfYX1Xk4TumtslGeOcEuwC/H/1j7lO8VQi1bfbKMH/xQpFj6/XkwwgfOJ7IjKN8FtB/pUoMOpWUz1p0FW2/We7J2NNhCQ/q7HSYhZ/VkLkA/MUpxIY2KFCXiv0fYy+0c8nDMgk9CnqJhmUOrsPUqjLLbJjcHmcAlCQQ/ExTBOy3AS/zrf0ssVedZ70Ff4Tj0G3mtGHLBgQjxBvRh0YK3E5x+JRuVklJA3gF/bsgZXC6jXkagOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XX6kf2j2rPfykWxM38mOYpW3pPysmCibPlkgvt5Fqnk=;
 b=STWoQtum1V12Csd7JgW9X5z99pgS6YMNY8dQnosKQMPBZeag/cfNykj84luFVfX54LWZmiNCrZ+kuC7/8x28SrN5Rxrq2W2w41jAwC4gPxtZZzna1tk+6eHr4DBWdFgkZP6H2vCSUOkqfVJY1H4OmNNmfNMqj/z2V/xBm2DzRCHc0fkLvzNxGFlOgBojglUQDjwyOm4NmozCHAOexPLRHJAsMYYgIxZf3499zUW1mfydi7LyUsLNYzmPwWfPHGJHld2T5HA6tBcz5ipVhQm5g8yv2zxgzGlbIrYIbqJaLJ6ndYq097EbBmeJvJtS97bstvlY5JYfuwATr+LGQltd0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MN2PR15MB2592.namprd15.prod.outlook.com (2603:10b6:208:124::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Wed, 6 Jul
 2022 21:37:52 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a%7]) with mapi id 15.20.5417.016; Wed, 6 Jul 2022
 21:37:52 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Topic: [PATCH v2 bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Index: AQHYdrj21zA3ifq/PEC7Yw0zyJbSw61x8o6AgAAhSYA=
Date:   Wed, 6 Jul 2022 21:37:52 +0000
Message-ID: <DC04E081-8320-4A39-A058-D0E33F202625@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-6-song@kernel.org>
 <20220706153843.37584b5b@gandalf.local.home>
In-Reply-To: <20220706153843.37584b5b@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5ea30de-23c6-4649-4f61-08da5f97c7b8
x-ms-traffictypediagnostic: MN2PR15MB2592:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mV26P2zzlzHNyg/6HAEtG7FScqmxjTZPXDsTd+5a2l0h7mBU52b6eTCuBYtWB7lgdhE9X9rGrn7dNNmXz0ZQmr7kFFmcRoa6bBmM836DcXJ1jB+1YkC2FDa46qV8VZbM6gJFOwxHpiZdYHVhn1cE2MxhwPUH11P/fC5nTj5YIcwQQ2hQk4Jal1Z0JsicCx2RwfV2Vcc+h0GX1OpYhUbTNasETDBj4tKW2PNVgSRFMFY/wXdh0sPzrpgkpXq3kp8dZ43BC+SubYuHOy/b3ztLnYqtZSuG5lBj16BYkLx6LrNLsxGUT7uJRQlMIqVYXJI6HjQdej4L6fmIFkIEQJaLjwYTzc2S+VOxarxQvol/b6u9sPHT9FZpttnfkkDGUab/ksPx9qAVD7Jx4YLiNy8W1RKMZ9ujMbQ/1aFq80dlvpByeQWRZNG8/rIOlOVVy+omFHijfYRmQi0XFdAkaAGHBeuIHbOljH7lNwNL/38N7LHlkI56CT06PE9UKX7Dm7Uoe2i6yR9GAHyB8pLAMMxVaZhbX7ELlO6BB90WPeh9uM8RVp47TTTmNKBmR8HzLVtc2Ca6GXvn/w7BtaI63ag5nwUrtvdT+1dh2oxJHrTwx3zWmPILbN5ZPvsppTVaXjyzGWJBweg3wTBc2fUf0J39cughitjkcfMEnMetJFRsfo+FYhi1LFGay7yhBrCvtI762uxPnO94xnhgVUig0eDJre9YU5U+onE617ztFkjm3tlReSaNO94v9/cAXLGZyVJByW1qL/uhyEwFwxWrh18M5qNZ7rTXPpgCmJGSJDt1VhRgB+C5TYhnQOHqGmN2YKjTiW59Eqhrh6vp4XAcOKRg0ug6fp1UHwGOVdfviSwm2o0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(6512007)(91956017)(66946007)(76116006)(66446008)(2906002)(8676002)(71200400001)(64756008)(66556008)(6486002)(5660300002)(83380400001)(41300700001)(66476007)(4326008)(7416002)(8936002)(2616005)(478600001)(33656002)(186003)(53546011)(6916009)(316002)(36756003)(6506007)(54906003)(122000001)(86362001)(38100700002)(38070700005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NrK8Pf33SoNm+uMeLQ0XCfCOv0dkQ/H+9xWN6ShF61VGzVI6oCQzmDPz6qnC?=
 =?us-ascii?Q?5DZXK4bPrKJFHyodYP66sZYBMMrrV22ftJhzT5YCOnbgDmRR41hMTToMVym+?=
 =?us-ascii?Q?qAAop3TBJhY0cE2+3rgye+ovTRZ7A4tQl/fUNWzIG6zP3UJxRnGCwNdK95Hp?=
 =?us-ascii?Q?RKRrRZ5f1eNppKBC9hvLcYIsUhdv8GSdAFVj4GiKRSI5hZCM+51R6O7TjKx3?=
 =?us-ascii?Q?MZwuGbtgupU33IXLCIi4VpSEJ5PnSpyiJlyEXPAd8igNe9gkmIDxEWrfXAka?=
 =?us-ascii?Q?iY7XrgejRxXinO8FgBjHk8+EtmggZIdUuDlGsLnUtTzKcWopNBQwf9z6gyEx?=
 =?us-ascii?Q?zpic/DcqGxneHgAc+KZFCg/23X0D0z2HtyZ9g/KIMnH2xOfg1yu45J9YXH2n?=
 =?us-ascii?Q?uTW4y5giLZbc3K73AsHry0Xp/Uxe1gM5PM5xYfJO9y5QcS98GndGzedqiAlp?=
 =?us-ascii?Q?sQWmeHPWW647rcmS39r7hEV5+F4n1m5RxeXj44WlOa3rwrwwTIQ+PsCgMidE?=
 =?us-ascii?Q?uW0tjecQ3VHQDperUD+2h8USoWae7xlZxm7iwJQCr5S3GTTlo0oUcxPHbrIH?=
 =?us-ascii?Q?vvfSfJUcECviMHph7DNra8n6uGPKvKeYHeGDCv3kTWtePvnlRaap3TmMp69v?=
 =?us-ascii?Q?eYQ2IdyYt1Dl+DuJOtSWIPUUvkpiyBCEkz8n/6iZSQ4jUbQSGN22qb5nkbFY?=
 =?us-ascii?Q?GxT0Th6NLODIvlFQnB035YWJ4NiKoVY9xtnaTD+d9gsk+/e0al6+MraNqkNL?=
 =?us-ascii?Q?Qj4SbJIZHvTIBeisrEf2+DktypIe4DP3TN/U/mvpYDecTNF24oILHp6xEP4m?=
 =?us-ascii?Q?zBayGe/XSeJPqK2x6crPa/5AyIxY5zcz3qv496HoOu39tz1fp+yFueNltybh?=
 =?us-ascii?Q?e218qI04AhZDoHmxLXJ1Zbd7EczrIcRLumYL60VUgp/qFmk9m7SKcjEsPdwi?=
 =?us-ascii?Q?hZ1Ru7tGUfshiY5L7ZD4o4+G15d1o3FqBmJw4hYSTUFUxe0tuUk/2jvNtJwm?=
 =?us-ascii?Q?ncQIK2VlvCpLy3WxUa85P8lkkXVvovG0eH78j/hxvc/nN1i6971My9NacOUc?=
 =?us-ascii?Q?v7oqIC1EIacSYo0II0y/l7xOTe/Mab2rvl5Yw0CnI8MrZPjt6fwu4CO1S0Tk?=
 =?us-ascii?Q?QbgxLy/K4zg7i0Vz88++hE2aGsA3p7VO27qT1+1f1M4gQ2hKbzjI7FUZ/Lfc?=
 =?us-ascii?Q?A+pQ6RIX4i0lnuvLoDAv5HD8HjF2nxyUWI9JGH4waDSL+z4PWMf2QSsj7PDH?=
 =?us-ascii?Q?NSRVAByZyWoybl8FiiKOabPlh7OtUAAsfkTM0c4b8PXY3scXqiXUBv/oEfYQ?=
 =?us-ascii?Q?2a2150EXcQwfBJZ2Yu7mm05fYUgdc3MRo5YML/5NZWZeRliawvFZcD1BbfqW?=
 =?us-ascii?Q?67V2IN9c6i5f7w5iGJFTcDB89kTEzVlSUKWTSqB1E6NXr0q2hHKwAhHdyozs?=
 =?us-ascii?Q?5xv0Pnyhuc3d8mbAG8VU0kgOB1FOR4jBCkSTmb6xrQP8QisjI5UuTO6dV30K?=
 =?us-ascii?Q?hkJTVcH8KNQSbruAs1V315WMoZwth+EydxZyLwH90dfbQWS2oybMXixIa8F9?=
 =?us-ascii?Q?q26ps9MfUhtG1lzA5zO8+J0S//7+GLAYrEYDesjYomU1X8/+wTDOe+D2zj0e?=
 =?us-ascii?Q?fV0q83Ev7bG7srJ/IR2hJps=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CCE7DB601C818D48A6518DD234ACED5C@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ea30de-23c6-4649-4f61-08da5f97c7b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 21:37:52.1323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QZBwwhom4lU/RAceDtkOFjGZJsUTC8t190TYmGW3juG+xaPsZFlkQZpk0ZwVDmmxwLvggmHxA1ZZeokFrN0WvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2592
X-Proofpoint-GUID: bRBJb9IwIeE1k8wLwLP9kDd6TKY8Z2Qg
X-Proofpoint-ORIG-GUID: bRBJb9IwIeE1k8wLwLP9kDd6TKY8Z2Qg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_12,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 6, 2022, at 12:38 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Thu, 2 Jun 2022 12:37:06 -0700
> Song Liu <song@kernel.org> wrote:
> 
> 
>> --- a/kernel/bpf/trampoline.c
>> +++ b/kernel/bpf/trampoline.c
>> @@ -27,6 +27,44 @@ static struct hlist_head trampoline_table[TRAMPOLINE_TABLE_SIZE];
>> /* serializes access to trampoline_table */
>> static DEFINE_MUTEX(trampoline_mutex);
>> 
>> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> +static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mutex);
>> +
>> +static int bpf_tramp_ftrace_ops_func(struct ftrace_ops *ops, enum ftrace_ops_cmd cmd)
>> +{
>> +	struct bpf_trampoline *tr = ops->private;
>> +	int ret;
>> +
>> +	/*
>> +	 * The normal locking order is
>> +	 *    tr->mutex => direct_mutex (ftrace.c) => ftrace_lock (ftrace.c)
>> +	 *
>> +	 * This is called from prepare_direct_functions_for_ipmodify, with
>> +	 * direct_mutex locked. Use mutex_trylock() to avoid dead lock.
>> +	 * Also, bpf_trampoline_update here should not lock direct_mutex.
>> +	 */
>> +	if (!mutex_trylock(&tr->mutex))
> 
> Can you comment here that returning -EAGAIN will not cause this to repeat.
> That it will change things where the next try will not return -EGAIN?

Hmm.. this is not the guarantee here. This conflict is a real race condition 
that an IPMODIFY function (i.e. livepatch) is being registered at the same time 
when something else, for example bpftrace, is updating the BPF trampoline. 

This EAGAIN will propagate to the user of the IPMODIFY function (i.e. livepatch),
and we need to retry there. In the case of livepatch, the retry is initiated 
from user space. 

> 
>> +		return -EAGAIN;
>> +
>> +	switch (cmd) {
>> +	case FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY:
>> +		tr->indirect_call = true;
>> +		ret = bpf_trampoline_update(tr, false /* lock_direct_mutex */);
>> +		break;
>> +	case FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY:
>> +		tr->indirect_call = false;
>> +		tr->fops->flags &= ~FTRACE_OPS_FL_SHARE_IPMODIFY;
>> +		ret = bpf_trampoline_update(tr, false /* lock_direct_mutex */);
>> +		break;
>> +	default:
>> +		ret = -EINVAL;
>> +		break;
>> +	};
>> +	mutex_unlock(&tr->mutex);
>> +	return ret;
>> +}
>> +#endif
>> +
>> 
> 
> 
>> @@ -330,7 +387,7 @@ static struct bpf_tramp_image *bpf_tramp_image_alloc(u64 key, u32 idx)
>> 	return ERR_PTR(err);
>> }
>> 
>> -static int bpf_trampoline_update(struct bpf_trampoline *tr)
>> +static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mutex)
>> {
>> 	struct bpf_tramp_image *im;
>> 	struct bpf_tramp_links *tlinks;
>> @@ -363,20 +420,45 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
>> 	if (ip_arg)
>> 		flags |= BPF_TRAMP_F_IP_ARG;
>> 
>> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> +again:
>> +	if (tr->indirect_call)
>> +		flags |= BPF_TRAMP_F_ORIG_STACK;
>> +#endif
>> +
>> 	err = arch_prepare_bpf_trampoline(im, im->image, im->image + PAGE_SIZE,
>> 					  &tr->func.model, flags, tlinks,
>> 					  tr->func.addr);
>> 	if (err < 0)
>> 		goto out;
>> 
>> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> +	if (tr->indirect_call)
>> +		tr->fops->flags |= FTRACE_OPS_FL_SHARE_IPMODIFY;
>> +#endif
>> +
>> 	WARN_ON(tr->cur_image && tr->selector == 0);
>> 	WARN_ON(!tr->cur_image && tr->selector);
>> 	if (tr->cur_image)
>> 		/* progs already running at this address */
>> -		err = modify_fentry(tr, tr->cur_image->image, im->image);
>> +		err = modify_fentry(tr, tr->cur_image->image, im->image, lock_direct_mutex);
>> 	else
>> 		/* first time registering */
>> 		err = register_fentry(tr, im->image);
>> +
>> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
>> +	if (err == -EAGAIN) {
>> +		if (WARN_ON_ONCE(tr->indirect_call))
>> +			goto out;
>> +		/* should only retry on the first register */
>> +		if (WARN_ON_ONCE(tr->cur_image))
>> +			goto out;
>> +		tr->indirect_call = true;
>> +		tr->fops->func = NULL;
>> +		tr->fops->trampoline = 0;
>> +		goto again;
> 
> I'm assuming that the above will prevent a return of -EAGAIN again. As if
> it can, then this could turn into a dead lock.
> 
> Can you please comment that?

This is a different case. This EAGAIN happens when the live patch came first, 
and we register bpf trampoline later. By enabling tr->indirect_call, we should
not get EAGAIN from register_fentry. 

I will add more comments for both cases. 

Thanks,
Song

