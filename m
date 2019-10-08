Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C9FCF210
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 06:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbfJHE4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 00:56:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57658 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729426AbfJHE4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 00:56:41 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x984tNkj002898;
        Mon, 7 Oct 2019 21:56:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=bbbS65SEMUMs0Ocuk7Bj0vkCrbOycbFoG34rNDT+e94=;
 b=BxGmW7iyCLE3+L11FxTi1o43HN5M7U/xCuVFRj1HDuGgiJXdermb7i8yECIfegeT3Ors
 66uSQ3rJ/6qBgCs5gqYSu64kqgwMyOx+OeSLiSwBdZMp/HBMg/R9J441oNaWrjmaluch
 DByBHiGVJjOWtwOHcfDEosnfrv3MwOAlEZ8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vfaxprbx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 21:56:27 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 7 Oct 2019 21:56:27 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 7 Oct 2019 21:56:26 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 7 Oct 2019 21:56:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYYyPsbq3rVehdFAVK0pfy0XHe1roNGZPqWb5TcXzf8ToKfjTZkFgl/rSw4M/BLg5CwI49oi5jbNQmcFkCCyQHVoXie+C6YWDnY1clkh5FMSvTjVoPHac/dS3j8dqhF7QJ8dbhE/sCKoYT4wL4rAdMvOi0Wl4kWreV83L5r4cq3Gj52ynGRrDk6FYdR4894vkLqPjysZ9fMtVLFQJGZsMhBfJoMztMyirUEU0qRzbdo2x1IeT/qaqFlnS/YjemvIYQh0Tr4Q5iInU/c83Fs3XKzraXkLEVOY3s3yPNKDHvzC2qQtnvhaimqS1O7j3p5aVTtBOmuo+VDHwFKt36oq7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbbS65SEMUMs0Ocuk7Bj0vkCrbOycbFoG34rNDT+e94=;
 b=SqKp0YJ61cx/hV8iqMsqKVcsGBKqwbI+fs0KFu+ybf/GclsHeZE4wUdyyCKYmEQGXtz1mUyZGjiD5M3GDDNzxKOem6ZLhHXTrw5GMjyhv6lR/di4IcPuJzXXcxiQZ6Slrcw6rrunAfVPcOun6Olpc0LXY9Fq71hgMAAUYqSCprbd6JDnzYSXNJUExbcC3FcoCAvWl59nRYzDirG3yEzAQqLrOOwVDjux1tsp3+8x4QQdRj31aS31Ww2FEoLg/8Ckd1xWkaWc2qJxgMHPdGnAzQQ7RAmry/7OjivQSTVV3AjE0PdshZITCgenZ1KUv1YN86P+Ld6ZD0px66HFW+MrZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbbS65SEMUMs0Ocuk7Bj0vkCrbOycbFoG34rNDT+e94=;
 b=T6XamDzcBlF6DI0Em/ryOHrIYKJ0zVqd05ygjwOGM+ptXuR6QZTXt2fGjANiw9C1F1nnoYmKmaAFoXSQRYGLATrDMVZ83eVOAwuAQHMFHgusb0ziq8NRXVlYCXKuJ2pYdN52HDEDv/IfUzmdhgD+HSVjINdbecJ2IM6kyGxX4no=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2199.namprd15.prod.outlook.com (52.135.193.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 8 Oct 2019 04:56:26 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.026; Tue, 8 Oct 2019
 04:56:26 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 6/7] libbpf: add
 BPF_CORE_READ/BPF_CORE_READ_INTO helpers
Thread-Topic: [PATCH v4 bpf-next 6/7] libbpf: add
 BPF_CORE_READ/BPF_CORE_READ_INTO helpers
Thread-Index: AQHVfWFOcTsVfqP3i0KD6451oBFXlKdQLrSA
Date:   Tue, 8 Oct 2019 04:56:25 +0000
Message-ID: <035617e9-2d0d-4082-8862-45bc4bb210fe@fb.com>
References: <20191007224712.1984401-1-andriin@fb.com>
 <20191007224712.1984401-7-andriin@fb.com>
In-Reply-To: <20191007224712.1984401-7-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0003.namprd20.prod.outlook.com
 (2603:10b6:301:15::13) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::3ea3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 534241e0-6be3-44c5-a53b-08d74babdf73
x-ms-traffictypediagnostic: BYAPR15MB2199:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB21990A50036A6031C16A2C1FD79A0@BYAPR15MB2199.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(376002)(39850400004)(346002)(189003)(199004)(36756003)(2501003)(46003)(71200400001)(71190400001)(66476007)(66556008)(64756008)(66446008)(66946007)(6436002)(478600001)(2906002)(2201001)(6512007)(486006)(86362001)(6486002)(476003)(2616005)(31696002)(229853002)(31686004)(11346002)(6116002)(305945005)(14444005)(256004)(25786009)(186003)(76176011)(7736002)(316002)(6246003)(446003)(81166006)(52116002)(99286004)(81156014)(14454004)(6506007)(386003)(4326008)(110136005)(54906003)(53546011)(8676002)(8936002)(5660300002)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2199;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A4Uo+HywVXWD2yU2lCeUV4UOeO5dKabV5WR2YxDk8oM72+JdTg8Y19oxt6SH5vc84+owa9DxrIXmDOUeLWDnMbOE5TJz2APAv97UAiJqQKls3z5LB1lsKhEWMUodqbHWpRgbakzRzXw2NNDPDvAquVhFjmMgPIgy1Sg1vdea3oemj0RaayXHEndrlxJCEmQv01KLMLySdl7heK3Q7WaePAKcPZvzQgEyoVRDF/HpVGW6IRHEdJugOgBWmOlOFc6mX+svf/PnRbDy0JUyRIob+V+AP0XwDzsV/YmSM4z3xpuHwSFA2DAnsJmlQtNVdylgReIkcVE5PVGF0FgibUa+eMpmh567OTBxDdzFZdMOlaVFD07Lifq/kM2Bs1Om6IE3lubrLUJM88k/qwy3iQIj3ONm7yClApivFp6ii5iCGXY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DAB8701433E93848B1B9C82AE20420B4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 534241e0-6be3-44c5-a53b-08d74babdf73
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 04:56:25.8892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R4LEkcQOCPnMW45rInR0zIJM7X4HtFHHp9sIN830v6Gpvik/ifCtzRwPH+dBNvg1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2199
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-08_01:2019-10-07,2019-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 clxscore=1015 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910080050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvNy8xOSAzOjQ3IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IEFkZCBmZXcgbWFj
cm9zIHNpbXBsaWZ5aW5nIEJDQy1saWtlIG11bHRpLWxldmVsIHByb2JlIHJlYWRzLCB3aGlsZSBh
bHNvDQo+IGVtaXR0aW5nIENPLVJFIHJlbG9jYXRpb25zIGZvciBlYWNoIHJlYWQuDQo+IA0KPiBB
Y2tlZC1ieTogSm9obiBGYXN0YWJlbmQgPGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbT4NCj4gQWNr
ZWQtYnk6IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQouLi4NCj4gKy8qDQo+ICsgKiBCUEZf
Q09SRV9SRUFEKCkgaXMgdXNlZCB0byBzaW1wbGlmeSBCUEYgQ08tUkUgcmVsb2NhdGFibGUgcmVh
ZCwgZXNwZWNpYWxseQ0KPiArICogd2hlbiB0aGVyZSBhcmUgZmV3IHBvaW50ZXIgY2hhc2luZyBz
dGVwcy4NCj4gKyAqIEUuZy4sIHdoYXQgaW4gbm9uLUJQRiB3b3JsZCAob3IgaW4gQlBGIHcvIEJD
Qykgd291bGQgYmUgc29tZXRoaW5nIGxpa2U6DQo+ICsgKglpbnQgeCA9IHMtPmEuYi5jLT5kLmUt
PmYtPmc7DQo+ICsgKiBjYW4gYmUgc3VjY2luY3RseSBhY2hpZXZlZCB1c2luZyBCUEZfQ09SRV9S
RUFEIGFzOg0KPiArICoJaW50IHggPSBCUEZfQ09SRV9SRUFEKHMsIGEuYi5jLCBkLmUsIGYsIGcp
Ow0KPiArICoNCj4gKyAqIEJQRl9DT1JFX1JFQUQgd2lsbCBkZWNvbXBvc2UgYWJvdmUgc3RhdGVt
ZW50IGludG8gNCBicGZfY29yZV9yZWFkIChCUEYNCj4gKyAqIENPLVJFIHJlbG9jYXRhYmxlIGJw
Zl9wcm9iZV9yZWFkKCkgd3JhcHBlcikgY2FsbHMsIGxvZ2ljYWxseSBlcXVpdmFsZW50IHRvOg0K
PiArICogMS4gY29uc3Qgdm9pZCAqX190ID0gcy0+YS5iLmM7DQo+ICsgKiAyLiBfX3QgPSBfX3Qt
PmQuZTsNCj4gKyAqIDMuIF9fdCA9IF9fdC0+ZjsNCj4gKyAqIDQuIHJldHVybiBfX3QtPmc7DQo+
ICsgKg0KPiArICogRXF1aXZhbGVuY2UgaXMgbG9naWNhbCwgYmVjYXVzZSB0aGVyZSBpcyBhIGhl
YXZ5IHR5cGUgY2FzdGluZy9wcmVzZXJ2YXRpb24NCj4gKyAqIGludm9sdmVkLCBhcyB3ZWxsIGFz
IGFsbCB0aGUgcmVhZHMgYXJlIGhhcHBlbmluZyB0aHJvdWdoIGJwZl9wcm9iZV9yZWFkKCkNCj4g
KyAqIGNhbGxzIHVzaW5nIF9fYnVpbHRpbl9wcmVzZXJ2ZV9hY2Nlc3NfaW5kZXgoKSB0byBlbWl0
IENPLVJFIHJlbG9jYXRpb25zLg0KPiArICoNCj4gKyAqIE4uQi4gT25seSB1cCB0byA5ICJmaWVs
ZCBhY2Nlc3NvcnMiIGFyZSBzdXBwb3J0ZWQsIHdoaWNoIHNob3VsZCBiZSBtb3JlDQo+ICsgKiB0
aGFuIGVub3VnaCBmb3IgYW55IHByYWN0aWNhbCBwdXJwb3NlLg0KPiArICovDQo+ICsjZGVmaW5l
IEJQRl9DT1JFX1JFQUQoc3JjLCBhLCAuLi4pCQkJCQkgICAgXA0KPiArCSh7CQkJCQkJCQkgICAg
XA0KPiArCQlfX190eXBlKHNyYywgYSwgIyNfX1ZBX0FSR1NfXykgX19yOwkJCSAgICBcDQo+ICsJ
CUJQRl9DT1JFX1JFQURfSU5UTygmX19yLCBzcmMsIGEsICMjX19WQV9BUkdTX18pOwkgICAgXA0K
PiArCQlfX3I7CQkJCQkJCSAgICBcDQo+ICsJfSkNCj4gKw0KDQpTaW5jZSB3ZSdyZSBzcGxpdHRp
bmcgdGhpbmdzIGludG8NCmJwZl97aGVscGVycyxoZWxwZXJfZGVmcyxlbmRpYW4sdHJhY2luZ30u
aA0KaG93IGFib3V0IGFkZGluZyBhbGwgY29yZSBtYWNyb3MgaW50byBicGZfY29yZV9yZWFkLmgg
Pw0KI2RlZmluZV9fX2NvbmNhdCwgX19fZW1wdHkgYXJlIHZlcnkgZ2VuZXJpYyBuYW1lcy4NCkkn
ZCByYXRoZXIgY29udGFpbiB0aGUgcmlzayBvZiBjb25mbGljdHMgdG8gcHJvZ3MgdGhhdCBhcmUg
Z29pbmcNCnRvIHVzZSBjby1yZSBpbnN0ZWFkIG9mIGZvcmNpbmcgaXQgb24gYWxsIHByb2dzIHRo
YXQgdXNlIGJwZl9oZWxwZXJzLmguDQpXaXRoIG15IGJ0ZiB2bWxpbnV4IHN0dWZmIGFsbCB0aGVz
ZSBicGZfcHJvYmVfcmVhZCooKSB3cmFwcGVycw0KaG9wZWZ1bGx5IHdpbGwgYmUgb2Jzb2xldGUg
ZXZlbnR1YWxseS4gU28ga2VlcGluZyB0aGVtIHNlcGFyYXRlIGluIA0KYnBmX2NvcmVfcmVhZC5o
IHdvdWxkIGhlbHAgdGhlIHRyYW5zaXRpb24gdG9vLg0K
