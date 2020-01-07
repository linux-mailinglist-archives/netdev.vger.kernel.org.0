Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58BF132F1D
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgAGTOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:19 -0500
Received: from mail-vi1eur05on2080.outbound.protection.outlook.com ([40.107.21.80]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728726AbgAGTOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+NTb8fHuKOfHme2ZDQkQfGY1HrXyE456eJYa+ANKtIYfvpiO+EaUrOq0AdnIAbkq2Odg/IndXwGyg0fXH4QbRF+YjBrevtrBPnMrQCqFjaaC4vQ9WQ+ygWWqrfyn7Ql9Td6gqLCf10MU3pEx+ZbnvCNApZcJRjhOorCD0E3y+HTHVSJBk0DGuxdj842b4HX20HevDgH3KR2XGc80ev12IlyCgYxlpdXG+wobKuUPj6J8Aprzx5ESuPGb9L9R2SQqdokF0La1zAMg5a/FXC0DDUpIMntj4Vy04QPH4erClULHSa1cggyAhcaTRyV4X99+1zlvx4A5oJuAW5y+/RbGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGr1WABUaqnwLcXG6JEeG9WLjpdy453PHj44QAcXahw=;
 b=fGS6OgmLv5ZD2k8rQmudumNljRve1OHIKeVMYKJQOsEFyyE49bdN+d0tDOfzF2vXCRmnUXG+l9CGgACtCaDKeYIUc03jurg31hgVqcA/O5keagYIihfcTby/JuOUkltrImPmKRc2QDSeH89w7c0btpnGQ0uEf9k4T3t9NrS06Oj+sB+0rfyuwLGqabbXCfB/BqeMt0lyBa0jjGHwad2HoaKZydMiGBwrPg5yYx57ptaNPKh8btklaZvTuyZd23FkrMzuqchxj4yYjaS+Przu0ffQ41H3aV4LJQBfFvN3osfVjmRiWK/ncRRd7F44+DCr3BHT/78FjXfZkRZz73p+mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGr1WABUaqnwLcXG6JEeG9WLjpdy453PHj44QAcXahw=;
 b=iCaziPabWMPiqhZPubW6NAadumIzI0UnKJJ/K1INFJTbz6kZAUuLQ7s3HB9DjlNJv6IDodNnXr5V4R3p6p4/MKpdOrnXk0ScXBV3WoewZlL51T+QaMzW/yvVVyX+J85oqIoOLJ7UXzhRN5Zhtr+QTYDqMEkJ3l/KbJZIoi1R61s=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:14 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:14 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/13] net/mlx5: Reduce No CQ found log level from warn to
 debug
Thread-Topic: [net-next 05/13] net/mlx5: Reduce No CQ found log level from
 warn to debug
Thread-Index: AQHVxY6mayJ0UZHDhUOMrBjdodw2OA==
Date:   Tue, 7 Jan 2020 19:14:13 +0000
Message-ID: <20200107191335.12272-6-saeedm@mellanox.com>
References: <20200107191335.12272-1-saeedm@mellanox.com>
In-Reply-To: <20200107191335.12272-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b36bb6b5-a642-4c3c-b779-08d793a5c873
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5411507185C71A60C2404FD1BE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QVoC3fJB3+ppkMyW8BUdimshYXbzQBdrMiWt5t+Qa0x3r9SG2YfArH/o2qCNpNmShqV0is13SIDFk4KDHM6IwmOzsfMz1ixyQ37n4p7srLptDrWir4y/jQLOd+R03bzlk/towR4Fji9/cfRVLE42MQWMqeZ7bAqTIgmrglo8DSCM1A+pRj/emHEgUMPiGCrxGXm7LfrcNadV0rg+rYHvonKIkX8oNfRjGLItjTPF1YPg1tvSIv4yPSEuUGh3HVh5gruhYqyDzb3EdMQ2QmcTYEktLAD3/UAd+5lVgIuLDAa6IhCDO9LGhjmd5sfXXgescrzePn5lURsOTXY53T71E+Z9N1TyZiW3MOXypCUc2P4kGQ4NStk2uPGATG9V75GmRazaLozdcdcYZf36//5AsUo8X8ROlUilwJhr470WWxzowj3AoWdr6pANFuy7MYzUdQJ6waB3Gro/OOkY/p9KPtlKzPtNrcfl3s6K3/Dd3zQZJBR58Uas/CLU9icUkcQXFev4LRdPtqUI5TTFMYFuqSF/Svfm2bKat/3yRXCZNXo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b36bb6b5-a642-4c3c-b779-08d793a5c873
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:13.9427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /nMHC1Ao9KPt8iX5ca0yAVR9jB80hQ9gKE1TaSqtjDxxbJB2bTImXNdmXtyF2ZVo+jd6lFBfiAVkf4cxDQvEIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

In below sequence, a EQE entry arrives for a CQ which is on the path of
being destroyed.

           cpu-0               cpu-1
           ------              -----
mlx5_core_destroy_cq()      mlx5_eq_comp_int()
  mlx5_eq_del_cq()          [..]
    radix_tree_delete()     [..]
  [..]                         mlx5_eq_cq_get() /* Didn't find CQ is
                                                 * a valid case.
                                                 */
  /* destroy CQ in hw */
  mlx5_cmd_exec()

This is still a valid scenario and correct delete CQ sequence, as
mirror of the CQ create sequence.
Hence, suppress the non harmful debug message from warn to debug level.
Keep the debug log message rate limited because user application can
trigger it repeatedly.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/eq.c
index 580c71cb9dfa..2c716abc0f27 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -156,7 +156,8 @@ static int mlx5_eq_comp_int(struct notifier_block *nb,
 			cq->comp(cq, eqe);
 			mlx5_cq_put(cq);
 		} else {
-			mlx5_core_warn(eq->dev, "Completion event for bogus CQ 0x%x\n", cqn);
+			dev_dbg_ratelimited(eq->dev->device,
+					    "Completion event for bogus CQ 0x%x\n", cqn);
 		}
=20
 		++eq->cons_index;
--=20
2.24.1

