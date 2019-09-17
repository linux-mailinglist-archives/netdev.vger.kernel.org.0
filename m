Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D57EB4833
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 09:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392566AbfIQHWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 03:22:08 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:59828 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727635AbfIQHWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 03:22:08 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8H7IGvI010887;
        Tue, 17 Sep 2019 03:21:56 -0400
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2052.outbound.protection.outlook.com [104.47.34.52])
        by mx0b-00128a01.pphosted.com with ESMTP id 2v0vu6dau8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 03:21:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FE/IDE1PoOZhBsaYuLEIa8yBSsl9KSa0+DBpqGSPCC4/IWRGrwwWs6De/QCJ/ohziyX3fju5lQOMOi5Ku9t4UL4/+K0C1VVUfHxeS9vJheO9pFDVc0Fu0DSxbDkTSHVW+rw/L8/7c5BE5rNX/PMW3TIFkNY3eLWEug8xugJAyiIaMCCMUBwSOi3M9v8T/zthizJFQktBIIwZOamyemtrTx/9fAQNWXe3IKqe97uaNiNi/EUTUh/VI8ZAjWuBfEyxijUAQbw8Uhklbnp0MXROY8hQgb2YNFMpj4xo8+2o1IKEQk11zVoWQRFtWk2fzR8K4OLUC23xN6XpSLV0I+Hw4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmXattSp8dkaum2TbKUvepfubY5QpuNi7jy+j4+SaK8=;
 b=bzhRo+5vxv251Gv7REbhTw0LiD/7txYt+beLJIUCasu18xKkU+0zZAs/Fn0Ta4NZpQ+gf8scrK1Gd6cRfBK2+iOl1HIYn4g80blpT1u8LhEl7YHqryueyKlS/VAd4Qqhf5Kf7yymGHX33y+dNkrU8MvY2UvJ382GL+M8KsTkzrWtpibI6azko2zkgbty/CyBuMeG90/lrgkMfI3VNbNXuBM/sRrj09NTM+7lFBcV8h9aFuBTX0JLuCBp4/uhXX6N2TyERfuKSWZo9z2KY8sGHqpxCT3AFUy/ixrLf94UXHr4/waa/6lwyXl/wkuG5n5OQgfabbPYgMTkRUphaoaoxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmXattSp8dkaum2TbKUvepfubY5QpuNi7jy+j4+SaK8=;
 b=MvlDKhRx6qRHsZHl1hjA2mduUvXbYkcKGpOlTanN3NNFxe9F/vREGvIhkhAHstL7ok2m1ju50v009OKNOaewQyspC589gUMCys7cpps0T6NUmMOKo52by2VYlmBtvrW6TJx41qNmj1JN1CsL15BoT0DQ6lZ2aoiMn43hxqPQ82Q=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5350.namprd03.prod.outlook.com (20.180.14.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Tue, 17 Sep 2019 07:21:54 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b%3]) with mapi id 15.20.2284.009; Tue, 17 Sep 2019
 07:21:54 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "robh@kernel.org" <robh@kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH 2/2] dt-bindings: net: dwmac: document 'mac-mode' property
Thread-Topic: [PATCH 2/2] dt-bindings: net: dwmac: document 'mac-mode'
 property
Thread-Index: AQHVZLNvGuXe180aF020AC4Y2jYaYacpt8iAgARm6YCAAZtZAA==
Date:   Tue, 17 Sep 2019 07:21:54 +0000
Message-ID: <dd3877616b2dee81cf35cfc9f53bbbb47335a357.camel@analog.com>
References: <20190906130256.10321-1-alexandru.ardelean@analog.com>
         <20190906130256.10321-2-alexandru.ardelean@analog.com>
         <5d7ba95d.1c69fb81.dabe4.8057@mx.google.com>
         <b5065fcfaaf8bcb7bc532a8eb9f54949da838965.camel@analog.com>
In-Reply-To: <b5065fcfaaf8bcb7bc532a8eb9f54949da838965.camel@analog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac14f77d-e3d2-4d37-1041-08d73b3fb78a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CH2PR03MB5350;
x-ms-traffictypediagnostic: CH2PR03MB5350:
x-microsoft-antispam-prvs: <CH2PR03MB53508E5D670E09EE399EEDAAF98F0@CH2PR03MB5350.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(346002)(366004)(136003)(199004)(189003)(26005)(316002)(14454004)(8936002)(2351001)(305945005)(14444005)(7736002)(256004)(476003)(2501003)(446003)(2616005)(11346002)(3846002)(2906002)(86362001)(6116002)(99286004)(5660300002)(186003)(36756003)(71200400001)(54906003)(66066001)(6506007)(486006)(478600001)(76176011)(25786009)(6916009)(6246003)(6436002)(6486002)(102836004)(66556008)(229853002)(6512007)(76116006)(64756008)(8676002)(81156014)(1730700003)(81166006)(66946007)(118296001)(4326008)(66446008)(66476007)(5640700003)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5350;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VjSJc6JUjSpSwNTtwGyOyWTfiyC3brUzt9R+ixlWra9pJimF1D+fgSj7AmAS6DPMShWPSphtKALh2CfQmKbGHpM+nIRLMFjlYeKE9Ro0EQkIsVV55IP3F9ML5z+fG5lotS0xkQ0IMiztW2JlznBPDXA+TdhEX5SEiUFQGbCxRpyHQgG6Vm7FoHiyIEUq32ojLKhUtMGKa/KBzW57A2bImxgP3b3fKfylLlG1jafRklqhBo9Q/Jf19r9gpB+7Rp9wQ5p4s7URTnTrnjwRSqKu5sSp1rewAz1MC9qJBr2k+3+rmQtY+7973aY/WdAn/TbYiiGSnb+OVCHjPUm1dBRcef5Ajo3xKZIzO/0CEXoSlSBakIA1dUdDKLFf2Avignvq2aRA/kS9IACwfcJCGj9dOo4gkDGV1SHqCdj17lIie3U=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE6442B622A669409D675BBBF5ABEFA5@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac14f77d-e3d2-4d37-1041-08d73b3fb78a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2019 07:21:54.2850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 66Wjx8JAEnMg0cibgohYRA7zA9zKVNI4wC0S0IcWCBiUEvryDP1WtF+0wowjLdUWZr3FMfyuOyumb1zSBF8LXtTtVygqEalpa4d1a6YW7b4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5350
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-17_04:2019-09-11,2019-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909170080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA5LTE2IGF0IDEyOjQ5ICswMzAwLCBBbGV4YW5kcnUgQXJkZWxlYW4gd3Jv
dGU6DQo+IE9uIEZyaSwgMjAxOS0wOS0xMyBhdCAxNTozNiArMDEwMCwgUm9iIEhlcnJpbmcgd3Jv
dGU6DQo+ID4gW0V4dGVybmFsXQ0KPiA+IA0KPiA+IE9uIEZyaSwgU2VwIDA2LCAyMDE5IGF0IDA0
OjAyOjU2UE0gKzAzMDAsIEFsZXhhbmRydSBBcmRlbGVhbiB3cm90ZToNCj4gPiA+IFRoaXMgY2hh
bmdlIGRvY3VtZW50cyB0aGUgJ21hYy1tb2RlJyBwcm9wZXJ0eSB0aGF0IHdhcyBpbnRyb2R1Y2Vk
IGluDQo+ID4gPiB0aGUNCj4gPiA+ICdzdG1tYWMnIGRyaXZlciB0byBzdXBwb3J0IHBhc3NpdmUg
bW9kZSBjb252ZXJ0ZXJzIHRoYXQgY2FuIHNpdCBpbi0NCj4gPiA+IGJldHdlZW4NCj4gPiA+IHRo
ZSBNQUMgJiBQSFkuDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRydSBBcmRl
bGVhbiA8YWxleGFuZHJ1LmFyZGVsZWFuQGFuYWxvZy5jb20+DQo+ID4gPiAtLS0NCj4gPiA+ICBE
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3NucHMsZHdtYWMueWFtbCB8IDgg
KysrKysrKysNCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspDQo+ID4gPiAN
Cj4gPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0
L3NucHMsZHdtYWMueWFtbA0KPiA+ID4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGlu
Z3MvbmV0L3NucHMsZHdtYWMueWFtbA0KPiA+ID4gaW5kZXggYzc4YmUxNTcwNGI5Li5lYmU0NTM3
YTdjY2UgMTAwNjQ0DQo+ID4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGlu
Z3MvbmV0L3NucHMsZHdtYWMueWFtbA0KPiA+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL25ldC9zbnBzLGR3bWFjLnlhbWwNCj4gPiA+IEBAIC0xMTIsNiArMTEyLDE0
IEBAIHByb3BlcnRpZXM6DQo+ID4gPiAgICByZXNldC1uYW1lczoNCj4gPiA+ICAgICAgY29uc3Q6
IHN0bW1hY2V0aA0KPiA+ID4gIA0KPiA+ID4gKyAgbWFjLW1vZGU6DQo+ID4gPiArICAgIG1heEl0
ZW1zOiAxDQo+ID4gDQo+ID4gSXMgdGhpcyBhbiBhcnJheSBiZWNhdXNlIHttaW4sbWF4fUl0ZW1z
IGlzIGZvciBhcnJheXM/IEl0IHNob3VsZCBiZSANCj4gPiBkZWZpbmVkIGFzIGEgc3RyaW5nIHdp
dGggcG9zc2libGUgdmFsdWVzLg0KPiA+IA0KPiA+IEFzIHRoaXMgcHJvcGVydHkgaXMgdGhlIHNh
bWUgYXMgYW5vdGhlciwgeW91IGNhbiBkbyB0aGlzOg0KPiA+IA0KPiA+ICRyZWY6IGV0aGVybmV0
LWNvbnRyb2xsZXIueWFtbCMvcHJvcGVydGllcy9waHktY29ubmVjdGlvbi10eXBlDQo+ID4gDQo+
ID4gVW5sZXNzIG9ubHkgYSBzbWFsbCBzdWJzZXQgb2YgdGhvc2UgdmFsdWVzIGFyZSB2YWxpZCBo
ZXJlLCB0aGVuIHlvdQ0KPiA+IG1heSANCj4gPiB3YW50IHRvIGxpc3QgdGhlbSBoZXJlLg0KPiA+
IA0KPiANCj4gQWNrLg0KPiBUaGFuayB5b3UuDQo+IA0KPiBXaWxsIGludmVzdGlnYXRlIGFuZCBy
ZS1zcGluLg0KDQpMb29raW5nIGF0ICckcmVmOiBldGhlcm5ldC1jb250cm9sbGVyLnlhbWwjL3By
b3BlcnRpZXMvcGh5LWNvbm5lY3Rpb24tdHlwZScNCml0IGxvb2tzIGxpa2UgJ21hYy1tb2RlJyBj
b3VsZCBjb3ZlciBhbG1vc3QgYWxsICdwaHktY29ubmVjdGlvbi10eXBlJw0KZXhjZXB0IGZvciBh
IGZldyAoMSBvciAyKS4gVGhlICdkd21hYycgZHJpdmVyIGlzIHByZXR0eSBjb21wbGV4L2JpZy4N
Cg0KVGhlcmUgd2FzIGEgbm90ZSB0aGF0IEFuZHJldyBtYWRlIG9uIGEgcHJldmlvdXMgY2hhbmdl
LCB0aGF0IHdlIGNvdWxkIGhhdmUNCmEgJ21hYy1tb2RlJyAoc2ltaWxhciB0byAncGh5LW1vZGUn
KSBhbmQgdGhhdCBjb3VsZCBiZWNvbWUgZ2VuZXJpYyAoZWl0aGVyDQppbiBwaHlsaWIgb3IgbWF5
YmUgc29tZXdoZXJlIGVsc2UgaW4gbmV0ZGV2KS4NCg0KSW4gYW55IGNhc2UsIHRoZSBjb25jbHVz
aW9uIFtmcm9tIG15IHNpZGVdIHdvdWxkIGJlIHRoYXQNCickcmVmOiBldGhlcm5ldC1jb250cm9s
bGVyLnlhbWwjL3Byb3BlcnRpZXMvcGh5LWNvbm5lY3Rpb24tdHlwZScNCmNvdWxkIHdvcmssIGFu
ZCBiZSBzdWZmaWNpZW50bHkgZnV0dXJlLXByb29mLg0KDQpUaGFua3MNCkFsZXgNCg0KPiANCj4g
DQo+ID4gPiArICAgIGRlc2NyaXB0aW9uOg0KPiA+ID4gKyAgICAgIFRoZSBwcm9wZXJ0eSBpcyBp
ZGVudGljYWwgdG8gJ3BoeS1tb2RlJywgYW5kIGFzc3VtZXMgdGhhdA0KPiA+ID4gdGhlcmUgaXMg
bW9kZQ0KPiA+ID4gKyAgICAgIGNvbnZlcnRlciBpbi1iZXR3ZWVuIHRoZSBNQUMgJiBQSFkgKGUu
Zy4gR01JSS10by1SR01JSSkuIFRoaXMNCj4gPiA+IGNvbnZlcnRlcg0KPiA+ID4gKyAgICAgIGNh
biBiZSBwYXNzaXZlIChubyBTVyByZXF1aXJlbWVudCksIGFuZCByZXF1aXJlcyB0aGF0IHRoZSBN
QUMNCj4gPiA+IG9wZXJhdGUNCj4gPiA+ICsgICAgICBpbiBhIGRpZmZlcmVudCBtb2RlIHRoYW4g
dGhlIFBIWSBpbiBvcmRlciB0byBmdW5jdGlvbi4NCj4gPiA+ICsNCj4gPiA+ICAgIHNucHMsYXhp
LWNvbmZpZzoNCj4gPiA+ICAgICAgJHJlZjogL3NjaGVtYXMvdHlwZXMueWFtbCNkZWZpbml0aW9u
cy9waGFuZGxlDQo+ID4gPiAgICAgIGRlc2NyaXB0aW9uOg0KPiA+ID4gLS0gDQo+ID4gPiAyLjIw
LjENCj4gPiA+IA0K
