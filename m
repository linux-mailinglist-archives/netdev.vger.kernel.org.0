Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F76104666
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 23:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfKTWWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 17:22:40 -0500
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:31714
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbfKTWWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 17:22:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXLZ1iIoIstpv7SUWQpgr8Xi+WTCtESzP33YTrkpZalEZUgvKfxCQ6VIQdre85buDpasaHaDGT8aaSKwdai6Gv2dBj+xcUatU/oiUUKDb0naRcUMsWXh5QosjeMkqAUjxPv764XsdRdPNt13rcsAWRAF4xCTQAu1phv3qbZTovp3N4J2qoQMpRa/cIb4/g9AKRMiUtct6Ux6bc98l6RZorWPx6RYfs5Iryvb7HkPOhW2pXO6UbS0IH+ocWSVBK95EN9xbEYzlJ0C9a0fglh5SOR16xjohBiMyUXBUhf1HfMWBKxVBKyYBUepMFgEf1177JsgvJkEp9jPAKaoVPiL8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s5v3Pmxv0dSIn9wGEsp8rSgJZG5V1DohEXKE1lHJ/Tg=;
 b=HB3nU+epv/2xXbPUEbskjFkX7gSDrPegPTCJI6alDcKKVAfJvQf7+YfaDbvaD6eUu2uWr1Yt5rpEwRv6y5GRh9mUpHN9up1aBnBMfhepa9wnZ2qziy5xdoJ5mf5ltuvAzy/Sq9bu3CSj9mn43D5F41rSxTRo7UkMlGLFVYiUF92Gm+3y9kn5DhcDH7dmIssJRmE5xvqWjaTARcBd1/VmH/2g+pVeA1z9u383rv/2AAz/ZcTIhLN1V1mZhKGRwM72Srr/s6QhG0jYEmgQwMSjes1KFzg6/pphSGU4KBDOL/KYgdpnST7ZoKHj+o3GPT/3XXOXY0SfxZp7hQFJNsDLrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s5v3Pmxv0dSIn9wGEsp8rSgJZG5V1DohEXKE1lHJ/Tg=;
 b=UMxk5B4SMsvTTSEPXmcTLzeFVuqSC/VV4zZJVK6qNYMKNx5ayFgjtoV+9dwXgq4ywc5/vRxCoZC+wzuYuOVJZcnQPGIArzHiTMcqw9W4Yg+ok36+X9PhY9Owvlf4kvm8jzOmAcVVW4UR4t4uHcZiv2a7OR34Gh5kLPpRMo+IX2E=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5341.eurprd05.prod.outlook.com (20.178.8.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 20 Nov 2019 22:22:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 22:22:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH mlx5-next 5/5] net/mlx5: Expose resource dump register mapping
Thread-Topic: [PATCH mlx5-next 5/5] net/mlx5: Expose resource dump register
 mapping
Thread-Index: AQHVn/D/ELG/SdH05Uakfhb1bvWXbQ==
Date:   Wed, 20 Nov 2019 22:22:30 +0000
Message-ID: <20191120222128.29646-6-saeedm@mellanox.com>
References: <20191120222128.29646-1-saeedm@mellanox.com>
In-Reply-To: <20191120222128.29646-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 22f276a7-b310-41f6-20c5-08d76e0821c2
x-ms-traffictypediagnostic: VI1PR05MB5341:|VI1PR05MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5341FE4A3BDA95F258CC75EDBE4F0@VI1PR05MB5341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(189003)(476003)(102836004)(316002)(99286004)(66476007)(76176011)(8936002)(14454004)(386003)(2906002)(6506007)(52116002)(110136005)(6436002)(446003)(6486002)(66556008)(54906003)(2616005)(66446008)(478600001)(64756008)(66066001)(66946007)(6636002)(5660300002)(11346002)(486006)(50226002)(81166006)(71190400001)(71200400001)(7736002)(186003)(305945005)(81156014)(36756003)(25786009)(8676002)(4326008)(6512007)(450100002)(14444005)(256004)(86362001)(6116002)(3846002)(1076003)(107886003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5341;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uUi3Nirs6DgOiJFaVae5bVYAmLE4H74+qC7ttLqBXgivyOPoTJs1Kwv3pX7n175a6QZeoq3Kxd3p84tM5Tk902QTMbTDGtAoHa0ba1rE6H4VPWq2+481/PCNrPK0y6aKMQzGyw3Y6GjKyBo4eagnu+q+fISkUyUCadqVV+13dO0VLmRxgWpIhPuCVyUcpCpM4L85bSBDQPfmLS7R4MZ+5FQXPJq/FOb291b58d6OybyN17EVaLc7kXVKMEV8HNVy2OEPcyYoe9JGNt5efgbHT32KQ3iNVNsAUHBqNcu+rzbRNbKSvEFNv5hkjcIWYFWWWnYj0FN//pEMziMUBXo4V+P2RkmuJpAdYTUTrQlEwYtdDt0xIDN5X14/3P9XlGZvXaA7Iq6pOdkhZa8I7Q6z9NLsVZuXsxWRRpMC/6C60xaEJGFkIrB6kT9DiCya9nrw
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f276a7-b310-41f6-20c5-08d76e0821c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 22:22:30.3037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YB1aimL4Z/qWm1E/15pABKljpuuOwMHOUsQL5j7syji0kY08vTWuUbzqIkYdbjTqbsJzqy+m9QPvJgA1eLEGQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5341
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
index d479c5e48295..8165d30e8b81 100644
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
index 9107c032062f..a96c9ce4e27a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -822,7 +822,9 @@ struct mlx5_ifc_qos_cap_bits {
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
@@ -1753,6 +1755,132 @@ struct mlx5_ifc_resize_field_select_bits {
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
2.21.0

