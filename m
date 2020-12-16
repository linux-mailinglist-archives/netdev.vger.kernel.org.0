Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D520B2DC570
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 18:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgLPRhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 12:37:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45806 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726706AbgLPRhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 12:37:01 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BGHUi0M030809;
        Wed, 16 Dec 2020 09:36:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QGEn7eTOyf58FmhAOxh68K6VPe3Fs+PE1Cc2wZo5hFo=;
 b=H0K7tSlGNn4gizNacg79MlAc5iMbyWnlwxy6GZlC5hn8ICgDbYdDcER48XBFJHVVd/h1
 GTwZbFlMz/77O7LdTXcX3izrLlcuWLjsnBbcAzXy95rw463T6yfH2tlS2XagQQN4ikXe
 OV+pmN+AYGt7PsPzz5m07FFtuj+qhCnlwCY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35f2tx5n4u-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Dec 2020 09:36:05 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 09:36:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DvZg594MttR9OvrGkvuVr905aNqSpZ8ZBS6qz4pP2egu4k1YnA1sXtLE4RW319BBT4wdBqCHSR8ujrHVBv7tE1yPq5+hih/hPkV1IpYtqKP8ptY5sAtDewGOKlFChb7sXYgV/bilzowBs06cr5y4PzZYvANx8UVuA8bhnUIe6yloNDfAUoLNu1ZNwM9mgSUhRvtAso2uvfH7RaGWGUPdE3eOcjPwarxU3H9ZAF20TnSZ8AQFz9y9LKIGLo++KdDPSoi4yxV2mPyTsPDM0z2WioLDh0scYo6qFCQ0DZuweuHYI37t2XVNfgbpYUOCFXBl5lOkaKDR7EZGBKfdpECYmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QGEn7eTOyf58FmhAOxh68K6VPe3Fs+PE1Cc2wZo5hFo=;
 b=Ddp6OnqjBb6yqDJddQundNykR8d5OmEdGT9I9qlf8mgSXHhm4RHbJc2Pp/oYB/rIWBULkyDDJ73vp0e/yZhBtqhUqWLZ//WTzDayW/J0YYmrF/AgnazH4bxT7mJ4Z+9k1XTMnhjBtbhPh9x2W2iAyXisJjpdRpbXFg5Vfku65zsyVAZB7rN3ItZC9UalnQ4omtgUEIBZtzCr/gaVdfm6nqfMxvK4qXhAlePO2ThLuGpzB9hejsWT783T6e5R00nVw7KKBdv7FXXhNE2V8tMfKx5rf6qj9qU5LrtdKS/OtuZXFiOuRCzuF3RIfulqj1WUquauwgSnzqmezLzm8shAYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QGEn7eTOyf58FmhAOxh68K6VPe3Fs+PE1Cc2wZo5hFo=;
 b=lgHlASaIpkIZ1ea+/1Gm4GrUnu5nNlhsNxMy4QTU3Xp9JxwaVsYTlZcgPl4DnxS4De1eJMzgQIef5J+DAlnPJpu+jXN7iOGMwbvUx3E6RGuGBv2LwJouKS84oBqsgBh63+47XdqlJghNkqvA3t71q1TqIlDUzC+h6b1jISdHgTY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2582.namprd15.prod.outlook.com (2603:10b6:a03:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.21; Wed, 16 Dec
 2020 17:35:58 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 17:35:58 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 0/4] introduce bpf_iter for task_vma
Thread-Topic: [PATCH v2 bpf-next 0/4] introduce bpf_iter for task_vma
Thread-Index: AQHW0zs5Zgx5qG7e7kmzUIj70BsWzan581cAgAAKBYA=
Date:   Wed, 16 Dec 2020 17:35:58 +0000
Message-ID: <192C599B-7ED6-47A5-BF83-FA25655EAE88@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <7032f6a9-ec51-51b0-8981-bdfda1aad5b6@fb.com>
In-Reply-To: <7032f6a9-ec51-51b0-8981-bdfda1aad5b6@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c091:480::1:e346]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c64c706-8f0d-464b-9166-08d8a1e90ce6
x-ms-traffictypediagnostic: BYAPR15MB2582:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB25824CB21DEC950321E155C5B3C50@BYAPR15MB2582.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T8vbVExPeFAeCo1gU3lTfx0Wow6OYQZyeWuCP4/hXYsnNGGWLWhygNiwA4NQth1aNL+BWsUpmqb+ydDSWMzN7LEXveb/xEXcLAPGwJcJbepyUDwTViSuR9s+hoBf3SWr2rswtPyXZuAl7Toe6SsGNdujw3S7tUMEJ4EAsVzlcgP6iGg8d/+SaUgIMoss7sSmWsoaJQ51+bpLlCuQZlLma/tN3QRnrw38KCXnBzghfrCRtPdfHAzTVW6A1YbGU57or2jS32lSa/MkVCG0s2FjLJOk7WlCVDm/EQyzDRJ6FxiZAazyes4DYTUeMNV/CZQz252kyxt8EcospRep+S6BOX2/QccqIqdoFBW7AVf8fmk54smggzNiW2IurVXcbeUP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(376002)(39860400002)(2906002)(5660300002)(6636002)(8936002)(6512007)(91956017)(76116006)(66946007)(66556008)(86362001)(66476007)(64756008)(36756003)(8676002)(6862004)(37006003)(54906003)(478600001)(6506007)(53546011)(186003)(66446008)(71200400001)(316002)(2616005)(6486002)(4326008)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?jpmPjwdu0sBO8HXAZJvBS2uM6OshRdNCQu3NQ0JqNFLxH5BLLcVaX4wDC+HB?=
 =?us-ascii?Q?yf19UL1uO2++2LhTiPv2bwOI9Ic7RDs/IZYbIzciTRC374hMUNor2eckFwYj?=
 =?us-ascii?Q?NUHaYB/z1MPzEUufVb8JuKJL61OD7z8MW8x4c2itfW4SDGk8FwnvKeikUBqN?=
 =?us-ascii?Q?e9Fd/zkfiYZDamK2avPaG3793LVogwIxbwD2KN/4FapwGBLe0CnirIcGWFBl?=
 =?us-ascii?Q?XRVyIRNKqvEOD8HS03CoQVxhFEkfldHAaUVCIwmHlEm4YmaK2mINcIwo76O1?=
 =?us-ascii?Q?O8ygt61DnGUGdngLkFXlGkFKKEYXZS2rloxVtLH9/W3o7tFrmGDiE+rBp7EZ?=
 =?us-ascii?Q?Igl/TILNAaEYeAC+2k01Nb8pG5MBzqobXWNXuEqKfUBnox8GsNnK+s/SyS+F?=
 =?us-ascii?Q?cCXzPqHaFIES0Uc4tx8hwUq7ol8dXfwzhzM6gKUOPmA3bbxuk8nksQo3Ybf7?=
 =?us-ascii?Q?mDChfIgMrgAIjmES25saYSWSapwUlrJoYPS8RsbC+5UUfBGZQcKZt/4ALYur?=
 =?us-ascii?Q?ZwTpvfJdKjAC/5BGfCnSxOGXuEOkQUuQGpheASVcGMp25HwabgIq3tXkPPFL?=
 =?us-ascii?Q?AT8a4lS+Qo+BpnhfowsLlj++lv7NEDkSj6oQUMZ2pB6F/fAQHwSvAoNB0yhJ?=
 =?us-ascii?Q?/F6uSHAntaNijEyiaTZ81VdPRd4fEVXr74lDpHBupKk5yeHbdtx6sQEXtSfI?=
 =?us-ascii?Q?uUhNoNfvGOVI78HVmT1/ADVRcbm2KYncwSnxYx7XRUNWcML/81/9bsHYL4w4?=
 =?us-ascii?Q?n3V1rIWASrA8dzfJltu4nsBvvIjSD25A//M9gI+OvkIs7VuAtKtmQLw9OXPF?=
 =?us-ascii?Q?GnoYCISDUMCwMLKqyWaq0Jx4VnzMEfjrYcO5bpeMA9O9jI/MSpanlO36T+Co?=
 =?us-ascii?Q?11xXfWQm5Z9LC8eiivSuZpr9GMTTaIHPlgxn9mk3otg4/DhgdP+EIASR2XIJ?=
 =?us-ascii?Q?uP+KkDrEQmIPjkN1T7rbLQieBZ1+sug1hkgTQp9f34IGKcYTxykU4JIHHbpm?=
 =?us-ascii?Q?djrrP+6S3DcxzZ+U+HudySraSJL5MLEn3vYMhbN7k2lRaQU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10EF933F6C65FC42895392D2B5595E06@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c64c706-8f0d-464b-9166-08d8a1e90ce6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 17:35:58.7914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: prrBuGYsbP9WKuveHfzeh0QGatbbWgeo8LSoD1dwbW1L9shpg8O7WCr40WyypVWuuormcwJWNsP7CHFmyLeofg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_07:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 phishscore=0
 mlxlogscore=927 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012160113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 16, 2020, at 9:00 AM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 12/15/20 3:36 PM, Song Liu wrote:
>> This set introduces bpf_iter for task_vma, which can be used to generate
>> information similar to /proc/pid/maps or /proc/pid/smaps. Patch 4/4 adds
>=20
> I did not see an example for /proc/pid/smaps. It would be good if you can=
 cover smaps as well since it is used by a lot of people.

smaps is tricky, as it contains a lot of information, and some of these inf=
ormation
require architecture and configuration specific logic, e.g., page table str=
ucture.=20
To really mimic smaps, we will probably need a helper for smap_gather_stats=
().
However, I don't think that's really necessary. I think task_vma iterator i=
s most
useful in gathering information that are not presented in smaps. For exampl=
e, if a
vma covers mixed 2MB pages and 4kB pages, smaps won't show which address ra=
nges are
backed by 2MB pages.=20

I have a test BPF program that parses 4-level x86 page table for huge pages=
. Since
we need bounded-loop to parse the page table, the program won't work well f=
or too
big vma. We can probably add this program to samples/bpf/, but I think it i=
s not
a good fit for selftests.=20

Thanks,
Song=20

