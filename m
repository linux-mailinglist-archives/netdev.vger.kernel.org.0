Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54CC5517BE
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731151AbfFXPzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:55:46 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:21637 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbfFXPzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:55:46 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.63,412,1557212400"; 
   d="scan'208";a="38666742"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2019 08:55:45 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.87.151) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 08:55:43 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Jun 2019 08:54:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSAL7ZUDnNnvwDnja2X3H+nPz0McQEvLa6pPV2s10AA=;
 b=Emj72WPPgHDHOW3QnD+lPQy3U3+4XvQCCGk7Mf9K5vN5JgpJBH4z67aIfGMm9IkbmnGsUQlawbhWVMz98u/ySi+3EW3Lz1RLl0zPD+KOV9eIGEsJNeXxwncn8g3gH5s4CGiSTrF/ouNsTObfjbC+qh1VY803WHejCwsdW1DS2PE=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHPR11MB1999.namprd11.prod.outlook.com (10.169.232.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 15:55:42 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 15:55:42 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <antoine.tenart@bootlin.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Ludovic.Desroches@microchip.com>, <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH net] net: macb: do not copy the mac address if NULL
Thread-Topic: [PATCH net] net: macb: do not copy the mac address if NULL
Thread-Index: AQHVKqVGsoNXrtPxPk6+LOJezvU7tA==
Date:   Mon, 24 Jun 2019 15:55:41 +0000
Message-ID: <0dceaf8f-0a08-8515-5054-1f9395e9b60f@microchip.com>
References: <20190621152635.29689-1-antoine.tenart@bootlin.com>
In-Reply-To: <20190621152635.29689-1-antoine.tenart@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0257.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::29) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 578956ea-04ad-46f5-29ce-08d6f8bc68bf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1999;
x-ms-traffictypediagnostic: MWHPR11MB1999:
x-microsoft-antispam-prvs: <MWHPR11MB1999C3517C82AE085FFACC82E0E00@MWHPR11MB1999.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(376002)(366004)(39860400002)(199004)(189003)(31686004)(186003)(256004)(14444005)(25786009)(305945005)(52116002)(102836004)(7736002)(99286004)(4326008)(6116002)(3846002)(6506007)(386003)(8676002)(476003)(229853002)(2906002)(11346002)(26005)(446003)(2616005)(68736007)(486006)(36756003)(316002)(6246003)(53546011)(110136005)(478600001)(54906003)(31696002)(2501003)(5660300002)(66066001)(14454004)(6512007)(81156014)(81166006)(66556008)(72206003)(66946007)(73956011)(66476007)(64756008)(66446008)(53936002)(6436002)(6486002)(76176011)(86362001)(8936002)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1999;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dikfw+ARIqM3QthXMSCBaJkWlovxnpzbqms7MeqTeculbdwzlu0X3a0104feIid5dpp8bsPP6zBn7vYybWSFwSRIu+hN+HiyPHXuuMsUT/LBahz4Ii5lzY2ogjvnbIg+E0kdtXMqci89EM84+54cTUzMB5LcSnBRKEOxvlXDQzeHaIxgynGuSrKfB8U+T8qCghm18V52aUBkO6CKMiYXoBL5lsPGLonm62DPTg/PHENdrInSYy4MaQXkqZ6lHMwdwGhIf7ZYWu1ljMZgGI8DI0JIiIvL/xLn9JrZ7GCL/Fa/QSsMRn5QnXefRQFdLOZEpHgC/erpqruyDNzNHkwgyeX8e7G8p1bh9AfBTRiTbJCkzYqedNyo84/1uLY9QfsX2EUTtICYSApNEW/gQNoboi1SgDX+jT+QPR4Xcz4hip4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86D8B851C2653D4A818D7CB3A6A763E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 578956ea-04ad-46f5-29ce-08d6f8bc68bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 15:55:41.9866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nicolas.ferre@microchip.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1999
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjEvMDYvMjAxOSBhdCAxNzoyNiwgQW50b2luZSBUZW5hcnQgd3JvdGU6DQo+IFRoaXMgcGF0
Y2ggZml4ZXMgdGhlIE1BQyBhZGRyZXNzIHNldHVwIGluIHRoZSBwcm9iZS4gVGhlIE1BQyBhZGRy
ZXNzDQo+IHJldHJpZXZlZCB1c2luZyBvZl9nZXRfbWFjX2FkZHJlc3Mgd2FzIGNoZWNrZWQgZm9y
IG5vdCBjb250YWluaW5nIGFuDQo+IGVycm9yLCBidXQgaXQgbWF5IGFsc28gYmUgTlVMTCB3aGlj
aCB3YXNuJ3QgdGVzdGVkLiBGaXggaXQgYnkgcmVwbGFjaW5nDQo+IElTX0VSUiB3aXRoIElTX0VS
Ul9PUl9OVUxMLg0KPiANCj4gRml4ZXM6IDU0MWRkYzY2ZDY2NSAoIm5ldDogbWFjYjogc3VwcG9y
dCBvZl9nZXRfbWFjX2FkZHJlc3MgbmV3IEVSUl9QVFIgZXJyb3IiKQ0KPiBTaWduZWQtb2ZmLWJ5
OiBBbnRvaW5lIFRlbmFydCA8YW50b2luZS50ZW5hcnRAYm9vdGxpbi5jb20+DQoNCkFja2VkLWJ5
OiBOaWNvbGFzIEZlcnJlIDxuaWNvbGFzLmZlcnJlQG1pY3JvY2hpcC5jb20+DQoNCkl0IGNvdWxk
IGJlIGdvb2QgdG8gaGF2ZSB0aGlzIGZpeCBmb3IgNS4yLWZpbmFsLi4uDQoNClRoYW5rcyENCg0K
PiAtLS0NCj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgMiAr
LQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IGluZGV4IDEyNDFh
MmE3MzQzOC4uMWNkMWYyYzM2ZDZmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVu
Y2UvbWFjYl9tYWluLmMNCj4gQEAgLTQzMDQsNyArNDMwNCw3IEBAIHN0YXRpYyBpbnQgbWFjYl9w
cm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgIAlpZiAoUFRSX0VSUihtYWMp
ID09IC1FUFJPQkVfREVGRVIpIHsNCj4gICAJCWVyciA9IC1FUFJPQkVfREVGRVI7DQo+ICAgCQln
b3RvIGVycl9vdXRfZnJlZV9uZXRkZXY7DQo+IC0JfSBlbHNlIGlmICghSVNfRVJSKG1hYykpIHsN
Cj4gKwl9IGVsc2UgaWYgKCFJU19FUlJfT1JfTlVMTChtYWMpKSB7DQo+ICAgCQlldGhlcl9hZGRy
X2NvcHkoYnAtPmRldi0+ZGV2X2FkZHIsIG1hYyk7DQo+ICAgCX0gZWxzZSB7DQo+ICAgCQltYWNi
X2dldF9od2FkZHIoYnApOw0KPiANCg0KDQotLSANCk5pY29sYXMgRmVycmUNCg==
