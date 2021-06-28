Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6D43B5D70
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 13:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhF1L7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 07:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbhF1L7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 07:59:49 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on071d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::71d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7187C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 04:57:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOQoZnIkwZTQOXFdq0IhGEcTRkBn8X70zd8ggJ7aZmNKmL2iO76KdPWflnZaunHROBeaYb+LSYmp1LAODxLChgK9Fzf2kSx0jO2gPJrY9OCQxyeSKeyTsnCceaOjv77Z3DrMFC9NRs/mV8LbaN9tg58b/uKR3yjawJGoppUdIgYe0WyAeBrvenV1CAAmiwZdRdJFHQZW3wz/8YiJGorbhmXvSjMUyjFW9c3k18yldBoof0WM7KHqqelBwpyRAkxHOTnbKthq2A1MK867a6BAzzxyZjFdlHBGGg8GehkK+eLSiYyeVwy2qafbImP750Ox6sfgUyVEGsWq03fwyf+G6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EPmr2iTuQD94NTiQhfF1T70TibXA+BO8QPHL1X1ZHc=;
 b=ABwqM2wN3oYrf1UBsFw0iqVmgLj6F+ydJRLAk9Y2pNOKwoeQ13LKu7xG55pg1svuPSBfh676CLQ919cZi9TVZADRIB1PlEYVGTiNpRshfhH4E6ex7SmqRT0MZD4HdGDLGTk/QBSwC4ri6CT1wmLldjmPpYEry40JQJA5cZ6rO30sNhWUh+3AoGjL5kFFd6ekO5PNkfSaJmhybF7w1Gkpmw8flrk7/CVq5cZLm9DDliafT5aqDslv7lgiK9FhS3V6qf0XtITWICTJ0VQoDiAxVLxXyITdqUdy/2TaWoxi+g5VlrN0MmmoruIkzYklJmnrhQJUnL6RG/MMN7IX+JSM0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=itu.dk; dmarc=pass action=none header.from=itu.dk; dkim=pass
 header.d=itu.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itu.dk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EPmr2iTuQD94NTiQhfF1T70TibXA+BO8QPHL1X1ZHc=;
 b=kHf5r9bRCV6ZlqPxnIkEpDz+USSRHvEx2xdfD4r3bk+CUvD4oKtEHgnJOatCtDlGb2Z4uja4rIEXsD50o13TpeGyKSirTsV0HiOQCHYbxVKTakY+odvfR2VxhIcm1PpDUmlTHAnuNmhYFgBt0cBE7CDf2wZmmjwGgOWnsVvnClniFZIlDKTf8nbjtOp8tcwsvBlUn5w8AoZ0LZSsGsnPluyRHAwi7+VoP3Hw16ZM0gcleLlierQzhwsIzXDIWfHovXG0IssGlYB9MPDhHHIkClb3d11SRhaLwJNAamSA2Cs28tbtrSzjY/tPVf+sFdICaKXop5Q/lCNL/F+/YFQFmA==
Received: from AM0PR02MB5777.eurprd02.prod.outlook.com (2603:10a6:208:180::13)
 by AM4PR0201MB2147.eurprd02.prod.outlook.com (2603:10a6:200:4c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.22; Mon, 28 Jun
 2021 11:57:21 +0000
Received: from AM0PR02MB5777.eurprd02.prod.outlook.com
 ([fe80::9832:7a6d:cf4e:d511]) by AM0PR02MB5777.eurprd02.prod.outlook.com
 ([fe80::9832:7a6d:cf4e:d511%9]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 11:57:20 +0000
From:   Niclas Hedam <nhed@itu.dk>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net: sched: Add support for packet bursting.
Thread-Topic: [PATCH v2] net: sched: Add support for packet bursting.
Thread-Index: AQHXbBBUhUqhno5k1EKsjrBYSual2KspTeUAgAADeQA=
Date:   Mon, 28 Jun 2021 11:57:20 +0000
Message-ID: <B28935AB-6078-4258-8E7C-14E11D1AD57F@itu.dk>
References: <532A8EEC-59FD-42F2-8568-4C649677B4B0@itu.dk>
 <877diekybt.fsf@toke.dk>
In-Reply-To: <877diekybt.fsf@toke.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=itu.dk;
x-originating-ip: [130.226.132.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56b40781-4cab-4240-631e-08d93a2be2a3
x-ms-traffictypediagnostic: AM4PR0201MB2147:
x-microsoft-antispam-prvs: <AM4PR0201MB21476CAB7375E30F4473BDF7B4039@AM4PR0201MB2147.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5gACgpFcwbBQ1pu+ibP/vTFs7x0fvBCdyURdFNV1I94THFKec00DgaUsMd6mKOLF2WiBRaNSHUPC5xRDBN5CYs3D8Vb4pVdh04Xegg1J3Ph8WjPz6uws1bOA1gIhxm/vz5iaXhby9E3Pr2ah/WV72UUmzqQnMmNSr68zUIHnsB3RzKeugeK0l/vPEUx2Gx3saYXRi816C5GixNZXTud7i6a4G/L8QSQxqg46G/UBj50xcqrzeV7g1bUzfzorO8guTIN/DWWFPJ2X5kDQWyespXX3BeuivV/WqDMXv7mK0u3fkQZsYTC0K6rZ5YT4vC9FsRKLhT/4aZKhEX8C7hN8ukaiX822LQwBfWI0E31UEOhHFF8ziNKj6BQlmOrqSuQIwV2VQDp/l6t0Jmr2Ja81KSxAJ3nesNipHK8nJgOYlOmwd4vzsYTnPuStdT/A3wrr5YJ7fjICxdATew4UeIL64dCKu7h5/UvynsuJyONU6DZIAE84IJSSUtiwxDi+LO1BNN4KXV9UNylOqiIxP4bI/ntaAy7KK4Ss9fwQ1+kO9qWitxOUEBmeeLjJmrkvMZ6bVKWlw1oN7qyb1kcxaQN109HXylJOwJJmArGGOHnVKPHAI6MPqojBcxsh3M/DzR7FY92sFyocnXYTJJwLRRdmrTqXE0/6FnZ7Nhot0PbLeqvl+veucLPpJX5ozQ+AKsE0h3cXk/kzPfbvF0TQ+3SzzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB5777.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39840400004)(396003)(366004)(136003)(8936002)(2616005)(8976002)(54906003)(2906002)(786003)(478600001)(6916009)(33656002)(5660300002)(86362001)(36756003)(316002)(71200400001)(26005)(6506007)(53546011)(186003)(91956017)(76116006)(6512007)(66446008)(66556008)(64756008)(66476007)(6486002)(66946007)(4326008)(38100700002)(83380400001)(122000001)(8676002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUtDR01sR0psZlhrUFdHREdhL24rL3NyTTU3TlRMZlg2azE3U2lWVzhscHpC?=
 =?utf-8?B?YXRkMnJiUjR0YUY0THhVcHV2UzZBZ2RydHE2bDhJMzltR2ZFL3haOW1SMXlR?=
 =?utf-8?B?cVFZazNkSHRON0hscGl0YTV0RUZycEdKRkw1SnhJNTB6a2FyMCt2SEtza1cr?=
 =?utf-8?B?NjBXbDFjeU0vbVo1aDNmVHpyS2MrVDE3d1JtS1VaLytFODlZdjArcitVakh4?=
 =?utf-8?B?QytQUWpSZnJCamhYQ1NHd1RBRXlZUVh5UE9JRGxSMVNIU3VkZ09Lbmg4b2lG?=
 =?utf-8?B?QXZCNXgwMFRxdjUwM2dqZGRRRWl0eXRlOWVSRTMycEdWejd2RjZ2cFB6S3BQ?=
 =?utf-8?B?QlpTMThKVDVFYlV1SmoyR0dxY1lPQmdjZkpUUElGWXVyaEVsdnZETjFCZ3VJ?=
 =?utf-8?B?YUl4Ukx5Vi9zSzhmaHg4cGRBaE8yU2pqdDFDcnBJb1lPdEJlanBIVjF2Z25v?=
 =?utf-8?B?dVFrZTNrN2lhTTJFM3NpZTBrQnN3T3ZuNlRXSWFsdEtpUWw2c0xDWDJSbnl4?=
 =?utf-8?B?ZnJMeWZDQzJsSWN6VU55Sml4UmZxeVVESDR4RS9ITm5tck8zYnpTQ2IyTFpO?=
 =?utf-8?B?TG5SU082V2ZjNVJ3YlJSU3lBamNyS3dqWDNKbkkwWk5qaG1vemZQVEVzTWVO?=
 =?utf-8?B?RU9hLzM3Yi8xaEJXbnVSRCtMTXNWSG9wT3NuSmFHbmNZZHVGV2dKNWJWTmw1?=
 =?utf-8?B?REUwaCtYVmI4Sm9xanBQUHVtcnpBaTg4cnhQM2ZYZHNRaDdvbUJZbGFxKytu?=
 =?utf-8?B?ZHN4SU9vd0crOTYwV1U5aWJORWZDY1VxRnJTeG1zMExzZ1JyYUpIYXVLL0k5?=
 =?utf-8?B?U2pXRzFNSG51aTlZVTc1cXFScG9oQXpYeEwyM0ozVEdkaEFnaTVJUGtTdUNs?=
 =?utf-8?B?dk1LTEplT1ZNOXhjK3gxeGUvNENTUU03eVo3UzlHdzg1N0oyWWNta0hnMXZU?=
 =?utf-8?B?TzF3Zm9sV2xXNGtFYW01MDA4QUdObmpSMldZMkF4SkVEQjZDa3JOelRDMHFM?=
 =?utf-8?B?WkJmY0RHcDBOYm1sSXVOU2NJMmFuOVgwV3M0NG96TzR3VnV4TDB1NDIycUY4?=
 =?utf-8?B?WWlVb09FVG9iNlNkUGxlOEtqdlVkVTIwMDZrK1ZuOENSQzVHd0kvYzZqcXJn?=
 =?utf-8?B?dWs3Slg2Vk0wTjF5bHVRbVpIbHorTEdyb0tVYk1paGJhOGlPY3JldHgyd3M1?=
 =?utf-8?B?UVFETUszemwyYTVNSjhPUko0cm9rc0w0RXcvb1Ruc1A5aXFDRzRjTGtFVVZU?=
 =?utf-8?B?SDR4ZmlnaTEwNlVYek9rSGVUdjZwc1lkcGQ3ZzZHYzZOcWJ2NlBNMzB4Ny9m?=
 =?utf-8?B?QllPY1Zib2pjaFdycGMrRTFPUzVrUFUrTCtKQTBxUEcyTy9QSUpnN090M28r?=
 =?utf-8?B?ZUhuaml6T3l0dGRSUjhXWmhPdUNwVzQrVzNONFJlQjltK1daTmVGTlgxWkZn?=
 =?utf-8?B?bmtYK1hKZXhMRWpjMjJueEpuME9zRXEyVTFreDh6ZXhwMldKMnhkbmlMOFBG?=
 =?utf-8?B?b2p1aG9OMllFdk1vb2ZCZ0k1aHFhcTNPa1FidWY5eXFvNWo0Vm1zUVZjdk9B?=
 =?utf-8?B?N3JMWE1STExMbGhDTC9PdDdib3RwM2MrSEU5TWpFZktPdEU1UmdlTDB1VCts?=
 =?utf-8?B?RzVxRlJMdVltTlJUWWIrZjVLTzAzM2pVUjRSdkk5elhSVTl1ZlcvRXhtaHQ1?=
 =?utf-8?B?bllUQzJhZDdzM3V4d3JEZGZxRnNTTTlmeGRBTkR6cmRidmNrUVRsdGJBUllu?=
 =?utf-8?Q?jxtP4sxhrBGo+nPrbo8z8m8YNCGWm3qCwpJCoq2?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <529A4566658F864EBD9C595979F1F539@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: itu.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB5777.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b40781-4cab-4240-631e-08d93a2be2a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2021 11:57:20.9501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea229b6-7a08-4086-b44c-71f57f716bdb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qDWIluW49fPSyteY/onmJlSHkTsKBttZfSYEkNPO1RWHPCl5ZuvYXGClZjUCKIP+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0201MB2147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+PiBGcm9tIDcxODQzOTA3YmRiOWNkYzRlMjQzNThmMGMxNmE4Nzc4ZjI3NjJkYzcgTW9uIFNl
cCAxNyAwMDowMDowMCAyMDAxDQo+PiBGcm9tOiBOaWNsYXMgSGVkYW0gPG5oZWRAaXR1LmRrPg0K
Pj4gRGF0ZTogRnJpLCAyNSBKdW4gMjAyMSAxMzozNzoxOCArMDIwMA0KPj4gU3ViamVjdDogW1BB
VENIXSBuZXQ6IHNjaGVkOiBBZGQgc3VwcG9ydCBmb3IgcGFja2V0IGJ1cnN0aW5nLg0KPiANCj4g
U29tZXRoaW5nIHdlbnQgd3Jvbmcgd2l0aCB0aGUgZm9ybWF0dGluZyBoZXJlLg0KDQpJJ2xsIHJl
c3VibWl0IHdpdGggZml4ZWQgZm9ybWF0dGluZy4gTXkgYmFkLg0KDQo+PiANCj4+IFRoaXMgY29t
bWl0IGltcGxlbWVudHMgcGFja2V0IGJ1cnN0aW5nIGluIHRoZSBOZXRFbSBzY2hlZHVsZXIuDQo+
PiBUaGlzIGFsbG93cyBzeXN0ZW0gYWRtaW5pc3RyYXRvcnMgdG8gaG9sZCBiYWNrIG91dGdvaW5n
DQo+PiBwYWNrZXRzIGFuZCByZWxlYXNlIHRoZW0gYXQgYSBtdWx0aXBsZSBvZiBhIHRpbWUgcXVh
bnR1bS4NCj4+IFRoaXMgZmVhdHVyZSBjYW4gYmUgdXNlZCB0byBwcmV2ZW50IHRpbWluZyBhdHRh
Y2tzIGNhdXNlZA0KPj4gYnkgbmV0d29yayBsYXRlbmN5Lg0KPiANCj4gSG93IGlzIHRoaXMgYnVy
c3RpbmcgZmVhdHVyZSBkaWZmZXJlbnQgZnJvbSB0aGUgZXhpc3Rpbmcgc2xvdC1iYXNlZA0KPiBt
ZWNoYW5pc20/DQoNCkl0IGlzIHNpbWlsYXIsIGJ1dCB0aGUgcmVhc29uIGZvciBzZXBhcmF0aW5n
IGl0IGlzIHRoZSBhdWRpZW5jZSB0aGF0IHRoZXkgYXJlIGNhdGVyaW5nLg0KVGhlIHNsb3RzIHNl
ZW1zIHRvIGJlIGZvY3VzZWQgb24gbmV0d29ya2luZyBjb25zdHJhaW50cyBhbmQgZHV0eSBjeWNs
ZXMuDQpNeSBjb250cmlidXRpb24gYW5kIG1lY2hhbmlzbSBpcyBtaXRpZ2F0aW5nIHRpbWluZyBh
dHRhY2tzLiBUaGUgY29tcGxleGl0eSBvZiBzbG90cyBhcmUgbW9zdGx5IHVud2FudGVkIGluIHRo
aXMgY29udGV4dCBhcyB3ZSB3YW50IGFzIGZldyBDUFUgY3ljbGVzIGFzIHBvc3NpYmxlLg0KDQo+
IE9uIDI4IEp1biAyMDIxLCBhdCAxMzo0NCwgVG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tl
QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gTmljbGFzIEhlZGFtIDxuaGVkQGl0dS5kaz4gd3Jp
dGVzOg0KPiANCj4+IEZyb20gNzE4NDM5MDdiZGI5Y2RjNGUyNDM1OGYwYzE2YTg3NzhmMjc2MmRj
NyBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDENCj4+IEZyb206IE5pY2xhcyBIZWRhbSA8bmhlZEBp
dHUuZGs+DQo+PiBEYXRlOiBGcmksIDI1IEp1biAyMDIxIDEzOjM3OjE4ICswMjAwDQo+PiBTdWJq
ZWN0OiBbUEFUQ0hdIG5ldDogc2NoZWQ6IEFkZCBzdXBwb3J0IGZvciBwYWNrZXQgYnVyc3Rpbmcu
DQo+IA0KPiBTb21ldGhpbmcgd2VudCB3cm9uZyB3aXRoIHRoZSBmb3JtYXR0aW5nIGhlcmUuDQo+
IA0KPj4gVGhpcyBjb21taXQgaW1wbGVtZW50cyBwYWNrZXQgYnVyc3RpbmcgaW4gdGhlIE5ldEVt
IHNjaGVkdWxlci4NCj4+IFRoaXMgYWxsb3dzIHN5c3RlbSBhZG1pbmlzdHJhdG9ycyB0byBob2xk
IGJhY2sgb3V0Z29pbmcNCj4+IHBhY2tldHMgYW5kIHJlbGVhc2UgdGhlbSBhdCBhIG11bHRpcGxl
IG9mIGEgdGltZSBxdWFudHVtLg0KPj4gVGhpcyBmZWF0dXJlIGNhbiBiZSB1c2VkIHRvIHByZXZl
bnQgdGltaW5nIGF0dGFja3MgY2F1c2VkDQo+PiBieSBuZXR3b3JrIGxhdGVuY3kuDQo+IA0KPiBI
b3cgaXMgdGhpcyBidXJzdGluZyBmZWF0dXJlIGRpZmZlcmVudCBmcm9tIHRoZSBleGlzdGluZyBz
bG90LWJhc2VkDQo+IG1lY2hhbmlzbT8NCj4gDQo+IC1Ub2tlDQo+IA0KDQo=
