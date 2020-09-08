Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F0F2616BC
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731297AbgIHQSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:18:18 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2858 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731673AbgIHQRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:17:23 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5774b50000>; Tue, 08 Sep 2020 05:10:29 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 05:12:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 08 Sep 2020 05:12:43 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 8 Sep
 2020 12:12:42 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 8 Sep 2020 12:12:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a16ttf9kPxTyR+UfxDjPx/Kis52wF8eXINvgyp3DAfCLQft7uOgsdVCALQ78rNpZZMccXCAQD6f98lxIHntzLNot5AETWujBZ45048iPFDqCTBpAYh+oamGV0bv1/kdgPFdOq5eP9IR78bPp8eIimXBgQ059Q4Kwy4DuP5Rcp/kcgQYC4UaHjD2TKZMP1sKzzOeQ+rnPAweNsh2V26MDtbEfvveG9znBER69w09F/JsWVwVt9q4IPLFu9zfwhRrU4AjmZdAXn9YVNysiT0HkYVR/nf+hzPn/Li/tBSzEIx48asrYazu2WJRuqxZ0ljsCZXCNNFnwxBjdlqTIOUfPtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iIFezwXIgz2BwlZHbFZI2RCs66cULyQ13Szvz1cJYkM=;
 b=FEvydvh8vflqf43VL9luGjh+kqG8ogAYF/aqwkK9bbTSd8PZeiKBCT/Sfc+c8vFkgC0ksm/Jo+HchBzJcaTGBLxZ6UZXAIucqcey5VpiAVMT6gtbiHryUE4tIDSAFHP1kBA2bE/ibV73jK37y92Jv2qM9Sez2ZVSf/vp0TosrxxfsU4pjWOaMr1UHrEO6iDxRXgPzAwCYNBCvqKYkMmL9i6p8f5encDilMyeJ+q+obp8n57mL5DGRA+vyB9gQYAEdR5DWCfPMnjmy9cHBaSnTpdiPN1wem4TgaOvTQ+e38sReEOksv07rEDCK5+v3M+nwOOa6qbTavWqSEwMUnyt3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33)
 by BYAPR12MB2968.namprd12.prod.outlook.com (2603:10b6:a03:ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Tue, 8 Sep
 2020 12:12:41 +0000
Received: from BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b]) by BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 12:12:41 +0000
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
Subject: Re: [PATCH RFC 1/7] net: bridge: extend the process of special frames
Thread-Topic: [PATCH RFC 1/7] net: bridge: extend the process of special
 frames
Thread-Index: AQHWgpx8we0gmalPpkuX1cEbYEHS+KlerXeA
Date:   Tue, 8 Sep 2020 12:12:40 +0000
Message-ID: <8bb3694a731ae574911c0f3ce2d71fadeb8c90cf.camel@nvidia.com>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
         <20200904091527.669109-2-henrik.bjoernlund@microchip.com>
In-Reply-To: <20200904091527.669109-2-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: bf1c56d1-898f-48a4-446f-08d853f07bfc
x-ms-traffictypediagnostic: BYAPR12MB2968:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB29683CD59ECD91184E9C512CDF290@BYAPR12MB2968.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sg9xDNVN8HLeHVpQD3qAMvEerarKie7toUF1Aldi0pLzUk1POEZ9O35Kb4wKahHVx2QON2gniusnx0VV9mghs/d7JNBzewVAuoniAYZA/4xV4sCkqPNtl/gsPqckqvYabOJEf+co2AdHrYp/Fq5+FTNen8S3rMK3DBmTwS2wk7zCj4lUtCVEtL4BS43bkxhONcourlT4xgTNdMNC5MQcPehknjIXFdTvGjZad9+Y7FqjYfkAv/sKN/tdSsBH/ENPf8618YOI1JONOHooIQu5WLFqKH5/WNYO2C8Y7BMl3XYGlicNFcI0DHLJGigYc6n6NdLP8pPHK3xhN3M9hZUzNVv9HOxupJDNJYZa9cvg1AsKKmWmxyAi1uor6UxPk7pV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(6486002)(4326008)(3450700001)(110136005)(91956017)(6512007)(2906002)(316002)(76116006)(66446008)(64756008)(66476007)(66556008)(2616005)(8676002)(36756003)(5660300002)(86362001)(26005)(8936002)(186003)(83380400001)(6506007)(71200400001)(66946007)(478600001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: K5Vp2EZPGucENarE26OFx3K23Ye/NjPd4BZXwVpzmP7i4rqUasoFw7lrjjd0vS2mwM4AzIe3dbFb0e9U9O8MkpJzaIX45d+wz5quRlv4Md72EwI1BA4fWUH9MOsi4xXvfClGmraHPWgji9FP3vfZnAbCexZKhBCNfWDpw7ACD4xqRrAIykn7tSLXDpKDDBBAjoXUkFMiFTlcIGNz4aTkBAAJjyh2Uj4OCFKc5kdgb1E/LOic+gXCrOP8JNUX4Q1FvAbGWNa6YiXueXIzGFBGs4UhpV7P9GkWtOjrK6+2IfsYj7vMIFM7TwNvUKKSzFr7Jvn7IwkrE6+cLvjNHO/l3wIHj8DNYS/bAxO0m8xv2OyDxMGHGg4/P6JwIoPAoF6G74O51H0ZOlr6rTBjP/3FfHBF/ooRHYr1o/SiK0pK9oy7nkXLyey6rPS1vKxgLanlQy+/iAPyY7wO1NuZAbqd5csMe/38bKoj2fMtPZ4uUsbl09G5KpQsiLhBNFo5e9HA1Ei2QL3xNpIF6VmyLma+Bj2ALB39C0xZDORQufRvwxh8Cs5XJdvtGd/8MUItgoneCUtAxvezh7Jh3o7NhQ0qiqzo//krvOa9sFAXT2rl4cPupsQMSCY6Dw+eIZYUJRPVqB4psw/v6xEJU+aQlyJfyg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <15512B9FB3A4A8488AD022B59A4BD06C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf1c56d1-898f-48a4-446f-08d853f07bfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2020 12:12:40.5364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kTIdb0nU5NgqrllpvKLemUzSt26DB2vTrrFeIOGkZwe1mCv1+XYorWxLpiD/q5GkYETXp5i7F4YHQ4MHaGV//Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2968
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599567029; bh=iIFezwXIgz2BwlZHbFZI2RCs66cULyQ13Szvz1cJYkM=;
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
        b=X1an3dyCv8qyx15NOLzmM1WGEvAcE1Xszd6ZnRmO31CtVIBi9ynracJCq00gACM+V
         aW1DRMnKIYtsCON6Mfj8Y/KSqf09Y+akOukDj/7BUAwi7IB2YqNglPqukuOaZCzQ78
         FdOvnUqfU2soii4t6IT+NncvFi14JvygHOKOHg2k6PYQzLSA47oT7CCrV3Ldc7jeXa
         i50l+SzTZnE4MVYAj96hKV+RA3HI+tAxHdP1CRF2bfs9pSL+v0iqgxrWoOTqZvo7n+
         m6q6MNUTeZbQXIhDTd4Kaj3et6bA2pm2J66pE+99z1hgA3//PXVonEn/goUkdb5J2Q
         Z6HWmspiD1Siw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA5LTA0IGF0IDA5OjE1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
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
cm9jaGlwLmNvbT4NCj4gLS0tDQo+ICBuZXQvYnJpZGdlL2JyX2RldmljZS5jICB8ICAxICsNCj4g
IG5ldC9icmlkZ2UvYnJfaW5wdXQuYyAgIHwgMzEgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrLQ0KPiAgbmV0L2JyaWRnZS9icl9tcnAuYyAgICAgfCAxOSArKysrKysrKysrKysrKystLS0t
DQo+ICBuZXQvYnJpZGdlL2JyX3ByaXZhdGUuaCB8IDE4ICsrKysrKysrKysrKy0tLS0tLQ0KPiAg
NCBmaWxlcyBjaGFuZ2VkLCA1OCBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkNCj4gDQoN
CkhpLA0KRmlyc3QgSSBtdXN0IHNheSBJIGRvIGxpa2UgdGhpcyBhcHByb2FjaCwgdGhhbmtzIGZv
ciBnZW5lcmFsaXppbmcgaXQuDQpZb3UgY2FuIHN3aXRjaCB0byBhIGhsaXN0IHNvIHRoYXQgdGhl
cmUncyBqdXN0IDEgcG9pbnRlciBpbiB0aGUgaGVhZC4NCkkgZG9uJ3QgdGhpbmsgeW91IG5lZWQg
bGlzdCB3aGVuIHlvdSdyZSB3YWxraW5nIG9ubHkgaW4gb25lIGRpcmVjdGlvbi4NCkEgZmV3IG1v
cmUgbWlub3IgY29tbWVudHMgYmVsb3cuDQoNCj4gZGlmZiAtLWdpdCBhL25ldC9icmlkZ2UvYnJf
ZGV2aWNlLmMgYi9uZXQvYnJpZGdlL2JyX2RldmljZS5jDQo+IGluZGV4IDlhMmZiNGFhMWExMC4u
YTkyMzJkYjAzMTA4IDEwMDY0NA0KPiAtLS0gYS9uZXQvYnJpZGdlL2JyX2RldmljZS5jDQo+ICsr
KyBiL25ldC9icmlkZ2UvYnJfZGV2aWNlLmMNCj4gQEAgLTQ3Myw2ICs0NzMsNyBAQCB2b2lkIGJy
X2Rldl9zZXR1cChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KPiAgCXNwaW5fbG9ja19pbml0KCZi
ci0+bG9jayk7DQo+ICAJSU5JVF9MSVNUX0hFQUQoJmJyLT5wb3J0X2xpc3QpOw0KPiAgCUlOSVRf
SExJU1RfSEVBRCgmYnItPmZkYl9saXN0KTsNCj4gKwlJTklUX0xJU1RfSEVBRCgmYnItPmZ0eXBl
X2xpc3QpOw0KPiAgI2lmIElTX0VOQUJMRUQoQ09ORklHX0JSSURHRV9NUlApDQo+ICAJSU5JVF9M
SVNUX0hFQUQoJmJyLT5tcnBfbGlzdCk7DQo+ICAjZW5kaWYNCj4gZGlmZiAtLWdpdCBhL25ldC9i
cmlkZ2UvYnJfaW5wdXQuYyBiL25ldC9icmlkZ2UvYnJfaW5wdXQuYw0KPiBpbmRleCA1OWEzMThi
OWY2NDYuLjBmNDc1YjIxMDk0YyAxMDA2NDQNCj4gLS0tIGEvbmV0L2JyaWRnZS9icl9pbnB1dC5j
DQo+ICsrKyBiL25ldC9icmlkZ2UvYnJfaW5wdXQuYw0KPiBAQCAtMjU0LDYgKzI1NCwyMSBAQCBz
dGF0aWMgaW50IG5mX2hvb2tfYnJpZGdlX3ByZShzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3Qg
c2tfYnVmZiAqKnBza2IpDQo+ICAJcmV0dXJuIFJYX0hBTkRMRVJfQ09OU1VNRUQ7DQo+ICB9DQo+
ICANCj4gKy8qIFJldHVybiAwIGlmIHRoZSBmcmFtZSB3YXMgbm90IHByb2Nlc3NlZCBvdGhlcndp
c2UgMQ0KPiArICogbm90ZTogYWxyZWFkeSBjYWxsZWQgd2l0aCByY3VfcmVhZF9sb2NrDQo+ICsg
Ki8NCj4gK3N0YXRpYyBpbnQgYnJfcHJvY2Vzc19mcmFtZV90eXBlKHN0cnVjdCBuZXRfYnJpZGdl
X3BvcnQgKnAsDQo+ICsJCQkJIHN0cnVjdCBza19idWZmICpza2IpDQo+ICt7DQo+ICsJc3RydWN0
IGJyX2ZyYW1lX3R5cGUgKnRtcDsNCj4gKw0KPiArCWxpc3RfZm9yX2VhY2hfZW50cnlfcmN1KHRt
cCwgJnAtPmJyLT5mdHlwZV9saXN0LCBsaXN0KSB7DQo+ICsJCWlmICh1bmxpa2VseSh0bXAtPnR5
cGUgPT0gc2tiLT5wcm90b2NvbCkpDQo+ICsJCQlyZXR1cm4gdG1wLT5mdW5jKHAsIHNrYik7DQo+
ICsJfQ0KDQpOaXQ6IHlvdSBjYW4gZHJvcCB0aGUge30uDQoNCj4gKwlyZXR1cm4gMDsNCj4gK30N
Cj4gKw0KPiAgLyoNCj4gICAqIFJldHVybiBOVUxMIGlmIHNrYiBpcyBoYW5kbGVkDQo+ICAgKiBu
b3RlOiBhbHJlYWR5IGNhbGxlZCB3aXRoIHJjdV9yZWFkX2xvY2sNCj4gQEAgLTM0Myw3ICszNTgs
NyBAQCBzdGF0aWMgcnhfaGFuZGxlcl9yZXN1bHRfdCBicl9oYW5kbGVfZnJhbWUoc3RydWN0IHNr
X2J1ZmYgKipwc2tiKQ0KPiAgCQl9DQo+ICAJfQ0KPiAgDQo+IC0JaWYgKHVubGlrZWx5KGJyX21y
cF9wcm9jZXNzKHAsIHNrYikpKQ0KPiArCWlmICh1bmxpa2VseShicl9wcm9jZXNzX2ZyYW1lX3R5
cGUocCwgc2tiKSkpDQo+ICAJCXJldHVybiBSWF9IQU5ETEVSX1BBU1M7DQo+ICANCj4gIGZvcndh
cmQ6DQo+IEBAIC0zODAsMyArMzk1LDE3IEBAIHJ4X2hhbmRsZXJfZnVuY190ICpicl9nZXRfcnhf
aGFuZGxlcihjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KPiAgDQo+ICAJcmV0dXJuIGJy
X2hhbmRsZV9mcmFtZTsNCj4gIH0NCj4gKw0KPiArdm9pZCBicl9hZGRfZnJhbWUoc3RydWN0IG5l
dF9icmlkZ2UgKmJyLCBzdHJ1Y3QgYnJfZnJhbWVfdHlwZSAqZnQpDQo+ICt7DQo+ICsJbGlzdF9h
ZGRfcmN1KCZmdC0+bGlzdCwgJmJyLT5mdHlwZV9saXN0KTsNCj4gK30NCj4gKw0KPiArdm9pZCBi
cl9kZWxfZnJhbWUoc3RydWN0IG5ldF9icmlkZ2UgKmJyLCBzdHJ1Y3QgYnJfZnJhbWVfdHlwZSAq
ZnQpDQo+ICt7DQo+ICsJc3RydWN0IGJyX2ZyYW1lX3R5cGUgKnRtcDsNCj4gKw0KPiArCWxpc3Rf
Zm9yX2VhY2hfZW50cnkodG1wLCAmYnItPmZ0eXBlX2xpc3QsIGxpc3QpDQo+ICsJCWlmIChmdCA9
PSB0bXApDQo+ICsJCQlsaXN0X2RlbF9yY3UoJmZ0LT5saXN0KTsNCj4gK30NCj4gZGlmZiAtLWdp
dCBhL25ldC9icmlkZ2UvYnJfbXJwLmMgYi9uZXQvYnJpZGdlL2JyX21ycC5jDQo+IGluZGV4IGIz
NjY4OWU2ZTdjYi4uMDQyOGUxNzg1MDQxIDEwMDY0NA0KPiAtLS0gYS9uZXQvYnJpZGdlL2JyX21y
cC5jDQo+ICsrKyBiL25ldC9icmlkZ2UvYnJfbXJwLmMNCj4gQEAgLTYsNiArNiwxMyBAQA0KPiAg
c3RhdGljIGNvbnN0IHU4IG1ycF90ZXN0X2RtYWNbRVRIX0FMRU5dID0geyAweDEsIDB4MTUsIDB4
NGUsIDB4MCwgMHgwLCAweDEgfTsNCj4gIHN0YXRpYyBjb25zdCB1OCBtcnBfaW5fdGVzdF9kbWFj
W0VUSF9BTEVOXSA9IHsgMHgxLCAweDE1LCAweDRlLCAweDAsIDB4MCwgMHgzIH07DQo+ICANCj4g
K3N0YXRpYyBpbnQgYnJfbXJwX3Byb2Nlc3Moc3RydWN0IG5ldF9icmlkZ2VfcG9ydCAqcCwgc3Ry
dWN0IHNrX2J1ZmYgKnNrYik7DQo+ICsNCj4gK3N0YXRpYyBzdHJ1Y3QgYnJfZnJhbWVfdHlwZSBt
cnBfZnJhbWVfdHlwZSBfX3JlYWRfbW9zdGx5ID0gew0KPiArCS50eXBlID0gY3B1X3RvX2JlMTYo
RVRIX1BfTVJQKSwNCj4gKwkuZnVuYyA9IGJyX21ycF9wcm9jZXNzLA0KPiArfTsNCj4gKw0KPiAg
c3RhdGljIGJvb2wgYnJfbXJwX2lzX3JpbmdfcG9ydChzdHJ1Y3QgbmV0X2JyaWRnZV9wb3J0ICpw
X3BvcnQsDQo+ICAJCQkJc3RydWN0IG5ldF9icmlkZ2VfcG9ydCAqc19wb3J0LA0KPiAgCQkJCXN0
cnVjdCBuZXRfYnJpZGdlX3BvcnQgKnBvcnQpDQo+IEBAIC00NDUsNiArNDUyLDkgQEAgc3RhdGlj
IHZvaWQgYnJfbXJwX2RlbF9pbXBsKHN0cnVjdCBuZXRfYnJpZGdlICpiciwgc3RydWN0IGJyX21y
cCAqbXJwKQ0KPiAgDQo+ICAJbGlzdF9kZWxfcmN1KCZtcnAtPmxpc3QpOw0KPiAgCWtmcmVlX3Jj
dShtcnAsIHJjdSk7DQo+ICsNCj4gKwlpZiAobGlzdF9lbXB0eSgmYnItPm1ycF9saXN0KSkNCj4g
KwkJYnJfZGVsX2ZyYW1lKGJyLCAmbXJwX2ZyYW1lX3R5cGUpOw0KPiAgfQ0KPiAgDQo+ICAvKiBB
ZGRzIGEgbmV3IE1SUCBpbnN0YW5jZS4NCj4gQEAgLTQ5Myw2ICs1MDMsOSBAQCBpbnQgYnJfbXJw
X2FkZChzdHJ1Y3QgbmV0X2JyaWRnZSAqYnIsIHN0cnVjdCBicl9tcnBfaW5zdGFuY2UgKmluc3Rh
bmNlKQ0KPiAgCXNwaW5fdW5sb2NrX2JoKCZici0+bG9jayk7DQo+ICAJcmN1X2Fzc2lnbl9wb2lu
dGVyKG1ycC0+c19wb3J0LCBwKTsNCj4gIA0KPiArCWlmIChsaXN0X2VtcHR5KCZici0+bXJwX2xp
c3QpKQ0KPiArCQlicl9hZGRfZnJhbWUoYnIsICZtcnBfZnJhbWVfdHlwZSk7DQo+ICsNCj4gIAlJ
TklUX0RFTEFZRURfV09SSygmbXJwLT50ZXN0X3dvcmssIGJyX21ycF90ZXN0X3dvcmtfZXhwaXJl
ZCk7DQo+ICAJSU5JVF9ERUxBWUVEX1dPUksoJm1ycC0+aW5fdGVzdF93b3JrLCBicl9tcnBfaW5f
dGVzdF93b3JrX2V4cGlyZWQpOw0KPiAgCWxpc3RfYWRkX3RhaWxfcmN1KCZtcnAtPmxpc3QsICZi
ci0+bXJwX2xpc3QpOw0KPiBAQCAtMTE3MiwxNSArMTE4NSwxMyBAQCBzdGF0aWMgaW50IGJyX21y
cF9yY3Yoc3RydWN0IG5ldF9icmlkZ2VfcG9ydCAqcCwNCj4gICAqIG5vcm1hbCBmb3J3YXJkaW5n
Lg0KPiAgICogbm90ZTogYWxyZWFkeSBjYWxsZWQgd2l0aCByY3VfcmVhZF9sb2NrDQo+ICAgKi8N
Cj4gLWludCBicl9tcnBfcHJvY2VzcyhzdHJ1Y3QgbmV0X2JyaWRnZV9wb3J0ICpwLCBzdHJ1Y3Qg
c2tfYnVmZiAqc2tiKQ0KPiArc3RhdGljIGludCBicl9tcnBfcHJvY2VzcyhzdHJ1Y3QgbmV0X2Jy
aWRnZV9wb3J0ICpwLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiAgew0KPiAgCS8qIElmIHRoZXJl
IGlzIG5vIE1SUCBpbnN0YW5jZSBkbyBub3JtYWwgZm9yd2FyZGluZyAqLw0KPiAgCWlmIChsaWtl
bHkoIShwLT5mbGFncyAmIEJSX01SUF9BV0FSRSkpKQ0KPiAgCQlnb3RvIG91dDsNCj4gIA0KPiAt
CWlmICh1bmxpa2VseShza2ItPnByb3RvY29sID09IGh0b25zKEVUSF9QX01SUCkpKQ0KPiAtCQly
ZXR1cm4gYnJfbXJwX3JjdihwLCBza2IsIHAtPmRldik7DQo+IC0NCj4gKwlyZXR1cm4gYnJfbXJw
X3JjdihwLCBza2IsIHAtPmRldik7DQo+ICBvdXQ6DQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+IGRp
ZmYgLS1naXQgYS9uZXQvYnJpZGdlL2JyX3ByaXZhdGUuaCBiL25ldC9icmlkZ2UvYnJfcHJpdmF0
ZS5oDQo+IGluZGV4IGJhYTE1MDBmMzg0Zi4uZTY3YzZkOWU4YmVhIDEwMDY0NA0KPiAtLS0gYS9u
ZXQvYnJpZGdlL2JyX3ByaXZhdGUuaA0KPiArKysgYi9uZXQvYnJpZGdlL2JyX3ByaXZhdGUuaA0K
PiBAQCAtODksNiArODksMTMgQEAgc3RydWN0IGJyaWRnZV9tY2FzdF9zdGF0cyB7DQo+ICB9Ow0K
PiAgI2VuZGlmDQo+ICANCj4gK3N0cnVjdCBicl9mcmFtZV90eXBlIHsNCj4gKwlfX2JlMTYJCQl0
eXBlOw0KPiArCWludAkJCSgqZnVuYykoc3RydWN0IG5ldF9icmlkZ2VfcG9ydCAqcG9ydCwNCj4g
KwkJCQkJc3RydWN0IHNrX2J1ZmYgKnNrYik7DQoNClBlcmhhcHMgZnJhbWVfaGFuZGxlciBvciBz
b21ldGhpbmcgc2ltaWxhciB3b3VsZCBiZSBhIGJldHRlciBuYW1lIGZvciB0aGUNCmNhbGxiYWNr
ID8NCg0KPiArCXN0cnVjdCBsaXN0X2hlYWQJbGlzdDsNCj4gK307DQo+ICsNCj4gIHN0cnVjdCBi
cl92bGFuX3N0YXRzIHsNCj4gIAl1NjQgcnhfYnl0ZXM7DQo+ICAJdTY0IHJ4X3BhY2tldHM7DQo+
IEBAIC00MzMsNiArNDQwLDggQEAgc3RydWN0IG5ldF9icmlkZ2Ugew0KPiAgI2VuZGlmDQo+ICAJ
c3RydWN0IGhsaXN0X2hlYWQJCWZkYl9saXN0Ow0KPiAgDQo+ICsJc3RydWN0IGxpc3RfaGVhZAkJ
ZnR5cGVfbGlzdDsNCg0KQ291bGQgeW91IHBsZWFzZSBleHBhbmQgdGhpcyB0byBmcmFtZV90eXBl
X2xpc3QgPw0KDQo+ICsNCj4gICNpZiBJU19FTkFCTEVEKENPTkZJR19CUklER0VfTVJQKQ0KPiAg
CXN0cnVjdCBsaXN0X2hlYWQJCW1ycF9saXN0Ow0KPiAgI2VuZGlmDQo+IEBAIC03MDgsNiArNzE3
LDkgQEAgaW50IG5icF9iYWNrdXBfY2hhbmdlKHN0cnVjdCBuZXRfYnJpZGdlX3BvcnQgKnAsIHN0
cnVjdCBuZXRfZGV2aWNlICpiYWNrdXBfZGV2KTsNCj4gIGludCBicl9oYW5kbGVfZnJhbWVfZmlu
aXNoKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qgc2tfYnVmZiAqc2ti
KTsNCj4gIHJ4X2hhbmRsZXJfZnVuY190ICpicl9nZXRfcnhfaGFuZGxlcihjb25zdCBzdHJ1Y3Qg
bmV0X2RldmljZSAqZGV2KTsNCj4gIA0KPiArdm9pZCBicl9hZGRfZnJhbWUoc3RydWN0IG5ldF9i
cmlkZ2UgKmJyLCBzdHJ1Y3QgYnJfZnJhbWVfdHlwZSAqZnQpOw0KPiArdm9pZCBicl9kZWxfZnJh
bWUoc3RydWN0IG5ldF9icmlkZ2UgKmJyLCBzdHJ1Y3QgYnJfZnJhbWVfdHlwZSAqZnQpOw0KPiAr
DQo+ICBzdGF0aWMgaW5saW5lIGJvb2wgYnJfcnhfaGFuZGxlcl9jaGVja19yY3UoY29uc3Qgc3Ry
dWN0IG5ldF9kZXZpY2UgKmRldikNCj4gIHsNCj4gIAlyZXR1cm4gcmN1X2RlcmVmZXJlbmNlKGRl
di0+cnhfaGFuZGxlcikgPT0gYnJfZ2V0X3J4X2hhbmRsZXIoZGV2KTsNCj4gQEAgLTEzMjAsNyAr
MTMzMiw2IEBAIGV4dGVybiBpbnQgKCpicl9mZGJfdGVzdF9hZGRyX2hvb2spKHN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYsIHVuc2lnbmVkIGNoYXIgKmFkZHIpDQo+ICAjaWYgSVNfRU5BQkxFRChDT05G
SUdfQlJJREdFX01SUCkNCj4gIGludCBicl9tcnBfcGFyc2Uoc3RydWN0IG5ldF9icmlkZ2UgKmJy
LCBzdHJ1Y3QgbmV0X2JyaWRnZV9wb3J0ICpwLA0KPiAgCQkgc3RydWN0IG5sYXR0ciAqYXR0ciwg
aW50IGNtZCwgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKTsNCj4gLWludCBicl9tcnBf
cHJvY2VzcyhzdHJ1Y3QgbmV0X2JyaWRnZV9wb3J0ICpwLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsN
Cj4gIGJvb2wgYnJfbXJwX2VuYWJsZWQoc3RydWN0IG5ldF9icmlkZ2UgKmJyKTsNCj4gIHZvaWQg
YnJfbXJwX3BvcnRfZGVsKHN0cnVjdCBuZXRfYnJpZGdlICpiciwgc3RydWN0IG5ldF9icmlkZ2Vf
cG9ydCAqcCk7DQo+ICBpbnQgYnJfbXJwX2ZpbGxfaW5mbyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBz
dHJ1Y3QgbmV0X2JyaWRnZSAqYnIpOw0KPiBAQCAtMTMzMiwxMSArMTM0Myw2IEBAIHN0YXRpYyBp
bmxpbmUgaW50IGJyX21ycF9wYXJzZShzdHJ1Y3QgbmV0X2JyaWRnZSAqYnIsIHN0cnVjdCBuZXRf
YnJpZGdlX3BvcnQgKnAsDQo+ICAJcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiAgfQ0KPiAgDQo+IC1z
dGF0aWMgaW5saW5lIGludCBicl9tcnBfcHJvY2VzcyhzdHJ1Y3QgbmV0X2JyaWRnZV9wb3J0ICpw
LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiAtew0KPiAtCXJldHVybiAwOw0KPiAtfQ0KPiAtDQo+
ICBzdGF0aWMgaW5saW5lIGJvb2wgYnJfbXJwX2VuYWJsZWQoc3RydWN0IG5ldF9icmlkZ2UgKmJy
KQ0KPiAgew0KPiAgCXJldHVybiBmYWxzZTsNCg0K
