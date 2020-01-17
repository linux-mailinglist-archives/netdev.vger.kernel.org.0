Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD12140086
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388091AbgAQAHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:16 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387974AbgAQAHP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WknEHmLPol6Xmcx3W0YFhDqDuHZ0K4aDfeKhfvfJGx0aAbph7CRXo0LzFLQelrTO0hOjkJfbG3GXn4yHSlKr1Tb05mbM5gPXBO6nQuFcRUGvXYH41iwCMtUFAbQ7FrZPYJloMQ2A6rkARUJ7OUNSeokxMOyFudMm62k6F6aAP8f2cBtAueWmSOu8bIVtpd6rUZRRoWoy8PxmWXJLS7ICP3mtc7FZ18hhQQSl6+nAX5AyNR4G3iXLiZY8GVih2T694h+8ohVYSm/DfgvmIli4lpwp27EhxBPqfxI8qcAeOIqAP8/Qdhv2rOPbHZmg/s6hVleXTT03y17C8BIJsylkjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7aOoC/hdFFQ2dg3KVadS9F9kmf7QGNzh3RKlq+X3io=;
 b=JpdmZqHnfcLjLJFuJpL6ZIEYx9OTolTqjA5IAV7e35aQ23i9udl1wlgkUpMkNaMYIVeawZCEzuGIFHPpNQiwYUF5QYlMTbTon9WoCiAQgpi51nOM7VvACH/KS8Vl2PWkcXPV/OSRcO7+7HtTY+8XMfVdR/RJsqroF49X9LxIsaghQGHlid0a51/K5e9g4tDvoashzQ/M5KaQyvtjymqrFJHMJCK58WQKRMe/jMhzmOppfSth/0TMTTBfazCETRU6h6XGkfzLiUDqMjftr4cmL6GVXxBhBosQaDvzoxBsRzzEmASfY5ijpY0UD0j7iEHoLdAgAk6apSfRyKTA+F3taQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7aOoC/hdFFQ2dg3KVadS9F9kmf7QGNzh3RKlq+X3io=;
 b=QjodNa9Wx2/m/IIfxizktBQo+aM62FTksvdaMfvaJSwLWyp8u902aTNbR41EZQZ8XvFqvDSaRz6ncSRRYvGhL86wmIhNNqPtD4W+7sD9KjImM67iaGh0XQAW/L0oITQcRebKZ6f777WAl/LVpf/W/nKZyASd7EhCqg5dbSzpIkY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:07:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:07:08 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:07:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aharon Landau <aharonl@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [mlx5-next 08/16] net/mlx5e: Add discard counters per priority
Thread-Topic: [mlx5-next 08/16] net/mlx5e: Add discard counters per priority
Thread-Index: AQHVzMoOIW2SdZnkcUeA6rgDuG+3vw==
Date:   Fri, 17 Jan 2020 00:07:08 +0000
Message-ID: <20200117000619.696775-9-saeedm@mellanox.com>
References: <20200117000619.696775-1-saeedm@mellanox.com>
In-Reply-To: <20200117000619.696775-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4468409d-1b82-4e16-2cce-08d79ae1313f
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4990628CE7278559ACFFD6EBBE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tyo5n1x5ca7b4iPbyf7GlnZz6wWTb8D2K4hSUxAqezteu6Ud0Y+9pZdjRmfaiYC/fvbeMWk1/ZlhgIb/sghwbtCU05pv57Y8OoqMuw4vQxAJ+NFgdHBMG+DUrqcV7VXRgZ6j+dEDb+2T0RUHJDbB2o4w7WU7hAIY5PB4ep4WYF1RqnB/27iWmonQ1Mcyv0hrCIvz6Pg8huq/YOQoPvg3/MZ5V5olzKWs0MRmuwrOde7amh6F1VakE4x0AkPAMHgJLReBhKJnJDVBypwLCpzEcdTIeg4FUmuwD9vNVAeCmdV2AQ0nZvaaYHWD68D/HFFYpJcUSoafubCzDSyG/QMLje0NUpprwsxFXPpk/uGvMbNlNiKqdOo3tHG5/zlSIaUkzI5/AKtUQtX7X1yYlddD6K+tALgli3zvweHxJBlhKICEeWwO1xzASCaFxnOJLj+pUI5QRcHBfQfhEbAVsiQZjuIbLfIVXFXs8fTvlxOtsy3QIr2KjSGZkJ2FhiepLtFUIJ76sooDjK5HOyGD9UzD8NjTzCXTXBEHtmsVO7zAWFs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4468409d-1b82-4e16-2cce-08d79ae1313f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:07:08.2446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bR0SCy9BLRqzzSMSduccIX9EAZ5t9/DlLOmhOkxz3Qu4KhaQKutGr0Y37rMshluSa5z1N+aZXVFa+tmJlKkICQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@mellanox.com>

Add counters that count (per priority) the number of received
packets that dropped due to lack of buffers on a physical port. If
this counter is increasing, it implies that the adapter is
congested and cannot absorb the traffic coming from the network.

Signed-off-by: Aharon Landau <aharonl@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 1 +
 include/linux/mlx5/mlx5_ifc.h                      | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index a05158472ed1..4291db78efc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1133,6 +1133,7 @@ static void mlx5e_grp_per_port_buffer_congest_update_=
stats(struct mlx5e_priv *pr
 static const struct counter_desc pport_per_prio_traffic_stats_desc[] =3D {
 	{ "rx_prio%d_bytes", PPORT_PER_PRIO_OFF(rx_octets) },
 	{ "rx_prio%d_packets", PPORT_PER_PRIO_OFF(rx_frames) },
+	{ "rx_prio%d_discards", PPORT_PER_PRIO_OFF(rx_discards) },
 	{ "tx_prio%d_bytes", PPORT_PER_PRIO_OFF(tx_octets) },
 	{ "tx_prio%d_packets", PPORT_PER_PRIO_OFF(tx_frames) },
 };
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2ab4562b4851..ee0a34d66c7c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2180,7 +2180,9 @@ struct mlx5_ifc_eth_per_prio_grp_data_layout_bits {
=20
 	u8         rx_pause_transition_low[0x20];
=20
-	u8         reserved_at_3c0[0x40];
+	u8         rx_discards_high[0x20];
+
+	u8         rx_discards_low[0x20];
=20
 	u8         device_stall_minor_watermark_cnt_high[0x20];
=20
--=20
2.24.1

