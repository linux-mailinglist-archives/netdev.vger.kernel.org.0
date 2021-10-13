Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6142742B6AF
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237877AbhJMGRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:17:03 -0400
Received: from mail-eopbgr1400117.outbound.protection.outlook.com ([40.107.140.117]:51936
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231414AbhJMGRC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 02:17:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5PoAUpPMY8wZIlPn+qdR4jYhBOAjtMBZpzY8EHSHV+O4SBX7yTmGEQsbtF4qmDyPAmK2v3xXpAKWLGjpjiGdGBATDRlOXnstHMyCDTdWWgcFboMv58iLtGgoH48UTqEc2bo4CEkN5nSpa3X1NQ3L9k71y6j5feQ4S63vakKjW4195LK8DtxTGibADKN74X9keKEzyCQW1OBnT29MHGubf2sKDn+Id+ediCkW9SJOHlls2UOmuxLVwJbM5FD00HheUuNJKfb44h2HdC1HplUbqlZZEk39jyr2dnFcy3lWJhMO+9cNKWvbJq22c1SlSI/cO7d+iPQ0uy9lVkrNUA/pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hoqPLeW5LPVIEx1dTcgXV6v6n/cAIOGoxlTNqyhUx1U=;
 b=Oeyyd+EypIGyKPE3P9/nkNm81/gJyRFizHa07rImenoqsrxKZ8jM0TYOqCcL0qi/6DKwQZd8ORZtwR1nqy+eQR1mefYgBC2KKeTTDMSs25OZjWCGdw1r4nlOdLp4JiZx9GbC2PvkF473NqmnFja+BH415Zm2XS72UzQZ4yasWDA1jefpFZdwwQOIKM5nLc02rSc5MWAVEUm+4+peC1jEW6U1uIfdCfN9Bcr2uDpqB9kv9YyY0uxli+Jv7JviIrkBI6aFVbjc+3fckyl9vIW20I9VnQfig0kGtJQz1ZS6phdqbHc4koa6pRm39Dz8iETo7qXa8bc6pLbLNF7aAGHKpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hoqPLeW5LPVIEx1dTcgXV6v6n/cAIOGoxlTNqyhUx1U=;
 b=Hlti9I03Dx8scdVQyMpuTY9IK3i1A/vM9/pVQ1dOw2nq3Jfw9H/L12K6WMLemWi317SqfEdvMqRx1Cc/SzUjMN3QkaajvA1nYxusc8scT4jD7qfVeiziT3PtgAsKzwghgin3hmWp8pc0vpFJ8ewsZrV9w1POE18zuPU/6Lrr/pA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB4450.jpnprd01.prod.outlook.com (2603:1096:604:63::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 06:14:56 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 06:14:56 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v3 13/14] ravb: Update ravb_emac_init_gbeth()
Thread-Topic: [PATCH net-next v3 13/14] ravb: Update ravb_emac_init_gbeth()
Thread-Index: AQHXv4dnnKNAfP5bNkuTvIq9GdANz6vPn6iAgAAEiTCAAAONgIAABUnQgAABDQCAAAIh4IAAw3qQ
Date:   Wed, 13 Oct 2021 06:14:55 +0000
Message-ID: <OS0PR01MB592286B6E3CBDC31514A9B6C86B79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
 <20211012163613.30030-14-biju.das.jz@bp.renesas.com>
 <b06ad74a-5ecd-8dbf-4b54-fc18ce679053@omp.ru>
 <OS0PR01MB59220334F9C1891BE848638D86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <dd98fb58-5cd7-94d6-14d6-cc013164d047@gmail.com>
 <OS0PR01MB59223759B5B15858E394461086B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <8b261e85-4aa3-3d58-906d-4da931057e96@gmail.com>
 <OS0PR01MB592259FBB622ECABF6ED250486B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB592259FBB622ECABF6ED250486B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d89c0d70-0732-472f-988b-08d98e10c729
x-ms-traffictypediagnostic: OSAPR01MB4450:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB4450471149C1CCE64020F0EC86B79@OSAPR01MB4450.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ll84cshvt9xffjuMfoyr1AXGRGLIkUZOQ5BbBukwXns39112U9c7y4Xb/xYxEopsp2MR0AW1y41b+di2I06mdD4MgnCYGBZyShWuSQb9PcrHZnv35I3SMzudoyzrSxEZaw4uStJcqL6Rv02mCpZxlNUHuGk9wTUdD4mNkO5Y317pdynWLUTevJNVmGWWD8c+YnJvIZkN5jVnpltwOnG7C9Y4SB3U5MrkKxsbzSWvfwrxSeXrHvv/Dd4nzSBbCL6tUJd5yonpd0/hM0iclnEHJLuC/BO7o01o74aTO8j50bDJVX5iF3VQFFwWACkfq1/0Y9rICHLfpW4GB8VU+/gDiZKkB4IP8i/9AB3hJy9X7Gbsvj+leXJ1Xfb32wNqZwNmDvQOam73SpldTeif9VcRHvfhDvY0e/4rdd9WeLw3PDimKbZz1vp+T0K+CSiaofPLObd3g+Jin7uaaTJvkuj8w5uL+rfLQ/uzd02uZ6+553NYu+/V7HcAtcg3W0c1EWLbTeBimS4fxyAU8l0DNALtj4uN4ttsnv6aBuyulUQ5nsFR4sWoqrEpXFnMx0gPUrb5NsTI+fZv8ZwQViMSa2+PRVsRUH/C17cmJQjFrLoyG1D1mg9x3KxEsQb3Itq2lKCnLuS9gc6CVNSuMrI+ksPuFsacvEScEvmFljo0GKzbCq30YpYYzwJWgPNhWX/3Rn/t5sX7+sF9mnKIzBoifhK7qQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(76116006)(52536014)(66446008)(66556008)(66946007)(122000001)(5660300002)(110136005)(38070700005)(66476007)(38100700002)(4326008)(508600001)(71200400001)(8676002)(2906002)(83380400001)(15650500001)(26005)(33656002)(86362001)(8936002)(55016002)(7696005)(186003)(53546011)(107886003)(9686003)(7416002)(54906003)(6506007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T1VHZEJrdXJWNWowdVp1dkVpUkxqZjJsK0tTblJnYXJWSlBWVDU2Mk12NWor?=
 =?utf-8?B?aENGTFEySjlRN3oxbDEwS2srUDlmVHc4SDZzUUdZL2laRUtDS0ZxRnhmWjB3?=
 =?utf-8?B?YUo3Rm9yeW90d3NvZTJVMEtEZS9rUXpJelRTSUFmMVlZYzBCK09oYXdNYVNy?=
 =?utf-8?B?RHhMMEhJak5FZUdYeTZsN3YzYnpoam0vUnQwQ1pzY2w2MzErQk80bGlPQ0k4?=
 =?utf-8?B?aS9HcVJLSHBnRlVxU2VLbmJJVEozTG5zVlRJaUtGbTVkbWZ3aTNVVW03cUdG?=
 =?utf-8?B?TUZweFZIVk5CVW1yMGlxdllyWUtvTEQyU3lKYXpmUWRlSG5hTUZCOUMzYUcz?=
 =?utf-8?B?NFRmTnNWemYzT2hkTEpTb045cnFZd2JPdmdBdnpPOWduTU1pVXlFWDg3Q1Y0?=
 =?utf-8?B?VEZzRmhtZUZqSlBSTzZzNmNlZ3B2V0FaeFluNUpMMkN5UG5sRVpFMHZxNy8x?=
 =?utf-8?B?Ti90bS92K01jc0FheWpYN0pIVzJCRnhWVnpScUI0MXpUVm15dnQvRittdGFr?=
 =?utf-8?B?RGNPMmxsVXk0OXFxUUVLVzhQMXV4Q2hHUHR0UTAzSWRzdlVVcXpSWEthejMv?=
 =?utf-8?B?RmtmbHRybVpoSm5JM25aT0RRSG9BNTAveTFlMGg2OWg3M0paYVIxc255aEdX?=
 =?utf-8?B?RGFuS2IyRzY3WHFXVWdqay9LR1R4U24xaGpuL09pSHVmbEhPYzZFOHAvNUVJ?=
 =?utf-8?B?dHh0TGh6NUQwb2k1RzU4Q2Q3TWhQRzNmVHBtUVN1eis5ZHk4Rlg5bFJtbVNF?=
 =?utf-8?B?UWJWbmRYWFZlZGR2RnlvRjdHZkpqcitRR2htWW51T0dUNXdGangzbWNCQVZV?=
 =?utf-8?B?elZNKzB4cEpwcm1vazBwMENFbWhvaGZYTTZNWHNrSWVOaVhnNmQ3aGkrbVpH?=
 =?utf-8?B?OHRMcXJuQ2U1a2piVXI2Q25UQXJHNmNqOFpOV1dTdDVtZTl4S2hCUnNTYkk3?=
 =?utf-8?B?a0FKMUNGZDIwenlTSGlYM3hkYWIxVHBtTytHcmljVUtobGh3RmhINmthbW9F?=
 =?utf-8?B?SjVndG1XOFVNQmxiVGdROHNtcmJQaGV1WGRIOGJZRWoraWNUdzVaOWQxa1Ar?=
 =?utf-8?B?VmUvZElYWGdzNTV0c0FGZ2Y5bmlkNVFiWG1tSkp5SHo5bDY4TTNabE1DTlNF?=
 =?utf-8?B?eGVTSTVrMjR6YmEybk9YdGJOc2lJZldvSDlVUGM5RytkK1lmaktRSW9BVkpW?=
 =?utf-8?B?TnlzbDVra0l0MVNRT1c2Zk1SVFpaNGpzNmRGWklwOTVtdDB0M1BYZno3RWpI?=
 =?utf-8?B?Z0x0NDg2bXNReTFXdTNmeWMzcHN4WkhxMlZZZlFsQ0orM0g5R2ZXaks1a0cr?=
 =?utf-8?B?b0t4WU1JR2RucFUvdTdZYXY5K211WC9EWHVXdzFIM0s5U1dhckRJMWFVejAv?=
 =?utf-8?B?d3E4a2V0V2U0UmlaMFBrVUthdHVzazZzMjNOY0J3VHpVaUs5Qkc5T0tFVC8z?=
 =?utf-8?B?RzhuTmdUMVQ3ZzZkMUt4a3ZGc0F0aEZiVmFHcmNWemh3OXZkaGVZMnF4SkZS?=
 =?utf-8?B?cndSZzQ0UFplYTQxRlhFOVJpNy9kbVdUQkFvYU9UMlZyT3FJM1NPL1A5RUVz?=
 =?utf-8?B?YjhiM1pkTHZEZEJzc2pYem5MeVFDNHk4MmQvTEtkWDNPTXhsU0orOGZWODhC?=
 =?utf-8?B?bnJ4M1kyRExNSTNMbzdLQkFmVnROUEQ2MzgxV0xlS2hOSklEaVhuRTloQ1Ar?=
 =?utf-8?B?SlIvWEY4b1duR00ybTl6Wm5yN2RMbU5FejFUMEJMcFloaGZqT2VkV2VOMmNx?=
 =?utf-8?Q?Rxu4XvceK9wZmd5nXc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d89c0d70-0732-472f-988b-08d98e10c729
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 06:14:55.5913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +h7wxJJvD0+a+6GCLoAABnDcxGR5n6xFdmtw/Lcjm7iSo7wqfXQBhkMUktMG0gsKly6U767wz+EoCD7TC3cJkDJWh6D7JE05AjAu1xtwMBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4450
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggbmV0LW5leHQgdjMgMTMvMTRdIHJh
dmI6IFVwZGF0ZSByYXZiX2VtYWNfaW5pdF9nYmV0aCgpDQo+IA0KPiBIaSBTZXJnZXksDQo+IA0K
PiBUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCj4gDQo+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBu
ZXQtbmV4dCB2MyAxMy8xNF0gcmF2YjogVXBkYXRlDQo+ID4gcmF2Yl9lbWFjX2luaXRfZ2JldGgo
KQ0KPiA+DQo+ID4gT24gMTAvMTIvMjEgOToyMyBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+ID4NCj4g
PiA+Pj4+PiBUaGlzIHBhdGNoIGVuYWJsZXMgUmVjZWl2ZS9UcmFuc21pdCBwb3J0IG9mIFRPRSBh
bmQgcmVtb3ZlcyB0aGUNCj4gPiA+Pj4+PiBzZXR0aW5nIG9mIHByb21pc2N1b3VzIGJpdCBmcm9t
IEVNQUMgY29uZmlndXJhdGlvbiBtb2RlIHJlZ2lzdGVyLg0KPiA+ID4+Pj4+DQo+ID4gPj4+Pj4g
VGhpcyBwYXRjaCBhbHNvIHVwZGF0ZSBFTUFDIGNvbmZpZ3VyYXRpb24gbW9kZSBjb21tZW50IGZy
b20NCj4gPiA+Pj4+PiAiUEFVU0UgcHJvaGliaXRpb24iIHRvICJFTUFDIE1vZGU6IFBBVVNFIHBy
b2hpYml0aW9uOyBEdXBsZXg7DQo+ID4gPj4+Pj4gVFg7IFJYOyBDUkMgUGFzcyBUaHJvdWdoIi4N
Cj4gPiA+Pj4+DQo+ID4gPj4+PiAgICBJJ20gbm90IHN1cmUgd2h5IHlvdSBzZXQgRUNNUi5SQ1BU
IHdoaWxlIHlvdSBkb24ndCBoYXZlIHRoZQ0KPiA+ID4+Pj4gY2hlY2tzdW0gb2ZmbG9hZGVkLi4u
DQo+ID4gPj4+Pg0KPiA+ID4+Pj4+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5q
ekBicC5yZW5lc2FzLmNvbT4NCj4gPiA+Pj4+PiAtLS0NCj4gPiA+Pj4+PiB2Mi0+djM6DQo+ID4g
Pj4+Pj4gICogRW5hYmxlZCBUUEUvUlBFIG9mIFRPRSwgYXMgZGlzYWJsaW5nIGNhdXNlcyBsb29w
YmFjayB0ZXN0IHRvDQo+ID4gPj4+Pj4gZmFpbA0KPiA+ID4+Pj4+ICAqIERvY3VtZW50ZWQgQ1NS
MCByZWdpc3RlciBiaXRzDQo+ID4gPj4+Pj4gICogUmVtb3ZlZCBQUk0gc2V0dGluZyBmcm9tIEVN
QUMgY29uZmlndXJhdGlvbiBtb2RlDQo+ID4gPj4+Pj4gICogVXBkYXRlZCBFTUFDIGNvbmZpZ3Vy
YXRpb24gbW9kZS4NCj4gPiA+Pj4+PiB2MS0+djI6DQo+ID4gPj4+Pj4gICogTm8gY2hhbmdlDQo+
ID4gPj4+Pj4gVjE6DQo+ID4gPj4+Pj4gICogTmV3IHBhdGNoLg0KPiA+ID4+Pj4+IC0tLQ0KPiA+
ID4+Pj4+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgNiArKysr
KysNCj4gPiA+Pj4+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8
IDUgKysrLS0NCj4gPiA+Pj4+PiAgMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pDQo+ID4gPj4+Pj4NCj4gPiA+Pj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiA+Pj4+PiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gPj4+Pj4gaW5kZXggNjlhNzcxNTI2Nzc2Li4wODA2MmQ3
M2RmMTAgMTAwNjQ0DQo+ID4gPj4+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiLmgNCj4gPiA+Pj4+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jh
dmIuaA0KPiA+ID4+Pj4+IEBAIC0yMDQsNiArMjA0LDcgQEAgZW51bSByYXZiX3JlZyB7DQo+ID4g
Pj4+Pj4gIAlUTEZSQ1IJPSAweDA3NTgsDQo+ID4gPj4+Pj4gIAlSRkNSCT0gMHgwNzYwLA0KPiA+
ID4+Pj4+ICAJTUFGQ1IJPSAweDA3NzgsDQo+ID4gPj4+Pj4gKwlDU1IwICAgID0gMHgwODAwLAkv
KiBSWi9HMkwgb25seSAqLw0KPiA+ID4+Pj4+ICB9Ow0KPiA+ID4+Pj4+DQo+ID4gPj4+Pj4NCj4g
PiA+Pj4+PiBAQCAtOTY0LDYgKzk2NSwxMSBAQCBlbnVtIENYUjMxX0JJVCB7DQo+ID4gPj4+Pj4g
IAlDWFIzMV9TRUxfTElOSzEJPSAweDAwMDAwMDA4LA0KPiA+ID4+Pj4+ICB9Ow0KPiA+ID4+Pj4+
DQo+ID4gPj4+Pj4gK2VudW0gQ1NSMF9CSVQgew0KPiA+ID4+Pj4+ICsJQ1NSMF9UUEUJPSAweDAw
MDAwMDEwLA0KPiA+ID4+Pj4+ICsJQ1NSMF9SUEUJPSAweDAwMDAwMDIwLA0KPiA+ID4+Pj4+ICt9
Ow0KPiA+ID4+Pj4+ICsNCj4gPiA+Pj4+DQo+ID4gPj4+PiAgIElzIHRoaXMgcmVhbGx5IG5lZWRl
ZCBpZiB5b3UgaGF2ZSBFQ01SLlJDUFQgY2xlYXJlZD8NCj4gPiA+Pj4NCj4gPiA+Pj4gWWVzIGl0
IGlzIHJlcXVpcmVkLiBQbGVhc2Ugc2VlIHRoZSBjdXJyZW50IGxvZyBhbmQgbG9nIHdpdGggdGhl
DQo+ID4gPj4+IGNoYW5nZXMgeW91IHN1Z2dlc3RlZA0KPiA+ID4+Pg0KPiA+ID4+PiByb290QHNt
YXJjLXJ6ZzJsOi9yemcybC10ZXN0LXNjcmlwdHMjIC4vZXRoX3RfMDAxLnNoDQo+ID4gPj4+IFsg
ICAzOS42NDY4OTFdIHJhdmIgMTFjMjAwMDAuZXRoZXJuZXQgZXRoMDogTGluayBpcyBEb3duDQo+
ID4gPj4+IFsgICAzOS43MTUxMjddIHJhdmIgMTFjMzAwMDAuZXRoZXJuZXQgZXRoMTogTGluayBp
cyBEb3duDQo+ID4gPj4+IFsgICAzOS44OTU2ODBdIE1pY3JvY2hpcCBLU1o5MTMxIEdpZ2FiaXQg
UEhZIDExYzIwMDAwLmV0aGVybmV0LQ0KPiA+ID4+IGZmZmZmZmZmOjA3OiBhdHRhY2hlZCBQSFkg
ZHJpdmVyDQo+ID4gPj4gKG1paV9idXM6cGh5X2FkZHI9MTFjMjAwMDAuZXRoZXJuZXQtDQo+ID4g
Pj4gZmZmZmZmZmY6MDcsIGlycT1QT0xMKQ0KPiA+ID4+PiBbICAgMzkuOTY2MzcwXSBNaWNyb2No
aXAgS1NaOTEzMSBHaWdhYml0IFBIWSAxMWMzMDAwMC5ldGhlcm5ldC0NCj4gPiA+PiBmZmZmZmZm
ZjowNzogYXR0YWNoZWQgUEhZIGRyaXZlcg0KPiA+ID4+IChtaWlfYnVzOnBoeV9hZGRyPTExYzMw
MDAwLmV0aGVybmV0LQ0KPiA+ID4+IGZmZmZmZmZmOjA3LCBpcnE9UE9MTCkNCj4gPiA+Pj4gWyAg
IDQyLjk4ODU3M10gSVB2NjogQUREUkNPTkYoTkVUREVWX0NIQU5HRSk6IGV0aDA6IGxpbmsgYmVj
b21lcw0KPiByZWFkeQ0KPiA+ID4+PiBbICAgNDIuOTk1MTE5XSByYXZiIDExYzIwMDAwLmV0aGVy
bmV0IGV0aDA6IExpbmsgaXMgVXAgLSAxR2Jwcy9GdWxsDQo+IC0NCj4gPiA+PiBmbG93IGNvbnRy
b2wgb2ZmDQo+ID4gPj4+IFsgICA0My4wNTI1NDFdIElQdjY6IEFERFJDT05GKE5FVERFVl9DSEFO
R0UpOiBldGgxOiBsaW5rIGJlY29tZXMNCj4gcmVhZHkNCj4gPiA+Pj4gWyAgIDQzLjA1NTcxMF0g
cmF2YiAxMWMzMDAwMC5ldGhlcm5ldCBldGgxOiBMaW5rIGlzIFVwIC0gMUdicHMvRnVsbA0KPiAt
DQo+ID4gPj4gZmxvdyBjb250cm9sIG9mZg0KPiA+ID4+Pg0KPiA+ID4+PiBFWElUfFBBU1N8fFs0
MjIzOTE6NDM6MDBdIHx8DQo+ID4gPj4+DQo+ID4gPj4+IHJvb3RAc21hcmMtcnpnMmw6L3J6ZzJs
LXRlc3Qtc2NyaXB0cyMNCj4gPiA+Pj4NCj4gPiA+Pj4NCj4gPiA+Pj4gd2l0aCB0aGUgY2hhbmdl
cyB5b3Ugc3VnZ2VzdGVkDQo+ID4gPj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4g
PiA+Pj4NCj4gPiA+Pj4gcm9vdEBzbWFyYy1yemcybDovcnpnMmwtdGVzdC1zY3JpcHRzIyAuL2V0
aF90XzAwMS5zaA0KPiA+ID4+PiBbICAgMjMuMzAwNTIwXSByYXZiIDExYzIwMDAwLmV0aGVybmV0
IGV0aDA6IExpbmsgaXMgRG93bg0KPiA+ID4+PiBbICAgMjMuNTM1NjA0XSByYXZiIDExYzMwMDAw
LmV0aGVybmV0IGV0aDE6IGRldmljZSB3aWxsIGJlIHN0b3BwZWQNCj4gPiBhZnRlcg0KPiA+ID4+
IGgvdyBwcm9jZXNzZXMgYXJlIGRvbmUuDQo+ID4gPj4+IFsgICAyMy41NDcyNjddIHJhdmIgMTFj
MzAwMDAuZXRoZXJuZXQgZXRoMTogTGluayBpcyBEb3duDQo+ID4gPj4+IFsgICAyMy44MDI2Njdd
IE1pY3JvY2hpcCBLU1o5MTMxIEdpZ2FiaXQgUEhZIDExYzIwMDAwLmV0aGVybmV0LQ0KPiA+ID4+
IGZmZmZmZmZmOjA3OiBhdHRhY2hlZCBQSFkgZHJpdmVyDQo+ID4gPj4gKG1paV9idXM6cGh5X2Fk
ZHI9MTFjMjAwMDAuZXRoZXJuZXQtDQo+ID4gPj4gZmZmZmZmZmY6MDcsIGlycT1QT0xMKQ0KPiA+
ID4+PiBbICAgMjQuMDMxNzExXSByYXZiIDExYzMwMDAwLmV0aGVybmV0IGV0aDE6IGZhaWxlZCB0
byBzd2l0Y2ggZGV2aWNlDQo+IHRvDQo+ID4gPj4gY29uZmlnIG1vZGUNCj4gPiA+Pj4gUlRORVRM
SU5LIGFuc3dlcnM6IENvbm5lY3Rpb24gdGltZWQgb3V0DQo+ID4gPj4+DQo+ID4gPj4+IEVYSVR8
RkFJTHx8WzQyMjM5MTo0MjozMl0gRmFpbGVkIHRvIGJyaW5nIHVwIEVUSDF8fA0KPiA+ID4+Pg0K
PiA+ID4+PiByb290QHNtYXJjLXJ6ZzJsOi9yemcybC10ZXN0LXNjcmlwdHMjDQo+ID4gPj4NCj4g
PiA+PiAgICBIbS4uLiA6LS8NCj4gPiA+PiAgICBXaGF0IGlmIHlvdSBvbmx5IGNsZWFyIEVDTVIu
UkNQVCBidXQgY29udGludWUgdG8gc2V0IENTUjA/DQo+ID4gPg0KPiA+ID4gV2UgYWxyZWFkeSBz
ZWVuLCBSQ1BUPTAsIFJDU0M9MSB3aXRoIHNpbWlsYXIgSGFyZHdhcmUgY2hlY2tzdW0NCj4gPiA+
IGZ1bmN0aW9uIGxpa2UgUi1DYXIsIFN5c3RlbSBjcmFzaGVzLg0KPiA+DQo+ID4gICAgSSBkaWRu
J3QgdGVsbCB5b3UgdG8gc2V0IEVDTVIuUkNTQyB0aGlzIHRpbWUuIDotKQ0KPiANCj4gVGhlb3Jl
dGljYWxseSwgSXQgc2hvdWxkIHdvcmsgYXMgaXQgaXMuIEFzIHdlIGFyZSBub3QgZG9pbmcgYW55
IGhhcmR3YXJlDQo+IGNoZWNrc3VtLA0KPiANCj4gSC9XIGlzIGp1c3QgcGFzc2luZyBSWCBDU1VN
IHRvIFRPRSB3aXRob3V0IGFueSBzb2Z0d2FyZSBpbnRlcnZlbnRpb24uDQo+IA0KPiBJdCBpcyBj
bGVhcmx5IG1lbnRpb25lZCBpbiBkYXRhIHNoZWV0LCBpdCBpcyBIVyBjb250cm9sbGVkLg0KPiAN
Cj4gMjUgUkNQVCBC4oCZMCBSL1cgUmVjZXB0aW9uIENSQyBQYXNzIFRocm91Z2gNCj4gMTogQ1JD
IG9mIHJlY2VpdmVkIGZyYW1lIGlzIHRyYW5zZmVycmVkIHRvIFRPRS4NCj4gUkNTQyAoYXV0byBj
YWxjdWxhdGlvbiBvZiBjaGVja3N1bSBvZiByZWNlaXZlZCBmcmFtZSBkYXRhIHBhcnQpIGZ1bmN0
aW9uDQo+IGlzIGRpc2FibGVkIGF0IHRoaXMgdGltZS4NCj4gMDogQ1JDIG9mIHJlY2VpdmVkIGZy
YW1lIGlzIG5vdCB0cmFuc2ZlcnJlZCB0byBUT0UuDQo+IA0KDQpUaGUgYm9hcmQgZG9lc24ndCBi
b290IHdpdGggTkZTLCBpZiBJIHRha2Ugb3V0IFJDUFQuIFNvIGl0IGlzIG5lZWRlZA0K
