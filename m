Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFF65D692
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 21:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfGBTGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 15:06:51 -0400
Received: from mail-eopbgr40087.outbound.protection.outlook.com ([40.107.4.87]:15807
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbfGBTGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 15:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0QUhXYSwxHW9JuZaL8Xdq5COalpVdgoEIB3yoCTCS4Q=;
 b=oOh8Fz+YMUoAahbWE7G2wI/5uIIft6iOM7d7YYQntNIrmpF+BMoSClib6EubJxjmiYfQY3U+OXl8FIOZKi24VAIO/LIJcsxX2TxnvE/pMOo6Cdq2pQ6+ner/3SzdvVtgcYCBMFM3+iFrJ31S9MQQ9+r/5Frd4RuIjhAyDKtVmbU=
Received: from AM6PR05MB6037.eurprd05.prod.outlook.com (20.179.2.84) by
 AM6PR05MB6069.eurprd05.prod.outlook.com (20.179.2.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Tue, 2 Jul 2019 19:06:47 +0000
Received: from AM6PR05MB6037.eurprd05.prod.outlook.com
 ([fe80::c5b1:6971:9d4b:d5cd]) by AM6PR05MB6037.eurprd05.prod.outlook.com
 ([fe80::c5b1:6971:9d4b:d5cd%7]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 19:06:47 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Colin Ian King <colin.king@canonical.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next] mlxsw: spectrum_ptp: Fix validation in
 mlxsw_sp1_ptp_packet_finish()
Thread-Topic: [PATCH net-next] mlxsw: spectrum_ptp: Fix validation in
 mlxsw_sp1_ptp_packet_finish()
Thread-Index: AQHVMQlL+WWG2AClkkiqi6xWjC0R2w==
Date:   Tue, 2 Jul 2019 19:06:47 +0000
Message-ID: <3f905fb4d20f266f777ef56648f7615edaaffc9c.1562094119.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::31) To AM6PR05MB6037.eurprd05.prod.outlook.com
 (2603:10a6:20b:aa::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43ccb075-430a-4e53-6328-08d6ff206e33
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6069;
x-ms-traffictypediagnostic: AM6PR05MB6069:
x-microsoft-antispam-prvs: <AM6PR05MB6069A6E550FE76F416566A46DBF80@AM6PR05MB6069.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(199004)(189003)(8676002)(53936002)(86362001)(186003)(66556008)(66066001)(102836004)(478600001)(107886003)(54906003)(5660300002)(316002)(66446008)(6116002)(486006)(2906002)(64756008)(3846002)(73956011)(2351001)(71200400001)(2616005)(71190400001)(476003)(66946007)(36756003)(99286004)(386003)(66476007)(6512007)(118296001)(81166006)(52116002)(81156014)(6436002)(305945005)(1730700003)(6916009)(6506007)(50226002)(7736002)(25786009)(4326008)(5640700003)(256004)(8936002)(14444005)(14454004)(26005)(6486002)(2501003)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6069;H:AM6PR05MB6037.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ekR33nNE6gPyTtioZiM2dIL9XwBsjajAm7OdQU33qU6AYvbreS6yTQrqBwhHuKBCUSSb76VTXzu6E/yxRQF+sN4s4FUc/N7ERrOo21IIaxaml7TZ0lMSLJuCakSX2GlUknPXQ/LHUep2r1wrGCbXK3HiA+7DXGd+aDqTmYeqqZIpHagymnFhn81QXCRIhU+43vrC/yQsfBkCkvJxFdS2rIpogl0vgoU5gyW33z13zpKVcP6wfhkwzCUiCZr9h//znw9YFrj5GSVAFA1Psw/zEnrAocrJMRsUTY5G4wDa2+zKPQkglmyz0tzA8Qgi8p+U84csXqzNa0vCgurv1hADiaukBe8WUp6ewKTNO8otXzH1Aw6CKPoX3nP3i57WU2RyaSVNS713uWl3Wq4E8pBRANSbLRAPX15h9aKNJ7P4wvo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43ccb075-430a-4e53-6328-08d6ff206e33
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 19:06:47.5869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before mlxsw_sp1_ptp_packet_finish() sends the packet back, it validates
whether the corresponding port is still valid. However the condition is
incorrect: when mlxsw_sp_port =3D=3D NULL, the code dereferences the port t=
o
compare it to skb->dev.

The condition needs to check whether the port is present and skb->dev still
refers to that port (or else is NULL). If that does not hold, bail out.
Add a pair of parentheses to fix the condition.

Fixes: d92e4e6e33c8 ("mlxsw: spectrum: PTP: Support timestamping on Spectru=
m-1")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/n=
et/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 7d42f86237cd..437023d67a3b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -425,7 +425,7 @@ static void mlxsw_sp1_ptp_packet_finish(struct mlxsw_sp=
 *mlxsw_sp,
 	 * split). Also make sure the SKB device reference is still valid.
 	 */
 	mlxsw_sp_port =3D mlxsw_sp->ports[local_port];
-	if (!mlxsw_sp_port && (!skb->dev || skb->dev =3D=3D mlxsw_sp_port->dev)) =
{
+	if (!(mlxsw_sp_port && (!skb->dev || skb->dev =3D=3D mlxsw_sp_port->dev))=
) {
 		dev_kfree_skb_any(skb);
 		return;
 	}
--=20
2.20.1

