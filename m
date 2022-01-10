Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFE84899B8
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbiAJNWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:22:42 -0500
Received: from mail-am6eur05on2101.outbound.protection.outlook.com ([40.107.22.101]:34719
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230248AbiAJNWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 08:22:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvxxIkKo+JkPNRiCwcwf+u+56zmOR7njmA/eAORPYIoVFEI1utndyFFH4StaxWjrfCALu8EOd2jbJQo0M5wlYLN/idNGBOPbKbckreF4bJB4RH2FU6OEdIuGUs47jUyzIYAHo3mWwAMNW+h99V6U3sBmiA/6LQ0WsOR78/Nu2/g/HQFDL756RkFK04J8btTcd1bR4qADV6MK5rINIJPBnzOvwk+0F/8niVpsVtF/DI1NunWQNZZjp+/b83Y2EGt00Z/ULVew2IHsqD/JYyVJm1TuB0K6XQvgQEpkG90PdRa+QlLqca/DpU/FS7Q6fSjCXeYLXakJ6vHZfZSbYqdGFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjaGgfgexWd7nmY/dao/0EUt5p3lmgKylZ1EFZ62gVo=;
 b=UDNt7gTwO127+yaQnKyh7F4jh2ibyvxzTR7+kHX94cULic02htq8sBbe2rhixokfj6kXtVewP4eRxH93ogQLz1CJjqPfQNmwYKQqr+1bjHL+vUARq1Aw0ek8wWIHlRmfXr10/Z2DI8xcOJ6kDBjjR5jm5LxhhB24MLa5Eo4LnOJHwRipMjhoO6VaOOUgRvRhGz9QoecH4F0apeZBJ97BezzFWmOpnEomAh5ll+gnqyhWSsy7gxn0u/qNAd6m9EyL7LGPFjJwBE3Gysj0Z1HuoRyVOqC3Mg2Koa8e3YVc3ARXZcYNTxLiBIwJkfESI8tgdlpL6ttP/UDw9iu9oFBrSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjaGgfgexWd7nmY/dao/0EUt5p3lmgKylZ1EFZ62gVo=;
 b=ao7yjZYFUC/fEHx0707aaWoOmMqvT5mikymxmKPzbp1B8kVzR/LIgHPKMCymNgEENht+tOlV69+MgKP89acqSltzIiQFCHt8Pi9m1+Sy1xYJYlVQ0GzJOUruVl2qNtLVIGnuhV0KzEFF5m3ZNtgOdBQCztB8CSZzvPeOcSa/lug=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB4517.eurprd03.prod.outlook.com (2603:10a6:20b:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Mon, 10 Jan
 2022 13:22:38 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 13:22:38 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>,
        "frank-w@public-files.de" <frank-w@public-files.de>
Subject: Re: [PATCH net-next v4 09/11] net: dsa: realtek: rtl8365mb: use DSA
 CPU port
Thread-Topic: [PATCH net-next v4 09/11] net: dsa: realtek: rtl8365mb: use DSA
 CPU port
Thread-Index: AQHYAeKZQsYvCWuC8EWFkVDzHVST8g==
Date:   Mon, 10 Jan 2022 13:22:38 +0000
Message-ID: <87mtk3d8te.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-10-luizluca@gmail.com>
In-Reply-To: <20220105031515.29276-10-luizluca@gmail.com> (Luiz Angelo Daros
        de Luca's message of "Wed, 5 Jan 2022 00:15:13 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3598d887-bee1-4478-6af1-08d9d43c45d2
x-ms-traffictypediagnostic: AM6PR03MB4517:EE_
x-microsoft-antispam-prvs: <AM6PR03MB4517BD7F64B770EE70871A3583509@AM6PR03MB4517.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N3xKxTnFqk3r+RoN5CTxplkj4koPnaCpf1TEJ4hQGPoE5NYQp2thn1QDDe12YEkMA/JezSuuE8raYrHagcAHbTiZW9ww4HMnINgnnlWH93FBkh0GVo8MY85VVeIMi9RaLQ8eJQx1AhmAzRACvw8HVhyVx/QdalScYSi8563pKxmLd/2nMSydxR2dEs8oYC56t4NHeX/2tjtvYz6UQK79fzorcGuqVpgPlJu4t+BLfgOc9Bv34eWu59Fo4FfASDxFzEGD6bmkAP+tJ9hc96+1XwO6Kz4jozzuE544x3TaY+b7wn5IX3ORlb69sx+94TfSw2ehFXhEIWPPkejNxEogGXTgiyp0oK0exg2HzhkrMJdnb5m7tfyds2c3/ZPqMpUJfEq524DNo4oDjkga8X8bD8u5gib//+cRxYLWAEdNwMsRBO1rvGAP5zR+Kw3Y5mSnYM5jkuznEDF5LGuHcQ2K/h941y0T10XlzHFkf15l3URHHRMZxSo1Mv26rcOXOt22C2n/YpnhWYHb4bZVn+GjOmuWNA+WiZcxoK5vZ+/1Y7o/uGxmmOn/S3vf+U8+ahWMiDKdtLD846Vcv6gRczTH8V+oW46XityWRCX3S8vQR+vg3rsUKeJ3uDctuKqbZTJWFc8O/mqO6akvR7oVs2GOVl3NogBw3pN/TEKXcfMIYT05a31Kq9eiMmMgoRGirZbJWrjjr4VJRoIUqVPXeBf6bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(4326008)(38070700005)(91956017)(64756008)(54906003)(508600001)(2906002)(6916009)(36756003)(6486002)(122000001)(6512007)(8936002)(85182001)(5660300002)(85202003)(2616005)(76116006)(71200400001)(66476007)(26005)(186003)(8976002)(8676002)(66574015)(66946007)(66446008)(38100700002)(86362001)(66556008)(316002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STVZOHVYajYrRllJWkFNS2NIWk12SnNEcXdnendFUjBnd1VSdnJqK1pBTllT?=
 =?utf-8?B?T3VXZWxxWmh0ZG8ycFZJYThkRHdhdHQ4K2Qwd3pwbkdsaWpQVHUzd3BQOXMv?=
 =?utf-8?B?RVBjeTBZQXNOcEJjdVlrRXZHY3NzTG9TZjJjVUdvZURnamszaDBmbnVTdGFT?=
 =?utf-8?B?TVpzY0NRc3JwUGhmRnllWENvVXFML243WnZZam1HWnRqeXl0RGMzZy9Sck55?=
 =?utf-8?B?UGZRWTg4d1dDQ1gzU1RiOEVOOWtHUWJnQ0tVYVdMa1lFNGpvcDFaUkk3TEU2?=
 =?utf-8?B?UGJ6SFNFdTRpajdVNnRjdVNQSmQyMXdEK20xYXB2bGN5V2xYRFUxc0s5endP?=
 =?utf-8?B?cTduOGozb2RUV0NpSzAzMDJ0WnJ4b2l5bk5yT2lIRlFLbUl1WVRyMm9GVy9P?=
 =?utf-8?B?WG5XSmRrODVOQm8zQ0crUXVqTjgwWGlGK09tSGlMdU8zdzhWdXk4b2VLVmZi?=
 =?utf-8?B?N0lwUUNYUTJ6bDZXYVNPSDd4Z2tVMmpZRzFGU3VrMEQ3enJYWldXcnQ0NWpL?=
 =?utf-8?B?eUJBT0NyV2FNeFRaS3BIVmk3Lys3TmpiVFhiU3AzYk04Ny9IZUlSdEJITnB0?=
 =?utf-8?B?N2F3L2xXSWlDTmN5M0gzTUZ1NDZMb2FhcStEaHJUQnE3Q0xoenF2bmVSbUxs?=
 =?utf-8?B?TmZ6Tm1reHN5dDQvcXJYdG1qVXVBMTNKZjhkeXQvcS91OFAzY2gxTVZTcEJX?=
 =?utf-8?B?d2hHTW8yaVRFSFVJb3cyZ1VMS1djUkNqRVk0TDFocWlhQnBWc3EzK2NRV2ln?=
 =?utf-8?B?SklIR2lwVDJ1ZU14WG42bGlIdEkvQzZ0L2V2d09pQ0hKNXltQ2taUklvemNR?=
 =?utf-8?B?MUV6U3hYSytQOHRKQTlqOFRYMjkxTlBOVlFBTFNWb2xibTJkNnpJd1lNU1lM?=
 =?utf-8?B?anlxR05pM2NtcnZHN1cyY1NkRDlIaEVGZCtIY3hFaFZONXhTOGtLeS9rNFMy?=
 =?utf-8?B?b1QyRUFXYWZOTkMyT1l3U0VWQUxFazFFTTNHaE42Yzg4Q0I0YndxdmRtSmVI?=
 =?utf-8?B?MDFaT2JIRzJjR2tkTTZqbmVyUnBTU2VFblhSS0VIbHg0YnVQall0cWc1VVZl?=
 =?utf-8?B?K2UrMTlyYVJWR1BRQ2RRMlZSbHh5SC9ja0QzNW9sNTJYYkpkZFBETG1iaEFR?=
 =?utf-8?B?cTZGSkptb0kvMTBORnFvVW9rUmxhTldEZ1lrYmpJaWZLRWF4NFVtM1FxcGtQ?=
 =?utf-8?B?U2R5UTk0cGNMUk5TWXp5WHNwREhFYjFpdlRKTTBGV1RvZ1I2Qk9FVkZWY0tR?=
 =?utf-8?B?R3QrS0cxKzBNZk43OW44dG5yeHIrQWY4TnNnT2c0bTFiNWw5bUxVS2xFVXo4?=
 =?utf-8?B?VWZQWVpiTVgvZys4d2lzc2FZWXVQY0I1UU4yN2ZucTZKcGJkQnJqQjVjdXBH?=
 =?utf-8?B?QVFVWVA0V3N2V3g0a2VybXNBbUJJemJUT2I4akhrRnozbnJNWG9PTTFDNnNG?=
 =?utf-8?B?UC9kcUdvT3k3bXRveFBlTG5qRHBaS1ZobnZVUW1XZWo5MStVZkEyTDNIWlJN?=
 =?utf-8?B?Vi93TEVMTjBWK3F4bkRkMEs4RjVGNERPUFhIOFZGdWh0eDhmOUlWMmRESlZK?=
 =?utf-8?B?eVgzaDFrcVF6SUl2VG1jbENDOWFOVzFSWjZGK0cyWE10UEdLVW5MUHpJUEJC?=
 =?utf-8?B?dCtERUpHVDN2eFpEbktjNU5Mckk2ZitOVmU4VHpZRHVBeWpBUktrSjJ1VmlR?=
 =?utf-8?B?ZVRSdVl1cWlPeDZFMm1Sbk1jdG9qdGNmY2pRK3JXK1k1elBUU2JYSXozYmEw?=
 =?utf-8?B?RkViVXlLcUVFTGlTalRlRkorMFJRMkh3TCsxeTA5WnJjWkhmREM2NE1pRWpu?=
 =?utf-8?B?dVhHajR0MjJJNFJHREtqMCtzYVR3bTBvSk0yaUlxS3RwRXIwMG5qTkRKZnl5?=
 =?utf-8?B?R1BOT29uR29haFNDcTBrN3l6b0FBNEU4ZjNSZTdGSE4rYUJJU1phdFRSWCtB?=
 =?utf-8?B?SW5hVFR3YmdJdlJXSlh6WDIyK3hmTTRBQngzN1E3Y0c3MEtEUllBRmVwelB0?=
 =?utf-8?B?aWNzTVlDVUVVdFdJdThlOURvRnJsckltckZ4ZUdEYk56ZjhZQmxybEV2TnVp?=
 =?utf-8?B?UDBSQVpNZVkxd1RYRmE1Z0Q3a0JIZ2hCVlFxT1BmajByT0psbmVlUnRQV1lX?=
 =?utf-8?B?eVRUZk5NbVVpb1pXZkdBK0hrdXRnRS94ZDBKdjV2ZlRtWDdlSVRmR0NhdkNK?=
 =?utf-8?Q?gIQ1H+ltZkxdjsykVP4crec=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F965DF0E23C0FA4BA9B77109BC5F345C@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3598d887-bee1-4478-6af1-08d9d43c45d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 13:22:38.3398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 43uDCfmKQp99zS0KSYPwiN2TdDxN1vjaqDWFsDBJNnIuw3Aq6d1YkumRDYEqWVf9olF188gLByCLhK/Muzr65Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4517
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gSW5zdGVhZCBvZiBhIGZpeGVkIENQVSBwb3J0LCBhc3N1bWUgdGhhdCBEU0EgaXMgY29ycmVj
dC4NCj4NCj4gU2lnbmVkLW9mZi1ieTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1
Y2FAZ21haWwuY29tPg0KPiBUZXN0ZWQtYnk6IEFyxLFuw6cgw5xOQUwgPGFyaW5jLnVuYWxAYXJp
bmM5LmNvbT4NCg0KV2l0aCB0aGUgd2FybmluZyBmaXhlZDoNCg0KUmV2aWV3ZWQtYnk6IEFsdmlu
IMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4NCg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0
L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIHwgMjMgKysrKysrKysrKysrKystLS0tLS0tLS0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0KPg0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1iLmMgYi9kcml2ZXJz
L25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYw0KPiBpbmRleCBiMjJmNTBhOWQxZWYuLmFkYzcy
ZjA4NDRhZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1i
LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1iLmMNCj4gQEAgLTEw
MywxNCArMTAzLDEzIEBADQo+ICANCj4gIC8qIENoaXAtc3BlY2lmaWMgZGF0YSBhbmQgbGltaXRz
ICovDQo+ICAjZGVmaW5lIFJUTDgzNjVNQl9DSElQX0lEXzgzNjVNQl9WQwkJMHg2MzY3DQo+IC0j
ZGVmaW5lIFJUTDgzNjVNQl9DUFVfUE9SVF9OVU1fODM2NU1CX1ZDCTYNCj4gICNkZWZpbmUgUlRM
ODM2NU1CX0xFQVJOX0xJTUlUX01BWF84MzY1TUJfVkMJMjExMg0KPiAgDQo+ICAvKiBGYW1pbHkt
c3BlY2lmaWMgZGF0YSBhbmQgbGltaXRzICovDQo+ICAjZGVmaW5lIFJUTDgzNjVNQl9QSFlBRERS
TUFYCTcNCj4gICNkZWZpbmUgUlRMODM2NU1CX05VTV9QSFlSRUdTCTMyDQo+ICAjZGVmaW5lIFJU
TDgzNjVNQl9QSFlSRUdNQVgJKFJUTDgzNjVNQl9OVU1fUEhZUkVHUyAtIDEpDQo+IC0jZGVmaW5l
IFJUTDgzNjVNQl9NQVhfTlVNX1BPUlRTCShSVEw4MzY1TUJfQ1BVX1BPUlRfTlVNXzgzNjVNQl9W
QyArIDEpDQo+ICsjZGVmaW5lIFJUTDgzNjVNQl9NQVhfTlVNX1BPUlRTICA3DQo+ICANCj4gIC8q
IENoaXAgaWRlbnRpZmljYXRpb24gcmVnaXN0ZXJzICovDQo+ICAjZGVmaW5lIFJUTDgzNjVNQl9D
SElQX0lEX1JFRwkJMHgxMzAwDQo+IEBAIC0xODA2LDYgKzE4MDUsOCBAQCBzdGF0aWMgaW50IHJ0
bDgzNjVtYl9yZXNldF9jaGlwKHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYpDQo+ICBzdGF0aWMg
aW50IHJ0bDgzNjVtYl9zZXR1cChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMpDQo+ICB7DQo+ICAJc3Ry
dWN0IHJlYWx0ZWtfcHJpdiAqcHJpdiA9IGRzLT5wcml2Ow0KPiArCXN0cnVjdCBydGw4MzY1bWJf
Y3B1IGNwdTsNCg0KVW51c2VkPw0KDQo+ICsJc3RydWN0IGRzYV9wb3J0ICpjcHVfZHA7DQo+ICAJ
c3RydWN0IHJ0bDgzNjVtYiAqbWI7DQo+ICAJaW50IHJldDsNCj4gIAlpbnQgaTsNCj4gQEAgLTE4
MzMsOSArMTgzNCwxNiBAQCBzdGF0aWMgaW50IHJ0bDgzNjVtYl9zZXR1cChzdHJ1Y3QgZHNhX3N3
aXRjaCAqZHMpDQo+ICAJCWRldl9pbmZvKHByaXYtPmRldiwgIm5vIGludGVycnVwdCBzdXBwb3J0
XG4iKTsNCj4gIA0KPiAgCS8qIENvbmZpZ3VyZSBDUFUgdGFnZ2luZyAqLw0KPiAtCXJldCA9IHJ0
bDgzNjVtYl9jcHVfY29uZmlnKHByaXYpOw0KPiAtCWlmIChyZXQpDQo+IC0JCWdvdG8gb3V0X3Rl
YXJkb3duX2lycTsNCj4gKwlkc2Ffc3dpdGNoX2Zvcl9lYWNoX2NwdV9wb3J0KGNwdV9kcCwgcHJp
di0+ZHMpIHsNCj4gKwkJcHJpdi0+Y3B1X3BvcnQgPSBjcHVfZHAtPmluZGV4Ow0KPiArCQltYi0+
Y3B1Lm1hc2sgPSBCSVQocHJpdi0+Y3B1X3BvcnQpOw0KPiArCQltYi0+Y3B1LnRyYXBfcG9ydCA9
IHByaXYtPmNwdV9wb3J0Ow0KPiArCQlyZXQgPSBydGw4MzY1bWJfY3B1X2NvbmZpZyhwcml2KTsN
Cj4gKwkJaWYgKHJldCkNCj4gKwkJCWdvdG8gb3V0X3RlYXJkb3duX2lycTsNCj4gKw0KPiArCQli
cmVhazsNCg0KTWF5YmUgYSBjb21tZW50IGxpa2UgLyogQ3VycmVudGx5LCBvbmx5IG9uZSBDUFUg
cG9ydCBpcyBzdXBwb3J0ZWQgKi8/DQoNCj4gKwl9DQo+ICANCj4gIAkvKiBDb25maWd1cmUgcG9y
dHMgKi8NCj4gIAlmb3IgKGkgPSAwOyBpIDwgcHJpdi0+bnVtX3BvcnRzOyBpKyspIHsNCj4gQEAg
LTE5NjcsOCArMTk3NSw3IEBAIHN0YXRpYyBpbnQgcnRsODM2NW1iX2RldGVjdChzdHJ1Y3QgcmVh
bHRla19wcml2ICpwcml2KQ0KPiAgCQkJICJmb3VuZCBhbiBSVEw4MzY1TUItVkMgc3dpdGNoICh2
ZXI9MHglMDR4KVxuIiwNCj4gIAkJCSBjaGlwX3Zlcik7DQo+ICANCj4gLQkJcHJpdi0+Y3B1X3Bv
cnQgPSBSVEw4MzY1TUJfQ1BVX1BPUlRfTlVNXzgzNjVNQl9WQzsNCj4gLQkJcHJpdi0+bnVtX3Bv
cnRzID0gcHJpdi0+Y3B1X3BvcnQgKyAxOw0KPiArCQlwcml2LT5udW1fcG9ydHMgPSBSVEw4MzY1
TUJfTUFYX05VTV9QT1JUUzsNCj4gIA0KPiAgCQltYi0+cHJpdiA9IHByaXY7DQo+ICAJCW1iLT5j
aGlwX2lkID0gY2hpcF9pZDsNCj4gQEAgLTE5NzksOCArMTk4Niw2IEBAIHN0YXRpYyBpbnQgcnRs
ODM2NW1iX2RldGVjdChzdHJ1Y3QgcmVhbHRla19wcml2ICpwcml2KQ0KPiAgCQltYi0+amFtX3Np
emUgPSBBUlJBWV9TSVpFKHJ0bDgzNjVtYl9pbml0X2phbV84MzY1bWJfdmMpOw0KPiAgDQo+ICAJ
CW1iLT5jcHUuZW5hYmxlID0gMTsNCj4gLQkJbWItPmNwdS5tYXNrID0gQklUKHByaXYtPmNwdV9w
b3J0KTsNCj4gLQkJbWItPmNwdS50cmFwX3BvcnQgPSBwcml2LT5jcHVfcG9ydDsNCj4gIAkJbWIt
PmNwdS5pbnNlcnQgPSBSVEw4MzY1TUJfQ1BVX0lOU0VSVF9UT19BTEw7DQo+ICAJCW1iLT5jcHUu
cG9zaXRpb24gPSBSVEw4MzY1TUJfQ1BVX1BPU19BRlRFUl9TQTsNCj4gIAkJbWItPmNwdS5yeF9s
ZW5ndGggPSBSVEw4MzY1TUJfQ1BVX1JYTEVOXzY0QllURVM7
