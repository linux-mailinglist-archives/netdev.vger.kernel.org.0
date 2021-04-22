Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DF836877C
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 21:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238818AbhDVT5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 15:57:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57608 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVT5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 15:57:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MIghlg175252;
        Thu, 22 Apr 2021 18:56:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZJRa6DBI0YbEWX+8F6U2BY8cz8Do/qdBDgZ/49jfTRA=;
 b=jVK8g6j2YjUnA8GRxg48bVifIalOKcNTU6FEO4OAwsOnS7iR+LT3EikIW244yX5NHg2N
 vTOq+AxR7bLux7ZmdNUSVDHMB7XWICBjpnYN/uEaSiA4OwBV7Kr0ddF80eHWFuxFx8Ji
 YTuVVzXMgtPAvimpl4Km3x8QGg/8RPAyCqRpWgo8HbGkZNqzJmetFunDUa0fV4aDV4ey
 3Pxf7oLyXgnQjbAWXJtv6WaScKDS0N7qiKZ/aUM5FzSBkAEjHNOSwjULs2Cel7A/fEMd
 SMVC5v3136werH/S/n0myaNj7zJFGxSNF1XATtX8BCWcy62GDQQ8n4GDgaoCUpiW+sQn Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38022y5rxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 18:56:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MIo0AO186349;
        Thu, 22 Apr 2021 18:56:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by userp3020.oracle.com with ESMTP id 383cg9esp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 18:56:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Im9yCfYrtqzoCJ4/Dq7953j5sKr+XgEUItm45VTpk6MTYC98gScnVFpLuW4hfyuqNVa4l7gWwxkzfHvUqUsPX4L35zRlC6YUes1UdHE0qV7pj9WN1n5oxaUidlmnRHgK/zCf7kJA4kVbo5i5mw2+agzALHGIKhmTf+8QlB6BjM5fqHLex5nZT4qAFPiMrRx+jICtqIhgJHTpJs8UgnoiUgOl3x0BzDMFWteKjEftki7l5F12nTBjUSUYCDpNy+oOa1tZGi8Dfaw6Ge/Zm4g32Dw0DE/N3VBqg0neX8cg49if2EO8pzVeKyxvhezV2QL4j5f6FXx1Dpi+Y8eoGOh/vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJRa6DBI0YbEWX+8F6U2BY8cz8Do/qdBDgZ/49jfTRA=;
 b=gmUtbm5yX6S3e8aQNAnHshSTSBQ+YPp96mdkCmCTlnKtGPoSYW3anfxa2DNH3WYHpveFMbtpWJYC+6JXzZbXailKrFSgWsFA6ejtTxf1xsziM20UqE7Bj6sSZ5jFbduKMK6v3Mm7uFx0NoWOF5uj9SuR4QuQwrZUBuFD5ok1EB++y2xBLzp4KjBJVbaRBXr77uMNosobJ0cIxcBVpit6Rozi8vxA5E5LMMTIjsxIYCOuUlg/GMEIA7RB+/YZbjmGVxC9TjnUZIoG557KEQzNduPm/ESXMbgegsrV311hGp0ZT6ZQMIvgA2QTYHEU8Yo2h1b1Ia2DCU93JcdD38QBMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJRa6DBI0YbEWX+8F6U2BY8cz8Do/qdBDgZ/49jfTRA=;
 b=HMjFIYORCigC6dzYWeVcMsckTM+KbWetHOH2rWPZyk0FLvE2fu+hkYSxQqE8PDppNNiaPJdeHqE9s61aAstgLBNayuUYAI9zhnN6R209kcw/JktrQBCdLMMTEFZY4FUR3K64nqo5t7F1E7gAy1uZP4V8jVeDcDVK0dEk0ZpvvCU=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by CO1PR10MB4788.namprd10.prod.outlook.com (2603:10b6:303:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 18:56:18 +0000
Received: from MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811]) by MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811%8]) with mapi id 15.20.4065.022; Thu, 22 Apr 2021
 18:56:18 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Will Deacon <will@kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH 3/3] arch/arm64/kernel/traps: Use find_vma_intersection()
 in traps for setting si_code
Thread-Topic: [PATCH 3/3] arch/arm64/kernel/traps: Use find_vma_intersection()
 in traps for setting si_code
Thread-Index: AQHXNgU7TopVgzWGUEaUH9orR8DEd6rAgPcAgABlUIA=
Date:   Thu, 22 Apr 2021 18:56:17 +0000
Message-ID: <20210422185611.ccdf3rm4zr3xtuzl@revolver>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
 <20210420165001.3790670-3-Liam.Howlett@Oracle.com>
 <20210422125334.GB1521@willie-the-truck>
In-Reply-To: <20210422125334.GB1521@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f90d5f6-ba9c-4c79-b1be-08d905c04ff4
x-ms-traffictypediagnostic: CO1PR10MB4788:
x-microsoft-antispam-prvs: <CO1PR10MB4788EA500C3AD6D34A07511BFD469@CO1PR10MB4788.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iQHxli9Rk2mXdysXKyxOHrT1tSYrX4gIOfYigDiloUcgcL75VQzcEW8QxqX0e1JtXgMlS0kjgQNLmsfcZ7aYllxZEK7ibZ0/NzKkpxEXbnlFlkZMHAA3swywux7rP/Pc5UKC7ySgJPzA7wxbHb7c/GzGnAsgN2ML0k0rminNg0ObXwgzuIOW0wDJ0Voe0JDcyPrg3YSl18AnEP0o4icHMgp6Sr+aVg+LQ1hUrBVZCxKdAxymNGehvR2GjAnq+o+qlvWFhEWF6rYk09dt4I6gFk6J2Jrjb9tKpC9jYpZ+SrN3dGIh5EW1BHrXEh+YdEe/+tZbVzpojdyym0sfTw42k7G4X8HZPyG8wPwdrygmzvxMjVr4XixUEXt+AsL34k3tW0pOihJx2vDEdos3J2MJ44HpL+8DXaypjguvdxRx0Lz3FRFsznJMBUSO8MptxBvca+IsXPXY8XMczYxI68Zra6mrK6n4LX+5UUX9PkYbi9lg1d2rhV3eje0qwD1CG5s3+KP1KNeU79WEXmBmxIITz2rRINViA8WDNFzKl8LEdDW7KT6HIAN3akwfWlh5xoCDAqFt57IvsEIasQi65w3GX95SkEEBE+cbI5v3DNkR07YLWwXnxtS+AaBwhnPPH3C47FIapK5JQHNfkRyVmcWyUdLVEYlWSRCQs5QQ/XFwQuQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(396003)(136003)(39860400002)(376002)(346002)(5660300002)(6916009)(478600001)(9686003)(6512007)(54906003)(6506007)(4326008)(122000001)(91956017)(71200400001)(8936002)(8676002)(66946007)(44832011)(33716001)(26005)(316002)(2906002)(83380400001)(66476007)(76116006)(186003)(66556008)(66446008)(1076003)(64756008)(966005)(7416002)(38100700002)(6486002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3pqPoDmZZFihOdv3rxZ9mQcccxRa24XU4tlVkKJ1ERJrHslfgTV+LQ1nOuTj?=
 =?us-ascii?Q?NWQfvhUJdZah40i8vaQHAA43YYXljAhpuqAsUvgd/7zJHxELq5V1p9151kYt?=
 =?us-ascii?Q?4iqm7eyy7ZxH8DVMviEix+fisOPkYjCO8HOnO6oOhm4QocWnH/T3pUSn3Jpy?=
 =?us-ascii?Q?jdhlpFVqF8OUKPAuD0YNQ0I+RUxEG79MiTQrqoUNNVIw34hTIGxUPc3sjtwD?=
 =?us-ascii?Q?fzEIA7AUd5TSOB+p/pMc0cJORuAktJI9+4hdIGeMGeLpjMKqTRtBxOaYO06O?=
 =?us-ascii?Q?NMtOl2s5ykMplhv/gijEOSBEj1aK6/806mTRWOQaDlvszGVe/oGZ0S///RMi?=
 =?us-ascii?Q?en+UBEqR0LMdtHWLkUjuS9ufLJcrXqa5Kqlk6QswnQNpVzMMueh5OylfRq8Z?=
 =?us-ascii?Q?m/aT5w15q624mG8eZJV1iKin/qlReQitdjKF5CKAdsrzFgj4QKFWmMxj9JRf?=
 =?us-ascii?Q?LjVQW7pM6idLQvxGQTkf7Di1zFte87zflZ16GK4Ltg3jsBPcnNX7ZApV1dQE?=
 =?us-ascii?Q?ChkwMbd6HmbIfbuvOHABveEw5ehahXlJDAn0sXDIcES4XumPjG+fKenHQIOR?=
 =?us-ascii?Q?HL0f3Id92RWlAbv+O3pRTEBnjdLwLsaI46BeDLLLct90pj2tt48MEEmwLLYU?=
 =?us-ascii?Q?LxLPmnmrqgan2TPKbQ1eL9s8Eg5AUI6UkwO/GYQEaXVoSzkiQE+uNirL+VdM?=
 =?us-ascii?Q?Ao5Nk4Mhhtuh1CNXRe7qeiQFEI+B5EnPNdxBSW2Vu3LMY/U3tWjiv3H/Fh1r?=
 =?us-ascii?Q?HRLUeK8iQ/P1qRiQZuax92uQj649E2qnSUd8OwSBNZ6WaCf0NoQwYRDGPy2g?=
 =?us-ascii?Q?viu1n+tFUJy1QF9VQUGluAL+1KOaaePiqJtVfrxD15ipR9bYAVDcyIqDgZj6?=
 =?us-ascii?Q?mgrbsOPFh+r6dyLF7fNJ8dH84GLYc8OVUXR/HQQwAdYW0wXq2rpHAa0e1v7t?=
 =?us-ascii?Q?DiJjcG+Cpf2zjnCQS/HLAjI6UiwKU7oZ/odIQ/qo06oLbUr+HbSdYJudHhdM?=
 =?us-ascii?Q?5vL3VgnmBy40Ijxwq8viq8L0DwbzHNZlJUnqp2OyEkstrEq8f51T1hY2JnGs?=
 =?us-ascii?Q?uDuByFu78PvDBFeix9SedDuRIhXfskiVi9DgolWo/S6d4/fFNlVeRLny7yp9?=
 =?us-ascii?Q?gJspceTtRKGoTHnW7duyl3LDzbOMMre6z//GSqLRREKU8q2v3af6hhx90fT0?=
 =?us-ascii?Q?Ls429EjCrweG8Y1fMhdluIP9O7CPSf6XyavRqPhBi/zhckkv0A9oZ/LGwDfU?=
 =?us-ascii?Q?U7zD9x+0YYNT4m0aM/5aRoGp3gBUWL2TqHuRWCzwxvHe5yvkTVb/ackwGpDM?=
 =?us-ascii?Q?kIL6A9CClXjk8wdXu+zMUthx?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <880F3AE23546C046A5BF7362C44334AC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f90d5f6-ba9c-4c79-b1be-08d905c04ff4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 18:56:18.1102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: br4uFs1/K/H8v8zQwQAT7GQ3LTrwOJJTKm/f/bPAOtTQS8uLlaN49Hoc2UYdIvaeOYJ7/6I/x3jQZu2m/osN3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4788
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220139
X-Proofpoint-ORIG-GUID: Cffe_KYwpV46DEvyr-1F5CAxnaoOd4jA
X-Proofpoint-GUID: Cffe_KYwpV46DEvyr-1F5CAxnaoOd4jA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220138
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Will Deacon <will@kernel.org> [210422 08:53]:
> On Tue, Apr 20, 2021 at 04:50:13PM +0000, Liam Howlett wrote:
> > find_vma() will continue to search upwards until the end of the virtual
> > memory space.  This means the si_code would almost never be set to
> > SEGV_MAPERR even when the address falls outside of any VMA.  The result
> > is that the si_code is not reliable as it may or may not be set to the
> > correct result, depending on where the address falls in the address
> > space.
> >=20
> > Using find_vma_intersection() allows for what is intended by only
> > returning a VMA if it falls within the range provided, in this case a
> > window of 1.
> >=20
> > Fixes: bd35a4adc413 (arm64: Port SWP/SWPB emulation support from arm)
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> > ---
> >  arch/arm64/kernel/traps.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> > index a05d34f0e82a..a44007904a64 100644
> > --- a/arch/arm64/kernel/traps.c
> > +++ b/arch/arm64/kernel/traps.c
> > @@ -383,9 +383,10 @@ void force_signal_inject(int signal, int code, uns=
igned long address, unsigned i
> >  void arm64_notify_segfault(unsigned long addr)
> >  {
> >  	int code;
> > +	unsigned long ut_addr =3D untagged_addr(addr);
> > =20
> >  	mmap_read_lock(current->mm);
> > -	if (find_vma(current->mm, untagged_addr(addr)) =3D=3D NULL)
> > +	if (find_vma_intersection(current->mm, ut_addr, ut_addr + 1) =3D=3D N=
ULL)
> >  		code =3D SEGV_MAPERR;
> >  	else
> >  		code =3D SEGV_ACCERR;
>=20
> I'm not seeing how this addresses VM_GROWSDOWN as Catalin mentioned befor=
e.

Sorry for not including the link before, but for context, I've added the
URL for the lore conversation from before at the end of my message [1].

I thought this was resolved by the fact that the stack expansion would
have already taken care of the VM_GROWSDOWN code path?  Did I
misunderstand what was said?

I've modified the other paths to this function to avoid causing issues
elsewhere and to hopefully do the necessary cleanup that Catalin said
needed to be tidied.

Link:  https://lore.kernel.org/lkml/20210413180030.GA31164@arm.com/

Thanks,
Liam=
