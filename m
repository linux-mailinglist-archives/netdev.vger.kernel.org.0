Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D31BCF7A3
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbfJHK5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:57:06 -0400
Received: from mail-eopbgr790080.outbound.protection.outlook.com ([40.107.79.80]:64603
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730218AbfJHK5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:57:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWUyE6knRqUVmwYjumve8r0fFlCTJYUa7sGw1RF+wKD1lzp6BmiFYHm6A80l4d+t/+A5DX/b3d237mpSpH99k7ELdZljJ7IbYqNaV15Zzn7GDREmKv2cxpe4mPUqhk0yHB8uXw7OxcLPGIHDVbmPJlud4MDrxcoa5Kt24sgziq4w7uuHtLqo91Hbvd6mUixEDP9rVV85Ys+FrfASydu8fmCdEG6Onl8P/7UnVdtMgsLAgflXqHW7nSXuVQl0YwSJ753DkT5vvCjcV4d/rL6i/mFgUspRQ+NkONe1glHCcsPP9kwlPPRv4XzIPfbqIyPDlxgvsPy1YpWb8yJDCFJhGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7LcZlH7lQoYqts4PITmjKgr2v7424lIGqzOF1i65tY=;
 b=i7sy6sdVZ3+Lr6+yezMw/RGvtX6QAW9sv6hJEdtsK/EcOHLJ7rKqqsphPC/vcI2mDzgjzstaCuuIY8gyKpBLUIFJrTIfSDJ1XQgpfQcCat7p2yIx9C3CNLdfjBBEq85DxnPDgehPT7WBw88+vy3WDMx268MIbPqeQt9jA+89KkfuPhDpqxBBFX14YnUfTNVCogCXPh7ce0oaDdZgoeTrD1rQUMhLtKMyzkDLTTLR5+dje+1qz2zydkE5EBIh8RxtOx+OhCU//l+5lYPVG6lFIYYnOcf6zZsfYOeRNC+hf1J0gVC0KKfkBbsyMzTpM5zKRI65VYSKE7xESRctXAXWuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7LcZlH7lQoYqts4PITmjKgr2v7424lIGqzOF1i65tY=;
 b=kaE2VU5dh1zWnklMUh19U61xq38gYJAXs8ExoDmY6OzeSWPUCpztlEN+u1hnjLSvoZgr1p5Al9P/dQNftPtjsOC+eEXHNbU8Lhx865BvQObc1WrQ38hx1HfVw5Yq6FTUuoiKU+OEUz1YITHD9Y3wCCXz+QXt9rESYS9iy8dgyNI=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3666.namprd11.prod.outlook.com (20.178.221.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 10:56:54 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 10:56:54 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: [PATCH v2 net-next 09/12] net: aquantia: implement get_ts_info
 ethtool
Thread-Topic: [PATCH v2 net-next 09/12] net: aquantia: implement get_ts_info
 ethtool
Thread-Index: AQHVfccYExjJPQMOJUibtnb4Jx6x/A==
Date:   Tue, 8 Oct 2019 10:56:54 +0000
Message-ID: <58f42998778f9fa152174f4bbc175b1b09ed54b8.1570531332.git.igor.russkikh@aquantia.com>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570531332.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0215.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::35) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2900554-d59e-4c6c-238f-08d74bde3b17
x-ms-traffictypediagnostic: BN8PR11MB3666:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3666701A8722022FCE3AEB4B989A0@BN8PR11MB3666.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:285;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(366004)(346002)(376002)(396003)(39850400004)(136003)(189003)(199004)(118296001)(71190400001)(71200400001)(2501003)(256004)(14444005)(6916009)(305945005)(316002)(107886003)(2351001)(4326008)(2906002)(44832011)(6116002)(7736002)(3846002)(54906003)(6486002)(6436002)(11346002)(5640700003)(6512007)(99286004)(25786009)(66556008)(50226002)(76176011)(52116002)(5660300002)(8936002)(2616005)(81156014)(66446008)(102836004)(81166006)(8676002)(386003)(6506007)(508600001)(14454004)(26005)(36756003)(86362001)(446003)(64756008)(476003)(486006)(66946007)(186003)(66476007)(66066001)(1730700003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3666;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gTQAlI3t0PQIUZjHJLbKGhzm+V/VE22b4jIi+l8YK+lUdv8AubcNF9eU1J9T4ugUnLzFP2j9TR1Hgzypp2uRod9Fgw4M3I+9q0xutZKNxPsM1HwPbaIvwd28nRhSmAKnO4ZdJ2qYreZYvxHcvNqTCBkl3YbRn5fcZVHBly67m6top/EtxtufO4nNIz/EoRhr58NQP3e67p9CNnkFjt29vbRBwofO7lGhDf+ely13q3CTa1UpUKCIZTVG9JX8MZsrpEOHSZIwheJMx2xs4TL/52OXneDKDYZOuMOhRpN9Fh4gxdY5Gd3c2es9EUKJO3+JHUN4cpOIjqquVX5gaDhXwz9GwGYrU8cngfwr7tXCDY7H+uD/fr43HMWNaQ+xETq0+Ng5fYus9I0mFAJv4f/c/zl3PBBx0JyDjhIbz/bjM9E=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2900554-d59e-4c6c-238f-08d74bde3b17
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 10:56:54.5807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: heiQxQ8rN2iHJSgB4MkBd5fLFv/uKfUpdC2fvOPT8/tKW9gbUiCraj9fDXOu3x0DyiD0GJ6yF3lBQwdk9QhgOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Egor Pomozov <egor.pomozov@aquantia.com>

Ethtool callback with basic information on what PTP features are supported
by the device.

Signed-off-by: Egor Pomozov <egor.pomozov@aquantia.com>
Co-developed-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Signed-off-by: Sergey Samoilenko <sergey.samoilenko@aquantia.com>
Co-developed-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
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

