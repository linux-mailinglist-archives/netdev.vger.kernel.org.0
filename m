Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A3A416368
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbhIWQhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:37:21 -0400
Received: from mail-eopbgr1400092.outbound.protection.outlook.com ([40.107.140.92]:36032
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229523AbhIWQhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 12:37:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRpQNOJPgstWF8F3fWb3t1Q/pTsOcI92Y8r8MoufyeAafz0CZorMXWGnDd9O82N1vUCbjSUHoqOPgfdORqzC54/HQKu7ZwSxpAjC1d8NFxH0k7AKkvJcM37FYJ6wwnkEvgdvBC4LZJ/l4T4AtQK7m7wrmpmyBMfqcLka1s5qCWogyCOtQJTsm0VW6nzHB8QbdpRWWUj9yWTxEeSBA7Jde90qeSgl5HcxPSdUTMpgvQzAuMxq78PF+JsYJ3QV5iQBRBATRdtI+zbC6ju/PRej+GF0fITFlk2UiLRsbQ1lXWsqZ0+eujYeXJwey/u38/o4RX9m38Ipe4HUE9BE7EoEFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qL1KVbs/zZQCIbNNZd9S4/ecKUrsHFEqvAuoa1L3L1o=;
 b=oKPVSa+6mlC3M/MvmBXeMREDj8E8OlXUNzCnI8Q+uDmTx+OnQz/ARAVTJSuiDdw18O1nsrgb4DqvUdyLsNGxetmaV2W3g4oecR1m+npkm84PU+JyAGdeIj+RtrG2CyUvI12mXzh+QOwaLeR+rnxaL4+HlFndgTICW5Ty08mVizZhi9cM+f01zXxjVmwgNklKo4lPYVXxu0EI/jBZwo6M1Sxz73FrTJOybF8sF9dgSHT51yvzoY9hYVNl4oV77nRl13x76gF7rxo7RrhtAPA3csDNIenv7H4JCltS7Ni7WWPaCYCpPhBgqjLmTYs3TPA2ZhI+qk/JO0tTq3kBrlrGTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qL1KVbs/zZQCIbNNZd9S4/ecKUrsHFEqvAuoa1L3L1o=;
 b=fqMTj+Nd7qzpHcxdaPypsBYs/hS8vYF0lIaOJ9mgqLhbEREbdn7Zx77sTKHSZjdpZ24QaXmfNhLBQk1o/H8zsGvRT2C+Rej7Yc2tVUP36g2gXzfTir5khki2kWa1MFX2fsAQoGsSlkKrRT7eMVdVf4RrEI0XCOgI8iIPqTFhN0w=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5957.jpnprd01.prod.outlook.com (2603:1096:604:d3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 16:35:45 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 16:35:45 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 02/18] ravb: Rename the variables "no_ptp_cfg_active"
 and "ptp_cfg_active"
Thread-Topic: [RFC/PATCH 02/18] ravb: Rename the variables "no_ptp_cfg_active"
 and "ptp_cfg_active"
Thread-Index: AQHXsIR6i8xRzRPknU2rkuHPKtaM+auxyTsAgAAE3lA=
Date:   Thu, 23 Sep 2021 16:35:45 +0000
Message-ID: <OS0PR01MB59228BE53DE8DB7AA491F03F86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-3-biju.das.jz@bp.renesas.com>
 <e54aa4c9-9438-bd99-559a-6aaa3676d733@omp.ru>
In-Reply-To: <e54aa4c9-9438-bd99-559a-6aaa3676d733@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dabd9280-d367-40d5-035f-08d97eb03131
x-ms-traffictypediagnostic: OS3PR01MB5957:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB5957CED6F230E52E2E8AE19486A39@OS3PR01MB5957.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VzrwHYi2K/KpDnU3dNrdwTJ/NiI60DWwYUuT0ylTj3wXTxfe5DwO9/5F1C0iWc04q362jIs0BAUyIFoUPi5vte0h5QBZGDwklURyfrknYffczLMEqW2goMLCG5P9qJB/jRVTQZJhHt0AOp4A7UKyk5SETafUknbgA48qY5B8giWyRsqAskk0vU6AGltnmgdFsYPQoosLd7giy6/PVnmgF7Gge1xLQEupJt3dFnn19EA6N5xdisrP4HzZI9aUnF1d6jBLHc1WNeIsiz82S5ybWBEK944n4uCmHBAccCGIYGe1Qldl2N8NJMsoZQaumyiXqXtOtbKBeoXaYCqrW55jEi98GDDFmUZKQ+S+10bHvvvkTXa+tPLsPsbveIl5jX4n75Sq5XLTjhUY3KBdaifObSgFbobloSYY6jiiNJh0sFLB4icBXaFoOUiO7DWKYwgYROQgS8WZ0773IbMtH9ATjRKogz0v6UuzVVYeaJrrZGkix7WEVo5Pp/tppUD0n8a4LZ7+n/zrSW9SZtayGj7II0NZPfupKeqFt4B9Dj0c/P8zQe2KbQkdwShlhDlGfoSoSyupodnXEB6guVyxLQB/i5psKpSFRN0g86A7wp6qm4B/ir6T3D8QXSzWHftxyytDYno7+fJ2VgjLSzUBhix0dDl3qBJGKymzV/xW7kbax+Oh87cUkaeBqsOoa32SkJfxUq9YEZzFnBNeTncGl8Vcgh5/iGT+QaFyb9FGMFmAIouq9dSTFUttdhQaoOb2S9ewwRdZINdoom5jrxmFg5HRiKqNm85DTOlVx/+FFDutwzXsFD4rqX0V8KUwYNDl6i7Z7kgLhc6KE4taHA1zqUP9NQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(38070700005)(2906002)(64756008)(66556008)(7696005)(66446008)(8676002)(8936002)(508600001)(110136005)(52536014)(5660300002)(122000001)(38100700002)(966005)(186003)(53546011)(86362001)(55016002)(316002)(6506007)(33656002)(83380400001)(66946007)(9686003)(26005)(54906003)(4326008)(107886003)(76116006)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTVuYUdxY0FVT0tDTk1rbldRQmQ4ZGo4a0NnWERmSHl6QzJDYXBMcURrblRQ?=
 =?utf-8?B?YUJJT3JvZTdTZFdoY3UwVEZvMUd3bDM0T20yVDZCREVXUTN0S2VDbVFZRkx3?=
 =?utf-8?B?WWJBdzlHcnRLNWZQRE5McnJCUUt2SCtpdWZxbDF3RXpTd0UwYTNjRXFCbU94?=
 =?utf-8?B?Vmh6ZmplK1VYNzk0SlNickFyL05ibXFZOWt1YkZoR1pBWDVCRjNDWVM5d1pQ?=
 =?utf-8?B?TWU2d3FqMjVuZnNOSFI2TC9RSWxCeGdJQTBTYWpqYXI2cTFoUnIxaktOaFl0?=
 =?utf-8?B?SVhwdUNLUGgxNG1hUmxSRXJKdzV3RldaU2tFa01rVFF5dFBFaHh2K3A3MFNs?=
 =?utf-8?B?UnBrL1pMYTBEL2xqZnlIcFlzT2wzRllEUXhWN3ptM1RmblpJUTh6Q0xJeFA1?=
 =?utf-8?B?RTdyeFBpVC81QU16THJPY1dXYit5YytCWjdUKzROdDI1SUI0bVVCOFhrQTFC?=
 =?utf-8?B?bm1jR1hLUkFsQU1FZWR5RzVPTVM2S2d3OGJEMDlldVk2Y2JtK0FXRGZFU3o4?=
 =?utf-8?B?ZHgzaFhlbHlYNUZmUnM2ak5ZdVJOY0l6ZmowRTBkK0VnYjFlb1JibDJYc01m?=
 =?utf-8?B?MmFVMkhubTJCK3NZMGZyVW1LdDI4enE1bXU1L2pPbmZYc2xPbm9USWNVcHRU?=
 =?utf-8?B?aU5MTXJkV0x3MzAxUmwwTUJJU1BQQUdLcVNoWi84eWNkd01iNGI2anFKZkNF?=
 =?utf-8?B?WkxTc0xTa0pSbjg0OVZwY2p1V1dkWndjakZGYzRqUS84dUZRaFpzRE9NUXA2?=
 =?utf-8?B?a25WNlJXY3NWcVJadGNSUXNmNGZVZEJaTjgxVjFQMzl2aVl1WXRXeEt3cVpV?=
 =?utf-8?B?QXBSa2w3Uzl4YTl0WUhNV0lPZ1dTU3R3cmswMTBvSG9wR3dGN0planZqcUNs?=
 =?utf-8?B?bTZESjVOek8yc2JqdGplMkJFTWtLSkhMSGhGZTNDSXR5YnJxSnNxdWhWaXZm?=
 =?utf-8?B?SjFZbGx0NCtsTmRpQ1MzOEZwMlhhU2FrMU5UdHZTR2dHSlJrUDBZdm1SWXA4?=
 =?utf-8?B?T1JLSUYrbDh2M29iUm9RQU9Nd2NLSFRsSXpEckFqeER1L092SmJOOEdSZnJF?=
 =?utf-8?B?eDNKNzZTaVAreEhkVE94MGlQRUJSOGFQRDlnQkUraVNTSXdXdSs1a1JxUTRH?=
 =?utf-8?B?SmhnblYxcTA0Wi91RThRcmw2V0dvUkFKeHZHMGVaa1NXOGJRN3N2RW4wOWsw?=
 =?utf-8?B?cmF5a2RTVWxvckp2Z2MxVEtIaFFEZmJvTGJLU3VEQ1F4eWdnck1adERNOWRt?=
 =?utf-8?B?VjdOSDJ4TzhsdnJsS3BGL2IwK1l3SWhMZ0ZNRlNxTk5HQUZxcjZmQzNWeENT?=
 =?utf-8?B?M1ZYNWJSalIzNFFqcFdWVFB3K0lEazhVV0VGZXFpeTFlczFsb0FTaytWRFpn?=
 =?utf-8?B?VGhlcmc4ZWZrK0Nub1RVbm5ySzB4OVFmZ2dZRS92SHZjUFE2SWRMWDdCNmlG?=
 =?utf-8?B?U1JXbVdNOHdIZDYxdUxzOWkzaEc1VDg3MDFScW9jemFGSVpqaWpVWTFGVmI0?=
 =?utf-8?B?MmdIWXgxQlJ6U00yQWN3ZDFNRDlnM2k5UVJZOVY3aG4rZUpBOGJoTE03cmxM?=
 =?utf-8?B?eU1CTVZJK2ZMVCtLRm4xakJsWHJFMUlPTUREaC94OWdYb01hbHBqQVF0M1hz?=
 =?utf-8?B?SWRIWHpPQXVGcmVOZXAwUzJkMnRpZklTRDBLL1lzN0xlaTZqclcya1lnTyt6?=
 =?utf-8?B?djRhU29lbnM2UTFKL1Vqbk9WeWdGSnhCYnhqeUU4ZHRYY3dBSVdRUnNTcThE?=
 =?utf-8?Q?Grls79A9lYiUSo6zni76ClfNHlTjESTAU67Xnt+?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dabd9280-d367-40d5-035f-08d97eb03131
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 16:35:45.1278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kSXNKMHkeAKP+dgYcwD2trEjpYooCvWuqSHpTJ38PCs3tqz3y0rFsr4zzCjvxDJztbHHxR3Tcho0pwEJUf0txG/RLJZJVQefipncnUWR1Nc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5957
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiAtLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KPiBTdWJqZWN0OiBSZTogW1JGQy9QQVRDSCAwMi8xOF0gcmF2YjogUmVu
YW1lIHRoZSB2YXJpYWJsZXMNCj4gIm5vX3B0cF9jZmdfYWN0aXZlIiBhbmQgInB0cF9jZmdfYWN0
aXZlIg0KPiANCj4gT24gOS8yMy8yMSA1OjA3IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4g
UmVuYW1lIHRoZSB2YXJpYWJsZSAibm9fcHRwX2NmZ19hY3RpdmUiIHdpdGggIm5vX2dwdHAiIHdp
dGggaW52ZXJ0ZWQNCj4gPiBjaGVja3MgYW5kICJwdHBfY2ZnX2FjdGl2ZSIgd2l0aCAiY2NjX2dh
YyIuDQo+IA0KPiAgICBUaGF0J3Mgbm90IGV4YWN0bHkgcmVuYW1lLCBubz8gQXQgbGVhc3QgZm9y
IHRoZSAxc3QgY2FzZS4uLg0KDQpUaGlzIGlzIHdoYXQgd2UgYWdyZWVkIGFzIHBlciBsYXN0IGRp
c2N1c3Npb25bMV0uIA0KDQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbGlu
dXgtcmVuZXNhcy1zb2MvcGF0Y2gvMjAyMTA4MjUwNzAxNTQuMTQzMzYtNS1iaWp1LmRhcy5qekBi
cC5yZW5lc2FzLmNvbS8NCg0KDQo+IA0KPiA+IFRoZXJlIGlzIG5vIGZ1bmN0aW9uYWwgY2hhbmdl
Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVz
YXMuY29tPg0KPiA+IFN1Z2dlc3RlZC1ieTogU2VyZ2V5IFNodHlseW92IDxzLnNodHlseW92QG9t
cC5ydT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgg
ICAgICB8ICA0ICsrLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21h
aW4uYyB8IDI1DQo+ID4gKysrKysrKysrKysrLS0tLS0tLS0tLS0tDQo+ID4gIDIgZmlsZXMgY2hh
bmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gaW5kZXggNzM2M2FiYWU2ZTU5Li4wY2Uw
YzEzZWY4Y2IgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiLmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+
IEBAIC0xMDAwLDggKzEwMDAsOCBAQCBzdHJ1Y3QgcmF2Yl9od19pbmZvIHsNCj4gPiAgCXVuc2ln
bmVkIGludGVybmFsX2RlbGF5OjE7CS8qIEFWQi1ETUFDIGhhcyBpbnRlcm5hbCBkZWxheXMgKi8N
Cj4gPiAgCXVuc2lnbmVkIHR4X2NvdW50ZXJzOjE7CQkvKiBFLU1BQyBoYXMgVFggY291bnRlcnMg
Ki8NCj4gPiAgCXVuc2lnbmVkIG11bHRpX2lycXM6MTsJCS8qIEFWQi1ETUFDIGFuZCBFLU1BQyBo
YXMgbXVsdGlwbGUNCj4gaXJxcyAqLw0KPiA+IC0JdW5zaWduZWQgbm9fcHRwX2NmZ19hY3RpdmU6
MTsJLyogQVZCLURNQUMgZG9lcyBub3Qgc3VwcG9ydCBnUFRQDQo+IGFjdGl2ZSBpbiBjb25maWcg
bW9kZSAqLw0KPiA+IC0JdW5zaWduZWQgcHRwX2NmZ19hY3RpdmU6MTsJLyogQVZCLURNQUMgaGFz
IGdQVFAgc3VwcG9ydCBhY3RpdmUgaW4NCj4gY29uZmlnIG1vZGUgKi8NCj4gPiArCXVuc2lnbmVk
IG5vX2dwdHA6MTsJCS8qIEFWQi1ETUFDIGRvZXMgbm90IHN1cHBvcnQgZ1BUUA0KPiBmZWF0dXJl
ICovDQo+IA0KPiAgICBKdWRnaW5nIG9uIHRoZSBmbGFnIHVzYWdlICh3aGljaCBlbnN1ZXMgdXNp
bmcgbG9naWNhbCBub3QgaW4gZXZlcnkNCj4gY2FzZSksIEknZCBzdWdnZXN0IHRvIGludmVydCB0
aGlzIGZsYWcgYW5kIGNhbGwgaXQgJ2dwdHAnLi4uDQoNCldlIGhhdmUgdGhlIGZvbGxvd2luZyBj
YXNlcyANCkNhc2UgMSkgT24gUi1DYXIgR2VuMywgZ1BUUCBzdXBwb3J0IGlzIGFjdGl2ZSBpbiBj
b25maWcgbW9kZS4NCkNhc2UgMikgT24gUi1DYXIgR2VuMiwgZ1BUUCBzdXBwb3J0IGlzIG5vdCBh
Y3RpdmUgaW4gY29uZmlnIG1vZGUuDQpDYXNlIDMpIFJaL0cyTCBkb2VzIG5vdCBzdXBwb3J0IHRo
ZSBnUFRQIGZlYXR1cmUuDQoNCkFuZCBJIGNhbWUgdXAgd2l0aCBwYXRjaGVzIFsxXSBhbmQgWzJd
LiBUaGVuIGFzIHBlciBkaXNjdXNzaW9uIHdlIGFncmVlZCBmb3IgZ1BUUCBzdXBwb3J0IGFjdGl2
ZSBpbiBjb25maWcoY2NjX2dhYykgd2hpY2ggdGFrZSBjYXJlIG9mIENhc2UgMSwgbm9fZ3B0cCB3
aGljaCB0YWtlIGNhcmUgb2YgY2FzZSAzIA0KQW5kIHRoZSBjYXNlcyBub3QgdW5kZXIgMSBhbmQg
MyBmYWxscyB0byAyLg0KDQpbMV0NCmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVj
dC9saW51eC1yZW5lc2FzLXNvYy9wYXRjaC8yMDIxMDgyNTA3MDE1NC4xNDMzNi00LWJpanUuZGFz
Lmp6QGJwLnJlbmVzYXMuY29tLw0KWzJdDQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3By
b2plY3QvbGludXgtcmVuZXNhcy1zb2MvcGF0Y2gvMjAyMTA4MjUwNzAxNTQuMTQzMzYtNS1iaWp1
LmRhcy5qekBicC5yZW5lc2FzLmNvbS8NCg0KU28gcGxlYXNlIGNsZWFyIG9uIHlvdXIgcHJvcG9z
YWxzIHRvIGFjY29tb2RhdGUgdGhlIDMgdXNlIGNhc2VzIGFzIG1lbnRpb25lZCBiZWxvdy4NCg0K
Q2FzZSAxKSBPbiBSLUNhciBHZW4zLCBnUFRQIHN1cHBvcnQgaXMgYWN0aXZlIGluIGNvbmZpZyBt
b2RlLg0KQ2FzZSAyKSBPbiBSLUNhciBHZW4yLCBnUFRQIHN1cHBvcnQgaXMgbm90IGFjdGl2ZSBp
biBjb25maWcgbW9kZS4NCkNhc2UgMykgUlovRzJMIGRvZXMgbm90IHN1cHBvcnQgdGhlIGdQVFAg
ZmVhdHVyZS4NCg0KUmVnYXJkcywNCkJpanUNCg0KDQoNCg0KDQoNCj4gDQo+IFsuLi5dDQo+IA0K
PiBNQlIsIFNlcmdleQ0K
