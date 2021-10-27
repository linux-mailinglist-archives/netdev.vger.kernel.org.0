Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3937243CA47
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbhJ0NHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:07:16 -0400
Received: from mail-db8eur05on2053.outbound.protection.outlook.com ([40.107.20.53]:33536
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233332AbhJ0NHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 09:07:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxWqomxjYBIfgcxLph7UXxuxjVjuO6p0IEa9JSh04RM0Pn0g1V8d4iEtxzQQYfkwgcu8alePKaFUkEK28Wq/i4paQ6oWleImDVh/obvauE6XbGQlxOXpzichudpPlCDs01OxFcFEZP0iPbtXnzkWeKJNt/t9IqpMzhivV+ctbbLAWxGzWTJjFggep59MBzYOjn0h4RDcPn9sklJosRWhMb09lMvxaoKQAlH2gOEishj/NyhVSBnoIWaN5lKcdF78pwZ3yH8bQd7ekeR06ydjPOvXULW7dMaxZO6ZEUiXPLv8eWRZKLJiwjxXGG6JVj1EhVmTg0pe6Gm7SKIk+KmfgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HePWRwdbHNTdDIWKpZRAWCpQqUOfx+gaBD9ZprtY4SQ=;
 b=XK6AquYxLdIAb2ERyHJP3Is6OvalNHsNEEZqsVfmHAVIP1ZPzcK6AkpIRCoJtTbHQIXh6/DvFdW7yRL+7ZKv9ij/wvOZg33/nlQlEW8ePXlWtaXgUKieUavZxNplHhM850BeD4t2v2HxSzjwyzDbxIC1RVM20r4QznSC+EbEQcVqgblPxxUA+nhAiygypyfCF1iROznVoDnDcs1v/X4ri8FoLrNhuX9/28+0HqJGlDSlMx16BsFuDbu92q2+wzICC9ePbbhCqnZqB0wgVWqYsy3u6W0wdl5CTwMZhSRtQyqdFsglMub1vhlEAFzlDfxJwY3H9K5gUM0BwiYL4YvduQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HePWRwdbHNTdDIWKpZRAWCpQqUOfx+gaBD9ZprtY4SQ=;
 b=qfdZZxFH3tRBK6P4DyuLKkJbjfGDIQVj730O9jz+qrgfoZabumKVun/ok7Zs2ckd5E10VHlyHqIlVxROUioVRGox+gzK8WTDDnWTD/bVhRzcMdI3R+ENtgw13dicqzAOIViQL/in/jrezP9cnIJUsA5MNYbO5XqMGXnnY2RHdFA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4686.eurprd04.prod.outlook.com (2603:10a6:803:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 13:04:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 13:04:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 6/8] net: bridge: move br_fdb_replay inside
 br_switchdev.c
Thread-Topic: [PATCH net-next 6/8] net: bridge: move br_fdb_replay inside
 br_switchdev.c
Thread-Index: AQHXynWzjMHxru/+PEOzqRDNrxzwF6vmgQIAgAADSICAAEuXAIAAAaOA
Date:   Wed, 27 Oct 2021 13:04:48 +0000
Message-ID: <20211027130447.esi2em63v63rla3s@skbuf>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-7-vladimir.oltean@nxp.com>
 <YXkK5jp7FHwJEeuw@shredder> <b73e4afe-07a7-08df-cc29-c2490265f2f8@nvidia.com>
 <20211027125856.wypzqjpepceq3jsy@skbuf>
In-Reply-To: <20211027125856.wypzqjpepceq3jsy@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82e09e2d-82b1-4719-933a-08d9994a5b03
x-ms-traffictypediagnostic: VI1PR04MB4686:
x-microsoft-antispam-prvs: <VI1PR04MB4686A5851BEC85CBFB014622E0859@VI1PR04MB4686.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SnjlRFZADUXTcH4FYmT6C4DHNAmYA3HVRUxGqxNG/W6Ffqg2Bx+7DPL9tvmlIprBlOHRnP/C7gNeOfiPmBKmVcKnbZJkJ48lsEKjwmOiJOVX8EREsE/3BHVBgySak8vdKztqdHsSMtLBT9EhWm0/Yd8Bv918IQdodENEfQVDyErlLV0uwkB7a37pegwRYlyGXJRSEuY2Yf7y9iI6gp5UMVt9BE0xhGWcPe9mWohjYBB01iItTkL2Upne/Ve7ZuYEVo1km2EC9xTF7HD1BAaesaIzbxAbLthE0naioWuYhtcBUzrgLmrQ5ktZmDneOtIza83bjsWZMQOTOoNjxThPsTTaUQzPS6cY0b+MQ5wKGSwU0E9ZmgqMbotxdJgBPLrNbeZwkd2Sw4pvdcJJSIe/ZEU+KwKgqiCV5pg/yFDQOp7TrPKxrhSldCecutKZrDlXaZQnO6KGtdj9JM9zOIsvti9Zv1taK6ViMqfL1kMEUAyObeHvVpW1OOvzU6LC2IfYEoT8i2TKgUs0+S4G59T3GZBSv5YBhsYUcKOXCjlxVdnX813YUWxYbb5Tuql9x53yd4mhFKvXrAxNUlJW3lOpufyvKRtqWIuMPGFoAwDJRokNmwdJz82a8Tz9pEZofBa9riOXkx57i8FNRgZOhQ1A1S397RMWJw6e5N2c+2VNiVHHXEJ4esxjtZegLQ/26QvX1di7jQL7jWF7xWN33Lnx9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6916009)(8936002)(8676002)(64756008)(66556008)(71200400001)(53546011)(508600001)(33716001)(186003)(9686003)(6512007)(66446008)(6506007)(1076003)(5660300002)(26005)(44832011)(86362001)(66946007)(91956017)(122000001)(6486002)(38100700002)(76116006)(38070700005)(54906003)(2906002)(66476007)(83380400001)(7416002)(316002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUZLcGRQZ3F6R0lRb0o3cVZ6V0pMT3lSVGl3SURzTTFwa0IrQ3BVZDJjK3A3?=
 =?utf-8?B?UHQ5S1Q1ZEI0c1U2OTljKzlJQTFaeFBlRjZaYWNic1l6S0JyeUNsUllDNDdr?=
 =?utf-8?B?TEw0bmkvNGc4TzlmcEJjSU1sN1R4VFJ1MnBqT1lTZEszaytpQXhrbUFnb0hR?=
 =?utf-8?B?Ykg5blJ5Mk9iWFBBUG9hNFNTWlVPMUp5a2M4OGsrMkIwS1dzL0lkQmxORzdM?=
 =?utf-8?B?MThwNzBPN2R5dW5NM09aUTBVUkJReW9lMEpoMDJ6eEd4NWxoT3R3MEpubnJG?=
 =?utf-8?B?WVJIQ1JLajl5dVpyNFV2OFlrWUp2QTMzNFFXUzRhK0NxbzVEbUNSOURCN1lm?=
 =?utf-8?B?YkZBQ2dXN2paWG5QRk1qNUVSQ1hWLyttQ3ZudVU0bFFjMDFURVBJR1Y2QnZz?=
 =?utf-8?B?OU5LR05UbzdWWU5aTEUzck1NbUtvb0JxSXVSa2dYT2ZkNCs4elBJWHFxK0VH?=
 =?utf-8?B?WUpDQmRyZTVEb0p6a1JqZ2FnNG5pM3dlcWlJQTFlNHd0bFZwY3AzQmN1a0hV?=
 =?utf-8?B?aHZGTGNLVzdCWVpQQWxCYjluRjVoTk8rZlNpWnBLY080VEJ2Vm4zYjlDRk1R?=
 =?utf-8?B?T29GckJwRFVFbW9SWUZ6SGU3TFUyQmc3UTUweDFwdEtWLzc1dEJYT1QyZlkw?=
 =?utf-8?B?NS9aMHIrWExQQVl6eGZKODFUQXN0YWxnZWdPVjZNUFBUYUYxS3JLMDdHR0ts?=
 =?utf-8?B?OS8xRXg0VFFxUjZrTUJVZDNuUlRMNDdqdC9wTkozSk9XMTFUb2FibG10RS9Z?=
 =?utf-8?B?cTNCUlM5L3E1TG8wODdoR0lzYXdDN2ZuOUJwVWRxQlZURStlRG5hUFdwQzR3?=
 =?utf-8?B?Qmdac1hLTWVHdVRKdDJEVm5aa1I1bXExcEtteXFNNXdoNC9iTjJQTk1tQkpm?=
 =?utf-8?B?VGRyNkxYRXNNQ3RzNGRndGdaWHpNZThWNVhwMXU2eldNaWtzUGo3UHV6RTVy?=
 =?utf-8?B?VEFjYWJxRWF6eFhrZTl3TmdhWjRVMEpHV3ppam9Yd3owRTY0VzN1NHlxWVpN?=
 =?utf-8?B?SnhQeERYelAreTdoOHBmbFVsQnRxN1FIYVNtMHhOZ1k2S3d5WTVOYzRRSUsw?=
 =?utf-8?B?WkNmUTgxN2xBNWUwTTlzUEMybUlVbG80bDd6T053RmNlY1BNUTdIWFBld1or?=
 =?utf-8?B?UmtxN1l1VnVPUlMxZENXamhtVU1rRTQ2TmxiQlJnOC9ZdDNtVmFMQVFnampK?=
 =?utf-8?B?VnA1ZmVJQkZxQjRRZUlrMGhKa1BXcDJ4Rm9rNmpnUlNZcXg2alhXVXU4cUlv?=
 =?utf-8?B?MEVLTUF0Y3VvTzZPUUJnMDFoNG1QNFF5YnZVRXd5RUZ2SlNSamh0NVZmbFM0?=
 =?utf-8?B?Z1V5b1ZVVDZ6bWxTRWtMbVJQTWVQeGQvbkd6RzhxSGNlMk0wbkl2aFM0dGk3?=
 =?utf-8?B?UUFqWTdvaE9KNjlOTjM3b3hVN0RIYml3TjB3YkdPMWJ5TVZMWklQQzhBa215?=
 =?utf-8?B?dWJMUDBxc1VYWHF6d2NMOHpDZWp6QjlTRWI5KzJmU3Y3UGh0NjczNzh6aDhE?=
 =?utf-8?B?ZFJmVkt2YWpCeG9Ocjc2c3h1WGZ4S0xsZGhwYkgxRWtlR2IrUnRGbitLa2Fh?=
 =?utf-8?B?NG4yVFdZUnJSWmdhbTlUc0JtVm11eUZQdTg1cmo2UmkyYktyeTBwbTJJUHFN?=
 =?utf-8?B?dWdkenZHc2tmanBUVFJCVVFHcFRyM0haS25tR0JFQ2FPMUtHS3BTb2hXNEtu?=
 =?utf-8?B?NDhxQklwRjBCTTNnTHVlTzdxU3h4Q0FqWGdnMDEwZGx2bHN6c011dk9MdjM1?=
 =?utf-8?B?V2k1c1kyLzYvK3FaNm5BSlU0ZHB5ZExabzl0cmRiUURENWxVNllReUVIenJC?=
 =?utf-8?B?dEVZMEVBS0VEbCt0cUp0c1R4UjZzUGhHWUJvZ3J1TVErb1NlRmR6WXV3YTJ2?=
 =?utf-8?B?dEo1SXFXSzRpY2MzL2Z1clF5VWpNbWpqdW9ieXFMRVAxajRyTGlIbTZTN0E1?=
 =?utf-8?B?TWlSTWZydlRWMm14WmlEQWU3aG43dEdJVXNsdkNwcjg2cUVlSmNyejdTVUZB?=
 =?utf-8?B?MlJUU2QzRzNGU1dNc2Z0WHNWSVlQOWxncTJvejZJQVFjWmczZ1F6VVBZQ2NY?=
 =?utf-8?B?REJsdDFCbEpaNTFSa0J1OFVzcnF0Y3RpNCtYV0tYekk5ejJnLzdFdVd3bkZy?=
 =?utf-8?B?bE0yeXRSdlg5V3FYSmZrQ0tPbFJPV2M0VklFYzNWc2JaYWhocnV5UUhXVUVY?=
 =?utf-8?Q?uvWIzUe9CzgnpR1f2QwO8ZibKcdbwinwzhjTUUMdT7iv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD717464B5CE704CA15432F9017497C9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e09e2d-82b1-4719-933a-08d9994a5b03
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 13:04:48.2556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0zyd4KzHnxGnsI4ZlW/rOhx/XfRAb0tYqp5jDcFXvHMwVAdLm+qq4RJsRhEdx4bWiowUD1OaPkCKGKTv3FxwPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBPY3QgMjcsIDIwMjEgYXQgMDM6NTg6NTZQTSArMDMwMCwgVmxhZGltaXIgT2x0ZWFu
IHdyb3RlOg0KPiBPbiBXZWQsIE9jdCAyNywgMjAyMSBhdCAxMToyODoyM0FNICswMzAwLCBOaWtv
bGF5IEFsZWtzYW5kcm92IHdyb3RlOg0KPiA+IE9uIDI3LzEwLzIwMjEgMTE6MTYsIElkbyBTY2hp
bW1lbCB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgT2N0IDI2LCAyMDIxIGF0IDA1OjI3OjQxUE0gKzAz
MDAsIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4gPiA+PiBicl9mZGJfcmVwbGF5IGlzIG9ubHkg
Y2FsbGVkIGZyb20gc3dpdGNoZGV2IGNvZGUgcGF0aHMsIHNvIGl0IG1ha2VzDQo+ID4gPj4gc2Vu
c2UgdG8gYmUgZGlzYWJsZWQgaWYgc3dpdGNoZGV2IGlzIG5vdCBlbmFibGVkIGluIHRoZSBmaXJz
dCBwbGFjZS4NCj4gPiA+Pg0KPiA+ID4+IEFzIG9wcG9zZWQgdG8gYnJfbWRiX3JlcGxheSBhbmQg
YnJfdmxhbl9yZXBsYXkgd2hpY2ggbWlnaHQgYmUgdHVybmVkIG9mZg0KPiA+ID4+IGRlcGVuZGlu
ZyBvbiBicmlkZ2Ugc3VwcG9ydCBmb3IgbXVsdGljYXN0IGFuZCBWTEFOcywgRkRCIHN1cHBvcnQg
aXMNCj4gPiA+PiBhbHdheXMgb24uIFNvIG1vdmluZyBicl9tZGJfcmVwbGF5IGFuZCBicl92bGFu
X3JlcGxheSBpbnNpZGUNCj4gPiA+PiBicl9zd2l0Y2hkZXYuYyB3b3VsZCBtZWFuIGFkZGluZyBz
b21lICNpZmRlZidzIGluIGJyX3N3aXRjaGRldi5jLCBzbyB3ZQ0KPiA+ID4+IGtlZXAgdGhvc2Ug
d2hlcmUgdGhleSBhcmUuDQo+ID4gPiANCj4gPiA+IFRCSCwgZm9yIGNvbnNpc3RlbmN5IHdpdGgg
YnJfbWRiX3JlcGxheSgpIGFuZCBicl92bGFuX3JlcGxheSgpLCBpdCB3b3VsZA0KPiA+ID4gaGF2
ZSBiZWVuIGdvb2QgdG8ga2VlcCBpdCB3aGVyZSBpdCBpcywgYnV0IC4uLg0KPiA+ID4gDQo+ID4g
Pj4NCj4gPiA+PiBUaGUgcmVhc29uIGZvciB0aGUgbW92ZW1lbnQgaXMgdGhhdCBpbiBmdXR1cmUg
Y2hhbmdlcyB0aGVyZSB3aWxsIGJlIHNvbWUNCj4gPiA+PiBjb2RlIHJldXNlIGJldHdlZW4gYnJf
c3dpdGNoZGV2X2ZkYl9ub3RpZnkgYW5kIGJyX2ZkYl9yZXBsYXkuDQo+ID4gPiANCj4gPiA+IHRo
aXMgc2VlbXMgbGlrZSBhIGdvb2QgcmVhc29uLCBzbzoNCj4gPiA+IA0KPiA+ID4gUmV2aWV3ZWQt
Ynk6IElkbyBTY2hpbW1lbCA8aWRvc2NoQG52aWRpYS5jb20+DQo+ID4gPiANCj4gPiA+IE5paywg
V0RZVD8NCj4gPiA+IA0KPiA+IA0KPiA+IEdvb2QgcG9pbnQsIGl0J2QgYmUgbmljZSB0byBoYXZl
IHRoZW0gYWxsIGluIG9uZSBwbGFjZSwgc2luY2UgdGhleSBhbGwgZGVhbA0KPiA+IHNwZWNpZmlj
YWxseSB3aXRoIHN3aXRjaGRldiB3ZSBjYW4gbW92ZSB0aGVtIHRvIGJyX3N3aXRjaGRldi5jLiBX
ZSBjYW4gYWxzbw0KPiA+IHJlbmFtZSB0aGVtIHNpbWlsYXIgdG8gb3RoZXIgZnVuY3Rpb25zIGlu
IGJyX3N3aXRjaGRldiwgZS5nLiBicl9zd2l0Y2hkZXZfZmRiX3JlcGxheQ0KPiANCj4gTG9va3Mg
bGlrZSB3ZSBjYW0gbW92ZSBhIHN1cnByaXNpbmdseSBsYXJnZSBhbW91bnQgb2YgY29kZSBmcm9t
IGJyX21kYi5jDQo+IHRvIGJyX3N3aXRjaGRldi5jLiBUaGUgb25seSBwcm9ibGVtIGlzOg0KPiAN
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdGhpcyB1c2VkIHRv
IGJlIGNhbGxlZCBicl9tZGJfY29tcGxldGUNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2DQo+IG5ldC9icmlkZ2UvYnJfc3dp
dGNoZGV2LmM6IEluIGZ1bmN0aW9uIOKAmGJyX3N3aXRjaGRldl9tZGJfY29tcGxldGXigJk6DQo+
IG5ldC9icmlkZ2UvYnJfc3dpdGNoZGV2LmM6NDM3OjIwOiBlcnJvcjog4oCYc3RydWN0IG5ldF9i
cmlkZ2XigJkgaGFzIG5vIG1lbWJlciBuYW1lZCDigJhtdWx0aWNhc3RfbG9ja+KAmTsgZGlkIHlv
dSBtZWFuIOKAmG11bHRpY2FzdF9jdHjigJk/DQo+ICAgNDM3IHwgIHNwaW5fbG9ja19iaCgmYnIt
Pm11bHRpY2FzdF9sb2NrKTsNCj4gICAgICAgfCAgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+
fn5+fn4NCj4gICAgICAgfCAgICAgICAgICAgICAgICAgICAgbXVsdGljYXN0X2N0eA0KPiANCj4g
V291bGQgeW91IGxpa2UgbWUgdG8gaW50cm9kdWNlIGEgc2V0IG9mIGJyX211bHRpY2FzdF9sb2Nr
KCkgYW5kDQo+IGJyX211bHRpY2FzdF91bmxvY2soKSBoZWxwZXJzIHRoYXQgaGF2ZSBzaGltIGRl
ZmluaXRpb25zIHNvIHRoYXQgdGhleQ0KPiB3b3JrIHdoZW4gQ09ORklHX0JSSURHRV9JR01QX1NO
T09QSU5HIGlzIGRpc2FibGVkPw0KPiANCj4gQW55d2F5LCBJJ2QgbGlrZSB0byBkbyB0aGlzIHNl
Y29uZCBwYXJ0IG9mIHJlZmFjdG9yaW5nIGluIGEgc2Vjb25kIHBhdGNoDQo+IHNlcmllcywgaWYg
eW91IGRvbid0IG1pbmQuDQoNCkFoLCBkb24ndCBtaW5kIG1lLCB0aGVyZSdzIG1vcmUuIFRoZSBl
bnRpcmUgJmJyLT5tZGJfbGlzdCBpcyB1bmRlcg0KQ09ORklHX0JSSURHRV9JR01QX1NOT09QSU5H
LiBTbyBJIGd1ZXNzIG15IG9ubHkgb3B0aW9uIGlzIHRvIHNsYXAgYSBiaWcNCiNpZmRlZiBDT05G
SUdfQlJJREdFX0lHTVBfU05PT1BJTkcgaWYgSSBtb3ZlIHRoZXNlIHRvIGJyX3N3aXRjaGRldi5j
Lg0KSSBndWVzcyBJIG1pZ2h0IGRvIHRoYXQgYW55d2F5Lg==
