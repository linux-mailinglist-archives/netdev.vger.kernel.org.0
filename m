Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CF04216BE
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbhJDSoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:44:03 -0400
Received: from mail-eopbgr1400123.outbound.protection.outlook.com ([40.107.140.123]:56960
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238815AbhJDSn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 14:43:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXsdob0rDi+5Ej8cnUutd8U4jMx5Sl2kco47adW/QOfenxd78MFFrkMHzJoANrqzNV1gKv85CeGXBfBv0xe2zpCOLsfXEUztqiWAiJhyIll+hx9PJ3EFbwuLYSYKoL9vHJBygNQ2q25d3zKywwlWNQxE4OCKMxGOPPJbfZJMZTCospPOWbd340liF4QJ+9fYuX6vj6Ee0P2ggNAEFEMOYMcmCDCaa5xT+b0Q5mLNzwNZX6zJxG7IiThgRAr7Pkz03gBrqUDIeThY43103zbT21UGkE0hyT7dpfU9li9m8urIUeFSdq3PWHlPhjI9W37aS3NNE8iQaKIwS+WjU76K4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWJxrkDAgdC094Pse3/4xh6I3tWZUXW103z1yy2nSX0=;
 b=KM6+A7BRjwDqMNzGEMyyxeqABZUOpZUMYaBT/9cIqG68ySyord6xAHPwUHPjT6kT/WEzPPu67tVxIzfOw5RXdgHEWktveKyA8gEsb8PtZQ1Cvzc/AeVMfHgPRbzQoF8cel/g8OLR7oiOfaQX1yiCKZdep+WVg/KwtEpOnxG1yCVnu+omE248xUnlvvt5peTXMPkLmANjkiBRN0XaA0Qv7zt2GerjGCT4uapEyk7Y/U+0jPkocWJybHuivCTbm0hK7/eOsUteMtcDHmOHcEbizlBPqPqhwhrG+EMjnjwxoD/8e1nZy5WhufDGM6rVAkkNHfqTyETjGff7gR5orlgpSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWJxrkDAgdC094Pse3/4xh6I3tWZUXW103z1yy2nSX0=;
 b=fWn8RB5RvcmGtzDhCM6Gfwy35YotimYMPSjqDWLpBul3VsiizNWbrq37R9oKOA5i8M0HcMI51FN/YUrdHUZLnMbsS6FIsUcWLSphOdklvPaktUdFNx7FOHwyU17Icm42OsvGvLeTAbZpeCminmxupSf5sd/0iDtk5CgD6NilOlM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2802.jpnprd01.prod.outlook.com (2603:1096:603:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Mon, 4 Oct
 2021 18:42:04 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 18:42:04 +0000
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
Subject: RE: [PATCH 05/10] ravb: Initialize GbEthernet DMAC
Thread-Topic: [PATCH 05/10] ravb: Initialize GbEthernet DMAC
Thread-Index: AQHXttX98IVMPc8eo06bCvpsOJ39GavCzDuAgAADyuCAADGHgIAAL6PA
Date:   Mon, 4 Oct 2021 18:42:04 +0000
Message-ID: <OS0PR01MB5922DA1ED378F730C3C6358286AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-6-biju.das.jz@bp.renesas.com>
 <58ca2e47-9c25-c394-51e5-067ebaa66538@omp.ru>
 <OS0PR01MB5922A72D9E04C359C64ACE4486AE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <fb9d4094-6458-f0b3-9e41-be5903f2800e@gmail.com>
In-Reply-To: <fb9d4094-6458-f0b3-9e41-be5903f2800e@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3b71a03-cdf1-4269-c9ea-08d98766a916
x-ms-traffictypediagnostic: OSAPR01MB2802:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB280299F5968E91E09343A34686AE9@OSAPR01MB2802.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YkxDHe4KhaGBn8kYYyJCr9r9TRDjZd4rFWNeXK3MmwJ0AVdIQ1jntdAHc8uXPCSxrzr+c08EgvQjH6eJpfad4asdOi3zMQF2dCW0Jl7RWUV07lddfaD4DLQqLwdjrJpQBp9W1E8yv2RZSnsh/uz9hWjhxXO+vUox0/nWbol+iP9S0X1lmPa+wsAuVy97EoK/SrYtUWwCQFjQ0QgS4eSpf7eZVNZGa9ajXxoq2pJ15dEXjqzN2dAcICiC8ErriQMZ88ULh42fXWY8k3/bjpkd3MB0QuseIKsf7xOIoDRsoWXSCaE2kPMwS4V0Ip85U7EKr4nFQx47YS4E+cBfvPzhEpsb6apRcDlegTJf4qN92DwC7VbxTEKyq4vjvDQuRMGnumbVxpakRvMh5JWRSkUTHZJH7Akicz3LA5cYs0vZj4IuLuB7ZDRAGnEoM1hFm2+lLhBk07HSfIM28JE+FEvaFftks2uAAw+WHE8m5yl0GadnuwndD/xTC3WP1BbwOQx2zwogjljjI5YP/JJCINWadBPQ86ScM1tsHupbEhIsdlGk9Y8IKlVlg/hcluOociCt7AOAr8X1cbhWDNHdP6vBSrG0jCS16O3XU6buZ/CDYzfkRh0oPGg0Eg3ploGxoocTfw6vDU5Zg7awGbOkTH4NIIrHn2qKORJcc2YsN1A2+jO+CtyTq1NRw9DL7S4PJB+U2700ZRiAydjFZwTW02bc2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(508600001)(8676002)(110136005)(33656002)(71200400001)(38070700005)(122000001)(6506007)(5660300002)(38100700002)(53546011)(55016002)(66476007)(7416002)(9686003)(7696005)(83380400001)(316002)(66446008)(66946007)(54906003)(66556008)(2906002)(64756008)(107886003)(8936002)(4326008)(52536014)(76116006)(86362001)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVVBZ2IvbXJrcmxweitXOTdsZmhhU2Y5ZklFRkRrMXJxRDkvekxVRXU4Wmgz?=
 =?utf-8?B?K2tSUVJDQnhPRTVObkZmTjdpYmp6ZEdWL0hvdUFFWUlIVjdJTTgwQW16RExn?=
 =?utf-8?B?TWgzWWZ3aFMzZFc4dWh5ZFQrREwxbnh6a0xwSXI0dk5ONE1xbXB6aVJUUFBr?=
 =?utf-8?B?SXRZYTBROUNCZUw2dnVaWnYrOGtsaWh5bDNVZkNVeXd6REl5MkIzc1JFbWxO?=
 =?utf-8?B?UFd3Rk9zeG1WdVVqcVR6enRibXhua21kd0dObnBYdVRsMkJjclcxYVBENWpL?=
 =?utf-8?B?aHNvcXM2T3d4ZDd2Si92cnozMmpiQWw5aytWZzMrVHB4TVQ5a2dzcDh4Zzkr?=
 =?utf-8?B?NWIwSzhPeWkyd0ZZZnArRFdQN3NqU1ZiYnRucXRiVjJId3BIcXp6T3NsMU1l?=
 =?utf-8?B?aU1OQ245VmxMZHd4THczWTFPUjRzdG9pb0hMWUpRZjB6cmo4ekN0UmpLcFV5?=
 =?utf-8?B?WkZzUFJLMysrMlR5UDdJNEp5dlFEUW1jMm9FQXQ5RDB4MDFiOEVxYlhTV1Yx?=
 =?utf-8?B?czkycGZ3M3lMa29OVURxT25ndG03TndaSXVrRjRqOFBMRkxGdHVGN1o1Nk1t?=
 =?utf-8?B?dzFYNGNsUFdRVkxPQllDQUk2WTMwZUMvUkZ5Z0RuSlB3YmYwKzg0K2tybnpY?=
 =?utf-8?B?QzkrT1VLOUNHdzR5VVJjSXNFYUhWWGhPTG9ieFFQUklubTk3dllGakRuV1hO?=
 =?utf-8?B?UGxYVzRYYTF0VFd0RTROTXYxNkYxcHZDaHpaTlZxVXJIeU1iRU00bzFKSnMz?=
 =?utf-8?B?Mnc5VG1qUDhEalhIc1dNWDlxYndTUEtRa2cxOFlpWlBJdG9sUkpJdzh2TFRY?=
 =?utf-8?B?SWRvNjhHVkpKSTJDUXYzclVURE5qM1kvbCs3aUROZTRJRjVwYlZkdmU4ckJ6?=
 =?utf-8?B?SHJNMHdsT1BnRjhtVGxPSnVuM1BjZFlLQ3lCUGZCaWxVd05aaGxJRTJEbjg0?=
 =?utf-8?B?emxpWE0wTnFwTHh4RzhLRTBCMWgvb3cxMS94YmxOT242czNDdGg5VVA2czIz?=
 =?utf-8?B?RkxIZmduVDYvODBTT3p3Q3JsNk5EdXQvYSthVC9LNUkwVS9FcWFTWmdvUmVS?=
 =?utf-8?B?NEdvYjVSNHBWZlFXb3B4N0JSRmJoVGxCY2U1SFRFMlZEYkJrZGJzRnIvS2VF?=
 =?utf-8?B?VVNzcjFKZjBYNkFUckZGdzVISWx4M0c4NWFVZSt2YmEyQ2ptQzVZd3lIaTVt?=
 =?utf-8?B?dkx1R0dZMFFoN0t2VmpkZHV0d2plTUxTQ0NUTTk1dmRiUWRjbHZEbkJqYm8w?=
 =?utf-8?B?bTNyWjFkVVJvUFpVR2kxbWtIQzBkK05QbkwyQ2dYOWlSMnVNTWJsVXl3YXhS?=
 =?utf-8?B?OXRMY1oyeFE2VmJ2VVNGQjJBdWZSSHh3OUFBMkxhMXYwZUwvSWdGZGk0R3Jh?=
 =?utf-8?B?MFNENzdXRTd4cUs0Z0pVKzZMWXdQZ1kzZ0xabCthaHNJaXdkZGR6ODR1OU9a?=
 =?utf-8?B?QVI2MC9MWVdicXNjZERqWkcwZWFRaVQ2K0xEQytDWjJFNHZoQUdETUs3VEw1?=
 =?utf-8?B?eG1lS2FKZUxNV2tHZ0QvNmlpYlIrRG9oMWRwQTRQcTFnUENOVk1DZ1VnR2x3?=
 =?utf-8?B?MDEyUkRVY0V2L3dXZ0lmVHZ3VkYwMVpHYzFzQkpGbjJ6WnIxc0pjeG5kZzI1?=
 =?utf-8?B?d2sxUXU1NGc5enZzbUQ5VTRBbko4bWJGcmdzY3g2YTVIc2hWMWh5Y0VuZTBh?=
 =?utf-8?B?WkxkeEhXaDRuWHlPSmllR3hQdTdKRVcvNUdjY1YrYjRJaERyUUlubGI1azk0?=
 =?utf-8?Q?fGGvxK6w4GF6D6rY30=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3b71a03-cdf1-4269-c9ea-08d98766a916
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 18:42:04.0742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y5aVXQYOq6zfXYC3v0XzDakmwIn2ibW6jIC0OXQaYpBiCuRzTc9rs7MOehBc87aIT/NIrC/1t00on1wqLVvYvi7QUAkOvQ1BUCsQkIh76R8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2802
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VyZ2VpIFNodHlseW92
IDxzZXJnZWkuc2h0eWx5b3ZAZ21haWwuY29tPg0KPiBTZW50OiAwNCBPY3RvYmVyIDIwMjEgMTY6
NTENCj4gVG86IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT47IFNlcmdleSBT
aHR5bHlvdg0KPiA8cy5zaHR5bHlvdkBvbXAucnU+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraQ0KPiA8a3ViYUBrZXJuZWwub3JnPg0KPiBDYzog
R2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT47IFNlcmdleSBTaHR5
bHlvdg0KPiA8cy5zaHR5bHlvdkBvbXBydXNzaWEucnU+OyBBZGFtIEZvcmQgPGFmb3JkMTczQGdt
YWlsLmNvbT47IEFuZHJldyBMdW5uDQo+IDxhbmRyZXdAbHVubi5jaD47IFl1dXN1a2UgQXNoaXp1
a2EgPGFzaGlkdWthQGZ1aml0c3UuY29tPjsgWW9zaGloaXJvDQo+IFNoaW1vZGEgPHlvc2hpaGly
by5zaGltb2RhLnVoQHJlbmVzYXMuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgt
DQo+IHJlbmVzYXMtc29jQHZnZXIua2VybmVsLm9yZzsgQ2hyaXMgUGF0ZXJzb24gPENocmlzLlBh
dGVyc29uMkByZW5lc2FzLmNvbT47DQo+IEJpanUgRGFzIDxiaWp1LmRhc0BicC5yZW5lc2FzLmNv
bT47IFByYWJoYWthciBNYWhhZGV2IExhZA0KPiA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJw
LnJlbmVzYXMuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDA1LzEwXSByYXZiOiBJbml0aWFs
aXplIEdiRXRoZXJuZXQgRE1BQw0KPiANCj4gT24gMTAvNC8yMSA0OjEyIFBNLCBCaWp1IERhcyB3
cm90ZToNCj4gDQo+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMDUvMTBdIHJhdmI6IEluaXRpYWxp
emUgR2JFdGhlcm5ldCBETUFDDQo+ID4+DQo+ID4+IEhlbGxvIQ0KPiA+Pg0KPiA+PiBPbiAxMC8x
LzIxIDY6MDYgUE0sIEJpanUgRGFzIHdyb3RlOg0KPiA+Pg0KPiA+Pj4gSW5pdGlhbGl6ZSBHYkV0
aGVybmV0IERNQUMgZm91bmQgb24gUlovRzJMIFNvQy4NCj4gPj4+DQo+ID4+PiBTaWduZWQtb2Zm
LWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4+PiBSZXZpZXdl
ZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMu
Y29tPg0KPiA+Pj4gLS0tDQo+ID4+PiBSRkMtPnYxOg0KPiA+Pj4gICogUmVtb3ZlZCBSSUMzIGlu
aXRpYWxpemF0aW9uIGZyb20gRE1BQyBpbml0LCBhcyBpdCBpcw0KPiA+Pj4gICAgc2FtZSBhcyBy
ZXNldCB2YWx1ZS4NCj4gPj4NCj4gPj4gICAgSSdtIG5vdCBzdXJlIHdlIGRvIGEgcmVzZXQgZXZl
cnl0aW1lLi4uDQo+ID4+DQo+ID4+PiAgKiBtb3ZlZCBzdHVicyBmdW5jdGlvbiB0byBlYXJsaWVy
IHBhdGNoZXMuDQo+ID4+PiAgKiByZW5hbWVkICJyZ2V0aCIgd2l0aCAiZ2JldGgiDQo+ID4+PiAt
LS0NCj4gPj4+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgIDMg
KystDQo+ID4+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDMw
DQo+ID4+PiArKysrKysrKysrKysrKysrKysrKysrKy0NCj4gPj4+ICAyIGZpbGVzIGNoYW5nZWQs
IDMxIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4+Pg0KPiA+PiBbLi4uXQ0KPiA+
Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMN
Cj4gPj4+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+Pj4g
aW5kZXggZGM4MTdiNGQ5NWExLi41NzkwYTkzMzJlN2IgMTAwNjQ0DQo+ID4+PiAtLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+PiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+PiBAQCAtNDg5LDcgKzQ4OSwz
NSBAQCBzdGF0aWMgdm9pZCByYXZiX2VtYWNfaW5pdChzdHJ1Y3QgbmV0X2RldmljZQ0KPiA+Pj4g
Km5kZXYpDQo+ID4+Pg0KPiA+Pj4gIHN0YXRpYyBpbnQgcmF2Yl9kbWFjX2luaXRfZ2JldGgoc3Ry
dWN0IG5ldF9kZXZpY2UgKm5kZXYpICB7DQo+ID4+PiAtCS8qIFBsYWNlIGhvbGRlciAqLw0KPiA+
Pj4gKwlpbnQgZXJyb3I7DQo+ID4+PiArDQo+ID4+PiArCWVycm9yID0gcmF2Yl9yaW5nX2luaXQo
bmRldiwgUkFWQl9CRSk7DQo+ID4+PiArCWlmIChlcnJvcikNCj4gPj4+ICsJCXJldHVybiBlcnJv
cjsNCj4gPj4+ICsNCj4gPj4+ICsJLyogRGVzY3JpcHRvciBmb3JtYXQgKi8NCj4gPj4+ICsJcmF2
Yl9yaW5nX2Zvcm1hdChuZGV2LCBSQVZCX0JFKTsNCj4gPj4+ICsNCj4gPj4+ICsJLyogU2V0IEFW
QiBSWCAqLw0KPiA+Pg0KPiA+PiAgICBBVkI/IFdlIGRvbid0IGhhdmUgaXQsIGRvIHdlPw0KPiA+
DQo+ID4gR29vZCBjYXRjaC4gSSBXaWxsIHVwZGF0ZSB0aGUgY29tbWVudCBpbiBuZXh0IFJGQyBw
YXRjaC4NCj4gDQo+ICAgIFRoYXQncyB0cmlmbGVzLCBub3Qgd29ydGggYSBwYXRjaCBvbiBpdHMg
b3duLi4uDQo+IA0KPiA+Pg0KPiA+Pj4gKwlyYXZiX3dyaXRlKG5kZXYsIDB4NjAwMDAwMDAsIFJD
Uik7DQo+ID4+DQo+ID4+ICAgIE5vdCBldmVuIFJDUi5FRkZTPyBBbmQgd2hhdCBkbyBiaXRzIDI5
Li4zMCBtZWFuPw0KPiA+DQo+ID4gUlovRzJMIEJpdCAzMSBpcyByZXNlcnZlZC4NCj4gPiBCaXQg
MTY6MzAgUmVjZXB0aW9uIGZpZm8gY3JpdGljYWwgbGV2ZWwuDQo+ID4gQml0IDE1OjEgcmVzZXJ2
ZWQNCj4gPiBCaXQgMCA6IEVGRlMNCj4gPg0KPiA+IEkgYW0gbm90IHN1cmUsIHdoZXJlIGRvIHlv
dSBnZXQgMjkuLjMwPyBjYW4geW91IHBsZWFzZSBjbGFyaWZ5Lg0KPiANCj4gICAgMHg2MDAwMDAw
MCBoYXMgYml0cyAyOS4uMzAgc2V0IGFuZCBnZW4zIG1hbnVhbCBoYXMgdGhlc2UgYml0cyByZXNl
cnZlZC4NCk9LLg0KDQo+IA0KPiA+PiBbLi4uXQ0KPiA+Pj4gKwkvKiBTZXQgRklGTyBzaXplICov
DQo+ID4+PiArCXJhdmJfd3JpdGUobmRldiwgMHgwMDIyMjIwMCwgVEdDKTsNCj4gPj4NCj4gPj4g
ICAgRG8gVEJEPG4+IChvdGhlciB0aGFuIFRCRDApIGZpZWxkcyBldmVuIGV4aXN0Pw0KPiA+DQo+
ID4gT25seSBUQkQgKEJpdCA4Li45KSBpcyBhdmFpbGFibGUgdG8gd3JpdGUsDQo+IA0KPiAgICBU
aG91Z2h0IHNvISA6LSkNCj4gDQo+ID4gcmVzdCBhbGwgYXJlIHJlc2VydmVkIHdpdGggcmVtYWlu
aW5nIHZhbHVlcyBhcyBpbiAiMHgwMDIyMjIwMCINCj4gDQo+ICAgT2gsIHNvIHRoZSBkZWZhbHV0
cyBhcmUgdGhlIHNtZSBvbiBSWi9HMkwsIGRlc3BpdGUgb25seSAxIFRYIHF1ZXVlPw0KDQpZZXAu
DQoNCj4gDQo+ID4gUmVnZHMsDQo+ID4gQmlqdQ0KPiANCj4gTUJSLCBTZXJnZXkNCg==
