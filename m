Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFA6478B2F
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 13:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbhLQMPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 07:15:10 -0500
Received: from mail-db8eur05on2094.outbound.protection.outlook.com ([40.107.20.94]:51136
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229891AbhLQMPK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 07:15:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWJzXcjkgz9LlgNSKa+u7VdyCl5u1HwjgOR8+G8SvGpvcGDU/M3AkfBtMQUHz+YLF5cwdyLOEmGhA3IhzUcNVjich7fBgpvpC9Xw4yr7Jq80kFvzdvU5O7Z0Tm/24P2Ee9YocEA1F1fKeqOlxUt9nTaaNtHInRByYKZOK2S0y7ByPgVXk8ESkFHcMMTjmftTbymFcTTCMvYkLu56J2vlIY4J8kuPY00YhzTcYETBY4qh+IgYnFpzLUfs3r9T35BXODDdyr9KTScS3SMdXeWp28t2zjdXfTr6YSYuPTSEMze2VaEAy1rNXc6V3EhjhvyYIAFS3PmRLIi2i/2v0DZJLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRfqKocxT5ApPHa+5tjzjqO9O5XdxgAosCNShyeyqMw=;
 b=NZMSJIdp2JaS6acK9jfcsuK5yn+EGtbl8T9cokhS6GlxifB5kr0S9dTwCszry2+gNfEHR1sIMilbu3JVNC7hqj/ry3dx6mclRVijn8aWvbwy24PPj+rnpSo0JLPf24zo7m1p7wVbo5rCM4+QYb4ZLfPEZyVDol0vYPkIEcb5GVCdSkye/1/9b6eKQ1pOKknHByv76gg3Yv5mEllf/pMDZH4QLFqnA5R1MFicZ5Omy7emnf88kfx+mnWSZR5QpxJU06gGTJKtCY718yik//0h4TmqyKNWZBPZes4XeK0ZMTxAu3Oveq+RP2gthcs4qBkSVm2gPW46gmmAYG9SapeyBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRfqKocxT5ApPHa+5tjzjqO9O5XdxgAosCNShyeyqMw=;
 b=H4Vpue1kvAQdBU53swL6ljHOZNl2spGzDFOcCPvAX9IaBjz0qh6aRPMu9tzUnCag0C9R69YVLaSWB6J1X1qf9FfrGU+UBD9aJFTpJ09rhK3+VNNCCSd0MzDl1hgIlh56zDv5GfkUCfVT0a53dyreKN9QfOwsahQ7XSVfTbvE5sk=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB4742.eurprd03.prod.outlook.com (2603:10a6:20b:6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Fri, 17 Dec
 2021 12:15:07 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63%3]) with mapi id 15.20.4778.018; Fri, 17 Dec 2021
 12:15:07 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next 07/13] net: dsa: rtl8365mb: rename rtl8365mb to
 rtl8367c
Thread-Topic: [PATCH net-next 07/13] net: dsa: rtl8365mb: rename rtl8365mb to
 rtl8367c
Thread-Index: AQHX8rmMkZSipe1IR0+5ApncYZHGFaw1x5WAgACBSoCAAFEhAA==
Date:   Fri, 17 Dec 2021 12:15:07 +0000
Message-ID: <15fa5d93-944a-0267-9593-a890080d6e02@bang-olufsen.dk>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211216201342.25587-8-luizluca@gmail.com>
 <1fbf5793-8635-557b-79f2-39b70b141ba3@bang-olufsen.dk>
 <CAJq09z79xThgsagBLAcLJqDKzC6yx=_jjP+Bg0G4OXXbNj30EQ@mail.gmail.com>
In-Reply-To: <CAJq09z79xThgsagBLAcLJqDKzC6yx=_jjP+Bg0G4OXXbNj30EQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24ac6fdf-c8c7-410a-c306-08d9c156dd65
x-ms-traffictypediagnostic: AM6PR03MB4742:EE_
x-microsoft-antispam-prvs: <AM6PR03MB47424A1CF5D9E7BC82485D4383789@AM6PR03MB4742.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Onxv/GcRsxdMJidlh2N8ZIdXbEwyGb69UxqC6hf8OPzPW/s1AKulclykVqUCFA3uOfJQCxHTmgh25KqygJ7br0k6GoBO1ZA4LVRnml87hd/c5j6g4XXlyHcKGQbd2k44dJvizxhSmb1XusF3mSw4LNAc/WLlnKJwMX1C38ED6Gi6oKYvYCeN7SlmPi6nXM/dlG/5zjOVyybtkNFEr10eT4nh4UnMWRlIGssS/2OvOwcN16+nemCGIFdUQVaganZGFrRbC/YQCTjeJzENB4j2bfIQeMRPpVo4kPF14hUB+9dK3ZjxNxee+5W5nUH7J+iNcWsxIktOERVGAFUTJxOHcnXI7CbeKTR7GLoDGXnfkm+uLRQ/+uD5juxmMerQRP8uMO/1ZYE2IGfu8DGzUazSpz/hcHcYrFu5StEmldsepms20O2Ef4cyoz+nzOVSVWnPUA5yRs4yPISMGUGKMFSdEx1q4kxnIZxg/bJ4RmGICKpbtF0bX496+AsNxjRjQOhTa1nPfqSpW1FgJSkRltIhFJ+75Dk/t/qla3M8S6ngRsXCJ8RRV/vLNVpFml2UCdMt5sRDPDCVFDq63a7FySaR6Hnh8kTXweGmhrAOsE0gIklZVQ4bVjyhC0ifXxSNaHTVeGYzDVZE6OZBWkTDPmBAvd6L25FPUqfvQuy7e77rtmmEg3DtOzSd4KwMkYM3CR5165omnNUfUCGtHXamoUABTQRjNJ6P9vprHFhaX1OGBXj7vvfhOAcl+cLVr5MCXX6ZxintmnVaVIZiIrxazTCA+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(38070700005)(508600001)(66476007)(38100700002)(31686004)(6486002)(5660300002)(53546011)(36756003)(8936002)(86362001)(122000001)(6506007)(8676002)(8976002)(2906002)(31696002)(6512007)(66446008)(186003)(66946007)(6916009)(83380400001)(85182001)(91956017)(54906003)(64756008)(71200400001)(85202003)(316002)(26005)(76116006)(2616005)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnZsZmdtc2Jja3Z3MkRDYTFOdnVWTXFaOEpRUkNKclhwNldCWjNQZmVQRHlZ?=
 =?utf-8?B?ZVZlNE5FRllkck5Xa3dSQ2s2OTM4d3d4cXcxYnhqTXBtcGdJS2UwY25ha2dZ?=
 =?utf-8?B?bGkyZ1Z6eG1SdkkzSStMN2habXBhczJQZStpQWNKNEFTYXVJY2lYRVFrcHIx?=
 =?utf-8?B?cnBIRHVucHgzcW43OFhsT0lwSDRLY01RVWorRTlONTk2eCtlU0Vma25YVEQx?=
 =?utf-8?B?MHVIRnFpZWJuMEo0M2ZTTkFpMnN1bzZoY1pURlhMNm5MLzNjWUdzbmlsR2Nt?=
 =?utf-8?B?TnI2cmVjWkErVngzcWxPdDA2aExWS3dVekdkWUJjMG1tNjFyRUdyRmJaanVm?=
 =?utf-8?B?aVU5aWNGRi9zSmkxQXJ4N1ZYbkpNWGxKTDQ2RlZZVWs0Z2UvaVprVnpucmdQ?=
 =?utf-8?B?THVHZVhvb2p4YXU0ZG91d2hnM25qdVpwQlNiUXZiMFlGUHU2bmdwNkttWUVW?=
 =?utf-8?B?eVh2bGtacjJtYXB2WU4rYmVqelhXVitEWmNOU09sQThyVDZFUWcxcVRtV2xm?=
 =?utf-8?B?cERjRWMxR2ZETDM0N3pVU2RsOGpRcHJOemtLVXVUUHRuQmNuZEc0RE5YR0VU?=
 =?utf-8?B?VHdnVjZ5QTNzM2RyRnV6WmlSSWtOZkNneVFHRnBsemNCZDNacTZjUlJJV3hC?=
 =?utf-8?B?Lyt4MnJqSXNGZk5qY0tqd3ZySms3QUd1eG4xN2NhZ05NMFRoczBVK2RFdGM0?=
 =?utf-8?B?dmpCV1hOZ3B5M2pJRE1qU1N0V2RmankvRDlpa2krV2ZDSlh4N08zbXdMc25P?=
 =?utf-8?B?TDdmRkpwWGhQNnVjUkpIRVNmU1p1bkNRR1RhcWNRRmgwVDNnbC9Bc0tHeHpW?=
 =?utf-8?B?UTZTanYzODU0MlYvdHhoaC9peDJrM0xqMmkvZXlZcnhpSFg0R09qekdrQWRY?=
 =?utf-8?B?L2ppNmsyOVV2c2I2ZURMZlN3enJBS2F4Z2M0ZG4rU0NTOTc1SFArakFuOUp5?=
 =?utf-8?B?MnVISk56T2NrcksyQ2c0ZTdHalRSR2pDVGo2dGVlZkJycElvSnFGSDYvTi80?=
 =?utf-8?B?ZmVOT2xqTE5mZXhvbzdVZzY4S0Jyb2dDK1B1a25SZERlc1RtcTBxcC9GOVJj?=
 =?utf-8?B?SkcreVBhU3Bqa084T0w4STMyRGluRnA1ODYzL2p2bkp5andQcW1QVXZNZktX?=
 =?utf-8?B?VkZJOXRFeWFDbk91RHhsU28vTW4rZ0cxMlZuM2xJT1AvUkpjdXQ2RnBGTVpn?=
 =?utf-8?B?bW9hcmdQL3pOVHdtcDJSQ3FOcGtSdGJBck5yYVZ6eDNQWThtckNRTjZlV2VV?=
 =?utf-8?B?dEE4WGM0NUVWRlJFQU0wZ3ByTnJ3RFdoK2UzbGttZzI0bUdhSDFVVVR0VmZI?=
 =?utf-8?B?LzRlaDEvcTFiRFBINVQrSk9ucTl0TUxodnpuSW9WTHlGbkdHV0tDeHVLc1BH?=
 =?utf-8?B?UzdseEF4eUdoNVhTc2R2ZExJL0RmckFHTnB6Y2hnRFcwaFIzenFCQkhMay85?=
 =?utf-8?B?aGcxaGFSV1NIMHlBckFqZnZXaFNIZG9OMWtjSmJxdG1FZGJua2Y2ZVhLL1F3?=
 =?utf-8?B?Z0tyMjkxWU5LTGFNdnBDanEvYUQ0eTNTK2V0MXRiSUZ3a3JwdmNSMG1HK0t2?=
 =?utf-8?B?b1dXWEw2Y2g3dDdoQ25neXNEd2lJZzZoOW55dU14ZWF6MFR2SWJzdHp5UFhO?=
 =?utf-8?B?WjhpRjBQcEVZYUxDbXA4WGpHRHk4RlV6Zi9qTHZuaTJOdCtEMlNQdDNmei9W?=
 =?utf-8?B?TlZHZXZZT0R1NHYwZHNaRktDSXl5YStyMHpYNm1hV3lmVjd6Rlc4K0ZrbEp4?=
 =?utf-8?B?OHUwMkEvMjNqN1RkMXJieGhFOWdBUnExZjdlWTRqdXExTHBRVUxtL0crQUdk?=
 =?utf-8?B?TFpGL2xjOGpRb3EvTkFRWUF5S2UrUXlub3pJMU5MUk9wU3hTNWVrSmJSbUw4?=
 =?utf-8?B?NDJYYlRvK0xVU01jMy95K3UxcFVGV0hKTzM0UU1qNHBONnZER2tnN09la2JQ?=
 =?utf-8?B?MmpRZXQ3Vy9CTjJvQVNsN2pYWTl1KzNTODFMdEY0Y0ZEQlA0THFOZEZCWFE4?=
 =?utf-8?B?MWgrOTlOdTU0b08zS2lUMzJzRm1pdmFrQXJCY3VodlA4U2t3ZDI5OVBKRFR6?=
 =?utf-8?B?MVFmN3FzOG1BRlJLRHZCK0RuLzlINzZJNWR5NWtISjN2TlVaNllPcDFZaFdI?=
 =?utf-8?B?c2htRHFiL1VRbzg5bUVYN2tPdytZZUZpV3c0bHhPZ2NFTEVVWE9DbmhnRE9j?=
 =?utf-8?Q?eHMtk8YG2RTrODI+ka6VpJw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <239832979203554CA8A0A7778E5CC4BB@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ac6fdf-c8c7-410a-c306-08d9c156dd65
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 12:15:07.3838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GAK4bLVFQGoYtqS01Cdwzlae1WIbb4zJhxGrwTViuJZHF951L81bWlov+IYscrjaMlRhHLav4YQDuW7b7MyVOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4742
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTcvMjEgMDg6MjQsIEx1aXogQW5nZWxvIERhcm9zIGRlIEx1Y2Egd3JvdGU6DQo+PiBI
aSBMdWl6LA0KPiBIaSBBbHZpbiwNCj4gDQo+PiBPbiAxMi8xNi8yMSAyMToxMywgbHVpemx1Y2FA
Z21haWwuY29tIHdyb3RlOg0KPj4+IEZyb206IEx1aXogQW5nZWxvIERhcm9zIGRlIEx1Y2EgPGx1
aXpsdWNhQGdtYWlsLmNvbT4NCj4+Pg0KPj4+IHJ0bDgzNjVtYiByZWZlcnMgdG8gYSBzaW5nbGUg
ZGV2aWNlIHN1cHBvcnRlZCBieSB0aGUgZHJpdmVyLg0KPj4+IFRoZSBydGw4MzY3YyBkb2VzIG5v
dCByZWZlciB0byBhbnkgcmVhbCBkZXZpY2UsIGJ1dCBpdCBpcyB0aGUNCj4+PiBkcml2ZXIgdmVy
c2lvbiBuYW1lIHVzZWQgYnkgUmVhbHRlay4NCj4+Pg0KPj4+IFRlc3RlZC1ieTogQXLEsW7DpyDD
nE5BTCA8YXJpbmMudW5hbEBhcmluYzkuY29tPg0KPj4+IFNpZ25lZC1vZmYtYnk6IEx1aXogQW5n
ZWxvIERhcm9zIGRlIEx1Y2EgPGx1aXpsdWNhQGdtYWlsLmNvbT4NCj4+PiAtLS0NCj4+PiAgICBk
cml2ZXJzL25ldC9kc2EvcmVhbHRlay9LY29uZmlnICAgICAgIHwgICAgOSArLQ0KPj4+ICAgIGRy
aXZlcnMvbmV0L2RzYS9yZWFsdGVrL01ha2VmaWxlICAgICAgfCAgICAyICstDQo+Pj4gICAgZHJp
dmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1zbWkuYyB8ICAgIDQgKy0NCj4+PiAgICBkcml2
ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLmggICAgIHwgICAgMiArLQ0KPj4+ICAgIGRyaXZl
cnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjdjLmMgICAgfCAxMzIxICsrKysrKysrKysrKy0tLS0t
LS0tLS0tLS0NCj4+PiAgICBkcml2ZXJzL25ldC9waHkvcmVhbHRlay5jICAgICAgICAgICAgIHwg
ICAgMiArLQ0KPj4+ICAgIDYgZmlsZXMgY2hhbmdlZCwgNjY2IGluc2VydGlvbnMoKyksIDY3NCBk
ZWxldGlvbnMoLSkNCj4+Pg0KPj4NCj4+IElzIHRoZSByZW5hbWUgcmVhbGx5IG5lY2Vzc2FyeT8g
TXkgbG9naWMgaW4gbmFtaW5nIGl0IHJ0bDgzNjVtYiB3YXMNCj4+IHNpbXBseSB0aGF0IGl0IHdh
cyB0aGUgZmlyc3QgaGFyZHdhcmUgdG8gYmUgc3VwcG9ydGVkIGJ5IHRoZSBkcml2ZXIsDQo+PiB3
aGljaCB3YXMgbW9yZSBtZWFuaW5nZnVsIHRoYW4gUmVhbHRlaydzIGZpY3RpdGlvdXMgcnRsODM2
N2MuIFRoaXMgc2VlbXMNCj4+IHRvIGJlIGNvbW1vbiBwcmFjdGljZSBpbiB0aGUga2VybmVsLCBh
bmQgYnVsayByZW5hbWVzIGRvbid0IG5vcm1hbGx5DQo+PiBicmluZyBtdWNoIHZhbHVlLg0KPj4N
Cj4+IEkgdGhpbmsgdGhlIHZlbmRvcidzIG5hbWluZyBzY2hlbWUgaXMgY29uZnVzaW5nIGF0IGJl
c3QsIHNvIGl0J3MgYmV0dGVyDQo+PiB0byBzdGljayB0byByZWFsIHRoaW5ncyBpbiB0aGUga2Vy
bmVsLg0KPiANCj4gWWVzLCBpdCBpcyBxdWl0ZSBjb25mdXNpbmcuIEkganVzdCBrbm93IHRoYXQg
dGhlIGxhc3QgZGlnaXQgaXMgdGhlDQo+IG51bWJlciBvZiBwb3J0cyBhbmQgTkINCj4gc2VlbXMg
dG8gaW5kaWNhdGUgYSBzd2l0Y2ggdGhhdCBkb2VzIG5vdCAic3dpdGNoIiAodXNlciBwb3J0cyBk
b2VzIG5vdA0KPiBzaGFyZSBhIGJyb2FkY2FzdA0KPiBkb21haW4pLiBSVEw4MzY1TUItVkMgZG9l
cyBzZWVtIHRvIGJlIHRoZSBmaXJzdCBvbmUgInN3aXRjaCIgaW4gdGhlDQo+IHJ0bDgzNjdjIHN1
cHBvcnRlZCBsaXN0Lg0KPiANCj4gSSBkb24ndCBoYXZlIGFueSBzdHJvbmcgcHJlZmVyZW5jZSB3
aGljaCBuYW1lIGl0IHdpbGwgaGF2ZS4gSSdtIHJlYWxseQ0KPiBub3QgYW4gZXhwZXJ0IGluDQo+
IHRoZSBSZWFsdGVrIHByb2R1Y3QgbGluZS4gTXkgZ3Vlc3MgaXMgdGhhdCBSZWFsdGVrIGhhcyBz
b21lIGtpbmQgb2YNCj4gImRyaXZlci9kZXZpY2UgZ2VuZXJhdGlvbiIsDQoNCkkgZG9uJ3QgdGhp
bmsgdGhlIGN1cnJlbnQgbmFtZSBpcyByZWFsbHkgaHVydGluZyBhbnlib2R5LiBBbmQgYXMgQXLE
sW7DpyANCnNheXMsIGl04oCZcyBhIGh1Z2UgY2h1bmsgb2YgY2hhbmdlIHdpdGggbm8gcmVhbCBi
ZW5lZml0cy4NCg0KQmVzaWRlcywgbm90IGFsbCByZW5hbWluZyBzZWVtcyBjb25zaXN0ZW50IC0g
d2hhdCBpcyBtYiB0byBtZWFuIGhlcmU/Og0KDQotCXN0cnVjdCBydGw4MzY1bWIgKm1iID0gcHJp
di0+Y2hpcF9kYXRhOw0KKwlzdHJ1Y3QgcnRsODM2N2MgKm1iID0gcHJpdi0+Y2hpcF9kYXRhOw0K
DQpUaGUgbmFtaW5nIHNjaGVtZSBmb3IgcnRsODM2NnJiIGlzIGFsc28gbXlzdGVyaW91cyAtIHdo
eSBub3QgZml4IHRoYXQgDQp0b28/IElzIHRoYXQgcnRsODM2N2I/DQoNCkhvbmVzdGx5IGl0IHNl
ZW1zIGxpa2UgbW9yZSBlZmZvcnQgdGhhbiBpdCBpcyB3b3J0aC4gVGhlIGNvbW1lbnRzIGF0IHRo
ZSANCnRvcCBvZiB0aGUgZHJpdmVyIHNob3VsZCBiZSBzdWZmaWNpZW50IHRvIGV4cGxhaW4gdG8g
YW55IGZ1dHVyZSANCmRldmVsb3BlciB3aGF0IGV4YWN0bHkgaXMgZ29pbmcgb24uIElmIHNvbWV0
aGluZyBpcyB1bmNsZWFyLCB3aHkgbm90IA0KanVzdCBhZGQvcmVtb3ZlIHNvbWUgbGluZXMgdGhl
cmU/DQoNClNpbmNlIHlvdSBkb24ndCBmZWVsIHN0cm9uZ2x5IGFib3V0IHRoZSBuYW1lLCBJIHdv
dWxkIHN1Z2dlc3QgeW91IGRyb3AgDQp0aGUgcmVuYW1pbmcgZnJvbSB5b3VyIE1ESU8vUlRMODM2
N1Mgc2VyaWVzIGZvciBub3cuIEl0IHdpbGwgYWxzbyBtYWtlIA0KdGhlIHJldmlldyBwcm9jZXNz
IGEgYml0IGVhc2llci4NCg0KCUFsdmluDQoNCj4gYmVjYXVzZSBJIGFsc28gc2VlIHJ0bDgzNjdi
LCBhbmQgcnRsODM2N2QuIEkgdXNlZCBydGw4MzY3YyBhcyBpdCBpcw0KPiB0aGUgbmFtZSB1c2Vk
IGJ5IFJlYWx0ZWsNCj4gQVBJIGFuZCBQcm9ncmFtbWluZyBHdWlkZS4gSSBzYXcgaXQgcmVmZXJl
bmNlZCBpbiwgYXJkdWlubyBhbmQgdWJvb3QNCj4gYW5kIG91dC1vZi10cmVlIGxpbnV4DQo+IGRy
aXZlcnMuIEkgcmVhbGx5IGRvbid0IGtub3cgdGhlIGJlc3QgbmFtZSBidXQsIGlmIHdlIHVzZSBh
IHJlYWwNCj4gcHJvZHVjdCBuYW1lLCBJIHN1Z2dlc3QgdXNpbmcNCj4gdGhlIGZ1bGwgbmFtZSwg
aW5jbHVkaW5nIHN1ZmZpeGVzIGJlY2F1c2UgUmVhbHRlayBjb3VsZCBsYXVuY2ggYSBuZXcNCj4g
UlRMODM2NU1CICh3aXRoIGENCj4gZGlmZmVyZW50IHN1ZmZpeCBvciBldmVuIHdpdGhvdXQgb25l
KSBmb3IgYSBkaWZmZXJlbnQgaW5jb21wYXRpYmxlDQo+IGNoaXAuIEFuZCB0aGF0IHdpbGwgYmUg
ZXZlbiBtb3JlDQo+IGNvbmZ1c2luZy4gV2UgY291bGQgYWxzbyBjcmVhdGUgb3VyIG93biBmYWtl
IHNlcXVlbmNlIChydGw4M3h4LTEsDQo+IHJ0bDgzeHgtMiwuLi4pIGJ1dCBpdCBpcyBub3JtYWxs
eQ0KPiBiZXR0ZXIgdG8gYWRvcHQgYW4gaW4tdXNlIHN0YW5kYXJkIHRoYW4gdG8gY3JlYXRlIGEg
bmV3IG9uZS4NCj4gDQo+IEkgZG8gY2FyZSBhYm91dCBuYW1lcyBidXQgSSBzaW1wbHkgZG9uJ3Qg
aGF2ZSB0aGUga25vd2xlZGdlIHRvIGhhdmUgYQ0KPiBzYXkuIEkgdGhpbmsgdGhlcmUgYXJlDQo+
IHBsZW50eSBvZiBleHBlcnRzIG9uIHRoaXMgbGlzdC4gSSB3b3VsZCBhbHNvIGxvdmUgdG8gaGVh
ciBmcm9tIHNvbWVvbmUNCj4gZnJvbSBSZWFsdGVrIHRvIHN1Z2dlc3QNCj4gICBhIGdvb2QgbmFt
ZS4gRG9lcyBhbnlvbmUgaGF2ZSBhIGNvbnRhY3Q/DQo+IA0KPiBSZWdhcmRzDQoNCg0K
