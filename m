Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACDC42ABD0
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhJLSZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:25:38 -0400
Received: from mail-eopbgr1410102.outbound.protection.outlook.com ([40.107.141.102]:54320
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230427AbhJLSZh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 14:25:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYSYhwj6oyHMO8M5V+vt57lTAGfXPMKTKNXuCy0QOpYjtctJF4B1+lD2lpSoD4GBb9m7ULDIqyzxPcQyoSDfVfmF9bpYXE9yLbyNAGky8KRh+btrY62Quo2eS2XT1bNxuClegfnp965iwdXVM9Fpm5tZuVK19yHpXYcYqSPDGS6jJS6vOKvP8OVuwqnbSqq0swZubQ6dLDHrBnLU8gHF+gfD/y2ZJXWmq+ZSWtXZjfAAorZY0qHRgM5KtHI6QkbBtElaugVfLKXduaR4QPgfxUViWprr9w9FtJdgzuOdcK2CsEjxiwn4thne2QyyJkKoGCMF/4hGm/ayDcR/TdtDUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FhOuyNZmv0GNUaSexeaDR6YHv1fFHHpb52rQcpoUZdE=;
 b=m6kGtQ5Xs0ZfM09qH82LocJfGQbhGW439UJO/Vmb5GVg6lfoTQ1o/mosfATiDrkr8hJR4tx+u8m7UkHOP7FdD8K3vYQf2xYIoG1j8LBnk3VqpofWBtPnC5xs3JY3h/+ZPu7ucQCxtovkQ7MMYEEk73hLAc00wOMdOa0sU6oUlN7VQPShZiWSAjPA0/yEOAMhAdkzCA1KEBtn33t3MYoYHms6MJnIGurXaE38EpVGfp4+ONs/PfbX9o0iOJSRzBf9jf6vL8re9Lf8lcmfnvJ6FlfEYJLPCx6ni8RcCIrzoauojlNTgeStvwEZNnCa8nd6Og2E845UtWGv3l560SKiRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhOuyNZmv0GNUaSexeaDR6YHv1fFHHpb52rQcpoUZdE=;
 b=k3UL1IELdKltLx4PFNCRiHHOSBo9cXd/a4mQflh3gmEx/ptxOHcegtz9v72rCWj6LTBhDxiIMlDQSScPZRUPbZKAB37x9ndfomhkJK54qj87QmfVSQQiYtgmbbaS/psSBIVadTYp9uGXM6ALsdar/sC2bsYlCJKpqE41Ow4dcFc=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB1700.jpnprd01.prod.outlook.com (2603:1096:603:31::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 18:23:30 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 18:23:29 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
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
Thread-Index: AQHXv4dnnKNAfP5bNkuTvIq9GdANz6vPn6iAgAAEiTCAAAONgIAABUnQ
Date:   Tue, 12 Oct 2021 18:23:29 +0000
Message-ID: <OS0PR01MB59223759B5B15858E394461086B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211012163613.30030-1-biju.das.jz@bp.renesas.com>
 <20211012163613.30030-14-biju.das.jz@bp.renesas.com>
 <b06ad74a-5ecd-8dbf-4b54-fc18ce679053@omp.ru>
 <OS0PR01MB59220334F9C1891BE848638D86B69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <dd98fb58-5cd7-94d6-14d6-cc013164d047@gmail.com>
In-Reply-To: <dd98fb58-5cd7-94d6-14d6-cc013164d047@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb4da01d-450f-4abe-e05b-08d98dad6422
x-ms-traffictypediagnostic: OSAPR01MB1700:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB170094431BE9B1702502BEBC86B69@OSAPR01MB1700.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +aXatE8sfeiDk20OrYg0gYKTU4ufIdQ0y76nu+wCK+5R0Fymzg8m/XeqJUT6WAE9KZ3z1ykFnrBaBsavUGbse7bgnoOy+lUJRLHeKSZpCeZpsHWZy7olsUKFwtNdmzl+RiRdo32uFRo28xXC0kv6tb0itcHRZdI3AzBHGkxnZ+2bwC/FnPpAkdPtdittZheY8KnrRodlTXQaNimuCpXswZaFxg35jx1/wM2757vK584Ukp/YFRyMH3nHEEaXn31tZYlbJmge7nDDKL/QyKLkejcA3/Fs6iqTkEETxVeyGqRwl7yTLdJ+23n3vJh44jPJEEIvyQhyun/f78Md5jFDWLJq5++RoQnLmDKcZzCfUq7/+QjcmBabSgodlWF5BoClLpFfnynEh2qQOW7sbDZbvlt0b500sWnK5Le5GG60ewZKc0E3P5HfthUXfHxXLK1JMjGuOXqSbZbwGX/3pScQk/b2LKXm6woyIVR59h2mWhMMD2KW6A8mPgmKmSb/N6d52ZLaQLzUmvRBZ55lNr/xZoE5vgpU2NPz0FrvsvoNtMRmoEDAEV9NfQpbyRxea2RsqhXFzfCp/39wz+Uxk7Bj66PIFTYXgWAmR3XQKuU2yPzmtij1AICb1gnaXy6J6ob6RQw2DdrKwKaFDbC6BZ69taW+MUdWJOmJrFx4qb2DceO9jYySTF6PCYMdU7GpIyMnvG3BxlfO4jJ760vFMym52Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(8936002)(86362001)(26005)(66946007)(83380400001)(38070700005)(53546011)(107886003)(76116006)(5660300002)(8676002)(6506007)(186003)(122000001)(38100700002)(52536014)(7696005)(15650500001)(33656002)(55016002)(64756008)(66556008)(66446008)(9686003)(54906003)(2906002)(110136005)(508600001)(66476007)(71200400001)(4326008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1JIRHFtRWI4ZXVxbFBKSU5QSU0vbGVwSnhzVXNDa2lyZ0c2U1A0cDU2eER6?=
 =?utf-8?B?MkI0SnlDWEZheGErMGhmZmFDZEhMdFcvMEpoV0lhRGQwYjBxQmhkR0FlMXp3?=
 =?utf-8?B?N25FSUFPSkFqeitPTzh2SytTaUJINFF6UGdBUDNDT05qUU9DNkpBZFhGZDhv?=
 =?utf-8?B?NmxVYko0MFJHWTFVS2Y4enRlMHRIYUg1SnlLUjVaNWtwWklXZ2JuQmpJR214?=
 =?utf-8?B?V2VpZVIwUlhGeDF1VTVBRjVVSDZDaVlQUVZ6VTV5UXdPTGQ3T0VnTy85Z0I2?=
 =?utf-8?B?ZUhRTGZlZm9yd3FMd1dHb3UwSmowSFZiM29STll3amY1blV5SjhuMWYrcHlY?=
 =?utf-8?B?UTlUZ0wxVnJCcHNpaWp0c055dTM0QWFpVGVQWE1wTGRqVnlaWUkwdkN0cXJM?=
 =?utf-8?B?WTRXSW9jZ2NjdHRYS2Z5SUlWamJWcVEzMFpGSFFlSVZzYXRITFlGc1ZLdmlQ?=
 =?utf-8?B?N1hGTXo2RmNJbTh4aUlBaEZ1VFRJWVZhcVM0WGp4QmNnQm1sOWVtUXVkdjJ6?=
 =?utf-8?B?WWp0S1EreUQ1eGtQN1R2UjIrSm16SzhTR0JERmRrYnRUOEJxZm14WEhEaGJy?=
 =?utf-8?B?Tm5seks5Uk9xQTFrRW5oTWUycXA4Wk5IbE4yc0RTQ0hUQk9JZENjbGI5akJJ?=
 =?utf-8?B?RzJkUGdwUkZuUUhVNlpiTjRIMTVaOC9qYTJ4ZTB0Zk9heGVqczgwQTJnQ0lk?=
 =?utf-8?B?QWt2MERZYzAvSjg4T20wcy9Kb0lpdHc4N2JYd3pEYTc3WUZjT1FaRTMwV2dy?=
 =?utf-8?B?ZGNMVENaZVdvRVM3RkZlUlo2aHVjUUVjYXU5M0pvMmUxODFBWUsrT2tvamQ5?=
 =?utf-8?B?Q29DS0tLUHI0WGJDRjFkZHNzYjlBN3NjUE5yVUZidUtVWk9LZmlyYzdNNVZD?=
 =?utf-8?B?SGRPWHplNzQxeUNvcDdFcmhBbG5oalRGaTFuOEs2VFVjNFo4WW5aVlV3M0Yx?=
 =?utf-8?B?MHBueVVuZ0lmR3JONGxZTGx5ZDJZb213LzY2ZjlqM1Rrbzg5YmVXSklrbVQr?=
 =?utf-8?B?Vk0xNDRLWVNrSXhOZCtIK2h2dklBSHFkOVB2VmNMNzc1ZHArQzVtU2Z4bzUv?=
 =?utf-8?B?OC9COHAwcTVndUh6TkNhaDJTRkdTQXBKRTR3djBzRUpVVGpHU0k4TzJKbkxs?=
 =?utf-8?B?ZmhsWXBYMFhLeStyRWZlNGlDc1QyM1Y2eDFiM3ZVNmkrbzJaNWl3OENmcWwr?=
 =?utf-8?B?RTJGRnB5eTlsa3dzN1lzMGV6YWdaVUJ1TjFxL0xsb0tjRG5iUDdFdmhrQWJO?=
 =?utf-8?B?Y0RyRnFvTDBLODFjVlQydHl4dVZKZE1TYkdaU2hvRWhYWDh2dUthcGRxK3lL?=
 =?utf-8?B?S1JEQkhaQTQxZWtCeGdid3lLTFg5RndLYTdYUmxkZnFGS3poSGdQYmNFellC?=
 =?utf-8?B?WklXSlVHMVd3NlJsTEJ1SmpFeGNmdTRwWHRCeE5XUEJPMnJBRWRhSjVaeDU2?=
 =?utf-8?B?VlNPRndUbUFXdUZTWGxGSy9vbHBaRVRPbENTNjNyM2FVWXpFVWdabjlhV1VY?=
 =?utf-8?B?NEN1cmkzclBXclFyekE1eWlyTlJVbDRVMkRiTTAxZGZQTW5JMG5FTi8rWnZS?=
 =?utf-8?B?aTVpZHh2MGM1WXJiMlVndGZPZkJyb0VrY0NpTEthNzJGZEdRd2dXWXdFTnZi?=
 =?utf-8?B?VDlDVlNBZy80TEJwWHRpa1NMZ1JqUDkzcXhnVjFGZWNqQlp6UHJMcEdPOFh6?=
 =?utf-8?B?QWdCbzlLYlk3WFplaXlkSWEveVUycVpwd2tnS0poVUVQVDE4MTdNMGlhQlJy?=
 =?utf-8?Q?BuMFXE0ob08opdzFCE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb4da01d-450f-4abe-e05b-08d98dad6422
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 18:23:29.4997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /SJmnrssjDb5AMf2uhkkq+SRwITouTMxxA5mNAAK5819krN3WUSK4J0N0zwCkuN/lsNvJOlDxxF0TQrz3ISVR4GmUJ2cQnK6HPw0IHBiF3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1700
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjMgMTMvMTRdIHJh
dmI6IFVwZGF0ZSByYXZiX2VtYWNfaW5pdF9nYmV0aCgpDQo+IA0KPiBPbiAxMC8xMi8yMSA4OjUy
IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4+PiBUaGlzIHBhdGNoIGVuYWJsZXMgUmVjZWl2
ZS9UcmFuc21pdCBwb3J0IG9mIFRPRSBhbmQgcmVtb3ZlcyB0aGUNCj4gPj4+IHNldHRpbmcgb2Yg
cHJvbWlzY3VvdXMgYml0IGZyb20gRU1BQyBjb25maWd1cmF0aW9uIG1vZGUgcmVnaXN0ZXIuDQo+
ID4+Pg0KPiA+Pj4gVGhpcyBwYXRjaCBhbHNvIHVwZGF0ZSBFTUFDIGNvbmZpZ3VyYXRpb24gbW9k
ZSBjb21tZW50IGZyb20gIlBBVVNFDQo+ID4+PiBwcm9oaWJpdGlvbiIgdG8gIkVNQUMgTW9kZTog
UEFVU0UgcHJvaGliaXRpb247IER1cGxleDsgVFg7IFJYOyBDUkMNCj4gPj4+IFBhc3MgVGhyb3Vn
aCIuDQo+ID4+DQo+ID4+ICAgIEknbSBub3Qgc3VyZSB3aHkgeW91IHNldCBFQ01SLlJDUFQgd2hp
bGUgeW91IGRvbid0IGhhdmUgdGhlDQo+ID4+IGNoZWNrc3VtIG9mZmxvYWRlZC4uLg0KPiA+Pg0K
PiA+Pj4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29t
Pg0KPiA+Pj4gLS0tDQo+ID4+PiB2Mi0+djM6DQo+ID4+PiAgKiBFbmFibGVkIFRQRS9SUEUgb2Yg
VE9FLCBhcyBkaXNhYmxpbmcgY2F1c2VzIGxvb3BiYWNrIHRlc3QgdG8gZmFpbA0KPiA+Pj4gICog
RG9jdW1lbnRlZCBDU1IwIHJlZ2lzdGVyIGJpdHMNCj4gPj4+ICAqIFJlbW92ZWQgUFJNIHNldHRp
bmcgZnJvbSBFTUFDIGNvbmZpZ3VyYXRpb24gbW9kZQ0KPiA+Pj4gICogVXBkYXRlZCBFTUFDIGNv
bmZpZ3VyYXRpb24gbW9kZS4NCj4gPj4+IHYxLT52MjoNCj4gPj4+ICAqIE5vIGNoYW5nZQ0KPiA+
Pj4gVjE6DQo+ID4+PiAgKiBOZXcgcGF0Y2guDQo+ID4+PiAtLS0NCj4gPj4+ICBkcml2ZXJzL25l
dC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgNiArKysrKysNCj4gPj4+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwgNSArKystLQ0KPiA+Pj4gIDIgZmls
ZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+Pj4NCj4gPj4+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+Pj4g
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+Pj4gaW5kZXggNjlhNzcx
NTI2Nzc2Li4wODA2MmQ3M2RmMTAgMTAwNjQ0DQo+ID4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVu
ZXNhcy9yYXZiLmgNCj4gPj4+IEBAIC0yMDQsNiArMjA0LDcgQEAgZW51bSByYXZiX3JlZyB7DQo+
ID4+PiAgCVRMRlJDUgk9IDB4MDc1OCwNCj4gPj4+ICAJUkZDUgk9IDB4MDc2MCwNCj4gPj4+ICAJ
TUFGQ1IJPSAweDA3NzgsDQo+ID4+PiArCUNTUjAgICAgPSAweDA4MDAsCS8qIFJaL0cyTCBvbmx5
ICovDQo+ID4+PiAgfTsNCj4gPj4+DQo+ID4+Pg0KPiA+Pj4gQEAgLTk2NCw2ICs5NjUsMTEgQEAg
ZW51bSBDWFIzMV9CSVQgew0KPiA+Pj4gIAlDWFIzMV9TRUxfTElOSzEJPSAweDAwMDAwMDA4LA0K
PiA+Pj4gIH07DQo+ID4+Pg0KPiA+Pj4gK2VudW0gQ1NSMF9CSVQgew0KPiA+Pj4gKwlDU1IwX1RQ
RQk9IDB4MDAwMDAwMTAsDQo+ID4+PiArCUNTUjBfUlBFCT0gMHgwMDAwMDAyMCwNCj4gPj4+ICt9
Ow0KPiA+Pj4gKw0KPiA+Pg0KPiA+PiAgIElzIHRoaXMgcmVhbGx5IG5lZWRlZCBpZiB5b3UgaGF2
ZSBFQ01SLlJDUFQgY2xlYXJlZD8NCj4gPg0KPiA+IFllcyBpdCBpcyByZXF1aXJlZC4gUGxlYXNl
IHNlZSB0aGUgY3VycmVudCBsb2cgYW5kIGxvZyB3aXRoIHRoZQ0KPiA+IGNoYW5nZXMgeW91IHN1
Z2dlc3RlZA0KPiA+DQo+ID4gcm9vdEBzbWFyYy1yemcybDovcnpnMmwtdGVzdC1zY3JpcHRzIyAu
L2V0aF90XzAwMS5zaA0KPiA+IFsgICAzOS42NDY4OTFdIHJhdmIgMTFjMjAwMDAuZXRoZXJuZXQg
ZXRoMDogTGluayBpcyBEb3duDQo+ID4gWyAgIDM5LjcxNTEyN10gcmF2YiAxMWMzMDAwMC5ldGhl
cm5ldCBldGgxOiBMaW5rIGlzIERvd24NCj4gPiBbICAgMzkuODk1NjgwXSBNaWNyb2NoaXAgS1Na
OTEzMSBHaWdhYml0IFBIWSAxMWMyMDAwMC5ldGhlcm5ldC0NCj4gZmZmZmZmZmY6MDc6IGF0dGFj
aGVkIFBIWSBkcml2ZXIgKG1paV9idXM6cGh5X2FkZHI9MTFjMjAwMDAuZXRoZXJuZXQtDQo+IGZm
ZmZmZmZmOjA3LCBpcnE9UE9MTCkNCj4gPiBbICAgMzkuOTY2MzcwXSBNaWNyb2NoaXAgS1NaOTEz
MSBHaWdhYml0IFBIWSAxMWMzMDAwMC5ldGhlcm5ldC0NCj4gZmZmZmZmZmY6MDc6IGF0dGFjaGVk
IFBIWSBkcml2ZXIgKG1paV9idXM6cGh5X2FkZHI9MTFjMzAwMDAuZXRoZXJuZXQtDQo+IGZmZmZm
ZmZmOjA3LCBpcnE9UE9MTCkNCj4gPiBbICAgNDIuOTg4NTczXSBJUHY2OiBBRERSQ09ORihORVRE
RVZfQ0hBTkdFKTogZXRoMDogbGluayBiZWNvbWVzIHJlYWR5DQo+ID4gWyAgIDQyLjk5NTExOV0g
cmF2YiAxMWMyMDAwMC5ldGhlcm5ldCBldGgwOiBMaW5rIGlzIFVwIC0gMUdicHMvRnVsbCAtDQo+
IGZsb3cgY29udHJvbCBvZmYNCj4gPiBbICAgNDMuMDUyNTQxXSBJUHY2OiBBRERSQ09ORihORVRE
RVZfQ0hBTkdFKTogZXRoMTogbGluayBiZWNvbWVzIHJlYWR5DQo+ID4gWyAgIDQzLjA1NTcxMF0g
cmF2YiAxMWMzMDAwMC5ldGhlcm5ldCBldGgxOiBMaW5rIGlzIFVwIC0gMUdicHMvRnVsbCAtDQo+
IGZsb3cgY29udHJvbCBvZmYNCj4gPg0KPiA+IEVYSVR8UEFTU3x8WzQyMjM5MTo0MzowMF0gfHwN
Cj4gPg0KPiA+IHJvb3RAc21hcmMtcnpnMmw6L3J6ZzJsLXRlc3Qtc2NyaXB0cyMNCj4gPg0KPiA+
DQo+ID4gd2l0aCB0aGUgY2hhbmdlcyB5b3Ugc3VnZ2VzdGVkDQo+ID4gLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQ0KPiA+DQo+ID4gcm9vdEBzbWFyYy1yemcybDovcnpnMmwtdGVzdC1zY3Jp
cHRzIyAuL2V0aF90XzAwMS5zaA0KPiA+IFsgICAyMy4zMDA1MjBdIHJhdmIgMTFjMjAwMDAuZXRo
ZXJuZXQgZXRoMDogTGluayBpcyBEb3duDQo+ID4gWyAgIDIzLjUzNTYwNF0gcmF2YiAxMWMzMDAw
MC5ldGhlcm5ldCBldGgxOiBkZXZpY2Ugd2lsbCBiZSBzdG9wcGVkIGFmdGVyDQo+IGgvdyBwcm9j
ZXNzZXMgYXJlIGRvbmUuDQo+ID4gWyAgIDIzLjU0NzI2N10gcmF2YiAxMWMzMDAwMC5ldGhlcm5l
dCBldGgxOiBMaW5rIGlzIERvd24NCj4gPiBbICAgMjMuODAyNjY3XSBNaWNyb2NoaXAgS1NaOTEz
MSBHaWdhYml0IFBIWSAxMWMyMDAwMC5ldGhlcm5ldC0NCj4gZmZmZmZmZmY6MDc6IGF0dGFjaGVk
IFBIWSBkcml2ZXIgKG1paV9idXM6cGh5X2FkZHI9MTFjMjAwMDAuZXRoZXJuZXQtDQo+IGZmZmZm
ZmZmOjA3LCBpcnE9UE9MTCkNCj4gPiBbICAgMjQuMDMxNzExXSByYXZiIDExYzMwMDAwLmV0aGVy
bmV0IGV0aDE6IGZhaWxlZCB0byBzd2l0Y2ggZGV2aWNlIHRvDQo+IGNvbmZpZyBtb2RlDQo+ID4g
UlRORVRMSU5LIGFuc3dlcnM6IENvbm5lY3Rpb24gdGltZWQgb3V0DQo+ID4NCj4gPiBFWElUfEZB
SUx8fFs0MjIzOTE6NDI6MzJdIEZhaWxlZCB0byBicmluZyB1cCBFVEgxfHwNCj4gPg0KPiA+IHJv
b3RAc21hcmMtcnpnMmw6L3J6ZzJsLXRlc3Qtc2NyaXB0cyMNCj4gDQo+ICAgIEhtLi4uIDotLw0K
PiAgICBXaGF0IGlmIHlvdSBvbmx5IGNsZWFyIEVDTVIuUkNQVCBidXQgY29udGludWUgdG8gc2V0
IENTUjA/DQoNCldlIGFscmVhZHkgc2VlbiwgUkNQVD0wLCBSQ1NDPTEgd2l0aCBzaW1pbGFyIEhh
cmR3YXJlIGNoZWNrc3VtIGZ1bmN0aW9uIGxpa2UgUi1DYXIsDQpTeXN0ZW0gY3Jhc2hlcy4NCg0K
UmVnYXJkcywNCkJpanUNCg0KPiANCj4gTUJSLCBTZXJnZXkNCg==
