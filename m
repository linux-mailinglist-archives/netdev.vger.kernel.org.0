Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9AE0140080
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387678AbgAQAHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:06 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730092AbgAQAHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KxFLXebcO5oJRAjLAPQKcMydzu5XBlsXKUmfsNwGHeIVReBGx97GZC/Bpo+3OJdann+5wLpURzoWCg2gUeWcNbK+WMbIhHCJfKxVZUQl9ub1QoFzIAaVjV2Axnz2kGy/UlfNeujRA8RRZhchng075NGLoQMaZ/lSoc5Cga6FqKKv79gheceeiTn/R6geRIkOFgPnDh1UCq/h7S27WifpapYjnXrnHpLsk6Xcjf+iVt+J0X+FBowcpwUzx3Ei0bYs5OhHT+KIYiufATnVMgGyxurDw7AdRpireiemCWhZkyOHQ5fEBDPPMPEzh8T1TS0Xh88MB4FLvBUtdrx4WO/Mrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCYBCNR8/B7aLtMWRki2mlgUyZobRsG3FXc7125+NLQ=;
 b=adoFvWkQZfbMC+DyU3pIzwo3aeai5rzQyezf1BiqeVpwpDyY/eqoQtnGcMVGk7bkw0bQTA1x9ZLUafcduOtB7lf5C/ozU8TncufrcqR7aG9tpVH7ZrS57et51ua7CFKSk21K4zsYx9mnLAk5doWjvhkGJEGbA5wDRA/5V8oQn5Hun4lJ/L+rsU23qTobI0ah88tSnXcp/xPl0jDQe4sw4bywKZSdqNYHOI5njbJlD1Tu1x5SRHPyIeTN9msAWDxx1KteYiX6Ibu78cM4Prtm/qrdd1TmlZ6W6P36BeX4t14OTtjRcZUaqhFm9hcjdoxG214sGAc8Pr9xj7K3ShJhAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCYBCNR8/B7aLtMWRki2mlgUyZobRsG3FXc7125+NLQ=;
 b=qNltyKogXPJCV0BhNeGAMeXH+PzVJAGXX7t5M8c8RJ6HEwPRAOlfIbMmYZL5bilEIpZkqeYw2y90nGeUH3FQRVkd8/QVd702HMMKAUCJGf9sDu896Ut3vyEY0jOMj2MjiZjkF8Cq9wDGsKTwxL2t1qCjuPCNiYCLg7t7yZbmKDk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:06:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:06:59 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:06:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [mlx5-next 04/16] net/mlx5: Expose resource dump register mapping
Thread-Topic: [mlx5-next 04/16] net/mlx5: Expose resource dump register
 mapping
Thread-Index: AQHVzMoJQkHFxa9Cs0SH9x4bmcSAOg==
Date:   Fri, 17 Jan 2020 00:06:59 +0000
Message-ID: <20200117000619.696775-5-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: c80b691e-d75c-45ab-84e0-08d79ae12bed
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49902215310D6F5D2EF0C811BE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rHwdpHCBevokEQhaRCIV1hUQ3tQmbj1jVUpHcEEMT4FZlmhXPjlaO0Qr3+BiVuUxmLY2svXC1e/6pMYUJCvZ2PfOPCd5N6MKYHgp7/chJro3Qfs/AXXlCUtKLTvqyCarUtR6csZbdv4N6E1QFj1h5NO7eDdZ9HXdBzChSW6AjySDvkmT3aYcue1bq3kHXRVBilu9S/ycVsHZpM5emg1wbuD9ykvI6yl1lFOAhCW208cSyTLJp5ErJwnnMKjgTdYzWG3vfZs4yhsD9gRMaRCJXM2Da8Dqt1xFI4BCNRhqcueUrzYPH+nIgqNgtQNXSDqoE2fqmCWYLtCtwPhspUXlcmroLkV/trvFlmtI6nF192Aubm8ZQWjHtGwWiZqLk68CmkjGYpeBNlexY950iXZ+jrr9UYg5oXrNzqqsoUN1O3iOJOjnOB6Kr4lh/YBkd3vyqbevNZ2euKsPUWL9guZs4PC2wylA1Nc7bp20KFppfxb+3vgcv6POihJx+TzOZEtcmTLnbLtnKgOGzoYpjk4INzeALA6ofBMDOJpQmokr1+w=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c80b691e-d75c-45ab-84e0-08d79ae12bed
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:06:59.3498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JKaREbTbilvfbhV0YBbVkJ/S5qyVNZv56CHv+viUn7BEiuYaBpxFGUh5GHboKhKGMkFnZQCd+dPVh07+n7WRNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add new register enumeration for resource dump. Add layout mapping for
resource dump: access command and response.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/driver.h   |   1 +
 include/linux/mlx5/mlx5_ifc.h | 130 +++++++++++++++++++++++++++++++++-
 2 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 5bbdbeb21ab6..22bd0d5024c8 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -146,6 +146,7 @@ enum {
 	MLX5_REG_MCDA		 =3D 0x9063,
 	MLX5_REG_MCAM		 =3D 0x907f,
 	MLX5_REG_MIRC		 =3D 0x9162,
+	MLX5_REG_RESOURCE_DUMP   =3D 0xC000,
 };
=20
 enum mlx5_qpts_trust_state {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a133583c3e4f..6fe0431e11ec 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -823,7 +823,9 @@ struct mlx5_ifc_qos_cap_bits {
 struct mlx5_ifc_debug_cap_bits {
 	u8         core_dump_general[0x1];
 	u8         core_dump_qp[0x1];
-	u8         reserved_at_2[0x1e];
+	u8         reserved_at_2[0x7];
+	u8         resource_dump[0x1];
+	u8         reserved_at_a[0x16];
=20
 	u8         reserved_at_20[0x2];
 	u8         stall_detect[0x1];
@@ -1767,6 +1769,132 @@ struct mlx5_ifc_resize_field_select_bits {
 	u8         resize_field_select[0x20];
 };
=20
+struct mlx5_ifc_resource_dump_bits {
+	u8         more_dump[0x1];
+	u8         inline_dump[0x1];
+	u8         reserved_at_2[0xa];
+	u8         seq_num[0x4];
+	u8         segment_type[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         vhca_id[0x10];
+
+	u8         index1[0x20];
+
+	u8         index2[0x20];
+
+	u8         num_of_obj1[0x10];
+	u8         num_of_obj2[0x10];
+
+	u8         reserved_at_a0[0x20];
+
+	u8         device_opaque[0x40];
+
+	u8         mkey[0x20];
+
+	u8         size[0x20];
+
+	u8         address[0x40];
+
+	u8         inline_data[52][0x20];
+};
+
+struct mlx5_ifc_resource_dump_menu_record_bits {
+	u8         reserved_at_0[0x4];
+	u8         num_of_obj2_supports_active[0x1];
+	u8         num_of_obj2_supports_all[0x1];
+	u8         must_have_num_of_obj2[0x1];
+	u8         support_num_of_obj2[0x1];
+	u8         num_of_obj1_supports_active[0x1];
+	u8         num_of_obj1_supports_all[0x1];
+	u8         must_have_num_of_obj1[0x1];
+	u8         support_num_of_obj1[0x1];
+	u8         must_have_index2[0x1];
+	u8         support_index2[0x1];
+	u8         must_have_index1[0x1];
+	u8         support_index1[0x1];
+	u8         segment_type[0x10];
+
+	u8         segment_name[4][0x20];
+
+	u8         index1_name[4][0x20];
+
+	u8         index2_name[4][0x20];
+};
+
+struct mlx5_ifc_resource_dump_segment_header_bits {
+	u8         length_dw[0x10];
+	u8         segment_type[0x10];
+};
+
+struct mlx5_ifc_resource_dump_command_segment_bits {
+	struct mlx5_ifc_resource_dump_segment_header_bits segment_header;
+
+	u8         segment_called[0x10];
+	u8         vhca_id[0x10];
+
+	u8         index1[0x20];
+
+	u8         index2[0x20];
+
+	u8         num_of_obj1[0x10];
+	u8         num_of_obj2[0x10];
+};
+
+struct mlx5_ifc_resource_dump_error_segment_bits {
+	struct mlx5_ifc_resource_dump_segment_header_bits segment_header;
+
+	u8         reserved_at_20[0x10];
+	u8         syndrome_id[0x10];
+
+	u8         reserved_at_40[0x40];
+
+	u8         error[8][0x20];
+};
+
+struct mlx5_ifc_resource_dump_info_segment_bits {
+	struct mlx5_ifc_resource_dump_segment_header_bits segment_header;
+
+	u8         reserved_at_20[0x18];
+	u8         dump_version[0x8];
+
+	u8         hw_version[0x20];
+
+	u8         fw_version[0x20];
+};
+
+struct mlx5_ifc_resource_dump_menu_segment_bits {
+	struct mlx5_ifc_resource_dump_segment_header_bits segment_header;
+
+	u8         reserved_at_20[0x10];
+	u8         num_of_records[0x10];
+
+	struct mlx5_ifc_resource_dump_menu_record_bits record[0];
+};
+
+struct mlx5_ifc_resource_dump_resource_segment_bits {
+	struct mlx5_ifc_resource_dump_segment_header_bits segment_header;
+
+	u8         reserved_at_20[0x20];
+
+	u8         index1[0x20];
+
+	u8         index2[0x20];
+
+	u8         payload[0][0x20];
+};
+
+struct mlx5_ifc_resource_dump_terminate_segment_bits {
+	struct mlx5_ifc_resource_dump_segment_header_bits segment_header;
+};
+
+struct mlx5_ifc_menu_resource_dump_response_bits {
+	struct mlx5_ifc_resource_dump_info_segment_bits info;
+	struct mlx5_ifc_resource_dump_command_segment_bits cmd;
+	struct mlx5_ifc_resource_dump_menu_segment_bits menu;
+	struct mlx5_ifc_resource_dump_terminate_segment_bits terminate;
+};
+
 enum {
 	MLX5_MODIFY_FIELD_SELECT_MODIFY_FIELD_SELECT_CQ_PERIOD     =3D 0x1,
 	MLX5_MODIFY_FIELD_SELECT_MODIFY_FIELD_SELECT_CQ_MAX_COUNT  =3D 0x2,
--=20
2.24.1

