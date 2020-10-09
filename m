Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0F7289B61
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 00:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389489AbgJIWA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 18:00:27 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:3413 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731745AbgJIWA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 18:00:27 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80dd770000>; Sat, 10 Oct 2020 06:00:23 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 22:00:23 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 22:00:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKp9djUTzqTd3Q7AcLVAbplxzLrxwbtsLWzofer7spknHYp2QSpLqJyznC3HykGuUt9buwa60DK342XxG8DF3R6KfYZBIiQMqyRZlMBd5oigLzhvztctdBrkCowgKyJbxfDubjFvGYhzVF3URDDT/GWbHTFi/gj4Ui96TCKHsFSOtuFB70sU43wUkzKJg6PbLUEj4xTfdF6db8BEgh/+mzTfTm/7hMEn50P9RYQz/eWc/zalRp4trQJs5qHGM9c7X/tulTOZe2MHCGbu0LGM/O/020a7C0bgnRqC6gAlZ+LiMmicezfc/j79xJVBzbh5id43KNQyayJmppWcJXUVUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmVbzwDdvo/1X4J0qtOg2dc8aBFBhEbpiYW7fihYZAE=;
 b=bnS19EzjEDAxjwXFvbQ8Nak/fySdBTSZ//N/Q4w5ybz6kmY4oPbEeCDw3dBwBR9cKakhzhV7SrLys4dDLBYj6j0l6SZvgjlrEbUp22HNMq/8QNvqVHGteEVu5NxaxLRDoU7y1a/KNCagfNPeVeqnsku8DixHBGEphPQBBwYfFRrx9AeKf8sdhE27ntrTYz5+Or5pCIep+CgRfGOibr92j2/HqF0IADYLLPmgpzKOY+ku/qWp9Yiv9ZHR6HYl5ws7IjrbV1eSl0GxTx1DxT6yc1LL97T+gEn804vB1XKEUWKWyG0Q0/ijOV70ZN1j77ljKB5RswBR8kQ1Yl1BD1qWOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM5PR1201MB0042.namprd12.prod.outlook.com (2603:10b6:4:50::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 9 Oct
 2020 22:00:20 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.027; Fri, 9 Oct 2020
 22:00:20 +0000
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
Subject: Re: [PATCH net-next v4 09/10] bridge: cfm: Netlink GET status
 Interface.
Thread-Topic: [PATCH net-next v4 09/10] bridge: cfm: Netlink GET status
 Interface.
Thread-Index: AQHWnkngJwVyFwyLWUCn23gd8BxQlKmP0pOA
Date:   Fri, 9 Oct 2020 22:00:20 +0000
Message-ID: <9248a20233893a46747f3c5c867f5f0db18eb69d.camel@nvidia.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
         <20201009143530.2438738-10-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201009143530.2438738-10-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: 2fad0f78-d780-407b-d3bd-08d86c9eb6e9
x-ms-traffictypediagnostic: DM5PR1201MB0042:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB0042085880656D9F9D1852A9DF080@DM5PR1201MB0042.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ORQXsQPD9EYVDCuR3E8xr/zGmEn2kGhZm9zJgThYNaOd8TmYvZqpjCh8s0eu+fdHN+5qILWeX+UjOOrQJ9Am433atlMxvwJUj5i0LQSeywI14TlLBTge9XXSVozuSiA2exfZacDyZwFqwtXmyjQmSQ2V5VuHzZAb6Qisuz1a6d5R+zBN+hh9NeZQd6PSbVxAB35XKU0SGtmOnJpMfMxUqNdNBo7r7yH8QGNwu+VNMqP/kB0joia0wF3B/tT8D/6O6qPngBU/jRAehr3hpMzZbyvHm07FftJ/JnyIGcR9UiXpZyAQfzN+gKrEHrHt3twEd/DfV+bT400C0t5HReVNPY1orIBTemdFTvGvvkPuh9Gs26rwFRk9IX+rks5D73ta
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(2906002)(66556008)(91956017)(66946007)(86362001)(6512007)(66476007)(64756008)(26005)(478600001)(83380400001)(316002)(8936002)(36756003)(5660300002)(186003)(110136005)(66446008)(6486002)(6506007)(76116006)(2616005)(8676002)(71200400001)(3450700001)(4326008)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: N9VeL7lOEZh6JtFVRpGQMGGiNE07dQyBN9fzAiYX4Jo6FL+V+ZZAC9YRTdMUSNVSQq/l5PxG7z8TJytBKTrVpIwV9eLR2ynpRObxdh/UX2NohnF3hk/FbUHneybYkPhrqJ8FdskkzI5jVaV2EnOwrgm5M/f8qxADXqzmXtSSLCoCO/Bj8qLCq1IJL9xIReUno4JWa/eXymymJDfhPI7ksKPeqRnYc7QMnojMg/qsgj0bAtiYslPuLfuP6/oCJA95lRDxgivcw0yl4j9t1FlHWQ/bFTT2/uJERgY8VUB26BXGVlLFOQ1pbTf4QL3jAulH5QSgKX3M/6Fh90EtGgypUU+tBjyH44dGWUp3Bx7cb2BZhWUdfIxCT2HPqWZg24Nq4NbJuQLoj9S3+o9KkUSXLzncLp45qZhYcqQfz8OFHM26WExGufSil5ccQZcn1Zdtngq7fMnnDlgW+dws/z+GHapLl1ob04w3R3Q4JzUJ2KqpwvCs6/pUuSdcUoYM/+GpAcFZplZYTeJZ+K4eW8wPZpJ3V5bwMOqwt/lL2Tn5lt45VwsgSjj8aSKFFNcweYyNpAaEFqkCdLYkM9JIl7/vmP4+2zEUC+aBAz3jF7Z07SlMn90xle3rnnfBbJGt76rF3oh2tAajLUQ44g8jQqtBOA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3C8F21140C9B04EBE7FB3DA1ED9983C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fad0f78-d780-407b-d3bd-08d86c9eb6e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 22:00:20.0506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YUVmwANvesM2Rh2PvDa1901sCsBRPeW77ylgumsuGVDZWDT5X0X32Xj2UwdQNrU2pUjlgm3pdCPwiJEe40DrMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0042
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602280823; bh=HmVbzwDdvo/1X4J0qtOg2dc8aBFBhEbpiYW7fihYZAE=;
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
        b=dYOZgPQk8b7kQAOQKLZ+3zYmv8w+h5t2iE+bUXeyyFxxJoVjMeOz9r6i9lzNucK6C
         nnl2X+73sq9lzOa63hx3P14tFoP+4mspf8XPw+1lgGjcY3WRjPAKyp6qoflaRVdB0n
         1w8E9xCp9kxGH7arhVhemEKf01toJH27y/2dggnpeaTlxY3NHJSpza0U/o+PuUXK83
         8Dw3rXZSpIbC4WDSPA0pCGS35kns0pUcoNAhDMojiv8asNO3Tz3D85mzBjTMeYvL4j
         sWvzkBWXfqPckcMPE23nsIvyrq+UtXZdMu7XYslxUYEAocxHeA0QJtS6EoGf4XiXNu
         aelmzm5y2XJ3g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE0OjM1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBpcyB0aGUgaW1wbGVtZW50YXRpb24gb2YgQ0ZNIG5ldGxpbmsgc3RhdHVzDQo+
IGdldCBpbmZvcm1hdGlvbiBpbnRlcmZhY2UuDQo+IA0KPiBBZGQgbmV3IG5lc3RlZCBuZXRsaW5r
IGF0dHJpYnV0ZXMuIFRoZXNlIGF0dHJpYnV0ZXMgYXJlIHVzZWQgYnkgdGhlDQo+IHVzZXIgc3Bh
Y2UgdG8gZ2V0IHN0YXR1cyBpbmZvcm1hdGlvbi4NCj4gDQo+IEdFVExJTks6DQo+ICAgICBSZXF1
ZXN0IGZpbHRlciBSVEVYVF9GSUxURVJfQ0ZNX1NUQVRVUzoNCj4gICAgIEluZGljYXRpbmcgdGhh
dCBDRk0gc3RhdHVzIGluZm9ybWF0aW9uIG11c3QgYmUgZGVsaXZlcmVkLg0KPiANCj4gICAgIElG
TEFfQlJJREdFX0NGTToNCj4gICAgICAgICBQb2ludHMgdG8gdGhlIENGTSBpbmZvcm1hdGlvbi4N
Cj4gDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX1NUQVRVU19JTkZPOg0KPiAgICAgICAgIFRo
aXMgaW5kaWNhdGUgdGhhdCB0aGUgTUVQIGluc3RhbmNlIHN0YXR1cyBhcmUgZm9sbG93aW5nLg0K
PiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX1BFRVJfU1RBVFVTX0lORk86DQo+ICAgICAgICAgVGhp
cyBpbmRpY2F0ZSB0aGF0IHRoZSBwZWVyIE1FUCBzdGF0dXMgYXJlIGZvbGxvd2luZy4NCj4gDQo+
IENGTSBuZXN0ZWQgYXR0cmlidXRlIGhhcyB0aGUgZm9sbG93aW5nIGF0dHJpYnV0ZXMgaW4gbmV4
dCBsZXZlbC4NCj4gDQo+IEdFVExJTksgUlRFWFRfRklMVEVSX0NGTV9TVEFUVVM6DQo+ICAgICBJ
RkxBX0JSSURHRV9DRk1fTUVQX1NUQVRVU19JTlNUQU5DRToNCj4gICAgICAgICBUaGUgTUVQIGlu
c3RhbmNlIG51bWJlciBvZiB0aGUgZGVsaXZlcmVkIHN0YXR1cy4NCj4gICAgICAgICBUaGUgdHlw
ZSBpcyB1MzIuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX1NUQVRVU19PUENPREVfVU5FWFBf
U0VFTjoNCj4gICAgICAgICBUaGUgTUVQIGluc3RhbmNlIHJlY2VpdmVkIENGTSBQRFUgd2l0aCB1
bmV4cGVjdGVkIE9wY29kZS4NCj4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIgKGJvb2wpLg0KPiAg
ICAgSUZMQV9CUklER0VfQ0ZNX01FUF9TVEFUVVNfVkVSU0lPTl9VTkVYUF9TRUVOOg0KPiAgICAg
ICAgIFRoZSBNRVAgaW5zdGFuY2UgcmVjZWl2ZWQgQ0ZNIFBEVSB3aXRoIHVuZXhwZWN0ZWQgdmVy
c2lvbi4NCj4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIgKGJvb2wpLg0KPiAgICAgSUZMQV9CUklE
R0VfQ0ZNX01FUF9TVEFUVVNfUlhfTEVWRUxfTE9XX1NFRU46DQo+ICAgICAgICAgVGhlIE1FUCBp
bnN0YW5jZSByZWNlaXZlZCBDQ00gUERVIHdpdGggTUQgbGV2ZWwgbG93ZXIgdGhhbg0KPiAgICAg
ICAgIGNvbmZpZ3VyZWQgbGV2ZWwuIFRoaXMgZnJhbWUgaXMgZGlzY2FyZGVkLg0KPiAgICAgICAg
IFRoZSB0eXBlIGlzIHUzMiAoYm9vbCkuDQo+IA0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX1BF
RVJfU1RBVFVTX0lOU1RBTkNFOg0KPiAgICAgICAgIFRoZSBNRVAgaW5zdGFuY2UgbnVtYmVyIG9m
IHRoZSBkZWxpdmVyZWQgc3RhdHVzLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMi4NCj4gICAg
IElGTEFfQlJJREdFX0NGTV9DQ19QRUVSX1NUQVRVU19QRUVSX01FUElEOg0KPiAgICAgICAgIFRo
ZSBhZGRlZCBQZWVyIE1FUCBJRCBvZiB0aGUgZGVsaXZlcmVkIHN0YXR1cy4NCj4gICAgICAgICBU
aGUgdHlwZSBpcyB1MzIuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9TVEFUVVNfQ0NN
X0RFRkVDVDoNCj4gICAgICAgICBUaGUgQ0NNIGRlZmVjdCBzdGF0dXMuDQo+ICAgICAgICAgVGhl
IHR5cGUgaXMgdTMyIChib29sKS4NCj4gICAgICAgICBUcnVlIG1lYW5zIG5vIENDTSBmcmFtZSBp
cyByZWNlaXZlZCBmb3IgMy4yNSBpbnRlcnZhbHMuDQo+ICAgICAgICAgSUZMQV9CUklER0VfQ0ZN
X0NDX0NPTkZJR19FWFBfSU5URVJWQUwuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9T
VEFUVVNfUkRJOg0KPiAgICAgICAgIFRoZSBsYXN0IHJlY2VpdmVkIENDTSBQRFUgUkRJLg0KPiAg
ICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoYm9vbCkuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0Nf
UEVFUl9TVEFUVVNfUE9SVF9UTFZfVkFMVUU6DQo+ICAgICAgICAgVGhlIGxhc3QgcmVjZWl2ZWQg
Q0NNIFBEVSBQb3J0IFN0YXR1cyBUTFYgdmFsdWUgZmllbGQuDQo+ICAgICAgICAgVGhlIHR5cGUg
aXMgdTguDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9TVEFUVVNfSUZfVExWX1ZBTFVF
Og0KPiAgICAgICAgIFRoZSBsYXN0IHJlY2VpdmVkIENDTSBQRFUgSW50ZXJmYWNlIFN0YXR1cyBU
TFYgdmFsdWUgZmllbGQuDQo+ICAgICAgICAgVGhlIHR5cGUgaXMgdTguDQo+ICAgICBJRkxBX0JS
SURHRV9DRk1fQ0NfUEVFUl9TVEFUVVNfU0VFTjoNCj4gICAgICAgICBBIENDTSBmcmFtZSBoYXMg
YmVlbiByZWNlaXZlZCBmcm9tIFBlZXIgTUVQLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAo
Ym9vbCkuDQo+ICAgICAgICAgVGhpcyBpcyBjbGVhcmVkIGFmdGVyIEdFVExJTksgSUZMQV9CUklE
R0VfQ0ZNX0NDX1BFRVJfU1RBVFVTX0lORk8uDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfUEVF
Ul9TVEFUVVNfVExWX1NFRU46DQo+ICAgICAgICAgQSBDQ00gZnJhbWUgd2l0aCBUTFYgaGFzIGJl
ZW4gcmVjZWl2ZWQgZnJvbSBQZWVyIE1FUC4NCj4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIgKGJv
b2wpLg0KPiAgICAgICAgIFRoaXMgaXMgY2xlYXJlZCBhZnRlciBHRVRMSU5LIElGTEFfQlJJREdF
X0NGTV9DQ19QRUVSX1NUQVRVU19JTkZPLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX1BFRVJf
U1RBVFVTX1NFUV9VTkVYUF9TRUVOOg0KPiAgICAgICAgIEEgQ0NNIGZyYW1lIHdpdGggdW5leHBl
Y3RlZCBzZXF1ZW5jZSBudW1iZXIgaGFzIGJlZW4gcmVjZWl2ZWQNCj4gICAgICAgICBmcm9tIFBl
ZXIgTUVQLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoYm9vbCkuDQo+ICAgICAgICAgV2hl
biBhIHNlcXVlbmNlIG51bWJlciBpcyBub3Qgb25lIGhpZ2hlciB0aGFuIHByZXZpb3VzbHkgcmVj
ZWl2ZWQNCj4gICAgICAgICB0aGVuIGl0IGlzIHVuZXhwZWN0ZWQuDQo+ICAgICAgICAgVGhpcyBp
cyBjbGVhcmVkIGFmdGVyIEdFVExJTksgSUZMQV9CUklER0VfQ0ZNX0NDX1BFRVJfU1RBVFVTX0lO
Rk8uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIZW5yaWsgQmpvZXJubHVuZCAgPGhlbnJpay5iam9l
cm5sdW5kQG1pY3JvY2hpcC5jb20+DQo+IFJldmlld2VkLWJ5OiBIb3JhdGl1IFZ1bHR1ciAgPGhv
cmF0aXUudnVsdHVyQG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0KPiAgaW5jbHVkZS91YXBpL2xpbnV4
L2lmX2JyaWRnZS5oIHwgIDI5ICsrKysrKysrKw0KPiAgaW5jbHVkZS91YXBpL2xpbnV4L3J0bmV0
bGluay5oIHwgICAxICsNCj4gIG5ldC9icmlkZ2UvYnJfY2ZtX25ldGxpbmsuYyAgICB8IDEwNSAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIG5ldC9icmlkZ2UvYnJfbmV0bGlu
ay5jICAgICAgICB8ICAxNiArKysrLQ0KPiAgbmV0L2JyaWRnZS9icl9wcml2YXRlLmggICAgICAg
IHwgICA2ICsrDQo+ICA1IGZpbGVzIGNoYW5nZWQsIDE1NCBpbnNlcnRpb25zKCspLCAzIGRlbGV0
aW9ucygtKQ0KPiANCltzbmlwXQ0KPiBkaWZmIC0tZ2l0IGEvbmV0L2JyaWRnZS9icl9jZm1fbmV0
bGluay5jIGIvbmV0L2JyaWRnZS9icl9jZm1fbmV0bGluay5jDQo+IGluZGV4IDk1MmI2MzcyODc0
ZS4uOTRlOWI0NmQ1ZmI0IDEwMDY0NA0KPiAtLS0gYS9uZXQvYnJpZGdlL2JyX2NmbV9uZXRsaW5r
LmMNCj4gKysrIGIvbmV0L2JyaWRnZS9icl9jZm1fbmV0bGluay5jDQo+IEBAIC02MTcsMyArNjE3
LDEwOCBAQCBpbnQgYnJfY2ZtX2NvbmZpZ19maWxsX2luZm8oc3RydWN0IHNrX2J1ZmYgKnNrYiwg
c3RydWN0IG5ldF9icmlkZ2UgKmJyKQ0KPiAgbmxhX2luZm9fZmFpbHVyZToNCj4gIAlyZXR1cm4g
LUVNU0dTSVpFOw0KPiAgfQ0KPiArDQo+ICtpbnQgYnJfY2ZtX3N0YXR1c19maWxsX2luZm8oc3Ry
dWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9icmlkZ2UgKmJyKQ0KPiArew0KPiArCXN0cnVj
dCBubGF0dHIgKnRiOw0KPiArCXN0cnVjdCBicl9jZm1fbWVwICptZXA7DQo+ICsJc3RydWN0IGJy
X2NmbV9wZWVyX21lcCAqcGVlcl9tZXA7DQo+ICsNCj4gDQoNClJldmVyc2UgeG1hcyB0cmVlIGhl
cmUsIHRvby4gU29ycnkgSSBtaXNzZWQgdGhlc2UgZWFybGllci4NCg0KDQo=
