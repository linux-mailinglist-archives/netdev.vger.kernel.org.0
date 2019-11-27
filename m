Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D815010AD27
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 11:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfK0KET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 05:04:19 -0500
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:31840
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726143AbfK0KES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 05:04:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZehIN4enJr3qmVJdI2+H7KpCqxK/reuqOAdPypc9qozddci/zFX/e8fHoIkZCTBpwUjjUYGCoPX5zBzWqY0R0rRZQ+vw9KT1RNoOvKDKF6ZWvvAfdM7gQ+Amk6AeD8GQVbaYPu69yhSfwozBOZYR3/0Elc8ufhIu9Q4naggGsQnpfAxJxiuvBao/cOI9zUzB3smVKGPtVED7X9b6o7uM6std710e5cMUJ+YRzlo15+obEq21epqPpUbeV97ifa46hlSn0L6hOJtrUmI6wD527DvBA2X55DeIUxEdvnV7ApDQjVM3PMLeokv1FNIOcg6P7QFw2MB263Ya8A+y3FkaPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLfQWUrO9YUOhf+ghAwO9zfdyA3/vm7BckmlMGlRvAg=;
 b=n+zGzENB77fFYoxcu1gtAV+tWME3F8aA8emT6W/jQrtCRC2KXad5jgWYYNL/4dCs+Tn+rZOTgAgYN5ESThl6QtL+wALyHToUlM/LFn8U4AEthYGKHVPYZBudfFMZYHhQHi6i5zus3KXX5ZB6mIo9D6VpNgJ6I5d4SCwkfvDXJC/cWpwfHDUgLB3PZq5iM3HllJaXTGCViDfiUwSKpDXMkMnSC8kEiXLMdtSSDrNjNJq89/HvfKJdG23y5CWG3BhsGEI/A+BGiU5s3hkeU9iIyY8l3X7wAlpZsSBL/EMfKjuQjHt5+FDSeysOjx1DFK0/p0xZ0qPgyLNT7jGqiDNUIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLfQWUrO9YUOhf+ghAwO9zfdyA3/vm7BckmlMGlRvAg=;
 b=Au8a/apDLSN/41RBFBZsRrxqRYQ5vvecanjWIHwa2mb/3s48BVYEPg0H4rreV/DTeVsGaP4YzRO912RIy1bQBJ6iDwJ0r69UMuB/iD6cH8t9KyuPwpG+TZb56601M7jpngywaiMQjewhJJ56MgdOgQnSCKJ+1MavYGyG2HSQQ54=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4857.eurprd04.prod.outlook.com (20.176.233.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Wed, 27 Nov 2019 10:04:15 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 10:04:15 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 0/4] can: flexcan: fixes for stop mode
Thread-Topic: [PATCH V2 0/4] can: flexcan: fixes for stop mode
Thread-Index: AQHVpOdxXAI9W9cZiUqxHtJbOFpoG6eeiWMAgAAhqwCAABa5QIAAAZ0wgAADdACAAADr0IAAAUMAgAAAVDA=
Date:   Wed, 27 Nov 2019 10:04:15 +0000
Message-ID: <DB7PR04MB4618737A1B5689E5B5474D74E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <e936b9b1-d602-ac38-213c-7272df529bef@geanix.com>
 <4a9c2e4a-c62d-6e88-bd9e-01778dab503b@geanix.com>
 <DB7PR04MB46186472F0437A825548CE11E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <DB7PR04MB4618C541894AD851BED5B0B7E6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <1c71c2ef-39a4-6f38-98c0-4ee43767a725@geanix.com>
 <DB7PR04MB46180EE59D373F9634DD936AE6440@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <6fa94966-c21b-ad2b-653d-aa3589b32df8@geanix.com>
In-Reply-To: <6fa94966-c21b-ad2b-653d-aa3589b32df8@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 24671b12-febc-46bb-1379-08d773212902
x-ms-traffictypediagnostic: DB7PR04MB4857:|DB7PR04MB4857:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB48573DD6C15C22F4254167ADE6440@DB7PR04MB4857.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(13464003)(189003)(199004)(6436002)(8676002)(81156014)(8936002)(76116006)(66446008)(4326008)(229853002)(81166006)(86362001)(74316002)(14454004)(478600001)(7736002)(52536014)(66066001)(55016002)(5660300002)(9686003)(2501003)(316002)(2906002)(76176011)(6506007)(99286004)(110136005)(102836004)(7696005)(305945005)(11346002)(6116002)(186003)(26005)(53546011)(33656002)(64756008)(66946007)(25786009)(66476007)(4744005)(3846002)(54906003)(2201001)(66556008)(6246003)(71190400001)(446003)(71200400001)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4857;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SZJxAw55cjU3PBggll2oQZ1T8nMMcKGXDjjkwGiEtzRrp7gCsfONbAoPL1xDKNWJKGtGUsx2XV6J86Yzzzab2Wa3WhtzbtUJouEaWlc3SNP2f6WjOQ1/b14xiFn2Qybj7GgDR/jHh0byW6JwK3WkBMoLWNFXPgLOY38cc+iVcZ4rbXfxv3C4Uk7D9AZWZBb7sqeR7NRbuwYBWpqo8RHLWyMToy4VxoYpBCtGlnhqmPI0XhXLGL0q9IeD8VufDDYYXgJcqleLxOcV5MfGXx51asM0KdGX5zFy/YxyY1CiUaMXqoXpvLvcd1hnMGHY2sRsc0o6Qxr2gmQveqk+Syts7dBwAFk3U1sRCnoGA/9+H2P+9FRIbXpr9ZHRS0aDklvlilOyS9XgrkgiVbTgRSLJJ1P+f25Zljwfs3Icf+o+ANYqf/99tqaai5FxBi2kxxFX
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24671b12-febc-46bb-1379-08d773212902
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 10:04:15.3892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xUTHyeDapmh9aIN3oIKRVFbPkt1eFZvaEYlfkIWFNCb7b4o2XQMfAvTlIgebXR99tSaikWBkHun4x0gMJ6BgDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4857
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4LWNhbi1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNhbi1vd25lckB2Z2VyLmtlcm5lbC5vcmc+DQo+IE9uIEJl
aGFsZiBPZiBTZWFuIE55ZWtqYWVyDQo+IFNlbnQ6IDIwMTnlubQxMeaciDI35pelIDE4OjAwDQo+
IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgbWtsQHBlbmd1dHJv
bml4LmRlOw0KPiBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXgg
PGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIFYyIDAvNF0gY2FuOiBmbGV4Y2FuOiBmaXhlcyBmb3Igc3RvcCBtb2RlDQo+IA0K
PiANCj4gDQo+IE9uIDI3LzExLzIwMTkgMTAuNTgsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBD
b3VsZCB5b3UgZ2l2ZSB5b3VyIFRlc3QtYnkgdGFnIGZvciB0aGlzIHBhdGNoIHNldD8gQW5kIHRo
ZW4gTWFyYyBjb3VsZA0KPiByZXZpZXcgdGhpcyBwYXRjaCBzZXQuDQo+IA0KPiBEb25lIDopDQoN
ClRoYW5rcyBhIGxvdPCfmIoNCg0KPiBDYW4ndCB0ZXN0IHBhdGNoIDQvNC4uLg0KPiBIb3BlIE1h
cmMgY2FuIGdpdmUgaGlzIGNvbW1lbnRzIGFuZCBwaWNrIHRoZXNlLg0KDQpNdWNoIGhvcGUsIEkg
d291bGQgaW1wcm92ZSBpdCB3aXRoIE1hcmMncyBjb21tZW50cy4NCg0KQmVzdCBSZWdhcmRzLA0K
Sm9ha2ltIFpoYW5nDQo+IC9TZWFuDQo=
