Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E35E420F37
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 15:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbhJDNcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 09:32:17 -0400
Received: from mail-eopbgr1400122.outbound.protection.outlook.com ([40.107.140.122]:35040
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237444AbhJDNaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 09:30:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6FPNkyJKH3JCjlaHUhxI7SVUoDw+rw1xOMWscb+wPoQK6GErWsLQfk1QE5YOWEd3tAkF9mT0r1sYO7thh+oRtGARCYQ0nCkRl7PqntCFh6qTN7WwXCHdPu5UhEaLHMx1ThjYne6PeSMZKxEYyEyguu9GoQnZco23AqPOT6spUgaFXlra6LPnXjrdHMKUrZmDx7yQRYDyI3A0ypgR00AvntglWz+cSR82HE1eRTNa+2zIgdVvIFgrEHsGuAEMlK+v9lzK8l8NG1/wlCqxYs7jLq2dChywOOfjL29S+IWImNDkYYLPfnKlG70/nSPqHLLYaorF+rmc3NxwwZu77ZohQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B7Vy4b/YSMrKynVbVatuMeVRzhJH6iUf8ARMhEAWjlc=;
 b=PER31+HzPAbiZTa9Vhkg9c82mzb0DMrMLB5gyurCSubJ4iIccEgQVEE/VUWPKhzviNTyMwhpOirLyyfN/N2O5MJhWDf6oyzRcXRPQ0dEInAFRU28NVpRETbiAK9ClTmODbFaELhlfDf3W/NuMg0X/rTT9+GeKhAcFa91qTNK/EKq1sz6OcCLVSE8Ef1wqfAi3ByFtHgc2v6ayDEAFvWwkvZuWB2y7pcKFpf6ffHxZev0G8dqHelKsv40bcskv9Jk379bd5H3SV5vldo6rmiKv0AWUSPkP5e5TxIghcFd2OYfh13EmFOUz2kIzYltulzra6VpfwVrar596FM418z4PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7Vy4b/YSMrKynVbVatuMeVRzhJH6iUf8ARMhEAWjlc=;
 b=jR/DH2cbWZ7jNR9o4zAgXXSH2Dj+hNxXr5iZNX+tOArr6ZEClkduLm7HFnf4QHbPR+mMvY9lxVCthBNR7U4eFPbmiXgVXNW2h7YqSl0j9jqawFlARRy9pqJVKJ4z3bYQ/iMm6VYDTl4CYkUWdfdfOlLtX0CRuW3HVO7HBtlwtZw=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5877.jpnprd01.prod.outlook.com (2603:1096:604:c0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Mon, 4 Oct
 2021 13:28:29 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 13:28:29 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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
Subject: RE: [PATCH 04/10] ravb: Add support for RZ/G2L SoC
Thread-Topic: [PATCH 04/10] ravb: Add support for RZ/G2L SoC
Thread-Index: AQHXttX7hUtu3PiXEk+gzpGHHZtaNqvAHb6AgAC5mMCAAgI9wA==
Date:   Mon, 4 Oct 2021 13:28:29 +0000
Message-ID: <OS0PR01MB5922E8774B029991E42B057486AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-5-biju.das.jz@bp.renesas.com>
 <b4c87a6d-014f-0170-feb5-20079c7d5761@omp.ru>
 <OS0PR01MB59224497C081231E9CC334B986AD9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB59224497C081231E9CC334B986AD9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f526e70-e9bb-4f77-1fb0-08d9873adad5
x-ms-traffictypediagnostic: OS3PR01MB5877:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB58777ABF2B7B381A230FCA8986AE9@OS3PR01MB5877.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SfyAXe4gbKw25h84Yon7MjITeMFPltyMTt7SB5VxUsMH7MstRZPmp/kcGDds5N57V7egMNwLFZRSOoG+7bCpi02u+S5FiPVVID8gqwHqfoRCtCLg12YilKhoA6aQ++xrehF+tCzAB9X0wUnIjLJCvcscvA7PU1f/gpLbJYQD/5700fdgduVoQMILMvMCfORr609s9IXnCUPkJh9GQ5rCrZUs3QXjaC0bGgK6H2ZdfzeONvAjtJ+mp5hccRXV0evbnM94agXp2evLFzd5u2zQ5Q+n3g5Ex0usr1TcGHD2zM6P369PGLZ8ht7Rl0vMZ/OeKk39WVe540Tx9PbGwd79hFBhh2pEObhRlkIO0gtXn86nH17EZvU++dr2THSQWdguumzKQFHNdAFmghQZw4Jvm1YJOiMgn8x/R7Bb8cu0Q3+woyZQ8ciQO9jUyI+AblLLwfoTXk0OaLePhvHcF//74ox3xzLtXjziMdMN128j4tnS+8KfV+yxbCYtoUr9eGGVCIhXpLcsfXnxHIaQ7KzBPN+J0dHx0zbh3fT0nW1IGYoVc+cDFrsVbXmPWflVGtIo33D37UCDHGMecdLJgu35h17KUvBmjxQ53oue0oC9DLuK9oC3oEqp27Yam9HyW7YC6L6fSWb0WlRnl1/A45m5C35UQ7pIK8Gmo/ukZOERVGuTwNFnEan221XJ0drY3Vn7k36d+HDrZ8QALDtKFrjLIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(110136005)(7696005)(508600001)(5660300002)(8676002)(7416002)(54906003)(83380400001)(53546011)(26005)(6506007)(2906002)(52536014)(186003)(71200400001)(33656002)(55016002)(9686003)(76116006)(66556008)(66476007)(122000001)(66946007)(86362001)(316002)(64756008)(38100700002)(107886003)(66446008)(4326008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wm8xUG8rSmZ3VEp1ZU9qVjRTZ3pyaThSeVVMd2NzZE5wK2s2ZDhDWVdVNEo2?=
 =?utf-8?B?bFNKeU9JZWpPVVZjVDhUOUpaS0VTVThlK3VLbzgxbjlqdGFOVUJVMnVDNExl?=
 =?utf-8?B?OWN3NzFqaVpmdmhGWVZUb29MNksyZDVETFdHU1JSQUdHQmV0emg5Z29mWVZh?=
 =?utf-8?B?eUt0SVJLQ29VSHloWHRqWTdIelNrellqYnc1MHE4R052RXFrWVRHUkc5Zm93?=
 =?utf-8?B?cjdoREJDZEw2Y3VwNkM1MGRJTzNBeU1kWVVxYWs3eTVRT1hyYlU1cEZvK3hX?=
 =?utf-8?B?ckVFKzZxS0NHWmNIazFyWE1lTjJDUFlpdTZOZEpYS2NRMWtkN0tDSHgwZUEz?=
 =?utf-8?B?Q0JxVDN2MW83elZ5eWlnait0QWtPeGJDTG4veGhyMUJ6WnZqa3BBRllvS1NV?=
 =?utf-8?B?RXoxTVlHSm1keXc4QWZNSHovUDJTTUdGR016NWRGbG5qTy92b2lIb2ViSGVU?=
 =?utf-8?B?UFBweEFjdzRpRFFvbCsxd2Q0c1k5UXRvclJ6ZHhmaFBpU2MzTlFicEQrdmhp?=
 =?utf-8?B?RHhVMXVsdnFzMG83RTIzcFV4dVhOdzFrT0QxelVmNmlQb1p3NGNPRGRnSG5w?=
 =?utf-8?B?NmlPblRndzU4MGNBVDJqdjM5RnNrczZCY2ZYbjVwVDFYQUlRQ21MVENta1FL?=
 =?utf-8?B?SHlEZXVuWVRQbkhJclZZVkR2Y1RRcVc5R255NjMyVGFlZytPODFhNk5QbUQw?=
 =?utf-8?B?SE16Q3BDS01tY1pUbmZWdWdLK09taGF3bmQ1b1h5SlRxNytGSHN0eGkxcGFY?=
 =?utf-8?B?UTdHb250UDljZ2tOS2tnSE1odFhrU1hMOHJoNExPcHY2NVZKMlMxQXRldXpx?=
 =?utf-8?B?emhoQnp6MlUrNVJxSFR3bm5hc1Y4ejlIL2dNczV2QjB4NFY0YnYxanpydVZR?=
 =?utf-8?B?NWdiOGRrUyt0dFkzNDZtbmRjejlBQ2w3MXVXSlBDdnFreHl0dTJyS2UyeUJI?=
 =?utf-8?B?QlRUU3drKzU0TDFyKzF6Q1dJSXJKTC8yTHhoc25KWkJ1d2liSC9NUjh0Zko0?=
 =?utf-8?B?d1ppMUxqUnR4V3N2WVRFbjhuOG9Za0IzUDhqQWVDY0lzZ1dzcXR0QmZYV3Ba?=
 =?utf-8?B?emE3aExkTUtPQmkxdnB2ODhaVkZxczdRaHM1UWdZSzRGM1ZZNGFnZS9IR2FF?=
 =?utf-8?B?WFhxVUJxb0tMb2tHd0lsbG1DWDNyN2FOOFdsVDVVNHZBMmJpZ3A5dCtOZGRW?=
 =?utf-8?B?V3pucWJXS0tObDFSMWVLNGFuQXRJRENndmtwTnlHUWhmZjNVeExManVQT3pM?=
 =?utf-8?B?cFhVNk5vWVJRK0tLNXJmeE1Cc3VtaWNQMFRVZFJnbVRvVkRaMG1UMWlIV21T?=
 =?utf-8?B?Kzg5NzN1QWg1S1hTTlI5SzIzWnh0bnhsTlNkbVc3cWgwYjJSdWNXWlB0aktR?=
 =?utf-8?B?a2tybjhRRGExVUFXYmh3QzVLQlgvTVZxcmVCbjNWSkx1RVpHUGt2K2xpQ0pU?=
 =?utf-8?B?YVlnQzRSekRRT2I5d3ZWaUFiMjlLclgwV0ZLalBvOWd3dzhtbGFXbTVxMHJr?=
 =?utf-8?B?VlFmMUwxbmlxU1pGYUVYWGtXeTRlYVZqbjRqNHZtOVI1c3B0R0xtdjRLMGdv?=
 =?utf-8?B?aEFKZ0JKOEVUVVJ0N1FHOVBobzVMSmV3VlJLSTRNS3VIYmtac2VEd2dDSHll?=
 =?utf-8?B?SGRIbUQrbXRHenFiNXAxMWEzY2dGdHNOaG1GdnhVR2hwOGVwVEtJT3RMZysx?=
 =?utf-8?B?MU81NVMzSVdTY1d6ZHg0RUV5NnpYcTNBQUlZM0I1Z21EUHcyaG5WN2RUT2RW?=
 =?utf-8?Q?4R+235ZI3UbHZHJGns=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f526e70-e9bb-4f77-1fb0-08d9873adad5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 13:28:29.7246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eMPaorpSQcHz+toCmZ8dFV3nE5Yfrbj/Hqob+e34TRqpBhNiCu6xNmBf0D1xvwdKecec/emmjBL+iav+92WLWYzu4a6MQ13+Qwfa3cMcSAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5877
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggMDQvMTBdIHJhdmI6IEFkZCBzdXBw
b3J0IGZvciBSWi9HMkwgU29DDQo+IA0KPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMDQvMTBdIHJh
dmI6IEFkZCBzdXBwb3J0IGZvciBSWi9HMkwgU29DDQo+ID4NCj4gPiBPbiAxMC8xLzIxIDY6MDYg
UE0sIEJpanUgRGFzIHdyb3RlOg0KPiA+DQo+ID4gPiBSWi9HMkwgU29DIGhhcyBHaWdhYml0IEV0
aGVybmV0IElQIGNvbnNpc3Rpbmcgb2YgRXRoZXJuZXQgY29udHJvbGxlcg0KPiA+ID4gKEUtTUFD
KSwgSW50ZXJuYWwgVENQL0lQIE9mZmxvYWQgRW5naW5lIChUT0UpIGFuZCBEZWRpY2F0ZWQgRGly
ZWN0DQo+ID4gPiBtZW1vcnkgYWNjZXNzIGNvbnRyb2xsZXIgKERNQUMpLg0KPiA+ID4NCj4gPiA+
IFRoaXMgcGF0Y2ggYWRkcyBjb21wYXRpYmxlIHN0cmluZyBmb3IgUlovRzJMIGFuZCBmaWxscyB1
cCB0aGUNCj4gPiA+IHJhdmJfaHdfaW5mbyBzdHJ1Y3QuIEZ1bmN0aW9uIHN0dWJzIGFyZSBhZGRl
ZCB3aGljaCB3aWxsIGJlIHVzZWQgYnkNCj4gPiA+IGdiZXRoX2h3X2luZm8gYW5kIHdpbGwgYmUg
ZmlsbGVkIGluY3JlbWVudGFsbHkuDQo+ID4NCj4gPiAgICBJJ3ZlIGFsd2F5cyBiZWVuIGFnYWlu
c3QgdGhpcyBwYXRjaCAtLSB3ZSBnZXQgYSBzdXBwb3J0IGZvciB0aGUNCj4gPiBHYkV0aGVyIHdo
aWhjIGRvZXNuJ3Qgd29yayBhZnRlciB0aGlzIHBhdGNoLiBJIGJlbGlldmUgd2Ugc2hvdWxkIGhh
dmUNCj4gPiB0aGUgR2JFdGhlciBzdXBwb3J0IGluIHRoZSBsYXN0IHBhdGNoLiBvZiB0aGUgb3Zl
cmFsbCBzZXJpZXMuDQo+IA0KPiANCj4gVGhpcyBpcyB0aGUgY29tbW9uIHByYWN0aWNlLiBXZSB1
c2UgYnJpY2tzIHRvIGJ1aWxkIGEgd2FsbC4gVGhlIGZ1bmN0aW9uDQo+IHN0dWJzIGFyZSBqdXN0
IEJyaWNrcy4NCj4gDQo+IEFmdGVyIGZpbGxpbmcgc3R1YnMsIHdlIHdpbGwgYWRkIFNvQyBkdCBh
bmQgYm9hcmQgRFQsIGFmdGVyIHRoYXQgb25lIHdpbGwNCj4gZ2V0IEdCc3VwcG9ydCBvbiBSWi9H
MkwgcGxhdGZvcm0uDQo+IA0KPiBSZWdhcmRzLA0KPiBCaWp1DQo+IA0KPiA+DQo+ID4gPiBTaWdu
ZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gPiBS
ZXZpZXdlZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJl
bmVzYXMuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiBSRkMtPnYxOg0KPiA+ID4gICogQWRkZWQgY29t
cGF0aWJsZSBzdHJpbmcgZm9yIFJaL0cyTC4NCj4gPiA+ICAqIEFkZGVkIGZlYXR1cmUgYml0cyBt
YXhfcnhfbGVuLCBhbGlnbmVkX3R4IGFuZCB0eF9jb3VudGVycyBmb3INCj4gUlovRzJMLg0KPiA+
ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmggICAgICB8
ICAyICsNCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwg
NjINCj4gPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ID4gIDIgZmlsZXMgY2hhbmdl
ZCwgNjQgaW5zZXJ0aW9ucygrKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmIuaA0KPiA+ID4gaW5kZXggYzkxZTkzZTU1OTBmLi5mNjM5OGZkY2VhZDIgMTAw
NjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBbLi4uXQ0K
PiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMNCj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+
ID4gaW5kZXggOGJmMTM1ODZlOTBhLi5kYzgxN2I0ZDk1YTEgMTAwNjQ0DQo+ID4gPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gWy4uLl0NCj4gPiA+IEBA
IC0yMDczLDEyICsyMTIwLDI3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcmF2Yl9od19pbmZvDQo+
ID4gcmF2Yl9nZW4yX2h3X2luZm8gPSB7DQo+ID4gPiAgCS5uY19xdWV1ZSA9IDEsDQo+ID4gPiAg
fTsNCj4gPiA+DQo+ID4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCByYXZiX2h3X2luZm8gZ2JldGhf
aHdfaW5mbyA9IHsNCj4gPiA+ICsJLnJ4X3JpbmdfZnJlZSA9IHJhdmJfcnhfcmluZ19mcmVlX2di
ZXRoLA0KPiA+ID4gKwkucnhfcmluZ19mb3JtYXQgPSByYXZiX3J4X3JpbmdfZm9ybWF0X2diZXRo
LA0KPiA+ID4gKwkuYWxsb2NfcnhfZGVzYyA9IHJhdmJfYWxsb2NfcnhfZGVzY19nYmV0aCwNCj4g
PiA+ICsJLnJlY2VpdmUgPSByYXZiX3J4X2diZXRoLA0KPiA+ID4gKwkuc2V0X3JhdGUgPSByYXZi
X3NldF9yYXRlX2diZXRoLA0KPiA+ID4gKwkuc2V0X2ZlYXR1cmUgPSByYXZiX3NldF9mZWF0dXJl
c19nYmV0aCwNCj4gPiA+ICsJLmRtYWNfaW5pdCA9IHJhdmJfZG1hY19pbml0X2diZXRoLA0KPiA+
ID4gKwkuZW1hY19pbml0ID0gcmF2Yl9lbWFjX2luaXRfZ2JldGgsDQo+ID4gPiArCS5tYXhfcnhf
bGVuID0gR0JFVEhfUlhfQlVGRl9NQVggKyBSQVZCX0FMSUdOIC0gMSwNCj4gPg0KPiA+ICAgIEFM
SUdOKEdCRVRIX1JYX0JVRkZfTUFYLCBSQVZCX0FMSUdOKT8NCg0KV2lsbCBzZW5kIHRoaXMgY2hh
bmdlIGFzIFJGQy4NCg0KUmVnYXJkcywNCkJpanUNCg0KPiA+DQo+ID4gPiArCS5hbGlnbmVkX3R4
ID0gMSwNCj4gPiA+ICsJLnR4X2NvdW50ZXJzID0gMSwNCj4gPiA+ICt9Ow0KPiA+ID4gKw0KPiA+
DQo+ID4gWy4uLl0NCj4gPg0KPiA+IE1CUi4gU2VyZ2V5DQo=
