Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D4929815D
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 11:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415261AbgJYKtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 06:49:51 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19213 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1415254AbgJYKtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 06:49:50 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9558380002>; Sun, 25 Oct 2020 03:49:28 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 25 Oct
 2020 10:49:47 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sun, 25 Oct 2020 10:49:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dj+I4nO4qGCrQLxgNs2BwXU6LjIWdZ7lZ/EYdTvj7shf4mFg42E6ePSy4z9xuLgrRc/Lb22D5lntThlVvFCeWswdCJi1vuB/GA6RMphBNbVh7aheAbDvFzc7P3J4iYTQVDbPFb1OluPDOcJlw0iV3vI0tYZD/trMeu5DvBU2MCQDscCfsDYVy917geWiEy/gGYZBBqrJFQccTSbGC/Aw5hSjF635XHwDgRMD+ZV5orzsSy/k0sbCiNo41DlCvdIYfuOM3L5LMKt9LhFu561F3X302yhbIVMLxxboXMXk8RNdRglvQ/hjDWU22S+XGteWVW83zaTyMrVPw2okmzBWTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZJjK8MwFPJiAB6ZSfg+XPhCPuSLLZ1IEagXtnufFk8=;
 b=c+GfofARuJ+gMmLCeMC7LaVKtks2xmIN8U2miKma2SNkd8ObfZIusqj98xgK86DM77UOVjjBFvT1J4JJlrqFdJeu/xIIRjPM6HV4sZWg03PJ9M9t7O+E6zCDR6edXHsS3wfc9y1cC5YF8RmyVvu0MS8UHo6uGYnWTlnRikIC4KpjGGzVJHmAzwdeiYMNesatOPmx/yKPM+ZlxmFfjaQB5Y5VOLOi4twFNKTacXKbrF7w6zjjRJbce2CeCKV1FFmsd+74dXq4AJ8aVglas1cdebglsOlmpkGXOwRsQiJYSb2CW2jJL8piaxQA7AIn+vRrVSQB0D2sh+aGQK23cm78wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BN6PR12MB1233.namprd12.prod.outlook.com (2603:10b6:404:1c::19)
 by BN7PR12MB2802.namprd12.prod.outlook.com (2603:10b6:408:25::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Sun, 25 Oct
 2020 10:49:46 +0000
Received: from BN6PR12MB1233.namprd12.prod.outlook.com
 ([fe80::f54d:4b1b:ab07:3c7c]) by BN6PR12MB1233.namprd12.prod.outlook.com
 ([fe80::f54d:4b1b:ab07:3c7c%3]) with mapi id 15.20.3499.018; Sun, 25 Oct 2020
 10:49:46 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>
CC:     "idosch@idosch.org" <idosch@idosch.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH] net: bridge: multicast: add support for L2 entries
Thread-Topic: [RFC PATCH] net: bridge: multicast: add support for L2 entries
Thread-Index: AQHWpLVezD+KQNrkJ0WU0qqZi5aFVKmhzHkAgAYjAgCAAEA0gA==
Date:   Sun, 25 Oct 2020 10:49:46 +0000
Message-ID: <c6b2a63f635d57bd34bb96bbc4deecb506968314.camel@nvidia.com>
References: <20201017184139.2331792-1-vladimir.oltean@nxp.com>
         <98ac64d9b048278d2296f5b0ff3320c70ea13c72.camel@nvidia.com>
         <20201025065957.5736elloorffcdif@skbuf>
In-Reply-To: <20201025065957.5736elloorffcdif@skbuf>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6990aeeb-b3b4-461c-1cdd-08d878d3b031
x-ms-traffictypediagnostic: BN7PR12MB2802:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR12MB2802ACF6352AB7B9A9A9EE32DF180@BN7PR12MB2802.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rEqb4KL4P2/3Zlzv+zFntDGfstl7sWHZ7+VMxKeyx+lH8htWyNDWevoFjfRLKKUQOBsh4+/MCdhg3T3uZOb1WthgPsIam9NU9UseFgqP3RjBmJFHCJqv4FYvfYL4JqhqpxocAVGPWtFZ2v6WRyGZROf2hDmr4XE4zceQwQo+mJDhC+Spx2/QK7UOjvHJSdwsTwMkzZPMHR/KGjWuNAsD6NvRGGyi2B/W3KCZcphaVWYHXZ5jX+1/LlUwzF/533ORr6gqiv5an5bZI6HlNekZRsm7VPHkbJbYDhaD/nUBTbuvj9mU12UEw8c8DlKo7gqb25Xf2p5WznDHT870Oec/Hw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR12MB1233.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(396003)(346002)(366004)(136003)(478600001)(4326008)(83380400001)(36756003)(71200400001)(2616005)(6486002)(186003)(6916009)(26005)(3450700001)(91956017)(66946007)(8936002)(6506007)(66446008)(86362001)(66556008)(5660300002)(66476007)(316002)(76116006)(6512007)(4001150100001)(64756008)(7416002)(54906003)(8676002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wP/YDNyxCJNCGDSaL2BjBBzWT4P4qa7Su9uJfqA9z+UaVugF3cVeiUOgCNcVd3eIymy+i3stw1s4QxmcM21qM+C7tJ5UOtZsKXV80wA+U/r/M63H3xsIhk0woN7XHDoOnl2GONKjnXyz496sjk4wuns+KeUcQ5RyMUjxjsUZvu07DttpsvzlrOMcmDfMc1ZwwH6Ur9PQGB3ow6hsJgkXfHGcGDz8npd0pVXY3uZu+K4Mejmhg0ee8TMD3a93Qpm8sOyygHSkb1Sx9/SzWwUkKfaVt1yKBFqQkFWcsNEjm8n2PelRlfCjufP9exRWk0R+EBFwjdqoFINAvpfuDgJ9TzK8v4JXuDA3Fl2biywiqIB65+iK49ADU6ysQvK1gbJUOJGI9x2ISKdOo5i8N0wzU7+tlf9ORodf6wyHWE1dMoxX20Pb5hOM74Rv4plEbeMk2momuNguaQGohtkmt61gvmJ/Ms0GQuktv/0aU7/tXi/c72X3d+JNHYC4tWMQ+kUmP5XB54QxkrtBTtRGOyCYcHzVQ47ngOd2YfE1pvmHOtD5w+u/3mIZLu3+0fuQY/AStbpXs/ZOx2I+FwMwmridETLEzlDbmWRIti5xZhnzJt8VTMW1QW/Po68d1C08ufDA9ECWzDtFf4EJiCbfRLQy7w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <3842ED0F0918F8418D174BD6D6A39FCB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR12MB1233.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6990aeeb-b3b4-461c-1cdd-08d878d3b031
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2020 10:49:46.0887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aJExWgfZbdkUKKw57dMCh3H55wFoLeYg185cglL8WZ5xcrn785E7ataV99O0mbMO7CO8fuwVvqKDFZ0XCGQPdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2802
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603622968; bh=rZJjK8MwFPJiAB6ZSfg+XPhCPuSLLZ1IEagXtnufFk8=;
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
        b=R0uAYFpEE6cNBzlWXI4Fx3PbcKM7C1Pe+mJYOE6Ff1FwMvQxeSeaR+19arpuGa7dM
         KB7RRpce651K6SKLEajQewdMugg9/cc8/EJBYzNizFvQtm6DxejwEfDBlLP0pkpBOt
         QLJhlun0V4TharZoD/87T7pFMC6bk9UE4RISASY337/S9Pc9DO0ix36SY0RDhGmaU8
         vc/8x405XOF1aURWBXkjqRxuYnqqtAE1AXCD0e/QNAj87Sm69SKYG9tX6Ez6ClaI+Z
         p0YXl9pT2xKKUKishw/YYJ/A4ihYMOoMLtL9HeHrW4c5dY7uWVdSOWHCLIijvN2c+0
         hZZ+QgpN6Nkfg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTEwLTI1IGF0IDA2OjU5ICswMDAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IE9uIFdlZCwgT2N0IDIxLCAyMDIwIGF0IDA5OjE3OjA3QU0gKzAwMDAsIE5pa29sYXkgQWxl
a3NhbmRyb3Ygd3JvdGU6DQo+ID4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2lm
X2JyaWRnZS5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2lmX2JyaWRnZS5oDQo+ID4gPiBpbmRleCA0
YzY4NzY4NmFhOGYuLmEyNWY2ZjlhYThjMyAxMDA2NDQNCj4gPiA+IC0tLSBhL2luY2x1ZGUvdWFw
aS9saW51eC9pZl9icmlkZ2UuaA0KPiA+ID4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2lmX2Jy
aWRnZS5oDQo+ID4gPiBAQCAtNTIwLDEyICs1MjAsMTQgQEAgc3RydWN0IGJyX21kYl9lbnRyeSB7
DQo+ID4gPiAgI2RlZmluZSBNREJfRkxBR1NfRkFTVF9MRUFWRQkoMSA8PCAxKQ0KPiA+ID4gICNk
ZWZpbmUgTURCX0ZMQUdTX1NUQVJfRVhDTAkoMSA8PCAyKQ0KPiA+ID4gICNkZWZpbmUgTURCX0ZM
QUdTX0JMT0NLRUQJKDEgPDwgMykNCj4gPiA+ICsjZGVmaW5lIE1EQl9GTEFHU19MMgkJKDEgPDwg
NSkNCj4gPiANCj4gPiBJIHRoaW5rIHRoaXMgc2hvdWxkIGJlIDQuDQo+ID4gDQo+IA0KPiBTaG91
bGRuJ3QgdGhpcyBiZSBpbiBzeW5jIHdpdGggTURCX1BHX0ZMQUdTX0wyIHRob3VnaD8gV2UgYWxz
byBoYXZlDQo+IE1EQl9QR19GTEFHU19CTE9DS0VEIHdoaWNoIGlzIEJJVCg0KS4NCg0KVW5mb3J0
dW5hdGVseSB0aGV5IGhhdmVuJ3QgYmVlbiBpbiBzeW5jIGZyb20gdGhlIHN0YXJ0LiBNREJfRkxB
R1MgYml0DQowIGlzIG9mZmxvYWQsIHdoaWxlIE1EQl9QR19GTEFHUyBiaXQgMCBpcyBwZXJtYW5l
bnQuIEFzIHlvdSBjYW4gc2VlDQpoZXJlIGJsb2NrZWQgaXMgYml0IDMsIHdoaWxlIGludGVybmFs
bHkgaXQncyA0IGR1ZSB0byB0aGUgc2FtZSByZWFzb24uDQpXZSBjYW4ndCBhZmZvcmQgdG8gc2tp
cCAxIGJpdCBzaW5jZSB0aGlzIGlzIHVBUEkgYW5kIHdlIG9ubHkgZ290IDggDQphdmFpbGFibGUg
Yml0cy4gSSB3b25kZXIgaWYgd2UgbmVlZCB0aGVzZSBMMiBiaXRzIGF0IGFsbCwgd2h5IG5vdCB1
c2UNCm9ubHkgcHJvdG8gPT0gMCB0byBkZW5vdGUgaXQncyBhIEwyIGVudHJ5PyBJIGNhbid0IHJl
bWVtYmVyIHdoeSBJIGFkZGVkDQp0aGUgYml0cyBiYWNrIHRoZW4sIGJ1dCB1bnRpbCBub3cgcHJv
dG8gPT0gMCB3YXNuJ3QgYWxsb3dlZCBhbmQgdGhlDQprZXJuZWwgY291bGRuJ3QgZXhwb3J0IGl0
IGFzIHN1Y2gsIHNvIGl0IHNlZW1zIHBvc3NpYmxlIHRvIHVzZSBpdC4NCg0KDQoNCg0K
