Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46509191F58
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 03:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgCYCkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 22:40:15 -0400
Received: from mail-eopbgr40045.outbound.protection.outlook.com ([40.107.4.45]:50908
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727262AbgCYCkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 22:40:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdxdWG5QS4hCCLACQPLQcYapqzodzGH0iBGz3aegiLbUMgbN7iBbzWTnOjf1iwE/ZMfVFtSMe5frOxNv8rSDMtVnR2+aqwVxAFCpRY2VXhNzF26u00T2UVxW8h0kmT0sbwmB+zu4zEA0OTBbSyiBqY7oxcyXSzCvXojENn3qVLA3clC5n8oNUya6ayZQV3c2+GBFuHjDAAbrVf3FHU/AKISwph8WzB7rsDSYosj6EzIz27EimbSPrXFqPt/+FOGUf+t6s4PpOgF+0jpmsc1KNmHZ4tyBOhWwobKu/6BD9W0iART+fINRG30ZeubjA5Q0B7argMSInwCEuWIRiA6ONw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ele5lyPxvjZtKjMR/uewsh3BBahyYtUD3TulFn3xgcI=;
 b=QKl35l7QJVhjoXyVIiZCJPTRcywmEE3wc+jtatOToxLvHclF/b4fd9XNvUOrIGJGuJhLSwITBm5OPdwl+mWcAqIKoXP5kvnXCD4lCpSaatIPd8+6u6amLtDmZFg88/E5sm5CNsd1CocgqujJhwma2SCi0SSyIkfF4U1ZPJEeHDLNFySbEFYnCxv4A+sXVs4XvTwhpLu6TJ5PIDLRJ3sApVP1cx4EgNv8skxb4naGE3hSS9a43ymIVl2Dh5Irv3eTfcl5TuHq2Qu1MYeJfd4tQNpDw6gZDCsst94Rc/EutXAxegEKC8jtuKhRbaOC/FIKWfCt8ctX3ibeP6BwEOSgpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ele5lyPxvjZtKjMR/uewsh3BBahyYtUD3TulFn3xgcI=;
 b=FGS5tV0RGt6lth5MgRBSmiX5rluvo0BQ3h4yxYI1HOyplRqRPFL3M4y8tkjn/8bDQAFAajdjVpwqnhrNyCptouN0lRv8HixeYK0gkFHlNJN5Cp0SgOrAlCYCarKKQ2zI+e/pRtZXtUBzOAZAvkrGhSRPKYImlvsFk7Ix6UZPMHQ=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6720.eurprd04.prod.outlook.com (20.179.234.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.19; Wed, 25 Mar 2020 02:40:10 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 02:40:10 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
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
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: RE: [EXT] Re: [v1,iproute2  1/2] iproute2:tc:action: add a gate
 control action
Thread-Topic: [EXT] Re: [v1,iproute2  1/2] iproute2:tc:action: add a gate
 control action
Thread-Index: AQHWAZHWX+H5eRA0m0Grm7QJOd4mkqhYS8MAgABN7vA=
Date:   Wed, 25 Mar 2020 02:40:10 +0000
Message-ID: <VE1PR04MB64968CF9E07D5CA510D2369492CE0@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200306125608.11717-11-Po.Liu@nxp.com>
        <20200324034745.30979-1-Po.Liu@nxp.com>
        <20200324034745.30979-7-Po.Liu@nxp.com> <20200324145912.657f2c9e@hermes.lan>
In-Reply-To: <20200324145912.657f2c9e@hermes.lan>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c697a10f-2db9-4b81-6444-08d7d065d66f
x-ms-traffictypediagnostic: VE1PR04MB6720:|VE1PR04MB6720:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB672028A8F14E4F1F884CAC6B92CE0@VE1PR04MB6720.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(186003)(5660300002)(52536014)(2906002)(7696005)(26005)(55016002)(8676002)(81166006)(8936002)(33656002)(71200400001)(9686003)(81156014)(76116006)(478600001)(6916009)(54906003)(66476007)(64756008)(66446008)(66556008)(6506007)(66946007)(86362001)(4326008)(53546011)(316002)(44832011)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6720;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2W61KSA863jYWcraNMZgFJgEbApdoFndW6vdFRLIjpibmqtc0/ChNQdOTOE52LfmWadS5OLT6Alr5l7U46YpbmbqgLZRcZIPsHMEYjS4qwfurJy8b866FsoYNxT3GpIzt2DnlG0tY705M1e8ZRUUTamb1DvX79ap2wJ7qNgYVsGTqa5aLcYuPIs6NRkz7mPLuYKcY+Oo0R+E0pl2QE3wI3JaXNuDpGi0b1L2KCPyrfgxEawxsZ4ActjX5/gWhdLIOk4lEMLoK95n/0xWdfXTdZL7nSpduE7st1i4k97rQiMkEzazmJ9BX6wEx1f+KXHIF73Um26o5hNYIyk9FtJCAa7vuX9uSr+1XxFMsSCdGBtM1x5m64NQ2hRNaADP4tUINXMrpIUqvFBe4YQZF2U8+C3//RitbYd/vlNm56ilh1cOUrvC0+oIdnlZOHP3tR94
x-ms-exchange-antispam-messagedata: 6sDZez9rjGZK9qtvYQApxfpS44ffcaHSjU7WMmUiH43iyYcsduvHY0NPMdiuGFkwtQqdVeeLlFYw+7wS5ho1ZDaeTyLIx6EM51hpAefdv1Tvt6Gphk1wUSxXI97sNW/bD3puKc6sNXi+zwTwyYQ5oQ==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c697a10f-2db9-4b81-6444-08d7d065d66f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 02:40:10.2174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mG67uX2WFdEvxiSRcYc+JlFox1je/yYq5/14GSvMupJlQeXVKEg7X1Nz2jJCyxn1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RlcGhlbiwNCg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFN0
ZXBoZW4gSGVtbWluZ2VyIDxzdGVwaGVuQG5ldHdvcmtwbHVtYmVyLm9yZz4NCj4gU2VudDogMjAy
MMTqM9TCMjXI1SA1OjU5DQo+IFRvOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPg0KPiBDYzogZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldDsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgdmluaWNpdXMuZ29tZXNAaW50ZWwuY29tOyBDbGF1ZGl1IE1hbm9p
bA0KPiA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNvbT47IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIu
b2x0ZWFuQG54cC5jb20+Ow0KPiBBbGV4YW5kcnUgTWFyZ2luZWFuIDxhbGV4YW5kcnUubWFyZ2lu
ZWFuQG54cC5jb20+OyBYaWFvbGlhbmcgWWFuZw0KPiA8eGlhb2xpYW5nLnlhbmdfMUBueHAuY29t
PjsgUm95IFphbmcgPHJveS56YW5nQG54cC5jb20+OyBNaW5na2FpIEh1DQo+IDxtaW5na2FpLmh1
QG54cC5jb20+OyBKZXJyeSBIdWFuZyA8amVycnkuaHVhbmdAbnhwLmNvbT47IExlbyBMaQ0KPiA8
bGVveWFuZy5saUBueHAuY29tPjsgbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTsgdmlzaGFsQGNo
ZWxzaW8uY29tOw0KPiBzYWVlZG1AbWVsbGFub3guY29tOyBsZW9uQGtlcm5lbC5vcmc7IGppcmlA
bWVsbGFub3guY29tOw0KPiBpZG9zY2hAbWVsbGFub3guY29tOyBhbGV4YW5kcmUuYmVsbG9uaUBi
b290bGluLmNvbTsNCj4gVU5HTGludXhEcml2ZXJAbWljcm9jaGlwLmNvbTsga3ViYUBrZXJuZWwu
b3JnOyBqaHNAbW9qYXRhdHUuY29tOw0KPiB4aXlvdS53YW5nY29uZ0BnbWFpbC5jb207IHNpbW9u
Lmhvcm1hbkBuZXRyb25vbWUuY29tOw0KPiBwYWJsb0BuZXRmaWx0ZXIub3JnOyBtb3NoZUBtZWxs
YW5veC5jb207IG0ta2FyaWNoZXJpMkB0aS5jb207DQo+IGFuZHJlLmd1ZWRlc0BsaW51eC5pbnRl
bC5jb207IERhdmlkIEFoZXJuIDxkc2FoZXJuQGdtYWlsLmNvbT4NCj4gU3ViamVjdDogW0VYVF0g
UmU6IFt2MSxpcHJvdXRlMiAxLzJdIGlwcm91dGUyOnRjOmFjdGlvbjogYWRkIGEgZ2F0ZSBjb250
cm9sDQo+IGFjdGlvbg0KPiANCj4gQ2F1dGlvbjogRVhUIEVtYWlsDQo+IA0KPiBPbiBUdWUsIDI0
IE1hciAyMDIwIDExOjQ3OjQ0ICswODAwDQo+IFBvIExpdSA8UG8uTGl1QG54cC5jb20+IHdyb3Rl
Og0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3BrdF9jbHMuaA0KPiA+
IGIvaW5jbHVkZS91YXBpL2xpbnV4L3BrdF9jbHMuaCBpbmRleCBhNmFhNDY2Li43YTA0N2E5IDEw
MDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9wa3RfY2xzLmgNCj4gPiArKysgYi9p
bmNsdWRlL3VhcGkvbGludXgvcGt0X2Nscy5oDQo+ID4gQEAgLTEwNiw2ICsxMDYsNyBAQCBlbnVt
IHRjYV9pZCB7DQo+ID4gICAgICAgVENBX0lEX1NBTVBMRSA9IFRDQV9BQ1RfU0FNUExFLA0KPiA+
ICAgICAgIFRDQV9JRF9DVElORk8sDQo+ID4gICAgICAgVENBX0lEX01QTFMsDQo+ID4gKyAgICAg
VENBX0lEX0dBVEUsDQo+ID4gICAgICAgVENBX0lEX0NULA0KPiA+ICAgICAgIC8qIG90aGVyIGFj
dGlvbnMgZ28gaGVyZSAqLw0KPiA+ICAgICAgIF9fVENBX0lEX01BWCA9IDI1NQ0KPiANCj4gQWxs
IHVhcGkgaGVhZGVycyBuZWVkIHRvIGNvbWUgZnJvbSBjaGVja2VkIGluIGtlcm5lbC4NCj4gDQo+
IFRoaXMgaXMgYW4gZXhhbXBsZSBvZiB3aHksIHlvdSBoYXZlIGFuIG91dCBvZiBkYXRlIHZlcnNp
b24gYmVjYXVzZSB0aGlzDQo+IHZlcnNpb24gd291bGQgaGF2ZSBicm9rZW4gQUJJLg0KPiANCj4g
DQo+IFRoaXMgcGF0Y2ggc2hvdWxkIGJlIGFnYWluc3QgaXByb3V0ZTItbmV4dCBzaW5jZSBiZWNh
dXNlIGl0IGRlcGVuZHMgb24NCj4gbmV0LW5leHQuDQoNCkknbGwga2VlcCB1cCB3aXRoIHRoZSBp
cHJvdXRlMi1uZXh0IGJyYW5jaC4gVGhhbmtzIQ0KDQpCciwNClBvIExpdQ0K
