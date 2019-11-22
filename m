Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E126107A3C
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfKVVvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:51:52 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:24062
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726620AbfKVVvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:51:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUKHUzrCs0DyvWbXNHQEFKFsQOqdJq/dP6lW7nEg1qxy2ebNP4DXbOhYxwHY5hwtXaZTirXwFT98dFBoDUgXSTzlIUeVZB+33By7pzwxRTj1RjXhIbZC9fwY0aGifSdhdjujG1zdpkGMQhlgGvEaPMt8UClFghynVniQ+DKhCpaCtaD7fxVqcBap1PlMR0AiFLd+td+4HXKmMKH2kjn5f7BtvXybDO03cPZuNkS3m6F/n4+RlcoD7FHUK0E1pzm/DUcb9HOnHJQDWSZJ3O4v3kqng9zvzdYllx5irNgsKptOBpbLwCpZUUrkp19R4bGqHJgpdfIR50gh8WS7XQMSBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqGXl1zLQmhlnob0CbkcPYHUbKSY78oy3t8l9OrXa10=;
 b=Tti1gfOubgBbrQr1GOM3vbi/lpoqBEbtn3pJUCOD96+ZnlwKDTtILW5ah6AnE6/Hxbi5xZbp+U5IASIFUduS1MN6QkuSG0JAumrCZKZ6UtbfR3+rUbXFq8m4KB5cSw0qx9Ee9qzoxdc0Q4CegTR/UldupJ7JmOIzoJ/rtFeLeNy6z47UWZNK4N9rOWwbTCbPzlznlX57vLSL1MxzH4niwHdiQfWOy15K5w/8T9P5paWMDFLfhn+XZ1LEs1lGF9XoY6/zsEXkzZuyRah/ocZI+gm66WqcqZhxLmmEG6hb67yu8v+caYXzOmzRGIYNUJwEsA1Rqdfksb8M6GnEMQeOiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqGXl1zLQmhlnob0CbkcPYHUbKSY78oy3t8l9OrXa10=;
 b=JbPN8OFvxp54pRmuiwCUVJi6JwH3S0nRY0VPQh0awQYu+whgApUkDwjnU25rqGDearD0mdK6JAlmxHj3tqVCa74pwncoYlrJuxjZaE+wgRUmpuWrmNoCUDf4ILjVZpi0zYglAjcu9vBVKmxh557bGAcMT6zqoPV8+3BxY6tF9uY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5341.eurprd05.prod.outlook.com (20.178.8.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 21:51:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:51:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 0/6] mlxfw: Improve error reporting
Thread-Topic: [PATCH net-next 0/6] mlxfw: Improve error reporting
Thread-Index: AQHVoX8K10a7pcx1N0iUmfXviJYuOw==
Date:   Fri, 22 Nov 2019 21:51:48 +0000
Message-ID: <20191122215111.21723-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2fbd7cd7-c76f-4351-2ab5-08d76f962cb7
x-ms-traffictypediagnostic: VI1PR05MB5341:|VI1PR05MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5341DFE6D2F9B971BECE81C5BE490@VI1PR05MB5341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(189003)(199004)(107886003)(8676002)(386003)(6506007)(3846002)(36756003)(6512007)(26005)(478600001)(1076003)(316002)(66476007)(2906002)(6116002)(66556008)(64756008)(66446008)(71200400001)(71190400001)(99286004)(66946007)(66066001)(25786009)(4326008)(14444005)(256004)(54906003)(50226002)(102836004)(7736002)(186003)(305945005)(6436002)(6486002)(8936002)(52116002)(6916009)(14454004)(81156014)(5660300002)(81166006)(2616005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5341;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JHfC97CtVXmf//Z0k3KWmPxgBKZ0/I9DcoT6Q/0ICWqRtv0m/KN663UpzVSR3bckCImf7o6T3txywC6Enmku66O4igAz5iWc8Aki7aH6D6yOuT3/WgenJqUyB3ffETdvhbNC2Z7W9at+hI9UJXew40+tHoLuWjBDCzPsJxMebCi03P7+cOEcqm0LzakPQzSBcwpXE5+sMivWhDozb4UaRPf1N24E2ymRTQDR2MYL8O6IPjlXUP1bznnLcJLf+v1mWFJmrIyWJcXrsihqPZvU/KQ4wOVtHjtyOxFQIPkqkzPtwiarLHHU14QADn0G9DLruL1kAtWhxQSH3+nIIItQ0EWz6/cyvBqeqXU3cv1iUuLVcOhbPWAP595Q+5J1Bp16vGq64rDVW6nVouscpi/opITPy47fyKbbjJqE5x4BAjMMGTRWOnZnyHRvU9ueEuIu
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fbd7cd7-c76f-4351-2ab5-08d76f962cb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:51:48.3712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iQ/L8yqhH6TKyRRoXff4RVI5WyW7YVCs57h1SHYAzwRjQ3gU0tXyj9j+c/u72umBrk2yTAciyvLJ8f2p/zDMEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This patchset improves mlxfw error reporting of mlxfw to netlink and
kernel log.

1) patch #1, Convert extack msg to a formattable buffer

2) patch #2, Make mlxfw/mlxsw fw flash devlink status notify generic,
   and enable it for mlx5.

3) rest of the patches are improving mlxfw flash error messages by
reporting detailed mlxfw FSM error messages to netlink and more detailed
kernel log.

merge conflict with net:
@ drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c

++<<<<<<< (net-next) (keep)
+
+       if (fsm_state_err !=3D MLXFW_FSM_STATE_ERR_OK)
+               return mlxfw_fsm_state_err(mlxfw_dev, extack, fsm_state_err=
);
+
++=3D=3D=3D=3D=3D=3D=3D =20
+=20
+       if (fsm_state_err !=3D MLXFW_FSM_STATE_ERR_OK) {
+               fsm_state_err =3D min_t(enum mlxfw_fsm_state_err,
+                                     fsm_state_err, MLXFW_FSM_STATE_ERR_MA=
X);
+               pr_err("Firmware flash failed: %s\n",
+                      mlxfw_fsm_state_err_str[fsm_state_err]);
+               NL_SET_ERR_MSG_MOD(extack, "Firmware flash failed");
+               return -EINVAL;
++>>>>>>> (net) (delete)=20

To resolve just use the 1st hunk, from net-next.

Thanks,
Saeed.

---

Saeed Mahameed (6):
  netlink: Convert extack msg to a formattable buffer
  net/mlxfw: Generic mlx FW flash status notify
  net/mlxfw: Improve FSM err message reporting and return codes
  net/mlxfw: Convert pr_* to dev_* in mlxfw_fsm.c
  net/mlxfw: More error messages coverage
  net/mlxfw: Macro for error reporting

 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   1 +
 drivers/net/ethernet/mellanox/mlxfw/Kconfig   |   1 +
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  36 ++--
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 162 +++++++++++++-----
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  17 +-
 include/linux/netlink.h                       |  27 ++-
 lib/nlattr.c                                  |   2 +-
 7 files changed, 162 insertions(+), 84 deletions(-)

--=20
2.21.0

