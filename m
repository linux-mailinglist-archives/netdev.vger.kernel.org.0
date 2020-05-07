Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988C51C7FFE
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 04:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgEGC2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 22:28:17 -0400
Received: from mail-eopbgr50079.outbound.protection.outlook.com ([40.107.5.79]:38761
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbgEGC2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 22:28:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVT3pNqQ4Iab71GACnK0bnZLjcBtavehfnFxl2MQ4LRzOgo4wnfH3qSi0f2ACnG+BVHxvF09GIW8sMYgOGL8xBF4PiRO8AK1LdbOux5C96bb0s2aTW6FzsZ28cOunOm34EkD+YxQTa/rDKAkH3fkp3mkRd1TrfneqzxEwqyEklV/kiT/8aS8lPD9f1fzdDhrLvHl+96DuW/vMre3HtIEnvbWMd2SBnAdLi2bQ8YhEi5YPqy7Xj0VBAo8r57U8j78y1aMy8Kl3Y8zBgnR19G/Ze6NMLlfSQ/m+SQrXB56+9EJGIRXSqrVCP9QA0s2oFOiypCeDZKIGWHpB5EP+Uiotw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rx9jRYwn/EHcrLvfHyI9eUg+oXhhFGvsSMTL0kDUwIM=;
 b=m3AYMRrSS3gdGjKRn0kNewSL9lkrDamwv+fx+q8lTALrwGR7UXxsFHMgEb17AL5vbfjQ1FDQKiDCAad5zubROEYau7LeCoeSVxcDOVXhzpAJ7CfvUCVSZtLfNwPFAAmmoFDjvq0VRx3uAwVdFh2+pF+4XstfKeKcEc8dqabmdxD11LbwVRLPN+dHrs0pFSa4WB7W2XD3w5EWWp+o+AziGlfpU+vkPKPY8iUWOEpYWzo2plJQIasqZMwykfPxIocA8pAEc4gIbQPy9KAuejwDnEu5ojrcqMOIcmiZcXCKyPPGnJ9JCp6LdmFow8Gw9z9FHPM0BhICEUf5KaevNgm1GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rx9jRYwn/EHcrLvfHyI9eUg+oXhhFGvsSMTL0kDUwIM=;
 b=ZFs7bWFj0luCWlphdwuX1q5oX/5B87fLbQIFb4hEZlOLdhvI0jcFzZFPI7grxkY391sCt4Z96ZFwpc8oQCY5o67GqIcBxVS6noTlYgj5IQ/c2MDoUqb2jINtoh8I9CScsjoRKiy0ZhDCMguhrQ5Ql3hQvQExObbuhwFY207tCdI=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6702.eurprd04.prod.outlook.com (2603:10a6:803:123::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Thu, 7 May
 2020 02:28:10 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.030; Thu, 7 May 2020
 02:28:10 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Davide Caratti <dcaratti@redhat.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: RE: [EXT] Re: [v4,iproute2-next 1/2] iproute2-next:tc:action: add a
 gate control action
Thread-Topic: [EXT] Re: [v4,iproute2-next 1/2] iproute2-next:tc:action: add a
 gate control action
Thread-Index: AQHWI4TcMEGEKP3B00eK+FTdZ8sAGaibA+gAgADiSlA=
Date:   Thu, 7 May 2020 02:28:10 +0000
Message-ID: <VE1PR04MB64962F48A04FA87C4B1EC54B92A50@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200503063251.10915-2-Po.Liu@nxp.com>
         <20200506084020.18106-1-Po.Liu@nxp.com>
 <5fd2df286f6d5bf813361cc8c907a155976a5c82.camel@redhat.com>
In-Reply-To: <5fd2df286f6d5bf813361cc8c907a155976a5c82.camel@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 16e3cdc0-7e78-47f7-c50e-08d7f22e4950
x-ms-traffictypediagnostic: VE1PR04MB6702:|VE1PR04MB6702:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6702BDE371A807959F2F8AF592A50@VE1PR04MB6702.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03965EFC76
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4hcEoO1CA2ctOPthvpyz36z2nbpvtDWRUFERdqbqfCTWFsRhFRa7Pg1phrshja9CO2ZNSflfW/niV87FOoVb3RBKgZdbfAuZ+M0dEe6D534iTgFJGuDWhx3NWE371P5RY2sEH8s8a/Lp7j8+0mFMWaA8LYRi+2Fw5vmKiT07kc2wLpv5agz4YOUP+8wIDFWL5UhsDdvqRPITUucBj+RRQ7nJ21f+5++vLUo8iY1wkJTlwokuDX2R0OAg2jItjbWSRKWDBLJ8QsNZGRyT63Sv6FKx4nCnlJEfdEWPpJPhwBDMywKUebo4ANyp5sPx7jFY0ZYcG2dsC972MM/mstyfb8xJlbQb7/IRAQyj3pnrRilgl0O+EFjcBkGKdvFRo5cJgErwijzHQI66c0Jn73qnScAx02zGC8WNvhN6tztEj3LaJrgAmjHHgP0ixDS78jiHPZsuotSAzhXdgkWzAdgNLyxl2eLMxE2rJzNIWEO48zLm3+XkJPmJKa4PV0VxdRvuzSghHWOyOWKmst8RZ6ehUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(33430700001)(52536014)(316002)(2906002)(53546011)(8676002)(4326008)(33440700001)(8936002)(83290400001)(83280400001)(83320400001)(83310400001)(83300400001)(9686003)(6506007)(86362001)(55016002)(66946007)(76116006)(26005)(66476007)(66446008)(64756008)(66556008)(5660300002)(478600001)(44832011)(186003)(33656002)(54906003)(7696005)(110136005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: InPv8HtorY2le6KTE4ilScfFMM22Xoy2Uvk4duZD1hQBcV6yBr5nl0P3v/vooUwa2eAHu1GRtlWmEm6pSew120tuYDUHobCrBBy2YWrg5ICe1JhUlq9Dfq2Iqk9xbfZTbGo84+Iu0UrnS33/WH4NmEm8aHMSljJas24D0rQFD7MtU2YNJvsnn4NqO/V5bXlaa4QRhQrLyRUp1uYAcfA4EnlXRcMv385bm6bp9+o0Pr49JwYmLAQCPObdZSvHmuRfwSjhNTMsAZOCM/hmOfUqTmh8Ng7aSI043lXcwawxVJNg9Y+XPEpvq2oemed0uw22DQugUK/kUeOLlPgxdZ6C0/FKexSH15z3VFLF5A5ia6ZwRcKBekvgJTFOmZjEKJIHlKaqu9EGxlDh0Vy4CRnZ8xyXAYgf87I6b3zS+RSNa6JzEIlBiZ0LZurmhjjUiGsxio6fTentVrvy29UMqgy3fqiPDVCBbc7VXS7o7DATmjl1LHTi86XQiAhM6zOK2Ljl+isZsfzkQBZrrJtATMci5xHUVLbA4owipH7LPOkEJcxtCUAJ1FqqIcdVBNIZkhY6F5jKftCJSpcHCGbD5GDQMv4gQ+BQewuKCtRJ1W+rPr7xXX/dVaq3c+CBbYdPxnWDPr1oyspaOJ/u9Z4Y1Qhzke+9huWD6+/KEFmq3YKzqeWnP+o3TE8WW/ZvlxVlzBJR9p1I87ftaIY70WgO352vY267k1HUWyc7NTRhFEatqXTU4ppdO7qgCVmAMJ/6OKJpC1lZk1DI54zysBa9wV0R7aiH79tW0ywi8QRQELChc6I=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e3cdc0-7e78-47f7-c50e-08d7f22e4950
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2020 02:28:10.8102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zTBTuhiVIHWfju5mTc5F3xtaKxtGUD8PrnKDupS8J8Zx4WDilkT1dEnJwdGiy7A4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6702
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWRlLA0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2
aWRlIENhcmF0dGkgPGRjYXJhdHRpQHJlZGhhdC5jb20+DQo+IFNlbnQ6IDIwMjDlubQ15pyINuaX
pSAyMDo1NA0KPiBUbzogUG8gTGl1IDxwby5saXVAbnhwLmNvbT47IGRzYWhlcm5AZ21haWwuY29t
OyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
Zw0KPiBDYzogdmluaWNpdXMuZ29tZXNAaW50ZWwuY29tOyBzdGVwaGVuQG5ldHdvcmtwbHVtYmVy
Lm9yZzsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgdmxhZEBidXNsb3YuZGV2OyBDbGF1ZGl1IE1h
bm9pbA0KPiA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNvbT47IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGlt
aXIub2x0ZWFuQG54cC5jb20+Ow0KPiBBbGV4YW5kcnUgTWFyZ2luZWFuIDxhbGV4YW5kcnUubWFy
Z2luZWFuQG54cC5jb20+DQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbdjQsaXByb3V0ZTItbmV4dCAx
LzJdIGlwcm91dGUyLW5leHQ6dGM6YWN0aW9uOiBhZGQgYQ0KPiBnYXRlIGNvbnRyb2wgYWN0aW9u
DQo+IA0KPiBDYXV0aW9uOiBFWFQgRW1haWwNCj4gDQo+IE9uIFdlZCwgMjAyMC0wNS0wNiBhdCAx
Njo0MCArMDgwMCwgUG8gTGl1IHdyb3RlOg0KPiA+IEludHJvZHVjZSBhIGluZ3Jlc3MgZnJhbWUg
Z2F0ZSBjb250cm9sIGZsb3cgYWN0aW9uLg0KPiBbLi4uXQ0KPiANCj4gaGVsbG8gUG8gTGl1LA0K
PiANCj4gWy4uLl0NCj4gDQo+ID4gK2NyZWF0ZV9lbnRyeToNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgZSA9IGNyZWF0ZV9nYXRlX2VudHJ5KGdhdGVfc3RhdGUsIGludGVydmFsLA0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaXB2LCBtYXhvY3RldHMp
Ow0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBpZiAoIWUpIHsNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgImdhdGU6IG5vdCBlbm91Z2ggbWVtb3J5
XG4iKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmcmVlX2VudHJpZXMoJmdh
dGVfZW50cmllcyk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC0x
Ow0KPiA+ICsgICAgICAgICAgICAgICAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICBsaXN0X2FkZF90YWlsKCZlLT5saXN0LCAmZ2F0ZV9lbnRyaWVzKTsNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgZW50cnlfbnVtKys7DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAg
fSBlbHNlIGlmIChtYXRjaGVzKCphcmd2LCAicmVjbGFzc2lmeSIpID09IDAgfHwNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICAgbWF0Y2hlcygqYXJndiwgImRyb3AiKSA9PSAwIHx8DQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgIG1hdGNoZXMoKmFyZ3YsICJzaG90IikgPT0gMCB8fA0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICBtYXRjaGVzKCphcmd2LCAiY29udGludWUiKSA9
PSAwIHx8DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgIG1hdGNoZXMoKmFyZ3YsICJwYXNz
IikgPT0gMCB8fA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICBtYXRjaGVzKCphcmd2LCAi
b2siKSA9PSAwIHx8DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgIG1hdGNoZXMoKmFyZ3Ys
ICJwaXBlIikgPT0gMCB8fA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICBtYXRjaGVzKCph
cmd2LCAiZ290byIpID09IDApIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgaWYgKHBhcnNl
X2FjdGlvbl9jb250cm9sKCZhcmdjLCAmYXJndiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICZwYXJtLmFjdGlvbiwgZmFsc2UpKSB7DQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgZnJlZV9lbnRyaWVzKCZnYXRlX2VudHJpZXMpOw0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtMTsNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgfQ0KPiA+ICsgICAgICAgICAgICAgfSBlbHNlIGlmIChtYXRjaGVzKCph
cmd2LCAiaGVscCIpID09IDApIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgdXNhZ2UoKTsN
Cj4gPiArICAgICAgICAgICAgIH0gZWxzZSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIGJy
ZWFrOw0KPiA+ICsgICAgICAgICAgICAgfQ0KPiA+ICsNCj4gPiArICAgICAgICAgICAgIGFyZ2Mt
LTsNCj4gPiArICAgICAgICAgICAgIGFyZ3YrKzsNCj4gPiArICAgICB9DQo+ID4gKw0KPiA+ICsg
ICAgIHBhcnNlX2FjdGlvbl9jb250cm9sX2RmbHQoJmFyZ2MsICZhcmd2LCAmcGFybS5hY3Rpb24s
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmYWxzZSwgVENfQUNUX1BJUEUp
Ow0KPiANCj4gaXQgc2VlbXMgdGhhdCB0aGUgY29udHJvbCBhY3Rpb24gaXMgcGFyc2VkIHR3aWNl
LCBhbmQgdGhlIGZpcnN0IHRpbWUgaXQgZG9lcw0KPiBub3QgYWxsb3cgImp1bXAiIGFuZCAidHJh
cCIuIElzIHRoYXQgaW50ZW50aW9uYWw/IElPVywgYXJlIHRoZXJlIHNvbWUNCj4gImFjdF9nYXRl
IiBjb25maWd1cmF0aW9ucyB0aGF0IGRvbid0IGFsbG93IGp1bXAgb3IgdHJhcD8NCg0KSXQgaXMg
YWxsb3dlZCB0byBqdW1wIGFuZCB0cmFwLiBJIGRpZG4ndCBub3RpY2UgaXQgd2FzIGxvYWRlZCB0
d2ljZS4gSSB3b3VsZCBjb3JyZWN0IGhlcmUgYW5kIHJlbW92ZSBvbmUgcGFyc2VfYWN0aW9uX2Nv
bnRyb2woKQ0KVGhhbmtzIGEgbG90IQ0KDQo+IA0KPiBJIGRvbid0IHNlZSBhbnl0aGluZyBzaW1p
bGFyIGluIGtlcm5lbCBhY3RfZ2F0ZS5jLCB3aGVyZSB0Y2ZfZ2F0ZV9hY3QoKSBjYW4NCj4gcmV0
dXJuIFRDX0FDVF9TSE9UIG9yIHdoYXRldmVyIGlzIHdyaXR0ZW4gaW4gcGFybS5hY3Rpb24uIFRo
YXQncyB3aHkgSSdtDQo+IGFza2luZywgaWYgdGhlc2UgdHdvIGNvbnRyb2wgYWN0aW9ucyBhcmUg
Zm9yYmlkZGVuIHlvdSBzaG91bGQgbGV0IHRoZSBrZXJuZWwNCj4gcmV0dXJuIC1FSU5WQUwgd2l0
aCBhIHByb3BlciBleHRhY2sgaW4gdGNmX2dhdGVfaW5pdCgpLiBDYW4geW91IHBsZWFzZQ0KPiBj
bGFyaWZ5Pw0KPiANCj4gdGhhbmsgeW91IGluIGFkdmFuY2UhDQo+IC0tDQo+IGRhdmlkZQ0KPiAN
Cg0KDQpCciwNClBvIExpdQ0K
