Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DDA517CF
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbfFXP6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:58:12 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:21767 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfFXP6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:58:08 -0400
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
   d="scan'208";a="38666964"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2019 08:58:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 08:58:04 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Jun 2019 08:57:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPMpKzMqzaCd0LID7sMLnevTBXUO/frjx1vMsgip6e8=;
 b=0HsKYBXCMM3mfADcixdokg0VbD2Hxpa0/pgdrL6ci3q3QZf6eyJQ/0eS+3bz6V4NOr6xVPIRvJtGb0KtmwMbfs/Lqxnc72KXZamisqQK7sLYK5JyHBONZ7u/cGpC5D/HslIKCf1t810x0s8YGZLFX14/WG+n1NXhNwIY51qVkDQ=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHPR11MB1999.namprd11.prod.outlook.com (10.169.232.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 15:58:02 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 15:58:02 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <antoine.tenart@bootlin.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Ludovic.Desroches@microchip.com>, <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH net-next] net: macb: use NAPI_POLL_WEIGHT
Thread-Topic: [PATCH net-next] net: macb: use NAPI_POLL_WEIGHT
Thread-Index: AQHVKqWaRtCQkculk0G0gm3Ocmu+bw==
Date:   Mon, 24 Jun 2019 15:58:02 +0000
Message-ID: <aa8dbdde-7fd2-24f4-b9db-6112152b25c4@microchip.com>
References: <20190621152855.30330-1-antoine.tenart@bootlin.com>
In-Reply-To: <20190621152855.30330-1-antoine.tenart@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0468.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::24) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1798d57-86cc-4624-7c0e-08d6f8bcbcc2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1999;
x-ms-traffictypediagnostic: MWHPR11MB1999:
x-microsoft-antispam-prvs: <MWHPR11MB1999258B570665FE47F4BD49E0E00@MWHPR11MB1999.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(376002)(366004)(39860400002)(199004)(189003)(31686004)(186003)(256004)(14444005)(25786009)(305945005)(52116002)(102836004)(7736002)(99286004)(4326008)(6116002)(3846002)(6506007)(386003)(8676002)(476003)(229853002)(2906002)(11346002)(26005)(446003)(2616005)(68736007)(486006)(36756003)(316002)(6246003)(53546011)(110136005)(478600001)(54906003)(31696002)(2501003)(5660300002)(66066001)(14454004)(6512007)(81156014)(81166006)(66556008)(72206003)(66946007)(73956011)(66476007)(64756008)(66446008)(53936002)(6436002)(6486002)(4744005)(76176011)(86362001)(8936002)(71190400001)(71200400001)(16393002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1999;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: N8nxOSGusifKLqUDVvTBYu8ERa9SMkFRoElf58pAkY+TmDFIP0JqvWVdhx4xQPmgriBW+LCZE80jx0P0KDDx4gfeBdPje0EQcPGo7gZx3GIKGw26xQ99bLKLkKFNPgH+SHfFQufqAvP0K5FQtzuDNIyzviRnTaKQmCzBmY3qOVGJ2iF99qy34kAnk6P2MLSS0qu3swWUBlGz8cLaxTvDpuJyOCAe1IlILqf8dpYgJb0mryUyMCD/kDzzFCcoXHyqjNrW86Uc+RaEnEC9WUEBIMwYZ9MyP2pq5LpC6QFdfOs49H6+6XhWzjy2NYe4B6bcXTH1p/0YMg/z2tKPddCq3apLiTzrt+UI+2VBp22HUay8SZOSEkfjv2JKxH+NYUMb2+CwT3s0BpXN5+au/GLsbGn4glI611ldq6Jbju/lUII=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96E6891747A8774FACC0297E5D16C22C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c1798d57-86cc-4624-7c0e-08d6f8bcbcc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 15:58:02.6928
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

T24gMjEvMDYvMjAxOSBhdCAxNzoyOCwgQW50b2luZSBUZW5hcnQgd3JvdGU6DQo+IFVzZSBOQVBJ
X1BPTExfV0VJR0hULCB0aGUgZGVmYXVsdCBOQVBJIHBvbGwoKSB3ZWlnaHQgaW5zdGVhZCBvZg0K
PiByZWRlZmluaW5nIG91ciBvd24gdmFsdWUgKHdoaWNoIHR1cm5zIG91dCB0byBiZSA2NCBhcyB3
ZWxsKS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFudG9pbmUgVGVuYXJ0IDxhbnRvaW5lLnRlbmFy
dEBib290bGluLmNvbT4NCg0KQWNrZWQtYnk6IE5pY29sYXMgRmVycmUgPG5pY29sYXMuZmVycmVA
bWljcm9jaGlwLmNvbT4NCg0KPiAtLS0NCj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNl
L21hY2JfbWFpbi5jIHwgMiArLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nh
ZGVuY2UvbWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFp
bi5jDQo+IGluZGV4IDE2M2RlYmEyNDRhYi4uMWNkMWYyYzM2ZDZmIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gQEAgLTM0OTAsNyArMzQ5MCw3IEBA
IHN0YXRpYyBpbnQgbWFjYl9pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAg
DQo+ICAgCQlxdWV1ZSA9ICZicC0+cXVldWVzW3FdOw0KPiAgIAkJcXVldWUtPmJwID0gYnA7DQo+
IC0JCW5ldGlmX25hcGlfYWRkKGRldiwgJnF1ZXVlLT5uYXBpLCBtYWNiX3BvbGwsIDY0KTsNCj4g
KwkJbmV0aWZfbmFwaV9hZGQoZGV2LCAmcXVldWUtPm5hcGksIG1hY2JfcG9sbCwgTkFQSV9QT0xM
X1dFSUdIVCk7DQo+ICAgCQlpZiAoaHdfcSkgew0KPiAgIAkJCXF1ZXVlLT5JU1IgID0gR0VNX0lT
Uihod19xIC0gMSk7DQo+ICAgCQkJcXVldWUtPklFUiAgPSBHRU1fSUVSKGh3X3EgLSAxKTsNCj4g
DQoNCg0KLS0gDQpOaWNvbGFzIEZlcnJlDQo=
