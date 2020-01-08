Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30070134B64
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 20:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgAHTR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 14:17:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46830 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726989AbgAHTR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 14:17:29 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008JG7w4031007;
        Wed, 8 Jan 2020 11:17:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=UyrhBElnKlBwGJ+YleVzFHWl4ECTt94heWRX07hj2Qo=;
 b=eljxccHe74OM3fPenFvwCSwhn//dLJ6wAGHFtQ9hvIrNzqRsjPXuUCYzUD596amYJw/o
 hRLJeK+cyDwKZ/xfm7fdMYgVjzoC+gDgA2ZRpZoYxGi1BhITak72L+cIWYPvBVS2M/G4
 HdJxyndZ48OdNVtgkMX6HagCEfIhvHMBGl4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xcy1vppu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Jan 2020 11:17:16 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 8 Jan 2020 11:17:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=da/QobLdFOBmxywpI+30mCh7ti+jTu1hscY2tXaHnBTvSIrLic9AkZleMZJ0EcSzbzCY0B9OgAaYZyK+JtejbReBg928q5bJDR80aLuxX0hUzUcBpx9VtPm85HemlExA4O1ewg5ViIKDfMYlvmOhRxBqzzm0XpP/EHZ2Fre67zA9U1hRIEGaUtxD0yuZGl5DaAU9nv/E5ZJQ9w5RfkUNDMTZjoNFiQlqGLn2Jy9Eu1DUhHuoUN04H7EbI+0kUX9yofJiFvO7C19DhHJdlzQhk4Y/1H8NDm5nCsyjs+ftWSD/6/dJixEi/Xh+p+GCsQdkiO19nR3jihbh69o+Si2h2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyrhBElnKlBwGJ+YleVzFHWl4ECTt94heWRX07hj2Qo=;
 b=klCDuXJUZ83ZR7C+A7HWqjyg3xAwbdr6NDu4yJRWnOah94gJYHPiNRmxuaTXowddrWd3rrMcCoWjAZqEQQL6g1TNHnQb0DWi1LxRMkYX4vzSzOtFL8NfvNCTkU43pHrhLFncUJcwNWoUZ2i2TZjkgbMHDfz8t1RaLlP1YOIrV/CnH6WPF7Rf1D8bEeD7h8OCxx2sFD6YDdGK2AG96rYzwxIILCDqLBImapi/CMh45XtVmB0zEiEy5seEKHiRCn8rXIkELBcKfJ4HOM1oUzfI3yvgzjWg45w1x3LlGqBznIAdDHatghF9bRZOVCDqUbIorjK0gnVrHjORrfuT6nFMmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UyrhBElnKlBwGJ+YleVzFHWl4ECTt94heWRX07hj2Qo=;
 b=jJgGHOF/2XCTZEE53LU+VmVuC+IEN6UQ6JtGT9DZ5kbj2q9yTAJ9a108jTcXUyApmZWYzLYMgfw00AqX/wgxrIhm3DXFpZaPpOvKoURZC5JrmqXI7aDe5dAl/SGxC0ow55pq7TGu3DZnWESPLyJtcvQMALZkDAM2Kdv7N5VpZD8=
Received: from BYAPR15MB3029.namprd15.prod.outlook.com (20.178.238.208) by
 BYAPR15MB3333.namprd15.prod.outlook.com (20.179.58.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Wed, 8 Jan 2020 19:17:14 +0000
Received: from BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d]) by BYAPR15MB3029.namprd15.prod.outlook.com
 ([fe80::3541:85d8:c4c8:760d%3]) with mapi id 15.20.2602.017; Wed, 8 Jan 2020
 19:17:13 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 5/6] selftests/bpf: Add a test for a large global
 function
Thread-Topic: [PATCH bpf-next 5/6] selftests/bpf: Add a test for a large
 global function
Thread-Index: AQHVxfTjbzXi7NA/6kibXmNTdS98SafhJGoAgAAAIoA=
Date:   Wed, 8 Jan 2020 19:17:13 +0000
Message-ID: <2B98CB37-3EC5-4949-B13B-C42CC50B8CA7@fb.com>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-6-ast@kernel.org>
 <CBF99827-3048-4517-BFE9-0AEE37BA278B@fb.com>
In-Reply-To: <CBF99827-3048-4517-BFE9-0AEE37BA278B@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.40.2.2.4)
x-originating-ip: [2620:10d:c090:180::c159]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bcd7f21-af95-4726-cdbe-08d7946f5e41
x-ms-traffictypediagnostic: BYAPR15MB3333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33337AC7ED6419C8B90C945DB33E0@BYAPR15MB3333.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:428;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39860400002)(396003)(366004)(199004)(189003)(2616005)(54906003)(6916009)(36756003)(71200400001)(2906002)(66476007)(64756008)(66446008)(66556008)(316002)(6512007)(33656002)(6486002)(86362001)(186003)(76116006)(66946007)(91956017)(8676002)(81156014)(8936002)(81166006)(53546011)(6506007)(5660300002)(478600001)(4326008)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3333;H:BYAPR15MB3029.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PdY28N89nSKvr3N5paeEAQkTIx6LKKaxXjWKD+VT7kmHyc0FQ1G38l9yYBptI/uqSEga00IgcE6GcsUisUIPFVaVgFqyW67luSFKSGDS8tAtPT4Ct85esllbTTyqCd2stcdAXl0O7bh4FQTgtP1fEUmZ5q9qzIHaDR0SvIX98dWTN5n3HSIc6B8JqyhPMqhUL6p8v7WIa9YSCbP8+7OMZ5PuMXhbJeXIQxP1hInrcOFUWMfW4tk402DG0W7FLqc7XrUGRmTVJ6i1hgvoDFLlsM7bmEI7nLigjiTHsaTb9QCUgG8ikrJwi7S9VkO/4VPzdDG37Wit8VkWPi6v8dBGI/53SHhqt3qydWo5fsxLX2Or8oZPdhDq6CFQJgDP9QhKveyXtstNrUaf/RTuba7wbM6ARdWgx8gApl7UQjPy4GW1JpzvcwAj0WXdtDFI8Je7
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10E9A980896312419C581FA80FD119D6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bcd7f21-af95-4726-cdbe-08d7946f5e41
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 19:17:13.8666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SVIVfsa9JICeX7wLyojQ5PlY8qxTbJ2ZJh1bLwqhICOwe8T3pb8hH9pfHJzorL1LWfASqqHO1N6cVbhQyYXZwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3333
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_05:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=649
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 8, 2020, at 11:16 AM, Song Liu <songliubraving@fb.com> wrote:
>=20
>=20
>=20
>> On Jan 7, 2020, at 11:25 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>>=20
>> test results:
>> pyperf50 with always_inlined the same function five times: processed 463=
78 insns
>> pyperf50 with global function: processed 6102 insns

This is awesome!

>>=20
>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>=20
> Acked-by: Song Liu <songliubraving@fb.com>

