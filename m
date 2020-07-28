Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185272312E0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732885AbgG1Tk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:40:29 -0400
Received: from mail-eopbgr10074.outbound.protection.outlook.com ([40.107.1.74]:20962
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728927AbgG1Tk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 15:40:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X90BWmrBNqBqYRse1p89XyXTWya2gccasVcC/CdPTvbROg7aMt7A2lIZT48eoJQu3VY6hNCCichgk3yJ/OzAot4mxTdbqw4eTbQZzkXpDdeeJhacwLVkJqPFhSdo/hkM/DPmnJR6tdF/kECxrFO5U3jBdAVf5S8anfI8jG2mZ+3LrKaAxzxes4WfiJrALndpyF2DsiQK1ognYLAq8zOXcNRakVPJQPiJOGVTNHMw1FbdIsFO1JlSUjh/fuAYh8YKLkJmqxxCjFXh+rZ+LA59HuojUi4byVGgUBIuTlne1FoJIvc1QSPUhgVBDmmAR+/QB7QUE+KhiksKjxVZ+7cMgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9Y/vNJyS9ityHRBgk7dyZWV/Am8R56pUTUazqBnMAA=;
 b=Fd1jppxwqA5JQi+QRKdlD+JWVqPs9fIfIFmx9WLC2HLXxmcSBy/zDjsSSghBXsXv3HoN1LlIDsm/Ubn1C3ExeAssXuwrZar4EW0P83Ol1GkKrTHAtKG3aMLljBDHmh+R4w1L1QaW8nCWyh9PJvsb1D7Ngl1v2M2K5an8j10bbTDds3h61uDa2GiUeMH1mvQalQa3wBqqIx6t4i7jYmfZOjxjsrokqnOE4Wp1uaYghTa057YgMU3LCwB/yTNOWqWlUfuw73BOoeKw9L3+FAt+1QoMQDhQNnSJmxSEvv7bU0QcqbLnMiJ4l9+vjE+losRqeEHGEmxKeI6rNIbxyvecdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9Y/vNJyS9ityHRBgk7dyZWV/Am8R56pUTUazqBnMAA=;
 b=FMzyH0NseeGXThPXCnL0s9XRzvnZCP9VvoCkB4jQx7odB1/Dv/7iLBc2eX1OkLlO+ct1yMGzKwKUtQ09UVPrv2XEvrwxqExgXV/mXx8cDXIFEQMCXKNfd6aJvmzMORIwfxk89NX+eGAqyb7b7cFoQr+A+gBFlM204/LxAc1klCc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6269.eurprd05.prod.outlook.com (2603:10a6:803:56::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 19:40:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 19:40:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        Ron Diskin <rondi@mellanox.com>
CC:     Roi Dayan <roid@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 11/12] net/mlx5e: Modify uplink state on interface up/down
Thread-Topic: [net 11/12] net/mlx5e: Modify uplink state on interface up/down
Thread-Index: AQHWZL8Y3/hPTEGIeEa9LOSeFDx+KakcyPSAgACbagA=
Date:   Tue, 28 Jul 2020 19:40:24 +0000
Message-ID: <09c0166149c13dba6fdb22ed47f2732444a91fb6.camel@mellanox.com>
References: <20200728091035.112067-1-saeedm@mellanox.com>
         <20200728091035.112067-12-saeedm@mellanox.com>
         <CAJ3xEMg+wW2FFrC3rRQyQbcSJKFf5Lr9EvNYuRQ0JZEDAztw7g@mail.gmail.com>
In-Reply-To: <CAJ3xEMg+wW2FFrC3rRQyQbcSJKFf5Lr9EvNYuRQ0JZEDAztw7g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 30e100f3-0012-44b8-e316-08d8332e127d
x-ms-traffictypediagnostic: VI1PR05MB6269:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6269E3F40A55A59F4D5936F2BE730@VI1PR05MB6269.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9MuL/bjMsILxGO7qABYRhU7hSv2LGBnnDXNnlkiux1CBeMuuyuCaFdWJQYOLx05v2LKgnv147BhAM3Hb/t9Pqq83RsfLvIO2zMbh5YVDUO5fD4vcpZtElWK0Zr2F4CW1nnj86ANI1eJ2cj0/x+nkx4RnshuzaIoZlSOjyiteVzgUSgKlvF/WxWA+oai8oV/iOlFSfCyCyV3s1BECbj031cpdaYn6ozy+qvapuHrCXe0AGKdC8o9qrdu7ThnOdnvyPWbhX8XFbMnUdwO1aPkW9JtJAPxICEMJ1COpLFpeAxc3VXStil8kBsP1lsetyIhT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(8936002)(8676002)(6512007)(4326008)(2616005)(86362001)(26005)(6506007)(53546011)(66946007)(186003)(54906003)(5660300002)(76116006)(66476007)(2906002)(71200400001)(91956017)(83380400001)(66446008)(66556008)(64756008)(498600001)(6486002)(110136005)(6636002)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: OI8Ae3MEgZ26zAz+1vtFmgN9MGpPV+B6OE2Ow4a56wvOf8kcj/OewoopxK4ZQGDtZAYI6yVLwjaowY3h8+OoaKI4EeWsPL3B/5rFArgMVZLzGD1FsoVwhpzTIUbMgBW2WAnKWPcjcNMpO2qXLn7m7PWIU1K3mGrcN7blPpDcmRXiNdq0V68z5YHQXs4ez+yuZW7TBDRkda/Pys4zUXWTpIPYqkJHq7/hXcl9RUeKfIVz3JNtHfbX58eqVcVPmdiAEFg2hZG4Ty3Cfm/sU5UAtNTMk5Ox5sgea8RWTIOUwCKpwTz3IZZVwQKQvS7y1MD0fbGuisuSzv2HOZ/s66ovl/boc7IahVCxzYqRBXtga9vmG/+mU7A8ST4dkhluiqg8g4dpY5+Rq0txGj+xBNO9K9i3eqMyohnm2HBwksIXWZ0f6A/3q/Q5ex0fjfw+uFNHzxTFk4jNJ8Dj1Wwm93HXfGjvaWyaqJ0vujPrXjSRyMRuP/1Ba4WyvDFGp1QQUMRlHXRP3YJ3VmoLN37X77+Xyqnt3ixGRrRr25SAyjKHeMz9kdRFnV2jig9VieDqdshP6P83JdtntqbbM7zHzEFsBE47HkYfBSESGucn29ki/kw+37Aa9YOOUlPD/tWeJi4H6AguOvw0LAi88hT90WzDYA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <0854F140C380D34FAED0A7031012A800@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e100f3-0012-44b8-e316-08d8332e127d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 19:40:24.3559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NhgM84e6gCU4DzJpprFu1FefKZhB1TBDNp13o+9ANdQ+b69sgzkYiLEQh4yha2s6iQjXB6B7yHPfhUQ48mvsDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6269
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA3LTI4IGF0IDEzOjI0ICswMzAwLCBPciBHZXJsaXR6IHdyb3RlOg0KPiBP
biBUdWUsIEp1bCAyOCwgMjAyMCBhdCAxMjoxNiBQTSBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1l
bGxhbm94LmNvbT4NCj4gd3JvdGU6DQo+ID4gRnJvbTogUm9uIERpc2tpbiA8cm9uZGlAbWVsbGFu
b3guY29tPg0KPiA+IA0KPiA+IFdoZW4gc2V0dGluZyB0aGUgUEYgaW50ZXJmYWNlIHVwL2Rvd24s
IG5vdGlmeSB0aGUgZmlybXdhcmUgdG8NCj4gPiB1cGRhdGUNCj4gPiB1cGxpbmsgc3RhdGUgdmlh
IE1PRElGWV9WUE9SVF9TVEFURQ0KPiANCj4gSG93IHRoaXMgcmVsYXRlcyB0byBlLXN3aXRjaGlu
Zz8gdGhlIHBhdGNoIHRvdWNoZXMgdGhlIGUtc3dpdGNoIGNvZGUNCj4gYnV0IEkgZG9uJ3Qgc2Vl
IG1lbnRpb25pbmcgb2YgdGhhdCBpbiB0aGUgY2hhbmdlLWxvZy4uDQo+IA0KDQpzZWUgYmVsb3cg
InVwbGluayBwb3J0IiBhbmQgIlZGIiB0aGVzZSB0ZXJtcyBhcmUgb25seSB1c2VkIGluIHdpdGgg
ZS0NCnN3aXRjaGluZy4uDQoNCj4gPiBUaGlzIGJlaGF2aW9yIHdpbGwgcHJldmVudCBzZW5kaW5n
IHRyYWZmaWMgb3V0IG9uIHVwbGluayBwb3J0IHdoZW4NCj4gPiBQRiBpcw0KPiA+IGRvd24sIHN1
Y2ggYXMgc2VuZGluZyB0cmFmZmljIGZyb20gYSBWRiBpbnRlcmZhY2Ugd2hpY2ggaXMgc3RpbGwN
Cj4gPiB1cC4NCj4gPiBDdXJyZW50bHkgd2hlbiBjYWxsaW5nIG1seDVlX29wZW4vY2xvc2UoKSwg
dGhlIGRyaXZlciBvbmx5IHNlbmRzDQo+ID4gUEFPUw0KPiA+IGNvbW1hbmQgdG8gbm90aWZ5IHRo
ZSBmaXJtd2FyZSB0byBzZXQgdGhlIHBoeXNpY2FsIHBvcnQgc3RhdGUgdG8NCj4gPiB1cC9kb3du
LCBob3dldmVyLCBpdCBpcyBub3Qgc3VmZmljaWVudC4gV2hlbiBWRiBpcyBpbiAiYXV0byIgc3Rh
dGUsDQo+ID4gaXQNCj4gDQo+ICJhdXRvIiBpcyBuYXN0eSBjb25jZXB0IHRoYXQgYXBwbGllcyBv
bmx5IHRvIGxlZ2FjeSBtb2RlLiBIb3dldmVyLA0KPiB0aGUgcGF0Y2gNCj4gdG91Y2hlcyB0aGUg
c3dpdGNoZGV2IG1vZGUgKHJlcHJlc2VudG9ycykgY29kZSwgcGxlYXNlIGV4cGxhaW4uLi4NCj4g
DQoNCiJBVVRPIiBpcyBhbHNvIG1seDUgY29uY2VwdCB3aGljaCBpcyBkZWZhdWx0IGJ5IEZXLg0K
DQpQcmlvciB0byB0aGlzIHBhdGNoIHRoZSB1cGxpbmsgc3RhdGUgd2FzIG5ldmVyIHRvdWNoZWQg
YnkgZHJpdmVyIHNvIG5vdw0KYXMgaXQgY2FuIGJlIG92ZXJ3cml0dGVuIGJ5IHRoZSBQRiBkcml2
ZXIgb24gbGVnYWN5L3NpbmdsZSBuaWMgbW9kZSwNCndoZW4gc3dpdGNoaW5nIHRvIHN3aXRjaGRl
diBtb2RlIHdlIG5lZWQgdG8gYnJpbmcgYmFjayB0aGUgRlcgZGVmYXVsdA0KdmFsdWUgIkFVVE8i
Lg0KDQpXaWxsIGFkZCB0aGlzIHRvIHRoZSBjb21taXQgbWVzc2FnZS4NCg0KPiA+IGZvbGxvd3Mg
dGhlIHVwbGluayBzdGF0ZSwgd2hpY2ggd2FzIG5vdCB1cGRhdGVkIG9uDQo+ID4gbWx4NWVfb3Bl
bi9jbG9zZSgpDQo+ID4gYmVmb3JlIHRoaXMgcGF0Y2guDQo+ID4gDQo+ID4gRml4ZXM6IDYzYmZk
Mzk5ZGU1NSAoIm5ldC9tbHg1ZTogU2VuZCBQQU9TIGNvbW1hbmQgb24gaW50ZXJmYWNlDQo+ID4g
dXAvZG93biIpDQo+ID4gU2lnbmVkLW9mZi1ieTogUm9uIERpc2tpbiA8cm9uZGlAbWVsbGFub3gu
Y29tPg0KPiA+IFJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3guY29tPg0KPiA+
IFJldmlld2VkLWJ5OiBNb3NoZSBTaGVtZXNoIDxtb3NoZUBtZWxsYW5veC5jb20+DQo=
