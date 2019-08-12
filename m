Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7187F89973
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfHLJHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:07:53 -0400
Received: from mail-eopbgr690075.outbound.protection.outlook.com ([40.107.69.75]:37956
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727154AbfHLJHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 05:07:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJ3gTKyV0I4GHTMzulnj4kCD9Z1jjnGwHPjlLCiepIhmeJYoK4ft4jNfW2LKecUy95lzsrNMQYQ+7p/D1bg4LR9ycYbs+xaMZG9xVNVBfk4M3Cq7Jq4/Oit05z2qKwsZ8ey1M7r5HqX4uYjz8ueRtUpClzhFt7ogFhw7ekwI6gzCQLE5Firbl/zB3kiAwkMuclY6bcNvk25aDfkjOGN1Fbde59ZmLI7NM9m2vRqEqAaydrO+x5Ts1GH2mTzKgWBlwRN4JE40A+eJQji5m2uW4gC/P1EagxwEbMT67XjGN3lC6unuythPygu+jvCcv++/4aUy9yRkZQbp/AXPvYlbGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnzR6td7kfoQXTg1O2h9LyVjbNA0Fs+TsWSO2QZ+bhw=;
 b=ko0302l8CeB432CWHYxgP4upJAMIHj2RsGDqqhdti/kiqOVYuzkDOvTaVYYQFfgSe0ct/+hQi+2jwcAxaigVfIIDPvmfypWx7q49uGHd5nqSJXTZoyWz4Qly+J3pTQ1wB3eB5D78o/ig9rAazU+JD0PJwRXMk+jEbrCSZIcvroCeF8tU4vRBKcWTLvPUz64Z5a9hqbTVIk42j26+05pXG+xAFAXToHQqker4w5EyB36M3JnH2Fb09nDKrR1wRF5GQj8fud1Pv7k06LM1SycIIV6KreYJrxEaVLIQFksfezROHtcrjWZyntXtk5NvvOnEKaynFXE4JE54bPw29Pr0PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnzR6td7kfoQXTg1O2h9LyVjbNA0Fs+TsWSO2QZ+bhw=;
 b=Xx8ErFyEicOyMOdCOMSbCR7jyGFZf2gQ47gzm/TiefQ872sFmvHQvpZBo03H0JCREzhK2EtVuRlnKlwU8uPaZebLoaUNwwZVFvHRA3bX38VT50G7Id6urIyEGK1BkeeQJZNEQ1oDZ3T+HdppnaMld4RgKFA5vLVKT1xM5aZl9rM=
Received: from MN2PR02MB6400.namprd02.prod.outlook.com (52.132.175.209) by
 MN2PR02MB6159.namprd02.prod.outlook.com (52.132.173.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Mon, 12 Aug 2019 09:07:48 +0000
Received: from MN2PR02MB6400.namprd02.prod.outlook.com
 ([fe80::51c3:4e3a:8313:28e7]) by MN2PR02MB6400.namprd02.prod.outlook.com
 ([fe80::51c3:4e3a:8313:28e7%7]) with mapi id 15.20.2157.022; Mon, 12 Aug 2019
 09:07:48 +0000
From:   Appana Durga Kedareswara Rao <appanad@xilinx.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Venkatesh Yadav Abbarapu <VABBARAP@xilinx.com>
Subject: RE: [PATCH 1/5] can: xilinx_can: defer the probe if clock is not
 found
Thread-Topic: [PATCH 1/5] can: xilinx_can: defer the probe if clock is not
 found
Thread-Index: AQHVUOzNGBkOMLLSYkukMJ5tsNAwwqb3OKiw
Date:   Mon, 12 Aug 2019 09:07:48 +0000
Message-ID: <MN2PR02MB64001BE4B002AE2AE5790FC3DCD30@MN2PR02MB6400.namprd02.prod.outlook.com>
References: <1565594914-18999-1-git-send-email-appana.durga.rao@xilinx.com>
 <1565594914-18999-2-git-send-email-appana.durga.rao@xilinx.com>
 <144fdbc7-982a-f50d-3bf1-dd9ee2ad282c@pengutronix.de>
In-Reply-To: <144fdbc7-982a-f50d-3bf1-dd9ee2ad282c@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=appanad@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc5d4833-45e0-4f9b-2c31-08d71f048c1c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR02MB6159;
x-ms-traffictypediagnostic: MN2PR02MB6159:
x-ms-exchange-purlcount: 1
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR02MB6159413E4259F348BDA21BE8DCD30@MN2PR02MB6159.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(199004)(189003)(51914003)(6116002)(7736002)(74316002)(305945005)(186003)(229853002)(26005)(25786009)(3846002)(966005)(71200400001)(6246003)(52536014)(107886003)(71190400001)(66066001)(6636002)(53386004)(99286004)(6306002)(316002)(8676002)(9686003)(5660300002)(7696005)(2906002)(81156014)(110136005)(76176011)(54906003)(55016002)(4326008)(102836004)(53936002)(2201001)(81166006)(8936002)(86362001)(6506007)(53546011)(478600001)(6436002)(14454004)(486006)(446003)(11346002)(66446008)(476003)(76116006)(64756008)(66556008)(66476007)(66946007)(2501003)(14444005)(256004)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6159;H:MN2PR02MB6400.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jGKnjXFt0EEQCVgXPGDeWbYvB8UICzrBEY5Io4lwFcF/aDDhFHW/BmoShGyKcoS3GGHbg9CjEFwCnH6Xh3BknCvVJTIqYmJlu+KmfYCGOG+Cae1HMIVOpaV1fay+cOOYdw1/1hnZZcq/SEj86k1nyeeZmgwQaw0EAiJXoM72dDebibDPCwFou9PQ0ynJI1VzTRFrgPQ5tqe8bAw2V7G53yy/jyymkU4qE0m4tiaVjunHZkRIN8+B+Duq1xUGx9orpOkPgY4Hpxbqhw6W21rzNBSAcz+pTrEoXITCl4wBXbxSbzZYET37mLBeWn+Ty0Z3OWBYTB9ZR+IilPsLrrHPY2N1pSdgTYX4meI+oG3yLQxQlYqYAONOHq/SoWFTbzyXQaynRgomQvBPtS0bBTRYx5u4Acn6l5svyJEZw/C69n8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc5d4833-45e0-4f9b-2c31-08d71f048c1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2019 09:07:48.6002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0kngpIOeXUcpHrBDJoHvtxZDWUjCYbN6TALydIOiLVGKtkazI+vSYH4Ho3lXNDNpEc4W7hO1JDgXkepVzFTyvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6159
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3Li4uDQoNCjxTbmlwPiANCj4gT24gOC8x
Mi8xOSA5OjI4IEFNLCBBcHBhbmEgRHVyZ2EgS2VkYXJlc3dhcmEgcmFvIHdyb3RlOg0KPiA+IEZy
b206IFZlbmthdGVzaCBZYWRhdiBBYmJhcmFwdSA8dmVua2F0ZXNoLmFiYmFyYXB1QHhpbGlueC5j
b20+DQo+ID4NCj4gPiBJdCdzIG5vdCBhbHdheXMgdGhlIGNhc2UgdGhhdCBjbG9jayBpcyBhbHJl
YWR5IGF2YWlsYWJsZSB3aGVuIGNhbg0KPiA+IGRyaXZlciBnZXQgcHJvYmVkIGF0IHRoZSBmaXJz
dCB0aW1lLCBlLmcuIHRoZSBjbG9jayBpcyBwcm92aWRlZCBieQ0KPiA+IGNsb2NrIHdpemFyZCB3
aGljaCBtYXkgYmUgcHJvYmVkIGFmdGVyIGNhbiBkcml2ZXIuIFNvIGxldCdzIGRlZmVyIHRoZQ0K
PiA+IHByb2JlIHdoZW4gZGV2bV9jbGtfZ2V0KCkgY2FsbCBmYWlscyBhbmQgZ2l2ZSBpdCBjaGFu
Y2UgdG8gdHJ5IGxhdGVyLg0KPiANCj4gVGVjaG5pY2FsbHkgdGhlIHBhdGNoIGNoYW5nZXMgdGhl
IGVycm9yIG1lc3NhZ2UgdG8gbm90IGJlaW5nIHByaW50ZWQgaW4gY2FzZQ0KPiBvZiBFUFJPQkVf
REVGRVIuIFRoaXMgcGF0Y2ggZG9lc24ndCBjaGFuZ2UgYW55IGJlaGF2aW91ciBhcGFydCBmcm9t
IHRoYXQuDQo+IFBsZWFzZSBhZGp1c3QgdGhlIHBhdGNoIGRlc2NyaXB0aW9uIGFjY29yZGluZ2x5
Lg0KDQpTdXJlIHdpbGwgZml4IGluIHYyLi4uIA0KDQpSZWdhcmRzLA0KS2VkYXIuDQoNCj4gDQo+
IE1hcmMNCj4gDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBWZW5rYXRlc2ggWWFkYXYgQWJiYXJh
cHUNCj4gPiA8dmVua2F0ZXNoLmFiYmFyYXB1QHhpbGlueC5jb20+DQo+ID4gU2lnbmVkLW9mZi1i
eTogTWljaGFsIFNpbWVrIDxtaWNoYWwuc2ltZWtAeGlsaW54LmNvbT4NCj4gPiAtLS0NCj4gPiAg
ZHJpdmVycy9uZXQvY2FuL3hpbGlueF9jYW4uYyB8IDMgKystDQo+ID4gIDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9jYW4veGlsaW54X2Nhbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9jYW4veGlsaW54
X2Nhbi5jIGluZGV4IGJkOTVjZmEuLmFjMTc1YWIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9u
ZXQvY2FuL3hpbGlueF9jYW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2Nhbi94aWxpbnhfY2Fu
LmMNCj4gPiBAQCAtMTc5MSw3ICsxNzkxLDggQEAgc3RhdGljIGludCB4Y2FuX3Byb2JlKHN0cnVj
dCBwbGF0Zm9ybV9kZXZpY2UNCj4gKnBkZXYpDQo+ID4gIAkvKiBHZXR0aW5nIHRoZSBDQU4gY2Fu
X2NsayBpbmZvICovDQo+ID4gIAlwcml2LT5jYW5fY2xrID0gZGV2bV9jbGtfZ2V0KCZwZGV2LT5k
ZXYsICJjYW5fY2xrIik7DQo+ID4gIAlpZiAoSVNfRVJSKHByaXYtPmNhbl9jbGspKSB7DQo+ID4g
LQkJZGV2X2VycigmcGRldi0+ZGV2LCAiRGV2aWNlIGNsb2NrIG5vdCBmb3VuZC5cbiIpOw0KPiA+
ICsJCWlmIChQVFJfRVJSKHByaXYtPmNhbl9jbGspICE9IC1FUFJPQkVfREVGRVIpDQo+ID4gKwkJ
CWRldl9lcnIoJnBkZXYtPmRldiwgIkRldmljZSBjbG9jayBub3QgZm91bmQuXG4iKTsNCj4gPiAg
CQlyZXQgPSBQVFJfRVJSKHByaXYtPmNhbl9jbGspOw0KPiA+ICAJCWdvdG8gZXJyX2ZyZWU7DQo+
ID4gIAl9DQo+ID4NCj4gDQo+IA0KPiAtLQ0KPiBQZW5ndXRyb25peCBlLksuICAgICAgICAgICAg
ICAgICAgfCBNYXJjIEtsZWluZS1CdWRkZSAgICAgICAgICAgfA0KPiBJbmR1c3RyaWFsIExpbnV4
IFNvbHV0aW9ucyAgICAgICAgfCBQaG9uZTogKzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBWZXJ0
cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAgICAgfCBGYXg6ICAgKzQ5LTUxMjEtMjA2OTE3LTU1
NTUgfA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiAgfCBodHRwOi8vd3d3LnBl
bmd1dHJvbml4LmRlICAgfA0KDQo=
