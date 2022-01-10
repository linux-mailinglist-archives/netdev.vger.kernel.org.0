Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84894898CB
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 13:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245631AbiAJMno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 07:43:44 -0500
Received: from mail-eopbgr130119.outbound.protection.outlook.com ([40.107.13.119]:12294
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245634AbiAJMnn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 07:43:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkEYBv9HJ5Gp/tP7QBGFgyymMGmw+Cw+az1JVJfyj27OxVd4Lw4FKjaf+PHR58RI7y5lqhRV3XsJVb9KqsUv/dCbUaegImg67iYO6GyzuKjVo1kK7B07OZEKtzRjcjo5lyvm66u7TdjBTyfq6jyqAD+edblho6El/1awCZFtODVVPH0suY7W3vUzdBqk4bAtjHNIsssvqVN85Kk2Se2ezXAQfUhY48T2aEos2qbBiGe3ZmkpeByQc7mnWywSyCy3VKt5bdPnGrpnEr5ai0P4wnSmG8QuSW7UYLs7jgGEhVRAH8PSN9BftvbNjrU13jGuLNBSbTSDYQD/F8is4PsGXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vj0Y5Y6GCDeK4OIz9bmNc3NqB9pVIGK3zWMsGKFIMrk=;
 b=hhkE6/vQaSQckWVASidg6Alokg0UyLHrzd/OHPm3bRMfpG8Rp0W0mf6DY9yDaOzHYCaPlMLBx9En5ukW+IidLB2+ZkMTd2aV8sWawGUKDcABHy5jWyayjwyPuefnq/FarJ44UnX6XdHwDXSfTVXOigPmbFQY82EhZBPKY5CdUcS8QmG1cZSxSszQjPEio4AlR+bOPPBh1Lx79bcttXvQ51vCdwyARX9rsDfGExfhMT6Yu7LNsUtw5UuJmodI/gcLRQgzJ7JKgcnyOE/DUgt+MjJPuOQ9x/e9R+UJ2Aszi1xtBIHBhjISY4+mVZvnF+8dLJLh7zsHADGSGR0TYnOngw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vj0Y5Y6GCDeK4OIz9bmNc3NqB9pVIGK3zWMsGKFIMrk=;
 b=E0/2vjS5U8gLjqFGWhZjJuCx+WhuJYYEtjWwkQODWgZD4rXOjX5juVxxVYBDMwUx3cLBgOoCawB3gDaOXvSDt960dF5yHxvoNrwA0XuL8tU5FxnCjp4HhyqzdownHoNySqF4YQyRUc25ws5sD10i1dlqqWVUJnRDFoAEUDG8YRk=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AS8PR03MB7286.eurprd03.prod.outlook.com (2603:10a6:20b:2b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 12:43:39 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 12:43:39 +0000
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
Subject: Re: [PATCH net-next v4 04/11] net: dsa: realtek: convert subdrivers
 into modules
Thread-Topic: [PATCH net-next v4 04/11] net: dsa: realtek: convert subdrivers
 into modules
Thread-Index: AQHYAeKPTuSsRYLlj0KE4K39VQ1AHw==
Date:   Mon, 10 Jan 2022 12:43:39 +0000
Message-ID: <87ilurep6t.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-5-luizluca@gmail.com>
In-Reply-To: <20220105031515.29276-5-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Wed, 5 Jan 2022 00:15:08 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b5127d3-5e0f-4127-027e-08d9d436d3c0
x-ms-traffictypediagnostic: AS8PR03MB7286:EE_
x-microsoft-antispam-prvs: <AS8PR03MB7286347D001E57A2DB0973D883509@AS8PR03MB7286.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:403;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 94yO4xCqx3RZ+M4wOcLvSlQgKk3mhs3ShcwNRiC7GTDGa00H7b/Ejy/g/FI8vxwIqIu3yYuv+iz3N4LmjZhuiq6uA7a/frcomQswSn3043Qw/j7Bbbkp8+Wcxf2JuyKLhIWgqFvu76g0nowUcMl8cc6/szqssS/i/AbXncrFafiyEW/j1K1zVH7ORFh77rdQ5CaKAdMUhNfO2WuEAcnDQncOoWtHBBMXJ/lpataYToj10G9EwBHwQB81zG+725DdTw+p6PdGxACKaYz9eOf5jXuELWkHwQ91wiSmM5tOBT/jkb2Jg9/ta5sXNMDRlIP75v8jRrjQ4zTUD8iRJmiI49lWCbYMzye+4KVwj0PhR7IHLGmHgWLayTYKbh0vTY1iK3YziBLfctpB6CWWaRBC7hDSH94GhTDFxXfuEUgGOk0Ni3Bbg1aQ4AHFSVLR2gctrgEq+WKGMlomFB7lBJe8I8yfqtYgAAHyfCqGu59+vNnVXk9tBmXuzRroYORyPYL4IKZd4sFPEzkZ1LULL28RmmbckgEGaD1kei3MTwqHUPha7NGV1LNByPYoNAOXYKqbHvgJNW5QnptZrBSUQEjyC12rEO/XsWVQN9Oo23ltzjU1jRA3ikeMDFUtiQkyfh4eWN5oLU3MHhF++efbEb2w4GioSbOQDs/MEPq8YBjnqVGK2AiFtpfvgLPgeEPJpetVepPrZnIOioGCyO4oDN2gY1n8QeQZfOpCsWCu4FEitZ8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(8676002)(66946007)(64756008)(38070700005)(66556008)(54906003)(4326008)(36756003)(66476007)(508600001)(85202003)(76116006)(91956017)(5660300002)(71200400001)(122000001)(6486002)(85182001)(6512007)(8936002)(2906002)(8976002)(26005)(316002)(186003)(6506007)(2616005)(38100700002)(86362001)(6916009)(83380400001)(334744004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QTc4dzB1UVFCY3Q2dVFSb1dvVXlLclludU5KYzZSSW9Hd1VsVmRRb1cwd2lu?=
 =?utf-8?B?Vk1yV2lsVTFOL3I2eUgwYzZSdGlJeGFLQzlOcXFPMEVTZXg2Rm1MSzNFSlJG?=
 =?utf-8?B?UUVvM0dkVGZWZ1RkcXlReXVTdHd1NUZId1BaZEY3dEs3eHVsYkMrMU1rcmpw?=
 =?utf-8?B?UDBDMVlCL0c3SGNMRk1kaGFlQUV3SHVwVG03bWtZWThwSHg2cmI1MnY2N0Ft?=
 =?utf-8?B?cGx6Qk5xRVg3OFN3V2RCeUJla1ZaV2ZXbnJ5RjFJd2s5ZUNHV3hrZGZVbm40?=
 =?utf-8?B?Zm84SmY4UVhtbm02OFhzeU5XMXBtVmo1SjdZV3NMaFQ3ekpQaE5Ka1BDWThi?=
 =?utf-8?B?TFVIVkVhQzd0WXRmK2dRb090M2VBb25OWXQrdkRBdHdFUlFLcm1JMDZ2RUYz?=
 =?utf-8?B?bHZsUVZhdzU2dkdLbVdxM2FkYUZkMEVKL0ZpemMwbzlENEpxVTlVNXloS1B2?=
 =?utf-8?B?bFRYb3B3Z1lCaCtDQ1l3UFpWYzFRcTUraVI4Y2ppNVh2YzMwQjJJNHY1TDE1?=
 =?utf-8?B?emZmeVZ2WThrakN2QUdkZTQrMStWblVMOERqVnJkbFpFeXBvN0luN0srYUMz?=
 =?utf-8?B?MTQ0K1RvbC9FaU5LSVV1c2hFeitEYncxYlVqQWJlWHpOdit3R3VqVHVRbGNp?=
 =?utf-8?B?ZlRwYWtBVWRiTkhTc2ZCQjkxVTFERytYR0YrMVNtN2czWHhFWjYvY1JFYUhu?=
 =?utf-8?B?ZlFkS083RVdDQTRCb2o1aWVxQ08wMzJqdHg2VVBIT2JEMytkaHlGeklUeU5a?=
 =?utf-8?B?MktDYm5jRDRRQjhwak1DSjJWcXZuNmJQYlRuTUd2cElQTEFFMCs0NFQyZWtq?=
 =?utf-8?B?L1hrTTBLelVxbkFFbDZEQXJtSXdOdlJZMko5N01wVWFFelZKSXZiRElCOUZs?=
 =?utf-8?B?ZjI3clB6WUwwME5XdWZqV0RzZjVjWXJ1U1RSdXFOMk5TcjZDUWxWM1p6N3hu?=
 =?utf-8?B?SDc4NVZyeUpocyt5TlRBUFE5OU9oZDZGOEtsazlZMnVEVE9KVDhqc21tR0Uz?=
 =?utf-8?B?OUFHQjdvMVBCV1ZjbDVaN1FZK05IZVFmbDNIMWwyWGphS0psalVKTmxYYlJu?=
 =?utf-8?B?NGNaMmJ3bzFQMmJOY0drOE44MXQrRkNtM1Q0czk0VE9UNjFEZzNqTnhpYnN2?=
 =?utf-8?B?bTNQQUNlRzlSeGwxVDZXVWVPRWF0eVJKMWJyVys4S0V2Nkd1K2wvOC9XVDRC?=
 =?utf-8?B?Skd1OHZOOTFPd0VwKzZNN1QxeStIaUVUZitJOTRBKzRCRDRqSzJBdEFZSEFm?=
 =?utf-8?B?YzFYOGphZ3pUWk5VbklIVG1vclFWWm1ROGI3KzBvbG84NWJva2N4Vk54Q0VH?=
 =?utf-8?B?NDFvL0o5MkJQcW9uOEdXdzNKNFNzQWVtL0ptWlVIWGNpQm51N0dtM25NMmFm?=
 =?utf-8?B?b1QvN2F3YkNVamZYWkNja00wNGdqMWdRKzRJa2M3cjUxSzNhMy8yVWZ4b2pY?=
 =?utf-8?B?cyttNW1VaEZ5MDVCZFNkU2hndnRGRStJaHB2a1dRMFJRRGlLb25oY0pySitO?=
 =?utf-8?B?d3V3eE5FU0hwTFAxNVo1QVlSWksyNXhSQmJ4OUlaZEFDTDlEYUJCOEJzNVI5?=
 =?utf-8?B?OExYUHZUNk5oMmd5V3ZMYTAxTm83OTVrRTJMblVwTG91OWEzRDhpdGh6eFZ0?=
 =?utf-8?B?ZUNSMnBTODZqbVZDK1YxSmlVa2llMGpDcHZkMkVDTmdtTVIvOWViNWMvTGJJ?=
 =?utf-8?B?TjNsVzdPRXRtaE9RYmhQbWwrcVl2TU9Sa3VibWwrRmF0L0VUeC9OMS91UFdV?=
 =?utf-8?B?SnRzb1hkd1pZQkk4VWNOZnVETHN4YW5YUkZaZTBReExVWWVLN0ZsUUJNWVhP?=
 =?utf-8?B?QWUxZW5ndXNWUWthdzdROElncENyOEtIcTdjbXlROGIwS1FmbWs5dEhielkv?=
 =?utf-8?B?T210bEtMeWRZVFNwVkNNZnVqTDBIRnY0TmVMa2N6YkFvWnQvNGdBOVBlY0da?=
 =?utf-8?B?WllaaTdSckRwRW9wSWN0TEl4TW90TGdVMnMrQVVSZ3dRNnFCNXBrVTBpM1c4?=
 =?utf-8?B?OU9rNkRTZGZKTnFQWDlyQjJDa0VnNkZHS3pyZERpLzhVWXFOazJ0VXViYnZ2?=
 =?utf-8?B?b3pkVVNra3VyTlhoa284dEt1TFlBZUhnV0p6MHNxZ1dvM08zYjg4YWVlM0R0?=
 =?utf-8?B?OFVRU1BTQTdlWGF5bHh0V2dWUTA2RFlxTDFrVTdEalZOYXErMVE1aVFwTndh?=
 =?utf-8?Q?XAlt/eS/pDp4gue9qxtzf54=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3154E78A0FA4642B27D6A3CC767DE1D@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b5127d3-5e0f-4127-027e-08d9d436d3c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 12:43:39.4753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: loUL5OngoS3bLVk5+o326P05WssCCE3hCUm5OJ6ZtmNTCnQDKfDnfAqbbf1UNZ3KYT1fZjeeJnV6F8PcqX8Oug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7286
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gUHJlcGFyaW5nIGZvciBtdWx0aXBsZSBpbnRlcmZhY2VzIHN1cHBvcnQsIHRoZSBkcml2ZXJz
DQo+IG11c3QgYmUgaW5kZXBlbmRlbnQgb2YgcmVhbHRlay1zbWkuDQo+DQo+IFNpZ25lZC1vZmYt
Ynk6IEx1aXogQW5nZWxvIERhcm9zIGRlIEx1Y2EgPGx1aXpsdWNhQGdtYWlsLmNvbT4NCj4gVGVz
dGVkLWJ5OiBBcsSxbsOnIMOcTkFMIDxhcmluYy51bmFsQGFyaW5jOS5jb20+DQo+IFJldmlld2Vk
LWJ5OiBMaW51cyBXYWxsZWlqIDxsaW51cy53YWxsZWlqQGxpbmFyby5vcmc+DQoNClJldmlld2Vk
LWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQoNCj4gLS0tDQo+ICBk
cml2ZXJzL25ldC9kc2EvcmVhbHRlay9LY29uZmlnICAgICAgICAgICAgICAgfCAyMCArKysrKysr
KysrKysrKysrKy0tDQo+ICBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay9NYWtlZmlsZSAgICAgICAg
ICAgICAgfCAgNCArKystDQo+ICAuLi4ve3JlYWx0ZWstc21pLWNvcmUuYyA9PiByZWFsdGVrLXNt
aS5jfSAgICAgfCAgNiArKysrKysNCj4gIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVt
Yi5jICAgICAgICAgICB8ICA0ICsrKysNCj4gIC4uLi9kc2EvcmVhbHRlay97cnRsODM2Ni5jID0+
IHJ0bDgzNjYtY29yZS5jfSB8ICAwDQo+ICBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY2
cmIuYyAgICAgICAgICAgfCAgNCArKysrDQo+ICA2IGZpbGVzIGNoYW5nZWQsIDM1IGluc2VydGlv
bnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ICByZW5hbWUgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsv
e3JlYWx0ZWstc21pLWNvcmUuYyA9PiByZWFsdGVrLXNtaS5jfSAoOTclKQ0KPiAgcmVuYW1lIGRy
aXZlcnMvbmV0L2RzYS9yZWFsdGVrL3tydGw4MzY2LmMgPT4gcnRsODM2Ni1jb3JlLmN9ICgxMDAl
KQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvS2NvbmZpZyBiL2Ry
aXZlcnMvbmV0L2RzYS9yZWFsdGVrL0tjb25maWcNCj4gaW5kZXggMWM2MjIxMmZiMGVjLi5jZDFh
YTk1YjdiZjAgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL0tjb25maWcN
Cj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvS2NvbmZpZw0KPiBAQCAtMiw4ICsyLDYg
QEANCj4gIG1lbnVjb25maWcgTkVUX0RTQV9SRUFMVEVLDQo+ICAJdHJpc3RhdGUgIlJlYWx0ZWsg
RXRoZXJuZXQgc3dpdGNoIGZhbWlseSBzdXBwb3J0Ig0KPiAgCWRlcGVuZHMgb24gTkVUX0RTQQ0K
PiAtCXNlbGVjdCBORVRfRFNBX1RBR19SVEw0X0ENCj4gLQlzZWxlY3QgTkVUX0RTQV9UQUdfUlRM
OF80DQo+ICAJc2VsZWN0IEZJWEVEX1BIWQ0KPiAgCXNlbGVjdCBJUlFfRE9NQUlODQo+ICAJc2Vs
ZWN0IFJFQUxURUtfUEhZDQo+IEBAIC0xOCwzICsxNiwyMSBAQCBjb25maWcgTkVUX0RTQV9SRUFM
VEVLX1NNSQ0KPiAgCWhlbHANCj4gIAkgIFNlbGVjdCB0byBlbmFibGUgc3VwcG9ydCBmb3IgcmVn
aXN0ZXJpbmcgc3dpdGNoZXMgY29ubmVjdGVkDQo+ICAJICB0aHJvdWdoIFNNSS4NCj4gKw0KPiAr
Y29uZmlnIE5FVF9EU0FfUkVBTFRFS19SVEw4MzY1TUINCj4gKwl0cmlzdGF0ZSAiUmVhbHRlayBS
VEw4MzY1TUIgc3dpdGNoIHN1YmRyaXZlciINCj4gKwlkZWZhdWx0IHkNCj4gKwlkZXBlbmRzIG9u
IE5FVF9EU0FfUkVBTFRFSw0KPiArCWRlcGVuZHMgb24gTkVUX0RTQV9SRUFMVEVLX1NNSQ0KPiAr
CXNlbGVjdCBORVRfRFNBX1RBR19SVEw4XzQNCj4gKwloZWxwDQo+ICsJICBTZWxlY3QgdG8gZW5h
YmxlIHN1cHBvcnQgZm9yIFJlYWx0ZWsgUlRMODM2NU1CDQo+ICsNCj4gK2NvbmZpZyBORVRfRFNB
X1JFQUxURUtfUlRMODM2NlJCDQo+ICsJdHJpc3RhdGUgIlJlYWx0ZWsgUlRMODM2NlJCIHN3aXRj
aCBzdWJkcml2ZXIiDQo+ICsJZGVmYXVsdCB5DQo+ICsJZGVwZW5kcyBvbiBORVRfRFNBX1JFQUxU
RUsNCj4gKwlkZXBlbmRzIG9uIE5FVF9EU0FfUkVBTFRFS19TTUkNCj4gKwlzZWxlY3QgTkVUX0RT
QV9UQUdfUlRMNF9BDQo+ICsJaGVscA0KPiArCSAgU2VsZWN0IHRvIGVuYWJsZSBzdXBwb3J0IGZv
ciBSZWFsdGVrIFJUTDgzNjZSQg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0
ZWsvTWFrZWZpbGUgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9NYWtlZmlsZQ0KPiBpbmRleCAz
MjNiOTIxYmZjZTAuLjhiNWE0YWJjZWRkMyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNh
L3JlYWx0ZWsvTWFrZWZpbGUNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvTWFrZWZp
bGUNCj4gQEAgLTEsMyArMSw1IEBADQo+ICAjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwt
Mi4wDQo+ICBvYmotJChDT05GSUdfTkVUX0RTQV9SRUFMVEVLX1NNSSkgCSs9IHJlYWx0ZWstc21p
Lm8NCj4gLXJlYWx0ZWstc21pLW9ianMJCQk6PSByZWFsdGVrLXNtaS1jb3JlLm8gcnRsODM2Ni5v
IHJ0bDgzNjZyYi5vIHJ0bDgzNjVtYi5vDQo+ICtvYmotJChDT05GSUdfTkVUX0RTQV9SRUFMVEVL
X1JUTDgzNjZSQikgKz0gcnRsODM2Ni5vDQo+ICtydGw4MzY2LW9ianMgCQkJCTo9IHJ0bDgzNjYt
Y29yZS5vIHJ0bDgzNjZyYi5vDQo+ICtvYmotJChDT05GSUdfTkVUX0RTQV9SRUFMVEVLX1JUTDgz
NjVNQikgKz0gcnRsODM2NW1iLm8NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9yZWFs
dGVrL3JlYWx0ZWstc21pLWNvcmUuYyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWst
c21pLmMNCj4gc2ltaWxhcml0eSBpbmRleCA5NyUNCj4gcmVuYW1lIGZyb20gZHJpdmVycy9uZXQv
ZHNhL3JlYWx0ZWsvcmVhbHRlay1zbWktY29yZS5jDQo+IHJlbmFtZSB0byBkcml2ZXJzL25ldC9k
c2EvcmVhbHRlay9yZWFsdGVrLXNtaS5jDQo+IGluZGV4IGE5MTc4MDEzODVjOS4uNTUxNGZlODFk
NjRmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLXNtaS1j
b3JlLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1zbWkuYw0KPiBA
QCAtNDk1LDE5ICs0OTUsMjMgQEAgc3RhdGljIHZvaWQgcmVhbHRla19zbWlfc2h1dGRvd24oc3Ry
dWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIH0NCj4gIA0KPiAgc3RhdGljIGNvbnN0IHN0
cnVjdCBvZl9kZXZpY2VfaWQgcmVhbHRla19zbWlfb2ZfbWF0Y2hbXSA9IHsNCj4gKyNpZiBJU19F
TkFCTEVEKENPTkZJR19ORVRfRFNBX1JFQUxURUtfUlRMODM2NlJCKQ0KPiAgCXsNCj4gIAkJLmNv
bXBhdGlibGUgPSAicmVhbHRlayxydGw4MzY2cmIiLA0KPiAgCQkuZGF0YSA9ICZydGw4MzY2cmJf
dmFyaWFudCwNCj4gIAl9LA0KPiArI2VuZGlmDQo+ICAJew0KPiAgCQkvKiBGSVhNRTogYWRkIHN1
cHBvcnQgZm9yIFJUTDgzNjZTIGFuZCBtb3JlICovDQo+ICAJCS5jb21wYXRpYmxlID0gInJlYWx0
ZWsscnRsODM2NnMiLA0KPiAgCQkuZGF0YSA9IE5VTEwsDQo+ICAJfSwNCg0KSWYgeW91IHNlbmQg
YSB2NSwgbWF5YmUgYWRkIGEgcGF0Y2ggdG8gcmVtb3ZlIHRoaXMuIEl0IGlzIGdvaW5nIHRvIGNy
YXNoDQphbnl3YXkgc28gSSBhbSBzdXJlIG5vYm9keSB1c2VzIGl0Lg0KDQo+ICsjaWYgSVNfRU5B
QkxFRChDT05GSUdfTkVUX0RTQV9SRUFMVEVLX1JUTDgzNjVNQikNCj4gIAl7DQo+ICAJCS5jb21w
YXRpYmxlID0gInJlYWx0ZWsscnRsODM2NW1iIiwNCj4gIAkJLmRhdGEgPSAmcnRsODM2NW1iX3Zh
cmlhbnQsDQo+ICAJfSwNCj4gKyNlbmRpZg0KPiAgCXsgLyogc2VudGluZWwgKi8gfSwNCj4gIH07
DQo+ICBNT0RVTEVfREVWSUNFX1RBQkxFKG9mLCByZWFsdGVrX3NtaV9vZl9tYXRjaCk7DQo+IEBA
IC01MjMsNCArNTI3LDYgQEAgc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgcmVhbHRla19z
bWlfZHJpdmVyID0gew0KPiAgfTsNCj4gIG1vZHVsZV9wbGF0Zm9ybV9kcml2ZXIocmVhbHRla19z
bWlfZHJpdmVyKTsNCj4gIA0KPiArTU9EVUxFX0FVVEhPUigiTGludXMgV2FsbGVpaiA8bGludXMu
d2FsbGVpakBsaW5hcm8ub3JnPiIpOw0KPiArTU9EVUxFX0RFU0NSSVBUSU9OKCJEcml2ZXIgZm9y
IFJlYWx0ZWsgZXRoZXJuZXQgc3dpdGNoIGNvbm5lY3RlZCB2aWEgU01JIGludGVyZmFjZSIpOw0K
PiAgTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNh
L3JlYWx0ZWsvcnRsODM2NW1iLmMgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIu
Yw0KPiBpbmRleCA1ZmI0NTNiNWY2NTAuLmI1MmJiOTg3MDI3YyAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1iLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNh
L3JlYWx0ZWsvcnRsODM2NW1iLmMNCj4gQEAgLTE5ODcsMyArMTk4Nyw3IEBAIGNvbnN0IHN0cnVj
dCByZWFsdGVrX3ZhcmlhbnQgcnRsODM2NW1iX3ZhcmlhbnQgPSB7DQo+ICAJLmNoaXBfZGF0YV9z
eiA9IHNpemVvZihzdHJ1Y3QgcnRsODM2NW1iKSwNCj4gIH07DQo+ICBFWFBPUlRfU1lNQk9MX0dQ
TChydGw4MzY1bWJfdmFyaWFudCk7DQo+ICsNCj4gK01PRFVMRV9BVVRIT1IoIkFsdmluIMWgaXBy
YWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4iKTsNCj4gK01PRFVMRV9ERVNDUklQVElPTigiRHJp
dmVyIGZvciBSVEw4MzY1TUItVkMgZXRoZXJuZXQgc3dpdGNoIik7DQo+ICtNT0RVTEVfTElDRU5T
RSgiR1BMIik7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY2
LmMgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY2LWNvcmUuYw0KPiBzaW1pbGFyaXR5
IGluZGV4IDEwMCUNCj4gcmVuYW1lIGZyb20gZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2
Ni5jDQo+IHJlbmFtZSB0byBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY2LWNvcmUuYw0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NnJiLmMgYi9kcml2
ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY2cmIuYw0KPiBpbmRleCAzNGUzNzEwODRkNmQuLmZm
NjA3NjA4ZGVhZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2
NnJiLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NnJiLmMNCj4gQEAg
LTE4MTQsMyArMTgxNCw3IEBAIGNvbnN0IHN0cnVjdCByZWFsdGVrX3ZhcmlhbnQgcnRsODM2NnJi
X3ZhcmlhbnQgPSB7DQo+ICAJLmNoaXBfZGF0YV9zeiA9IHNpemVvZihzdHJ1Y3QgcnRsODM2NnJi
KSwNCj4gIH07DQo+ICBFWFBPUlRfU1lNQk9MX0dQTChydGw4MzY2cmJfdmFyaWFudCk7DQo+ICsN
Cj4gK01PRFVMRV9BVVRIT1IoIkxpbnVzIFdhbGxlaWogPGxpbnVzLndhbGxlaWpAbGluYXJvLm9y
Zz4iKTsNCj4gK01PRFVMRV9ERVNDUklQVElPTigiRHJpdmVyIGZvciBSVEw4MzY2UkIgZXRoZXJu
ZXQgc3dpdGNoIik7DQo+ICtNT0RVTEVfTElDRU5TRSgiR1BMIik7
