Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8004710453E
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfKTUgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:36:48 -0500
Received: from mail-eopbgr20061.outbound.protection.outlook.com ([40.107.2.61]:41697
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbfKTUgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:36:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcODbNlk6siPHND0j+FygjZnQbyWXP0JnKhvc+3jBqX2ITVE+KbBhGNnUiFHjzgDPvyDtkZsRg8BTRkGWYAQSTuAoHP1UHkACs/wk1H1ZKYCsSLto1PnSMvDBQ1czE/GfkyqDIBzWvDdpP8CIvrazxs5SaTCNYfFuC9OWwm1ZUZUiKKI/WAxttIw4NuwMItbq3/XO7ZpL0xH0aJonc76LR/C5IrrsNH5qDD5+vaT7u1V6xzDAbOXw0zzOnS7Jok7ejy3cU8kdXI3Y+mDW8UIPK5EvGhnuuL6n3nNx7l9beHUBV6YzuSvH5gXh0lM/2j+L+2aMwRo1dYtPuU3pbVy9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZC4L3LuP2KuJrKhmndTJeQDOzM+1cPE0QcnBpUfUW4=;
 b=kaZEiZhWvTg9q/m6p1NkTRt74XyB2o8ZsMLFg52vaBsAx8b2b1ujSJTmxQMTugZRDxu+Ex76YpFOzvpW/2B124kBY3ib056I+HVaB4FZ3F6boR/iDng/OmaawqTsB83VwK62raFe1RrB4UQeuM30e2cMuZyoFJeyr4t3N3D/xh6+7SWTMP0xW1u5qUprRborzNwUyIigOV6Gw1OkXrRvYnMDMy8Nd5PKwaylouBckqK3osnFcUccRIVP/XXwpAcFkepAftsvmxrieKQ5eHhPwQze4RgHctreGVuYf5ktxjyvDLsQXii5J8XypE3J8EYT+vhJNcFmj41+VwM+ZjfDGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZC4L3LuP2KuJrKhmndTJeQDOzM+1cPE0QcnBpUfUW4=;
 b=CWS33uPhwkOdMDZ3cxFSAMieUgfpj47YXIGFucW5DLG/xQ7WmKKKxLQtkgFKyMTxAn+ALkAueQVWMT5wTy7BPv2XfuxPxIfrbrMSmlXwCp0A2eFRScYmZwdON1lpMsPKFhSUGxs1ScNLEAf2dT0a4XNqrtHAlrUREzB9/xfAduw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:36:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:36:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 12/12] net/mlxfw: Verify FSM error code translation doesn't
 exceed array size
Thread-Topic: [net 12/12] net/mlxfw: Verify FSM error code translation doesn't
 exceed array size
Thread-Index: AQHVn+IhmC3HA0Pfc0eTXGkeUAaX4Q==
Date:   Wed, 20 Nov 2019 20:36:04 +0000
Message-ID: <20191120203519.24094-13-saeedm@mellanox.com>
References: <20191120203519.24094-1-saeedm@mellanox.com>
In-Reply-To: <20191120203519.24094-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:a03:54::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 01eda939-2f11-41eb-df51-08d76df94357
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6110D8A4154A688C96DCAAFEBE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(446003)(11346002)(66476007)(64756008)(2616005)(476003)(52116002)(14444005)(76176011)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kB07DU+IgZTqS1dk6TgPrtnpqPCEtrEaV2r3w9JMsdS03bBM4lPvyTD+vMSdrfSrPXoJAVUTMX+NgPpe0B/l2AztbkRtQzBif0JzNglQSYH3aAp5EVjpuSDKGpesjjPpx4eBEAP1EwiIdqKsTxsCKrMIijSvO2RU8g8DEWzDNNn+pYT42UHYHfcdI5NmI0Lk3bcBHlvsmvw4eZ3E2EScoD8ExadNJyKA+GMoxVMcB+HDMk1lpiB50erAYUEk3RQVyopDyPIVbPhCPrEKzAmo3nk1Sb+/1JYDtQ5GBcTicbnkpNfH7HWsdpKMUl9ICuZVRaf/9ZOV8OWgEKoIX66VixaWZ57P3chooEBeaHku4SojhJ8evcdI7jlMPU0c4pDnTRZyn95MPtRUqG7K3xqRguwLNMMr+N2yCHBSOvSa0mjw/58xiIrTVZPd5TQv7Bwa
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01eda939-2f11-41eb-df51-08d76df94357
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:36:04.4198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U85+8TMi4E8pgqsqf+HjSzXODHSdO4TmFFRVKKWX8VsaLI1CICbB1qQddTPxfyYZVSYQketklSztczk92GWBGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Array mlxfw_fsm_state_err_str contains value to string translation, when
values are provided by mlxfw_dev. If value is larger than
MLXFW_FSM_STATE_ERR_MAX, return "unknown error" as expected instead of
reading an address than exceed array size.

Fixes: 410ed13cae39 ("Add the mlxfw module for Mellanox firmware flash proc=
ess")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 67990406cba2..29e95d0a6ad1 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -66,6 +66,8 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_d=
ev, u32 fwhandle,
 		return err;
=20
 	if (fsm_state_err !=3D MLXFW_FSM_STATE_ERR_OK) {
+		fsm_state_err =3D min_t(enum mlxfw_fsm_state_err,
+				      fsm_state_err, MLXFW_FSM_STATE_ERR_MAX);
 		pr_err("Firmware flash failed: %s\n",
 		       mlxfw_fsm_state_err_str[fsm_state_err]);
 		NL_SET_ERR_MSG_MOD(extack, "Firmware flash failed");
--=20
2.21.0

