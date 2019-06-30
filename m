Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B885AEC6
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfF3GCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:02:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58418 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbfF3GCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:02:00 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5U5wb1H025613;
        Sat, 29 Jun 2019 23:01:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wRQpzaVHvonSpfgQA8oR3TxvBPtXlnP2nLvbAwlkw2U=;
 b=MU4rBWk4rkE0nAlJV8sieR3DRIxGEfPgIWFVFJ5VfcwVIyxmnFSok56Z0mXyw/Q6IPcI
 dy3+N9mxc90dbmjS/LSmQKMXop3QsZf8ppJm+r/QodAoXgQFDBz85RbCWo3mLjjSK5nJ
 vyWJur+Zy3sEJYv3Dz7AoSaU4eIUsMyJMjA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2te79jsyn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 29 Jun 2019 23:01:33 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 29 Jun 2019 23:01:32 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 29 Jun 2019 23:01:32 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 29 Jun 2019 23:01:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRQpzaVHvonSpfgQA8oR3TxvBPtXlnP2nLvbAwlkw2U=;
 b=YpB9/j5/QE2WT1xVocIslmK34LVPRicrwYnXGGRZrhM7RcuTLTLgM+Zsa3Merf2wtHo3XX2ZtflX8ZmMI/QYQLYWm1Bs4Nyn03fubXNKXK5WIND+UyXGAShWmh14QCgrZHVOmVmQhcHdYOSiX4t59gRk5X40jIZRJNUX4sdu0Ac=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3046.namprd15.prod.outlook.com (20.178.238.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.17; Sun, 30 Jun 2019 06:01:22 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Sun, 30 Jun 2019
 06:01:22 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andriin@fb.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: add verifier tests for wide
 stores
Thread-Topic: [PATCH bpf-next 2/2] selftests/bpf: add verifier tests for wide
 stores
Thread-Index: AQHVLgbQLmRbW4kp/kqaAjOppXNtXqaztmkA
Date:   Sun, 30 Jun 2019 06:01:22 +0000
Message-ID: <8e469767-a108-ba42-f8c8-6fd505393699@fb.com>
References: <20190628231049.22149-1-sdf@google.com>
 <20190628231049.22149-2-sdf@google.com>
In-Reply-To: <20190628231049.22149-2-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:300:c0::21) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:13d0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c9c2148-b326-46d3-2e12-08d6fd20605f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3046;
x-ms-traffictypediagnostic: BYAPR15MB3046:
x-microsoft-antispam-prvs: <BYAPR15MB304640C6F79CAE6D3781DDD0D3FE0@BYAPR15MB3046.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:480;
x-forefront-prvs: 008421A8FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(366004)(376002)(136003)(189003)(199004)(8676002)(5660300002)(6512007)(4326008)(186003)(53936002)(229853002)(99286004)(446003)(36756003)(71190400001)(54906003)(8936002)(110136005)(6116002)(6436002)(2501003)(6486002)(25786009)(5024004)(2201001)(256004)(6246003)(66946007)(478600001)(486006)(66476007)(66556008)(64756008)(66446008)(31696002)(52116002)(316002)(73956011)(86362001)(14454004)(68736007)(31686004)(2616005)(2906002)(305945005)(53546011)(7736002)(6506007)(386003)(81166006)(81156014)(76176011)(71200400001)(14444005)(476003)(46003)(102836004)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3046;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xPYjC8mMi16f/bA17eRGt7h5m66zs9JwR5EzhiZg0HeX/XMLgKNKUFatvtgBM3162IlK8LX3CCZjrB0UDnFiX6tR6o7hanllhragTFpGzb+f+lXgNqwJVq6R0fdNWl2IJpUi+ivhDatmo3ozh9ncrzPrsx4cDVwyo+3wjYt0HQ8CwpeiCMqT/DXo01jiCKtAklhJ+AnJ0OiNmk8tCkv/aGPs2YFk+4EEq3s6A31C7muIoVc+6UMPHYG+Vqsb6BkFkN/43KI5g5Nn0nUAsYQlhX2Bk6HYpMkwQhidlx/ZFD66m1587O4X8innmW66EORBEJaXZWnp4FllFJkh9QQrqyoF2o6MEbwS15q4phnHR5gsp8qHLQtyRdOvx7b/xo6aSxOlGB/1oKrDjhLX0vNUeeSqbCmvY2nDGfr1a+NUrPU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB2EEAC68D8F1142A1C3CE5AFB2DFB38@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c9c2148-b326-46d3-2e12-08d6fd20605f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2019 06:01:22.1682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3046
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-30_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906300077
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMjgvMTkgNDoxMCBQTSwgU3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPiBNYWtl
IHN1cmUgdGhhdCB3aWRlIHN0b3JlcyBhcmUgYWxsb3dlZCBhdCBwcm9wZXIgKGFsaWduZWQpIGFk
ZHJlc3Nlcy4NCj4gTm90ZSB0aGF0IHVzZXJfaXA2IGlzIG5hdHVyYWxseSBhbGlnbmVkIG9uIDgt
Ynl0ZSBib3VuZGFyeSwgc28NCj4gY29ycmVjdCBhZGRyZXNzZXMgYXJlIHVzZXJfaXA2WzBdIGFu
ZCB1c2VyX2lwNlsyXS4gbXNnX3NyY19pcDYgaXMsDQo+IGhvd2V2ZXIsIGFsaWduZWQgb24gYSA0
LWJ5dGUgYm9uZGFyeSwgc28gb25seSBtc2dfc3JjX2lwNlsxXQ0KPiBjYW4gYmUgd2lkZS1zdG9y
ZWQuDQo+IA0KPiBDYzogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4gQ2M6IFlv
bmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFN0YW5pc2xhdiBGb21p
Y2hldiA8c2RmQGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAgIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi90ZXN0X3ZlcmlmaWVyLmMgICB8IDE3ICsrKysrKy0tDQo+ICAgLi4uL3NlbGZ0ZXN0cy9i
cGYvdmVyaWZpZXIvd2lkZV9zdG9yZS5jICAgICAgIHwgNDAgKysrKysrKysrKysrKysrKysrKw0K
PiAgIDIgZmlsZXMgY2hhbmdlZCwgNTQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4g
ICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3ZlcmlmaWVy
L3dpZGVfc3RvcmUuYw0KPiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi90ZXN0X3ZlcmlmaWVyLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF92
ZXJpZmllci5jDQo+IGluZGV4IGM1NTE0ZGFmODg2NS4uYjA3NzMyOTEwMTJhIDEwMDY0NA0KPiAt
LS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF92ZXJpZmllci5jDQo+ICsrKyBi
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3ZlcmlmaWVyLmMNCj4gQEAgLTEwNSw2
ICsxMDUsNyBAQCBzdHJ1Y3QgYnBmX3Rlc3Qgew0KPiAgIAkJCV9fdTY0IGRhdGE2NFtURVNUX0RB
VEFfTEVOIC8gOF07DQo+ICAgCQl9Ow0KPiAgIAl9IHJldHZhbHNbTUFYX1RFU1RfUlVOU107DQo+
ICsJZW51bSBicGZfYXR0YWNoX3R5cGUgZXhwZWN0ZWRfYXR0YWNoX3R5cGU7DQo+ICAgfTsNCj4g
ICANCj4gICAvKiBOb3RlIHdlIHdhbnQgdGhpcyB0byBiZSA2NCBiaXQgYWxpZ25lZCBzbyB0aGF0
IHRoZSBlbmQgb2Ygb3VyIGFycmF5IGlzDQo+IEBAIC04NTAsNiArODUxLDcgQEAgc3RhdGljIHZv
aWQgZG9fdGVzdF9zaW5nbGUoc3RydWN0IGJwZl90ZXN0ICp0ZXN0LCBib29sIHVucHJpdiwNCj4g
ICAJaW50IGZkX3Byb2csIGV4cGVjdGVkX3JldCwgYWxpZ25tZW50X3ByZXZlbnRlZF9leGVjdXRp
b247DQo+ICAgCWludCBwcm9nX2xlbiwgcHJvZ190eXBlID0gdGVzdC0+cHJvZ190eXBlOw0KPiAg
IAlzdHJ1Y3QgYnBmX2luc24gKnByb2cgPSB0ZXN0LT5pbnNuczsNCj4gKwlzdHJ1Y3QgYnBmX2xv
YWRfcHJvZ3JhbV9hdHRyIGF0dHI7DQo+ICAgCWludCBydW5fZXJycywgcnVuX3N1Y2Nlc3NlczsN
Cj4gICAJaW50IG1hcF9mZHNbTUFYX05SX01BUFNdOw0KPiAgIAljb25zdCBjaGFyICpleHBlY3Rl
ZF9lcnI7DQo+IEBAIC04ODEsOCArODgzLDE3IEBAIHN0YXRpYyB2b2lkIGRvX3Rlc3Rfc2luZ2xl
KHN0cnVjdCBicGZfdGVzdCAqdGVzdCwgYm9vbCB1bnByaXYsDQo+ICAgCQlwZmxhZ3MgfD0gQlBG
X0ZfU1RSSUNUX0FMSUdOTUVOVDsNCj4gICAJaWYgKHRlc3QtPmZsYWdzICYgRl9ORUVEU19FRkZJ
Q0lFTlRfVU5BTElHTkVEX0FDQ0VTUykNCj4gICAJCXBmbGFncyB8PSBCUEZfRl9BTllfQUxJR05N
RU5UOw0KPiAtCWZkX3Byb2cgPSBicGZfdmVyaWZ5X3Byb2dyYW0ocHJvZ190eXBlLCBwcm9nLCBw
cm9nX2xlbiwgcGZsYWdzLA0KPiAtCQkJCSAgICAgIkdQTCIsIDAsIGJwZl92bG9nLCBzaXplb2Yo
YnBmX3Zsb2cpLCA0KTsNCj4gKw0KPiArCW1lbXNldCgmYXR0ciwgMCwgc2l6ZW9mKGF0dHIpKTsN
Cj4gKwlhdHRyLnByb2dfdHlwZSA9IHByb2dfdHlwZTsNCj4gKwlhdHRyLmV4cGVjdGVkX2F0dGFj
aF90eXBlID0gdGVzdC0+ZXhwZWN0ZWRfYXR0YWNoX3R5cGU7DQo+ICsJYXR0ci5pbnNucyA9IHBy
b2c7DQo+ICsJYXR0ci5pbnNuc19jbnQgPSBwcm9nX2xlbjsNCj4gKwlhdHRyLmxpY2Vuc2UgPSAi
R1BMIjsNCj4gKwlhdHRyLmxvZ19sZXZlbCA9IDQ7DQo+ICsJYXR0ci5wcm9nX2ZsYWdzID0gcGZs
YWdzOw0KPiArDQo+ICsJZmRfcHJvZyA9IGJwZl9sb2FkX3Byb2dyYW1feGF0dHIoJmF0dHIsIGJw
Zl92bG9nLCBzaXplb2YoYnBmX3Zsb2cpKTsNCj4gICAJaWYgKGZkX3Byb2cgPCAwICYmICFicGZf
cHJvYmVfcHJvZ190eXBlKHByb2dfdHlwZSwgMCkpIHsNCj4gICAJCXByaW50ZigiU0tJUCAodW5z
dXBwb3J0ZWQgcHJvZ3JhbSB0eXBlICVkKVxuIiwgcHJvZ190eXBlKTsNCj4gICAJCXNraXBzKys7
DQo+IEBAIC05MTIsNyArOTIzLDcgQEAgc3RhdGljIHZvaWQgZG9fdGVzdF9zaW5nbGUoc3RydWN0
IGJwZl90ZXN0ICp0ZXN0LCBib29sIHVucHJpdiwNCj4gICAJCQlwcmludGYoIkZBSUxcblVuZXhw
ZWN0ZWQgc3VjY2VzcyB0byBsb2FkIVxuIik7DQo+ICAgCQkJZ290byBmYWlsX2xvZzsNCj4gICAJ
CX0NCj4gLQkJaWYgKCFzdHJzdHIoYnBmX3Zsb2csIGV4cGVjdGVkX2VycikpIHsNCj4gKwkJaWYg
KCFleHBlY3RlZF9lcnIgfHwgIXN0cnN0cihicGZfdmxvZywgZXhwZWN0ZWRfZXJyKSkgew0KPiAg
IAkJCXByaW50ZigiRkFJTFxuVW5leHBlY3RlZCBlcnJvciBtZXNzYWdlIVxuXHRFWFA6ICVzXG5c
dFJFUzogJXNcbiIsDQo+ICAgCQkJICAgICAgZXhwZWN0ZWRfZXJyLCBicGZfdmxvZyk7DQo+ICAg
CQkJZ290byBmYWlsX2xvZzsNCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi92ZXJpZmllci93aWRlX3N0b3JlLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYv
dmVyaWZpZXIvd2lkZV9zdG9yZS5jDQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAw
MDAwMDAwMDAwMC4uYzYzODVmNDViMTE0DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvYnBmL3ZlcmlmaWVyL3dpZGVfc3RvcmUuYw0KPiBAQCAtMCwwICsx
LDQwIEBADQo+ICsjZGVmaW5lIEJQRl9TT0NLX0FERFIoZmllbGQsIG9mZiwgcmVzLCBlcnIpIFwN
Cj4gK3sgXA0KPiArCSJ3aWRlIHN0b3JlIHRvIGJwZl9zb2NrX2FkZHIuIiAjZmllbGQgIlsiICNv
ZmYgIl0iLCBcDQo+ICsJLmluc25zID0geyBcDQo+ICsJQlBGX01PVjY0X0lNTShCUEZfUkVHXzAs
IDEpLCBcDQo+ICsJQlBGX1NUWF9NRU0oQlBGX0RXLCBCUEZfUkVHXzEsIEJQRl9SRUdfMCwgXA0K
PiArCQkgICAgb2Zmc2V0b2Yoc3RydWN0IGJwZl9zb2NrX2FkZHIsIGZpZWxkW29mZl0pKSwgXA0K
PiArCUJQRl9FWElUX0lOU04oKSwgXA0KPiArCX0sIFwNCj4gKwkucmVzdWx0ID0gcmVzLCBcDQo+
ICsJLnByb2dfdHlwZSA9IEJQRl9QUk9HX1RZUEVfQ0dST1VQX1NPQ0tfQUREUiwgXA0KPiArCS5l
eHBlY3RlZF9hdHRhY2hfdHlwZSA9IEJQRl9DR1JPVVBfVURQNl9TRU5ETVNHLCBcDQo+ICsJLmVy
cnN0ciA9IGVyciwgXA0KPiArfQ0KPiArDQo+ICsvKiB1c2VyX2lwNlswXSBpcyB1NjQgYWxpZ25l
ZCAqLw0KPiArQlBGX1NPQ0tfQUREUih1c2VyX2lwNiwgMCwgQUNDRVBULA0KPiArCSAgICAgIE5V
TEwpLA0KPiArQlBGX1NPQ0tfQUREUih1c2VyX2lwNiwgMSwgUkVKRUNULA0KPiArCSAgICAgICJp
bnZhbGlkIGJwZl9jb250ZXh0IGFjY2VzcyBvZmY9MTIgc2l6ZT04IiksDQo+ICtCUEZfU09DS19B
RERSKHVzZXJfaXA2LCAyLCBBQ0NFUFQsDQo+ICsJICAgICAgTlVMTCksDQo+ICtCUEZfU09DS19B
RERSKHVzZXJfaXA2LCAzLCBSRUpFQ1QsDQo+ICsJICAgICAgImludmFsaWQgYnBmX2NvbnRleHQg
YWNjZXNzIG9mZj0yMCBzaXplPTgiKSwNCj4gK0JQRl9TT0NLX0FERFIodXNlcl9pcDYsIDQsIFJF
SkVDVCwNCj4gKwkgICAgICAiaW52YWxpZCBicGZfY29udGV4dCBhY2Nlc3Mgb2ZmPTI0IHNpemU9
OCIpLA0KDQpXaXRoIG9mZnNldCA0LCB3ZSBoYXZlDQojOTY4L3Agd2lkZSBzdG9yZSB0byBicGZf
c29ja19hZGRyLnVzZXJfaXA2WzRdIE9LDQoNClRoaXMgdGVzdCBjYXNlIGNhbiBiZSByZW1vdmVk
LiB1c2VyIGNvZGUgdHlwaWNhbGx5DQp3b24ndCB3cml0ZSBicGZfc29ja19hZGRyLnVzZXJfaXA2
WzRdLCBhbmQgY29tcGlsZXINCnR5cGljYWxseSB3aWxsIGdpdmUgYSB3YXJuaW5nIHNpbmNlIGl0
IGlzIG91dCBvZg0KYXJyYXkgYm91bmQuIEFueSBwYXJ0aWN1bGFyIHJlYXNvbiB5b3Ugd2FudCB0
bw0KaW5jbHVkZSB0aGlzIG9uZT8NCg0KDQo+ICsNCj4gKy8qIG1zZ19zcmNfaXA2WzBdIGlzIF9u
b3RfIHU2NCBhbGlnbmVkICovDQo+ICtCUEZfU09DS19BRERSKG1zZ19zcmNfaXA2LCAwLCBSRUpF
Q1QsDQo+ICsJICAgICAgImludmFsaWQgYnBmX2NvbnRleHQgYWNjZXNzIG9mZj00NCBzaXplPTgi
KSwNCj4gK0JQRl9TT0NLX0FERFIobXNnX3NyY19pcDYsIDEsIEFDQ0VQVCwNCj4gKwkgICAgICBO
VUxMKSwNCj4gK0JQRl9TT0NLX0FERFIobXNnX3NyY19pcDYsIDIsIFJFSkVDVCwNCj4gKwkgICAg
ICAiaW52YWxpZCBicGZfY29udGV4dCBhY2Nlc3Mgb2ZmPTUyIHNpemU9OCIpLA0KPiArQlBGX1NP
Q0tfQUREUihtc2dfc3JjX2lwNiwgMywgUkVKRUNULA0KPiArCSAgICAgICJpbnZhbGlkIGJwZl9j
b250ZXh0IGFjY2VzcyBvZmY9NTYgc2l6ZT04IiksDQo+ICtCUEZfU09DS19BRERSKG1zZ19zcmNf
aXA2LCA0LCBSRUpFQ1QsDQo+ICsJICAgICAgImludmFsaWQgYnBmX2NvbnRleHQgYWNjZXNzIG9m
Zj02MCBzaXplPTgiKSwNCg0KVGhlIHNhbWUgYXMgYWJvdmUsIG9mZnNldD00IGNhc2UgY2FuIGJl
IHJlbW92ZWQ/DQoNCj4gKw0KPiArI3VuZGVmIEJQRl9TT0NLX0FERFINCj4gDQo=
