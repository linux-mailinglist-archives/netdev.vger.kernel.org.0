Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3AB14908D
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgAXVzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:55:40 -0500
Received: from mail-eopbgr40047.outbound.protection.outlook.com ([40.107.4.47]:56737
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbgAXVzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:55:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTzH8O1DFFHw9JvRt7LAUOCfz/sbfTNNEG9XLGQqFEkNbuYpcV+yVnaWBqqULVMcO4mC2HD616Swu9giNHmjTlh8DParfOnPlgN598QpMmBAyCjg2sexRSF5N55oUri9SI28JACEl/DUlLGVbEFZUrf+QoVzrcOdxyjGrDSbvb4upGZsckNhUvakUffZgm8tl+UaS/sbLzc9Z/j/vltPumdujccIH506ic48AW5qec5w3Qee+ZHV8JRYmGBi0QnA8T5mK5H63drTzw+2mkFDehgWxjl1gK0Ui5AcFwR/lAHz54ACSBB/b3amqtClbPE5Shz7O+edObTs4l6KaNnkoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vT6tGO7Fm1WNB2N7cyzEYfJ66iDK0/bWzAV4XoiH8LA=;
 b=EP3QctHO56rQYlJk0fjUIm+fFokw1JJKaIFldwuFe5l5/Ki6EfuiP+8oY+yixQ9QO6/muFOOFos8dpMfz7V9qqPvVs1jGgzl5famln0yERkiWGy0NG/2M6FVnWrjk9oyutlJ/Cw9XddcLBF+RKBya/E8DZ2/NgCtBJfk7n2FMU3/jTN/zTkCacDiWmynSAjkwLSX9lZS5zXIybUlRrtgAdKuMU9wEB2EYz8kTQDABqFsBBavXqhxM/JE9q2X6M1y2E/itmy76+Vy/OoNejm7RSrXrC+Bzsz7i99S/S0/7CMZkqSWYxbAk0pNg++QO0j1aTV7y1op1DSZasZkA+TFVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vT6tGO7Fm1WNB2N7cyzEYfJ66iDK0/bWzAV4XoiH8LA=;
 b=XsDngzMUkP4RV9ANkntf0OH/lip83mOK3s9N6PWsl1YkR7RBElDUTJtUC+fsM1HybAA9dpSMAVTUmjj6/pgHeSI5oF3lrSKeLa72UkYLYfOPwy8QXSyFJLC+D/FFOPaE3vukugAKKDozcS7XOOPdX1aMKz+nbvedkHwYjmDscSE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5456.eurprd05.prod.outlook.com (20.177.201.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:55:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:55:21 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 21:55:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/14] net/mlx5: Fix lowest FDB pool size
Thread-Topic: [net-next 14/14] net/mlx5: Fix lowest FDB pool size
Thread-Index: AQHV0wD5osCeaP/DQEawmH0DSmjzJw==
Date:   Fri, 24 Jan 2020 21:55:21 +0000
Message-ID: <20200124215431.47151-15-saeedm@mellanox.com>
References: <20200124215431.47151-1-saeedm@mellanox.com>
In-Reply-To: <20200124215431.47151-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR17CA0038.namprd17.prod.outlook.com
 (2603:10b6:a03:167::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5aba7223-0b17-40a9-d460-08d7a1181ba8
x-ms-traffictypediagnostic: VI1PR05MB5456:|VI1PR05MB5456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB54569CCCF1F7F695A0C39B00BE0E0@VI1PR05MB5456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(956004)(4326008)(107886003)(5660300002)(316002)(54906003)(478600001)(6666004)(8936002)(2616005)(6916009)(26005)(52116002)(6506007)(36756003)(8676002)(81166006)(81156014)(86362001)(16526019)(186003)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(6486002)(71200400001)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5456;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pJ8zn2yWoiaD3sgja1bsmvFSxJ0G6vsHmXMXKFIs9TT2GT8catwes7c0y/A36XFZ01YE+iUbQIlUOj3bMzZs+Q2XAGieQ8KDxqedwXlGmCdGS44rp1Ja45/10ALIzxhMOXwctTepzCC+1hUweBIcP80msjqvfXPa9V2UUjtxnJ6wUW8ms5N3TjAfPizT4fD1l2M3MAI2J3DcP9MoHdfoM2EWGmQORpf4/21Od1ZUdtIscSUpwUkmW+kyPJUWlVNwoTxOLwsPJaG6jPcLda4LL8O/pJbWEvdhufCFzj/tMYp+3jm2oiCExUgYpEvcblwLP6cC+dwuOroQkW7kvSCX4etQxwhgOhwrJ2ay0Mcqplp98wplgV1N3Sctm9m/+E0Jv7ljxUNSCkhWeLO9eZbZShnxIUpi0csL1MtTHQDHafRPzfpQOk0xUyxVUYZhOLZW2hWDvvHgUlMeYWbHQQWWHNDBCpicpRJ3HbR1IPMuzUQrKQXsNtZ47/HRR0zCy0/OvPpyrv/ok1yz47lTXGV47rkDMID16LGoO28Dsncvs2U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aba7223-0b17-40a9-d460-08d7a1181ba8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:55:21.7727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pVS0P8S8L936uiLVwj5b/s9k9bYpQ1H8L1CPjNrf+nhRo3MNmGFdBh1dhKjqDa1pp44pTBUIIht68p7oluo8NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5456
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

The pool sizes represent the pool sizes in the fw. when we request
a pool size from fw, it will return the next possible group.
We track how many pools the fw has left and start requesting groups
from the big to the small.
When we start request 4k group, which doesn't exists in fw, fw
wants to allocate the next possible size, 64k, but will fail since
its exhausted. The correct smallest pool size in fw is 128 and not 4k.

Fixes: 39ac237ce009 ("net/mlx5: E-Switch, Refactor chains and priorities")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c   | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chain=
s.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index c5a446e295aa..4276194b633f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -35,7 +35,7 @@
 static const unsigned int ESW_POOLS[] =3D { 4 * 1024 * 1024,
 					  1 * 1024 * 1024,
 					  64 * 1024,
-					  4 * 1024, };
+					  128 };
=20
 struct mlx5_esw_chains_priv {
 	struct rhashtable chains_ht;
--=20
2.24.1

