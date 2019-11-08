Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC1EF5BF7
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfKHXp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:45:26 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:11398
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726640AbfKHXpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 18:45:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/AmVggqR5rVUY02wyE3MFlTqW+1hoGvDY9gwT64kqA6wI27KZSVsqyJMsav5c1sev9vmFFlWgB/U0tf+mLspW0VyYvE4XTy9uKHEzBvJctfTbpD6dxno/TjE1159DRSgcfo9Ii2Mb5gQp1qe0D4TS5mmmsox1dWaH6o61uqOqzncdwsggmcFXds6vUHA68opRfKfYwoOieAujJocIIr0URXzhJgf/pYVYpimAVaYbY6N3KB8IE/vWs6tWLC3wiY+Vz5nS0zCEL2bCnhgTncFbO1s7rzV5fOvmRTWkdCc6hxDKs0oO3Uwx7akxHkASBBOfCvwhEGlmQvxooDbU7WcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LLvxzyFaTNAYMMY1fN7lWYpHivs1AMahEeBeH/2+tEg=;
 b=DQWwDl+gpzxmDe2w7L2aulca+GvUSCsyR4/j2h1ALMDf9RqiETVIXpzUqy7vg+dBqrvFkqzoTBNgIstT4t4o2ELFP7YtLUoTS3+79aRv6J2mWnjgbZWtgf4eDqZ0czxjCQIQI8XX2KWofaPJMwKDax3wyAAxC5y+DphAzttErPZH0VWcPTyWjESIQLWfZqTnGU8oXw55rAnTWm6GXQCi9Cq50lPbbrB4HI4v1/h17v+YhBIvHs2F1dx82OzELBa8TX96fFwx/niBdJ2OXn1sVKuCFhBX+UjiZK/HSzZtJScWAlzbs1xwgq0H0VdsYu7HgTgHfSbXwB5AfM+EjQskQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LLvxzyFaTNAYMMY1fN7lWYpHivs1AMahEeBeH/2+tEg=;
 b=THmMZ8FWWp8O+opcCX9gh+Wa4JrDUwHCiSx303AX5l6SbyV7uRY3ek7kGLUG39BMyMAZLzBjULHeJDkRb9jh57vmV28VxkV7/Uj3isvgZgvfSc0lZt0GxCLkFJXh9whDnit+sUMM/WH4V6L7Mb2R2Pre4YrLwQrBgx1+lGEwd5A=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4334.eurprd05.prod.outlook.com (52.133.14.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 23:45:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 23:45:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH mlx5-next 1/5] devlink: Add new "enable_roce" generic device
 param
Thread-Topic: [PATCH mlx5-next 1/5] devlink: Add new "enable_roce" generic
 device param
Thread-Index: AQHVlo6UhJsqrRgluUeov6OdqpldAA==
Date:   Fri, 8 Nov 2019 23:45:20 +0000
Message-ID: <20191108234451.31660-2-saeedm@mellanox.com>
References: <20191108234451.31660-1-saeedm@mellanox.com>
In-Reply-To: <20191108234451.31660-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR21CA0030.namprd21.prod.outlook.com
 (2603:10b6:a03:114::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9bdbe055-3712-449e-8415-08d764a5b710
x-ms-traffictypediagnostic: VI1PR05MB4334:|VI1PR05MB4334:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB43345861674E4257E309053ABE7B0@VI1PR05MB4334.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(189003)(199004)(2616005)(102836004)(36756003)(450100002)(52116002)(486006)(71200400001)(1076003)(71190400001)(6636002)(107886003)(14454004)(4326008)(478600001)(110136005)(256004)(66946007)(25786009)(66476007)(66556008)(64756008)(66446008)(86362001)(5660300002)(316002)(6506007)(6116002)(8936002)(50226002)(3846002)(186003)(6436002)(6486002)(81156014)(446003)(8676002)(26005)(14444005)(2906002)(76176011)(305945005)(99286004)(6512007)(386003)(7736002)(66066001)(54906003)(11346002)(81166006)(476003)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4334;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /hfPjowgBcmS7DFvC8/3hZ37XLD87FJ1qIUxw8anKDZHDkB7sQulMEAH6tIX4DC6T+7kMFSyPWIPcZYt0a8zq3/kZDCjgIZxejrCNpQ6l700WJd7U8LtrRQ4zEjnhqvJlTGXMyeJ5gTs9RVbvXZ9EEp6yQV4srPIyLUGr12/J9+NiU1ho4Z+b4364llreflr3AQtHkvIf2eHZ+W5mN9kT9r4iMOuJV3kRZSt+TzKw9FSNQYgUGvi3/pCimPr4Wk1PXESG7awTgPkcevTTji1Rcrk066akuq76Sb1HTfYV+45MKCjfuhkmYRQwaNcdlNAX92ZmbAV0hs8UnVGC0yUxkd0YZpHmmYs6P7Yv8/NHR71ZS2z+pktHFjIxwmrkFMcLX9PDXop6ZVAaitrESeDk3ktL0ZL096xB6ePC7ANuH0xespo0MKpkYM4GOqOpW30
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bdbe055-3712-449e-8415-08d764a5b710
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 23:45:20.3546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HCV79+uqU9YVhqGd/OkWvBxvdtUV4rD2tkWifpFUogubQyrzEUB8XVbVQILQzdO8gQKrhhmxlpQdOMUczEgATQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4334
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

New device parameter to enable/disable handling of RoCE traffic in the
device.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 Documentation/networking/devlink-params.txt | 4 ++++
 include/net/devlink.h                       | 4 ++++
 net/core/devlink.c                          | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/Documentation/networking/devlink-params.txt b/Documentation/ne=
tworking/devlink-params.txt
index ddba3e9b55b1..04e234e9acc9 100644
--- a/Documentation/networking/devlink-params.txt
+++ b/Documentation/networking/devlink-params.txt
@@ -65,3 +65,7 @@ reset_dev_on_drv_probe	[DEVICE, GENERIC]
 			  Reset only if device firmware can be found in the
 			  filesystem.
 			Type: u8
+
+enable_roce		[DEVICE, GENERIC]
+			Enable handling of RoCE traffic in the device.
+			Type: Boolean
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 23e4b65ec9df..39fb4d957838 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -400,6 +400,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_MSIX_VEC_PER_PF_MIN,
 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
 	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
=20
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -434,6 +435,9 @@ enum devlink_param_generic_id {
 	"reset_dev_on_drv_probe"
 #define DEVLINK_PARAM_GENERIC_RESET_DEV_ON_DRV_PROBE_TYPE DEVLINK_PARAM_TY=
PE_U8
=20
+#define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
+#define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id =3D DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f80151eeaf51..0fbcd44aa64f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2884,6 +2884,11 @@ static const struct devlink_param devlink_param_gene=
ric[] =3D {
 		.name =3D DEVLINK_PARAM_GENERIC_RESET_DEV_ON_DRV_PROBE_NAME,
 		.type =3D DEVLINK_PARAM_GENERIC_RESET_DEV_ON_DRV_PROBE_TYPE,
 	},
+	{
+		.id =3D DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+		.name =3D DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
+		.type =3D DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
+	},
 };
=20
 static int devlink_param_generic_verify(const struct devlink_param *param)
--=20
2.21.0

