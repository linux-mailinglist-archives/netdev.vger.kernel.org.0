Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7548FE42F4
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 07:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392999AbfJYFhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 01:37:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43166 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732032AbfJYFht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 01:37:49 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9P5Y52w023253;
        Thu, 24 Oct 2019 22:37:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=exx4NqJqaQ+vgBGKwHLDOmzPYv4mxNcMkYuH0rHJ4/U=;
 b=EkxCBs1fu4f0t/GPv10kAqVKu46xupCxfvs2TB7rk7ijK/PTw0L0yzMpCKT5fRn1UzlE
 dSeODbSDSVnQAooLEfQxZuza8u1sMWFBCV/Rt7QmgHQoYgu4CkcA/n2GUBfZKG12ZDSS
 ji8tPdXSj12Mlxfe+mlekBam5KhVJ0QNdTU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vtyd6y9rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 24 Oct 2019 22:37:36 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 24 Oct 2019 22:37:02 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 24 Oct 2019 22:37:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CoSVC8lettdatbhKlRtR9uhIBcPOILYxOovWg6JnDIWz6G/IirIRmScjQxl2GCFdO1VCq9JRu3v99wpzHtBHCF9/cyxc3MshHkXxmsTy7QGoWVP1N4zpmKziINaVjF2UsXTfQUGUcgkxij9n8mJgrYhR6jAd7xsRpKND5fDFX/3AjEj5r4YnIowo3Ut73bj2rCbQuW2dv5ioGaGQsGXVaJIVLxjPaAn+i5C4DQ78QIs0RuPYJye2dTf9QpvuOlDGcrmAiYGL6EBM6Ik0Uy0GoWq647Cd3h7PF6BJ+0YiwVDgH0EBrj53L01SVM5Y7GV1J2iL6VqpqQwjklrmUCKqyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exx4NqJqaQ+vgBGKwHLDOmzPYv4mxNcMkYuH0rHJ4/U=;
 b=JWTtnGTRJBOv0WcvQfw7sDeSEKziCfHOrwprBvcG+pVx6Uljak5aUk20ydh95/SwU4LPgfS0WlbNQWGlM3e+YZYzi89xp5KzWx4yEqEKVkZ06ok4HXXuuY/xMgvOvu5rD6U0mYS0taIAazQ25a3FsVPpMNSMLlrsgpypDOeEZgIudvf2qOtZQEzQQyLOewaEuRuIIkMyoXb/H4OOXAD6f0N0G8DMXc9a0Ww2uUaSkAhN4JAVjGAbRwfQ2bJsHCm4mr11zS49jWlJ4deLOasct4ROQg1z0W38PLjcquYEMHmBAuwi3uL2m0ZhiHrdI33zPBdjkQZdM9LgfOOmhN6+zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exx4NqJqaQ+vgBGKwHLDOmzPYv4mxNcMkYuH0rHJ4/U=;
 b=XQIa4mWtmfGkC+Z8V7yIv58iyWWWZCBm8ua02fco91AOydVrpXu0K26NNOJUb0zSXYIXZzOT+tVCJQ4mElsgUUokT0Z/4s36KWtRdc/s2VOx5sYR4LgDAL8Ihw6qEJqNzyHhr9ECbtf3hqGiEC5UB0u+Lx1+Cr4bLAntKhERDjY=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2421.namprd15.prod.outlook.com (52.135.197.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Fri, 25 Oct 2019 05:36:47 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 05:36:47 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix .gitignore to ignore
 no_alu32/
Thread-Topic: [PATCH bpf-next] selftests/bpf: fix .gitignore to ignore
 no_alu32/
Thread-Index: AQHVivBq7XylMGNGsUWLTpnfHXvr3adq1nsA
Date:   Fri, 25 Oct 2019 05:36:47 +0000
Message-ID: <874e3435-e092-2151-64aa-b58b61ddfb4f@fb.com>
References: <20191025045503.3043427-1-andriin@fb.com>
In-Reply-To: <20191025045503.3043427-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0031.namprd21.prod.outlook.com
 (2603:10b6:300:129::17) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::c05b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5595d9cc-3f37-43d4-81ae-08d7590d53a0
x-ms-traffictypediagnostic: BYAPR15MB2421:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2421C3B65BE630F210A12C26D3650@BYAPR15MB2421.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(346002)(39860400002)(396003)(51914003)(199004)(189003)(102836004)(36756003)(4744005)(305945005)(478600001)(229853002)(6486002)(5660300002)(186003)(46003)(86362001)(71190400001)(71200400001)(2501003)(8936002)(2616005)(11346002)(25786009)(81166006)(486006)(6436002)(53546011)(6506007)(386003)(6512007)(446003)(316002)(54906003)(99286004)(2906002)(31686004)(476003)(81156014)(7736002)(110136005)(14454004)(76176011)(6246003)(66946007)(4326008)(66556008)(31696002)(66476007)(64756008)(6116002)(256004)(14444005)(52116002)(8676002)(2201001)(66446008)(142923001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2421;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mDGYWy3iJ9TZjXfjEc/dQ+jBu3entjT+mQQgYBmda0AumCI2KEcMJxGqTvEpi1ZN/SY+4ZLRON0ouLCh+dqjJZdXAuf91i4KTNm7WIa8qNghDGEShDZzC3azc90cCGrDCeHurqOit1Il3YuG8dBdV0Fephy8hkwOiGBJmsy3mSJv3fg1wYNfVfBydhykI7k52NkccCWRUL1i0VZRc1P5zwaHToSEmzyNMmZfzzrxOKnRaxXnK066Ur1j+XTDVzH6QcDgUGTZvdveLIL8slydlywLqEN3dAVxyWOwqk0kxgfm24O2irLyMRphnxxLV47KzUvmvMv8mBGo0yoiqGIolMLCRhusedcItTQw4cyhPAyo0VDK1RqQ4095UHzCwxVr1uJ3jf0azyErsg73zflSswn3J2ezxrqQXPhTBKTerRmHuitN6IHFVGWaNlyWKmD2
Content-Type: text/plain; charset="utf-8"
Content-ID: <387AAA1091CB46469E478AB05F4BD374@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5595d9cc-3f37-43d4-81ae-08d7590d53a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 05:36:47.2746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DYGAlodz5Xicz5+782urpn/9CjALSMhKSdkonUrhfCQKT41JVeNEEKnNn3RiGw7j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2421
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-25_03:2019-10-23,2019-10-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910250054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzI0LzE5IDk6NTUgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gV2hlbiBz
d2l0Y2hpbmcgdG8gYWx1MzIgYnkgZGVmYXVsdCwgbm9fYWx1MzIvIHN1YmRpcmVjdG9yeSB3YXNu
J3QgYWRkZWQNCj4gdG8gLmdpdGlnbm9yZS4gRml4IGl0Lg0KPiANCj4gRml4ZXM6IGUxM2EyZmU2
NDJiZCAoInRvb2xzL2JwZjogVHVybiBvbiBsbHZtIGFsdTMyIGF0dHJpYnV0ZSBieSBkZWZhdWx0
IikNCj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCg0K
VGhhbmtzIGZvciB0aGUgZml4IQ0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+
DQoNCj4gLS0tDQo+ICAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmLy5naXRpZ25vcmUgfCAy
ICstDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmLy5naXRpZ25vcmUg
Yi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvLmdpdGlnbm9yZQ0KPiBpbmRleCA2ZjQ2MTcw
ZTA5YzEuLjQ4NjUxMTZiOTZjNyAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvYnBmLy5naXRpZ25vcmUNCj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmLy5n
aXRpZ25vcmUNCj4gQEAgLTM3LDUgKzM3LDUgQEAgbGliYnBmLnNvLioNCj4gICB0ZXN0X2hhc2ht
YXANCj4gICB0ZXN0X2J0Zl9kdW1wDQo+ICAgeGRwaW5nDQo+IC0vYWx1MzINCj4gKy9ub19hbHUz
Mg0KPiAgIC9icGZfZ2NjDQo+IA0K
