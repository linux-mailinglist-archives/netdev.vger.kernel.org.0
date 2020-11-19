Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8DC2B8D0B
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgKSIZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:25:29 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12868 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgKSIZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:25:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb62bed0004>; Thu, 19 Nov 2020 00:25:17 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Nov
 2020 08:25:27 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.53) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 19 Nov 2020 08:25:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltWXGAAeDuyX8U2jtPcaKA7qWoS3yYTj/whZiYW4VDViSsZ0wzwZoT4JXNwFDzww66ei2PMeaD1e2yj6rwq0tjtZ/csI5+6EGre4AiliPUWVl+Us1KSlk7NAKRnXx2HOFzVakSzAUom+sgbq+hQu+UZG39OziSK/9kMwotuz0pBzfm0y15mD05a7mJbVL6sI+y1LeMzLHVkt8wRkxInh3z18MKwmoc8FbAobr/XQGwMBoWBi7jWKtFOlcnC6RvHnr7id8U3avuebiT2YbF46xOoaQtfIxCiVwN2LjiqH2N90MkipxZbwDe5cyQR/ItKORt+VHarGH4ff95Ph/TFUWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BsKVrEr4HRC167fg6Suj82F6+/OgJxEc89Rjc04L01U=;
 b=CtV+JHFCJ2rTnLy0DC5oSliZ7Ri7jNwevBfMGkbAQqCXE/jr38CNOpDBXB2tBhKbNUmIr/5su3D7bKiHfNsunxh59VjfBjU+/tavfjL/RT36fpuSynqwpuIbclzhBXWV0khFG/4qhGa0rEG+bqGLumeuejkmgLIdXYyjroItscJjo8cM4n0q6tFdaaRKWtLitarScPpJy805wwDuXq+eEGFS5X/JPCRmaBKmF1JG6g35jt+R+gakRv/Euz3lwrkVc8qBd+t0pNKGANqaKPUIg5TUE07EQ9lZNkpzgyznyWU1Sk0ltkgF5BmaizcJ31W3cQVzW8D4ddfgreKLuZwaeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3985.namprd12.prod.outlook.com (2603:10b6:a03:196::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Thu, 19 Nov
 2020 08:25:25 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53%7]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 08:25:24 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Leon Romanovsky" <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next 00/13] Add mlx5 subfunction support
Thread-Topic: [PATCH net-next 00/13] Add mlx5 subfunction support
Thread-Index: AQHWuSmL5Mv5iXh50kOvsKYXf73R1KnLY/sAgAAUkACAAB9NAIAAFpTQgADolgCAABuKAIACDoWAgABCfgCAACQGQA==
Date:   Thu, 19 Nov 2020 08:25:24 +0000
Message-ID: <BY5PR12MB43224CC697D1C9BE23CC8D6ADCE00@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112192424.2742-1-parav@nvidia.com>
         <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
         <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
         <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <20201117184954.GV917484@nvidia.com>
         <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <533a8308c25b62d213990e5a7e44562f4dc7b66f.camel@kernel.org>
In-Reply-To: <533a8308c25b62d213990e5a7e44562f4dc7b66f.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.222.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95fbf859-76b0-4c24-9235-08d88c64a9e3
x-ms-traffictypediagnostic: BY5PR12MB3985:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB398532CBF4DB7C9CC5CA6327DCE00@BY5PR12MB3985.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P164eq31LgXV6kzYGOZO/7pccBvI0Fa5xBKMMBX7CqxkTq71F+6uNBnwST9oUnctckNFRDhL/DQemEEKBPEswt9dZ0r9hr5znhDOO13IIFoB+I7B5Cts3qXUPKYovdqxxMobkrGwRc6dzZ/r+8NAP/zASpTG9WtO0HtalH8ZpH/UBsvv/H5KkmMRZqsjGB7dLaUCg8akqdIn5u4t0EnelBQ0K5pJYWq3PDMzzfkizvrNBR3oAm2LK23qsyoK9ejkP72kC8HFnYzb/vzVAxByNcGJhzlh7ECMQ9yYmqmXsa71rIQySrq/3bsbAoOE1mNSIA0HC2BjK8MY6eHrw80n2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(8936002)(71200400001)(86362001)(4326008)(7696005)(26005)(316002)(8676002)(6636002)(66556008)(478600001)(66476007)(66446008)(66946007)(76116006)(55016002)(52536014)(64756008)(5660300002)(186003)(55236004)(110136005)(54906003)(2906002)(33656002)(6506007)(9686003)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KWwRwqj40wjo3AN0etchATX1i+EmoMfgpg9QJeJgM89hncPv3kG1eAo00nc9ChsXA8R9RCaK9m6/rvNxMAbBc28J1uuNovs4i/xpRcMV4Pk3KPtxHMMvEBxvQSUmoNuMnZusVN1W4nnAUCspeFA+ACzg9yO/rs4q6t/2hAx4u0SQeQfOh9NArB+J+NLpsTpEH+6LdIkboL9ZhK6ohicvv9NFGIb2TkenQgI7zSezcOV0oCLDc9BJBaVHGjf/kxN7blVNQoe4RZh8bmIZsPGuE94BccMAEQAFA7d24m3r2lYBuKoiGfnKIbpaRC0QW7o5dljqKh8uoVausphA0psW4lRJiGuoHwviRtM1hEqz3+G2kJW4VeOxK1yK7SX5XwrPFoJI6DerugsZ/+oKRzn6v801xMT1LMMA982Hm8zn6S/zdjjo4WZIrAOvGWO/ulEV3QqxkeXcnfTgynLlaerLKQRuUQxOEH0thhJZq1ZzkpcZoHO+ZaOZopwrg8V20SBluUZF41n4jApInKlbqy3CjQWlGdyDPei+Zc2crjGkMObN66gCTubhuUK5Oi333AjxUj7VqsbeSvKORcZPbW+8aRQfxxTOEjNktarsoJhOBL9Lf4j1dBCwzTfYkL/z1NoP3js98qJeKYAqIAzwBZpEbA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95fbf859-76b0-4c24-9235-08d88c64a9e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 08:25:24.6472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S11Nh2ewn2uUTsRytjCNR7h0Z76UTJJcffoeCJwpi10PTNXkSjO9aVBJ+2j3XQly68Rco1oITXfLLVOXl1zByw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3985
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605774317; bh=BsKVrEr4HRC167fg6Suj82F6+/OgJxEc89Rjc04L01U=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=YshZYIlG43UzTM1uYvSi7Hf8KDxiRjs75FcS/vAEmNy7RdbIupjhke6U6VH1YBk2y
         RYQ6pyWvXB0BPmYqH4wK2GjtCJkTgs484d9L4UGbrbNgZ06CeMIKKhfdfmE4J0fXyp
         yAZyw1dHN8RrOLX9zicXD69I+Z5sMhbYHV0UyjXEUtK4o/6sbKwpd91y3QDzxuvW/0
         /dPkIegmQZha5oV03rVk5ua3UgMgNNCdxEFJoANletYOJ0me2KfRsz/VrFrF2KuNpW
         r54HvFinZYENICyPTObQ9blTjAjGTM9It96g5F+9bOAg0/GSKokC/pI3tC4GDJyulw
         EGt2gcdhVlkcw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFRo
dXJzZGF5LCBOb3ZlbWJlciAxOSwgMjAyMCAxMTo0MiBBTQ0KPiANCj4gRnJvbSBob3cgdGhpcyBk
aXNjdXNzaW9uIGlzIGdvaW5nLCBpIHRoaW5rIHlvdSBhcmUgcmlnaHQsIHdlIG5lZWQgdG8gY2xh
cmlmeQ0KPiB3aGF0IHdlIGFyZSBkb2luZyBpbiBhIG1vcmUgaGlnaCBsZXZlbCBzaW1wbGlmaWVk
IGFuZCBnZW5lcmljIGRvY3VtZW50YXRpb24NCj4gdG8gZ2l2ZSBzb21lIGluaXRpYWwgY29udGV4
dCwgUGFyYXYsIGxldCdzIGFkZCB0aGUgbWlzc2luZyBkb2N1bWVudGF0aW9uLCB3ZQ0KPiBjYW4g
YWxzbyBhZGQgc29tZSBjb21tZW50cyByZWdhcmRpbmcgaG93IHRoaXMgaXMgdmVyeSBkaWZmZXJl
bnQgZnJvbQ0KPiBWTURxLCBidXQgaSB3b3VsZCBsaWtlIHRvIGF2b2lkIHRoYXQsIHNpbmNlIGl0
IGlzIGRpZmZlcmVudCBpbiBhbG1vc3QgZXZlcnkgd2F5OikNCg0KU3VyZSBJIHdpbGwgYWRkIERv
Y3VtZW50YXRpb24vbmV0d29ya2luZy9zdWJmdW5jdGlvbi5yc3QgaW4gdjIgZGVzY3JpYmluZyBz
dWJmdW5jdGlvbiBkZXRhaWxzLg0K
