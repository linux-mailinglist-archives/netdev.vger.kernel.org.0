Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A4C57663F
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiGORnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiGORm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:42:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12AD7CB58;
        Fri, 15 Jul 2022 10:42:58 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26FGHCbJ005623;
        Fri, 15 Jul 2022 10:42:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=alP49tc21y9/0vQHE0Q90dwMgd9mpekUfcyfHXFbUEs=;
 b=iZ5zvpWso1wGp6w9lSccJnrW3mvdlrlX9H24BtAGuBPWrpccLr9TdmOiuxuLB4eNfzjD
 wCE9gmnXKodLcH/wMd1o5VZa52rNv8TCjbJMZ8pxhH2FYTWG1u68j8Pk757fQl11QPJQ
 +3VXgHKJJlLiM2hCbN0c4+Ui5DFEu8VD0tc= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hae0wafs4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 10:42:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9BrCS2f+fMMsdc2FFe5j7AZnnd6tqailNnDnCw2/yoV9YbTKDjJ50nYQWelrH2d6bieqRrThFkGHW2T8dUo9D9r9u/Xasn2/q1CzW5+/ACMhGmLafjPHSgafzMg7ruKQWQTayMREs2fpIUR6Dqm1C6/mApWkxPGKhNSxIuT2VCwsObcKTsVMU2iPFYflUywa+Au5v+ExzOP9SqK6Yhm/EFjSaB3i2ZZa2j5dPj8QAizo7bJXTWGGhxjme14HWKxN84J9fIDk+IIi9yXjA+FnVvGiosAfkzmuUqX/zS8chN+QNSK5fja+bzagSkDrz312WqYUdcRX3fTzd6z8gI/1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alP49tc21y9/0vQHE0Q90dwMgd9mpekUfcyfHXFbUEs=;
 b=btFWkahx6t7xqV96nL+dmILel7WI8qcWL7DiB1miRrT1ha/41WBst33zradpNFvfmGqj3m8o0YOaz5uHtxtzeRYOBU4htRuM7rbE9QwZeIt5+BkGOxDdCdu4Ytk2M4JJdG+Ng+JBTJu2w9AlcQ7nFrkobAdAm7S16AW+xenlRqPf4Q1K8YH8OP/CwB0PtqlpiYBLHrggUjiyAGBfXq1tXZFRXV67mlnv68U+sKb/1WjZQmzAE2dqGTKZCI74N7C/heAv9FWfPLyiwc+nG/Rr5euJ0VCvJOexgLPHBZNoIcJ3Ld0JCy/X+MXL8hyyibh7YCbGdxoVmC3LVJdEmQ7lDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BL3PR15MB5385.namprd15.prod.outlook.com (2603:10b6:208:3b0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 17:42:55 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 17:42:55 +0000
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
Thread-Index: AQHYdrjyXTiiEgEgK0K1BTZfHuJgSq19RUuAgAGMyICAAAmfgIAAFU+AgAALzACAAADvgIAA+XEA
Date:   Fri, 15 Jul 2022 17:42:55 +0000
Message-ID: <0CE9BF90-B8CE-40F6-A431-459936157B78@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-4-song@kernel.org>
 <20220713203343.4997eb71@rorschach.local.home>
 <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
 <20220714204817.2889e280@rorschach.local.home>
 <6A7EF1C7-471B-4652-99C1-87C72C223C59@fb.com>
 <20220714224646.62d49e36@rorschach.local.home>
 <170BE89A-101C-4B25-A664-5E47A902DB83@fb.com>
In-Reply-To: <170BE89A-101C-4B25-A664-5E47A902DB83@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af74fece-263f-4bfb-f009-08da668972ee
x-ms-traffictypediagnostic: BL3PR15MB5385:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S51O6ls6qL+g7uclJgY71UYIO1Ws/y3qMWpSlafCMCtiIRrY6QlKrxoh+vLNbO90RN2Pcso199piYbYGE0FhGq5ZvI9RV6Im6dZCQ9HpL26rYZw3zeuL0ZAXGVupDLnww/KvDqoKzTBEgcyYu8oSMPRLw/eP+0gyJinpSnPRF3BDl/8eDAuGhJ21jfVNcEjlgPM5XcFW2U1lLmfIbFKPs4/97XpC6KbuDXvi1xCgEIp0yV/OGCO1IMPLHTyAgc8MDneX9zGZEV4jo+F6D8f09gf8nEsO4kDCqYhjcPmHc7PvIv4jyBx9UCxqnG6MjuUYHJ7M/gYPhtBk2P33XJAyI2iHMqkYuq30HVq+u7Kz4dc2YwWUV7kgzbiRzGG0eBiN1GnnjUCCAqsCMRM1bWAtPI8oUZrkXVbak4CPn8+RQF/RF7x7NBkZbXsYs62tEdYEgnanu4ldSPpsaj9m5F3KHK3hMKgG3lG/nNPKznuV17adnIqUHPqARnvvESn5f5fv1OXj4QyiBKP6fCw2y1GzYDRqfOWt628kQF/Tfbrrb3T4LiWXIhaoSgVUBTXkqp04pwUqSOD+doogH1My1fTBkNI/hhE4Ny6zBf3ztQpSGwmZEQ9Nlzbyi4bc1wqag01Y8K3oKZtKQ3AcseDMjhBmWMlUoS9Kr7X03ONLKXOj7abz1wfblew+Jl71qGjvT+pe5qMwcMQOOOGv90/bFisg3By2ASDATEx9hrVh+CUm7lBNUSoIiH0wlM6wQtHcpwZDeVfkfYlyUFAuSjGMd4H4EUvumhFE/NCBmm925bEcMAfdP350I2es9Mty6Z5/TZQ8iCqU/ORknqws7a+mCBg3pZmpXV3B7ITwqQQWzuiMbKo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(33656002)(66556008)(186003)(7416002)(6916009)(54906003)(53546011)(6506007)(6486002)(38100700002)(478600001)(2906002)(71200400001)(36756003)(83380400001)(122000001)(38070700005)(64756008)(2616005)(66946007)(6512007)(66476007)(91956017)(4326008)(316002)(8676002)(8936002)(5660300002)(86362001)(41300700001)(66446008)(76116006)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RIR4eAK+WJrhstjUxv1340d1TilaJPR44wr6iaOPEOAtShCpiHr84F5Cw8tJ?=
 =?us-ascii?Q?J2XYMcM2M2ZmUpkYFV57qRGAhGgdOXfPosjFiGQrv4dGUY4rIgP2XvxPEu+S?=
 =?us-ascii?Q?SPB8VN0hJjBKvQCKxTh7SZG4BRxTdvKRkoWL439/Y9mxcEpdzrbBk5ThgOMt?=
 =?us-ascii?Q?TuyRPjqQiOR0YtYL3WuGlCWfVH4eipWSSB1sHwiO9IL7o7KObIYCuYRepEmB?=
 =?us-ascii?Q?XrafcM9gRV6sinDg9Ps0MVZM8FL9XUVaD11IlmkFqOOFyBJ5cK6aa92tTqM/?=
 =?us-ascii?Q?unn28LVX9GoKER6K65rw51t+siOShH/sNdMtw4eHs9J44lJG2so2Gk6IBqgG?=
 =?us-ascii?Q?Tz9UpfpvyoPdh7/Lwrf66mnqR65R3r/jCAxRdO47Gwn7m5AUAnNM/TvdLKI3?=
 =?us-ascii?Q?CcJ4R7g7gYgNQghcAurxnPMUHbLwiN2M+uyzCaNra0F9V2dbKWvO66RXPXp9?=
 =?us-ascii?Q?oH+3YBvlkiTXJAAusq2Tq4ORBQq150taogxT674en71pKplU2vnMe1X1U1qr?=
 =?us-ascii?Q?aFAJP54OXokphKIP3msTEuAca7QyP8td7ckERkThFQnvn7Mbxgh0vzwZj3ZO?=
 =?us-ascii?Q?OaoYdN1ZxHr0Q3NSL6pSa/1RVaQ7xrak8T+yytlVwxjH9mm/8JfZ20o17fSQ?=
 =?us-ascii?Q?9MtA3v8IGr9P6sJ02uEqzYYxyo/YoKK7U6+ygrxEyjOVBVEeOfRHkNq+KsDb?=
 =?us-ascii?Q?dYEfSJ7oIz2V+G4nzUyspCvWLM8UCXOE3sxHUFZy9Bqv3A1X99idMDy8DUdK?=
 =?us-ascii?Q?KahdoOqWCadzTpBZeizv4V3VoL3kdgEvZ5vztMUEQ7aNOa9Xz+0dhLrDCCxU?=
 =?us-ascii?Q?9cbO9JOTMXHThrQ+BOaBJgGmqI6SIcP9danJYj1LMVVAjxqrLLdSyOv624tg?=
 =?us-ascii?Q?9udg9AgV3ORcsMdaFw6K6qn8Akvs3AscTfM/NuC5LJujRA2dhm/HB8v0eBQF?=
 =?us-ascii?Q?fatb1bDiIivxZLFPHtkcCuNTQ/GtLVkxf+I1T4Fquu3rF1gR1HWZykF9XN54?=
 =?us-ascii?Q?C4t0GpK7dS5+4VfB2/pScJt3ByGWaM/27Timsfk88YTruBUONNG3JkQdzjog?=
 =?us-ascii?Q?Hys/1YsNqQTjBNWZBMdHw3VSu2yTrVqJhjNjnsEpIOcBtkgRMxaZ+jH7dTNY?=
 =?us-ascii?Q?zXTLxCnmRjhTQfcyCbxTE+rbBIxV03kSriAGDnvI1pXUxw/B7iBCWOqDH8Fn?=
 =?us-ascii?Q?GMBjm4ROIAR4VttMxzEZyKpfTpH0lKL2F42NPqYoY7U5qFxIX4w+HPdIkE+X?=
 =?us-ascii?Q?DYRd/cmVcvuPiCcggHinOK/OYScXM0iTOaOmTzdGX4nSuPf7G66Trn0oPw/g?=
 =?us-ascii?Q?vgHImnm1HQ5Z8gr3qxSGJqlucCjxWNQkAs2ZMvgyYYlsdGvCaG6LJx1oubKC?=
 =?us-ascii?Q?VNpbThExSkAckmv7SEu4DR+Aw/kegmymKzIKkGXLI67zERFXl+tD56wMENoU?=
 =?us-ascii?Q?fDGKri/v8LqV4tgCyqXmZXQ4TGZKEPh4sE8BV0noBAdpLNdV3jGAphMo39fU?=
 =?us-ascii?Q?QY0xNPmsAXfUsLjUNVxlx0DPu4w8mSUAycyVH7aWThE+j083c1jm9ih/36hl?=
 =?us-ascii?Q?/t20DvsXQ+iVUUYzb9PlcbYb3QrPqxKd51CGKjCTM1awCj9S4e/3FDurZErJ?=
 =?us-ascii?Q?2GEm1Y4stvJFD2II+Z8pv+U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D88153F4C499C64BA96409B120F9CF38@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af74fece-263f-4bfb-f009-08da668972ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 17:42:55.0848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vfs+0uyyVOu0ur2Qm2JkjO9g3kYJaREL5t7VmjM2eD8Wfec2Zd5q3XkgZxX3ot3/atsqj6MPPHhLOnP2BSoekw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR15MB5385
X-Proofpoint-GUID: RkPgpwIJoHw4C61OV3AffVYbIBUmPb4S
X-Proofpoint-ORIG-GUID: RkPgpwIJoHw4C61OV3AffVYbIBUmPb4S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_09,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steven,

> On Jul 14, 2022, at 7:50 PM, Song Liu <songliubraving@fb.com> wrote:
> 
> 
> 
>> On Jul 14, 2022, at 7:46 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> 
>> On Fri, 15 Jul 2022 02:04:33 +0000
>> Song Liu <songliubraving@fb.com> wrote:
>> 
>>>> What I'm suggesting is that a DIRECT ops will never set IPMODIFY.  
>>> 
>>> Aha, this the point I misunderstood. I thought DIRECT ops would always
>>> set IPMODIFY (as it does now). 
>> 
>> My fault. I was probably not being clear when I was suggesting that
>> DIRECT should *act* like an IPMODIFY, but never explicitly stated that
>> it should not set the IPMODIFY flag.
>> 
>> The only reason it does today was to make it easy to act like an
>> IPMODIFY (because it set the flag). But I'm now suggesting to get rid
>> of that and just make DIRECT act like an IPMDOFIY as there can only be
>> one of them on a function, but now we have some cases where DIRECT can
>> work with IPMODIFY via the callbacks.
> 
> Thanks for the clarification. I think we are finally on the same page on
> this. :)

A quick update and ask for feedback/clarification.

Based on my understanding, you recommended calling ops_func() from 
__ftrace_hash_update_ipmodify() and in ops_func() the direct trampoline
may make changes to the trampoline. Did I get this right?


I am going towards this direction, but hit some issue. Specifically, in 
__ftrace_hash_update_ipmodify(), ftrace_lock is already locked, so the 
direct trampoline cannot easily make changes with 
modify_ftrace_direct_multi(), which locks both direct_mutex and 
ftrace_mutex. 

One solution would be have no-lock version of all the functions called
by modify_ftrace_direct_multi(), but that's a lot of functions and the
code will be pretty ugly. The alternative would be the logic in v2: 
__ftrace_hash_update_ipmodify() returns -EAGAIN, and we make changes to 
the direct trampoline in other places: 

1) if DIRECT ops attached first, the trampoline is updated in 
   prepare_direct_functions_for_ipmodify(), see 3/5 of v2;

2) if IPMODIFY ops attached first, the trampoline is updated in
   bpf_trampoline_update(), see "goto again" path in 5/5 of v2. 

Overall, I think this way is still cleaner. What do you think about this?

Thanks,
Song

