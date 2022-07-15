Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CCB575891
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 02:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241131AbiGOAN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 20:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiGOAN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 20:13:57 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E50112AAD;
        Thu, 14 Jul 2022 17:13:55 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26ENcdU5007192;
        Thu, 14 Jul 2022 17:13:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=fDJj/K1JAq0HhJUNuGZXW7Safu2kfRnQfthJlnyVLnM=;
 b=W7pxD2V3KIqSFfvnAHt3d9vGphjVpkBLIf3DPbSWxLQPBIkhC2TG2xz6lMu12kepEqnM
 fJsxF+4JFHdN4hCCSRhwKGvUWvlBFu+7Pks2LmIxdY4LwyRRY7Ljb8UhFZ4615NXaSul
 cS2kZ0HkyFrT6K4eZw4qNIR8x4UeA1jEKGI= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h9h5g7463-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 17:13:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMk3I+G0mTf/BLyXD0iIIV/D9oSkr+R9W4teovr6xIWziNHlxtzwhBkB4OiSmHmrvztAJdPdu+es30/BzRVHOZBzj92WiNXloDu+apG7YuC2geuCyywWJiUlm1i91S6sBZ9ABrEx/xYD2ybs778NU/i8hKQ6YZyzROa89JumRHpjNqU5nCYa2J1CqM68SeaH4vkdK7C0V9SnRqoFM1IXMMiHcW/NIuWAiturSDKr7wM9D7vv2FNCnyWBeCfKig8T61TtWLZhRxT6zd7EduFJcW/U+QFUJuLYnd596Rp2frAmdij0eQe7wDsvHgqGZUGmN/rqGb0ApjrPN89bw4Os+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fDJj/K1JAq0HhJUNuGZXW7Safu2kfRnQfthJlnyVLnM=;
 b=d1GSll2RSmA5aHZvAESPsjkRwT5ZEmf4EiQt+3O1joZeVogQSPk0Dv5AVElM6X7xMfj4ZcvnUEXkSqPpN2B2uYHnDUKM+t75W7OChDzqbRsxxz0lrm3YPLhM0dI+kE6jNNP5ub3u1wTJIyJ3WAshPEYelHfRVLwMUpM3M/KqqSaDHHm9TOWQzRL+XDTq70IWkt+n0iTbiBaFdxmW2/VOdjQRdtrZ1hmSeLaIRMd/nt18OIPleB5XGj8n1GXbZArIx2qpAdpgoD5aWnP5+v7bfw1UuM0RvssPWrKB6VgGwXkEoZ+Gan57GixJt2c9Dy9dJFStBP33tJhXuWtCI5egKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BY3PR15MB4978.namprd15.prod.outlook.com (2603:10b6:a03:3c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 00:13:51 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 00:13:51 +0000
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
Subject: Re: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Topic: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Index: AQHYdrjyXTiiEgEgK0K1BTZfHuJgSq19RUuAgAGMyIA=
Date:   Fri, 15 Jul 2022 00:13:51 +0000
Message-ID: <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-4-song@kernel.org>
 <20220713203343.4997eb71@rorschach.local.home>
In-Reply-To: <20220713203343.4997eb71@rorschach.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33183c4c-3f0a-49ef-2ef8-08da65f6e5a5
x-ms-traffictypediagnostic: BY3PR15MB4978:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TwPLntunBTdlMsfI2EpTNcQl10Fu74SadDr5rlMp7ImctaRNqo13M0OWMrOeVrynkNZgrbsNvyXyfV5iTCHnF+TpoJeAMyIIdciJ3rt5GRNZPRe6/CfbhBnTp5foA83kyfvW0m1admhHmapFfnzniXLTCfcLjgvtefnwdfD0iyN1YLGhOZnb7+WY2bPdGarDOqckSiC2wTVNsUYJeMNqMrX9inuu5TMhc2IxSvTrjNS69HmcJx74cI4FUXmuRY6VcZuEhV8m0hBk+ExqJaYRD2bhzPW/8MJIghKfYKa+BKdGpNJdTPs5Zptn5sNkP2GCuab+4GSKvvyNsq4MSK7ZENM8KzaMQpTANtRaZGcD5+4nqEgK55mUAm1ULARcl+cJjMxEJIC5eQEzwBuY89Jy0bwzm3yzrgZchoSdis4ZVUSoOyPwykThilMc+ho7+RdwMfPZ97iZ9Mexum6UQ9fcR8CPPpfETr42K201yd0phYVag2UBktV0aKXphjWGJ0jgijm8mDdfp7l7Tr903zOitFhnT02BQmN8EpDAuNlhqCazQ/RSFEvGQgB59562s5iYyEmQVK5uaeeZWhZESotdGit+ZFsR6eOOZeMss8WEltNcB4GPRTnwE23z+U2lHflHtKGygIiRkHpQEVcqkLEgTuZwxwZR/byLwgFf5PAa+LLavDUoiONw0p3m5rKDAO3cYAgOgKlYWy1/XXQm8AH95xk1H51Y+lQLaJWNHJvlfZcmaWuzA5H5J8t8oh5OV0hVn9i7InVipQa1G/9SCXjsrrN0P7o89Ym+eLf7D/nMTP1YoMNleU/MLbbedl5/aA49+kPw9iaaUORDPt+FE7lCzDm8JhCtr+8l6qZrdEPpaXU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(8936002)(5660300002)(30864003)(7416002)(71200400001)(478600001)(33656002)(6486002)(6512007)(83380400001)(186003)(2616005)(38070700005)(2906002)(86362001)(41300700001)(53546011)(6506007)(316002)(91956017)(54906003)(36756003)(122000001)(6916009)(4326008)(66476007)(66446008)(64756008)(66556008)(8676002)(38100700002)(66946007)(76116006)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8/UzLqC5GqYN5/pDdFyQSWX2MNghtjzrZ/tjPxRN+HOBm0WkxSmgkIJx5A/I?=
 =?us-ascii?Q?Pkpe1k9fgiSF92+eWgOZsw11I6yVN0AUDFHEBTLfTcppzCXnbfWxbv2vM43C?=
 =?us-ascii?Q?ToESGYwNPyobC25U05qqvCyGpM/RnQggolltqCNd9D95x9vEpbthOPZAQY0C?=
 =?us-ascii?Q?Rp6xHN67eOR9rg6NqDiJHR7dTo3kwzLnuizKcuN6mtFu2/TqwJ4lTMJTNPlT?=
 =?us-ascii?Q?swNPaVYBsspwk+CnBUlk/CdNzEzaBDbReliMTuyPeQqKS13A294X3xKyqV5b?=
 =?us-ascii?Q?NS6PoHqfksr6OvVNEB7CIVgh1iRJ6C7NLMGUOuMa05k0rINuwr9192o0oxEM?=
 =?us-ascii?Q?LhGZskNsjMuz+TehBDG2+GpHJd5Wdx5WB/m2KnTY4/AnWGprI7UznNIpGCsL?=
 =?us-ascii?Q?i0dmMqf7UlmDsAvwoBXeZLlBZU8vTIsk2N9E8bKdwebHH5gevHTiSCdozgXG?=
 =?us-ascii?Q?IpFQiE3+9jGIhO7IcgLrQgPFR3MFZl671zaqu4x4uQKIT3SlNwyl2TMwPJ5s?=
 =?us-ascii?Q?c6F+hhv5sarKpZSQ126eSQJ2g1y3oZy1GiWOzuW0HzVm95wygCSPClxGtEW9?=
 =?us-ascii?Q?MWwErqj4FxD1RjJCPKr92FbRouqO2JDSFLlSR+gl2dj7qINS04FzQQT8up7E?=
 =?us-ascii?Q?xOpuZQCFUmfmBXq6mhHuJ3tIyMLoZ+XeRH/Q36XVBIiTQMHXXTVj3fEzSUGU?=
 =?us-ascii?Q?ytKSzrAq+pXm55kGsc4FI8hPOe3Dju7iu8IRWp1bO2SapTMiOal9Wgx9ypv6?=
 =?us-ascii?Q?85Fv3bOyR6RG2ESri+aA7qecTLV6BSZmwlRTU5dTmdT/9LXrUHfY7K23VMiw?=
 =?us-ascii?Q?l8otv0XU+b6IGn7blzKUX9aX3jtGc+uKKzxusA57RaxQoYv4fcgODA4rCfOI?=
 =?us-ascii?Q?LMc2s52lestC2pbj+6L1gBf6Nkd3Kz9J+RSMd25Px2H/fmtUjPq2IExyXxcX?=
 =?us-ascii?Q?tJp4M9NHP6QqZKnbz++i+G/X+RsMeOLWKBv9wiT5do0z7ebCqcJNgApwiJ6v?=
 =?us-ascii?Q?OywJjtZKSf4I1jrlqtRc3KRpHEtOzAWhI2O5yiNERw271pQonTSE3s+tiSN4?=
 =?us-ascii?Q?cNOgNq/E1xsn541+HOoBQtDV40PE6FwEj3u0Yemv7zvJZMscTKGJRpEHK3VM?=
 =?us-ascii?Q?7PtiTZcSVf0ahEvD552CboBgesc9JVJvqLh31ytxi3rfEIzLNbOY/jws4gwa?=
 =?us-ascii?Q?yRrive/poRBY17TCMhgGMxMdtKtS0lNjtgjOx7L8nnP4h/vvEWqZmHB9uR2n?=
 =?us-ascii?Q?MUcdEFwSkeSTSeFppTaaNeyEPnWR9O7KiRYQS2CG/CJvFN/Cs7Wtcn/fP3DG?=
 =?us-ascii?Q?TtdVdaIlo8QmOMxXhPOKbQCqaLjAnHUe0NBtJF72muyB3kRPqD0PpP+fMSE6?=
 =?us-ascii?Q?+XzgsO7br7Aghsa2hb2G1VCnMgay4MGfHXvTTQseWtQ9fQEvR+yH5+9BrwZ2?=
 =?us-ascii?Q?R7X+cDCp81+is0cWbapmYhFijAnQxL0b0U104cuObWUP70Rmi9FjkZOp4F1F?=
 =?us-ascii?Q?K7If8UGzy6btuZ/7F58syA2CchyffI8IrUPRUM1ptWPeYVlYVeArAVfLamo6?=
 =?us-ascii?Q?bXm0/c7zIednOpwaiwM+Wl9OZZwl46Fd4zFn0MPCzCPq+xIMu4PKXQKmKh0u?=
 =?us-ascii?Q?pH/KOh4LmuAukyFjfLsZCqU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5624E33E4DC3394FB8304996D69B8534@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33183c4c-3f0a-49ef-2ef8-08da65f6e5a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 00:13:51.4888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: deI0Eg/uFC0wnGU/W/B7d5hkgONNEUNQ4L7o1YRRxououDBiiGYmwMaYIN3VhLHDt9kPAZI+NY4QcxZlptSdNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4978
X-Proofpoint-GUID: 6D5Kkx0k_thy0ZB1VqqL7NXHDVKxvjmy
X-Proofpoint-ORIG-GUID: 6D5Kkx0k_thy0ZB1VqqL7NXHDVKxvjmy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_19,2022-07-14_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 13, 2022, at 5:33 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Thu, 2 Jun 2022 12:37:04 -0700
> Song Liu <song@kernel.org> wrote:
> 
>> live patch and BPF trampoline (kfunc/kretfunc in bpftrace) are important
>> features for modern systems. Currently, it is not possible to use live
>> patch and BPF trampoline on the same kernel function at the same time.
>> This is because of the resitriction that only one ftrace_ops with flag
>> FTRACE_OPS_FL_IPMODIFY on the same kernel function.
>> 
>> BPF trampoline uses direct ftrace_ops, which assumes IPMODIFY. However,
>> not all direct ftrace_ops would overwrite the actual function. This means
>> it is possible to have a non-IPMODIFY direct ftrace_ops to share the same
>> kernel function with an IPMODIFY ftrace_ops.
>> 
>> Introduce FTRACE_OPS_FL_SHARE_IPMODIFY, which allows the direct ftrace_ops
>> to share with IPMODIFY ftrace_ops. With FTRACE_OPS_FL_SHARE_IPMODIFY flag
>> set, the direct ftrace_ops would call the target function picked by the
>> IPMODIFY ftrace_ops.
>> 
>> Comment "IPMODIFY, DIRECT, and SHARE_IPMODIFY" in include/linux/ftrace.h
>> contains more information about how SHARE_IPMODIFY interacts with IPMODIFY
>> and DIRECT flags.
>> 
>> Signed-off-by: Song Liu <song@kernel.org>
>> ---
>> include/linux/ftrace.h | 74 +++++++++++++++++
>> kernel/trace/ftrace.c | 179 ++++++++++++++++++++++++++++++++++++++---
>> 2 files changed, 242 insertions(+), 11 deletions(-)
>> 
>> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
>> index 9023bf69f675..bfacf608de9c 100644
>> --- a/include/linux/ftrace.h
>> +++ b/include/linux/ftrace.h
>> @@ -98,6 +98,18 @@ static inline int ftrace_mod_get_kallsym(unsigned int symnum, unsigned long *val
>> }
>> #endif
>> 
>> +/*
>> + * FTRACE_OPS_CMD_* commands allow the ftrace core logic to request changes
>> + * to a ftrace_ops.
>> + *
>> + * ENABLE_SHARE_IPMODIFY - enable FTRACE_OPS_FL_SHARE_IPMODIFY.
>> + * DISABLE_SHARE_IPMODIFY - disable FTRACE_OPS_FL_SHARE_IPMODIFY.
> 
> The above comment is basically:
> 
> 	/* Set x to 1 */
> 	x = 1;
> 
> Probably something like this:
> 
> * FTRACE_OPS_CMD_* commands allow the ftrace core logic to request
> changes
> * to a ftrace_ops. Note, the requests may fail.
> *
> *	ENABLE_SHARE_IPMODIFY - Request setting the ftrace ops
> *				SHARE_IPMODIFY flag.
> *	DISABLE_SHARE_IPMODIFY - Request disabling the ftrace ops
> *				SHARE_IPMODIFY flag.
> 
> 
>> + */
>> +enum ftrace_ops_cmd {
>> +	FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY,
>> +	FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY,
>> +};
>> +
>> #ifdef CONFIG_FUNCTION_TRACER
>> 
>> extern int ftrace_enabled;
>> @@ -189,6 +201,9 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
>> * ftrace_enabled.
>> * DIRECT - Used by the direct ftrace_ops helper for direct functions
>> * (internal ftrace only, should not be used by others)
>> + * SHARE_IPMODIFY - For direct ftrace_ops only. Set when the direct function
>> + * is ready to share same kernel function with IPMODIFY function
>> + * (live patch, etc.).
>> */
>> enum {
>> 	FTRACE_OPS_FL_ENABLED			= BIT(0),
>> @@ -209,8 +224,66 @@ enum {
>> 	FTRACE_OPS_FL_TRACE_ARRAY		= BIT(15),
>> 	FTRACE_OPS_FL_PERMANENT = BIT(16),
>> 	FTRACE_OPS_FL_DIRECT			= BIT(17),
>> +	FTRACE_OPS_FL_SHARE_IPMODIFY		= BIT(18),
>> };
>> 
>> +/*
>> + * IPMODIFY, DIRECT, and SHARE_IPMODIFY.
>> + *
>> + * ftrace provides IPMODIFY flag for users to replace existing kernel
>> + * function with a different version. This is achieved by setting regs->ip.
>> + * The top user of IPMODIFY is live patch.
>> + *
>> + * DIRECT allows user to load custom trampoline on top of ftrace. DIRECT
>> + * ftrace does not overwrite regs->ip. Instead, the custom trampoline is
> 
> No need to state if DIRECT modifies regs->ip or not. ftrace must assume
> that it does (more below).
> 
>> + * saved separately (for example, orig_ax on x86). The top user of DIRECT
>> + * is bpf trampoline.
>> + *
>> + * It is not super rare to have both live patch and bpf trampoline on the
>> + * same kernel function. Therefore, it is necessary to allow the two work
> 
> 					"the two to work"
> 
>> + * with each other. Given that IPMODIFY and DIRECT target addressese are
> 
> 						"addresses"
> 
>> + * saved separately, this is feasible, but we need to be careful.
>> + *
>> + * The policy between IPMODIFY and DIRECT is:
>> + *
>> + * 1. Each kernel function can only have one IPMODIFY ftrace_ops;
>> + * 2. Each kernel function can only have one DIRECT ftrace_ops;
>> + * 3. DIRECT ftrace_ops may have IPMODIFY or not;
> 
> I was thinking about this more, and I think by default we should
> consider all DIRECT ftrace_ops as the same as IPMODIFY. So perhaps the
> first patch is to just remove the IPMODIFY from direct (as you did) but
> then make all checks for multiple IPMODIFY also check DIRECT as well.
> 
> That is because there's no way that ftrace can verify that a direct
> trampoline modifies the IP or not. Thus, it must assume that all do.
> 
>> + * 4. Each kernel function may have one non-DIRECT IPMODIFY ftrace_ops,
>> + * and one non-IPMODIFY DIRECT ftrace_ops at the same time. This
>> + * requires support from the DIRECT ftrace_ops. Specifically, the
>> + * DIRECT trampoline should call the kernel function at regs->ip.
>> + * If the DIRECT ftrace_ops supports sharing a function with ftrace_ops
>> + * with IPMODIFY, it should set flag SHARE_IPMODIFY.
>> + *
>> + * Some DIRECT ftrace_ops has an option to enable SHARE_IPMODIFY or not.
>> + * Usually, the non-SHARE_IPMODIFY option gives better performance. To take
>> + * advantage of this performance benefit, is necessary to only enable
> 
> The performance part of this comment should not be in ftrace. It's an
> implementation detail of the direct trampoline and may not even be
> accurate with other implementations.
> 
>> + * SHARE_IPMODIFY only when it is on the same function as an IPMODIFY
>> + * ftrace_ops. There are two cases to consider:
>> + *
>> + * 1. IPMODIFY ftrace_ops is registered first. When the (non-IPMODIFY, and
>> + * non-SHARE_IPMODIFY) DIRECT ftrace_ops is registered later,
>> + * register_ftrace_direct_multi() returns -EAGAIN. If the user of
>> + * the DIRECT ftrace_ops can support SHARE_IPMODIFY, it should enable
>> + * SHARE_IPMODIFY and retry.
> 
> If this ftrace_ops being registered can support SHARE_IPMODIFY, then it
> should have the ops_func defined, in which case, why not have it just
> call that instead of having to return -EAGAIN?
> 
> 
>> + * 2. (non-IPMODIFY, and non-SHARE_IPMODIFY) DIRECT ftrace_ops is
>> + * registered first. When the IPMODIFY ftrace_ops is registered later,
>> + * it is necessary to ask the direct ftrace_ops to enable
>> + * SHARE_IPMODIFY support. This is achieved via ftrace_ops->ops_func
>> + * cmd=FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY. For more details on this
>> + * condition, check out prepare_direct_functions_for_ipmodify().
>> + */
>> +
>> +/*
>> + * For most ftrace_ops_cmd,
>> + * Returns:
>> + * 0 - Success.
>> + * -EBUSY - The operation cannot process
>> + * -EAGAIN - The operation cannot process tempoorarily.
>> + */
>> +typedef int (*ftrace_ops_func_t)(struct ftrace_ops *op, enum ftrace_ops_cmd cmd);
>> +
>> #ifdef CONFIG_DYNAMIC_FTRACE
>> /* The hash used to know what functions callbacks trace */
>> struct ftrace_ops_hash {
>> @@ -253,6 +326,7 @@ struct ftrace_ops {
>> 	unsigned long			trampoline;
>> 	unsigned long			trampoline_size;
>> 	struct list_head		list;
>> +	ftrace_ops_func_t		ops_func;
>> #endif
>> };
>> 
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 6a419f6bbbf0..868bbc753803 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -1865,7 +1865,8 @@ static void ftrace_hash_rec_enable_modify(struct ftrace_ops *ops,
>> /*
>> * Try to update IPMODIFY flag on each ftrace_rec. Return 0 if it is OK
>> * or no-needed to update, -EBUSY if it detects a conflict of the flag
>> - * on a ftrace_rec, and -EINVAL if the new_hash tries to trace all recs.
>> + * on a ftrace_rec, -EINVAL if the new_hash tries to trace all recs, and
>> + * -EAGAIN if the ftrace_ops need to enable SHARE_IPMODIFY.
> 
> It should just call the ftrace_ops() with the command to set it. If you
> want, we could add another CMD enum that can be passed for this case.
> 
>> * Note that old_hash and new_hash has below meanings
>> * - If the hash is NULL, it hits all recs (if IPMODIFY is set, this is rejected)
>> * - If the hash is EMPTY_HASH, it hits nothing
>> @@ -1875,6 +1876,7 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>> 					 struct ftrace_hash *old_hash,
>> 					 struct ftrace_hash *new_hash)
>> {
>> +	bool is_ipmodify, is_direct, share_ipmodify;
>> 	struct ftrace_page *pg;
>> 	struct dyn_ftrace *rec, *end = NULL;
>> 	int in_old, in_new;
>> @@ -1883,7 +1885,24 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>> 	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
>> 		return 0;
>> 
>> -	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
>> +	/*
>> +	 * The following are all the valid combinations of is_ipmodify,
>> +	 * is_direct, and share_ipmodify
>> +	 *
>> +	 * is_ipmodify is_direct share_ipmodify
>> +	 * #1 0 0 0
>> +	 * #2 1 0 0
>> +	 * #3 1 1 0
> 
> I still think that DIRECT should automatically be considered IPMODIFY
> (at least in the view of ftrace, whether or not the direct function
> modifies the IP).
> 
>> +	 * #4 0 1 0
>> +	 * #5 0 1 1
>> +	 */
>> +
>> +
>> +	is_ipmodify = ops->flags & FTRACE_OPS_FL_IPMODIFY;
>> +	is_direct = ops->flags & FTRACE_OPS_FL_DIRECT;
>> +
>> +	/* either ipmodify nor direct, skip */
>> +	if (!is_ipmodify && !is_direct) /* combinations #1 */
>> 		return 0;
>> 
>> 	/*
>> @@ -1893,6 +1912,30 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>> 	if (!new_hash || !old_hash)
>> 		return -EINVAL;
>> 
>> +	share_ipmodify = ops->flags & FTRACE_OPS_FL_SHARE_IPMODIFY;
>> +
>> +	/*
>> +	 * This ops itself doesn't do ip_modify and it can share a fentry
>> +	 * with other ops with ipmodify, nothing to do.
>> +	 */
>> +	if (!is_ipmodify && share_ipmodify) /* combinations #5 */
>> +		return 0;
>> +
> 
> Really, if connecting to a function that already has IPMODIFY, then the
> ops_func() needs to be called, and if the ops supports SHARED_IPMODIFY
> then it should get set and then continue. 
> 
> Make sense?
> 
> -- Steve
> 

I think there is one more problem here. If we force all direct trampoline
set IPMODIFY, and remove the SHARE_IPMODIFY flag. It may cause confusion 
and/or extra work here (__ftrace_hash_update_ipmodify). 

Say __ftrace_hash_update_ipmodify() tries to attach an ops with IPMODIFY, 
and found the rec already has IPMODIFY. At this point, we have to iterate
all ftrace ops (do_for_each_ftrace_op) to confirm whether the IPMODIFY is 
from 

1) a direct ops that can share IPMODIFY, or 
2) a direct ops that cannot share IPMODIFY, or 
3) another non-direct ops with IPMODIFY. 

For the 1), this attach works, while for 2) and 3), the attach doesn't work. 

OTOH, with current version (v2), we trust the direct ops to set or clear 
IPMODIFY. rec with IPMODIFY makes it clear that it cannot share with another
ops with IPMODIFY. Then we don't have to iterate over all ftrace ops here. 

Does this make sense? Did I miss some better solutions?

Thanks,
Song

>> +	/*
>> +	 * Only three combinations of is_ipmodify, is_direct, and
>> +	 * share_ipmodify for the logic below:
>> +	 * #2 live patch
>> +	 * #3 direct with ipmodify
>> +	 * #4 direct without ipmodify
>> +	 *
>> +	 * is_ipmodify is_direct share_ipmodify
>> +	 * #2 1 0 0
>> +	 * #3 1 1 0
>> +	 * #4 0 1 0
>> +	 *
>> +	 * Only update/rollback rec->flags for is_ipmodify == 1 (#2 and #3)
>> +	 */
>> +
>> 	/* Update rec->flags */
>> 	do_for_each_ftrace_rec(pg, rec) {
>> 
>> @@ -1906,12 +1949,18 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>> 			continue;
>> 
>> 		if (in_new) {
>> -			/* New entries must ensure no others are using it */
>> -			if (rec->flags & FTRACE_FL_IPMODIFY)
>> -				goto rollback;
>> -			rec->flags |= FTRACE_FL_IPMODIFY;
>> -		} else /* Removed entry */
>> +			if (rec->flags & FTRACE_FL_IPMODIFY) {
>> +				/* cannot have two ipmodify on same rec */
>> +				if (is_ipmodify) /* combination #2 and #3 */
>> +					goto rollback;
>> +				/* let user enable share_ipmodify and retry */
>> +				return -EAGAIN; /* combination #4 */
>> +			} else if (is_ipmodify) {
>> +				rec->flags |= FTRACE_FL_IPMODIFY;
>> +			}
>> +		} else if (is_ipmodify) {/* Removed entry */
>> 			rec->flags &= ~FTRACE_FL_IPMODIFY;
>> +		}
>> 	} while_for_each_ftrace_rec();
>> 
>> 	return 0;

