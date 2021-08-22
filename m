Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A713F4232
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 00:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhHVWnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 18:43:10 -0400
Received: from mail-am6eur05on2101.outbound.protection.outlook.com ([40.107.22.101]:12385
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230172AbhHVWnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 18:43:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ef1upvx9XhhVv+9fWggYdn60kcicTRdEG6sGVQLBGfChsRellfygdjtcnGakpXCdm5EVwvKXOWh3dgHs6qtTPCd50ICrre7J/NUGxRDU9yoA3UUlnrEpM+q8CJsutyvMXvWlSFpKEQ0qnHl3QKJnUlxrVRrL0Ok/AzIodZW/yEj+/KqVv2uuAD4nxNA3Av5TxNjl2/yFW/rs+2W5wPQ9mKP+1CpiCrCHYaVG82wQSl+ssFJyX8Xt6b1GHjo+Xxueicobfm24q4IeEIOkr2BedxM438TLnD9XxtnVAEbtmwCAJnGUgsXWAfdvEUvmXgxrv7hKpvso2E/7GQCrMtTKkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dmj66X6WKCGMUzfmxAa7rmT8SRBnG4MXdU5eKPBkxQ=;
 b=oBIoGjI53xg5pz5ZNF7YZUZmwkceekPPNTOz34K1mEitqr/Ca/g655172ddkxubyF9d3lvocHk3kigALae0mDN18Bjmp+S5m9PSB/KOsw1LN9ksjYG7KdRiHNHCkIB2JMO8MJ8ye7v4OAwAw48+Ljw15mJBNhRVYFW2MKCd+7pCy7+54z1ezeD06h3m/S8kIMqnROB400obXqAVO8EEsb/m5vA1bIfzTONMjAsTqElaH+DWlEJGft/7h7NNrJ+Df5tGNVH35kEiyEpyEAhk2gSTLh5GBgVict+TsFURVELfcbpPMfAxwSS5ywGfd9FrwtzWklcle+kaQcCg6s7vF8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dmj66X6WKCGMUzfmxAa7rmT8SRBnG4MXdU5eKPBkxQ=;
 b=jIdAnc17vxk5gXF8bI8Y/EkJJzeSuyDcWy9370lAbHxKCqV0ljFDFPwfao7ihLHwcXeKIZPdYNUtkLAyc+a3gHe0iB1jwsE9Tz/YJjH/MqU7mGFMtd0zAOMXzNFME1ygPJbYRaaqojYJxUR5LFxAb8pOVa9TcJyHriNZRZCJzUM=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2810.eurprd03.prod.outlook.com (2603:10a6:3:f2::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Sun, 22 Aug 2021 22:42:23 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Sun, 22 Aug 2021
 22:42:23 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <olteanv@gmail.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 1/5] net: dsa: realtek-smi: fix mdio_free bug
 on module unload
Thread-Topic: [RFC PATCH net-next 1/5] net: dsa: realtek-smi: fix mdio_free
 bug on module unload
Thread-Index: AQHXl4x7EC/JWmhXnkaFSDyQCHXzdauAEYYAgAANUgA=
Date:   Sun, 22 Aug 2021 22:42:23 +0000
Message-ID: <65997ecd-d405-c258-89d2-d6418c3ae2c4@bang-olufsen.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-2-alvin@pqrs.dk>
 <20210822215442.a2xywnodg7qwf2b5@skbuf>
In-Reply-To: <20210822215442.a2xywnodg7qwf2b5@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7afb51ca-df44-4885-28a6-08d965be1bc8
x-ms-traffictypediagnostic: HE1PR0302MB2810:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0302MB2810894E2D5E34868ECDC40F83C39@HE1PR0302MB2810.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: opwhE0qApcazUXJCzoZ9W5UFdUu9JdIdc+UmcS6mrbSeaMdYPmCrofVIvYy1reNYmypj8l/cnocBUfxha58Bqu59Mk8SNd2a9HWCCnk/91eN32GgKcQiRBseLnQKmKb6R5d+zhzRnUKx2D7gLU9sOGwcObEAUPemgPFiFkeBksizesK25PMK4+7VPerdERzxvjokUcuLi4UBjgRUjx8nSHl391mQK3NQtweoOKGFn29xgSLuntWKLVNf7sOIWU0Dpz23B6QoIISL+rTmnoD1Y6xn0pa3swvR0A9QV/LN/t+OtgcbZFJACiYUWrUq9D/xaW7dgJPqQUl1KxsGggIAaEqm/DwUrOAYlkXaLqaH6VIZbxC003CIZWIEqPrmFsbulDdaE1pYyYHFYgVvFohOz7//mqgENrdSareFM9EV3/Fj5PtkRMdIokwjevfte9YlEl4/QT8rYq+XqWaJLJxdTr2iMZ9/EK3vEYJCuiCPFF06aK6j9Uf7gcmxQZUjf8cyln/aYCeUHbDNsasfwgSmBwGSZjw9FZJ00pMBjWBry441Gvql+nTrnTCPY4pssOyn60M2F3HvFNAaYrLuGJYpPoREplPhxgzzPfBre3ycyMp253tFhRZOQgr/2BklW3zxktM/4uKBDa/SBW5o6StXCyALMpRTj7taUg9UIp6iXdcXueiS4M8D9RaaRJWlx4PYX8ebmeQ0IEnHi2OMcqVb6cOKkhc+C2oPkKxnQIrdEsbR1d0VRFdhlV3mrNyEZ44e1ATMVc1Sj4r1GSWRbWEaHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(366004)(396003)(376002)(346002)(136003)(6512007)(4326008)(2906002)(76116006)(2616005)(7416002)(91956017)(66446008)(66556008)(6506007)(6486002)(110136005)(5660300002)(54906003)(66946007)(64756008)(66476007)(316002)(478600001)(53546011)(85182001)(31686004)(31696002)(122000001)(86362001)(38100700002)(36756003)(38070700005)(66574015)(186003)(85202003)(83380400001)(26005)(8676002)(8976002)(71200400001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmdsczhFTlA0NHdHanRjMTBST2ZXclZUbUpocTJ2amVlN2VIKzR2cmUvaHlV?=
 =?utf-8?B?clpsZFVjNDc0cUhjdTRpbldqTHBvU3hpTGV4VlBjZ3RHa0J3OXdlVThXd2cv?=
 =?utf-8?B?UFpUTEVIakY3THdzdWQvdE5Yd0lORTBobnp2d3UvbWp1UVRUaHZlbit4MjE4?=
 =?utf-8?B?YUNhVWZ3MElMaEltK2t0NUJJQ0FSMnIvekcxTXAvWENnTFFZLzNiV2hCVXRz?=
 =?utf-8?B?Z0dBRnZZUm9uVHYrWUcrbllHUnpaWjFLeFRlS3l4ZFdzSFMwTThaVHFBQ3FE?=
 =?utf-8?B?cXNNS1VncTk3M0VWTkd3NUFDbTkxRHVNMytWaWxJQ21Hd2JjQWJWYUdPQ2RP?=
 =?utf-8?B?MWJBQUJFNUdsd2llYTNZK3ZQZHVJZGFqNnZvL2dwcS9pOGp4Ui9tQjk5Snhz?=
 =?utf-8?B?djZxTC9wa0RUZW5XTmwrRUNhNm1CQVl5RnpnS0hFZDQ3T1pmN0pIM05GRUpy?=
 =?utf-8?B?RS9mNzl4em05V2JseGFhbzJ0WVltS3lNb1h2bVBkQXMrZ2R6Wm5jc29vWnFt?=
 =?utf-8?B?UksrU0ZERmk1MlFScDhBSklFZ1kxaktkNlpPWWRPd3NSbGZCaXVSTXYwUXR0?=
 =?utf-8?B?UGJFSnprTWJqZmlBcW9nbXg3MjdqZWtBU3Y4TzJpbEMzQUhUcC9XaVNwYnYz?=
 =?utf-8?B?UjBFV2QvZHBHOHE5T01LZzNscWJVSzN1V0xzVFRkbFRmMnpxQ004Uy9PNFNZ?=
 =?utf-8?B?TWJkQWNxOWhMNGNPWUNKd1duY1RxN240RStvUTBtMnJDNjUwMlhjRnMvcnRp?=
 =?utf-8?B?T2hOQWxrVGdoQ2RyTDl4TXdTUkxvbHJhRHRTZWl1aW5EdzVRbmV5TWRlNTBF?=
 =?utf-8?B?S2RPVmJZWGZSb3RlS3dIUEpoc1E3S2cxbmM2VXRLOHFvdi9tMFNNcTBtL3J5?=
 =?utf-8?B?SGd2OHVhSzAweElweEdYR2RHbDdtM2pQT21iVXRzTHc0TGFTTFBMUG1ETVBm?=
 =?utf-8?B?ZVhGRy9RMG5BKzRTQ0E5VlJPWFBHdnc1ck9sd0VESHdkaGw0YzNWbWpDVEtw?=
 =?utf-8?B?VWk5alAwdEZZTGdocHRwZjBZeDhUREoxMnlMOHFGWVV5ejRCREVyV0tkM3Nt?=
 =?utf-8?B?T3RsWkg4L2NVUlFlUjhoMkNIS0k2aUJibjRVZ1A3TGJJSDNwT0tBZGozYkhD?=
 =?utf-8?B?bDZjcVNKQW5BaDFBWU4vRU1Ja3VzV0tyek1ScHI2YzF3Qmh3K2lTTktpMVhr?=
 =?utf-8?B?Yk0zTjF2TWovWUVmNkZWeFRWd01jbWpPbHQ3UEdiSWlyaXA4UC82T3o1UVh4?=
 =?utf-8?B?dTBQQWRoOVJ2alU1VjhoMjZZR0NrQXpBZjJVQ2R6ck1kZVBCTGhTQVBBR1g1?=
 =?utf-8?B?ME9pT2I5cWtYNW1NSWplelUzNEV4ZHVQN0dlMDBYcFA1RjU2MmNoNWVHSUVH?=
 =?utf-8?B?cmYzZkx3cFdacGJWQ2huNEFxTDVKb0l4bjRVRjFiM2l6dmo1cnA4WVN5cUY4?=
 =?utf-8?B?akFVWkRsR2VrUDhwSTJMQ1FKT0lMU1l6Ympwa0JObUhsOGFTVW9TT0FzWjln?=
 =?utf-8?B?d09OU0xsRUdRNnphQk9BNlhwZUxJY3VKQTdmc1JqZGJmcmgzS1lYaHJ3dkM1?=
 =?utf-8?B?QVMwcTFHcWx5N0d1L1VESklzVTl3VDBuZWg0L0FwQS9hZy9hZWNFWExyRjhG?=
 =?utf-8?B?M1B3a2daRFYzMk5MNEtiSGxCbTExOWtWRTdJdW1oQUpLVGdmL1I3YmZhZTBH?=
 =?utf-8?B?UHBJdUk0SzZ4S0t3bWxWSnYvVTZ4Z05hN1Jzc0ljNkJKbzcyQ09aTGd2a3FT?=
 =?utf-8?Q?iMUbthcMcpwNcQxWvf92JMnP1kKxBg6EKIixtST?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <89CBCBBC789ED44DB199217B40615895@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7afb51ca-df44-4885-28a6-08d965be1bc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2021 22:42:23.2440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zMuc36V6bXGOATGE45m7WgVn8wX7Ips7pJEXmkYEs/hEFPVySNz3CU7hVaLztJqs3LLpdtrxXdfQsKOPQYAScw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2810
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIDgvMjIvMjEgMTE6NTQgUE0sIFZsYWRpbWlyIE9sdGVhbiB3cm90
ZToNCj4gT24gU3VuLCBBdWcgMjIsIDIwMjEgYXQgMDk6MzE6MzlQTSArMDIwMCwgQWx2aW4gxaBp
cHJhZ2Egd3JvdGU6DQo+PiBGcm9tOiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4u
ZGs+DQo+Pg0KPj4gcmVhbHRlay1zbWktY29yZSBmYWlscyB0byB1bnJlZ2lzdGVyIHRoZSBzbGF2
ZSBNSUkgYnVzIG9uIG1vZHVsZSB1bmxvYWQsDQo+PiByYWlzaW5nIHRoZSBmb2xsb3dpbmcgQlVH
IHdhcm5pbmc6DQo+Pg0KPj4gICAgICBtZGlvX2J1cy5jOjY1MDogQlVHX09OKGJ1cy0+c3RhdGUg
IT0gTURJT0JVU19VTlJFR0lTVEVSRUQpOw0KPj4NCj4+ICAgICAga2VybmVsIEJVRyBhdCBkcml2
ZXJzL25ldC9waHkvbWRpb19idXMuYzo2NTAhDQo+PiAgICAgIEludGVybmFsIGVycm9yOiBPb3Bz
IC0gQlVHOiAwIFsjMV0gUFJFRU1QVF9SVCBTTVANCj4+ICAgICAgQ2FsbCB0cmFjZToNCj4+ICAg
ICAgIG1kaW9idXNfZnJlZSsweDRjLzB4NTANCj4+ICAgICAgIGRldm1fbWRpb2J1c19mcmVlKzB4
MTgvMHgyMA0KPj4gICAgICAgcmVsZWFzZV9ub2Rlcy5pc3JhLjArMHgxYzAvMHgyYjANCj4+ICAg
ICAgIGRldnJlc19yZWxlYXNlX2FsbCsweDM4LzB4NTgNCj4+ICAgICAgIGRldmljZV9yZWxlYXNl
X2RyaXZlcl9pbnRlcm5hbCsweDEyNC8weDFlOA0KPj4gICAgICAgZHJpdmVyX2RldGFjaCsweDU0
LzB4ZTANCj4+ICAgICAgIGJ1c19yZW1vdmVfZHJpdmVyKzB4NjAvMHhkOA0KPj4gICAgICAgZHJp
dmVyX3VucmVnaXN0ZXIrMHgzNC8weDYwDQo+PiAgICAgICBwbGF0Zm9ybV9kcml2ZXJfdW5yZWdp
c3RlcisweDE4LzB4MjANCj4+ICAgICAgIHJlYWx0ZWtfc21pX2RyaXZlcl9leGl0KzB4MTQvMHgx
YyBbcmVhbHRla19zbWldDQo+Pg0KPj4gRml4IHRoaXMgYnkgZHVseSB1bnJlZ2lzdGVyaW5nIHRo
ZSBzbGF2ZSBNSUkgYnVzIHdpdGgNCj4+IG1kaW9idXNfdW5yZWdpc3Rlci4gV2UgZG8gdGhpcyBp
biB0aGUgRFNBIHRlYXJkb3duIHBhdGgsIHNpbmNlDQo+PiByZWdpc3RyYXRpb24gaXMgcGVyZm9y
bWVkIGluIHRoZSBEU0Egc2V0dXAgcGF0aC4NCj4+DQo+PiBDYzogTGludXMgV2FsbGVpaiA8bGlu
dXMud2FsbGVpakBsaW5hcm8ub3JnPg0KPj4gRml4ZXM6IGQ4NjUyOTU2Y2YzNyAoIm5ldDogZHNh
OiByZWFsdGVrLXNtaTogQWRkIFJlYWx0ZWsgU01JIGRyaXZlciIpDQo+PiBTaWduZWQtb2ZmLWJ5
OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQo+PiAtLS0NCj4+ICAgZHJp
dmVycy9uZXQvZHNhL3JlYWx0ZWstc21pLWNvcmUuYyB8IDYgKysrKysrDQo+PiAgIGRyaXZlcnMv
bmV0L2RzYS9yZWFsdGVrLXNtaS1jb3JlLmggfCAxICsNCj4+ICAgZHJpdmVycy9uZXQvZHNhL3J0
bDgzNjZyYi5jICAgICAgICB8IDggKysrKysrKysNCj4+ICAgMyBmaWxlcyBjaGFuZ2VkLCAxNSBp
bnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVr
LXNtaS1jb3JlLmMgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay1zbWktY29yZS5jDQo+PiBpbmRl
eCA4ZTQ5ZDRmODVkNDguLjY5OTJiNmIzMWRiNiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0
L2RzYS9yZWFsdGVrLXNtaS1jb3JlLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVr
LXNtaS1jb3JlLmMNCj4+IEBAIC0zODMsNiArMzgzLDEyIEBAIGludCByZWFsdGVrX3NtaV9zZXR1
cF9tZGlvKHN0cnVjdCByZWFsdGVrX3NtaSAqc21pKQ0KPj4gICAJcmV0dXJuIHJldDsNCj4+ICAg
fQ0KPj4gICANCj4+ICt2b2lkIHJlYWx0ZWtfc21pX3RlYXJkb3duX21kaW8oc3RydWN0IHJlYWx0
ZWtfc21pICpzbWkpDQo+PiArew0KPj4gKwlpZiAoc21pLT5zbGF2ZV9taWlfYnVzKQ0KPj4gKwkJ
bWRpb2J1c191bnJlZ2lzdGVyKHNtaS0+c2xhdmVfbWlpX2J1cyk7DQo+PiArfQ0KPj4gKw0KPj4g
ICBzdGF0aWMgaW50IHJlYWx0ZWtfc21pX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBk
ZXYpDQo+PiAgIHsNCj4+ICAgCWNvbnN0IHN0cnVjdCByZWFsdGVrX3NtaV92YXJpYW50ICp2YXI7
DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWstc21pLWNvcmUuaCBiL2Ry
aXZlcnMvbmV0L2RzYS9yZWFsdGVrLXNtaS1jb3JlLmgNCj4+IGluZGV4IGZjZjQ2NWY3ZjkyMi4u
NmNmYTVmMmRmN2VhIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWstc21p
LWNvcmUuaA0KPj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWstc21pLWNvcmUuaA0KPj4g
QEAgLTExOSw2ICsxMTksNyBAQCBzdHJ1Y3QgcmVhbHRla19zbWlfdmFyaWFudCB7DQo+PiAgIGlu
dCByZWFsdGVrX3NtaV93cml0ZV9yZWdfbm9hY2soc3RydWN0IHJlYWx0ZWtfc21pICpzbWksIHUz
MiBhZGRyLA0KPj4gICAJCQkJdTMyIGRhdGEpOw0KPj4gICBpbnQgcmVhbHRla19zbWlfc2V0dXBf
bWRpbyhzdHJ1Y3QgcmVhbHRla19zbWkgKnNtaSk7DQo+PiArdm9pZCByZWFsdGVrX3NtaV90ZWFy
ZG93bl9tZGlvKHN0cnVjdCByZWFsdGVrX3NtaSAqc21pKTsNCj4+ICAgDQo+PiAgIC8qIFJUTDgz
NjYgbGlicmFyeSBoZWxwZXJzICovDQo+PiAgIGludCBydGw4MzY2X21jX2lzX3VzZWQoc3RydWN0
IHJlYWx0ZWtfc21pICpzbWksIGludCBtY19pbmRleCwgaW50ICp1c2VkKTsNCj4+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9kc2EvcnRsODM2NnJiLmMgYi9kcml2ZXJzL25ldC9kc2EvcnRsODM2
NnJiLmMNCj4+IGluZGV4IGE4OTA5M2JjNmM2YS4uNjUzN2ZhYzdhYmE0IDEwMDY0NA0KPj4gLS0t
IGEvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9kc2Ev
cnRsODM2NnJiLmMNCj4+IEBAIC05ODIsNiArOTgyLDEzIEBAIHN0YXRpYyBpbnQgcnRsODM2NnJi
X3NldHVwKHN0cnVjdCBkc2Ffc3dpdGNoICpkcykNCj4+ICAgCXJldHVybiAwOw0KPj4gICB9DQo+
PiAgIA0KPj4gK3N0YXRpYyB2b2lkIHJ0bDgzNjZyYl90ZWFyZG93bihzdHJ1Y3QgZHNhX3N3aXRj
aCAqZHMpDQo+PiArew0KPj4gKwlzdHJ1Y3QgcmVhbHRla19zbWkgKnNtaSA9IGRzLT5wcml2Ow0K
Pj4gKw0KPj4gKwlyZWFsdGVrX3NtaV90ZWFyZG93bl9tZGlvKHNtaSk7DQo+PiArfQ0KPj4gKw0K
PiANCj4gT2JqZWN0aW9uOiBkc2Ffc3dpdGNoX3RlYXJkb3duIGhhczoNCj4gDQo+IAlpZiAoZHMt
PnNsYXZlX21paV9idXMgJiYgZHMtPm9wcy0+cGh5X3JlYWQpDQo+IAkJbWRpb2J1c191bnJlZ2lz
dGVyKGRzLT5zbGF2ZV9taWlfYnVzKTsNCg0KVGhpcyBpcyB1bnJlZ2lzdGVyaW5nIGFuIG1kaW9i
dXMgcmVnaXN0ZXJlZCBpbiBkc2Ffc3dpdGNoX3NldHVwOg0KDQoJaWYgKCFkcy0+c2xhdmVfbWlp
X2J1cyAmJiBkcy0+b3BzLT5waHlfcmVhZCkgew0KCQlkcy0+c2xhdmVfbWlpX2J1cyA9IGRldm1f
bWRpb2J1c19hbGxvYyhkcy0+ZGV2KTsNCgkJaWYgKCFkcy0+c2xhdmVfbWlpX2J1cykgew0KCQkJ
ZXJyID0gLUVOT01FTTsNCgkJCWdvdG8gdGVhcmRvd247DQoJCX0NCg0KCQlkc2Ffc2xhdmVfbWlp
X2J1c19pbml0KGRzKTsNCg0KCQllcnIgPSBtZGlvYnVzX3JlZ2lzdGVyKGRzLT5zbGF2ZV9taWlf
YnVzKTsNCgkJaWYgKGVyciA8IDApDQoJCQlnb3RvIHRlYXJkb3duOw0KCX0NCg0KSG93ZXZlciwg
d2UgZG9uJ3QgZW50ZXIgdGhpcyBjb2RlcGF0aCBiZWNhdXNlOg0KDQotIGRzLT5zbGF2ZV9taWlf
YnVzIGlzIGFscmVhZHkgc2V0IGluIHRoZSBjYWxsIHRvIGRzLT5vcHMtPnNldHVwKCkgDQpiZWZv
cmUgdGhlIGNvZGUgc25pcHBldCBhYm92ZTsNCi0gZHMtPm9wcy0+cGh5X3JlYWQgaXMgbm90IHNl
dC4NCg0KV2UgZG9uJ3Qgd2FudCB0byBlaXRoZXIsIHNpbmNlIHdlIHdhbnQgdG8gdXNlIG9mX21k
aW9idXNfcmVnaXN0ZXIoKS4NCg0KPiANCj4gVGhlIHJlYWx0ZWtfc21pX3NldHVwX21kaW8gZnVu
Y3Rpb24gZG9lczoNCj4gDQo+IAlzbWktPmRzLT5zbGF2ZV9taWlfYnVzID0gc21pLT5zbGF2ZV9t
aWlfYnVzOw0KPiANCj4gc28gSSB3b3VsZCBleHBlY3QgdGhhdCB0aGlzIHdvdWxkIHJlc3VsdCBp
biBhIGRvdWJsZSB1bnJlZ2lzdGVyIG9uIHNvbWUNCj4gc3lzdGVtcy4NCj4gDQo+IEkgaGF2ZW4n
dCB3ZW50IHRocm91Z2ggeW91ciBuZXcgZHJpdmVyLCBidXQgSSB3b25kZXIgd2hldGhlciB5b3Ug
aGF2ZQ0KPiB0aGUgcGh5X3JlYWQgYW5kIHBoeV93cml0ZSBtZXRob2RzIGltcGxlbWVudGVkPyBN
YXliZSB0aGF0IGlzIHRoZQ0KPiBkaWZmZXJlbmNlPw0KDQpSaWdodCwgcGh5X3JlYWQvcGh5X3dy
aXRlIGFyZSBub3Qgc2V0IGluIHRoZSBkc2Ffc3dpdGNoX29wcyBvZiANCnJ0bDgzNjVtYi4gU28g
d2Ugc2hvdWxkIGJlIHNhZmUuDQoNCkl0IGRpZCBnZXQgbWUgdGhpbmtpbmcgdGhhdCBpdCB3b3Vs
ZCBiZSBuaWNlIGlmIGRzYV9yZWdpc3Rlcl9zd2l0Y2goKSANCmNvdWxkIGNhbGwgb2ZfbWRpb2J1
c19yZWdpc3RlcigpIHdoZW4gbmVjZXNzYXJ5LCBzaW5jZSB0aGUgc25pcHBldCBhYm92ZSANCihh
bmQgaXRzIGNhbGwgdG8gZHNhX3NsYXZlX21paV9idXNfaW5pdCgpKSBpcyBhbG1vc3Qgc2FtZSBh
cyANCnJlYWx0ZWtfc21pX3NldHVwX21kaW8oKS4gSXQgd291bGQgc2ltcGxpZnkgc29tZSBsb2dp
YyBpbiByZWFsdGVrLXNtaSANCmRyaXZlcnMgYW5kIG9idmlhdGUgdGhlIG5lZWQgZm9yIHRoaXMg
cGF0Y2guIEkgYW0gbm90IHN1cmUgd2hhdCB0aGUgDQpyaWdodCBhcHByb2FjaCB0byB0aGlzIHdv
dWxkIGJlIGJ1dCB3aXRoIHNvbWUgcG9pbnRlcnMgSSBjYW4gZ2l2ZSBpdCBhIHNob3QuDQoNCj4g
DQo+PiAgIHN0YXRpYyBlbnVtIGRzYV90YWdfcHJvdG9jb2wgcnRsODM2Nl9nZXRfdGFnX3Byb3Rv
Y29sKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywNCj4+ICAgCQkJCQkJICAgICAgaW50IHBvcnQsDQo+
PiAgIAkJCQkJCSAgICAgIGVudW0gZHNhX3RhZ19wcm90b2NvbCBtcCkNCj4+IEBAIC0xNTA1LDYg
KzE1MTIsNyBAQCBzdGF0aWMgaW50IHJ0bDgzNjZyYl9kZXRlY3Qoc3RydWN0IHJlYWx0ZWtfc21p
ICpzbWkpDQo+PiAgIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHNhX3N3aXRjaF9vcHMgcnRsODM2NnJi
X3N3aXRjaF9vcHMgPSB7DQo+PiAgIAkuZ2V0X3RhZ19wcm90b2NvbCA9IHJ0bDgzNjZfZ2V0X3Rh
Z19wcm90b2NvbCwNCj4+ICAgCS5zZXR1cCA9IHJ0bDgzNjZyYl9zZXR1cCwNCj4+ICsJLnRlYXJk
b3duID0gcnRsODM2NnJiX3RlYXJkb3duLA0KPj4gICAJLnBoeWxpbmtfbWFjX2xpbmtfdXAgPSBy
dGw4MzY2cmJfbWFjX2xpbmtfdXAsDQo+PiAgIAkucGh5bGlua19tYWNfbGlua19kb3duID0gcnRs
ODM2NnJiX21hY19saW5rX2Rvd24sDQo+PiAgIAkuZ2V0X3N0cmluZ3MgPSBydGw4MzY2X2dldF9z
dHJpbmdzLA0KPj4gLS0gDQo+PiAyLjMyLjANCj4+DQo=
