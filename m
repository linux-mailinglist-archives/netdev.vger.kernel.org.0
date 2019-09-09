Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3C0ADA1F
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 15:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbfIINjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 09:39:37 -0400
Received: from mail-eopbgr780075.outbound.protection.outlook.com ([40.107.78.75]:42640
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730592AbfIINjh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 09:39:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQjbFcwJWheUNCs0SXnRivgt38pNBiC19Fk7i6PZ3Y6LRIWzNe3EiaKFR4P9XR7IclPaSOUNYHQo/aDJ4+Hf14ulwY1d8KTVldSQ+vp+FFw4rzZgB9YidX52oGIKYUex6wGPPjF0QlR+HthuDoqsGb1MI8XqxeCmoq48fZpT/F86Xa8SMihZ2IdlGBr8dFg+LSke3A3uCW5JX7doRVGpXiCLZdB9mSSWQKCF/hbK8Nn6+iJIjutQKnOsxCua8Y9ycO9o2QeCcC5hSFHu1mCf52wIXKbfdU+BRvPnYpkNGkniNUUBvipbjioWDc4MHvn7b9JNjbAJ45Hj3B2MlNzoBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWy3EvrWH3zf3DLnnWBOrpH/S4ZfR56oT34uYYEK5eU=;
 b=hwEwSK3aAb+fym7AOqPxZWNfjKxO7NmSKvdMIFpIlqnk6p0MLo8EsxSgxQLzf+6/z7s+F1/6M0kOSZg9pqYMy12kzswgWz2L4gj/i7phY9SP8H0B+dfuxGBUMIfQh3RGJOw+VO4Y35vKVCbhlnU7MRAAglhdXoEHU1Hl05y+XFaX3t2mUD4Y2CjYITTjHRKZZGC3+Vwa+mP9dnbNnGzpuiYs6oT2L1ITBNjVszhiR0Op9Ci/wN28AH6Dyr1vsk40iqLr2hFFOYQ1bmmjFWHFfdY7M91vTkyd/RjPHO8A3I3Pw5ASXAchV0e6SYiGXaW2UuQgBH9qfRqjRxPZfhNodw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWy3EvrWH3zf3DLnnWBOrpH/S4ZfR56oT34uYYEK5eU=;
 b=pzN8cp59HunglTE1kOQXqORv2MO/tO031r06UB5eRlnL7b+NwCT54/WGgbdE0+CPKClfWjx6DePxCkeqWQXhSFBRXplttLXCSA9UQ9XtzWyL9zeT4EHa/qyoJunoKKEfe6bw/05matE20D9nefvjjhY4AHOZzYgp3xWvRDYTf14=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1892.namprd11.prod.outlook.com (10.175.100.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.13; Mon, 9 Sep 2019 13:38:56 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 13:38:55 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 09/11] net: aquantia: implement get_ts_info ethtool
Thread-Topic: [PATCH net-next 09/11] net: aquantia: implement get_ts_info
 ethtool
Thread-Index: AQHVZxPtD/xCFRbNiE2y7qcafg+AYg==
Date:   Mon, 9 Sep 2019 13:38:55 +0000
Message-ID: <e3e53701e78fd45dabeb9b773663d30acd20ac7b.1568034880.git.igor.russkikh@aquantia.com>
References: <cover.1568034880.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1568034880.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0298.eurprd05.prod.outlook.com
 (2603:10a6:7:93::29) To BN6PR11MB4081.namprd11.prod.outlook.com
 (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39faecd8-1e21-4785-4fa2-08d7352b0f5d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1892;
x-ms-traffictypediagnostic: BN6PR11MB1892:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1892C288E06340A85EC16AFF98B70@BN6PR11MB1892.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:285;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(396003)(39850400004)(366004)(189003)(199004)(4326008)(99286004)(25786009)(7736002)(52116002)(6916009)(14454004)(8936002)(2906002)(44832011)(54906003)(2616005)(446003)(11346002)(71200400001)(476003)(71190400001)(316002)(50226002)(102836004)(478600001)(118296001)(6506007)(386003)(36756003)(53936002)(76176011)(6116002)(486006)(107886003)(6436002)(2351001)(6486002)(8676002)(186003)(64756008)(66446008)(5660300002)(66946007)(81166006)(14444005)(81156014)(1730700003)(26005)(66556008)(66476007)(86362001)(305945005)(256004)(2501003)(6512007)(66066001)(3846002)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1892;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H4k9V/thKBbRerlaZuhMA90DRE+u+CzNMB/qPM+H/EzdL8hUTztWXMw8fk6DO0P9swuz80VY27tMgbEiWiX/VPK1KN1SQ1wLnyl76S0rwqvHDi7YWhrhV/Ye9Cn/rGawlzNBuweVTD38Qt6MqseCNM46jVf0KkBwra5lBN3je1miXgcKzlbL86nVpYXHlrhmdoR11OIf7qdzTdmFnbA3vl4Zdg5QB8q/g3yl1orVFhf0GCGcMicTWzWKuv0C+17YbGYNKt4YIUTN8wupSN9JCyiASqHLHk1+vXZiXTbhx+1SyQBbKj1afdM+4k6ezzSmnbSZa+HbscZv4/fJeIXgS8BtojXWLV4OM6VzvxmzXQ10UCc5K6I5bRTNDaL9ys1nnBdDuNQh18NcuyMKkwHNJzxGu01Yt6xBtpzqXUO4Cts=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39faecd8-1e21-4785-4fa2-08d7352b0f5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 13:38:55.6222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V4+utbKM4avSdMpFHbJgxkk1pqboDJtebjHnkJqour8l9LjkR95PpVD7oxS5CHWXQszDeiiZVM2Qj0k3TL2QHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1892
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

Ethtool callback with basic information on what PTP features are supported
by the device.

Co-developed-by: Egor Pomozov <egor.pomozov@aquantia.com>
Signed-off-by: Egor Pomozov <egor.pomozov@aquantia.com>
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 35 ++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/=
net/ethernet/aquantia/atlantic/aq_ethtool.c
index 24df132384fb..fb40bd099a4e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+ * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
  */
=20
 /* File aq_ethtool.c: Definition of ethertool related functions. */
@@ -9,8 +9,11 @@
 #include "aq_ethtool.h"
 #include "aq_nic.h"
 #include "aq_vec.h"
+#include "aq_ptp.h"
 #include "aq_filters.h"
=20
+#include <linux/ptp_clock_kernel.h>
+
 static void aq_ethtool_get_regs(struct net_device *ndev,
 				struct ethtool_regs *regs, void *p)
 {
@@ -377,6 +380,35 @@ static int aq_ethtool_set_wol(struct net_device *ndev,
 	return err;
 }
=20
+static int aq_ethtool_get_ts_info(struct net_device *ndev,
+				  struct ethtool_ts_info *info)
+{
+	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
+
+	ethtool_op_get_ts_info(ndev, info);
+
+	info->so_timestamping |=3D
+		SOF_TIMESTAMPING_TX_HARDWARE |
+		SOF_TIMESTAMPING_RX_HARDWARE |
+		SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	info->tx_types =3D
+		BIT(HWTSTAMP_TX_OFF) |
+		BIT(HWTSTAMP_TX_ON);
+
+	info->rx_filters =3D BIT(HWTSTAMP_FILTER_NONE);
+
+	if (aq_nic->aq_ptp)
+		info->rx_filters |=3D BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
+				    BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+				    BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
+
+	info->phc_index =3D (aq_nic->aq_ptp) ?
+		ptp_clock_index(aq_ptp_get_ptp_clock(aq_nic->aq_ptp)) : -1;
+
+	return 0;
+}
+
 static enum hw_atl_fw2x_rate eee_mask_to_ethtool_mask(u32 speed)
 {
 	u32 rate =3D 0;
@@ -604,4 +636,5 @@ const struct ethtool_ops aq_ethtool_ops =3D {
 	.set_link_ksettings  =3D aq_ethtool_set_link_ksettings,
 	.get_coalesce	     =3D aq_ethtool_get_coalesce,
 	.set_coalesce	     =3D aq_ethtool_set_coalesce,
+	.get_ts_info         =3D aq_ethtool_get_ts_info,
 };
--=20
2.17.1

