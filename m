Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1584899B1
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiAJNSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:18:37 -0500
Received: from mail-am6eur05on2130.outbound.protection.outlook.com ([40.107.22.130]:30304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231807AbiAJNSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 08:18:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMrm6WDsiTa35GWnbM8mFlAH6a9tlJdqtN9nJtJzE7vh5wLAautBJm46NxGVH5GCnG14WABl23ICk8NWQmiHBZTCVvLunEgDeZoxqvAyHWEovdafooJv/ulHFJg+ZJRUTfrf0j2tLl0k4uV8cSF6FToZb+eLa6QQKtLxS45g8cr04fYlbXV6qvc8pj7xg/dtvSR3b4LlOTjhRVsoiKSwmRWWJl45/JbTUhvAe+DF5iJEgVm1LdVAeXHFRXLfukq9QX6hgV8Ftklj3v9PJZliWhO/F8yejzgza1T2TrePKRTwk5PgQX8KkglZqon/QxqNCuxbhXEJBJHtBVZ27kJpMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLuEtMp5C3XghfS0PUB4zfibXyV427OQjqqykmIkViE=;
 b=UjelkWR34v/2xbHBysFgouT4OGdHrUAIyiCXPPEn/qVaE3gzh1IyGtXAOoHKsb/SqAufiGIyUV9RqVNClDd3rmoJIjFMeZms/rSaxG6VLuIYSV4Oq9RYtdVXqzJBLe4FC+9cedChYA2BbBS1r6FIZIj3eiyGrvRzvTZr2ySLrWU+ZdCXCiIQj3kWSem7mZugEGV5fRbR+XKeQyIlby+XrwkgiZf/u8htuh22+yKYvAgtar7mZkmJCow8SwBp/xwvkzcDQfNbZgxLZvHS0AGp+HnCDPlwBWermoPy0bRlvfXVJAgciHqRGPaiQcsEL+KNzOoPxXLnscbnMk0pB6LGDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLuEtMp5C3XghfS0PUB4zfibXyV427OQjqqykmIkViE=;
 b=ahe7NAoE70bo0utrtcvbNQmC0nXcFNnY47rDpuqTQ4yx+rvgUiuJpNzFexYXIyMr2idhxsXkcPC7C1URXOM3l4MJbdqEJNdF/6Tflj9N5JFn+aBoqSJTBnThJGBrLVJxE53MgW32huZ9ilbPEXau7/iJvDCNerSGpCe+rh13rGg=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AS8PR03MB7271.eurprd03.prod.outlook.com (2603:10a6:20b:2ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Mon, 10 Jan
 2022 13:18:31 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 13:18:31 +0000
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
Subject: Re: [PATCH net-next v4 08/11] net: dsa: realtek: rtl8365mb: use
 GENMASK(n-1,0) instead of BIT(n)-1
Thread-Topic: [PATCH net-next v4 08/11] net: dsa: realtek: rtl8365mb: use
 GENMASK(n-1,0) instead of BIT(n)-1
Thread-Index: AQHYAeKXQnbiyhrM40W4KVrxutCzMA==
Date:   Mon, 10 Jan 2022 13:18:31 +0000
Message-ID: <87r19fd908.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-9-luizluca@gmail.com>
In-Reply-To: <20220105031515.29276-9-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Wed, 5 Jan 2022 00:15:12 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58c27b24-3e11-4f98-5928-08d9d43bb2b1
x-ms-traffictypediagnostic: AS8PR03MB7271:EE_
x-microsoft-antispam-prvs: <AS8PR03MB7271271ECFF35306C1D3C16C83509@AS8PR03MB7271.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:296;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6tFJ8nonU/a7MuLo9nlsBBtWJ+b2BfxjRpexbwE0riuuhAa6oBjQU0qYt/Sv5asKyvwWRmwpwwUqv/vsiMvQOX6g+Zeewf6zFWaZly0RMV3nwtT0BH/5XQi76AhIILx/1JsBf81cvFUlJ9VfwZi03VeulYMny6Z47d7wwMLPSOtjrBl087xBvgenKV5R+TJj57S99PfzyqcuO9GsjgqUjWoVLtpG0qLGiZWQo3eiV9u4R49QVKtYs2TzDk21DfjaN6eSpiPFYfs0JqtBLoqZiEkrDyuy1ouBPckXefTCi4ko754Tk6cBsmxkQMNx02wqKuILulDMEFNbToTXfNiB+JbCXToEg+WBxCmQgdEnnzw9MSDmB0qjJJ0e7cQerNDvrM+86z5jiUVRf5n1vg18IOyW69z8xbMSkOkHbsXloZwqYODeTQ87tpGMKGmX5OqTXA6vW6ADPTRINbIkX51dgqP6ZpaCsBkVSIZrHxI3m1/CXL3Rc89jQhJuKPi2Rg5v75WzFbOq81Wg0AwTI/44pfCNAYbjqBbaJ8cjQf5p9soHPypAjEPfAQIkwxocHhvC3OelfMzr8560WP17OdSztvFyb66kgzz//zn5VjKIF9qZibIZGH1NtwkUxlYWFxI/peBjsZfzucESVgBSytJqaAYDvvnXXT8D8xjKYRrbhe1Qc1cmgVUzcRRHkvQLeE1StSVtpIOJx0MevLiVEq5Afw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(85182001)(2906002)(6512007)(38070700005)(91956017)(66946007)(26005)(38100700002)(4744005)(186003)(86362001)(85202003)(66574015)(5660300002)(8676002)(8976002)(36756003)(6486002)(122000001)(6916009)(54906003)(6506007)(71200400001)(4326008)(316002)(2616005)(66556008)(66476007)(64756008)(66446008)(76116006)(83380400001)(8936002)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a00zYW1kMUoyeFM4MEJUTFJqN0FiYVlSMXRFZUo0cGIvSDN6blhZUU5mZEcr?=
 =?utf-8?B?R1N3UzBhNHZpODQ3Y3VmYWhCVjV2NVFGRC9ueDRCZENuaUNwb2hhWWJtODBL?=
 =?utf-8?B?TFQyTkU0dERqanJFdVZuZWxKbXN2aUVJZ0dETnlPOGtpRXNoYVBXY1FJZklv?=
 =?utf-8?B?US9URlhoOHFzRzJMalRoRWRVR2hFOERWbVU4anZlV2JTT0VMbDE2bENxOTRZ?=
 =?utf-8?B?cE8wTFF4a05wVGZ1aCtLYjhuOE1ibjIxY0hZQ3FwY3hCZVJzY2NtTFZkbGk3?=
 =?utf-8?B?cWhlYmFER3dQMm5kendHV3h6dkVkY0FhZ25hZ1RmRk9OaW5xM3A4OFhWUkVu?=
 =?utf-8?B?eEJkenpVK2FEbUJCc01YZ0FZRGwxTDYzQnFnMTZRU2hBQUVwczdkOTJ6NHha?=
 =?utf-8?B?M1NleWwzTS83RUFPRzlSZHMwODdaZ2QxeTY4WWQvbjZPVWE1Q0pSVTlZbHpN?=
 =?utf-8?B?cHAxUU5PSnRDYnNnUDVwN2U2SWJaRVI4MU1KejlFZ1hraHAvVGVBaTVSdC9D?=
 =?utf-8?B?eVQxV0xyYUFkMDNiWUlPS3IyZTZDNWllT0RFQk5QaUFFNWlROWJJOE1EeXZ0?=
 =?utf-8?B?UURIZUFCMmtRVFhUOWpqZ090T0VwcVNSUUlja2JJQi9TVElSaTVRV1NqeUpK?=
 =?utf-8?B?ek1YRXI1ZEgza2VXR2VBeXdHWVduTlpoNk9EanhsemZHb0FMdElpNnVYM1VN?=
 =?utf-8?B?ZXRzdkRmalM0ekhSYUlTT0J4TjJjZ08yUDVnVm5wbUk5M1pMYmhYUWRWUkFy?=
 =?utf-8?B?NktZWkJuNFhjaTNUSk9BellSZXNBMXFIWFVlRm9TbWdRV04ySDFqTlN2elo5?=
 =?utf-8?B?aSs0WndKenY5dWVITTlDM2lpS2pjSmFjbjRwYTJRcm0rNmcrL2dPTzh6QUdO?=
 =?utf-8?B?YWJsSlBnRG9sZXlIYWx4N0lFQ0l6Q3g1L3FhSHRXalFCSFNEOENMeHpDL0lx?=
 =?utf-8?B?Q0R0SWowc0lqYnJLUWVwbXBmTU16ZkZHRDFhZFZTZWpqU3ZXVmZFRnBhdkJw?=
 =?utf-8?B?MG5Sd1hlOERWcWpnZWsxaEtSQURrVzF2dFRBR1U2aS9iRWdMUk9GSzZYSGVM?=
 =?utf-8?B?NklCTExoeEFoalpnNkFid2lKOWlLNzY2ZnJud3JyTmZWL1JMTUpQQVVSU0d1?=
 =?utf-8?B?dDZVYkIxMEZ0VWdnMUI3U2RRem5NK29Od01mYkhPREFmb3VaZzhET0l5c2Ns?=
 =?utf-8?B?cjhKMHFuMHFzQ1BQWkM0aGVjNlNQYmM0M3BvODFjclhySVZvTDR6Z3graUYy?=
 =?utf-8?B?Wlo1VjhaeFZrbkI2OW5RM0hjQkJkZHBKNmtqVk9KTWU1bVg1OUJabEYvUUJi?=
 =?utf-8?B?UlV1Qkp3UXJla2hwcDlxcjd1SmR4bFg1S0lONEZGRE5pU2U5Q0VQZUticjRZ?=
 =?utf-8?B?dTNEN2s1MEgrOVhLSlk3VlhQVjB2Q1FtOElJYkFCanhCQTEwQ1hsQ1FTNEgx?=
 =?utf-8?B?ZmdDVDc5Tnc1dzE3RkRWZ3hKOFJ3UmNSSmV6SUJyRVJIc2tYSVFWNEFkUjRq?=
 =?utf-8?B?Z2xpVkdiVFhrS09KV0tsNlRsN2VDcDhBbjlNWnplM2U1YllQMEVOejBYODNC?=
 =?utf-8?B?K3cvVStaeFJqOERtS3NjNjRXeXV5ZXJXMVdkVkdFelN0V3Fobkp6SHRkOFJD?=
 =?utf-8?B?SG9NcEt0NG1Od2xsQlFJRHMvSzNVNk9BOUZ0anRyQjVyMmRLNXNwUFhqZkJY?=
 =?utf-8?B?VndmY2EyeW0wdXRtZWJ0QXI2eXo2VFRUTzJ0WmhMR2JtWEd1OUx6djdpL2g5?=
 =?utf-8?B?MzNtNzZpeW85S09FeWwzRzdKVnpPUzRlcXNXbDZ1M2FuZDZtTllZVnpjWHRl?=
 =?utf-8?B?NzdCMG9VZUpTM0JuS1VidWdJTnRDMHdBZTNmSmNKcGVGMU96UjdBWGp1SktT?=
 =?utf-8?B?a2ttYmZZVnExaDFiQjdCcW5wSGFWRUo0aG5EdDFXWU9iODBWaG8wc3V6OXBy?=
 =?utf-8?B?YVFEWjd1S0pPYnJVUFUxSTlVbW4wM1Nrb0dvakRLeEFqNFV2NUovYUlkRElp?=
 =?utf-8?B?cFhVbGw2OVJFMXRBV04wWVBPZ1d1SERCNzNpNDlIVkV5STMvbTRuMWdCd1J6?=
 =?utf-8?B?TkN6R3ZQY2c2UXFVclRZcG5Od0J1dDlkczF2SDJ2aENDYTBqQnExNTVHVDdD?=
 =?utf-8?B?V1RRcjBKbDF1UVFyTGJucU9qb1EzV1Z5VDlDUEtzWVhQVTdDMEkzWVFHTnVO?=
 =?utf-8?Q?eArghv9btWmn6oJTjj2/0Ns=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ADA3B65639984F4C8DCE5CA34725E93E@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c27b24-3e11-4f98-5928-08d9d43bb2b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 13:18:31.5137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mvEX7Lkw/bkccZZDHzqKul2/kiamQMdKud/6UoGjAVHiFTBhbsnbvKHWQFs4o8MSCOwuVWM6LCREwW+jNBAhTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gU2lnbmVkLW9mZi1ieTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21h
aWwuY29tPg0KPiBUZXN0ZWQtYnk6IEFyxLFuw6cgw5xOQUwgPGFyaW5jLnVuYWxAYXJpbmM5LmNv
bT4NCj4gUmV2aWV3ZWQtYnk6IExpbnVzIFdhbGxlaWogPGxpbnVzLndhbGxlaWpAbGluYXJvLm9y
Zz4NCg0KUmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4N
Cg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIHwgMiArLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+DQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYyBiL2RyaXZlcnMv
bmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jDQo+IGluZGV4IGUxMTUxMjljZDVjZC4uYjIyZjUw
YTlkMWVmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIu
Yw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYw0KPiBAQCAtMTk3
Myw3ICsxOTczLDcgQEAgc3RhdGljIGludCBydGw4MzY1bWJfZGV0ZWN0KHN0cnVjdCByZWFsdGVr
X3ByaXYgKnByaXYpDQo+ICAJCW1iLT5wcml2ID0gcHJpdjsNCj4gIAkJbWItPmNoaXBfaWQgPSBj
aGlwX2lkOw0KPiAgCQltYi0+Y2hpcF92ZXIgPSBjaGlwX3ZlcjsNCj4gLQkJbWItPnBvcnRfbWFz
ayA9IEJJVChwcml2LT5udW1fcG9ydHMpIC0gMTsNCj4gKwkJbWItPnBvcnRfbWFzayA9IEdFTk1B
U0socHJpdi0+bnVtX3BvcnRzIC0gMSwgMCk7DQo+ICAJCW1iLT5sZWFybl9saW1pdF9tYXggPSBS
VEw4MzY1TUJfTEVBUk5fTElNSVRfTUFYXzgzNjVNQl9WQzsNCj4gIAkJbWItPmphbV90YWJsZSA9
IHJ0bDgzNjVtYl9pbml0X2phbV84MzY1bWJfdmM7DQo+ICAJCW1iLT5qYW1fc2l6ZSA9IEFSUkFZ
X1NJWkUocnRsODM2NW1iX2luaXRfamFtXzgzNjVtYl92Yyk7
