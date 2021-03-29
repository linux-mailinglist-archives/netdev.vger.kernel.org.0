Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A3434D4B1
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhC2QQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:16:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41884 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229479AbhC2QQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:16:03 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TGAJD0006251;
        Mon, 29 Mar 2021 09:10:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9PhZGnh/Qwj3meitN8ajbzc4QPHw+f5+gDmA0NOkEdI=;
 b=a/HjBwygPpX/eZyngBfEHmOlLUFcHnat4m3XgkYU7QDnBqfHFPG8sD/VmJ7Ho1C497Yt
 RyoTTx+x/2iiXHudqZrJUv6mgRxROQHALp6doxu/L7BGyU3ze5Ukn9dgENa3pIjV57IY
 tRoFNdtHC9+Pc3ZeGmjlzl3zECwFpDX4cFI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37kcfn9udb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Mar 2021 09:10:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 09:10:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XH2aD/MljzbW/JJHhiGs4VKlvEvwtGzR/IJCAS5TbABVVP6/rbJGlkOETcEXWBqjrAEkA7PzWi6+xch7zr29SYjiEJusqkVCrDoO95fEiOQJ/JYpHNiVKxzWuvkmC/GMdDbh5HL2FVBskpS8oaLrnbhtQp+oRzFIqmQTw8a2ORBzto3ILERgYrzf5kZk2WcQquq5VluJ0WK7bjPD7Y9PLm5088AFv/0wqSenvp9WBT+P1FIhNVJ6tay0hNwZ2F03Grba6wDDWiD5m1XFGlXr9UmtlPi94z4yEefmsG35luyLOZP5e17kZsgE+PwzqzsJpH/NZzKNtCRyvegJ/qN5jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PhZGnh/Qwj3meitN8ajbzc4QPHw+f5+gDmA0NOkEdI=;
 b=azp+nVc6zuRjTAWZL7CfFaAF2k1R07yjiaVWBYvSxDMepAkMCzFGdvrE2ZLAcFQLH0PvL2TB9NObZy9gCoCItu2IusloVttiovp2yxmFG4rul4AGJajuka7G7doChytDrIHdxKNv8y0xcB435BmLh4qMoGPm6wGLl1vZ1Djtf7Biov0d95SUUQdY9W9KnkoviGNPLnEkPLcsQaq5dfSwVWEpaDx2+HnjJaLYeSOPQ6W1UrWvofKgtrpaiXbnyJuuJGJWyqsmKCa3q9EAKrSZMpyDMVnTBulrjrZqhIdoHFcZPtd5HpWXzaklGr6+OdeDwQifbGzoBJskJhXGE5X1Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4711.namprd15.prod.outlook.com (2603:10b6:a03:37c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Mon, 29 Mar
 2021 16:10:46 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Mon, 29 Mar 2021
 16:10:46 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pedro Tammela <pctammela@gmail.com>
CC:     Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: check flags in 'bpf_ringbuf_discard()' and
 'bpf_ringbuf_submit()'
Thread-Topic: [PATCH bpf-next] bpf: check flags in 'bpf_ringbuf_discard()' and
 'bpf_ringbuf_submit()'
Thread-Index: AQHXI+0ig0TIMP/v406/VUGb0CIUpKqbJEwA
Date:   Mon, 29 Mar 2021 16:10:46 +0000
Message-ID: <A175BAAD-39B2-4ECE-9BA0-D070E84484FF@fb.com>
References: <20210328161055.257504-1-pctammela@mojatatu.com>
 <20210328161055.257504-2-pctammela@mojatatu.com>
In-Reply-To: <20210328161055.257504-2-pctammela@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:876e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e7a89f9-7ab1-4327-2556-08d8f2cd3642
x-ms-traffictypediagnostic: SJ0PR15MB4711:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB47118E38BB5BE991847ADBE7B37E9@SJ0PR15MB4711.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:328;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tmv7iYeITbeFzTYzuf0Bs802vzcTb1CJfwOd0Pxun6eK1Ikxn12VPI94OGEnhIQ5gEixNzxYHOyf6ViDLKc15nCKEcwOfIdJz3nvnBR0tnmaMsS2YA+kOpOJJYEkHO7Xi7+wl2yQC23jAYxe9wHQawhOIuK1vkClQu9YKyo5kSxaqvHmKnrwp0CtNvV/ZlU+tas9a30hIYG/jNzgx4kyldn1+Ib0DWGCg1ZZG9m0Iwskgmy4BrQ0Uq1g+j2rbQF8ZQundkj4Vtn/NcWpPiDt7v/L4ELVMCtK2kQ9czyu9EwFrSCV6qKW66NeOeBOC6lGfQTayLLYu8wl9tLHrYZHxGOAqwlPtCgVfDnsYOoLIcBrI3nbXk0SF+U94UGEUMz7GqaM0eWXqXpMKynkBwL+HNLTHLuSqwU8cxMW2NgGZZY/hKVMUR0i9ZEd3XdjRfdNXPPO0jbd7cHqayVYW3c5WfFY5lkDxaDWujDEzK1e3VTQkWy0PD+F0BwCwNCc5PiRlSPPquw6SLtZNlhIQKlsxONRc92VpMwZHuPj1i5e5M7sg2qdtBKkKTbyLezDv4a8So1apj/4YSD7GozeIdOaUSb2uNO652yT0W7T9kTodkfgM6Ggdx4dAFaKpvthqKpLZZDVrbOowebB93ITZaYC/pPwzwulnIrgB4YITMcWW3APeR4F97IyHcmgN2oMQzRz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(376002)(136003)(64756008)(8676002)(54906003)(5660300002)(316002)(66556008)(2906002)(86362001)(8936002)(36756003)(66476007)(478600001)(66946007)(38100700001)(66446008)(76116006)(6916009)(6512007)(186003)(71200400001)(7416002)(6486002)(83380400001)(53546011)(2616005)(6506007)(33656002)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?va8jFvkt8HE99/QrNatWGBQaQFO7RvdS9UJEGhoMyuu6bPyibiG3g//MM55V?=
 =?us-ascii?Q?QV1utjT7yicPpj63DqiaVz/bpXfpSeh1awKAszsV8fud5ABiqg37nxHIkq7O?=
 =?us-ascii?Q?2cke3FVHBgmDo40sOnVJQqY4VnzTGiFHkUt7bGrWFx8ro5imoolzCIWMEFfk?=
 =?us-ascii?Q?X5e3GQIHY6lAbHHwIH34qMON3qILCXCPi/u3kEF65zPfTZ+gbWRkyfumCA/b?=
 =?us-ascii?Q?Q4su/IhwZbphMTjYDpenHU/jzKC1g6pTzn7L6JCpry7UIk1R0YjRGXSAMW5m?=
 =?us-ascii?Q?au3Q25icQ3ODGZphc3LUXH3ZiB4FEbeSsXsnfSWAnAwTLcj6OtTfck74PuRl?=
 =?us-ascii?Q?WaLPqAkczAbzK0Kc1REprgVibVJ7oX3NIGjcum+Imp7mufXO8VNhBXkEdHJ9?=
 =?us-ascii?Q?AxuQyu5D9wyT6IPLTLmoDTz8itWv733jpaVu7kYfETh0ekNyObzU7+OaTt1g?=
 =?us-ascii?Q?WDaiPfAneUiE6JbCxvQ2cVOGzM37lxAPvGwO0lmg/JFiqyxWNPYZQrk1/QMA?=
 =?us-ascii?Q?5J5rj/GUk8ab78bLOG7JanQzVJvCcuW06OxUl2Qd6pZRnipZ7g+U/D01K2fl?=
 =?us-ascii?Q?ULvwixwVjWDUWHPXcOfYZrm4npDLeQ/jr+qrUO3oYotIrnyGbe8s2OZsZipl?=
 =?us-ascii?Q?dryasH993ydMQdnXe5xZrmLajdtOpYlGc8eDuhcdjUBMl42Gbtakm1gTM/4k?=
 =?us-ascii?Q?Z56B1waQuHJznaFiYpMjjSpPxhDn9pLBYvtbJ2FvfayJstLUPn5rFMQlSb/h?=
 =?us-ascii?Q?rh2jSSfsiC57jHSWhmkiJX1COlSJA9Tr2Y7PEUl+HQ9IOM57d1rbB3vaoCIN?=
 =?us-ascii?Q?q9imOay7MSKXL6BpNPAO4ueI4G/GXkqDZLUCflVKA25wCtM270HN5c/vJBkZ?=
 =?us-ascii?Q?yuPdA9hVeZI6mS6Q842Z1wyof68lm1rTy2t0pDN0lryHjsjl7sEIBzcP/NXB?=
 =?us-ascii?Q?RzD2asaUkAe7lFnUUC8n7NKDrQ9HziuOE5v3FLwGn2dWO0LeaWPXCSl4dQkq?=
 =?us-ascii?Q?wLl2BfXYDBHDmmQuj/rEiIcwyGht9Bw5p4Y7/p3+zPManclW75YmEtMRBZ3y?=
 =?us-ascii?Q?ZP/gkrCL41FT78jzwSllhzw3HjwJaMIzBeppVAVzB1px16xJLLVQ/EJjpIyi?=
 =?us-ascii?Q?MjR/+x3Miu/LadPXT5TK2zOi928G/NAihiFR+6FeAW9/7M+xWOJV1EAGNqr2?=
 =?us-ascii?Q?Q0umLAqPOMcnH+dxxQ5AM2O+dp9sdKKC5z9LguXlKL2Y3CWBSkPFV7OGqD0v?=
 =?us-ascii?Q?VOX0y98/+Wpg4Fj0SjTNfh91LfhBIMywZrBuv3o+ptXbO3SzqfuLmcysa8za?=
 =?us-ascii?Q?7+espNJHtzy2gdiQluWt72AcbLcAxilQ0LtQRJ01scMXCiDTyAONkdgAVEDF?=
 =?us-ascii?Q?Uq7RSv8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AD5B5C3C5E3ABF4A86BC8E650B35ACB6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e7a89f9-7ab1-4327-2556-08d8f2cd3642
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 16:10:46.3718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c7KwA6uFOTyxPA6AnZMDEYrmh2Y1d36Hfym0kk4vOM/IMmFVBbv+zpc7W3ARl53iPlovQZHRx0qsjUixxFUz8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4711
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: xFHPtNSEcXOO8VgaM_IX_iP0n97kkW3B
X-Proofpoint-ORIG-GUID: xFHPtNSEcXOO8VgaM_IX_iP0n97kkW3B
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_10:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 impostorscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290119
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 28, 2021, at 9:10 AM, Pedro Tammela <pctammela@gmail.com> wrote:
>=20
> The current code only checks flags in 'bpf_ringbuf_output()'.
>=20
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
> include/uapi/linux/bpf.h       |  8 ++++----
> kernel/bpf/ringbuf.c           | 13 +++++++++++--
> tools/include/uapi/linux/bpf.h |  8 ++++----
> 3 files changed, 19 insertions(+), 10 deletions(-)
>=20
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 100cb2e4c104..232b5e5dd045 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4073,7 +4073,7 @@ union bpf_attr {
>  * 		Valid pointer with *size* bytes of memory available; NULL,
>  * 		otherwise.
>  *
> - * void bpf_ringbuf_submit(void *data, u64 flags)
> + * int bpf_ringbuf_submit(void *data, u64 flags)

This should be "long" instead of "int".=20

>  * 	Description
>  * 		Submit reserved ring buffer sample, pointed to by *data*.
>  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
> @@ -4083,9 +4083,9 @@ union bpf_attr {
>  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
>  * 		of new data availability is sent unconditionally.
>  * 	Return
> - * 		Nothing. Always succeeds.
> + * 		0 on success, or a negative error in case of failure.
>  *
> - * void bpf_ringbuf_discard(void *data, u64 flags)
> + * int bpf_ringbuf_discard(void *data, u64 flags)

Ditto. And same for tools/include/uapi/linux/bpf.h

>  * 	Description
>  * 		Discard reserved ring buffer sample, pointed to by *data*.
>  * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
> @@ -4095,7 +4095,7 @@ union bpf_attr {
>  * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
>  * 		of new data availability is sent unconditionally.
>  * 	Return
> - * 		Nothing. Always succeeds.
> + * 		0 on success, or a negative error in case of failure.
>  *
>  * u64 bpf_ringbuf_query(void *ringbuf, u64 flags)
>  *	Description
> diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> index f25b719ac786..f76dafe2427e 100644
> --- a/kernel/bpf/ringbuf.c
> +++ b/kernel/bpf/ringbuf.c
> @@ -397,26 +397,35 @@ static void bpf_ringbuf_commit(void *sample, u64 fl=
ags, bool discard)
>=20
> BPF_CALL_2(bpf_ringbuf_submit, void *, sample, u64, flags)
> {
> +	if (unlikely(flags & ~(BPF_RB_NO_WAKEUP | BPF_RB_FORCE_WAKEUP)))
> +		return -EINVAL;

We can move this check to bpf_ringbuf_commit().=20

Thanks,
Song

[...]=
