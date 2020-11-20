Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03092B9FDE
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgKTBj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:39:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39704 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbgKTBjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 20:39:24 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK1EWVq016907;
        Thu, 19 Nov 2020 17:39:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4ViDyCvJgPOSlCa12hxCgMSYf3EBU4Ab7MQs4NghHr8=;
 b=LJ67J8+cWZw3bbcgZgqx7OeV2ZcUkMsEwypxhSYiQTnGnO+3+zKm2tx+9aLCnfutEtEG
 F75FfIxaLijfE80tLiYLqKqIIwNrBW6ogRysb29pPW23Ux3a5R8Qv6x/H3Ndso5l9VTC
 +wxLpBn4qY9gd0FiZCS/djKPM9JawEyECcQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34wdgvssv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 17:39:09 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 17:39:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8YItL7nrTjebqHnqhTC8dkcZ4NSNmV6mgWZNx2caNgSohG4B06Kd5BlKwb0Nip3XpYCPlUi6h80Cm2Svee6Ib7A9Hj5GZ/j4xikKE0AHxXhZA/vQN7PaVx4iGyJRlbVO+Ax9SQWmDYOxYbxFmKHxdzs0DTv78JT5qRdcFbOs7eGu3vyVh4WXw7vifGF5bkw08oWtiX5z71EHTuPZCVqRG8Pgw1gpgZ10TfYKwnwJDmos/Q0v2lR9qIlZ7Xk8a47+gO0+m9szqIAqez5uV6X/a72lB8AN63HSWW5oD7BkIlqPtASdtUFNOdyAtUuvK+Tj+lQSNzpRB7FzCcvvV8Mig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ViDyCvJgPOSlCa12hxCgMSYf3EBU4Ab7MQs4NghHr8=;
 b=j3nytu3Rpm7r/wuZbqcZQ4dq7V8fBOvpCPMPNPMcz90fCRjcDvIr86PcwC+V2wvz4g23zGE/j7F2wivnb9CLVYn4yhLsypLFoJsZszjIFHveY7WbWeNSxK0kY0y/AoCpJDwJR4cZvkWXE9QRyLSgDHUg3kpFJp3oYvSucgVZVBntIfBg9fDrw44+qCPOLFILHNIX5E5lYsoqqYy9j6q+9WTI8vK+3cNElMKQ7KWQV3HhayaeyC9y5+NE/h1/x5SqJW9oKnDf1ZkM8g0KMZ96QZuvu4tAZyNMvgd5qCEFFEbwaFBo67ySpK960X2o6GnFlu5+8kV1ilDKFvIFQZt5sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ViDyCvJgPOSlCa12hxCgMSYf3EBU4Ab7MQs4NghHr8=;
 b=XQOH4YKjsxHmfYwDcQLTwKcyJu1XiMO5pbe6nk4NWjAIxggy6Rt0le36fOeOGf9nqSy5ukj7aQV7KCXrDmQFSVP3WHreXJfH2jPVVLc2N0ygkjvRjQogqBU56mKrPX41+om7Ob0To8wPrW8mbvLdrNjjXdFFhC1ccX9uISa870w=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3715.namprd15.prod.outlook.com (2603:10b6:a03:1fe::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Fri, 20 Nov
 2020 01:39:05 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 01:39:05 +0000
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
Subject: Re: [PATCH bpf-next v7 12/34] bpf: refine memcg-based memory
 accounting for hashtab maps
Thread-Topic: [PATCH bpf-next v7 12/34] bpf: refine memcg-based memory
 accounting for hashtab maps
Thread-Index: AQHWvprXtR3pfRAa/k2I5gDf/Ew0GanQPqUA
Date:   Fri, 20 Nov 2020 01:39:05 +0000
Message-ID: <25D6C4A2-A92C-403A-8550-70FC81E14286@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
 <20201119173754.4125257-13-guro@fb.com>
In-Reply-To: <20201119173754.4125257-13-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f2e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03ca08bd-af04-4817-4db3-08d88cf510ef
x-ms-traffictypediagnostic: BY5PR15MB3715:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3715822D6EDA801A5D537B8EB3FF0@BY5PR15MB3715.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:595;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5DtPUKgJJ4gfFFKwM/TU71j4N1NohVQdvJio0lOJAF3S9O2Mw66/xd/nyRRHkViOFWxTSEAhp2/LI4Sz25NIPH/5RNDMRgX1XWzhq9AmG2OkWldiYfSnboV4Rduc0cd0cNVGknJQSK2s1uB9izHmbPAgwZ+W/7aQV4kIoxx9JyVLR8/sQyjx+ULHXigUMwCLzFoB57rR2IzUGMjTLQPzTKW2HH5IX7phJyyKgqEiOWpa2knALfCGJtNEq7DTE5TFQwCduSmMmTINGhfAQO8Nwvzi/QjYBHjluvKi0raoiyC+sC0vyTyKz8AavzIRHlq7pUxBG+G0D0zjbExkR015zQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39860400002)(366004)(376002)(478600001)(6512007)(2906002)(316002)(91956017)(54906003)(64756008)(33656002)(76116006)(558084003)(6636002)(15650500001)(66476007)(6506007)(37006003)(66946007)(71200400001)(6486002)(8676002)(5660300002)(53546011)(2616005)(86362001)(66556008)(83380400001)(6862004)(66446008)(36756003)(8936002)(186003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2ggT9G0jzNKPk9PAduvOYz15W3TIFVytwRJnMjYnTP1XjLknkXFxExshJ3sHCiQ+2Z5tOSMYS03sUHGnv2j6Fc8nNSfOrew6+Qq3sytqikLsoom5kslYwQj6BzxeOG+lQfPSKVurn25DsltVE/eprmolaMnckhmE0gfLLc899cQLwpUtYa+ZEhz5D/n8nkRPi/FdXq0OK8mQCMz7pV2Amsr6y5bnn5jJ6X68lp8QBD49Wa7DQQoig9gExNj2lqzu80Z4y+CBWggXQw8rw6hs3lemwFMWtA6aFD5b0glrsMgFLMHO0dA8K6xAMNgdr5thCAiod1O8AtiRC5JaQfmFjPd9U6DnjIbrDJlKvLR8YtOWmZdHYAJaFceuqW9amjvdWfBDtsSdQAhrUeFxJ9SxDYJIcH/LxHClzb4iPqm+N8cz+9+/qbOZEz3Fnj7iHinDVhMzC+7Ze4KPK61KR9f/gvP/l1UCQ+Jdo0O0b9T9rKFemSiobKPVWr+rQICifI5klxZ0Zk+GgJZXrhYlJyi3v+eN78KiTRt2g3siaBLYppPqCZcijxURd3AtD6Uozl8HZq7B3huFEqykXtH9Ji6bD51dHVqCvp9gaGnlqZPhcwPVcMp92GNgC9LKVtrYTVpv9G77IC0a7mQwoIOjZmY8zqOPLVzao4HT9YSX4KlCnepyKVcyFpDHRF2bR+TwebLe
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B95D0878F37B6408F3801247C53D5F5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ca08bd-af04-4817-4db3-08d88cf510ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 01:39:05.0610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EjH3BWOxaKWcZf/wKIxCz1uUEbB30xR/T2BV/rdPoS08CV9quVtKOGcuV2i/RB7UDCvKng34tKeqjN5t8o1Uvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3715
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 spamscore=0 mlxlogscore=799 clxscore=1015
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011200009
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 19, 2020, at 9:37 AM, Roman Gushchin <guro@fb.com> wrote:
>=20
> Include percpu objects and the size of map metadata into the
> accounting.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>


