Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94C63B5EDA
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 15:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhF1N0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 09:26:39 -0400
Received: from mail-eopbgr130094.outbound.protection.outlook.com ([40.107.13.94]:15686
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232507AbhF1N0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 09:26:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TN38xsGcfIlRP9qLmkZXqNkBr8XKeWHE8fTtQNDHj6i5zozv5F6LYfc/Imz1osUdJa2CTu0UIsDIVutn5W4hNFNiwTMS6vZwwftnEOVeaTs1U8Wf9gYuxV4t0sLfgM0OMWQ/TTGPlFT+gF9y/oY3PPUpet3wARXvK/Qp+ckOmUqti87C3gL78PRUHsv1PXLnaEUD4RbWr59t9RKcMExOOsJW1j2NcGra/7/mtnWAXVQkFrjDoCAFI9zXibNYopVGG4CVBTwmGCmYsJFToNb6u7c42Vxnj1d8PGyQ2GOxfSsFt7/0PbEdKOZ3XRir7ygFOGg5AZHOMuW0tOLXMv69fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71knWlrPpw/8oYTk7Izr7egOv2EcbKEwnfXRUlQSpa4=;
 b=giXuTJc/t3tSQOPCOuosNQtzpeHj7OgKPbzDtANoFOlc/8MWEaXVhUmsGt8cjarPQ+5bRPuf3NNkadYpKV4vo14K83ujVioSGvHdb178AZ1S+vALOYBK+gZrctluqoVP2wk/q2b8PLcp8ZAa5OzC39wzr+xubt4XZNFjjWHC5UDlR1hlsG+szH8Bt7T7Hasz/wvNoeh8Nme603wnhUxc9OpOkr/nvQvN4+BKL1InIa3Ij/w2tayYgB0flcy5/etxcOQcYOvMAq7WKXkQZFMmG87AFoAbZMvWrxR4/fbdXHfWDydYHHSaeyYCStXNavGBs0t0cF5uuVCnp5VKMLwzbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=itu.dk; dmarc=pass action=none header.from=itu.dk; dkim=pass
 header.d=itu.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itu.dk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71knWlrPpw/8oYTk7Izr7egOv2EcbKEwnfXRUlQSpa4=;
 b=Brm171D/SnPMz/ZV+mTRSbMCzmSzwVSAILRy2ofCHMu2hg5K06uP/+a5alpzqw9a6clrBVfnmCW6AYSo5qr+FvAzt3j4UgNgNX/uxgpzIaWv0oVjcSFM45mlswaR2SpgmAiRJtJDDqXGuX/YCbpaZZfx21eygVQBLfQORbtW2mwTI3TAPV5YnEVx62Vahw8YzdWAF9p3DX4bjaMboRGl1DSu5fYUK8vfa8azmCpRHwaxxlhXumeX3opxYly192nyJXUcugt/snhJ/DDAYcN8vA9HlMIDfTZVNxaMOGrtqLGUXCzTSQPRi0NzLV17JHQHW3f5HuZnZ56xqx5VSuBWWw==
Received: from AM0PR02MB5777.eurprd02.prod.outlook.com (2603:10a6:208:180::13)
 by AM9PR02MB7409.eurprd02.prod.outlook.com (2603:10a6:20b:3b4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Mon, 28 Jun
 2021 13:24:09 +0000
Received: from AM0PR02MB5777.eurprd02.prod.outlook.com
 ([fe80::9832:7a6d:cf4e:d511]) by AM0PR02MB5777.eurprd02.prod.outlook.com
 ([fe80::9832:7a6d:cf4e:d511%9]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 13:24:08 +0000
From:   Niclas Hedam <nhed@itu.dk>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH v2] net: sched: Add support for packet bursting.
Thread-Topic: [PATCH v2] net: sched: Add support for packet bursting.
Thread-Index: AQHXbBBUhUqhno5k1EKsjrBYSual2KspTeUAgAADeQCAAAa1AIAAEYsA
Date:   Mon, 28 Jun 2021 13:24:08 +0000
Message-ID: <B95D6635-02AE-4912-B521-2BECEE16927E@itu.dk>
References: <532A8EEC-59FD-42F2-8568-4C649677B4B0@itu.dk>
 <877diekybt.fsf@toke.dk> <B28935AB-6078-4258-8E7C-14E11D1AD57F@itu.dk>
 <87wnqeji2n.fsf@toke.dk>
In-Reply-To: <87wnqeji2n.fsf@toke.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=itu.dk;
x-originating-ip: [130.226.132.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f6df003-88cc-4e9a-bf01-08d93a3802d1
x-ms-traffictypediagnostic: AM9PR02MB7409:
x-microsoft-antispam-prvs: <AM9PR02MB74098C3233650E4E7A234130B4039@AM9PR02MB7409.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YbTswuNOIoyP3AYXJwm4y6R5XnBxtspIrvqxPME0l0riSUZ/cNF3DF7zxuADwEfwtyDK7xCaCxOeWx+/BbZU2mzKedo5pvDf2Y9Amo9u+UHLuDitnH4UOTpZRJORXJ3Tokp9AqCDzGv9c27gk4X42Xu0v+t6vmuPSElTyey2SP8bDmJA1tb8Pjq+WtbPXaU5EtNgdTYbpOfsyYzVYs5iMG6HjBzr7XHPLejHyLEvIiGzYDbWbtdHhXpuHX7RuTqe6tyOFEQgGBZ77evD42q/TT3rKxHCRIql2sMq2YG8ECeavLjV6fUGzrs8W+gFGmlyQbMaONUp6NCMgFtrg8IQIha3QY3EYPfQrmv7BLylzqWu2Z6tG8W65RWPzYCXRP8RoPVWfHFL8fB4x0aCznD+klj7PH/QOxNKiQwJMxWbNkJVBqp68YmyX04q7aKoqNBSA75MEJXVuZXsGqpG7FSLeL0m+BW+uj6HFSXcLq/axsL3ZvXM5LtjR4wEKQEPVLmTBirz1St71ShGATONbD8lVRtIepl/u+BNYqv5q/5SsB4g74O3KDjJ4urBFSjREScDFP52Y+MNQzAJ1V5z7k/uZ8inSZAPXSmQWmQ3wIzRFgQGpEVle+TpAksrw5szB9NLjw1REG5MX178NvFo/6RvjpHHdzPr/c2gRbWedyd3NG3rU2o8/Jo890xcWrI91MSi0X421k8NJ0kp90EKxhLXPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB5777.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(366004)(346002)(376002)(396003)(136003)(33656002)(8976002)(8676002)(8936002)(38100700002)(26005)(5660300002)(36756003)(186003)(66556008)(4326008)(2616005)(6506007)(316002)(91956017)(54906003)(76116006)(86362001)(786003)(122000001)(66476007)(66946007)(53546011)(66446008)(64756008)(71200400001)(83380400001)(6916009)(478600001)(66574015)(6486002)(2906002)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MjJPdE5xRWlTK01zbGRCNG9EY1Z6ZG9QdUJHTjlTcTNZRHEyMm1qNmtDYk1t?=
 =?utf-8?B?ZktuTElObEUvV0lNV0FnS2hlRnhhc01aN0F4UzVsQ25JaTJnL1B2ekUvUzNk?=
 =?utf-8?B?TW03cFRQOEprUWNYWlUzZU02U0g1dFo1VHNDaTV3aUw5L04zRzZ2c1BwRlB0?=
 =?utf-8?B?L083c3pZdjNEbURpbnJkS081L1Z1Q3F1MGRpK0dLKzlGTEJ0TjA4OGpmSDRM?=
 =?utf-8?B?SzBoN0dKQWo2YUVYWWVJMklNak5zbndIWW85bWF6eE1NTzg5eStQZzVGeGRp?=
 =?utf-8?B?ZlFrSE5RWVBUU3QrVnhNTTBWUTRmK3QwemJxMkJObnZjSmU5VSsyTHlMRlg4?=
 =?utf-8?B?ZFNkdlAvQ1lNMW1tUy9jUnNNM2JxZEc0aGhaaFBOK0VieVBkTzg5L3o0VTQr?=
 =?utf-8?B?cXQrdjRZb1FHZzVuNlpKSlFhckNZRHhVWGh6eGhiNHg4R09ndnNTSUx5a0M5?=
 =?utf-8?B?bmtnNE9WaXBrbDNkeUFacGFiTlJMSGxEL3BvWTlPbTVrd2pCbUNUWGwzRkxy?=
 =?utf-8?B?eDEyZXZBVlR1ZlRPd3gvc1pBOVlpaGNTTytPRS9UZGdFV0k1Y1VGbWdEZXl0?=
 =?utf-8?B?VnlZWHNSSVNmT211dG15KzNyWVB5YndRUUFuLzhKS3J6OHdmdkV2cW9ORVpN?=
 =?utf-8?B?dk5OTEg5RmtFUDRETjJXUzhiVExUVXBBWS81NEp1Qnl3dWQ4REZjdmduZzU2?=
 =?utf-8?B?ZEY1Z0pZNm1SdFpjTVhzcWgwVkw2OGRlK0l3Ynd2TkZmaTQydTZvK042TE1Q?=
 =?utf-8?B?R240NEJLVEZ1MkI5a1E3Q0xQR3BOM2xTVTBkSFBqWk5KZFIvcmtVSVZ6aXdK?=
 =?utf-8?B?cUxoTHJBZE9xaTU1Y0tETmFuYVluS0hDRzlPanZ3VXJJZ2VmakJKdXVST2hv?=
 =?utf-8?B?WHA4c0JiNEo1b2VpUG03YTByR1VGemorTVd3cVI4bHhqdzI5VjRJZEkzNk9t?=
 =?utf-8?B?R1Y5SVQ0RzdXNnVIUlgvdW13eGVSU3JBRTZ6TWc1QjlvTkZNbE0yRE5VS3Br?=
 =?utf-8?B?WnFOSVZJK1diN20walg2U3FhSFBUcnBsVnliZDVUbWdCQXk2T1JWa1VwZWxX?=
 =?utf-8?B?RGNOQ1B5RGRFWnNMQjlCeW9lOUJrNWJuWUl5TFlUMXh5MFI2L1d4akZxVzJW?=
 =?utf-8?B?aWs5cmtDZGR0aE02cGp4YXpHZ0NuWDQ5R2xyWTFVeWFjL20rbzZTSStnRTdR?=
 =?utf-8?B?eTRSQ3JBQ0d1WS9sU0IzWGxDZy9FVk9HZ2NncXV3NGJKK200U0FVOGwrVXZW?=
 =?utf-8?B?U1BBN3hBQUJGSThsclhaVk5XSGRDa0Y2OWY1UFl2eS9KVzd4aU9KYmRjcWFk?=
 =?utf-8?B?OW5FTVdIMzgwbk40Z1licWQ1Rk85QmRKMmYzUkZNcW4xOU5XV2hEOWNrMmFD?=
 =?utf-8?B?OTBFUnE5b2ZwMi82bVRad0drVDYyaXQ5SnV1NEJYSThHOC9DVnJRWHNiaHRi?=
 =?utf-8?B?VlpFWWlDRVovbTJRTXh0YjZrcFg0dGZqcit3UHdQY3RlSWRDVTdvZll0ek9m?=
 =?utf-8?B?WDhMeDczcEtRV1E2N3ZGeWhCV3g0aksyUVh0RmJrcFNJeDNaZE93N3hHZmQw?=
 =?utf-8?B?cmdtOFlJVXNUNDI5aW9UcDVnZXQrVVhjVTJUN3lKWXlycTl6WjRBSWtYdGJw?=
 =?utf-8?B?UUdCTVg5U2VtT1MyR2xIQis5L0tQUTdMc3gwL2hXanZOL29zaDN1TUFiOS9N?=
 =?utf-8?B?UUl6ekNIRmNyVGNvNThMSHRiWUxKU25FMUFGTlhEVng1TnJMcXBOZFhDNHVy?=
 =?utf-8?B?RjBPZTVLb2hoU2VSbmVSSWJnZlVXUlI1VUZMM3RwNWZnb1MxYXVuc2FtaWly?=
 =?utf-8?B?cmtvNlVIS2hPQk1tRll2QT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <537DA2007817B541924187C4E1B55FF8@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: itu.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB5777.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6df003-88cc-4e9a-bf01-08d93a3802d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2021 13:24:08.8759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea229b6-7a08-4086-b44c-71f57f716bdb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /qKAd2A1QvUbUqkZCyUge4uimRd0Qz9YzFG8q9h1ECBR2Ab8rnPWgAUCii0Z+ac5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR02MB7409
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB0aGUgdmFsdWFibGUgdGhvdWdodHMsIFRva2UuDQoNClRoZSBwYXRjaCBzdGFy
dGVkIHdpdGggbWUgYmVpbmcgdGFza2VkIHRvIHRyeSBhbmQgbWl0aWdhdGUgdGltaW5nIGF0dGFj
a3MgY2F1c2VkIGJ5IG5ldHdvcmsgbGF0ZW5jaWVzLg0KSSBzY291dGVkIG92ZXIgdGhlIGN1cnJl
bnQgbmV0d29yayBzdGFjayBhbmQgZGlkbid0IGZpbmQgYW55dGhpbmcgdGhhdCBmdWxseSBtYXRj
aGVkIG15IHVzZS1jYXNlLg0KV2hpbGUgSSBub3cgdW5kZXJzdGFuZCB0aGF0IHlvdSBjYW4gYWN0
dWFsbHkgbGV2ZXJhZ2UgdGhlIHNsb3RzIGZ1bmN0aW9uYWxpdHkgZm9yIHRoaXMsIEkgd291bGQg
c3RpbGwgb3B0IGZvciBhIG5ldyBpbnRlcmZhY2UgYW5kIGltcGxlbWVudGF0aW9uLg0KDQpJIGhh
dmUgbm90IGRvbmUgYW55IENQVSBiZW5jaG1hcmtzIG9uIHRoZSBzbG90cyBzeXN0ZW0sIHNvIEkn
bSBub3QgYXBwcm9hY2hpbmcgdGhpcyBmcm9tIHRoZSBwcmFjdGljYWwgcGVyZm9ybWFuY2Ugc2lk
ZSBwZXIgc2UuDQpJbnN0ZWFkLCBJIGFyZ3VlIGZvciBzZXBlcmF0aW9uIHdpdGggcmVmZXJlbmNl
IHRvIHRoZSBTZXBlcmF0aW9uIG9mIENvbmNlcm4gZGVzaWduIHByaW5jaXBsZS4gVGhlIHNsb3Rz
IGZ1bmN0aW9uYWxpdHkgaXMgbm90IGJ1aWx0L2Rlc2lnbmVkIHRvIGNhdGVyIHNlY3VyaXR5IGd1
YXJhbnRlZXMsIGFuZCBteSBwYXRjaCBpcyBub3QgYnVpbHQgdG8gY2F0ZXIgZHV0eSBjeWNsZXMs
IGV0Yy4NCklmIHdlIG9wdCB0byBtZXJnZSB0aGVzZSB0d28gZnVuY3Rpb25hbGl0aWVzIG9yIGRp
c2NhcmQgbWluZSwgd2UgaGF2ZSB0byBpbXBsZW1lbnQgc29tZSBndWFyYW50ZWUgdGhhdCB0aGUg
c2xvdHMgZnVuY3Rpb25hbGl0eSB3b24ndCBiZWNvbWUgc2lnbmlmaWNhbnRseSBzbG93ZXIgb3Ig
Y29tcGxleCwgd2hpY2ggaW4gbXkgb3BpbmlvbiBpcyBsZXNzIG1haW50YWluYWJsZSB0aGFuIHR3
byBzaW1pbGFyIHN5c3RlbXMuIEFsc28sIHRoaXMgcGF0Y2ggaXMgdmVyeSBsaW1pdGVkIGluIGxp
bmVzIG9mIGNvZGUsIHNvIG1haW50YWluaW5nIGl0IGlzIHByZXR0eSB0cml2aWFsLg0KDQpJIGRv
IGFncmVlLCBob3dldmVyLCB0aGF0IHdlIHNob3VsZCBkZWZpbmUgd2hhdCB3b3VsZCBoYXBwZW4g
aWYgeW91IGVuYWJsZSBib3RoIHN5c3RlbXMgYXQgdGhlIHNhbWUgdGltZS4NCg0KQERhdmU6IEFu
eSB0aG91Z2h0cyBvbiB0aGlzPw0KDQo+IE9uIDI4IEp1biAyMDIxLCBhdCAxNDoyMSwgVG9rZSBI
w7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gTmljbGFz
IEhlZGFtIDxuaGVkQGl0dS5kaz4gd3JpdGVzOg0KPiANCj4+Pj4gRnJvbSA3MTg0MzkwN2JkYjlj
ZGM0ZTI0MzU4ZjBjMTZhODc3OGYyNzYyZGM3IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KPj4+
PiBGcm9tOiBOaWNsYXMgSGVkYW0gPG5oZWRAaXR1LmRrPg0KPj4+PiBEYXRlOiBGcmksIDI1IEp1
biAyMDIxIDEzOjM3OjE4ICswMjAwDQo+Pj4+IFN1YmplY3Q6IFtQQVRDSF0gbmV0OiBzY2hlZDog
QWRkIHN1cHBvcnQgZm9yIHBhY2tldCBidXJzdGluZy4NCj4+PiANCj4+PiBTb21ldGhpbmcgd2Vu
dCB3cm9uZyB3aXRoIHRoZSBmb3JtYXR0aW5nIGhlcmUuDQo+PiANCj4+IEknbGwgcmVzdWJtaXQg
d2l0aCBmaXhlZCBmb3JtYXR0aW5nLiBNeSBiYWQuDQo+PiANCj4+Pj4gDQo+Pj4+IFRoaXMgY29t
bWl0IGltcGxlbWVudHMgcGFja2V0IGJ1cnN0aW5nIGluIHRoZSBOZXRFbSBzY2hlZHVsZXIuDQo+
Pj4+IFRoaXMgYWxsb3dzIHN5c3RlbSBhZG1pbmlzdHJhdG9ycyB0byBob2xkIGJhY2sgb3V0Z29p
bmcNCj4+Pj4gcGFja2V0cyBhbmQgcmVsZWFzZSB0aGVtIGF0IGEgbXVsdGlwbGUgb2YgYSB0aW1l
IHF1YW50dW0uDQo+Pj4+IFRoaXMgZmVhdHVyZSBjYW4gYmUgdXNlZCB0byBwcmV2ZW50IHRpbWlu
ZyBhdHRhY2tzIGNhdXNlZA0KPj4+PiBieSBuZXR3b3JrIGxhdGVuY3kuDQo+Pj4gDQo+Pj4gSG93
IGlzIHRoaXMgYnVyc3RpbmcgZmVhdHVyZSBkaWZmZXJlbnQgZnJvbSB0aGUgZXhpc3Rpbmcgc2xv
dC1iYXNlZA0KPj4+IG1lY2hhbmlzbT8NCj4+IA0KPj4gSXQgaXMgc2ltaWxhciwgYnV0IHRoZSBy
ZWFzb24gZm9yIHNlcGFyYXRpbmcgaXQgaXMgdGhlIGF1ZGllbmNlIHRoYXQgdGhleSBhcmUgY2F0
ZXJpbmcuDQo+PiBUaGUgc2xvdHMgc2VlbXMgdG8gYmUgZm9jdXNlZCBvbiBuZXR3b3JraW5nIGNv
bnN0cmFpbnRzIGFuZCBkdXR5IGN5Y2xlcy4NCj4+IE15IGNvbnRyaWJ1dGlvbiBhbmQgbWVjaGFu
aXNtIGlzIG1pdGlnYXRpbmcgdGltaW5nIGF0dGFja3MuIFRoZQ0KPj4gY29tcGxleGl0eSBvZiBz
bG90cyBhcmUgbW9zdGx5IHVud2FudGVkIGluIHRoaXMgY29udGV4dCBhcyB3ZSB3YW50IGFzDQo+
PiBmZXcgQ1BVIGN5Y2xlcyBhcyBwb3NzaWJsZS4NCj4gDQo+IChBZGRpbmcgRGF2ZSB3aG8gd3Jv
dGUgdGhlIHNsb3RzIGNvZGUpDQo+IA0KPiBCdXQgeW91J3JlIHN0aWxsIGR1cGxpY2F0aW5nIGZ1
bmN0aW9uYWxpdHksIHRoZW4/IFRoaXMgaGFzIGEgY29zdCBpbg0KPiB0ZXJtcyBvZiBtYWludGFp
bmFiaWxpdHkgYW5kIGludGVyYWN0aW9ucyAod2hhdCBoYXBwZW5zIGlmIHNvbWVvbmUgdHVybnMN
Cj4gb24gYm90aCBzbG90cyBhbmQgYnVyc3RpbmcsIGZvciBpbnN0YW5jZSk/DQo+IA0KPiBJZiB0
aGUgY29uY2VybiBpcyBDUFUgY29zdCAoZ290IGJlbmNobWFya3MgdG8gYmFjayB0aGF0IHVwPyks
IHdoeSBub3QNCj4gaW1wcm92ZSB0aGUgZXhpc3RpbmcgbWVjaGFuaXNtIHNvIGl0IGNhbiBiZSB1
c2VkIGZvciB5b3VyIHVzZSBjYXNlIGFzDQo+IHdlbGw/DQo+IA0KPiAtVG9rZQ0KDQo=
