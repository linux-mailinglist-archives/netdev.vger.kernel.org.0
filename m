Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F77FF57F2
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbfKHTz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:55:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28476 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729683AbfKHTz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:55:58 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA8JndCV032413;
        Fri, 8 Nov 2019 11:55:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6hF/oLjFCi8+WAdywH6J+FUV+DzedKBzWwhXksJIZ1o=;
 b=bmkPtSn6ajh42+72KBvoZVDxvNCAwpgLpamLQs5nFvnQ4pgvYDxsmqH+7V50qvpV+IUW
 v3QiOd0eWEyjg0dodrVoaTwyeExIIPHXUXfGoIpw8Lt70GrFwEB5NdVbI9OY6PMcOd+I
 j/J4vkC8hsYF+QGLnntnN+WZHcrHsTUBJlY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2w5ckcgugn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 11:55:41 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 8 Nov 2019 11:55:40 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 11:55:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOWxvfLAzPDvSdkTcJbtYM/NiN38lHPYgc1ocHzSiTryua/8M0UnQentqLHlhGdrihu6jL38YWU3Hf0yxp2KS0KiB7Gnj8ms6lFfeaEcpLpIcNaL6w49PCz/oysJ2Mg9gm5+0SNF1zkvDhSVC9Ll6tkN1SkLShSoWTKsabzzd/57QsdI/nLOc+pjydr+v4dg/8wIkX07KNamEVmYK73oclZ+RvZcspLZmYLPHPNqiq/faOBCQIQA9FmPPZ2Bi4fnzi9B9mDJcjl87BpMigBvOtdGt+W+q6jdxuf++T9IFQGLZMbgJ4Ey5hmH0WpnLDZEaDcKVZQgJeMWrB++box/Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hF/oLjFCi8+WAdywH6J+FUV+DzedKBzWwhXksJIZ1o=;
 b=Zs0JjZaTLT9yTpPv8S7WqaNwq1V0Rl77erS9ZALNmexSZmp2twUafIWguUKvqaG08sWLLZdw+szvnAYoYm9by+HuI9THkz0XY7GCZvlraOa7sqSd2XI4mNJQElEWkEyVeZZznkxLaYu5hXzPdG314JuLqbFH5w4NB2ZGdgT3GAnFMKIcVwyZpVERZ9SoP6nHxt2vQtZuJCgPzWP03B2FyucMqENi0QFNq2vlyFBS+TIAPFoALzrakpVw9mQKxaexwNpnbFIyVuBk82QSK+nXHRdedV19BA1OEypNeZ7pXsB+uJx2i/DngEAsblO4tWv18ihLs/jml3oQlMX2x1PtqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hF/oLjFCi8+WAdywH6J+FUV+DzedKBzWwhXksJIZ1o=;
 b=cGKsrmPFtzFiJqbtAVJw0kka/IENmk2ZHQV51UGBB0KbDKDkBu/RZK4esll6DeX1cBaXSUM2I3eQaHIcI4Du/GpYku2hkU9fl0S5GRiscLChH/tWLFdyr26FZtSeCQBV1qGu6MFdJ87ijPaEjl7zqdZ/L2AHIP9ZPvZ29A60s3s=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1679.namprd15.prod.outlook.com (10.175.141.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 19:55:38 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 19:55:38 +0000
From:   Song Liu <songliubraving@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 6/6] libbpf: Add getter for program size
Thread-Topic: [PATCH bpf-next 6/6] libbpf: Add getter for program size
Thread-Index: AQHVlYu/psQaqtey9Uu/tRwcdpVbpKeBseQA
Date:   Fri, 8 Nov 2019 19:55:38 +0000
Message-ID: <AD18E451-4473-41E3-8247-372643E68A85@fb.com>
References: <157314553801.693412.15522462897300280861.stgit@toke.dk>
 <157314554482.693412.362818059218610123.stgit@toke.dk>
In-Reply-To: <157314554482.693412.362818059218610123.stgit@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c4896a3-8602-41bd-c47b-08d76485a0b6
x-ms-traffictypediagnostic: MWHPR15MB1679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB16796CE142A30505E4604B82B37B0@MWHPR15MB1679.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(136003)(396003)(39860400002)(346002)(189003)(199004)(66476007)(66446008)(86362001)(6486002)(476003)(229853002)(446003)(81166006)(256004)(6436002)(8676002)(2616005)(36756003)(50226002)(81156014)(8936002)(33656002)(14454004)(2906002)(54906003)(486006)(11346002)(6916009)(6512007)(14444005)(5660300002)(99286004)(186003)(46003)(76116006)(6506007)(76176011)(64756008)(66556008)(66574012)(66946007)(7736002)(53546011)(316002)(25786009)(6246003)(71200400001)(6116002)(305945005)(4326008)(102836004)(71190400001)(4744005)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1679;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lwNYNO9aUMz3m/MLx44e7CuJ/69HIp2tHj3osJy6eAFkDZekPkMnPPSLPwwQBwyPIfNJ3wB77NtfiX2fXFxfQDC2nnm1pGjZTKg86KxuffqDD1kiJx7tFT0kNPeyvsH1udT91k6Sxg5FzLvjSAQ141GlGhFWiMTmIv9R/H0GwV38HVAH5+5dQQUoFv+7GL5pf0UK460AIUFecQ9s0yKrnb3AJKh8waoFDmUnoiNQEJngvDUvx2QkAtWfIe6TVCMuHZWI8wO0/9M80EKIKFCLtrfGDSnl0ClnDjScPA+/AmwbQ9Kx0ZEeWPznKcqbyL/GvdcDW8KWvxX6phCMvRMlulHGFBNiZ7dWDj5y0p6YO4xjkgewZ7pxYsg7klCuPXl2y7g7tV7t9UOgT2nmcW4ldDcwfj43dKBqk1J+4v1WO3xpeKA/T8s5NcX33z/4LMt3
Content-Type: text/plain; charset="utf-8"
Content-ID: <66FC744C8624614DAB73F65BB6FB4C44@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c4896a3-8602-41bd-c47b-08d76485a0b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 19:55:38.5035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ueW8muREuwZaz98TiEe/QmXRbj54Yd4v9nMWgNCMfqvRb6WEcpW0S7G+esJKCm6xaTGhpEdglord5BFqJjMRBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1679
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_07:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=643 impostorscore=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080192
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTm92IDcsIDIwMTksIGF0IDg6NTIgQU0sIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNl
biA8dG9rZUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFRva2UgSMO4aWxhbmQtSsO4
cmdlbnNlbiA8dG9rZUByZWRoYXQuY29tPg0KPiANCj4gVGhpcyBhZGRzIGEgbmV3IGdldHRlciBm
b3IgdGhlIEJQRiBwcm9ncmFtIHNpemUgKGluIGJ5dGVzKS4gVGhpcyBpcyB1c2VmdWwNCj4gZm9y
IGEgY2FsbGVyIHRoYXQgaXMgdHJ5aW5nIHRvIHByZWRpY3QgaG93IG11Y2ggbWVtb3J5IHdpbGwg
YmUgbG9ja2VkIGJ5DQo+IGxvYWRpbmcgYSBCUEYgb2JqZWN0IGludG8gdGhlIGtlcm5lbC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiA8dG9rZUByZWRoYXQu
Y29tPg0KDQpBY2tlZC1ieTogU29uZyBMaXUgPHNvbmdsaXVicmF2aW5nQGZiLmNvbT4NCg0K
