Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89713183FC9
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 04:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgCMDrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 23:47:32 -0400
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:17893
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgCMDrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 23:47:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZRDIcTSi80wZWAxgNaOD7jnMLCqxkLOu5/hiulH8o1rpoqZW6sOemSapj0sqpCmgIdWHVhzeVCtmrT8A/h7rx8MxvsghktFNPudGhd8MeiywutD0aFX/NyHJnfDP4CRS4p6TJz4rzuutwmV7n2WgY/PaVIP4Kpuu7aIyicsG5SPOldQbhoFBPxrqz/GAN66maKEPBaV+OZprH5W7+XZ015t6GjZGe0he90Vpq03xSpJRMDPVP7pheceNwfHEZbFY6Znr1c9U1L3eLwIv0GHmFmXP5s+lBrN5zZuRG/Kk2QZINw6WNVUi9tvb6zalYIHmWKqrs/8vcRzNwq8//at5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sHCWz0i9jbEroBPilUbnUd+OLSYhZoxF1ANQy5AC88=;
 b=RH1j012g8GAGX5qDsDsSHHJ+/hEL8ceYd7zfhirn6bukwKceboY0yKuBfNXxbfvK1ExY1PSXyQaBMoTrjgGQNb2zcQ0Q4kIrNbVTLTViJOwmi8YvKyrx+aOpiLgFimfAg6/G/M/DWglyEV0tbUl2bHtPv+SkZtIqnPe5q5awXSRuSFmJPc6rRw/pGOqnfM0MLc7GGVoLqVIVeaD1ircYjsyUbTbLcv+W41d/lEi4NifFEFgFshx8phaaHpFhvvb8ZnQ4ra1+xrHPan+Jzi8mcWeKZvpbx0W2fgNZNDFwYvv2vyl6n1YZeH9uR7TpwTVp3goTkMHSnIsVYQjOmlakfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sHCWz0i9jbEroBPilUbnUd+OLSYhZoxF1ANQy5AC88=;
 b=flgPGqXcv6kJPYvD9+nBH102JONoqIaYLcU2hhWY9b/eujpD6rOfsBe2TrVZiSNgWeoeLKUdWiV6omx++Fyc412X2ttJqj1TP6FaiNo4yUDfdy7IurXUZ9ojz6F8ESBKwujBL5QIG7WWrveOf39bt+Ixf0q4XTsXwvRKaUzPKnE=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6655.eurprd04.prod.outlook.com (20.179.232.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Fri, 13 Mar 2020 03:47:25 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 03:47:25 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "john.hurley@netronome.com" <john.hurley@netronome.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>
Subject: RE: [EXT] Re: [RFC,net-next  2/9] net: qos: introduce a gate control
 flow action
Thread-Topic: [EXT] Re: [RFC,net-next  2/9] net: qos: introduce a gate control
 flow action
Thread-Index: AQHV87k3gR0PIY1RlEuDZub3eMl0sKhFj56AgABQnhA=
Date:   Fri, 13 Mar 2020 03:47:25 +0000
Message-ID: <VE1PR04MB6496FB9C6C6DC9794826B37092FA0@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
 <20200306125608.11717-3-Po.Liu@nxp.com> <871rpxi5li.fsf@linux.intel.com>
In-Reply-To: <871rpxi5li.fsf@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b6aa0a18-2ad5-4f32-1781-08d7c7013e7d
x-ms-traffictypediagnostic: VE1PR04MB6655:|VE1PR04MB6655:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB66553ABD68103DA4A0E44C7192FA0@VE1PR04MB6655.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 034119E4F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(199004)(81166006)(2906002)(110136005)(54906003)(8676002)(6506007)(71200400001)(8936002)(81156014)(498600001)(5660300002)(7416002)(26005)(186003)(9686003)(4326008)(86362001)(7696005)(64756008)(66946007)(76116006)(44832011)(52536014)(66446008)(66556008)(55016002)(66476007)(33656002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6655;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZmbJxbuyrbLVvgZ02aVOc0gjSYkZa4gpkCA7wvMlidk8WVIe/KOSAblJgo+EmNaDJnootVN9uY1+oWImzr2yuGsvAUWr4Hfo/cI8hDQAoIBF2cXl80ZeQe6oKSw6hJl7PwuY68/xKzfUANEnN37LpUEWBi9KYuuzA5+viM9mvkuHu0U99M4B1OzO4G5f/Kzi6wc3HX/xKBsC4p0LqwqlOAkYO83TvWoyY7VVIfnY7yI2qPLiSDR6THiw6BnjfCdEMtvWqKUhmjR0VrXuX5OZbKiUc5wQFd2QdqKHQbXU5CO12kEOMtjLhY4NrKuusOWk5vei3XfutChctYmuhWFSBTGpdIe99XAwIfDZ1PIJT0DhvwfTmU65GTA9Xw4vwQJbd03FOnB+dPzxYt2byuB6EL25mliK2AeU20az7NcluAkdcHh2icZCujo7Xu/UOMQHYI/R5uZuN/AOSox1UFWuAuA4RBwqO2HVbslwsMUeWXAkcS3hbyiHPS+rVy/QpCNv
x-ms-exchange-antispam-messagedata: rzDlOeVD9hBcRn0mscM+nM57jcrm5lbeYjgEkaxn7LfvRn4eM2trrrshJSWH0mEVwE7m88wr1RDZH+dsxL5M3icKtcTR0G40MqApEF6m97tXTxf1CedgSLyGAiOPKXOkyQYcU61l9sXpZLOj25uICw==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6aa0a18-2ad5-4f32-1781-08d7c7013e7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2020 03:47:25.1625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FeJRyqqBxsfMhMEU4VkJWsojIcOqHAeQtKtX7r+KqNyZmAbbRIDHK1O1Phom2mpy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmluaWNpdXMsDQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBW
aW5pY2l1cyBDb3N0YSBHb21lcyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPg0KPiBTZW50OiAy
MDIwxOoz1MIxM8jVIDY6MTQNCj4gPj4gdGMgcWRpc2MgYWRkIGRldiBldGgwIGluZ3Jlc3MNCj4g
Pg0KPiA+PiB0YyBmaWx0ZXIgYWRkIGRldiBldGgwIHBhcmVudCBmZmZmOiBwcm90b2NvbCBpcCBc
DQo+ID4gICAgICAgICAgZmxvd2VyIHNyY19pcCAxOTIuMTY4LjAuMjAgXA0KPiA+ICAgICAgICAg
IGFjdGlvbiBnYXRlIGluZGV4IDIgXA0KPiA+ICAgICAgICAgIHNjaGVkLWVudHJ5IE9QRU4gMjAw
MDAwMDAwIC0xIC0xIFwNCj4gPiAgICAgICAgICBzY2hlZC1lbnRyeSBDTE9TRSAxMDAwMDAwMDAg
LTEgLTENCj4gPg0KPiA+PiB0YyBjaGFpbiBkZWwgZGV2IGV0aDAgaW5ncmVzcyBjaGFpbiAwDQo+
IA0KPiBBIG1vcmUgY29tcGxleCBleGFtcGxlLCBzaG93aW5nIGhvdyBpdCB3b3VsZCB3b3JrIGZv
ciBtb3JlIGZpbHRlcnMNCj4gd291bGQgYmUgbmljZS4NCj4gDQo+IEZvciBleGFtcGxlLCBmaWx0
ZXJzIG1hdGNoaW5nIDMgZGlmZmVyZW50IHNvdXJjZSBJUHMgKGV2ZW4gYmV0dGVyLCB1c2luZw0K
PiBNQUMgYWRkcmVzc2VzIHNvIGl0IHdvdWxkIHdvcmsgd2hlbiB5b3UgYWRkIHRoZSAnc2tpcF9z
dycgZmxhZyksDQo+IGFzc2lnbmluZyBkaWZmZXJlbnQgcHJpb3JpdGllcyB0byB0aGVtLCBhbHNv
IHNob3dpbmcgaG93IHRoZSAiYmFzZS10aW1lIg0KPiBjb3VsZCBiZSB1c2VkLg0KDQpPaywgSSB3
b3VsZCB1cGRhdGUgd2l0aCBhIG1vcmUgY2xlYXIgZXhhbXBsZS4NCg0KPiA+DQo+ID4gK3N0YXRp
YyBpbnQgdGNmX2dhdGVfYWN0KHN0cnVjdCBza19idWZmICpza2IsIGNvbnN0IHN0cnVjdCB0Y19h
Y3Rpb24gKmEsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCB0Y2ZfcmVzdWx0ICpy
ZXMpIHsNCj4gPiArICAgICBzdHJ1Y3QgdGNmX2dhdGUgKmcgPSB0b19nYXRlKGEpOw0KPiA+ICsg
ICAgIHN0cnVjdCB0Y2ZfZ2F0ZV9wYXJhbXMgKnA7DQo+ID4gKyAgICAgc3RydWN0IGdhdGVfYWN0
aW9uICpnYWN0Ow0KPiA+ICsgICAgIGludCBhY3Rpb247DQo+ID4gKw0KPiA+ICsgICAgIHRjZl9s
YXN0dXNlX3VwZGF0ZSgmZy0+dGNmX3RtKTsNCj4gPiArICAgICB0Y2ZfYWN0aW9uX3VwZGF0ZV9i
c3RhdHMoJmctPmNvbW1vbiwgc2tiKTsNCj4gPiArDQo+IA0KPiBQbGVhc2UgdGVzdCB0aGlzIHdp
dGggbG9ja2RlcCBlbmFibGVkLCBJIGdvdCB0aGUgZmVlbGluZyB0aGF0IHRoZXJlJ3MgYQ0KPiBt
aXNzaW5nIHJjdV9yZWFkX2xvY2soKSBzb21ld2hlcmUgYXJvdW5kIGhlcmUuDQoNCkkgd2lsbCBh
ZGQgbG9jayBoZXJlLg0KDQo+IA0KPiA+ICsgICAgIGdhY3QtPnRrX29mZnNldCA9IHRrX29mZnNl
dDsNCj4gPiArICAgICBzcGluX2xvY2tfaW5pdCgmZ2FjdC0+ZW50cnlfbG9jayk7DQo+ID4gKyAg
ICAgaHJ0aW1lcl9pbml0KCZnYWN0LT5oaXRpbWVyLCBjbG9ja2lkLCBIUlRJTUVSX01PREVfQUJT
KTsNCj4gPiArICAgICBnYWN0LT5oaXRpbWVyLmZ1bmN0aW9uID0gZ2F0ZV90aW1lcl9mdW5jOw0K
PiANCj4gSG0sIGhhdmluZyBhbiBocnRpbWVyIHBlciBmaWx0ZXIgc2VlbXMga2luZCBkYW5nZXJv
dXMsIGluIHRoZSBzZW5zZSB0aGF0IGl0DQo+IHNlZW1zIHZlcnkgaGFyZCB0byBjb25maWd1cmUg
cmlnaHQuDQoNClBlciBnYXRlIGFjdGlvbiBleGFjdGx5LiANCg0KPiANCj4gQnV0IEkgZG9uJ3Qg
aGF2ZSBhbnkgYWx0ZXJuYXRpdmUgaWRlYXMgZm9yIG5vdy4NCg0KWWVzLCBocnRpbWVyIHNob3Vs
ZCBvbmx5IHN0YXJ0IHdoZW4gc29mdHdhcmUgZ2F0ZSBzaW11bGF0b3IgYmluZGluZy4gQnV0IHNl
ZW1zIHRoZXJlIGlzIG5vIHdheSB0byBsaW5rIHRoZSBza2lwX2h3IHN0YXRlIHdpdGggdGhlIGdh
dGUgYWN0aW9uIGluIGN1cnJlbnQgc3RhdGUuIFNvIGhydGltZXIgaGFzIHRvIHN0YXJ0IGF0IGlu
aXRpYWwgdGltZSB3aGVuIGl0IGlzIGNyZWF0ZS4NCg0KPiANCj4gLS0NCj4gVmluaWNpdXMNCg0K
QnIsDQpQbyBMaXUNCg==
