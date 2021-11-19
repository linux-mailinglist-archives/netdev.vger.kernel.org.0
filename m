Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B9F4568F9
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 05:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhKSER7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 23:17:59 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23676 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233060AbhKSER6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 23:17:58 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIKEnid030321;
        Thu, 18 Nov 2021 20:14:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=9DzHOhNdDrEOuImShcLl1duRVUNPkrN0alsTOuIAJ6w=;
 b=KITpW6s1bYRrDw7JgkIfDG/4TndE3pBLMpMVI4Um4cPdC9X9TScBPEgeky9Faa1NcGow
 7qGvUB5yyKvU8c33hw9cpRSeV/YfhULGvoyj+V5vtf/lEURXju0kOY1cxcC1bBF25vRg
 WQelTeZsr+PFPNRakq4MA7aPuIe0i3JFyfE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cdqp4nqj6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Nov 2021 20:14:57 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 18 Nov 2021 20:14:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfMWfmFLInbfR/GaESmFWplX30vG1K+9vRXTfEytzRYoeyhLjyfVtuLb+LY1ZTowR/zbyoK9HUh/wkdRguFB1ovul5a/8hmeSwWeQhHvElS0rVGFeCbyAMoSmop4iiowLBgwq6z6kMLRgERE0XqFc2Ou6rslXGHDpSpxtyZ9ZFvEw52rumAEsM6VRZy8DJ1bnv1eortMLbPgkhcPFE66i9xqcONCAlm/PEu7im51gbVjm08UaTr3ss1aImH+vY2nNROLSGKGUMA2Gnw7/fqSClL/Ha8ZIDL/ARXCIkxDaDvuFA82OEe6Q/kiotu7JLd8uI/7okp8DAVqdtXqDRxx4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9DzHOhNdDrEOuImShcLl1duRVUNPkrN0alsTOuIAJ6w=;
 b=R72V1jH8zNdcm504GX1YMbUueD4OGqdzNDGWcLO1lKk492J4OWL+CIbO24vpDIQHV6BJIW2bwkw7imuipR61afiieAWsizzwSLglSQ69WByqf9jZ/Nju7thvIYQi9WbvKqpvgTnJ8XfZSnMfbTdg8EzAhzHrBdTyM0BezBxYhRVS7r7ZXTYH7H7KILxZQCXL/bvvaXvzboE+YdIZuBuYDFuFH+lW31cXIAfVf8felIasNh8ZG/FbfItH9hpWdWFt+aQjLytElRHM+BzZ8y8B6Ncoo9v2bIUimVTILyNj8EUeC2GHykfypmYkooGFOftF14a+0XVNfwhISuYFdPqTcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5235.namprd15.prod.outlook.com (2603:10b6:806:22a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 19 Nov
 2021 04:14:47 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%4]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 04:14:47 +0000
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
Thread-Index: AQHX2rsqg2QxafvOqk+EnT2R5OJ5LqwFyq6AgAJ2NACAAAcDAIAAIFIAgACFb4CAAJzpgIAAFDQAgAADGgCAAAVWAIAAm06A
Date:   Fri, 19 Nov 2021 04:14:46 +0000
Message-ID: <7DFF8615-6DEF-4CE6-8353-0AF48C204A84@fb.com>
References: <20211116071347.520327-1-songliubraving@fb.com>
 <20211116071347.520327-3-songliubraving@fb.com>
 <20211116080051.GU174703@worktop.programming.kicks-ass.net>
 <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
 <20211117220132.GC174703@worktop.programming.kicks-ass.net>
 <73EBD706-4FEC-4976-9041-036EB3032478@fb.com>
 <20211118075447.GG174703@worktop.programming.kicks-ass.net>
 <9DB9C25B-735F-4310-B937-56124DB59CDF@fb.com>
 <20211118182842.GJ174703@worktop.programming.kicks-ass.net>
 <510E6FAA-0485-4786-87AA-DF2CEE0C4903@fb.com>
 <20211118185854.GL174703@worktop.programming.kicks-ass.net>
In-Reply-To: <20211118185854.GL174703@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e552e8c-356d-4c93-8ba5-08d9ab131f77
x-ms-traffictypediagnostic: SA1PR15MB5235:
x-microsoft-antispam-prvs: <SA1PR15MB5235514688EDD80AB9741CB5B39C9@SA1PR15MB5235.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bXDy0+13BsgZdfHVg0IV6+31ylqdSQfoKYskMS++WfW7cZlyztiXQu4FazBebl5OvrEHvV+FtRN3OA4T6g4fcRq2kfpnYzo0kOQ1XTWpSgFlK9JaF+APHRrwjKEtwdF18k0st6GaaHmHu9sTODqhM7nEu5FgNj6jE1AxUypMSeXT9PDI8oiGD7F3STIBT+Fx1aKyj4zdny3cx6Q6U2aGuIT2kcvzsa+PR4/rE8IcVrcIxvxDTfuIohljkPjMuS6nywONrIRBPvIsVcTNcmimA5e4WDgrGzX05fSQPtyCmYxQKbeFRXjLtOXc9AUgcP4PwWHiWjPuNs3+WRUn3u2pr/J5hsAQdIdrE200qI3z5/IYWtN6SdiKGbWj+sV1oYUKSrmaiSN+vpE7zZsH43FiurMflFjEvQGeJvV5Trgl0BD3L16A3EdpjHFzCJhI4kHC/SQSvEHlQ6RngkryxjeMC2qMop2RUt3AEb63Eyhr6Q6i70U5zc4MiGSHxSMDL6/GgG7cQmJAIMqirokQl4CCcbJX0cKmM2DbrHCKX7f8+l6wa0rTS9RkSxzqLLnubDBZmDrd8XXECcdjUiPDjMK5RIc0Td7G1+W31twJJ0JAmSMjopcFcpgnbcWNmQhvzXopQMQkTUG1rxGzSGc0Ct/7c7L3nHLtd9F03CsLvQqnFZqVfGaLefLJU7Tw4rFwaIIrk9OvNhy6Hp9LUV3o3gauuNJoL7Yxb5xWHD9sXaW4eh6zFLYNgdhD+599YBqc1iop
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66446008)(66556008)(53546011)(6506007)(8676002)(38100700002)(186003)(71200400001)(36756003)(64756008)(33656002)(66946007)(54906003)(6916009)(2616005)(76116006)(8936002)(6512007)(91956017)(83380400001)(6486002)(316002)(122000001)(2906002)(508600001)(7416002)(5660300002)(86362001)(38070700005)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8xoGRLxOSBlATovCh2VQ5TeJXsLP58XBvbAVsrpcAauj87w7yNP60TL43KhC?=
 =?us-ascii?Q?/TJRLT/La720P1lEh3lUkH6FGhyNt8qMJ+E//Aw/WEq+cp4rGHKgzaSb85Hb?=
 =?us-ascii?Q?e0qg6kYUsh473MDF7ge+bwq5HQ/QEZqr2fLaEmY8CpSTE/LxvPxFSQtA4XhD?=
 =?us-ascii?Q?+ioxE+mbPK0wMpDDd2VPtebz7tm6peRWgIoVU0cEygaH3FshBTOVopHLoZJv?=
 =?us-ascii?Q?K6Ou8KtbSNk6RbP8MLB5BHtVTsZfSASlNuGVUrrbGgi+I/h/hbmt2gEAqPcs?=
 =?us-ascii?Q?vppIjkPDdv2ZVmWpYhXAr+hCOkNI8vLNdDo3xhavMY9n90Y12LbyS0jhCb75?=
 =?us-ascii?Q?esXabvzWspZf0IVXB0vXa/6rOouX1wI6oTlIg0ejg57eVhlJY+NPxDpyxr7U?=
 =?us-ascii?Q?8Vuce1Ti3AP64gl1lMuTn1kJ6uWr+kFQEXip0Srz6KlZ28FOlO/2Z4FZtjpX?=
 =?us-ascii?Q?eUK/kL3PlPR0L2nNIb4Su7sSAolAIOyryxHGoLnt25WLvjo4StyOCwMY5mcj?=
 =?us-ascii?Q?sOANHqssWaIVn5b+t/1BhiItL6Tn/nRLZbAVmBk+XLPjlX6Jc4XlRujaDKFj?=
 =?us-ascii?Q?D0oWcvqvrGz8TzBm9gGYfrJu9BnAT9TqDlAWnscYCnPElorfzZgBAtnnJokt?=
 =?us-ascii?Q?Ry4CoA2AF1LAgfi53EgTwCKGEgCoFeLtRoLFRnstiQee6uYfhcxq6rW7Sioo?=
 =?us-ascii?Q?AJcyxzamnt9YqaSKemPAuGDbrXyvMfCTC9f+Vebd4qBuIG8OV5h4cW3/ZT3a?=
 =?us-ascii?Q?l+NGndAeQw5pyIJ1rrkFCnxCUhnKjSPPwMhyyA5yVN7Hgs8pf2L9Y+pkDthy?=
 =?us-ascii?Q?/AxcHg+6V//3hCsJfkRbnkY22cL2PxxtpSa7ezJ494EF10zBQsYLKMRoasI8?=
 =?us-ascii?Q?6gE3FXR1pThJB5To8vVhh8zSFGD4OG1oINuwQC5L2KBuK4gWbBef41b347R0?=
 =?us-ascii?Q?dGmPppnkRms4rBq/r3rvN9VcEwwiaA4rZBNafEPb9zeK0zZczdSihZq6ojyO?=
 =?us-ascii?Q?N6GvWxcJVEIxyvkftM4ibPL/j8JPs5FUuv1GScuTbDbnG/HmMBpUj7JzpjzA?=
 =?us-ascii?Q?mXJ/dB6sc2WKBbE585ayphyAYeExct3NwrqsnrY7Ka5sRZDpCAcQF3em11qX?=
 =?us-ascii?Q?S/uKdyqQgSbHffVPogsohYFSuIas7dSfwDOWl4BjXlpzJHT6Q5X6tuFpW51m?=
 =?us-ascii?Q?UTFwNGhQC2aQSM7PjdyiUHd9K8fpjqNthUWX901zn2PwQxjSWh4hxGBsRblK?=
 =?us-ascii?Q?qm/CaVBGX8TnotB94RfBWBwVWYzSD7dfFYlCjMNLJNQO8DEVpCy5UVFfazIG?=
 =?us-ascii?Q?RK9kMYfE5W609vML5sXt0Pe9TOIW+Mr8lKx0Rxo7M3OeM3EM3TcE4UpRfCrL?=
 =?us-ascii?Q?bwBJMhgE5buLxA60AGIoeGRloffbiYK0HVGTQ2XqCtsDGfvmH8peCgfFohFn?=
 =?us-ascii?Q?evlfnCCvnuY7TR33UpA0M1omAoeOrjOIdyG9oczTnyy1lKFibFaoJ5jbAzxW?=
 =?us-ascii?Q?g4szydVp3LUUdXpFJOcjelSEid/pLOxCiY90d6ORAihnkFVhqpvQ4RmuKvbq?=
 =?us-ascii?Q?6unqABXTv9Sd980fZ+XzIG6w58MNYk5ft2OpsSufih2N8AXm+zv9UNQGMXKp?=
 =?us-ascii?Q?09woFyzLRFdeN8+7QYSHsjFVy1EVf1Jo99MSZGHHvFeEq+yE9as0PmOkcLYd?=
 =?us-ascii?Q?5hZ7SQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <892FD7D1B547AF42845F0F719C88C41A@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e552e8c-356d-4c93-8ba5-08d9ab131f77
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2021 04:14:46.9157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5kq93VPltN+aWBgOnrXSpxveeSpjKLyrllOy/ylb5ziKzzgEdNnpQjwgOH3GHTVZE+07eYHtsCnJ+IlzOLXLkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5235
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: iUdfT-li9uLRsoorgnYfH-5uhdei6Pmj
X-Proofpoint-ORIG-GUID: iUdfT-li9uLRsoorgnYfH-5uhdei6Pmj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_02,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190021
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 18, 2021, at 10:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> On Thu, Nov 18, 2021 at 06:39:49PM +0000, Song Liu wrote:
> 
>>> You're going to have to do that anyway if you're going to write to the
>>> directmap while executing from the alias.
>> 
>> Not really. If you look at current version 7/7, the logic is mostly 
>> straightforward. We just make all the writes to the directmap, while 
>> calculate offset from the alias. 
> 
> Then you can do the exact same thing but do the writes to a temp buffer,
> no different.

There will be some extra work, but I guess I will give it a try. 

> 
>>>> The BPF program could have up to 1000000 (BPF_COMPLEXITY_LIMIT_INSNS)
>>>> instructions (BPF instructions). So it could easily go beyond a few 
>>>> pages. Mapping the 2MB page all together should make the logic simpler. 
>>> 
>>> Then copy it in smaller chunks I suppose.
>> 
>> How fast/slow is the __text_poke routine? I guess we cannot do it thousands
>> of times per BPF program (in chunks of a few bytes)? 
> 
> You can copy in at least 4k chunks since any 4k will at most use 2
> pages, which is what it does. If that's not fast enough we can look at
> doing bigger chunks.

If we do JIT in a buffer first, 4kB chunks should be fast enough. 

Another side of this issue is the split of linear mapping (1GB => 
many 4kB). If we only split to PMD, but not PTE, we can probably 
recover most of the regression. I will check this with Johannes. 

Thanks,
Song



