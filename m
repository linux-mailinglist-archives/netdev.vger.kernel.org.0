Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABCE3EF03A
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhHQQeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 12:34:12 -0400
Received: from mail-eopbgr1400094.outbound.protection.outlook.com ([40.107.140.94]:53696
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230261AbhHQQeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 12:34:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ii0tAOO9fw8ZukM+Q23Gg1q9i0ajQuenCUvjU6tZ4t/H3qrQdy3AGWVwL6FHTfD+IeghZkhq4xRATYAf7IbquzPKWWL5vDLsAcZIHcsDUb/jX1RZSn01neJZ/8fSneiQCKQYpzWylMmMnjciwfZ6CRzbksicxMEouJkyKo0fa1cnxXxKlwPiy0bJ94lz0vLV2HnF+FZw8XFtFIP+WVS4tEifFDrxnRuzKMkpB0awZlNlzhUtYS7L+94QGG8phVHYcXgizS061GUWp8sicjNVjmODWKZeTWiiCs7V60WsGGrsihMoylcj70hJwxHs91r7VKiuHCMUkH23w3Z5EIPctQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rttt1BHNB/WFuodPOHQr2+Kxn36Bgrsp9ItJtO40yI8=;
 b=gqDOZ6m6dtamGUfvR+vFDm+myHYscbzmkVXuPmnz4D40woxLYM4YzuQbBGKHi8FODuA+MVEVNZQ3MwcEcRvTkYryAqF0VV1QX6wcAu/OnyQow6wlZkR6WnfZLPWjgY8jN4xckbWoEh3sW9wz5PoTMngli7WiPfaJAPSmf6Mode06q/7IyQVZVc3QwPVKN2LF8JcPV7k81sTy1Wo8odEM7scvViWB8iBxzuo2/50ceCdDDr3ihbWgAOjtNLGMMFdkbkygopYW7ecNXLQoBW+gl9g2WpFWkuT0y8PMBvSBZUMuFEaQFgF/ATZycz4jiBqrTvwvygH+Iv4cZ10kILGBpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rttt1BHNB/WFuodPOHQr2+Kxn36Bgrsp9ItJtO40yI8=;
 b=nRv3+X9nFTFPqHtOa0QMKXWsXXvC8milmWNL83Ok/BZFlnx6Bf2TAgy4ocDB/rqsU8V2eZ93G8pmv4lM1ifnhoz/Ssu/C2jsQQOR9kAyHC6iU/yqSSmMujMNXAwEe6Njiuf2+bsPSwMpg2PmPzu0spKcPiP+53bSXQ69c2SF2JQ=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB5223.jpnprd01.prod.outlook.com (2603:1096:604:7f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Tue, 17 Aug
 2021 16:33:35 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 16:33:35 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
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
Subject: RE: [PATCH net-next v2 8/8] ravb: Add tx_drop_cntrs to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next v2 8/8] ravb: Add tx_drop_cntrs to struct
 ravb_hw_info
Thread-Index: AQHXh4kMhjmmRbUodUeqNfnthDyvtKtj1bOAgBQYucCAAAzvgIAAAIxA
Date:   Tue, 17 Aug 2021 16:33:35 +0000
Message-ID: <OS0PR01MB59225B9B11F3F7964800B68B86FE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-9-biju.das.jz@bp.renesas.com>
 <24d63e2c-8f3b-9f75-a917-e7dc79085c84@gmail.com>
 <OS0PR01MB59220310BBD822BB863F642786FE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <9b09e2ba-4e92-6e1e-e26b-c2a3152f7fe4@omp.ru>
In-Reply-To: <9b09e2ba-4e92-6e1e-e26b-c2a3152f7fe4@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb955c62-ef82-47d7-256a-08d9619cc279
x-ms-traffictypediagnostic: OSBPR01MB5223:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB5223539749ABD7D02B00C77B86FE9@OSBPR01MB5223.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GRM7uUqmuuUJPDFT73K8GzL7ODjxSzyv6AbCojaBIv/G7aXM6X8ehYiPfEhig2Zo+BZNoY83qbF4vP67cXoT/9NBX2EZ1+vFOcyC4gyGDW8nMvnD/TQDYu7mymi06amgbBy2psQvTVqjowRNFVl+Hy8gtARyQApCqKJnwoWGOClms8TxSMHe6funEqCu/1wNlOCFZy822tO5Ys7vHkOgD6Xf3hzt2mB7B7b8b2xbtHpXCvm/F5A4dy2OZChmWe3qvVfOEpxQZYo7Rn8gY5J98uSKTfDGzfDyDiRs7RL6BmBfx2mYQJFaXo5NN4ig4p1BI7USi/H6u4jqMBMAN7etIr2mUTra8HHiI4n22Q1Qv7ITGvrdN+o4pnqJqt9b2jQSEOHkxrrjE5W+HQAuX3Yu5I7PwO4kFRLwJL9ddpkJMB76qHdEkvETdzFmXH+m0ict8Hncoy2OhFMJjwE4tq8oWxB6jyIFbiF/0EXL7Z07auvBFo/L6Kp2yjUKZ5nAKun/BEtWj3dOGIXYxSnq4OZRlThmMdNdfnH7P2jLXY6WtE1vtGDvzRsDkHc4a9kJEs2FxvqFjj0520JHxar1jwYXCHekFcfp/Uhi2vtY7ypKzIi5mWx330k5ksLFGLRyAUJdkOlNbxQbSL5TZWBQUD3ckmO8L99f6pgScdLc3PcSpQOsa8j4VBjfrgaJ8/cf11O8DrBfiwiQLWIPtpoMbDeDfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(366004)(346002)(376002)(66446008)(107886003)(64756008)(38100700002)(66556008)(122000001)(4326008)(66946007)(6506007)(76116006)(54906003)(8936002)(2906002)(7696005)(66476007)(8676002)(33656002)(26005)(7416002)(316002)(9686003)(38070700005)(83380400001)(478600001)(110136005)(186003)(71200400001)(5660300002)(86362001)(52536014)(55016002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzRGWHVuaXRGU3pRRHBqbVZ4WVNFSFpqVWVyL2FPRTFtVWhMUmpaZGNTU0cy?=
 =?utf-8?B?eThSSnJDN1gvUXpmbDl0QS96VnJCQUVDTUtQVGQ5ZmNzWFJDNVo3QkNtNGNn?=
 =?utf-8?B?WVBhN2xNVFpZRm5XbVltcUU0OTJ2MVV6ZVZFa3NrQ09WUkpVYVoxaWx1YkxY?=
 =?utf-8?B?VkdDYkJyUlNxc29hTWdNYmNxZnNXNGwweTl3Zmc4QklsSVY5aHIvTWVZUTc0?=
 =?utf-8?B?T3N1cUtacTl0ZlZLUTMxUmpZRGFaYmpHVSs0cDM1Z09hTHhsNnpzZjdTK1BD?=
 =?utf-8?B?cDVCQzBsQ2RmTEREQmJ2NVhBLysrb1dmNW9EZTM5ODF4YUtKNVJtSmtnRXB3?=
 =?utf-8?B?VTR5aTBLV21zTnlSVGJTTmlkY2VudkZrM2VEQW9BZDR3UldUbm5yblNFRnE0?=
 =?utf-8?B?RXcyQVUyeEtMZVRzbkg0SEtrYXZmMFc3cDk2b1VIZkN3S1lxSzkyZ2dWczlz?=
 =?utf-8?B?Vk8zTTRWR2Y5QlhNRzhiSW1mSm41N0VvUklxa2FIczVjR1kwME9KTlFJOW1o?=
 =?utf-8?B?TGtTVzlnWk10SHdqckJQL2lzaVRHWCs3YS9ZOGRrWjZHL25VRzBvMzl2RXVa?=
 =?utf-8?B?aEx5Z2NzZ05yVDhDMUxiMFpSbTlDL3cyaTFoNW1aQks1ZndWU3l5T0hwLzdt?=
 =?utf-8?B?S0V6cXUxUFpINGJFZEpwbW9zTWwwUnY3alZaeGtvaWJNcUNybnljVGlsQzc0?=
 =?utf-8?B?M1N0S2g3anVscjZsRnVVZll3NjkzUDAzZG5nOUNKMGhpemhpTXdjOGU3RXVu?=
 =?utf-8?B?Z0tHeS93MlhuZytYYzFDZFJDdklCckZQbVYxYlhjOFlTQmw3eGw5Q0l4SnJ2?=
 =?utf-8?B?SDMvTmdzMncraHB0c0ozWjJDeXEwczFVb1FvRWVaUXJnWU9uTlhVN0ExM01z?=
 =?utf-8?B?Skx1aVg3NWQ4eG4vQ2J2cVk3VytZbis2d3kvR3J1cU5qSDV3R0pqZXl6STh0?=
 =?utf-8?B?UjVML3JLci9MTjZicEE0QWpHNE94T0pKVUhFUVhrVmI3YVQ5bzRTLzFTQTE1?=
 =?utf-8?B?UHhIaWo1T0xwRzFuQmx5a0hGTnR6Q1pVMmVaYmJIaHZNcUxsRE5jR0lrYkw3?=
 =?utf-8?B?cWdxZm5Yd2hKaWNGalhJTEFyVDBRSmhKSlFXanVFOTZhMjRsQzZEcjMyQjRC?=
 =?utf-8?B?VlB3Z2ZqSU91U1NIQmZ1KzNmWmxNdVlEMDFoWTBER1Z3aGx2TGgveEgrTmts?=
 =?utf-8?B?aEgrNnYyWWw5RDcrNlhaV0h5NU40UGtMQm9pUmM5aU1KN1dRRzVDZ2p6dGpv?=
 =?utf-8?B?V1FFbm43SVpWWjhCZysxOFpoYVhieUFmazNjd1FKellQWENTTjJNWTViM2dy?=
 =?utf-8?B?ekhNY3FHSFBjdG9JTGg2Yjg1VnZ2NTZVdnE3VnY3eGFyZU1FUWZ2RUNVckV2?=
 =?utf-8?B?ckNPMFRMN1dLdnQ3eWxzTmZOWGNjYVlyLzdsTml3VE92L2hDYmp5bkFJRTBs?=
 =?utf-8?B?MVd2VytIbWtqckJkbU15cEZqWGFoTmsyQnhPeDhKdzJpRzBEejhwaTVyMllV?=
 =?utf-8?B?Mm5SWjFEbFJoV1hqaEZPUzlYYm44RVJtanBEd09iSndKQWVsSk1DUzdFUmxL?=
 =?utf-8?B?Rjd1QTNhK2xJdEJDK3RTSjUrOXNMNUFRRWE2M1JaSFFTNE1DdkdaYVZIci9N?=
 =?utf-8?B?QkJQTlJXYjdrV1dzRi9EZ1BmbHA5dTJFZ05mcU1hQ0pjNkJSNE1NWThzRDd1?=
 =?utf-8?B?OE0rN2xrWnJvUSsxbmE5bC96c002TkVsdTAwRWgxNm1KV0wyLzArc3hJeEtj?=
 =?utf-8?Q?wdho8fLUaIhCIA2/vBcZ3wjoHRPGlOMhuCk2OfV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb955c62-ef82-47d7-256a-08d9619cc279
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 16:33:35.3524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HUZVpWGF6US4qRkSs1MldgdhD4YU+uKSmgaxTDnIlFiDViOKfpCGsVnWestGALZhiBotiobbEQLrUuEO8V3hG+O3AHwTazSIBD4xRa+mt0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB5223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjIgOC84XSByYXZi
OiBBZGQgdHhfZHJvcF9jbnRycyB0byBzdHJ1Y3QNCj4gcmF2Yl9od19pbmZvDQo+IA0KPiBIZWxs
byENCj4gDQo+IE9uIDgvMTcvMjEgNjo0NyBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiBbLi4u
XQ0KPiA+Pj4gVGhlIHJlZ2lzdGVyIGZvciByZXRyaWV2aW5nIFRYIGRyb3AgY291bnRlcnMgaXMg
cHJlc2VudCBvbmx5IG9uDQo+ID4+PiBSLUNhcg0KPiA+Pj4gR2VuMyBhbmQgUlovRzJMOyBpdCBp
cyBub3QgcHJlc2VudCBvbiBSLUNhciBHZW4yLg0KPiA+Pj4NCj4gPj4+IEFkZCB0aGUgdHhfZHJv
cF9jbnRycyBodyBmZWF0dXJlIGJpdCB0byBzdHJ1Y3QgcmF2Yl9od19pbmZvLCB0bw0KPiA+Pj4g
ZW5hYmxlIHRoaXMgZmVhdHVyZSBzcGVjaWZpY2FsbHkgZm9yIFItQ2FyIEdlbjMgbm93IGFuZCBs
YXRlciBleHRlbmQNCj4gPj4+IGl0IHRvDQo+ID4+IFJaL0cyTC4NCj4gPj4+DQo+ID4+PiBTaWdu
ZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4+PiBS
ZXZpZXdlZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJl
bmVzYXMuY29tPg0KPiA+Pj4gLS0tDQo+ID4+PiB2MjoNCj4gPj4+ICAqIEluY29ycG9yYXRlZCBB
bmRyZXcgYW5kIFNlcmdlaSdzIHJldmlldyBjb21tZW50cyBmb3IgbWFraW5nIGl0DQo+ID4+IHNt
YWxsZXIgcGF0Y2gNCj4gPj4+ICAgIGFuZCBwcm92aWRlZCBkZXRhaWxlZCBkZXNjcmlwdGlvbi4N
Cj4gPj4+IC0tLQ0KPiA+Pj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAg
ICAgfCAxICsNCj4gPj4+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5j
IHwgNCArKystDQo+ID4+PiAgMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkNCj4gPj4+DQo+ID4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yYXZiLmgNCj4gPj4+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZi
LmgNCj4gPj4+IGluZGV4IDBkNjQwZGJlMWVlZC4uMzVmYmI5ZjYwYmE4IDEwMDY0NA0KPiA+Pj4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPj4+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+PiBAQCAtMTAwMSw2ICsxMDAx
LDcgQEAgc3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4+Pg0KPiA+Pj4gIAkvKiBoYXJkd2FyZSBm
ZWF0dXJlcyAqLw0KPiA+Pj4gIAl1bnNpZ25lZCBpbnRlcm5hbF9kZWxheToxOwkvKiBSQVZCIGhh
cyBpbnRlcm5hbCBkZWxheXMgKi8NCj4gPj4+ICsJdW5zaWduZWQgdHhfZHJvcF9jbnRyczoxOwkv
KiBSQVZCIGhhcyBUWCBlcnJvciBjb3VudGVycyAqLw0KPiA+Pg0KPiA+PiAgICBJIHN1Z2dlc3Qg
J3R4X2NvdW50ZXJzJyAtLSB0aGlzIG5hbWUgY29tZXMgZnJvbSB0aGUgc2hfZXRoIGRyaXZlcg0K
PiA+PiBmb3IgdGhlIHNhbWUgcmVncyAoYnV0IG5lZ2F0ZWQgbWVhbmluZykuIEFuZCBwbGVhc2Ug
ZG9uJ3QgY2FsbCB0aGUNCj4gPj4gaGFyZHdhcmUgUkFWQi4gOi0pDQo+ID4NCj4gPiBBZ3JlZWQu
IFdpbGwgY2hhbmdlIGl0IHRvICd0eF9jb3VudGVycycgb24gbmV4dCB2ZXJzaW9uIGFuZCBjb21t
ZW50IGl0DQo+ID4gYXMNCj4gPiAvKiBBVkItRE1BQyBoYXMgVFggY291bnRlcnMgKi8NCj4gDQo+
ICAgIFRoZSBjb3VudGVycyBiZWxvbmcgdG8gRS1NQUMsIG5vdCBBVkItRE1BQy4NCg0KWW91IGFy
ZSBjb3JyZWN0LCBpdCBpcyBhdCBvZmZzZXQgMHg3MDAgb24gRS1NQUMgYmxvY2suDQoNCkNoZWVy
cywNCkJpanUNCg==
