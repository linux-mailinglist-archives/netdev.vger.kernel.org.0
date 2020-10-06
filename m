Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C2B284E4B
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgJFOth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:49:37 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:39245 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgJFOtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 10:49:36 -0400
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7c83fd0000>; Tue, 06 Oct 2020 22:49:33 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Oct
 2020 14:49:32 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 6 Oct 2020 14:49:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enLQkFVgfsVJgZu9etbtL/E0zBqB342hmUfsrfaD+kTjrd02csptBwNs6WeMVH/s8Q4CmpWM16JFHbMPzA5VT38kFTCmK1VTxx1NTRKFqqUP5pP0S9dvTxoQ/SPY4LlhPuDCKfQJ10TcgdmxmigQwKylQ2lZtJpKjoDglpQyH9UcXxBASw8BdHTZJfs8XMden7RgKfzKkGI64Zj2cgOme3vS4Ul4VjTVFRnVoK9uREBi8XUY/jHIzEBCDQs3Nk+iWzCMsuyqxnrRFtApeXjNc6vVZD6PyrguRhjS/CCqOpUJL7e37QxMVKpo/I7TLzEXQSh5qNgCRIHmUDvdDoE/MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vBXmcuCq084oKoeXiItqcAJ9fihgPlxAFVln8gd180=;
 b=QOQFXW30k6kxxSRoG5f+m0VILz922FS/w3BhxqoQaK1n//TAaq9c3mtG3CsG3MCO/VSigD80v/ZojBsVoePr+G0tEjtV5jaDaVu9YwWt9TvtO0ZzW06M6qXRzbXwbWWijmDGvG1xCk+CN5jXapCS70DYmz8RDk+8EP9reI6UTtSssNiYUJwnoGbhIevs2Ehkm12sKBU18m8Dg2jcPktB0jyp8VmLjtc1pObQ3mTrFh1iU1d93gkrxcr9ACOjIQUNL4SjR4dOq53XxXDBKVCmvdcskqnK6dZrLkMmJd236DNETbZznBfo+AbG5jAXycaUbUHFi1f+Q4gnMu0sF3CDTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3291.namprd12.prod.outlook.com (2603:10b6:5:186::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Tue, 6 Oct
 2020 14:49:29 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3433.045; Tue, 6 Oct 2020
 14:49:29 +0000
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
Subject: Re: [net-next v2 08/11] bridge: cfm: Netlink Notifications.
Thread-Topic: [net-next v2 08/11] bridge: cfm: Netlink Notifications.
Thread-Index: AQHWl94+AmT5Ryihjk618WTnpfqYqamKsAsA
Date:   Tue, 6 Oct 2020 14:49:29 +0000
Message-ID: <dbaa671103ebe049a93c14b47b8d0b8bf4b8b0f6.camel@nvidia.com>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
         <20201001103019.1342470-9-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201001103019.1342470-9-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: 628bf42a-e694-49f2-dd8b-08d86a07077a
x-ms-traffictypediagnostic: DM6PR12MB3291:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB32914C1BEA7DB5C07D72AE88DF0D0@DM6PR12MB3291.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YE0FPm8dYkdpTLs3T6CLWiRge/Nagnmam9vmwObNaySqXA4hhgOXlF/XYMeKtAh7orWaZ5B9Qws/nlgmshHgpjnf7ocrLrJcEOtElHou7dTIvf+4HpmIkoLpUv0fW1iP/x7mg36Zy/let288jKibbt+1qomJGGpf3FcYbjVT66NFcejdxTq0lQ8Z7uJt/x3RAeMkJI7qhcZL0/JF9p+5gB779vtsBtfIllnRQanDTGTPLAFKtUdOR1pxKImtVJY/Iz1ZrRWwNfB24+8Gd9dp0ZYNDm8SIEY/EvOx1NJDjsFppoyf6ugdiUgETicQPwFIkKLy4orCdLLlyEYFrbpUWNnMlKOdZwpf8bA34rbzMAYHojTpzLG63WlxuMi5JyAf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(4326008)(86362001)(36756003)(6512007)(2616005)(8936002)(8676002)(186003)(316002)(110136005)(83380400001)(5660300002)(3450700001)(6486002)(2906002)(478600001)(76116006)(91956017)(66556008)(6506007)(66476007)(66946007)(64756008)(66446008)(26005)(15650500001)(71200400001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hj4krW+r7bFuTV3CU56G6UUSx7OqxJs6Ina0jnn41kL6+Zw3PSfOnfXk+aAM92pv+lncH8w3fWMeoEt1ybW5PGf37XyEd9Z8MfPEP9xvgF1akDM9Cbe8hBrRqZUCtkOmPhsn7LoW1+JYkI66dQWRgfnkgicXi5Si5qGbusl77KvK1aqhS7PPUJijAih+xUycUgTFeb86q2489HhX60M8RQMuCtSZngFtJjIH8+6cO+V6c+U/B+OsHDj6icK0LKm4OR8ymjql6tdX3pE4ZICNtVCSivL56DyALcj72MhA2em7UPjwc0FgIU52WZU9J5mpTW7n/cwiCakNI9+OC9wGfoDZ28Y3tgjTuLdLMT6g9efwN0Xo/X2EzkGaGBB9ToJn3gM9OPwmt3Ii6PBRpx8cVecjozX1wbEB6Dp1i2uCPg50lhVj9fWwiB/8y79g0fo6jdmasKzcZUInr4rCERfGOr7Tal8z0VRGJtS59UoPvlWYJcJtcjfQJm25UIJa7PtbPni0hsnGEhwJto5//TtlNWTRxA0u11bxVDjsKPUwAbDhbIU8DaFUraTBEA5m66rf/nGQChUY0I5yVDRArGMumadB2b0RXq9f6kJ8rUn2qWWAotlpLiiDnmUfdxC5kxP/oZthzvczsfwBq0/CLGInCg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <133F3489D5A8C24F9522FFAFD958E7B1@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 628bf42a-e694-49f2-dd8b-08d86a07077a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2020 14:49:29.4653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7WbJEVPNc7kbt8Wq48o2ev5hlwXNMYT3wACCIRugr0hQEigpQt88ObR0uNksTQlhoJq7yowdHLF9z4HZen89Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3291
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601995773; bh=4vBXmcuCq084oKoeXiItqcAJ9fihgPlxAFVln8gd180=;
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
        b=BuJbKS20n1oz+k6lH49P1UPROgLkZGrATm91g9T0Vy7mecdUjV3gmj9YTUQYw9ETh
         VWuM40GXFflxFCG3eaDEFKW/8Tl0htxIAMgXCk+1VsJe8BMwpHUKyaM4+OoRhCnIpl
         vyugqr1tm4fbrzPNF68x5TXKxvTC9+dgMtUXxjR8Il5iVMcaBTk/fa14BhA9KVwlEF
         kccZGafwDCgFrvlTqRhqrPjvu8m9e2nN4RTkywi5sAMnMbORJINCQ5IWKnYxHFzq08
         SB2BnQga8uN8zv1PjsumqLXyDwbsD/1vsEN8jPAiT2cxm8RARZhkQpr3iYp5Xp+3U9
         9M8rFcpXd3pIA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTEwLTAxIGF0IDEwOjMwICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBpcyB0aGUgaW1wbGVtZW50YXRpb24gb2YgTmV0bGluayBub3RpZmljYXRpb25z
IG91dCBvZiBDRk0uDQo+IA0KPiBOb3RpZmljYXRpb25zIGFyZSBpbml0aWF0ZWQgd2hlbmV2ZXIg
YSBzdGF0ZSBjaGFuZ2UgaGFwcGVucyBpbiBDRk0uDQo+IA0KPiBJRkxBX0JSSURHRV9DRk06DQo+
ICAgICBQb2ludHMgdG8gdGhlIENGTSBpbmZvcm1hdGlvbi4NCj4gDQo+IElGTEFfQlJJREdFX0NG
TV9NRVBfU1RBVFVTX0lORk86DQo+ICAgICBUaGlzIGluZGljYXRlIHRoYXQgdGhlIE1FUCBpbnN0
YW5jZSBzdGF0dXMgYXJlIGZvbGxvd2luZy4NCj4gSUZMQV9CUklER0VfQ0ZNX0NDX1BFRVJfU1RB
VFVTX0lORk86DQo+ICAgICBUaGlzIGluZGljYXRlIHRoYXQgdGhlIHBlZXIgTUVQIHN0YXR1cyBh
cmUgZm9sbG93aW5nLg0KPiANCj4gQ0ZNIG5lc3RlZCBhdHRyaWJ1dGUgaGFzIHRoZSBmb2xsb3dp
bmcgYXR0cmlidXRlcyBpbiBuZXh0IGxldmVsLg0KPiANCj4gSUZMQV9CUklER0VfQ0ZNX01FUF9T
VEFUVVNfSU5TVEFOQ0U6DQo+ICAgICBUaGUgTUVQIGluc3RhbmNlIG51bWJlciBvZiB0aGUgZGVs
aXZlcmVkIHN0YXR1cy4NCj4gICAgIFRoZSB0eXBlIGlzIE5MQV9VMzIuDQo+IElGTEFfQlJJREdF
X0NGTV9NRVBfU1RBVFVTX09QQ09ERV9VTkVYUF9TRUVOOg0KPiAgICAgVGhlIE1FUCBpbnN0YW5j
ZSByZWNlaXZlZCBDRk0gUERVIHdpdGggdW5leHBlY3RlZCBPcGNvZGUuDQo+ICAgICBUaGUgdHlw
ZSBpcyBOTEFfVTMyIChib29sKS4NCj4gSUZMQV9CUklER0VfQ0ZNX01FUF9TVEFUVVNfVkVSU0lP
Tl9VTkVYUF9TRUVOOg0KPiAgICAgVGhlIE1FUCBpbnN0YW5jZSByZWNlaXZlZCBDRk0gUERVIHdp
dGggdW5leHBlY3RlZCB2ZXJzaW9uLg0KPiAgICAgVGhlIHR5cGUgaXMgTkxBX1UzMiAoYm9vbCku
DQo+IElGTEFfQlJJREdFX0NGTV9NRVBfU1RBVFVTX1JYX0xFVkVMX0xPV19TRUVOOg0KPiAgICAg
VGhlIE1FUCBpbnN0YW5jZSByZWNlaXZlZCBDQ00gUERVIHdpdGggTUQgbGV2ZWwgbG93ZXIgdGhh
bg0KPiAgICAgY29uZmlndXJlZCBsZXZlbC4gVGhpcyBmcmFtZSBpcyBkaXNjYXJkZWQuDQo+ICAg
ICBUaGUgdHlwZSBpcyBOTEFfVTMyIChib29sKS4NCj4gDQo+IElGTEFfQlJJREdFX0NGTV9DQ19Q
RUVSX1NUQVRVU19JTlNUQU5DRToNCj4gICAgIFRoZSBNRVAgaW5zdGFuY2UgbnVtYmVyIG9mIHRo
ZSBkZWxpdmVyZWQgc3RhdHVzLg0KPiAgICAgVGhlIHR5cGUgaXMgTkxBX1UzMi4NCj4gSUZMQV9C
UklER0VfQ0ZNX0NDX1BFRVJfU1RBVFVTX1BFRVJfTUVQSUQ6DQo+ICAgICBUaGUgYWRkZWQgUGVl
ciBNRVAgSUQgb2YgdGhlIGRlbGl2ZXJlZCBzdGF0dXMuDQo+ICAgICBUaGUgdHlwZSBpcyBOTEFf
VTMyLg0KPiBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9TVEFUVVNfQ0NNX0RFRkVDVDoNCj4gICAg
IFRoZSBDQ00gZGVmZWN0IHN0YXR1cy4NCj4gICAgIFRoZSB0eXBlIGlzIE5MQV9VMzIgKGJvb2wp
Lg0KPiAgICAgVHJ1ZSBtZWFucyBubyBDQ00gZnJhbWUgaXMgcmVjZWl2ZWQgZm9yIDMuMjUgaW50
ZXJ2YWxzLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX0NPTkZJR19FWFBfSU5URVJWQUwuDQo+
IElGTEFfQlJJREdFX0NGTV9DQ19QRUVSX1NUQVRVU19SREk6DQo+ICAgICBUaGUgbGFzdCByZWNl
aXZlZCBDQ00gUERVIFJESS4NCj4gICAgIFRoZSB0eXBlIGlzIE5MQV9VMzIgKGJvb2wpLg0KPiBJ
RkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9TVEFUVVNfUE9SVF9UTFZfVkFMVUU6DQo+ICAgICBUaGUg
bGFzdCByZWNlaXZlZCBDQ00gUERVIFBvcnQgU3RhdHVzIFRMViB2YWx1ZSBmaWVsZC4NCj4gICAg
IFRoZSB0eXBlIGlzIE5MQV9VOC4NCj4gSUZMQV9CUklER0VfQ0ZNX0NDX1BFRVJfU1RBVFVTX0lG
X1RMVl9WQUxVRToNCj4gICAgIFRoZSBsYXN0IHJlY2VpdmVkIENDTSBQRFUgSW50ZXJmYWNlIFN0
YXR1cyBUTFYgdmFsdWUgZmllbGQuDQo+ICAgICBUaGUgdHlwZSBpcyBOTEFfVTguDQo+IElGTEFf
QlJJREdFX0NGTV9DQ19QRUVSX1NUQVRVU19TRUVOOg0KPiAgICAgQSBDQ00gZnJhbWUgaGFzIGJl
ZW4gcmVjZWl2ZWQgZnJvbSBQZWVyIE1FUC4NCj4gICAgIFRoZSB0eXBlIGlzIE5MQV9VMzIgKGJv
b2wpLg0KPiAgICAgVGhpcyBpcyBjbGVhcmVkIGFmdGVyIEdFVExJTksgSUZMQV9CUklER0VfQ0ZN
X0NDX1BFRVJfU1RBVFVTX0lORk8uDQo+IElGTEFfQlJJREdFX0NGTV9DQ19QRUVSX1NUQVRVU19U
TFZfU0VFTjoNCj4gICAgIEEgQ0NNIGZyYW1lIHdpdGggVExWIGhhcyBiZWVuIHJlY2VpdmVkIGZy
b20gUGVlciBNRVAuDQo+ICAgICBUaGUgdHlwZSBpcyBOTEFfVTMyIChib29sKS4NCj4gICAgIFRo
aXMgaXMgY2xlYXJlZCBhZnRlciBHRVRMSU5LIElGTEFfQlJJREdFX0NGTV9DQ19QRUVSX1NUQVRV
U19JTkZPLg0KPiBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9TVEFUVVNfU0VRX1VORVhQX1NFRU46
DQo+ICAgICBBIENDTSBmcmFtZSB3aXRoIHVuZXhwZWN0ZWQgc2VxdWVuY2UgbnVtYmVyIGhhcyBi
ZWVuIHJlY2VpdmVkDQo+ICAgICBmcm9tIFBlZXIgTUVQLg0KPiAgICAgVGhlIHR5cGUgaXMgTkxB
X1UzMiAoYm9vbCkuDQo+ICAgICBXaGVuIGEgc2VxdWVuY2UgbnVtYmVyIGlzIG5vdCBvbmUgaGln
aGVyIHRoYW4gcHJldmlvdXNseSByZWNlaXZlZA0KPiAgICAgdGhlbiBpdCBpcyB1bmV4cGVjdGVk
Lg0KPiAgICAgVGhpcyBpcyBjbGVhcmVkIGFmdGVyIEdFVExJTksgSUZMQV9CUklER0VfQ0ZNX0ND
X1BFRVJfU1RBVFVTX0lORk8uDQo+IA0KPiBSZXZpZXdlZC1ieTogSG9yYXRpdSBWdWx0dXIgIDxo
b3JhdGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBIZW5yaWsgQmpv
ZXJubHVuZCAgPGhlbnJpay5iam9lcm5sdW5kQG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0KPiAgbmV0
L2JyaWRnZS9icl9jZm0uYyAgICAgICAgIHwgNDggKysrKysrKysrKysrKysrKysrKysrKysrDQo+
ICBuZXQvYnJpZGdlL2JyX2NmbV9uZXRsaW5rLmMgfCAyNyArKysrKysrKystLS0tLQ0KPiAgbmV0
L2JyaWRnZS9icl9uZXRsaW5rLmMgICAgIHwgNzMgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKystLS0tLQ0KPiAgbmV0L2JyaWRnZS9icl9wcml2YXRlLmggICAgIHwgMjIgKysrKysrKysr
Ky0NCj4gIDQgZmlsZXMgY2hhbmdlZCwgMTQ4IGluc2VydGlvbnMoKyksIDIyIGRlbGV0aW9ucygt
KQ0KPiANCltzbmlwXQ0KPiAgCXJldHVybiAhaGxpc3RfZW1wdHkoJmJyLT5tZXBfbGlzdCk7DQo+
IGRpZmYgLS1naXQgYS9uZXQvYnJpZGdlL2JyX2NmbV9uZXRsaW5rLmMgYi9uZXQvYnJpZGdlL2Jy
X2NmbV9uZXRsaW5rLmMNCj4gaW5kZXggN2JkZjg5MGI4Y2NjLi41ZjgxMjYyYzljYWEgMTAwNjQ0
DQo+IC0tLSBhL25ldC9icmlkZ2UvYnJfY2ZtX25ldGxpbmsuYw0KPiArKysgYi9uZXQvYnJpZGdl
L2JyX2NmbV9uZXRsaW5rLmMNCj4gQEAgLTMyNSw4ICszMjUsOCBAQCBzdGF0aWMgaW50IGJyX2Nj
X2NjbV90eF9wYXJzZShzdHJ1Y3QgbmV0X2JyaWRnZSAqYnIsIHN0cnVjdCBubGF0dHIgKmF0dHIs
DQo+ICAJCQkgICAgICBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spDQo+ICB7DQo+ICAJ
c3RydWN0IG5sYXR0ciAqdGJbSUZMQV9CUklER0VfQ0ZNX0NDX0NDTV9UWF9NQVggKyAxXTsNCj4g
LQl1MzIgaW5zdGFuY2U7DQo+ICAJc3RydWN0IGJyX2NmbV9jY19jY21fdHhfaW5mbyB0eF9pbmZv
Ow0KPiArCXUzMiBpbnN0YW5jZTsNCj4gIAlpbnQgZXJyOw0KDQpUaGlzIGh1bmsgaXMgdW5uZWNl
c3NhcnkgYXMgaXQncyBuZXcgY29kZSBhZGRlZCBieSB0aGlzIHNldCwganVzdCBhZGQgaXQNCmNv
cnJlY3RseSBpbiB0aGUgZmlyc3QgcGxhY2UgYW5kIGRyb3AgdGhpcyBjaGFuZ2UuDQoNClRoYW5r
cywNCiBOaWsNCg==
