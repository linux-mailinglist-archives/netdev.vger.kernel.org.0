Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E92146204
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgAWGjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:39:41 -0500
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:52999
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbgAWGjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:39:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftszn1tQN6GAHun/XBiyCAsUFBcPNBOhcAjDesQLcKTnwaTd1vQdEbxMdqwo31Wusl/4c8Hrw0Rin/R9Mk/J0oLRbcoJHdtBGezyJRkxLDDq8WraSCvBGc3EJ96RiaRwIyf5EqcwuiA1zMpUE/aopgjDjkZW6+PCD9QU7bVyuQmGjdX83G1sI/pETgXEfK2PqSYbmsVVla6ahFLDe9nZak6zKjzSNjN9Xo8Oz0gOFzB6lvxBzAn2zJu8dNDqypcedGD6iCw9qY+v5c/4OKs28GWrF5XJf0wdZ1paVH5T706hoAOUBeYeje5zxVb2iq4JYCPo8/9DqXKHkU3t+9SbAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eB8KAbP1cVM40LTj03ERBgQ0ED7s3SSBqpKJLXGVXB4=;
 b=S8IIwCK9q4h8C5kDxm2MFVmuKtBLUTuoKX8a8PV4TLY5Ww050CTmDi5E7s1CjXkpyo6rLc/5EnFBY++zN+vP+EHRbLlPCKiOiG+79i6d2VyfclxCjE7RKBHmDqB6xtYZUj4i/cSOu35lWD85XNGZUX9DxE9Kbbogk07btYF3gNW7jl7UIq3uBrcTWbw53dPQORgnxGpBKXnHfh0JF4cUJMH3lkf4EjZiSmBIU7ZWTvAAjea5guu8GvkfUGqhgpt19/A6wyaXPUIN/vXv+AWyZT2DFIaZUBGOfJezyrgOwF8/t2xTEy6GmE11L0czn3R6qDJ4ERmoCB8ZbOs096AgIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eB8KAbP1cVM40LTj03ERBgQ0ED7s3SSBqpKJLXGVXB4=;
 b=AtYdwrMWtC7CttsfWMcRtWJUB2NUJLcvU96iIDdR0vUCW7IyHE4pNkSPAh9nlIE1TIMUGlhMr7WJ6ZVPhv0Es3GvxVdOsy4C9BsC8rGN1Y6/mB7qsmdABUPZaAzloBDIJL9mFPToBTCk+zBmMtP7NOwkEHxbsdM3tcb79sfocec=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:37 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/15] net/mlx5e: Fix printk format warning
Thread-Topic: [net-next 01/15] net/mlx5e: Fix printk format warning
Thread-Index: AQHV0bfhWHdhS4suQku3WEVrqtTx1w==
Date:   Thu, 23 Jan 2020 06:39:37 +0000
Message-ID: <20200123063827.685230-2-saeedm@mellanox.com>
References: <20200123063827.685230-1-saeedm@mellanox.com>
In-Reply-To: <20200123063827.685230-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 95050cb7-c751-40d0-bda7-08d79fcf0402
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49419FD08CB557CEABB41444BE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IuEi9mQBoc3Tb0X4pGxgv5BOX7WGfhi/s3Wcnux4TcjAVrWPTGqFO9A8N+8KDzoF8tsTLLQMgMTqqIZ5FwUcpmzM/0dvRmPOEXZydJu/QGLOLvauN8xvxJDOUewAoRbeVAwkpJnMd9ROdoUYhXUt54OQsodvPxddDNo9qtYHtjL3Slbm5d+4uH7JilOM+2Z3xK/gn6HWoyDwbzWLS6xtTP1r2yzQqnyhbBjtheeDfHdqFbu0VIbksLfXSzaimBWeQ/k002EYpBMc6LH0JE7LtyW8A4HZxh3irut1nQSntcbCZbnn40LC3zeIBJfOm7IjgAY+AXtgtzBejhhurVrz2SDROeOzT4SsEvpfUUs2YVzvsq8p+wmXUZgn9leMQcCCQrV9SGIdnMZ1AeoAc3sQbxtmyrSFcZB3IdW/oaEFLqIdpdBv8TpBGkbCUIXf/QAhdCwORbd29yoWFhhwqi1c47ePuEVzc4FDdbtJPKpAK+EN2+W5iZ0igJto8oQzei164gF9fD+3AZQJMoWBGBjxaFP1hE8n3sIiSMztFTyFZyI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95050cb7-c751-40d0-bda7-08d79fcf0402
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:37.3957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e/781fgbpIghMcAoOwApAo/9Je8ivw9m0RK38ojU12THYvBtWGclckbZ+SiCVw/wtzoEhC/TN3V14oIDgl0R1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Olof Johansson <olof@lixom.net>

Use "%zu" for size_t. Seen on ARM allmodconfig:

drivers/net/ethernet/mellanox/mlx5/core/wq.c: In function 'mlx5_wq_cyc_wqe_=
dump':
include/linux/kern_levels.h:5:18: warning: format '%ld' expects argument of=
 type 'long int', but argument 5 has type 'size_t' {aka 'unsigned int'} [-W=
format=3D]

Fixes: 130c7b46c93d ("net/mlx5e: TX, Dump WQs wqe descriptors on CQE with e=
rror events")
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/wq.c
index f2a0e72285ba..02f7e4a39578 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
@@ -89,7 +89,7 @@ void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix,=
 u8 nstrides)
 	len =3D nstrides << wq->fbc.log_stride;
 	wqe =3D mlx5_wq_cyc_get_wqe(wq, ix);
=20
-	pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %ld\n"=
,
+	pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %zu\n"=
,
 		mlx5_wq_cyc_get_size(wq), wq->cur_sz, ix, len);
 	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, wqe, len, fal=
se);
 }
--=20
2.24.1

