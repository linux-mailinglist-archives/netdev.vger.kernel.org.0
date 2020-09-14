Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6BC2697AC
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgINVYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:24:47 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:19787 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgINVYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:24:44 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5fde670000>; Tue, 15 Sep 2020 05:19:35 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Mon, 14 Sep 2020 14:19:35 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Mon, 14 Sep 2020 14:19:35 -0700
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Sep
 2020 21:19:31 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.54) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 14 Sep 2020 21:19:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUWSgTOcroj0yMbNGQ9MaE9YriyWTeUM1paylksICIrDf0et0Sj+qH6AiYNKW0vNAHjXTHEzMJIceGbcC9euJWRjKl5cCWCaRzxa69RM44cZuRubPYiIrqVPDhL+lGf1YZvuuzeSh1YxrR7vVn6xF9cBf29UCOaNqgm08tqjEpPljyoP6rPKVd6EsOo+y+NoLaMq7Y2tyegM09+iRoyUD4yaXDV63zYthmlPGd9T6v+1A0ovMI5NjTqcqsDxmCcjklxsPYE1OP4cHPQRhuFm6a/rvQJm4u+9oK0lYwEbWaA4yZvQjQ1HJ5sLNCaO8A87x3LiE0WvfqfpeuU12sEAPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMPjnmt0FGManZMAMYnvCOYIR/sC29xJK2sj49UFbjo=;
 b=knV8+nQC1d/r6icxo00i7fMW5Bbx5aWxIM1EzSV3ILWeiAv1mBy2g7SIcfQjK2qdXQg0UXGD7p8PwI7FCMCW+MDr5J8bjC9qKgkdmCj19LNETM8EcPiw33P2rjvLqXwOGfzeDB5wHRcvjyd0guF4TvQ1uwpbMD0UQxkxQTwOvx2FZH0jdRZbn/GW2dqsaTXqjbUujlmEXhywTmxqcpE2aanF7LCeHoN06+fW4KLs8Qycljn8/idAOia6gzE22OZHo5e1c1Elo/dI0da3a/HrbG/UnvqUHL6Y3mqnRatzN5D39ot7/GsjL9Cn1J67FUUt/3qIYDdIrLSHZdpj4cwNsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB3681.namprd12.prod.outlook.com (2603:10b6:a03:194::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 21:19:25 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::90a0:8549:2aeb:566%6]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 21:19:25 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        Tariq Toukan <tariqt@nvidia.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 2/8] docs: net: include the new ethtool pause
 stats in the stats doc
Thread-Topic: [PATCH net-next v2 2/8] docs: net: include the new ethtool pause
 stats in the stats doc
Thread-Index: AQHWiJNXEgM4oiMb8UeBzJO0n0/JmKloio8AgAAFWwCAABhfAA==
Date:   Mon, 14 Sep 2020 21:19:25 +0000
Message-ID: <961c3983df3e42b5cd6da909c69a0fa1f5c5c850.camel@nvidia.com>
References: <20200911232853.1072362-1-kuba@kernel.org>
         <20200911232853.1072362-3-kuba@kernel.org>
         <1ee0f0af5fc15236689028a95ea25082138a6ebd.camel@nvidia.com>
         <20200914125210.3b230a32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914125210.3b230a32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df35dca1-409c-48f6-d1d5-08d858f3db81
x-ms-traffictypediagnostic: BY5PR12MB3681:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB36811A8752082BB9858073FCB3230@BY5PR12MB3681.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ka0TwbTWfbmJ3HWtpW6rQKutWlc7p6kSl882J1DPFquZ5MlUKMoAMsETTr15JuhcLnJhkv8q5WbwgxUTmOeYdlgDD6geNcjubDSOjtfp9NMNnB6o5zpFnENzY46B0Rp1OzFqTWOFM8I5xPkbQuBGQ+k2pEwbpig5sS5V30EFWZgV9A3/OKRvEFT8oa9Y0DjUDxVpkQBoWqpGDLJRKUunahOMX861LMri2mZr6cGfzo/s110eKu+/8mWO9RXbWt2ShxGzVAHLQ/kQ731A/yE2McffGRvk8qy/QY8s5WjQBMfjpMtE1Hufa7htp0EiHmgYBpIjSdhghejp/M6xEz8l5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(316002)(8936002)(8676002)(54906003)(478600001)(6506007)(186003)(26005)(4326008)(2616005)(66556008)(66476007)(6512007)(66446008)(66946007)(64756008)(86362001)(76116006)(2906002)(36756003)(83380400001)(6916009)(5660300002)(6486002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RjP+bQvS8J/t0zSFclxuckFjbk0NKJQU5tpxn0j8NnOdEB3Deua8dxAxqVzkFimFvzma9PMlF3LQXV+r8p/TNOTYSoWVQbVRTmkOyTdsALwj51ea144lPoiOUKJsxrDJGe9tardpuYtbApxhWQZ43Oq7X4UNyQZJhd5rru6wOas694r9tkE0RKdzjeFEcKd8VmXb0Y1xiofRyDEEkeBbnWXZsHkxIDN6QtJHRZ9Rwuc9eL2sO4OBKINMs6jU8I7gs7153QSwR2Sf+NEmCArpsI5Wdc9U5U9RwORzt4n9LtCURet8YwQiIoMbRGLhy/G+ZeB68E3QWXb5GMc7Egw3qw/jFNEnP3RregGEcmg5x8kvPboqMpGQQNpFTLCEIgG1zpCvnT5wsKjMjVNqN1EtIQXaF8A94ZhKCU2Jl/zBH4o2r0Vl+GrwsIHY7es+/8MhLizf4xak+1dnDWv9Ln/ooTFAFZVbFB33oEBMkkhHDFjZhd9dCB4NGJhUqjZc/DVwJvubIzHPzKq5qGwM0TdelwY5JbZMBCboaMYKdGTfYy2/QcFzJMEkIyhAoGl9kQMBdsa+oo6QV1zfkhWkwMMHoui7m15SxOZ6aioWKBdPvN6T8njXGEs1fs7f2XtdssHgxLoVcTh6ZzL9PAiilIaZCA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3C68144059623439B7F0E187B026530@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df35dca1-409c-48f6-d1d5-08d858f3db81
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 21:19:25.3809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4/A1Fkj0IbcF4J+OlTJEedp7k6jbvhRGqeSMhpofjLjZ1tICeNlD1YGGvkEuzAVGStsFHRATuKfvlldE4YJpdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3681
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600118375; bh=UMPjnmt0FGManZMAMYnvCOYIR/sC29xJK2sj49UFbjo=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:Content-ID:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=azcoYJg01Rp1fGDtsGmdoNnBTiiJJYExjC4n1FFe4hN7CbQMWH2HKwUORhOv0AST1
         qbuDuLndAe6O765aixb34AfdK590BpxfBKwOQ0VaXGcRT0ZBUfXkiJdw2TgXVn8tnW
         UVM8yJTRJbJhhvviPvoWH6+mJoWKz0D2LJXOVaKfabrMucWE6uqnsS5UqbPVzHd9dw
         l1A3bFnr1ixwiaasjUYDSMPZByZJSwimDeqmT8ExtQfBa2iDh3vQzNIQkPj8IDSAhK
         B0oj7lhhjiQ91rsxp500sn8AgRUXZE/1kvGFcEyExf/tT65uh9MD50+OWuHmuWrpkZ
         DB2jUPQYc5tQw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA5LTE0IGF0IDEyOjUyIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAxNCBTZXAgMjAyMCAxOTozMzowOCArMDAwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiA+ICtQcm90b2NvbC1zcGVjaWZpYyBzdGF0aXN0aWNzDQo+ID4gPiArLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ID4gKw0KPiA+ID4gK1NvbWUgb2YgdGhlIGludGVyZmFj
ZXMgdXNlZCBmb3IgY29uZmlndXJpbmcgZGV2aWNlcyBhcmUgYWxzbw0KPiA+ID4gYWJsZQ0KPiA+
ID4gK3RvIHJlcG9ydCByZWxhdGVkIHN0YXRpc3RpY3MuIEZvciBleGFtcGxlIGV0aHRvb2wgaW50
ZXJmYWNlIHVzZWQNCj4gPiA+ICt0byBjb25maWd1cmUgcGF1c2UgZnJhbWVzIGNhbiByZXBvcnQg
Y29ycmVzcG9uZGluZyBoYXJkd2FyZQ0KPiA+ID4gY291bnRlcnM6Og0KPiA+ID4gKw0KPiA+ID4g
KyAgJCBldGh0b29sIC0taW5jbHVkZS1zdGF0aXN0aWNzIC1hIGV0aDANCj4gPiA+ICsgIFBhdXNl
IHBhcmFtZXRlcnMgZm9yIGV0aDA6DQo+ID4gPiArICBBdXRvbmVnb3RpYXRlOglvbg0KPiA+ID4g
KyAgUlg6CQkJb24NCj4gPiA+ICsgIFRYOgkJCW9uDQo+ID4gPiArICBTdGF0aXN0aWNzOg0KPiA+
ID4gKyAgICB0eF9wYXVzZV9mcmFtZXM6IDENCj4gPiA+ICsgICAgcnhfcGF1c2VfZnJhbWVzOiAx
DQo+ID4gPiArICANCj4gPiANCj4gPiB0aGlzIHdpbGwgcmVxdWlyZSB0byBhY2Nlc3MgdGhlIEhX
IHR3aWNlIHBlciBzdGF0cyByZXF1ZXN0IHRvIHJlYWQNCj4gPiBib3RoDQo+ID4gc3RhdHMgYW5k
IGN1cnJlbnQgcGFyYW1ldGVycywgbWF5YmUgdGhpcyBpcyBub3QgYSBiaWcgZGVhbCwgYnV0DQo+
ID4gc2hhcnANCj4gPiBhY2N1cmFjeSBjYW4gYmUgaW1wb3J0YW50IGZvciBzb21lIHBlcmZvcm1h
bmNlIGVudGh1c2lhc3RzLg0KPiA+IA0KPiA+IERvIHdlIG5lZWQgYW4gQVBJIHRoYXQgb25seSBy
ZXBvcnRzIHN0YXRpc3RpY3Mgd2l0aG91dCB0aGUgY3VycmVudA0KPiA+IHBhcmFtZXRlcnMgPw0K
PiANCj4gVGhhdCBjcm9zc2VkIG15IG1pbmQuIElESyBob3cgcmVhbCB0aGlzIGNvbmNlcm4gaXMg
aWYgd2UgaGF2ZSBldGh0b29sDQo+IC1TIHdoaWNoIGR1bXBzIGhhbGYgb2YgdGhlIHVuaXZlcnNl
IGFuZCBub2JvZHkgZXZlciBkb25lIGFueXRoaW5nDQo+IGFib3V0IGl0Li4NCj4gDQo+IE9uY2Ug
d2Ugc3RhcnQgYWRkaW5nIG1vcmUgaW50ZXJmYWNlcyAoYXMgSSBzYWlkIGVsc2V3aGVyZSBJIHBs
YW4gdG8NCj4gYWRkDQo+IEZFQyBjb3VudGVycykgd2UnbGwgYWxzbyBoYXZlIHRvIGRvIG11bHRp
cGxlIGNhbGxzIGZvciBtdWx0aXBsZSB0eXBlcw0KPiBvZiBzdGF0cy4gQnV0IEkgdGhpbmsgdGhh
dCdzIGZpbmUgYXMgYSBzdGFydGluZyBwb2ludC4gV2UgY2FuIGV4dGVuZA0KPiBSVE1fR0VUU1RB
VFMgdG8gcHJvdmlkZSBhbiBlZmZpY2llbnQgaW50ZXJmYWNlIHdoZW4gbmVlZGVkLg0KPiANCj4g
QXMgeW91IG1heSByZWNhbGwgYSBjb3VwbGUgeWVhcnMgYmFjayBJIHBvc3RlZCBhIHNldCB3aXRo
DQo+ICJoaWVyYXJjaGljYWwNCj4gc3RhdHMiIHdoaWNoIGFzIGFuIGF0dGVtcHQgdG8gc29sdmUg
YWxsIHRoZSBwcm9ibGVtcyBhdCBvbmNlLiANCj4gSSBjb25jbHVkZWQgdGhhdCBpdCdzIGEgd3Jv
bmcgYXBwcm9hY2guIFdlIHNob3VsZCBzdGFydCB3aXRoIHRoZQ0KPiBzaW1wbGUNCj4gYW5kIG9i
dmlvdXMgc3R1ZmYuIFdlIGNhbiBidWlsZCBjb21wbGV4aXR5IGxhdGVyLg0KDQpBZ3JlZWQuDQo=
