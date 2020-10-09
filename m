Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD5B289AD6
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389195AbgJIVjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:39:46 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17856 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732056AbgJIVjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 17:39:46 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80d8950002>; Fri, 09 Oct 2020 14:39:33 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 21:39:45 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 21:39:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcWDi7NajzBBwhuF9Ys5NaUEMtFQ0fMdKQJq4/sIOuzKyL9Ohsb2qnpo8giytfZm8FYdwxjMe5ql81VbpXct5WE1G0zYwGObzvjkUd1Xc9e6HE7KWjiNxjRyMTBQM7TVT60cbFYFEwtA8W9G458F88wqno9PoAIH4Yp+hEcudGAJOY6kpOpVObya7ha3GYu2ER846uFvODHi3GSr6mOVow558DBKx3BRmpxxtmun9xMRyTcsMEj9B21r/TU7eqxba/cuFmPAU73Mub6pA4+//3CXqacpZzbym4wdLWxKgG1wfUAaWOn0ySbtignKRJ9P9DxwGi9IUhVXnYEsofhhxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5fj3Jp+rrDYV08IgNgp2pJEokIQs56zgCyPnv5UHEI=;
 b=J3LmE90H7ToA95O4ggpqvSPjDJDIpJ2tc56wSDgWXC+gc1ZFjIbaF7sRPv0vioZjI6kI11vvQzgpvszjGgwBIkna1HMHWU/+AbhobF+6nWBKBh9ET/c3ei+xCdfHzrb7XZ5zbQPSDeAOuZkQXo7eT//b/lGFy8crsTUr5ezkZ5QNlvLDui8oufsJ43b0olLCHY+MDhm8EUHMX0503bv08FntKyv36csPF/kowNTwgsaBQzMTYAWjiDJ1L4LhE4TWtfcyTwpJ+rSjFMVFjoXpB9IO+NxdezkpGtcZBKY9vRKTA8Tf97LFVY5yp647MXGNLUWZZmvute2Fp9hGNlxo7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3897.namprd12.prod.outlook.com (2603:10b6:5:1ca::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.26; Fri, 9 Oct
 2020 21:39:44 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.027; Fri, 9 Oct 2020
 21:39:44 +0000
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
Subject: Re: [PATCH net-next v4 02/10] bridge: cfm: Add BRIDGE_CFM to Kconfig.
Thread-Topic: [PATCH net-next v4 02/10] bridge: cfm: Add BRIDGE_CFM to
 Kconfig.
Thread-Index: AQHWnknUQ2L8lvyK7U2lstNK1vxWJKmPzNKA
Date:   Fri, 9 Oct 2020 21:39:44 +0000
Message-ID: <f3e27f2363bf116ada0f352f263d6cbd051b6a87.camel@nvidia.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
         <20201009143530.2438738-3-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201009143530.2438738-3-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: 86373fa6-183c-4168-5e3d-08d86c9bd654
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3897478D9261572BA9BDBC54DF080@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xTsU8E2+oTAkWpDtBCXcuPak1fhgI2jW/1IxtQYYTxqqbeiBI61m/TH780M4rWx/dJuYE1JhH3M/TYDSiLzbHtsX8bD40xaf3zg1rqmBQPo/JgUZv/8oKYXad+ssG2y51Vpbk61KiQ/O1POyV9m/5R29bdbsDH8HjlFK5J015LlH4K4xhSvVAHtUd9qen/LH1aPfOdRFSe6SvndzqztV0qozxrHcjtMsPqtDqHXOGczRdv3RWcts5yUu7cAVGKnqi29kVbkQEnc+dxbHjsTYyYUNeKuf0DtZJuk4LAD7Uq9H+RF7NjZ3wOPQ+sBeXnVZ5jNP2/j9cU/Wxt/hKAumLRU0/xt4e68y7bsThssncoP4VhrmRVo71fASB1mdZm2M
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(478600001)(2906002)(66946007)(71200400001)(8676002)(8936002)(3450700001)(4744005)(316002)(5660300002)(4326008)(2616005)(110136005)(6512007)(36756003)(6486002)(66476007)(66556008)(186003)(91956017)(76116006)(64756008)(6506007)(86362001)(66446008)(26005)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: AdFr7kynXFpQf2ZaphNjQ7RdHZMU9VjIHLvCSp7JE7tFoU/kvAAU9VbiFlDQ1lwWOtwsQc+M9h1XhPnzeuTrVrTYQS2+PZqhEwYXs0q0NDkbVHheSV85x2QEMb+peqfcgglNe/iwsopIHbxQqzrIWj8xkJRuO73YOpY5O9CD0Bfd6AbQWP5US6Edw02wWcVNiqOHQH4RbnNbfXKL0P/iS+sQcfq0vjndzmZXDBBUzrIOEfVMJ1wiL/S694UPK77oY5Hk8oPwnli6ioGn9eeRU6LYSp4UAyQMAvB5dNSHRmC0jeqa0ukycQPlXOigHH2/l3R2ytvw5wvKZO7cDPZlU5KryCUImz238OmQ3tejWUibeHxHWLyc6PCLm6LcQveROoXKeCepn2SeUS4EvZ3gEyqc0bgEt303gcUJfQvALFL46sVSZ6KrWxUSrpKsjzgt+cQUB4ADZJgsroore/nzXrWNjk2W9lo+QiwlNEyXxX8P60fumU5M8BpyTsHkYlsOrDr6LAsf+vpw31fnJ1213hFzKzft6gnmkUHZ3I7KeynT8K164JtBjbeGoHqVKxx8EZWku0jmlIOgZbasYTyFEmx4NZh3AhFaAS7b7WNjN5+LCy9Acjrdkhpogbb0vTucdqu9T+jWaYsOqGNSWi8m9A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE5AC55D9D526E4BBB6628B283F21F99@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86373fa6-183c-4168-5e3d-08d86c9bd654
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 21:39:44.2240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2tMBL9S7ZHAHbLUwEzj4Mv3Z2JIa195nSPXfeA0fzcrLHExf963nO28k7J+D7xMbM2VtBP0y99rSk7p+RIfT7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602279573; bh=b5fj3Jp+rrDYV08IgNgp2pJEokIQs56zgCyPnv5UHEI=;
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
        b=D7bz+xQtgBJ3mNJoDFdqMZYpA/UkYYXZdvHYss8l2DmI4/H4CaFTa1OZY4mBC84f9
         mCi+ellknmbP47+n7QAbMS0Ra1SVXU4tosVxG+pUOA05hk2nBTiaAKaoIVUjvcV/z4
         xkj8C1gX+Ipi03iXPiQbji8UQzWcVfXG3vtrh+zzPFm4+0eZk+z3Z7D8jxVqDphZQf
         Lf67GTv36zeBI5LyksUKgxlRr40D5dURFBTz43uyg4+Um26eZlGZDma+g6olTcrS2R
         qNwXYJxSE4ylDdVVVixXhKD1LO6aNnQZDk/KPzBM/FZIH/CC3kALKv0xsLRG+LQhr+
         vqCG6FMM4g2Gg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE0OjM1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBtYWtlcyBpdCBwb3NzaWJsZSB0byBpbmNsdWRlIG9yIGV4Y2x1ZGUgdGhlIENG
TQ0KPiBwcm90b2NvbCBhY2NvcmRpbmcgdG8gODAyLjFRIHNlY3Rpb24gMTIuMTQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBIZW5yaWsgQmpvZXJubHVuZCAgPGhlbnJpay5iam9lcm5sdW5kQG1pY3Jv
Y2hpcC5jb20+DQo+IFJldmlld2VkLWJ5OiBIb3JhdGl1IFZ1bHR1ciAgPGhvcmF0aXUudnVsdHVy
QG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0KPiAgbmV0L2JyaWRnZS9LY29uZmlnICAgICAgfCAxMSAr
KysrKysrKysrKw0KPiAgbmV0L2JyaWRnZS9icl9kZXZpY2UuYyAgfCAgMyArKysNCj4gIG5ldC9i
cmlkZ2UvYnJfcHJpdmF0ZS5oIHwgIDMgKysrDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDE3IGluc2Vy
dGlvbnMoKykNCj4gDQoNCkFja2VkLWJ5OiBOaWtvbGF5IEFsZWtzYW5kcm92IDxuaWtvbGF5QG52
aWRpYS5jb20+DQoNCg==
