Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E171A16F77
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 05:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfEHDaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 23:30:07 -0400
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:15937
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726589AbfEHDaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 23:30:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXsMM7PHgUh0FrziekItBuSj29pgo/FKalU8Cey8QQs=;
 b=niFu7yq/bCLhs0XQZYkRWpeWYHykf7igE9J/xZdSmY1FYGbFz3JQRJHf1NsMqYpPm7eL3mzUJjM1qd3vkAjdjShb4dsGjcKVcpXgf+NG6zOIqOCjdVFY1C1KbS28NHVkZ1zs4LRv37+jEjzGUkZQvdwhuvgk8wg8kjQEy8yj+u8=
Received: from VI1PR04MB5135.eurprd04.prod.outlook.com (20.177.50.160) by
 VI1PR04MB5968.eurprd04.prod.outlook.com (20.178.123.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Wed, 8 May 2019 03:30:01 +0000
Received: from VI1PR04MB5135.eurprd04.prod.outlook.com
 ([fe80::a986:98cc:25cc:ace0]) by VI1PR04MB5135.eurprd04.prod.outlook.com
 ([fe80::a986:98cc:25cc:ace0%6]) with mapi id 15.20.1856.012; Wed, 8 May 2019
 03:30:01 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Leo Li <leoyang.li@nxp.com>, Roy Zang <roy.zang@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        "deepa.kernel@gmail.com" <deepa.kernel@gmail.com>
Subject: RE: [EXT] Re: [PATCH v1] timer:clock:ptp: add support the dynamic
 posix clock alarm set for ptp
Thread-Topic: [EXT] Re: [PATCH v1] timer:clock:ptp: add support the dynamic
 posix clock alarm set for ptp
Thread-Index: AQHVAv+uAw38mip9iECrS0NFEcaAmaZfsX0AgADheTA=
Date:   Wed, 8 May 2019 03:30:01 +0000
Message-ID: <VI1PR04MB51359553C796D25765720FCC92320@VI1PR04MB5135.eurprd04.prod.outlook.com>
References: <1557032106-28041-1-git-send-email-Po.Liu@nxp.com>
 <20190507134952.uqqxmhinv75actbh@localhost>
In-Reply-To: <20190507134952.uqqxmhinv75actbh@localhost>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52d56291-104d-49ea-3bd7-08d6d3657463
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5968;
x-ms-traffictypediagnostic: VI1PR04MB5968:
x-microsoft-antispam-prvs: <VI1PR04MB5968345413BB7156C5A2AAEC92320@VI1PR04MB5968.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0031A0FFAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(366004)(396003)(39860400002)(346002)(136003)(376002)(189003)(199004)(13464003)(74316002)(55016002)(305945005)(99286004)(2906002)(54906003)(316002)(6246003)(9686003)(68736007)(6506007)(4326008)(53936002)(102836004)(6916009)(7696005)(26005)(76176011)(86362001)(6116002)(3846002)(53546011)(5660300002)(14444005)(8936002)(81156014)(81166006)(66476007)(66446008)(64756008)(33656002)(66556008)(14454004)(76116006)(73956011)(66946007)(186003)(7736002)(71200400001)(71190400001)(229853002)(1411001)(6436002)(8676002)(256004)(25786009)(486006)(446003)(11346002)(478600001)(476003)(44832011)(52536014)(66066001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5968;H:VI1PR04MB5135.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /IkRLUEgR0OsoZLOkDqYiDDCu4qg0pA5SUcfT+uRQGTlleXrY8Z3kwn2GwCrZ2/amKVbesm6szOQUy+c9k2Ofazpa8ZZkSnuvhapZVkNGYEaUdgB/HHsPT4XMg/O5SEmp/3CBPB/wUb1yC/Zv0vxJZRm/BnMoTqJb7lH8q4MCUQ+ewtKS/rsFyT6Juufxd8X0luVg7w4AxNgI0mCaia9yJ6rRoA5sRi4Nxb3h6Plmh1+KxNQEw3VT1PDYQsr3lp85ppcve+pudCfeocn3nIZQwuwTo3xhijJmqdrxAODdp1LgV9Wjq77EIj2PMmZz9+46QYT6wwKtPgRH3ovBE0//EUBsKv/wY1uzDgXD1lpuZSUYldd5A2J0WKk7o79Z+wqiWbBQnQcqtF4L0Ktp73sN4Xxp0xXhtmuYnSNamN7DdA=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d56291-104d-49ea-3bd7-08d6d3657463
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2019 03:30:01.6371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KVGhhbmsgeW91IGZvciB5b3VyIHJlcGx5Lg0KDQoNCkJyLA0KUG8gTGl1
DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUmljaGFyZCBDb2NocmFu
IFttYWlsdG86cmljaGFyZGNvY2hyYW5AZ21haWwuY29tXQ0KPiBTZW50OiAyMDE5xOo11MI3yNUg
MjE6NTANCj4gVG86IFBvIExpdSA8cG8ubGl1QG54cC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eHBwYy0NCj4gZGV2
QGxpc3RzLm96bGFicy5vcmc7IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsg
WS5iLiBMdQ0KPiA8eWFuZ2JvLmx1QG54cC5jb20+OyBDbGF1ZGl1IE1hbm9pbCA8Y2xhdWRpdS5t
YW5vaWxAbnhwLmNvbT47DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IExlbyBMaSA8bGVveWFuZy5s
aUBueHAuY29tPjsgUm95IFphbmcNCj4gPHJveS56YW5nQG54cC5jb20+OyBNaW5na2FpIEh1IDxt
aW5na2FpLmh1QG54cC5jb20+Ow0KPiBkZWVwYS5rZXJuZWxAZ21haWwuY29tDQo+IFN1YmplY3Q6
IFtFWFRdIFJlOiBbUEFUQ0ggdjFdIHRpbWVyOmNsb2NrOnB0cDogYWRkIHN1cHBvcnQgdGhlIGR5
bmFtaWMgcG9zaXgNCj4gY2xvY2sgYWxhcm0gc2V0IGZvciBwdHANCj4gDQo+IENhdXRpb246IEVY
VCBFbWFpbA0KPiANCj4gT24gU3VuLCBNYXkgMDUsIDIwMTkgYXQgMDU6MDI6MDVBTSArMDAwMCwg
UG8gTGl1IHdyb3RlOg0KPiA+IEN1cnJlbnQga2VybmVsIGNvZGUgZG8gbm90IHN1cHBvcnQgdGhl
IGR5bmFtaWMgcG9zaXggY2xvY2sgYWxhcm0gc2V0Lg0KPiA+IFRoaXMgY29kZSB3b3VsZCBzdXBw
b3J0IGl0IGJ5IHRoZSBwb3NpeCB0aW1lciBzdHJ1Y3R1cmUuDQo+ID4NCj4gPiAzMTkgIGNvbnN0
IHN0cnVjdCBrX2Nsb2NrIGNsb2NrX3Bvc2l4X2R5bmFtaWMgPSB7DQo+ID4NCj4gPiAzMjAgICAg
ICAgICAuY2xvY2tfZ2V0cmVzICAgPSBwY19jbG9ja19nZXRyZXMsDQo+ID4gMzIxICAgICAgICAg
LmNsb2NrX3NldCAgICAgID0gcGNfY2xvY2tfc2V0dGltZSwNCj4gPiAzMjIgICAgICAgICAuY2xv
Y2tfZ2V0ICAgICAgPSBwY19jbG9ja19nZXR0aW1lLA0KPiA+IDMyMyAgICAgICAgIC5jbG9ja19h
ZGogICAgICA9IHBjX2Nsb2NrX2FkanRpbWUsDQo+ID4gMzI0ICsgICAgICAgLnRpbWVyX2NyZWF0
ZSAgID0gcGNfdGltZXJfY3JlYXRlLA0KPiA+IDMyNSArICAgICAgIC50aW1lcl9kZWwgICAgICA9
IHBjX3RpbWVyX2RlbGV0ZSwNCj4gPiAzMjYgKyAgICAgICAudGltZXJfc2V0ICAgICAgPSBwY190
aW1lcl9zZXQsDQo+ID4gMzI3ICsgICAgICAgLnRpbWVyX2FybSAgICAgID0gcGNfdGltZXJfYXJt
LA0KPiA+IH0NCj4gPg0KPiANCj4gU29ycnksIE5BSywgc2luY2Ugd2UgZGVjaWRlZCBzb21lIHRp
bWUgYWdvIG5vdCB0byBzdXBwb3J0IHRpbWVyXyogb3BlcmF0aW9ucw0KPiBvbiBkeW5hbWljIGNs
b2Nrcy4gIFlvdSBnZXQgbXVjaCBiZXR0ZXIgYXBwbGljYXRpb24gbGV2ZWwgdGltZXIgcGVyZm9y
bWFuY2UNCj4gYnkgc3luY2hyb25pemluZyBDTE9DS19SRUFMVElNRSB0byB5b3VyIFBIQyBhbmQg
dXNpbmcgY2xvY2tfbmFub3NsZWVwKCkNCj4gd2l0aCBDTE9DS19SRUFMVElNRSBvciBDTE9DS19N
T05PVE9OSUMuDQoNClRoZSBjb2RlIGludGVuZCB0byBnZXQgYWxhcm0gYnkgaW50ZXJydXB0IG9m
IHB0cCBoYXJkd2FyZS4gVGhlIGNvZGUgdG8gZml4IHB0cCBub3Qgc3VwcG9ydCB0byBhcHBsaWNh
dGlvbiBsYXllciB0byBnZXQgdGhlIGFsYXJtIGludGVycnVwdC4gDQpEbyB5b3UgbWVhbiB0aGUg
c3luY2hyb25pemluZyBhdCBhcHBsaWNhdGlvbiBsYXllciBieSBQSEMgKHVzaW5nIGNsb2NrX25h
bm9zbGVlcCgpKSB0byB0aGUgQ0xPQ0tfUkVBTFRJTUUgc291cmNlPyBUaGVuIHRoZSBrZXJuZWwg
Y291bGQgdXNpbmcgdGhlIGhydGltZXIgd2l0aCBDTE9DS19SRUFMVElNRT8NCg0KPiANCj4gPiBU
aGlzIHdvbid0IGNoYW5nZSB0aGUgdXNlciBzcGFjZSBzeXN0ZW0gY2FsbCBjb2RlLiBOb3JtYWxs
eSB0aGUgdXNlcg0KPiA+IHNwYWNlIHNldCBhbGFybSBieSB0aW1lcl9jcmVhdGUoKSBhbmQgdGlt
ZXJfc2V0dGltZSgpLiBSZWZlcmVuY2UgY29kZQ0KPiA+IGFyZSB0b29scy90ZXN0aW5nL3NlbGZ0
ZXN0cy9wdHAvdGVzdHB0cC5jLg0KPiANCj4gVGhhdCBwcm9ncmFtIHN0aWxsIGhhcyBtaXNsZWFk
aW5nIGV4YW1wbGVzLiAgU29ycnkgYWJvdXQgdGhhdC4gIEknbGwgc3VibWl0IGENCj4gcGF0Y2gg
dG8gcmVtb3ZlIHRoZW0uDQoNCklzIHRoZXJlIGFueSByZXBsYWNlIG1ldGhvZCBmb3IgYW4gYXBw
bGljYXRpb24gY29kZSB0byBnZXQgYWxhcm0gaW50ZXJydXB0IGJ5IHRoZSBwdHAgc291cmNlPw0K
DQo+IA0KPiA+ICtzdGF0aWMgaW50IHBjX3RpbWVyX2NyZWF0ZShzdHJ1Y3Qga19pdGltZXIgKm5l
d190aW1lcikgew0KPiA+ICsgICAgIHJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiANCj4gVGhp
cyBvZiBjb3Vyc2Ugd291bGQgbmV2ZXIgd29yay4gIENvbnNpZGVyIHdoYXQgaGFwcGVucyB3aGVu
IHR3byBvciBtb3JlDQo+IHRpbWVycyBhcmUgY3JlYXRlZCBhbmQgYXJtZWQuDQo+IA0KPiBUaGFu
a3MsDQo+IFJpY2hhcmQNCg==
