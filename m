Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9871814907D
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgAXVzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:55:00 -0500
Received: from mail-am6eur05on2040.outbound.protection.outlook.com ([40.107.22.40]:49114
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbgAXVzA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:55:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdW1nEUHWv4oqmCvKj1dVKA4OLGkoLNbDae61WP9snWR42T8h1m4A/GXyZ/9SugMqRMi9tLSDliS02QWm+2S32I1DhdUNqLMtCigVDkKtUUVWtXSIleu0s4v0BpTfhd4LN1RmaKji2kTo2rM9hCFlc4RZJFu9dXOCpXdXLmOZ+vg1FqZp2UlZK72OG5vYT9XGa59OII3iAgjXxxlGAJr7uPF97aPx4kaS959j6eCptJpF+JZ4NE2cbwgimJAUwCUlUuheF1xTnmHWTDmjHDhp0ryy5iQY7rWG1R90aoiQjwkAI6FPTqQBJCdBR2r98u9KjlKOSqdzQbgR1U3BUPHPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCeNy6b4TcKibeMNX4Kg5vAszUhedG0Jv0DMP5Q7akQ=;
 b=hEYSvt1ZvFojsujaN/hicClEtQIatEN1RUfYGysqslSVzKAWsxix4BsxEVwSWG0f+/kPWZxDMplBJwPSxO0N6h6qAwRFlrWvto0ItDC0tF+Lcl0s/DS8T0S5FMtgzJhOefWNsU6QHnnZTyZsJbW8w3llxngp4/utGSsSAIP+O0JN87gxaq8PlqxeS97LirCV8jE+XeHwLdyS9YoRTd5gI0KfR7Vq/0cQU/HyhrR76PEYhDmKDPe1SNbs0+REmYfafXvMS58KTgAXOCYFSt7/XA/TRpLn7B7FgaXZgsdf+0oT16yyH7iMVywFV/lkBccfDv0C3j45RHxUTsQcuAGn6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCeNy6b4TcKibeMNX4Kg5vAszUhedG0Jv0DMP5Q7akQ=;
 b=XGGWbGByASab4u1mOKolIHTFn3TJXegXepx+pijcQlnIzBRxcTLSytAiOPlofpGdCz5KDt+Xd/AVeY0P1Pc5sMD6UsA+cbYNE+Td/hhsu//FgdVfDm9yxlNY/eveVR/KO0K5YLWM/z4Vhwkn60jTe6DHsIiFnUGWzx2Q7XVdgSc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5456.eurprd05.prod.outlook.com (20.177.201.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:54:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:54:51 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 21:54:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/14] devlink: Force enclosing array on binary fmsg data
Thread-Topic: [net-next 01/14] devlink: Force enclosing array on binary fmsg
 data
Thread-Index: AQHV0wDn/Ks2HCnTvEeLcw0dX319pg==
Date:   Fri, 24 Jan 2020 21:54:50 +0000
Message-ID: <20200124215431.47151-2-saeedm@mellanox.com>
References: <20200124215431.47151-1-saeedm@mellanox.com>
In-Reply-To: <20200124215431.47151-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR17CA0038.namprd17.prod.outlook.com
 (2603:10b6:a03:167::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cac255b1-a7aa-4900-fc01-08d7a1180969
x-ms-traffictypediagnostic: VI1PR05MB5456:|VI1PR05MB5456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB54568703EBE5F8713C8C9710BE0E0@VI1PR05MB5456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(956004)(4326008)(107886003)(5660300002)(316002)(54906003)(478600001)(6666004)(8936002)(2616005)(6916009)(26005)(52116002)(6506007)(36756003)(8676002)(81166006)(81156014)(86362001)(16526019)(186003)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(6486002)(71200400001)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5456;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MXl8s3bNoM9RNAK/IFApi0vveP5A65l5tvTqfQf5QnKupo7XS125pOm+4ykK8gAiQk9LkATLHotONA4aUkelMGg+iuPOdAPfuw4/pd9y9f3peQZU4Gi+er3sSIeqzlimboUecX1M0uJiOFueFgOAC7nhPdjqCH896KjWW8fALfSWYbHYUmRwFb4QfCM6fjoWfnl2IiPkr0fvujM6QXgzNqkEUnyxqi8sUGVINyWK7goy1Hov85vZ5w4cP+XkMBcSAk8UjnuJy2mueuHO4vjs3DwpfmaDFzCpmqkzFmynYr396w5nRBIhp7jfm4UDV/8lf542uc7tZfLRSaNlkc2cut78Si3Qcr0uudtcZaMQ5qQuCmB9oiQzCLMONGz+B5IDNAD704lh4wsk7xXjgMUtOZVx//QOwXRDB3YhxZ4va/j5/0Z1Z3rPsqUu1/XbIKKKpYfVSugVGqbcbyGgX1sIKQpSUBFK3bpVjMLiWGrKVgZJleQhitcPh8jKC7NcR61yCN1bnBHOpukzbJMF7UaEdBmU/7Bj+yM9QLsgVLUDgSU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac255b1-a7aa-4900-fc01-08d7a1180969
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:54:50.9500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uemZSFZM1T9gtsFFrMOmqedz7+qEJ/+KHEV78po239sfWxreH2K42xEJyh6dE3Z31opR26GmmmcGS+g6emjl3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5456
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add a new API for start/end binary array brackets [] to force array
around binary data as required from JSON. With this restriction, re-open
API to set binary fmsg data.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/net/devlink.h |  5 +++
 net/core/devlink.c    | 94 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 91 insertions(+), 8 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 5e46c24bb6e6..182a5e69355b 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -979,12 +979,17 @@ int devlink_fmsg_pair_nest_end(struct devlink_fmsg *f=
msg);
 int devlink_fmsg_arr_pair_nest_start(struct devlink_fmsg *fmsg,
 				     const char *name);
 int devlink_fmsg_arr_pair_nest_end(struct devlink_fmsg *fmsg);
+int devlink_fmsg_binary_pair_nest_start(struct devlink_fmsg *fmsg,
+					const char *name);
+int devlink_fmsg_binary_pair_nest_end(struct devlink_fmsg *fmsg);
=20
 int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value);
 int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value);
 int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value);
 int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value);
 int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value);
+int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
+			    u16 value_len);
=20
 int devlink_fmsg_bool_pair_put(struct devlink_fmsg *fmsg, const char *name=
,
 			       bool value);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 64367eeb21e6..4791dd8f9917 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4231,6 +4231,12 @@ struct devlink_fmsg_item {
=20
 struct devlink_fmsg {
 	struct list_head item_list;
+	bool putting_binary; /* This flag forces enclosing of binary data
+			      * in an array brackets. It forces using
+			      * of designated API:
+			      * devlink_fmsg_binary_pair_nest_start()
+			      * devlink_fmsg_binary_pair_nest_end()
+			      */
 };
=20
 static struct devlink_fmsg *devlink_fmsg_alloc(void)
@@ -4274,17 +4280,26 @@ static int devlink_fmsg_nest_common(struct devlink_=
fmsg *fmsg,
=20
 int devlink_fmsg_obj_nest_start(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_OBJ_NEST_START);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_start);
=20
 static int devlink_fmsg_nest_end(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_NEST_END);
 }
=20
 int devlink_fmsg_obj_nest_end(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_end(fmsg);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_end);
@@ -4295,6 +4310,9 @@ static int devlink_fmsg_put_name(struct devlink_fmsg =
*fmsg, const char *name)
 {
 	struct devlink_fmsg_item *item;
=20
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	if (strlen(name) + 1 > DEVLINK_FMSG_MAX_SIZE)
 		return -EMSGSIZE;
=20
@@ -4315,6 +4333,9 @@ int devlink_fmsg_pair_nest_start(struct devlink_fmsg =
*fmsg, const char *name)
 {
 	int err;
=20
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	err =3D devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_PAIR_NEST_START)=
;
 	if (err)
 		return err;
@@ -4329,6 +4350,9 @@ EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_start);
=20
 int devlink_fmsg_pair_nest_end(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_end(fmsg);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_end);
@@ -4338,6 +4362,9 @@ int devlink_fmsg_arr_pair_nest_start(struct devlink_f=
msg *fmsg,
 {
 	int err;
=20
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	err =3D devlink_fmsg_pair_nest_start(fmsg, name);
 	if (err)
 		return err;
@@ -4354,6 +4381,9 @@ int devlink_fmsg_arr_pair_nest_end(struct devlink_fms=
g *fmsg)
 {
 	int err;
=20
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	err =3D devlink_fmsg_nest_end(fmsg);
 	if (err)
 		return err;
@@ -4366,6 +4396,30 @@ int devlink_fmsg_arr_pair_nest_end(struct devlink_fm=
sg *fmsg)
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_arr_pair_nest_end);
=20
+int devlink_fmsg_binary_pair_nest_start(struct devlink_fmsg *fmsg,
+					const char *name)
+{
+	int err;
+
+	err =3D devlink_fmsg_arr_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	fmsg->putting_binary =3D true;
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_start);
+
+int devlink_fmsg_binary_pair_nest_end(struct devlink_fmsg *fmsg)
+{
+	if (!fmsg->putting_binary)
+		return -EINVAL;
+
+	fmsg->putting_binary =3D false;
+	return devlink_fmsg_arr_pair_nest_end(fmsg);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_end);
+
 static int devlink_fmsg_put_value(struct devlink_fmsg *fmsg,
 				  const void *value, u16 value_len,
 				  u8 value_nla_type)
@@ -4390,40 +4444,59 @@ static int devlink_fmsg_put_value(struct devlink_fm=
sg *fmsg,
=20
 int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_FLAG);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_bool_put);
=20
 int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U8);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_u8_put);
=20
 int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U32);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_u32_put);
=20
 int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U64);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_u64_put);
=20
 int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, value, strlen(value) + 1,
 				      NLA_NUL_STRING);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_string_put);
=20
-static int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *=
value,
-				   u16 value_len)
+int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
+			    u16 value_len)
 {
+	if (!fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_put_value(fmsg, value, value_len, NLA_BINARY);
 }
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_put);
=20
 int devlink_fmsg_bool_pair_put(struct devlink_fmsg *fmsg, const char *name=
,
 			       bool value)
@@ -4534,10 +4607,11 @@ int devlink_fmsg_binary_pair_put(struct devlink_fms=
g *fmsg, const char *name,
 				 const void *value, u32 value_len)
 {
 	u32 data_size;
+	int end_err;
 	u32 offset;
 	int err;
=20
-	err =3D devlink_fmsg_arr_pair_nest_start(fmsg, name);
+	err =3D devlink_fmsg_binary_pair_nest_start(fmsg, name);
 	if (err)
 		return err;
=20
@@ -4547,14 +4621,18 @@ int devlink_fmsg_binary_pair_put(struct devlink_fms=
g *fmsg, const char *name,
 			data_size =3D DEVLINK_FMSG_MAX_SIZE;
 		err =3D devlink_fmsg_binary_put(fmsg, value + offset, data_size);
 		if (err)
-			return err;
+			break;
+		/* Exit from loop with a break (instead of
+		 * return) to make sure putting_binary is turned off in
+		 * devlink_fmsg_binary_pair_nest_end
+		 */
 	}
=20
-	err =3D devlink_fmsg_arr_pair_nest_end(fmsg);
-	if (err)
-		return err;
+	end_err =3D devlink_fmsg_binary_pair_nest_end(fmsg);
+	if (end_err)
+		err =3D end_err;
=20
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_put);
=20
--=20
2.24.1

