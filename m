Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63C49107AC4
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfKVWmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:42:00 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:57606
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726880AbfKVWl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:41:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dIjpCMt+9pbE6ddmOcsmJproJVbTZlU0IPNB02UwHWTO2T3An1AEnNOstZarGb4hu7px57us2jqr6hypBPX/DdTwb+DDLjPFE1a4/zWpFufY4fbgvxGgggkzGbNH8Uz+yV8TZ50zrm54nEpDkyUdiR4MsXiKJc64dhl2P5C/PVePxzlKTLHBby7I165ilkA2xvdwxjxkQpB8+1DK5KgT1cTrXpsXNq1YxmRnOu6DO1eQwYv0pIM5LV/PQ8EDn9Ge9/p8mQDRI9wsQ17RH+kRENjjxAF/VhwwaNNmgAi+wjC+tD1OVrfj9BAEailC/APbKBfDbtxlhjTvN2iEtW6APQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQl/f9sP36otlWapu5ADgExNhWeF/k8WEyUJ8wlWbsE=;
 b=TtHsyHnMZuh6pROnYMbKGfVnOGdyQOo8VCH9V6mznmu9c+j5l9Po4JAFm0IB2mmUnA75Ocoq2kKShsrA1Q+CXi1y0KGX0nv8379urqFfOzUojrEreU7AxFR+SDM+4QQ1SbIpRJ/tKJoMJyPUjns9ui7aZXEBkr2xKbxZ30yl/ilG4HOWpF1DUQ249O+NY7pm1dbOMPm+r24jPJCBXx35z5DaIqcJMuTil2EJ94pgJqXLqiyzBkzBIPEOwPdnsGIuu4334xpNn3Yt2HmkOIQ000nOSEE1u+GqTOgp5rrBkBv2t2fQeaEIoqaodnpKpulm3lP14ueVbyXvRYQatUIBZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQl/f9sP36otlWapu5ADgExNhWeF/k8WEyUJ8wlWbsE=;
 b=dggAQMdSCs8zllM5hBOWQK7Em6Y3Eh240Y0tSgPksVCVigQ2IaZqtzu6GxzXBnMpHbCmyF/rbmZG0F1d4o4L2Pb/YNXociNTzO7L5yaeWzO4qXwaNzrzpax6XHscd/rO+jJW1m2lbNSUyKio1rsQOOKjEctanYjEBRMo+nFulcU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6718.eurprd05.prod.outlook.com (10.186.162.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 22:41:45 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 22:41:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 net-next 0/6] mlxfw: Improve error reporting
Thread-Topic: [PATCH V2 net-next 0/6] mlxfw: Improve error reporting
Thread-Index: AQHVoYYETrCQjnektEyNYrPdK2kK0A==
Date:   Fri, 22 Nov 2019 22:41:45 +0000
Message-ID: <20191122224126.24847-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR16CA0008.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7bce19fc-3729-4758-0d48-08d76f9d2732
x-ms-traffictypediagnostic: VI1PR05MB6718:|VI1PR05MB6718:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6718DFEFC615BE42D08AE27CBE490@VI1PR05MB6718.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(189003)(199004)(14454004)(66946007)(64756008)(66556008)(1076003)(66066001)(66476007)(4326008)(6486002)(66446008)(14444005)(8936002)(6512007)(6916009)(7736002)(6506007)(26005)(256004)(305945005)(386003)(186003)(3846002)(102836004)(6116002)(2616005)(107886003)(2906002)(478600001)(99286004)(8676002)(25786009)(52116002)(81156014)(36756003)(81166006)(316002)(6436002)(54906003)(86362001)(50226002)(5660300002)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6718;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2jWSKZEPKn8cskjFHKSazge+n3D6ptu2DtUl/44/nNlSLnu3/V0PMYVf84Wp9N5rzU+uVziDT7lDODgkvlH40bmv/LCYpWjDpdkt0JoP1+OH7fEpLzmowiH+BTfVxND6Mw2hE7XAuM9deYyts7v3ext3IeCjWMJEtSll3mSoQBE93Bj8ZQVKi8flq1R4+pXbTjpmyZupBY5ourAcGYUVCPSPzL6s8z4N3IPr1arqT29upu/bwVCHF8YuRJw8VK0Gnti8a0N5kwbqP7JgBYQwwq+8jKkiAy8GW6OApdJZwZosmMptEiLpuarY33XhMudqs47y16nodz9jATMogzXgUVzfbhimNEGCREnQxuJPIHNtTuJI6DDyJWTSjsHO6QfqEDCa1FgCkVDkgTdSTu2AEulnongXxIVL3kv49VIQeWkDgifzq2rKQNLAMSyVXSSH
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bce19fc-3729-4758-0d48-08d76f9d2732
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 22:41:45.6063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gQIiFaiY6ObVp0rTjL41RxJ/JS//Vb40li3ucCfzOevWtxA0YIqOPaEtQVN3UKS0MIQZnhAoWKe2btZFLKQdWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6718
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

v2:
- Avoid long switch case and replace it with one call to NL_SET_ERR_MSG_MOD
  to format the message directly from the mlxfw_fsm_state_err_str table.

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
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  36 +++--
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 149 ++++++++++++------
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  17 +-
 include/linux/netlink.h                       |  27 ++--
 lib/nlattr.c                                  |   2 +-
 7 files changed, 145 insertions(+), 88 deletions(-)

--=20
2.21.0

