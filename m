Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02151F6FB6
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgFKWGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:06:25 -0400
Received: from mail-eopbgr00074.outbound.protection.outlook.com ([40.107.0.74]:24902
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725869AbgFKWGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:06:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HI+2nriuZbvsnRSwiT6WwOHkCYfXlbtGlT4uFjZWYq3zT1voH09qBd882vSeCnP78DF/65juYKOmw2XZ9LEDYZWdLYYR0ZM3sSkIMfnIu/wYRioiWxOleePDMa6btX9nraIWiwbmWKNtknDSSaMayfm53xFzbi9mTUyVQgtLRIsRqphfdLBjV4d8ZodOHiGj2z9E4pjjPhWd7X1oiMKcg7efpb0rPBRf7i6H/pBy9x0qLttL+gQl3dwsIgcariv/yGH9iHeWVWHPBMNiJhTYh2yoFvFjd+P0u769JEEXuqRg8YG217Obek9JqOgX53pBSabrDEENt2te7BDBlPKFYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjPCHoHMz2FU6RrSLguyW/yfVLNkqneHmZ8QjK6jxVc=;
 b=jt/hp0jqiDqA76kLUAx24p5AzjMPhYodffz5/2I0fbXkEDrMkHlRmxdDPrReiTzfr9QmDTCBQS/RBhJBSOIgqWiTch2EM20CwzQhlVX13OT3JaaFeLnklIKjMNiSdYDDQXUXyLwtVMi4OTRbT+hTUO2cWospJfDE1oLeTFSFj5esgAZI7BrYJBe34pi1mssboKnvxjqvXWMO8jPNwdE1M+0uylW6X+j8Lz5s6yU77HvTFIBDh20IFq3y+/QDGRV+R4ERHO9W1WDtVobG2dXDf7d6zE7hjfP56dXXnjNaRgfmCQbJaXqn1Wc2aCkNzH2jWYrVnxhuRE1eYYVxxB4+YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjPCHoHMz2FU6RrSLguyW/yfVLNkqneHmZ8QjK6jxVc=;
 b=tC4kqIqqBsqAH96bywCQqz8CoUXxRAqNOLtzNKHkDQTdosTyst9RS9jnibF6OUKjXFI8h5QMz9Bn3xL4OOayV5KdwwmZZUvpr9YhAMVXZ7mtOn29M9nCD6N1i3ukGXY94Y5JVlJHqFgt5MBITMmSFvsVmGEcFIHUwBiQwcjh5hY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5119.eurprd05.prod.outlook.com (2603:10a6:803:a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 22:06:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:06:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     Vu Pham <vuhuong@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: E-Switch, Fix some error pointer dereferences
Thread-Topic: [PATCH] net/mlx5: E-Switch, Fix some error pointer dereferences
Thread-Index: AQHWOdBbGQAdFUMt30uX+lYMVaxOUqjIQ2OAgAGXrYCAAtpOgIACCSSAgAVG7QA=
Date:   Thu, 11 Jun 2020 22:06:20 +0000
Message-ID: <fcac5706683cc63cfd2db520e53826e604f59ae3.camel@mellanox.com>
References: <20200603175436.GD18931@mwanda> <20200604103255.GA8834@unreal>
         <20200605105203.GK22511@kadam> <20200607062555.GC164174@unreal>
         <20200608133109.GQ22511@kadam>
In-Reply-To: <20200608133109.GQ22511@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bd47d026-1592-4255-8b5d-08d80e53ac7e
x-ms-traffictypediagnostic: VI1PR05MB5119:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5119AB7BC38E31B503DD0F4BBE800@VI1PR05MB5119.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0431F981D8
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aTiohYzZsxI8sQjU6M7HaT8iY/xTAlKHekRkzdVpyvXw2Ud2Q88VUZpwqJr1yoc6ab0/9aXfw2Y66C566HiAUdFMSS+q+4MSgr4RDaGUDyxIkNFvEjK5fPGPWJegBxoiNQkrrv/VXazZuMeZi1aNLE4VHHym4bbHnS2URNJxCsspLrJqWkFMrtXnozBKlMc09qi7XIenvuIdpTNnZshM3/7araeQtSmaRCE/zLsLlCYkK8GMPpQLlypRGRubGgh5vcY7NgOVeeo7FJ2w4y3T1VuGeVYg3ZSXY5ztcco6cFyIcaome4VA1M3dhSwKaBuZoxWIUNIda5hs3wgoAJjQMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(86362001)(6486002)(4326008)(26005)(6512007)(8936002)(478600001)(64756008)(2906002)(66446008)(71200400001)(66946007)(66476007)(76116006)(186003)(2616005)(36756003)(54906003)(6506007)(66556008)(8676002)(5660300002)(110136005)(91956017)(316002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: XFFCVTSkorHbm4kpqVN7tXWhXgGeukGUcWcodFvgMMtXLmzBWAvNXJClbTVwe9+r1EFT8H5ePPt+4LYCNmvMM2f21EnjTb585mT+FG8bb2/RNUODbb/vA8ANyWGisQ/rZe/vQcfdfeAcQgf6n/+QdBXYl3XBPk12dtiLqPerSPxiYpB5WrlXukUvS/CMHQTG74rxO0g1Q9tP9BjwzPufjgrqj2Fq4894o1L5+yoIiexPhjXltiOiHyOl1tT7ehQ2VT+V4MGXQK+bl4NNqt++h2QAdok7QSvKt9C3g39Awb55wujYauBJ7kqWz1fStBbOYU/bjVEKe6c3zuwqIRvSMyn9Y02UANCdp+MFh1vgWU+Nwynf4qXo+/wkwiOswpqAmtjZZENXNbB/b1i3K3DZEct1/IcQ/S4XNYWC2JODgoa6m/n1garRmZhkRVEPhOKVdaAqgBQCCh4/uOySatwrWWU17XckyuqEtcHHM19Lz9k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28A1F131F98E9A4A8C04437DCDCFBA86@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd47d026-1592-4255-8b5d-08d80e53ac7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2020 22:06:21.0095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: akWZyopCHL/xwxiWpfThi1/V6F0+KIJqC0vtWljLwSnZVdqlnuwCiAFVGQRlRe5jhRgDICJqePvMzcOUR6xhug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA2LTA4IGF0IDE2OjMxICswMzAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOg0K
PiBPbiBTdW4sIEp1biAwNywgMjAyMCBhdCAwOToyNTo1NUFNICswMzAwLCBMZW9uIFJvbWFub3Zz
a3kgd3JvdGU6DQo+ID4gT24gRnJpLCBKdW4gMDUsIDIwMjAgYXQgMDE6NTI6MDNQTSArMDMwMCwg
RGFuIENhcnBlbnRlciB3cm90ZToNCj4gPiA+IE9uIFRodSwgSnVuIDA0LCAyMDIwIGF0IDAxOjMy
OjU1UE0gKzAzMDAsIExlb24gUm9tYW5vdnNreSB3cm90ZToNCj4gPiA+ID4gKyBuZXRkZXYNCj4g
PiA+ID4gDQo+ID4gPiANCj4gPiA+IFRoaXMgaXMgc29ydCBvZiB1c2VsZXNzLiAgV2hhdCdzIG5l
dGRldiBnb2luZyB0byBkbyB3aXRoIGEgcGF0Y2gNCj4gPiA+IHRoZXkNCj4gPiA+IGNhbid0IGFw
cGx5PyAgSSBhc3N1bWVkIHRoYXQgbWVsbGFub3ggd2FzIGdvaW5nIHRvIHRha2UgdGhpcw0KPiA+
ID4gdGhyb3VnaA0KPiA+ID4gdGhlaXIgdHJlZS4uLg0KPiA+IA0KPiA+IFJpZ2h0LCBidXQgaXQg
d2lsbCBiZSBwaWNrZWQgYnkgU2FlZWQgd2hvIHdpbGwgc2VuZCBpdCB0byBuZXRkZXYNCj4gPiBs
YXRlcg0KPiA+IGFzIFBSLiBDQ2luZyBuZXRkZXYgc2F2ZXMgZXh0cmEgcmV2aWV3IGF0IHRoYXQg
c3RhZ2UuDQo+IA0KPiBPa2F5LiAgSSB3aWxsIHRyeSB0byByZW1lbWJlciB0aGlzIGluIHRoZSBm
dXR1cmUuICBJJ2xsIHRyeSBwdXQNCj4gW1BBVENIIG1seDUtbmV4dF0gaW4gdGhlIHN1YmplY3Qg
ZXZlbiB3aGVuIGl0IGFwcGxpZXMgdG8gdGhlIG5ldA0KPiB0cmVlLg0KDQpUaGFua3MgRGFuIGZv
ciB0aGUgcGF0Y2guDQoNCm5ldGRldiBpcyBhbHdheXMgb3BlbiBmb3IgZml4ZXMuDQoNCkFwcGxp
ZWQgdG8gbmV0LW1seDUsIHdpbGwgc2VuZCB0aGlzIGluIHRvZGF5IFBSIHRvIG5ldC4NCg0KLVNh
ZWVkLg0KDQo+IA0KPiByZWdhcmRzLA0KPiBkYW4gY2FycGVudGVyDQo+IA0K
