Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30A21090F7
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfKYPYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:24:37 -0500
Received: from mail-eopbgr40068.outbound.protection.outlook.com ([40.107.4.68]:59104
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727785AbfKYPYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 10:24:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwtiurkU3S5P2pXegSa+A+CFpgqzfB4hHVDW2fPMuWUwNASPL2PlogLIoUt8nlyJ9GvO07ubefHN5Z5PcF+rO5SKEe08N3lHSyv2M3mwMsOOQHo1+FEAcEyxDUW6IeQCTXtoz26e5CISfNwhI2g00POmqxa06Zyip8EV1S2s+x7smxfIN3wkNpbVoVQO9KwPMBbheYly0qNTl2H7ryrJU0cdvKfz9HuLB/yurIfAwA8XrtcQaoAqha9M7+HXeg1RH9cWrRNAFrjk38JQ+YEBh56wS4qgAZxYZbcscVz1pOYBJxNtlVYR1JCvfcwMcbLs9zELX96+SEAtjcCVZPdUVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xv2Mlk8YSw5ui3eDrQoiGF/m2/XdLLAxIDQXA/LiMH0=;
 b=ILor8lCif1taf06wMuk14d/dNEQcwCyafCfbeDvc4iyyhVakL1A0vDE9e4BwPD6A9r50MXWP4clK6ZYseiz/x8n1JZcW5wr5fQBWW6GAQGCJkq8WQYOlEhVBnCApBnsSLQcyXYtxRj7PlDbBVf1W3VNIcr58BVMmv8ZTZHI6b0lDQnaqebiLDfP4SS8nuXU9jv3ilVy1EoKcZcr3yqixWSKhJWFS+UcN9qjXSEGXDXXyeVmjN39unwfS/lNnm3VYgmaJRv5aapIy+6DqSJNixF12G6w0o9uBHwMoZekavxs2SZxlPD7ValjYDQWrMcAqTwDNVGjogZsrpBeMIN9how==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xv2Mlk8YSw5ui3eDrQoiGF/m2/XdLLAxIDQXA/LiMH0=;
 b=ChKnLC3Qj9S3P/D8saLydQtjr/llSHcIdzWOMiy8YWGdXF67jyxxaHzmxriK5YK3gBrKQw4Lbnmmwin3SzuyHYECaYZJ/micecPSBfqpWF+Mq5sl9G2cb/yD8KW+gQoGxf4WIkgRczWv691/p+oAKWdolqQODS48fXWqL706Ipw=
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com (20.178.119.159) by
 AM0PR05MB6609.eurprd05.prod.outlook.com (20.178.117.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.22; Mon, 25 Nov 2019 15:24:34 +0000
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::dca5:7e63:8242:685e]) by AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::dca5:7e63:8242:685e%7]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 15:24:34 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net 1/2] i40e: need_wakeup flag might not be set for Tx
Thread-Topic: [PATCH net 1/2] i40e: need_wakeup flag might not be set for Tx
Thread-Index: AQHVlm7i7p+2W9+KN0WXqHs0vfAePqecHAEA
Date:   Mon, 25 Nov 2019 15:24:33 +0000
Message-ID: <adee745d-6522-309d-a944-7a54869ac945@mellanox.com>
References: <1573243090-2721-1-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1573243090-2721-1-git-send-email-magnus.karlsson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR10CA0058.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::38) To AM0PR05MB5875.eurprd05.prod.outlook.com
 (2603:10a6:208:12d::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.75.144.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 23f5fb51-2fbe-476e-3a5f-08d771bb931c
x-ms-traffictypediagnostic: AM0PR05MB6609:|AM0PR05MB6609:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6609F6ACB2129B3DC0D25E0BD14A0@AM0PR05MB6609.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(22813001)(199004)(189003)(54906003)(2501003)(26005)(102836004)(107886003)(76176011)(8936002)(2616005)(66066001)(11346002)(52116002)(6246003)(5660300002)(386003)(6506007)(53546011)(256004)(31686004)(4744005)(446003)(4326008)(14444005)(81166006)(36756003)(81156014)(8676002)(6512007)(2906002)(305945005)(71190400001)(14454004)(6436002)(99286004)(66556008)(66946007)(66476007)(64756008)(66446008)(71200400001)(186003)(229853002)(6116002)(86362001)(478600001)(110136005)(316002)(7736002)(31696002)(2201001)(3846002)(25786009)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6609;H:AM0PR05MB5875.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U20YpN+rC1DqcM/QC+vswItJgrH2dL0mZGEsWJrecSE7ecwH+YL1FUsAPYAkobQ2q7kLmwQ1US/ltJEBAuOB/YU6l0RVFVgNYlZcxErehmmByKIqX2rl93GSMcHmfxKXxv0EbJFqxPcfueyOdNtsXUPBorOx2W6UcXCH+tXgvuOdYTXDMrQx6gugY3cP/Eq5Ysbbu6nzpx5+VE/ga6IsUdiWNjxrJ2GvXOVQM6uwXZxgmUQJVpKrhaRifBTmVPSuOeBqrRDt/KYdZPYOiHaQvqEktwfMadZjfuFK+VYsy3rCd65Pas8DsrmYuauKVPWVQtgbCZ++tIOhBde5f2DQAhBm7Erwx0Y4xwat+6+T9q18PyF37wyVxKWchE6lcWVmDunaJYH9udQ2OdMUOcG5Gl727Z/4yXt80u85bepdlU3mH2b3e2Ka5xAViLo2NAUWX7NX0Z8Jtss51T2Ao+5sdg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <01DD5B46563A43458FFDCCC73BBFDC17@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23f5fb51-2fbe-476e-3a5f-08d771bb931c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 15:24:33.9027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ba1ir/zC3jhPpw7s5MYu7QLRYAoAPooaiRLGwhMQRrE0ucKraVZRTM5JbCvjWvzVbRf8eT8t8A1Wpv3aN3ncnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6609
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFnbnVzLA0KDQpPbiAyMDE5LTExLTA4IDIxOjU4LCBNYWdudXMgS2FybHNzb24gd3JvdGU6
DQo+IFRoaXMgaGFwcGVucyBpZiB0aGVyZSBpcyBhdCBsZWFzdCBvbmUNCj4gb3V0c3RhbmRpbmcg
cGFja2V0IHRoYXQgaGFzIG5vdCBiZWVuIGNvbXBsZXRlZCBieSB0aGUgaGFyZHdhcmUgYW5kIHdl
DQo+IGdldCB0aGF0IGNvcnJlc3BvbmRpbmcgY29tcGxldGlvbiAod2hpY2ggd2lsbCBub3QgZ2Vu
ZXJhdGUgYW4NCj4gaW50ZXJydXB0IHNpbmNlIGludGVycnVwdHMgYXJlIGRpc2FibGVkIGluIHRo
ZSBuYXBpIHBvbGwgbG9vcCkgYmV0d2Vlbg0KPiB0aGUgdGltZSB3ZSBzdG9wcGVkIHByb2Nlc3Np
bmcgdGhlIFR4IGNvbXBsZXRpb25zIGFuZCBpbnRlcnJ1cHRzIGFyZQ0KPiBlbmFibGVkIGFnYWlu
Lg0KDQo+IEJ1dCBpZiB0aGlzIGNvbXBsZXRpb24gaW50ZXJydXB0IG9jY3VycyBiZWZvcmUgaW50
ZXJydXB0cw0KPiBhcmUgZW5hYmxlLCB3ZSBsb3NlIGl0DQpXaHkgY2FuJ3QgaXQgaGFwcGVuIGZv
ciByZWd1bGFyIHRyYWZmaWM/IEZyb20geW91ciBkZXNjcmlwdGlvbiBpdCBsb29rcyANCnRvIG1l
IGFzIGlmIHlvdSBjYW4gbWlzcyBhIGNvbXBsZXRpb24gZm9yIG5vbi1BRl9YRFAgdHJhZmZpYywg
dG9vLiBJcyANCnRoZXJlIGFueSBkZXRhaWwgdGhhdCBtYWtlcyB0aGlzIGlzc3VlIEFGX1hEUC1z
cGVjaWZpYz8NCg0KVGhhbmtzLA0KTWF4DQo=
