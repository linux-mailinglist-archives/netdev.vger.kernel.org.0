Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993821AF62C
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 03:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgDSBo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 21:44:29 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:36224
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725827AbgDSBo3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 21:44:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHofekkoMGKOTZ6JefAIb60KjP/vpQ4VBFGOwazA/sBlZvoOpXQ3ut66atp+opG5rauKdvNeUSCIzJslO6QZNDH7YM2YyMJBZeJ8KxdwAbp3wE6uW+cDP9CzF/7wiMgDve3Oaf38fnIe1MEIvil8wAlL+CUPurEvptXm5CLM9T3fWUo3RmjP4FN25BLM2fe0qcl9TtCqLhgWkudO2kR9K+CnaCm3hBzGWa/y4dwmVutkJzKpyJvQIE3Y8P31anNZQQUYxjUEejbtc2fieu8XaxeqsddrVOk14ZiLlD/fttpWel2rGJL9fcUVdKSsZb/JACDhhIX40Un/QRuSDv+W/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYeRznyVUIYSt1fpd2giWqwLI1IHxJoto2tkllQL+lw=;
 b=ih7clw9VzDmcNySsS9BAMZv0+yy9bVTyj46TWBNh+WqWFxlRLuMy6Pmqmwo9rlKQ5Dm4qnDNIRsKL1uf3T24B1Rl+WXE1D0TbLMoEb281eXqnUieSyzq4lZVrG/k9KSrTldGOdbjA12Ih9ocbHFydapvfMk/WLDEtx6BNpPTO9rsCRwXKupx5KugkBYN/VwY5JpnfiPotIy7XUxOv9Ozy4xNIKbaxLgD4HZbcBhMJLkEfTgShU9vRsN4pjizqQnXzGWqh68vUZTX/GWgmje4eUtukIHJBk8ZhKf6EWEK0umX2SCWZOk/9ObxADfGSuYKNEwj2Z7KGEe55EcaxpzJsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYeRznyVUIYSt1fpd2giWqwLI1IHxJoto2tkllQL+lw=;
 b=jVbsDgWb14lU5MIAQRwE4ij5I7Joyn4Dcf5my3+Mqo35RmWJl1baZiuoEjjC1BAxxbQCaW2DReQ+/qNipjN+OXxjjWHW7jW/ZicpVy8zMSNdmekhf62l3F/yNu4j6PAx3oIiXBltgltf0O8OW3kZJHjh+IhK0SCvLheyv4z1W5M=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6477.eurprd04.prod.outlook.com (2603:10a6:803:11e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Sun, 19 Apr
 2020 01:44:23 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2921.027; Sun, 19 Apr 2020
 01:44:23 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: RE: [EXT] Re: [ v2,net-next 4/4] net: enetc: add tc flower psfp
 offload driver
Thread-Topic: [EXT] Re: [ v2,net-next 4/4] net: enetc: add tc flower psfp
 offload driver
Thread-Index: AQHWFdQjjjOzBJ3ZKUu+BTpR17zoMah/p7vQ
Date:   Sun, 19 Apr 2020 01:44:23 +0000
Message-ID: <VE1PR04MB6496BF61F5C899351174E82A92D70@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200324034745.30979-8-Po.Liu@nxp.com>
 <20200418011211.31725-1-Po.Liu@nxp.com>
 <20200418011211.31725-5-Po.Liu@nxp.com>
 <CA+h21hqwtg5zYfiZmFb0Bmq5_oUwJO9wZDr+N5D_8=nrHhjjNg@mail.gmail.com>
In-Reply-To: <CA+h21hqwtg5zYfiZmFb0Bmq5_oUwJO9wZDr+N5D_8=nrHhjjNg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [114.244.47.43]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c4f8de47-be85-421d-afdd-08d7e4032fde
x-ms-traffictypediagnostic: VE1PR04MB6477:|VE1PR04MB6477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6477951D8727D7FEB5BD03BB92D70@VE1PR04MB6477.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0378F1E47A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(81156014)(54906003)(8936002)(86362001)(8676002)(7416002)(7696005)(5660300002)(71200400001)(53546011)(6506007)(316002)(33656002)(2906002)(44832011)(52536014)(6916009)(26005)(55016002)(4326008)(9686003)(66946007)(66476007)(66556008)(64756008)(478600001)(76116006)(66446008)(186003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2sOLgF4CqkVXpyQtNcKkP+5cjYwWFV/ehuRxvJeod0jGxKQjj0LiHyTS+Kk+OGq+L/lE6NfR/0WnyopTwtsEKpDaJ3GFprqmRsYxME8At1mpyamEonOamf8eqe21J4NqIzan3f5KNq5wcf9IfvC8mPUg2zmTuZYx2Ek9ycpMHwfq6fdOCHlUXMJxZrgobKTa5Ri20O8F4NNDLQazDvoe2PbfkyMKZ8L8KDyMZQZ7WycnVp4etRVJvdY+GGkcQvsjdfC2OEER4b1xIGjdqh+7KbwpCg3ZN/6IwHRi47bof3Ghd+EfRHcldEAPytWWEiGGrxQniNnqqh2IqF6qcSVHGKQsDZS1AdGrfRAH7IikAdHkULou6hjQiMAr+AsUQREkYsI6v3iQq8y0gMbmACXjIzMM/wXS6m5WAY5ih81mUVICMkbXqRN+zcHuwKxDtzZU
x-ms-exchange-antispam-messagedata: Gz1XYHRWQ/V/qoCEXC69luRsK+EihZfmOdlP/ktv1uM1611pmnxlQdHNtB6bRggovtnNaWyw7jNIo74ZB3+Z5XhlaSP7RTddxrTkwaiLRtbIcT4ILEBwS5GLigzhL9n32rDaBDiyYocMJlA/+E6jKQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4f8de47-be85-421d-afdd-08d7e4032fde
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2020 01:44:23.4193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CGXKdX7OO/4b/8SsvuPDWDGy7XEM+IGLEfsxvaLKPCN/JkhvCxhOR8n0RqeVX47Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6477
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVmxh
ZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMOW5tDTmnIgxOeaX
pSA2OjUzDQo+IFRvOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPg0KPiBDYzogRGF2aWQgUy4gTWls
bGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgbGttbCA8bGludXgtDQo+IGtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc+OyBuZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBWaW5pY2l1cyBDb3N0
YQ0KPiBHb21lcyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsgQ2xhdWRpdSBNYW5vaWwNCj4g
PGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVh
bkBueHAuY29tPjsNCj4gQWxleGFuZHJ1IE1hcmdpbmVhbiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBu
eHAuY29tPjsNCj4gbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTsgdmlzaGFsQGNoZWxzaW8uY29t
Ow0KPiBzYWVlZG1AbWVsbGFub3guY29tOyBsZW9uQGtlcm5lbC5vcmc7IEppcmkgUGlya28gPGpp
cmlAbWVsbGFub3guY29tPjsNCj4gSWRvIFNjaGltbWVsIDxpZG9zY2hAbWVsbGFub3guY29tPjsg
QWxleGFuZHJlIEJlbGxvbmkNCj4gPGFsZXhhbmRyZS5iZWxsb25pQGJvb3RsaW4uY29tPjsgTWlj
cm9jaGlwIExpbnV4IERyaXZlciBTdXBwb3J0DQo+IDxVTkdMaW51eERyaXZlckBtaWNyb2NoaXAu
Y29tPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47DQo+IEphbWFsIEhhZGkgU2Fs
aW0gPGpoc0Btb2phdGF0dS5jb20+OyBDb25nIFdhbmcNCj4gPHhpeW91Lndhbmdjb25nQGdtYWls
LmNvbT47IHNpbW9uLmhvcm1hbkBuZXRyb25vbWUuY29tOw0KPiBwYWJsb0BuZXRmaWx0ZXIub3Jn
OyBtb3NoZUBtZWxsYW5veC5jb207IE11cmFsaSBLYXJpY2hlcmkgPG0tDQo+IGthcmljaGVyaTJA
dGkuY29tPjsgQW5kcmUgR3VlZGVzIDxhbmRyZS5ndWVkZXNAbGludXguaW50ZWwuY29tPjsNCj4g
U3RlcGhlbiBIZW1taW5nZXIgPHN0ZXBoZW5AbmV0d29ya3BsdW1iZXIub3JnPg0KPiBTdWJqZWN0
OiBbRVhUXSBSZTogWyB2MixuZXQtbmV4dCA0LzRdIG5ldDogZW5ldGM6IGFkZCB0YyBmbG93ZXIg
cHNmcCBvZmZsb2FkDQo+IGRyaXZlcg0KPiANCj4gQ2F1dGlvbjogRVhUIEVtYWlsDQo+IA0KPiBI
aSBQbywNCj4gDQo+IE9uIFNhdCwgMTggQXByIDIwMjAgYXQgMDQ6MzUsIFBvIExpdSA8UG8uTGl1
QG54cC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gKyAgICAgICBpZiAoZmxvd19ydWxlX21hdGNoX2tl
eShydWxlLCBGTE9XX0RJU1NFQ1RPUl9LRVlfRVRIX0FERFJTKSkNCj4gew0KPiA+ICsgICAgICAg
ICAgICAgICBzdHJ1Y3QgZmxvd19tYXRjaF9ldGhfYWRkcnMgbWF0Y2g7DQo+ID4gKw0KPiA+ICsg
ICAgICAgICAgICAgICBmbG93X3J1bGVfbWF0Y2hfZXRoX2FkZHJzKHJ1bGUsICZtYXRjaCk7DQo+
ID4gKw0KPiA+ICsgICAgICAgICAgICAgICBpZiAoIWlzX3plcm9fZXRoZXJfYWRkcihtYXRjaC5t
YXNrLT5kc3QpKSB7DQo+IA0KPiBEb2VzIEVORVRDIHN1cHBvcnQgbWFza2VkIG1hdGNoaW5nIG9u
IE1BQyBhZGRyZXNzPyBJZiBub3QsIHlvdSBzaG91bGQNCj4gZXJyb3Igb3V0IGlmIHRoZSBtYXNr
IGlzIG5vdCBmZjpmZjpmZjpmZjpmZjpmZi4NCg0KSSBnZXQgaXQuIFRoYW5rcy4NCg0KPiANCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICBldGhlcl9hZGRyX2NvcHkoZmlsdGVyLT5zaWQuZHN0
X21hYywgbWF0Y2gua2V5LT5kc3QpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGZpbHRl
ci0+c2lkLmZpbHRlcnR5cGUgPSBTVFJFQU1JRF9UWVBFX05VTEw7DQo+ID4gKyAgICAgICAgICAg
ICAgIH0NCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAgIGlmICghaXNfemVyb19ldGhlcl9hZGRy
KG1hdGNoLm1hc2stPnNyYykpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBldGhlcl9h
ZGRyX2NvcHkoZmlsdGVyLT5zaWQuc3JjX21hYywgbWF0Y2gua2V5LT5zcmMpOw0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgIGZpbHRlci0+c2lkLmZpbHRlcnR5cGUgPSBTVFJFQU1JRF9UWVBF
X1NNQUM7DQo+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiArICAgICAgIH0gZWxzZSB7DQo+ID4g
KyAgICAgICAgICAgICAgIE5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssICJVbnN1cHBvcnRlZCwg
bXVzdA0KPiBFVEhfQUREUlMiKTsNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7
DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKGZsb3dfcnVsZV9tYXRjaF9r
ZXkocnVsZSwgRkxPV19ESVNTRUNUT1JfS0VZX1ZMQU4pKSB7DQo+ID4gKyAgICAgICAgICAgICAg
IHN0cnVjdCBmbG93X21hdGNoX3ZsYW4gbWF0Y2g7DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAg
ICBmbG93X3J1bGVfbWF0Y2hfdmxhbihydWxlLCAmbWF0Y2gpOw0KPiA+ICsgICAgICAgICAgICAg
ICBpZiAobWF0Y2gubWFzay0+dmxhbl9wcmlvcml0eSkgew0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgIGlmIChtYXRjaC5tYXNrLT52bGFuX3ByaW9yaXR5ICE9DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgIChWTEFOX1BSSU9fTUFTSyA+PiBWTEFOX1BSSU9fU0hJRlQpKSB7DQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBOTF9TRVRfRVJSX01TR19NT0QoZXh0
YWNrLCAiT25seSBmdWxsIG1hc2sgaXMNCj4gc3VwcG9ydGVkIGZvciBWTEFOIHByaW9yaXR5Iik7
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBlcnIgPSAtRUlOVkFMOw0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ290byBmcmVlX2ZpbHRlcjsNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICB9DQo+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiArDQo+
ID4gKyAgICAgICAgICAgICAgIGlmIChtYXRjaC5tYXNrLT52bGFuX3RwaWQpIHsNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICBpZiAobWF0Y2gubWFzay0+dmxhbl90cGlkICE9IFZMQU5fVklE
X01BU0spIHsNCj4gDQo+IEknbSBwcmV0dHkgc3VyZSB0aGF0IHZsYW5fdHBpZCBpcyB0aGUgRXRo
ZXJUeXBlICgweDgxMDAsIGV0YyksIGFuZA0KPiB0aGF0IHlvdSBhY3R1YWxseSBtZWFudCB2bGFu
X2lkLg0KPiANCg0KWWVzLCBJJ2xsIGNvcnJlY3QgaXQuDQoNCj4gPiAtLQ0KPiA+IDIuMTcuMQ0K
PiA+DQo+IA0KPiBUaGFua3MsDQo+IC1WbGFkaW1pcg0KDQpCciwNClBvIExpdQ0K
