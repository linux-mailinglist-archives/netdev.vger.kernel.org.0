Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5EA2118FAE
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbfLJSWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:22:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50972 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727374AbfLJSWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 13:22:02 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBAIJtvi005690;
        Tue, 10 Dec 2019 10:21:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dwVl7DGRtWPLAsXUWKHJZjcTRpvqxVkng764O/h1nDc=;
 b=LcGq5E92j7t+9Pt7FMeihXf9CdesLfzr6v6WF6h8qXWZCr3BCcCTfpQ+Vs5iyXTe61Xu
 1nl5Eq0qiHSP/acREKkBWdrP6BxsjXwAtogU42zCjL77pI4lHmhcilqqabg+nvB+0Xpm
 pl8ogK8Wsi+GVTxBOFneRx/sSyYQXDyoRvw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wteug8p4a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Dec 2019 10:21:46 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Dec 2019 10:21:46 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Dec 2019 10:21:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeBwAvJioS8C8g/kDqU8DLDcMO2201MNHUq8xUhVxpUm8o7QpYqK/2XAyvHq48QXBNtXS08V9ETEfDsUiWKhcHwvInGLKMLggsxl1gWbIER1cX9SsPyWWnM1dpMrQf9MZNmz1IZbSqKmRtsyg+na7M5qpW4jnJzX2+LjHYKB15lFApH70lS+m3PvCKmsSPqjnHxaQp7cE5CrHwDuhSZDGa/9SDLFjlo1/wMYRKigS2YK8n0cw0mjG2h8gv9FfXGL45D9JuY1aCeK6WIQxsTC2WUtCQWoos5dlnejt4cYussGO2CLrTHUAvap7wbSHhm4If6UuXOIwm++kREuyx5u6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwVl7DGRtWPLAsXUWKHJZjcTRpvqxVkng764O/h1nDc=;
 b=XhkXSoXIhd1QRmDc6D1/OSUV93hVVQNGwV8pDI0j58/7Lf9C5hGWo/iAulrTgwUu1qJBE7sva9kC/Yi5VdpTdpJ6eyll0jBdg9h0QbqtzNdEBjIgQUiiZb5w8Xh8DkmKhp0TZjclaY9jiUNQzzbVcXcj+OHZZ5xzIXkRH2Ix8ws5fwic/e1aN/zxymlzrMbCNeyoqWvVnKWoh6B+wxSd3O/PwLGhquUUUbcr79I4Km6R9ysS0SlTkcgE0SAe/J1e9jp2hMePL8FvcXCSOBW1coLPVORpcWDIsnfvVx173920NDsmOc8ZIbMaZphJuvTLldPYcEF6TPIq0pOeWtzmsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwVl7DGRtWPLAsXUWKHJZjcTRpvqxVkng764O/h1nDc=;
 b=MozRi5HAiOgw8WafQQA3gKxE2iblOmcLr3zGaroHjLZkuJSMt/bs1JOZZEZw6z9ERLXY1gQl76Q1N31Ot+BAJRIZ/9E/bjIs+oA/1sh8wcucls9y+2cc3LRrmfmPTHT7KYvMeV2PS0QSgMI2JGI1l5VZLtpXEqPWapeak3awCB0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3279.namprd15.prod.outlook.com (20.179.21.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 18:21:45 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 18:21:45 +0000
From:   Martin Lau <kafai@fb.com>
To:     =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf v2] bpftool: Don't crash on missing jited insns or
 ksyms
Thread-Topic: [PATCH bpf v2] bpftool: Don't crash on missing jited insns or
 ksyms
Thread-Index: AQHVr4XTlNJlrcw9ukGEe5p86G241aezrksA
Date:   Tue, 10 Dec 2019 18:21:45 +0000
Message-ID: <20191210182141.eibshhthezq6d6zd@kafai-mbp>
References: <20191210181412.151226-1-toke@redhat.com>
In-Reply-To: <20191210181412.151226-1-toke@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:300:13d::18) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:85a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 089eb64c-5c00-445d-363b-08d77d9dd00c
x-ms-traffictypediagnostic: MN2PR15MB3279:
x-microsoft-antispam-prvs: <MN2PR15MB3279F460FE132406CBC40F85D55B0@MN2PR15MB3279.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(199004)(189003)(71200400001)(66446008)(6486002)(81156014)(66556008)(81166006)(5660300002)(8936002)(66946007)(66476007)(64756008)(33716001)(186003)(4744005)(6506007)(6916009)(86362001)(6512007)(498600001)(1076003)(54906003)(8676002)(2906002)(52116002)(4326008)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3279;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: huACOZBp/zaiZklM9/44khm9WYG6lTmTOiGdtEXQgNXarCs3m6beHd19lPm8FZmMwvYJzUssQq187Xv5O8awntTUHa8VkkRIYNnWsq2/KBXSyIt3umYIyMfSGGKgYgCSlVd48yoSXGYqC6mL+J6/3aXTBj0Ta5U8/jfdfIsn0nasCnfuWxPxPQSRr8BHwwvDJ14Im9p1E/GjLiPoFg2Z/qZPScnp7sZUMJfqT2/FCGG22LUUlBrPKhCTz6SGgqbiOZbjKHnn6/Gj2wOyFdjjyDDv0eZyPClLJbl+vLJD2zVw+dOncbTbModaNbn4nijM1mNMw3TarMGMKKYtopkWFQ4xoG+NwvszuaUTY1V/TeDrD4aBO5p77/QJVtWvl9B7V1dMXmEMohpfeVcivtQR/2xz1GDW3AkWopseaN0j6QxvRg/DeJrUSVnXShT98skR
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <122C4B40D7FD9143B4C925365EEAD417@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 089eb64c-5c00-445d-363b-08d77d9dd00c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 18:21:45.1782
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mK4xfRvam03FpHm3dMbHrisXkfCqGpD+VoyEIJ8rl+efJImaUV8T35/Gla74GH9p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3279
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-10_05:2019-12-10,2019-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=435 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 phishscore=0 impostorscore=0 adultscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 07:14:12PM +0100, Toke H=F8iland-J=F8rgensen wrote:
> When the kptr_restrict sysctl is set, the kernel can fail to return
> jited_ksyms or jited_prog_insns, but still have positive values in
> nr_jited_ksyms and jited_prog_len. This causes bpftool to crash when tryi=
ng
> to dump the program because it only checks the len fields not the actual
> pointers to the instructions and ksyms.
>=20
> Fix this by adding the missing checks.
Acked-by: Martin KaFai Lau <kafai@fb.com>
