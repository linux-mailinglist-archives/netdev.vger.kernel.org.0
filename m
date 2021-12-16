Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9A14780C8
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 00:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhLPXmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 18:42:02 -0500
Received: from mail-vi1eur05on2100.outbound.protection.outlook.com ([40.107.21.100]:59233
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229449AbhLPXmC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 18:42:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUCrED0+TiGw5cZNjqpLVaqWWuDDCSolyIC3F15kYwlFGB9YAZ+xtb8r+ml+27Iej89faKKswzrpzUXbE/OOfVk2FIJCO5DXFRBTHNfaHLUx3mjmIl5Pvtbg3eVX3t238awmgvPsZaOMa+ZXKvyYZQ/4/jvE8xCgoGftST6L+Ofz6dQHUNu7oy2IrvaGdyMWS8UNeoWq6Ev2tLhGTfeGoSX1iC7hSg7eKws2s8mCSkLaCiSpmSsy5rgVBdz9yHkRl+MIHrZswrcQplOefczwL6y3jJq9uSpgg+PAW7ZmGjSwyzgtDRJDo0tS8GoPnIFz2YWZCEdAitsNAYiMvaDFDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YkbAPbqsBXzkce0Ft3ESr1O4jb+D0ESu+WAA2lBRZwU=;
 b=FW5Ts6aN7tIofeZWhugOI0IRoHFOzdygoP15Jp2wCW9R2+PKgHL+Jwq9m8/Psw+6BGweGW6PUv9eZgdlWcDTv7TKjTa/+GrU3AzLOdaUZXNUtjTDxgL5CTuiC20QmBsOLTWH+0nPqYZaHH1WBq/qIryItXb2lvEujbAvTRXjxxp9K8qSbLfslCUV71uj7S45mT24wCfx8IBXFlyaHNXMtnV3bjxve4I5IH/WkrSeXqHEz6/UmLE1xrQuGlgKN7bq39rxb27E+Q6BuS1SvIwnoy1Z6Gb0/t7XR5PZ1ODV4/z42nZOBM8IJ1szK2wwHxW8PB5PXwK1QWoJjz+usaBdtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YkbAPbqsBXzkce0Ft3ESr1O4jb+D0ESu+WAA2lBRZwU=;
 b=gMewXz9Rb6hmCjx3vx/LqvQVxfXdXdq4o83Iu/MqlqLC0mKtMQejOYEOTa7XhR/ZvMiIfhiHKwNS5yhEhIXmwxpna7VbHURdpKs4JTWHHEsX4PFRorVIKaVI4u4aBJeUMaEj7JIp+LgtpA7zXy/TIBlFFt5gJld575yCxKn8W3M=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB4200.eurprd03.prod.outlook.com (2603:10a6:20b:1::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Thu, 16 Dec
 2021 23:41:59 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63%3]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 23:41:59 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     "luizluca@gmail.com" <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next 07/13] net: dsa: rtl8365mb: rename rtl8365mb to
 rtl8367c
Thread-Topic: [PATCH net-next 07/13] net: dsa: rtl8365mb: rename rtl8365mb to
 rtl8367c
Thread-Index: AQHX8rmMkZSipe1IR0+5ApncYZHGFaw1x5WA
Date:   Thu, 16 Dec 2021 23:41:59 +0000
Message-ID: <1fbf5793-8635-557b-79f2-39b70b141ba3@bang-olufsen.dk>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211216201342.25587-8-luizluca@gmail.com>
In-Reply-To: <20211216201342.25587-8-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54478378-4469-4268-b8fb-08d9c0eda76a
x-ms-traffictypediagnostic: AM6PR03MB4200:EE_
x-microsoft-antispam-prvs: <AM6PR03MB4200CAD1B61E0FD0320A92D783779@AM6PR03MB4200.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +l8WrjgccXdZWl0WdwDHdajVpm7WIIqtK/k1PW+uj8uu3td2l77SklFJ+6cqzWhsGryILcvF5Q3OT9Y4FZWM6t+OWXpzNqrlZ/8/yyN9EL8u5Rw7w2PCbVJYd64gtPQdVU4nombuIuKeyUwQ1uOoGBQm4p96rNOofRhn0xo49UvE1dIWUl3r8RieZfwfPwt+BEjqSIurvk6r2TcO2qIQC3BgjdAOAn7f5PEBosCH35s//Oic0CbG7KROFeHJFlRSyrZAqqRn5ZTqmM5WK0BTgVc2isaxgmH8GHeVOtmN9M4wrEPeZlAP8pvV6t8SAyJe4WqbNmU0Cu1KmbmCACVjfX/C0Lxi+MxrzdvKU+CRFRnuRvQ4Qi9QHoOniNjek0HjS+PN/CgF1vFKlfJIFxuTC5zpJuzgFJtHd+7Y1soQCAApYzvScnraPRx8W+0islO2BiIqyNX6hvw6A1VDSLlp24r1G+9CiOIxLf8AuY3XjgzjrXhEDVBAYMB/BpUhNcIk2K4gj0zvDj7iUjD9VGvDTeZ8laVFe8KJNZ4deoW99tI25gekgvf2ItmeGyT/TcLFQfzG2p2JevRbjygGXShX0y+dDwj34Kol+VRg89+Eoudr2Hf5h4AVgZRllV3yxoASLemgByT7DXwt/UetxFgq+DHxBgNk4Pu8TigXb3inNU4Ny5CSVOj49TofpbyFH1XqGaXH2Z8uxjLg8dppxK2N+ETQIUyrW/5ZP3WOHkFAbUp+lBc96JYJPgSw5GvfnXoRBX6s7UYFj0uejtLduru2lQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(86362001)(64756008)(2616005)(66446008)(6486002)(110136005)(54906003)(316002)(85202003)(38070700005)(186003)(8676002)(8936002)(31686004)(4326008)(8976002)(2906002)(5660300002)(38100700002)(83380400001)(122000001)(508600001)(36756003)(26005)(31696002)(6512007)(91956017)(71200400001)(66946007)(66556008)(85182001)(53546011)(76116006)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmVPdWFwQ2FCWWxjVHE2bmhzMDFqT2owT0NpdGlnR2UxTEc4aFFlaENKTmhD?=
 =?utf-8?B?Z2tJWllSYlI2RmZYT2ZrTVljRENvaVhubC9SZmNUMEZMb0srOUJYWkZrRU50?=
 =?utf-8?B?NXBqWkFHNnRiS0dWajZoWmIweUZtTXh5L2ZSeHRSM0ZJQUF1US9KMVBnZjQw?=
 =?utf-8?B?SXM1UGF1cHBmK3JmUDk4OHdJUW05amRvN1NUazNWMUpwb1oybTFNa0lsSmdq?=
 =?utf-8?B?ZytkUlRyWWg4dEdxVnFCcXRVaXo2QWVZUUNRWkxiaGNXY1lMQkdWaGlEaUc3?=
 =?utf-8?B?bGRETDlodzhQTEVUL2VUUUFjZWhQRlB5WjlxWE1kMTNVSThLNFgyMjVkLzFi?=
 =?utf-8?B?cXVYU04wekFtc0FUb2dmVVNFYlZqR3NJTitKZ0ViaStFVndSYUpmYjkvZUhs?=
 =?utf-8?B?NmF5ZVI2TURzT3ZrYXRwNjNVVExFZUoybElaVGY1cjRqTEJvbXhlOEcrc2Mx?=
 =?utf-8?B?Vzg1c3NwajNJWlEyS3JYR3ZIWjFRSjFzM3hlZUYzbFRyNHBFcmlCSkhuekpk?=
 =?utf-8?B?QWtwQlFFQkwwa0FnL2J5K0dpWWFJeWt0TjRiRSthYXZQVVVIZnhGTy9BV1pt?=
 =?utf-8?B?bnkxbTRMeHVrZ0lVMlkvVnFmUXoyODBtM3F6ZU4ydXBlSXg0UXR5SGxJQWQy?=
 =?utf-8?B?cG9YVDJtT3RNMksrS2YydnZDdEpld2tVSEYzWG56TTJnZENTWWVOUngrVXhX?=
 =?utf-8?B?ZDVWVGhadmZ5bDhMOGFBVFRpcjJzQSsydFhMSUJTc1JxbGNsN1lvVkRpTWI1?=
 =?utf-8?B?c3lZV3pjMUdteUYzK0ZHZWlhUzg0bDBSaU90SHZrcEt4RzlwMmUwK1QrUUR0?=
 =?utf-8?B?K1RtVFJvUnIrTVdpNk9obG5RK3F6RnJlMUVKbHA2NnpaRjVDUWpjcXQrcUxi?=
 =?utf-8?B?WFlMcVQyNUF5cnVHWGtFTEkyVDJnejJBRjR6YTVTTFR1Q1h0RDF4RUEyQjBM?=
 =?utf-8?B?di9HQ0VKN2F0SisrTjQ2emVwK2I2a05nNU5lTHBrZi9sYktZb2NZS2dzUDRv?=
 =?utf-8?B?UDR1Wlg2VEc0K3ZkQmg3WnZscG9QQ3NVbUxrN29SNnprNnhEZ21PZVZRbThW?=
 =?utf-8?B?b1phUFJGNnVBQ0ZkdFk4eENMR2tJM0EzeUc5dlR2clVPazN0WjZRT3Z2WGJO?=
 =?utf-8?B?bHBVL3o3MnkxcDhDeDhyUUI1K2tqaG5RSHFEaDV4Q0NPYWtSUjBQYmFUZEhu?=
 =?utf-8?B?NWdkNVNqTmFwYnJ0bFlwdFFkam5RME1YY1M1aFlzMVQyclRsUUMzaW1iUVhI?=
 =?utf-8?B?aU1DaWVrd1ZocEU3S09nMXBEeUEybnFSbm83Si9qYnZ0LzNzbEpPTFVwR3Y0?=
 =?utf-8?B?QkF4NWxBYW1tZVBJNjZHbUswK1FNbFk3bkY4QVFob1pvUSt4RHNLQUhzeDB1?=
 =?utf-8?B?eGFuNTc0cXZtZ3Uyb3BqNy8vWDE1UFdPaDI3ekVPVEJBdGowZkFUTEwxSHVO?=
 =?utf-8?B?YnRDaTljRlEwbmNhQ0QrKzV1Y0ZrMjhJWnVONTBta3VIT2dWZnQ4K0JJRmc3?=
 =?utf-8?B?MzdtN2p4S1JSMytncXBPMlFOZmE1aVZIczFvNUJHeTd0djRTaksxZU1RQVI4?=
 =?utf-8?B?UWM3RmlWZW5temZ1MFVVaEorY2QzZmxybS9wVHdXY20rRmFra3F0aDdwV1U4?=
 =?utf-8?B?Qkh5alBLYk9iazNCQjNaZEREWWtYTERlMmNlUDVLQmJkZ3l2bERINGR5VXVh?=
 =?utf-8?B?bEZKTFZCMkJLZzk2Z2x4M2trY0dteWZJMFhrdHRWNzRzbmJXTEJwbk4vc20y?=
 =?utf-8?B?a25aOWkxM2cyejVvMUFXcWhFOVlNQzYvVGxwa3lsQXlzdFN5Z2llMVdhcjRw?=
 =?utf-8?B?ekliclB0WXNUbjc4TDZDcSs5WllJd3huWVM1a2x2V2R2SUxjcjlmb0xBL0lM?=
 =?utf-8?B?UTJJOW1vMVVZOVlJL0M5bDEzSGlQckg2S1BuOG5jc09CT29PS0lSbkhad1k3?=
 =?utf-8?B?c1k4akZiTGpaakZ4Vm1kZ2Iyam01Zm45ZCtqUXlBaEYwSldiTmViUFVTK0Y5?=
 =?utf-8?B?Z3hBaHJKMU04dllLdE0xVmErWklrSXIwVWRLMGNEYkhxbEFjWldCU0d3QzlW?=
 =?utf-8?B?dDg4aUFxZERFcnJDV2pPUVZ1cnJkN2crWHFlZlZydVlDUXhjL0VuZXFncWx3?=
 =?utf-8?B?K01odG5LTTRUckJJSXE0aFY5NGtXUDFid0o4UWhqVmdYS3Z4NzRpc1NtNVdK?=
 =?utf-8?Q?3oyPAqKRrHa+q11fbnmY/Wc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29BE8ED27DBB6544A633E80E290EF480@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54478378-4469-4268-b8fb-08d9c0eda76a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 23:41:59.6907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KoVPkx7DFhmuVggE+9F7Yd98SRj4bP2LkQINzufXBh9keAiRH+INRGaieRve1Hv6v73I4wLZy4/ZTz9tFzb2vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTHVpeiwNCg0KT24gMTIvMTYvMjEgMjE6MTMsIGx1aXpsdWNhQGdtYWlsLmNvbSB3cm90ZToN
Cj4gRnJvbTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0K
PiANCj4gcnRsODM2NW1iIHJlZmVycyB0byBhIHNpbmdsZSBkZXZpY2Ugc3VwcG9ydGVkIGJ5IHRo
ZSBkcml2ZXIuDQo+IFRoZSBydGw4MzY3YyBkb2VzIG5vdCByZWZlciB0byBhbnkgcmVhbCBkZXZp
Y2UsIGJ1dCBpdCBpcyB0aGUNCj4gZHJpdmVyIHZlcnNpb24gbmFtZSB1c2VkIGJ5IFJlYWx0ZWsu
DQo+IA0KPiBUZXN0ZWQtYnk6IEFyxLFuw6cgw5xOQUwgPGFyaW5jLnVuYWxAYXJpbmM5LmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21h
aWwuY29tPg0KPiAtLS0NCj4gICBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay9LY29uZmlnICAgICAg
IHwgICAgOSArLQ0KPiAgIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL01ha2VmaWxlICAgICAgfCAg
ICAyICstDQo+ICAgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1zbWkuYyB8ICAgIDQg
Ky0NCj4gICBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLmggICAgIHwgICAgMiArLQ0K
PiAgIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjdjLmMgICAgfCAxMzIxICsrKysrKysr
KysrKy0tLS0tLS0tLS0tLS0NCj4gICBkcml2ZXJzL25ldC9waHkvcmVhbHRlay5jICAgICAgICAg
ICAgIHwgICAgMiArLQ0KPiAgIDYgZmlsZXMgY2hhbmdlZCwgNjY2IGluc2VydGlvbnMoKyksIDY3
NCBkZWxldGlvbnMoLSkNCj4gDQoNCklzIHRoZSByZW5hbWUgcmVhbGx5IG5lY2Vzc2FyeT8gTXkg
bG9naWMgaW4gbmFtaW5nIGl0IHJ0bDgzNjVtYiB3YXMgDQpzaW1wbHkgdGhhdCBpdCB3YXMgdGhl
IGZpcnN0IGhhcmR3YXJlIHRvIGJlIHN1cHBvcnRlZCBieSB0aGUgZHJpdmVyLCANCndoaWNoIHdh
cyBtb3JlIG1lYW5pbmdmdWwgdGhhbiBSZWFsdGVrJ3MgZmljdGl0aW91cyBydGw4MzY3Yy4gVGhp
cyBzZWVtcyANCnRvIGJlIGNvbW1vbiBwcmFjdGljZSBpbiB0aGUga2VybmVsLCBhbmQgYnVsayBy
ZW5hbWVzIGRvbid0IG5vcm1hbGx5IA0KYnJpbmcgbXVjaCB2YWx1ZS4NCg0KSSB0aGluayB0aGUg
dmVuZG9yJ3MgbmFtaW5nIHNjaGVtZSBpcyBjb25mdXNpbmcgYXQgYmVzdCwgc28gaXQncyBiZXR0
ZXIgDQp0byBzdGljayB0byByZWFsIHRoaW5ncyBpbiB0aGUga2VybmVsLg0KDQoJQWx2aW4NCg==
