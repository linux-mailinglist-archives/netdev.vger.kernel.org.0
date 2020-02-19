Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1133163B0C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBSDXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:08 -0500
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:22272
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726648AbgBSDXH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nl/Pn5r/IwJCHEI0hud8oVXG8anqVOTVhodgG0TjA7N8Gl7jtXTI46Ov2iBbyY23XdiQ1bPqKV1+qO4kxOFV3grTSz8FzyzfnaU8zRt+uP22KmMDLvNZdPLqD3xDs2lMwVZHOnlxkIpS9Rw0pkSwNZ+Kqga4JN+hC4/dR2/daMcpVF8+/1SUFA3Zwe/S6QvMj2gySr5ZaS/uzoCOSQNY9JLxYVUa05rwDaddgKKY8YlDynU9k8NiSB83ms6X75RrQf8ef2JJQsR/Z1CyVdEPyhwMHmE5A7RM0pZoPHhNAC94JckPJAZ8OewoK8McvGBXmqDjkKk1Z1GS9Zt1xHO7Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2kYYuNHy9LWH5e0eC+52NnM6uFBoMTnYcrYxW26pxs=;
 b=VR+NAJmgrzEmjovhffIgDqZZDfEVjCbtr5CNEX6PiNNFx035bkcX1HZxnC5BnN2Atg4o+N9XKpTeIkh0vzfuhuERUJEoQnAyKfYl41HZnfGm22hoDpHVxMoY/YiSdp9M9v2k1aOD1eN7Qw+zDHCUCRP+FMZKcxHfU+2v4yMLctxFDErfG8RsH7DF7713pccSdD7mYwj81i6Lyd8v/7kcIHaLRx30xK5tQ64iPuTKOs89lFcXetKTBn0isjPnk3ahpkAy2nrcjqJ8IefjtkQ92ncF3tUuDjcNkPPf3sWKKI/EvYrHNNSevj/U/DMAR66i/lBhBlAbuyRYY8tUTefE9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2kYYuNHy9LWH5e0eC+52NnM6uFBoMTnYcrYxW26pxs=;
 b=KFCodX7nYneACEXV9TaGzaKTPjPU407i+QxE+nHemp7k9VvmKDmiq0FhQGgoNLawqKxh+lR+HhjS0dAYRIlDFhKMC7AZkABhvD3Nr1prPzADcRS+fTkjYpYQUX/9VZB+HGb6io//r2OFZglXXLY6UFlvxWdhlOAqw3WpYNbVIlQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4590.eurprd05.prod.outlook.com (20.176.5.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Wed, 19 Feb 2020 03:23:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:23:01 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:22:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 01/13] devlink: Force enclosing array on binary fmsg
 data
Thread-Topic: [net-next V4 01/13] devlink: Force enclosing array on binary
 fmsg data
Thread-Index: AQHV5tPjimCJiPalR0W58xSwjMFN0g==
Date:   Wed, 19 Feb 2020 03:23:01 +0000
Message-ID: <20200219032205.15264-2-saeedm@mellanox.com>
References: <20200219032205.15264-1-saeedm@mellanox.com>
In-Reply-To: <20200219032205.15264-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c0291572-8a4f-4845-6f50-08d7b4eb0640
x-ms-traffictypediagnostic: VI1PR05MB4590:|VI1PR05MB4590:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4590FF8CD782419829A04836BE100@VI1PR05MB4590.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(2616005)(956004)(16526019)(498600001)(186003)(66446008)(6666004)(66556008)(71200400001)(26005)(86362001)(66946007)(66476007)(6512007)(36756003)(6486002)(64756008)(107886003)(4326008)(110136005)(8676002)(2906002)(5660300002)(54906003)(8936002)(52116002)(81156014)(81166006)(6506007)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4590;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FJbenAl41nD0Di7euHK2ElAnji4Wo+q8KwCWczg7agR4d0qms+N1YO4PjMVRQNd/5csom+RatYl0eOsIHzuk30rn3Wtel0KB9fBuTkaWAhcrqfBYv2YKEfvgTjJOo9EoUkZrL8ETbZupfupiS2ha1AGhSMreewRYPtnYQreS0D2VSrh9nXywgdJP423vCrPNbEXff4civBqwcQjjJnsRhxWmeCth4ezimU6PAQTz0hFyTMsD2pOLCBZaqeSzrGHSIWmebI63w1++WEhg7ULdJQndoLlFJcyEb6Th2p1Vv1dhMrddBAwv1ou+CP5o1x3v8WIUZITh1Uhhl7Ktg2N/gLdKViaTVykXe5VT3DeJEPazV4v47X9ooG9f1twkkESTBr7NhJNPXZkKzyzDLwHhRYH5O3axzTPmR3xov2ipOiW+N+3BRrSbOm356kry6mr8jCPY2e7dcZbxv7F5M+dKFzxndIoU4Rbug/3a7Ay2ed8YCCZP2KaRpecQJu1l3dqD7tLFUF26QevUVpxd6MzVFcwl43xv1ALyghWqxqYKBYI=
x-ms-exchange-antispam-messagedata: UE6ACsQGaSUIYWrVC/umbXERcXDMAZbZgJxNl1WzGU+lkAybRId4h8bFw7j0urqaq/wKDnNMRXP+mrvK8HNGHCo6XUo5x1EPBMBettfWW276erUjt+5CP3yY0LRBTcD8vulh5MNIx99DgwEg+ANkTA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0291572-8a4f-4845-6f50-08d7b4eb0640
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:23:01.4912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QSU9wHXBAUmReJyG6BQ2mGl2SCUCv5sZL6VGgWPTJ6xzrMHOXYLl4UaJMnI0gsrQkTwXXrsEn/qmCKrfMWbP0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4590
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
index ce5cea428fdc..149c108be66f 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -981,12 +981,17 @@ int devlink_fmsg_pair_nest_end(struct devlink_fmsg *f=
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
index 549ee56b7a21..216bdd25ce39 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4237,6 +4237,12 @@ struct devlink_fmsg_item {
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
@@ -4280,17 +4286,26 @@ static int devlink_fmsg_nest_common(struct devlink_=
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
@@ -4301,6 +4316,9 @@ static int devlink_fmsg_put_name(struct devlink_fmsg =
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
@@ -4321,6 +4339,9 @@ int devlink_fmsg_pair_nest_start(struct devlink_fmsg =
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
@@ -4335,6 +4356,9 @@ EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_start);
=20
 int devlink_fmsg_pair_nest_end(struct devlink_fmsg *fmsg)
 {
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
 	return devlink_fmsg_nest_end(fmsg);
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_end);
@@ -4344,6 +4368,9 @@ int devlink_fmsg_arr_pair_nest_start(struct devlink_f=
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
@@ -4360,6 +4387,9 @@ int devlink_fmsg_arr_pair_nest_end(struct devlink_fms=
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
@@ -4372,6 +4402,30 @@ int devlink_fmsg_arr_pair_nest_end(struct devlink_fm=
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
@@ -4396,40 +4450,59 @@ static int devlink_fmsg_put_value(struct devlink_fm=
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
@@ -4540,10 +4613,11 @@ int devlink_fmsg_binary_pair_put(struct devlink_fms=
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
@@ -4553,14 +4627,18 @@ int devlink_fmsg_binary_pair_put(struct devlink_fms=
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

