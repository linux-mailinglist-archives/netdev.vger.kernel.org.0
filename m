Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1B645D81C
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 11:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347801AbhKYKWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 05:22:22 -0500
Received: from mail-os0jpn01on2121.outbound.protection.outlook.com ([40.107.113.121]:18290
        "EHLO JPN01-OS0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244132AbhKYKUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 05:20:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWpE5OTHSGOg9oXjNc0RVR9TntSpMYnd8GpC77TeufTShHb8WoQBPzMi6KjMd3HVul0xJjrgKBu+lBo3zfNfXf3iFhA5QhXyhJg3QaxAFojKI+FIyPrwUpAOwx4EmkYSlrfFjEw3FiE4XFperfQYZ+GjU7TC7V7iw9f+8jxExoUVbD3hxTbuZxG9Ft7m5QRY9bwbBX/FkuySCJ4uFO7Vb6dpxG9Obsk1V8HRif+3gXp1KxsphEeNMgGPuCu0J3ynlIW8RwiwJuAqotxtAgxYeeHRYkh1PhXXID3JGydMaQ5jsfyiQyuqtiYyRN7v8s5i9zhFO5FRQax44VTC93JB3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LuIOZcXQcjbgrmA0ZVqaHBEji7giMwMh5RvwheRHnic=;
 b=kTnlR69J/jKXBlztx98JlHr0p+bODJHjOwzvjFWuLbJNu1ts3qtEjaYl0aTRwiD61um4Fa1dH0uJrurcOAmywnxaTKcRL1R4/57LYHaHIJpReTmBAyFK3rZv+HEif4dgyJmXc2oe9n3JdDq/iddC26mg3tlO8+csk6Xesv7nVaXedV5vNP2oioNobhY1iLwz65/v3ole99ePRXIkGJXQNPu0lIfymlXt4udJhAJfal1VJ6wamyf8PGfBBWANDh6PsO5BqIDd825VMA3xYWpl3oz4dRnmoODM0NQZawujvqjC6nZuZCO8M47HCeSWzxJcBYx3ufZ/ThXATfUojnKJxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LuIOZcXQcjbgrmA0ZVqaHBEji7giMwMh5RvwheRHnic=;
 b=JtGxiGGPa2Yc5K/g+fa1CzwtQR0nX79hY09J2qyCXyP3Mu7/aRXb4rJ27LoliYVj/Gj2xNP+xZiqA2xyZYP/9vrDcHE9BhkcgiyxmJVfSIW0um5HVCUC92NGcmZQzFHUovbSzs1Yj7e7HMHopVTp22XcR+B7BMNKNo959fxHBDE=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5441.jpnprd01.prod.outlook.com (2603:1096:604:a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Thu, 25 Nov
 2021 10:16:44 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c0bd:405a:cdd3:f153]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c0bd:405a:cdd3:f153%9]) with mapi id 15.20.4713.027; Thu, 25 Nov 2021
 10:16:44 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC 0/2] Add Rx checksum offload support
Thread-Topic: [RFC 0/2] Add Rx checksum offload support
Thread-Index: AQHX4G6BPnL1RhDFrUy043gm2E9zIawTH3SAgADqc7A=
Date:   Thu, 25 Nov 2021 10:16:44 +0000
Message-ID: <OS0PR01MB59222D5453745C2197DB1D4886629@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211123133157.21829-1-biju.das.jz@bp.renesas.com>
 <50544d12-01f1-2ec0-a9e1-992a307cc781@omp.ru>
In-Reply-To: <50544d12-01f1-2ec0-a9e1-992a307cc781@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee27b527-e9f9-47d4-2261-08d9affcaec7
x-ms-traffictypediagnostic: OS0PR01MB5441:
x-microsoft-antispam-prvs: <OS0PR01MB54416B935877F9FEF749AAA686629@OS0PR01MB5441.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0jM02bpUVltTsP5wioF3ZeXxjdFspAraKjf/W1bH9J96NEEadmlivnSRhkRQYTSQIQnyZiY1vWTbYOHsualNE4VfwE7pi/GH2i6fq0jpfihA6pBlO4Rcwwep4zNJQTSuVnNupMm/7a2YRM7gC33NJ+6YxNyDs/hmdLYJzAl5AboklZci6dFU+CaNjfJLTFGoc5va8rT3x/W7bCeh5sRPpZNp0Ldoil7GyI9xmw3a41H53KaymGay8bN7rdUrk51UxsOlaSaoBKsv1AAqb1wb52yP31pQEHYwTJKQQc1S3RzP7LeemQFXMBRHZFtPZP5ZhRmt57LaZ/zNmycn/beoZanYOG4QaBbIRjRLAi2c5Jigm5bD8nVRQLNHf1BteXJJ3TDFm560aEGCNuSMzF4jIuxOEhBDaMV7svWkjPr69RoWAl1O/oW0a1Rb6CsCpYGJswH9OYxkSBkGhxOOOK1avsQVV/Tu809blDRLZOnA5+7UimHaufCmN/MsqLlSlbqm4FY/2M6ee1EOLdkaxjC3c0i9bt/lyLF6Bd1b1sGK/vLPNYfF6ZgFNWZed27PTTcKFiwSVlxMPTsNp3H1+n7fB94mrsS/wiDYpk7Y6UxyQ0ClFMfn/UAd+RiwR0OYBQNyU2MyMBTAtKj0zYb/S6pC25DVrbzUAGPxSBvlGHKYnRqDTo9At3gf5irIM8/fHMk+gDZshQ3uK7qtR2WoFRIC8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(186003)(86362001)(8676002)(107886003)(66446008)(122000001)(508600001)(2906002)(38100700002)(33656002)(5660300002)(26005)(64756008)(316002)(54906003)(9686003)(76116006)(6506007)(8936002)(71200400001)(55016003)(110136005)(66556008)(66476007)(7696005)(38070700005)(53546011)(4326008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2swcE1ZVFd2aGZ3RTNjRjRwa2dFdVFnYTBrdDA3T3djZW9JZVZjSnZNZlpK?=
 =?utf-8?B?c1g0dU1qNVNUQ2NLUE1YTVdBcUx3c0RrRmFOaWM3M0JxSnpqc0t2YlB0TDRt?=
 =?utf-8?B?bDRCc2M4OEtnOUxIdWQzdHhyV0w2VUtQNk5VZEVUR0pzaXJ6a2lpN3Y4Mnpp?=
 =?utf-8?B?UWp0M0NKeUUxR0tlQVBudE5JRkd2OUVOQ2UzTjFGYzFEOU1FS3IxS2tlUzJ1?=
 =?utf-8?B?dVpUcDV5Z3NOWXdJeFIwMHBTT1dZTVB4MS9CSUhnUTdiSStWeGgyajFWUmlV?=
 =?utf-8?B?Q082SmUwRzRUZTZoU29ycmlGTFZrcWZCT3hHWlhFcXNHSXYzU3ZqU0l1TDRw?=
 =?utf-8?B?WGVORVQ1Q0FaTlFtaHVmRDJZbVZyNXlsSURHN1cyZjVrS1poNWJlQ2NUSGdm?=
 =?utf-8?B?MjMwb2VIbDd0UW9wOUFwd3RzUFpjZXBMSjBrRURia3ZoMG83ZzNNbGYycXlG?=
 =?utf-8?B?N0REV2ljVjNQNDhsLzd1KzBCVlhxdkFRWE45dFMxWW9XSG03dVV1dmRqOTVi?=
 =?utf-8?B?UWl6aFBQTlhsZm1KY25zS0llZnI0M21TcGphZlZmdWxJK3pNWnNIYnkrRi9p?=
 =?utf-8?B?dDNBeTFhSmRqdEQzL1NQS2FjWmE4OG1TQWM2MlJEMlo5cy9CYmFzS2xyUnVO?=
 =?utf-8?B?OGJhbmJRZk1KNm5DbFpqbDVodmpqcWNIUkZJekFZUXFUQzRrbXFQc1NhVHhL?=
 =?utf-8?B?bnpRVWVEcEp0YlJvQ3gxNUcvbDhLZ3M1N2twN3VOeitVSTErbVZQbGFqcG5n?=
 =?utf-8?B?aGlKaWZyMlJ0aDdIN0hoeFlmYmNZbUVOeU5yUHpsSjgzVzByRHVsc1hpdkJy?=
 =?utf-8?B?Ti93Y3lUMGRMd2lTL09rTFdaaWFmUkNmVmJRYy9JQ09PbmZ2YXNxcjV3U2JJ?=
 =?utf-8?B?SkxCb0dKUWpGblhhRVQzL0lHVGh2SzVNby9sZENNS2FvNTNnUlluSFVYZjdF?=
 =?utf-8?B?UEZRdHVNUTJ0Vzh1QjBKdjV3bVA0a1Y5SzFtRU14bE9vSUpLeGZnV016M0sz?=
 =?utf-8?B?NjJ6ZVBqakh5bHNqRE5LZldKN0pWK2FIZU80dlBieExYaEFndG5kOHY4cHgz?=
 =?utf-8?B?RHovNkI0ZnFiZWFUS1NoeEpJVEZGVCt2Ry85Nk5lZmdvaHRhM29SbDZ6bGJN?=
 =?utf-8?B?WWRqYlJFWmFWcWR4NEhQYXJxQ2ZYNCtsZFBBaElvTDQ2b1kxSVFvZ0hEeUcx?=
 =?utf-8?B?RnJ0WXFvR2FBOHphUlhNTHpCTDVmQ0FYUkxhNFcrakJDZDRuQzRlVkk4bGJL?=
 =?utf-8?B?UUdqN1hvVER5c283VmVCYjdsQUpWUVVsdWVBUFJsU3pTU2gxMnMzR1cxNU1u?=
 =?utf-8?B?UE5oNngyN0dBcFo4TVhSUHJSUlZDcDhmSXJqYnZuRXMxdDNyWXFqQm9MNUNa?=
 =?utf-8?B?eW9KbENmaVJWTmh6Qm1hQXg0RDlEWkJpNTlRY1R5L3BlQ0gzSGdhZHNhTm9w?=
 =?utf-8?B?QTJtY2RQQWlPMXhydFhISVVUY3EzeGJuT1c5ODFpSFZvVWZkWGZuTTdOalJJ?=
 =?utf-8?B?RS9zOUhuaS9IQlFhWVM2aEhES3FGdHdrMDFDcjhQVThsNkMyZWVGTkhUaDhF?=
 =?utf-8?B?RFNqY2UxbEFHYzdmdFNIWkVLZlhnd1p6NCtRT3pUZit1U3ZQS2dydmduYklB?=
 =?utf-8?B?UzJaUXorTkhoejUyNjhUUms2N0NsOU5BMXQ3WW4rTzhVdlUvVDRtbHo3aVNZ?=
 =?utf-8?B?OHpKUmwzRGhNbjR3S21hUmxpTUJqVGJnSEtFUmNEZkNLWjN6bmFZTHY1dGxO?=
 =?utf-8?B?Q29KalBXS3hTNmNHZjJNaWx3d095bnpiMVU0bmEvcit5aG5YZGQwemp2MkNV?=
 =?utf-8?B?M1R3eFJjR0FnSzQ0YWhDZTJqN1pZSGhBWkgzMjA4NDR0eUtaVFhYaWRPa21L?=
 =?utf-8?B?aklENnZncC8yclV1eXNZZVUwT2dMNFp2cEZNWGJ3TkhQM2txQVJGMURHVmIy?=
 =?utf-8?B?WU0vb1A4aG5WRis0a1o4STBXeE5EV2k5c0Y4ZU43eTB3TUVFNU9OcExrWXlC?=
 =?utf-8?B?YWNKSTVmNUFadW52blpsUlZ0RFp5NGJJSHpxMGlIZ00yd3Q3KzQ1RytrZ0dz?=
 =?utf-8?B?NXhmRm1NbUwvS0FCK1Y1aVliZkdjR2QzWlg5akV4azFWV3ZWK0xCNFNxWEpx?=
 =?utf-8?B?TDdnUUU4b3RuOFNTN2RBUTUzRWtUKzgxUEpoNzlnay9BWHB5bXE5am81aGIr?=
 =?utf-8?B?eW8xNmV6Rk9rY1ltMS93cEdKRStXNFg0ckhPd01FWGEydk1EREl1cVM3RFdo?=
 =?utf-8?B?bzZlZGtiazVJa1hRcFR4OVA4dVZBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee27b527-e9f9-47d4-2261-08d9affcaec7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 10:16:44.6649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LE1mT5p/GWlPxoJJjtfw4e7HHpKJ5UCN7byc12GJZ7DS7IXm+pZXGgAbl5ElqlhNCtLGzLJc4yAXgWrp4aispdOriaswjsdqxsQUzXG41/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5IFNodHlseW92LA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDIDAvMl0gQWRkIFJ4IGNo
ZWNrc3VtIG9mZmxvYWQgc3VwcG9ydA0KPiANCj4gT24gMTEvMjMvMjEgNDozMSBQTSwgQmlqdSBE
YXMgd3JvdGU6DQo+IA0KPiA+IFRPRSBoYXMgaHcgc3VwcG9ydCBmb3IgY2FsY3VsYXRpbmcgSVAg
aGVhZGVyIGNoZWNrdW0gZm9yIElQVjQgYW5kDQo+ID4gVENQL1VEUC9JQ01QIGNoZWNrc3VtIGZv
ciBib3RoIElQVjQgYW5kIElQVjYuDQo+ID4NCj4gPiBUaGlzIHBhdGNoIHNlcmllcyBhaW1zIHRv
IGFkZHMgUnggY2hlY2tzdW0gb2ZmbG9hZCBzdXBwb3J0ZWQgYnkgVE9FLg0KPiA+DQo+ID4gRm9y
IFJYLCBUaGUgcmVzdWx0IG9mIGNoZWNrc3VtIGNhbGN1bGF0aW9uIGlzIGF0dGFjaGVkIHRvIGxh
c3QgNGJ5dGUNCj4gPiBvZiBldGhlcm5ldCBmcmFtZXMuIEZpcnN0IDJieXRlcyBpcyByZXN1bHQg
b2YgSVBWNCBoZWFkZXIgY2hlY2tzdW0gYW5kDQo+ID4gbmV4dCAyIGJ5dGVzIGlzIFRDUC9VRFAv
SUNNUC4NCj4gPg0KPiA+IGlmIGZyYW1lIGRvZXMgbm90IGhhdmUgZXJyb3IgIjAwMDAiIGF0dGFj
aGVkIHRvIGNoZWNrc3VtIGNhbGN1bGF0aW9uDQo+ID4gcmVzdWx0LiBGb3IgdW5zdXBwb3J0ZWQg
ZnJhbWVzICJmZmZmIiBpcyBhdHRhY2hlZCB0byBjaGVja3N1bQ0KPiA+IGNhbGN1bGF0aW9uIHJl
c3VsdC4gQ2FzZXMgbGlrZSBJUFY2LCBJUFY0IGhlYWRlciBpcyBhbHdheXMgc2V0IHRvDQo+ICJG
RkZGIi4NCj4gPg0KPiA+IHdlIGNhbiB0ZXN0IHRoaXMgZnVuY3Rpb25hbGl0eSBieSB0aGUgYmVs
b3cgY29tbWFuZHMNCj4gPg0KPiA+IGV0aHRvb2wgLUsgZXRoMCByeCBvbiAtLT4gdG8gdHVybiBv
biBSeCBjaGVja3N1bSBvZmZsb2FkIGV0aHRvb2wgLUsNCj4gPiBldGgwIHJ4IG9mZiAtLT4gdG8g
dHVybiBvZmYgUnggY2hlY2tzdW0gb2ZmbG9hZA0KPiA+DQo+ID4gQmlqdSBEYXMgKDIpOg0KPiA+
ICAgcmF2YjogRmlsbHVwIHJhdmJfc2V0X2ZlYXR1cmVzX2diZXRoKCkgc3R1Yg0KPiA+ICAgcmF2
YjogQWRkIFJ4IGNoZWNrc3VtIG9mZmxvYWQgc3VwcG9ydA0KPiANCj4gICAgVGhhdCdzIGFsbCBm
aW5lIGJ1dCB3aHkgaW4gdGhlIHdvcmxkIGRpZCB5b3Ugc2VwYXJhdGUgdGhlc2UgcGF0Y2hlcz8N
Cg0KT0ssIGFzIHlvdSBzdWdnZXN0ZWQgd2lsbCBtZXJnZSB0aGlzIHBhdGNoZXMgYW5kIHNlbmQg
YW4gUkZDIGZvciBmdXJ0aGVyIGZlZWRiYWNrLg0KDQpSZWdhcmRzLA0KQmlqdQ0K
