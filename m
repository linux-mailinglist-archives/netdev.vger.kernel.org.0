Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF40454F6E
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240361AbhKQVjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:39:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22886 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239950AbhKQVjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:39:31 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AHLT36G001686;
        Wed, 17 Nov 2021 13:36:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=TXZF+wYkUZqluy7BUqpkHXEA0x0/993roHoNTlrCGs8=;
 b=pZcnmFFuTV2PnAvSik0EBSCFk+h274CqVjTiG97EX5pt122BiSe/g+dEnClK6pJ2r33+
 0+mRPXG1uBobxFjgS/tgWE9KeCw9mSS1tptb62QmdmG7tOPEbMgqSRVegeDmDq5U8KfF
 abI9EBK0KVCKwpd6ZVYG6r+S8yqKwc+UwmY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cd4bxaq9k-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 17 Nov 2021 13:36:31 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 17 Nov 2021 13:36:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMKKuAZoVL43cv+pejQjNgTlppIOxg6PpJTP8g5+8GCC5vnwy4ybcIznrRpT4Vfoa42+bOeMz8L9hphngOvTKL17JlaGtzvxMrPLnJSR2bPmHoTZTwGZxLMrH/frn+3sHElSU6UoKd8FleBmCoXPVlhLP9QUlY/eJoTwc9DSCcy4eYrc5gJHzF/V6nXk/JD7EgHQ0ViI6/J5dn3m/g2DGDA9psoTaBm+NM8IqkuPZTYCpx5yocqPrVAuNExvkcuQi9OB5uYUKndPRGGW/sAbYV/4fg47zyXOeKIUDwwgNFij7rsYMwmCAGYB/RIXwkTobKQqCMl2sTH7x6GRwRE5kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXZF+wYkUZqluy7BUqpkHXEA0x0/993roHoNTlrCGs8=;
 b=FszuhC4OdHpkBYSQlZI3E3LeckrnXC95FKxZnr0rvORhNIELikIIRBsgRDCjMFdUu9F6/4ADG9ExCfy8XV0n1wTwMk5hK29jnZdm12H+L1ThD5U8yGRcrmDAxvf93slGMMdKlRUqhZLplOEgVGSJ9h/uZ8Q5JGi+deVLEV2lICIwCQGHMa8H2MFzvyv/hAf7T7R7fILEwAl7G8gKx3oMv3DcbJvcbcDmaPcJZcNjk0WtR69S5bDqzLS/t/pgNBAECRKUQavQHsTN03tUZKLfAb3z7pZJ4l/s1ZRf2DJRUtlkgVO9VJsN1iV3y9ckaHzCtx6S6rUkB2Kcai5zBoDlTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5137.namprd15.prod.outlook.com (2603:10b6:806:231::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Wed, 17 Nov
 2021 21:36:27 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%4]) with mapi id 15.20.4713.021; Wed, 17 Nov 2021
 21:36:27 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>
CC:     the arch/x86 maintainers <x86@kernel.org>,
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
Thread-Index: AQHX2rsqg2QxafvOqk+EnT2R5OJ5LqwFyq6AgAJ2NAA=
Date:   Wed, 17 Nov 2021 21:36:27 +0000
Message-ID: <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
References: <20211116071347.520327-1-songliubraving@fb.com>
 <20211116071347.520327-3-songliubraving@fb.com>
 <20211116080051.GU174703@worktop.programming.kicks-ass.net>
In-Reply-To: <20211116080051.GU174703@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02633aa0-1ae3-4920-2352-08d9aa124ffe
x-ms-traffictypediagnostic: SA1PR15MB5137:
x-microsoft-antispam-prvs: <SA1PR15MB5137F4326C13A90E024FFC3FB39A9@SA1PR15MB5137.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OJSN7p/2E6+Wfc5/7134JZPjqj2ceqOGSBWLt2Cxo2B1T+yUqXYVy7ln6P3BSsSJt1/EMM7kG2p81moYcW7L1y5QxUfdzDv5hVmaiMxmGW+AGooPsKkoRiB7HXNF+Qo8O2aM8b/X7ATiBI5kAdMArPjHCBX4AFkmgU5d2yd/Q5HLvo+LaQzvF7P62qSaf2LRNvIDpk69+yEMREexpHV6x2KDoh+QD3fowH3nWJYgJDLRU/flDU61SeaS7vbs5lKcScoue1QjB4+3vAEnotNHwaynHCkXpJo9VOjJyd+xpjHP5r3zuCrK8dZ4DwaKOmvH9NktZaH2uW+Jri0Z5pqdjHvJxGNErP1nCuwzKxMNj0cc03HLWWiL17W0GhxaWXjwXD1CColByKlWbqPVuJZ+HVoTFCDOD9rjqiLHu2sRODtx9QiB/wke3UjBGTf0OPI/qsdpDcgFDUy6u14f84lbmQsQejozPWCgvu0m0yKeMeGF1Uunbnq/TAI4HoDeiNt4YD11lt0c+PAptQWcOfIKD1Rj+Th0kFQqPpglSKx8GpRpNjg3l3IHb7nMrK5oDJjSjCbUyH/oLyl3zCWG0i/DV3N5Qeh4ZRfzR8ct6tvAizQpzFb5+2AtpliS/rYNzIR+TWkidNPy8R7tPAYgTZBCKRc7LTNLcoBlboihG8JqkOezfYSiG97c5oWTtM0hnzQqhUmAqiw+C9Wb7A0D9hoMthNnruw+ZG/KIKZKjbRxqiJ3tnrA9CkxUDUxRF62xtXN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(33656002)(2616005)(4326008)(186003)(6506007)(83380400001)(7416002)(66946007)(86362001)(38070700005)(71200400001)(122000001)(6486002)(38100700002)(36756003)(110136005)(54906003)(6512007)(66556008)(76116006)(64756008)(91956017)(2906002)(8676002)(66446008)(508600001)(8936002)(66476007)(5660300002)(316002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rcZMiG8ijUjCjLnQjypSOV+yYhcJPdlRjf2qBmDRy6quyr7D8WgHWddq+Olp?=
 =?us-ascii?Q?hwTFhbi3QKZ0dTSfsN1ZUC9Awmr1ycVlCiofPWQBRlkzFBB0/4Q7h2sOons6?=
 =?us-ascii?Q?Qnd1TlpBglJmaV+TPBRE3d5uD+vCEMPZPKuC6NVQ2Gy0dMqNHFU4EeNnwv7y?=
 =?us-ascii?Q?OU1hbt/qypvOpfwzpcozC4UvFrX5hTtc/tmXRG823b+C0Kl42RQ/gOoovNAD?=
 =?us-ascii?Q?WSXjJXnw4eejke0E+YPeRhdiZ7jIvQbARGdiw/AaHvmflavQycmFBYGFYTMq?=
 =?us-ascii?Q?0babDXa9sgBC528YNnFZ1uIbV2EL3lGdgt0sKNf4OR/2UF1WBFrFLwfw9Tux?=
 =?us-ascii?Q?6RJKVhfBf+Ouos5PyiqMw6V0vsgOJbW4K4Mh4Vs0cdh0Re3e/EH13oc6IhWt?=
 =?us-ascii?Q?uSVgGbJ6RLxfK2KN582baaxeQ1/TQashY/UCIGGDPp5HLh8oN9OHFAPt8iZL?=
 =?us-ascii?Q?qaWrzS0sVl0mMzogz8+ZMT9IColZ8k/eAR4/LSMqxIjfudubJvNRgH13jD7q?=
 =?us-ascii?Q?NUZtrl7TK+S9rHTEilY0alVT4YnzqtvbOn1gP/FGPNIdbolL2w3BYik3GSXY?=
 =?us-ascii?Q?y3tmk5WqsQqmP1hnzUa9b+vP3wOgylb/brC8aPjDraWZ1nIpZr+9TTe285jL?=
 =?us-ascii?Q?dxfvG8/wTuZsA0XB8+xsBGcCvb+EW1Q7//e9g22ksJ59GHDuW0wYadoB3DXz?=
 =?us-ascii?Q?xJcLwekFXus3DcQPZpaXt/9CAX7HwwSzVrCFypB11DvU9kTOf3sfB5T0FUX2?=
 =?us-ascii?Q?VqWE5Q4uJQ2BqW/WlACmff6FMkBhy0nyulj9oQhRY+ImObF5bRWVlaiNFD1+?=
 =?us-ascii?Q?4KLKff1QPTaW/ymz7976LElj9kHPutS9D7fl/hYrPAf/tL0E96+PHMMZEoX3?=
 =?us-ascii?Q?U9CwEy018JNWp7ehN3y+54FYypYJxhGzUKTNu/ufoMjONsK/RUmi7EjGl1Ry?=
 =?us-ascii?Q?Sxp9k1YzAZn7U7pq6b6CJswz21RSx398RBTaTjH894atayffavkzMvWpZiqA?=
 =?us-ascii?Q?zmowmoGOmytlscHTZpYFqG3RfcssnK2ZxRqLt3nEgM4ri+iSY7TMSzkFo9Oj?=
 =?us-ascii?Q?uCtCv6SFXquyNPAOcvFTXD9p950jE3vynIRJ9TOLc/hbWGkCCbIfo+Wd/Zuk?=
 =?us-ascii?Q?C/2tTGc5HoRVs/NU2TLkOWsUa/Ij9zoQ5t6pmivLjMV90lxFCRKOp7eFpwNU?=
 =?us-ascii?Q?FYc23VKP3CwgdLwIdfBAWYu3pnyGTmy4k+WNvTaADiNt1P4mTLLf2Ws45acm?=
 =?us-ascii?Q?/tovyqz2XSSdGbSdoQk4jdFN+wWdbMlFEUTdvBhaWO7+iDH6LjXQ62Kz8H+p?=
 =?us-ascii?Q?m4X0QFjUKGynPaWUQpFCzmCTVD/4ULnLlqjN3OLIa7Ka/dyDUEygVLnngJNs?=
 =?us-ascii?Q?rvP9PSC07CVlhOqF02vOua/IQHtbdBrr8uP0Wm3XVtG8i9RJj4Mi4bjZ1K8r?=
 =?us-ascii?Q?E57FXaWZzBLgTn0ponjqqTNnDtQ2Q327bZI7pO0RDTyVCPbM1biCmgg9IcAW?=
 =?us-ascii?Q?N1QN1r8NoErN37XnIiP3zHquL1YHSX9wEZr+z+OD1yjY+Dr1UEZReGIR4keP?=
 =?us-ascii?Q?hHrEss1dyRcBS8WqLFfWl0vLdsQOUthpmpNAAApw1oSFscnluA6GKJ0KP5Dk?=
 =?us-ascii?Q?FxoCzoUoRxNWhtSpam/EGVJ9wKdFC2nSe8B7IXcFvZIXNEaehfRNd33Si2JB?=
 =?us-ascii?Q?Sn+mVw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <137D37CAC1074E4DBDF968068859F5F6@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02633aa0-1ae3-4920-2352-08d9aa124ffe
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 21:36:27.7595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CePoIvdc+Mr4djQIkrsq1CJQeCPJx3LzABAyT6qK3EWjmiDSe6VZapRqfi0YRMLREq6kexUPO2RPWbpn8jLC9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5137
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: QsX2MUHCJLzDDZ_tqEjfmSh2Sfx1y-r-
X-Proofpoint-ORIG-GUID: QsX2MUHCJLzDDZ_tqEjfmSh2Sfx1y-r-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-17_08,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 mlxlogscore=679 impostorscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111170097
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 16, 2021, at 12:00 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> On Mon, Nov 15, 2021 at 11:13:42PM -0800, Song Liu wrote:
>> These allow setting ro/x for module_alloc() mapping, while leave the
>> linear mapping rw/nx.
> 
> This needs a very strong rationale for *why*. How does this not
> trivially circumvent W^X ?

In this case, we want to have multiple BPF programs sharing the 2MB page. 
When the JIT engine is working on one program, we would rather existing
BPF programs on the same page stay on RO+X mapping (the module_alloc() 
address). The solution in this version is to let the JIT engine write to 
the page via linear address. 

An alternative is to only use the module_alloc() address, and flip the 
read-only bit (of the whole 2MB page) back and forth. However, this 
requires some serialization among different JIT jobs. 

Johannes also noticed that set_memory_[ro|x] for kernel modules and BPF 
programs causes splitting the 1GB linear mapping. This leads to visible 
performance degradation in the tests. CC'ing him for more details on this. 

Thanks,
Song
