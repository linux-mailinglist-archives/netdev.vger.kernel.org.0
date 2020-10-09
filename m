Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5C8289B1B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391846AbgJIVlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:41:05 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:8604 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388979AbgJIVlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 17:41:04 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80d8ed0000>; Sat, 10 Oct 2020 05:41:01 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 21:41:00 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 21:41:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtjWRZPGXV3lGr2x/NRRkFGzl7gCD1FgCcKokV13EHJr+MvdcBgq1eR/+eoiOtZVsnJm/h42pNho1CcQsBi1VlDkKidev6d4cCuaAygLZ6+CLyD1yLUExyoWaNIj4+1CeqxYm+w0cYbEYv252yNOHn8qT4BYnDs8K2ShyZfRYlFCddEIDl2GaioHNVuFDJ3eFxwUGPmyKkczKVfG5lpFVMAicX5OvW5kpQTKCZXDNT4Pauam2SNBv2W7JO8WXQSH62i27zmx4keDiVTHBVT4uBF6v3wyZEFhnYkJALwWX4SMqvHAIexrYKG1kfFwJKb2exsYEutFHmdh0WKTi44qjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3E1LNrWQWMIMe35AcnNuZxp3VOmMxAv0w110Aq7aS4U=;
 b=fuj7SQ7kBWdmRLWI8AEkbV/4w9lIxsbgApnYkteILktyitg/sSf0YQrs2lK3fmj4G9NRR38rv1t3LMLqlwySEEMKw+KEvcBnzhbHfKDW4WDZ2/g3zoBq2SXllXYrvAIaPFZqCG3kosmp5uSWCbrASx4RpqyLkYTZWYfi0UaaYD2EeXcNi60zr8f+KtfzWcliVS44l5hwfvDWpvot1IZMtIIvyNlmk2vi5PJinPt7TWFn4hrDypCrS2/qpnldNqw1vp60UchJtL7g7crAbqMUUxce9vCUutYdeQ4Df/gFBUjTtmIjvM1TGrGnu7Pbffz9SCkoXkHyL4wqH0+tF62qgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3897.namprd12.prod.outlook.com (2603:10b6:5:1ca::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.26; Fri, 9 Oct
 2020 21:40:58 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.027; Fri, 9 Oct 2020
 21:40:58 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
CC:     "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v4 01/10] net: bridge: extend the process of
 special frames
Thread-Topic: [PATCH net-next v4 01/10] net: bridge: extend the process of
 special frames
Thread-Index: AQHWnknUyv0axoQ8Ok62KdiGISiNnKmPzSqA
Date:   Fri, 9 Oct 2020 21:40:58 +0000
Message-ID: <e4d70e3fc4a653ebc08d938dad8eb68819d696ca.camel@nvidia.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
         <20201009143530.2438738-2-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201009143530.2438738-2-henrik.bjoernlund@microchip.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e99c46d-98d5-4cd5-ba17-08d86c9c0259
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3897D58BA58BF76B81A4CAD7DF080@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rcLSj0XVRuq96zilTRPWJLBRkr/eEFMwwchhsnrxM7Xm0SRPmghpjRyHX8za86xCHFYyhR8MV33oWuCe/n89/sYT4ECBeg02hgSDbwxijuFuEB0gDrHn6NcUJ65yzY7SC6EpQrs1NkIfEJH5aNqQSYSPhYnM3XpsrfZ8IuWoyxfNPfwshYtW0jnvTQnxAvklQ9Q3wkmygslj3MNc8WsrM92koGkI5GFM9EKWqWuXKaHhTBifiLJVxOVkMmZRSHifY7oKeU2zvHMpWunm+X23IvXN23vuAZRhq93EJY4ikpqO0qJNmrPkqRYPtFSWrn0bsnmz0SkE38+GltKBGjxB9SYQ2FCiFGByymJyuWcVOenLKBXkfXwpUCQA823Uogmo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(478600001)(2906002)(66946007)(83380400001)(71200400001)(8676002)(8936002)(3450700001)(316002)(5660300002)(4326008)(2616005)(110136005)(6512007)(36756003)(6486002)(66476007)(66556008)(186003)(91956017)(76116006)(64756008)(6506007)(86362001)(66446008)(26005)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: uGSsrZ12Csoc7GLYjIqCxdLZF3gpR1Pcv/hNoavSsLtTw430LPb41ebmOVhxvLM/8FVeMrlWWCqnkmzQx4IE+Fd/qvFm4kf4hitTFm1ysWhhyXBRzdigL+/c0Sp9VPWYldAqnaGxO5nc7frCFz9iIXGFbgsm5pK6VaMo/4WaZ9pG4bClHdzdHBScsrFsdDgJIvEkm6tLJkJBTtEfmioPfpMN6/Iwe23P0dXs8NAVV/LjdYHLXRGBRXxcoe0ES5pcMu8sEnQN4r6AaeGkFlUEEbDyg68mnO49hfuLOwzjyciOWf09htaWcQqC0n8+Lb4783dlmHN9HUbgtqsMaUTycpz2A4HOghvqOJjAxe2tqSRptuAkU8aPnPvFs+WJPvDRMw4WlczlLjdtjgexjf0XKO/p8DXeTSVw7B65F+hLjmnyIEtrpHMSXjDfB4AGl8H1TRYtlK1Oe10PUZWI1Nyky8mx9+vTx1Rm+SUZ70+Subcpk1XFhbGe3yxvUo0JzmlYlX5xFH7SubgdgfscTPgm4IQA8DuMLDVkpugUuwyz2sQe0+sWsH9UKyTAJow7FcZe9Al2li5If0z2fbCYdgtggPrqQKTZ+3DCKo67aoefz/bKOWttIAkD3eAogkHy8IVg5cz7gRX/JkkkZlpdNsMpbQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <165F5A56EB34BB4C9B05C7C366BF7DF2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e99c46d-98d5-4cd5-ba17-08d86c9c0259
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 21:40:58.1518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0CCylENB6VIn6u4CA/llNZSe3VX+474SCjvtcK42rY7WYiJ+gXrEuHk8kEGjfPuImEzvh3TbZ1FcZHTyYVEIPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602279661; bh=3E1LNrWQWMIMe35AcnNuZxp3VOmMxAv0w110Aq7aS4U=;
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
        b=LAy7iBuZBTJlfjVY7pq3+8a4e44FpiegqRXytgcYHsKkCvyReI+ZXyKncXLlKSgeE
         nrr0jAfFeiXpZ5EDWvRQXHazti4/8HSbdMnDcD2NLL/VS6J50YJ04Rajmc+6otAl5T
         OnuXV9ZK1IS8u80j+oPeqiofGmqMO7fAgcbrGnr0Zv6BpGOZOvsRzzQQ8LuB5ol3ir
         g3w2OTWXTBkeZ2g1cGcHN8Pq1+vRHTV/x/AZxI2BgskxynWcMJA0VtUEtVmkxUFmpt
         13BQ+FFwQIu0pNeAK/QDzcXfdRFvJDP5xLq2l6CYS6XQXoRmBqoWOzJp7Vpv3Yq9V+
         pJjmMw8vzbmmw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE0OjM1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBwYXRjaCBleHRlbmRzIHRoZSBwcm9jZXNzaW5nIG9mIGZyYW1lcyBpbiB0aGUg
YnJpZGdlLiBDdXJyZW50bHkgTVJQDQo+IGZyYW1lcyBuZWVkcyBzcGVjaWFsIHByb2Nlc3Npbmcg
YW5kIHRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIGRvZXNuJ3QNCj4gYWxsb3cgYSBuaWNlIHdh
eSB0byBwcm9jZXNzIGRpZmZlcmVudCBmcmFtZSB0eXBlcy4gVGhlcmVmb3JlIHRyeSB0bw0KPiBp
bXByb3ZlIHRoaXMgYnkgYWRkaW5nIGEgbGlzdCB0aGF0IGNvbnRhaW5zIGZyYW1lIHR5cGVzIHRo
YXQgbmVlZA0KPiBzcGVjaWFsIHByb2Nlc3NpbmcuIFRoaXMgbGlzdCBpcyBpdGVyYXRlZCBmb3Ig
ZWFjaCBpbnB1dCBmcmFtZSBhbmQgaWYNCj4gdGhlcmUgaXMgYSBtYXRjaCBiYXNlZCBvbiBmcmFt
ZSB0eXBlIHRoZW4gdGhlc2UgZnVuY3Rpb25zIHdpbGwgYmUgY2FsbGVkDQo+IGFuZCBkZWNpZGUg
d2hhdCB0byBkbyB3aXRoIHRoZSBmcmFtZS4gSXQgY2FuIHByb2Nlc3MgdGhlIGZyYW1lIHRoZW4g
dGhlDQo+IGJyaWRnZSBkb2Vzbid0IG5lZWQgdG8gZG8gYW55dGhpbmcgb3IgZG9uJ3QgcHJvY2Vz
cyBzbyB0aGVuIHRoZSBicmlkZ2UNCj4gd2lsbCBkbyBub3JtYWwgZm9yd2FyZGluZy4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IEhlbnJpayBCam9lcm5sdW5kICA8aGVucmlrLmJqb2Vybmx1bmRAbWlj
cm9jaGlwLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEhvcmF0aXUgVnVsdHVyICA8aG9yYXRpdS52dWx0
dXJAbWljcm9jaGlwLmNvbT4NCj4gLS0tDQo+ICBuZXQvYnJpZGdlL2JyX2RldmljZS5jICB8ICAx
ICsNCj4gIG5ldC9icmlkZ2UvYnJfaW5wdXQuYyAgIHwgMzMgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKystDQo+ICBuZXQvYnJpZGdlL2JyX21ycC5jICAgICB8IDE5ICsrKysrKysrKysr
KysrKy0tLS0NCj4gIG5ldC9icmlkZ2UvYnJfcHJpdmF0ZS5oIHwgMTggKysrKysrKysrKysrLS0t
LS0tDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDYwIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygt
KQ0KPiANCg0KQWNrZWQtYnk6IE5pa29sYXkgQWxla3NhbmRyb3YgPG5pa29sYXlAbnZpZGlhLmNv
bT4NCg==
