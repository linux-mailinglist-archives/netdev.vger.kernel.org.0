Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E68A85646
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 01:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387849AbfHGXEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 19:04:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56378 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729624AbfHGXEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 19:04:11 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x77N2aOo024557;
        Wed, 7 Aug 2019 16:03:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=RnUbRxoQ1GDYV6N3gKPhTM2ihK4izjcufNmwljP0Ox8=;
 b=TGbfTr7L5D+TksFe4brBRIlZQ7DE7cVKT3IW0p7xSlVLj+wlFNGKspl+xnKxv6F+/9wl
 RCLwqMSnvhMYq+VrSIgyD5Y3xMjvvER9nyKrKA3LeP5n4oa2oDVQBsZ0/nsuD7NO/j7k
 V4bfRs+xEjuXEOAmAnBKKdURpNNDjiAMtuo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2u87u1g0x6-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 07 Aug 2019 16:03:45 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 7 Aug 2019 16:03:43 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Aug 2019 16:03:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7hHWB52b7mxoJpe6XcrKDbC4hnVrF9Li1TnytkZxh8QSDY1dh2qUnNI8uS//Ya98SFK8ZJjSPwmw1dOqJwH+q6lVLDc1RLikRefPD6Q7M7byThmYZGiW5qqZrTYO6sJyc9KWv9xvlp9Cj9zXbGIDkcGuSXow0UWcI2GPqcSgGJjNrswfPquslseDHiXKV+dmfLVQDrrzHEOVwbaLN9+TKptSarVPXhHOGRm6Ctp6VTZ9MnNxUzwgejYjFPpE0r8L/yCZEHEH0YPsEyI5u3vOgyl24o3j8JPYjAlNCD99gdDtU7bxkJxZb6uN7EY9WBw3yFc4Ep6gMBXBqFhlPj2Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnUbRxoQ1GDYV6N3gKPhTM2ihK4izjcufNmwljP0Ox8=;
 b=lPLA/xaYVyFwbYJ033HfOXQTEXRl/UNWJxSGlQp2eE121SBJigI74/Cr/W12qSYb4jNHm6utkJlA/LkbrcMlXOmn3SZOs2snKb5mmDTTQCuv6b0yubm/swvG6e5A4XKcfzhYjE6cu7emvEgee0o0ZA3yXtHn1FyNGynEj6Bbg3dUi5Q34BUz4WBv8l0VtIDEJUUq9IYrp6ChjmUTE5ssoU9tPXWFcZTm+Cmb88bQYSp8ZlYEetNEne1NCQXlXYUZDCOZ2axk8ZOnD7VIRs4CzjaNhHmeTmNQ1zwBoEcd4ZPnzbCFI/k79VHftLD5qI3tvrXBW6yfyGy1B9RC87uH1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnUbRxoQ1GDYV6N3gKPhTM2ihK4izjcufNmwljP0Ox8=;
 b=bG3Ak7GFYcoSPCFvSMvDE97FFE4w8UaPl1KxthbmFQ2UK/vT/gi9VZ6ffuq18FDXHSMbakq7WaLiEGNWrM43ClW1/+OEzoTlVEkYIhhLtAUclWLbTGYbIcBqUXz0erEue5VIdOON+Y8wah7WrsgoHmLt/RSIzkG4vwvOxQmGYcM=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2694.namprd15.prod.outlook.com (20.179.156.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 7 Aug 2019 23:03:39 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 23:03:39 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
Thread-Topic: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
Thread-Index: AQHVTTdwUPivpnTVP0StwugAgCIRIabwTkGA
Date:   Wed, 7 Aug 2019 23:03:39 +0000
Message-ID: <9bd56e49-c38d-e1c4-1ff3-8250531d0d48@fb.com>
References: <20190807154720.260577-1-sdf@google.com>
 <20190807154720.260577-2-sdf@google.com>
In-Reply-To: <20190807154720.260577-2-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR06CA0055.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::32) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:f6d1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e425fd2c-d5e2-4b3a-0d1f-08d71b8b7c0f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2694;
x-ms-traffictypediagnostic: BYAPR15MB2694:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2694F8C98D1EE6645BCA3B91D3D40@BYAPR15MB2694.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(39860400002)(366004)(396003)(199004)(189003)(86362001)(2501003)(478600001)(5660300002)(316002)(31696002)(2201001)(7736002)(54906003)(305945005)(6512007)(66446008)(14454004)(11346002)(81166006)(81156014)(8936002)(446003)(8676002)(6116002)(110136005)(53936002)(66946007)(66476007)(64756008)(4326008)(52116002)(102836004)(76176011)(99286004)(476003)(386003)(31686004)(53546011)(14444005)(256004)(6506007)(2616005)(229853002)(25786009)(486006)(71200400001)(71190400001)(6246003)(46003)(186003)(6436002)(6486002)(36756003)(66556008)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2694;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7rLekXg1IYXP1g41yGOe4sIKJb3runs0mAcGMhIo3p5plUEqnFGgob4z5vfSyb6qc4K5BitZOflj0fpuABR6CDDgujrZ7D/CgcDIlqpxdSv825WVoUy3EO37uJGB2HN4ZJ9WfPTa2cILaqxWkWQkNH7TbGcSIVgFUNQh1k0N4bKfrsQ3cjqVI5iEOhzaSVj0nu58byyC560C5KVDydjGcKYgIfSeTgnDYREh9hMiAfoAXQbSETRrcr0HvMwGSfCL4deg5yqcI4Hk8OingmwnRTLcsYAEu09Z+pgt4mqsI99wNCVgUlA4gOORV+f7ffuRbigDSO4PPFuG1/YSGM7T/Kc0g7CCQXTSq3AYtnxDgzmGFLQPJSuLCxqkJ7C7FPGqaHBBlSG59/higihgnCcmCNk89SYe3TYDLhm2MPoxxrg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B106D50062FD64983E7B013D4BA6BDD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e425fd2c-d5e2-4b3a-0d1f-08d71b8b7c0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 23:03:39.4568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2694
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvNy8xOSA4OjQ3IEFNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+IEFkZCBu
ZXcgaGVscGVyIGJwZl9za19zdG9yYWdlX2Nsb25lIHdoaWNoIG9wdGlvbmFsbHkgY2xvbmVzIHNr
IHN0b3JhZ2UNCj4gYW5kIGNhbGwgaXQgZnJvbSBicGZfc2tfc3RvcmFnZV9jbG9uZS4gUmV1c2Ug
dGhlIGdhcCBpbg0KPiBicGZfc2tfc3RvcmFnZV9lbGVtIHRvIHN0b3JlIGNsb25lL25vbi1jbG9u
ZSBmbGFnLg0KPiANCj4gQ2M6IE1hcnRpbiBLYUZhaSBMYXUgPGthZmFpQGZiLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogU3RhbmlzbGF2IEZvbWljaGV2IDxzZGZAZ29vZ2xlLmNvbT4NCg0KSSB0cmll
ZCB0byBzZWUgd2hldGhlciBJIGNhbiBmaW5kIGFueSBtaXNzaW5nIHJhY2UgY29uZGl0aW9ucyBp
bg0KdGhlIGNvZGUgYnV0IEkgZmFpbGVkLiBTbyBleGNlcHQgYSBtaW5vciBjb21tZW50cyBiZWxv
dywNCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KDQo+IC0tLQ0KPiAgIGlu
Y2x1ZGUvbmV0L2JwZl9za19zdG9yYWdlLmggfCAgMTAgKysrKw0KPiAgIGluY2x1ZGUvdWFwaS9s
aW51eC9icGYuaCAgICAgfCAgIDEgKw0KPiAgIG5ldC9jb3JlL2JwZl9za19zdG9yYWdlLmMgICAg
fCAxMDIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4gICBuZXQvY29yZS9z
b2NrLmMgICAgICAgICAgICAgIHwgICA5ICsrLS0NCj4gICA0IGZpbGVzIGNoYW5nZWQsIDExNSBp
bnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bmV0L2JwZl9za19zdG9yYWdlLmggYi9pbmNsdWRlL25ldC9icGZfc2tfc3RvcmFnZS5oDQo+IGlu
ZGV4IGI5ZGNiMDJlNzU2Yi4uOGU0ZjgzMWQyZTUyIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL25l
dC9icGZfc2tfc3RvcmFnZS5oDQo+ICsrKyBiL2luY2x1ZGUvbmV0L2JwZl9za19zdG9yYWdlLmgN
Cj4gQEAgLTEwLDQgKzEwLDE0IEBAIHZvaWQgYnBmX3NrX3N0b3JhZ2VfZnJlZShzdHJ1Y3Qgc29j
ayAqc2spOw0KPiAgIGV4dGVybiBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX3NrX3N0
b3JhZ2VfZ2V0X3Byb3RvOw0KPiAgIGV4dGVybiBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8g
YnBmX3NrX3N0b3JhZ2VfZGVsZXRlX3Byb3RvOw0KPiAgIA0KPiArI2lmZGVmIENPTkZJR19CUEZf
U1lTQ0FMTA0KPiAraW50IGJwZl9za19zdG9yYWdlX2Nsb25lKGNvbnN0IHN0cnVjdCBzb2NrICpz
aywgc3RydWN0IHNvY2sgKm5ld3NrKTsNCj4gKyNlbHNlDQo+ICtzdGF0aWMgaW5saW5lIGludCBi
cGZfc2tfc3RvcmFnZV9jbG9uZShjb25zdCBzdHJ1Y3Qgc29jayAqc2ssDQo+ICsJCQkJICAgICAg
IHN0cnVjdCBzb2NrICpuZXdzaykNCj4gK3sNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKyNlbmRp
Zg0KPiArDQo+ICAgI2VuZGlmIC8qIF9CUEZfU0tfU1RPUkFHRV9IICovDQo+IGRpZmYgLS1naXQg
YS9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4g
aW5kZXggNDM5M2JkNGIyNDE5Li4wMDQ1OWNhNGM4Y2YgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUv
dWFwaS9saW51eC9icGYuaA0KPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4gQEAg
LTI5MzEsNiArMjkzMSw3IEBAIGVudW0gYnBmX2Z1bmNfaWQgew0KPiAgIA0KPiAgIC8qIEJQRl9G
VU5DX3NrX3N0b3JhZ2VfZ2V0IGZsYWdzICovDQo+ICAgI2RlZmluZSBCUEZfU0tfU1RPUkFHRV9H
RVRfRl9DUkVBVEUJKDFVTEwgPDwgMCkNCj4gKyNkZWZpbmUgQlBGX1NLX1NUT1JBR0VfR0VUX0Zf
Q0xPTkUJKDFVTEwgPDwgMSkNCj4gICANCj4gICAvKiBNb2RlIGZvciBCUEZfRlVOQ19za2JfYWRq
dXN0X3Jvb20gaGVscGVyLiAqLw0KPiAgIGVudW0gYnBmX2Fkal9yb29tX21vZGUgew0KPiBkaWZm
IC0tZ2l0IGEvbmV0L2NvcmUvYnBmX3NrX3N0b3JhZ2UuYyBiL25ldC9jb3JlL2JwZl9za19zdG9y
YWdlLmMNCj4gaW5kZXggOTRjN2Y3N2VjYjZiLi5iNmRlYTY3OTY1YmMgMTAwNjQ0DQo+IC0tLSBh
L25ldC9jb3JlL2JwZl9za19zdG9yYWdlLmMNCj4gKysrIGIvbmV0L2NvcmUvYnBmX3NrX3N0b3Jh
Z2UuYw0KPiBAQCAtMTIsNiArMTIsOSBAQA0KPiAgIA0KPiAgIHN0YXRpYyBhdG9taWNfdCBjYWNo
ZV9pZHg7DQo+ICAgDQo+ICsjZGVmaW5lIEJQRl9TS19TVE9SQUdFX0dFVF9GX01BU0sJKEJQRl9T
S19TVE9SQUdFX0dFVF9GX0NSRUFURSB8IFwNCj4gKwkJCQkJIEJQRl9TS19TVE9SQUdFX0dFVF9G
X0NMT05FKQ0KPiArDQo+ICAgc3RydWN0IGJ1Y2tldCB7DQo+ICAgCXN0cnVjdCBobGlzdF9oZWFk
IGxpc3Q7DQo+ICAgCXJhd19zcGlubG9ja190IGxvY2s7DQo+IEBAIC02Niw3ICs2OSw4IEBAIHN0
cnVjdCBicGZfc2tfc3RvcmFnZV9lbGVtIHsNCj4gICAJc3RydWN0IGhsaXN0X25vZGUgc25vZGU7
CS8qIExpbmtlZCB0byBicGZfc2tfc3RvcmFnZSAqLw0KPiAgIAlzdHJ1Y3QgYnBmX3NrX3N0b3Jh
Z2UgX19yY3UgKnNrX3N0b3JhZ2U7DQo+ICAgCXN0cnVjdCByY3VfaGVhZCByY3U7DQo+IC0JLyog
OCBieXRlcyBob2xlICovDQo+ICsJdTggY2xvbmU6MTsNCj4gKwkvKiA3IGJ5dGVzIGhvbGUgKi8N
Cj4gICAJLyogVGhlIGRhdGEgaXMgc3RvcmVkIGluIGFvdGhlciBjYWNoZWxpbmUgdG8gbWluaW1p
emUNCj4gICAJICogdGhlIG51bWJlciBvZiBjYWNoZWxpbmVzIGFjY2VzcyBkdXJpbmcgYSBjYWNo
ZSBoaXQuDQo+ICAgCSAqLw0KPiBAQCAtNTA5LDcgKzUxMyw3IEBAIHN0YXRpYyBpbnQgc2tfc3Rv
cmFnZV9kZWxldGUoc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3QgYnBmX21hcCAqbWFwKQ0KPiAgIAly
ZXR1cm4gMDsNCj4gICB9DQo+ICAgDQo+IC0vKiBDYWxsZWQgYnkgX19za19kZXN0cnVjdCgpICov
DQo+ICsvKiBDYWxsZWQgYnkgX19za19kZXN0cnVjdCgpICYgYnBmX3NrX3N0b3JhZ2VfY2xvbmUo
KSAqLw0KPiAgIHZvaWQgYnBmX3NrX3N0b3JhZ2VfZnJlZShzdHJ1Y3Qgc29jayAqc2spDQo+ICAg
ew0KPiAgIAlzdHJ1Y3QgYnBmX3NrX3N0b3JhZ2VfZWxlbSAqc2VsZW07DQo+IEBAIC03MzksMTkg
Kzc0MywxMDYgQEAgc3RhdGljIGludCBicGZfZmRfc2tfc3RvcmFnZV9kZWxldGVfZWxlbShzdHJ1
Y3QgYnBmX21hcCAqbWFwLCB2b2lkICprZXkpDQo+ICAgCXJldHVybiBlcnI7DQo+ICAgfQ0KPiAg
IA0KPiArc3RhdGljIHN0cnVjdCBicGZfc2tfc3RvcmFnZV9lbGVtICoNCj4gK2JwZl9za19zdG9y
YWdlX2Nsb25lX2VsZW0oc3RydWN0IHNvY2sgKm5ld3NrLA0KPiArCQkJICBzdHJ1Y3QgYnBmX3Nr
X3N0b3JhZ2VfbWFwICpzbWFwLA0KPiArCQkJICBzdHJ1Y3QgYnBmX3NrX3N0b3JhZ2VfZWxlbSAq
c2VsZW0pDQo+ICt7DQo+ICsJc3RydWN0IGJwZl9za19zdG9yYWdlX2VsZW0gKmNvcHlfc2VsZW07
DQo+ICsNCj4gKwljb3B5X3NlbGVtID0gc2VsZW1fYWxsb2Moc21hcCwgbmV3c2ssIE5VTEwsIHRy
dWUpOw0KPiArCWlmICghY29weV9zZWxlbSkNCj4gKwkJcmV0dXJuIEVSUl9QVFIoLUVOT01FTSk7
DQo+ICsNCj4gKwlpZiAobWFwX3ZhbHVlX2hhc19zcGluX2xvY2soJnNtYXAtPm1hcCkpDQo+ICsJ
CWNvcHlfbWFwX3ZhbHVlX2xvY2tlZCgmc21hcC0+bWFwLCBTREFUQShjb3B5X3NlbGVtKS0+ZGF0
YSwNCj4gKwkJCQkgICAgICBTREFUQShzZWxlbSktPmRhdGEsIHRydWUpOw0KPiArCWVsc2UNCj4g
KwkJY29weV9tYXBfdmFsdWUoJnNtYXAtPm1hcCwgU0RBVEEoY29weV9zZWxlbSktPmRhdGEsDQo+
ICsJCQkgICAgICAgU0RBVEEoc2VsZW0pLT5kYXRhKTsNCj4gKw0KPiArCXJldHVybiBjb3B5X3Nl
bGVtOw0KPiArfQ0KPiArDQo+ICtpbnQgYnBmX3NrX3N0b3JhZ2VfY2xvbmUoY29uc3Qgc3RydWN0
IHNvY2sgKnNrLCBzdHJ1Y3Qgc29jayAqbmV3c2spDQo+ICt7DQo+ICsJc3RydWN0IGJwZl9za19z
dG9yYWdlICpuZXdfc2tfc3RvcmFnZSA9IE5VTEw7DQo+ICsJc3RydWN0IGJwZl9za19zdG9yYWdl
ICpza19zdG9yYWdlOw0KPiArCXN0cnVjdCBicGZfc2tfc3RvcmFnZV9lbGVtICpzZWxlbTsNCj4g
KwlpbnQgcmV0Ow0KPiArDQo+ICsJUkNVX0lOSVRfUE9JTlRFUihuZXdzay0+c2tfYnBmX3N0b3Jh
Z2UsIE5VTEwpOw0KPiArDQo+ICsJcmN1X3JlYWRfbG9jaygpOw0KPiArCXNrX3N0b3JhZ2UgPSBy
Y3VfZGVyZWZlcmVuY2Uoc2stPnNrX2JwZl9zdG9yYWdlKTsNCj4gKw0KPiArCWlmICghc2tfc3Rv
cmFnZSB8fCBobGlzdF9lbXB0eSgmc2tfc3RvcmFnZS0+bGlzdCkpDQo+ICsJCWdvdG8gb3V0Ow0K
PiArDQo+ICsJaGxpc3RfZm9yX2VhY2hfZW50cnlfcmN1KHNlbGVtLCAmc2tfc3RvcmFnZS0+bGlz
dCwgc25vZGUpIHsNCj4gKwkJc3RydWN0IGJwZl9za19zdG9yYWdlX21hcCAqc21hcDsNCj4gKwkJ
c3RydWN0IGJwZl9za19zdG9yYWdlX2VsZW0gKmNvcHlfc2VsZW07DQo+ICsNCj4gKwkJaWYgKCFz
ZWxlbS0+Y2xvbmUpDQo+ICsJCQljb250aW51ZTsNCj4gKw0KPiArCQlzbWFwID0gcmN1X2RlcmVm
ZXJlbmNlKFNEQVRBKHNlbGVtKS0+c21hcCk7DQo+ICsJCWlmICghc21hcCkNCj4gKwkJCWNvbnRp
bnVlOw0KPiArDQo+ICsJCWNvcHlfc2VsZW0gPSBicGZfc2tfc3RvcmFnZV9jbG9uZV9lbGVtKG5l
d3NrLCBzbWFwLCBzZWxlbSk7DQo+ICsJCWlmIChJU19FUlIoY29weV9zZWxlbSkpIHsNCj4gKwkJ
CXJldCA9IFBUUl9FUlIoY29weV9zZWxlbSk7DQo+ICsJCQlnb3RvIGVycjsNCj4gKwkJfQ0KPiAr
DQo+ICsJCWlmICghbmV3X3NrX3N0b3JhZ2UpIHsNCj4gKwkJCXJldCA9IHNrX3N0b3JhZ2VfYWxs
b2MobmV3c2ssIHNtYXAsIGNvcHlfc2VsZW0pOw0KPiArCQkJaWYgKHJldCkgew0KPiArCQkJCWtm
cmVlKGNvcHlfc2VsZW0pOw0KPiArCQkJCWF0b21pY19zdWIoc21hcC0+ZWxlbV9zaXplLA0KPiAr
CQkJCQkgICAmbmV3c2stPnNrX29tZW1fYWxsb2MpOw0KPiArCQkJCWdvdG8gZXJyOw0KPiArCQkJ
fQ0KPiArDQo+ICsJCQluZXdfc2tfc3RvcmFnZSA9IHJjdV9kZXJlZmVyZW5jZShjb3B5X3NlbGVt
LT5za19zdG9yYWdlKTsNCj4gKwkJCWNvbnRpbnVlOw0KPiArCQl9DQo+ICsNCj4gKwkJcmF3X3Nw
aW5fbG9ja19iaCgmbmV3X3NrX3N0b3JhZ2UtPmxvY2spOw0KPiArCQlzZWxlbV9saW5rX21hcChz
bWFwLCBjb3B5X3NlbGVtKTsNCj4gKwkJX19zZWxlbV9saW5rX3NrKG5ld19za19zdG9yYWdlLCBj
b3B5X3NlbGVtKTsNCj4gKwkJcmF3X3NwaW5fdW5sb2NrX2JoKCZuZXdfc2tfc3RvcmFnZS0+bG9j
ayk7DQoNCkNvbnNpZGVyaW5nIGluIHRoaXMgcGFydGljdWxhciBjYXNlLCBuZXcgc29ja2V0IGlz
IG5vdCB2aXNpYmxlIHRvIA0Kb3V0c2lkZSB3b3JsZCB5ZXQgKGJvdGgga2VybmVsIGFuZCB1c2Vy
IHNwYWNlKSwgbWFwX2RlbGV0ZS9tYXBfdXBkYXRlDQpvcGVyYXRpb25zIGFyZSBub3QgYXBwbGlj
YWJsZSBpbiB0aGlzIHNpdHVhdGlvbiwgc28NCnRoZSBhYm92ZSByYXdfc3Bpbl9sb2NrX2JoKCkg
cHJvYmFibHkgbm90IG5lZWRlZC4NCg0KDQo+ICsJfQ0KPiArDQo+ICtvdXQ6DQo+ICsJcmN1X3Jl
YWRfdW5sb2NrKCk7DQo+ICsJcmV0dXJuIDA7DQo+ICsNCj4gK2VycjoNCj4gKwlyY3VfcmVhZF91
bmxvY2soKTsNCj4gKw0KPiArCWJwZl9za19zdG9yYWdlX2ZyZWUobmV3c2spOw0KPiArCXJldHVy
biByZXQ7DQo+ICt9DQo+ICsNCj4gICBCUEZfQ0FMTF80KGJwZl9za19zdG9yYWdlX2dldCwgc3Ry
dWN0IGJwZl9tYXAgKiwgbWFwLCBzdHJ1Y3Qgc29jayAqLCBzaywNCj4gICAJICAgdm9pZCAqLCB2
YWx1ZSwgdTY0LCBmbGFncykNCj4gICB7DQo+ICAgCXN0cnVjdCBicGZfc2tfc3RvcmFnZV9kYXRh
ICpzZGF0YTsNCj4gICANCj4gLQlpZiAoZmxhZ3MgPiBCUEZfU0tfU1RPUkFHRV9HRVRfRl9DUkVB
VEUpDQo+ICsJaWYgKGZsYWdzICYgfkJQRl9TS19TVE9SQUdFX0dFVF9GX01BU0spDQo+ICsJCXJl
dHVybiAodW5zaWduZWQgbG9uZylOVUxMOw0KPiArDQo+ICsJaWYgKChmbGFncyAmIEJQRl9TS19T
VE9SQUdFX0dFVF9GX0NMT05FKSAmJg0KPiArCSAgICAhKGZsYWdzICYgQlBGX1NLX1NUT1JBR0Vf
R0VUX0ZfQ1JFQVRFKSkNCj4gICAJCXJldHVybiAodW5zaWduZWQgbG9uZylOVUxMOw0KPiAgIA0K
PiAgIAlzZGF0YSA9IHNrX3N0b3JhZ2VfbG9va3VwKHNrLCBtYXAsIHRydWUpOw0KPiAgIAlpZiAo
c2RhdGEpDQo+ICAgCQlyZXR1cm4gKHVuc2lnbmVkIGxvbmcpc2RhdGEtPmRhdGE7DQo+ICAgDQo+
IC0JaWYgKGZsYWdzID09IEJQRl9TS19TVE9SQUdFX0dFVF9GX0NSRUFURSAmJg0KPiArCWlmICgo
ZmxhZ3MgJiBCUEZfU0tfU1RPUkFHRV9HRVRfRl9DUkVBVEUpICYmDQo+ICAgCSAgICAvKiBDYW5u
b3QgYWRkIG5ldyBlbGVtIHRvIGEgZ29pbmcgYXdheSBzay4NCj4gICAJICAgICAqIE90aGVyd2lz
ZSwgdGhlIG5ldyBlbGVtIG1heSBiZWNvbWUgYSBsZWFrDQo+ICAgCSAgICAgKiAoYW5kIGFsc28g
b3RoZXIgbWVtb3J5IGlzc3VlcyBkdXJpbmcgbWFwDQo+IEBAIC03NjIsNiArODUzLDkgQEAgQlBG
X0NBTExfNChicGZfc2tfc3RvcmFnZV9nZXQsIHN0cnVjdCBicGZfbWFwICosIG1hcCwgc3RydWN0
IHNvY2sgKiwgc2ssDQo+ICAgCQkvKiBzayBtdXN0IGJlIGEgZnVsbHNvY2sgKGd1YXJhbnRlZWQg
YnkgdmVyaWZpZXIpLA0KPiAgIAkJICogc28gc29ja19nZW5fcHV0KCkgaXMgdW5uZWNlc3Nhcnku
DQo+ICAgCQkgKi8NCj4gKwkJaWYgKCFJU19FUlIoc2RhdGEpKQ0KPiArCQkJU0VMRU0oc2RhdGEp
LT5jbG9uZSA9DQo+ICsJCQkJISEoZmxhZ3MgJiBCUEZfU0tfU1RPUkFHRV9HRVRfRl9DTE9ORSk7
DQo+ICAgCQlzb2NrX3B1dChzayk7DQo+ICAgCQlyZXR1cm4gSVNfRVJSKHNkYXRhKSA/DQo+ICAg
CQkJKHVuc2lnbmVkIGxvbmcpTlVMTCA6ICh1bnNpZ25lZCBsb25nKXNkYXRhLT5kYXRhOw0KPiBk
aWZmIC0tZ2l0IGEvbmV0L2NvcmUvc29jay5jIGIvbmV0L2NvcmUvc29jay5jDQo+IGluZGV4IGQ1
N2IwY2M5OTVhMC4uZjVlODAxYTljZWE0IDEwMDY0NA0KPiAtLS0gYS9uZXQvY29yZS9zb2NrLmMN
Cj4gKysrIGIvbmV0L2NvcmUvc29jay5jDQo+IEBAIC0xODUxLDkgKzE4NTEsMTIgQEAgc3RydWN0
IHNvY2sgKnNrX2Nsb25lX2xvY2soY29uc3Qgc3RydWN0IHNvY2sgKnNrLCBjb25zdCBnZnBfdCBw
cmlvcml0eSkNCj4gICAJCQlnb3RvIG91dDsNCj4gICAJCX0NCj4gICAJCVJDVV9JTklUX1BPSU5U
RVIobmV3c2stPnNrX3JldXNlcG9ydF9jYiwgTlVMTCk7DQo+IC0jaWZkZWYgQ09ORklHX0JQRl9T
WVNDQUxMDQo+IC0JCVJDVV9JTklUX1BPSU5URVIobmV3c2stPnNrX2JwZl9zdG9yYWdlLCBOVUxM
KTsNCj4gLSNlbmRpZg0KPiArDQo+ICsJCWlmIChicGZfc2tfc3RvcmFnZV9jbG9uZShzaywgbmV3
c2spKSB7DQo+ICsJCQlza19mcmVlX3VubG9ja19jbG9uZShuZXdzayk7DQo+ICsJCQluZXdzayA9
IE5VTEw7DQo+ICsJCQlnb3RvIG91dDsNCj4gKwkJfQ0KPiAgIA0KPiAgIAkJbmV3c2stPnNrX2Vy
cgkgICA9IDA7DQo+ICAgCQluZXdzay0+c2tfZXJyX3NvZnQgPSAwOw0KPiANCg==
