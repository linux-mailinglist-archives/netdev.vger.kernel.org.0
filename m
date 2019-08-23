Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248F79B037
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 15:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395123AbfHWM7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 08:59:53 -0400
Received: from mail-eopbgr130135.outbound.protection.outlook.com ([40.107.13.135]:56824
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392642AbfHWM7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 08:59:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+UC/J7NrjZAQ/w+4DxQyMwR9j4F23p6hIHBGeHIKi47pHnp2jHEuvEvxYnJeMWenia+QIwc0Fpo/VCYowK68ys1lsuf5gz0FEtKagPgA32IEa8NYvWwJh9NlkYvbJDJLBPKjZ0P8hEM03nase1Sp7VAIyOPtiWVAqcdBGvyiRM+FIAJC1UNPBa7UwzFsPrrsQ6SZ/HyPDI8BXhKSayKScSCKbluQcVl5UE4XFHWHVjUgnEeYm5Eu20abaCUEhJ94nkaGQhZjxSAu7Fyxiy9BJtZfQI+ZG2Z2FTz4FSGPrN2AB0DaKFihrJ5kmyIrPd0dH+IuXCqGqF0DsgTdtPZ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zB5X+n1hZZf4kq3HrGRwNGqDlne0LcdhzFmI0kGIiZM=;
 b=ILO/VFr09mWdxwhMidmG5Am2vWYa4spG68TFmB8UZQIxG/c+At4jkrcsfccUJJ1bvBG39IvNjUe0YB0Zdj3hXS9vX8TbC/dMVyjEjtv0KyiEkMMMqhZtMCwBdVLJHP2KUIPVapJW/6CmdK8fER/3HyykfoIi/sVehp68tfumT7rWaAsS19aw0qdjprZjaKXm/1LMTjKoRDmjS1flCk9c+J90BV7sq6m7SXJXpJI7pmy5vbgursWykzYs3ubTWoO4eOFwE06YzqNvJvDxyLL6fVZb9MYEMAmcTB7f3leccdZGPLv6RnXBMoOPMbcVE9Ugho/WkqmdYg7OaWy+/7ZRpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zB5X+n1hZZf4kq3HrGRwNGqDlne0LcdhzFmI0kGIiZM=;
 b=ZGSIDj88mWz5+TDk8JwUXoqqTkuX/JLLP4+jRN+y8RtUhnoUTpGuXSIylCNy7cZdrG7AEGrt5h6BHirFVh+87hpj6wtikmxTwsbDNeCDCH7f+PUfOrZ1WI6vjoNkzT1+SYYC7agkH2PeJ+wEPVu7huZBElw/f2E8hXSYpZINNmg=
Received: from AM0PR07MB4819.eurprd07.prod.outlook.com (20.178.19.14) by
 AM0PR07MB4291.eurprd07.prod.outlook.com (52.133.60.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.11; Fri, 23 Aug 2019 12:59:47 +0000
Received: from AM0PR07MB4819.eurprd07.prod.outlook.com
 ([fe80::3855:624c:a577:48dd]) by AM0PR07MB4819.eurprd07.prod.outlook.com
 ([fe80::3855:624c:a577:48dd%4]) with mapi id 15.20.2199.011; Fri, 23 Aug 2019
 12:59:47 +0000
From:   "Tilmans, Olivier (Nokia - BE/Antwerp)" 
        <olivier.tilmans@nokia-bell-labs.com>
To:     Dave Taht <dave.taht@gmail.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Olga Albisser <olga@albisser.org>,
        "De Schepper, Koen (Nokia - BE/Antwerp)" 
        <koen.de_schepper@nokia-bell-labs.com>,
        Bob Briscoe <research@bobbriscoe.net>,
        Henrik Steen <henrist@henrist.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v5] sched: Add dualpi2 qdisc
Thread-Topic: [PATCH net-next v5] sched: Add dualpi2 qdisc
Thread-Index: AQHVWMEa7eVJSJLM00ebRS7myTVOW6cHoFOAgAERIgA=
Date:   Fri, 23 Aug 2019 12:59:47 +0000
Message-ID: <20190823125130.4y3kcg6ghewghbxg@nokia-bell-labs.com>
References: <20190822080045.27609-1-olivier.tilmans@nokia-bell-labs.com>
 <CAA93jw5_LN_-zhHh=zZA8r6Zvv1CvA_AikT_rCgWyT8ytQM_rg@mail.gmail.com>
In-Reply-To: <CAA93jw5_LN_-zhHh=zZA8r6Zvv1CvA_AikT_rCgWyT8ytQM_rg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CH2PR14CA0038.namprd14.prod.outlook.com
 (2603:10b6:610:56::18) To AM0PR07MB4819.eurprd07.prod.outlook.com
 (2603:10a6:208:f3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=olivier.tilmans@nokia-bell-labs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [131.228.32.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 190c06a7-4b73-43dd-7c04-08d727c9c6ba
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR07MB4291;
x-ms-traffictypediagnostic: AM0PR07MB4291:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR07MB4291EED52036CC5C8E42CF8CE0A40@AM0PR07MB4291.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(189003)(199004)(386003)(14454004)(99286004)(6506007)(4326008)(5660300002)(6116002)(66446008)(3846002)(26005)(14444005)(256004)(6246003)(486006)(476003)(316002)(2906002)(64756008)(66556008)(66476007)(446003)(36756003)(54906003)(1076003)(102836004)(11346002)(6916009)(2616005)(25786009)(76176011)(52116002)(81156014)(86362001)(8676002)(81166006)(8936002)(6436002)(66066001)(6486002)(229853002)(478600001)(7416002)(7736002)(305945005)(186003)(71200400001)(71190400001)(66946007)(6512007)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR07MB4291;H:AM0PR07MB4819.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: nokia-bell-labs.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7vUjr86qEitIPDh8YTep8RiMP/O59wU0+rZe9HRH2gcXpl5OrOp4xH8zP34Z8NA+bFy3nnd2jrfOAsOkZj4uNdMzMzaUqJGiqJTIrkTTypBBtKeWN7GpyePg3whaaSq6yXIWfVcSW1Jjdu5meF7142bDHVc1U8tcCAgyYM/ArmToMSUryLaz7ilsyqR5U66tfwQr3dir7EeJKvU31u1cnTkQHWRtAd0OklX5+mZX06NCx+QWeUSWxaOSRlfXEMOJbEjd1LAd76hlMq3WdPUr38agKBuptMr5lNR9CYhoRqOa6gW7gl4QVXOdmZOfpiiIs/Hc6DguuMKWo0+VjlYhsIVxRu41mh+Ze2uWizpVtyYKm5ahOC17mYkqxeXyG2Dv/DPsQ0vJ1EhVrYK1tDMS5IcVX1E6iW/dybmUuAQlE/8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <326D8A2F7CE95544BA475EA5442975E0@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 190c06a7-4b73-43dd-7c04-08d727c9c6ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 12:59:47.6212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ni2h+5N0qG+AFfbhnxf2iXcrFzdrwLRwQMyboDzgfbQo3rc0bRQCH9IBJLNw0Idzjmxnv+pWRmLK4CZ/NGPkowqcMw+Y2mI22JOHVQ1EFWZVFA5gE56GNmFPgL+noJQs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB4291
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAxKSBTaW5jZSB3ZSdyZSBzdGlsbCBkdWtpbmcgaXQgb3V0IG92ZXIgdGhlIG1lYW5pbmcgb2Yg
dGhlIGJpdHMgLSBub3QNCj4ganVzdCB0aGUgU0NFIHRoaW5nLCBidXQgYXMgYmVzdCBhcyBJIGNh
bg0KPiB0ZWxsIChidXQgY291bGQgYmUgd3JvbmcpIHRoZSBOUUIgaWRlYSB3YW50cyB0byBwdXQg
c29tZXRoaW5nIGludG8gdGhlDQo+IGw0cyBmYXN0IHF1ZXVlPyBPciBpcyBOUUIgc3VwcG9zZWQg
dG8NCj4gYmUgYSB0aGlyZCBxdWV1ZT8NCg0KV2UgY2FuIGFkZCBzdXBwb3J0IGZvciBOUUIgaW4g
dGhlIGZ1dHVyZSwgYnkgZXhwYW5kaW5nIHRoZQ0KZHVhbHBpMl9za2JfY2xhc3NpZnkoKSBmdW5j
dGlvbi4gVGhpcyBpcyBob3dldmVyIG91dCBvZiBzY29wZSBhdCB0aGUNCm1vbWVudCBhcyBOUUIg
aXMgbm90IHlldCBhZG9wdGVkIGJ5IHRoZSBUU1YgV0cuIEknZCBndWVzcyB3ZSBtYXkgd2FudCBt
b3JlDQp0aGFuIGp1c3QgdGhlIE5RQiBEU0NQIGNvZGVwb2ludCBpbiB0aGUgTCBxdWV1ZSwgd2hp
Y2ggdGhlbiB3YXJyYW50DQphbm90aGVyIHdheSB0byBjbGFzc2lmeSB0cmFmZmljLCBlLmcuLCB1
c2luZyB0YyBmaWx0ZXIgaGludHMuDQoNCj4gSW4gdGhvc2UgY2FzZXMsIHRoZSBlY25fbWFzayBz
aG91bGQganVzdCBiZSBtYXNrLg0KDQpUaGF0IGlzIGFjdHVhbGx5IHdoYXQgaXQgaXMgYXQgdGhl
IG1vbWVudDogYSBtYXNrIG9uIHRoZSB0d28gZWNuIGJpdHMuDQoNCj4gMikgSXMgdGhlIGludGVu
dCB0byBtYWtlIHRoZSBkcm9wIHByb2JhYmlsaXR5IDAgYnkgZGVmYXVsdD8gKDEwIGluIHRoZQ0K
PiBwaWUgcmZjLCBub3QgbWVudGlvbmVkIGluIHRoZSBsNHMgcmZjIGFzIHlldCkNCg0KSSBhc3N1
bWUgeW91IGFyZSByZWZlcnJpbmcgdG8gwqc1LjEgb2YgdGhlIFBJRSBSRkMsIGkuZS4sIHRoZSBz
d2l0Y2ggdG8NCnB1cmUgZHJvcCBvbmNlIHRoZSBjb21wdXRlZCBtYXJraW5nIHByb2JhYmlsaXR5
IGlzID4xMCU/DQoNClRoZSBkZWZhdWx0IGZvciBkdWFscGkyIGlzIGFsc28gdG8gZW50ZXIgYSBw
dXJlLWRyb3AgbW9kZSBvbiBvdmVybG9hZC4NCk1vcmUgcHJlY2lzZWx5LCB3ZSBkZWZpbmUgb3Zl
cmxvYWQgYXMgcmVhY2hpbmcgYSBtYXJraW5nIHByb2JhYmlsaXR5IG9mDQoxMDAlIGluIHRoZSBM
IHF1ZXVlLCBtZWFuaW5nIGFuIGludGVybmFsIFBJIHByb2JhYmlsaXR5IG9mIDUwJSAoYXMgaXQN
CmdldHMgbXV0aXBsaWVkIGJ5IHRoZSBjb3VwbGluZyBmYWN0b3Igd2hpY2ggZGVmYXVsdHMgdG8g
MikuDQpUaGlzIGlzIGVxdWl2YWxlbnQgdG8gYSBQSUUgcHJvYmFiaWxpdHkgb2YgMjUlIChhcyB0
aGUgY2xhc3NpYyBxdWV1ZSBnZXRzIGEgDQpzcXVhcmVkIHByb2JhYmlsaXR5KS4NClRoaXMgZHJv
cCBtb2RlIG1lYW5zIHRoYXQgcGFja2V0cyBpbiBib3RoIHF1ZXVlcyB3aWxsIGJlIHN1YmplY3Qg
dG8NCnJhbmRvbSBkcm9wcyB3aXRoIGEgUEleMiBwcm9iYWJpbGl0eS4gQWRkaXRpb25hbGx5LCBh
bGwgcGFja2V0cyBub3QNCmRyb3BwZWQgaW4gdGhlIEwgcXVldWUgYXJlIENFIG1hcmtlZC4NCg0K
V2UgdXNlZCB0byBoYXZlIGEgcGFyYW1ldGVyIHRvIGNvbmZpZ3VyZSB0aGlzIG92ZXJsb2FkIHRo
cmVzaG9sZCAoSUlSQw0KaXQgd2FzIHN0aWxsIGluIHRoZSBwcmUtdjQgcGF0Y2hlcyksIGJ1dCBm
b3VuZCBubyByZWFsIHVzZSBmb3IgbG93ZXJpbmcNCml0LCBoZW5jZSBpdHMgcmVtb3ZhbC4NCg0K
Tm90ZSB0aGF0IHRoZSBkcm9wIG9uIG92ZXJsb2FkIGNhbiBiZSBkaXNhYmxlZCwgcmVzdWx0aW5n
IGluIGluY3JlYXNlZA0KbGF0ZW5jaWVzIGluIGJvdGggcXVldWVzLCAxMDAlIENFIG1hcmtpbmcg
aW4gdGhlIEwgcXVldWUsIGFuZCBldmVudHVhbGx5DQphIHRhaWxkcm9wIGJlaGF2aW91ciBvbmNl
IHRoZSBwYWNrZXQgbGltaXQgaXMgcmVhY2hlZC4NCg0KPiAzKSBoYXMgdGhpcyBiZWVuIHRlc3Rl
ZCBvbiBhIGh3IG1xIHN5c3RlbSBhcyB5ZXQ/ICgxMGdpZ0UgaXMgdHlwaWNhbGx5DQo+IDY0IHF1
ZXVlcykNCg0KWWVzLCBpbiBhIHNldHVwIHdoZXJlIDEvMzIvNjQvMTI4Vk1zIHdlcmUgYmVoaW5k
IGFuIEludGVsIFg1NDAtKiwgd2hpY2ggaW5kZWVkDQpoYXMgNjQgaW50ZXJuYWwgcXVldWVzLiBU
aGUgVk1zIHVzZSBhIG1peCBvZiBsb25nL3Nob3J0IGN1YmljL0RDVENQIGNvbm5lY3Rpb25zDQp0
b3dhcmRzIGFub3RoZXIgc2VydmVyLiBJIGNvdWxkIG5vdCB0aGluayBhYm91dCBhbm90aGVyIHVz
ZS1jYXNlIHdoZXJlIGEgMTBHDQpzb2Z0d2FyZSBzd2l0Y2ggd291bGQgcHJvdmUgdG8gYmUgYSBi
b3R0bGVuZWNrLCBpLmUuLCB3aGVyZSBhIHF1ZXVlIHdvdWxkDQpoYXBwZW4uDQpUaGUgcWRpc2Mg
aXMgaG93ZXZlciBub3Qgb3B0aW1pemVkIGZvciBtcSBzeXN0ZW1zLCBjb3VsZCBpdCBjYXVzZSBw
ZXJmb3JtYW5jZSANCmRlZ3JhZGF0aW9uIGlmIHRoZSBzZXJ2ZXIgd2FzIHNldmVyZWx5IHJlc291
cmNlIGNvbnN0cmFpbmVkPw0KDQpBbHNvLCBlbnN1cmluZyBpdCB3YXMgYWJsZSB0byBzYXR1cmF0
ZSAxMEcgbWVhbnQgZ3JvIHdhcyByZXF1aXJlZCBvbiB0aGUgDQpoeXBlcnZpc29yLCB0aHVzIHRo
YXQgdGhlIHN0ZXAgdGhyZXNob2xkIG9mIGR1YWxwaTIgaGFzIHRvIGJlIGluY3JlYXNlZCB0byAN
CmNvbXBlbnNhdGUgZm9yIHRob3NlIGxhcmdlIGJ1cnN0cy4gTWF5YmUgdGhhdCBpcyB3aGVyZSBi
ZWluZyBtcS1hd2FyZSB3b3VsZCANCmhlbHAsIGkuZS4sIGJ5IGluc3RhbnRpYXRpbmcgb25lIGR1
YWxwaTIgaW5zdGFuY2UgcGVyIEhXIHF1ZXVlPw0KVGhlIEFRTSBzY2hlbWUgaXRzZWxmIGlzIENQ
VSBmcmllbmRseSAobGlnaHRlciB0aGFuIFBJRSktLWkuZS4sIGNvbXB1dGluZyB0aGUNCnByb2Jh
YmlsaXR5IHRha2VzIDwxMCBhcml0aG1ldGljIG9wcyBhbmQgNSBjb21wYXJpc29ucyBvbmNlIGV2
ZXJ5IDE2bXMsIHdoaWxlDQplbnF1ZXVlL2RlcXVldWUgY2FuIGludm9sdmUgfjEwIGNvbXBhcmlz
b25zIGFuZCBhdCBtb3N0IDIgcm5nIGNhbGxzKS0tc28NCnNob3VsZCBub3QgaW5jcmVhc2UgdGhl
IGxvYWQgdG9vIG11Y2ggaXNzdWVzIGlmIGl0IHdhcyBkdXBsaWNhdGVkLg0KDQoNCkJlc3QsDQpP
bGl2aWVyDQo=
