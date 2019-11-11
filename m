Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF42F78F5
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 17:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfKKQjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 11:39:40 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60640 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726857AbfKKQjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 11:39:40 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xABGd9q8009304;
        Mon, 11 Nov 2019 08:39:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QpXH9YBhCyZx8h016E5ugJMpJsXismthp7uuEQOk9Kk=;
 b=hiG3Wkh+pdhP41Bf5aSAOlewWTzz9Tn1s9NExQ74uNJF4bWOKI+LxJQKxJ0knx18NFkh
 72Ziy9eHMrBdb4JGmSKIH1ve24T/3WZuSSJPFuDKKGfe9gu+FoDAB8tThw1/mYBDOpv+
 fo99RlIPj5C3Og//s/qVkcnr1/6iwBtW0lQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w5uup1tkp-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Nov 2019 08:39:17 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 11 Nov 2019 08:39:10 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 11 Nov 2019 08:39:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSQAZ56kp1+q/L6/BVn7fjaHMWXZbYuoY/JP6THxLvu2F7zWBXIqFokO3UQaXZI8Z54vQvuMkpfnzBHSlZVN54BcG0b3wqIdrLby2ZEd/iNESuCuO7HeKfgj/AoR+9pYX2YlFJEj9blh1yFGDCSojn7z4t5vFFi2qhFKf7GQIZOyFo/EGpzp1WiOp+veqWryQESmnUecL8R1IeMOTIPAnJS5RhHF/0ZTggGQWoapAAS5cynnrxIH6YQQw36cDuS8zsMCBwypX03xNIoAQC5WgGvIheBIBEwpWZArvl6wmrnsJ/eHcg35j8ehJSjwQtGT3gx+btzpAea5iT6COOplvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpXH9YBhCyZx8h016E5ugJMpJsXismthp7uuEQOk9Kk=;
 b=OnxiUJ1j4rZfrTaarAt0cH1T6XLYKpTTrHnz6fxrGOSJXdLcCBSvG0hmHY+Ne3B0SLn/dyYzHJOaMOYY4ZDfo8/eyOQUDNI4TeXrpjXYSHw8WvhGFRVFmflu/DojQ4y4TFUdLOE/yVIWq5Qhw7kgCWjR+H2pGGT2clc54YjymsdrA63+J8Ae/WcIFQwQOxoyYCSy7mtRmq1LXq/crgtyZwLryZ3RdNAjiNhe7z0FOEyN6l/Kuar2DjRb9pYAHF7zsXBhXqP3oL8v2Nif4X9Ce0QOkZb4MW4FddKcza39GT1OJL1Y5ptOZ1uHtHz2MUEwxGfEq3z02RmqDFZ/GezNGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpXH9YBhCyZx8h016E5ugJMpJsXismthp7uuEQOk9Kk=;
 b=LA1FBn/D5Ogz8cvsdvNSgSflmM8zBSJjZlRFEoAEDnYuI8APHEcSrB0HvzHf71J1iEmVx6DL8KU845jmZeBZUoiggE0upkM5tpSVAn5MUHQVeIkxkV2IK8Xdd+T6t4xIwpOF9bC/DAsMAqdL6mQ0kQluq2nIwrSZVp9SVPVjHhI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1311.namprd15.prod.outlook.com (10.175.3.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Mon, 11 Nov 2019 16:39:09 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 16:39:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next 1/3] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Thread-Topic: [PATCH bpf-next 1/3] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Thread-Index: AQHVlevuobT30QigFUGH2JlZwZjdj6eA0sOAgADYeoCABIX+AA==
Date:   Mon, 11 Nov 2019 16:39:08 +0000
Message-ID: <B968B10D-3506-4C4E-B2D5-36707F05E75F@fb.com>
References: <20191108042041.1549144-1-andriin@fb.com>
 <20191108042041.1549144-2-andriin@fb.com>
 <94BD3FAC-CA98-4448-B467-3FC7307174F9@fb.com>
 <CAEf4BzY2gp9DR+cdcr4DFhOYc8xkHOOSSf9MiJ6P+54USa8zog@mail.gmail.com>
In-Reply-To: <CAEf4BzY2gp9DR+cdcr4DFhOYc8xkHOOSSf9MiJ6P+54USa8zog@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::3:1a5a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ab3c9f5-681b-4ac5-3472-08d766c5acd6
x-ms-traffictypediagnostic: MWHPR15MB1311:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB13114D77282B60465948427FB3740@MWHPR15MB1311.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(396003)(346002)(376002)(51914003)(189003)(199004)(66476007)(76116006)(66946007)(6116002)(99286004)(7736002)(14454004)(5660300002)(305945005)(6916009)(33656002)(186003)(2906002)(25786009)(478600001)(66446008)(64756008)(66556008)(71200400001)(6512007)(11346002)(6486002)(229853002)(71190400001)(86362001)(53546011)(76176011)(4326008)(50226002)(486006)(6436002)(8936002)(2616005)(316002)(446003)(476003)(81156014)(81166006)(8676002)(6246003)(36756003)(6506007)(14444005)(256004)(102836004)(46003)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1311;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uuHUtZtvpX13Hkg/qxTJYzCIpefZQj8UVd11MjTV/xEz4JSXKyiYCWw6HSidI2jwh4iGaK3Y0t/c1/C8G38TI9B91j++A56teig2J1GVPH7wtUASbb3q9Tpb7cKHPtQS0+EEYdjwDjYgBI9PhL/wj6lrYQMTdGiLo9Yr5rnFHt86NaH8ga5uuq1vf6dwQ1opwrlxsCfJch5/I6X06bRZJz6LlSFtgNDu+GtrtAhjuQoZpVJflRwfMlSBsdjEDKwnEE44e80QMhaMZihfKrq8Cs9GT7TH45d616YUgziWN6jxE1MA7RUwHgx/5DwYGqa7j3EI6GQITnoW4DDcsl/coPdjWlLzKWLdylWZ4YGU8KIq9uMR8mk47M3/Ndddem8COQjCkFdz/fMpk0BQ4Cs6PdiWkuhAtji2BY9lv/m2tFyi24CDawoqqsZh/r5gQtA6
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2502B153EE41264C8678F5858028E5D9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab3c9f5-681b-4ac5-3472-08d766c5acd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 16:39:08.9394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vx7mZC/e3Uy8FFa65KBXVHCTXH8zArMJsJIaE3T1fB1I355VTYo9l4fWmCYKR6tW3bMkNVTyNY0H0mtWfu1CcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1311
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-11_05:2019-11-11,2019-11-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911110151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 8, 2019, at 11:34 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Thu, Nov 7, 2019 at 10:39 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Nov 7, 2019, at 8:20 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> Add ability to memory-map contents of BPF array map. This is extremely =
useful
>>> for working with BPF global data from userspace programs. It allows to =
avoid
>>> typical bpf_map_{lookup,update}_elem operations, improving both perform=
ance
>>> and usability.
>>>=20
>>> There had to be special considerations for map freezing, to avoid havin=
g
>>> writable memory view into a frozen map. To solve this issue, map freezi=
ng and
>>> mmap-ing is happening under mutex now:
>>> - if map is already frozen, no writable mapping is allowed;
>>> - if map has writable memory mappings active (accounted in map->writecn=
t),
>>>   map freezing will keep failing with -EBUSY;
>>> - once number of writable memory mappings drops to zero, map freezing c=
an be
>>>   performed again.
>>>=20
>>> Only non-per-CPU arrays are supported right now. Maps with spinlocks ca=
n't be
>>> memory mapped either.
>>>=20
>>> Cc: Rik van Riel <riel@surriel.com>
>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>=20
>> Acked-by: Song Liu <songliubraving@fb.com>
>>=20
>> With one nit below.
>>=20
>>=20
>> [...]
>>=20
>>> -     if (percpu)
>>> +     data_size =3D 0;
>>> +     if (percpu) {
>>>              array_size +=3D (u64) max_entries * sizeof(void *);
>>> -     else
>>> -             array_size +=3D (u64) max_entries * elem_size;
>>=20
>>> +     } else {
>>> +             if (attr->map_flags & BPF_F_MMAPABLE) {
>>> +                     data_size =3D (u64) max_entries * elem_size;
>>> +                     data_size =3D round_up(data_size, PAGE_SIZE);
>>> +             } else {
>>> +                     array_size +=3D (u64) max_entries * elem_size;
>>> +             }
>>> +     }
>>>=20
>>>      /* make sure there is no u32 overflow later in round_up() */
>>> -     cost =3D array_size;
>>> +     cost =3D array_size + data_size;
>>=20
>>=20
>>=20
>> This is a little confusing. Maybe we can do
>>=20
>=20
> I don't think I can do that without even bigger code churn. In
> non-mmap()-able case, array_size specifies the size of one chunk of
> memory, which consists of sizeof(struct bpf_array) bytes, followed by
> actual data. This is accomplished in one allocation. That's current
> case for arrays.
>=20
> For BPF_F_MMAPABLE case, though, we have to do 2 separate allocations,
> to make sure that mmap()-able part is allocated with vmalloc() and is
> page-aligned. So array_size keeps track of number of bytes allocated
> for struct bpf_array plus, optionally, per-cpu or non-mmapable array
> data, while data_size is explicitly for vmalloc()-ed mmap()-able chunk
> of data. If not for this, I'd just keep adjusting array_size.
>=20
> So the invariant for per-cpu and non-mmapable case is that data_size =3D
> 0, array_size =3D sizeof(struct bpf_array) + whatever amount of data we
> need. For mmapable case: array_size =3D sizeof(struct bpf_array),
> data_size =3D actual amount of array data.

I see. Thanks for the explanation.=20

Song

