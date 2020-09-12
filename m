Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D52B267869
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 08:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgILG4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 02:56:20 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15576 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgILG4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 02:56:16 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5c71000001>; Fri, 11 Sep 2020 23:56:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 11 Sep 2020 23:56:13 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 11 Sep 2020 23:56:13 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 12 Sep
 2020 06:56:13 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 12 Sep 2020 06:56:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7IVd/l1Uvp0b6xBLEC3l3Y5hE7E4JFfol7JpJGn37qOf1fX3moHXeq1pv93R3CQGm8tmwqaEvv7DLkXgCLt/tGfGr512mu+8CyfNdH7ZwvjhATcyEu5KiiPIiaUXZBDdnfUXEyaRHy9FET/4/qyQlk0QNPJBm45ssdiig9HNk5/MSQmKUAOUsM4W4MEYGpzW+8wKcaRevki2R0X4PopEyeLVrt2ZGmnOTZSoy3SPtA2Tam0bi/6sAi6XxHcUD+Mq1imdaxmn4VOsZUssKbdAqT/mmwg6rN7oiBSJOwSS6PKGsvl6Ut+3gS+lPIT4oI3UNxIt4vHcDOzKXyyzSe4Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GeqizIBfMs2kbuJAan3v1RcJg9hufqPIrIO+h7JCQc=;
 b=U0P/trUiX1fhhbRMkr2B+CGD+SzwebYbW2Prbfz3unMaqCQLXLxRPV1DIDjQy1EjJd4IV8QRvmOwsqSULgUrxx8qL/dKmS7sIEIFmHOosBb/9z9FYT1L60O6cP077XyQ8SO1o2kaqlLDB/Ei0DewlArt/0++5+f/QQRHhkMgL+fOuYEmxeJ3orNdVS3/66l60G3DeqkngUJdI99oLJ4jq9wlgsNcKib175i5xQeRRdqBTG35fk4eUNOGAOo1hTgydOD+uEzBUMF41Ls/J9irbzk9oOLDEqYyPzUVO70y3v6+dFLZ/nyaX2GWERiO88YzD3XSrPr33NyQnGGhEnwDYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33)
 by BYAPR12MB2679.namprd12.prod.outlook.com (2603:10b6:a03:72::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Sat, 12 Sep
 2020 06:56:12 +0000
Received: from BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b]) by BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b%6]) with mapi id 15.20.3348.019; Sat, 12 Sep 2020
 06:56:12 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
Thread-Topic: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
Thread-Index: AQHWiJGYqt2ABPNtfE6Zj34+KHfdVqlkknWA
Date:   Sat, 12 Sep 2020 06:56:12 +0000
Message-ID: <ddfecf408d3d1b7e4af97cb3b1c1c63506e4218e.camel@nvidia.com>
References: <20200911231619.2876486-1-olteanv@gmail.com>
In-Reply-To: <20200911231619.2876486-1-olteanv@gmail.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5629240f-7f8c-4ca2-85f9-08d856e8ef9d
x-ms-traffictypediagnostic: BYAPR12MB2679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2679E0078E458A0A961761ADDF250@BYAPR12MB2679.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /cpZPMPw4ewXH2kSB6S3on5ENBgX+IYQIJlB3A18CCPsv5PBHj+XB3nMwUExwymLS37ZczcoEMeyimK26w496i9JBu/OkwLo3wkHaYka291pzU98rbZ3XZy13VOsQZkcYa/1tPp4lEM4t0B17zWrd5eOn5HDqzdL6zbBa8xIfchnqbre3HMwfkL18MiZDKIKQb/ffB0tcs90+3yQ9kkmrW3qNVdCMmoiM05Eycf4nPQVpJAuW2nEzRYIUohMRzUju6ifnJzcmg2taLy1kBA9N9J9cTPDZ7dcoP4BvJoy/NkQWvMwOtCsSJYo536caC1RzGX7KcwhFZambryy+hxjgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(71200400001)(316002)(4326008)(86362001)(6636002)(6506007)(2906002)(478600001)(110136005)(54906003)(6486002)(66556008)(66446008)(64756008)(66476007)(66946007)(186003)(26005)(2616005)(83380400001)(8676002)(5660300002)(6512007)(91956017)(76116006)(36756003)(3450700001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 6IDXkdkAiLOfI2iaK+DuqI/5CUgQARaK0iTLXCKtl3Q6Ky6ABLDzNaAYTz7kModb9fCK+XjWAnmT1ASk6B63KrJQ6bZBncTAVFlrwCzMwnqGhfxkVd6cc9vhpVdjhjkusC2pKCu0jbjrHzhi0o5CAdKCpzWCJZXh9/V74gN7S2PC45dZSVuW0siGQsECXfnjLFfKtC188KBjtL+S6KooEa6Ae7eyYEf9TUx0f036G6n5svrBBxGW2Wv32WWLIfRNk2h1vZ823yySSvg30n7eAxM2tyiZNtGeVBSURULhqjd9Lzz6KKPGkf32sK8nCK+RtgO0VKdPHkylQD8jpdc6zOMQQSnGgLhNGxYmAsDY9nJkxx+9TYMnrE6i9QHs8aOP7jhK5whkO6FoAhutS4mck+svwY/k2bENBFaMyHrvdrX0+Y+OLnoYc3TwaZCcOmsP311THHhlAox8EPTd6HJ6M26DYfVW3tzuSf67cHJ243xT6Ok2f+HMz9qP184c+Fl/zcRUmCBlG5led3fMCu4xXtPusOGxAws+TZijDFGQXHUPv1fFf3MLKm507np6E7D09auuHzJlZD+dCwVzd4DVimmeVfRtQeDeGs3aqIEBDE/MoSvLQLDTszKAxr52URxazi0BwInFGzBmJ0U2x7veOQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C6544650AC91A4C8C7418500374CFBF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5629240f-7f8c-4ca2-85f9-08d856e8ef9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 06:56:12.4844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DMOYVw8Th9quCFJCSkd0SyS80PGr3OZRHNYftOzFrlSf+f9+APS9fUB9aXgI7Ez76ESvSXUdX4Kbie4z2aHWtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2679
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599893760; bh=9GeqizIBfMs2kbuJAan3v1RcJg9hufqPIrIO+h7JCQc=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:user-agent:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
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
        b=Xgd0rf3YWaMshe2k+HJtPlc8L0mIDxAfXsqYB4lN7yflp1IseXhGWGAN46MwwKcLH
         rm3EePx0xlbwenyFD8VG6Bj54KioQU/dsRtwcpK59Rjk8IwxmCWdhms/YheCw01J24
         pL0hI0BboAXhjk8m33cf1c1rZ/z768Ohoo24Hdd93UvYJ7l8izUpLqs2asndqQEeOS
         kLqspCru6gqG8x7GKhwxAdM5MxG09xujqOEgrfZ4EHHXh8yCins12sSlx7+8XTYgKA
         +bAXJZIznZPeqKmSwmMr9yRpnveXil8CEECnKbve/IF3YdcKtooLKQkHHkCH0VnDh0
         BwLwXUVAuoQDg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIwLTA5LTEyIGF0IDAyOjE2ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEN1cnJlbnRseSB0aGUgYnJpZGdlIHVudGFncyBWTEFOcyBmcm9tIGl0cyBWTEFOIGdyb3Vw
IGluDQo+IF9fYWxsb3dlZF9pbmdyZXNzKCkgb25seSB3aGVuIFZMQU4gZmlsdGVyaW5nIGlzIGVu
YWJsZWQuDQo+IA0KPiBXaGVuIGluc3RhbGxpbmcgYSBwdmlkIGluIGVncmVzcy10YWdnZWQgbW9k
ZSwgRFNBIHN3aXRjaGVzIGhhdmUgYQ0KPiBwcm9ibGVtOg0KPiANCj4gaXAgbGluayBhZGQgZGV2
IGJyMCB0eXBlIGJyaWRnZSB2bGFuX2ZpbHRlcmluZyAwDQo+IGlwIGxpbmsgc2V0IHN3cDAgbWFz
dGVyIGJyMA0KPiBicmlkZ2UgdmxhbiBkZWwgZGV2IHN3cDAgdmlkIDENCj4gYnJpZGdlIHZsYW4g
YWRkIGRldiBzd3AwIHZpZCAxIHB2aWQNCj4gDQo+IFdoZW4gYWRkaW5nIGEgVkxBTiBvbiBhIERT
QSBzd2l0Y2ggaW50ZXJmYWNlLCBEU0EgY29uZmlndXJlcyB0aGUgVkxBTg0KPiBtZW1iZXJzaGlw
IG9mIHRoZSBDUFUgcG9ydCB1c2luZyB0aGUgc2FtZSBmbGFncyBhcyBzd3AwIChpbiB0aGlzIGNh
c2UNCj4gInB2aWQgYW5kIG5vdCB1bnRhZ2dlZCIpLCBpbiBhbiBhdHRlbXB0IHRvIGNvcHkgdGhl
IGZyYW1lIGFzLWlzIGZyb20NCj4gaW5ncmVzcyB0byB0aGUgQ1BVLg0KPiANCj4gSG93ZXZlciwg
aW4gdGhpcyBjYXNlLCB0aGUgcGFja2V0IG1heSBhcnJpdmUgdW50YWdnZWQgb24gaW5ncmVzcywg
aXQNCj4gd2lsbCBiZSBwdmlkLXRhZ2dlZCBieSB0aGUgaW5ncmVzcyBwb3J0LCBhbmQgd2lsbCBi
ZSBzZW50IGFzDQo+IGVncmVzcy10YWdnZWQgdG93YXJkcyB0aGUgQ1BVLiBPdGhlcndpc2Ugc3Rh
dGVkLCB0aGUgQ1BVIHdpbGwgc2VlIGEgVkxBTg0KPiB0YWcgd2hlcmUgdGhlcmUgd2FzIG5vbmUg
dG8gc3BlYWsgb2Ygb24gaW5ncmVzcy4NCj4gDQo+IFdoZW4gdmxhbl9maWx0ZXJpbmcgaXMgMSwg
dGhpcyBpcyBub3QgYSBwcm9ibGVtLCBhcyBzdGF0ZWQgaW4gdGhlIGZpcnN0DQo+IHBhcmFncmFw
aCwgYmVjYXVzZSBfX2FsbG93ZWRfaW5ncmVzcygpIHdpbGwgcG9wIGl0LiBCdXQgY3VycmVudGx5
LCB3aGVuDQo+IHZsYW5fZmlsdGVyaW5nIGlzIDAgYW5kIHdlIGhhdmUgc3VjaCBhIFZMQU4gY29u
ZmlndXJhdGlvbiwgd2UgbmVlZCBhbg0KPiA4MDIxcSB1cHBlciAoYnIwLjEpIHRvIGJlIGFibGUg
dG8gcGluZyBvdmVyIHRoYXQgVkxBTi4NCj4gDQo+IE1ha2UgdGhlIDIgY2FzZXMgKHZsYW5fZmls
dGVyaW5nIDAgYW5kIDEpIGJlaGF2ZSB0aGUgc2FtZSB3YXkgYnkgcG9wcGluZw0KPiB0aGUgcHZp
ZCwgaWYgdGhlIHNrYiBoYXBwZW5zIHRvIGJlIHRhZ2dlZCB3aXRoIGl0LCB3aGVuIHZsYW5fZmls
dGVyaW5nDQo+IGlzIDAuDQo+IA0KPiBUaGVyZSB3YXMgYW4gYXR0ZW1wdCB0byByZXNvbHZlIHRo
aXMgaXNzdWUgbG9jYWxseSB3aXRoaW4gdGhlIERTQQ0KPiByZWNlaXZlIGRhdGEgcGF0aCwgYnV0
IGV2ZW4gdGhvdWdoIHdlIGNhbiBkZXRlcm1pbmUgdGhhdCB3ZSBhcmUgdW5kZXIgYQ0KPiBicmlk
Z2Ugd2l0aCB2bGFuX2ZpbHRlcmluZz0wLCB0aGVyZSBhcmUgc3RpbGwgc29tZSBjaGFsbGVuZ2Vz
Og0KPiAtIHdlIGNhbm5vdCBiZSBjZXJ0YWluIHRoYXQgdGhlIHNrYiB3aWxsIGVuZCB1cCBpbiB0
aGUgc29mdHdhcmUgYnJpZGdlJ3MNCj4gICBkYXRhIHBhdGgsIGFuZCBmb3IgdGhhdCByZWFzb24s
IHdlIG1heSBiZSBwb3BwaW5nIHRoZSBWTEFOIGZvcg0KPiAgIG5vdGhpbmcuIEV4YW1wbGU6IHRo
ZXJlIG1pZ2h0IGV4aXN0IGFuIDgwMjFxIHVwcGVyIHdpdGggdGhlIHNhbWUgVkxBTiwNCj4gICBv
ciB0aGlzIGludGVyZmFjZSBtaWdodCBiZSBhIERTQSBtYXN0ZXIgZm9yIGFub3RoZXIgc3dpdGNo
LiBJbiB0aGF0DQo+ICAgY2FzZSwgdGhlIFZMQU4gc2hvdWxkIGRlZmluaXRlbHkgbm90IGJlIHBv
cHBlZCBldmVuIGlmIGl0IGlzIGVxdWFsIHRvDQo+ICAgdGhlIGRlZmF1bHRfcHZpZCBvZiB0aGUg
YnJpZGdlLCBiZWNhdXNlIGl0IHdpbGwgYmUgY29uc3VtZWQgYWJvdXQgdGhlDQo+ICAgRFNBIGxh
eWVyIGJlbG93Lg0KDQpDb3VsZCB5b3UgcG9pbnQgbWUgdG8gYSB0aHJlYWQgd2hlcmUgdGhlc2Ug
cHJvYmxlbXMgd2VyZSBkaXNjdXNzZWQgYW5kIHdoeQ0KdGhleSBjb3VsZG4ndCBiZSByZXNvbHZl
ZCB3aXRoaW4gRFNBIGluIGRldGFpbCA/DQoNCj4gLSB0aGUgYnJpZGdlIEFQSSBvbmx5IG9mZmVy
cyBhIHJhY2UtZnJlZSBBUEkgZm9yIGRldGVybWluaW5nIHRoZSBwdmlkIG9mDQo+ICAgYSBwb3J0
LCBicl92bGFuX2dldF9wdmlkKCksIHVuZGVyIFJUTkwuDQo+IA0KDQpUaGUgQVBJIGNhbiBiZSBl
YXNpbHkgZXh0ZW5kZWQuDQoNCj4gQW5kIGluIGZhY3QgdGhpcyBtaWdodCBub3QgZXZlbiBiZSBh
IHNpdHVhdGlvbiB1bmlxdWUgdG8gRFNBLiBBbnkgZHJpdmVyDQo+IHRoYXQgcmVjZWl2ZXMgdW50
YWdnZWQgZnJhbWVzIGFzIHB2aWQtdGFnZ2VkIGlzIG5vdyBhYmxlIHRvIGNvbW11bmljYXRlDQo+
IHdpdGhvdXQgbmVlZGluZyBhbiA4MDIxcSB1cHBlciBmb3IgdGhlIHB2aWQuDQo+IA0KDQpJIHdv
dWxkIHByZWZlciB3ZSBkb24ndCBhZGQgaGFyZHdhcmUvZHJpdmVyLXNwZWNpZmljIGZpeGVzIGlu
IHRoZSBicmlkZ2UsIHdoZW4NCnZsYW4gZmlsdGVyaW5nIGlzIGRpc2FibGVkIHRoZXJlIHNob3Vs
ZCBiZSBubyB2bGFuIG1hbmlwdWxhdGlvbi9maWx0ZXJpbmcgZG9uZQ0KYnkgdGhlIGJyaWRnZS4g
VGhpcyBjb3VsZCBwb3RlbnRpYWxseSBicmVhayB1c2VycyB3aG8gaGF2ZSBhZGRlZCA4MDIxcSBk
ZXZpY2VzDQphcyBicmlkZ2UgcG9ydHMuIEF0IHRoZSB2ZXJ5IGxlYXN0IHRoaXMgbmVlZHMgdG8g
YmUgaGlkZGVuIGJlaGluZCBhIG5ldyBvcHRpb24sDQpidXQgSSB3b3VsZCBsaWtlIHRvIGZpbmQg
YSB3YXkgdG8gYWN0dWFsbHkgcHVzaCBpdCBiYWNrIHRvIERTQS4gQnV0IGFnYWluIGFkZGluZw0K
aGFyZHdhcmUvZHJpdmVyLXNwZWNpZmljIG9wdGlvbnMgc2hvdWxkIGJlIGF2b2lkZWQuDQoNCkNh
biB5b3UgdXNlIHRjIHRvIHBvcCB0aGUgdmxhbiBvbiBpbmdyZXNzID8gSSBtZWFuIHRoZSBjYXNl
cyBhYm92ZSBhcmUgdmlzaWJsZQ0KdG8gdGhlIHVzZXIsIHNvIHRoZXkgbWlnaHQgZGVjaWRlIHRv
IGFkZCB0aGUgaW5ncmVzcyB2bGFuIHJ1bGUuDQoNClRoYW5rcywNCiBOaWsNCg0KPiBTaWduZWQt
b2ZmLWJ5OiBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZAZ21haWwuY29tPg0KPiBUZXN0ZWQtYnk6
IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiAtLS0NCj4gIG5ldC9i
cmlkZ2UvYnJfdmxhbi5jIHwgMTYgKysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQs
IDE2IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvYnJpZGdlL2JyX3ZsYW4u
YyBiL25ldC9icmlkZ2UvYnJfdmxhbi5jDQo+IGluZGV4IGQyYjg3MzdmOWZjMC4uZWNmZGI5Y2Qz
MTgzIDEwMDY0NA0KPiAtLS0gYS9uZXQvYnJpZGdlL2JyX3ZsYW4uYw0KPiArKysgYi9uZXQvYnJp
ZGdlL2JyX3ZsYW4uYw0KPiBAQCAtNTgwLDcgKzU4MCwyMyBAQCBib29sIGJyX2FsbG93ZWRfaW5n
cmVzcyhjb25zdCBzdHJ1Y3QgbmV0X2JyaWRnZSAqYnIsDQo+ICAJICogcGVybWl0dGVkLg0KPiAg
CSAqLw0KPiAgCWlmICghYnJfb3B0X2dldChiciwgQlJPUFRfVkxBTl9FTkFCTEVEKSkgew0KPiAr
CQl1MTYgdjsNCj4gKw0KPiAgCQlCUl9JTlBVVF9TS0JfQ0Ioc2tiKS0+dmxhbl9maWx0ZXJlZCA9
IGZhbHNlOw0KPiArDQo+ICsJCS8qIFNlZSBjb21tZW50IGluIF9fYWxsb3dlZF9pbmdyZXNzIGFi
b3V0IGhvdyBza2IgY2FuIGVuZCB1cA0KPiArCQkgKiBoZXJlIG5vdCBoYXZpbmcgYSBod2FjY2Vs
IHRhZw0KPiArCQkgKi8NCj4gKwkJaWYgKHVubGlrZWx5KCFza2Jfdmxhbl90YWdfcHJlc2VudChz
a2IpICYmDQo+ICsJCQkgICAgIHNrYi0+cHJvdG9jb2wgPT0gYnItPnZsYW5fcHJvdG8pKSB7DQo+
ICsJCQlza2IgPSBza2Jfdmxhbl91bnRhZyhza2IpOw0KPiArCQkJaWYgKHVubGlrZWx5KCFza2Ip
KQ0KPiArCQkJCXJldHVybiBmYWxzZTsNCj4gKwkJfQ0KPiArDQo+ICsJCWlmICghYnJfdmxhbl9n
ZXRfdGFnKHNrYiwgJnYpICYmIHYgPT0gYnJfZ2V0X3B2aWQodmcpKQ0KPiArCQkJX192bGFuX2h3
YWNjZWxfY2xlYXJfdGFnKHNrYik7DQo+ICsNCj4gIAkJcmV0dXJuIHRydWU7DQo+ICAJfQ0KPiAg
DQoNCg==
