Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895094264D8
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 08:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhJHGse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 02:48:34 -0400
Received: from mail-eopbgr1410091.outbound.protection.outlook.com ([40.107.141.91]:47963
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229664AbhJHGsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 02:48:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c39ejfbQPz92rlCuvvhq93C8cwMwXT4dichNyubE9GHtgj0Lo2MmwCeJbK7vkxy4I5G0Pmq5dYRh7YsGyysG4zTouwBGtuZz6KPAk+gBN7dcIq6MYE7Gdi7lo6AzYNVG4/+PO1cgBk39IvbPXg0Nh5RX3J+a5Zc7KaQA8+AtV1jNwC9U6oywmm7nxTekVwYnjhGbehsbvv72sLCY9GixDfoJMWbAvRkv0/7iw4CKIEg8xPNYN0/brJwPJyu77DQ+OaWbubZ/DjadGSkzzxh4YlaDPu3CcPrWJHi3fqI9HFfzhRYueECI0EycGOgBj+N7zU7oUPYK87yvbcOwgGxpxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFOqhJwsiMpCtn7UzC2l12wYHXRXnP4Reo5+TvK+ufg=;
 b=SWSvt+/f/gH9d3uQpu8rTQh8NJn7bgJjfu8CkPaALl1AOvAsK/N/hrORQFU16VLkQ6+lp7/mujhFdgk7NgUIVmB5J1vTjAWcKirD0c5/2/qo8efQTYWfgZyf4CWsjwfnALjVybDrwP9BvJhs+HR8ngjovnFooeQOcY3WDH2jS8xy//zvCoDt2G0PDt/p2XZyFuq/hFVhY1M0loL2UAgEZcThvHnoLd0lNQI1wIbhl1zc0DWdRtTyWHQqBPvPBm0R5i8myQQpXEmILlVqwD2JTaRa/+GWiEP4VTFavgyVpcJTAp2BUJeJ0IDbtED/g1pwVGo1qiqT3Wd2LK1ARnameA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFOqhJwsiMpCtn7UzC2l12wYHXRXnP4Reo5+TvK+ufg=;
 b=BtQFQoucM+Niy4WguIRa+3hX0l1Zrk61xAXTatwgXzZKT9nm89gh9MLaRhBDU8lQTEzXIUAvCpVbXmigm1+Y8RrLK7ZNqIa0bzZeWSh2RQrSiTvwUNJQeHFzdnwFKBlQ3sYqj3qKr63nESNxfOp+qviE2ap240eVFlbk8HrhBfs=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB3890.jpnprd01.prod.outlook.com (2603:1096:604:5d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 06:46:34 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.018; Fri, 8 Oct 2021
 06:46:32 +0000
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
Subject: RE: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Thread-Topic: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Thread-Index: AQHXudknyVYpSr19EUOWd3E+ko3swavGX+aAgAAJbzCAAAV1gIAAlePwgADj/ACAAAp2UIAAuMcg
Date:   Fri, 8 Oct 2021 06:46:32 +0000
Message-ID: <OS0PR01MB5922165EFE14E02388B34F4086B29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-8-biju.das.jz@bp.renesas.com>
 <63592646-7547-1a81-e6c3-5bac413cb94a@omp.ru>
 <OS0PR01MB592295BD59F39001AC63FD3886B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <7c31964b-8cde-50c5-d686-939b7c5bd7f0@omp.ru>
 <OS0PR01MB5922239A85405F807AE3C79A86B19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <04dea1e6-c014-613d-f2f9-9ba018ced2a3@omp.ru>
 <OS0PR01MB5922BCF31F520F8F975606B286B19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB5922BCF31F520F8F975606B286B19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff3b486b-8c09-40f3-f418-08d98a275da9
x-ms-traffictypediagnostic: OSAPR01MB3890:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB3890C5C95350BCCD9AA5DF2686B29@OSAPR01MB3890.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Us7RLpQ1q9xHn/7Sa4c4BJAxIXZ3v9Nm1RU8CKQTEG2jAbi23XuvoH+klyLeK6qYbgNtrjL+CTq5u204Va/8Ng6QJ2JBVW7gla9rA6T/5MjS0NkxxnqJg7hL4yGVLscgY1LjzR+eZZjOQCINqQY+tuj57AYK27BokyAxRmk8gugcNJDXN2pIJijyEuNfYgpw8WzFFOGKypXm1c59yhWnpAKK2WfaY6YcWPOj3ruqk5CCOsvcB+SNFOwruFdTe0xSp/+Ce5DaSBNgFrKyWO3y84+5zD7q+puwIOSKZIHDwzXkzpWqCcHk6nWIXCkC1wAJaePVkHtODKE18vlgSOhBto9/Z1zvixUHJk/sbZTN9aZDkeEh9ljVqguC/RAOSyf2zatIiFYNY5e/HpyjQAaJvDmsJ/0nuc9dpiPRV/xm5/clzzwi5Tmxc33qe8x0tvPr2RFQeTlvHIToiXMzub3mnr+2oDjuUv/8tJM3UBAKFBUwbzYxKtthsIe2XnKIcQN90gEFHC5F0ljzBPz4hfLeorg7PvM3dP8GA8uo1KDkFkR2z5zohuc0x+21aix7CTkgT6cKqqOte3V+DPYKS0kHp89Ek7mQOQO4IhYk6vPrbPwa2Hkn1+mDXqndqoZlOXA5UTNLsQro3ogemTMXyIRi1qajYiUULKlU7WacSbJwOTGNZ7B5ZrgTTn6PnOj1L+Yj+hJ0KrHG3qWNjTUu6EiSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(54906003)(38070700005)(7416002)(122000001)(107886003)(316002)(52536014)(2906002)(66946007)(76116006)(66476007)(66556008)(64756008)(5660300002)(38100700002)(66446008)(508600001)(71200400001)(4326008)(186003)(26005)(33656002)(86362001)(8936002)(9686003)(55016002)(6506007)(53546011)(8676002)(83380400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SENXcitHZFkvQ2U5WXVRa2poQmsrQktQdzVJZ3JxMHdRV2VmZEFZbFA5aWpL?=
 =?utf-8?B?QzJhdWluNXpZNGFVcnlYUTNaR0cvWE5hWGxJVnphbCt4dUhrZnB0T0ZNeDVV?=
 =?utf-8?B?NXJlK1ZXbkZleXZnVCt2REhZSVJhdXpkeDVTRkM4ZUZEMHc1K0xQSWsvSjlF?=
 =?utf-8?B?U281SlRxVGpreFBvSXc2clZZYVBWbTczUXFIVWE0QWdHRSt2bTRNVEU0eGhl?=
 =?utf-8?B?bTZGQmtHa0xsenZTZHZidjJpYXE0T25Cb2dVMHcwSGNRbElCQ2ZZV1RpUHVV?=
 =?utf-8?B?YTFzM1k3UFBpV09MSTFaUloveW16MWFOZktUVzdHcFAwZ0NjQUpjOFVUVnZh?=
 =?utf-8?B?bzB3ZzA2aVBhTzAvU1JQeFBjTFBGOTV1eGZxdm5sRVRkN2VDd3YrL2NSemp4?=
 =?utf-8?B?WXFSNjdSWkxEK25IbXFmdlJJQTcrNVNJYmhkNW1oWHZUMkswV0hsTlA0dHJM?=
 =?utf-8?B?czVTbkU1M0RudTFmNGtXcjdVVGhsL0VYWFE3UWxLRTRwRTBpYU5IRysxTXNv?=
 =?utf-8?B?bVRTNkdVQ3Z0SWdnRnROblJqdWc4czY3UCtYVGFBcUlydkxVMi8vRXQ3Y2Nw?=
 =?utf-8?B?dVAzN0N4bDdMTnFiTkVSdHlISzNNSllGb3VTR05NZnBDd29SMXBMazl0enNS?=
 =?utf-8?B?Y201eXpWMXN2MEsramhZNXRBQkp0TDZaZ1hRb3hZQmFpUWUwNXM3ZTZKTWJD?=
 =?utf-8?B?OSswT2QySnZ2SFRZS1VPWTZrSnM4OW01Qk9nWW5ST1hqWitVNzVUdmxjbGc3?=
 =?utf-8?B?TlBVMDRBVjB0QnFXMnBnVWVJOTlKdFY5UC9POW43MDVGRWNGd2JmTnpNZzRl?=
 =?utf-8?B?THUzQ3k0bEJBRm9vZklyeU9PMjY0UTJoUmg3VUpyZGI0OERvSTFDVld2N0g4?=
 =?utf-8?B?Z2d2MVJlRmgwcUJ6V2k4Vk5rNzNmYlNkM0FaaWhTSnhiRXd2aVk5MjYvV3c3?=
 =?utf-8?B?M3cwZFhnZ2Z2V3JkMXdwZnJ6ZjE0a2Y4THV1a2FjQ1V6UHJpYXQ4cmRha3Mw?=
 =?utf-8?B?aWYrQ2w2SHFaK0hCRXM5WnBNRnNOQnRLYklHMmxDQkhuQ0tVeTVYR1JNOHhB?=
 =?utf-8?B?MDNSaUprSDVTZVlPbTV3SFNQWWNvYjBWcHd1d2d0a0g0NGtlUEZiUjVGSHFC?=
 =?utf-8?B?SG9tUzV3YkhIL2dpdC96dXNjYlpqSGlpZTZYeHVUUGhod2F3NTZBMGhSRzdP?=
 =?utf-8?B?OFZJMEZMVTQwanpYeHVsV0E5UXc4dmUzQnB2QnErdFpMUVJhR2VkT2RrS2lV?=
 =?utf-8?B?QVpHWnpVRjQwL3EwWHhyVkJkWnFvRWtYdkliRVVwRzhVelh2QU8valdHMEx6?=
 =?utf-8?B?blVKR1FvODh0MGc1Rkdvd0Q1QzZDY1RhWU9IbnQ2cXdWaXM5Z2J1dHdVV2du?=
 =?utf-8?B?QWVCalFLU3VZWDB0V2pyajV4NXRJL1h2U2trVnNNTlJkeFZzWDlxS3c0N1Vi?=
 =?utf-8?B?UTlEa0djZEp0V0l5MUllWjFObk5rK0tDL29RY0cxekphNHI2YnBkNWlGRnpJ?=
 =?utf-8?B?TzhGc1VZVW1SbldXL3g2VGgxVERiS2JHY2RhbW1zRFZJWjRBaERESzE0ZjV5?=
 =?utf-8?B?THJKMDZ5WFZkWTV5OXR0WXlzcWJkdmpOVTBQUTYwTDltbFFJMnY5MElJcndB?=
 =?utf-8?B?YW9UaUhkdEpyV29maklodU10Z3Q1dmN2a3pPOEhGMzc2S3ExZ3hnMEtCQ0ly?=
 =?utf-8?B?MW5WVlNkcnR0ZXFhSk5Kc0FxcUhwWE1Rbm9nVkhrc2lSNXhId3VaS3V2dHpL?=
 =?utf-8?Q?zt5pUKnDKvK9r+HDyQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff3b486b-8c09-40f3-f418-08d98a275da9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2021 06:46:32.6824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kIw6v1tJUhZg7JprZoBdz/T1N7Cmfr9HA22ryBswJUSZzq0LGr7wbj3+sJSC8P8dK+bGrlvVtNg13TkIS0jeR1J4Z5WUTeFuGlgGsaCafm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3890
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJFOiBbUkZDIDA3LzEyXSByYXZiOiBGaWxsdXAgcmF2
Yl9yeF9nYmV0aCgpIHN0dWINCj4gDQo+IEhpIFNlcmdleSwNCj4gDQo+IA0KPiBUaGFua3MgZm9y
IHRoZSBmZWVkYmFjay4NCj4gDQo+ID4gU3ViamVjdDogUmU6IFtSRkMgMDcvMTJdIHJhdmI6IEZp
bGx1cCByYXZiX3J4X2diZXRoKCkgc3R1Yg0KPiA+DQo+ID4gT24gMTAvNy8yMSA4OjQ5IEFNLCBC
aWp1IERhcyB3cm90ZToNCj4gPg0KPiA+IFsuLi5dDQo+ID4gPj4+Pj4gRmlsbHVwIHJhdmJfcnhf
Z2JldGgoKSBmdW5jdGlvbiB0byBzdXBwb3J0IFJaL0cyTC4NCj4gPiA+Pj4+Pg0KPiA+ID4+Pj4+
IFRoaXMgcGF0Y2ggYWxzbyByZW5hbWVzIHJhdmJfcmNhcl9yeCB0byByYXZiX3J4X3JjYXIgdG8g
YmUNCj4gPiA+Pj4+PiBjb25zaXN0ZW50IHdpdGggdGhlIG5hbWluZyBjb252ZW50aW9uIHVzZWQg
aW4gc2hfZXRoIGRyaXZlci4NCj4gPiA+Pj4+Pg0KPiA+ID4+Pj4+IFNpZ25lZC1vZmYtYnk6IEJp
anUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiA+Pj4+PiBSZXZpZXdlZC1i
eTogTGFkIFByYWJoYWthcg0KPiA+ID4+Pj4+IDxwcmFiaGFrYXIubWFoYWRldi1sYWQucmpAYnAu
cmVuZXNhcy5jb20+Wy4uLl0NCj4gPiA+Pj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4+Pj4+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4+Pj4+IGluZGV4IDM3MTY0YTk4MzE1Ni4uNDI1
NzNlYWM4MmI5IDEwMDY0NA0KPiA+ID4+Pj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yl9tYWluLmMNCj4gPiA+Pj4+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gPj4+Pj4gQEAgLTcyMCw2ICs3MjAsMjMgQEAgc3RhdGlj
IHZvaWQgcmF2Yl9nZXRfdHhfdHN0YW1wKHN0cnVjdA0KPiA+ID4+Pj4+IG5ldF9kZXZpY2UNCj4g
PiA+Pj4+ICpuZGV2KQ0KPiA+ID4+Pj4+ICAJfQ0KPiA+ID4+Pj4+ICB9DQo+ID4gPj4+Pj4NCj4g
PiA+Pj4+PiArc3RhdGljIHZvaWQgcmF2Yl9yeF9jc3VtX2diZXRoKHN0cnVjdCBza19idWZmICpz
a2IpIHsNCj4gPiA+Pj4+PiArCXU4ICpod19jc3VtOw0KPiA+ID4+Pj4+ICsNCj4gPiA+Pj4+PiAr
CS8qIFRoZSBoYXJkd2FyZSBjaGVja3N1bSBpcyBjb250YWluZWQgaW4gc2l6ZW9mKF9fc3VtMTYp
ICgyKQ0KPiA+IGJ5dGVzDQo+ID4gPj4+Pj4gKwkgKiBhcHBlbmRlZCB0byBwYWNrZXQgZGF0YQ0K
PiA+ID4+Pj4+ICsJICovDQo+ID4gPj4+Pj4gKwlpZiAodW5saWtlbHkoc2tiLT5sZW4gPCBzaXpl
b2YoX19zdW0xNikpKQ0KPiA+ID4+Pj4+ICsJCXJldHVybjsNCj4gPiA+Pj4+PiArCWh3X2NzdW0g
PSBza2JfdGFpbF9wb2ludGVyKHNrYikgLSBzaXplb2YoX19zdW0xNik7DQo+ID4gPj4+Pg0KPiA+
ID4+Pj4gICAgTm90IDMyLWJpdD8gVGhlIG1hbnVhbCBzYXlzIHRoZSBJUCBjaGVja3N1bSBpcyBz
dG9yZWQgaW4gdGhlDQo+ID4gPj4+PiBmaXJzdA0KPiA+ID4+Pj4gMiBieXRlcy4NCj4gPiA+Pj4N
Cj4gPiA+Pj4gSXQgaXMgMTYgYml0LiBJdCBpcyBvbiBsYXN0IDIgYnl0ZXMuDQo+ID4NCj4gPiAg
ICBUaGUgSVAgY2hlY2tzdW0gaXMgYXQgdGhlIDFzdCAyIGJ5dGVzIG9mIHRoZSBvdmVyYWxsIDQt
Ynl0ZQ0KPiA+IGNoZWNrc3VtIChjb21pbmcgYWZ0ZXIgdGhlIHBhY2tldCBwYXlsb2FkKSwgbm8/
DQo+IA0KPiBTb3JyeSwgSSBnb3QgY29uZnVzZWQgd2l0aCB5b3VyIHF1ZXN0aW9uIGVhcmxpZXIu
IE5vdyBpdCBpcyBjbGVhciBmb3IgbWUuDQo+IA0KPiBJIGFncmVlIHRoZSBjaGVja3N1bSBwYXJ0
IGlzIHN0b3JlZCBpbiBsYXN0IDRieXRlcy4gT2YgdGhpcywgdGhlIGZpcnN0IDINCj4gYnl0ZXMg
SVBWNCBjaGVja3N1bSBhbmQgbGFzdCAyIGJ5dGVzIFRDUC9VRFAvSUNNUCBjaGVja3N1bS4NCj4g
DQo+ID4NCj4gPiA+PiAgICBTbyB5b3UncmUgc2F5aW5nIHRoZSBtYW51YWwgaXMgd3Jvbmc/DQo+
ID4gPg0KPiA+ID4gSSBhbSBub3Qgc3VyZSB3aGljaCBtYW51YWwgeW91IGFyZSByZWZlcnJpbmcg
aGVyZS4NCj4gPiA+DQo+ID4gPiBJIGFtIHJlZmVycmluZyB0byBSZXYuMS4wMCBTZXAsIDIwMjEg
b2YgUlovRzJMIGhhcmR3YXJlIG1hbnVhbCBhbmQNCj4gPg0KPiA+ICAgIFNhbWUgaGVyZS4NCj4g
Pg0KPiA+IFsuLi5dDQo+ID4NCj4gPiA+IFBsZWFzZSBjaGVjayB0aGUgc2VjdGlvbiAzMC41LjYu
MSBjaGVja3N1bSBjYWxjdWxhdGlvbiBoYW5kbGluZz4gQW5kDQo+ID4gPiBmaWd1cmUgMzAuMjUg
dGhlIGZpZWxkIG9mIGNoZWNrc3VtIGF0dGFjaGluZyBmaWVsZA0KPiA+DQo+ID4gICAgSSBoYXZl
Lg0KPiA+DQo+ID4gPiBBbHNvIHNlZSBUYWJsZSAzMC4xNyBmb3IgY2hlY2tzdW0gdmFsdWVzIGZv
ciBub24tZXJyb3IgY29uZGl0aW9ucy4NCj4gPg0KPiA+ID4gVENQL1VEUC9JQ1BNIGNoZWNrc3Vt
IGlzIGF0IGxhc3QgMmJ5dGVzLg0KPiA+DQo+ID4gICAgV2hhdCBhcmUgeW91IGFyZ3Vpbmcgd2l0
aCB0aGVuPyA6LSkNCj4gPiAgICBNeSBwb2ludCB3YXMgdGhhdCB5b3VyIGNvZGUgZmV0Y2hlZCB0
aGUgVENQL1VEUC9JQ01QIGNoZWNrc3VtIElTTw0KPiA+IHRoZSBJUCBjaGVja3N1bSBiZWNhdXNl
IGl0IHN1YnRyYWN0cyBzaXplb2YoX19zdW0xNiksIHdoaWxlIHNob3VsZA0KPiA+IHByb2JhYmx5
IHN1YnRyYWN0IHNpemVvZihfX3dzdW0pDQo+IA0KPiBBZ3JlZWQuIE15IGNvZGUgbWlzc2VkIElQ
NCBjaGVja3N1bSByZXN1bHQuIE1heSBiZSB3ZSBuZWVkIHRvIGV4dHJhY3QgMg0KPiBjaGVja3N1
bSBpbmZvIGZyb20gbGFzdCA0IGJ5dGVzLiAgRmlyc3QgY2hlY2tzdW0oMmJ5dGVzKSBpcyBJUDQg
aGVhZGVyDQo+IGNoZWNrc3VtIGFuZCBuZXh0IGNoZWNrc3VtKDIgYnl0ZXMpICBmb3IgVENQL1VE
UC9JQ01QIGFuZCB1c2UgdGhpcyBpbmZvDQo+IGZpbmRpbmcgdGhlIG5vbiBlcnJvciBjYXNlIG1l
bnRpb25lZCBpbiAgVGFibGUgMzAuMTcuDQo+IA0KPiBGb3IgZWc6LQ0KPiBJUFY2IG5vbiBlcnJv
ci1jb25kaXRpb24gLS0+ICAiMHhGRkZGIi0tPklQVjRIZWFkZXJDU3VtIHZhbHVlIGFuZCAiMHgw
MDAwIg0KPiBUQ1AvVURQL0lDTVAgQ1NVTSB2YWx1ZQ0KPiANCj4gSVBWNCBub24gZXJyb3ItY29u
ZGl0aW9uIC0tPiAgIjB4MDAwMCItLT5JUFY0SGVhZGVyQ1N1bSB2YWx1ZSBhbmQgIjB4MDAwMCIN
Cj4gVENQL1VEUC9JQ01QIENTVU0gdmFsdWUNCj4gDQo+IERvIHlvdSBhZ3JlZT8NCg0KV2hhdCBJ
IG1lYW50IGhlcmUgaXMgc29tZSB0aGluZyBsaWtlIGJlbG93LCBwbGVhc2UgbGV0IG1lIGtub3cg
aWYgeW91IGhhdmUgYW55IGlzc3VlcyB3aXRoDQp0aGlzLCBvdGhlcndpc2UgSSB3b3VsZCBsaWtl
IHRvIHNlbmQgdGhlIHBhdGNoIHdpdGggYmVsb3cgY2hhbmdlcy4NCg0KRnVydGhlciBpbXByb3Zl
bWVudHMgY2FuIGhhcHBlbiBsYXRlci4NCg0KUGxlYXNlIGxldCBtZSBrbm93Lg0KDQorLyogSGFy
ZHdhcmUgY2hlY2tzdW0gc3RhdHVzICovDQorI2RlZmluZSBJUFY0X1JYX0NTVU1fT0sgICAgICAg
ICAgICAgICAgMHgwMDAwMDAwMA0KKyNkZWZpbmUgSVBWNl9SWF9DU1VNX09LICAgICAgICAgICAg
ICAgIDB4RkZGRjAwMDANCisNCiBlbnVtIHJhdmJfcmVnIHsNCiAgICAgICAgLyogQVZCLURNQUMg
cmVnaXN0ZXJzICovDQogICAgICAgIENDQyAgICAgPSAweDAwMDAsDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCmluZGV4IGJiYjQyZTUzMjhlNC4uZDkyMDFmYmJkNDcy
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0K
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KQEAgLTcyMiwx
NiArNzIyLDE4IEBAIHN0YXRpYyB2b2lkIHJhdmJfZ2V0X3R4X3RzdGFtcChzdHJ1Y3QgbmV0X2Rl
dmljZSAqbmRldikNCiANCiBzdGF0aWMgdm9pZCByYXZiX3J4X2NzdW1fZ2JldGgoc3RydWN0IHNr
X2J1ZmYgKnNrYikNCiB7DQotICAgICAgIHUxNiAqaHdfY3N1bTsNCisgICAgICAgdTMyIGNzdW1f
cmVzdWx0Ow0KKyAgICAgICB1OCAqaHdfY3N1bTsNCiANCiAgICAgICAgLyogVGhlIGhhcmR3YXJl
IGNoZWNrc3VtIGlzIGNvbnRhaW5lZCBpbiBzaXplb2YoX19zdW0xNikgKDIpIGJ5dGVzDQogICAg
ICAgICAqIGFwcGVuZGVkIHRvIHBhY2tldCBkYXRhDQogICAgICAgICAqLw0KLSAgICAgICBpZiAo
dW5saWtlbHkoc2tiLT5sZW4gPCBzaXplb2YoX19zdW0xNikpKQ0KKyAgICAgICBpZiAodW5saWtl
bHkoc2tiLT5sZW4gPCBzaXplb2YoX193c3VtKSkpDQogICAgICAgICAgICAgICAgcmV0dXJuOw0K
LSAgICAgICBod19jc3VtID0gKHUxNiopKHNrYl90YWlsX3BvaW50ZXIoc2tiKSAtIHNpemVvZihf
X3N1bTE2KSk7DQorICAgICAgIGh3X2NzdW0gPSBza2JfdGFpbF9wb2ludGVyKHNrYikgLSBzaXpl
b2YoX193c3VtKTsNCisgICAgICAgY3N1bV9yZXN1bHQgPSBnZXRfdW5hbGlnbmVkX2xlMzIoaHdf
Y3N1bSk7DQogDQotICAgICAgIGlmICgqaHdfY3N1bSA9PSAwKQ0KKyAgICAgICBpZiAoY3N1bV9y
ZXN1bHQgPT0gSVBWNF9SWF9DU1VNX09LIHx8IGNzdW1fcmVzdWx0ID09IElQVjZfUlhfQ1NVTV9P
SykNCg0KUmVnYXJkcywNCkJpanUNCg0KPiANCj4gUmVnYXJkcywNCj4gQmlqdQ0KPiA+DQo+ID4g
Pj4+Pj4gKw0KPiA+ID4+Pj4+ICsJaWYgKCpod19jc3VtID09IDApDQo+ID4gPj4+Pg0KPiA+ID4+
Pj4gICAgWW91IG9ubHkgY2hlY2sgdGhlIDFzdCBieXRlLCBub3QgdGhlIGZ1bGwgY2hlY2tzdW0h
DQo+ID4gPj4+DQo+ID4gPj4+IEFzIEkgc2FpZCBlYXJsaWVyLCAiMCIgdmFsdWUgb24gbGFzdCAx
NiBiaXQsIG1lYW5zIG5vIGNoZWNrc3VtDQo+IGVycm9yLg0KPiA+ID4+DQo+ID4gPj4gICAgSG93
J3MgdGhhdD8gJ2h3X2NzdW0nIGlzIGRlY2xhcmVkIGFzICd1OCAqJyENCj4gPiA+DQo+ID4gPiBJ
dCBpcyBteSBtaXN0YWtlLCB3aGljaCB3aWxsIGJlIHRha2VuIGNhcmUgaW4gdGhlIG5leHQgcGF0
Y2ggYnkNCj4gPiA+IHVzaW5nDQo+ID4gdTE2ICouDQo+ID4NCj4gPiAgICBOb3RlIHRoYXQgdGhp
cyAndTE2JyBoYWxmd29yZCBjYW4gYmUgdW5hbGlnbmVkLCB0aGF0J3Mgd2h5IHRoZQ0KPiA+IGN1
cnJlbnQgY29kZSB1c2VzIGdldF91bmFsaWduZWRfbGUxNigpLg0KPiA+DQo+ID4gPj4+Pj4gKwkJ
c2tiLT5pcF9zdW1tZWQgPSBDSEVDS1NVTV9VTk5FQ0VTU0FSWTsNCj4gPiA+Pj4+PiArCWVsc2UN
Cj4gPiA+Pj4+PiArCQlza2ItPmlwX3N1bW1lZCA9IENIRUNLU1VNX05PTkU7DQo+ID4gPj4+Pg0K
PiA+ID4+Pj4gICBTbyB0aGUgVENQL1VEUC9JQ01QIGNoZWNrc3VtcyBhcmUgbm90IGRlYWx0IHdp
dGg/IFdoeSBlbmFibGUNCj4gPiA+Pj4+IHRoZW0NCj4gPiA+PiB0aGVuPw0KPiA+ID4+Pg0KPiA+
ID4+PiBJZiBsYXN0IDJieXRlcyBpcyB6ZXJvLCBtZWFucyB0aGVyZSBpcyBubyBjaGVja3N1bSBl
cnJvciB3LnIudG8NCj4gPiA+PiBUQ1AvVURQL0lDTVAgY2hlY2tzdW1zLg0KPiA+ID4+DQo+ID4g
Pj4gICAgV2h5IGNoZWNrc3VtIHRoZW0gaW5kZXBlbmRlbnRseSB0aGVuPw0KPiA+ID4NCj4gPiA+
IEl0IGlzIGEgaGFyZHdhcmUgZmVhdHVyZS4NCj4gPg0KPiA+ICAgIFN3aXRjaGFibGUsIGlzbid0
IGl0Pw0KPiANCj4gPg0KPiA+ID4gUmVnYXJkcywNCj4gPiA+IEJpanUNCj4gPg0KPiA+IFsuLi5d
DQo+ID4NCj4gPiBNQlIsIFNlcmdleQ0K
