Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC7F28B13C
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 11:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgJLJMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 05:12:36 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:9320 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbgJLJMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 05:12:34 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f841e000000>; Mon, 12 Oct 2020 17:12:32 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 09:12:32 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 12 Oct 2020 09:12:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DD+4OQ6s4qewd35JLXmuI+lSpeGVfQb9VFyn0Y3zu+o0TkJ/vWe9XyV+tR0cZB1wYh4EWIbCPCJVX18YV1V0IhOf27BTfEEhuxtQgOQTH89AMv5hyVeNmRIAbrSuMV+Cx0Lufrj85IE9V1EOwvaV3jcPjI9xeydVIgitXZ72Y1byTfzHfaij/GnEHvOcCeIprzW2nGQCT46G+E2FLTt4JcEYY1gVz/Vxkz54D8P1Wb1hIA+PoAEP+tXrNnczOPdDK+t1rGCjlPM75LjPAYla/k1xqcK1iA2lAo2JSXxKgQaZejBE8F2IIMy10MaFKBhyMWkT3HTYNVtAKMvlx3RGLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPlgaN9ep5uGClRRUbvOY9ROxTDlf1/hBq0aCZKZqvs=;
 b=Uop9zR2j/YzwOupY2YTIQ2lKrReSN9LpCAWRVIZtUhUNom4UWx4N4SQJS9lqhNC77Ya6jrm5xB/7MiKIlFd1w1kaVfFUSgN5mATsDzRGaLUJTMWgPn5XtRtlbS/FhacoMIP9T0nVaOKhI3ZU9H6OUrTvcnCRoNmcq6AVXN9RILtVG5xUkLcqNlhaFaFLbTDoftXEnZ7wMJyxiJd8bwL3RIDuPV+zxiHrmZLaNf3YqvjmDYayfntsCC+HpbrhrDnzTDyqVkx3Fd4OK18EUQjRiGApLt3D3E6kaVw57Acc8FGkevgBCZFx1CXMtTuYwOhRcUUh9nlZTgZsyvIZaIFG2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BN6PR12MB1233.namprd12.prod.outlook.com (2603:10b6:404:1c::19)
 by BN6PR12MB1636.namprd12.prod.outlook.com (2603:10b6:405:6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Mon, 12 Oct
 2020 09:12:29 +0000
Received: from BN6PR12MB1233.namprd12.prod.outlook.com
 ([fe80::f54d:4b1b:ab07:3c7c]) by BN6PR12MB1233.namprd12.prod.outlook.com
 ([fe80::f54d:4b1b:ab07:3c7c%3]) with mapi id 15.20.3455.030; Mon, 12 Oct 2020
 09:12:29 +0000
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
Thread-Index: AQHWnknUyv0axoQ8Ok62KdiGISiNnKmTswiA
Date:   Mon, 12 Oct 2020 09:12:29 +0000
Message-ID: <3fc314a2074001f7b39bada2c50529eb2aefd077.camel@nvidia.com>
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
x-ms-office365-filtering-correlation-id: de8e624c-f07a-418d-a5ac-08d86e8ef1d5
x-ms-traffictypediagnostic: BN6PR12MB1636:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR12MB1636417CE4FBDAC66975A067DF070@BN6PR12MB1636.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rf8TKM41BWGmsTa+r3UlLNRdvC/e7/dONiM4mUZpkJWjRxNaxWrGVQcjbO+nkHrsaqGgLMp4xkzOEifgFHRzX3yL/A8TCB7rp3gREa09dxHhA20CETu6dYDPoUeLgzqKlHtEEhX8qg9dIGqMKSoPwSfB1WFcLKLTmtXS/FcBadKHkrXcCVSSIIauPHnHIgmYYNnqujCXZ+HTvJFOO+M3W6RZJufr6Suxpyr4QUfr61cqAo8AdpmjLlJ+KZzy8fqSuUclL7tLfqFqu3Jdq5nJMjWotk2TNDVIIBerL0cTy9HkjXHMc+JeGGzwpO2HCOBybIzdUgelk0eh9WtXTWV+r6IfThYZW8nYj1LwNrwzZvpbIyF6iDpDtmmaCCYJQ5+e
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR12MB1233.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(110136005)(316002)(71200400001)(66446008)(66946007)(5660300002)(6512007)(91956017)(66556008)(64756008)(66476007)(76116006)(186003)(83380400001)(86362001)(26005)(478600001)(2616005)(3450700001)(6506007)(6486002)(2906002)(8676002)(8936002)(36756003)(4326008)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1uRjqr9sl+UYKWF3BYiPXBsiQIu5k1xlDrrkEph22vnnv6L8JTQcbzrIljsNidkMnML0o4fEDnXX2WkJ0/l0QM7/sdTaIOgomwxAbGaQ8Hl5c0VSREJGSC+b7qaC8zha87eS0hCDv4tJi6Ct1SS9utSovGfYCTxnMzFbGEef8dISL3fNHm6o5ZrAQ1uYaBNnUN6Lo/EkZSJK09ITc91lAlpE8giCdZYuSBn4zQaL71rJmRvVPiQEQeHHvpVCfznAr+VWvs6FSDzAAi/zJxKnkmHb/ye2YH1ZMtrXb1nQswvKNJzO2OTYRXaxQPvgrr3JEnP1Yffdb6IilVw4VgzLJbOZQdjsjPT7Z6OSiv8pdHpaKLY/c1HBaga2UR63S21lAwlb07FYBD4QlkyHO82gcmgqgGcK8qwffzPRf26p8OSavkQfaq2uDs8ZhS0j/tty11wfZT7A6BMO7J2pYEM/38lNXfsvPIOCLXF1kJl/u7wKEgRdvIcDlCBBxHPPSEXwxS0IL2Bux2onOswT/8orARkWlbzbM51AVY/wBVXqBJsrhdK58MBKoVBdtkXciSn4gT0FXkkUDa1VFr0PjP24TMWtdOC7QRu0Sit9SQu8Qetytc1B4fpo0Uyk7uuUQeTfy3W2x6lQiFV8MEbt1FvpEw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <5297160F08544143804D56C2968F8D58@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR12MB1233.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de8e624c-f07a-418d-a5ac-08d86e8ef1d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 09:12:29.1778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mpONvcGqqwJ3tIbFuM0ycR8QNSwKGRO1FwwOiD/ST+/BCfof1ogvowPRSnt+qyuRwdxFuMZOl7CEmpr7E4jC5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1636
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602493952; bh=lPlgaN9ep5uGClRRUbvOY9ROxTDlf1/hBq0aCZKZqvs=;
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
        b=MsIvs5rE6/r3jP+lK7+Ac+gJJAfIErxdT0VJQytEfyuNzk+bWjCTiMBGnxaBM4iQ1
         TWEV804t4YQ2b4RzACLQBGGasrl/+W3+U8t6sx7ovkl3njPoNdjg6p/VRpkUAMmi92
         Snq5X3HpB/RoDOKg55B8yeXhR8Nzz2GxDKyxVbjI2obu9Il4c3qn6KwvSsyD9UYLpM
         pY8RNpzkaVH9YABfr9KGfdPB2hDHx5LbjaHPFUfK313nwldEjEliw/mcRJMEdVsNW1
         5TGQBYgmchM92zJqQtveABLTGorZkJtnl2RPudCfvQztcrXVaCcyIi43wKvVv7oJXs
         ajdspdjtpJ5Mg==
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
KQ0KPiANCltzbmlwXQ0KPiBkaWZmIC0tZ2l0IGEvbmV0L2JyaWRnZS9icl9wcml2YXRlLmggYi9u
ZXQvYnJpZGdlL2JyX3ByaXZhdGUuaA0KPiBpbmRleCAzNDUxMThlMzVjNDIuLjNlNjJjZTJlZjhh
NSAxMDA2NDQNCj4gLS0tIGEvbmV0L2JyaWRnZS9icl9wcml2YXRlLmgNCj4gKysrIGIvbmV0L2Jy
aWRnZS9icl9wcml2YXRlLmgNCj4gQEAgLTQ4MCw2ICs0ODAsOCBAQCBzdHJ1Y3QgbmV0X2JyaWRn
ZSB7DQo+ICAjZW5kaWYNCj4gIAlzdHJ1Y3QgaGxpc3RfaGVhZAkJZmRiX2xpc3Q7DQo+ICANCj4g
KwlzdHJ1Y3QgaGxpc3RfaGVhZAkJZnJhbWVfdHlwZV9saXN0Ow0KDQpTaW5jZSB0aGVyZSB3aWxs
IGJlIGEgdjUsIEknZCBzdWdnZXN0IHRvIG1vdmUgdGhpcyBzdHJ1Y3QgbWVtYmVyIGluIHRoZSBm
aXJzdA0KY2FjaGUgbGluZSBhcyBpdCB3aWxsIGJlIGFsd2F5cyB1c2VkIGluIHRoZSBicmlkZ2Ug
ZmFzdC1wYXRoIGZvciBhbGwgY2FzZXMuDQpJbiBvcmRlciB0byBtYWtlIHJvb20gZm9yIGl0IHRo
ZXJlIHlvdSBjYW4gbW92ZSBwb3J0X2xpc3QgYWZ0ZXIgZmRiX2hhc2hfdGJsIGFuZA0KYWRkIHRo
aXMgaW4gaXRzIHBsYWNlLCBwb3J0X2xpc3QgaXMgY3VycmVudGx5IHVzZWQgb25seSB3aGVuIGZs
b29kaW5nIGFuZCBzb29uDQpJJ2xsIGV2ZW4gY2hhbmdlIHRoYXQuDQoNClRoYW5rcywNCiBOaWsN
Cg0KPiArDQo+ICAjaWYgSVNfRU5BQkxFRChDT05GSUdfQlJJREdFX01SUCkNCj4gIAlzdHJ1Y3Qg
bGlzdF9oZWFkCQltcnBfbGlzdDsNCj4gICNlbmRpZg0KPiBAQCAtNzU1LDYgKzc1NywxNiBAQCBp
bnQgbmJwX2JhY2t1cF9jaGFuZ2Uoc3RydWN0IG5ldF9icmlkZ2VfcG9ydCAqcCwgc3RydWN0IG5l
dF9kZXZpY2UgKmJhY2t1cF9kZXYpOw0KPiAgaW50IGJyX2hhbmRsZV9mcmFtZV9maW5pc2goc3Ry
dWN0IG5ldCAqbmV0LCBzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19idWZmICpza2IpOw0KPiAg
cnhfaGFuZGxlcl9mdW5jX3QgKmJyX2dldF9yeF9oYW5kbGVyKGNvbnN0IHN0cnVjdCBuZXRfZGV2
aWNlICpkZXYpOw0KPiAgDQo+ICtzdHJ1Y3QgYnJfZnJhbWVfdHlwZSB7DQo+ICsJX19iZTE2CQkJ
dHlwZTsNCj4gKwlpbnQJCQkoKmZyYW1lX2hhbmRsZXIpKHN0cnVjdCBuZXRfYnJpZGdlX3BvcnQg
KnBvcnQsDQo+ICsJCQkJCQkgc3RydWN0IHNrX2J1ZmYgKnNrYik7DQo+ICsJc3RydWN0IGhsaXN0
X25vZGUJbGlzdDsNCj4gK307DQo+ICsNCj4gK3ZvaWQgYnJfYWRkX2ZyYW1lKHN0cnVjdCBuZXRf
YnJpZGdlICpiciwgc3RydWN0IGJyX2ZyYW1lX3R5cGUgKmZ0KTsNCj4gK3ZvaWQgYnJfZGVsX2Zy
YW1lKHN0cnVjdCBuZXRfYnJpZGdlICpiciwgc3RydWN0IGJyX2ZyYW1lX3R5cGUgKmZ0KTsNCj4g
Kw0KPiAgc3RhdGljIGlubGluZSBib29sIGJyX3J4X2hhbmRsZXJfY2hlY2tfcmN1KGNvbnN0IHN0
cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+ICB7DQo+ICAJcmV0dXJuIHJjdV9kZXJlZmVyZW5jZShk
ZXYtPnJ4X2hhbmRsZXIpID09IGJyX2dldF9yeF9oYW5kbGVyKGRldik7DQo+IEBAIC0xNDE3LDcg
KzE0MjksNiBAQCBleHRlcm4gaW50ICgqYnJfZmRiX3Rlc3RfYWRkcl9ob29rKShzdHJ1Y3QgbmV0
X2RldmljZSAqZGV2LCB1bnNpZ25lZCBjaGFyICphZGRyKQ0KPiAgI2lmIElTX0VOQUJMRUQoQ09O
RklHX0JSSURHRV9NUlApDQo+ICBpbnQgYnJfbXJwX3BhcnNlKHN0cnVjdCBuZXRfYnJpZGdlICpi
ciwgc3RydWN0IG5ldF9icmlkZ2VfcG9ydCAqcCwNCj4gIAkJIHN0cnVjdCBubGF0dHIgKmF0dHIs
IGludCBjbWQsIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjayk7DQo+IC1pbnQgYnJfbXJw
X3Byb2Nlc3Moc3RydWN0IG5ldF9icmlkZ2VfcG9ydCAqcCwgc3RydWN0IHNrX2J1ZmYgKnNrYik7
DQo+ICBib29sIGJyX21ycF9lbmFibGVkKHN0cnVjdCBuZXRfYnJpZGdlICpicik7DQo+ICB2b2lk
IGJyX21ycF9wb3J0X2RlbChzdHJ1Y3QgbmV0X2JyaWRnZSAqYnIsIHN0cnVjdCBuZXRfYnJpZGdl
X3BvcnQgKnApOw0KPiAgaW50IGJyX21ycF9maWxsX2luZm8oc3RydWN0IHNrX2J1ZmYgKnNrYiwg
c3RydWN0IG5ldF9icmlkZ2UgKmJyKTsNCj4gQEAgLTE0MjksMTEgKzE0NDAsNiBAQCBzdGF0aWMg
aW5saW5lIGludCBicl9tcnBfcGFyc2Uoc3RydWN0IG5ldF9icmlkZ2UgKmJyLCBzdHJ1Y3QgbmV0
X2JyaWRnZV9wb3J0ICpwLA0KPiAgCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gIH0NCj4gIA0KPiAt
c3RhdGljIGlubGluZSBpbnQgYnJfbXJwX3Byb2Nlc3Moc3RydWN0IG5ldF9icmlkZ2VfcG9ydCAq
cCwgc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4gLXsNCj4gLQlyZXR1cm4gMDsNCj4gLX0NCj4gLQ0K
PiAgc3RhdGljIGlubGluZSBib29sIGJyX21ycF9lbmFibGVkKHN0cnVjdCBuZXRfYnJpZGdlICpi
cikNCj4gIHsNCj4gIAlyZXR1cm4gZmFsc2U7DQoNCg==
