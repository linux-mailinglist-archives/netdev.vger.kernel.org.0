Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8079AF5320
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfKHSAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:00:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12262 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbfKHSAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:00:18 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8I03aU007970;
        Fri, 8 Nov 2019 10:00:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/urdifZwTcs24dLHe/l0e77V7rhEXpHK1oMLpY37m5c=;
 b=H6IbiA+wRCbAwJas0s5eU0IFmpNGzcRCPWnVEJU++AFbwFm7IsoHyDf/c1Mnpppdv+HD
 V0d87ZVQ8lu2vm3PBJ7Fi8jTjTGdgCLtZ83S2ir9qZgkMQ8o5SviP07A/AXImJaosQsT
 ZhFKyicPW3Llov349gD1eZB8SSa2wkow+6A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w5a4rh5ec-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Nov 2019 10:00:05 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 09:59:40 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 09:59:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEmM9hpoQbKer+fVI9mO1peoyBCIyVMCwtzxNVg7ajSzML/NkZu6Ze5GAzCtwoRWtdPgoHDJBZFQRBxrqDt6fFQwmu1a6l5qZrn8Y36l+NYO/mZxBh1BD4S4TCNituYI7aDMTtotqnVNuCEPaDy/ujVcMlrLLoLO7hRrCiYEKwP2mfeRGZiCmKhYa/dyp12Hsqn0igYXY4YKb3BhWRkMvJYq3ewjt19Hotf4GjcKw3NIZ9gwDyp5WhoCXER8sqbB6wpzHWpZtRAwxRiDhL8mEorfJaaoFl2XapTCoL+cGHpTQeYHXWDX1M7xaSd73ApwLS9HuGpHaWUCt3LOvpyZcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/urdifZwTcs24dLHe/l0e77V7rhEXpHK1oMLpY37m5c=;
 b=gcSfnciAo/7UlzZu18UIKHWpUf7p+n/l1+IuDaN9BW/bfyx3Ah+PTdYoSsrW2KQSTQ+Zf7ovcgZUkBcJIvUzEzr2KDSmKBaUPLTs21c83gPHFJdjkw6gIa9hs0+KyyDVG8I15stf3835iQazxiwTkTBczCW/qB/lbhqjeX63VLAAQzO7L9CB/8d4jLMufQWfhurKYQcPLM1EPDcYvqtDss2dp9e9mzDmkMRXav770RhqKCZdc7ZZ9aS5rXryxydyVPg9Lyb1VopbhdCjeCD4VNbv9FMnz+mYeBLhxWeenv3iHqQjtklms6W/+0U+E2p5jjGe//kJgLeHhl73Hsn3BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/urdifZwTcs24dLHe/l0e77V7rhEXpHK1oMLpY37m5c=;
 b=JtbHZXb4I3lH71KoMWIMVOBbKqbx8qWbViXJyMHzXRBfG8tbthydo1X//LeQIVunibHAHE5XFol4GMtFK1Ke0cxz/06RjSY1wZS5lMPEUa+BnD6mGP6Gr5Dxc4HOw0P1x3UncnftrMMewj3KwloszNlXgvjLHefSzU23cRURN+A=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1855.namprd15.prod.outlook.com (10.174.99.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 17:59:38 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 17:59:38 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 14/18] bpf: Compare BTF types of functions
 arguments with actual types
Thread-Topic: [PATCH v3 bpf-next 14/18] bpf: Compare BTF types of functions
 arguments with actual types
Thread-Index: AQHVlf+bHUIhx96v2Ey15OIsHx2+aaeBh9iAgAABKwCAAAbegIAAALIA
Date:   Fri, 8 Nov 2019 17:59:38 +0000
Message-ID: <7E549AA1-07A8-456E-8372-41242143582D@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-15-ast@kernel.org>
 <0A1C27F0-25D9-455C-86DF-97AC19674D8D@fb.com>
 <0E317F4C-F81F-43D2-9B8E-D8EE93C98A07@fb.com>
 <a95217de-16b2-4150-51a1-513f190e2079@fb.com>
In-Reply-To: <a95217de-16b2-4150-51a1-513f190e2079@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1be2e03e-b623-4775-ce88-08d764756c45
x-ms-traffictypediagnostic: MWHPR15MB1855:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB18554DA1C48999625C60DFBDB37B0@MWHPR15MB1855.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(51914003)(99286004)(6636002)(186003)(71200400001)(6246003)(8676002)(81156014)(71190400001)(4326008)(6862004)(486006)(81166006)(2906002)(6512007)(14444005)(33656002)(8936002)(6486002)(5024004)(256004)(229853002)(76176011)(476003)(66446008)(64756008)(66556008)(66476007)(76116006)(11346002)(446003)(50226002)(2616005)(5660300002)(6436002)(305945005)(6506007)(7736002)(102836004)(54906003)(53546011)(37006003)(478600001)(25786009)(86362001)(6116002)(316002)(14454004)(36756003)(66946007)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1855;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ur2s84GuCCfrTnYHynqFIcFA3RocuovcAarbDiYcO7lYBAc8IRedm0gYj4k26vUZOFTX/pOV8dcG7vCV/7hwg3Ab/C0oXWQl3ow3WgEFcSZlGk/mjptZV1vWY6UfZ+kJGbrsF6zyFVEUcI+Y7LB8qDRa6X9jJGcxKsGUCFn8+5lkaLpxbobGgxm1yImUOf/KFj2vifrjwlxkT9eRZmjwBglm78AvWF40sAyMyMm5q/YRn8Y55W4V0/VJPQ+q9RRQn80relckYZwtq4h/CXyrkATdeU/HKZMWBeExF8qrMOyb2H3dbjF5kplVzuiD+de9iJyJp1q4ZnuQXdLfevwReyd/iCFpcmcZcIvKb3y9LZn+0phfM8CwQfNK/TB/3PBjC4jd3DVF6mMgRbGUkcRukznOBmyWw8jEyEMu/lcyE3Ep4uwNoffTKfmmTKk4CqUg
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1852585075682D4AADDEA23E3847E2EE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be2e03e-b623-4775-ce88-08d764756c45
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 17:59:38.5370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3YZAQsq1/g6AxHdLfHr0DQYkHBEiriGci/jSkWYLL8nWlri1CN4d3uwQBNU6I5iu4QctToMnyK26P2BwVWIXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1855
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_06:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 mlxlogscore=607 malwarescore=0 impostorscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080176
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 8, 2019, at 9:57 AM, Alexei Starovoitov <ast@fb.com> wrote:
>=20
> On 11/8/19 9:32 AM, Song Liu wrote:
>>=20
>>=20
>>> On Nov 8, 2019, at 9:28 AM, Song Liu <songliubraving@fb.com> wrote:
>>>=20
>>>=20
>>>=20
>>>> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote=
:
>>>>=20
>>>> Make the verifier check that BTF types of function arguments match act=
ual types
>>>> passed into top-level BPF program and into BPF-to-BPF calls. If types =
match
>>>> such BPF programs and sub-programs will have full support of BPF tramp=
oline. If
>>>> types mismatch the trampoline has to be conservative. It has to save/r=
estore
>>>> all 5 program arguments and assume 64-bit scalars. If FENTRY/FEXIT pro=
gram is
>>>> attached to this program in the future such FENTRY/FEXIT program will =
be able
>>>> to follow pointers only via bpf_probe_read_kernel().
>>>>=20
>>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>>=20
>>> Acked-by: Song Liu <songliubraving@fb.com>
>>=20
>> One nit though: maybe use "reliable" instead of "unreliable"
>>=20
>> +struct bpf_func_info_aux {
>> +	bool reliable;
>> +};
>> +
>>=20
>> +	bool func_proto_reliable;
>>=20
>> So the default value 0, is not reliable.
>=20
> I don't see how this can work.
> Once particular func proto was found unreliable the verifier won't keep=20
> checking. If we start with 'bool reliable =3D false'
> how do you see the whole mechanism working ?
> Say the first time the verifier analyzed the subroutine and everything
> matches. Can it do reliable =3D true ? No. It has to check all other
> callsites. Then it would need another variable and extra pass ?

I see. I missed the multiple call sites part.=20

Thanks for the explanation.=20
Song

