Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658BA12B07A
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 03:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfL0CLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 21:11:46 -0500
Received: from mail-eopbgr40083.outbound.protection.outlook.com ([40.107.4.83]:31401
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbfL0CLq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 21:11:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATcJNWxl3idoFzGSHykPUeFc69lnDg7McfFZf5IK9wFCmjPDu8dj9WUorMu/z/eKWAm+7ILNMolYBpD92wpFLUgQhe3o29NyC+9Ic+KfK2TOQxuaIkERRMz4d7qKuQp/1nUENcCaEAKa9oq6bHhw02vSFSOeUUfnt4tWM9WI3G6V2ZqP3lC62K5T+S6iFq5F+BYkKjvCpYMVyfQ5gu1/M622WG6lnvysC6ERmgmnSjsPD7Bh5pQWrgeJmwfDbhoFjAEISYFpn+Zyxj5ljNEgSIKs8nTGmpvS7sHwq+8ByUezlKEFDiM7Q3bBf2FUlPV9XKPZA9PD6stKblqA8lOgXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6SXIiQgP2uAPLgIa/gbTjsfIt3VtJaG54iIOQl0vRk=;
 b=TBmRDjSnMrPXen5KbkAFzWcKJ+dcExNEMAY9/d1VWIxM44its7DgSDFI5FBDJEJPcNoEeb3lee6yQ83Vx4qdP9CVxET8kRhmhbVBxv1uno3e2+O+TOC6DwxLIABY5z3EGKy0QrXnYrmZCE2rTqaxYGqXON+uFqvAImJG59VkM5OsAJ81ucU+NXUiGtn+JGpyiiFIl0MiWomQWq0YgT7b8ikfZzilFZpBBPw0sauCkCTqFgwebV9SdwuAWhNxkf5i3uR1eG3a3AjGkNSUDoIAmqsI5uTxetiJEYDUKdatPqmi8mrAS6ecXPPhcO+r+B1Q4JYLy7UM9wawmKGs3f+SHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6SXIiQgP2uAPLgIa/gbTjsfIt3VtJaG54iIOQl0vRk=;
 b=RfBa3CkWxD0slWRnRcN176hmKvdzneWcL75Ey9D5jpsqa57r745N44FNZIFE0NaCte6Ds7NG3fuetwK/BulNKL7+etShfh+HpY14sBp5O1bQ6jjYMr+QPhXek6IthO/NQvibfYksQYLSUh4tXI7m1g1mh/GweUYeHjbxOTZaffo=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6656.eurprd04.prod.outlook.com (20.179.235.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Fri, 27 Dec 2019 02:11:42 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::b870:829f:748a:4bc]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::b870:829f:748a:4bc%3]) with mapi id 15.20.2581.007; Fri, 27 Dec 2019
 02:11:41 +0000
From:   Po Liu <po.liu@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>
Subject: RE: [EXT] Re: [net-next] enetc: add support time specific departure
 base on the qos etf
Thread-Topic: [EXT] Re: [net-next] enetc: add support time specific departure
 base on the qos etf
Thread-Index: AQHVuUMFGbRcJW58xE+CKKbOYElKEqfNEJSAgAAvp/A=
Date:   Fri, 27 Dec 2019 02:11:41 +0000
Message-ID: <VE1PR04MB64967EB9ED113EF77B48D7E8922A0@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20191223032618.18205-1-Po.Liu@nxp.com>
 <20191226.150941.618022568387879445.davem@davemloft.net>
In-Reply-To: <20191226.150941.618022568387879445.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: babb86cc-d48e-4cf9-bbcb-08d78a721d55
x-ms-traffictypediagnostic: VE1PR04MB6656:|VE1PR04MB6656:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6656DB35D6649E7691A38F95922A0@VE1PR04MB6656.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0264FEA5C3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(189003)(199004)(13464003)(8936002)(8676002)(81166006)(81156014)(5660300002)(76116006)(66946007)(33656002)(66446008)(64756008)(66556008)(66476007)(54906003)(186003)(55016002)(7696005)(2906002)(26005)(44832011)(9686003)(478600001)(86362001)(6506007)(53546011)(4326008)(316002)(52536014)(71200400001)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6656;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Myb1iP9vTtJ4O0izUUY24iUTDMYr06E4YUmQv3nnMWcaSJk6VRK13OEL2gNAaBJKaK4sdSAZr+oovvPTPKHFhmG8wWWMClLLUoeSvsLtFY+Nth9ftiud7RrT7ZXRGqGOVXm/izj0M7Jna6gE81PlWEOUCeyBe2mSrzSp8OIDLqwm1lzrnNNeNjc/BD4xWKDINbgEyc0A12WVA9d+hN5a/NDCZeVSATME7EOF04bVKV37hladfYHBOPX5fzNufGpfaZ6IhSj7QZHh5SOsfuZaeInxn2OvetQX5jAMZQWUF0k9X68SJp3yChrJQYf5gQWvYTPSakyKJNFD9yI96lwBtbh/SFZxsFiR1pt3SoHomBi2md86O21eOIURORtIk5ky28NHZREqv/rCaGNURTS2Os3TTci5gKZb2uBjMocfntGlHO3+xfkq4Jk86i4zGW2IVoHv6HvRl7SJfPDMXWynus6zNKM/yYIgfeyHGorBVVdIhim2m6Y2aE6eDJVJatv
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: babb86cc-d48e-4cf9-bbcb-08d78a721d55
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Dec 2019 02:11:41.2621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioN/BvVdZc28ANu/mAqUItKpefaWeYRHvy8i6PduhgldtZrLELCICAZbmsuCY+X2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6656
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCg0KQnIsDQpQbyBMaXUNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9t
OiBEYXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IFNlbnQ6IDIwMTnE6jEy1MIy
N8jVIDc6MTANCj4gVG86IFBvIExpdSA8cG8ubGl1QG54cC5jb20+DQo+IENjOiBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiB2aW5pY2l1cy5n
b21lc0BpbnRlbC5jb207IENsYXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPjsN
Cj4gVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47IEFsZXhhbmRydSBN
YXJnaW5lYW4NCj4gPGFsZXhhbmRydS5tYXJnaW5lYW5AbnhwLmNvbT47IFhpYW9saWFuZyBZYW5n
DQo+IDx4aWFvbGlhbmcueWFuZ18xQG54cC5jb20+OyBSb3kgWmFuZyA8cm95LnphbmdAbnhwLmNv
bT47IE1pbmdrYWkgSHUNCj4gPG1pbmdrYWkuaHVAbnhwLmNvbT47IEplcnJ5IEh1YW5nIDxqZXJy
eS5odWFuZ0BueHAuY29tPjsgTGVvIExpDQo+IDxsZW95YW5nLmxpQG54cC5jb20+OyBpdmFuLmto
b3JvbnpodWtAbGluYXJvLm9yZw0KPiBTdWJqZWN0OiBbRVhUXSBSZTogW25ldC1uZXh0XSBlbmV0
YzogYWRkIHN1cHBvcnQgdGltZSBzcGVjaWZpYyBkZXBhcnR1cmUgYmFzZSBvbg0KPiB0aGUgcW9z
IGV0Zg0KPiANCj4gQ2F1dGlvbjogRVhUIEVtYWlsDQo+IA0KPiBGcm9tOiBQbyBMaXUgPHBvLmxp
dUBueHAuY29tPg0KPiBEYXRlOiBNb24sIDIzIERlYyAyMDE5IDAzOjQyOjM5ICswMDAwDQo+IA0K
PiA+IC0gVHJhbnNtaXQgY2hlY2tzdW0gb2ZmbG9hZHMgYW5kIHRpbWUgc3BlY2lmaWMgZGVwYXJ0
dXJlIG9wZXJhdGlvbiBhcmUNCj4gPiBtdXR1YWxseSBleGNsdXNpdmUuDQo+IA0KPiBJIGRvIG5v
dCBzZWUgYW55dGhpbmcgd2hpY2ggZW5mb3JjZXMgdGhpcyBjb25mbGljdC4NCj4gDQo+IEl0IGxv
b2tzIHRvIG1lIGxpa2UgaWYgdGhlIHVzZXIgY29uZmlndXJlcyB0aW1lIHNwZWNpZmljIGRlcGFy
dHVyZSwgYW5kIFRYIFNLQnMgd2lsbA0KPiBiZSBjaGVja3N1bSBvZmZsb2FkZWQsIHRoZSB0aW1l
IHNwZWNpZmljIGRlcGFydHVyZSB3aWxsIHNpbXBseSBub3QgYmUgcGVyZm9ybWVkLg0KPiANCj4g
SWYgdHJ1ZSwgdGhpcyBiZWhhdmlvciB3aWxsIGJlIHZlcnkgc3VycHJpc2luZyBmb3IgdGhlIHVz
ZXIuDQo+IA0KPiBJbnN0ZWFkLCB0aGUgY29uZmlndXJhdGlvbiBvcGVyYXRpb24gdGhhdCBjcmVh
dGVzIHRoZSBjb25mbGljdCBzaG91bGQgdGhyb3cgYW5kDQo+IGVycm9yIGFuZCBmYWlsLg0KDQpJ
IHdvdWxkIGZpeCBpdC4NCg0KPiANCj4gVGhhbmsgeW91Lg0K
