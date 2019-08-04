Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E53228099C
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 07:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbfHDFqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 01:46:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51530 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbfHDFqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 01:46:03 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x745iUCB005139;
        Sat, 3 Aug 2019 22:45:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ALpqmZ+l27G8kA+cVxGkioggom4C1BmhlqCm2+NfaCs=;
 b=RI/s9hLkjOTWTBUjeGZlHo7W/ICSTx9Z+3uSOpAnb7vW0D8SUP39kvABQ8MW+uKAdlxi
 IHZeH4fWxMz8TlAkRZdkZFD5tIK1MKrpVAuti89C74oKYbV0QaZR86PtoYN1plWiFL7D
 GmqtZVhrgIrtTE9rGQT9c7VSLQrZJ6LvTeA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u55jpan61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 03 Aug 2019 22:45:42 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 3 Aug 2019 22:45:41 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 3 Aug 2019 22:45:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lq/MwE11FqtHsk5bO1qSG/X9cATKH/mZbv8013Qnmmc1yIjdFXKjDW06mi1RP1wxbv64OhO/X5RnUCJw1QXd6SLhTqszzqYDDuxbj3mDzTntPaPmn3gTGkItiZ+RS206Z0KgFI5oHjtyK0n4d2t4qatThdCNP33pDuYNHoZTr86dJ60VokItpOiSQBr5vRJ20J7q/9ZSfeLgOvYjkM7TyAeTqk6xd1+ZE7iHZFPkxhXjNl2NfQoFBsul3DN3ri231fY6KZ9ZFOtU2nU0oJqynGA2pVFiB3Q/YJCfUxtZSg3Uv4SOgurVUmcINkbJPyMmMcUxildql1qXGFXxZjKi3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALpqmZ+l27G8kA+cVxGkioggom4C1BmhlqCm2+NfaCs=;
 b=Km9jARU2Jjc2WJC2SlVoQ+KXYhvd5Za1+oUQXedopCaoDaTvI0wEaMdBUtGq+l4MqhC/O6PolKzM1LPpCbOxHvrK4M8UKA11Jk/E2TBeQyU6PLsyxLWjdpcCQQdrOQ+wa6C4jICt2LDAeB9xTYRstpto+RCeIfEM6vKdjORx6RmMdAja6dL/AzJSCgi9hrvJQZkzfWnxv/99bBqL5Xi1YKLRgS4QwL0fx9WZf5NpH+vxa5T5CtpNq3wSl0ruMd7lyvzxdZHEk90+kKrAPuChoyGDTJz9PCOeisFFFlFzuRqTkp68zasqiVyiKsobRmzAKUVqZkWg6sIgRhrLMODX/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALpqmZ+l27G8kA+cVxGkioggom4C1BmhlqCm2+NfaCs=;
 b=D28SVZImj3NuU0jnEpewaVILQ9I5MSDVzlXuMuYsE6xaFUY0h5YAPN3r7lk2KuRrOxe65OXuPK6AJ5nZKx5iv9roxBSzfsnqQJdWDT0516SN1f1t2zTpsBVlgWx7KFWc3fM2oj1FEui4jlubP245NwGrK7UOINntWzeqMg+kYjc=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2440.namprd15.prod.outlook.com (52.135.198.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Sun, 4 Aug 2019 05:45:23 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2136.018; Sun, 4 Aug 2019
 05:45:23 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: add loop test 5
Thread-Topic: [PATCH bpf-next 2/2] selftests/bpf: add loop test 5
Thread-Index: AQHVSYrdk2+SyumPdkyaCEy/6vRCg6bqfIQA
Date:   Sun, 4 Aug 2019 05:45:23 +0000
Message-ID: <3f8c913c-3644-6821-70a0-cf129d2a080d@fb.com>
References: <20190802233344.863418-1-ast@kernel.org>
 <20190802233344.863418-3-ast@kernel.org>
In-Reply-To: <20190802233344.863418-3-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1601CA0012.namprd16.prod.outlook.com
 (2603:10b6:300:da::22) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::dc4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1de669b0-791d-4e95-9fda-08d7189ef1b5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2440;
x-ms-traffictypediagnostic: BYAPR15MB2440:
x-microsoft-antispam-prvs: <BYAPR15MB24404AB43DA460C488DA6750D3DB0@BYAPR15MB2440.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0119DC3B5E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(396003)(346002)(136003)(189003)(199004)(446003)(66946007)(66476007)(6436002)(71200400001)(66446008)(2906002)(64756008)(6246003)(31696002)(31686004)(110136005)(36756003)(71190400001)(229853002)(53936002)(6486002)(2501003)(66556008)(99286004)(6506007)(5024004)(86362001)(6512007)(102836004)(8676002)(52116002)(8936002)(478600001)(7736002)(53546011)(76176011)(11346002)(186003)(25786009)(476003)(14454004)(305945005)(4326008)(81156014)(6116002)(81166006)(2616005)(386003)(68736007)(486006)(54906003)(256004)(316002)(5660300002)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2440;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fsibLVN7VZFpPtEHIDFUXiC/o+lddcIVtXFXAUXfpE2C8EJB18HsOxrFH8lnn+iPmSDWQbHicLU8cD2qt+G65XIodul5ACH35W079hyDZRejYSxe7/6nSk5z6fH8ubjVCOSgIJi5S0uCvrcoVDDiihrSsfEWwg3l2z3UDtD1QX0YNIC+fKu+uqzzPEkkOUTksLxGGVbUTZPSt2k0UTQN6rSZFO6AdnIM4eDvgNPaNFH9BHPHSN8y+6WSeib4RrHcDIWS4ubzWNn86rVtuRGrljiNBhQtk6NCfGSJK+CSFtvVqe4M1kof1os7VVvQSHoqQ5zulxSG5JYIOECa22hhD8XkW+WNjQv51QqV6HoSME/F/GYK+SrlknprCbXFcX58Q1UzWp0bAL4FXh34OJEAMZbrMRWruI3JcPwFZ7/0dL0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3530C1FFBAC13443876E96E53DCD1798@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de669b0-791d-4e95-9fda-08d7189ef1b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2019 05:45:23.7474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2440
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-04_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908040068
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMi8xOSA0OjMzIFBNLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+IEFkZCBh
IHRlc3Qgd2l0aCBtdWx0aXBsZSBleGl0IGNvbmRpdGlvbnMuDQo+IEl0J3Mgbm90IGFuIGluZmlu
aXRlIGxvb3Agb25seSB3aGVuIHRoZSB2ZXJpZmllciBjYW4gcHJvcGVybHkgdHJhY2sNCj4gYWxs
IG1hdGggb24gdmFyaWFibGUgJ2knIHRocm91Z2ggYWxsIHBvc3NpYmxlIHdheXMgb2YgZXhlY3V0
aW5nIHRoaXMgbG9vcC4NCg0KQWdyZWVkIHdpdGggbW90aXZhdGlvbiBvZiB0aGlzIHRlc3QuDQoN
Cj4gDQo+IGJhcnJpZXIoKXMgYXJlIG5lZWRlZCB0byBkaXNhYmxlIGxsdm0gb3B0aW1pemF0aW9u
IHRoYXQgY29tYmluZXMgbXVsdGlwbGUNCj4gYnJhbmNoZXMgaW50byBmZXdlciBicmFuY2hlcy4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+
DQo+IC0tLQ0KPiAgIC4uLi9icGYvcHJvZ190ZXN0cy9icGZfdmVyaWZfc2NhbGUuYyAgICAgICAg
ICB8ICAxICsNCj4gICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvbG9vcDUuYyAg
ICAgfCAzNyArKysrKysrKysrKysrKysrKysrDQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCAzOCBpbnNl
cnRpb25zKCspDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi9wcm9ncy9sb29wNS5jDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvYnBmL3Byb2dfdGVzdHMvYnBmX3ZlcmlmX3NjYWxlLmMgYi90b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9icGZfdmVyaWZfc2NhbGUuYw0KPiBpbmRleCA3NTdlMzk1
NDBlZGEuLjI5NjE1YTRhOTM2MiAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvYnBmL3Byb2dfdGVzdHMvYnBmX3ZlcmlmX3NjYWxlLmMNCj4gKysrIGIvdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvYnBmX3ZlcmlmX3NjYWxlLmMNCj4gQEAgLTcyLDYg
KzcyLDcgQEAgdm9pZCB0ZXN0X2JwZl92ZXJpZl9zY2FsZSh2b2lkKQ0KPiAgIAkJeyAibG9vcDEu
byIsIEJQRl9QUk9HX1RZUEVfUkFXX1RSQUNFUE9JTlQgfSwNCj4gICAJCXsgImxvb3AyLm8iLCBC
UEZfUFJPR19UWVBFX1JBV19UUkFDRVBPSU5UIH0sDQo+ICAgCQl7ICJsb29wNC5vIiwgQlBGX1BS
T0dfVFlQRV9SQVdfVFJBQ0VQT0lOVCB9LCA+ICsJCXsgImxvb3A1Lm8iLCBCUEZfUFJPR19UWVBF
X1JBV19UUkFDRVBPSU5UIH0sDQoNCk1vcmUgbGlrZSBhIEJQRl9QUk9HX1RZUEVfU0NIRURfQ0xT
IHR5cGUgYWx0aG91Z2ggcHJvYmFibHkgaXQgZG9lcyBub3QgDQptYXR0ZXIgYXMgd2UgZGlkIG5v
dCBhdHRhY2ggaXQgdG8gYW55d2hlcmU/DQoNCj4gICANCj4gICAJCS8qIHBhcnRpYWwgdW5yb2xs
LiAxOWsgaW5zbiBpbiBhIGxvb3AuDQo+ICAgCQkgKiBUb3RhbCBwcm9ncmFtIHNpemUgMjAuOGsg
aW5zbi4NCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9s
b29wNS5jIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL2xvb3A1LmMNCj4gbmV3
IGZpbGUgbW9kZSAxMDA2NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwLi45ZDk4MTdlZmUyMDgNCj4g
LS0tIC9kZXYvbnVsbA0KPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3Mv
bG9vcDUuYw0KPiBAQCAtMCwwICsxLDM3IEBADQo+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmll
cjogR1BMLTIuMA0KPiArLy8gQ29weXJpZ2h0IChjKSAyMDE5IEZhY2Vib29rDQo+ICsjaW5jbHVk
ZSA8bGludXgvc2NoZWQuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9wdHJhY2UuaD4NCg0KVGhlIGFi
b3ZlIGhlYWRlcnMgcHJvYmFibHkgbm90IG5lZWRlZC4NCg0KPiArI2luY2x1ZGUgPHN0ZGludC5o
Pg0KPiArI2luY2x1ZGUgPHN0ZGRlZi5oPg0KPiArI2luY2x1ZGUgPHN0ZGJvb2wuaD4NCj4gKyNp
bmNsdWRlIDxsaW51eC9icGYuaD4NCj4gKyNpbmNsdWRlICJicGZfaGVscGVycy5oIg0KPiArI2Rl
ZmluZSBiYXJyaWVyKCkgX19hc21fXyBfX3ZvbGF0aWxlX18oIiI6IDogOiJtZW1vcnkiKQ0KPiAr
DQo+ICtjaGFyIF9saWNlbnNlW10gU0VDKCJsaWNlbnNlIikgPSAiR1BMIjsNCj4gKw0KPiArU0VD
KCJzb2NrZXQiKQ0KPiAraW50IHdoaWxlX3RydWUodm9sYXRpbGUgc3RydWN0IF9fc2tfYnVmZiog
c2tiKQ0KPiArew0KPiArCWludCBpID0gMDsNCj4gKw0KPiArCXdoaWxlICh0cnVlKSB7DQo+ICsJ
CWlmIChza2ItPmxlbikNCj4gKwkJCWkgKz0gMzsNCj4gKwkJZWxzZQ0KPiArCQkJaSArPSA3Ow0K
PiArCQlpZiAoaSA9PSA5KQ0KPiArCQkJYnJlYWs7DQo+ICsJCWJhcnJpZXIoKTsNCj4gKwkJaWYg
KGkgPT0gMTApDQo+ICsJCQlicmVhazsNCj4gKwkJYmFycmllcigpOw0KPiArCQlpZiAoaSA9PSAx
MykNCj4gKwkJCWJyZWFrOw0KPiArCQliYXJyaWVyKCk7DQo+ICsJCWlmIChpID09IDE0KQ0KPiAr
CQkJYnJlYWs7DQo+ICsJfQ0KPiArCXJldHVybiBpOw0KPiArfQ0KPiANCg==
