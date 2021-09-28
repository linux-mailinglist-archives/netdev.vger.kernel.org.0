Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C7B41ABB3
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 11:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239782AbhI1J0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 05:26:10 -0400
Received: from mail-eopbgr1400125.outbound.protection.outlook.com ([40.107.140.125]:37600
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239708AbhI1J0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 05:26:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hy984lgmQWKfyYLUaEV3Pn5Hz5Fh0SSFWeuGSnJ4NJPjdR+CXkKFGqAsaSqK46MsJiDZkNz5Yildemmpb8kQGkYtsEIiSbWNI99xlSL+Vs7Ope9e/zADvy3fRVLL+66NxIPUFv3e13mycMkYPSofBbNMN+8u0v/7zIkFRZZf2dt+XlBLQFPi7zFEJ91jlUjArBSHh1vE8WyjSMMRknzJqqLbem1ucku7+VsbrJ/Poe1vUo7fz5WVL1iQvyhJTRAbvbTMSyv1S8By7TOpa1+ORkoGKs1Kias0XCqAoiHksgt8LdY8d5a7M7uQgIg88njFXUgoLyzmAN9xelVn4RmOOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qzdUDFOe113unVWc1j7BeTwZ+7SmU3sm3Mfggt/NZs0=;
 b=elGOcvP47ppHfEEB9HzrbDJ/PHMWj9Gr6GJ3dBeTxWVpI9lfnZrXNYQjMHpSbkT1s4pUaGbxcGxe85ZeTpDM4qFOyqV5lgEtIZxuFCqYLVuDj5NmLuqSL0kXoIPKvh18mlPjESZqE7cYpZK6eyWumlVl3n747BuyjMZVq4eR1UD/UoATyTEno2EhNknTUyGDQmq/jtMWZAP8JqZ2EGmk1YR8lNJK+TJfWXiekuT0734QuG150ii7tJdiRBXvhrcW6RqMqb/Vwi4m5FtYl0uppQ2rVj1tMyIzsljZGspJjGq4itjXreAkIiDzIDMQAUJJvvgjYTmMV/Eeny+o3frtNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzdUDFOe113unVWc1j7BeTwZ+7SmU3sm3Mfggt/NZs0=;
 b=LG2TEKSz1d7vNUmEonkqjIvoXKZMhTIcUc9RDf37O3/7GO3DvALecQeG6NH0Ohd45wtlGUOxRE7XUPHAMR4KtDNsVRUJl28jbPgwotW1sp2ik4jrUU2NSkp0cA5Q+dN3xMjA/KF1167ZpN2VJFKMXMZGtHL/8qn88dw8+PIpPPo=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5924.jpnprd01.prod.outlook.com (2603:1096:604:b3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 09:24:25 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262%9]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 09:24:25 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 13/18] ravb: Add rx_ring_free function support for
 GbEthernet
Thread-Topic: [RFC/PATCH 13/18] ravb: Add rx_ring_free function support for
 GbEthernet
Thread-Index: AQHXsISRC57DCO6WZ06KaWVpTjz4Tqu4Sp8AgADoa+A=
Date:   Tue, 28 Sep 2021 09:24:25 +0000
Message-ID: <OS0PR01MB5922E75F05556EC526ABA3B686A89@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-14-biju.das.jz@bp.renesas.com>
 <6d6c1a5d-fcaa-4af9-0ed8-51920c237bde@omp.ru>
In-Reply-To: <6d6c1a5d-fcaa-4af9-0ed8-51920c237bde@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9e954ee-3336-4d77-0ef0-08d98261c3c4
x-ms-traffictypediagnostic: OS0PR01MB5924:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS0PR01MB59244B17836CD73E80F461B186A89@OS0PR01MB5924.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jycQPIFdSG4qM+aExiZytnUi16Qn0dAVPCvSZpLCl0SdDNcanq8p55enwFi+Gxl8Of9wok1wOPsKvhddHKmiONo2ve0jLptgdkRyPGEFOpTUwMElNnwxNS8y+7NnTG/OYHKjYpe/49pGvbZVoGTqcCaBf+Nujk2hYhrgl19VvvF3n2lsRHiUAf4M/S9rLvFYt1261hUq6OdSipxLohoUsRKSeYsX77n2TvtpfXO5NBu3wmMdcCO2snW0RGS27TzWFf/jtTxPj4AJfHZZeqdDtM8yQicuSwXDLPMGf3kYcfRIZK24WuK0lqivUP5RgdfDWbbbqgyekUUbpASw9GB/NiBU0KJ9HKGPuEONxPKMVsrXbV1OXiUhKgaRbX9XXiotnNBYi3c7/0QWyeyiN7hDtr/Yk2JFRrpPRbGxLOgoNN4DjGZbksk2OW2gYNuw4XaYiecjH0H4xZVSiEqm3cwXtkek5o63u2U0kBBvBnSQ6i1HVPDON8ARQEFrANd+MUZ0UxTZ8W4N1J1LlsU49bspcWxsF4E+t2UAQA2wmixQNwY1fiHKRLn460zm6yO76mDHs7BEck/Z7zA250VRkqZwBT8hkVR8rqxEc3LcNTgxvl+UlyjwjLTRjtUV9XaLe0cBBRTnQ5EqOeIEEOyHOieZUGpfpT8gSAd8wvqAGl5iG5A3CUG0bumglU5/JG4255HHkE/ZyZx2XmBQ5b+voL9/9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(6506007)(66946007)(8676002)(66476007)(26005)(38070700005)(110136005)(54906003)(53546011)(186003)(107886003)(76116006)(66556008)(64756008)(66446008)(71200400001)(83380400001)(316002)(2906002)(55016002)(38100700002)(5660300002)(122000001)(86362001)(7696005)(8936002)(4326008)(52536014)(508600001)(33656002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3VuOThNRHpkYXlROHdsNU9VMi95Q0hlQnZHdGNwR0VlTjJzV29OaWZtNDhH?=
 =?utf-8?B?dkRnb2FBcFZ5NEdCMFh4R2VkS09jRGhSUHhWZjVYOWw5MVNZajVuNmdRVzdr?=
 =?utf-8?B?TFB3Unc5NzVZaUE2bkdBTXRWRDdNNGlvVGExUFpQSnJwK29wVGNUWHd4SnJ4?=
 =?utf-8?B?N2VNUzdvMTFBblJVclBpV0h6RFBDMnJGSmdqTUZ1a1VTd1NoL2l0UUs4MHRK?=
 =?utf-8?B?UEpUYjN5WDA0UlFYZFVsc1BUSHlQWFNBV2FmTHBreW54ays0eXhKcU5maEZh?=
 =?utf-8?B?UDJKODBERGs1bXlSTDkveEZmNFhSYUIzMjNkeDFIS3doWVd4YVM1a0hVT2Fs?=
 =?utf-8?B?aG5zTXhKTUFzVmFSK21JcGIvM1hlWUZacWNJNHJ5TmRhcURRMk9qUmdjbWho?=
 =?utf-8?B?UXF4VW9MV1NLNTdTSXo1eEd2em9ZWGVndXZXQWVHYnMrYzRPWGpqblZGSFFX?=
 =?utf-8?B?SThyWjczd2xWM1plVEhYdTJYRzRXa1Y5amhKVkJ0WU1GZFI3UC9XVFJweWZL?=
 =?utf-8?B?ZFBWOFdDTVdqZ0hSUUwxTExob1lXelhNeWdqMkphMEVxMWVVSXhvMTh6NmdQ?=
 =?utf-8?B?YzdhVzZzKzFkbWRpbHY1MnkrMGhZb3luVE53M05zTTBtTlgvak1YV2RmbkUy?=
 =?utf-8?B?NGJiYy9NR2RDNVJuYjZ2ZGhUUURtYmEwRFVybHhURThFRFRGbzBpN2R1UnZ3?=
 =?utf-8?B?K2JLcUtKdnBmbjkrbFFSdEZ2U1lHUzZYcjl5TnhRZEFwT2Yycm9OTElMZUIr?=
 =?utf-8?B?S2ZueXB6SWFxdDRpdUQrcW5iTHJ5bHlPMVZZSnROZTRGekprOU5lZzJ4NE1K?=
 =?utf-8?B?Syt2NThtOHp3MlBCNzM5Y2RKQnNHWUwybkxROE5QeVEraHVCNkFJVVQ4UFY1?=
 =?utf-8?B?c1hETTVHZitudStnKzhDNTlRRTBCTmdNeEw0NDBnWVJWd3k4bHE5WjFMNkdQ?=
 =?utf-8?B?M0ZvNUlXbk1WTzRLcGFscDBndjZ2OEQ0VFBvcHp2VHpaT0NQNUFBa2dYWkF0?=
 =?utf-8?B?QXdrVktCMXpsUmJkb0N6aWRQc1NxZnRHNjZXRFJJeGVyM3FMMmg4TzMwQmxC?=
 =?utf-8?B?Nkp6YlhYWHMzZGZTeUhrYjdwbUd2WEpaOTRNM2JFM3M4K1FaZVlxSDNZOWti?=
 =?utf-8?B?bHI2em90QnFrSit6M29HMURITm9CNlkzTUhMcFJHM1oxUnJydFVySHl5WUlK?=
 =?utf-8?B?aGxPRFFoODd1Y0ZnUWhXa0JBbUpsMTVFczVFOW54eTA5OHNxeFBZbmpoS3FL?=
 =?utf-8?B?UTNyTm1Nc3RCMEhCbTRJZS80TDNMcnB5YnlaQmtXZXQzT0lOSHZGL25vMHh6?=
 =?utf-8?B?VHNnSnBrOVM2bzZHYUV6RTFPQnRLWTNRa0Vya1h6VXVmTVhOREZKc0NaWnp3?=
 =?utf-8?B?ZGs1UXpJbnd6YmJHcTg0VEh6MVRKZmwyYk5pQS8wTDVaV1BHZ1NmR1JBSHhv?=
 =?utf-8?B?SkJFM1REWUo0YzU0ayt1VStiVVU5eTkrTFp5bGRSWHpnOHpZb1ZtUlNPSTdw?=
 =?utf-8?B?eUc5R01wSFgrSE9MZWdwZ0RZajBzMzFvMnBaUDVvVFlzQlRoV25KMXdhUFBC?=
 =?utf-8?B?Q2VtUDlCb2RLTUZLSW85YnQ3N1NXVjB6SGh4TnozbWpLSmh2TFdCVXN5TWFL?=
 =?utf-8?B?ZmNhc1poMW5hb2V4emNFSGZ5Zm44RUIybXdvbTF5eWNZT0dWR2tGTThGc2Rv?=
 =?utf-8?B?d0ZBM3oybUtpWk9qbDdzZ2t1bUV5bUtLWXFpM0ZqV0ZJZzJDT285T21YaVU4?=
 =?utf-8?Q?qn1gFN9nzhD4dzgLN6DP1I8xqXn9PwS/4cpeCY5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e954ee-3336-4d77-0ef0-08d98261c3c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 09:24:25.5538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BWP80mZav14xWywXl5YJbd4Lh0EQZ8nNpMYky0T3fknsyx3lj3yUlADNUhY6lFFRMd2dmIsi2pkq8hQ27y6PtWy8TKHkUsCdAxrzBcdRgLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5924
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1JGQy9QQVRDSCAxMy8xOF0gcmF2YjogQWRkIHJ4X3JpbmdfZnJlZSBmdW5jdGlvbiBzdXBwb3J0
IGZvcg0KPiBHYkV0aGVybmV0DQo+IA0KPiBPbiA5LzIzLzIxIDU6MDggUE0sIEJpanUgRGFzIHdy
b3RlOg0KPiANCj4gPiBUaGlzIHBhdGNoIGFkZHMgcnhfcmluZ19mcmVlIGZ1bmN0aW9uIHN1cHBv
cnQgZm9yIEdiRXRoZXJuZXQgZm91bmQgb24NCj4gPiBSWi9HMkwgU29DLg0KPiA+DQo+ID4gU2ln
bmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IC0t
LQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwgMjIgKysr
KysrKysrKysrKysrKysrKysrLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCAyYzM3NTAwMmViY2IuLjAzOGFmMzYxNDFiYiAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IEBA
IC0yMzYsNyArMjM2LDI3IEBAIHN0YXRpYyBpbnQgcmF2Yl90eF9mcmVlKHN0cnVjdCBuZXRfZGV2
aWNlICpuZGV2LA0KPiA+IGludCBxLCBib29sIGZyZWVfdHhlZF9vbmx5KQ0KPiA+DQo+ID4gIHN0
YXRpYyB2b2lkIHJhdmJfcnhfcmluZ19mcmVlX3JnZXRoKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2
LCBpbnQgcSkNCj4gPiB7DQo+ID4gLQkvKiBQbGFjZSBob2xkZXIgKi8NCj4gPiArCXN0cnVjdCBy
YXZiX3ByaXZhdGUgKnByaXYgPSBuZXRkZXZfcHJpdihuZGV2KTsNCj4gPiArCXVuc2lnbmVkIGlu
dCByaW5nX3NpemU7DQo+ID4gKwl1bnNpZ25lZCBpbnQgaTsNCj4gPiArDQo+ID4gKwlpZiAoIXBy
aXYtPnJnZXRoX3J4X3JpbmdbcV0pDQo+IA0KPiAgICBJcyB0aGUgbmV0d29yayBjb250cm9sIHF1
ZXVlIHByZXNlbnQgb24geW91ciBoYXJkd2FyZSBhdCBhbGw/IFBlcmhhcHMNCj4gd2UgY2FuIGln
bm9yZSBxIGZvciBub3c/DQoNCk5DIHF1ZXVlIGlzIG5vdCBwcmVzZW50IG9uIFJaL0cyTC4gV2ls
bCBhZGQgYSBmZWF0dXJlIGZsYWcgYW5kIGZ1bmN0aW9uIHBvaW50ZXIgcmVsYXRlZCBjaGFuZ2Vz
IHRvDQptaW5pbWl6ZSB0aGUgY2hlY2sgZm9yIE5DIGFuZCBhdm9pZCB1c2luZyBOQyBxdWV1ZSBm
b3IgUlovRzJMIHBsYXRmb3JtLg0KDQpQbGVhc2UgbGV0IG1lIGtub3csIGlmIHlvdSB0aGluayBv
dGhlcndpc2UuDQoNCj4gDQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsNCj4gPiArCWZvciAoaSA9IDA7
IGkgPCBwcml2LT5udW1fcnhfcmluZ1txXTsgaSsrKSB7DQo+ID4gKwkJc3RydWN0IHJhdmJfcnhf
ZGVzYyAqZGVzYyA9ICZwcml2LT5yZ2V0aF9yeF9yaW5nW3FdW2ldOw0KPiANCj4gICAgTG9va3Mg
bGlrZSBwYXRjaCAjMTIgc2hvdWxkIGNvbWUgYWZ0ZXIgdGhpcyBvbmUsIG5vdCBiZWZvcmUuLi4N
Cg0KUGF0Y2gjMTIgaXMgdGltZXN0YW1wIHJlbGF0ZWQgYW5kIHdlIGFncmVlZCB0byBtZXJnZSB3
aXRoIGdQVFAgc3VwcG9ydCBjYXNlLg0KDQpSZWdhcmRzLA0KQmlqdQ0KDQo+IA0KPiA+ICsNCj4g
PiArCQlpZiAoIWRtYV9tYXBwaW5nX2Vycm9yKG5kZXYtPmRldi5wYXJlbnQsDQo+ID4gKwkJCQkg
ICAgICAgbGUzMl90b19jcHUoZGVzYy0+ZHB0cikpKQ0KPiA+ICsJCQlkbWFfdW5tYXBfc2luZ2xl
KG5kZXYtPmRldi5wYXJlbnQsDQo+ID4gKwkJCQkJIGxlMzJfdG9fY3B1KGRlc2MtPmRwdHIpLA0K
PiA+ICsJCQkJCSBSR0VUSF9SWF9CVUZGX01BWCwNCj4gPiArCQkJCQkgRE1BX0ZST01fREVWSUNF
KTsNCj4gPiArCX0NCj4gPiArCXJpbmdfc2l6ZSA9IHNpemVvZihzdHJ1Y3QgcmF2Yl9yeF9kZXNj
KSAqIChwcml2LT5udW1fcnhfcmluZ1txXSArDQo+IDEpOw0KPiA+ICsJZG1hX2ZyZWVfY29oZXJl
bnQobmRldi0+ZGV2LnBhcmVudCwgcmluZ19zaXplLCBwcml2LQ0KPiA+cmdldGhfcnhfcmluZ1tx
XSwNCj4gPiArCQkJICBwcml2LT5yeF9kZXNjX2RtYVtxXSk7DQo+ID4gKwlwcml2LT5yZ2V0aF9y
eF9yaW5nW3FdID0gTlVMTDsNCj4gPiAgfQ0KPiA+DQo+ID4gIHN0YXRpYyB2b2lkIHJhdmJfcnhf
cmluZ19mcmVlKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSkNCj4gDQo+IE1CUiwgU2Vy
Z2V5DQo=
