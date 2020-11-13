Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E231A2B25CE
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgKMUsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:48:32 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36810 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726003AbgKMUsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:48:31 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADKdoUj001778;
        Fri, 13 Nov 2020 12:48:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=KlC7w9MgdPnMpYEXgYEZyiMhFeycHYhXYIRMgsT9uLU=;
 b=lV5bv5W32zainfIC6TXLeqgXshq+8qCaYTHHBSOz+D1u03NrqYnVa8vCm63WyrojeHCB
 1fovovpoqrTXFEjXdniSMPo3AnJoUQ2uPslHNWDB3vtoPmC4Y/UcP7ZnrlxWSPRx3ghj
 g0/RzBVHTeIHA/LJUHUr236Msox2X3QibCA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34s7gf08ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Nov 2020 12:48:12 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 13 Nov 2020 12:48:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tell0CseZatAFlVAwDOghMJFifHhYwTXdmJyv8C48QL+zs0vf82C/OFABlRntphhd2F4ba98u/z6lBwdNd3zfMrP+dbObavujxsf6uyf2wmqqZ0CGcAu9bTXlAI6zPWgmVHk1KvX8qUpTaBPlYW3WwxjNH6QBDB5aS82/6gskayJyw7yAc9sKjxmgCX2m9+YZREfChmE3gLjHvoU8rW4r54TumgvUi1XrNFz1/7Pa3rTi54UkO3AcIcLPPHl2uK59vXnp7HHFrOG65ckOsOu+UtMa3hrqiWbcAXC5fajp7Gy0DGvaPRLxHMoMOyXyIvwhfy1PVH4XdpiR9YhSfseOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlC7w9MgdPnMpYEXgYEZyiMhFeycHYhXYIRMgsT9uLU=;
 b=edLSpXnXAr8PJeEfpJeQ2hTdTQsymaiKCIYYnZ4KxcMaib6T/verS7Cob6GlXlq5mDttZGw7Y5M3I/Rh3ChHZd69HIri+OurLt+F2c4TRN/9zQW32sFclPb2OWusD2tItsHjQzV+fFbLTvl/i1PxWNOfz80kIaBfJ7GPoX52wvZAivnho8nFUck6mxeSJGAwmzN41xdUukpcCQEeIV2C7IdPYmC0LAfIymHpaH7oMSXS4RVlkINagCky/TNHKQgxexuTYn9HhLiUaOrfUtpi3IY0Dq7FZjIE1cpXg+NEbvkfwLNR5SkCfaY+49jcorXRnLZUwlxP8H5jjTWDVpkoPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlC7w9MgdPnMpYEXgYEZyiMhFeycHYhXYIRMgsT9uLU=;
 b=M31TQGgj0vHdPGqArS74hx7lmBALJKyMO/6ms5LJ1iekwng+HwVQ2qVywHYWhoqM/SP1fDS2yFxMq9LQuUfNC5jNmQTXVmqkZTMG2jh20m5XqxgQmQBLn2Igx5WjH2jJ4ThZDxsTKOtPiJo5Vkx1h4yqT/MZFljDByYXJHlJSGE=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3569.namprd15.prod.outlook.com (2603:10b6:a03:1ff::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Fri, 13 Nov
 2020 20:48:07 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 20:48:07 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v5 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Thread-Topic: [PATCH bpf-next v5 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Thread-Index: AQHWuUMKg1vDyQyVG0KrHEFVr4bP66nGV2aAgAAfu4CAABLrAA==
Date:   Fri, 13 Nov 2020 20:48:07 +0000
Message-ID: <4E6A1738-4138-4F48-95ED-BD139A72B296@fb.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-7-guro@fb.com>
 <3645417A-F356-4422-B336-874DFEB74014@fb.com>
 <20201113194023.GD2955309@carbon.dhcp.thefacebook.com>
In-Reply-To: <20201113194023.GD2955309@carbon.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f6d8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7146e721-87eb-409e-42c9-08d888156cb3
x-ms-traffictypediagnostic: BY5PR15MB3569:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3569F226E91C66FAE61A814DB3E60@BY5PR15MB3569.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UKxDgc1ENYYuZeh0l+tb1rggMxLT4uPa4ib6vj4vvzjbBXz+v/MtSnq7mgTNJu3EchJoIzjerGcUNnxK0b4W8aRjLajrNJqDYVCgT+foz754vQLPmZDMAR+07mkCXjBmxAElR/ClGbgxv17hnmoO06P7LzGbpRBGRgQlojw+Jkp2UZIkn5ZSepa0BlkaZnDi2M0jIBm2ugq1Ek/Cqk3qYEEEwQ+Kg1fABRqwr+wu9MP6nGEnawBMUP3By2tfP8XFiUpF8qEmzccguZcmnuWbvAsWB1kybjUpvBNrRwa9/AseB23Jl5/F3P5oflCpQENdiO/yx5LrXSgM8XxIiQryFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(346002)(136003)(366004)(83380400001)(76116006)(6512007)(8936002)(4326008)(66476007)(91956017)(66446008)(8676002)(66556008)(5660300002)(64756008)(66946007)(71200400001)(6862004)(36756003)(33656002)(37006003)(15650500001)(2906002)(316002)(6636002)(6486002)(86362001)(2616005)(6506007)(53546011)(54906003)(186003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: kCvIkKWhOhuTaXZ2P42ZR6UKRAUQtS4Kj5pHmJp9x86DBXyPHZoDyJ50fg/TsnBZfWR3iei+E8jUNmfZhG3SM8h3NjhzfkVrjIde23G9BAaPo9AttcMqzdzvTA+0d/TUasAUZpRLVN33zbZXc/SOH+Js/gFLTPsUxfGK/iEXQUEy0PozgLXYmlkcNPpwYgoxhjz42IFJt4WJUz0KrEYQRCsbcDWirDqQYI/H2U6jNON/pE5pklrZnuE6OQch1JExk8nm4xvFe3qhF+r+rK946zgbnXsNw3CqJtJUM5Y7maNajWyuwuAv1OAU3I4DR4dh1NTxeCEh16oOCm1nNUDxVh9lVthiSQdFt011IXeMKtGuiY+GJkUG04ouQoLZqvsILaUBlyU+yn3I48G7bdsBTeHR2tNVL93BpxNtUcKDKFNAHkcTI17xTbhubMiux6vGrAlXbYV8+3VAPrgiBrfD3Y8IaTw+Y0gwQB1JvYixj4kM4oFsD14gsoyPyyLzD04fvP2THXNMWe9kYKX32OpxRc4ma2xbdU+Wrf3ll8AJ2lfLBqPH0DspytUlq9j1EywG6hzto/O2Zoca8fO+1UYSJAVBypMlr08FnEc+qN7i3T4yQLyDCC2WaxCd6EJGAYAU4pJubjutfatT8qI70HmSmY/ds6Hv3Wci2adQNxgZ9ny09W8RvKhJ3c/q39Q2NukMr679ClbCKcdwo5aXASyMu4fqrX6knTxxwEzcvgFHiysZTcPFlSJHROT0aEFlSlJ8TPP7fmTMUOlI+D0bgjwN5Cs+h3tJHzkrIkYdYiCem3GVB8tDKJ/OmrOb7bkgudR0mJXMFs58Rw0v4IprhYzQeCZr6aBvVptcpdlmWfL14M5qgk8T4SBU911gNgqEH1nFM2VuoxCcVsqkU3u8YT8bfJag8uHDNqQ2PCn5lGjqYgE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <013FB2967C802449A3D25D60B7BAE5B1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7146e721-87eb-409e-42c9-08d888156cb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 20:48:07.1843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AAgrllAag1WkV8j9gVKyicHpuQDOunjw2qzJjazlxS2+/iHDqYuF37yH1/4yxnvLYoOrRdzNSHQl92dgC47HSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3569
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_19:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=701 adultscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 malwarescore=0 phishscore=0 clxscore=1015
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 13, 2020, at 11:40 AM, Roman Gushchin <guro@fb.com> wrote:
>=20
> On Fri, Nov 13, 2020 at 09:46:49AM -0800, Song Liu wrote:
>>=20
>>=20
>>> On Nov 12, 2020, at 2:15 PM, Roman Gushchin <guro@fb.com> wrote:
>>=20
>> [...]
>>=20
>>>=20
>>> +#ifdef CONFIG_MEMCG_KMEM
>>> +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, =
void *key,
>>> +						 void *value, u64 flags)
>>> +{
>>> +	struct mem_cgroup *old_memcg;
>>> +	bool in_interrupt;
>>> +	int ret;
>>> +
>>> +	/*
>>> +	 * If update from an interrupt context results in a memory allocation=
,
>>> +	 * the memory cgroup to charge can't be determined from the context
>>> +	 * of the current task. Instead, we charge the memory cgroup, which
>>> +	 * contained a process created the map.
>>> +	 */
>>> +	in_interrupt =3D in_interrupt();
>>> +	if (in_interrupt)
>>> +		old_memcg =3D set_active_memcg(map->memcg);
>>=20
>> set_active_memcg() checks in_interrupt() again. Maybe we can introduce a=
nother
>> helper to avoid checking it twice? Something like
>>=20
>> static inline struct mem_cgroup *
>> set_active_memcg_int(struct mem_cgroup *memcg)
>> {
>>        struct mem_cgroup *old;
>>=20
>>        old =3D this_cpu_read(int_active_memcg);
>>        this_cpu_write(int_active_memcg, memcg);
>>        return old;
>> }
>=20
> Yeah, it's a good idea!
>=20
> in_interrupt() check is very cheap (like checking some bits in a per-cpu =
variable),
> so I don't think there will be any measurable difference. So I suggest to=
 implement
> it later as an enhancement on top (maybe in the next merge window), to av=
oid an another
> delay. Otherwise I'll need to send a patch to mm@, wait for reviews and a=
n inclusion
> into the mm tree, etc). Does it work for you?

Yeah, that works.=20

Acked-by: Song Liu <songliubraving@fb.com>

