Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB91EC291
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbfKAMRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:32 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22212 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730559AbfKAMRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:31 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1CB4Ko001217;
        Fri, 1 Nov 2019 05:17:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=kUbdPoffWqZaxGjPyFmABDbboc5MHn0GYAflDsT6JTw=;
 b=CCinb5kJyT7MJbGcv9UHXg7mz/guRlasCMeyWwa8SFIIsOsSAl3qfOmgB2x+jBm+lSfZ
 IG7TITGvAxqYIT5Wu1Y7Ffv8JtaSP7PkAkVSCw9IBkETRPYtEVUBT+Pl3Z0AN21vRVIi
 weHK22hrL1R3FCH0r5x/2oPrrnofU4ySvUQEBYjlI2VoygvcDJhn/V0q2mitcWQXD9bt
 /x7TUsYULDi8G7IFSlaz0RqEGwObJzuMluMbf+8sQUkhyv7of6TVCDUVdYfWlTELdueV
 DFp/5XqB9zdpQWNR1RkfRzzIVIwuPYEDsWLnOF/4oxqTvH3BUY/r1Hm4Zz2ge6VhPb8i kw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vxwjmbtky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Nov 2019 05:17:29 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 1 Nov
 2019 05:17:28 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 1 Nov 2019 05:17:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6ZORhziuEFJUBLcgKlgOhziCb6ZLx3n+uND/OkonEPt+2sh7plGybuFituqsNrXXogyylyeGO47qfdeaM7XkRpIA+fw0bP0n/pBIZHx9XGVGr8112JEpr7bX8tA+xiIdzncJ4vVQQfxJ+704m700NZBNEAvAno9fAAxTaAH/KRSCYm0Mntw2wOskiZOLuw/ANxCt+6+eZuBKFiwHOf9rFWWOB7/TtfnqMr9zJiE5jv/gqSQJgC0YfT4T6yu1PYwcjB6HnRR8hIpMd/5qklSL615H4Kw9jtLAmUhHPAG7F57asWLkAurUKtlqqoRjcAJV6fvDHMlNDRymhbq79qQTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUbdPoffWqZaxGjPyFmABDbboc5MHn0GYAflDsT6JTw=;
 b=hbohilD1yUfpwgAO7Ly7AQ+/i1iGvr/wjcdGePr5N1+oeIjrGbj28PaE82jmAMGKzERsVa2ttSk7RlyOHro/c/jl3Cq5mMKsitmn9baPAiEtuD+blRE5HzRstIO+VKMNNJkOC0XylJu/zCMhy5QSsmQLKgih0c9fy3kNwc/NBfsoX2N16nEl12Q7lr1H//+qibDDOgi2ZVOVUxSlVbZRh0YbjAx2a3B5ixIuxLsSe51BqIPB7CcOFhceYUGdyNWDuR86QMNtqpDrXasVvZNEg+GgnIDqrkux8uq3lAugZD4lSiwZORPcaKOAqGT22Wgi8YJKTACt+S2tbdy9u3UDvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUbdPoffWqZaxGjPyFmABDbboc5MHn0GYAflDsT6JTw=;
 b=OTs8dJUZwoS+JTbmgljZ89w1qAwRYke/MxAKFbu4uyhPQZnnQMU1f0Yv4qWX9CsGZte2WhTsdo0DBZoNjgLTdgvwd2AKnIE9PytMGbNuoVu4Afj/rxcTAhf/aSBDnT7S+YxEyIY6lWRbx7MCi93BAe8i+3TqhnoEsbAfs7I8EFQ=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2306.namprd18.prod.outlook.com (52.132.30.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 12:17:21 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 12:17:21 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 07/12] net: atlantic: loopback tests via private
 flags
Thread-Topic: [PATCH net-next 07/12] net: atlantic: loopback tests via private
 flags
Thread-Index: AQHVkK5PevX5L1L65UKTRGodnIDJLg==
Date:   Fri, 1 Nov 2019 12:17:21 +0000
Message-ID: <76690e382c4916800aa042b393721d263feb18fe.1572610156.git.irusskikh@marvell.com>
References: <cover.1572610156.git.irusskikh@marvell.com>
In-Reply-To: <cover.1572610156.git.irusskikh@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0035.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::23) To BL0PR18MB2275.namprd18.prod.outlook.com
 (2603:10b6:207:44::13)
x-mailer: git-send-email 2.17.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3d309e0-8918-47d5-67bb-08d75ec57247
x-ms-traffictypediagnostic: BL0PR18MB2306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB2306F8CB09EC84B2E99DA9E9B7620@BL0PR18MB2306.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:514;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(81156014)(186003)(25786009)(102836004)(14444005)(52116002)(6916009)(256004)(76176011)(6506007)(66066001)(36756003)(386003)(66556008)(66476007)(2351001)(66446008)(486006)(26005)(64756008)(476003)(66946007)(2501003)(478600001)(30864003)(99286004)(3846002)(11346002)(5660300002)(71200400001)(107886003)(71190400001)(50226002)(2906002)(8936002)(86362001)(118296001)(2616005)(81166006)(316002)(446003)(6486002)(54906003)(7736002)(6116002)(14454004)(305945005)(6512007)(8676002)(6436002)(5640700003)(1730700003)(4326008)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2306;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z1AJGQ/tBlp/pGK+0RdWqjXUlE7YduJY91K5tzGFa/dMDm8cB+unWvCW7hl4OUZiaxlShmAVmjownTfAn4AwvuAhe9rgG2Vtdo1ndMV698EZ0coYhynF99oJrqJmmOFA7EPkm6IJdJenXhZoP1lfAJDVNGeUZsONBYEIvHaGwvoHwQDfw6j+fKRcOEEifWrd3x8AQsN7wRTyLq26OvmkEdsa7DSXSL3wkjtmPgyRGrg1pJym1NHLgiAynCWGmjLmO5Q8AV93yRU9l6nrB3JU7CJ6SVruur3AjIz3t5AncloTkSvCyod0wO3ptIZ2kb/pMGmZzE23rjM/OZK95KA3oTbn1HANmw4SoSPfViaOhhEFcsMgCyGXoAau5wNwSclLcnfgtiNSPSX3CYz5q0cA0RVnrRh15UTPQOCF5QAkF2QOfw7ybqVDZNkC8T7tbXXv
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e3d309e0-8918-47d5-67bb-08d75ec57247
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 12:17:21.7613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BCwChJjtw7i7f/lC4xG0fRnpjyHtUZbsGRXllwPaC5neNzWWiXoktDQlLp0oUpQ2mMIUIQx4zVZJYWVzILR0PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2306
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_04:2019-10-30,2019-11-01 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here we add a number of ethtool private flags
to allow enabling various loopbacks on HW.

Thats useful for verification and bringup works.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../device_drivers/aquantia/atlantic.txt      | 25 +++++++++
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 52 +++++++++++++++++-
 .../ethernet/aquantia/atlantic/aq_ethtool.h   |  1 +
 .../net/ethernet/aquantia/atlantic/aq_hw.h    | 18 +++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 45 ++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  2 +
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 30 ++++++++++-
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     | 26 +++++++++
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     | 11 ++++
 .../atlantic/hw_atl/hw_atl_llh_internal.h     | 54 +++++++++++++++++++
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 32 +++++++++++
 11 files changed, 294 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/aquantia/atlantic.txt =
b/Documentation/networking/device_drivers/aquantia/atlantic.txt
index d235cbaeccc6..ef3d8c749d4c 100644
--- a/Documentation/networking/device_drivers/aquantia/atlantic.txt
+++ b/Documentation/networking/device_drivers/aquantia/atlantic.txt
@@ -325,6 +325,31 @@ Supported ethtool options
  Example:
  ethtool -N eth0 flow-type udp4 action 0 loc 32
=20
+ Private flags (testing)
+ ---------------------------------
+
+ Atlantic driver supports private flags for hardware custom features:
+
+	$ ethtool --show-priv-flags ethX
+
+	Private flags for ethX:
+	DMASystemLoopback  : off
+	PKTSystemLoopback  : off
+	DMANetworkLoopback : off
+	PHYInternalLoopback: off
+	PHYExternalLoopback: off
+
+ Example:
+
+ 	$ ethtool --set-priv-flags ethX DMASystemLoopback on
+
+ DMASystemLoopback:   DMA Host loopback.
+ PKTSystemLoopback:   Packet buffer host loopback.
+ DMANetworkLoopback:  Network side loopback on DMA block.
+ PHYInternalLoopback: Internal loopback on Phy.
+ PHYExternalLoopback: External loopback on Phy (with loopback ethernet cab=
le).
+
+
 Command Line Parameters
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 The following command line parameters are available on atlantic driver:
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/=
net/ethernet/aquantia/atlantic/aq_ethtool.c
index 2f877fb46615..aff8684c007c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -92,6 +92,14 @@ static const char aq_ethtool_queue_stat_names[][ETH_GSTR=
ING_LEN] =3D {
 	"Queue[%d] InErrors",
 };
=20
+static const char aq_ethtool_priv_flag_names[][ETH_GSTRING_LEN] =3D {
+	"DMASystemLoopback",
+	"PKTSystemLoopback",
+	"DMANetworkLoopback",
+	"PHYInternalLoopback",
+	"PHYExternalLoopback",
+};
+
 static void aq_ethtool_stats(struct net_device *ndev,
 			     struct ethtool_stats *stats, u64 *data)
 {
@@ -137,7 +145,8 @@ static void aq_ethtool_get_strings(struct net_device *n=
dev,
 	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
 	u8 *p =3D data;
=20
-	if (stringset =3D=3D ETH_SS_STATS) {
+	switch (stringset) {
+	case ETH_SS_STATS:
 		memcpy(p, aq_ethtool_stat_names,
 		       sizeof(aq_ethtool_stat_names));
 		p =3D p + sizeof(aq_ethtool_stat_names);
@@ -150,6 +159,11 @@ static void aq_ethtool_get_strings(struct net_device *=
ndev,
 				p +=3D ETH_GSTRING_LEN;
 			}
 		}
+		break;
+	case ETH_SS_PRIV_FLAGS:
+		memcpy(p, aq_ethtool_priv_flag_names,
+		       sizeof(aq_ethtool_priv_flag_names));
+		break;
 	}
 }
=20
@@ -193,6 +207,9 @@ static int aq_ethtool_get_sset_count(struct net_device =
*ndev, int stringset)
 		ret =3D ARRAY_SIZE(aq_ethtool_stat_names) +
 			cfg->vecs * ARRAY_SIZE(aq_ethtool_queue_stat_names);
 		break;
+	case ETH_SS_PRIV_FLAGS:
+		ret =3D ARRAY_SIZE(aq_ethtool_priv_flag_names);
+		break;
 	default:
 		ret =3D -EOPNOTSUPP;
 	}
@@ -650,6 +667,37 @@ static void aq_set_msg_level(struct net_device *ndev, =
u32 data)
 	aq_nic->msg_enable =3D data;
 }
=20
+u32 aq_ethtool_get_priv_flags(struct net_device *ndev)
+{
+	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
+
+	return aq_nic->aq_nic_cfg.priv_flags;
+}
+
+int aq_ethtool_set_priv_flags(struct net_device *ndev, u32 flags)
+{
+	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
+	struct aq_nic_cfg_s *cfg =3D &aq_nic->aq_nic_cfg;
+	u32 priv_flags =3D cfg->priv_flags;
+
+	if (flags & ~AQ_PRIV_FLAGS_MASK)
+		return -EOPNOTSUPP;
+
+	cfg->priv_flags =3D flags;
+
+	if ((priv_flags ^ flags) & BIT(AQ_HW_LOOPBACK_DMA_NET)) {
+		if (netif_running(ndev)) {
+			dev_close(ndev);
+
+			dev_open(ndev, NULL);
+		}
+	} else if ((priv_flags ^ flags) & AQ_HW_LOOPBACK_MASK) {
+		aq_nic_set_loopback(aq_nic);
+	}
+
+	return 0;
+}
+
 const struct ethtool_ops aq_ethtool_ops =3D {
 	.get_link            =3D aq_ethtool_get_link,
 	.get_regs_len        =3D aq_ethtool_get_regs_len,
@@ -676,6 +724,8 @@ const struct ethtool_ops aq_ethtool_ops =3D {
 	.set_msglevel        =3D aq_set_msg_level,
 	.get_sset_count      =3D aq_ethtool_get_sset_count,
 	.get_ethtool_stats   =3D aq_ethtool_stats,
+	.get_priv_flags      =3D aq_ethtool_get_priv_flags,
+	.set_priv_flags      =3D aq_ethtool_set_priv_flags,
 	.get_link_ksettings  =3D aq_ethtool_get_link_ksettings,
 	.set_link_ksettings  =3D aq_ethtool_set_link_ksettings,
 	.get_coalesce	     =3D aq_ethtool_get_coalesce,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.h b/drivers/=
net/ethernet/aquantia/atlantic/aq_ethtool.h
index 632b5531db4a..6d5be5ebeb13 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.h
@@ -12,5 +12,6 @@
 #include "aq_common.h"
=20
 extern const struct ethtool_ops aq_ethtool_ops;
+#define AQ_PRIV_FLAGS_MASK   (AQ_HW_LOOPBACK_MASK)
=20
 #endif /* AQ_ETHTOOL_H */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/e=
thernet/aquantia/atlantic/aq_hw.h
index 57396e516939..cc70c606b6ef 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -122,6 +122,20 @@ struct aq_stats_s {
 #define AQ_HW_LED_BLINK    0x2U
 #define AQ_HW_LED_DEFAULT  0x0U
=20
+enum aq_priv_flags {
+	AQ_HW_LOOPBACK_DMA_SYS,
+	AQ_HW_LOOPBACK_PKT_SYS,
+	AQ_HW_LOOPBACK_DMA_NET,
+	AQ_HW_LOOPBACK_PHYINT_SYS,
+	AQ_HW_LOOPBACK_PHYEXT_SYS,
+};
+
+#define AQ_HW_LOOPBACK_MASK	(BIT(AQ_HW_LOOPBACK_DMA_SYS) |\
+				 BIT(AQ_HW_LOOPBACK_PKT_SYS) |\
+				 BIT(AQ_HW_LOOPBACK_DMA_NET) |\
+				 BIT(AQ_HW_LOOPBACK_PHYINT_SYS) |\
+				 BIT(AQ_HW_LOOPBACK_PHYEXT_SYS))
+
 struct aq_hw_s {
 	atomic_t flags;
 	u8 rbl_enabled:1;
@@ -280,6 +294,8 @@ struct aq_hw_ops {
 			    u64 *timestamp);
=20
 	int (*hw_set_fc)(struct aq_hw_s *self, u32 fc, u32 tc);
+
+	int (*hw_set_loopback)(struct aq_hw_s *self, u32 mode, bool enable);
 };
=20
 struct aq_fw_ops {
@@ -310,6 +326,8 @@ struct aq_fw_ops {
=20
 	int (*led_control)(struct aq_hw_s *self, u32 mode);
=20
+	int (*set_phyloopback)(struct aq_hw_s *self, u32 mode, bool enable);
+
 	int (*set_power)(struct aq_hw_s *self, unsigned int power_state,
 			 u8 *mac);
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index 8f83e91f8146..5462b7efcf2f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -406,6 +406,8 @@ int aq_nic_start(struct aq_nic_s *self)
=20
 	INIT_WORK(&self->service_task, aq_nic_service_task);
=20
+	aq_nic_set_loopback(self);
+
 	timer_setup(&self->service_timer, aq_nic_service_timer_cb, 0);
 	aq_nic_service_timer_cb(&self->service_timer);
=20
@@ -625,6 +627,11 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff =
*skb)
=20
 	aq_ring_update_queue_state(ring);
=20
+	if (self->aq_nic_cfg.priv_flags & BIT(AQ_HW_LOOPBACK_DMA_NET)) {
+		err =3D NETDEV_TX_BUSY;
+		goto err_exit;
+	}
+
 	/* Above status update may stop the queue. Check this. */
 	if (__netif_subqueue_stopped(self->ndev, ring->idx)) {
 		err =3D NETDEV_TX_BUSY;
@@ -973,6 +980,44 @@ u32 aq_nic_get_fw_version(struct aq_nic_s *self)
 	return fw_version;
 }
=20
+int aq_nic_set_loopback(struct aq_nic_s *self)
+{
+	struct aq_nic_cfg_s *cfg =3D &self->aq_nic_cfg;
+
+	if (!self->aq_hw_ops->hw_set_loopback ||
+	    !self->aq_fw_ops->set_phyloopback)
+		return -ENOTSUPP;
+
+	mutex_lock(&self->fwreq_mutex);
+	self->aq_hw_ops->hw_set_loopback(self->aq_hw,
+					 AQ_HW_LOOPBACK_DMA_SYS,
+					 !!(cfg->priv_flags &
+					    BIT(AQ_HW_LOOPBACK_DMA_SYS)));
+
+	self->aq_hw_ops->hw_set_loopback(self->aq_hw,
+					 AQ_HW_LOOPBACK_PKT_SYS,
+					 !!(cfg->priv_flags &
+					    BIT(AQ_HW_LOOPBACK_PKT_SYS)));
+
+	self->aq_hw_ops->hw_set_loopback(self->aq_hw,
+					 AQ_HW_LOOPBACK_DMA_NET,
+					 !!(cfg->priv_flags &
+					    BIT(AQ_HW_LOOPBACK_DMA_NET)));
+
+	self->aq_fw_ops->set_phyloopback(self->aq_hw,
+					 AQ_HW_LOOPBACK_PHYINT_SYS,
+					 !!(cfg->priv_flags &
+					    BIT(AQ_HW_LOOPBACK_PHYINT_SYS)));
+
+	self->aq_fw_ops->set_phyloopback(self->aq_hw,
+					 AQ_HW_LOOPBACK_PHYEXT_SYS,
+					 !!(cfg->priv_flags &
+					    BIT(AQ_HW_LOOPBACK_PHYEXT_SYS)));
+	mutex_unlock(&self->fwreq_mutex);
+
+	return 0;
+}
+
 int aq_nic_stop(struct aq_nic_s *self)
 {
 	struct aq_vec_s *aq_vec =3D NULL;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.h
index 527273502d54..bb4957a31498 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -46,6 +46,7 @@ struct aq_nic_cfg_s {
 	bool is_polling;
 	bool is_rss;
 	bool is_lro;
+	u32 priv_flags;
 	u8  tcs;
 	struct aq_rss_parameters aq_rss;
 	u32 eee_speeds;
@@ -158,6 +159,7 @@ int aq_nic_set_link_ksettings(struct aq_nic_s *self,
 			      const struct ethtool_link_ksettings *cmd);
 struct aq_nic_cfg_s *aq_nic_get_cfg(struct aq_nic_s *self);
 u32 aq_nic_get_fw_version(struct aq_nic_s *self);
+int aq_nic_set_loopback(struct aq_nic_s *self);
 int aq_nic_update_interrupt_moderation_settings(struct aq_nic_s *self);
 void aq_nic_shutdown(struct aq_nic_s *self);
 u8 aq_nic_reserve_filter(struct aq_nic_s *self, enum aq_rx_filter_type typ=
e);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index abee561ea54e..92115362d549 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1427,6 +1427,30 @@ static int hw_atl_b0_hw_vlan_ctrl(struct aq_hw_s *se=
lf, bool enable)
 	return aq_hw_err_from_flags(self);
 }
=20
+static int hw_atl_b0_set_loopback(struct aq_hw_s *self, u32 mode, bool ena=
ble)
+{
+	switch (mode) {
+	case AQ_HW_LOOPBACK_DMA_SYS:
+		hw_atl_tpb_tx_dma_sys_lbk_en_set(self, enable);
+		hw_atl_rpb_dma_sys_lbk_set(self, enable);
+		break;
+	case AQ_HW_LOOPBACK_PKT_SYS:
+		hw_atl_tpo_tx_pkt_sys_lbk_en_set(self, enable);
+		hw_atl_rpf_tpo_to_rpf_sys_lbk_set(self, enable);
+		break;
+	case AQ_HW_LOOPBACK_DMA_NET:
+		hw_atl_rpf_vlan_prom_mode_en_set(self, enable);
+		hw_atl_rpfl2promiscuous_mode_en_set(self, enable);
+		hw_atl_tpb_tx_tx_clk_gate_en_set(self, !enable);
+		hw_atl_tpb_tx_dma_net_lbk_en_set(self, enable);
+		hw_atl_rpb_dma_net_lbk_set(self, enable);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 const struct aq_hw_ops hw_atl_ops_b0 =3D {
 	.hw_set_mac_address   =3D hw_atl_b0_hw_mac_addr_set,
 	.hw_init              =3D hw_atl_b0_hw_init,
@@ -1481,5 +1505,9 @@ const struct aq_hw_ops hw_atl_ops_b0 =3D {
 	.rx_extract_ts           =3D hw_atl_b0_rx_extract_ts,
 	.extract_hwts            =3D hw_atl_b0_extract_hwts,
 	.hw_set_offload          =3D hw_atl_b0_hw_offload_set,
-	.hw_set_fc                   =3D hw_atl_b0_set_fc,
+	.hw_get_hw_stats         =3D hw_atl_utils_get_hw_stats,
+	.hw_get_fw_version       =3D hw_atl_utils_get_fw_version,
+	.hw_set_offload          =3D hw_atl_b0_hw_offload_set,
+	.hw_set_loopback         =3D hw_atl_b0_set_loopback,
+	.hw_set_fc               =3D hw_atl_b0_set_fc,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index 6cadc9054544..d1f68fc16291 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -563,6 +563,13 @@ void hw_atl_rpb_dma_sys_lbk_set(struct aq_hw_s *aq_hw,=
 u32 dma_sys_lbk)
 			    HW_ATL_RPB_DMA_SYS_LBK_SHIFT, dma_sys_lbk);
 }
=20
+void hw_atl_rpb_dma_net_lbk_set(struct aq_hw_s *aq_hw, u32 dma_net_lbk)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL_RPB_DMA_NET_LBK_ADR,
+			    HW_ATL_RPB_DMA_NET_LBK_MSK,
+			    HW_ATL_RPB_DMA_NET_LBK_SHIFT, dma_net_lbk);
+}
+
 void hw_atl_rpb_rpf_rx_traf_class_mode_set(struct aq_hw_s *aq_hw,
 					   u32 rx_traf_class_mode)
 {
@@ -1341,7 +1348,26 @@ void hw_atl_tpb_tx_dma_sys_lbk_en_set(struct aq_hw_s=
 *aq_hw, u32 tx_dma_sys_lbk_
 			    tx_dma_sys_lbk_en);
 }
=20
+void hw_atl_tpb_tx_dma_net_lbk_en_set(struct aq_hw_s *aq_hw,
+				      u32 tx_dma_net_lbk_en)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL_TPB_DMA_NET_LBK_ADR,
+			    HW_ATL_TPB_DMA_NET_LBK_MSK,
+			    HW_ATL_TPB_DMA_NET_LBK_SHIFT,
+			    tx_dma_net_lbk_en);
+}
+
+void hw_atl_tpb_tx_tx_clk_gate_en_set(struct aq_hw_s *aq_hw,
+				      u32 tx_clk_gate_en)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL_TPB_TX_CLK_GATE_EN_ADR,
+			    HW_ATL_TPB_TX_CLK_GATE_EN_MSK,
+			    HW_ATL_TPB_TX_CLK_GATE_EN_SHIFT,
+			    tx_clk_gate_en);
+}
+
 void hw_atl_tpb_tx_pkt_buff_size_per_tc_set(struct aq_hw_s *aq_hw,
+
 					    u32 tx_pkt_buff_size_per_tc, u32 buffer)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL_TPB_TXBBUF_SIZE_ADR(buffer),
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index 5750b0c9cae7..62992b23c0e8 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -288,6 +288,9 @@ void hw_atl_reg_glb_cpu_scratch_scp_set(struct aq_hw_s =
*aq_hw,
 /* set dma system loopback */
 void hw_atl_rpb_dma_sys_lbk_set(struct aq_hw_s *aq_hw, u32 dma_sys_lbk);
=20
+/* set dma network loopback */
+void hw_atl_rpb_dma_net_lbk_set(struct aq_hw_s *aq_hw, u32 dma_net_lbk);
+
 /* set rx traffic class mode */
 void hw_atl_rpb_rpf_rx_traf_class_mode_set(struct aq_hw_s *aq_hw,
 					   u32 rx_traf_class_mode);
@@ -629,6 +632,14 @@ void hw_atl_tpb_tx_buff_lo_threshold_per_tc_set(struct=
 aq_hw_s *aq_hw,
 /* set tx dma system loopback enable */
 void hw_atl_tpb_tx_dma_sys_lbk_en_set(struct aq_hw_s *aq_hw, u32 tx_dma_sy=
s_lbk_en);
=20
+/* set tx dma network loopback enable */
+void hw_atl_tpb_tx_dma_net_lbk_en_set(struct aq_hw_s *aq_hw,
+				      u32 tx_dma_net_lbk_en);
+
+/* set tx clock gating enable */
+void hw_atl_tpb_tx_tx_clk_gate_en_set(struct aq_hw_s *aq_hw,
+				      u32 tx_clk_gate_en);
+
 /* set tx packet buffer size (per tc) */
 void hw_atl_tpb_tx_pkt_buff_size_per_tc_set(struct aq_hw_s *aq_hw,
 					    u32 tx_pkt_buff_size_per_tc,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_inter=
nal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
index ec3bcdcefc4d..18de2f7b8959 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -554,6 +554,24 @@
 /* default value of bitfield dma_sys_loopback */
 #define HW_ATL_RPB_DMA_SYS_LBK_DEFAULT 0x0
=20
+/* rx dma_net_loopback bitfield definitions
+ * preprocessor definitions for the bitfield "dma_net_loopback".
+ * port=3D"pif_rpb_dma_net_lbk_i"
+ */
+
+/* register address for bitfield dma_net_loopback */
+#define HW_ATL_RPB_DMA_NET_LBK_ADR 0x00005000
+/* bitmask for bitfield dma_net_loopback */
+#define HW_ATL_RPB_DMA_NET_LBK_MSK 0x00000010
+/* inverted bitmask for bitfield dma_net_loopback */
+#define HW_ATL_RPB_DMA_NET_LBK_MSKN 0xffffffef
+/* lower bit position of bitfield dma_net_loopback */
+#define HW_ATL_RPB_DMA_NET_LBK_SHIFT 4
+/* width of bitfield dma_net_loopback */
+#define HW_ATL_RPB_DMA_NET_LBK_WIDTH 1
+/* default value of bitfield dma_net_loopback */
+#define HW_ATL_RPB_DMA_NET_LBK_DEFAULT 0x0
+
 /* rx rx_tc_mode bitfield definitions
  * preprocessor definitions for the bitfield "rx_tc_mode".
  * port=3D"pif_rpb_rx_tc_mode_i,pif_rpf_rx_tc_mode_i"
@@ -2107,6 +2125,24 @@
 /* default value of bitfield dma_sys_loopback */
 #define HW_ATL_TPB_DMA_SYS_LBK_DEFAULT 0x0
=20
+/* tx dma_net_loopback bitfield definitions
+ * preprocessor definitions for the bitfield "dma_net_loopback".
+ * port=3D"pif_tpb_dma_net_lbk_i"
+ */
+
+/* register address for bitfield dma_net_loopback */
+#define HW_ATL_TPB_DMA_NET_LBK_ADR 0x00007000
+/* bitmask for bitfield dma_net_loopback */
+#define HW_ATL_TPB_DMA_NET_LBK_MSK 0x00000010
+/* inverted bitmask for bitfield dma_net_loopback */
+#define HW_ATL_TPB_DMA_NET_LBK_MSKN 0xffffffef
+/* lower bit position of bitfield dma_net_loopback */
+#define HW_ATL_TPB_DMA_NET_LBK_SHIFT 4
+/* width of bitfield dma_net_loopback */
+#define HW_ATL_TPB_DMA_NET_LBK_WIDTH 1
+/* default value of bitfield dma_net_loopback */
+#define HW_ATL_TPB_DMA_NET_LBK_DEFAULT 0x0
+
 /* tx tx{b}_buf_size[7:0] bitfield definitions
  * preprocessor definitions for the bitfield "tx{b}_buf_size[7:0]".
  * parameter: buffer {b} | stride size 0x10 | range [0, 7]
@@ -2144,6 +2180,24 @@
 /* default value of bitfield tx_scp_ins_en */
 #define HW_ATL_TPB_TX_SCP_INS_EN_DEFAULT 0x0
=20
+/* tx tx_clk_gate_en bitfield definitions
+ * preprocessor definitions for the bitfield "tx_clk_gate_en".
+ * port=3D"pif_tpb_clk_gate_en_i"
+ */
+
+/* register address for bitfield tx_clk_gate_en */
+#define HW_ATL_TPB_TX_CLK_GATE_EN_ADR 0x00007900
+/* bitmask for bitfield tx_clk_gate_en */
+#define HW_ATL_TPB_TX_CLK_GATE_EN_MSK 0x00000010
+/* inverted bitmask for bitfield tx_clk_gate_en */
+#define HW_ATL_TPB_TX_CLK_GATE_EN_MSKN 0xffffffef
+/* lower bit position of bitfield tx_clk_gate_en */
+#define HW_ATL_TPB_TX_CLK_GATE_EN_SHIFT 4
+/* width of bitfield tx_clk_gate_en */
+#define HW_ATL_TPB_TX_CLK_GATE_EN_WIDTH 1
+/* default value of bitfield tx_clk_gate_en */
+#define HW_ATL_TPB_TX_CLK_GATE_EN_DEFAULT 0x1
+
 /* tx ipv4_chk_en bitfield definitions
  * preprocessor definitions for the bitfield "ipv4_chk_en".
  * port=3D"pif_tpo_ipv4_chk_en_i"
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2=
x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 3dbce03c5a94..feef2b0177b2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -42,6 +42,9 @@
 #define HW_ATL_FW2X_CTRL_PAUSE            BIT(CTRL_PAUSE)
 #define HW_ATL_FW2X_CTRL_TEMPERATURE      BIT(CTRL_TEMPERATURE)
 #define HW_ATL_FW2X_CTRL_ASYMMETRIC_PAUSE BIT(CTRL_ASYMMETRIC_PAUSE)
+#define HW_ATL_FW2X_CTRL_INT_LOOPBACK     BIT(CTRL_INT_LOOPBACK)
+#define HW_ATL_FW2X_CTRL_EXT_LOOPBACK     BIT(CTRL_EXT_LOOPBACK)
+#define HW_ATL_FW2X_CTRL_DOWNSHIFT        BIT(CTRL_DOWNSHIFT)
 #define HW_ATL_FW2X_CTRL_FORCE_RECONNECT  BIT(CTRL_FORCE_RECONNECT)
=20
 #define HW_ATL_FW2X_CAP_EEE_1G_MASK      BIT(CAPS_HI_1000BASET_FD_EEE)
@@ -53,6 +56,7 @@
 #define HAL_ATLANTIC_UTILS_FW2X_MSG_WOL  0x0E
=20
 #define HW_ATL_FW_VER_LED                0x03010026U
+#define HW_ATL_FW_VER_MEDIA_CONTROL      0x0301005aU
=20
 struct __packed fw2x_msg_wol_pattern {
 	u8 mask[16];
@@ -539,6 +543,33 @@ static u32 aq_fw2x_get_flow_control(struct aq_hw_s *se=
lf, u32 *fcmode)
 	return 0;
 }
=20
+static int aq_fw2x_set_phyloopback(struct aq_hw_s *self, u32 mode, bool en=
able)
+{
+	u32 mpi_opts;
+
+	switch (mode) {
+	case AQ_HW_LOOPBACK_PHYINT_SYS:
+		mpi_opts =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
+		if (enable)
+			mpi_opts |=3D HW_ATL_FW2X_CTRL_INT_LOOPBACK;
+		else
+			mpi_opts &=3D ~HW_ATL_FW2X_CTRL_INT_LOOPBACK;
+		aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, mpi_opts);
+		break;
+	case AQ_HW_LOOPBACK_PHYEXT_SYS:
+		mpi_opts =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
+		if (enable)
+			mpi_opts |=3D HW_ATL_FW2X_CTRL_EXT_LOOPBACK;
+		else
+			mpi_opts &=3D ~HW_ATL_FW2X_CTRL_EXT_LOOPBACK;
+		aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, mpi_opts);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static u32 aq_fw2x_mbox_get(struct aq_hw_s *self)
 {
 	return aq_hw_read_reg(self, HW_ATL_FW2X_MPI_MBOX_ADDR);
@@ -586,4 +617,5 @@ const struct aq_fw_ops aq_fw_2x_ops =3D {
 	.send_fw_request    =3D aq_fw2x_send_fw_request,
 	.enable_ptp         =3D aq_fw3x_enable_ptp,
 	.led_control        =3D aq_fw2x_led_control,
+	.set_phyloopback    =3D aq_fw2x_set_phyloopback,
 };
--=20
2.17.1

