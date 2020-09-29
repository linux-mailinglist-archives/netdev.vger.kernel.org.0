Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B91A27D9C2
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgI2VI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:08:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59764 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728940AbgI2VI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:08:57 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TL5jch031222;
        Tue, 29 Sep 2020 14:08:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xIVkZR6B3Qe7rgnjS+2ugEpFFXX6XSp3nxQle6JPS+I=;
 b=A19XBBX/AVa4joD+aocIh7Fb5EJm1r+MRSOaZZ8mbm2QGCJDZihw/W+gmSDV127s7dS5
 KHVKsJn1AJ5XM85yJE+yfMHUshCRWmmfPsIUrT07tj/gPYmW7wC3Q9MeauiV8DrO9CJP
 ivWk2AFqVf9hsFcZv0gnFOjoII8iXsNB7Kg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33t35n7g7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Sep 2020 14:08:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 14:08:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7OqOtmWO+uDVXTeM7BwgvtQ7en4ssSidiwpacz7vBeZ+Mnqie2Y8nSmzb7JafIrQPGvzDcYDg7WSnTxrBasBBuwJGyOkj5RQ9LcT6W1zXoE4K96euSDN97qmHXwlVdfdUD4XvQz9GZMA2VQM+Bf4B7DDv196qIaK0hpzbTl0Gz86aXZYSXiuDlMMia8hLvihkdYhKTQ+wV9sdXhGFhrCQjXM94z2yRuCU6BJSjMm/Gr3TjEGQkR16SAy0vROHYU8SH98YMqYM7D0hdKK7ujBZIDNZX6IeK6bRa97kLBsLRZ26X5V5UsmRTv4MUFd0mEL+0KTap5Vy1SKztsAyhMfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIVkZR6B3Qe7rgnjS+2ugEpFFXX6XSp3nxQle6JPS+I=;
 b=aXHMNvf9WdiQFy/82K4PAwB6+pRrV3zMZvMTRqLrM7NPhOzU1h0JZrUktGCQQSfXvSTeWCOERd16RqUq5o6G94sedX6iNwwGhn0pW/z0Xf6AgrcMMQGYQsf31KGhiLh6+jPqwoLDatdtGUICCt+3z5XpIyMPPydEd/kvJre9V/cc6VNtFfm5A9/GRKk0AeHuYDL6/i27jzbga7SB2KD3GYusNfjBRKw39xqRuh1GIsmT0VGKdia+gYVq/dl7RKRSXxGc+gOYzQc4fcEXSoZJ+PvQWFgryiD+bZ2PqnmR94HSpcHkAFX+R0X1LO/lRNlaSOTEFlZBuGqPw2/SmipHhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIVkZR6B3Qe7rgnjS+2ugEpFFXX6XSp3nxQle6JPS+I=;
 b=BP6HvD9AEWZsLLgmnlSJDaePvFaAChfBvVabZq4YAuoBFce5CUOy95USdey8vAduRtHqbKGEVoX5oQmiD6vMyFSfvORWnqofvRyERZAimk59ivXON5v+cLu0ejIUXkxKf4i6PLXyKMat+NH+JYNe/3DASKTBnWfgf6eX169JKJQ=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2406.namprd15.prod.outlook.com (2603:10b6:a02:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.26; Tue, 29 Sep
 2020 21:08:39 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 21:08:39 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 1/2] bpf: introduce BPF_F_SHARE_PE for perf event
 array
Thread-Topic: [PATCH bpf-next 1/2] bpf: introduce BPF_F_SHARE_PE for perf
 event array
Thread-Index: AQHWlj1FNhN/q3rWS0i/6Efm6LO1bql/pcQAgABTdwCAAATXgIAAAu+AgAAb6gA=
Date:   Tue, 29 Sep 2020 21:08:39 +0000
Message-ID: <81BFF6AD-A8B7-4D15-AB31-2DEEE904B881@fb.com>
References: <20200929084750.419168-1-songliubraving@fb.com>
 <20200929084750.419168-2-songliubraving@fb.com>
 <04ba2027-a5ad-d715-ffc8-67f13e40f2d2@iogearbox.net>
 <20200929190054.4a2chcuxuvicndtu@ast-mbp.dhcp.thefacebook.com>
 <7c13d40b-fe79-ddbf-2a37-abae1b44de71@iogearbox.net>
 <CAADnVQJKArVZBg+qLqG0=rFMHC77aOed5o+zydzuM3QXE+cZrA@mail.gmail.com>
In-Reply-To: <CAADnVQJKArVZBg+qLqG0=rFMHC77aOed5o+zydzuM3QXE+cZrA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fb0b57a-45f8-4e6a-da63-08d864bbd66b
x-ms-traffictypediagnostic: BYAPR15MB2406:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2406F80893D1C4A1745867FAB3320@BYAPR15MB2406.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: byLqSPI7xGmyDjo3TR+8Z+fttZm15zBKHVgRGMywm/5EyMyoEA4JTr/TuS6+W8whiNhto15Gpx8R7cDu1nsYAdVa8WQp4Y3l9p+Hb0VbboXRkaeexMjQ3FFGHv+/MhYOVNlrFuyuL6sQfo2beicmY8ioa2vyHeMt2gaEVKh0SkrfX6h/qv2RtxO6ZVmcDAPk76fx7ZDqgqfXsxH8MNCitNTzcex0rWImSM4ZJvgyoGCpvfyu2oDtGmXJaH9wabwu9JLTLfZzr4Kif9QWLlrmOwjAhOZplz8msymj5nFIhxzIz2Jf0QYxEwNbPqvjQ8SA7vkXPEaWE2JHDKjOS91AHDLsuVldEAYq2XKNBkiilgXuqL/yNm7HwNPt1iHZ0Wi5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(366004)(346002)(376002)(4326008)(2906002)(6512007)(66446008)(66476007)(66556008)(64756008)(91956017)(76116006)(66946007)(86362001)(478600001)(83380400001)(186003)(71200400001)(33656002)(8676002)(2616005)(6506007)(6486002)(8936002)(53546011)(6916009)(316002)(5660300002)(54906003)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: rZwHCwlmm9CfELvVYiB013g1BVWbLxVym+jBK8INzJY66Vo2T4/P3kimbiOEiQ3FK3tLeoKTc9kGz6ZaJx8zo3B5zfwRi1ikYYtMl19UaBGTjOzgZ3RsN4aSkR+fmFBe/ecIDerj1ZdZPs5QIjysr7qKrFLzOeIPrCAwleEvWafx4JScQEJVvKd+BPDHQjdkwpgq2X7u4EkRGa2Oi5jqv5dUh+I7RzP6enhDNfU2fW9//DTTl/zXn4EbW3zHqjgqAUI7hahzzkcqjdN2gJ1dBBRPX9Br1SP5pJbyuBQ4RSfo6UFJtDCQ+C8SJe5hmHJjIFeDKAoaP4UffcZ9cZwuOkNxrAH6qfo5sHSroMBtAUhRVIyngTBJES62y52rGHR5BTb1lkdDAt7HKT+jYgClPgzdCcZPw/olh1RJ0luMr/9LWqFXfgn8CLlw4INnm/3Ka/+oTe6TTEUekT34YteQQfrR1EIM5nIW9MZgkvsYhwvC5K226L+p4Pk9eOZEUSx6OA/3J1I20cZ+RQCLRJkcYqjBshmkvf7I2hc6AcSZCtzObtYKJ/fWf4Hvif7sWy4T2QPwXjaWY8xHUm/f66teYvuxxMgKvcjVUZr1I8UjZR9fuWyJXKW2mjZRxO/i2+h3JWHZuQ1UZfww6fcjtRYw9ayKYewr6i62mq1S0CLZk0lzCf05EWzKF6g6kLxvtLKv
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0CE5F9350559C2448EE51122147696F2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fb0b57a-45f8-4e6a-da63-08d864bbd66b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2020 21:08:39.0820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SdE0KGokiOyWTEZRVVNWgD31yFAFQ7g1uSLcXfB0dHsNPAiDrYMze2F/Mtdo0N+k8V/fWaehfCcIKuIczit08g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2406
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290180
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 29, 2020, at 12:28 PM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>=20
> On Tue, Sep 29, 2020 at 12:18 PM Daniel Borkmann <daniel@iogearbox.net> w=
rote:
>>=20
>> On 9/29/20 9:00 PM, Alexei Starovoitov wrote:
>>> On Tue, Sep 29, 2020 at 04:02:10PM +0200, Daniel Borkmann wrote:
>>>>> +
>>>>> +/* Share perf_event among processes */
>>>>> +   BPF_F_SHARE_PE          =3D (1U << 11),
>>>>=20
>>>> nit but given UAPI: maybe name into something more self-descriptive
>>>> like BPF_F_SHAREABLE_EVENT ?
>>>=20
>>> I'm not happy with either name.
>>> It's not about sharing and not really about perf event.
>>> I think the current behavior of perf_event_array is unusual and surpris=
ing.
>>> Sadly we cannot fix it without breaking user space, so flag is needed.
>>> How about BPF_F_STICKY_OBJECTS or BPF_F_PRESERVE_OBJECTS
>>> or the same with s/OBJECTS/FILES/ ?
>>=20
>> Sounds good to me, BPF_F_PRESERVE_OBJECTS or _ENTRIES seems reasonable.
>=20
> May be BPF_F_PRESERVE_ELEMENTS?
> or _ELEMS ?
> I think we refer to map elements more often as elements instead of entrie=
s.
> But both _entries and _elems work for me.

BPF_F_PRESERVE_ELEMS sounds best to me. I will go ahead with it.=20

Thanks,
Song=
