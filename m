Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FCE45614D
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 18:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbhKRRTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 12:19:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63168 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233968AbhKRRTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 12:19:30 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AI9wxLS002997;
        Thu, 18 Nov 2021 09:16:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=zGJYzG2yVlzLfZw5CQW7HBG4eh90ZnXTEvXr/CXqN6c=;
 b=m4fyPCgZKO1fcYoFG/ptpkRnqcMweLqIzJQcV3TT3d0aw1/NsAAwTGHMviWw2t80o37z
 S2FAx9vDoQSmsrUtG1VYYSpHwte9kPCCw2uBKA3qVmJcoyyKiwq4hebfES9znJ3q09e+
 oZ3G3y6tDyGo7kzpkGcGF26z1j1U54A+Osw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cdmp0k12p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Nov 2021 09:16:30 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 18 Nov 2021 09:16:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9ZAh5CC2tAmSRHiQ2bqMRff2WR1CJnvgwATKrhq8WOHOLJUyhcnvp4t8uaO1apW6C3fZMKGsF8nQUboA/g/mRwnmOPYd7ShH5U5WeMptOaxc/dYBsxMkn7Bdt9SrXa0H+BKmqI3XcgyfQR3CAJSCrXTG0VUMRzcLGLdqFNzdpphD0CuANAo0PrlsmZsKr58r8nGf+Uodf6P6JCq/nC/iyp/E/PERMFk24NJKtRhU5WXuAHK/8/53W9wRCpKeMmffDBrbKM/SLInS6w0MFEJmolegKAwQOk1rHkjrfBuCteJqddohzd64JkaqYklc4VsKaRol4j6ueW1WLQTAqzusg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGJYzG2yVlzLfZw5CQW7HBG4eh90ZnXTEvXr/CXqN6c=;
 b=dn1iivkBdmOASiGdPt7b69I5hSOQiqcLBJfyj5fKT2bZpCS9l+wMfG5ncEbvKNN2WdMNYZGk3+Ga4pS4NGTlKvGHMzXx9o+0Rhokxasr+80iaalJKZV1IeISZH16oVaUJr9/MHccqENaVIR5kvm1QIFb94sEKXjsYvLJvaQcSqR/3ZjSBtWR8cvc5+gKtK3QwZJnzAs4gz4LOdNVJRDM5uBcArA/3UpUWGxGtTmHqGMDPSs13Og7GpYpmamHpasKfeJ8ng020TSUk1W9V7ybnENkirOc88aFYNqDQqqLehD5AyNIClSFkNprPQAl1QSye+2pZZezHap1sXM+VSpduw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5260.namprd15.prod.outlook.com (2603:10b6:806:239::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Thu, 18 Nov
 2021 17:16:24 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%4]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 17:16:24 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Johannes Weiner <hannes@cmpxchg.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/7] set_memory: introduce
 set_memory_[ro|x]_noalias
Thread-Topic: [PATCH bpf-next 2/7] set_memory: introduce
 set_memory_[ro|x]_noalias
Thread-Index: AQHX2rsqg2QxafvOqk+EnT2R5OJ5LqwFyq6AgAJ2NACAAAcDAIAAIFIAgACFb4CAAJzpgA==
Date:   Thu, 18 Nov 2021 17:16:24 +0000
Message-ID: <9DB9C25B-735F-4310-B937-56124DB59CDF@fb.com>
References: <20211116071347.520327-1-songliubraving@fb.com>
 <20211116071347.520327-3-songliubraving@fb.com>
 <20211116080051.GU174703@worktop.programming.kicks-ass.net>
 <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
 <20211117220132.GC174703@worktop.programming.kicks-ass.net>
 <73EBD706-4FEC-4976-9041-036EB3032478@fb.com>
 <20211118075447.GG174703@worktop.programming.kicks-ass.net>
In-Reply-To: <20211118075447.GG174703@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8bf9df40-b5d6-4356-1bda-08d9aab7262a
x-ms-traffictypediagnostic: SA1PR15MB5260:
x-microsoft-antispam-prvs: <SA1PR15MB5260789AE9956F99469CF8F4B39B9@SA1PR15MB5260.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vRtPTpHKVQh57gxun+tcw37c7BfSbr/FZOT3x3kGRTdrHe1kniwmboWkUaU+0810P8Tei5vVULzsqRool6wKabAj5XPugLPxzZS9dgD7rZoW4PXaNMegunxosPOYAE6DIabpmneWU0Q12bd/QgJ9BDctpfO/v4AS/vvE1Z8jlj86cab9VeeaNi/AP8bOR5ZIc85iRxDXWlEDF//z139mSx9mUrTBU/TirEXTfd5Kjkbq1WUO6YCxMej1SunWW/Y0Edkbhy3QjeCQkFMZ0sj4OVn0XBA9y2Jxs8B1yoIkWf/0yxIuMbguKlyF7fbF6TPmivgDBCvbfx7Ys82EQLEe84WWPEJasSQIUDfDZQJfwNja7joCHeaMrFXwj/oyT5ZmUIvBo2n1YKD81daAC3DyUaWNvylMtY3t63u4w9EoVPvFy0u+83CI5iEOIk1Ww9EbJrDjTtpBaLkGGXa7u2KdLr5m3zkuGsNjJsYyMwj1JZTcSDDVKgRV/UN9XXnaZ9j70DXx8wu899e4OxplCONU0bOY1puRZ29EM7+sr+Kq7yg7xHoNGUBOfK0hxU01po3UAfEvoflA4d87/EOoYv+G6ZGBU04NII9RQafGdkbyMMlrq5YylthcVwuBBRYd2YFb+6+S626/EeTW1tjq178S58EiGU0CpwtMvrJyQ52hMEx4ptiaqEESDXnUApwODWvH2TuQ8fNZw7fmWlprqfQJYbYnXCuTOfc9FLeEAIxqppWRJNUCCVFR6/+nwIWMOciS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(66556008)(64756008)(66476007)(54906003)(7416002)(6916009)(4326008)(66446008)(91956017)(5660300002)(36756003)(76116006)(186003)(66946007)(508600001)(6486002)(38100700002)(86362001)(6512007)(6506007)(122000001)(2906002)(316002)(71200400001)(2616005)(8936002)(38070700005)(83380400001)(53546011)(8676002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hS56bioYpInGbG2dNgHCTRLBeDdMdg3ep/eAm430wJ05144AlaFfNaa7Q3Sb?=
 =?us-ascii?Q?f87LGvQnIQc1ashPfAEct6MDiMUW8zNcCtzTnSYZvfX1sPRvqDirn2A6l+pg?=
 =?us-ascii?Q?j8FBBcvE/wAVMBxy1IuGF0svjqFyfaEHqe/zHWA7CBmq/w7dEozJIUrUBYZT?=
 =?us-ascii?Q?8btXlOMQPR4uaUlRUMCKaRJf82+LVqIF4jyVwsbWtKn6qYURDPusEaw9Ib3z?=
 =?us-ascii?Q?foj/a/RhXb5OjIO3DJCsguxVX2rVuPEnV2FR4xdZONr5imkscKgrJFMvHlvx?=
 =?us-ascii?Q?vrx2AFHf6uauJQQQYyWut07aCBYUNWrj5nasiRIEk0jp6h1b8xieXsfQVUr2?=
 =?us-ascii?Q?4dVfjzMhqHNRMNpF2so6tUyaRG5rYyZXWPPQU+zQZtw5lj4nwsHM+mY5mE47?=
 =?us-ascii?Q?zdcDrnWx+Bl3nDR2WJnwt3P6xPlYTOwIpXiunH7XyA2iLqf948HRDU5j2P1K?=
 =?us-ascii?Q?wFTmTQqp/VAsRcVe8xiERo8t5v5PK907X1X2RGevsc1sk/Wi0uXMv+t3UrzI?=
 =?us-ascii?Q?Z6p0e7a7g0mYmW7QqDLaoIWHnEJN4AXZFa4TgjeZkCRH0C7F3HHze79S8UCF?=
 =?us-ascii?Q?RzFCtiz08MP50FCH44cxQ6XoJEiB93oMxil7rptCEzampYLaFsrLF3XQM5WR?=
 =?us-ascii?Q?jINW9xWMAKmXq7MXZMiOc/XEWQvKp47xcfc/jm0T5FYb+BM4bvtpIrw65dh6?=
 =?us-ascii?Q?IVsO4pqQaynDKv//h5JMLOgwC48sAQAMbSJUSdvl1q4vXKzEWIP5GJ1HAOgf?=
 =?us-ascii?Q?Vq7H2zdxkyGgQCEVxOC4Ckr6o7rrq81Si4iUQBxQyq56Ndcv9Rjsj+LbnVq0?=
 =?us-ascii?Q?ZApjzMlrnMlI1Wcxjt7IkCMvpLhw+bn6Pmv9RV6WeCvE+Mct0VK5Y5x03wG/?=
 =?us-ascii?Q?acLM3wKd7WRKoHRkEyrT3tZix9sF9x+xyWP4zeSjzLz3POEIfvAmW4T6594W?=
 =?us-ascii?Q?y/H7QOE1ZHPGpF4N65cSCSXxONyIp9WfmwfaYVPiofNRhA/dQLMXcPkZDRXF?=
 =?us-ascii?Q?TnPgPOZHGxV/7zegpoRT78Yu9Ntb9GEYhZhnb5aqOHok4jHPIY+X7NQtnHs6?=
 =?us-ascii?Q?mePLxegJvHKfwxe4rJMCkaB5ML4akXu71xTx3ilCcVxfl5AjP4oCGHo/jxso?=
 =?us-ascii?Q?tpVnjwr6bJLD1FhKpoBFWa5gBYICdvdbYNEaPrHeHLkiUSUMu3iSM1bqCIy4?=
 =?us-ascii?Q?s3Bo+c0D61K8SDMzebDMWB39rNexYEkNcrGdOHbDCOwgJNHTjZZMl8OqS+sB?=
 =?us-ascii?Q?+6kSpPquwKjFbGg/0Q2QZA1zUdEWKse4Rgg2j1p7X7I1hcvDaByYs8aVGEeb?=
 =?us-ascii?Q?A23+c7ot2FAa8/+wjj35Na31Bcav8/igtZUXiv9JooYlacmWsnZu6uYZUypJ?=
 =?us-ascii?Q?wq3CIUvaOj6tnkN6NkS1Zbl7XrJTrwjoWaz+8S2tij7sRkFyKD84CcEdTQqX?=
 =?us-ascii?Q?TdUQgkGg3UXhw7gurF8zJjPSL4qO8Os3dX75Ip3q1O1oDLi7sQ6mVCTkQfbC?=
 =?us-ascii?Q?Ihamd+2hax2guYLLI+Ufq4Gd4jKby8aYGgyxG9QqD/G9fklwdu3JeLeMagKI?=
 =?us-ascii?Q?3mw+7RFc6adAZjxljT3DxOm6zEQxnZOjDuMxLnFIfINfLVm4XhInIfXgBHOF?=
 =?us-ascii?Q?uEuj4lrU4mDn+TQ3/EIaSsTBEDTUt0LttcwtcyyZ8IVBTmqYXilJcz2NIF4Y?=
 =?us-ascii?Q?vxrl1A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <119B279C5842614FAF52CA7727155A94@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf9df40-b5d6-4356-1bda-08d9aab7262a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 17:16:24.4372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G+6DDM0Y1n6UQl7LtTTJpNzvbZLka58/jEHp0F5xntizbWjpuXLEZGMdZw+LveD+PZDjYxXdV8uBuIFBcGJdQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5260
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: zWUm9DOFaZV0X2ekJWVkaTP560Ry9unD
X-Proofpoint-ORIG-GUID: zWUm9DOFaZV0X2ekJWVkaTP560Ry9unD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 mlxlogscore=933 suspectscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180092
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 17, 2021, at 11:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> On Wed, Nov 17, 2021 at 11:57:12PM +0000, Song Liu wrote:
> 
>> I would agree that __text_poke() is a safer option. But in this case, we 
>> will need the temporary hole to be 2MB in size. Also, we will probably 
>> hold the temporary mapping for longer time (the whole JITing process). 
>> Does this sound reasonable?
> 
> No :-)
> 
> Jit to a buffer, then copy the buffer into the 2M page using 4k aliases.
> IIRC each program is still smaller than a single page, right? So at no
> point do you need more than 2 pages mapped anyway.

JITing to a separate buffer adds complexity to the JIT process, as we 
need to redo some offsets before the copy to match the final location of 
the program. I don't have much experience with the JIT engine, so I am
not very sure how much work it gonna be. 

The BPF program could have up to 1000000 (BPF_COMPLEXITY_LIMIT_INSNS)
instructions (BPF instructions). So it could easily go beyond a few 
pages. Mapping the 2MB page all together should make the logic simpler. 

Thanks,
Song
