Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC4C455156
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 00:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241720AbhKRAAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 19:00:22 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21662 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233088AbhKRAAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 19:00:20 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AHLe24o010814;
        Wed, 17 Nov 2021 15:57:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=ik9vP2C4BRaVKNIe4dyUJQyPKkZ9GKTIlMVSjA71DBI=;
 b=aW9TdVyGCGxw82Mh/G6aqWRSJeUzMgsybTnBnuRCnADjRlnzA1VAmmW9hnaMtv3HGX1x
 FjP1VLqtPq7F8byrnJ4pOXQ9pWz+01blWZTtFshlqFAOp5W7jXoEk9IPaNd+94C1KrqI
 KqLUcWTuCUU4xXBzIs6OOH2q5tySwaSj3vI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cd3y1v31e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 17 Nov 2021 15:57:19 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 17 Nov 2021 15:57:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cF2PC7Ar2xEY9FGY9yx5io8OC2eZjO2p3nxIZtdD4GlXiadHF8PeSJ8TfQpIPJZ2JSksn7+HQutHK52omYLAMIXt4vWk+UukeQyuhGH+XmsLvArP64e81L8ztw5C9PWcGMB3lNhEa7wCtNOPwxavzyiQrQ0aU2JsmzZCLlQdnTKBCQQxYmas+iSlO6ShzOWzb1DNgN4Wrwn40oUeWL7O0SILpI961IvleAX6CEy4t9XP5XDu9OyyWFAaQnGgdeJAYYG0TrlufDy2Cdl4Kxq8uFLFBdiPMljHLgrBBQBWPMSlSYPY/IXDany7EhN7UKQOIXVfs21SCPr2bO7zati5Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ik9vP2C4BRaVKNIe4dyUJQyPKkZ9GKTIlMVSjA71DBI=;
 b=b7B5UOH48zmMb9H5q+Ukcroxmrc98XBKISCBZwCyHa8hLIyhXK+MPxkAN/aC4zjnTqZRz+6j+KNqv1JijHSCf63O1PEhBunP47X9vGO2qbs0a8zkimKdlJbWcH4AqcE0rGeJVPHYEs1BB2zdUyEiJQAzXRNiAdOwkc2yntf4tQKXvFH+2kQesF5kdQuBcYbF5JkxKKL6yBJaoWJbT8WNEyKjaLQTJADMm9aPdNdIxTlnngRpf4f3uMYv/w4gSStpnCUC7NtTVDxxJM96mTK6opGR14seyK2kjA1mQ7ll0Gh4PmEwO2PnNV/Ut2kM4eVc86wi5kBvqUj/7+ogYwRfKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5185.namprd15.prod.outlook.com (2603:10b6:806:235::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Wed, 17 Nov
 2021 23:57:12 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%4]) with mapi id 15.20.4713.021; Wed, 17 Nov 2021
 23:57:12 +0000
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
Thread-Index: AQHX2rsqg2QxafvOqk+EnT2R5OJ5LqwFyq6AgAJ2NACAAAcDAIAAIFIA
Date:   Wed, 17 Nov 2021 23:57:12 +0000
Message-ID: <73EBD706-4FEC-4976-9041-036EB3032478@fb.com>
References: <20211116071347.520327-1-songliubraving@fb.com>
 <20211116071347.520327-3-songliubraving@fb.com>
 <20211116080051.GU174703@worktop.programming.kicks-ass.net>
 <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
 <20211117220132.GC174703@worktop.programming.kicks-ass.net>
In-Reply-To: <20211117220132.GC174703@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e501d190-5d03-4b19-064e-08d9aa25f9a9
x-ms-traffictypediagnostic: SA1PR15MB5185:
x-microsoft-antispam-prvs: <SA1PR15MB5185AA75B36476F887BA83C3B39A9@SA1PR15MB5185.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PozGnihUfOIG19nE8EXcQ3F247t3R+0BTmhtTqmOAHNbS119bW1waZp82BAmTWS3vICInGUXRefER/c91ZF1k2Iac0VAxpjQ1oU9Zrhkr4zwNpgV5aDloVGsTOYdwNThCYi/ooCBmsfgcPfIs0+abc3k5OfODJpEZcI5kego49/jfZXX48It2LKcoc7S53ai7qbbJH+urpvDbZMuioM3v+qUPOJP6+jQe0GNgCVONrLxWqSvvRjdkjXyZmdD6yDEI02XS0XgTcjYdVTdDVgxYO3npl1QQ53ZH2kGx3q+dm1Ze5YWfOScmBDGGfq+L61xnww1FXvUSWc5Z9MpLiuWSdIUfQZbBiEoCZU119fJG80wqJFNfpFd9C2SF+vhH59aAQhV6/H41YoRTwqc5Z+iz/FOjCUNP+IagQMug+M/fzc7PNCUQLkieol9nwZEOI/POLucZz5gpbikgnN/PxWKzLh4fwTD96Iym0RgA+qOqVkjsorObdNnGizc7LK19yLnKK7l3dcCdYuFtA+Lbez3cuaywnN+4QeqPF06W1wYtFeAxTDEizQKj/0LVZ7qac+f6iikKFYLrKLS+iduua60lCzLzirLKC8lz2UNmSynPnPhGEe0o5EwbHhixHYv2AHOiKiUNjO4cmZM/lJxJEu1QXUSUsBUUKw62UAxz52H/eKm28uvAT5Fl/49XUGchtnS4m9OnfXpZSE59APG9HJpIMjufmDoLDBmfqqheZIhSnzpMwax9kndzRJN8jJJmJgM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(316002)(122000001)(6486002)(33656002)(64756008)(71200400001)(54906003)(5660300002)(38100700002)(66446008)(66476007)(91956017)(66946007)(76116006)(66556008)(186003)(7416002)(6506007)(8936002)(53546011)(2906002)(36756003)(83380400001)(38070700005)(86362001)(8676002)(6512007)(4326008)(6916009)(508600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cvwKKbp/UMKKefo5jAzv1sKe3DJqXLrbKzt6uJ/StTr3nWUsG6a4ew2wilaa?=
 =?us-ascii?Q?hovE/TtqmzoE5QGQ9b5xCw89oxtHVih4PvwWdznSi/NtswDE6BFLhcN9IxKj?=
 =?us-ascii?Q?PI6SzM1OTfgz4pD5w3JOQeTOpfPC66mr+QbUAT8NZWKP4jy/uo++wTFkJev7?=
 =?us-ascii?Q?AZyPabh7PPTSCN5MaOa7XiGVjUVuS21O9NCm/qURorWvTO/sKl/xte4wCNfo?=
 =?us-ascii?Q?wUd2jq62mej5goz5OOc/wMyN4HJzrVr1zoc0aZ/LgQrrz6bbrcwvBlfMxUc7?=
 =?us-ascii?Q?kGcrlQ4hJFp4GwvNN3C4bHB86+zm+WBfg5SE/pxCw6WXOT6nDNayM1gVHpBI?=
 =?us-ascii?Q?S9n+E/eAFJYwKLo9nuFE/nhehRyhKSxn7c7+QIWImTG2moPRNtUMzrZmbX/j?=
 =?us-ascii?Q?uOLcMyuDY1sb9ELPFnP92khlfG7Kaqhck6wWb+QVQZTuharuYxNEgBmcKPv4?=
 =?us-ascii?Q?xibp2Ay/oKVN7H7xUo00CK2JJ8fM1ccOhvU88noXAYFo1+omITnbyypqTvR4?=
 =?us-ascii?Q?h+3JjU+Lxug21YaB1ihIcb8iT8U8tpjWii4C/7D9WuK8JLjAQRFGEMh5Vmfe?=
 =?us-ascii?Q?k5wBJKjjNTZMAJxEh38Cfb1CWiQITCUen6M1ZBAZnojhlqc7rkHorBUuHdcs?=
 =?us-ascii?Q?2O56R1Jrjc2qmjbi5ag+0p4gw6EKt5OgrrArW/MlxIVZ1r8CJCYnCv83A/R2?=
 =?us-ascii?Q?xY0n/wCU+Wha9t+MP/hRu+TU22DCfVx+iKg3k4aii1eEWKfI0PKI7ZwkP7sl?=
 =?us-ascii?Q?IXlJTh46DWDi5BHnKGyK4lf5v9G0QOp8ve7MOIK6sa2ZItBYiAkTPyLFkHHA?=
 =?us-ascii?Q?+ZJKPUKxdIHDjDb14u2lOCkOShogXKt6IMcUQx4HziNXJUgFKEw343s2tiuU?=
 =?us-ascii?Q?cEDCI7N9Jk4c9xEHmv5gN1O3HLsQjaD5DWpuB+rBrNh7peaj6qwSKzK0f7Sf?=
 =?us-ascii?Q?akqmlcUaLK+Xd00B9OPm5GAfpbirY4UT8GsZJ5R3AND8n1OK5oeh8wxVzbLs?=
 =?us-ascii?Q?eG7EiuXN2QI/8f5SpS5WtdZqPxKQX8kM6vyUpWefV/7eoUVHn5DkqdY9tRsg?=
 =?us-ascii?Q?3dIwvsRm6f20xNLTWJZGn1a9BLVTOSNkN8fW+MijYQirNCvxR1XnYiY5ozOm?=
 =?us-ascii?Q?iyULR+Ft5bERnfS/17kgCRm4Teqss/FmJQGd3dii1D6R+hedBrxoGLfTC97l?=
 =?us-ascii?Q?Akh8xnNTF9LAGgfoUBjhZzRy2fPIaJB0Ga4+a8H90dz2ojFdZdLd2AhlXnzn?=
 =?us-ascii?Q?S+NfG9RGBZJ7jrv1KCQpRvIn0HIFpS23mGMXZB9Qfi6lLmviYZaKF5wU6SNL?=
 =?us-ascii?Q?yLaeDahBuxmbQtxwtGjEllCY5I/8IhmUC9HDAY/9Beh/0d0LsWkbINKP8TEl?=
 =?us-ascii?Q?B41MVKTEx8GPe705idmSWLhWUSu5qWlSXsgYpvEjge3hO7gTa3vdOqdDaRFO?=
 =?us-ascii?Q?ktl0uuv4SLjx9P8omy8/byl73/sgdJxI5+zEdWgWtECpftfTi9QyikhEKCSV?=
 =?us-ascii?Q?FlJD+87lzxwIUCt9HJZD9uMmNxcOtSfOdXn2YQxUJh+AUhyMHGEhnvEQ7qXi?=
 =?us-ascii?Q?htVWuFeiPdvADQ1rthN6/QtczsJ6mNAIyxrSUSOgQMAcsUySErGBGEArfuL0?=
 =?us-ascii?Q?3NHGPmxp/2eAWVW1OyufMKF499J8q1ZgsG7r/u8N0GngZzRE4ISd6xZbR5eF?=
 =?us-ascii?Q?1WJ8DQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <077419E04F2E3B4B9CB94DB70B242224@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e501d190-5d03-4b19-064e-08d9aa25f9a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 23:57:12.7795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b1X9KE8INovLerxGRDdn5VHLd0ylBF6DuD81nYrURZCmtgi3NCUHBpAeOCbhbXUuhBb0tasOly/hwlh70iEylg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5185
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: wfDY8UjkD50eQl1a2g4G4c5KA2k4Xe3p
X-Proofpoint-GUID: wfDY8UjkD50eQl1a2g4G4c5KA2k4Xe3p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-17_09,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 malwarescore=0
 mlxlogscore=485 spamscore=0 mlxscore=0 bulkscore=0 impostorscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111170111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 17, 2021, at 2:01 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> On Wed, Nov 17, 2021 at 09:36:27PM +0000, Song Liu wrote:
>> 
>> 
>>> On Nov 16, 2021, at 12:00 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> 
>>> On Mon, Nov 15, 2021 at 11:13:42PM -0800, Song Liu wrote:
>>>> These allow setting ro/x for module_alloc() mapping, while leave the
>>>> linear mapping rw/nx.
>>> 
>>> This needs a very strong rationale for *why*. How does this not
>>> trivially circumvent W^X ?
>> 
>> In this case, we want to have multiple BPF programs sharing the 2MB page. 
>> When the JIT engine is working on one program, we would rather existing
>> BPF programs on the same page stay on RO+X mapping (the module_alloc() 
>> address). The solution in this version is to let the JIT engine write to 
>> the page via linear address. 
>> 
>> An alternative is to only use the module_alloc() address, and flip the 
>> read-only bit (of the whole 2MB page) back and forth. However, this 
>> requires some serialization among different JIT jobs. 
> 
> Neither options seem acceptible to me as they both violate W^X.
> 
> Please have a close look at arch/x86/kernel/alternative.c:__text_poke()
> for how we modify active text. I think that or something very similar is
> the only option. By having an alias in a special (user) address space
> that is not accessible by any other CPU, only the poking CPU can expoit
> this (temporary) hole, which is a much larger ask than any of the
> proposed options.

I would agree that __text_poke() is a safer option. But in this case, we 
will need the temporary hole to be 2MB in size. Also, we will probably 
hold the temporary mapping for longer time (the whole JITing process). 
Does this sound reasonable?

Thanks,
Song

