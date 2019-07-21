Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867C06F3EA
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 17:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfGUPTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 11:19:31 -0400
Received: from mail-eopbgr140089.outbound.protection.outlook.com ([40.107.14.89]:9329
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726405AbfGUPTb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jul 2019 11:19:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4/Y/G2rGNmvzHgZd5m+hkvrmZCAbxuWY8oA+9oATMBn+UOwjEBFFbh9iNHZWkYwuVnIt7IqZoNP527G/uVqEKJkZPDYccN2VNgugGqqHVUqOYUiVMWNN3AfhUoYQxpVFD/7wX87ffgPkwQCN1+f/6qEIJB3tEqzcPp38qsU/3CfBApugSTXSP1Ac999kVra20/LhF5rlGtXaLAHmaRXGPriKVSlE1Yq9Arg92JUDzXyzjkwImit2ZdYQCXkJsQRh6GMYiTDMzU/UWvyFEKKAAHagZezUnNzmPm4T8EwQucsRZwRTOt6jSGzUr17cStSLN7hQNnwrftgQ+Fo56OYwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCqO7jYWCanU49q8ZabIA2YJZvWWpFpj+3oLuWqTWWo=;
 b=hgkynkKbO6SRtQZzUN058Vqirq2futqM1SsvcTHOn1iO1hRhGIdjDTFez6HQwCrbjb0bx9FGycnOIXqVk0H+r/yzbbG+MYT7ZrOV9R2sZIvKYcVmIS9AKLqb4e387wvCgcInAsH8YuxIn2ZXqlsFVpk7LFS1ZuuLWnIWLpqNXhLR21Qibp1B7z3uURtOFkHlNq5gnfL1mnTr/fdRnM8/Dd9WaapPQFBVrw5lIVANRAKSAiDDKnp3UUzF1UcTCaCYgLXuzDDaVSytzp3YmFSEUYPk1nrPTVz76S2PRtul4IVBjQARfdqoCmivCNkvCdv/+M3FNcwDc4qURWbHXCEH/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCqO7jYWCanU49q8ZabIA2YJZvWWpFpj+3oLuWqTWWo=;
 b=rHnNyCO0ItjI2WxXB/oMrSbYOJ+EaWPMI7o3ueSeMZVyKY6w8F+Amoiu46WAqCuRHBj9mqGQHEVhyA1oNKB3ZhCEtVW7z9elwRMrlqNbOD0zHaSG3gbfQmrr8Z+MiWWdolCDe5WPP1ldgup+5h6h3yshk9AEiVFvXTacrZXIUUY=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6297.eurprd05.prod.outlook.com (20.179.40.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Sun, 21 Jul 2019 15:19:25 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d%6]) with mapi id 15.20.2094.013; Sun, 21 Jul 2019
 15:19:25 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     David Miller <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH net-next 00/12] mlx5 TLS TX HW offload support
Thread-Topic: [PATCH net-next 00/12] mlx5 TLS TX HW offload support
Thread-Index: AQHVM0amZ+XSxwyRMEeKcG4BIrzTvqa8rIOAgAI+DgCAEDyqgIAA6k4AgACe1oCAACGiAIAEdsoA
Date:   Sun, 21 Jul 2019 15:19:25 +0000
Message-ID: <fc3fac94-c83c-b0c5-b9ce-dc497624bdb6@mellanox.com>
References: <20190717104141.37333cc9@cakuba.netronome.com>
 <1b27ca27-fd33-2e2c-a4c0-ba8878a940db@mellanox.com>
 <20190718100847.52d6314b@cakuba.netronome.com>
 <20190718.120910.1323935732125670131.davem@davemloft.net>
In-Reply-To: <20190718.120910.1323935732125670131.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0226.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::22) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b141b79-2640-45b4-bbe1-08d70deed0ea
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6297;
x-ms-traffictypediagnostic: DBBPR05MB6297:
x-microsoft-antispam-prvs: <DBBPR05MB62975A1E86715921467122A7AEC50@DBBPR05MB6297.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0105DAA385
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(189003)(199004)(6506007)(53546011)(102836004)(186003)(36756003)(386003)(305945005)(7736002)(99286004)(25786009)(53936002)(52116002)(8676002)(71200400001)(71190400001)(229853002)(478600001)(26005)(31686004)(2501003)(6246003)(76176011)(4326008)(6512007)(107886003)(446003)(31696002)(6116002)(68736007)(6486002)(66066001)(558084003)(8936002)(14454004)(2906002)(66476007)(66556008)(64756008)(66446008)(6436002)(476003)(2616005)(86362001)(11346002)(81166006)(81156014)(316002)(486006)(5660300002)(3846002)(66946007)(54906003)(110136005)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6297;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3iB+EEfeTZnkmsMx4gj6JlR22rzAmUa04i7fT5KRw9N4jdH5OnEg+LFRZIW3N1nxMS5HUKE7QZ1JfHjyePtl93yzuSaI/TdqFjpBmklQHg6k1d7plOIiWUYiXWA/9Y8jvm1T88H+7J50ZXK9LV+evxHHVttVyEl9Jpxcg2alsYC+VPqNQrcuJTPWzEQTdBbVdY6gb8+HBWf7B4dAHkbYzaxiHgkL7sY6NvpEUltmFWLYkaoWK9JyBhbkdYVQ+77Od8H5RrpkTDzMuhDaP0iyIYQo1zD57ndB/tNpIypvJWiDvL9yvW/uYK1rdAAYcxNUO9p7DSTkGKya40YXAmYgHamC8bqqZMwFUyVRuOPGNh7zrSN1qt3U0ZsQPazWtuxu3Mu4FDMRAktapvSYlQfL6ts5mQwMhrpJtP9EUARsBoE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B18A353B671734F8DBFFD4AB225DA8F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b141b79-2640-45b4-bbe1-08d70deed0ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2019 15:19:25.6735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6297
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMTgvMjAxOSAxMDowOSBQTSwgRGF2aWQgTWlsbGVyIHdyb3RlOg0KPiBGcm9tOiBK
YWt1YiBLaWNpbnNraSA8amFrdWIua2ljaW5za2lAbmV0cm9ub21lLmNvbT4NCj4gRGF0ZTogVGh1
LCAxOCBKdWwgMjAxOSAxMDowODo0NyAtMDcwMA0KPiANCj4+IFllcywgY2VydGFpbmx5LiBJdCdz
IGRvY3VtZW50YXRpb24gYW5kIHJlbmFtaW5nIGEgc3RhdCBiZWZvcmUgaXQgbWFrZXMNCj4+IGl0
IGludG8gYW4gb2ZmaWNpYWwgcmVsZWFzZS4NCj4gDQo+IEFncmVlZC4NCj4gDQoNCkFjay4NCkkn
bGwgcHJlcGFyZSBhbmQgc2VuZCB0aGlzIHdlZWsuDQoNClRhcmlxDQo=
