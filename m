Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38847E3A1
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388854AbfHAT5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:57:13 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:64391
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388834AbfHAT5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:57:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJUOuBVWuOMwYvIxJ1mCcsrGabDzG9mCf9eKMKqv8f2O+fE6Jy14t60l5e6ZHPyT3GfkSylswq2nGC/w7eq1gdukRcUM5NwxwBJn6GUQHXRdbpU9ZXeeNr/J8yTgkUsyT5Kmgr1l6TDd8qQ1KSGRw8lzMFNn29bPJflAkMBwU6TDSRDF7bDD1OQ74dHpoUqnD9fB2IavL5dR3tMN8zDIi1TdMwm6SaeznEYhbBNfczwUPflcxaWZbgLnX4e4wssiFhAjcdHUPPThFcbSC1PldZa6pndoBDWPvwiBQgiOiecxbzS+O5NRc+qddFKOSHbLvJDq4T+p7E7LvXGqFyoOwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNT54JgURB2qWSqlygSth9FVall1fVSWFN+8megEG5U=;
 b=ahQKdWceXCZlXlMZCfb6rGF9+2TNsdrvxMRfv9UDCZzMR++aL7Oe95LV6zuHi47gL6/Ri6GY0k4LJkEp6cwnrs8Dj/XcRJ1GoKqrdQB+rlumxPfKkZAENkv0Hyg3msHsifKVadoAQXOBTvpVW6G/9UvESG2N5tTHtK6jSyIn9mjgt3ZT+WBiJP9jTWZh5rMD752RHk2i2YxZyMfogP+L4Rejr7VSQhn3wT1/5Hzrgbigbp4nUYqTEfXMbyisp0Xwu7a7iF6pILJWIAjB7HYY53OlAx+a6xj0GAfukFMypwItf94WY8dHYpRIJpIL9BaOn5tseH7dr/b0dS2AfIYsMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNT54JgURB2qWSqlygSth9FVall1fVSWFN+8megEG5U=;
 b=oeUIj5s8qc/ScRf6hB5JXX1yfWuO89Pt72UOaRP9yqwMfaIYi7WOn/yH6H6ha8dnixI65Qtw+bnTmcOc8Yxb3evV7BWvmGEeb4iBdNmfO2vdIgjNL26irhIYdTojuwHi9Siah860NZVWGVjjWtTySWgyQGyZPSkmgbj4Qg0gXLM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:56:57 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:56:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/12] net/mlx5e: Tx, Strict the room needed for SQ edge
 NOPs
Thread-Topic: [net-next 04/12] net/mlx5e: Tx, Strict the room needed for SQ
 edge NOPs
Thread-Index: AQHVSKNGyxuaNJU6Q0GMlL9elQRfSQ==
Date:   Thu, 1 Aug 2019 19:56:57 +0000
Message-ID: <20190801195620.26180-5-saeedm@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
In-Reply-To: <20190801195620.26180-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: MWHPR22CA0034.namprd22.prod.outlook.com
 (2603:10b6:300:69::20) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28354bc3-027b-448e-49d3-08d716ba68b8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB2759EC7CA4A1882900189735BEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(14444005)(66066001)(86362001)(11346002)(446003)(25786009)(2616005)(4744005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(14454004)(53936002)(316002)(7736002)(6486002)(76176011)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PvYcOw4KAOBlTGHCD3sey+Fglimu68jczrmS2SvpoczYOMnMupCF5/jLmJrH2sQ+d+t/RYUco4meWA7cadVuMzn6oXlWWPw9LNXn/YIP/4lkg4Ru6VZk4jqhqOHLULQoKMLBgN6xASisMhu9vYeO1FBITXTAzBuUWIg6cwGYMEhvVmjX+2h7LoN0inUDOP36Vm7xeJEajGlgighMpY5yuswKfGmj0DOnJXFqxaPAXvb3ZUIsqMrF9p33C7Q7IhbHq/am/QJMhnPyKs9SRc24FT2/9dr7ZAEboSMQ0ebD/XGw/9YcrnY8Uh5BfRaUfMEOfOYqMAUKN+NqvYNkH3xHKA1/aVsM3v8TX3bd6MQ7JRCbwxDkPnW7EYxyZ2Z8WMNeiXo7TtvaXe1CxO3zF4kkFD4w+M87Q3zUXWLKQsfrwN8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28354bc3-027b-448e-49d3-08d716ba68b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:56:57.6079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

We use NOPs to populate the WQ fragment edge if the WQE does not fit
in frag, to avoid WQEs crossing a page boundary (or wrap-around the WQ).

The upper bound on the needed number of NOPs is one WQEBB less than
the largest possible WQE, for otherwise the WQE would certainly fit.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index ddfe19adb3d9..7da22b413a48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -6,7 +6,7 @@
=20
 #include "en.h"
=20
-#define MLX5E_SQ_NOPS_ROOM  MLX5_SEND_WQE_MAX_WQEBBS
+#define MLX5E_SQ_NOPS_ROOM (MLX5_SEND_WQE_MAX_WQEBBS - 1)
 #define MLX5E_SQ_STOP_ROOM (MLX5_SEND_WQE_MAX_WQEBBS +\
 			    MLX5E_SQ_NOPS_ROOM)
=20
--=20
2.21.0

