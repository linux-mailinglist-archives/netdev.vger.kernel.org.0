Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B11C3DD1A0
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhHBIDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:03:02 -0400
Received: from mail-eopbgr150099.outbound.protection.outlook.com ([40.107.15.99]:12523
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232537AbhHBICP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 04:02:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhFSgQXyEiXUmukBNXEH+iXmEDLnbBgvfA1KFsayQ3hqrXe1qOJ9CptC88r45crrJ+QGrB3pWWFPBxc+UltmtBygKPDpKUcZsU5749GQprQlnxchw95G8c1xH8d7soRn/nDebWY6jkXc+NTO8IzhCwP9JhK/qCuKNhcUeE5osZ2sl5ElaXtWUTH3nzAb2yh2LuneVZhLzqwja2oq4Taxi2bJwqXCc4ewQuzP5X+LGpm8B4qea+FGcy9Yu/21gnWZCYak0cM//0rPosnNr7gEGOFOmxaMCnO+TWVoYAFL7h6gJ8okj2GKGAHL4L0/6AGITNtxKEGWSXTm6Xb7Bet6Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZUHerf7lxoOtka6zgnLZToN/21OUB9HON9Ohiwu0Iw=;
 b=ZioxRsHL1y4gc8LPN9weyVKjKlj7JTNfZrY7fkagVwfB6VjOFxu/p3JRD/wqVV0R+r1fNORn1eBwOsVLVdZToXh+SWyGQvrHTKjHCcPRM4QzONgwPXRoYjXl2tg5cYHhpLTZTAlW94TTHufj6M2gXjcl+sk2YuUwTkDLtCRs5f6APnqO4NnYKfp0t46Y+KkoPS33KticUvBTfCY3PgHtuFn2VMzfSxARVIKImuLHyWAG4HT55Zi9uSps8eyNiZwB9pgf37HfZpS+yDfClHA7aq7AaioaUVgWwKRYjGnB3Uevwx3ox+X2yMsTH0UWiFP2/x9054MSbuazq7peh0j4MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZUHerf7lxoOtka6zgnLZToN/21OUB9HON9Ohiwu0Iw=;
 b=NLNq+hDGiDceh08Y64pfQxLyTfUwLwC3KKKfNV2IvUdfPwb73kWrqAnGpacgp6U2z6XMNmRmOixyeANjrTQtNnLQy30Ud9qRQthKq4H+gZDl/nSXCcy9UhYSpf3FKiHGXCN+B6ogdJBO3wTyww41WDN2Io7QSOr1wgyPI8dpiAE=
Received: from VE1PR05MB7327.eurprd05.prod.outlook.com (2603:10a6:800:1b0::18)
 by VI1PR05MB6622.eurprd05.prod.outlook.com (2603:10a6:803:e3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 08:02:03 +0000
Received: from VE1PR05MB7327.eurprd05.prod.outlook.com
 ([fe80::10c3:7a07:9dde:584]) by VE1PR05MB7327.eurprd05.prod.outlook.com
 ([fe80::10c3:7a07:9dde:584%6]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:02:03 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     zhengyongjun <zhengyongjun3@huawei.com>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] tipc: Return the correct errno code
Thread-Topic: [PATCH net-next] tipc: Return the correct errno code
Thread-Index: AQHXWOGxFjLDcBI1IEq8yG0LTNdx8KsDEcUAgF0jNzA=
Date:   Mon, 2 Aug 2021 08:02:03 +0000
Message-ID: <VE1PR05MB7327C7E4BC3EAF9D398A6B86F1EF9@VE1PR05MB7327.eurprd05.prod.outlook.com>
References: <20210604014702.2087584-1-zhengyongjun3@huawei.com>
 <7b100c7c3a7c4c658374164cb848d8e6@huawei.com>
In-Reply-To: <7b100c7c3a7c4c658374164cb848d8e6@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16fa249d-9e51-4918-7546-08d9558bd095
x-ms-traffictypediagnostic: VI1PR05MB6622:
x-microsoft-antispam-prvs: <VI1PR05MB6622915335014A44305D6043F1EF9@VI1PR05MB6622.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QB4RbSDkc9F0iD/BYK5lAK2+S3fY/z/zLiVmK5Pq1U/1TxcymGFltApAmssZ9Y1L6J2FruMpwBZiUNFr2XS1cEbUxokoDt5WFp+5RD+j1TqLTaQBnB4Sh+OR4ZZ4L4eT2VqfQlC5MnLyJ1OUgqBNseDrrGFWF158Od8atHIRl9U0LqyQArmVwrYfJk8eLm937DhSbX2Lau87piy0VnKoFERdp434P5xIdnKHy7kA+DzbPJufaaCDYf+SO8/hhgAiMDVrGg1H4/6S+stGZKrYDeL6VFzZJmW6wPCRjLOFMrxtBbyeS3yg160M2MB7ep4lMYoypsO1tLD5K/8llZvqbHYYjQ8iY+8zfSrDQZaOtm3p6AvILs/7+wvq7D2Eh29xf5NEnE0OYO+owuMzpD4jvEGNWI3g2ByAkvKAqRrf+yFOyFjQPWCqyDpAHcSz+cmlr9XgtyU0DYyg3gzQ/Hd2cM3aXHyaHoNG0SbHA+GUHMC8MhFqz2dxJJwd4OieIVcsSxrgq4n0kXkU0/GhPilQY/7G83OtiocIXqwHdeupcYBSc0VaQS3PZjSRMwugyPFiRch6Q1meUD/UABXkhJzdC1n+et4fX0qDeG+mjV7x8CseIc+i/wvhfijlXYPdRKT1u6Z5wnFoOwj1EDZaRDftDvHomggOv33c9+xL5U/wUD5kN1CyCAZr0gh0OqvioD0Ru6wCEj+gacS1TwEKRQDxzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR05MB7327.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39830400003)(136003)(396003)(366004)(33656002)(86362001)(186003)(76116006)(6506007)(66446008)(64756008)(53546011)(66476007)(66946007)(66556008)(55236004)(83380400001)(5660300002)(2906002)(8936002)(55016002)(8676002)(71200400001)(9686003)(316002)(478600001)(52536014)(7696005)(110136005)(26005)(122000001)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YldycXM3NW1zcFlrWjFrc0VHVFdVcmJaaGZ2Mk5YajJSa3djQ2c1eVdEZHlC?=
 =?utf-8?B?YzA0NWEwdmkydEM0Q05FMU00U2R1N1luQlVubHMwMDZEM3NrRUpyaWttNmlx?=
 =?utf-8?B?c1FobGxxb3Rld3BacGl2aUFEVEVsOGJZZGFTZXlEQVdQeWlaUi9BVEdiSUJW?=
 =?utf-8?B?dDBsZ0tXdERnNkY4MTNxalFtV2I2OCtNd3Z5SDRRSk54Ums4dW9SeUN1TlZy?=
 =?utf-8?B?ZUxzWW5IWmJndXFvbDRGS3VkUlVtT0ZIbVdOU1JxQWRDV0QxSUdiNkFON1ZG?=
 =?utf-8?B?N3pNdThvRTE3MFFwa2JEY3lRWmJVMkVrSVN6Ynp0Z2VQeERSc1htQ0x4MlJn?=
 =?utf-8?B?NkFCbWpSU3NvZjFuaW1VU0QxV1ZQbCtxeHZPd0RibDRYY0JXQUJCQVg2OHRj?=
 =?utf-8?B?TkhlSTMxL1FzdHZiODRXSlZGL3hPL3NoMXBGNzMvK3Q4R0ZzVjRQenZyTVYz?=
 =?utf-8?B?N2JZQU9JZW1URHRvWjF0ZkZLWmtPdDA2RVcwbWIvRkFMajEwQ1lVb1VlSzcv?=
 =?utf-8?B?eFlJc2k5V204cjRQYlZUeU9QeFAwdm0wZW9UZGttbXdWNmZRRzZvRUhDZFRv?=
 =?utf-8?B?bmNJZHdOeTVUNDZ5dE9uTm1uNm9MYUJzM1I1WlBrYUdoQ01VcUJkcFlrQXZW?=
 =?utf-8?B?WCt0VTlrNnh3RXNBbmVPcURNa1A0NnZVM0o5cWFoUTZjTU9PeGdoYVFHcStM?=
 =?utf-8?B?NDVTNjhMNEdRTzVpWnd2VXJES1EzSG1tT29jZ1hNaWl2T1pHZlVpdWY1N0xz?=
 =?utf-8?B?UnBGbkdoaFJ1azY5d1hQVVBCT0FRVDlJNDg2TCtzbkdudzViQlkvNXl0YkNk?=
 =?utf-8?B?Y0o4cDBVb29nZ01pM0plMG5vTkNaeHlCajBKZVYzbTE4Nlg0ekFiU3UxN0Mx?=
 =?utf-8?B?SUZQMnpLU3QxZTdQWU14Q0pOTkpGV01vT3ZINWhPU3E0bTloTFRBQTh0cGFk?=
 =?utf-8?B?SU9NaTJTWkZDTDBIakhrVlR1THNWNlRQYnA1WmhXM0kwWGVDaTl5ZWhvYWpY?=
 =?utf-8?B?dklFODJQMmpkSjVCZzl6ZlllQ2Q1UlI3V1dITERRUW1nSm1BVnFIZk82azBL?=
 =?utf-8?B?TllkZk0wSXRMTGIxNzVCVTRQOW5kSVBlbWQ0SkNDQjJJaFZwMS9UN2JrMmRT?=
 =?utf-8?B?R0xXQnhrQjhOaXptNVlhRCszSDNHUHl5V2trQU55aUUvd2VKWkRqbUVTUVhP?=
 =?utf-8?B?aEJLaTNsaHlkVVpYemhZOXBENjFFQ1RJdHBCbWdadHBjelU0bHptM3I4SFN3?=
 =?utf-8?B?RlhjWXB5WVpqL1dNUnpjU0luaFRrNDBucXVqUlY1VkV6YitQWUFzUm12cjJw?=
 =?utf-8?B?dkQza0k1SWJMYWRPWm9TZHlVWTlwTU5SS3gxMnM0SFY3ZWI1elhvUmo2YnB3?=
 =?utf-8?B?a2lQZ2RKWGhHbmFkcjRneGp2cUlLNm1XWTFmQVBHTUx5eDl5OFFCQTZuam50?=
 =?utf-8?B?aTk5UjBUREdlRnFVa3RocUZLR3VUUWR6RkgyM3lsMGNjM05nQ2VOcTdMdHVN?=
 =?utf-8?B?YVBoZEYyekZWcVh5OW5sL0hsQnBPc0RpQ3hmRVNia3pzaVFCTVRDUitLM1Zs?=
 =?utf-8?B?SE83SlppWmVoSkU1TDl5Vk1sRjNSVUdiRTRvS05EUkVkQmxhdTZRK2tNWHVk?=
 =?utf-8?B?RS9rUWdSMWZJNklrK3dOU2JSOFltWmNvNkxUYVkxcDhPSVVrU1BWUlp3MWdl?=
 =?utf-8?B?Y0d0VHVMbjlLOVpjMnJZcHJLekVtNTYvT29sT0llWUVwTjl6ck9zdWh5bTVu?=
 =?utf-8?Q?mxoUJYvzm1VSQ/rLDoxfEzdmOOrXgqrx5dmgcxs?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR05MB7327.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16fa249d-9e51-4918-7546-08d9558bd095
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 08:02:03.6254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /AUWuesACE00zid58xtZfTS20lMC4gWYjKmTnlmpOe59Ty1hikAMQyMjInfQcSsaanUnw5QG9cV17it5DU/fvZOLVtJf93BrnRl39zqnFjg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6622
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgWmhlbmcsDQoNClRoZSBwYXRjaCB3YXMgYmVpbmcgbWVyZ2VkIGJ5IGFjY2lkZW50LiBXaWxs
IGhhdmUgeW91IHBsYW5uaW5nIHRvIHJldmVydCBpdD8NCldlIG5lZWQgdG8gZG8gQVNBUCBzaW5j
ZSBjYWxsaW5nIHBhdGggdGlwY19ub2RlX3htaXQoKSAtPiB0aXBjX2xpbmtfeG1pdCgpIGJyb2tl
biBhcyBzaWRlIGVmZmVjdC4NCg0KVGhhbmtzLA0KaG9hbmcNCj4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gRnJvbTogemhlbmd5b25nanVuIDx6aGVuZ3lvbmdqdW4zQGh1YXdlaS5jb20+
DQo+IFNlbnQ6IEZyaWRheSwgSnVuZSA0LCAyMDIxIDg6MzUgQU0NCj4gVG86IGptYWxveUByZWRo
YXQuY29tOyB5aW5nLnh1ZUB3aW5kcml2ZXIuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJh
QGtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHRpcGMtDQo+IGRpc2N1c3Npb25A
bGlzdHMuc291cmNlZm9yZ2UubmV0OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1
YmplY3Q6IOetlOWkjTogW1BBVENIIG5ldC1uZXh0XSB0aXBjOiBSZXR1cm4gdGhlIGNvcnJlY3Qg
ZXJybm8gY29kZQ0KPiANCj4gU29ycnksIHRoaXMgcGF0Y2ggaXMgd3JvbmcsIHBsZWFzZSBpZ25v
cmUgaXQsIHRoYW5rcyA6KQ0KPiANCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bk
uro6IHpoZW5neW9uZ2p1bg0KPiDlj5HpgIHml7bpl7Q6IDIwMjHlubQ25pyINOaXpSA5OjQ3DQo+
IOaUtuS7tuS6ujogam1hbG95QHJlZGhhdC5jb207IHlpbmcueHVlQHdpbmRyaXZlci5jb207IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgdGlwYy0NCj4gZGlzY3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQ7IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmcNCj4g5oqE6YCBOiB6aGVuZ3lvbmdqdW4gPHpoZW5neW9uZ2p1bjNA
aHVhd2VpLmNvbT4NCj4g5Li76aKYOiBbUEFUQ0ggbmV0LW5leHRdIHRpcGM6IFJldHVybiB0aGUg
Y29ycmVjdCBlcnJubyBjb2RlDQo+IA0KPiBXaGVuIGthbGxvYyBvciBrbWVtZHVwIGZhaWxlZCwg
c2hvdWxkIHJldHVybiBFTk9NRU0gcmF0aGVyIHRoYW4gRU5PQlVGLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KPiAtLS0NCj4g
IG5ldC90aXBjL2xpbmsuYyB8IDYgKysrLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRp
b25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC90aXBjL2xpbmsu
YyBiL25ldC90aXBjL2xpbmsuYyBpbmRleCBjNDRiNGJmYWFlZTYuLjViNjE4MTI3N2NjNSAxMDA2
NDQNCj4gLS0tIGEvbmV0L3RpcGMvbGluay5jDQo+ICsrKyBiL25ldC90aXBjL2xpbmsuYw0KPiBA
QCAtOTEyLDcgKzkxMiw3IEBAIHN0YXRpYyBpbnQgbGlua19zY2hlZHVsZV91c2VyKHN0cnVjdCB0
aXBjX2xpbmsgKmwsIHN0cnVjdCB0aXBjX21zZyAqaGRyKQ0KPiAgCXNrYiA9IHRpcGNfbXNnX2Ny
ZWF0ZShTT0NLX1dBS0VVUCwgMCwgSU5UX0hfU0laRSwgMCwNCj4gIAkJCSAgICAgIGRub2RlLCBs
LT5hZGRyLCBkcG9ydCwgMCwgMCk7DQo+ICAJaWYgKCFza2IpDQo+IC0JCXJldHVybiAtRU5PQlVG
UzsNCj4gKwkJcmV0dXJuIC1FTk9NRU07DQo+ICAJbXNnX3NldF9kZXN0X2Ryb3BwYWJsZShidWZf
bXNnKHNrYiksIHRydWUpOw0KPiAgCVRJUENfU0tCX0NCKHNrYiktPmNoYWluX2ltcCA9IG1zZ19p
bXBvcnRhbmNlKGhkcik7DQo+ICAJc2tiX3F1ZXVlX3RhaWwoJmwtPndha2V1cHEsIHNrYik7DQo+
IEBAIC0xMDMwLDcgKzEwMzAsNyBAQCB2b2lkIHRpcGNfbGlua19yZXNldChzdHJ1Y3QgdGlwY19s
aW5rICpsKQ0KPiAgICoNCj4gICAqIENvbnN1bWVzIHRoZSBidWZmZXIgY2hhaW4uDQo+ICAgKiBN
ZXNzYWdlcyBhdCBUSVBDX1NZU1RFTV9JTVBPUlRBTkNFIGFyZSBhbHdheXMgYWNjZXB0ZWQNCj4g
LSAqIFJldHVybjogMCBpZiBzdWNjZXNzLCBvciBlcnJubzogLUVMSU5LQ09ORywgLUVNU0dTSVpF
IG9yIC1FTk9CVUZTDQo+ICsgKiBSZXR1cm46IDAgaWYgc3VjY2Vzcywgb3IgZXJybm86IC1FTElO
S0NPTkcsIC1FTVNHU0laRSBvciAtRU5PQlVGUyBvcg0KPiArIC1FTk9NRU0NCj4gICAqLw0KPiAg
aW50IHRpcGNfbGlua194bWl0KHN0cnVjdCB0aXBjX2xpbmsgKmwsIHN0cnVjdCBza19idWZmX2hl
YWQgKmxpc3QsDQo+ICAJCSAgIHN0cnVjdCBza19idWZmX2hlYWQgKnhtaXRxKQ0KPiBAQCAtMTA4
OCw3ICsxMDg4LDcgQEAgaW50IHRpcGNfbGlua194bWl0KHN0cnVjdCB0aXBjX2xpbmsgKmwsIHN0
cnVjdCBza19idWZmX2hlYWQgKmxpc3QsDQo+ICAJCQlpZiAoIV9za2IpIHsNCj4gIAkJCQlrZnJl
ZV9za2Ioc2tiKTsNCj4gIAkJCQlfX3NrYl9xdWV1ZV9wdXJnZShsaXN0KTsNCj4gLQkJCQlyZXR1
cm4gLUVOT0JVRlM7DQo+ICsJCQkJcmV0dXJuIC1FTk9NRU07DQo+ICAJCQl9DQo+ICAJCQlfX3Nr
Yl9xdWV1ZV90YWlsKHRyYW5zbXEsIHNrYik7DQo+ICAJCQl0aXBjX2xpbmtfc2V0X3NrYl9yZXRy
YW5zbWl0X3RpbWUoc2tiLCBsKTsNCj4gLS0NCj4gMi4yNS4xDQoNCg==
