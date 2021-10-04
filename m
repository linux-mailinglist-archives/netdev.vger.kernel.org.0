Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2940842179C
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhJDTfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:35:33 -0400
Received: from mail-eopbgr1410117.outbound.protection.outlook.com ([40.107.141.117]:6116
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232043AbhJDTfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:35:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNONfp5VzaR9q51yOSwhEYG1djpGKOXAhdwZd49q9lZMZl5jDId8YcweRHvQ1YQgocT14U/5Sik3Q0iiMNF+82paaczFtBjJwO5hwpaO+c0W2o2cpfRmCIbr1kt0S+jDeWRNolCIykbKPRoodyLQHZWN33ugvee0Cz7im0j3JSf0Pesat4wrV5iKWZ7wEGmOWVt/zOVBuGorNatS7ggr5gU9uAMtJHlX+TUwxpf0ri39a2021beMoS/I3MFM0swNkIAJFIBIqVC5kArxg1iT/KtK8pHVFLNHCv5Y5olebriu3NmSlQPQOEFT7iWLdhzHNGCbR7VFgUNG/0SSK8M93Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NgTaYKH9/ETnmgz+4rPjAS1EbGOPaD3PbCzwr8LJiE=;
 b=MPbz5Q5v23VnG0HK/0lES8NCMRp9bC/xWvg157JuEaKXZdVhB9rJhPtScIjYGTVfuJ/V8eukNi4MhZ6fAui0OcK17H5TxWn8udcR2q4xCRtASevTAOPRPQCH+SvGA5bjbQDpSc58BkRMK9fWzNqq9K5xOoKmryLtXnQVO2Db8S2KHKUZWZ1FCnjiokHR72LrgouUyH3opqOgvsaqFjiGlf6D1/7D65mN7jWEmZKFp37I99pPH1+qr+bB2IuU4WW/KXMBONv+fI4J7TD0SE7t6EhHaDgxadrybUDNkPmsHk4NO2IgEisAJQ/TaqUC1360Al1M+KRIO+9fG/5doBz17A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NgTaYKH9/ETnmgz+4rPjAS1EbGOPaD3PbCzwr8LJiE=;
 b=HT3VfWgTLL9FsxE4i6hFWjqCmer3jpu+lQQMeBHD/toaLMTii6ljxt4u4Y9lrXSSBWrhT9xSksykpC8ttDvDnq322H3ZK0q8cmfVKSIoRI44qBoZgX+9OqtqokfN24UaVyZjoFwhbbI6Dt4Ey0DdjZdfLfeY4F1Xrsi6Qj5VPw8=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5956.jpnprd01.prod.outlook.com (2603:1096:604:b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Mon, 4 Oct
 2021 19:33:40 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:33:40 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
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
Subject: RE: [PATCH 10/10] ravb: Initialize GbEthernet E-MAC
Thread-Topic: [PATCH 10/10] ravb: Initialize GbEthernet E-MAC
Thread-Index: AQHXttYI4a5ceI8hlUKdgFCw+KNoBavDNUAAgAAGlsCAAAJagIAAACzQ
Date:   Mon, 4 Oct 2021 19:33:40 +0000
Message-ID: <OS0PR01MB592256FA5BE63953936EB84386AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-11-biju.das.jz@bp.renesas.com>
 <9e7f271f-fc49-a85a-b790-af3a9bdc4be1@omp.ru>
 <OS0PR01MB5922AD9E0E01812FC4A11E1386AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <fc3cce12-e16b-41b2-1aeb-7ddc22e03e91@omp.ru>
In-Reply-To: <fc3cce12-e16b-41b2-1aeb-7ddc22e03e91@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25f0a654-1c74-452c-2dc7-08d9876dde75
x-ms-traffictypediagnostic: OS0PR01MB5956:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS0PR01MB5956CA364CDFEDE18D43136386AE9@OS0PR01MB5956.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cbjM5+NnxzrU0ilgAC5p70aRBfo/1BN8/n8qOrnyndSM6r8kgoKomybk21PWuDcKpmdlBygayR5QjQ8n0sPJScDxvX/tkkZDMT0xGdjshqmVV2cfYiszHFtnZvy8eFsv7mUJi0wLRa7mUmRW1En8a9LHZnkavRKQ9nCKG9AH/xNVIJ8yg7SALuX/IXcskWSLXHbf4Rw1QMWjUtZWNM8B03/xGs73h4j6XAXhNZiJwpA+xE4x7icIgTcrv5hfWr6uW7uPXyBvJw+/AE086PDI2LttahJ5q0E7GlcdhaMTU98waS6gg4eURwaIiqJZ1en0izfnjKq25t5B6knTdOdIu1v7HwbZdHBZpsa7dDq7Ey2/WmrpTXXJgvRkRZTgOoh1tnj4woNOzPUzfR3G/Hu9MXqGo91oLBGTOb8QT4jRuKa8zwqU+c32Zd7jbjlSTP9NGqRtC2Vl+IGLZuNdMvP6iPHcwYli3gUQK7RhMzfTeSl2t9mb65kiBhHEn7dnFCM7TEh8TzuObZR4H3Ydou26tVtIv3eQkKTuL0wEu1iRs6VDyw5DOnBxBqwycwH7Ul5u8UYTR8HP+NhbF3483B/zkaqC9uMPF1A+E++ZX+AIQ1HmcdjBVLhJut0Fwq2UHPSiyMRNqO3LWikpdzECxwzt8p3Uh2U6HyQCY14htWYgcIQEP0E0tGcfPr7u2FraVXFD6WTQfx8DjMmBf3XNaOiDyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(122000001)(107886003)(9686003)(8936002)(54906003)(110136005)(316002)(86362001)(33656002)(38070700005)(6506007)(53546011)(38100700002)(52536014)(64756008)(66446008)(66946007)(5660300002)(55016002)(8676002)(186003)(66556008)(2906002)(7416002)(71200400001)(83380400001)(26005)(66476007)(7696005)(508600001)(4326008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2x5UHlVQmJxb0JDb1FlOEpFS1BhZGtoaHY3U3NTZWlOMW1qOGdwUUJtM1lG?=
 =?utf-8?B?NjVpUnRMeXZQOUtsUFJQUUhYLzVEdUJuNjl3N3Z2OC9iTWE1VllFclBkdHVx?=
 =?utf-8?B?ckhjaXNqZXdxeXk4MldRd3hqdHVwUWpNOUVzTjlVUkFGeEEwZE5VL05vaGg4?=
 =?utf-8?B?TXViMlpzNUJDbU41QXMycUgxMm8zSDBIUGFlQ2djUjNVNWNGcUw3bDRtL0tn?=
 =?utf-8?B?Sit3ZS9VTDZxUUhoY1BwcW5kRE40OEtDU0dlY29nTzArUG9QQlM0SkdZNzJ5?=
 =?utf-8?B?NnBwSHg0SUlwY00yY0dBSHU3aE9lM0c1VFhpMDFuZFlnWVprbi9mS0N3TTdz?=
 =?utf-8?B?MWFJaWRKUGpYbktKWER1WlFaQ2YxY0RwWG5kaXFTMW9jQ1E5cElOQWRqbkto?=
 =?utf-8?B?eDR6UExCQ2tLNUhYdHlvYXd1ak8rQnRnTGI0aDBiK0ovS1BvcVZGWWV3Z29U?=
 =?utf-8?B?U01RTTJrcHFwWEJjSXRuazlGanpkM2I0ekl1QzNVdWVTWExmU2d4ejFTbVlh?=
 =?utf-8?B?cC9nR2ttdzN3YTUwZDBaTmJRREcxYUJ1bjJzWFBtdFNrdENVYlBxd0ZFdTZJ?=
 =?utf-8?B?ZFJwdDZZVmwvSjdPWHdRT0xqUnVkOWUxaHVyUDhwZ3UxWGpYZmpzRXM2MXZo?=
 =?utf-8?B?QTB6TlhTRVpYWWJSMjQrYldJNlhlRndhVUIveFViQXNKdHF5aGRIaWZUalZR?=
 =?utf-8?B?VE9Kc204anF1d0lJYzZ5ZjhveXduZHNzVGtDLzhCTWRZL29RS1dQNlNNVUZz?=
 =?utf-8?B?ODh6R0dOcnlwdVNzWXQwejI4YkFpdCtFL0dnZThEZytzU0p4NjJrVEJMNC9U?=
 =?utf-8?B?aHQyK2kxMDRzNmwrbXB1NVU2bUJlNS80a3JUL2FaNDRtT3B3T0NHT0d5MXdu?=
 =?utf-8?B?aHI4ZiswQjJvNzZCLzBCR2lPL0hDREFlQzBrZ2RGUlgwTnJHdE0vcmo3cjcy?=
 =?utf-8?B?aTFjMjRuMEhUV0JvUXl1R1paQzRlYVRkNVZwM2E1R3ZpR2JUbWQzZWdhR3Bh?=
 =?utf-8?B?S01UdnRjWnBOdVptYzY2emJ6elo0UXdhbEZ6VEltVGVhMFFQa2tJL213TS80?=
 =?utf-8?B?aTlITjlLdEtEclZQYnEwVlNaUDNNZGU2OHd4MGgxN2ZJdXJySURqbTBVRlk2?=
 =?utf-8?B?NWU3QVBONzNQMDF4RE8zZ3Q1UUIxN1plT3pVOHhFYy9wckwxc3VZYk1OT3Fk?=
 =?utf-8?B?bWsxemhSZXErWVUrMEEvcXpzZEtDTnFCUXpzWFpjajQ2djAvOHlkcm9wUlFk?=
 =?utf-8?B?dFYvd0kyNzZ1SzBWbDhxaHpHeTNOUGJkMGdjcDg4bzZOWU8vM3Nvb2lPbk43?=
 =?utf-8?B?a1VlS3VTR05zZVJ4Z3M4ZEdodkZISWlFbjhmYzc0RnF4ZVRab1FxeEswSFVZ?=
 =?utf-8?B?VUJEZjdnQUlhak5DeWlEZlNpZS9yQ2szK2JjR3cxaWJjQURoSG1BcGU0SFBK?=
 =?utf-8?B?cW1MMGdPazBkSko1K2E0TUlMZDRSZXJrRW9uUHU0UWxkbUZ2MVVrOGVzK1lr?=
 =?utf-8?B?MmFaakZkTkkrQkMzVWpqVGlGYkE2bC9DS3ZPNnhRQ1ltVjZCdzFZMjVvU292?=
 =?utf-8?B?bERTN3pmZ3piaTB0RGl1NW52OWR5Mk4rWmpiU0IveDE5QjA3VjhwSDIzckNB?=
 =?utf-8?B?Q0EzeHg3cVhBZEtTRVB5YXg5TFVIZjBpQVJqOFo2bWZCZ1hGT2wvbzcwTmhD?=
 =?utf-8?B?RzZqM1FNQ1FQbmJBSTREWGFuL3JXS3ZZcTZQL3JNQ0pncHJ4Mi9saWV1RUta?=
 =?utf-8?Q?5OSr1tPE6y3Vvnrfi8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25f0a654-1c74-452c-2dc7-08d9876dde75
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 19:33:40.1827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1jM+ocoaHO/5asoADywiBevwx3HEwwt4H9Xl1sEP9jtTl1Ql38YPMRUwNtVBPjgKB66OcCZ9l1hOZSWWGBLlmJwu1YYHK7+8d15VRyguyNQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5956
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VyZ2V5IFNodHlseW92
IDxzLnNodHlseW92QG9tcC5ydT4NCj4gU2VudDogMDQgT2N0b2JlciAyMDIxIDIwOjI4DQo+IFRv
OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+OyBEYXZpZCBTLiBNaWxsZXIN
Cj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3Jn
Pg0KPiBDYzogU2VyZ2VpIFNodHlseW92IDxzZXJnZWkuc2h0eWx5b3ZAZ21haWwuY29tPjsgR2Vl
cnQgVXl0dGVyaG9ldmVuDQo+IDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT47IFNlcmdleSBTaHR5
bHlvdiA8cy5zaHR5bHlvdkBvbXBydXNzaWEucnU+OyBBZGFtDQo+IEZvcmQgPGFmb3JkMTczQGdt
YWlsLmNvbT47IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFl1dXN1a2UgQXNoaXp1a2EN
Cj4gPGFzaGlkdWthQGZ1aml0c3UuY29tPjsgWW9zaGloaXJvIFNoaW1vZGENCj4gPHlvc2hpaGly
by5zaGltb2RhLnVoQHJlbmVzYXMuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgt
cmVuZXNhcy0NCj4gc29jQHZnZXIua2VybmVsLm9yZzsgQ2hyaXMgUGF0ZXJzb24gPENocmlzLlBh
dGVyc29uMkByZW5lc2FzLmNvbT47IEJpanUNCj4gRGFzIDxiaWp1LmRhc0BicC5yZW5lc2FzLmNv
bT47IFByYWJoYWthciBNYWhhZGV2IExhZCA8cHJhYmhha2FyLm1haGFkZXYtDQo+IGxhZC5yakBi
cC5yZW5lc2FzLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAxMC8xMF0gcmF2YjogSW5pdGlh
bGl6ZSBHYkV0aGVybmV0IEUtTUFDDQo+IA0KPiBPbiAxMC80LzIxIDEwOjIzIFBNLCBCaWp1IERh
cyB3cm90ZToNCj4gDQo+IFsuLi5dDQo+ID4+PiBJbml0aWFsaXplIEdiRXRoZXJuZXQgRS1NQUMg
Zm91bmQgb24gUlovRzJMIFNvQy4NCj4gPj4+IFRoaXMgcGF0Y2ggYWxzbyByZW5hbWVzIHJhdmJf
c2V0X3JhdGUgdG8gcmF2Yl9zZXRfcmF0ZV9yY2FyIGFuZA0KPiA+Pj4gcmF2Yl9yY2FyX2VtYWNf
aW5pdCB0byByYXZiX2VtYWNfaW5pdF9yY2FyIHRvIGJlIGNvbnNpc3RlbnQgd2l0aCB0aGUNCj4g
Pj4+IG5hbWluZyBjb252ZW50aW9uIHVzZWQgaW4gc2hfZXRoIGRyaXZlci4NCj4gPj4+DQo+ID4+
PiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+
ID4+PiBSZXZpZXdlZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJq
QGJwLnJlbmVzYXMuY29tPg0KPiA+Pj4gLS0tDQo+ID4+PiBSRkMtPnYxOg0KPiA+Pj4gICogTW92
ZWQgQ1NSMCBpbnRpYWxpemF0aW9uIHRvIGxhdGVyIHBhdGNoLg0KPiA+Pj4gICogc3RhcnRlZCB1
c2luZyByYXZiX21vZGlmeSBmb3IgaW5pdGlhbGl6aW5nIGxpbmsgcmVnaXN0ZXJzLg0KPiA+Pj4g
LS0tDQo+ID4+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmggICAgICB8IDIw
ICsrKysrKystLQ0KPiA+Pj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMgfCA1NQ0KPiA+Pj4gKysrKysrKysrKysrKysrKysrKystLS0tDQo+ID4+PiAgMiBmaWxlcyBj
aGFuZ2VkLCA2MiBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlvbnMoLSkNCj4gPj4+DQo+IFsuLi5d
DQo+ID4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21h
aW4uYw0KPiA+Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+
ID4+PiBpbmRleCAzZTY5NDczOGU2ODMuLjlhNDg4ODU0MzM4NCAxMDA2NDQNCj4gPj4+IC0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPj4+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPj4gWy4uLl0NCj4gPj4+
IEBAIC00NDksMTAgKzQ2MSwzNSBAQCBzdGF0aWMgaW50IHJhdmJfcmluZ19pbml0KHN0cnVjdCBu
ZXRfZGV2aWNlDQo+ID4+PiAqbmRldiwgaW50IHEpDQo+ID4+Pg0KPiA+Pj4gIHN0YXRpYyB2b2lk
IHJhdmJfZW1hY19pbml0X2diZXRoKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KSAgew0KPiA+Pj4g
LQkvKiBQbGFjZSBob2xkZXIgKi8NCj4gPj4+ICsJc3RydWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9
IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+Pj4gKw0KPiA+Pj4gKwkvKiBSZWNlaXZlIGZyYW1lIGxp
bWl0IHNldCByZWdpc3RlciAqLw0KPiA+Pj4gKwlyYXZiX3dyaXRlKG5kZXYsIEdCRVRIX1JYX0JV
RkZfTUFYICsgRVRIX0ZDU19MRU4sIFJGTFIpOw0KPiA+Pj4gKw0KPiA+Pj4gKwkvKiBQQVVTRSBw
cm9oaWJpdGlvbiAqLw0KPiA+Pg0KPiA+PiAgICAgU2hvdWxkIGJlOg0KPiA+Pg0KPiA+PiAJLyog
RU1BQyBNb2RlOiBQQVVTRSBwcm9oaWJpdGlvbjsgRHVwbGV4OyBUWDsgUlggKi8NCg0KV2h5IGRv
IHdlIG5lZWQgIjsiIGluIGJldHdlZW4/IEp1c3QgY2hlY2tpbmcgb3IgIjoiIGlzIHN1ZmZpY2ll
bnQgdGhyb3VnaG91dD8NCg0KPiA+Pg0KPiA+Pj4gKwlyYXZiX3dyaXRlKG5kZXYsIEVDTVJfWlBG
IHwgKChwcml2LT5kdXBsZXggPiAwKSA/IEVDTVJfRE0gOiAwKSB8DQo+ID4+PiArCQkJIEVDTVJf
VEUgfCBFQ01SX1JFIHwgRUNNUl9SQ1BUIHwNCj4gPj4+ICsJCQkgRUNNUl9UWEYgfCBFQ01SX1JY
RiB8IEVDTVJfUFJNLCBFQ01SKTsNCj4gPj4+ICsNCj4gPj4+ICsJcmF2Yl9zZXRfcmF0ZV9nYmV0
aChuZGV2KTsNCj4gPj4+ICsNCj4gPj4+ICsJLyogU2V0IE1BQyBhZGRyZXNzICovDQo+ID4+PiAr
CXJhdmJfd3JpdGUobmRldiwNCj4gPj4+ICsJCSAgIChuZGV2LT5kZXZfYWRkclswXSA8PCAyNCkg
fCAobmRldi0+ZGV2X2FkZHJbMV0gPDwgMTYpIHwNCj4gPj4+ICsJCSAgIChuZGV2LT5kZXZfYWRk
clsyXSA8PCA4KSAgfCAobmRldi0+ZGV2X2FkZHJbM10pLCBNQUhSKTsNCj4gPj4+ICsJcmF2Yl93
cml0ZShuZGV2LCAobmRldi0+ZGV2X2FkZHJbNF0gPDwgOCkgIHwgKG5kZXYtPmRldl9hZGRyWzVd
KSwNCj4gPj4+ICtNQUxSKTsNCj4gPj4+ICsNCj4gPj4+ICsJLyogRS1NQUMgc3RhdHVzIHJlZ2lz
dGVyIGNsZWFyICovDQo+ID4+PiArCXJhdmJfd3JpdGUobmRldiwgRUNTUl9JQ0QgfCBFQ1NSX0xD
SE5HIHwgRUNTUl9QRlJJLCBFQ1NSKTsNCj4gPj4+ICsNCj4gPj4+ICsJLyogRS1NQUMgaW50ZXJy
dXB0IGVuYWJsZSByZWdpc3RlciAqLw0KPiA+Pj4gKwlyYXZiX3dyaXRlKG5kZXYsIEVDU0lQUl9J
Q0RJUCwgRUNTSVBSKTsNCj4gPj4NCj4gPj4gICAgVG9vIG11Y2ggcmVwZXRpdGl2ZSBjb2RlLCBJ
IHRoaW5rLi4uDQo+ID4NCj4gPiBDYW4geW91IHBsZWFzZSBjbGFyaWZ5IHdoYXQgYXJlIHRoZSBj
b2RlcyByZXBldGl0aXZlIGhlcmU/DQo+IA0KPiAgICBNQUhSL01BTFIgcmVhZGluZywgbWFpbmx5
Li4uDQo+ICAgIFRoZSBmb2xsb3dpbmcgY29kZSB0dXJuZWQgb3V0IHRvIGJlIGRpZmZlcmVudCBm
cm9tIGdlbjIvMyBpbmRlZWQuLi4NCg0KSXQgaXMgT0suIE9ubHkgZm9yIGp1c3Qgc2F2aW5nIDIg
d3JpdGVzIHdlIGRvbid0IG5lZWQgdG8gaW50cm9kdWNlIGEgbmV3IGZ1bmN0aW9uLg0KDQpSZWdh
cmRzLA0KQmlqdQ0KDQoNCg0KPiANCj4gWy4uLl0NCj4gDQo+IE1CUiwgU2VyZ2V5DQo=
