Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E70AD194E
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbfJIT7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:59:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43352 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729865AbfJIT7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:59:24 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x99JwSFY009851;
        Wed, 9 Oct 2019 12:58:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hc7J5BJLVg4xNit//WzMXsoM/THZKWtUIaNmsiA3mkY=;
 b=nwA4M9Pra8RUepsjIWcriifYLb9q4SzHJxpZF7N0yp/lRez6zka4WxaS8kwZ4mw92FHc
 hZkxaXw5kTX7Zxg4y/jGxhlg/CLff8l8swuubqCqovQ97Tw31kUqWyZqz+hPlkArjp3d
 rt08m6uRquCc/T1pQoUEceHJQXo1qwHty+0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhm0u8nen-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Oct 2019 12:58:30 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Oct 2019 12:58:16 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 9 Oct 2019 12:58:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LfkzSm2mKa3ywleP8gOL86rhUxS42n5Gawlbp26cPzrxpOhpte8POgyZLEkDUkdnh0QoCwghGgqXAqGsHIXfTCUgfAUiUNVGHccM5gH0hMFizBuZ+VzUM84Y6n72ScLzSTDp5k5pNxSzhqaLk+ltcIPqPVVZ+s8bmVV75HlwHfeNYyddOMaKTtMNj23tA5jy6Uy4uU252aaCkIMstXGnDaAtlUEJGK+c66Ks3B7O35wU/xSYhEE3dvM0DhjcmaGyVVYVTsMXFot6Hh2zldbLJUa4WGFhO8MqtAwZ+2Ifx1E2DKwXBiQZi27LjLCU1/7r3HLsH13oiKnjjVhTO9YUJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hc7J5BJLVg4xNit//WzMXsoM/THZKWtUIaNmsiA3mkY=;
 b=P1TKSR4Mo8jfZ/5smLeHzMrC8jLr6p54bs2Mbz0okXwopQkhelcmgOf+CBE8Tf0xCjpfuegNAqsm/u86dLpT7PLgb6iLvbr521D2xthBPAAAcHGvkflNlcWxN3q8CNu/SLDqS1n/hUEJTVFX3vRcsy0TbrtU2qV/oM3eZnmA7HEjHqXkgVcDEw3wFuMCzaIOOzupHIsFnpMPjmvFwwlkrrMf/cZW25rN2N67ISId2xZ/boGtjkQR9LuUIFYzNdssRoKjoi4w3zFHgIQA3kCRPWhk4cHrDJE89rjfaDg7iNhMS2Dfu/0hQNL25L0vE4DQhT6FcscttUqyPNIzdJ8GTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hc7J5BJLVg4xNit//WzMXsoM/THZKWtUIaNmsiA3mkY=;
 b=LSkCth84IBcw97R+VR+Q/7z7+MwKr9i1WXVgf9492kVCj/MzFUsqRhxEyjOngEA7n+egJPBrfK+8x1kzbe4VzlZ2rqtMWElzboZfaucJdqGiZvmYWtldG3g+Uepl1r1XzRvo903ODNOK5K136Jof13Spwb77dUkFSU6BA25rRw8=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3253.namprd15.prod.outlook.com (20.179.56.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Wed, 9 Oct 2019 19:58:15 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 19:58:15 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 08/10] bpf: check types of arguments passed into
 helpers
Thread-Topic: [PATCH bpf-next 08/10] bpf: check types of arguments passed into
 helpers
Thread-Index: AQHVezpRdZVOJfu5vkiiw3KVecAP5qdSoJyAgAAgsQA=
Date:   Wed, 9 Oct 2019 19:58:14 +0000
Message-ID: <e92c76b7-0cbf-750b-1252-78e1a773a379@fb.com>
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-9-ast@kernel.org>
 <CAEf4BzYpPMM=RZ=_kQqin1Aqj=RDx6T8YBJp=-sxgYq54bWhSw@mail.gmail.com>
In-Reply-To: <CAEf4BzYpPMM=RZ=_kQqin1Aqj=RDx6T8YBJp=-sxgYq54bWhSw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:102:2::32) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::cfd7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6bc94f2-56de-4ea6-31c0-08d74cf3056c
x-ms-traffictypediagnostic: BYAPR15MB3253:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB32531C2278A9B5AA96450DC7D7950@BYAPR15MB3253.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(366004)(396003)(376002)(39860400002)(199004)(189003)(8676002)(256004)(31696002)(14444005)(64756008)(99286004)(36756003)(316002)(66946007)(76176011)(81166006)(81156014)(86362001)(66476007)(66556008)(52116002)(66446008)(14454004)(305945005)(8936002)(186003)(6116002)(102836004)(53546011)(6506007)(386003)(5660300002)(25786009)(46003)(7736002)(2616005)(446003)(31686004)(486006)(476003)(71200400001)(4326008)(6246003)(2906002)(11346002)(71190400001)(6436002)(229853002)(478600001)(54906003)(6512007)(6486002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3253;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PRpmXzZARhF6lsA3HUlsYxEfBzAWATNe1fFg2j2cPnv6qxkIQKfnwT6LJZK2Y/kkMN3Z1Ec12DiKhvDb3IL2QB/xJbSAZ9qlDHz7NxfPpwg7RwK1/KcH8aQQv2/valy6qfQ5pOQFJG3Q5PGnGRNXYRH5BDwjg8B5nvgh0CVbNe6RvbsY58JOck+h9p3D1JdYiyaBr7ir900NnuEfPuFCYZbyNAEcdYKtwzcVf+mWdSBBEhS8RcN/eCD4LA6muYe76wtgtTTNmU90XKRaEI6sxzjP+FymQEAoPyKYxR+VW/pI5QmWcpOhv5lriw/SZr3Bao2RfXjS0lGYn0y1V1YotE1wqEyz4BglXR4z18isHEKo2FRj/v8U92mhs2uZtAi/0t/BU+4W0JkJRRbVZjvzaJBcbhrRQyI1BUW4vqR3fl4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CABE10B08191D6499784437A7CA56D51@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e6bc94f2-56de-4ea6-31c0-08d74cf3056c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 19:58:15.0123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ACzHT1HpIw7KkV+FV0s+9WdxHw7rbOI9CtpeXYDnDr/R3sBxkFpFWbmCIljtazc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3253
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_09:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910090158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvOS8xOSAxMTowMSBBTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBGcmksIE9j
dCA0LCAyMDE5IGF0IDEwOjA0IFBNIEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+
IHdyb3RlOg0KPj4NCj4+IEludHJvZHVjZSBuZXcgaGVscGVyIHRoYXQgcmV1c2VzIGV4aXN0aW5n
IHNrYiBwZXJmX2V2ZW50IG91dHB1dA0KPj4gaW1wbGVtZW50YXRpb24sIGJ1dCBjYW4gYmUgY2Fs
bGVkIGZyb20gcmF3X3RyYWNlcG9pbnQgcHJvZ3JhbXMNCj4+IHRoYXQgcmVjZWl2ZSAnc3RydWN0
IHNrX2J1ZmYgKicgYXMgdHJhY2Vwb2ludCBhcmd1bWVudCBvcg0KPj4gY2FuIHdhbGsgb3RoZXIg
a2VybmVsIGRhdGEgc3RydWN0dXJlcyB0byBza2IgcG9pbnRlci4NCj4+DQo+PiBJbiBvcmRlciB0
byBkbyB0aGF0IHRlYWNoIHZlcmlmaWVyIHRvIHJlc29sdmUgdHJ1ZSBDIHR5cGVzDQo+PiBvZiBi
cGYgaGVscGVycyBpbnRvIGluLWtlcm5lbCBCVEYgaWRzLg0KPj4gVGhlIHR5cGUgb2Yga2VybmVs
IHBvaW50ZXIgcGFzc2VkIGJ5IHJhdyB0cmFjZXBvaW50IGludG8gYnBmDQo+PiBwcm9ncmFtIHdp
bGwgYmUgdHJhY2tlZCBieSB0aGUgdmVyaWZpZXIgYWxsIHRoZSB3YXkgdW50aWwNCj4+IGl0J3Mg
cGFzc2VkIGludG8gaGVscGVyIGZ1bmN0aW9uLg0KPj4gRm9yIGV4YW1wbGU6DQo+PiBrZnJlZV9z
a2IoKSBrZXJuZWwgZnVuY3Rpb24gY2FsbHMgdHJhY2Vfa2ZyZWVfc2tiKHNrYiwgbG9jKTsNCj4+
IGJwZiBwcm9ncmFtcyByZWNlaXZlcyB0aGF0IHNrYiBwb2ludGVyIGFuZCBtYXkgZXZlbnR1YWxs
eQ0KPj4gcGFzcyBpdCBpbnRvIGJwZl9za2Jfb3V0cHV0KCkgYnBmIGhlbHBlciB3aGljaCBpbi1r
ZXJuZWwgaXMNCj4+IGltcGxlbWVudGVkIHZpYSBicGZfc2tiX2V2ZW50X291dHB1dCgpIGtlcm5l
bCBmdW5jdGlvbi4NCj4+IEl0cyBmaXJzdCBhcmd1bWVudCBpbiB0aGUga2VybmVsIGlzICdzdHJ1
Y3Qgc2tfYnVmZiAqJy4NCj4+IFRoZSB2ZXJpZmllciBtYWtlcyBzdXJlIHRoYXQgdHlwZXMgbWF0
Y2ggYWxsIHRoZSB3YXkuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQWxleGVpIFN0YXJvdm9pdG92
IDxhc3RAa2VybmVsLm9yZz4NCj4+IC0tLQ0KPiANCj4gbm8gcmVhbCBjb25jZXJucywgZmV3IHF1
ZXN0aW9ucyBhbmQgbml0cyBiZWxvdy4gTG9va3MgZ3JlYXQgb3RoZXJ3aXNlIQ0KPiANCj4+ICAg
aW5jbHVkZS9saW51eC9icGYuaCAgICAgICAgICAgICAgICAgICAgICAgfCAgMyArDQo+PiAgIGlu
Y2x1ZGUvdWFwaS9saW51eC9icGYuaCAgICAgICAgICAgICAgICAgIHwgIDMgKy0NCj4+ICAga2Vy
bmVsL2JwZi9idGYuYyAgICAgICAgICAgICAgICAgICAgICAgICAgfCA3MyArKysrKysrKysrKysr
KysrKysrKysrKw0KPj4gICBrZXJuZWwvYnBmL3ZlcmlmaWVyLmMgICAgICAgICAgICAgICAgICAg
ICB8IDI5ICsrKysrKysrKw0KPj4gICBrZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMgICAgICAgICAg
ICAgICAgICB8ICA0ICsrDQo+PiAgIG5ldC9jb3JlL2ZpbHRlci5jICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgMTUgKysrKy0NCj4+ICAgdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oICAg
ICAgICAgICAgfCAgMyArLQ0KPj4gICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvYnBmX2hl
bHBlcnMuaCB8ICA0ICsrDQo+PiAgIDggZmlsZXMgY2hhbmdlZCwgMTMxIGluc2VydGlvbnMoKyks
IDMgZGVsZXRpb25zKC0pDQo+Pg0KPiANCj4gWy4uLl0NCj4gDQo+PiArICAgICAgIGFyZ3MgPSAo
Y29uc3Qgc3RydWN0IGJ0Zl9wYXJhbSAqKSh0ICsgMSk7DQo+PiArICAgICAgIGlmIChhcmcgPj0g
YnRmX3R5cGVfdmxlbih0KSkgew0KPj4gKyAgICAgICAgICAgICAgIGJwZl92ZXJpZmllcl9sb2df
d3JpdGUoZW52LA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgImJw
ZiBoZWxwZXIgJyVzJyBkb2Vzbid0IGhhdmUgJWQtdGggYXJndW1lbnRcbiIsDQo+PiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmbm5hbWUsIGFyZyk7DQo+PiArICAgICAg
ICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+PiArICAgICAgIH0NCj4+ICsNCj4+ICsgICAgICAg
dCA9IGJ0Zl90eXBlX2J5X2lkKGJ0Zl92bWxpbnV4LCBhcmdzW2FyZ10udHlwZSk7DQo+PiArICAg
ICAgIGlmICghYnRmX3R5cGVfaXNfcHRyKHQpIHx8ICF0LT50eXBlKSB7DQo+PiArICAgICAgICAg
ICAgICAgLyogYW55dGhpbmcgYnV0IHRoZSBwb2ludGVyIHRvIHN0cnVjdCBpcyBhIGhlbHBlciBj
b25maWcgYnVnICovDQo+PiArICAgICAgICAgICAgICAgYnBmX3ZlcmlmaWVyX2xvZ193cml0ZShl
bnYsDQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiQVJHX1BUUl9U
T19CVEYgaXMgbWlzY29uZmlndXJlZFxuIik7DQo+PiArDQo+PiArICAgICAgICAgICAgICAgcmV0
dXJuIC1FRkFVTFQ7DQo+PiArICAgICAgIH0NCj4+ICsgICAgICAgYnRmX2lkID0gdC0+dHlwZTsN
Cj4+ICsNCj4+ICsgICAgICAgdCA9IGJ0Zl90eXBlX2J5X2lkKGJ0Zl92bWxpbnV4LCB0LT50eXBl
KTsNCj4+ICsgICAgICAgaWYgKCFidGZfdHlwZV9pc19zdHJ1Y3QodCkpIHsNCj4gDQo+IHJlc29s
dmUgbW9kcy90eXBlZGVmcz8NCg0KZml4ZWQNCg0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAg
dmVyYm9zZShlbnYsICJIZWxwZXIgaGFzIHR5cGUgJXMgZ290ICVzIGluIFIlZFxuIiwNCj4+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYnRmX25hbWVfYnlfb2Zmc2V0KGJ0Zl92bWxp
bnV4LA0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgYnRmX3R5cGVfYnlfaWQoYnRmX3ZtbGludXgsDQo+PiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtZXRhLT5idGZfaWQp
LT5uYW1lX29mZiksDQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJ0Zl9uYW1l
X2J5X29mZnNldChidGZfdm1saW51eCwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGJ0Zl90eXBlX2J5X2lkKGJ0Zl92bWxpbnV4LA0KPj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgcmVnLT5idGZfaWQpLT5uYW1lX29mZiksDQo+IA0KPiBUaGlzIGlzIHJhdGhlciB2ZXJi
b3NlLCBidXQgcG9wdWxhciwgY29uc3RydWN0LCBtYXliZSBleHRyYWN0IGludG8gYQ0KPiBoZWxw
ZXIgZnVuYyBhbmQgY3V0IG9uIGNvZGUgYm9pbGVycGxhdGU/IEkgdGhpbmsgeW91IGhhZCBzaW1p
bGFyIHVzYWdlDQo+IGluIGZldyBwbGFjZXMgaW4gcHJldmlvdXMgcGF0Y2hlcy4NCg0KbWFrZXMg
c2Vuc2UuDQoNCj4+ICsgICAgICAgaWYgKGZuLT5hcmcxX3R5cGUgPT0gQVJHX1BUUl9UT19CVEZf
SUQpIHsNCj4+ICsgICAgICAgICAgICAgICBpZiAoIWZuLT5idGZfaWRbMF0pDQo+PiArICAgICAg
ICAgICAgICAgICAgICAgICBmbi0+YnRmX2lkWzBdID0gYnRmX3Jlc29sdmVfaGVscGVyX2lkKGVu
diwgZm4tPmZ1bmMsIDApOw0KPj4gKyAgICAgICAgICAgICAgIG1ldGEuYnRmX2lkID0gZm4tPmJ0
Zl9pZFswXTsNCj4+ICsgICAgICAgfQ0KPiANCj4gSXMgdGhpcyB0aGlzIGJhYnktc3RlcHBpbmcg
dGhpbmcgdGhhdCB3ZSBkbyBpdCBvbmx5IGZvciBhcmcxPyBBbnkNCj4gY29tcGxpY2F0aW9ucyBm
cm9tIGRvaW5nIGEgbG9vcCBvdmVyIGFsbCA1IHBhcmFtcz8NCg0KZml4ZWQNCg==
