Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C2A86B6B
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404879AbfHHUWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:33 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404864AbfHHUWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3YgWLsrrF8/+1j0AxfcDA2CgO5NS08vSYI6ICJjBQ3aK7yEBs3SchoTiG2+ForK9W4/s3m8PXDY1FM315CB4jUVCwI+pbwJt6Y4VVfxZTH8Nw+Nxtg4Ep/E3xzonKH1GHOcE9AiM5tZKMs3bx/yV7xp0ApMak9xP9mMdtIM9AueRpgVxvq/3YxDRTMQQbZLvrFTsJ+J3dlZOzlMpM9GGAYfJ0QIG9wviU78hTTpFMDpq5Ukswh4CHntEoRuIHhVo9FknOKwAgGZr/dFYJf56YgL6Z26p5nVk/nC89ElOCg3RmpoUSTLpyyHA6Y4wmiOh7n5i51QjDFTbo1J+WC5Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEZrLwc7ebgnaIs4m4w632mXO8LSmF3xbFlkpB98ilQ=;
 b=ePQal4n6X06IVhPDLjNMOXwo29J/6pKeCwYTauBAfMhoin4W98TtCvgGJbImaTb4jJsKSzix3WbIwDDwP/tpcTcnY396O6JP+A5CD7RX3vZ0EVZbgS0fY1rkBABUL5bbZmyYWSA5Fq4wSC75L986/kBvx8kclI3CBaDJCUcKU5PiSWdx9wx776iJ1/wTFMzwyRdwTCsVYldfnn15iWUA6TLdyKD80Se55N73FpOGQpIgP3qfWka43RNi44mIDDQKZmo+KlKxFz5GBG1deAr2mCUgqpEtIIPprBPxaZOHYai1KPFXi38SGLTSPV2feRVZhWTEPvzqm6B/QInleZlK/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEZrLwc7ebgnaIs4m4w632mXO8LSmF3xbFlkpB98ilQ=;
 b=nC0PfDekPWf2FtCPYBW/mgPp4XswS92oaualJEI1iC4JzWEMIlTBew+TUWBrJ380xX5DKeSXsReUUEA7uY45BOnIYmIQOVtaaG7iCkZO2Xo6m+GFuVN5IqNl9sdKGiy/wSkllDGqIBrE+QTZTmJmqXbBgVaxTAqL/BZewBDRPXA=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:22:21 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:22:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 12/12] net/mlx5e: Remove redundant check in CQE recovery flow of
 tx reporter
Thread-Topic: [net 12/12] net/mlx5e: Remove redundant check in CQE recovery
 flow of tx reporter
Thread-Index: AQHVTib7pA5Y4QCX8E218IZLPmLfuQ==
Date:   Thu, 8 Aug 2019 20:22:21 +0000
Message-ID: <20190808202025.11303-13-saeedm@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
In-Reply-To: <20190808202025.11303-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 867b4674-715e-4582-2629-08d71c3e1dc2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB225768D1314D51E9CABB8C20BED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(2616005)(11346002)(1076003)(256004)(476003)(486006)(446003)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(76176011)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 075BW8KEecY7Ydk3S5BgJYJ5E738SFitY3L3VQQ5bY27m7Lcm452SF+Ef5WoMJ8WJPjKAUHFm3TvGYRunAfvjUvk+GXvlV2JQ5FqtcMWNhSXKBpzdKQ3X1+iFcgAQXqt+psA5QED/2PMoDCYM12hlZcv0gWGOnaZN0YWC2MORYvjFL7hg9udsEqagTv7FZTQK2hYZkHfN3cmwJzlTwoBO/YHYUqqTMBX/Ik6/gqsutsmzrKtsvSyk3Rlx/9hEaYomdc6oAngREpIkWTwuxOOrl2eFikLxItIdMZa1pvuY1+lJVDFp+hKLgahR+wwHQ5akCHOLRPypO704bl87sr/S8BzcOJzRR+Kt82Ht4jZTTUqnjGEgVbhj3GejNbJuNBXpDdazexh392xrOr2frNj38c3R6beiecVupFmh60TrJ4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 867b4674-715e-4582-2629-08d71c3e1dc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:22:21.5024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d4OSxpUwg1mPpfuIy9lUUh66ohTajGkhb17noCsOUmdvXv7DUhQ6Xn/krT4P9W/+kYn8v1USds00xp/iPDHITA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Remove check of recovery bit, in the beginning of the CQE recovery
function. This test is already performed right before the reporter
is invoked, when CQE error is detected.

Fixes: de8650a82071 ("net/mlx5e: Add tx reporter support")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index b91814ecfbc9..c7f86453c638 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -76,9 +76,6 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5e=
_txqsq *sq)
 	u8 state;
 	int err;
=20
-	if (!test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
-		return 0;
-
 	err =3D mlx5_core_query_sq_state(mdev, sq->sqn, &state);
 	if (err) {
 		netdev_err(dev, "Failed to query SQ 0x%x state. err =3D %d\n",
--=20
2.21.0

