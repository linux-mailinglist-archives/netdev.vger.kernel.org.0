Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926438D643
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfHNOeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:34:11 -0400
Received: from mail-eopbgr20074.outbound.protection.outlook.com ([40.107.2.74]:13508
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725955AbfHNOeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 10:34:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H14hS3rUK2xNHoxeSGeKy/sTo6NWf42LyC02IUfSSTpsjz7sKQ40hFfVGURp/1Zv/A0SGHRSs9QsAJFZComEZ6TQV/t/Aj+JBi2j4ErQbb24/n28o80hYg8xLGSFlbI063Bu8aAQ0I/ryvLHMl+k2mlBA6ViZD1eVubyXkS8rYcygo2UeRDQM3v3iGSvDoVJo10qvEnTY3+rTICSyxB1OoWWMvjbJmgE2LrWFiiLnStpGIYp2ZAdZi0qNaF0uDuWYk3E27YUxIKigVvZDsXljvPpzrBIfs6ILJQCqFVBQp3A9wFEihxjKtGcTHvAc22i2pfL1XZEcE5m4KYmIB2XtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7zf2zNQzm32xvMEhDeiqIeQyYosEvwiy3stj8OKHgc=;
 b=CNejvpsuqjLaBixEndAwwA7Daf8HK2LyU4JP+J2PV3YZrm29T/pdw0KFzWSK2VmqrCK6qvZEPnpLRomzIvSXwKiAs25T/FghjkFZgDd2eKq59Y93cUfWXF1vB0amOxUNjk2ejmLCG9Romwkwjp+Lvrv7+XlQkVOrXvXYG1BtU3CAyE8bVUx+hF2NZY70dMCauGDmuK8+4D7UYOcDbZHt9aqik/RZXmLGkyVAkTEzd6pgUk43e/706Zh70zJlFm6RSc60PyQ68UmvsKWkaza7/zHuzep+M7i6zzYvpQv2cnEaO4fG/iX7SCdXLDrjt6GQCt3tJGOZUlpSI9RIHb0n6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h7zf2zNQzm32xvMEhDeiqIeQyYosEvwiy3stj8OKHgc=;
 b=k7TYGOLPv0z7SO4nB8Moqh92xtpBdYCn6WRS3Y77cUMnK7avtpo6SrLEAPJGpAhvKVdF00z52oYnW3zwjtt+OqZ5zSNG9RA444jpUk13HvAfJhRF/Am4xh7xA+/cbjF3B2URX/cn1tlZrD5Ta+mB2+BaZKKeHRVmldSav9q1HHQ=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5750.eurprd05.prod.outlook.com (20.178.95.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Wed, 14 Aug 2019 14:34:06 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7%5]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 14:34:06 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf-next v2] net: Don't call XDP_SETUP_PROG when nothing is
 changed
Thread-Topic: [PATCH bpf-next v2] net: Don't call XDP_SETUP_PROG when nothing
 is changed
Thread-Index: AQHVUq1TcF+6WG05QEaQNq3RwsneQw==
Date:   Wed, 14 Aug 2019 14:34:06 +0000
Message-ID: <20190814143352.3759-1-maximmi@mellanox.com>
References: <5b123e9a-095f-1db4-da6e-5af6552430e1@iogearbox.net>
In-Reply-To: <5b123e9a-095f-1db4-da6e-5af6552430e1@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0265.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::13) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 719ff8d6-fbf0-47d9-002f-08d720c47604
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5750;
x-ms-traffictypediagnostic: AM6PR05MB5750:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB57509EFA50035BB9CA8A0DEBD1AD0@AM6PR05MB5750.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(199004)(189003)(86362001)(64756008)(478600001)(66946007)(107886003)(76176011)(186003)(486006)(66446008)(14454004)(66556008)(66476007)(2616005)(476003)(11346002)(26005)(6506007)(386003)(4326008)(52116002)(6436002)(36756003)(6486002)(1076003)(25786009)(110136005)(5660300002)(99286004)(6512007)(54906003)(53936002)(5024004)(8936002)(102836004)(8676002)(81156014)(81166006)(305945005)(7736002)(66066001)(3846002)(2906002)(6116002)(50226002)(316002)(7416002)(14444005)(446003)(256004)(71200400001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5750;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yJN0vMEeQXFj3mheTyUWrFxz4FJ6fO0kkhddVsd1Zu3K9t9MUqHAusHugcBwgj49u2aOhHHfvEGmU6IOsUOIaloBYwFzEutYixXoNWPWwslvv6KUfM7/7OMYcBHwJG29f+Ia+zig5s+C04ByY/cQ9eZ2L2W4mEQR+WAXjKaRXLF5g/LJBcDVj1FljSDrnIO3SQCWMILOIyHyzJW/cDgvfTTEl7cFauCbZP35kvVt1bVX60ZyhpeWst2bNSQlvMFgUYsdPz8WwOlmJZS63PnDSZ/uri6PcmUahIPgfSbe80uizHLkpD8mENDsNj3eZzE73g6Qbz1WIpA49v7HOFe12g8l7bKhjduNFv/oEEV4ZdIroome8H60R37xSiQcEJF0A/qkfAtwx4Sv1oUtuqvjsmzV+rv30IT5A4JrO1Bupew=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 719ff8d6-fbf0-47d9-002f-08d720c47604
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 14:34:06.5185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WLQIGimGUl8CIElkOvamdHhlzCh+1IZidVallMV4xj4UiStfURRiJjqgKpyK0KEQak9vFLkwPUpqg01bJur73w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5750
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't uninstall an XDP program when none is installed, and don't install
an XDP program that has the same ID as the one already installed.

dev_change_xdp_fd doesn't perform any checks in case it uninstalls an
XDP program. It means that the driver's ndo_bpf can be called with
XDP_SETUP_PROG asking to set it to NULL even if it's already NULL. This
case happens if the user runs `ip link set eth0 xdp off` when there is
no XDP program attached.

The symmetrical case is possible when the user tries to set the program
that is already set.

The drivers typically perform some heavy operations on XDP_SETUP_PROG,
so they all have to handle these cases internally to return early if
they happen. This patch puts this check into the kernel code, so that
all drivers will benefit from it.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
v2 changes: Cover the case when the program is set, but isn't changed.

 net/core/dev.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 49589ed2018d..b1afafee3e2a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8126,12 +8126,15 @@ int dev_change_xdp_fd(struct net_device *dev, struc=
t netlink_ext_ack *extack,
 		bpf_chk =3D generic_xdp_install;
=20
 	if (fd >=3D 0) {
+		u32 prog_id;
+
 		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
 			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the s=
ame time");
 			return -EEXIST;
 		}
-		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) &&
-		    __dev_xdp_query(dev, bpf_op, query)) {
+
+		prog_id =3D __dev_xdp_query(dev, bpf_op, query);
+		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && prog_id) {
 			NL_SET_ERR_MSG(extack, "XDP program already attached");
 			return -EBUSY;
 		}
@@ -8146,6 +8149,14 @@ int dev_change_xdp_fd(struct net_device *dev, struct=
 netlink_ext_ack *extack,
 			bpf_prog_put(prog);
 			return -EINVAL;
 		}
+
+		if (prog->aux->id =3D=3D prog_id) {
+			bpf_prog_put(prog);
+			return 0;
+		}
+	} else {
+		if (!__dev_xdp_query(dev, bpf_op, query))
+			return 0;
 	}
=20
 	err =3D dev_xdp_install(dev, bpf_op, extack, flags, prog);
--=20
2.20.1

