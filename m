Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922B5442B5B
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 11:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhKBKJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 06:09:40 -0400
Received: from mail-eopbgr40046.outbound.protection.outlook.com ([40.107.4.46]:3396
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229924AbhKBKJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 06:09:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myPvC4P8DAikJD9bH0TYt5s90DgdpR8kPsYgUIxc/c6rLE/Xrju4V/+tZOmmLaFQqCIr/f8X6BSpMEhs5NyHr7Crhyater7viO1meEd383++Nuuzmkvql+sSVMzaS64rIYQ59mp953yYPHhTfxL03KM2+DE3FLP7mNQk64tkRsC6zzRPVV0m61yEcQN0bSsfRy/Pif+3l0lvm0Tod3cGPC8fjuwEoh3MXNs/P/Krevf8v22FmdcXLQ8fJ6c4df/BYBvSkFYtyv6DC4Z/KUYIEqBWaki6sy77EmbchHXeVxRIlvluYZk2k7J+W2xdj9ChAYMd5U1fyvaVXr2Dw9ibLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pJawuseNggWhKTKint/u3dq5NhSwJEN4RVcT4qK34Rk=;
 b=WtlVd/W2FqYwupKjtf++3tAr9D8UaTLKbC4thykESz8L5tSMM9CKGtXhs4azYfCJgrBMj+R5Ssy0VrbJ+gb/V1UzO+UmmF5D8YLyOV6uaqqbZhDOghkFyDhosmB86a0dJmZ/FT57kiI9amTyGW1D0x9u0AHXA5qCDitYnvMlCO7/dY0lMEUK+yDQEwvsGsNymp9lVRksjr1uSgV6ZVfNa036hNBy+S42WvIxNJ+o9920NTU6977cylo6yBgqtdnuxQK9Izq2HMzAjem1U/2khLxfMPlXCLQYSoDDrDfkYj+AuXGXFOLKI5h/XKygbs1gnK9Xe6P5uwTvTBDaI1Qglw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJawuseNggWhKTKint/u3dq5NhSwJEN4RVcT4qK34Rk=;
 b=FQUx3VQ3JLctLthy5WSbhziuLfi8Wof1SEmZKNBowCjrdGwG5lEXH7DdU7cwY2VCkdzujW5csv0RkMV1q4PTnkZDYOD8YvScleu7o7OsK99yN4oDKFblhWVQ7Y0CSG69T0SmsJRzgHYyViLKlkBDvlpsAAuEAo5huF0Pb404Rxg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 10:07:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 10:07:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?gb2312?B?QWx2aW4gqeCoomlwcmFnYQ==?= <alsi@bang-olufsen.dk>
Subject: Re: [RFC PATCH net-next 0/6] Rework DSA bridge TX forwarding offload
 API
Thread-Topic: [RFC PATCH net-next 0/6] Rework DSA bridge TX forwarding offload
 API
Thread-Index: AQHXyoZGgvljE7NVe0S+/ReovjrXSKvwDbYA
Date:   Tue, 2 Nov 2021 10:07:03 +0000
Message-ID: <20211102100702.72u2abq3mft45svo@skbuf>
References: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ab08ffd-d0a4-49cf-2cdd-08d99de884c2
x-ms-traffictypediagnostic: VI1PR0402MB3839:
x-microsoft-antispam-prvs: <VI1PR0402MB3839B3A995FD7C0B563E969AE08B9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aJuY0iCLE3rrh8790NGVtvxlWt4M4P0kD9vb/YxGfII1utxugQB1Xgp6MPt4pWY7NLexxrP06333ktTSEkIdb6xakKcqyVxNnK5xFAJKXAf+sDe8LldhJ3p8McM464SYjwl3wQkNwjYjjV3scNW8VObo2CRg5zpC4JV3MVy9NV77o38GaaxJChsLTRe2f1xCSEz54AvkWXbskTCspXCeJG0s7840HVE7cGwgDkRQK0WGisz1RAGHuK94RZfkOArvFmUaw2pib/OOP3kVyAloIjXiZmf/8jy0uL5+Jk/5nwTNB6qVtl5ZV8EQUDdSx/4+aGD3U9mvI/JCpzqp2Am91MJSg/pCFhEvtsmqUbPSLmbBgtq6nKfAZLgvVwp39I0vYbC+KHr0ewCARnc1Hp+C7DModX5bl5VRUp9XsElGhVuH126ZvdrWVkUT1jJCteUQD/suL+EmH88Nz5YZOeAQgQdiz7K+SZMY/th8Y0smRtpboc32tCBkev13c4gS/vEQOMwZSdeS98toqQPpTcA1ORHjAfUEvL3HPK0oyiq+/eUknpsDGEege6+LY7NNlMvaguxeo9W7gI56K7F/g+UwuPYW8nqblUcnnuqhJ83XOv1BbmxWOKV7ygf+ljErgTqbXc0tHZ1+jGKqQQ5n3UhX/u7klr5iyUTleEME3BdjXAh3DC0ESu4f9sh00zZqvQRzaBxQ7UG1U7BbKAucb1gTqPrrduJ6dwXmYEEb0JlQMGpJ0zbB/sBq3+LzypN/y2MxDDttGeZ2LBYayh1kEiZFB65DPXveIgyPieuRRFfFwOY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(122000001)(6916009)(186003)(966005)(6486002)(83380400001)(508600001)(2906002)(54906003)(91956017)(38070700005)(76116006)(44832011)(8676002)(1076003)(8936002)(6506007)(38100700002)(66476007)(66446008)(86362001)(33716001)(4326008)(316002)(66556008)(64756008)(26005)(71200400001)(9686003)(5660300002)(6512007)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bTlPV1ZkcktyRytjelZiWkVUb09TNk1QRXNMcTZDUnp2cnlLckRUVFJVWE43?=
 =?gb2312?B?RHVJNVJYcmthMnN5a1M1ZXNnQ1F2LzlTNXhVdDYwQmkvN3R5Qyt5c05oVWtj?=
 =?gb2312?B?QkFiL2NZUTU1VXpINm5Rdjd1SGI2bFI2ZjhVTFcrdXVTbUpZZWp5WHppUnFp?=
 =?gb2312?B?Q3Uwb2JDUlJqdFVwUFQrNnRnN09kWjFZbFlBZGJyeHpNc1UrQUdvcnFkc011?=
 =?gb2312?B?aEphcVVUTWJiT3prRkk4K0JrQ2V2UTlNbHdEVE1OOG16ZTAwY0Jqc2FvQzRM?=
 =?gb2312?B?Vm5NVzFONXl6RWU1NU5OaS9seWxBWTlxS2Q4NEdpQXlobGJ4d050cVBkUlRC?=
 =?gb2312?B?SmphODUxQTVBZzBHSThIUHJ6N3lzcmNINDNLeSsxSW4rUXN6eGJjODZheFFt?=
 =?gb2312?B?MExTbTBFWEhOdGdMRllpRzlJQlEwMEdQakgwTS8vWkxISjJRTjY2c2xPN1Bj?=
 =?gb2312?B?bFIxakxTNWtNaGN4ZGNCM1JXcHduRG1LWWFJWHNTUlBONW5VTjNvMGszRTM5?=
 =?gb2312?B?dlVYeW9rMUZ1ZVBIbTNUL2diM3FYTlpjcWh0d2ZSNHR0akdrM0dNVWh4elJ5?=
 =?gb2312?B?M09UdlBmMGdmbk5nSXBkYy9zUWtPSUdJcVJMT1ZMSi8rV3oySmVMa0tGVkhh?=
 =?gb2312?B?bklzcC9NQ0gvS1Vkanl3Y1ZGSkMxQTJIb0ZnUHNNNUtkajNoWVhLc0M2WnA1?=
 =?gb2312?B?QmZySFhlbk1rTXUraFZSSHhTeUJCS3AzaFJKcU83dzVLaHdDcWlGV0JKNFlB?=
 =?gb2312?B?V1dEazBmMjlBK3lKN211TnI5UTErMFZkNmlhdkxGVHBEc0t2Mzd6NlRENGpQ?=
 =?gb2312?B?K0M0SnExVFVvby9SbWNIaFlhN1BIUE9NeEV1dU5ERlA1Y3RhT0s5dFBlUWpy?=
 =?gb2312?B?Q3FvTDZUbVNPZ1QvTzh0cjd1SDFkc011Z3JFZ25IZDBuQ1J6VVZQMjloYTVB?=
 =?gb2312?B?eFVmUkxFRmZ1d1hyTitXMkV5UkU1OE9kN2hQVW1PNlVjbDVZaENyQWlNL0Zn?=
 =?gb2312?B?ZHcxanpJKzFVUUZnTzE3M0Y5cEtvMzJMWUY0eHVURGZxRFU1azFEeDN5RDE4?=
 =?gb2312?B?NE90YmYrMG5IVmpzTnA4cGlRcXVPZ2c3MHNLS0FUMGtXUzFFb0FzOWVMR3FR?=
 =?gb2312?B?bXplQ0M3T3E3TWhycTFyQS9QQWM3Qzh2M0NLT1IvYWV2NFN2TnJUbVR6Zmkv?=
 =?gb2312?B?Z0o3aHpHUjBvVnJYOExxMklFQlI2eHVIdXkwalJtcm40OTZkeG1TeEQvUDZY?=
 =?gb2312?B?dCt5c0Z6K29EVTlOVlBZVzNKazBONWtOaUxYNUh4eHJvUWJkQU4wb0FIemRO?=
 =?gb2312?B?R1kvWUZqeHFEVE1ZZzdtODNZaUZzdG1SMklncXVpbEk5NlFHQXFZaDNWKzBV?=
 =?gb2312?B?TWNNVjBXR2wySTlVTTFwaExXU1pJZG9tdmlFSVBKRlBEL2d6WnVqalM0bW9I?=
 =?gb2312?B?alRXMERYamNnUVlQMm5hSFFEVFRaa2VuVmxTS0F5ZEpaa2RYaTE1MjQzMTlC?=
 =?gb2312?B?S3JLTDJDR3Zqem9PcUh0TkJWQzdjZzFnYk1LdExsUEd5a3FSb3ByK0Rja01n?=
 =?gb2312?B?UmpmVm5TTlFMaXpEZGZUNjhmMGVxVGoxcjJQOWxObmJKaHhwM0V3UDU3N0Fv?=
 =?gb2312?B?WUl3VlJpTmd0WGFnY3lGK0hXak10T05hOE5UcE1CT0hWS3hYSXkrZDgwK0pX?=
 =?gb2312?B?UkcrRTU4dkVUa1IzajNCanNQQVdjNzRiK3J0ODJ3bTUrRExhelJxU3Uxa0FL?=
 =?gb2312?B?dm4xS1BrRW5KZmVBSHRLVlFLMW1tbmdDU2wyUW1yS2cvVXFYR0lxRUxpVEhF?=
 =?gb2312?B?d3pkamg3aEptZFZGUHEyMHVKWThOWVA0Zi9UVkhMVnBtYjRSRG5Gdk5QRXJp?=
 =?gb2312?B?ekhvSjJsUmllNUcxZXV0SXVEL29sSzd6eCsvZkVGekQwSGV0YUJaU3RMWTBy?=
 =?gb2312?B?bjZxRXFBY1NaekJHbHBKY2xCR05XQzl4MlM5Mjd3OW4wTEJTU1lrWFRmQVA4?=
 =?gb2312?B?Mk1GOVFGTzdnRDRTUm5hbDI0bFUvMlRaTUN1TmlldHdaVkFrZm5nb0w0RTVN?=
 =?gb2312?B?eXhvZWlkeFExdWhOQW9nOFFYak55OEFxU1dYUGExNVNvVmRSTXR4VHlLdlhw?=
 =?gb2312?B?SnJJSnFIQlpvWTUyTExCS3dBWXZLWWJzejlKTnlBSnY3K2tBOUFMQjAzMTl2?=
 =?gb2312?Q?dOCMLk0oIYMo0vgqp6fZNhE=3D?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <CC925FAAF3AAD1479BEF4C9A5C54FA16@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab08ffd-d0a4-49cf-2cdd-08d99de884c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 10:07:03.3588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zJKUzqPqUYfnpL6xmAS1B+kc785R4r1HBxOMOs69tLcC+DrgpMGhhA8/N5PMiuJml8Ah0X10T195YR6nuJYqFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBPY3QgMjYsIDIwMjEgYXQgMDc6MjY6MTlQTSArMDMwMCwgVmxhZGltaXIgT2x0ZWFu
IHdyb3RlOg0KPiBUaGlzIGNoYW5nZSBzZXQgcmVwbGFjZXMgc3RydWN0IG5ldF9kZXZpY2UgKmRw
LT5icmlkZ2VfZGV2IHdpdGggYQ0KPiBzdHJ1Y3QgZHNhX2JyaWRnZSAqZHAtPmJyaWRnZSB0aGF0
IGNvbnRhaW5zIHNvbWUgZXh0cmEgaW5mb3JtYXRpb24gYWJvdXQNCj4gdGhhdCBicmlkZ2UsIGxp
a2UgYSB1bmlxdWUgbnVtYmVyIGtlcHQgYnkgRFNBLg0KPiANCj4gVXAgdW50aWwgbm93IHdlIGNv
bXB1dGVkIHRoYXQgbnVtYmVyIG9ubHkgd2l0aCB0aGUgYnJpZGdlIFRYIGZvcndhcmRpbmcNCj4g
b2ZmbG9hZCBmZWF0dXJlLCBidXQgaXQgd2lsbCBiZSBuZWVkZWQgZm9yIG90aGVyIGZlYXR1cmVz
IHRvbywgbGlrZSBmb3INCj4gaXNvbGF0aW9uIG9mIEZEQiBlbnRyaWVzIGJlbG9uZ2luZyB0byBk
aWZmZXJlbnQgYnJpZGdlcy4gSGFyZHdhcmUNCj4gaW1wbGVtZW50YXRpb25zIHZhcnksIGJ1dCBv
bmUgY29tbW9uIHBhdHRlcm4gc2VlbXMgdG8gYmUgdGhlIHByZXNlbmNlIG9mDQo+IGEgRklEIGZp
ZWxkIHdoaWNoIGNhbiBiZSBhc3NvY2lhdGVkIHdpdGggdGhhdCBicmlkZ2UgbnVtYmVyIGtlcHQg
YnkgRFNBLg0KPiBUaGUgaWRlYSB3YXMgb3V0bGluZWQgaGVyZToNCj4gaHR0cHM6Ly9wYXRjaHdv
cmsua2VybmVsLm9yZy9wcm9qZWN0L25ldGRldmJwZi9wYXRjaC8yMDIxMDgxODEyMDE1MC44OTI2
NDctMTYtdmxhZGltaXIub2x0ZWFuQG54cC5jb20vDQo+ICh0aGUgZGlmZmVyZW5jZSBiZWluZyB0
aGF0IHdpdGggdGhpcyBuZXcgcHJvcG9zYWwsIGRyaXZlcnMgd291bGQgbm90DQo+IG5lZWQgdG8g
Y2FsbCBkc2FfYnJpZGdlX251bV9maW5kLCBpbnN0ZWFkIHRoZSBicmlkZ2VfbnVtIHdvdWxkIGJl
IHBhcnQNCj4gb2YgdGhlIHN0cnVjdCBkc2FfYnJpZGdlIDo6IG51bSBwYXNzZWQgYXMgYXJndW1l
bnQpLg0KPiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuDQo+IA0KPiBWbGFkaW1p
ciBPbHRlYW4gKDYpOg0KPiAgIG5ldDogZHNhOiBtYWtlIGRwLT5icmlkZ2VfbnVtIG9uZS1iYXNl
ZA0KPiAgIG5ldDogZHNhOiBhc3NpZ24gYSBicmlkZ2UgbnVtYmVyIGV2ZW4gd2l0aG91dCBUWCBm
b3J3YXJkaW5nIG9mZmxvYWQNCj4gICBuZXQ6IGRzYTogaGlkZSBkcC0+YnJpZGdlX2RldiBhbmQg
ZHAtPmJyaWRnZV9udW0gYmVoaW5kIGhlbHBlcnMNCj4gICBuZXQ6IGRzYTogcmVuYW1lIGRzYV9w
b3J0X29mZmxvYWRzX2JyaWRnZSB0bw0KPiAgICAgZHNhX3BvcnRfb2ZmbG9hZHNfYnJpZGdlX2Rl
dg0KPiAgIG5ldDogZHNhOiBrZWVwIHRoZSBicmlkZ2VfZGV2IGFuZCBicmlkZ2VfbnVtIGFzIHBh
cnQgb2YgdGhlIHNhbWUNCj4gICAgIHN0cnVjdHVyZQ0KPiAgIG5ldDogZHNhOiBlbGltaW5hdGUg
ZHNhX3N3aXRjaF9vcHMgOjogcG9ydF9icmlkZ2VfdHhfZndkX3ssdW59b2ZmbG9hZA0KPiANCj4g
IGRyaXZlcnMvbmV0L2RzYS9iNTMvYjUzX2NvbW1vbi5jICAgICAgIHwgICA5ICstDQo+ICBkcml2
ZXJzL25ldC9kc2EvYjUzL2I1M19wcml2LmggICAgICAgICB8ICAgNSArLQ0KPiAgZHJpdmVycy9u
ZXQvZHNhL2RzYV9sb29wLmMgICAgICAgICAgICAgfCAgIDkgKy0NCj4gIGRyaXZlcnMvbmV0L2Rz
YS9oaXJzY2htYW5uL2hlbGxjcmVlay5jIHwgICA1ICstDQo+ICBkcml2ZXJzL25ldC9kc2EvbGFu
OTMwMy1jb3JlLmMgICAgICAgICB8ICAgNyArLQ0KPiAgZHJpdmVycy9uZXQvZHNhL2xhbnRpcV9n
c3dpcC5jICAgICAgICAgfCAgMjUgKysrLS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAv
a3N6X2NvbW1vbi5jIHwgICA1ICstDQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9j
b21tb24uaCB8ICAgNCArLQ0KPiAgZHJpdmVycy9uZXQvZHNhL210NzUzMC5jICAgICAgICAgICAg
ICAgfCAgMTggKy0tDQo+ICBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2NoaXAuYyAgICAgICB8
IDE0NSArKysrKysrKysrKystLS0tLS0tLS0tLS0tDQo+ICBkcml2ZXJzL25ldC9kc2Evb2NlbG90
L2ZlbGl4LmMgICAgICAgICB8ICAgOCArLQ0KPiAgZHJpdmVycy9uZXQvZHNhL3FjYThrLmMgICAg
ICAgICAgICAgICAgfCAgMTMgKystDQo+ICBkcml2ZXJzL25ldC9kc2EvcnRsODM2NnJiLmMgICAg
ICAgICAgICB8ICAgOSArLQ0KPiAgZHJpdmVycy9uZXQvZHNhL3NqYTExMDUvc2phMTEwNV9tYWlu
LmMgfCAgNDAgKysrKystLQ0KPiAgZHJpdmVycy9uZXQvZHNhL3hyczcwMHgveHJzNzAweC5jICAg
ICAgfCAgMTAgKy0NCj4gIGluY2x1ZGUvbGludXgvZHNhLzgwMjFxLmggICAgICAgICAgICAgIHwg
ICA5ICstDQo+ICBpbmNsdWRlL25ldC9kc2EuaCAgICAgICAgICAgICAgICAgICAgICB8IDEwMiAr
KysrKysrKysrKysrLS0tLQ0KPiAgbmV0L2RzYS9kc2EyLmMgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgNTcgKysrKysrLS0tLQ0KPiAgbmV0L2RzYS9kc2FfcHJpdi5oICAgICAgICAgICAgICAg
ICAgICAgfCAgNTkgKystLS0tLS0tLQ0KPiAgbmV0L2RzYS9wb3J0LmMgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAxMjMgKysrKysrKysrKystLS0tLS0tLS0tDQo+ICBuZXQvZHNhL3NsYXZlLmMg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAzNCArKystLS0NCj4gIG5ldC9kc2Evc3dpdGNoLmMg
ICAgICAgICAgICAgICAgICAgICAgIHwgIDIwICsrLS0NCj4gIG5ldC9kc2EvdGFnXzgwMjFxLmMg
ICAgICAgICAgICAgICAgICAgIHwgIDIwICsrLS0NCj4gIG5ldC9kc2EvdGFnX2RzYS5jICAgICAg
ICAgICAgICAgICAgICAgIHwgICA1ICstDQo+ICBuZXQvZHNhL3RhZ19vY2Vsb3QuYyAgICAgICAg
ICAgICAgICAgICB8ICAgMiArLQ0KPiAgbmV0L2RzYS90YWdfc2phMTEwNS5jICAgICAgICAgICAg
ICAgICAgfCAgMTEgKy0NCj4gIDI2IGZpbGVzIGNoYW5nZWQsIDQxNCBpbnNlcnRpb25zKCspLCAz
NDAgZGVsZXRpb25zKC0pDQo+IA0KPiAtLSANCj4gMi4yNS4xDQo+DQoNCkFueSBmZWVkYmFjaz8=
