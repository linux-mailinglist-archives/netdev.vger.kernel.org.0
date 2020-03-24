Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5593E190558
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 06:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgCXFxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 01:53:53 -0400
Received: from mail-db8eur05on2059.outbound.protection.outlook.com ([40.107.20.59]:20810
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725853AbgCXFxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 01:53:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvLNEeM/ACS0wZoLo2z+E7ecf1fMa23THjo6sR1sc+bs0q0Ei8DEvz0ZPOdzB9IVTwsqzbkTuFlkzScI1VePW+MLG/Qe5lviDt+yIm84kTvFIEiq571fZLRCesmtri2/fQKNeAwjHKZgNcUCEB5NcHSBLKb/dEM39kIZYg9cwc7PTN4kB5GczfSHTSMqry1Cy4r8CSe2nKKwkboTAcEMR83SGqTY+Sb64cufnD4R1KW9Qdi20paQMBqSi7K8i+Yo6oFLF/TFOHpYHoOiGh4Dz9pTh3z4LU03GBF2QyCatL8n6xfUb7Vm7VcngWs5V7K8g+lnpJFfshMCjVf4od8u7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ho9w9ApRInSZj0R5ugFjt1eKT1cMul9Uk8zpZPr/Mic=;
 b=GZCHXURizkFRFuKpB4P0rm3y4X09hQ9Nzhl2y6zGNmO3UC2iX9t1YkpgM6BHTZGr5Q2Ojkw8pZB+RvikjNuE2aUH4P4DlEDhaL806VyAN3Js+D1ej29CfcQRdxt5dYFx8DiQdoldaZurd06lHc41WXhXT2CISjSnzvHFlUQVAdnOPf6Al3c2S1zXNyr3IF0BB0C3S1PdUQHMNi8IN1nWpCdCVHKI/t5MSwkHTYdWHJwR1UGVybgnxXpG5pTBrN2JXp73fopLfrL9YKndSW2myVDBb5YeXDJ/PFUARF/uBbCsOonCPYRpYQVCvbA30Bi0Wj3RxAx/oPovrvryvKDawA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ho9w9ApRInSZj0R5ugFjt1eKT1cMul9Uk8zpZPr/Mic=;
 b=rH/DuIngR2jLhYIn3kMjCSxsrQgJYUrXAoTwlR5EplJnl5uSZmHURRLBdhEspYYHz/CY3dOUL3cZM9tQzhIZl0V9omptZp6VqxcQtN5fzKddvo5RJgLRfB5l+7Tgq0E3lt9bYg7E81BC7slgwNPM+tt3fWUFBiAG91Q8JRkptBU=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6052.eurprd05.prod.outlook.com (20.178.202.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Tue, 24 Mar 2020 05:53:49 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 05:53:49 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Andy Gospodarek <andy@greyhouse.net>, Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Thread-Topic: [RFC] current devlink extension plan for NICs
Thread-Index: AQHV/iRsiKU58im38Um7T8fyNtLerKhQ1DGAgABD54CAAOeuAIAAzAqAgAQOZwCAAGqqAA==
Date:   Tue, 24 Mar 2020 05:53:49 +0000
Message-ID: <02f8b89d-22bf-12f3-136c-e907f0284a28@mellanox.com>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323233200.GD21532@C02YVCJELVCG.greyhouse.net>
In-Reply-To: <20200323233200.GD21532@C02YVCJELVCG.greyhouse.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [49.207.58.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a606f2fe-7cad-44d5-ab5b-08d7cfb7b9aa
x-ms-traffictypediagnostic: AM0PR05MB6052:|AM0PR05MB6052:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6052AD35C854D3999BDF87A9D1F10@AM0PR05MB6052.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 03524FBD26
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(8676002)(36756003)(5660300002)(81166006)(55236004)(26005)(53546011)(6506007)(81156014)(478600001)(316002)(110136005)(31686004)(71200400001)(6512007)(54906003)(186003)(4326008)(8936002)(2616005)(2906002)(7416002)(558084003)(91956017)(66946007)(31696002)(66476007)(64756008)(66446008)(66556008)(86362001)(76116006)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6052;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DPTg/Hcv/HHxcfrnuNeW/Dtyg5SRY3Qg/p7B5qrjK//Xi20zk5izhuKgAgGYQoXjk5fUKD9Vl1Pm/07ix9YkluwQrRaue834TtTbB0JMaxvXlNRLzVv4r74yty6jXSV3p//7/+SYVZsk0Ll2nhvVOZ5a7b38X0N1HTM5yv1hoiD8cE3Qxwx6ETZNm9xmEN2tuAue9eyMbcHUtM8sdQeYEA+UD4z9eVEiJiH/5T1RosSJkoyf92VLDz2ObFG3xXncQX3t7ROV+I+FHtCayKeCDa9lNJkAhF9fIOI3B4KTfYb3xaAuQD4UfepV0Z4I2Dw8YE05fcCUYJl0Uiu1s10VQIHdYiwaI2Y+paHVIzb3vX0Mp078djZhpT3Whbrro206uzl2hP6CB3q2o6qsl9dJZiiFSKvRoZyr2Opgiv3ffvovJfZJf+cOT7DEO20eLM4K
x-ms-exchange-antispam-messagedata: wQ+W/nW2Wqr/ssn6lQGmW1fWBj+ZSlk9NbJJ3t+5aUFQwQEFZoOpaYXRxF0zKc4b6dZKJoEt3ycK/M9crbzWE9xAj1o4GZOoEHLgb2uTKY3dklhTLgoCJInpx7XKW4jf/1CjMEFBHvTLwtb42wovtw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <E32C083C62CF954398811D32A743CB8B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a606f2fe-7cad-44d5-ab5b-08d7cfb7b9aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2020 05:53:49.5192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IK3bpftqx29bjR8WO6Zi+edkFGTAFi3NfByvkl6fjVIfZ/7wHA7oiSFkwqvCoxn7Eq0VPHRIDT7jVuQn/eo8lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6052
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMy8yNC8yMDIwIDU6MDIgQU0sIEFuZHkgR29zcG9kYXJlayB3cm90ZToNCj4gDQo+IEFncmVl
ZC4gIFRoZSBWRiByZXBzIHNob3VsZCBwcm9iYWJseSBhcHBlYXIgb24gd2hpY2hldmVyIGhvc3Qv
ZG9tYWluIGhhcw0KPiB0aGUgQWRtaW4gUEYuDQo+IA0KKzENCg0K
