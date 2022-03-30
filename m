Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93D54EB77C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 02:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240987AbiC3AlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 20:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbiC3AlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 20:41:14 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8C3182AD2;
        Tue, 29 Mar 2022 17:39:29 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22U0cWUd005159;
        Tue, 29 Mar 2022 17:39:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=Cv4h1EPNor/OE0p0A/4CC/MCoHOXSy2Nf3rFWa20b00=;
 b=LlYkpN0vQVjb/R3m5hIkedVWibZIUjZcOXiRk3NeOW5nI8/X0macISuVywIOCRDCN6/k
 zClUrtA5ifmQHCwQuHYSMqQ7VRhk0YYvFut7UF6dvzxIIPN3xObYENIRtfwayGVdzQad
 BnEDmJGqqCkWoKdYll82pCX3EHZeYLomzhA= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f3takf8by-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 17:39:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fpd1LC/iLFt4j9WJ8rhIJ3fSkLIdjUTxhD6ls7NwRImD12QiW7nkybf8FMVoIhpvSf2Ic7Kenw0tBuEIj1yMuGXvYF+ugtkOQ1+dTQO+LZ+AvItxPn/PFXjCuBLGdLBWIApwuvKCWqSxXKBOiIgfCre/MAusvlVUB1UA9MFgFpr/AuQfx20nGk1AVt/hzqA4S25sqOAv6PC8Hd4+9P+aoDZQ7VCKkeMWURAAz/KSLpYbXxfQDBBLVX7QtKG6IXVt0VXJzPDV9w0Clzx0JeB3xnf6ksCnG/GR67otch1Vig4Y0+ul0iInZNRM+r3O0KWSNwmu99i/4pgc2fQYmVQJoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cv4h1EPNor/OE0p0A/4CC/MCoHOXSy2Nf3rFWa20b00=;
 b=lHfZs0XRg7IjlZrhP1eyC7TsgQFg+zxfJ7n8brJS4Djarg8ybUQ9S6d8hm9Ae6qzDQC1jrX6BTsUMZw6k+fw+ovPpw9l273DcrrsqPVHREvm5S+zyp29zZS7+eYe0NMmJrruXWnwN9zjL9M8OrlVpijN/W2GMjewZGEKXVlhrmCOP64QVzAGxGi/sJTQKClb4p5iqL4Sac6VJbo62MbPOhM9DXX/bo0i3sRikrdLyCzfC1dKDFOA/MDQWfHVmEsamHT6iJvGCfMnd0M2vVtu5Tk35Yc2JGCIsYhK5xySmcJoxXHmwR2XgV3Zjg8rSgprz01PMmpv5Hww6z3DPVWXng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MN2PR15MB2878.namprd15.prod.outlook.com (2603:10b6:208:e9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.23; Wed, 30 Mar
 2022 00:39:19 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4%3]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 00:39:19 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] tools/runqslower: fix handle__sched_switch for
 updated tp sched_switch
Thread-Topic: [PATCH bpf] tools/runqslower: fix handle__sched_switch for
 updated tp sched_switch
Thread-Index: AQHYQ8NoYshikhsCNUuid70h4G7GUqzXCr4AgAAK54A=
Date:   Wed, 30 Mar 2022 00:39:19 +0000
Message-ID: <53E87B8F-6BB1-42AB-965B-096C86236926@fb.com>
References: <20220329231854.3188647-1-song@kernel.org>
 <CAEf4BzZCLwzrZPTOBEg88i1Tki6uPL73ujSE-SCSSU16HENUHA@mail.gmail.com>
In-Reply-To: <CAEf4BzZCLwzrZPTOBEg88i1Tki6uPL73ujSE-SCSSU16HENUHA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e47856c-71e5-472b-31e2-08da11e5ba07
x-ms-traffictypediagnostic: MN2PR15MB2878:EE_
x-microsoft-antispam-prvs: <MN2PR15MB2878FAF4DAD99F9252D6897DB31F9@MN2PR15MB2878.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W3duk+U5HKYPyuuwuitp4go8kJaoX/dcgMRT5IZSF/qd645bP3fj3/IoPCLCP9pOIvGy7xNcKXPBlTbsLoabIRy4cwgAZ9V08TbVV4F34GWx3WJbJrjMPzZdWhG31G/XC5Q7kkBOpnWlFrWzTxdE7GRaMPwqk26/fGEs96JUmiWlHvoWziPnkUkOBCytJZ783EZrTUEl5s7pWymhtpjSjzBJquoFCWlao0zd9GYlT7Q8zpbAUzL+IjR24zDlVC52xJFoULGMZv0IZul+smjYli/C4+ZZmeeyBtsIFebNPBCsjtFc7T0hyqvP3TKejSb8dGNfnP4CplJaYs7sZdc5QBkRCzYlXV33UeVMPr61D8SSA0AXz7E5ODiX2BcYDwBNJH9L/0MaAasKzy2UsY/EhCOT7VbK9BrKYutbmKbv2r+/eKq+ZQBEUal/IZn31H4Qoj5mHDC4D13sKLjyad3kBDBd+fU5TAeVstZ+9WRCPl4roWUA7vBrZAtlBWxJlxsN3HskmD4LmjzDMSpsV6C6AdyQh/8TnvzK1dmiYqwm8yXa8MQM9/8ZWaLIB1SN8mH5KxqqMKKsvLGAHFZhWVY1kfa93rXd5U7eXz/feMfJJPZVEXJDfoGFGp3BHpxRv5/eaYfYyY/qFAIX8j+nOnSo1PRwOLLYedkuTGED9WE6bNID1twaMknMxByhrAG6nrSsm5dLiA7jDXAsNGpMj3SMn6///WNFTykMSXwA3ygQQ409mvF9fu7j2uaDjoTvb1jVl5vAoTlKxqQZD760ZzD5fQ0t8VZkN8vt+dYLVoQ3xdCTD5J3DtJaK9h1sdVpQsBBpkJTsMK171TNXe3RSltMz3DJsUNhsG3ZXMZKHMdv5c8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(186003)(36756003)(91956017)(966005)(6486002)(86362001)(66446008)(38100700002)(66556008)(66946007)(53546011)(66476007)(76116006)(64756008)(8936002)(2616005)(54906003)(122000001)(6512007)(38070700005)(110136005)(8676002)(316002)(33656002)(71200400001)(6506007)(508600001)(2906002)(4326008)(5660300002)(15650500001)(101420200003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HSZw+Ez04HgouKV+RTFVWbAQEx7T35kggLhO9pknYKz8qNWB9sWQ3O56lN++?=
 =?us-ascii?Q?GDmZMSWl8H2MN6AzYx6+1wHfmJs1ybvIcfDJvExcyMYweezV0soPsfSzFyjj?=
 =?us-ascii?Q?1GwEgZUAaIsSKc555Akw1E534B8J++2xpd8y6elRwoKUbbMK2UVV+qGdZ3w7?=
 =?us-ascii?Q?d1c4vjWPVb/SCbP6oBmknTEjYYoj/4g26GVzfiDgdHm+M3dyIz3pxmiXzwsE?=
 =?us-ascii?Q?P48MwcO1ZnqQSa0Bh8e9ILLzGvIccnFnd43725fNA8H3Oo4YPu1XpFMR3YQ9?=
 =?us-ascii?Q?N9ERLVGlrs2P/VD81S2iNBUUjLURok6/7cRaCc6Qet7bbFl6XzQ+4O48eyZe?=
 =?us-ascii?Q?bDrAjImOZnOR7ynGdNtjY4Ujl5N4VYc16ACz6V65H0HcRyVXfa3vDoI+N08b?=
 =?us-ascii?Q?Idwg7jfACDnyhyi8oKCZM+ADrGsYjCaz1E0Z70i1wBLDDmKyVB0UOe62hJxk?=
 =?us-ascii?Q?rUbQFn81MD6hIxWG68qeaX4/bba27uOmgigTsWH9LquXv+OirMTtYy3KI55W?=
 =?us-ascii?Q?0rjE+BRKbfQiFhpzVeopuTa1x4dvnGz0bKYXbbgozb9MdVtC4GTdVKh6kyTS?=
 =?us-ascii?Q?0CJ0+vCQz37xFP8PpnDGS0/DrESvCdkiMKEEe9gPlZ3WAPhFk0B6iYr8KYUv?=
 =?us-ascii?Q?64rKGWnBpZPGjvxEOoha9r5pWOpnSP7b9RHdIpwvUpIq4O9nQW6gpo1g41w7?=
 =?us-ascii?Q?/z3ja5AXamkq1XPgQSV2ge2RKcggsgXssvU5GS1b208C8K2jiaWHvC0rziVx?=
 =?us-ascii?Q?+aX8aa577+bx0g7o68LJkY6gH93nghj9iiBnUb3MS34a966AxLevhT1Tw52h?=
 =?us-ascii?Q?t0pXKU7u7Yvn8w+K2U8/G3gntri/EBJDXaKwC4w38l0VUunofZqkuWTJbzYL?=
 =?us-ascii?Q?pCYMcEEvE6cyUMwqUl53STHjXPTpzww0yzGNsdG0FW0KhWxhUAH6SkdVR0eS?=
 =?us-ascii?Q?Q/Le5/CcRjn6F07IRKsAz9ZLILQQ1eAGvkdiTZ+o/EDkb4+Zk1VZexVYzKGF?=
 =?us-ascii?Q?wbVsxgouJibCUUpstAO8ZfZabVCgfALhJ3F/Sr4/zYweWdC/3hc6gVsf1hRy?=
 =?us-ascii?Q?F/gUxD0jsMPOSDJGHgB1Qi2fMmV58XpwjPkkpsBZzpYIh6Mp7Mw1GNrX6gO0?=
 =?us-ascii?Q?OeVZUmdPXUN4vXFHQyAauhGP1m4qq3GbwOKEoKWIe2tKbjOFhRupGf5j2d2J?=
 =?us-ascii?Q?kKY/HtbHWZXbUk7COomtgOoptZF3xawvd8XjPxyTunFHvsTLdBY7zjreUPVs?=
 =?us-ascii?Q?wdbQlLbl5noGyM5Bopg2ARDM0CflutvJIkwXgFmgjRIaFOKHE2G4k8THcjzq?=
 =?us-ascii?Q?mjicVmYuiB9ZUrWUmvVWGX5Hi4T+XSTYhsSbD/w0XUvpAe7tEn/+RczGIQ7U?=
 =?us-ascii?Q?wTB0V3mWv2uCP2ocgkuUV90z26Sw8tel0Y+MqoV5VVySs9b9FrmDmePrFpxj?=
 =?us-ascii?Q?ZIOb9JXtZQQsFKqpEoGVvXBnkN+TwY2NIRoY/sGuS4lanEvPVhkvn+cWRVlN?=
 =?us-ascii?Q?o+5vhMi/BEFWDiboqV0JOOXjUlR0vnissLoYDKeCCsw9iwN7ib7CKmRvUMgN?=
 =?us-ascii?Q?fyvjU/4dmT6LONvOSheXZ/rTU2N4hWGCkKy0aLRJORc/f3fNOPzaE2I/GScF?=
 =?us-ascii?Q?SvedQ2aj3FdweAEdr5iY4jWdVJB72Lgg1FNaaWcm9CzyXspklacKq9Y+qQHU?=
 =?us-ascii?Q?u8bTP3fLSyxRChVgakGDXhODWYjLOF7NxkkITkF4ZnigN5aNu/z88kfrHzy5?=
 =?us-ascii?Q?FF5BAU+7NLzzhUgOYWtoNVHVaOdHCw7nqiB2IxlR/V9Vl5LFaW34?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2BAD6D213EA7BD419BFE71E22D3028FD@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e47856c-71e5-472b-31e2-08da11e5ba07
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2022 00:39:19.1625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hdg7+GaTFr52XCZ01zodDcP3EV+AXoLr1D5Bqo3kC5KD+aUIG52jeBB+ofZibftY8/AP64by+cHNtX3FqV387Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2878
X-Proofpoint-GUID: yu7fBCdomUWhhqZ2wn_c7RrlQ6nePLmq
X-Proofpoint-ORIG-GUID: yu7fBCdomUWhhqZ2wn_c7RrlQ6nePLmq
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-29_10,2022-03-29_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 29, 2022, at 5:00 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> 
> On Tue, Mar 29, 2022 at 4:19 PM Song Liu <song@kernel.org> wrote:
>> 
>> TP_PROTO of sched_switch is updated with a new arg prev_state, which
>> causes runqslower load failure:
>> 
>> libbpf: prog 'handle__sched_switch': BPF program load failed: Permission denied
>> libbpf: prog 'handle__sched_switch': -- BEGIN PROG LOAD LOG --
>> R1 type=ctx expected=fp
>> 0: R1=ctx(off=0,imm=0) R10=fp0
>> ; int handle__sched_switch(u64 *ctx)
>> 0: (bf) r7 = r1                       ; R1=ctx(off=0,imm=0) R7_w=ctx(off=0,imm=0)
>> ; struct task_struct *next = (struct task_struct *)ctx[2];
>> 1: (79) r6 = *(u64 *)(r7 +16)
>> func 'sched_switch' arg2 has btf_id 186 type STRUCT 'task_struct'
>> 2: R6_w=ptr_task_struct(off=0,imm=0) R7_w=ctx(off=0,imm=0)
>> ; struct task_struct *prev = (struct task_struct *)ctx[1];
>> 2: (79) r2 = *(u64 *)(r7 +8)          ; R2_w=scalar() R7_w=ctx(off=0,imm=0)
>> 3: (b7) r1 = 0                        ; R1_w=0
>> ; struct runq_event event = {};
>> 4: (7b) *(u64 *)(r10 -8) = r1         ; R1_w=P0 R10=fp0 fp-8_w=00000000
>> 5: (7b) *(u64 *)(r10 -16) = r1        ; R1_w=P0 R10=fp0 fp-16_w=00000000
>> 6: (7b) *(u64 *)(r10 -24) = r1        ; R1_w=P0 R10=fp0 fp-24_w=00000000
>> 7: (7b) *(u64 *)(r10 -32) = r1        ; R1_w=P0 R10=fp0 fp-32_w=00000000
>> ; if (prev->__state == TASK_RUNNING)
>> 8: (61) r1 = *(u32 *)(r2 +24)
>> R2 invalid mem access 'scalar'
>> processed 9 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
>> -- END PROG LOAD LOG --
>> libbpf: failed to load program 'handle__sched_switch'
>> libbpf: failed to load object 'runqslower_bpf'
>> libbpf: failed to load BPF skeleton 'runqslower_bpf': -13
>> failed to load BPF object: -13
>> 
>> Update runqslower to fix this issue. Also, as we are on this, use BPF_PROG
>> in runqslower for cleaner code.
>> 
>> Fixes: fa2c3254d7cf ("sched/tracing: Don't re-read p->state when emitting sched_switch event")
>> Signed-off-by: Song Liu <song@kernel.org>
>> ---
>> tools/bpf/runqslower/runqslower.bpf.c | 19 +++++--------------
>> 1 file changed, 5 insertions(+), 14 deletions(-)
>> 
> 
> It would be much less disruptive if that prev_state was added after
> "next", but oh well...

Maybe we should change that. 

+Valentin and Steven, how about we change the order with the attached 
diff (not the original patch in this thread, but the one at the end of 
this email)?

> 
> But anyways, let's handle this in a way that can handle both old
> kernels and new ones and do the same change in libbpf-tool's
> runqslower ([0]). Can you please follow up there as well?

Yeah, I will also fix that one. 

> 
> 
> We can use BPF CO-RE to detect which order of arguments running kernel
> has by checking prev_state field existence in struct
> trace_event_raw_sched_switch. Can you please try that? Use
> bpf_core_field_exists() for that.

Do you mean something like

if (bpf_core_field_exists(ctx->prev_state))    
    /* use ctx[2] and ctx[3] */
else
    /* use ctx[1] and ctx[2] */

? I think we will need BTF for the arguments, which doesn't exist yet.
Did I miss something? 

I was thinking about adding something like struct tp_sched_switch_args 
for all the raw tracepoints, but haven't got time to look into how. 

Thanks,
Song

> 
> 
>  [0] https://github.com/iovisor/bcc/blob/master/libbpf-tools/runqslower.bpf.c
> 
> 
>> diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
>> index 9a5c1f008fe6..30e491d8308f 100644
>> --- a/tools/bpf/runqslower/runqslower.bpf.c
>> +++ b/tools/bpf/runqslower/runqslower.bpf.c
>> @@ -2,6 +2,7 @@
>> // Copyright (c) 2019 Facebook
>> #include "vmlinux.h"
>> #include <bpf/bpf_helpers.h>
>> +#include <bpf/bpf_tracing.h>
>> #include "runqslower.h"
>> 
>> #define TASK_RUNNING 0
>> @@ -43,31 +44,21 @@ static int trace_enqueue(struct task_struct *t)
>> }
>> 
>> SEC("tp_btf/sched_wakeup")
>> -int handle__sched_wakeup(u64 *ctx)
>> +int BPF_PROG(handle__sched_wakeup, struct task_struct *p)
>> {
>> -       /* TP_PROTO(struct task_struct *p) */
>> -       struct task_struct *p = (void *)ctx[0];
>> -
>>        return trace_enqueue(p);
>> }
>> 
>> SEC("tp_btf/sched_wakeup_new")
>> -int handle__sched_wakeup_new(u64 *ctx)
>> +int BPF_PROG(handle__sched_wakeup_new, struct task_struct *p)
>> {
>> -       /* TP_PROTO(struct task_struct *p) */
>> -       struct task_struct *p = (void *)ctx[0];
>> -
>>        return trace_enqueue(p);
>> }
>> 
>> SEC("tp_btf/sched_switch")
>> -int handle__sched_switch(u64 *ctx)
>> +int BPF_PROG(handle__sched_switch, bool preempt, unsigned long prev_state,
>> +            struct task_struct *prev, struct task_struct *next)
>> {
>> -       /* TP_PROTO(bool preempt, struct task_struct *prev,
>> -        *          struct task_struct *next)
>> -        */
>> -       struct task_struct *prev = (struct task_struct *)ctx[1];
>> -       struct task_struct *next = (struct task_struct *)ctx[2];
>>        struct runq_event event = {};
>>        u64 *tsp, delta_us;
>>        long state;
>> --
>> 2.30.2



diff --git i/include/trace/events/sched.h w/include/trace/events/sched.h
index 65e786756321..fbb99a61f714 100644
--- i/include/trace/events/sched.h
+++ w/include/trace/events/sched.h
@@ -222,11 +222,11 @@ static inline long __trace_sched_switch_state(bool preempt,
 TRACE_EVENT(sched_switch,
 
 	TP_PROTO(bool preempt,
-		 unsigned int prev_state,
 		 struct task_struct *prev,
-		 struct task_struct *next),
+		 struct task_struct *next,
+		 unsigned int prev_state),
 
-	TP_ARGS(preempt, prev_state, prev, next),
+	TP_ARGS(preempt, prev, next, prev_state),
 
 	TP_STRUCT__entry(
 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
diff --git i/kernel/sched/core.c w/kernel/sched/core.c
index d575b4914925..25784f3efd81 100644
--- i/kernel/sched/core.c
+++ w/kernel/sched/core.c
@@ -6376,7 +6376,7 @@ static void __sched notrace __schedule(unsigned int sched_mode)
 		migrate_disable_switch(rq, prev);
 		psi_sched_switch(prev, next, !task_on_rq_queued(prev));
 
-		trace_sched_switch(sched_mode & SM_MASK_PREEMPT, prev_state, prev, next);
+		trace_sched_switch(sched_mode & SM_MASK_PREEMPT, prev, next, prev_state);
 
 		/* Also unlocks the rq: */
 		rq = context_switch(rq, prev, next, &rf);
diff --git i/kernel/trace/fgraph.c w/kernel/trace/fgraph.c
index 19028e072cdb..d7a81d277f66 100644
--- i/kernel/trace/fgraph.c
+++ w/kernel/trace/fgraph.c
@@ -415,9 +415,10 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 
 static void
 ftrace_graph_probe_sched_switch(void *ignore, bool preempt,
-				unsigned int prev_state,
 				struct task_struct *prev,
-				struct task_struct *next)
+				struct task_struct *next,
+				unsigned int prev_state)
+
 {
 	unsigned long long timestamp;
 	int index;
diff --git i/kernel/trace/ftrace.c w/kernel/trace/ftrace.c
index 4f1d2f5e7263..957354488242 100644
--- i/kernel/trace/ftrace.c
+++ w/kernel/trace/ftrace.c
@@ -7420,9 +7420,9 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops)
 
 static void
 ftrace_filter_pid_sched_switch_probe(void *data, bool preempt,
-				     unsigned int prev_state,
 				     struct task_struct *prev,
-				     struct task_struct *next)
+				     struct task_struct *next,
+				     unsigned int prev_state)
 {
 	struct trace_array *tr = data;
 	struct trace_pid_list *pid_list;
diff --git i/kernel/trace/trace_events.c w/kernel/trace/trace_events.c
index e11e167b7809..e7b6a2155e96 100644
--- i/kernel/trace/trace_events.c
+++ w/kernel/trace/trace_events.c
@@ -773,9 +773,9 @@ void trace_event_follow_fork(struct trace_array *tr, bool enable)
 
 static void
 event_filter_pid_sched_switch_probe_pre(void *data, bool preempt,
-					unsigned int prev_state,
 					 struct task_struct *prev,
-					struct task_struct *next)
+					 struct task_struct *next,
+					 unsigned int prev_state)
 {
 	struct trace_array *tr = data;
 	struct trace_pid_list *no_pid_list;
@@ -799,9 +799,9 @@ event_filter_pid_sched_switch_probe_pre(void *data, bool preempt,
 
 static void
 event_filter_pid_sched_switch_probe_post(void *data, bool preempt,
-					 unsigned int prev_state,
 					 struct task_struct *prev,
-					 struct task_struct *next)
+					 struct task_struct *next,
+					 unsigned int prev_state)
 {
 	struct trace_array *tr = data;
 	struct trace_pid_list *no_pid_list;
diff --git i/kernel/trace/trace_sched_switch.c w/kernel/trace/trace_sched_switch.c
index 45796d8bd4b2..c9ffdcfe622e 100644
--- i/kernel/trace/trace_sched_switch.c
+++ w/kernel/trace/trace_sched_switch.c
@@ -22,8 +22,8 @@ static DEFINE_MUTEX(sched_register_mutex);
 
 static void
 probe_sched_switch(void *ignore, bool preempt,
-		   unsigned int prev_state,
-		   struct task_struct *prev, struct task_struct *next)
+		   struct task_struct *prev, struct task_struct *next,
+		   unsigned int prev_state)
 {
 	int flags;
 
diff --git i/kernel/trace/trace_sched_wakeup.c w/kernel/trace/trace_sched_wakeup.c
index 46429f9a96fa..330aee1c1a49 100644
--- i/kernel/trace/trace_sched_wakeup.c
+++ w/kernel/trace/trace_sched_wakeup.c
@@ -426,8 +426,8 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 
 static void notrace
 probe_wakeup_sched_switch(void *ignore, bool preempt,
-			  unsigned int prev_state,
-			  struct task_struct *prev, struct task_struct *next)
+			  struct task_struct *prev, struct task_struct *next,
+			  unsigned int prev_state)
 {
 	struct trace_array_cpu *data;
 	u64 T0, T1, delta;


