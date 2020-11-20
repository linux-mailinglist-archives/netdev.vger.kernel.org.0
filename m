Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62182B9FEC
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgKTBpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:45:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgKTBpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 20:45:05 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK1ari4007110;
        Thu, 19 Nov 2020 17:44:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Bcaqnwss+kj1PNod5B2cX9ILBvhKGUGX2KjdQrh9kwU=;
 b=P8Jb7ggmJwS55BI95rICwoFvFLVNMVCuX0FYWYiKmwa302LqXsU9MgVgmuYeAh8BMFC1
 MVVL96VDc2Bd+xI5AL8m2938QGsEJiuUUdRGx7ES1NfYnLafy3MH4eJ2rhLLs8TyD0Vo
 pHGA2XnsnJijMGRB3z5kswiCVS6NfA77ZzU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wgckrv3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 17:44:49 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 17:44:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSvkN12a4DPARbq5k8k15vgWbFczCg8krTtVraJFStCQuflvIUaC/WN3fNPpvbMfj58Yof/Jq8RXiL/hoKYER87zdkGITQKX5vakCdoS5kUQEQt+F+06+CruiY0aGHxcECju0FMtjJ/w6FEENcrCc5Lzy9yPj3ucOI3b+ZZuCOqOxUjiL1tChDMLlEl430rSkbppXU3kB53W8qlbLmpQnPX+9l5HpQrd3yeqFUFUKkS22ZAiQCyoZNH0BbhK2QTO/MIq6yY+XX4f0cA04MIt5Mr+KrLJUCHCo5h3Hs6nPhKJr0it/q8kq3t13LG/Pnw6qNRmI3jaFRPMg+IStcFkxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bcaqnwss+kj1PNod5B2cX9ILBvhKGUGX2KjdQrh9kwU=;
 b=g1eOT28Kmp9ZJuTsPoaKVd3FsKGRwH13UiBVa6dJVDcfGm831DKnEtxviUDO7cLfSf9gGM9x7B04U+UsKvmu32/CWy4H07/5Nble/H1h4eMpuC0d68rCdb0187JfDgMo0ZJH88z+xXPMRdWfmJXPdHjAfqd9QQgYV6DilTnmSOVewOq7xOrejHOM3tzAQsP9gztX5yb4lzEnnAmA58vcTDDf38tQZlShg76LSMOJYdH6X2v2WmJoT31L7YJluOFZsFSKKIZuY3J5RrL6qzNilcdS/OSSdgWvL9SlSfVmmV0cDn8aZF6v9EsvlsgBptp1SLq04joaeWOowgeJWI1OvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bcaqnwss+kj1PNod5B2cX9ILBvhKGUGX2KjdQrh9kwU=;
 b=ShGhCRnRUOHqPQGJ8a7TnuGLMlsdj1gYR75Uxwh+9Qjg1lSCAoKEWvjv29iVX14OIFLGHZt8eyIhdBKPqMJ4mTNVONRT28x537tzCKdTwr7lHoE9vkrHWcAwbgjscB7JbyV6GIu3/opFfywaytqqtIEdBER32PtXTGtGT3kTOWk=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3715.namprd15.prod.outlook.com (2603:10b6:a03:1fe::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Fri, 20 Nov
 2020 01:44:44 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 01:44:44 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v7 15/34] bpf: memcg-based memory accounting for
 bpf local storage maps
Thread-Topic: [PATCH bpf-next v7 15/34] bpf: memcg-based memory accounting for
 bpf local storage maps
Thread-Index: AQHWvprzeEkI/H0MtUiCZTmWgV7/5anQQDoA
Date:   Fri, 20 Nov 2020 01:44:44 +0000
Message-ID: <2D0B8ED8-D2B5-4C3D-804E-D0582C1861B2@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
 <20201119173754.4125257-16-guro@fb.com>
In-Reply-To: <20201119173754.4125257-16-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f2e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0f6977d-61c9-45af-f60a-08d88cf5db5f
x-ms-traffictypediagnostic: BY5PR15MB3715:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3715C0CD788EF74502E00EDDB3FF0@BY5PR15MB3715.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:260;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jQWaQPNz7vszt+Z9Yv5LHojzxAQ76uKrhdGFsTzruGdqY1A1qyoDhIw2Pyz4VsnBsdrGHPOWmQ2CH9xk7F5lCHv0hEb9dQ+6pIzQbaxLQM+draqMO0TnpKbLD92g1dShtmvZiHzY+P2CA6eVyA9rsJr1UZ3mA9M/P8eE2S89bqByx2F5XsiDssiqS243YMJFlbHeLUzT8Rm1kaqJJ4oMpN/JsUN0qxKQBFuSByTyOLKRJxt6sQQ+tb/NF/Z5oM3m5Zj4488t3vCOIEkflZlRwydcNXDiJ+1S+S93WrObxQW/UsirDq80zNQjRbO5Tj+elI302m9+MFdfPxzgRz+hYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(396003)(136003)(346002)(6486002)(8676002)(5660300002)(53546011)(66476007)(6506007)(37006003)(71200400001)(66946007)(4326008)(8936002)(186003)(86362001)(66556008)(2616005)(83380400001)(6862004)(66446008)(36756003)(64756008)(33656002)(76116006)(6512007)(478600001)(91956017)(54906003)(316002)(2906002)(6636002)(15650500001)(558084003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: h1/VT26k5QfvYdAikn4LdNBjWBU4zVcB3lKnOIt6ROKUC4RwGgd8i1OWWvYSkeGikwQJfn7bdyvMpM3gDsKm2GSapxbfuF9VJPmLBrKpMrnyTMvUZt7kMbWUyHRxujPsRZDo/jSCgG/We54eua+as/w2aqbo7zveegVNu2dFlIziKBh1uW/c5GGrjRtZPQRuDoAoUN0zT3z3/tiYYaNkpqRJb6CiYlyVRekUr5yLSZnSiklVIgeLxYOE7WN1Ygk9hfPjTDxsqf+UbZFKQqqt6//mfnB89aPg9axyR1Lxkf6nxixB3pKGTRXrqbWHeL7xrtauOhBQp3wqhBuWIoXQB2RicyqbzN0JGMcUnVYPHQ98NMy8mMDtPpsNSSi7pvslHAbaqjQUvI8u/wOK9deiCBMfUmTwkFih6SpiT56IPII2Spe0d+Bm6+5d2cInEGFX3/180bJLiClMj7Q6plGH/MsKMbPf4VgXjp0qbFhAPYedIO+seLjywk3cDvq2y+yLt7enjxzs34c+19jU/gwjm/55Cx5+biRuQbTE1pzwD+6MLciht+jILouLBRK3i1wwGJPBGzEHBjvzzwdFoF2i//NiNSgpBKcpIPJHmp/6xhRyFGpkX/W63GqMLaS0b8yiaIt51TmeouSpRzgh1Lbqsh895Y173bd64DGHnMCiI60JkSbvqzc7HLhOoh6AK2rX
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0121E184731B1D48B86EEE3CEF2FD98F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0f6977d-61c9-45af-f60a-08d88cf5db5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 01:44:44.7171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vTKy8JhjCkJ7gjNPTJELNhB50MPvRcsD1zmN9agguRgWphAtj8ZkvznmfdGRLgmwwNbLm02Z4NGSbYN7NcnHaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3715
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1015 adultscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=848
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 19, 2020, at 9:37 AM, Roman Gushchin <guro@fb.com> wrote:
>=20
> Account memory used by bpf local storage maps:
> per-socket, per-inode and per-task storages.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

