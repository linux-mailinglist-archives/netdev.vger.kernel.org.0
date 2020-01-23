Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7657B146207
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgAWGjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:39:44 -0500
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:52999
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbgAWGjo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:39:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIXcjWnPZgOZM5cMtJHsBOd2ze4215A2Ar7xmVTXObRzIxn5jtxSjRJvPCYSR/7lacGEkkedhbHFa+v6sdrR8Vjsc6cUMuKbV5cwwIGaAwhNsmo9LFwLD0BqZTIMO845N+AoDTgJHTTrmtPs5JwPDrKwuLq5l5zJ5sbgm61wGYocDnGivmRdS5DQPxdTtiKhZbU2uTVbRtK+VjaX3nJT02PtcCKHBTSj65l7fDEkL7FF4remyHEtnjYe7Y5Ng9cNZ7BqUPfwbSQ/o/O2cJPaq/amGqRIkQpJYEkkBgk3cK1ddttOJuLYIXKPqFo6ebVAMEJx0YlXCqkE3RwKqwMV5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CE6eWadNx3dwwF2TIh55dCzV18iearlGiGB4GYXicAI=;
 b=oglaszQ32MCHe8YDB0urB8yhc2Z58eD1foPJEpwcoxWcAET9DhgLVnRD/MBNK6oliDeLrwVgvuC6VfXwGT737MRbTwKpLY+gPdIIUWFN81udGILvy6hy/ivKhvhUjVxwqIhnU+ZJk4m3Y+u6POrE9jNlrZDT0pDPoAo/TBke3l0bwxY7FJ/vQGBxLj9jzoGiRI+pwR0awdPOtFvCbasLyAVahU3YJJuI0u1TWSvNoS5YycRnyN9zvLTz4ppjiQaGpOAb0URkThQOIWTeyTtvuIGWhj4yIbnL/ZMIHkGFkifl/wFwJoyFN1BqbsJ0QT1sUnDUjmIgCKwdyPkLs6i3Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CE6eWadNx3dwwF2TIh55dCzV18iearlGiGB4GYXicAI=;
 b=gzSTtZRCvas7QwSXzv1Zvhsrn8xU/hDNN4yFKJgBd5hmr7lhJ0QtF4aOsQzG1I6jAWZveMtMDZwYm3nbx1pmAhmv4A+XJzKQU+Ps96Sd0BZ8ouefV04o0T9m3pHf0AV1iyZrehfwj7fVqCu9mmj8JOub3HXV3q88dbEd5TcZtMY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:40 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0028.namprd08.prod.outlook.com (2603:10b6:a03:100::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Thu, 23 Jan 2020 06:39:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: [PATCH mlx5-next] net/mlx5: Add bit to indicate support for
 encap/decap in sw-steering managed tables
Thread-Topic: [PATCH mlx5-next] net/mlx5: Add bit to indicate support for
 encap/decap in sw-steering managed tables
Thread-Index: AQHV0bfildO3/fmBk0KPwytw+zNPBw==
Date:   Thu, 23 Jan 2020 06:39:39 +0000
Message-ID: <20200123063904.685314-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:a03:100::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5fe098bf-9ccc-4dfd-ef63-08d79fcf051d
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB494178BC88C2489FFF76746DBE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(6636002)(107886003)(8936002)(81166006)(450100002)(81156014)(8676002)(186003)(4744005)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(110136005)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wDDdpQsDH8PuoMMcFG7PK0QumoIW8DLVbjboHrEM7qnKuCqRUUEdQwEmLVU0jW/hvSE4nFSemtyOqp8TyXvaaw8Y1EaDlJYYWtLzppojJNkmg9FgeYrJrWMXYz/U4DGJ2blOJJ9T8tUVpmtOH7fIbLmBKvigDaGNqeAoozv1jQ38OO1nYygJ3Wi98INsyDpY1MkIU6yzd24Cfs7jsCjSdTj6Qm3XIqFTqHzrC5nLObE99A0j570AT4pGE1pDqCgBUHwfhNAU+IHn8r3Z+/fE2/K6uQBshZXEgJuVRHVeT48rKkJHKdzIKiJssNzNPISWkIEvRHvBHP0vJJRDMRxPz0ZapMaVqvZWoXC9yMhzF76GackWk9e9i8sky2viKJhqjG/berrySg6MRjZnMPD8+VrgqQJhu84NqQufBa3vNr8juKph2xLEac44NrhH3SAbD8CopLWtR+vySIKqAQNn88QjPkSAKoZzIr9u9b58sOEF03F6+GNkIiwZDtv9iUStz0M1tLLkoACL/4OWxDwAONPrglHJLbDjP67Ccybaucw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe098bf-9ccc-4dfd-ef63-08d79fcf051d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:39.3116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U1y/OlQRjPDz3FPGekzWGPCShV/dmYazkT4nnu4p6uVykpekQLNoPfdzbH2gR+TkOS1hw3gb8mhpv5SIXPHppw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

Whenever set, the FW allows driver to open sw-steering table with
encap/decap ability.

Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 0796401d2e80..257c40fdb4ba 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -688,7 +688,10 @@ struct mlx5_ifc_flow_table_nic_cap_bits {
 	u8         nic_rx_multi_path_tirs[0x1];
 	u8         nic_rx_multi_path_tirs_fts[0x1];
 	u8         allow_sniffer_and_nic_rx_shared_tir[0x1];
-	u8	   reserved_at_3[0x1d];
+	u8	   reserved_at_3[0x4];
+	u8	   sw_owner_reformat_supported[0x1];
+	u8	   reserved_at_8[0x18];
+
 	u8	   encap_general_header[0x1];
 	u8	   reserved_at_21[0xa];
 	u8	   log_max_packet_reformat_context[0x5];
--=20
2.24.1

