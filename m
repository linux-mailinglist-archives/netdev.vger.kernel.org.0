Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2722A26FCB8
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgIRMkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:40:06 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15608 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgIRMkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:40:05 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 08:40:05 EDT
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64a94c0003>; Fri, 18 Sep 2020 05:34:20 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 12:35:04 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 12:35:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCog3zAabHstKVsiH2pL5H5CeAWyG3PlrDLfs/4zIINisPXfFAopI9n0vI6Xo7w8A6qWeaL8BV1+CaQmhKh2etvpyAt7MdSiQJuPfUQDiXBuPk+hKOaZxVfyF+0hWy6mBfVXjrAnsYPjzpIczbbdrvbiqSmboypmDfQk2Y/iCvCgNrMkKgdqPrWQorMeWXS8AzLIfeyd7IcgeHXoXDO9LTU/qe493wSu3k7o7VAfUCr/NnPDeUyR42caFw1xZzvYvXJQYGr7pNw0vFIS5bvy9hUslUHg1ZbwaEhi4Cp03oF+w6DFbglo+N4D8EzKbwvb1auYk5+If3KOzdQorb2t9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/jBSanyBxK7bWX+OVxK3fSFXORvSxaNGGv7E5spujQ=;
 b=kI+bVZGxjahsliGyvnLoQso9aKC7QJNBBw17Y8Y8AwHVNg6mwI3GzwARjfcXKh3ZeG6ohC7j1207nxGaWMqXDWkcMUbak58fz8BV6965lDoMQvpjfuVc0awATPOKeLTPTw865lc9/vO07vIHCVdQDfTsdUuRv0USwffhgkE2wjd+LRAOqENLYYtSc4BOoy1giIyQ10diL9CJvFNqfAubQcXTrXm+Lxt0UIdJLGVNOz5KokoZrAk5Dfc/N35H8+W5w41nESPlRXDlFRjact8V51laOt7eWQWEEbTnKNmYDJuiy1cYNmy+yCCf6kPrNqysL9u5QmH9y01BR6g1F2P/Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33)
 by BY5PR12MB5000.namprd12.prod.outlook.com (2603:10b6:a03:1d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Fri, 18 Sep
 2020 12:35:03 +0000
Received: from BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b]) by BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b%6]) with mapi id 15.20.3348.019; Fri, 18 Sep 2020
 12:35:03 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yoshihiro.shimoda.uh@renesas.com" <yoshihiro.shimoda.uh@renesas.com>,
        "gaku.inami.xh@renesas.com" <gaku.inami.xh@renesas.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
Thread-Topic: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
Thread-Index: AQHWgHD7uYKKA6Pj+E6rHgG5PdDifaliTgaAgAC724CAATDYAIAAxl6AgADaHICAAfh5AIAGm7KA
Date:   Fri, 18 Sep 2020 12:35:02 +0000
Message-ID: <9ab2973de2c0fb32de7fbc4ae823a820cd48a769.camel@nvidia.com>
References: <CAMuHMdUd4VtpOGr26KAmF22N32obNqQzq3tbcPxLJ7mxUtSyrg@mail.gmail.com>
         <20200911.174400.306709791543819081.davem@davemloft.net>
         <CAMuHMdW0agywTHr4bDO9f_xbQibCxDykdkcAmuRJQO90=E6-Zw@mail.gmail.com>
         <20200912.183437.1205152743307947529.davem@davemloft.net>
         <CAMuHMdXGmKYKWtkFCV0WmYnY4Gn--Bbz-iSX76oc-UNNrzCMuw@mail.gmail.com>
In-Reply-To: <CAMuHMdXGmKYKWtkFCV0WmYnY4Gn--Bbz-iSX76oc-UNNrzCMuw@mail.gmail.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe2769f3-409b-4555-75e6-08d85bcf4412
x-ms-traffictypediagnostic: BY5PR12MB5000:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB50005998B40F230512BDD3E7DF3F0@BY5PR12MB5000.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xfeqFNTS98ykYw47FARkL9sWaB+ipIR5HTgUPeMSTWVBqwWxrSzUsGkGu7HCWmNn2+MCyUCIKGqUMrKKnR6q8WN8jzDAAyaArJ5mU47BFl8b0l0WH4xtI2eGXEl2NBTh4Q/tMFuaEbCHHdHLlVLup9M27h+9k6p7W0w49BLZew8Jxt/OAE0Cren6UrIDU2Rq9S8jNzZn146B0ervamn66r01hfe2E43uRa9RC30tzozGahQhUaAqgeuWBwzzXAgLqVdaq61nSd5Fs4lEWsyMkzINRNmAQql1YPzC0sNIzQ4wNLAgcgrOTipKv5Jb1joyhybj6/Jjz7FJ928ad2IXGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(83380400001)(8676002)(26005)(2906002)(91956017)(5660300002)(86362001)(6506007)(53546011)(2616005)(3450700001)(6512007)(110136005)(54906003)(478600001)(7416002)(76116006)(64756008)(316002)(66556008)(66946007)(6486002)(66476007)(71200400001)(66446008)(36756003)(4326008)(8936002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Wg+Kr9z5nm31i0KyZRFnPMkq+c/b9Attiu+4yryzb/5Uq519NtY0TBeLaBvwwkS7w/Kt+jnciMCj1zPaN+JcZsy3NNZ1SeSe3bd/cKkFxoJL75rLMvGAVkZfsmtLNGajKuJ/EO6R7GEG/xeXb4BeAlqEHyGmjKV/jxEtSkqDAtG4JjcaVPep+IdkpYJ7ru4Nx5ChMLEOhLwNiPzqzJEmXxVsFYr1GIJAJkN3xWM0vkgf/SHt2tKeNPpX5j0ewHDvmf1UD6q9UHuWCVm9yD1R36DMJK7Petwz/o5dbPfZt2jBNrPP8Rdf658mjj3h8OnclM08dfOfvAc57Y/wW4pT3D2K7PvaPWOoFXoCVUVJmWMQlkxXOctVGcaGU9nE9661KSjuhkPEPKzuMrcHfkBK2g5yuLlfSbsFtznD7ITs3cX7UTT6R7Y1giHIo7aT6Xjp7yxsFj4Lp0vhh+f+W5ld7hzGsgkS4qAu6vu1wyfYsiHD04/xPqTFDwBqmxEpuQs17hLfpDNT5QAfxpWaycYmQdV26ARZpBcp08v3P9oh1OELm7GwQW+qnUJO8DJsYsLZGtmO2VuMmfIEeuXoEvHVcIKR9UGeee2d9aB0pKCMlxUZs9Xvef+jmCSSt+yjHMWJQmYjjO0xz542p5lYpqIpIw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDB2C3060B5F194BAC4EBCCF6887BA0B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2769f3-409b-4555-75e6-08d85bcf4412
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 12:35:03.0074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D1ASfgjIao8UgajTvDZnEsUYDhq8rCDVSQd8GnjxCny4kDnvl13+Cu1uleaVatA1rm8Z4seva6B5YJQserNPYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5000
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600432460; bh=h/jBSanyBxK7bWX+OVxK3fSFXORvSxaNGGv7E5spujQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Reply-To:Accept-Language:Content-Language:
         X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=hVMFh6DHP3wQLOMdt+RxyWfUrzhB8uVhYJcUa/wb1Hp6vX+38mVLJhm7jFo2Utlo+
         pEebdoEv/YhiRfdrtM27eTkiiMO7C2KdjWFN6wHZN+tZTn0lv30Q8WxmyLW84CDevA
         ad7dnAynbxC40k2ZhXfSC4a4/xKNu5H/nemRbnRUxjC5jUc5+LL5kcF/gc2WEj9D4Z
         GjTkf2YUUl7BFFeGNtihP3ybBnIERouXBMi8jtSr+jvy7D3nc7L78BdmSMfqk+P0io
         ppReEwb/K9bRl/GXkvWCLVLQrUjRQhOinIB31SN0qOnpZ1YC5k6CDYv+JZKLVGLb1Y
         hQhdly5Z9ToGw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA5LTE0IGF0IDA5OjQwICswMjAwLCBHZWVydCBVeXR0ZXJob2V2ZW4gd3Jv
dGU6DQo+IEhpIERhdmlkLA0KPiANCj4gQ0MgYnJpZGdlDQo+IA0KPiBPbiBTdW4sIFNlcCAxMywg
MjAyMCBhdCAzOjM0IEFNIERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4gd3JvdGU6
DQo+ID4gRnJvbTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydEBsaW51eC1tNjhrLm9yZz4NCj4g
PiBEYXRlOiBTYXQsIDEyIFNlcCAyMDIwIDE0OjMzOjU5ICswMjAwDQo+ID4gDQo+ID4gPiAiZGV2
IiBpcyBub3QgdGhlIGJyaWRnZSBkZXZpY2UsIGJ1dCB0aGUgcGh5c2ljYWwgRXRoZXJuZXQgaW50
ZXJmYWNlLCB3aGljaA0KPiA+ID4gbWF5IGFscmVhZHkgYmUgc3VzcGVuZGVkIGR1cmluZyBzMnJh
bS4NCj4gPiANCj4gPiBIbW1tLCBvay4NCj4gPiANCj4gPiBMb29raW5nIG1vcmUgZGVlcGx5IE5F
VERFVl9DSEFOR0UgY2F1c2VzIGJyX3BvcnRfY2Fycmllcl9jaGVjaygpIHRvIHJ1biB3aGljaA0K
PiA+IGV4aXRzIGVhcmx5IGlmIG5ldGlmX3J1bm5pbmcoKSBpcyBmYWxzZSwgd2hpY2ggaXMgZ29p
bmcgdG8gYmUgdHJ1ZSBpZg0KPiA+IG5ldGlmX2RldmljZV9wcmVzZW50KCkgaXMgZmFsc2U6DQo+
ID4gDQo+ID4gICAgICAgICAqbm90aWZpZWQgPSBmYWxzZTsNCj4gPiAgICAgICAgIGlmICghbmV0
aWZfcnVubmluZyhici0+ZGV2KSkNCj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+IA0K
PiA+IFRoZSBvbmx5IG90aGVyIHdvcmsgdGhlIGJyaWRnZSBub3RpZmllciBkb2VzIGlzOg0KPiA+
IA0KPiA+ICAgICAgICAgaWYgKGV2ZW50ICE9IE5FVERFVl9VTlJFR0lTVEVSKQ0KPiA+ICAgICAg
ICAgICAgICAgICBicl92bGFuX3BvcnRfZXZlbnQocCwgZXZlbnQpOw0KPiA+IA0KPiA+IGFuZDoN
Cj4gPiANCj4gPiAgICAgICAgIC8qIEV2ZW50cyB0aGF0IG1heSBjYXVzZSBzcGFubmluZyB0cmVl
IHRvIHJlZnJlc2ggKi8NCj4gPiAgICAgICAgIGlmICghbm90aWZpZWQgJiYgKGV2ZW50ID09IE5F
VERFVl9DSEFOR0VBRERSIHx8IGV2ZW50ID09IE5FVERFVl9VUCB8fA0KPiA+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgZXZlbnQgPT0gTkVUREVWX0NIQU5HRSB8fCBldmVudCA9PSBORVRERVZf
RE9XTikpDQo+ID4gICAgICAgICAgICAgICAgIGJyX2lmaW5mb19ub3RpZnkoUlRNX05FV0xJTkss
IE5VTEwsIHApOw0KPiA+IA0KPiA+IFNvIHNvbWUgdmxhbiBzdHVmZiwgYW5kIGVtaXR0aW5nIGEg
bmV0bGluayBtZXNzYWdlIHRvIGFueSBhdmFpbGFibGUNCj4gPiBsaXN0ZW5lcnMuDQo+ID4gDQo+
ID4gU2hvdWxkIHdlIHJlYWxseSBkbyBhbGwgb2YgdGhpcyBmb3IgYSBkZXZpY2Ugd2hpY2ggaXMg
bm90IGV2ZW4NCj4gPiBwcmVzZW50Pw0KPiA+IA0KPiA+IFRoaXMgd2hvbGUgc2l0dWF0aW9uIHNl
ZW1zIGNvbXBsZXRlbHkgaWxsb2dpY2FsLiAgVGhlIGRldmljZSBpcw0KPiA+IHVzZWxlc3MsIGl0
IGxvZ2ljYWxseSBoYXMgbm8gbGluayBvciBvdGhlciBzdGF0ZSB0aGF0IGNhbiBiZSBtYW5hZ2Vk
DQo+ID4gb3IgdXNlZCwgd2hpbGUgaXQgaXMgbm90IHByZXNlbnQuDQo+ID4gDQo+ID4gU28gYWxs
IG9mIHRoZXNlIGJyaWRnZSBvcGVyYXRpb25zIHNob3VsZCBvbmx5IGhhcHBlbiB3aGVuIHRoZSBk
ZXZpY2UNCj4gPiB0cmFuc2l0aW9ucyBiYWNrIHRvIHByZXNlbnQgYWdhaW4uDQo+IA0KPiBUaGFu
a3MgZm9yIHlvdXIgYW5hbHlzaXMhDQo+IEknZCBsaWtlIHRvIGRlZmVyIHRoaXMgdG8gdGhlIGJy
aWRnZSBwZW9wbGUgKENDKS4NCj4gDQo+IEdye29ldGplLGVldGluZ31zLA0KPiANCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgR2VlcnQNCj4gDQoNCkhpLA0KU29ycnkgZm9yIHRoZSBkZWxheS4g
SW50ZXJlc3RpbmcgcHJvYmxlbS4gOikNClRoYW5rcyBmb3IgdGhlIGFuYWx5c2lzLCBJIGRvbid0
IHNlZSBhbnkgaXNzdWVzIHdpdGggY2hlY2tpbmcgaWYgdGhlIGRldmljZQ0KaXNuJ3QgcHJlc2Vu
dC4gSXQgd2lsbCBoYXZlIHRvIGdvIHRocm91Z2ggc29tZSB0ZXN0aW5nLCBidXQgbm8gb2J2aW91
cw0Kb2JqZWN0aW9ucy9pc3N1ZXMuIEhhdmUgeW91IHRyaWVkIGlmIGl0IGZpeGVzIHlvdXIgY2Fz
ZT8NCkkgaGF2ZSBicmllZmx5IGdvbmUgb3ZlciBkcml2ZXJzJyB1c2Ugb2YgbmV0X2RldmljZV9k
ZXRhY2goKSwgbW9zdGx5IGl0J3MgdXNlZA0KZm9yIHN1c3BlbmRzLCBidXQgdGhlcmUgYXJlIGEg
ZmV3IGNhc2VzIHdoaWNoIHVzZSBpdCBvbiBJTyBlcnJvciBvciB3aGVuIGENCmRldmljZSBpcyBh
Y3R1YWxseSBkZXRhY2hpbmcgKFZGIGRldGFjaCkuIFRoZSB2bGFuIHBvcnQgZXZlbnQgaXMgZm9y
IHZsYW4NCmRldmljZXMgb24gdG9wIG9mIHRoZSBicmlkZ2Ugd2hlbiBCUk9QVF9WTEFOX0JSSURH
RV9CSU5ESU5HIGlzIGVuYWJsZWQgYW5kIHRoZWlyDQpjYXJyaWVyIGlzIGNoYW5nZWQgYmFzZWQg
b24gdmxhbiBwYXJ0aWNpcGF0aW5nIHBvcnRzJyBzdGF0ZS4NCg0KVGhhbmtzLA0KIE5paw0KDQo=
