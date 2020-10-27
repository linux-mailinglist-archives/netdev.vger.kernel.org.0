Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333D429B536
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 16:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793985AbgJ0PJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 11:09:34 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:41560 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793968AbgJ0PJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 11:09:32 -0400
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f98382a0000>; Tue, 27 Oct 2020 23:09:30 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 27 Oct
 2020 15:09:30 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 27 Oct 2020 15:09:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AeuMOSZaEmXcWUNajoM2D5Ak1iRcVT+jMC9FSzGulISa9tfgCcs3I7TWhRZ5EkLD1cpCa/sKJS2jp2unAnlDwPC7GsbIVeLKmQ0EgvbezxZpOpJQxh9JIwVypORu9R1qsJEugTOFkqLXWiFF9Q/CqlqTlFnRAJEg4ARB4Enjd+N417F0mGRn49PgaQJfYNr2M8TNBityKMz+mxR1LxeUlG2I+7Qb8mFSCTyYdcZ5BhiX59QGcB9wH8L/qomXYlpDxA5jES+1PLxlDjiWtJmoqFE/9yX4NyFXnhmnPNr3VNBzkv1N5CIaakjZtFwqMqp+ds4Cfc43QvsdqqkikegH9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIn8VrD8UlH+41e59jfyfdchwtN6vO0NxG3TV3AXGr0=;
 b=XbDdjoi7DyQm5/9khM8DVYlCApyg+kA5CRU+2TlAVMltpsPcW8F52SOB0pmmiMUdPWDq94DeseUFS+5DCcgmvTKvoDC4W5WQKr38cbV0vOICW4MrwYPuYp295BkxYUCDqBCnYIZ8M++lLVw3M6vrIihYkwnIyzmnxBa4+EnGIJld1kn/R7wxLlSRBkeWeBxKzvPjS1e0Fh7DpSl5xN7/68cZRzlypv89eta/F/zcqgv7+hSxtyd8LHD1yu3WnOfbui1lepEfJYAvYsCGU055BLVG9iXFNxy5pWxK1zAXd2O1EQW5KEOvPvdKx1pQSR4kiCYn2QaxJWQaM9qda4QgxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BN6PR12MB1233.namprd12.prod.outlook.com (2603:10b6:404:1c::19)
 by BN6PR12MB1169.namprd12.prod.outlook.com (2603:10b6:404:19::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Tue, 27 Oct
 2020 15:09:27 +0000
Received: from BN6PR12MB1233.namprd12.prod.outlook.com
 ([fe80::f54d:4b1b:ab07:3c7c]) by BN6PR12MB1233.namprd12.prod.outlook.com
 ([fe80::f54d:4b1b:ab07:3c7c%3]) with mapi id 15.20.3499.018; Tue, 27 Oct 2020
 15:09:27 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
CC:     "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [Bridge] [PATCH net-next v7 01/10] net: bridge: extend the
 process of special frames
Thread-Topic: [Bridge] [PATCH net-next v7 01/10] net: bridge: extend the
 process of special frames
Thread-Index: AQHWrEiTHFOtz3I0z0mO5e+ZWh3Ohqmriu+AgAAC0IA=
Date:   Tue, 27 Oct 2020 15:09:27 +0000
Message-ID: <0dd2e57a61d618984648a3bf6373728f61a8fecf.camel@nvidia.com>
References: <20201027100251.3241719-1-henrik.bjoernlund@microchip.com>
         <20201027100251.3241719-2-henrik.bjoernlund@microchip.com>
         <20201027075921.69976131@hermes.local>
In-Reply-To: <20201027075921.69976131@hermes.local>
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
x-ms-office365-filtering-correlation-id: b8c5630f-2d53-484e-01d8-08d87a8a4c34
x-ms-traffictypediagnostic: BN6PR12MB1169:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR12MB1169A3F9401761002FCEFFBEDF160@BN6PR12MB1169.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i2knvIyondZ1RWdRpeX8lu6vQ1Iyx8mjr5ODSzOxx+4eXZ9o62PziwUfzxaB6QyZYQlvSOja6VbDRvUKujttSHNcdGqklC1cOqTcKJzmlrsGP6QnvNohHmsIPndtCkLH/IbgSDkJOJvwSZNVtWBEKE2GEmfZ+xolAKDGRgQkwB8kLnpz91RJ4MWHLXPYjocppp3fcI94sYRwfHUIzERAZwQzxERL2xGTlqzQE/h6GjGl74B04B2fnGSa0xPZaXjk/Qk68CemGQiUqqJtOjOcp5zQmO/RrZ9XlmpYEFqK46bTTXvbjl1v0iBhV0q5i8JPljp+tDa1s2QBZAwLhxgzLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR12MB1233.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(4326008)(36756003)(64756008)(76116006)(91956017)(66476007)(66556008)(4001150100001)(66946007)(6486002)(478600001)(2616005)(86362001)(186003)(110136005)(83380400001)(66446008)(2906002)(54906003)(8936002)(26005)(6506007)(3450700001)(8676002)(71200400001)(5660300002)(316002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: no71zb2hEupoeCzK+eG3B1MxmdFNLOf3w0cPeQCToUS7B3r3Nm7zUbg1k7dKKvfmBrvsAl0pvgjVDs0yhNlLdFhg4DWIu7hCaVG/fzFGC3r4HXpMqud9IyR4lcMR51ViV8CScIL8ZMXKci2eyCvzSROOuHbc72sFVKAG9j+oa/vWzV3kApK2O41m52I1Bsxnaynpt6tf2Y7dynta2bAp+nPJRZg20b99skVdSe47wKegL0zhFjebZ+YfkmpwN9sRStiUd34DFbXAFYj6sDPxcdDi+UK9IhV0vz7I3Ub1e+HyE7j4oQAOLHQoizmawpPxuRXAwEybLk7A1gC1HXkrr94d3yxJyjAc+aabDz6tKtuq1vUo1K99NP715WEFmJXfTOnnLaBPTKiATjYfp/yPhuUg7Y7Xg+7RQaG73H2suLOMK/i8FN5W7XVqDon/fN+sGKhr0zmKOQU/8THla5GSP6p4+trZRtQu0YOf7vy30f8wX8OUp+RVSMo/p5kW0OVcVwNgqrikW5obUhZgbTTCgjM32D15hQhgJwdH59RS1gmw6EljfTM+L2uNx8O8OGYSe9691n6RlM+KF9ahMk179NYe67Cf+4aC/NGufyr5yvd3K8mvJkyarWav4xMWcNCL9C4FlhiRda7dRfmKBuFleQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2187ED1B5E62F40AD7D297CDD0A739F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR12MB1233.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c5630f-2d53-484e-01d8-08d87a8a4c34
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 15:09:27.3108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ud+L8bJ5gzbHUyAfxLnNkfrPS5dw4w5WaPLKSi7UqQUSC/7VLNiy2eybXaigTYQWeBr75+wbLry6lun4i1vMwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1169
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603811370; bh=lIn8VrD8UlH+41e59jfyfdchwtN6vO0NxG3TV3AXGr0=;
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
        b=j/u/YQq7N9OFY1Hi4vw1Iwpk6Q9kn67s5uU/j/dRQU3jIhbOE55akcKgUz+MN0ifV
         pwtsm1joq6kzk/5mnzPttBTIdnFR24FKLFMSANQhziJ8WpmvFEfkcR4YV79zsg89hZ
         DDG7Jn1RPPG38nXH0WGwM+tpMR1p2WqYbX/i1WmFPxPPSxU70wdf6FY5YHOvizMFOP
         qfxbXSxldr/sJzV64WhOudq5BUXajGpkPRasmsoXG/jZhUPsUx7sW/e6K0nBsqKI8o
         NA5/nIJSSRPW1Ic8Za5RPUKgr1mgRlTfhvYJRtPEvUrP0xUVDz8/k0tPIhmPuz30GH
         oy8nrBRsIhprQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTEwLTI3IGF0IDA3OjU5IC0wNzAwLCBTdGVwaGVuIEhlbW1pbmdlciB3cm90
ZToNCj4gT24gVHVlLCAyNyBPY3QgMjAyMCAxMDowMjo0MiArMDAwMA0KPiBIZW5yaWsgQmpvZXJu
bHVuZCB2aWEgQnJpZGdlIDxicmlkZ2VAbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmc+IHdyb3Rl
Og0KPiANCj4gPiArLyogUmV0dXJuIDAgaWYgdGhlIGZyYW1lIHdhcyBub3QgcHJvY2Vzc2VkIG90
aGVyd2lzZSAxDQo+ID4gKyAqIG5vdGU6IGFscmVhZHkgY2FsbGVkIHdpdGggcmN1X3JlYWRfbG9j
aw0KPiA+ICsgKi8NCj4gPiArc3RhdGljIGludCBicl9wcm9jZXNzX2ZyYW1lX3R5cGUoc3RydWN0
IG5ldF9icmlkZ2VfcG9ydCAqcCwNCj4gPiArCQkJCSBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiA+
ICt7DQo+ID4gKwlzdHJ1Y3QgYnJfZnJhbWVfdHlwZSAqdG1wOw0KPiA+ICsNCj4gPiArCWhsaXN0
X2Zvcl9lYWNoX2VudHJ5X3JjdSh0bXAsICZwLT5ici0+ZnJhbWVfdHlwZV9saXN0LCBsaXN0KQ0K
PiA+ICsJCWlmICh1bmxpa2VseSh0bXAtPnR5cGUgPT0gc2tiLT5wcm90b2NvbCkpDQo+ID4gKwkJ
CXJldHVybiB0bXAtPmZyYW1lX2hhbmRsZXIocCwgc2tiKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4g
MDsNCj4gPiArfQ0KPiANCj4gRG9lcyB0aGUgbGluZWFyIHNlYXJjaCBvZiBmcmFtZSB0eXBlcyBo
YXZlIG5vdGljYWJsZSBpbXBhY3Qgb24gcGVyZm9ybWFuY2U/DQo+IEhpbnQ6IG1heWJlIGEgYml0
bWFwIG9yIHNvbWV0aGluZyB3b3VsZCBiZSBmYXN0ZXIuDQoNCkkgZG9uJ3QgdGhpbmsgaXQncyBu
ZWNlc3NhcnkgdG8gb3B0aW1pemUgaXQgc28gZWFybHkuIFRoZXJlIGFyZSBvbmx5IDIgcG9zc2li
bGUNCnR5cGVzIHNvIGZhciAod2l0aCB0aGlzIHNldCBpbmNsdWRlZCkgaWYgQ2ZNIGFuZCBNUlAg
Ym90aCBhcmUgaW4gdXNlLCBpZiBhdCBzb21lDQpwb2ludCBpdCBncm93cyB3ZSBjYW4gdHVybiBp
dCBpbnRvIGEgaGFzaCBvciBiaXRtYXAsIGF0IHRoZSBtb21lbnQgYSBzaW1wbGUgYW5kDQplYXNp
ZXIgdG8gbWFpbnRhaW4gc29sdXRpb24gc2VlbXMgYmV0dGVyIHRvIG1lLiBXZSBjb3VsZCBtYXNr
IHRoZSBzZWFyY2ggaXRzZWxmDQpiZWhpbmQgYSBzdGF0aWMga2V5IGFuZCBkbyBpdCBvbmx5IGlm
IGEgcHJvdG9jb2wgaXMgcmVnaXN0ZXJlZCB0byBtaW5pbWl6ZSB0aGUNCmltcGFjdCBmdXJ0aGVy
Lg0KDQpDaGVlcnMsDQogTmlrDQoNCg0K
