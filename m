Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6B83B0126
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 12:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhFVKUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 06:20:06 -0400
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:41216
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229668AbhFVKUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 06:20:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxOXyFx0yLcSI+GdYPHWKI0NLrEndI69jW0X7owy4qbyNzUKlesb6aHQst0AA9tFccoNlAKVPv59FdLI4bDGiG8KPMovzpJ7og7E8P8uBCFQN8h42HY7Qo+wnZ2ZCs11pSLAgeEqA7WtNsdawaJfaZMthwcm9uLcsOIRY8kkJ49vRzlt2lM7OvEtVBrU1acAkGu+qx1b0uzuY3wYKq54xkeJrPwjQlW0m+/U9nXzV574XDHkXa/yZ8iu92DuGOkWi8wGqrzqUMYKjPutSiFiZax+5O5fnVP5ddyM4qVzUc3Y4acawznHEEvnDeSMwbFq6yYFpSx+neVdkYEEpfNtgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNMu3hXL54/oL/RykYJ8rZBqr8nBuq22CbXiKutuJQk=;
 b=OdN2Fv37pLKtmSLDNCZfAu9D7hdyDsdrD49Q25MyaGfWdQZN80C/9UhWQW8ldRYywia+6RymdiRkVK2n05YH4k6KmQqOU2WqzGKELqZiUYtv6DOwcZ5rlQSOd62gTSOfd08HDZnzGtVyth2CBjjfWgvZ7gaxOkMBt9Ut/mEEnwC/i74jbZdUhYZdEgYLBxN/01JgonPkKdbBWK2cGUZHDUAe0AU3P1uTIjuFw0E8U/uHetoJ+9dx5gO2NmAXnHWXJd5GBeaoaVX1A9/TgRJHbkTOfV+IJ5YB1U3kaZAH2gBmWSFUDdw8k0r9F3/RFWTN8rOinI9jAui/ODAJTT8YRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNMu3hXL54/oL/RykYJ8rZBqr8nBuq22CbXiKutuJQk=;
 b=euCGotzHzPodf+q+xopqVkv6eL8t6w9pAspKKV/CJpVfXXbiGOZfhUyDH03zEWUIvYoOEHAGNojQ9u9g4VGCudar/X+I8Swz1ETh5DT0DV4coaMrsEpvBl8+5XnlQUqbPFZrj0EvxwWiuFvrOMxEX7YFI+lI1FM1l6IZx5Ls7BQ=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB7PR04MB5209.eurprd04.prod.outlook.com (2603:10a6:10:13::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Tue, 22 Jun
 2021 10:17:46 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 10:17:46 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: RE: [net-next, v3, 01/10] ptp: add ptp virtual clock driver framework
Thread-Topic: [net-next, v3, 01/10] ptp: add ptp virtual clock driver
 framework
Thread-Index: AQHXYcnvh7lodEz0xUGYFbPMJnkpEKsYefQAgAdhU0A=
Date:   Tue, 22 Jun 2021 10:17:46 +0000
Message-ID: <DB7PR04MB5017E87F4E95BBCB1D326EB4F8099@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
 <20210615094517.48752-2-yangbo.lu@nxp.com> <20210617173237.GA4770@localhost>
In-Reply-To: <20210617173237.GA4770@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4591e21-4cf7-496b-7196-08d93566fb3d
x-ms-traffictypediagnostic: DB7PR04MB5209:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5209ED34CF1C68CBB9796FD2F8099@DB7PR04MB5209.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3NMBMlXPEKN1uPv+3D9xd8y6rag4eBRq3qTaYbB/CUqe39BuxVl7O9QX509EUhR9BaOM3fZPnzc0UXZQYLrHugj2ilAJRT/+2mTOBjWgiZsNkdtvliVH3vUXh1U1FU/95WU1dri2DSuFtGUjUVabcYARx6ylllqt4GQ91EgDee+ImQjUaQyri9SOgf97TIh7XNnTqBHaNRAc77b/BlzEUML6H93xTrNFnq54SAESMsjzXqlXnkyaN7ExReukWWQzV+lI0qhPDkufoVunJkHnf7EQifguLbOSoVQj1Dqi19eKIOAitlXs1w7bIlLmFHZbxrr3R9htJBFu3MmtxdC/7qTKTVty3LxiOPMmsn8d6z91WDL+OEP4nW/yy9SFrrsoGa6t6fdjlwXU3BKjboGUuJJ18/G5SeOcGy1nSjs1k0SKfoj55dbnpFvinIVpoWZApTapC77QFQLNbMefAibvLVpeVLs32d4N6CW7Trn0YBw50wLlTDiNwP5mjiDg/t8i/5e4YfIemF8lrLJ1GtQXnz5jhoLqhcMIU9ulzGak5ObS3VM3nxHoThOjvgsv6+kQQAY6+WfmJ7k/z7ExLLmFX+eTPPIv8gWuHXW1iw+gUNk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(66446008)(76116006)(64756008)(66556008)(55016002)(66476007)(9686003)(5660300002)(86362001)(33656002)(66946007)(7696005)(8936002)(71200400001)(38100700002)(6506007)(53546011)(54906003)(2906002)(26005)(4326008)(122000001)(83380400001)(52536014)(478600001)(186003)(7416002)(6916009)(8676002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?dnBIcldaUFd4SkJzc2hIL3NqL0Nsc3lXdEI5Unc4aTROYmpuZFMrR1NveHY4?=
 =?gb2312?B?RFdLNlh6MzFLZUhDeWEyMUdOcmkwMUdrNE5FKzZMMThEai9VU0h1bnoybXcy?=
 =?gb2312?B?YXQxYjQ0YUprYlpxTmtSbEI4djVBNS9RMnlsaE8vNEJGTW9OUzZZQ1RhT3Jk?=
 =?gb2312?B?dEtmMzdqcWJPekhYNDFEYmkyS2hya3BPM3M0RmVLOXZDRDhhdmw2VlBWdUdi?=
 =?gb2312?B?TExOelczcUpDWnBPalNTSm1pc1RpeVB5WDdPYnROT2MrSVJFekJwQU1MamI3?=
 =?gb2312?B?YWRJUDRJeENDZHNXNTlEOHJoSWxVbUVJRExNNnc5VXFzM3ZET2hrSFNCYjFH?=
 =?gb2312?B?WGdHeTc3cVBScXVveDdncndyK1VrMjBmNjkwNUV1cm95N1MzNHVWQ1FsSEhq?=
 =?gb2312?B?c3hhMXJtMUU5clVqUnN0Zk5yelROTFBkTWNCWXlOUUxiMUwrV2ZJeEZTbkVH?=
 =?gb2312?B?eU1oU3RLdDd1UTFsVllzQUxkYUwxQTgrekFNUWFyeE5Ic01uZEJheEEzam5i?=
 =?gb2312?B?R2hCLzlwbzhxSWp5YVlleDZmNHlINStJUWpxeG9wOGFUelFTQ2p2NCtPVlA4?=
 =?gb2312?B?NUNvenFHekovUDNoNjdDc3FVODZaUWxsT3dFUzdPaVdROWo1ajU4MmtOUEFo?=
 =?gb2312?B?VUVjcXVXNjRlZkFRcXlDUFhoZFlHUVJ0NzFVUFFhendvdllOZitZQUhmNEtJ?=
 =?gb2312?B?NWlRUkRNbGNzV2RkcWpZcGFIT1k2NnkvaFBrbVFpWlFqVUJIcDFxRXlmNys2?=
 =?gb2312?B?SzNwdlpMem0vMnV3eER0aU10emVMSWZtUGszMDdKMThOT3lvR0Zxc09kNEo5?=
 =?gb2312?B?bGtEVm52LzNoRDRCMGRZZE9zTCtVbkVqSC9PUU1aVDFhbDBWcU9OQ1loc3BZ?=
 =?gb2312?B?Wm5peWNpQXp0SEFucHF5YkEwZk1QNElNZld2VXdqMVMyc0dEamFmSzgxL2lB?=
 =?gb2312?B?dWZTNlhpckF0Zjh3aHNzclBWYTBNbzlNQzZzWFNHcElTSXFlTkZ2TzltWFlk?=
 =?gb2312?B?V205Y1F3dUNFRGRBMmNGb3FoTXMwbUs4NnN0YWFJajg0eklGSmZhZjNPM1V4?=
 =?gb2312?B?Q3Vnc1RBUll5VTQyMy9sV3VocU53WStIV2xQOSsxZjRkaWFMaCtjdm5SMGcw?=
 =?gb2312?B?UVo5cXVGYXUxbVRBR0NsRUZ1REhGaW9kVHlBN253WjUvRjYxcVJ1UmJDYmJk?=
 =?gb2312?B?bTAvcUp5NWhwcE43MVE3UUMxUGc1c3R1Q2twNG9pelFLUjlOdjYvSVRrVG1K?=
 =?gb2312?B?VDZOZk8vTGpFajA1QU91S3dJa2lmL2FheWlJdUdHK0dkVm1OQ1JIQ2U4UVlP?=
 =?gb2312?B?ZDF2T2tKT0xtRXRUdS9aODdiak95WmNramwyU1ZDWFkrZ2dwVzhNdWxwRkpu?=
 =?gb2312?B?Z3N5b1FOM2k3WTVhelkxaFpKcXdTMGRoZGtWdndOeTRhT3FZK2F0bitMd1hM?=
 =?gb2312?B?bFRWMDVEK2xGTWJWd1VVa3RsTUdUaDRVVUJWdmdTKzR3SU1lT2FRWjFadEZ3?=
 =?gb2312?B?YVcvYTZ2YnM1bnNES28zdGIxNk03TWYvc1c0cFJZUWhockFQeGNNSnV5MFhu?=
 =?gb2312?B?Q2VSeUpsNnFGU2p2OHhHOVpiakR3ODJKVHlleER6emNqOE5jcW1aU2ovZTlP?=
 =?gb2312?B?MzZuRXhzSE8rNEZxbGNpelFoai9NS1FkeTBIWHlOTkFtMHNxdXkxK29QK0dv?=
 =?gb2312?B?WkYxU1VZL1I1UjdMRmVXc2FhK2VTVGZOU1V4cG1WRDVyN1ZkY0kwUTdvM2NE?=
 =?gb2312?Q?C9W6IqhfYL1b6XHBiqg9KxzuNCTU2jMcN+aZTvm?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4591e21-4cf7-496b-7196-08d93566fb3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 10:17:46.6240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kgZGLnk9E1hQHlHAm2M4Ss8URL2emaPLlfh9VCrgA4aG4XA+nuV7eDnZDrvzR1RId1Sff3otgerjhLuYEfHPEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5209
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNo
YXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNtTC
MTjI1SAxOjMzDQo+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4
LWtzZWxmdGVzdEB2Z2VyLmtlcm5lbC5vcmc7IG1wdGNwQGxpc3RzLmxpbnV4LmRldjsgRGF2aWQg
UyAuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJh
QGtlcm5lbC5vcmc+OyBNYXQgTWFydGluZWF1DQo+IDxtYXRoZXcuai5tYXJ0aW5lYXVAbGludXgu
aW50ZWwuY29tPjsgTWF0dGhpZXUgQmFlcnRzDQo+IDxtYXR0aGlldS5iYWVydHNAdGVzc2FyZXMu
bmV0PjsgU2h1YWggS2hhbiA8c2h1YWhAa2VybmVsLm9yZz47IE1pY2hhbA0KPiBLdWJlY2VrIDxt
a3ViZWNla0BzdXNlLmN6PjsgRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+
Ow0KPiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBSdWkgU291c2EgPHJ1aS5zb3VzYUBu
eHAuY29tPjsgU2ViYXN0aWVuDQo+IExhdmV6ZSA8c2ViYXN0aWVuLmxhdmV6ZUBueHAuY29tPg0K
PiBTdWJqZWN0OiBSZTogW25ldC1uZXh0LCB2MywgMDEvMTBdIHB0cDogYWRkIHB0cCB2aXJ0dWFs
IGNsb2NrIGRyaXZlciBmcmFtZXdvcmsNCj4gDQo+IE9uIFR1ZSwgSnVuIDE1LCAyMDIxIGF0IDA1
OjQ1OjA4UE0gKzA4MDAsIFlhbmdibyBMdSB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9wdHAvTWFrZWZpbGUgYi9kcml2ZXJzL3B0cC9NYWtlZmlsZSBpbmRleA0KPiA+IDg2NzNkMTc0
M2ZhYS4uM2M2YTkwNTc2MGUyIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvcHRwL01ha2VmaWxl
DQo+ID4gKysrIGIvZHJpdmVycy9wdHAvTWFrZWZpbGUNCj4gPiBAQCAtMyw3ICszLDcgQEANCj4g
PiAgIyBNYWtlZmlsZSBmb3IgUFRQIDE1ODggY2xvY2sgc3VwcG9ydC4NCj4gPiAgIw0KPiA+DQo+
ID4gLXB0cC15CQkJCQk6PSBwdHBfY2xvY2subyBwdHBfY2hhcmRldi5vIHB0cF9zeXNmcy5vDQo+
ID4gK3B0cC15CQkJCQk6PSBwdHBfY2xvY2subyBwdHBfdmNsb2NrLm8gcHRwX2NoYXJkZXYubw0K
PiBwdHBfc3lzZnMubw0KPiANCj4gTml0OiBQbGVhc2UgcGxhY2UgcHRwX3ZjbG9jay5vIGF0IHRo
ZSBlbmQgb2YgdGhlIGxpc3QuDQoNCk9rLg0KDQo+IA0KPiA+ICBwdHBfa3ZtLSQoQ09ORklHX1g4
NikJCQk6PSBwdHBfa3ZtX3g4Ni5vIHB0cF9rdm1fY29tbW9uLm8NCj4gPiAgcHRwX2t2bS0kKENP
TkZJR19IQVZFX0FSTV9TTUNDQykJOj0gcHRwX2t2bV9hcm0ubw0KPiBwdHBfa3ZtX2NvbW1vbi5v
DQo+ID4gIG9iai0kKENPTkZJR19QVFBfMTU4OF9DTE9DSykJCSs9IHB0cC5vDQo+IA0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3B0cC9wdHBfcHJpdmF0ZS5oIGIvZHJpdmVycy9wdHAvcHRwX3By
aXZhdGUuaA0KPiA+IGluZGV4IDZiOTcxNTUxNDhmMS4uM2YzODhkNjM5MDRjIDEwMDY0NA0KPiA+
IC0tLSBhL2RyaXZlcnMvcHRwL3B0cF9wcml2YXRlLmgNCj4gPiArKysgYi9kcml2ZXJzL3B0cC9w
dHBfcHJpdmF0ZS5oDQo+ID4gQEAgLTQ4LDYgKzQ4LDIwIEBAIHN0cnVjdCBwdHBfY2xvY2sgew0K
PiA+ICAJc3RydWN0IGt0aHJlYWRfZGVsYXllZF93b3JrIGF1eF93b3JrOyAgfTsNCj4gPg0KPiA+
ICsjZGVmaW5lIGluZm9fdG9fdmNsb2NrKGQpIGNvbnRhaW5lcl9vZigoZCksIHN0cnVjdCBwdHBf
dmNsb2NrLCBpbmZvKQ0KPiA+ICsjZGVmaW5lIGNjX3RvX3ZjbG9jayhkKSBjb250YWluZXJfb2Yo
KGQpLCBzdHJ1Y3QgcHRwX3ZjbG9jaywgY2MpDQo+ID4gKyNkZWZpbmUgZHdfdG9fdmNsb2NrKGQp
IGNvbnRhaW5lcl9vZigoZCksIHN0cnVjdCBwdHBfdmNsb2NrLA0KPiA+ICtyZWZyZXNoX3dvcmsp
DQo+ID4gKw0KPiA+ICtzdHJ1Y3QgcHRwX3ZjbG9jayB7DQo+ID4gKwlzdHJ1Y3QgcHRwX2Nsb2Nr
ICpwY2xvY2s7DQo+ID4gKwlzdHJ1Y3QgcHRwX2Nsb2NrX2luZm8gaW5mbzsNCj4gPiArCXN0cnVj
dCBwdHBfY2xvY2sgKmNsb2NrOw0KPiA+ICsJc3RydWN0IGN5Y2xlY291bnRlciBjYzsNCj4gPiAr
CXN0cnVjdCB0aW1lY291bnRlciB0YzsNCj4gPiArCXNwaW5sb2NrX3QgbG9jazsJLyogcHJvdGVj
dHMgdGMvY2MgKi8NCj4gPiArCXN0cnVjdCBkZWxheWVkX3dvcmsgcmVmcmVzaF93b3JrOw0KPiAN
Cj4gQ2FuIHdlIHBsZWFzZSBoYXZlIGEga3RocmVhZCB3b3JrZXIgaGVyZSBpbnN0ZWFkIG9mIHdv
cms/DQo+IA0KPiBFeHBlcmllbmNlIHNob3dzIHRoYXQgcGxhaW4gd29yayBjYW4gYmUgZGVsYXll
ZCBmb3IgYSBsb25nLCBsb25nIHRpbWUgb24gYnVzeQ0KPiBzeXN0ZW1zLg0KPiANCg0KSSB0aGlu
ayBkb19hdXhfd29yayBjYWxsYmFjayBjb3VsZCBiZSB1dGlsaXplZCBmb3IgcHRwIHZpcnR1YWwg
Y2xvY2ssIHJpZ2h0Pw0KDQo+ID4gK307DQo+ID4gKw0KPiA+ICAvKg0KPiA+ICAgKiBUaGUgZnVu
Y3Rpb24gcXVldWVfY250KCkgaXMgc2FmZSBmb3IgcmVhZGVycyB0byBjYWxsIHdpdGhvdXQNCj4g
PiAgICogaG9sZGluZyBxLT5sb2NrLiBSZWFkZXJzIHVzZSB0aGlzIGZ1bmN0aW9uIHRvIHZlcmlm
eSB0aGF0IHRoZQ0KPiA+IHF1ZXVlIEBAIC04OSw0ICsxMDMsNiBAQCBleHRlcm4gY29uc3Qgc3Ry
dWN0IGF0dHJpYnV0ZV9ncm91cA0KPiA+ICpwdHBfZ3JvdXBzW107ICBpbnQgcHRwX3BvcHVsYXRl
X3Bpbl9ncm91cHMoc3RydWN0IHB0cF9jbG9jayAqcHRwKTsNCj4gPiB2b2lkIHB0cF9jbGVhbnVw
X3Bpbl9ncm91cHMoc3RydWN0IHB0cF9jbG9jayAqcHRwKTsNCj4gPg0KPiA+ICtzdHJ1Y3QgcHRw
X3ZjbG9jayAqcHRwX3ZjbG9ja19yZWdpc3RlcihzdHJ1Y3QgcHRwX2Nsb2NrICpwY2xvY2spOw0K
PiA+ICt2b2lkIHB0cF92Y2xvY2tfdW5yZWdpc3RlcihzdHJ1Y3QgcHRwX3ZjbG9jayAqdmNsb2Nr
KTsNCj4gPiAgI2VuZGlmDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3B0cC9wdHBfdmNs
b2NrLmMgYi9kcml2ZXJzL3B0cC9wdHBfdmNsb2NrLmMgbmV3DQo+ID4gZmlsZSBtb2RlIDEwMDY0
NCBpbmRleCAwMDAwMDAwMDAwMDAuLmI4ZjUwMDY3NzMxNA0KPiA+IC0tLSAvZGV2L251bGwNCj4g
PiArKysgYi9kcml2ZXJzL3B0cC9wdHBfdmNsb2NrLmMNCj4gPiBAQCAtMCwwICsxLDE1NCBAQA0K
PiA+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlcg0KPiA+ICsv
Kg0KPiA+ICsgKiBQVFAgdmlydHVhbCBjbG9jayBkcml2ZXINCj4gPiArICoNCj4gPiArICogQ29w
eXJpZ2h0IDIwMjEgTlhQDQo+ID4gKyAqLw0KPiA+ICsjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0K
PiA+ICsjaW5jbHVkZSAicHRwX3ByaXZhdGUuaCINCj4gPiArDQo+ID4gKyNkZWZpbmUgUFRQX1ZD
TE9DS19DQ19NVUxUCQkoMSA8PCAzMSkNCj4gPiArI2RlZmluZSBQVFBfVkNMT0NLX0NDX1NISUZU
CQkzMQ0KPiANCj4gVGhlc2UgdHdvIGFyZSBva2F5LCBidXQgLi4uDQo+IA0KPiA+ICsjZGVmaW5l
IFBUUF9WQ0xPQ0tfQ0NfTVVMVF9OVU0JCSgxIDw8IDkpDQo+ID4gKyNkZWZpbmUgUFRQX1ZDTE9D
S19DQ19NVUxUX0RFTQkJMTU2MjVVTEwNCj4gDQo+IHRoZSBzaW1pbGFyaXR5IG9mIG5hbWluZyBp
cyBjb25mdXNpbmcgZm9yIHRoZXNlIHR3by4gIFRoZXkgYXJlIG9ubHkgdXNlZCBpbg0KPiB0aGUg
LmFkamZpbmUgbWV0aG9kLiAgSG93IGFib3V0IHRoaXM/DQo+IA0KPiAgIFBUUF9WQ0xPQ0tfRkFE
Sl9OVU1FUkFUT1IsIG9yIGV2ZW4gUFRQX1ZDTE9DS19GQURKX1NISUZUIChzZWUNCj4gYmVsb3cp
DQo+ICAgUFRQX1ZDTE9DS19GQURKX0RFTk9NSU5BVE9SDQo+IA0KPiA+ICsjZGVmaW5lIFBUUF9W
Q0xPQ0tfQ0NfUkVGUkVTSF9JTlRFUlZBTAkoSFogKiAyKQ0KPiANCj4gQ29uc2lkZXIgZHJvcHBp
bmcgQ0MgZnJvbSB0aGUgbmFtZS4NCj4gUFRQX1ZDTE9DS19SRUZSRVNIX0lOVEVSVkFMIHNvdW5k
cyBnb29kIHRvIG1lLg0KPiANCg0KVGhhbmtzLiBXaWxsIHJlbmFtZSB0aGUgTUFDUk9zIHBlciB5
b3VyIHN1Z2dlc3Rpb24uDQoNCj4gPiArc3RhdGljIGludCBwdHBfdmNsb2NrX2FkamZpbmUoc3Ry
dWN0IHB0cF9jbG9ja19pbmZvICpwdHAsIGxvbmcNCj4gPiArc2NhbGVkX3BwbSkgew0KPiA+ICsJ
c3RydWN0IHB0cF92Y2xvY2sgKnZjbG9jayA9IGluZm9fdG9fdmNsb2NrKHB0cCk7DQo+ID4gKwl1
bnNpZ25lZCBsb25nIGZsYWdzOw0KPiA+ICsJczY0IGFkajsNCj4gPiArDQo+ID4gKwlhZGogPSAo
czY0KXNjYWxlZF9wcG0gKiBQVFBfVkNMT0NLX0NDX01VTFRfTlVNOw0KPiANCj4gUmF0aGVyIHRo
YW4NCj4gDQo+ICAgICBzY2FsZWRfcHBtICogKDEgPDwgOSkNCj4gDQo+IEkgc3VnZ2VzdA0KPiAN
Cj4gICAgIHNjYWxlZF9wcG0gPDwgOQ0KPiANCj4gaW5zdGVhZC4gIEkgc3VwcG9zZSBhIGdvb2Qg
Y29tcGlsZXIgd291bGQgcmVwbGFjZSB0aGUgbXVsdGlwbGljYXRpb24gd2l0aCBhDQo+IGJpdCBz
aGlmdCwgYnV0IGl0IG5ldmVyIGh1cnRzIHRvIHNwZWxsIGl0IG91dC4NCg0KT2suDQoNCj4gDQo+
ID4gKwlhZGogPSBkaXZfczY0KGFkaiwgUFRQX1ZDTE9DS19DQ19NVUxUX0RFTSk7DQo+ID4gKw0K
PiA+ICsJc3Bpbl9sb2NrX2lycXNhdmUoJnZjbG9jay0+bG9jaywgZmxhZ3MpOw0KPiA+ICsJdGlt
ZWNvdW50ZXJfcmVhZCgmdmNsb2NrLT50Yyk7DQo+ID4gKwl2Y2xvY2stPmNjLm11bHQgPSBQVFBf
VkNMT0NLX0NDX01VTFQgKyBhZGo7DQo+ID4gKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZ2Y2xv
Y2stPmxvY2ssIGZsYWdzKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiANCj4g
VGhhbmtzLA0KPiBSaWNoYXJkDQo=
