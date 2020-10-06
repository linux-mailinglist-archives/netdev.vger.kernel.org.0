Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EA0284D61
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgJFONW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:13:22 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:18402 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgJFONV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 10:13:21 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7c7b7e0000>; Tue, 06 Oct 2020 22:13:18 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Oct
 2020 14:13:18 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 6 Oct 2020 14:13:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMQ1Vpyu1FqMhVS+AztVRZkN2iQcHeMa6t+o1v44DpFbl/xdKbSJYFHLc1RtCD7NxZkMq56eI4toLy9S3QTvXWyeDP5T4QGmEC3nCjLKG9xZzVoy6ngp3qizkXEAFTKJoWUX/c+XOnpPZsom0nf8ZxEzrG/i/mvdvHOeRP0eiNlWi7V1MQSLqLYExBJ2aa5gG7MbLvQeIoM6dlJkqkJ9bD2L+3lrn6JdX5TxUjVIDSzsCD2uXU6oVgCztni+Ufrp1/TmyDGySStuYl508nRTMMEyrjqvfR5/6tys9pNR2s2iIaD9vAgcYKmZYzWINdAkL0pfvQ+W9/dCDOTvpPcLDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmPRsyn1oG4SMYPUOGekrUlH3mnqVSA9dJsolaGVHak=;
 b=b0b9G53ZmQ7Jof1X7jmLAwBegwnkJ4B9A9Ec31KVyB8yjcJ5sUEA0f7gnmHDE51xyZZcSaUVSenOKDSscvOdNKWRpR4L4oDmGe3EYhB9vtGgicL8LtmRxMhYq3/5mPjgIo5ThAQGQMW+aYPRe+qH+Q8gAlTq4JaFpZ14d5Ii6ZUmVNclF3n1PrP36+NBYzR2yhPr2s/egB9jGT0W1hCXcRXaeIhup5J+E4Ao6WdbStazgLE7f+mJRULFOPYEY2a+AiFK5Y+fr/cb14RAtAdg5SJYpkVH+kNYSXxPoBZ0lR2uInlCIbZlTbRVerjtqblciGkc9I1X72P27SZsCxeuBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3995.namprd12.prod.outlook.com (2603:10b6:5:1c6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34; Tue, 6 Oct
 2020 14:13:16 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3433.045; Tue, 6 Oct 2020
 14:13:16 +0000
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
Subject: Re: [net-next v2 01/11] net: bridge: extend the process of special
 frames
Thread-Topic: [net-next v2 01/11] net: bridge: extend the process of special
 frames
Thread-Index: AQHWl94y4mVxmoGrEkODUwQcN93G+qmKpe2A
Date:   Tue, 6 Oct 2020 14:13:15 +0000
Message-ID: <9149db9d070102e20208d962aeb9101fd5fe2c4c.camel@nvidia.com>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
         <20201001103019.1342470-2-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201001103019.1342470-2-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: 13f9ae00-6acc-42a7-bc0e-08d86a01f801
x-ms-traffictypediagnostic: DM6PR12MB3995:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3995BE340E662A7CD5D394D0DF0D0@DM6PR12MB3995.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UKPttcBJ+I9ijipI95gmNzC6fN/aOoEQi7q+W+UQ21GGTc81au9W9/5fcV8mm/8U9/cwqPAgVlVxYlv7/sKGDuY8OfYaiGxBGWf5NsjIsjzJimiZLTXvJBzVyDjMfqg8eLspjHmaXC29n3GgZz7tw+NfBqbrLmdOUxpbULhJtd+2bjQykMdvnAILlt2MpJG8pqlhKFrgh8FkHxsTYp7XKDnGxRoSRk203Li5pVOx7tnmNJbHgNe6QGMGL0n5hrvKbqdWoNHtp3ExbVpVMwezoHwR6iXxaA+BmEzemBOBIE0W7IA7fBf+duXQfSWdLvlStt9cNmXYl/pdju6dNMdBxTp8wwpuTk6jQqDT5zk1fbW2TQELfUe8gjr3roiBoMkn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(5660300002)(2616005)(478600001)(71200400001)(6506007)(110136005)(2906002)(3450700001)(66446008)(316002)(26005)(91956017)(76116006)(186003)(36756003)(64756008)(66556008)(66946007)(66476007)(86362001)(83380400001)(4326008)(6512007)(8936002)(8676002)(6486002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: pmhr7GzxkTr6f56q9U6u0fVTl+zb8t714N5fZir7uG0LhhLyKCNjzaMPD2B7TqSGIZ01OYbISchnnmoIl9YWPgDrPuA43PQYRpSF0nFH6LaKGZiSZnUoUjPYpc709nM6+H3RnzUGyXyTRE2YMZGV2icd+EEInnICwqU4fY7NSLRbwn5zZFkzOG888R/Lm5ibX2b27UEgun5uaOcpSXtAX5lmMbjYnxKGPqH8v7hhC2+H4sxKbjetwaVTlCd1PMSLwMq+qtv+RkZBPr011Au+8AdMcqtWaFjiRX7c66ppe+UX2urLPMukHVIU9u9MXoc1gk4p7TNgsxksMqY9R2ip0mmvw2aipOENioRAFgzNuoMh9gTUB3cFKD23L3hlc/69Usx56ikYQj4wZdJraZ+zFyj123rmM1Ey7HCAlaeZFu6U2PlANAxb86NhI1S86rxXxk0/TCcEpz9zvKrDUbJW/NPk74dqOObP2TGxO1raHa6aeB47iHzPgcygmRnwA2Mmk+aS6UhnDjjm8naHKUb2XgHBCcgA3hwJdIXZ2gv/208YeWIWRYg+Oln5zH84UoSGiZSfgeoXI4JbpeoR2IWsm5e6RfLdAIsWjGZD4C/FsqgzzywRqLnRG2fPe3yb+hChCxu4iqS6AJEA40zYHXheFw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <30E27537C8946C4A8C2D5B6D555CCC6F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f9ae00-6acc-42a7-bc0e-08d86a01f801
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2020 14:13:15.9940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LYcrz1P1IvH8HEJVx9Se9zF/KvALJ+dDUw+yRWAgTzeD4b3d15OP1SLJyGBCuxIc1FIfXHg46rOiHF9lb51whA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3995
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601993598; bh=EmPRsyn1oG4SMYPUOGekrUlH3mnqVSA9dJsolaGVHak=;
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
        b=EzQwksvAyEhc86ZGUEO0DuZk5Tfq7QhL+oC6PPsiP5aQ9Q9rzRO7+fFSVx5jTArZj
         cKBEcs6y4PdPFiD80Iz96L2bL+a1GsWramsdoAWuKDTfTpUEyU1QoCrQlhHXKszJDh
         VO0KOS4fnWEFEPHEfqN5fGcP/iWqtjNLPuX7wxWSXZbTJdwEfiqBS3+/r72tafYJtI
         bl36DDzGr1/SdAABZv5zIngqR+Dxp1TRwVbHoT+DU2oJPcHfHfm3Zze1Kx9jhYKgFV
         OOgADuaFAfYAJOptNrFPq2jnTaQNr06nIBi2+1f4SlVycmi55LL2eq4MQoki1Zp+0C
         w4fhnlk2XJnuA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTEwLTAxIGF0IDEwOjMwICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
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
IFJldmlld2VkLWJ5OiBIb3JhdGl1IFZ1bHR1ciAgPGhvcmF0aXUudnVsdHVyQG1pY3JvY2hpcC5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IEhlbnJpayBCam9lcm5sdW5kICA8aGVucmlrLmJqb2Vybmx1
bmRAbWljcm9jaGlwLmNvbT4NCj4gLS0tDQo+ICBuZXQvYnJpZGdlL2JyX2RldmljZS5jICB8ICAx
ICsNCj4gIG5ldC9icmlkZ2UvYnJfaW5wdXQuYyAgIHwgMzEgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrLQ0KPiAgbmV0L2JyaWRnZS9icl9tcnAuYyAgICAgfCAxOSArKysrKysrKysrKysr
KystLS0tDQo+ICBuZXQvYnJpZGdlL2JyX3ByaXZhdGUuaCB8IDE4ICsrKysrKysrKysrKy0tLS0t
LQ0KPiAgNCBmaWxlcyBjaGFuZ2VkLCA1OCBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkN
Cj4gDQoNCkhpLA0KTW9zdGx5IGxvb2tzIGdvb2QsIG9uZSBjb21tZW50IGJlbG93Lg0KDQo+IGRp
ZmYgLS1naXQgYS9uZXQvYnJpZGdlL2JyX2RldmljZS5jIGIvbmV0L2JyaWRnZS9icl9kZXZpY2Uu
Yw0KPiBpbmRleCA5YTJmYjRhYTFhMTAuLjIwNmM0YmE1MWNkMiAxMDA2NDQNCj4gLS0tIGEvbmV0
L2JyaWRnZS9icl9kZXZpY2UuYw0KPiArKysgYi9uZXQvYnJpZGdlL2JyX2RldmljZS5jDQo+IFtz
bmlwXQ0KPiBAQCAtMzgwLDMgKzM5NSwxNyBAQCByeF9oYW5kbGVyX2Z1bmNfdCAqYnJfZ2V0X3J4
X2hhbmRsZXIoY29uc3Qgc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4gIA0KPiAgCXJldHVybiBi
cl9oYW5kbGVfZnJhbWU7DQo+ICB9DQo+ICsNCj4gK3ZvaWQgYnJfYWRkX2ZyYW1lKHN0cnVjdCBu
ZXRfYnJpZGdlICpiciwgc3RydWN0IGJyX2ZyYW1lX3R5cGUgKmZ0KQ0KPiArew0KPiArCWhsaXN0
X2FkZF9oZWFkX3JjdSgmZnQtPmxpc3QsICZici0+ZnJhbWVfdHlwZV9saXN0KTsNCj4gK30NCj4g
Kw0KPiArdm9pZCBicl9kZWxfZnJhbWUoc3RydWN0IG5ldF9icmlkZ2UgKmJyLCBzdHJ1Y3QgYnJf
ZnJhbWVfdHlwZSAqZnQpDQo+ICt7DQo+ICsJc3RydWN0IGJyX2ZyYW1lX3R5cGUgKnRtcDsNCj4g
Kw0KPiArCWhsaXN0X2Zvcl9lYWNoX2VudHJ5KHRtcCwgJmJyLT5mcmFtZV90eXBlX2xpc3QsIGxp
c3QpDQo+ICsJCWlmIChmdCA9PSB0bXApDQo+ICsJCQlobGlzdF9kZWxfcmN1KCZmdC0+bGlzdCk7
DQoNClRoaXMgaGFzbid0IGNyYXNoZWQgb25seSBiZWNhdXNlIHlvdSdyZSB1c2luZyBobGlzdF9k
ZWxfcmN1KCksIG90aGVyd2lzZSBpdCdzDQp3cm9uZy4gWW91IHNob3VsZCB1c2UgaGxpc3RfZm9y
X2VhY2hfZW50cnlfc2FmZSgpIHdoZW4gZGVsZXRpbmcgZnJvbSB0aGUgbGlzdA0Kd2hpbGUgd2Fs
a2luZyBpdCBvciB5b3Ugc2hvdWxkIGVuZCB0aGUgd2FsayBhZnRlciB0aGUgZGVsZXRlIHNpbmNl
IHRoZXJlIGNhbid0DQpiZSB0d28gZWxlbWVudHMgd2l0aCB0aGUgc2FtZSBhZGRyZXNzIGFueXdh
eS4NCg0KVGhhbmtzLA0KIE5paw0KDQoNCg0K
