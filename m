Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9BE4D8A15
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 17:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243322AbiCNQo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 12:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244479AbiCNQnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 12:43:52 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70057.outbound.protection.outlook.com [40.107.7.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46AF433B0
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 09:42:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghJBJVW54TExIu/vaevFVVmZudvuJylF+QBqqDqRUoZkLW44nEtBvD3UD0m36bP99w671AQ9e0ZLMS2uzgEMKjKd+BGF9KuMayGkmHgKyk5jjVdptrqozy8u55kivMvJBSw2AuuS66zZGaD1NU3J5qepIE9U0BMiHYY/DgIg8YbrwRU/fA6fzyMN1kwi1mNPC4IV9QhGqb9gBqv+9OJz39QPeUqzg7VGKcZVT33FNjZ4Mu90/et+WACf31A2CF3ANd0qrg3JVIraz+h2rHzWrDrQBrONeFTtJW/vArxYiIFg0lkQNReXsuAS/VNgTGL6lEW32oeF+wOfe/I7AEz6Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1eJi0laQ0JfF202FewaxTa7p9NZjNgcGqobyuTNyf0=;
 b=grI6FPkzLYofAOJuQ9JoZfQl7uMYoXnFMweSI2r13mJOI0fK5c1LKNFN4Iwv9jyk7SrozCLXiHOrfWpSAXUxxUGde2uAPTkP/G7sWU1S4qH5tm0g1gZUmiY0vW/yWJyOc2viYmvTqxLWefxmcNOwWiConXHjP9v7ehfDvigYMEgiMtW+73fLqTp9Sr4H7QIcNaMbxBol9lVCRPjovq7s7J4d/JrlFeaeB/PbFIptKBKYYZyxloCzLePr9nJKCWgYmpNPsVfVUZts6VWcVh5VYtF7v2ASqbmcXFtcuRXy33ic8nayRepRgldyyIRHSj+Z0YGxPTvpwluCFPEAmOhPLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1eJi0laQ0JfF202FewaxTa7p9NZjNgcGqobyuTNyf0=;
 b=cpkdL/ZYeAWtl7fClo1Z1DSL4V5OYnOHR4ifkMjl/0/G4NFSlNEKEZw1qzFJEUYDzaVlYPfWdzgJfU61c/FJCpiJjoIkdU2vvomVUHeYpwVKi6c9g/67CFHX4as+qetFTz2O3u7lqI3QDmsvACnT4FdhFhG4RZSalTaZN/JA7so=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4624.eurprd04.prod.outlook.com (2603:10a6:803:72::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28; Mon, 14 Mar
 2022 16:42:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5061.026; Mon, 14 Mar 2022
 16:42:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
CC:     Tobias Waldekranz <tobias@waldekranz.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?SmFuIELEm3TDrWs=?= <hagrid@svine.us>
Subject: Re: [PATCH net] net: dsa: fix panic when port leaves a bridge
Thread-Topic: [PATCH net] net: dsa: fix panic when port leaves a bridge
Thread-Index: AQHYN7j4R52Ve+kGyEmg11EfqSyjH6y/BomAgAAEq4CAAAM/AIAABOCAgAACQAA=
Date:   Mon, 14 Mar 2022 16:42:37 +0000
Message-ID: <20220314164236.5s4g2w453fxuulzw@skbuf>
References: <20220314153410.31744-1-kabel@kernel.org>
 <87tuc0lelc.fsf@waldekranz.com> <20220314170529.2b71978d@dellmb>
 <20220314161706.mo3ph3aadzdqwdag@skbuf> <20220314173433.793d25e8@dellmb>
In-Reply-To: <20220314173433.793d25e8@dellmb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 003f9663-1042-4369-299f-08da05d9a5b4
x-ms-traffictypediagnostic: VI1PR04MB4624:EE_
x-microsoft-antispam-prvs: <VI1PR04MB46242FFFEC15D4540EF87BDBE00F9@VI1PR04MB4624.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YHzXgGG3d/MeLTOTE65CN1dhgCoJtC3K2r88X2W5wxE1pWIdYNekp8Sm9zUHw/eSLnw65mxD6NgrWVLyGS/yy7pJQPFMvOjhyBEPKOKm8WmYFGIYxOJhO29/Z7viJBCANS1ZnqH91z0xG0UpQG65ZT5EqwgvWc51F49uahS+jbykDajdFS+BaO6JbTvp+4vupGEtr12driXKkL61w2eaeCS05ZG8xgIvAX9pSKT1+HfWipg/iG2WjsHDm85EOR6jEM4LV7dR03tzSANgdbH2JIcYpvYtNO7aQe/+dufaybbPTZAyAzcbu2o0CplISrg68bLuCi2+Qy8bHStsXgNCD4fYgYtYzW4kPd2Sw0HgGtonSw0Dxy/WbQ7NI0i71PFbM+U9IZ/ccSaqCjA1rAF7pHmL5PXOj3qmWJ1xDmh2RZN0iopEfQ/Vv+WrzSCzEMtbnJ60/QSdRi89CSoV2Yobl0FZ+lSepO5QZyw95yEBBRrnNFR7b2KGK8rxYj+TTa8atdcNAK5Lv3rJLXCBboiIHaBbXXdv5ywZ3hsPWHqs7LlaeRExjA2Bl9dw3czPDEtxiEeaSkDaQoR76GxVkeTJxXazUbQvjU/UinanluL304fYEvLZ7Jb3tDkZYOAEq9huxyWSeDoyydqNBcgiHiuBx0mO459xlt40kZtWYbauDsjrDEa0m2Evl11UUKansAjRrNzGy+ALmsP5GSno0DhcgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(53546011)(54906003)(6916009)(71200400001)(9686003)(2906002)(316002)(6506007)(6512007)(186003)(1076003)(26005)(8676002)(38100700002)(76116006)(66556008)(66946007)(86362001)(66446008)(66476007)(44832011)(5660300002)(8936002)(38070700005)(4326008)(508600001)(122000001)(33716001)(6486002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3ZDZ1dUd3djVDFYU0NwOC9LRWZtbjAxTkRHc25oOVl5NitMT2d4dXR1ZlJG?=
 =?utf-8?B?QW5URE12OUp6azBkc2t2SzdGQlo1UnFubVFjTW0xTWFYeEZNdDc4RG5UU2pm?=
 =?utf-8?B?b3hQdUxuYXNWN3pBRk1QQlA5eW0wQmwzd2lvdjcwVXUrbFZ2YkxOVkVQRVhl?=
 =?utf-8?B?eWpLbWU0Q3RieTJtWGNMdjVDdFhYdzhzMzVoVUQ3NTdCOHc2dzVlM25kb1NP?=
 =?utf-8?B?bGpGanJDdUFWNHQ0Tm9YMGplc3h1eml5VzJubHZOM0lvYkh2YnBvbFdIbHVm?=
 =?utf-8?B?ZjIvOW5hVTdzVjg3OHBxNWZJOXAwNFFLN0JyczlIbDFrQ084UmdMTC9qOGpH?=
 =?utf-8?B?dE9pN0VDOENuakRrZXRCcG9PTlRXcU9sQ0dlZGs1ZzJFZHZSblVtODVsVXY2?=
 =?utf-8?B?L1YzSXpyc0FBVWlhYmYySXNvQnRHLzhqMCtWS0Q1cDkybTNLYm5pS1dsd2Vh?=
 =?utf-8?B?RGhtSUp1dFhERUZkb0FZaHhWWmtHZFEyY2g5T2UrM0ZiS3FzNmZvMkIvSU5K?=
 =?utf-8?B?ck5BSEtHcXdWdmJxQm8rSjRkS2dmNU43c3RpN0hUc1dzWjlPbWxDSjVMNmF4?=
 =?utf-8?B?dmFPQTJuc0xGU05YVFM0Y1hFUkhzY0lKUmIzOE5qdG1qT3R4YVpLNHlLMW5v?=
 =?utf-8?B?MUsvdnFjOEQ5NDVSRlB5WFlmL1dVcFNoMG5MWmJMb0J4YlVHditiSjBPSll2?=
 =?utf-8?B?MWRnYmlnaG54aEM0Zko0VmRTanB4VG92by9kL2JIUmhWNGZuTk5STk5paWxx?=
 =?utf-8?B?b3N4WFNqVjI3d1U5a3VZdXRycTdDUHcxZ1J1T1JZbWVsL2s0Uyt4Smc1SjV4?=
 =?utf-8?B?ZDFkZXVPRzEwSFpEVXZZcnByOWNjQTg5TGE3T0h2bXRCU25ndUVIRnM5NTBN?=
 =?utf-8?B?TjlwaW4vTlZyVytsZjVaZ04ra2NlOHBndVRpamlZbEZVOHp4YmdZSDlpejRV?=
 =?utf-8?B?aENnbytiUFpjV0VmajRaTDFuSm5TenJCY01YY3YyQXV5Wk8vb1VyUzFQZVpp?=
 =?utf-8?B?MGFEWWpzUGMrM1B6Rk5ORkpLcVA5OENjT2ZwSmFrencrNzc3b0Y4V1M5TGtp?=
 =?utf-8?B?YnVzaUhIeGlhMHhnVGlwQXdQT25qMXdxSERQTE55UndLOS9QbHBJWm9QQTZC?=
 =?utf-8?B?USt2RHgva1hrQ29NeG9wejloRmttcjk4MWpJTnBqZ3JYaWJHN1piTmxyVC9V?=
 =?utf-8?B?U0RrUytrRG8yRmZDL1Vmb2dRQXg5K2ZidkVXVmtxMkZJd2J4TWp3eG5FQWpy?=
 =?utf-8?B?S05RS1phTVE3S3hxRk5iL1JOUjNhZDNSWWJYUUJ6Q0k3QW1CNVkrQzBSd1Fj?=
 =?utf-8?B?bDFDOVozMGhCWU11WDlJeGFiamxKN2lrNVRFcitROW0rczE4UXozMU00eFZl?=
 =?utf-8?B?RHBhendhTzBaTFpWNWF2QlFFd2NTWUNSOC9UM2dwMzJUcmlGMWloTjZGbFdw?=
 =?utf-8?B?TnZhOEJVTHhHR1BhZ2wwbGsvUjBSZGR2cVFPYkZ2ZDNsZTQzTUROYk1zTC9F?=
 =?utf-8?B?UnFuUnhpZHVxZDVDRTJnei92aVR3bGMyMHFnUDNOYmNiM3NCYnRRMnJIWnZp?=
 =?utf-8?B?MXplcU80Umw4WmREOC8xZnRKM2xwaG5xOGlrMWo4THlhaXFqdHlNNC9oNmNu?=
 =?utf-8?B?MFJHRmZkbmRWUXp3a2duQW9SWVJtM0VOR3orTEN0TWw0Y2pvL2txaDNxL2dN?=
 =?utf-8?B?NTE5TmZNVmUwVDFWM0xYNFVZQ3ZEMXhDWjBuN3RaVVZITzV5aEc4ZnI1SXUw?=
 =?utf-8?B?RjRqbmJqS1RMODQ1YnFBT3dHSTBUM2tZTStCSDF0ZWpCTGorTkdYWTA3TGlQ?=
 =?utf-8?B?U2ZOd0Z1RHExblU3R1Rtc1lUbXFKMlF5cWRETk56K0wrNExQeDB0UHdjZWs4?=
 =?utf-8?B?QmRHZGlXS2Rzd3UvVEkwVWNLYzI3TmdUMVZUTjBLa0lvZEVnUklMMUUydkhm?=
 =?utf-8?B?bkxscTNsWHIvakk3UU9seW5MNmdPMUR6Y2hmcThnZ3Bjbks5eWtvWWZGRUZH?=
 =?utf-8?B?TWlZMjRBSC93PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7579514A6D1044ABC48F9C245733751@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 003f9663-1042-4369-299f-08da05d9a5b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 16:42:37.1655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mjDNNJMYrfSmwPu1xuEdLwe+TTjntMgmklcIaAQzmvxhIpTA3fuJu96RKXXKb+gNuyu2rnXCmW0RDh4RXONktQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4624
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBNYXIgMTQsIDIwMjIgYXQgMDU6MzQ6MzNQTSArMDEwMCwgTWFyZWsgQmVow7puIHdy
b3RlOg0KPiBPbiBNb24sIDE0IE1hciAyMDIyIDE2OjE3OjA2ICswMDAwDQo+IFZsYWRpbWlyIE9s
dGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBNb24sIE1h
ciAxNCwgMjAyMiBhdCAwNTowNToyOVBNICswMTAwLCBNYXJlayBCZWjDum4gd3JvdGU6DQo+ID4g
PiBPbiBNb24sIDE0IE1hciAyMDIyIDE2OjQ4OjQ3ICswMTAwDQo+ID4gPiBUb2JpYXMgV2FsZGVr
cmFueiA8dG9iaWFzQHdhbGRla3JhbnouY29tPiB3cm90ZToNCj4gPiA+ICAgDQo+ID4gPiA+IE9u
IE1vbiwgTWFyIDE0LCAyMDIyIGF0IDE2OjM0LCBNYXJlayBCZWjDum4gPGthYmVsQGtlcm5lbC5v
cmc+IHdyb3RlOiAgDQo+ID4gPiA+ID4gRml4IGEgZGF0YSBzdHJ1Y3R1cmUgYnJlYWtpbmcgLyBO
VUxMLXBvaW50ZXIgZGVyZWZlcmVuY2UgaW4NCj4gPiA+ID4gPiBkc2Ffc3dpdGNoX2JyaWRnZV9s
ZWF2ZSgpLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gV2hlbiBhIERTQSBwb3J0IGxlYXZlcyBhIGJy
aWRnZSwgZHNhX3N3aXRjaF9icmlkZ2VfbGVhdmUoKSBpcyBjYWxsZWQgYnkNCj4gPiA+ID4gPiBu
b3RpZmllciBmb3IgZXZlcnkgRFNBIHN3aXRjaCB0aGF0IGNvbnRhaW5zIHBvcnRzIHRoYXQgYXJl
IGluIHRoZQ0KPiA+ID4gPiA+IGJyaWRnZS4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEJ1dCB0aGUg
cGFydCBvZiB0aGUgY29kZSB0aGF0IHVuc2V0cyB2bGFuX2ZpbHRlcmluZyBleHBlY3RzIHRoYXQg
dGhlIGRzDQo+ID4gPiA+ID4gYXJndW1lbnQgcmVmZXJzIHRvIHRoZSBzYW1lIHN3aXRjaCB0aGF0
IGNvbnRhaW5zIHRoZSBsZWF2aW5nIHBvcnQuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUaGlzIGxl
YWRzIHRvIHZhcmlvdXMgcHJvYmxlbXMsIGluY2x1ZGluZyBhIE5VTEwgcG9pbnRlciBkZXJlZmVy
ZW5jZSwNCj4gPiA+ID4gPiB3aGljaCB3YXMgb2JzZXJ2ZWQgb24gVHVycmlzIE1PWCB3aXRoIDIg
c3dpdGNoZXMgKG9uZSB3aXRoIDggdXNlciBwb3J0cw0KPiA+ID4gPiA+IGFuZCBhbm90aGVyIHdp
dGggNCB1c2VyIHBvcnRzKS4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFRodXMgd2UgbmVlZCB0byBt
b3ZlIHRoZSB2bGFuX2ZpbHRlcmluZyBjaGFuZ2UgY29kZSB0byB0aGUgbm9uLWNyb3NzY2hpcA0K
PiA+ID4gPiA+IGJyYW5jaC4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEZpeGVzOiBkMzcxYjdjOTJk
MTkwICgibmV0OiBkc2E6IFVuc2V0IHZsYW5fZmlsdGVyaW5nIHdoZW4gcG9ydHMgbGVhdmUgdGhl
IGJyaWRnZSIpDQo+ID4gPiA+ID4gUmVwb3J0ZWQtYnk6IEphbiBCxJt0w61rIDxoYWdyaWRAc3Zp
bmUudXM+DQo+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogTWFyZWsgQmVow7puIDxrYWJlbEBrZXJu
ZWwub3JnPg0KPiA+ID4gPiA+IC0tLSAgICANCj4gPiA+ID4gDQo+ID4gPiA+IEhpIE1hcmVrLA0K
PiA+ID4gPiANCj4gPiA+ID4gSSByYW4gaW50byB0aGUgc2FtZSBpc3N1ZSBhIHdoaWxlIGJhY2sg
YW5kIGZpeGVkIGl0IChvciBhdCBsZWFzdCB0aG91Z2h0DQo+ID4gPiA+IEkgZGlkKSBpbiAxMDhk
Yzg3NDFjMjAuIEhhcyB0aGF0IGJlZW4gYXBwbGllZCB0byB5b3VyIHRyZWU/IE1heWJlIEkNCj4g
PiA+ID4gbWlzc2VkIHNvbWUgdGFnIHRoYXQgY2F1c2VkIGl0IHRvIG5vdCBiZSBiYWNrLXBvcnRl
ZD8gIA0KPiA+ID4gDQo+ID4gPiBJdCB3YXNuJ3QgYXBwbGllZCBiZWNhdXNlIEkgd2FzIHdvcmtp
bmcgd2l0aCBuZXQsIG5vdCBuZXQtbmV4dC4NCj4gPiA+IA0KPiA+ID4gVmVyeSB3ZWxsLiBXZSB3
aWxsIG5lZWQgdG8gZ2V0IHRoaXMgYmFja3BvcnRlZCB0byBzdGFibGUsIHRob3VnaC4NCj4gPiA+
IA0KPiA+ID4gTWFyZWsgIA0KPiA+IA0KPiA+IFdobyBjYW4gc2VuZCBUb2JpYXMncyAyIHBhdGNo
ZXMgdG8gbGludXgtc3RhYmxlIGJyYW5jaGVzIGZvciA1LjQgYW5kIGhpZ2hlcj8NCj4gDQo+IEkg
Y2FuLCBidXQgSSB0aG91Z2h0IGl0IHNob3VsZCBvbmx5IGJlIGRvbmUgYWZ0ZXIgaXQgZ2V0cyBt
ZXJnZWQgdG8NCj4gTGludXMnIG1hc3Rlci4NCg0KQWgsIG5vdyBJIHJlLXJlYWQgVG9iaWFzJyBk
aXNjdXNzaW9uIHdpdGggSmFrdWIgZnJvbSB0aGUgY292ZXIgbGV0dGVyLg0KSSd2ZSBuZXZlciBz
ZWVuIHRoYXQgcHJvY2VkdXJlIGluIGFjdGlvbiwgdG8gYmUgaG9uZXN0LCBsZXQncyBzZWUgaG93
IGl0IGdvZXMu
