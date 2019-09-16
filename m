Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93A5B34E6
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 08:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbfIPGtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 02:49:47 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:31402 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729039AbfIPGtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 02:49:47 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8G6ljin014815;
        Mon, 16 Sep 2019 02:49:38 -0400
Received: from nam03-co1-obe.outbound.protection.outlook.com (mail-co1nam03lp2059.outbound.protection.outlook.com [104.47.40.59])
        by mx0a-00128a01.pphosted.com with ESMTP id 2v0w47jrpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Sep 2019 02:49:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjGjzGoSoC9ZMtk0ckmSdmo22eZOF0fxKapqpD9VqmfCBfw4BWVytXtZ+TSX5EF4TuUROIphU7KXpdkNLS68+UxYnlGs0SxjNHFwbcgfz+gL30EaUD7GWCR4JfaqNYQ5QcOVGrBATd4YVWeZlY7kwaAZt/wb0UOTg4Z0s7e50wyzATdsI/3DSLearAba1azmaRRwBtJQ8pDa/zo7R7rhL0+gcr5zgXNuTTMU/BUuJsyyJm/h35UrxvOkkMxYvU7dBV0RBLRd6W84d2znPXGP72u+4kehcmzMK1VOhHA5a72tEpp/SOmp05HFniaSrBofa/hqzpuP5q74yiu4Adti4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZnyhc5+H77+lSrzzKJ0/2xfJ9o+ECfnlbCfasJChg8=;
 b=JUl0xH0gDdAqULRpPy5pDvzrtxcD+ctJWJ+d92d6oHzbSsm8VSz2NcKFVxt0Ovk/nREUyBFzVTf8dEXmyA4fpCKt86fxZDWbmRMykaAa0rtmuB4wo0Tlx302PYuQMNI7y/HS1GZMgiG9dAlDwNao3H/6KTOl5hSbSlzsOTfDVoLRdJx3Bd7oVAUW/Vw2RMsVp1bQtn38dJ8NjYDKxQKdUTeTIM1LhuwmhaoUlrylHCZWpmZWG4ZBrQgXfx9PPXRETkbh0L3nH8+7o2kZ5fOcvvRRSEuXolFBwLW0LWPnKRvF+GvmFntju+dXsraipHhpcCdrkWdTLFfMmUs0mDfSAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZnyhc5+H77+lSrzzKJ0/2xfJ9o+ECfnlbCfasJChg8=;
 b=FSMNqq9J8tS086pfUqVhGFux7/cZPj9mj484/hGfrXREmElLQSD2S0N2w61mIvBgwVhcPQAx9UEH2iK/+NtAN6D3tGQWivyfplBV1FFTKRC4OcJa943MfY0CtvLYdrX0rtj1qerF4T1UXVHNg0c4H+KaIXMw3WsdPdsz5ZsE4Ok=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5158.namprd03.prod.outlook.com (20.180.13.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Mon, 16 Sep 2019 06:49:37 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b%3]) with mapi id 15.20.2263.023; Mon, 16 Sep 2019
 06:49:37 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "robh@kernel.org" <robh@kernel.org>
CC:     "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "--cc=andrew@lunn.ch" <--cc=andrew@lunn.ch>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 2/2] dt-bindings: net: dwmac: document 'mac-mode' property
Thread-Topic: [PATCH 2/2] dt-bindings: net: dwmac: document 'mac-mode'
 property
Thread-Index: AQHVZLNvGuXe180aF020AC4Y2jYaYacpt8iAgARm6YA=
Date:   Mon, 16 Sep 2019 06:49:36 +0000
Message-ID: <b5065fcfaaf8bcb7bc532a8eb9f54949da838965.camel@analog.com>
References: <20190906130256.10321-1-alexandru.ardelean@analog.com>
         <20190906130256.10321-2-alexandru.ardelean@analog.com>
         <5d7ba95d.1c69fb81.dabe4.8057@mx.google.com>
In-Reply-To: <5d7ba95d.1c69fb81.dabe4.8057@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d44c6bb3-3a85-408f-d877-08d73a720a71
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CH2PR03MB5158;
x-ms-traffictypediagnostic: CH2PR03MB5158:
x-microsoft-antispam-prvs: <CH2PR03MB51587531C54962B506468B0EF98C0@CH2PR03MB5158.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(376002)(136003)(366004)(396003)(189003)(199004)(6246003)(81166006)(81156014)(1730700003)(446003)(11346002)(478600001)(2616005)(186003)(71190400001)(71200400001)(25786009)(66066001)(36756003)(6506007)(4326008)(3846002)(6116002)(102836004)(99286004)(2351001)(2501003)(2906002)(316002)(476003)(14444005)(486006)(91956017)(256004)(8936002)(5660300002)(76116006)(66476007)(66946007)(66446008)(64756008)(66556008)(54906003)(76176011)(26005)(6512007)(53936002)(14454004)(6436002)(7736002)(6916009)(229853002)(305945005)(8676002)(5640700003)(86362001)(118296001)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5158;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: D7g+SRsSuWRteZofiJtG5Lgr+P7B+ib6cKjKS/mDqnutwtPW2J3MSFrQLgBOeSbe3nTgfLCUocALdgX+3tQXIT8JYp+hBv2sG2LzTRUtFtblfUo4/624X+B/XNt7IQZQV7/4RCq55xDyuF4haKACebKDzV7ewBK7aWfBSpNBPg0AJZlDKmNjWVVLUzD9REqZFysS0Si4mPDjJ/NxqRfYTW835NAWXQABWw19xwTTdO83p+FRAhn0HSESWoz9lUfT/pLb4Tu0mne405T0Fb1GDAlINq+SbTOV6+ca8JrOIlxfdwd+/VvHJKmwolG4Yrgnn2yHnmvsxnT2HX1bm02Uzm+7MPBsxjs2eXyPuwcSlIq4SMtgorMOdCYLkLT91VFZI49z6OyK9jruRmu03sRmrfaU1waGKEvlxNh1Iooyh7g=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B14A9DFE43F1A419C06705452BBAA03@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d44c6bb3-3a85-408f-d877-08d73a720a71
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 06:49:36.9428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FWhJfMu0+YSQKYWN9KN3k7iEDbQ/9Wx7lkgCtebrKvC8kXdItXk/QFyYChHmb5PmDCWhBNZS/agOtCKEP8mzUjPDPd741J9bzZ97lYsMlZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5158
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-16_03:2019-09-11,2019-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909160073
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA5LTEzIGF0IDE1OjM2ICswMTAwLCBSb2IgSGVycmluZyB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gRnJpLCBTZXAgMDYsIDIwMTkgYXQgMDQ6MDI6NTZQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IFRoaXMgY2hhbmdlIGRvY3VtZW50cyB0
aGUgJ21hYy1tb2RlJyBwcm9wZXJ0eSB0aGF0IHdhcyBpbnRyb2R1Y2VkIGluIHRoZQ0KPiA+ICdz
dG1tYWMnIGRyaXZlciB0byBzdXBwb3J0IHBhc3NpdmUgbW9kZSBjb252ZXJ0ZXJzIHRoYXQgY2Fu
IHNpdCBpbi1iZXR3ZWVuDQo+ID4gdGhlIE1BQyAmIFBIWS4NCj4gPiANCj4gPiBTaWduZWQtb2Zm
LWJ5OiBBbGV4YW5kcnUgQXJkZWxlYW4gPGFsZXhhbmRydS5hcmRlbGVhbkBhbmFsb2cuY29tPg0K
PiA+IC0tLQ0KPiA+ICBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3NucHMs
ZHdtYWMueWFtbCB8IDggKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbmV0L3NucHMsZHdtYWMueWFtbA0KPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVl
L2JpbmRpbmdzL25ldC9zbnBzLGR3bWFjLnlhbWwNCj4gPiBpbmRleCBjNzhiZTE1NzA0YjkuLmVi
ZTQ1MzdhN2NjZSAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbmV0L3NucHMsZHdtYWMueWFtbA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9uZXQvc25wcyxkd21hYy55YW1sDQo+ID4gQEAgLTExMiw2ICsxMTIsMTQg
QEAgcHJvcGVydGllczoNCj4gPiAgICByZXNldC1uYW1lczoNCj4gPiAgICAgIGNvbnN0OiBzdG1t
YWNldGgNCj4gPiAgDQo+ID4gKyAgbWFjLW1vZGU6DQo+ID4gKyAgICBtYXhJdGVtczogMQ0KPiAN
Cj4gSXMgdGhpcyBhbiBhcnJheSBiZWNhdXNlIHttaW4sbWF4fUl0ZW1zIGlzIGZvciBhcnJheXM/
IEl0IHNob3VsZCBiZSANCj4gZGVmaW5lZCBhcyBhIHN0cmluZyB3aXRoIHBvc3NpYmxlIHZhbHVl
cy4NCj4gDQo+IEFzIHRoaXMgcHJvcGVydHkgaXMgdGhlIHNhbWUgYXMgYW5vdGhlciwgeW91IGNh
biBkbyB0aGlzOg0KPiANCj4gJHJlZjogZXRoZXJuZXQtY29udHJvbGxlci55YW1sIy9wcm9wZXJ0
aWVzL3BoeS1jb25uZWN0aW9uLXR5cGUNCj4gDQo+IFVubGVzcyBvbmx5IGEgc21hbGwgc3Vic2V0
IG9mIHRob3NlIHZhbHVlcyBhcmUgdmFsaWQgaGVyZSwgdGhlbiB5b3UgbWF5IA0KPiB3YW50IHRv
IGxpc3QgdGhlbSBoZXJlLg0KPiANCg0KQWNrLg0KVGhhbmsgeW91Lg0KDQpXaWxsIGludmVzdGln
YXRlIGFuZCByZS1zcGluLg0KDQoNCj4gPiArICAgIGRlc2NyaXB0aW9uOg0KPiA+ICsgICAgICBU
aGUgcHJvcGVydHkgaXMgaWRlbnRpY2FsIHRvICdwaHktbW9kZScsIGFuZCBhc3N1bWVzIHRoYXQg
dGhlcmUgaXMgbW9kZQ0KPiA+ICsgICAgICBjb252ZXJ0ZXIgaW4tYmV0d2VlbiB0aGUgTUFDICYg
UEhZIChlLmcuIEdNSUktdG8tUkdNSUkpLiBUaGlzIGNvbnZlcnRlcg0KPiA+ICsgICAgICBjYW4g
YmUgcGFzc2l2ZSAobm8gU1cgcmVxdWlyZW1lbnQpLCBhbmQgcmVxdWlyZXMgdGhhdCB0aGUgTUFD
IG9wZXJhdGUNCj4gPiArICAgICAgaW4gYSBkaWZmZXJlbnQgbW9kZSB0aGFuIHRoZSBQSFkgaW4g
b3JkZXIgdG8gZnVuY3Rpb24uDQo+ID4gKw0KPiA+ICAgIHNucHMsYXhpLWNvbmZpZzoNCj4gPiAg
ICAgICRyZWY6IC9zY2hlbWFzL3R5cGVzLnlhbWwjZGVmaW5pdGlvbnMvcGhhbmRsZQ0KPiA+ICAg
ICAgZGVzY3JpcHRpb246DQo+ID4gLS0gDQo+ID4gMi4yMC4xDQo+ID4gDQo=
