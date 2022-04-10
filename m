Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818DF4FAB5C
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 03:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbiDJB1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 21:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbiDJB1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 21:27:53 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A06D87;
        Sat,  9 Apr 2022 18:25:44 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23A162w3022639;
        Sat, 9 Apr 2022 18:25:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=/O6WunaalM/4iEbHfJJC2ytOZAZLCZLhKr0/kfyh3So=;
 b=Qe4uLNmyq9qprJwMIFFAA7EvHiWH24dnfDBZUXkmlUWr58Er1BNAQjyibCnrN8pzBlbt
 AeM+1I7khUyla8dQHUEiKUs+FEXoxLqvzeHi5TOtj0Ghw+gmgDdPSua5w9Omvjqq147/
 hWXLMbRSVcVztxNMTQxYC3mRus8X4NKFb6g= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fb5n7tsre-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 09 Apr 2022 18:25:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TY64cKR1ba3vruhjagsAJwNzmRgfJlEDdWpn272lS8uM1/G97Y5ok5nkmEm4xwS3NveSh8DKkLRWnwG6nczTujPgZew52jBPOY8oM3P9vFCn3BkuBIf7pcQsC9pweIKpT0F5FAJN92EfG9sqJ7GB3wshRa6X6wyq7XVhaBLftbUVdVqt4HFn/g3qQEU/ZWGOQBYUv+Yc6IJ7Z3PlD5Dw9p5DXg7xWZck8jBz6weogYiYAL5GPFGfOO0PZNU0tZvBJOrMbF+B0h6fGtBkZ4Ful3h5oVnS4M7tvPD+Jztz7CsaHFXEqiqKckXb6Jiqyh2fRPChsmsk90AcbABzOGQBLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1RbzZAcx3LPx9hYmS5LjokdwSab49mU5lo00BTLqBg=;
 b=NwZeWf8C4Z2Vn2DkG/NfUwC7alqspvN2uN6ihJ/hlwozrZ22CFpwmdXdtPJUg/4W1jwtgCOtArXimGK7xf9n6illqpV4KnU4H4jnYt+juXKipT8oaEs6w5MWNormOs8SpMpx6WTqh2lwxWAASfWR/IolasQFM/RNpqIV9Yrm/z5wCFV6Y1Wd4pxxuxgKESgKwUNKbxgCJUh+zLbSsOBF+pMwYq34Cs9S5QSEf+87fXoi1P/LbHMUsZa+ANQpXC3zVFHxckdbzzqDLpEDhZeG6NfhI342X2fhUYCEQfXFOpboRjIuBQg3ttbOPgeNMvHF7AJO7d6uvu2VCkKune6HtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MN2PR15MB3565.namprd15.prod.outlook.com (2603:10b6:208:184::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27; Sun, 10 Apr
 2022 01:25:41 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e150:276a:b882:dda7]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e150:276a:b882:dda7%8]) with mapi id 15.20.5144.028; Sun, 10 Apr 2022
 01:25:40 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>
Subject: Re: [PATCH bpf 1/2] vmalloc: replace VM_NO_HUGE_VMAP with
 VM_ALLOW_HUGE_VMAP
Thread-Topic: [PATCH bpf 1/2] vmalloc: replace VM_NO_HUGE_VMAP with
 VM_ALLOW_HUGE_VMAP
Thread-Index: AQHYS5m3yAbe72P76EaO7d5i7CEYDqznDf8AgAFOlAA=
Date:   Sun, 10 Apr 2022 01:25:40 +0000
Message-ID: <4D0216A9-E667-4936-8FF7-A1B94E973720@fb.com>
References: <20220408223443.3303509-1-song@kernel.org>
 <20220408223443.3303509-2-song@kernel.org> <YlEZahPCTI/qh/6u@infradead.org>
In-Reply-To: <YlEZahPCTI/qh/6u@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0360593-5b1e-4e62-3dae-08da1a910697
x-ms-traffictypediagnostic: MN2PR15MB3565:EE_
x-microsoft-antispam-prvs: <MN2PR15MB356520085095BAC1C58FCD35B3EB9@MN2PR15MB3565.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FHpZz89wVeOcPNt+qYa43mU9d1Y1nCf1afnQ6ERCdmVcAZWCS+CH3uIchz0Oph/b+hboeGuLSEFsHCviRhVcEDE64oXvAVZGuFRoxioItqj9rAJtm4cDIPquErQY5iKx2gBXNQ3/sEbq91mcX2UGZQzH0mS1Dd6Ba6h+qGzycMtSpIydLZUQBvPnObwHeypr3qrv9m5CpYvky3IfoTYeqaX3h1EZZcitWFo2a+rtq3cQ6SmuW0Id0uiBbIpZa8nh1mBiKG1LH1Vp/hd6XlVYsXlIZL5qsXxImnVFmkNRaVSwclSHt4GCqTYet8YkCED6x/pPZ/XOavODMO63us2zKZN820v9EayPO/tcrRMA26hJWMDBEkwYKkpWshfmffjSjAlBNuNyQrZ6+ejEBP2FxUWIkqBuDS59Gl//Y/KVZgiAm0bXk4r2xRuQYas8PFBapRCS09dsrvDw3/17kfZ702oprfEtGMNalflOAVIh79ZjrsiQhJqfoFyIlrbAwUiBve8GsShyH8kg4GwquATy3h/BEUh9Af0W0o15BpX2hP0b8d4nhbov1m7OX5Xj1Ygl1yf1KqGLBuJUrFOhJ+BoF6YgusDnVyHE7xnxm9MbqixsYgUghUZaevfu/Jq+nSoMZjPU5C/KeFr0Vkh61la5gLQwo6tPeGl2BKPApPW8XpKmTe6Sn1KeGG+GAhPUZDeXE54JIXGM/zAnTkSz8uyo0q6WaoVG/XYW4ZYcyLeyoaHTlbwXyQ9UVFHuYJnhVaiAf7CF+fVnU4LbapHWJEx4bw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(64756008)(66556008)(8676002)(4326008)(66446008)(33656002)(6506007)(53546011)(36756003)(91956017)(76116006)(66946007)(2906002)(86362001)(38100700002)(122000001)(38070700005)(8936002)(4744005)(5660300002)(7416002)(508600001)(6486002)(71200400001)(6512007)(2616005)(186003)(54906003)(316002)(6916009)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SUR3frbYDP61FZKrlPtLBmgsaWOYSV2RMOHBmgf+hGQafP1ktIen4h9fk1qy?=
 =?us-ascii?Q?reGLfhU+IP+hr45Eme0mq5zljO4oZyGHW4o3FwAoRAgGTUr7WDga+XoMwifu?=
 =?us-ascii?Q?IYE0K5S+xY/XrHXbing7BpJ+cx6NZYiVcN38kkqDrZKdJE0rZCanuC+OMl38?=
 =?us-ascii?Q?IyEzjckZtoGG71M/KceEsvq1zBt9ZtRaM+f23iE3/caIKoBG3BH7kFKw6I5j?=
 =?us-ascii?Q?6b6Oy3kUspJfE+uBGFmIEV1y7WhzxYx+cG64GgGhexbDuTMYq5BAfVeJ14vN?=
 =?us-ascii?Q?70QS6Xz1qlZf8lvDHDUBPmMlkYt9c5wfInVnmOm5oAbGB3mC0U6NlxYkhckL?=
 =?us-ascii?Q?dRDg/GF5RHtUZ5MVblHMa8apT005PIQ65O6uIqclr4/xWSMM3ipYLg7maCGr?=
 =?us-ascii?Q?SPPbpjgzu/MevO+ARXBXuMlEndXjTz08/LEi2USnSZI4lujitMhCVRndJn1B?=
 =?us-ascii?Q?MB2pq5YrRZSkQLAH8kduPvUMPaFLqcLYFNPtBC706JzPl1FHHqlFttRnGSxH?=
 =?us-ascii?Q?kjbBNjOAqGQWFIOueXIpSoZ+V1Q3ibLsJawihM2/omXF5eA93h0l8VmMCSaY?=
 =?us-ascii?Q?D8/petJwoWNXQilF0GB61wgRgyJ+Ps3DJA4sgBJvIb+6S4Rr3GAMFf8/4nyf?=
 =?us-ascii?Q?uexQ6j4PUGBM+dQXBHEjEP2Oga+1mzc3sGgmM7G0tZ4sYQ89aibBaWAzvOvc?=
 =?us-ascii?Q?eaFg8iBBj2BzUg1qvxpl+5k3ed6F2u9O6JfH5V6ojxx39482bwKH1C3KLvMX?=
 =?us-ascii?Q?F+74+TADiVOlXQ/yNcRLqHBDcu6iDnJdNBJkPcTIfpLWOTp2GtCJQb/7SESW?=
 =?us-ascii?Q?aS9D+qH7MMRu0tQ9fsKUsULCXeEO5qo6qCjpRLGzscCNE2kkYM9rEtpWHl4A?=
 =?us-ascii?Q?u4V5qP+aBPKc8lI7p84dyYqeAKWLYhfWjqWLaQBt5BebHw5tk4AUJqS/tdP+?=
 =?us-ascii?Q?Tj4nqOLzZ0T4QGmwLdEzI58L6xSlh8M36+gFj5NH3qRi3+cdfRhYmRt5ElxB?=
 =?us-ascii?Q?rm6j+d8Vd70j9kujcEN3jPC4+pR4P8XtYOJ7fzKLCoUeK02lkqEtzqNBQDtO?=
 =?us-ascii?Q?2vKetd2Ubsgat1rhDiXLj83bqUs94jvTLJRRez8VdqOlIu1984SUpUyg1OjP?=
 =?us-ascii?Q?FN4JAd9Di1iSTIgdj8OOI/Tb5/InmyV/0/Bu/l+pPft7dq4rMX/5oNmJaP6i?=
 =?us-ascii?Q?EMGYygR/HEAX5k4GpzGg2P53uTZm8Xy/9mNHHsEpZ1ZG3u59Bbg7F3xk+zCV?=
 =?us-ascii?Q?sXShIi4TI/T0XmWSF9GSnyT8YUIHkEz14NanWanak7+qnFPxMsoVOVkimDDm?=
 =?us-ascii?Q?ke6HpLq8tmgIVViMOfEew8W3XH8rGJJhJZWeCVmcs+PICcnsw6HMG2KFZjTC?=
 =?us-ascii?Q?g1JKg/LyDGHrmlwY7bf+5TbzqwkDMIzQmwSqEe3PGfd0hMoWMicvsgzsNZV3?=
 =?us-ascii?Q?duMcDbpsc33E3iNF4KftNes3lYRB+sxzCiRupImbG7q4InhQYu4242Ul9Z8e?=
 =?us-ascii?Q?4yxKSOm4p/KVFFc4XKNhYtMzWRTgrelTOF+IRVxGXfPCnHnCO/M7lyEVOw7M?=
 =?us-ascii?Q?0RJ/nJX6Yjt3ccm6KKgyMgT3aDU1VwvmW7nOyf+g4KKoYwMa8Tmu1WVqfaRu?=
 =?us-ascii?Q?bkQ/HKl58AnvhdpS06ktqDwOE3Q8ynJJSLPQmvKnQ5G8AjzUK/njjdycCQKD?=
 =?us-ascii?Q?jIBxkDdiLIGQ1x5r+DQiUShqhb+FRAtS/KwoHjsqbfT0Hg7qkO/JlU3limsb?=
 =?us-ascii?Q?MqT3+3UONT/rZgt5uHO41miYeTD8hHJCcZ0FbablxXsQPGiGbs39?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C2AA698A4C52D34CA2039E2BEAF27DF1@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0360593-5b1e-4e62-3dae-08da1a910697
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2022 01:25:40.8720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j5QkwWmoMs1vCOXmOkWnD5q7LyczWF+pU03TgkAQdabtteQJhYyrvFReBxlEgffmJvRcHwFjdZarQW9aA2w7OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3565
X-Proofpoint-ORIG-GUID: CB0XSUi-uESCrhQMGi5WCfjFWfSq9kqe
X-Proofpoint-GUID: CB0XSUi-uESCrhQMGi5WCfjFWfSq9kqe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-09_25,2022-04-08_01,2022-02-23_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 8, 2022, at 10:28 PM, Christoph Hellwig <hch@infradead.org> wrote:
> 
> On Fri, Apr 08, 2022 at 03:34:42PM -0700, Song Liu wrote:
>> Huge page backed vmalloc memory could benefit performance in many cases.
>> Since some users of vmalloc may not be ready to handle huge pages,
>> VM_NO_HUGE_VMAP was introduced to allow vmalloc users to opt-out huge
>> pages. However, it is not easy to add VM_NO_HUGE_VMAP to all the users
>> that may try to allocate >= PMD_SIZE pages, but are not ready to handle
>> huge pages properly.
>> 
>> Replace VM_NO_HUGE_VMAP with an opt-in flag, VM_ALLOW_HUGE_VMAP, so that
>> users that benefit from huge pages could ask specificially.
> 
> Given that the huge page backing was added explicitly for some big boot
> time allocated hashed,those should probably have the VM_ALLOW_HUGE_VMAP
> added from the start (maybe not in this patch, but certainly in this
> series).  We'll probably also need a vmalloc_huge interface for those.

Will add it in v2. 

Thanks,
Song
