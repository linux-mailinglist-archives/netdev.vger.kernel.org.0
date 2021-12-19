Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F81E47A2FE
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 00:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhLSXVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 18:21:38 -0500
Received: from mail-vi1eur05on2138.outbound.protection.outlook.com ([40.107.21.138]:1967
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233859AbhLSXVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Dec 2021 18:21:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZI1EY7XEnvVzUOEvVOwu88DIwjjUgVzFF0j4ntcQ4HZOmT58N+S45d5S2cUlSG9WyzRBXGfrcGyYc0juYHIVAbr7UfuluCX02G8t6VYj/syOM0XeGkeHdu5amnW8g7IqFqA/TjfTk+chY1AlKrkKFJdT7v+tuGZsruAr0n/hsTMrbuz7qz++WrDlNzC3/fy7nK8HDrP5e+mL+TlLjt1A5DLQlNZdW+5ReZtABVv/nl4hJxKrXBT+ZGXrWANtgnDCihZdfl4HQqxBKZL2D8+InMg+Lwro9E9OihOxwI8Y2iOJIqVnJylSVwY3mHuK0AyT7dnlBN4ncuhPFAvxOCUg4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26H5JL4qkaOpSSYYRX2KY76n7pw7qcqzrKwGRqjktHs=;
 b=Bu1CKeewdGcP4v7QXTbfhIbEPM2sqw/jJ0R8oq42HmhWUSvHMMN+NerHUGsotaifJzYrWjyKqvRTT+SvBhsyj2gqXphQtklQ9gxwbgSQukcTH+hSROQHgLsa7TJIDcT4tiwcmsvrxxF2cr03ApAgKJPd+6KWykpt5hU8fz0zDyAt7KkgHNEUK/7LrQVCDQNwghEPgno3qaCdz6KE9RuO0NJlONypZbmfu83g791R9KVlhRrOJsEElDkGcJEQGe0nhSwSSYjJEvl05UC84HFnOhzMTXz47PsMKY5vFkKCvAriJx+V5iLwpHN8Bpwv8BojHsYL7rcNzHrMm3F+F06NMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26H5JL4qkaOpSSYYRX2KY76n7pw7qcqzrKwGRqjktHs=;
 b=Qy7zKQuS+gGqN67ur7hVM/hgKpq6iJTFcdhoOruLHAaJuC6kKyBiIDmoN0l0TErEBCUvn96pWjwq7e/uusI8b9mYWI+AnmOycmk+pjehqimV+RBOsV1y2NOKGPbjB+/rDnMGyWIcU9eGm/1zUppRSRFbP08jJ9BJXieX782RkEg=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB3941.eurprd03.prod.outlook.com (2603:10a6:20b:1e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sun, 19 Dec
 2021 23:21:35 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4801.020; Sun, 19 Dec 2021
 23:21:35 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        "luizluca@gmail.com" <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next 06/13] net: dsa: rtl8365mb: move rtl8365mb.c to
 rtl8367c.c
Thread-Topic: [PATCH net-next 06/13] net: dsa: rtl8365mb: move rtl8365mb.c to
 rtl8367c.c
Thread-Index: AQHX8rmJluWPz7jddUehvfgcyWf89qw6anaAgAAOagA=
Date:   Sun, 19 Dec 2021 23:21:35 +0000
Message-ID: <cf0fedc1-4743-55f1-424f-8f08137e10b0@bang-olufsen.dk>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211216201342.25587-7-luizluca@gmail.com>
 <CACRpkdZxc+97aqpuE+4JK4_Pf+gv4zRd7U2QvJAb5mur-VucKQ@mail.gmail.com>
In-Reply-To: <CACRpkdZxc+97aqpuE+4JK4_Pf+gv4zRd7U2QvJAb5mur-VucKQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fe03f7d-4caf-4bab-4735-08d9c3464cf5
x-ms-traffictypediagnostic: AM6PR03MB3941:EE_
x-microsoft-antispam-prvs: <AM6PR03MB3941B4A661E51126EF8FC32C837A9@AM6PR03MB3941.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IllxuIxbb95s54Re9kVHPzgOtSAI/RULKImNeMNJsCy9Kbxf0zox7CGUla2R41aPESbZC9Zj3qoUiV/EiZqeXRqujTAN4esqeK0u654G7kOobmpDr8uQnW/Ees3Lu7qOBXmMpNy87NK+RO6I/u0lukbsjt1lWVGzvNgz11MrGzlAIbiYSF5hrKYqGnLcBmREZcavMy7VWPoR4LP7Etn2e3+9JK+PLLgNUckq/V3TBpiCfJbrDkcQq/X3Oo/F8OnPhNrhecs/IZcKhBovBeBytRHjZzBWB8Z9vCPqCRBo6mlj2ePl0eAJLVmdtoDge3HhzI9XR/yn1MvkGhp/UTE6qBJ8lWk+ua+anVDWQA2CMAaVtBvk7iSbJkRqIpnKbb1vofD/PsM3IorRxFvWXh7uppMSpDXRBaKkdAFzrzCWjRxdSSjKMahxRC6XOWbSoop0UU9FakTDCWjPPhGDQgBbl7ZOJr29yhuZfT94d3hrc4/NQb9qApG9jIeLA9np974K9f4TqqX8xfSRqUnORC2MKKSkDEIeAP6qkDqiGju1jVeBI0EEbmgP3R6xBt2jiXruAjKVKmmqiaFRGihihIJAOE5Zggo0yoSqmP1wBZBIwYV2dp6Up9Il7HSkw5V1TP51y4fYHvu7PR18QhOG4FKPQpmPqkbwaCjOZymnDje/Sfru33qwHSo30N4rWcffoBsEBk9992fnxc65yt/NVDGKzfs0X2WCAq6XdJsAAgEpJyQvmy3ezX6CdCurJ//X8wdEOUJ+APbon80SY2Z7ZRAKoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(38100700002)(2906002)(6486002)(316002)(38070700005)(2616005)(5660300002)(110136005)(31696002)(4744005)(85202003)(86362001)(31686004)(66446008)(4326008)(36756003)(66476007)(66946007)(508600001)(8936002)(66556008)(64756008)(85182001)(6512007)(76116006)(91956017)(186003)(54906003)(26005)(8976002)(53546011)(8676002)(6506007)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cC9UUzBQZElndTViWU9rb1Z6N2NOMWMvdVZRTW45bXF4Rk8zdUpMbGF0SG5q?=
 =?utf-8?B?ZVRIVncxdEc0aElqYnloNGptMEJLRkNEc1p0aHpxT3VoVWM5RjNRMDNvMHRB?=
 =?utf-8?B?UEEwZzNxOVpnRjdIMmhwdURHRzZaZEtxdnFKV1IxRkZ0VUExUjREeWdOcXBw?=
 =?utf-8?B?ZStvN25OQ0VmcHg0YmxRU09VRXBmS3prbm1TdDFXclRNWXNHQ015TXhXN2lO?=
 =?utf-8?B?SUdtM3RhK1pVRWtXV1BxVFZ1bXlIQU9peFdQNlZiZW9IdDFvOHZ3VDBvT0hn?=
 =?utf-8?B?emJZTWMxOFBieFlZcWtaSE5zcVNNdHRtN0E4eGp4VnNrbDVJVzluUVdzTHBw?=
 =?utf-8?B?OFcrR0VNNWFJYzdOSUZxTUNqWkwvNHBYeGZWOWdyQU1tODM1NzNUb3pCM2Z3?=
 =?utf-8?B?K2xMQXRqeGh3SGxHa0ZRM01pU3kyVTdrOStvci9IWEliZWRhOU1SbnUrWVlp?=
 =?utf-8?B?TGU0b0lUSzBzQnRpYzdwRTdGMWxUODBMZU1IMlArUGZ5clZDWk9RcUZ4L0VI?=
 =?utf-8?B?RmdWTlBBU0VIejR0MHNlNFFGQ3U3QUlnZitNSVkyeEJMc1lSMFRPZFY2UGZC?=
 =?utf-8?B?TitiSW1HRWxJRjBHZ0k2dXZLQUEvYllDdmhEckFTTTN5NzNtMkplV2hGQmZM?=
 =?utf-8?B?SHJGVUtNdjRIdWZ3L3JUaUFMUVN1ejhBWDR3VzNpc3JTZzhaRlpCSjhuUTAw?=
 =?utf-8?B?MTRZME9pVU5JRWxMN0hSTHJ1Ym95NlZ2Z1I4SVJjNUFGejdZU0NKZWRJN0Yz?=
 =?utf-8?B?VkluMGNkK2ovYjg1L1dRTnVJdnhXWi9CaSt5OXowNmdMVHRRNlhTTWFmeTgw?=
 =?utf-8?B?b1VSR09PV09WVlV4N3RNTWt5NWM2Q1dZTitDYWN2cnRtRUhrQVU2Sk1UVzMy?=
 =?utf-8?B?akFuUkhzc2FjTHRCeFExQlZBdU9DaEcvOWUyRkZ1MC9mT3Qwdzd4czdXQVUr?=
 =?utf-8?B?enVHamt0ZUNENlJ1MXpRaTFSQk5pVFlMVVNUdzhsV1JDcW9FUDhRWTU5L1BW?=
 =?utf-8?B?K2MzTXgyTVpTSlV0am5lVHNnSzM1SitYYnFIeFBYT0JvZHhDMUxjNi9qUHFM?=
 =?utf-8?B?dTlDS1VtcFRSTitHVGtiY2lPK3FVTE5qMXE0S1RHeUJqZmJodHM4QmpGOVQr?=
 =?utf-8?B?eFUrVExjaUdmS0FTK3dJNWphQVRtVjB3cEpCeGZSalptZmNaYjlBMExtTnFJ?=
 =?utf-8?B?dXFOYnRLVW5IZlU4d0grdjBZYU5OamhncWRKWEpsQitsTkVheEhLN0toVnUv?=
 =?utf-8?B?WlBXczQxemNrQmVKTEZJY2hGcENmektzcGFqbi9NcmFBaTV5Z0pwbmgraUtz?=
 =?utf-8?B?QkduRFdSVjRpUk1WT3pXOUhBOGZtWGM5YmRZMzV0NVZXK2Zjd051dlB2cWl5?=
 =?utf-8?B?Si93T2t0cFVNNC9xeUZVM0QxY3pCVFRsL2VYWjVGRnNYNHdtQjRQV2FWYWYv?=
 =?utf-8?B?dzk2N3Zwck52VUxQMEZ5RHdUc1BISjRrVGFhYjF3b1dLQUZZNDJFVFpYZC9u?=
 =?utf-8?B?a0JSUDRVeXl3a2szNGJSNzN3QUFobkRnVEx2bTl6VlJicTZHMVZYQXlqeHAy?=
 =?utf-8?B?RnBpc1NQNzJoWVZNSWVac3UrUkllcjlkNGsycWlEUW8xZzdsNGZKNXU1NEs0?=
 =?utf-8?B?Z0p2b3VQdkZDVTdoenJHUUxHWXJERlY5STJpV0MzZnZFc2xvTTFZcHBBRzZ0?=
 =?utf-8?B?MGpmaXB2YVN1VjBmZ29ZK0ErYjlUS1NQR3ZSbEh5NUtBSjBIYjNwN2Q1ai9i?=
 =?utf-8?B?Rm81bmQ2cWoraGNzZUg4dGpzbSt6SlV6djdScFFuRGs4TTZhbWhpQjNma2tu?=
 =?utf-8?B?RE9lTlE5U3pQblFXNm1LN3FkWXpUeUlPdFhJRVJTdjFTdDd1THlDRTZNNWsz?=
 =?utf-8?B?TnFoY3BxdUpLOTNZZ251MlFBbk9xY1FWaDR6QWY3eDBETW85eWVhZ2doaVhM?=
 =?utf-8?B?NU56dU9pWkRTYlVObEZETmV0ekdtekZickZuaTN5SGVSRzJOa2lXODM2OHJ4?=
 =?utf-8?B?Y2dEQkNsMEpCcEZiRXpuK3RaTE54SGV2bnc0aXhvajdHNTVMN0hTMS9RdmhJ?=
 =?utf-8?B?RnN3V3NpRW55a1NqVjlEMXU3NUpkdm00QkZmckw4NThOcnpSZCt3YjdaQ2J0?=
 =?utf-8?B?L3dLM1Vxb01iekxOSDJYNUVyQlQ3ajJ2T05FWm5iM3JBcHRpRmZuTk8wa2Yx?=
 =?utf-8?Q?1eW3SoU3ZWjRykZ2+kl26exsMGfdoK8rsJpoE3CNt95Y?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C747A51B3843B748828D5BA457FD6D57@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe03f7d-4caf-4bab-4735-08d9c3464cf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2021 23:21:35.4655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WCvxV0nkyvAbTbxQcHP8hSBZ04OLedjQudhh1I3EdrJa2M6WP9Tv5HS8mEaN2cn+qqlZQ46oUAUiNk5BNzam8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB3941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTkvMjEgMjM6MjksIExpbnVzIFdhbGxlaWogd3JvdGU6DQo+IE9uIFRodSwgRGVjIDE2
LCAyMDIxIGF0IDk6MTQgUE0gPGx1aXpsdWNhQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPj4gRnJv
bTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0KPj4NCj4+
IFRlc3RlZC1ieTogQXLEsW7DpyDDnE5BTCA8YXJpbmMudW5hbEBhcmluYzkuY29tPg0KPj4gU2ln
bmVkLW9mZi1ieTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29t
Pg0KPiANCj4gQWNrZWQtYnk6IExpbnVzIFdhbGxlaWogPGxpbnVzLndhbGxlaWpAbGluYXJvLm9y
Zz4NCg0KV2F0Y2ggb3V0IExpbnVzLCB5b3UgYXJlIHJldmlld2luZyBhIHN0YWxlIHNlcmllcyAo
djIgd2FzIHBvc3RlZCBhcyBhIA0KZm9sbG93dXAgaW4gdGhlIHRocmVhZCkuDQoNCkkgYWxyZWFk
eSBjb252aW5jZWQgTHVpeiB0byBkcm9wIHRoZSByZW5hbWUgZnJvbSB0aGUgc2VyaWVzLg0KDQoJ
QWx2aW4NCg0KPiANCj4gWW91cnMsDQo+IExpbnVzIFdhbGxlaWoNCg0K
