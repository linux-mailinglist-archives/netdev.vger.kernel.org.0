Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D1A32C3D8
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbhCDAIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:08:05 -0500
Received: from mail-am6eur05on2044.outbound.protection.outlook.com ([40.107.22.44]:32545
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351067AbhCCGRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 01:17:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nC9v1njN8ncHr31spDE53ua2NAqhOPPTgqSKjswGZmbczre/Isg2WrU+/gdfzQyXeAcqa0GxGR2fQXl8MwfJfoIrt9O6b8VLS7zi7QvYhueCjMrIrE7uxsSYn39+0mTLTMnd1IGCR2/8eWXxeFvlH1IRcbp0q/bqIqkgRh/PncVV3ro38nLoP4s3M5PDvmP6OmFuwfFcOFIfERHq1lDbH6eY4cb7cjl+lR/mucuzlLD3/3lszsLUCgRTT+LUZmCtgnoJHlk2tloSgDyx+lT764w1LW4GxluDlopmxsiClVOwaRrCEnrnazCvpu6rgyX7wfoyg+4aAHMlzzAls/MJAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WotuXV6XwwJT38JPtCF3ZFfYkVkVN08bUKr5Vwc93B4=;
 b=R03VTbIXO23sZKRZ903vE4PuqmWKIpxLXzuuMcipIRfK5zUvGKvOZzG+6xqjPYQ/Jx0SXLQCu7wtLsW4gc6MMuiJnnqnIH57YDVIJdgL30kJO2J3BuEIFgForIdrh1+Kmx0XDp3kTgFzUcJP5cEogBX4VjshmPLmswjsExmeMIZFCK7UApJuiTjaUO0vEcSBJArpXqrGXfM9R3roSt2LTkXjus3hx4b6lAzvKrU9F6S68zHRFEcQeAuKcjyie8Fc9lFFqI8hdSubMSHAo6Ifd/nkahV0y/GBfjSooHjluwcJX40nz9GdAkpPzNi95Ft3YBxoGVPIHEqUUiCx/hyxWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WotuXV6XwwJT38JPtCF3ZFfYkVkVN08bUKr5Vwc93B4=;
 b=gA2QpoxQ3xXo5DL9QAcjv7Ns7q5sHakQcEYKs+w+tUV9zwfq1JsZRtsG/GUMwS99+aqHV6oOEAyHqMhDORrjipVscH9i3pKrdkKflHHmvUp7hTkqfm+Ohhu0gw5WJYvUoCQP3uLvAigoaeW3/3Sbos6lfJcc+1AUIfyGIW2Xky8=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5883.eurprd04.prod.outlook.com (2603:10a6:10:b1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Wed, 3 Mar
 2021 06:16:14 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 06:16:14 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "ramesh.babu.b@intel.com" <ramesh.babu.b@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: RE: [PATCH net 1/1] net: stmmac: fix incorrect DMA channel intr
 enable setting of EQoS v4.10
Thread-Topic: [PATCH net 1/1] net: stmmac: fix incorrect DMA channel intr
 enable setting of EQoS v4.10
Thread-Index: AQHXD/C+19WPBcYm1keXTedu0UOCm6pxyWpg
Date:   Wed, 3 Mar 2021 06:16:14 +0000
Message-ID: <DB8PR04MB67950628B6E44EF47E61CB22E6989@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210303150840.30024-1-ramesh.babu.b@intel.com>
In-Reply-To: <20210303150840.30024-1-ramesh.babu.b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c7331495-ea49-4341-fd91-08d8de0bd92a
x-ms-traffictypediagnostic: DB8PR04MB5883:
x-microsoft-antispam-prvs: <DB8PR04MB58837289D6B14C46226B183CE6989@DB8PR04MB5883.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EeCgiIssvVmgEzVBS2l4j8hb3gVwANTmNaxROA1r8lxycayFl2L54MYJaLHN56Caqx1Hr1WI8uxxnxgh7mitL+MgTHkPefr/lYE4HKsj7DqLRZuYJptFemNUwi4721/RCXpVrPfFIfDpFWtrYogjL3Ar50WH3bZfbb8TsOsIqcekzLKsvjd7wLizguZELvs226uvY3q/Luhh5TtahI8v4mX1RutF/xc8fYPwZugyZiLy8jOE1Ka/LwY1UILW3aYjhHD4bwWXMrERQpq+/0PUNe7dPfrEimLk/axEdpZLH2dcSX7tEjkZjIfDXpjkmjk7dafW8PzefqCXvOh/D9t44Y79hb2LPzpeY5db7bP4/qBFyHCz4CX/0W0hDmPS2092zRPlj4d+1NLZVb3K8FFi5Te85SlkuNxTJY5zxnWF2+cPjjgCq32IaXkOWwurs/0aEuN3wTO1ORRYlowXB6Hr2wKxf0v3HzjCdFanrR633eWOfUd7HQSkXmWu2EdgU2+Gyvva43bGFJ9VG+iyyVQviQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(64756008)(66476007)(66446008)(26005)(7696005)(33656002)(4326008)(53546011)(186003)(6506007)(2906002)(66556008)(76116006)(52536014)(5660300002)(86362001)(66946007)(478600001)(9686003)(110136005)(83380400001)(54906003)(8676002)(7416002)(8936002)(71200400001)(55016002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?cUs4VTJLdFJ6Mk8xUzZ6ZE5MNEpsWTVLdGZ2TFY4VmRDWVBsVXY1MVY5eUdW?=
 =?gb2312?B?WHRTU3pKcUg1bWVuZWkydTN1UzJkMk9SelFzQWJadzQ2MVRUZ0ZIb29UdGlk?=
 =?gb2312?B?V1NYZ0VMNFB3cEJtenJjM2ZHN0NOYXhDcy84d1lVWktML3hiNFJXdmdvU012?=
 =?gb2312?B?dGtXcHk5M0VPSEIvOFJXa1RLZkZOQkVBcmc5SmFQL0ZLM1dZcVVPVlI5akVB?=
 =?gb2312?B?b0RWQVRvN3RLVkM0bnZwb0RkVkkvVVZ5MFc3OC9OMFg3MFFCWFVnckNLRXI0?=
 =?gb2312?B?SU9zYVlhMXh1SWJZenk2OExzdlRXb2YraS9BTE1lQW8zeHlmbU5pdVUxRE4r?=
 =?gb2312?B?NFZnY1RTV3NCd0E0M1ZLVlhmNjVkYVhGVmpJUHVrVGhsMSt6d2xSdVg0dUpk?=
 =?gb2312?B?aTdlRG9ERWltM00wK2FhcjFiRkJKSnJmUkhnYjlXd2kvSVNCMzZFa1RDUExp?=
 =?gb2312?B?cGZnTWFvRmd1dkFyWVp3TVlWYi9rRWxteVBqcUhOK3orNmdQeW13Uzc1bitQ?=
 =?gb2312?B?QzF2Zkc4WWpVM3NpWU1EQUJDTEFGVHFUNVFlU3pUL3ZwY2UyL2krUzZGSVRD?=
 =?gb2312?B?NTBvbVNibEJYVGdlTURDM0E1ZFFTMDdSbGZKOTBUWktGZ2NnbzNJNXZqQkVu?=
 =?gb2312?B?WXdjeWE4S3B0QXZ6REsxZkpmLzZVVk1KditUQm5McWZWUVdSZ2JDNWk1bFha?=
 =?gb2312?B?eEpPV0FKcVVWODNpSDJTUnh4MmgxaVl5NnhFODhkbzB0TXkrUXpGZ01yS04x?=
 =?gb2312?B?MFl0QlkrSHZ2WE9XVmR1djFxOXFidzBvS3B0b2lKMDFsVG5kU3RURnRaYWRr?=
 =?gb2312?B?NkdPOEdFRWNGUjZhNHNJVGNpdVk5UHcwNzZsWHVpVWtVMUR5d2hHOEtNVEJE?=
 =?gb2312?B?VTRlNFM5dzV0cFNjTnFlc0wwbHNMSksvRmh6WGxOZ3VFaGcxak92Vk5SZnVp?=
 =?gb2312?B?WFBDQ24xdXZ5R3BLZ1pveWRKWVV1NXQvTGtGUGFmVTA5Y0lDa1I2RjdLNkxy?=
 =?gb2312?B?OVNDTzVUS21mN0N3aGlMNWdOVHpuTEFweGZuSjhtUStvOVNNbGZZMGJMbzZY?=
 =?gb2312?B?eXUzL0JqelMxZFZWZHowSCtkQ0JPWExzUjlESEx6OG9UTC94R2RjVTdYWEt1?=
 =?gb2312?B?cUpDaUdPcFZSclRPY2E4TlJDRVlWdU11eDJtczc4NUtyaHprcXM4cEJMNXJG?=
 =?gb2312?B?cWZYclMxQ0dBZ0poTzI2Nm5MektvLzR4ZnJKUXdxblFjeGxNalI4VE5tMk54?=
 =?gb2312?B?U05aQUNXV3c2elpSQzBMRnBWd28xU0wwaXMxSllpOTV0Y0h3YVNwZWE0RXk2?=
 =?gb2312?B?MytiRm9IOGk5NE1JS2VNYmdRK0swN1NNT2FZSktHaUZzUFNTWmxDMVh4TGF0?=
 =?gb2312?B?anM3eDBUR2FQMGZhaEdwT29tdkhRYmdoQkwxeW13cmZxckswUjQwVW5KNFl5?=
 =?gb2312?B?UDJ1Q2lZVlRLVXIwaW5zZktSdWFncGxTVDAvZU9sRm56dFJBbjdGdjE0bkVL?=
 =?gb2312?B?OWkzeVYyNjRvc045V0VPem91MGRJbEJFQXROaUtlb1JBSEN1dFhQM3lDVEw5?=
 =?gb2312?B?cXJxRERlOTRiS0VqQzBONkxnV1hVcW1kSndHc1M5L2Z0UkthNU9kenpWUDFJ?=
 =?gb2312?B?QzVqNVV4bTIzR3djVWFRbE9nU1BkRnVDa3FFVzJPZk5TcDk1UC9PUWdyR3ZT?=
 =?gb2312?B?L2ZaNW5yZ1lYdS9YdE5XMlNzUWxRU203MFZ2UHh2ZDhOaVhicCt2Q2sxN3hj?=
 =?gb2312?Q?kNHoS81rlMGLzGcShy93HCfrtU3pVEKb8wnSzNr?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7331495-ea49-4341-fd91-08d8de0bd92a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 06:16:14.2136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OzsDM7U/a2uNsAzRmvtvEXqVGyQCIYVIdwG7AkoRdUqT1zxCXrw3rMqp2aArW+fE4KULJYtBhKsaDCyTA31ZGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5883
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IHJhbWVzaC5iYWJ1LmJAaW50
ZWwuY29tIDxyYW1lc2guYmFidS5iQGludGVsLmNvbT4NCj4gU2VudDogMjAyMcTqM9TCM8jVIDIz
OjA5DQo+IFRvOiBHaXVzZXBwZSBDYXZhbGxhcm8gPHBlcHBlLmNhdmFsbGFyb0BzdC5jb20+OyBB
bGV4YW5kcmUgVG9yZ3VlDQo+IDxhbGV4YW5kcmUudG9yZ3VlQHN0LmNvbT47IEpvc2UgQWJyZXUg
PGpvYWJyZXVAc3lub3BzeXMuY29tPjsgRGF2aWQgUyAuDQo+IE1pbGxlciA8ZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBNYXhpbWUNCj4gQ29x
dWVsaW4gPG1jb3F1ZWxpbi5zdG0zMkBnbWFpbC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1zdG0zMkBzdC1tZC1tYWlsbWFuLnN0b3JtcmVwbHkuY29tOw0KPiBsaW51
eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmc7IE9uZyBCb29uDQo+IExlb25nIDxib29uLmxlb25nLm9uZ0BpbnRlbC5jb20+OyBWb29u
IFdlaSBGZW5nDQo+IDx3ZWlmZW5nLnZvb25AaW50ZWwuY29tPjsgV29uZyBWZWUgS2hlZSA8dmVl
LmtoZWUud29uZ0BpbnRlbC5jb20+Ow0KPiBSYW1lc2ggQmFidSBCIDxyYW1lc2guYmFidS5iQGlu
dGVsLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIG5ldCAxLzFdIG5ldDogc3RtbWFjOiBmaXggaW5j
b3JyZWN0IERNQSBjaGFubmVsIGludHIgZW5hYmxlDQo+IHNldHRpbmcgb2YgRVFvUyB2NC4xMA0K
PiANCj4gRnJvbTogT25nIEJvb24gTGVvbmcgPGJvb24ubGVvbmcub25nQGludGVsLmNvbT4NCj4g
DQo+IFdlIGludHJvZHVjZSBkd21hYzQxMF9kbWFfaW5pdF9jaGFubmVsKCkgaGVyZSBmb3IgYm90
aCBFUW9TIHY0LjEwIGFuZA0KPiBhYm92ZSB3aGljaCB1c2UgZGlmZmVyZW50IERNQV9DSChuKV9J
bnRlcnJ1cHRfRW5hYmxlIGJpdCBkZWZpbml0aW9ucyBmb3IgTklFDQo+IGFuZCBBSUUuDQo+IA0K
PiBGaXhlczogNDg4NjNjZTU5NDBmICgic3RtbWFjOiBhZGQgRE1BIHN1cHBvcnQgZm9yIEdNQUMg
NC54eCIpDQo+IFNpZ25lZC1vZmYtYnk6IE9uZyBCb29uIExlb25nIDxib29uLmxlb25nLm9uZ0Bp
bnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFJhbWVzaCBCYWJ1IEIgPHJhbWVzaC5iYWJ1LmJA
aW50ZWwuY29tPg0KDQpSZXZpZXdlZC1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdA
bnhwLmNvbT4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IC0tLQ0KPiAgLi4uL25l
dC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYzRfZG1hLmMgIHwgMTkNCj4gKysrKysrKysr
KysrKysrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0
bW1hYy9kd21hYzRfZG1hLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1h
Yy9kd21hYzRfZG1hLmMNCj4gaW5kZXggYmIyOWJmY2Q2MmMzLi42MmFhMGU5NWJlYjcgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjNF9kbWEu
Yw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYzRfZG1h
LmMNCj4gQEAgLTEyNCw2ICsxMjQsMjMgQEAgc3RhdGljIHZvaWQgZHdtYWM0X2RtYV9pbml0X2No
YW5uZWwodm9pZCBfX2lvbWVtDQo+ICppb2FkZHIsDQo+ICAJICAgICAgIGlvYWRkciArIERNQV9D
SEFOX0lOVFJfRU5BKGNoYW4pKTsgIH0NCj4gDQo+ICtzdGF0aWMgdm9pZCBkd21hYzQxMF9kbWFf
aW5pdF9jaGFubmVsKHZvaWQgX19pb21lbSAqaW9hZGRyLA0KPiArCQkJCSAgICAgIHN0cnVjdCBz
dG1tYWNfZG1hX2NmZyAqZG1hX2NmZywgdTMyIGNoYW4pIHsNCj4gKwl1MzIgdmFsdWU7DQo+ICsN
Cj4gKwkvKiBjb21tb24gY2hhbm5lbCBjb250cm9sIHJlZ2lzdGVyIGNvbmZpZyAqLw0KPiArCXZh
bHVlID0gcmVhZGwoaW9hZGRyICsgRE1BX0NIQU5fQ09OVFJPTChjaGFuKSk7DQo+ICsJaWYgKGRt
YV9jZmctPnBibHg4KQ0KPiArCQl2YWx1ZSA9IHZhbHVlIHwgRE1BX0JVU19NT0RFX1BCTDsNCj4g
Kw0KPiArCXdyaXRlbCh2YWx1ZSwgaW9hZGRyICsgRE1BX0NIQU5fQ09OVFJPTChjaGFuKSk7DQo+
ICsNCj4gKwkvKiBNYXNrIGludGVycnVwdHMgYnkgd3JpdGluZyB0byBDU1I3ICovDQo+ICsJd3Jp
dGVsKERNQV9DSEFOX0lOVFJfREVGQVVMVF9NQVNLXzRfMTAsDQo+ICsJICAgICAgIGlvYWRkciAr
IERNQV9DSEFOX0lOVFJfRU5BKGNoYW4pKTsgfQ0KPiArDQo+ICBzdGF0aWMgdm9pZCBkd21hYzRf
ZG1hX2luaXQodm9pZCBfX2lvbWVtICppb2FkZHIsDQo+ICAJCQkgICAgc3RydWN0IHN0bW1hY19k
bWFfY2ZnICpkbWFfY2ZnLCBpbnQgYXRkcykgIHsgQEANCj4gLTUyMyw3ICs1NDAsNyBAQCBjb25z
dCBzdHJ1Y3Qgc3RtbWFjX2RtYV9vcHMgZHdtYWM0X2RtYV9vcHMgPQ0KPiB7ICBjb25zdCBzdHJ1
Y3Qgc3RtbWFjX2RtYV9vcHMgZHdtYWM0MTBfZG1hX29wcyA9IHsNCj4gIAkucmVzZXQgPSBkd21h
YzRfZG1hX3Jlc2V0LA0KPiAgCS5pbml0ID0gZHdtYWM0X2RtYV9pbml0LA0KPiAtCS5pbml0X2No
YW4gPSBkd21hYzRfZG1hX2luaXRfY2hhbm5lbCwNCj4gKwkuaW5pdF9jaGFuID0gZHdtYWM0MTBf
ZG1hX2luaXRfY2hhbm5lbCwNCj4gIAkuaW5pdF9yeF9jaGFuID0gZHdtYWM0X2RtYV9pbml0X3J4
X2NoYW4sDQo+ICAJLmluaXRfdHhfY2hhbiA9IGR3bWFjNF9kbWFfaW5pdF90eF9jaGFuLA0KPiAg
CS5heGkgPSBkd21hYzRfZG1hX2F4aSwNCj4gLS0NCj4gMi4xNy4xDQoNCg==
