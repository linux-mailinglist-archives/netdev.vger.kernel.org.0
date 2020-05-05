Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DE01C51E2
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 11:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgEEJ0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 05:26:36 -0400
Received: from mail-eopbgr30047.outbound.protection.outlook.com ([40.107.3.47]:31047
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgEEJ0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 05:26:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMykDqJ1AQkhOzQgAj/Wfrj0yvW1Rk7GpLivtdZvJnqw0L52HdeALdM+wv+P0LfmAJJKqkgGDnTpa11PUMVRdOr8C7hrxrAu6pQDdKmz+VDW7ZA+LONEDXV0x1cu54pu9TA9x0rUe3ePMVtHhrSbDl+gIR+S1dMZhAbDssUeS9Y8TQ6uQQ3sFEKuHqOUhS9ZBi1VoxUZxQObzpeUevx3DBUzs/hShMA0x8JDFyq06Q4tHHykfmDXsV748f5Tq1XilYilv9noLhH4DNNEjHKGT++tMMakfXqjyi7UKe+wdI3A6yZaZBLi3hNaCclUIbsqERCex0wZ26CKb+cBaNZYdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6Zg8YerXipU9JTYp8s4fFbsSIW3G6d2sgubmAZwNKs=;
 b=a5IAkC4VfZ5hRxJkyCim/F7nQOEFA8ozSeWAXcxApAXaCrsJ7IWH3MNBXZQYAE/xDdGNXADaJcBI58ORn1GwM4TIviVanwysIBi9MvF9qB5XiVNkDw2/21SCq6JYL6zngaG6hOpXdDaB5QXHnkEpOdsrL/KqiFVsBF/jKlSi+zKpNRSrxOD3QFOijeWHtv1Q1gJiG3X6EyEMoAW9az0l8QIz27GXiNVPkvHY43Q/EH0ZNl+SiSYFIhBZmAsTsDL3XAJI6o13N1ddDWuCBDN8eKjdGx80Uoh5R76CO5GcqCo5ZFieJIxi4xTV2CEzuMyjv1J2V/3+p3i19/Kpf0NtHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6Zg8YerXipU9JTYp8s4fFbsSIW3G6d2sgubmAZwNKs=;
 b=KOh/XwaS8zAb+Ww/lBAcd9DoHyRSVMXKDOKxamEEIIwn49DUM0BtX2bfM2bspS9/vPf+hhOCwoKu9F3XxfTGaiAxzhWAGoNIi5jZjudPNCi3RWh8pHXVuGWkvzPN8287l3+tq/VxoDE+vnIOBLOBc7fpt1C0TjOHNo3q8KCN+WI=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6463.eurprd04.prod.outlook.com (2603:10a6:803:11d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Tue, 5 May
 2020 09:26:29 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 09:26:29 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>
Subject: RE:  Re: [v3,iproute2 1/2] iproute2:tc:action: add a gate control
 action
Thread-Topic: Re: [v3,iproute2 1/2] iproute2:tc:action: add a gate control
 action
Thread-Index: AdYivuDXOLwhNrRiQWy2fxkcEUd6qw==
Date:   Tue, 5 May 2020 09:26:29 +0000
Message-ID: <VE1PR04MB649614F66A0C4EF22063A37492A70@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7b448146-e53f-4159-9ec2-08d7f0d66458
x-ms-traffictypediagnostic: VE1PR04MB6463:|VE1PR04MB6463:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6463E45069EB65412E056F8592A70@VE1PR04MB6463.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0394259C80
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EtGpWQp2W86d+HxSbksWFk03SWCHvSORYjq05o0cPVZYcDjY0s+nnaJYzkaj/XMjIgBPvb6Xnk11kch43MLCUzhstlzddrDEXumPNjvDQRy4IN77ahPv4vxHRDMZs7G1N0XgZvVOBIlEZBr0UaWLmlOdGoivscyAqpN4Ift+fSlMvT0tSIrQ+jJEFZGiTlAvRalre/5bdwLO4xpDGT/Xp9gmHrxMowwA9p9fpFoy4cyfBk+6E/PNDBtQGs5x8Z7gxQfhmT4jV8KUxd+EO+4BS6oobDu7mAHuKo55Q9vHCrYs+vbWE4wClm3jlHbbSBeu+D3ozkZAayUXNNBoEUkRRSPrLCFyaKyuoTZcbIjNQTz5WSsvikSdq7AlitmaOG9EPOW4x6yr3N3EOjbvEHYDA2tnQ9Re1j9oQEnltoctQsJSRXaaQZH130WCILP3XXvJU9xhdqjsF1MGgf/m/mMGW6KvhItEP5BfBtBURnlLYP5swDwPWKEWEbhVka/gEk4T43j3YDZblPUwj4/A750IeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(33430700001)(2906002)(55016002)(33656002)(9686003)(316002)(33440700001)(86362001)(54906003)(110136005)(71200400001)(8676002)(76116006)(8936002)(26005)(186003)(44832011)(52536014)(478600001)(66476007)(64756008)(66446008)(66556008)(7416002)(66946007)(6506007)(4326008)(53546011)(5660300002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 24mnihZuurNKN39ATNjOvCR7SuXXAQAIKUgkFuI6vdsnpNwfSVRjW6NL6bXc7/+g6ndfRNKjYynzkuMvs13/ViwC6e1voRfQYdHzNYvXQhzGTYgHfABNn7DctYsTloSISWN/qrgn42+9K8jX6toGaX0wOQn2g0y0xeRdMJjsZUwahb2tppvt56diooOnyo6kClajMgVP4Gwwq5CQBlbfw1RNn+5Jtz7i0MPbArJAgPEDpYneaQV6ck8xqF30+UybJ+Ib96e+za9CW2O+WEr2scLvymIylrGHSP2BydJaIzIHEHj+A+lxBzCuzOdgftbqlGxYrIZ0IwTOIIdRXJ/LBMKTDgWUQ7n77xEDBJP5+kxyimt6cMKHzhMb0354XCzA5QV47IF9Xgu0qyVtRhaqw+XAvd3VxyQlPqbqBGWg4/vcYoMikkQi5vWx6p6EAoXduAKflSz4CFbsVZUbYvjx+BcTEfgAXZmCtA9yJib3enS3myvAY6KZeO5yRgB/yjpIgAksAE8k9H35EsO8hF18D2HVbdxLIM+7wv7vNUR361OZTs7kWN8SBHbone8YiRkcOOYIVqtyguoyd5yUqUt1wEjiRAKkHJ6fEtWmrSVTlvAQ3m69dWF/zjOVo9kI7wfB8CEmJUryoVHWsRUj4OCA01caxban4NRUabdq6ME4XER0C0P/nMSv7cm+RBd0Pf+XnMq7bRai92svFZzk1C2luQGkq/HnORA7UUK7nmMq7dyhPPUmRWZnBwE5pDeAmkBTMBm7u1N5fZQvW76EVuf9qrJsq0PlC6h/W0e89prRnB8=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b448146-e53f-4159-9ec2-08d7f0d66458
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2020 09:26:29.1722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hbtk9sdv6sJQ1edZBR32Mqvh4kXE/hgVYkDTsf2EFvAN/CoHoYozgW7hunTBnOrq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6463
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RlcGhlbiwgIERhdmlkLA0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4g
RnJvbTogU3RlcGhlbiBIZW1taW5nZXIgPHN0ZXBoZW5AbmV0d29ya3BsdW1iZXIub3JnPg0KPiBT
ZW50OiAyMDIwxOo11MI1yNUgODowNQ0KPiBUbzogUG8gTGl1IDxwby5saXVAbnhwLmNvbT4NCj4g
Q2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHZpbmljaXVzLmdvbWVzQGludGVsLmNvbTsgdmxhZEBi
dXNsb3YuZGV2Ow0KPiBDbGF1ZGl1IE1hbm9pbCA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNvbT47IFZs
YWRpbWlyIE9sdGVhbg0KPiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+OyBBbGV4YW5kcnUgTWFy
Z2luZWFuDQo+IDxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5jb20+OyBtaWNoYWVsLmNoYW5AYnJv
YWRjb20uY29tOw0KPiB2aXNoYWxAY2hlbHNpby5jb207IHNhZWVkbUBtZWxsYW5veC5jb207IGxl
b25Aa2VybmVsLm9yZzsNCj4gamlyaUBtZWxsYW5veC5jb207IGlkb3NjaEBtZWxsYW5veC5jb207
DQo+IGFsZXhhbmRyZS5iZWxsb25pQGJvb3RsaW4uY29tOyBVTkdMaW51eERyaXZlckBtaWNyb2No
aXAuY29tOw0KPiBrdWJhQGtlcm5lbC5vcmc7IHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbTsNCj4g
c2ltb24uaG9ybWFuQG5ldHJvbm9tZS5jb207IHBhYmxvQG5ldGZpbHRlci5vcmc7DQo+IG1vc2hl
QG1lbGxhbm94LmNvbTsgbS1rYXJpY2hlcmkyQHRpLmNvbTsNCj4gYW5kcmUuZ3VlZGVzQGxpbnV4
LmludGVsLmNvbQ0KPiBTdWJqZWN0OiBbRVhUXSBSZTogW3YzLGlwcm91dGUyIDEvMl0gaXByb3V0
ZTI6dGM6YWN0aW9uOiBhZGQgYSBnYXRlIGNvbnRyb2wNCj4gYWN0aW9uDQo+IA0KPiBPbiBTdW4s
ICAzIE1heSAyMDIwIDE0OjMyOjUwICswODAwDQo+IFBvIExpdSA8UG8uTGl1QG54cC5jb20+IHdy
b3RlOg0KPiANCj4gPiBJbnRyb2R1Y2UgYSBpbmdyZXNzIGZyYW1lIGdhdGUgY29udHJvbCBmbG93
IGFjdGlvbi4NCj4gPiBUYyBnYXRlIGFjdGlvbiBkb2VzIHRoZSB3b3JrIGxpa2UgdGhpczoNCj4g
PiBBc3N1bWUgdGhlcmUgaXMgYSBnYXRlIGFsbG93IHNwZWNpZmllZCBpbmdyZXNzIGZyYW1lcyBj
YW4gcGFzcyBhdA0KPiA+IHNwZWNpZmljIHRpbWUgc2xvdCwgYW5kIGFsc28gZHJvcCBhdCBzcGVj
aWZpYyB0aW1lIHNsb3QuIFRjIGZpbHRlcg0KPiA+IGNob29zZXMgdGhlIGluZ3Jlc3MgZnJhbWVz
LCBhbmQgdGMgZ2F0ZSBhY3Rpb24gd291bGQgc3BlY2lmeSB3aGF0IHNsb3QNCj4gPiBkb2VzIHRo
ZXNlIGZyYW1lcyBjYW4gYmUgcGFzc2VkIHRvIGRldmljZSBhbmQgd2hhdCB0aW1lIHNsb3Qgd291
bGQgYmUNCj4gPiBkcm9wcGVkLg0KPiA+IFRjIGdhdGUgYWN0aW9uIHdvdWxkIHByb3ZpZGUgYW4g
ZW50cnkgbGlzdCB0byB0ZWxsIGhvdyBtdWNoIHRpbWUgZ2F0ZQ0KPiA+IGtlZXAgb3BlbiBhbmQg
aG93IG11Y2ggdGltZSBnYXRlIGtlZXAgc3RhdGUgY2xvc2UuIEdhdGUgYWN0aW9uIGFsc28NCj4g
PiBhc3NpZ24gYSBzdGFydCB0aW1lIHRvIHRlbGwgd2hlbiB0aGUgZW50cnkgbGlzdCBzdGFydC4g
VGhlbiBkcml2ZXINCj4gPiB3b3VsZCByZXBlYXQgdGhlIGdhdGUgZW50cnkgbGlzdCBjeWNsaWNh
bGx5Lg0KPiA+IEZvciB0aGUgc29mdHdhcmUgc2ltdWxhdGlvbiwgZ2F0ZSBhY3Rpb24gcmVxdWly
ZSB0aGUgdXNlciBhc3NpZ24gYQ0KPiA+IHRpbWUgY2xvY2sgdHlwZS4NCj4gPg0KPiA+IEJlbG93
IGlzIHRoZSBzZXR0aW5nIGV4YW1wbGUgaW4gdXNlciBzcGFjZS4gVGMgZmlsdGVyIGEgc3RyZWFt
IHNvdXJjZQ0KPiA+IGlwIGFkZHJlc3MgaXMgMTkyLjE2OC4wLjIwIGFuZCBnYXRlIGFjdGlvbiBv
d24gdHdvIHRpbWUgc2xvdHMuIE9uZSBpcw0KPiA+IGxhc3QgMjAwbXMgZ2F0ZSBvcGVuIGxldCBm
cmFtZSBwYXNzIGFub3RoZXIgaXMgbGFzdCAxMDBtcyBnYXRlIGNsb3NlDQo+ID4gbGV0IGZyYW1l
cyBkcm9wcGVkLg0KPiA+DQo+ID4gICMgdGMgcWRpc2MgYWRkIGRldiBldGgwIGluZ3Jlc3MNCj4g
PiAgIyB0YyBmaWx0ZXIgYWRkIGRldiBldGgwIHBhcmVudCBmZmZmOiBwcm90b2NvbCBpcCBcDQo+
ID4NCj4gPiAgICAgICAgICAgICBmbG93ZXIgc3JjX2lwIDE5Mi4xNjguMC4yMCBcDQo+ID4gICAg
ICAgICAgICAgYWN0aW9uIGdhdGUgaW5kZXggMiBjbG9ja2lkIENMT0NLX1RBSSBcDQo+ID4gICAg
ICAgICAgICAgc2NoZWQtZW50cnkgb3BlbiAyMDAwMDAwMDAgLTEgLTEgXA0KPiA+ICAgICAgICAg
ICAgIHNjaGVkLWVudHJ5IGNsb3NlIDEwMDAwMDAwMA0KPiA+DQo+ID4gICMgdGMgY2hhaW4gZGVs
IGRldiBldGgwIGluZ3Jlc3MgY2hhaW4gMA0KPiA+DQo+ID4gInNjaGVkLWVudHJ5IiBmb2xsb3cg
dGhlIG5hbWUgdGFwcmlvIHN0eWxlLiBHYXRlIHN0YXRlIGlzDQo+ID4gIm9wZW4iLyJjbG9zZSIu
IEZvbGxvdyB0aGUgcGVyaW9kIG5hbm9zZWNvbmQuIFRoZW4gbmV4dCAtMSBpcyBpbnRlcm5hbA0K
PiA+IHByaW9yaXR5IHZhbHVlIG1lYW5zIHdoaWNoIGluZ3Jlc3MgcXVldWUgc2hvdWxkIHB1dCB0
by4gIi0xIiBtZWFucw0KPiA+IHdpbGRjYXJkLiBUaGUgbGFzdCB2YWx1ZSBvcHRpb25hbCBzcGVj
aWZpZXMgdGhlIG1heGltdW0gbnVtYmVyIG9mDQo+IE1TRFUNCj4gPiBvY3RldHMgdGhhdCBhcmUg
cGVybWl0dGVkIHRvIHBhc3MgdGhlIGdhdGUgZHVyaW5nIHRoZSBzcGVjaWZpZWQgdGltZQ0KPiA+
IGludGVydmFsLg0KPiA+DQo+ID4gQmVsb3cgZXhhbXBsZSBzaG93cyBmaWx0ZXJpbmcgYSBzdHJl
YW0gd2l0aCBkZXN0aW5hdGlvbiBtYWMgYWRkcmVzcyBpcw0KPiA+IDEwOjAwOjgwOjAwOjAwOjAw
IGFuZCBpcCB0eXBlIGlzIElDTVAsIGZvbGxvdyB0aGUgYWN0aW9uIGdhdGUuIFRoZQ0KPiA+IGdh
dGUgYWN0aW9uIHdvdWxkIHJ1biB3aXRoIG9uZSBjbG9zZSB0aW1lIHNsb3Qgd2hpY2ggbWVhbnMg
YWx3YXlzIGtlZXANCj4gY2xvc2UuDQo+ID4gVGhlIHRpbWUgY3ljbGUgaXMgdG90YWwgMjAwMDAw
MDAwbnMuIFRoZSBiYXNlLXRpbWUgd291bGQgY2FsY3VsYXRlIGJ5Og0KPiA+DQo+ID4gICAgICAx
MzU3MDAwMDAwMDAwICsgKE4gKyAxKSAqIGN5Y2xldGltZQ0KPiA+DQo+ID4gV2hlbiB0aGUgdG90
YWwgdmFsdWUgaXMgdGhlIGZ1dHVyZSB0aW1lLCBpdCB3aWxsIGJlIHRoZSBzdGFydCB0aW1lLg0K
PiA+IFRoZSBjeWNsZXRpbWUgaGVyZSB3b3VsZCBiZSAyMDAwMDAwMDBucyBmb3IgdGhpcyBjYXNl
Lg0KPiA+DQo+ID4gICN0YyBmaWx0ZXIgYWRkIGRldiBldGgwIHBhcmVudCBmZmZmOiAgcHJvdG9j
b2wgaXAgXA0KPiA+ICAgICAgICAgICAgZmxvd2VyIHNraXBfaHcgaXBfcHJvdG8gaWNtcCBkc3Rf
bWFjIDEwOjAwOjgwOjAwOjAwOjAwIFwNCj4gPiAgICAgICAgICAgIGFjdGlvbiBnYXRlIGluZGV4
IDEyIGJhc2UtdGltZSAxMzU3MDAwMDAwMDAwIFwNCj4gPiAgICAgICAgICAgIHNjaGVkLWVudHJ5
IENMT1NFIDIwMDAwMDAwMCBcDQo+ID4gICAgICAgICAgICBjbG9ja2lkIENMT0NLX1RBSQ0KPiA+
DQo+ID4gU2lnbmVkLW9mZi1ieTogUG8gTGl1IDxQby5MaXVAbnhwLmNvbT4NCj4gDQo+IFRoZXNl
IGNoYW5nZXMgYXJlIHNwZWNpZmljIHRvIG5ldC1uZXh0IHNob3VsZCBiZSBhc3NpZ25lZCB0byBp
cHJvdXRlMi1uZXh0Lg0KPiBXaWxsIGNoYW5nZSBkZWxlZ2F0aW9uLg0KDQpJIHdvdWxkIHB1c2gg
cmVxdWVzdCBzcGVjaWZpYyBuYW1lIHdpdGggaXByb3V0ZTItbmV4dCBmb3IgdmVyc2lvbiA0LiBU
aGFua3MhDQoNClRoYW5rcyBhIGxvdCENCg0KQnIsDQpQbyBMaXUNCg0KDQo=
