Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB2D163B18
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgBSDXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:36 -0500
Received: from mail-eopbgr20051.outbound.protection.outlook.com ([40.107.2.51]:43238
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726817AbgBSDXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLiPhG8ISc4FirjXAzCzPEA0yIXcLKGP41z7dxZbkRdb16gAejSpK4y0r/Ar/HftB37oVHwFjAvvqPQgsS6ohW4Qu81erzECZ6LGji2hVUjemsbLmKHrsZ3aPEGLc31qjQP7SLrGqHgiC8Xw6znKjeS0eW1AkJIzCokR7qrFvKe8UWQ0MqdNL5hp3njBflKuhT/rihoR9JEMPVWBEhOO3CE7uKw7h0ajcYNu5vY5hdQ8TdmuYTTBmfjwg2sGcI6eWiRbec9es92GdOG8GVz1ToB8RgpzNd+cyrKHRmrITJe9+66R4ClaRqjG068ecnIhczxkkKIu5MViycujZpN3hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oh/h/6OPulu49T4b/Xm1LA69bJ8nJjZhPnIrfArr7f0=;
 b=RGc+x85Oo7jn3zt5Q7766RcVDbjqAnWYHoAYQg527AfF34xZf3dpDCI5ZLv6XIbxpMrBFhUx6XB3dqCUJJZGJJ1v4SZILQem0FWDL1b3LqwLFvSUjP9AfxtP3zTxFlenaOf/l+173KbOCjcW9jz53TOWgXZtG4Zov+PDOKnRm5vnwP314QV0vxrbCxNvgleTS38i+zHDvEKQA6bbTi48nt6hR6Tvv5nxuudJBy9MgYmJ9Y428hGClYr17SEp3dDYhw0RxEuYgf9dm6U/huW1YYW/GC9eK4k4XJf1+QESN+8Rx/M06lpisCjLV9IK1Hh3gASHftzvKoEfMtkFTIDreQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oh/h/6OPulu49T4b/Xm1LA69bJ8nJjZhPnIrfArr7f0=;
 b=VwNMG5mRv6zQemyBNMzOIswkh+3I9gkO6E7zaDlTumHlL3x7KUoQwePaI8sBr7gxdMV9KbIYtYsAPXJhjspGSZW6m8bo+FYuj5w4BIz4cKM5bt64BRBd/Bv/3ZcSx1PhNMsENjeLRLgCs33qOr4xJi+wiRoQV94s1bLsofjU7Sg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5791.eurprd05.prod.outlook.com (20.178.122.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Wed, 19 Feb 2020 03:23:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:23:26 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:23:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 13/13] net/mlx5: Remove a useless 'drain_workqueue()'
 call in 'mlx5e_ipsec_cleanup()'
Thread-Topic: [net-next V4 13/13] net/mlx5: Remove a useless
 'drain_workqueue()' call in 'mlx5e_ipsec_cleanup()'
Thread-Index: AQHV5tPzdmGk2tNvVkuPAPyUSbh2tA==
Date:   Wed, 19 Feb 2020 03:23:26 +0000
Message-ID: <20200219032205.15264-14-saeedm@mellanox.com>
References: <20200219032205.15264-1-saeedm@mellanox.com>
In-Reply-To: <20200219032205.15264-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b421421f-f398-430e-da05-08d7b4eb1564
x-ms-traffictypediagnostic: VI1PR05MB5791:|VI1PR05MB5791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB57912751E8B37765E6926F6BBE100@VI1PR05MB5791.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:222;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(189003)(199004)(110136005)(54906003)(1076003)(186003)(8676002)(16526019)(316002)(66946007)(52116002)(6506007)(5660300002)(36756003)(4744005)(66446008)(64756008)(66556008)(66476007)(81166006)(8936002)(86362001)(81156014)(71200400001)(4326008)(2906002)(26005)(107886003)(6486002)(478600001)(6512007)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5791;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lzCDZqkEXzI0qHvu9Oaj+LPBwR2N8sZWrqrNsuKRowTk4MyiGu7ivHNcMKAdQcQG9ykUc7D0IdapRFV1vKkirTYWQG9fCBmIh5TnI+Nzm43nqqH2sV5T/6vMBrkFWx7CfW9Qc/wARLzHfTQW8HKoDAVXQj9ucvTc6UBFUlOuOc91QXR+KTguEmAxdy/iBakXhWSNzb6RDRGldj/Ef9VTQpyf8xfh/kT6ghfKVm3bcbFs8+QJbrMH6sAiwhbgPleQFSo1qYoCj46fRu+DtZ0QAs8Zvg5rurxW0JgTPw/YDCtZLY19SJWGuNM1WcoV5JolHVa484CX5ZCaxs7YWqbAYgz7AYNYGU8OAQQnOgrU6GCruE6JAjyQwK6uD1MjA5K0YWA1VTjVdMJULumV+HKrXGgRu/fRqS9mzkuCbv9VCAMnpt0rDa/nx7hlZCg91XzWGnnFHS6t/1z0Nk1n9rOyTDHYCueae6mxshLKOtqUXH8YUKIBPuxycs/v537WGOP7uEXSt9jMpddOlrov15QIDiDEM5VZI8vUTCsOv6KERH0=
x-ms-exchange-antispam-messagedata: sNxkRwXWb7NvPkIyEnpN2tZ9IuIw8WWCnAf3tLcMk+8IVR20JNUa+PkzwpnSz2RxKUiiYvS95oG4eUgxE2bKDbZI38YxNYESubLRj9mQS57ZIp0SjbcfXYIPA5Jq/v6jxOJisimP4eEA2tZ3A+ZN6g==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b421421f-f398-430e-da05-08d7b4eb1564
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:23:26.8517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e7/nQC6OUrTsNXpZIbXFLueJ8BM9leNVnAFDciAFrgLscNSY6mzwS/DRAPnWbx7wS7DaucRyRFCjpuFI0Xcs7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

'destroy_workqueue()' already calls 'drain_workqueue()', there is no need
to call it explicitly.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index cf58c9637904..29626c6c9c25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -433,7 +433,6 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 	if (!ipsec)
 		return;
=20
-	drain_workqueue(ipsec->wq);
 	destroy_workqueue(ipsec->wq);
=20
 	ida_destroy(&ipsec->halloc);
--=20
2.24.1

