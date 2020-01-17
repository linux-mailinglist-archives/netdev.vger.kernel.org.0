Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96424140081
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgAQAHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:08 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728982AbgAQAHH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKhIwr2ZdrFfXvK1ji+0PrfOSpleA6vPqWubfpgEMKtuQ/vU8533aA5R9QVz+RYE9o7h9uLpE5YtqXdc7K1xCnL1cT8t/HL7X5tUV7YCQJ4liliedK2o+rqgXznHB6TkQvE9eAM/fKg5ZhYe3RwH2TxZpKmpdtqt9O5YU2jAh+HsOLnHQwSfK9sKFCW1zS9QnGw/kTxVPSaLiZDRCaZ9lxei/XUGPDCBvlID8YZma1qYz5FfNp4noSaNABE8zP1Ed1FwMsT6CocEDzvSfPE6/y9G7X+Bn9ATfY2ThokZnhA6sf3KJnVyt8qe92/kANJi3R874zlU9hSGC54NDsv7MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yE8urjzpl2Hd//K1OdBFBU/OCLupVpB9sr5d4eTyoEE=;
 b=SFLn6ttBB9s7KX/NLBhurccd4RfO3MC7gyue2U9HdUItaYOA6SYWJAEUP8M/XOLIt9mm/lNAw4O9d5rYtJgdvYo0WdmiYuhAoJhB2cujmknoIOVdmKNdFNHhHfgZpO0XIOLldIaxFmPmw5gv+20RQvUW6WrwUdpGx8i395VJZSZGY5WQzL0qKxok0SkegoeeVUAyTyt9eXA8L4QfZiccNTDmfXL1K1QeJNkfQN0lzkI1SfGEp+GESxPsGrLp1f1UikPdctsmr0S5APXjr+Yj5Df6fJGkrwOy/D3f9SI9a9Ed/kKiALu48tjFX0GcPGBCKIt7Aa9AqjdIFa0af6XXZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yE8urjzpl2Hd//K1OdBFBU/OCLupVpB9sr5d4eTyoEE=;
 b=IxFbHFI97XVhfJ4+k16tQOeHqOb7Wyq/niAIYyhkWhp0xIyJddDMK7O4FNZJqhNc9PScTMx0e71ptiOwIqozkofcPvbQ4yG7d5iCljMk17RVF1eA2X4lGG/dwJMcR5dMXDerxfbTqByLxLRW9ijtGtNWcB7ZD5lFH6qE0XHoMgw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:07:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:07:01 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:06:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hamdan Igbaria <hamdani@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [mlx5-next 05/16] net/mlx5: Add copy header action struct layout
Thread-Topic: [mlx5-next 05/16] net/mlx5: Add copy header action struct layout
Thread-Index: AQHVzMoK6c9YhowUBkadyF7q0Qsyrg==
Date:   Fri, 17 Jan 2020 00:07:01 +0000
Message-ID: <20200117000619.696775-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 37f34282-b5e9-46ea-1a3f-08d79ae12d33
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4990E599DFB1D55B3C197472BE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(6666004)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S+4trM0ssN0QiVeY7YC68TtdSxDRZq4+c0YAf6LXHC0w922axAquB7+6gX/zyQ2WOpkeL0N8j/4k8lz28UrIBBfeXU93M9kVGtti2CRa/8MzguOsFbxXy0xIZmmF3+yAdmm0TXYC0qbQasjGOg4/mvg7v+0Azm8tBLTaK2u1BEJUObCCj02W9WaJVeXXxQ4I+nIYWLkP97paTLvAJ+tCxhCBsSIaH3hDoRcBYfY9iwl53CLTybXuXZ1VonifEMwL5d9hBpj71iDR77rm/KiDGvH/m7SIM0HEWwHrAIhF+e4dZX8sA9ukifsJiAo3b7n1H9t1ykmDxiDwXCxnftAcNVFfBAL3Chf4nDiPmUMwlORW2HKEqkblDUn3vKJ0sRmqRxuErskNJ48dMzTBwU6sFXQ4EjCaxMzXlo8oXMYB5K9AdpJc5drmyzZ6tT+5JZpT162QQUnj7/yRUcdvHl+KMwxYndqsu+IYluQV9zTiki+Lax65tEZRdb+p9rGGNRVKM7nwZ7MSuxg94yf06h0JRTdVp+wSegi9cOvy1ABnobY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37f34282-b5e9-46ea-1a3f-08d79ae12d33
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:07:01.4656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i4FFBVLQnymX/LL/cF4qYuCiVDGdOzZEZX7TQd3rbZWHGlm+Bd3NIzVR+wshBEp3WPkL7VwF1PKTpfZewtfywA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hamdan Igbaria <hamdani@mellanox.com>

Add definition for copy header action, copy action is used
to copy header fields from source to destination.

Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 6fe0431e11ec..23613a6ea51c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5609,6 +5609,21 @@ struct mlx5_ifc_add_action_in_bits {
 	u8         data[0x20];
 };
=20
+struct mlx5_ifc_copy_action_in_bits {
+	u8         action_type[0x4];
+	u8         src_field[0xc];
+	u8         reserved_at_10[0x3];
+	u8         src_offset[0x5];
+	u8         reserved_at_18[0x3];
+	u8         length[0x5];
+
+	u8         reserved_at_20[0x4];
+	u8         dst_field[0xc];
+	u8         reserved_at_30[0x3];
+	u8         dst_offset[0x5];
+	u8         reserved_at_38[0x8];
+};
+
 union mlx5_ifc_set_action_in_add_action_in_auto_bits {
 	struct mlx5_ifc_set_action_in_bits set_action_in;
 	struct mlx5_ifc_add_action_in_bits add_action_in;
@@ -5618,6 +5633,7 @@ union mlx5_ifc_set_action_in_add_action_in_auto_bits =
{
 enum {
 	MLX5_ACTION_TYPE_SET   =3D 0x1,
 	MLX5_ACTION_TYPE_ADD   =3D 0x2,
+	MLX5_ACTION_TYPE_COPY  =3D 0x3,
 };
=20
 enum {
--=20
2.24.1

