Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F3623B690
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 10:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgHDINZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 04:13:25 -0400
Received: from mail-eopbgr00045.outbound.protection.outlook.com ([40.107.0.45]:25913
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbgHDINY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 04:13:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/FJvHGPKnWgC47Xu/9a22+eAGysE7bzPv7AJ0EB6Ss6jXuTUDj2Uocq8o3pLQhm434Jedip/s3SjF5BK4D0mu65vGT1MCCyHUcU06trO1g+J0HLGhlGM3WCMcu/yqMP1yqo+iGqtfMsrYkymAnK12Vjl039456PGb5IVPp4e5YxsMDdRkEuoSYsOyeBt4dPYcD4TBwtBDv7Qrx9O9nKPz+VFKQ1upP1Ljisd54rK2CfUwmkQcCv3WMr/GaHTZ0+CT3gCwcQcld6Y7+dC0eci8s8E6tgJw8Hi86ZmKFRLyOpu1gIWawcOz1VvUT1HqW+dI1BMevw6Fqmf2/bdyBO1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wdtvE2+QGqUIVXasuT/d+xSfpk/Rn/gHDx2UnCkY1k=;
 b=A45u19Wt5ot5+2x3Xm+R79KgxAwhorwJQaWnI1yd8VtyIaQqMoGwBr/Edx/+SQ/h9yYcG7wsVex5Iirndl4NXmaiCgUmuJcJ0DvKvJbNLBWqbOxc2Q8DmTM0K0Uxr7nWPGZOYfLL+3yP5pL43HmerSxCPHS7qwB0aoZKvlEQpdDM7+4sqGGGho0Z8W6CyFmzuYP5eWgGCMkUoPlgFaqbY9LaKSl5meD7pj6kcm/uKi9QNkUBeonkQC+kCEp4jEOFqo1+Mjv5CftyzDTbB6+7RHR3VmEDulTMcX930OT0KhvEvwIzvWPcESyRNJUBgxhvbU6H66ZMLbenwWEvuVxYTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wdtvE2+QGqUIVXasuT/d+xSfpk/Rn/gHDx2UnCkY1k=;
 b=bb/IsOGHS/SUONdCi+NIs7LTumNnYezxUYeS0YJ3bQMh0KAhpe3hKF0NIyRX6mRdknuThxpMze3M6OXJ5lO49B95BdhZfG87KQY5C52iq5ADpwY6ElzMq1Qt9X+THyD9+kX6SJdlrl/sQutkku6jS6Rdo+nQnPWrvn865pybnMk=
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR0402MB3471.eurprd04.prod.outlook.com (2603:10a6:803:7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Tue, 4 Aug
 2020 08:13:19 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3%7]) with mapi id 15.20.3239.022; Tue, 4 Aug 2020
 08:13:19 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>
Subject: RE: [EXT] Re: [PATCH v4 2/2] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Topic: [EXT] Re: [PATCH v4 2/2] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Index: AQHWZltTjJoiQZyRB0ahxfHbav3IXaknA0gAgACSMEA=
Date:   Tue, 4 Aug 2020 08:13:18 +0000
Message-ID: <VI1PR04MB5103686E3E19D7C0748778E0E14A0@VI1PR04MB5103.eurprd04.prod.outlook.com>
References: <20200730102505.27039-1-hongbo.wang@nxp.com>
 <20200730102505.27039-3-hongbo.wang@nxp.com>
 <b7021ec2-b0bb-d5bf-9b69-2e490d7191e8@gmail.com>
In-Reply-To: <b7021ec2-b0bb-d5bf-9b69-2e490d7191e8@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 925791ba-6fc1-4fee-7bbd-08d8384e3f22
x-ms-traffictypediagnostic: VI1PR0402MB3471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3471062576324CE276B85E2AE14A0@VI1PR0402MB3471.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZhwXbfGv5brUp76FBf+B3OAowJZjT+cvxp1LYO1BX+PLAxYQS6O7qioDEuODfufsG/MGCyBAbfwa+yEp9I9cJKsQsdYVNqwJjaxGaWqP7A4OM9f9FeAAiq6mabPXV2Bfam7RozYOEzPeqUHrOYbc+DOHaof3zqtLN78V2AReYaQkU7lybjX2l6wk0xuHSu/tmDmm/uwqYYYVsl+Ed5k1aOT+l2Idp0u/MKwBMib2ZletJ3DWD9xgxqbQcFWEFVIw/AfaaC/qwt7HEoWywAyG6iFlJI3IVzLXmhfKeOPEyRjrx7vZ4ze+p74vtF6U9UuyP1UIzgBhAHr9Fo+yItNpRFnhFAeP/44OXUyjJ9kDxQgTvfSsqh1u5ni9QJ8NJ9iW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(86362001)(83380400001)(316002)(26005)(8936002)(7416002)(52536014)(5660300002)(186003)(110136005)(6506007)(2906002)(478600001)(8676002)(71200400001)(7696005)(66446008)(64756008)(66556008)(9686003)(44832011)(66946007)(33656002)(55016002)(66476007)(76116006)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: UWE+tilt/MnxrBIwQC58lvWGIIYpwZr1zF0vBW/0Mk8yjXm6XF/CTEbNvAs61Ru3OW96Gdli2TmDpoHFRxWuQXkfUavnKwxRGM6ZhAWc/wFsyZxEordmaMFk/pvtEoL5gxqlRZPcLvzpBh17i6PWjw+/FSg8bXWlo3NYrZXkcNzjbMIaLXDoZzwLav15xUGWUKSk8yU7xRGY6wI1ipi70BU8oPpuzS2ASzblJI9P8MAo49Wbs5SpWtUXSnz6b9Awb9Nis/+aJ6/87KVJAfP6e41J0KGuTzCnu4DNFJqRfQtqyJm72HKUdYkxVwhDsqdh2GBsTur2Md/J3jWeVdYqckN3MM9YklsNYQ2SUa8LBCg8J+wYapdQrTRTeq8Pa0/jKjIqEJM9Vf3eNNGrjFM/rI3a5zl23k3M8GYITHuTz6cLThSbVtTKSIfk3s3nSooZqzM1NlDLp9wfMeQLic5ZXu6IvcoHJxqdOvK8T+PLXklujOhB/XaI7pBqT7g6UJUC6r+F2WdmzJmlpmaOLp9pOojep5+9Jgn1HJxqPmhDKYEiCiYbopKPHqSWqqKnoIlEO1hsdhr+x9C2xBBPTUVArm6xJIKHxSGb3ylw7f3mgJyVoNy6F7solhCatBJca7Ca9KI3DLg+cWIUjcpMdbfzyQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 925791ba-6fc1-4fee-7bbd-08d8384e3f22
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 08:13:18.9025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kANQkLsAo2Qo3WaAwZHRykshyj790FgNt4RTyAzxatbChuwzANT1Zv6UfQLDsLgeZi0igX6s1/zG3uCKvjVfow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3471
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+IFRoaXMgZmVhdHVlIGNhbiBiZSB0ZXN0IHVzaW5nIG5ldHdvcmsgdGVzdCB0b29scw0KPiAN
Cj4gbWlzcGVsbGVkOiBmZWF0dXJlLCBjYW4gYmUgdXNlZCB0byB0ZXN0IG5ldHdvcmsgdGVzdCB0
b29scz8gb3IgY2FuIGJlIHVzZWQgdG8NCj4gZXhlcmNpc2UgbmV0d29yayB0ZXN0IHRvb2w/DQoN
CndoZW4gdGVzdGluZyB0aGlzIGZlYXR1cmUsIEkgbmVlZCBuZXR3b3JrIHRvb2wgdG8gc2VuZCBw
YWNrZXQgd2l0aCBWTEFOIHRhZyhwY3AgcHJvdG8gYW5kIHZpZCksIEkgd2lsbCBjaGFuZ2UgaXQg
dG8gYXZvaWQgYW1iaWd1aXR5Lg0KDQo+IA0KPiA+ICAgICAgIHN0cnVjdCBvY2Vsb3QgKm9jZWxv
dCA9IGRzLT5wcml2Ow0KPiA+ICsgICAgIHN0cnVjdCBvY2Vsb3RfcG9ydCAqb2NlbG90X3BvcnQg
PSBvY2Vsb3QtPnBvcnRzW3BvcnRdOw0KPiA+ICAgICAgIHUxNiB2aWQ7DQo+ID4gICAgICAgaW50
IGVycjsNCj4gPg0KPiA+ICsgICAgIGlmICh2bGFuLT5wcm90byA9PSBFVEhfUF84MDIxQUQpIHsN
Cj4gPiArICAgICAgICAgICAgIG9jZWxvdC0+ZW5hYmxlX3FpbnEgPSBmYWxzZTsNCj4gPiArICAg
ICAgICAgICAgIG9jZWxvdF9wb3J0LT5xaW5xX21vZGUgPSBmYWxzZTsNCj4gPiArICAgICB9DQo+
IA0KPiBZb3UgbmVlZCB0aGUgZGVsZXRlIHBhcnQgdG8gYmUgcmVmZXJlbmNlIGNvdW50ZWQsIG90
aGVyd2lzZSB0aGUgZmlyc3QgODAyLjFBRA0KPiBWTEFOIGRlbGV0ZSByZXF1ZXN0IHRoYXQgY29t
ZXMgaW4sIHJlZ2FyZGxlc3Mgb2Ygd2hldGhlciBvdGhlciA4MDIuMUFEIFZMQU4NCj4gZW50cmll
cyBhcmUgaW5zdGFsbGVkIHdpbGwgZGlzYWJsZSBxaW5xX21vZGUgYW5kIGVuYWJsZV9xaW5xIGZv
ciB0aGUgZW50aXJlDQo+IHBvcnQgYW5kIHN3aXRjaCwgdGhhdCBkb2VzIG5vdCBzb3VuZCBsaWtl
IHdoYXQgeW91IHdhbnQuDQoNCkkgd2lsbCBhZGQgcmVmZXJlbmNlIGNvdW50IGluIG5leHQgdmVy
c2lvbi4NCm1heWJlIEkgY2FuIGRpc2FibGUgcWlucV9tb2RlIGFuZCBlbmFibGVfcWlucSBvbmx5
IHdoZW4gZGVsZXRpbmcgcHZpZCAxLCBJIHdpbGwgdGVzdCBhbmQgY2hhbmdlIGl0Lg0KDQo+IA0K
PiBJcyBub3Qgb2NlbG90LT5lbmFibGVfcWlucSB0aGUgbG9naWNhbCBvciBvZiBhbGwgb2NlbG9f
cG9ydCBpbnN0YW5jZXMncw0KPiBxaW5xX21vZGUgYXMgd2VsbD8NCg0KZW5hYmxlX3FpbnEgaXMg
ZmxhZyBvZiBzd2l0Y2gsIGFuZCBxaW5xX21vZGUgaXMgZmxhZyBvZiBzaW5nbGUgcG9ydCwNCmlm
IHN3aXRjaCBpcyBpbiB3b3JraW5nIGluIFFpblEgbW9kZSwgc29tZSBwb3J0cyB0aGF0IGxpbmtl
ZCB0byBJU1AgbmV0d29ya2luZyBzaG91bGQgZW5hYmxlIHFpbnFfbW9kZSwNCm90aGVyIHBvcnRz
IHRoYXQgbGlua2VkIHRvIGN1c3RvbWVyIG5ldHdvcmtpbmcgZG9uJ3QgbmVlZCBzZXQgcWlucV9t
b2RlLiB0aGVzZSB0d28gdHlwZXMgb2YgcG9ydCBoYXZlIGRpZmZlcmVudCBhY3Rpb24uDQoNCj4g
PiAgICAgICAgICAgICAgIGVsc2UNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgLyogVGFnIGFs
bCBmcmFtZXMgKi8NCj4gPiAgICAgICAgICAgICAgICAgICAgICAgdmFsID0gUkVXX1RBR19DRkdf
VEFHX0NGRygzKTsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICBpZiAob2NlbG90X3BvcnQtPnFp
bnFfbW9kZSkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgdGFnX3RwaWQgPSBSRVdfVEFHX0NG
R19UQUdfVFBJRF9DRkcoMSk7DQo+ID4gKyAgICAgICAgICAgICBlbHNlDQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgIHRhZ190cGlkID0gUkVXX1RBR19DRkdfVEFHX1RQSURfQ0ZHKDApOw0KPiA+
ICAgICAgIH0gZWxzZSB7DQo+ID4gLSAgICAgICAgICAgICAvKiBQb3J0IHRhZ2dpbmcgZGlzYWJs
ZWQuICovDQo+ID4gLSAgICAgICAgICAgICB2YWwgPSBSRVdfVEFHX0NGR19UQUdfQ0ZHKDApOw0K
PiA+ICsgICAgICAgICAgICAgaWYgKG9jZWxvdF9wb3J0LT5xaW5xX21vZGUpIHsNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgaWYgKG9jZWxvdF9wb3J0LT52aWQpDQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgdmFsID0gUkVXX1RBR19DRkdfVEFHX0NGRygxKTsNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgZWxzZQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHZhbCA9IFJFV19UQUdfQ0ZHX1RBR19DRkcoMyk7DQo+ID4gKz4gKyAgICAgICAgICAgICAgICAg
IHRhZ190cGlkID0gUkVXX1RBR19DRkdfVEFHX1RQSURfQ0ZHKDEpOw0KPiANCj4gVGhpcyBpcyBu
ZWFybHkgdGhlIHNhbWUgYnJhbmNoIGFzIHRoZSBvbmUgYWJvdmUsIGNhbiB5b3UgbWVyZ2UgdGhl
IGNvbmRpdGlvbnMNCj4gdmxhbl9hd2FyZSB8fCBxaW5xX21vZGUgYW5kIGp1c3Qgc2V0IGFuIGFw
cHJvcHJpYXRlIFRBR19DRkcoKSByZWdpc3RlciB2YWx1ZQ0KPiBiYXNlZCBvbiBlaXRoZXIgYm9v
bGVhbnM/DQoNCnRoaXMgZmVhdHVyZSBuZWVkcyB2bGFuX2ZpbHRlcj0xLCBzbyB0aGUgYnJhbmNo
IGlmICh2bGFuX2ZpbHRlciA9PSAwICYmIHFpbnFfbW9kZSkgY2FuIGJlIGRlbGV0ZWQgbm93Lg0K
SSB3aWxsIG9wdGltaXplIHRoZSByZWxhdGVkIGNvZGUuDQoNCj4gDQo+IEFyZSB5b3UgYWxzbyBu
b3QgcG9zc2libHkgbWlzc2luZyBhIGlmICh1bnRhZ2VkIHx8IHFpbnFfbW9kZSkgY2hlY2sgaW4N
Cj4gb2NlbG90X3ZsYW5fYWRkKCkgdG8gY2FsbCBpbnRvIG9jZWxvdF9wb3J0X3NldF9uYXRpdmVf
dmxhbigpPw0KDQpUaGUgcWlucV9tb2RlIGFjdGlvbiBjYW4gYmUgdHJpZ2dlcmVkIGJ5IG9jZWxv
dF9wb3J0X3ZsYW5fZmlsdGVyaW5nLCBzbyBkb24ndCBuZWVkIGlmICh1bnRhZ2dlZCB8fCBxaW5x
X21vZGUpLg0KDQpUaGFua3MhDQpIb25nYm8NCg0K
