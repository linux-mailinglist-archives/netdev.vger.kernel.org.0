Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D3C152794
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 09:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgBEIbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 03:31:55 -0500
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:6047
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726490AbgBEIbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 03:31:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F4GxYAUO55HqjK1gUpGuCHkXpx3dMzUMmUtQbd3u9NXxKHP+e3syVgdeSyFRbhHveNbUBQIxXlc+TlghKRc1a6xtLyH1pUWz60K93ePvXu9lQYqqfCrv5Y3eoQuqta6QtIhyilF7eeB0pgXlMyoBY5jmEJ10GmArpi+w8gcoiI3+8fw/J9vPvk1im4DBlDkRSIWTVCwSwW0N/tj+KPP7AnZHIq2Ev2BB7FAKy9l7NfZdwDdQjhWw4huC2v8c3A8IbNuC/+piwu9jSMr9zEK5LS8WzWCr5qdc6+NHn+0AqGv6cHzPbgK3HE3IO6zaY/+hMXOrcY2Aee8gKHrcar9etw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/thCdcjMRqyvQyWLtGG7WbGUyFGVFtes5Oy1wTFqZ4=;
 b=AZfaBAOhheFQWNC6F9xrxDse9MhZwDBYzfJMEi0v/1WT3hUXSXoKemNzCC0LSkXIVrcCbZGzZ/0LYp9gQgp3EyoLgeYOC4HuFPEQN/MO2A1f/jDGqTIIL8DSzRiw+pIckptT7oNnLUWNix/tUkUIffH1/tOUYNkO8Jr+37IWmz2E9WjgXq5BX0TfNMjM28LfQ0VvVG48M7sV9+uSHLr9SKX1yJbBpghvSJx7jqgWEYiY/PUTljYJiaUT4cqbaRw/rPybrhHEtRUapQFZf7VBwDAjaZ4xD5Xei3khnaHhuDELfM241Th1aV+W5kEGjWN70tjAVXuSYjUx2UGfiNgIFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/thCdcjMRqyvQyWLtGG7WbGUyFGVFtes5Oy1wTFqZ4=;
 b=UMhcipUZnJHXEvicwc6stBj28FsKqXMjG3sDWFQcHZS54o0Ii9yOTWPC6qjQDL5VcTHmvYlHcvKtkqDtojiM7cS1ZXH+mwU1ZNSHm4dv5yRkuHZxsw2bf+hrmR/w8lzcyvB6ZkRfvuwBxPB/t3JR/5afleJZHCsPHDF6PRPFXuY=
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (20.178.202.86) by
 AM0PR04MB4146.eurprd04.prod.outlook.com (52.134.93.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.30; Wed, 5 Feb 2020 08:31:48 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07%7]) with mapi id 15.20.2686.034; Wed, 5 Feb 2020
 08:31:48 +0000
From:   "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "linux.cj@gmail.com" <linux.cj@gmail.com>,
        Jon Nettleton <jon@solid-run.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "Rajesh V. Bikkina" <rajesh.bikkina@nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>
CC:     "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Matteo Croce <mcroce@redhat.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v1 0/7] ACPI support for xgmac_mdio and
 dpaa2-mac drivers.
Thread-Topic: [EXT] Re: [PATCH v1 0/7] ACPI support for xgmac_mdio and
 dpaa2-mac drivers.
Thread-Index: AQHV2EwK5IRV9QOYbk268Y13ZqNpbagJx4mAgAJ/H+A=
Date:   Wed, 5 Feb 2020 08:31:47 +0000
Message-ID: <AM0PR04MB56363057017987033F0BCD1393020@AM0PR04MB5636.eurprd04.prod.outlook.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <fcda49b6-7a45-cd86-e33e-f8dea07c0684@gmail.com>
In-Reply-To: <fcda49b6-7a45-cd86-e33e-f8dea07c0684@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8321bf2d-12fb-47bc-f438-08d7aa15d76e
x-ms-traffictypediagnostic: AM0PR04MB4146:|AM0PR04MB4146:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB41460963497153B2C824B6C9D2020@AM0PR04MB4146.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0304E36CA3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(189003)(199004)(7416002)(66446008)(26005)(478600001)(66476007)(5660300002)(64756008)(66556008)(7696005)(186003)(66946007)(71200400001)(9686003)(316002)(55016002)(2906002)(86362001)(33656002)(8676002)(110136005)(52536014)(4326008)(54906003)(76116006)(966005)(53546011)(6506007)(81156014)(8936002)(81166006)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4146;H:AM0PR04MB5636.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QxOl+VIPe5G3vsS4n74hZ1rtfp6oxaSycVj1AOSZQi4rBtqKkw1G92whDJGjRCmEuZlm9srUvdfvpE8MUW0WryQQ6uRl3W6x5XxNRbLNpYP8dXu9Y3hN6vBNdLHPjUWgvtyjMyROvFcigtaSb3hvE2tZ0EA9dJCLBY3qH1gXuT8VTbv6RsVW0zyKclhlukSMWjoMG9AzdzZQgncwHLi7zzheFaGvJ24Zf1b0vKDxbX8tX+r/1CNco3AgxdQNYlelbz1yoDSs3qlWarAOC1SBFA1q+DGP3sgstBVpmA1+21Ug4wVjz1pyk50UP1ti22GwmhkRS7xHikA3T9DtnLdUzQQmbpVTy2GhQIaZWfo09h3WKSrukH/YO4xCwL3u18IVnVUmXKlAGNTVg7HRoCzi2g/UzaClQExuJ/y6p8VHsTiTqooWYLE6QZD624I0XWBBrR3SJg5LTLcNqw8rkHNp5oMOBVE3imZ1wBP9K1RIKupaF9mQlqivKwI2hopNzULQjdgpaiNUW12In2H+f8JSKc9QOdzw+Opi2Mb0EAgbAYsC8mt+eQ5/ZAWw9V+Fsms5Ygk9dC8I2rTHxjBdPFmGzQ==
x-ms-exchange-antispam-messagedata: xcHQ4g/eyyTuKwW23OtcfE63Qx4op1F9C2bzlr1V2cx4WOcX2jEvLrObd6qQbMbJe2+Hqx5A/SFm7vVpOy2HRrDY3TYkwzrGQWdUMTR+FoT/W97UuYFdo54N09MIhGLDXflLsZLoonQRXZXIGDpEKA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8321bf2d-12fb-47bc-f438-08d7aa15d76e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2020 08:31:47.8394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0JaMu376bknoZUtvJq/1vHgPm04DYUpD2bvLQkwMc8FDZJ5p4vi00JkXfRGiFVEvOYq4OKUb/4fJG2JYhyFU8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRmxvcmlhbg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZsb3Jp
YW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiBNb25kYXksIEZlYnJ1
YXJ5IDMsIDIwMjAgMTE6MzIgUE0NCj4gVG86IENhbHZpbiBKb2huc29uIDxjYWx2aW4uam9obnNv
bkBueHAuY29tPjsgbGludXguY2pAZ21haWwuY29tOyBKb24NCg0KPHNuaXA+DQoNCj4gT24gMS8z
MS8yMCA3OjM0IEFNLCBDYWx2aW4gSm9obnNvbiB3cm90ZToNCj4gPiBGcm9tOiBDYWx2aW4gSm9o
bnNvbiA8Y2FsdmluLmpvaG5zb25Ab3NzLm54cC5jb20+DQo+ID4NCj4gPiBUaGlzIHBhdGNoIHNl
cmllcyBwcm92aWRlcyBBQ1BJIHN1cHBvcnQgZm9yIHhnbWFjX21kaW8gYW5kIGRwYWEyLW1hYw0K
PiA+IGRyaXZlci4gTW9zdCBvZiB0aGUgRFQgQVBJcyBhcmUgcmVwbGFjZWQgd2l0aCBmd25vZGUg
QVBJcyB0byBoYW5kbGUNCj4gPiBib3RoIERUIGFuZCBBQ1BJIG5vZGVzLg0KPiA+DQo+ID4gT2xk
IHBhdGNoIGJ5IE1hcmNpbiBXb2p0YXM6IChtZGlvX2J1czogSW50cm9kdWNlIGZ3bm9kZSBNRElP
IGhlbHBlcnMpLA0KPiA+IGlzIHJldXNlZCBpbiB0aGlzIHNlcmllcyB0byBnZXQgc29tZSBmd25v
ZGUgbWRpbyBoZWxwZXIgQVBJcy4NCj4gDQo+IEFuZHJldydzIGNvbW1lbnQgb24geW91ciBmaXJz
dCBwYXRjaCBpcyBhIGdvb2Qgc3VtbWFyeSBvZiB3aGF0IHRoaXMgcGF0Y2gNCj4gc2VyaWVzIGRv
ZXMsIGluc3RlYWQgb2YgY29uc29saWRhdGluZyB0aGUgZXhpc3RpbmcgY29kZSBhbmQgbWFraW5n
IGl0IGxlc3Mgb2ZfKg0KPiBjZW50cmljIGFuZCBtb3JlIGZpcm13YXJlIGFnbm9zdGljLCB0aGlz
IGR1cGxpY2F0ZXMgdGhlIGV4aXN0aW5nIGluZnJhc3RydWN0dXJlDQo+IGFsbW9zdCBsaW5lIGZv
ciBsaW5lIHRvIGNyZWF0ZSBhIGZ3bm9kZSBzcGVjaWZpYyBpbXBsZW1lbnRhdGlvbi4gVGhlDQo+
IHByZWZlcmVuY2Ugd291bGQgYmUgZm9yIHlvdSB0byBtb3ZlIGF3YXkgZnJvbSB0aGF0IGFuZCB1
c2UgZGV2aWNlXyoNCj4gcHJvcGVydGllcyBhcyBtdWNoIGFzIHBvc3NpYmxlIHdoaWxlIG1ha2lu
ZyB0aGUgY29kZSBjYXBhYmxlIG9mIGhhbmRsaW5nIGFsbA0KPiBmaXJtd2FyZSBpbXBsZW1lbnRh
dGlvbnMuDQoNClRoYW5rcyBmb3IgdGhlIHN1Z2dlc3Rpb24uIFdpbGwgdGFrZSB0aGlzIGRpcmVj
dGlvbiBmb3IgdjIuDQoNCj4gQ2FuIHlvdSBhbHNvIHNob3cgYSBmZXcgRFNEVCBmb3IgdGhlIGRl
dmljZXMgdGhhdCB5b3UgYXJlIHdvcmtpbmcgc28gd2UgY2FuDQo+IGEgZmVlbGluZyBvZiBob3cg
eW91IHJlcHJlc2VudGVkIHRoZSB2YXJpb3VzIHByb3BlcnRpZXMgYW5kIHBhcmVudC9jaGlsZA0K
PiBkZXZpY2VzIGRlcGVuZGVuY2llcz8NCg0KaHR0cHM6Ly9zb3VyY2UuY29kZWF1cm9yYS5vcmcv
ZXh0ZXJuYWwvcW9yaXEvcW9yaXEtY29tcG9uZW50cy9lZGsyLXBsYXRmb3Jtcy90cmVlL1BsYXRm
b3JtL05YUC9MWDIxNjBhUmRiUGtnL0FjcGlUYWJsZXMvRHNkdC9NZGlvLmFzbD9oPUxYMjE2MF9V
RUZJX0FDUElfRUFSMQ0KaHR0cHM6Ly9zb3VyY2UuY29kZWF1cm9yYS5vcmcvZXh0ZXJuYWwvcW9y
aXEvcW9yaXEtY29tcG9uZW50cy9lZGsyLXBsYXRmb3Jtcy90cmVlL1BsYXRmb3JtL05YUC9MWDIx
NjBhUmRiUGtnL0FjcGlUYWJsZXMvRHNkdC9NYy5hc2w/aD1MWDIxNjBfVUVGSV9BQ1BJX0VBUjEN
Cg0KVGhhbmtzDQpDYWx2aW4NCg==
