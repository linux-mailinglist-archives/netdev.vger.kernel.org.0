Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2355C657
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 02:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfGBAgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 20:36:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23042 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726678AbfGBAgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 20:36:32 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x620TgqS027642;
        Mon, 1 Jul 2019 17:36:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=MxuQDGLar3lEkiJniyi4tR7wMuhAOJCRJA6Oc11diyU=;
 b=WiPxjo0Y7MLm6ehJD2XGFf02rDKk9BWl0lCDegis1AYzO/FahnDv3sSVVXBz1QMHyW9r
 7ADYaZMH1g1Yp+BdZYsjfmsQeQIDeyahodpY5z9bXyoAjiAOvXY+I/qU2pqBaslA+lUz
 u3Ks8FPKH5g1FfJErJS8yfJ78+tCqkk9h2E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tfns49jsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Jul 2019 17:36:12 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 1 Jul 2019 17:36:11 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 17:36:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MxuQDGLar3lEkiJniyi4tR7wMuhAOJCRJA6Oc11diyU=;
 b=hheo/DY7UGhSHbr3FBWA8luebxLFuGTYGCSTcPME+B4gegFMfnzgN2DEuB14vuwREJxju6uXJIN6850O/a8O0zjaRhW+VQ8Ys1+gVZH0TCcbzSQUNy4NqqK1TVTgnebpobkj/0V43qND2KbwI8B1mOtv34PvAAhBJJCsJ3O+IXI=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3159.namprd15.prod.outlook.com (20.178.207.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 00:36:09 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 00:36:09 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v5 bpf-next 0/9] libbpf: add bpf_link and tracing attach
 APIs
Thread-Topic: [PATCH v5 bpf-next 0/9] libbpf: add bpf_link and tracing attach
 APIs
Thread-Index: AQHVMGkObzHJIo0eEECT0SFQdyxRGaa2e3IA
Date:   Tue, 2 Jul 2019 00:36:09 +0000
Message-ID: <fb734118-a051-c3de-560d-42f0fcc79cdd@fb.com>
References: <20190701235903.660141-1-andriin@fb.com>
In-Reply-To: <20190701235903.660141-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0141.namprd04.prod.outlook.com (2603:10b6:104::19)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 410f01f1-48ae-4add-9224-08d6fe8546de
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3159;
x-ms-traffictypediagnostic: BYAPR15MB3159:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR15MB315982A3C4598FD0642C4C36D3F80@BYAPR15MB3159.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(346002)(376002)(136003)(396003)(199004)(189003)(256004)(31696002)(14444005)(2201001)(86362001)(5024004)(478600001)(36756003)(66446008)(64756008)(73956011)(66946007)(446003)(316002)(7736002)(66556008)(6246003)(305945005)(6306002)(8676002)(6636002)(81156014)(81166006)(6512007)(53936002)(2501003)(6486002)(46003)(71190400001)(6436002)(71200400001)(229853002)(2616005)(476003)(186003)(14454004)(5660300002)(11346002)(486006)(110136005)(68736007)(102836004)(966005)(25786009)(8936002)(53546011)(386003)(6506007)(31686004)(76176011)(99286004)(66476007)(52116002)(6116002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3159;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7wxQ8t/h/NteMrhDD5U3hQ7Qnbc98EFyykM3St1L8CxbAKHy1rhOQNyr+Vol/vVYstgOw3gJgB/jsKDAzHEW2EXwhRDyEzn9TZ07ycFLcFewQYyD3u5CVaVG7AojtKRSsQIgZ6DRglAziCjeewImR19uYiaYDfHEl1tQMt21Wppg8V3r+qbI53lAA2dBP08281IylFmgJJHx/0RH2m5kF5/tLBNFIYQlHWp4UMC1t6Pvru34ne9ZGHipAr2bc/RTF0o0ZLZU67dyGt9pnMi6XDkXJjkMVwetah2AIHal3o68MXKdDttWjMZ6Zxc8nKD7r+A/8RWbkt5b8Ad+g9WwD61+FpoKW0Nko2h/7hHZE/6qGPv+DmQVic67oW6LOJRea+OBeUKfioyflmJDNlpAQnpd+HfITwthrhGSlok6BV8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9854EAB0E284349B0F6C6563BD259C6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 410f01f1-48ae-4add-9224-08d6fe8546de
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 00:36:09.5789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3159
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMS8xOSA0OjU4IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IFRoaXMgcGF0
Y2hzZXQgYWRkcyB0aGUgZm9sbG93aW5nIEFQSXMgdG8gYWxsb3cgYXR0YWNoaW5nIEJQRiBwcm9n
cmFtcyB0bw0KPiB0cmFjaW5nIGVudGl0aWVzOg0KPiAtIGJwZl9wcm9ncmFtX19hdHRhY2hfcGVy
Zl9ldmVudCBmb3IgYXR0YWNoaW5nIHRvIGFueSBvcGVuZWQgcGVyZiBldmVudCBGRCwNCj4gICAg
YWxsb3dpbmcgdXNlcnMgZnVsbCBjb250cm9sOw0KPiAtIGJwZl9wcm9ncmFtX19hdHRhY2hfa3By
b2JlIGZvciBhdHRhY2hpbmcgdG8ga2VybmVsIHByb2JlcyAoYm90aCBlbnRyeSBhbmQNCj4gICAg
cmV0dXJuIHByb2Jlcyk7DQo+IC0gYnBmX3Byb2dyYW1fX2F0dGFjaF91cHJvYmUgZm9yIGF0dGFj
aGluZyB0byB1c2VyIHByb2JlcyAoYm90aCBlbnRyeS9yZXR1cm4pOw0KPiAtIGJwZl9wcm9ncmFt
X19hdHRhY2hfdHJhY2Vwb2ludCBmb3IgYXR0YWNoaW5nIHRvIGtlcm5lbCB0cmFjZXBvaW50czsN
Cj4gLSBicGZfcHJvZ3JhbV9fYXR0YWNoX3Jhd190cmFjZXBvaW50IGZvciBhdHRhY2hpbmcgdG8g
cmF3IGtlcm5lbCB0cmFjZXBvaW50DQo+ICAgICh3cmFwcGVyIGFyb3VuZCBicGZfcmF3X3RyYWNl
cG9pbnRfb3Blbik7DQo+IA0KPiBUaGlzIHNldCBvZiBBUElzIG1ha2VzIGxpYmJwZiBtb3JlIHVz
ZWZ1bCBmb3IgdHJhY2luZyBhcHBsaWNhdGlvbnMuDQo+IA0KPiBBbGwgYXR0YWNoIEFQSXMgcmV0
dXJuIGFic3RyYWN0IHN0cnVjdCBicGZfbGluayB0aGF0IGVuY2Fwc3VsYXRlcyBsb2dpYyBvZg0K
PiBkZXRhY2hpbmcgQlBGIHByb2dyYW0uIFNlZSBwYXRjaCAjMiBmb3IgZGV0YWlscy4gYnBmX2Fz
c29jIHdhcyBjb25zaWRlcmVkIGFzDQo+IGFuIGFsdGVybmF0aXZlIG5hbWUgZm9yIHRoaXMgb3Bh
cXVlICJoYW5kbGUiLCBidXQgYnBmX2xpbmsgc2VlbXMgdG8gYmUNCj4gYXBwcm9wcmlhdGUgc2Vt
YW50aWNhbGx5IGFuZCBpcyBuaWNlIGFuZCBzaG9ydC4NCj4gDQo+IFByZS1wYXRjaCAjMSBtYWtl
cyBpbnRlcm5hbCBsaWJicGZfc3RyZXJyb3JfciBoZWxwZXIgZnVuY3Rpb24gd29yayB3LyBuZWdh
dGl2ZQ0KPiBlcnJvciBjb2RlcywgbGlmdGluZyB0aGUgYnVyZGVyIG9mZiBjYWxsZXJzIHRvIGtl
ZXAgdHJhY2sgb2YgZXJyb3Igc2lnbi4NCj4gUGF0Y2ggIzIgYWRkcyBicGZfbGluayBhYnN0cmFj
dGlvbi4NCj4gUGF0Y2ggIzMgYWRkcyBhdHRhY2hfcGVyZl9ldmVudCwgd2hpY2ggaXMgdGhlIGJh
c2UgZm9yIGFsbCBvdGhlciBBUElzLg0KPiBQYXRjaCAjNCBhZGRzIGtwcm9iZS91cHJvYmUgQVBJ
cy4NCj4gUGF0Y2ggIzUgYWRkcyB0cmFjZXBvaW50IEFQSS4NCj4gUGF0Y2ggIzYgYWRkcyByYXdf
dHJhY2Vwb2ludCBBUEkuDQo+IFBhdGNoICM3IGNvbnZlcnRzIG9uZSBleGlzdGluZyB0ZXN0IHRv
IHVzZSBhdHRhY2hfcGVyZl9ldmVudC4NCj4gUGF0Y2ggIzggYWRkcyBuZXcga3Byb2JlL3Vwcm9i
ZSB0ZXN0cy4NCj4gUGF0Y2ggIzkgY29udmVydHMgc29tZSBzZWxmdGVzdHMgY3VycmVudGx5IHVz
aW5nIHRyYWNlcG9pbnQgdG8gbmV3IEFQSXMuDQo+IA0KPiB2NC0+djU6DQo+IC0gdHlwbyBhbmQg
c21hbGwgbml0cyAoWW9uZ2hvbmcpOw0KPiAtIHZhbGlkYXRlIHBmZCBpbiBhdHRhY2hfcGVyZl9l
dmVudCAoWW9uZ2hvbmcpOw0KPiAtIHBhcnNlX3VpbnRfZnJvbV9maWxlIGZpeGVzIChZb25naG9u
Zyk7DQo+IC0gY2hlY2sgZm9yIG1hbGxvYyBmYWlsdXJlIGluIGF0dGFjaF9yYXdfdHJhY2Vwb2lu
dCAoWW9uZ2hvbmcpOw0KPiAtIGF0dGFjaF9wcm9iZXMgc2VsZnRlc3RzIGNsZWFuIHVwIGZpeGVz
IChZb25naG9uZyk7DQo+IHYzLT52NDoNCj4gLSBwcm9wZXIgZXJybm8gaGFuZGxpbmcgKFN0YW5p
c2xhdik7DQo+IC0gYnBmX2ZkIC0+IHByb2dfZmQgKFN0YW5pc2xhdik7DQo+IC0gc3dpdGNoIHRv
IGZwcmludGYgKFNvbmcpOw0KPiB2Mi0+djM6DQo+IC0gYWRkZWQgYnBmX2xpbmsgY29uY2VwdCAo
RGFuaWVsKTsNCj4gLSBkaWRuJ3QgYWRkIGdlbmVyaWMgYnBmX2xpbmtfX2F0dGFjaF9wcm9ncmFt
IGZvciByZWFzb25zIGRlc2NyaWJlZCBpbiBbMF07DQo+IC0gZHJvcHBlZCBTdGFuaXNsYXYncyBS
ZXZpZXdlZC1ieSBmcm9tIHBhdGNoZXMgIzItIzYsIGluIGNhc2UgaGUgZG9lc24ndCBsaWtlDQo+
ICAgIHRoZSBjaGFuZ2U7DQo+IHYxLT52MjoNCj4gLSBwcmVzZXJ2ZSBlcnJubyBiZWZvcmUgY2xv
c2UoKSBjYWxsIChTdGFuaXNsYXYpOw0KPiAtIHVzZSBsaWJicGZfcGVyZl9ldmVudF9kaXNhYmxl
X2FuZF9jbG9zZSBpbiBzZWxmdGVzdCAoU3RhbmlzbGF2KTsNCj4gLSByZW1vdmUgdW5uZWNlc3Nh
cnkgbWVtc2V0IChTdGFuaXNsYXYpOw0KPiANCj4gWzBdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2JwZi9DQUVmNEJ6WjdFTTVlUDJlYVpuN1QyWWI1UWdWUml3QXMrZXBlTFIxZzAxVFR4LTZtNlFA
bWFpbC5nbWFpbC5jb20vDQo+IA0KPiBBbmRyaWkgTmFrcnlpa28gKDkpOg0KPiAgICBsaWJicGY6
IG1ha2UgbGliYnBmX3N0cmVycm9yX3IgYWdub3N0aWMgdG8gc2lnbiBvZiBlcnJvcg0KPiAgICBs
aWJicGY6IGludHJvZHVjZSBjb25jZXB0IG9mIGJwZl9saW5rDQo+ICAgIGxpYmJwZjogYWRkIGFi
aWxpdHkgdG8gYXR0YWNoL2RldGFjaCBCUEYgcHJvZ3JhbSB0byBwZXJmIGV2ZW50DQo+ICAgIGxp
YmJwZjogYWRkIGtwcm9iZS91cHJvYmUgYXR0YWNoIEFQSQ0KPiAgICBsaWJicGY6IGFkZCB0cmFj
ZXBvaW50IGF0dGFjaCBBUEkNCj4gICAgbGliYnBmOiBhZGQgcmF3IHRyYWNlcG9pbnQgYXR0YWNo
IEFQSQ0KPiAgICBzZWxmdGVzdHMvYnBmOiBzd2l0Y2ggdGVzdCB0byBuZXcgYXR0YWNoX3BlcmZf
ZXZlbnQgQVBJDQo+ICAgIHNlbGZ0ZXN0cy9icGY6IGFkZCBrcHJvYmUvdXByb2JlIHNlbGZ0ZXN0
cw0KPiAgICBzZWxmdGVzdHMvYnBmOiBjb252ZXJ0IGV4aXN0aW5nIHRyYWNlcG9pbnQgdGVzdHMg
dG8gbmV3IEFQSXMNCj4gDQo+ICAgdG9vbHMvbGliL2JwZi9saWJicGYuYyAgICAgICAgICAgICAg
ICAgICAgICAgIHwgMzY3ICsrKysrKysrKysrKysrKysrKw0KPiAgIHRvb2xzL2xpYi9icGYvbGli
YnBmLmggICAgICAgICAgICAgICAgICAgICAgICB8ICAyMSArDQo+ICAgdG9vbHMvbGliL2JwZi9s
aWJicGYubWFwICAgICAgICAgICAgICAgICAgICAgIHwgICA4ICstDQo+ICAgdG9vbHMvbGliL2Jw
Zi9zdHJfZXJyb3IuYyAgICAgICAgICAgICAgICAgICAgIHwgICAyICstDQo+ICAgLi4uL3NlbGZ0
ZXN0cy9icGYvcHJvZ190ZXN0cy9hdHRhY2hfcHJvYmUuYyAgIHwgMTY2ICsrKysrKysrDQo+ICAg
Li4uL2JwZi9wcm9nX3Rlc3RzL3N0YWNrdHJhY2VfYnVpbGRfaWQuYyAgICAgIHwgIDU1ICstLQ0K
PiAgIC4uLi9icGYvcHJvZ190ZXN0cy9zdGFja3RyYWNlX2J1aWxkX2lkX25taS5jICB8ICAzMSAr
LQ0KPiAgIC4uLi9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvc3RhY2t0cmFjZV9tYXAuYyB8ICA0
MyArLQ0KPiAgIC4uLi9icGYvcHJvZ190ZXN0cy9zdGFja3RyYWNlX21hcF9yYXdfdHAuYyAgICB8
ICAxNSArLQ0KPiAgIC4uLi9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfYXR0YWNoX3Byb2JlLmMg
ICB8ICA1NSArKysNCj4gICAxMCBmaWxlcyBjaGFuZ2VkLCA2NjQgaW5zZXJ0aW9ucygrKSwgOTkg
ZGVsZXRpb25zKC0pDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2JwZi9wcm9nX3Rlc3RzL2F0dGFjaF9wcm9iZS5jDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0
IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2F0dGFjaF9wcm9iZS5jDQoN
Ckxvb2tzIGdvb2QgdG8gbWUuIEFjayBmb3IgdGhlIHdob2xlIHNlcmllcy4NCkFja2VkLWJ5OiBZ
b25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0K
