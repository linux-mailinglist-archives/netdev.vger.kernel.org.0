Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E734AA9B45
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 09:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbfIEHKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 03:10:39 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:24294
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727900AbfIEHKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 03:10:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b32NibNpZym7iT9rgLmP1f760WbncGOLlhNx561THt2TomOOtEEu0wen7aK56E4x1ZNDZkW95LTX7mgjP0BOxR2PwvkRWYwsiALIPinPjPsPKB5hUy87QhjxUPTkRwNmbdVcHrMEAdtaVXf+hC69Zo4nwWgZGwEDhoYESdWPF69JPYaKwOtjqKt9UqD5dY3/vByT157eSeedb+LvTLbw8ZTKLPAEhOT5X2qKaHj7VkSf8SEszwZaSIAC4LChwkZyhzv+pFqRMibWJJAWY2amYdIHOaLv1ek2I+m0J2YKoEWCQ4NVKBOBnrGU6KpPbWIf4tmE8cnyVl+//Pg76/VNhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgU37U5yEp3D5WCox/GdFSWSGFDf+XstUx973GwKxOY=;
 b=lTww+c9bID/wiw+lgHYw6j91m0Pq1nA5/Rd2PVoIkJGpFapZQJH6OLrOScOLk0ihv5HhFYbULuaNSISnV1cxC7Uh9ACZGfIyL6SlNgNFhVKxpFR0NSDk9ND5HtLR7k9VzPm1misA/5vfY6eagnnNgu3RaZc+YGae5JYyjMhNXJpU0fqjjyE02YLz8w8XYUpoqvirauFW2bMH+0Uo3a0sbicxkghy/EP0I1HtFJp5mm1xF4t+veYmhUUY4I9i138XUp9Iz89yxWKEEw3rTv4TS322SfG2wChV7rIkB+pemdcrQKDh8F9KE9Rw7KfrTyxGvhBftJAGkzqfjsnfRgkK5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgU37U5yEp3D5WCox/GdFSWSGFDf+XstUx973GwKxOY=;
 b=JOYUzfwOX/T8xRRIbpxz0FC5F6dV9f3dCdn+tc1LoDhVkW1bCTuNCeh1XloHpBXJbRVpWOBCdPtST6KxuVYeBV83NKGQzh3KCjp3/1xsnJ13p7pT8GXYQerHfhqsHmESEY0d3N1cLr9gEc95ho+j+1Exk0s9dHe/fwK/Fb9VFj4=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5513.eurprd04.prod.outlook.com (20.178.106.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Thu, 5 Sep 2019 07:10:36 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::29e4:47d:7a2b:a6c6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::29e4:47d:7a2b:a6c6%7]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 07:10:36 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        =?utf-8?B?TWFydGluIEh1bmRlYsO4bGw=?= <martin@geanix.com>
Subject: RE: [PATCH REPOST 1/2] can: flexcan: fix deadlock when using self
 wakeup
Thread-Topic: [PATCH REPOST 1/2] can: flexcan: fix deadlock when using self
 wakeup
Thread-Index: AQHVVAt+uezYlHzMP0yJKoK3YxkiS6cD2xAAgAAKUjCAAA71AIAMq3CAgAEuS9CACueJAIAAERog
Date:   Thu, 5 Sep 2019 07:10:35 +0000
Message-ID: <DB7PR04MB461868320DA0B25CC8255213E6BB0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190816081749.19300-1-qiangqing.zhang@nxp.com>
 <20190816081749.19300-2-qiangqing.zhang@nxp.com>
 <dd8f5269-8403-702b-b054-e031423ffc73@geanix.com>
 <DB7PR04MB4618A1F984F2281C66959B06E6AB0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <35190c5b-f8be-8784-5b4f-32a691a6cffe@geanix.com>
 <6a9bc081-334a-df91-3a23-b74a6cdd3633@geanix.com>
 <DB7PR04MB4618E527339B69AEAD46FB06E6A20@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <588ab34d-613d-ac01-7949-921140ca4543@geanix.com>
In-Reply-To: <588ab34d-613d-ac01-7949-921140ca4543@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca20b89a-d80e-4404-37f6-08d731d0263e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5513;
x-ms-traffictypediagnostic: DB7PR04MB5513:|DB7PR04MB5513:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5513D6EE712F50FEBF74220DE6BB0@DB7PR04MB5513.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39850400004)(136003)(396003)(376002)(189003)(199004)(13464003)(53546011)(476003)(486006)(26005)(446003)(11346002)(305945005)(52536014)(6506007)(7736002)(8676002)(74316002)(33656002)(86362001)(2201001)(2501003)(81166006)(81156014)(8936002)(76176011)(102836004)(186003)(6116002)(7696005)(14444005)(76116006)(66946007)(71190400001)(110136005)(66476007)(66556008)(256004)(54906003)(99286004)(9686003)(66066001)(6246003)(316002)(71200400001)(3846002)(64756008)(66446008)(53936002)(6436002)(25786009)(2906002)(229853002)(5660300002)(4326008)(66574012)(478600001)(55016002)(14454004)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5513;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hW4QHEVsr29oul5HRWVHsMw0XNkstizltWrskhD6XUbSGTS3QeHVZ0jj+pqb9hKA3N8npvlVqqM4POUJjKJ62CruNmNxz/RF/Y2ODfPYkDW7HSm3We3/TV2H85+NyqBafLJIuHIqgH1Jec4gKeZC0pjLZhE0wESKnxsFz1Ms5WC6afVZaRFYDthA3no0bFW/j6m/yAoTFNXU7RZlLHZi0xEmzP8WajV7B5eXXeVZlyDaI1Bc7axZ+q9KrDP+MsYip/kh4PvtpaeyrRPum/P6MqcQKnyaOxCVmPtSR+NMjNLJLeB5+XAabkRcmunI+HP1kPKvYLH+XZBsoHpPhZY7wLQZ8DAXy807OHl7lDVu2xywthRLOnAMyKCEFNSLdZqMxPvwoWbkBV9f6I/2rVIdh+MespDNCTtOxG6137xbD3Y=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca20b89a-d80e-4404-37f6-08d731d0263e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 07:10:36.0375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9lS6v32xNg6Xjk0E3BXGIMk4iHy7FWf8+IKEHXdlLXdFETnVdzXiHP60XmNc11xrYH+KcmYAjB/KQ0+aORyVUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5513
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDnmnIg15pelIDEzOjU4DQo+IFRvOiBKb2Fr
aW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgbWtsQHBlbmd1dHJvbml4LmRlOw0K
PiBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnDQo+IENjOiB3Z0BncmFuZGVnZ2VyLmNvbTsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsgZGwtbGludXgtaW14DQo+IDxsaW51eC1pbXhAbnhwLmNvbT47
IE1hcnRpbiBIdW5kZWLDuGxsIDxtYXJ0aW5AZ2Vhbml4LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBSRVBPU1QgMS8yXSBjYW46IGZsZXhjYW46IGZpeCBkZWFkbG9jayB3aGVuIHVzaW5nIHNl
bGYNCj4gd2FrZXVwDQo+IA0KPiANCj4gDQo+IE9uIDI5LzA4LzIwMTkgMDkuMzAsIEpvYWtpbSBa
aGFuZyB3cm90ZToNCj4gPiBIaSBTZWFuLA0KPiA+DQo+ID4gSSdtIHNvcnJ5IHRoYXQgSSBjYW4n
dCBnZXQgdGhlIGRlYnVnIGxvZyBhcyB0aGUgc2l0ZSBjYW4ndCBiZSByZWFjaGVkLiBBbmQgSQ0K
PiBjb25uZWN0IHR3byBib2FyZHMgdG8gZG8gdGVzdCBhdCBteSBzaWRlLCB0aGlzIGlzc3VlIGNh
bid0IGJlIHJlcHJvZHVjZWQuDQo+ID4NCj4gPiBCZXN0IFJlZ2FyZHMsDQo+ID4gSm9ha2ltIFpo
YW5nDQo+IA0KPiBIaSBKb2FraW0sDQo+IA0KPiBXaGF0IGNvbW1pdCBhbmQgYnJhbmNoIGFyZSB5
b3UgZG9pbmcgeW91ciB0ZXN0cyB3aXRoPw0KDQpIaSBTZWFuLA0KDQpDb3VsZCB5b3UgdXBkYXRl
IGxhc3Rlc3QgZmxleGNhbiBkcml2ZXIgdXNpbmcgbGludXgtY2FuLW5leHQvZmxleGNhbiBhbmQg
dGhlbiBtZXJnZSBiZWxvdyB0d28gcGF0Y2hlcyBmcm9tIGxpbnV4LWNhbi90ZXN0aW5nPw0KZDBi
NTM2MTY3MTZlIChIRUFEIC0+IHRlc3RpbmcsIG9yaWdpbi90ZXN0aW5nKSBjYW46IGZsZXhjYW46
IGFkZCBMUFNSIG1vZGUgc3VwcG9ydCBmb3IgaS5NWDdEDQo4MDNlYjZiYWQ2NWIgY2FuOiBmbGV4
Y2FuOiBmaXggZGVhZGxvY2sgd2hlbiB1c2luZyBzZWxmIHdha2V1cA0KDQpCZXN0IFJlZ2FyZHMs
DQpKb2FraW0gWmhhbmcNCj4gL1NlYW4NCg==
