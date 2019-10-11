Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF5ED36C2
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 03:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfJKBK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 21:10:28 -0400
Received: from mail-eopbgr30049.outbound.protection.outlook.com ([40.107.3.49]:33861
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727518AbfJKBK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 21:10:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzLzqHv1/kmNm2DvrwUBoJXSCqX1Yhg+aniI0WEWJ1+5yq4Uv186QMS6e+90tqY7TJfw1NMgdgQi+I/h4gZwO/sA3q5kWdA1CZ0xK8n7uHeLwu2sLJcT+qY71n7ha1eMBGSjbGRPp6i/jZGjzMd6pTe53qzmgUr8oOZK2bd2X5KLz1xkdO+YSSj4UlWsqAoJf0rZypOBlqvx0pHYE/cjS2LWoIUMZ9WEhCMXQAr5H9eBGOHU4l9bSjr2B+B/X8dcDE+uRNb9eco0tHLLyjhlQzkhO9mUYwgfFh0pXVXlBj3X/YN5c88ILsQ0fkZAdNqHHbccPv57+ZSG4/I+PLqIaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQuqtqitp+YZ/TmvqzWGeol+x5QMF5tIJTqYVU7qaw0=;
 b=X/KQwNlasK6erKFJxf/nNxc56TkfGpJEJwES4ZV16HiCa8QFcxy8KSCEKok6SD6RyI8a08jQ/SxQhwBE712MegyaYBJk4kGvA7p4Zoi6TOpk50A6VpiiYBigxAV9OGDMVEljCs01uNolA4A0b85KyvZH9mErl1wq5iVLjVyP1j2R03UHxsbJbSsTyCcw4TKAqzQRo9zgOSOP0Q0S0tNOCTPb3AHiRfiuDpRJgDqklPjGCxEmlDUKyhO/EtJITc79JCrgo2W941Q/ZeuVpxB4iywEwZEm3pEGbALNysLZ0LiTjJkh9XOC5jy8Ec9z6VahaFnWgjIeqA2LnBHTdqJatg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQuqtqitp+YZ/TmvqzWGeol+x5QMF5tIJTqYVU7qaw0=;
 b=aLbgQTwo6h9TwSCIi2M7G6kKwaFRxgWo69N/nXWQZXiijslSHq+iWWQG3qosopkvU9xbATg/jmx7oPxLCzymYYByNH9+mIKM34ft9r5ZHR8JzkmNb4uT+uEZ879VUwykVCS+t3gWJDH+IipuFit5E9OmYu2GcRjKEjxFXtvHOCs=
Received: from DB3PR0402MB3916.eurprd04.prod.outlook.com (52.134.72.18) by
 DB3PR0402MB3850.eurprd04.prod.outlook.com (52.134.65.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 11 Oct 2019 01:10:23 +0000
Received: from DB3PR0402MB3916.eurprd04.prod.outlook.com
 ([fe80::d469:ad51:2bec:19f0]) by DB3PR0402MB3916.eurprd04.prod.outlook.com
 ([fe80::d469:ad51:2bec:19f0%6]) with mapi id 15.20.2347.016; Fri, 11 Oct 2019
 01:10:23 +0000
From:   Anson Huang <anson.huang@nxp.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "swboyd@chromium.org" <swboyd@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH 1/2] net: fec_main: Use platform_get_irq_byname_optional()
 to avoid error message
Thread-Topic: [PATCH 1/2] net: fec_main: Use
 platform_get_irq_byname_optional() to avoid error message
Thread-Index: AQHVforZimETp53I4UOLcQPYAMVf3qdUghaAgAAN4TCAAAnBAIAAAP3QgAAEwgCAAARvAA==
Date:   Fri, 11 Oct 2019 01:10:23 +0000
Message-ID: <DB3PR0402MB3916F0AC3E3AEC2AC1900BCCF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
References: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
        <20191010160811.7775c819@cakuba.netronome.com>
        <DB3PR0402MB3916FF4583577B182D9BF60CF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
        <20191010173246.2cd02164@cakuba.netronome.com>
        <DB3PR0402MB3916284A326512CE2FDF597EF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
 <20191010175320.1fe5f6b3@cakuba.netronome.com>
In-Reply-To: <20191010175320.1fe5f6b3@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=anson.huang@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f4d2be7-4a8c-4fbc-9a14-08d74de7cad2
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DB3PR0402MB3850:|DB3PR0402MB3850:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB3850F14936237A925BD4139BF5970@DB3PR0402MB3850.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(136003)(396003)(39850400004)(189003)(199004)(25786009)(6246003)(7736002)(8676002)(8936002)(229853002)(81166006)(11346002)(81156014)(86362001)(476003)(44832011)(446003)(9686003)(4326008)(55016002)(305945005)(486006)(6436002)(74316002)(66066001)(64756008)(66556008)(66476007)(478600001)(186003)(71190400001)(54906003)(52536014)(66946007)(5660300002)(76116006)(14454004)(2906002)(26005)(99286004)(6506007)(76176011)(102836004)(316002)(71200400001)(7696005)(6116002)(33656002)(3846002)(6916009)(256004)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR0402MB3850;H:DB3PR0402MB3916.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ryk5eoettjZCEWr5c4Vot3w0Xwil6qfZEtm+2Zj3q2ynaEit9T9acrQdSROPgureS+RQfr6FVt8U+s6/9sDX8aaj4eUCphFdmskyZX1ncMADGDdcIFyyHQUNEzsPtikVw2GODtJuiykCCW/LlR+uPa9H5FsvkyC6M0epYrLGMtDmyCJfPsRB6dyb2Cy4FGZrZRvjuPsY7zdeBy1l9/UBJkQHKwuZ5ePJDESNr34FZtdHGQwe+B4NjnQ8+W2pos2XrXo4OBvZgP0C3sYyZtBgFMXBJreAaSflfwkPU3kg+CSKoRpI9kW7j8x7ivOkFxMJNj0zMWKIihRg6ZArAJEIn+UXP8PZYKay+BYRJdIbBmkuf+PZpN/dOyHnt6IobwcDU5tBP78NCBif8+xcr9d2uI2jY9x56ea2KXBF62vMT/0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4d2be7-4a8c-4fbc-9a14-08d74de7cad2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 01:10:23.0738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BPSYCYnySmKxty98eqN2yJe55/hv2p9d8z2bGhvmbOHMPFS558BTTqzpUa4cm/toEnB8qPjugomnu3yz1JjrMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3850
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIEpha3ViDQoNCj4gT24gRnJpLCAxMSBPY3QgMjAxOSAwMDozODo1MCArMDAwMCwgQW5zb24g
SHVhbmcgd3JvdGU6DQo+ID4gPiBIbS4gTG9va3MgbGlrZSB0aGUgY29tbWl0IHlvdSBuZWVkIGlz
IGNvbW1pdCBmMWRhNTY3ZjFkYzEgKCJkcml2ZXIgY29yZToNCj4gPiA+IHBsYXRmb3JtOiBBZGQg
cGxhdGZvcm1fZ2V0X2lycV9ieW5hbWVfb3B0aW9uYWwoKSIpIGFuZCBpdCdzDQo+ID4gPiBjdXJy
ZW50bHkgaW4gR3JlZydzIHRyZWUuIFlvdSBoYXZlIHRvIHdhaXQgZm9yIHRoYXQgY29tbWl0IHRv
IG1ha2UNCj4gPiA+IGl0cyB3YXkgaW50byBMaW51cydlcyBtYWluIHRyZWUgYW5kIHRoZW4gZm9y
IERhdmUgTWlsbGVyIHRvIHB1bGwgZnJvbSBMaW51cy4NCj4gPiA+DQo+ID4gPiBJJ2Qgc3VnZ2Vz
dCB5b3UgY2hlY2sgaWYgeW91ciBwYXRjaGVzIGJ1aWxkcyBvbiB0aGUgbmV0IHRyZWU6DQo+ID4g
Pg0KPiA+ID4gICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQv
bmV0ZGV2L25ldC5naXQNCj4gPiA+DQo+ID4gPiBvbmNlIGEgd2Vlay4gTXkgZ3Vlc3MgaXMgaXQn
bGwgcHJvYmFibHkgdGFrZSB0d28gd2Vla3Mgb3Igc28gZm9yDQo+ID4gPiBHcmVnJ3MgcGF0Y2hl
cyB0byBwcm9wYWdhdGUgdG8gRGF2ZS4NCj4gPg0KPiA+IFRoYW5rcyBmb3IgZXhwbGFuYXRpb24g
b2YgaG93IHRoZXNlIHRyZWVzIHdvcmssIHNvIGNvdWxkIHlvdSBwbGVhc2UNCj4gPiB3YWl0IHRo
ZSBuZWNlc3NhcnkgcGF0Y2ggbGFuZGluZyBvbiBuZXR3b3JrIHRyZWUgdGhlbiBhcHBseSB0aGlz
IHBhdGNoDQo+ID4gc2VyaWVzLCB0aGFua3MgZm9yIGhlbHAuDQo+IA0KPiBVbmZvcnR1bmF0ZWx5
IHRoZSBuZXR3b3JraW5nIHN1YnN5c3RlbSBzZWVzIGFyb3VuZCBhIDEwMCBwYXRjaGVzDQo+IHN1
Ym1pdHRlZCBlYWNoIGRheSwgaXQnZCBiZSB2ZXJ5IGhhcmQgdG8ga2VlcCB0cmFjayBvZiBwYXRj
aGVzIHdoaWNoIGhhdmUNCj4gZXh0ZXJuYWwgZGVwZW5kZW5jaWVzIGFuZCB3aGVuIHRvIG1lcmdl
IHRoZW0uIFRoYXQncyB3aHkgd2UgbmVlZCB0aGUNCj4gc3VibWl0dGVycyB0byBkbyB0aGlzIHdv
cmsgZm9yIHVzIGFuZCByZXN1Ym1pdCB3aGVuIHRoZSBwYXRjaCBjYW4gYmUNCj4gYXBwbGllZCBj
bGVhbmx5Lg0KDQpPSywgSSB3aWxsIHJlc2VuZCB0aGlzIHBhdGNoIHNlcmllcyBvbmNlIHRoZSBu
ZWNlc3NhcnkgcGF0Y2ggbGFuZHMgb24gdGhlIG5ldHdvcmsNCnRyZWUuDQoNClRoYW5rcywNCkFu
c29uDQo=
