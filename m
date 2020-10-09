Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D4B289B37
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391935AbgJIVwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:52:34 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18920 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732056AbgJIVwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 17:52:34 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80db950000>; Fri, 09 Oct 2020 14:52:21 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 21:52:33 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 21:52:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzsKtBjcOO26huyDBLmTBnuEfFG8GcoMjxhcLorohy6VtDDJqiCTkpvP7gD0qXiZMb3v01k8i7miKsW7fUcgKqbaMFZU2G0wjxiiMDn3ogneykyAvWZ+ktZEM7Py2j/u2/o/u0iIwxvoTNoSbbdKF5IpCdNDZ10UU9QeNbQ6qfmK7YbEG7cVn0R/SvtwN5INkyJ0yWk+xwtg+lRVPm7sKgo/xhQ3YLi/dKxscDM7mFiIyuZzsWJL8DfZ/JnjCxm+m1nBMuHiA1qpmCxFDc+OcoEk+v/VLBIhjH7PE4O7xzNqpvsJ3QJcd1IMU5mi7L8b+QO9tTp5sJM+xtA1mBkyTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I09VDzVoZh5+iTBqSAwOOIkD+EDlxCvrdK8PCBQVTjc=;
 b=W1que05BhdY2/al24Rn1ZM08oPVt1pySZGMZqak0W21kjqgQDIXO6v0LvR3/0Fvsw6TaNLznOy/aDs+fDx6zxgnMi0Bh/BB8PkmBbZ9m7yC549QuetS6PaO4Dl+G7VCe+sD1rpFJu4Av9B5Gte6PMFG3hEtLVimZ9LS8CAZJ7zBBCU5Oz7VBBV6ODnGxFx+GxF9EEcXSo9NMCcEQpO9OQl+YIK248FORV23BmllK43zpWLEaRY5CNF9tZiFopyPBsPvyTYFgAtJ9pA2a9MmXICPwyx1fRkE/B7fbge/OOxPtMP2/W6HSwfTtgpViDXXQwa94ZVsF+vUXVDFivv9y8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3563.namprd12.prod.outlook.com (2603:10b6:5:11a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Fri, 9 Oct
 2020 21:52:32 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.027; Fri, 9 Oct 2020
 21:52:32 +0000
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
Subject: Re: [PATCH net-next v4 06/10] bridge: cfm: Kernel space
 implementation of CFM. CCM frame RX added.
Thread-Topic: [PATCH net-next v4 06/10] bridge: cfm: Kernel space
 implementation of CFM. CCM frame RX added.
Thread-Index: AQHWnkna4VmLR+70jkab+Ysc39Yj+KmP0GWA
Date:   Fri, 9 Oct 2020 21:52:32 +0000
Message-ID: <2ec76c98813c8190ced9e34b70b46d2dad94d714.camel@nvidia.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
         <20201009143530.2438738-7-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201009143530.2438738-7-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: fd28f9aa-7b0e-4cf9-ffa7-08d86c9da017
x-ms-traffictypediagnostic: DM6PR12MB3563:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB356337A4EB94E7E801093E7EDF080@DM6PR12MB3563.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:274;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sHjqTIfzvj7Ntn//6hGHZvp4GhhL5v/UvGiu98esVTU1Fn7fTuxWsBPc+QAtPGiTJMXUYmgO7isWlmfGc2L5bL0yhS0TpG7c29c8+nBOj+YabPLJL9d/Ey/1iYZmV5QpjZqNSHF/nTXN9o6CF0gVfXcoFH7Lqp+eBCt4dAYO6jiFjgwryX5lKn5+acBLuSdA8M8y79SIQxOV3LpZkxVe2eNq5YWEVi2MPH086KCzIbgFTeG2ED+N+PLLcCwW5jJpbIYF+6L9/bICk1XFZ+80OIl9ta2Audj/wfkEVckcZFxrjA+ai3w1MapBuwRb6xNtrVFX6MUohyhyaiavHwEoB8K69Mx8ZRl2EBHhSOLD1hci4UAC7Vr9xdZ/qAOlOxXq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(186003)(26005)(6506007)(478600001)(316002)(4744005)(5660300002)(71200400001)(2616005)(91956017)(64756008)(66946007)(66446008)(66476007)(76116006)(66556008)(86362001)(3450700001)(8676002)(4326008)(110136005)(2906002)(6486002)(8936002)(36756003)(6512007)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: dRv230QONo02IGPT4oaXbmrma451Pn2QBz7siJ1a/N6J0+HCladEOVB9JDieilrJgQrk9HiT9rNVfHVpfvsJNjzx9/6hlnIj173ukPu+IJekoHDzCyThQfjLrWXc07wNRHuXZ6wtkHFOcvUXCQhUYHxpouYSmp4xCLtTGZKkm9kdT2vLVlGAh7FAV+aDtfmCM0TPmPBVTdNoRfJhj2TtG8xHOgksKkFO7scyhDk73O4QJPp/OttcyGJk7WC2iJdZfmsW5LQ8zmE1qtTL/HOjHT6kAJ+tahb33G3Qj0lDfsxR5w8tFvO4ilcqEdY/ei1bRvGVfucQhQqdLy+HuvQJ9v7uLY6+RAAp0iG4mLR+KBYFb0BwxeVAVbZvH86WOyFcte7OA5iJ39+IOv43BUoTUlILHwT++dRmgn+5VGF/rUSLwp9+yhKs3TTtLS0zaQUvFHUhCsQ+JJULtfMBxlOr5QM1W2RvuhJKwSr1wpliCE6ixdbs2C76nM/XiXzL+rVK4X7ntGsBynPn2osvxW65XnmVERZ9NZGkUrRuRk4vf7S8jV7ZFOgQrBjUMprFLzTAimipIy5N2Z6gOA1eATVUkwnzV8qLLd96sOP750BYu0cgM3WV2cbYEW1EXv8LaTseOpM0w0HZ/ns88wXwoYbENw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <4868D7FDBE19674CA5711868EF963C64@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd28f9aa-7b0e-4cf9-ffa7-08d86c9da017
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 21:52:32.3028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pPRxdt5iGmCPkit/jSrsBu4n9ZBmU71XlxPt/oKHdBH4hgKHKDKTFER9XVK0bgY3yp9/i6WBP6z27fvNos/JlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3563
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602280341; bh=I09VDzVoZh5+iTBqSAwOOIkD+EDlxCvrdK8PCBQVTjc=;
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
        b=BwzKBPedMbEJ1XP7QvpYfw4WfW9Nptve7Ymd0rpwrI5LqCFBwGqrsDZkvWb9YAB+k
         8NmQSyygvLRXZxPIKviL2MkIXGpJsvvzh9CmfILr1EBvKN3wWZQZqcq1po+cYo4sIp
         sczXHrkxXE6MUViJ5CyQuNhargi4nFLU+U8vJ/+xcbbGmd3j5L81A0jjYS/Hm9vwp6
         muOHTENORlyp/ApIggL+D+Rt2xXUZr5eG1deMEWHbXWBX12I2D+t8xkQRAUJr4K44I
         pNc4p4mFh8lq4pL0QZwGF/Szr0/yUDY+7DpgNv9Vu0pdOupMY6ODs4aD12fiOg7XEd
         dZdURKnJ0CtVQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE0OjM1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBpcyB0aGUgdGhpcmQgY29tbWl0IG9mIHRoZSBpbXBsZW1lbnRhdGlvbiBvZiB0
aGUgQ0ZNIHByb3RvY29sDQo+IGFjY29yZGluZyB0byA4MDIuMVEgc2VjdGlvbiAxMi4xNC4NCj4g
DQo+IEZ1bmN0aW9uYWxpdHkgaXMgZXh0ZW5kZWQgd2l0aCBDQ00gZnJhbWUgcmVjZXB0aW9uLg0K
PiBUaGUgTUVQIGluc3RhbmNlIG5vdyBjb250YWlucyBDQ00gYmFzZWQgc3RhdHVzIGluZm9ybWF0
aW9uLg0KPiBNb3N0IGltcG9ydGFudCBpcyB0aGUgQ0NNIGRlZmVjdCBzdGF0dXMgaW5kaWNhdGlu
ZyBpZiBjb3JyZWN0DQo+IENDTSBmcmFtZXMgYXJlIHJlY2VpdmVkIHdpdGggdGhlIGV4cGVjdGVk
IGludGVydmFsLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSGVucmlrIEJqb2Vybmx1bmQgIDxoZW5y
aWsuYmpvZXJubHVuZEBtaWNyb2NoaXAuY29tPg0KPiBSZXZpZXdlZC1ieTogSG9yYXRpdSBWdWx0
dXIgIDxob3JhdGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29tPg0KPiAtLS0NCj4gIGluY2x1ZGUvdWFw
aS9saW51eC9jZm1fYnJpZGdlLmggfCAgMTAgKysNCj4gIG5ldC9icmlkZ2UvYnJfY2ZtLmMgICAg
ICAgICAgICAgfCAyNjkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIG5ldC9i
cmlkZ2UvYnJfcHJpdmF0ZV9jZm0uaCAgICAgfCAgMzIgKysrKw0KPiAgMyBmaWxlcyBjaGFuZ2Vk
LCAzMTEgaW5zZXJ0aW9ucygrKQ0KPiANCg0KQWNrZWQtYnk6IE5pa29sYXkgQWxla3NhbmRyb3Yg
PG5pa29sYXlAbnZpZGlhLmNvbT4NCg0KDQo=
