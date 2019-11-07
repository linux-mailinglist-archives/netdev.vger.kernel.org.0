Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F615F3BA0
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfKGWmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:42:11 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28992 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727961AbfKGWmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:42:09 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7MembE003017;
        Thu, 7 Nov 2019 14:42:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=RW6JqIoZk6BB/3bd2rAwJZ/+FhZjsnAd5qaKwSib23A=;
 b=vNbz00PI32QScg7AxZRyueiXAxscu3q3VlYKOj743QV09Z9PAjUqIbeilwBPS6IWdKVs
 h5OXTSyvcPQR82hG2HOfZymzlI+6gYJTTr/XvEQh7rGBhqaKR3ZLNtB2NkbJMvYp7aGt
 znRw4B5nPQALkD7k4qvZZ9YP0GntsFOBHi7KtmT6KLm+zBxXfQ03/wYlnPwBc69D97fM
 q7CHQIhLBnh7eKfM5QsLn3+zHawoW6D+PLW4xdu2nCmtNzGPeK3Wps7wo85UwSMv3WYU
 q4lLX8N3JbijK838+GsWGaiWSJ2Y5otm0LBgUy+MR2O4d+20rZcu9yE257M9oWCxH1V7 qg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w41uwxrfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 14:42:03 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 7 Nov
 2019 14:42:02 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 7 Nov 2019 14:42:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bHwMB7wPT7LU6TVHG3VSHVP1Q1E7ig9cmkNt3v5RoN0rHvdrabLXywiDwyE+TbmOtpV3GdLN63i6O1sMYcygjPAeoQbP3VkpxUepAAvWcDnCFlbpwtIqlySK0gTXKOIZO5rqE4J7ynftwQkSLbWxohKDILvgyO5JQnzo4wCBIprg3Tmhii/TvbslG1H74j0hwutOCZ23r2Dgcf5+PcUgVi+Zh3Y93lR4UFpyhyauOGKsaYLmh8UWfobgweXpsGp/jcyf25Fm3ZjPSMFaFZsj6hkVvxlxK70InzzwxiB4MqUiYsTvlN3KAXSr9yWi+Da7QcAwxaSRcCSw6iX+dTBdIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RW6JqIoZk6BB/3bd2rAwJZ/+FhZjsnAd5qaKwSib23A=;
 b=D+vsvonIuoPGxJPBEYBCjCLcl5GDbqcoHvRAOSRjJvCk+HBBuT+ZEkyX9SNH4NPJ4Rbf7y6FTPTOKqgQ4YMrzqinmM6ahA5XaxwWpcmVsJDnEGbXQXdPUo6R5e8hglBueiXqYf3lXGpHo7k33bxYiEKkYFL4VehSRNrw/urEYyT4tBc3fEfH8EcIcEXNmckmyMitJPDmB6Wkp+2/vrsrU95jztOuvS1/vw/397L6PohrXAJJxp788YKEy2yjQe6rpIEyK/+uegL58YU2uemXz4lGW1IKY6oFrllQbmBXgTzhIPlW2QHWyUVAfH3Pbwx13ElkIc4ZCs7W08c+xJGh4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RW6JqIoZk6BB/3bd2rAwJZ/+FhZjsnAd5qaKwSib23A=;
 b=HAMqtxbwfObUtGXk2aDF6QeU6ZTbQU8tO2vARv0GudAc3ISalrthYy+Xw85cJ5J8cn38/hRndoRwYwSzlbyIP0QYd0QeosKDU5tHYmEL6PyONAvas47cYTtYLpuu7oKdUyO9QIaQtG9UIY54/9REeYQKNLhz4+RoUNtOMx232XQ=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB2295.namprd18.prod.outlook.com (52.132.142.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 22:42:00 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:42:00 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH v2 net-next 08/12] net: atlantic: code style cleanup
Thread-Topic: [PATCH v2 net-next 08/12] net: atlantic: code style cleanup
Thread-Index: AQHVlbyRO4yeQEP4u0+vbJmhBSN2cQ==
Date:   Thu, 7 Nov 2019 22:42:00 +0000
Message-ID: <43e82aee9803dd67266abe1e377bcb17664fcc31.1573158382.git.irusskikh@marvell.com>
References: <cover.1573158381.git.irusskikh@marvell.com>
In-Reply-To: <cover.1573158381.git.irusskikh@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0011.eurprd09.prod.outlook.com
 (2603:10a6:101:16::23) To DM5PR18MB1642.namprd18.prod.outlook.com
 (2603:10b6:3:14c::8)
x-mailer: git-send-email 2.17.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fdd977ae-1a4b-40f2-1f9e-08d763d3b3da
x-ms-traffictypediagnostic: DM5PR18MB2295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB229532647E6AEBE69A03FD22B7780@DM5PR18MB2295.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:17;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(64756008)(76176011)(7736002)(99286004)(316002)(66066001)(54906003)(2351001)(30864003)(52116002)(5640700003)(2501003)(8676002)(25786009)(118296001)(8936002)(305945005)(81166006)(81156014)(1730700003)(6486002)(478600001)(71200400001)(71190400001)(6436002)(50226002)(6916009)(66476007)(6116002)(6512007)(14454004)(2616005)(476003)(256004)(486006)(186003)(3846002)(102836004)(11346002)(107886003)(36756003)(66946007)(26005)(2906002)(66446008)(86362001)(66556008)(4326008)(386003)(6506007)(5660300002)(446003)(14444005)(559001)(579004)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB2295;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6KZKRc/pEKeYMMT1MFUDV1BU5xQkw5hlOmYPI82q5R5ll97mqbgCiWBIInArouusveVnyMap9lmm49JidCWhWYn/oa38NKQ7wfF05iTPfJu+rk/H7jnMKwR2m6iZswnMjihUErmF94tjmINNGBOcKLKcB6ln0GDY9gHcyGOVe/5xTUnoSOis+9za03fx+Mw3sXTGgyVEpjn9ffIppdVWpOzxjwAYaOPDK3Gp4vArIC+pYGBnxZ9YAToMaC2KerqpFvavlHNR3xNiM3csl7cnC9PSZHknFUSbEUlBTKpX9/mH10GLi4P4ISVrnqjXK9krAj75QktORx10cOEx/i0Pkd9EIdPh8ShpdRIgDj5a6b1r4vUJ1hgdJMqAiWZESAF2+tIVfvv+uEQ6J9j4vXVjsiKX++AIfJNkwwUAHgSq9bym55G2v8SLpMD7ZhWGZiTx
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd977ae-1a4b-40f2-1f9e-08d763d3b3da
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:42:00.6188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 92GFlENsPPdfk9JIfrzAmelSMWT+kgN3bpI3Pv1nRJk6UyWz157BWlF1W4Zkl90U2Epfj2XnTO8oSR9D/NGfXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2295
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

Thats a pure checkpatck walkthrough the code with no functional
changes. Reverse christmas tree, spacing, etc.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 108 ++++++++++++------
 .../ethernet/aquantia/atlantic/aq_hw_utils.c  |   1 +
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  11 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  39 ++++---
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   4 +-
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |   8 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |   6 +-
 .../net/ethernet/aquantia/atlantic/aq_vec.c   |   8 +-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  39 ++++---
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  69 ++++++-----
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  52 +++++----
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |  34 +++---
 12 files changed, 240 insertions(+), 139 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/=
net/ethernet/aquantia/atlantic/aq_ethtool.c
index 963bf6e67573..8286c77d43a5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -18,7 +18,9 @@ static void aq_ethtool_get_regs(struct net_device *ndev,
 				struct ethtool_regs *regs, void *p)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	u32 regs_count =3D aq_nic_get_regs_count(aq_nic);
+	u32 regs_count;
+
+	regs_count =3D aq_nic_get_regs_count(aq_nic);
=20
 	memset(p, 0, regs_count * sizeof(u32));
 	aq_nic_get_regs(aq_nic, regs, p);
@@ -27,7 +29,9 @@ static void aq_ethtool_get_regs(struct net_device *ndev,
 static int aq_ethtool_get_regs_len(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	u32 regs_count =3D aq_nic_get_regs_count(aq_nic);
+	u32 regs_count;
+
+	regs_count =3D aq_nic_get_regs_count(aq_nic);
=20
 	return regs_count * sizeof(u32);
 }
@@ -104,7 +108,9 @@ static void aq_ethtool_stats(struct net_device *ndev,
 			     struct ethtool_stats *stats, u64 *data)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
+	struct aq_nic_cfg_s *cfg;
+
+	cfg =3D aq_nic_get_cfg(aq_nic);
=20
 	memset(data, 0, (ARRAY_SIZE(aq_ethtool_stat_names) +
 			 ARRAY_SIZE(aq_ethtool_queue_stat_names) *
@@ -115,11 +121,15 @@ static void aq_ethtool_stats(struct net_device *ndev,
 static void aq_ethtool_get_drvinfo(struct net_device *ndev,
 				   struct ethtool_drvinfo *drvinfo)
 {
-	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
 	struct pci_dev *pdev =3D to_pci_dev(ndev->dev.parent);
-	u32 firmware_version =3D aq_nic_get_fw_version(aq_nic);
-	u32 regs_count =3D aq_nic_get_regs_count(aq_nic);
+	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
+	struct aq_nic_cfg_s *cfg;
+	u32 firmware_version;
+	u32 regs_count;
+
+	cfg =3D aq_nic_get_cfg(aq_nic);
+	firmware_version =3D aq_nic_get_fw_version(aq_nic);
+	regs_count =3D aq_nic_get_regs_count(aq_nic);
=20
 	strlcat(drvinfo->driver, AQ_CFG_DRV_NAME, sizeof(drvinfo->driver));
 	strlcat(drvinfo->version, AQ_CFG_DRV_VERSION, sizeof(drvinfo->version));
@@ -140,10 +150,12 @@ static void aq_ethtool_get_drvinfo(struct net_device =
*ndev,
 static void aq_ethtool_get_strings(struct net_device *ndev,
 				   u32 stringset, u8 *data)
 {
-	int i, si;
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
+	struct aq_nic_cfg_s *cfg;
 	u8 *p =3D data;
+	int i, si;
+
+	cfg =3D aq_nic_get_cfg(aq_nic);
=20
 	switch (stringset) {
 	case ETH_SS_STATS:
@@ -198,9 +210,11 @@ static int aq_ethtool_set_phys_id(struct net_device *n=
dev,
=20
 static int aq_ethtool_get_sset_count(struct net_device *ndev, int stringse=
t)
 {
-	int ret =3D 0;
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
+	struct aq_nic_cfg_s *cfg;
+	int ret =3D 0;
+
+	cfg =3D aq_nic_get_cfg(aq_nic);
=20
 	switch (stringset) {
 	case ETH_SS_STATS:
@@ -213,6 +227,7 @@ static int aq_ethtool_get_sset_count(struct net_device =
*ndev, int stringset)
 	default:
 		ret =3D -EOPNOTSUPP;
 	}
+
 	return ret;
 }
=20
@@ -224,7 +239,9 @@ static u32 aq_ethtool_get_rss_indir_size(struct net_dev=
ice *ndev)
 static u32 aq_ethtool_get_rss_key_size(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
+	struct aq_nic_cfg_s *cfg;
+
+	cfg =3D aq_nic_get_cfg(aq_nic);
=20
 	return sizeof(cfg->aq_rss.hash_secret_key);
 }
@@ -233,9 +250,11 @@ static int aq_ethtool_get_rss(struct net_device *ndev,=
 u32 *indir, u8 *key,
 			      u8 *hfunc)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
+	struct aq_nic_cfg_s *cfg;
 	unsigned int i =3D 0U;
=20
+	cfg =3D aq_nic_get_cfg(aq_nic);
+
 	if (hfunc)
 		*hfunc =3D ETH_RSS_HASH_TOP; /* Toeplitz */
 	if (indir) {
@@ -245,6 +264,7 @@ static int aq_ethtool_get_rss(struct net_device *ndev, =
u32 *indir, u8 *key,
 	if (key)
 		memcpy(key, cfg->aq_rss.hash_secret_key,
 		       sizeof(cfg->aq_rss.hash_secret_key));
+
 	return 0;
 }
=20
@@ -288,9 +308,11 @@ static int aq_ethtool_get_rxnfc(struct net_device *nde=
v,
 				u32 *rule_locs)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
+	struct aq_nic_cfg_s *cfg;
 	int err =3D 0;
=20
+	cfg =3D aq_nic_get_cfg(aq_nic);
+
 	switch (cmd->cmd) {
 	case ETHTOOL_GRXRINGS:
 		cmd->data =3D cfg->vecs;
@@ -315,8 +337,8 @@ static int aq_ethtool_get_rxnfc(struct net_device *ndev=
,
 static int aq_ethtool_set_rxnfc(struct net_device *ndev,
 				struct ethtool_rxnfc *cmd)
 {
-	int err =3D 0;
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
+	int err =3D 0;
=20
 	switch (cmd->cmd) {
 	case ETHTOOL_SRXCLSRLINS:
@@ -337,7 +359,9 @@ static int aq_ethtool_get_coalesce(struct net_device *n=
dev,
 				   struct ethtool_coalesce *coal)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
+	struct aq_nic_cfg_s *cfg;
+
+	cfg =3D aq_nic_get_cfg(aq_nic);
=20
 	if (cfg->itr =3D=3D AQ_CFG_INTERRUPT_MODERATION_ON ||
 	    cfg->itr =3D=3D AQ_CFG_INTERRUPT_MODERATION_AUTO) {
@@ -351,6 +375,7 @@ static int aq_ethtool_get_coalesce(struct net_device *n=
dev,
 		coal->rx_max_coalesced_frames =3D 1;
 		coal->tx_max_coalesced_frames =3D 1;
 	}
+
 	return 0;
 }
=20
@@ -358,7 +383,9 @@ static int aq_ethtool_set_coalesce(struct net_device *n=
dev,
 				   struct ethtool_coalesce *coal)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
+	struct aq_nic_cfg_s *cfg;
+
+	cfg =3D aq_nic_get_cfg(aq_nic);
=20
 	/* This is not yet supported
 	 */
@@ -400,7 +427,9 @@ static void aq_ethtool_get_wol(struct net_device *ndev,
 			       struct ethtool_wolinfo *wol)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
+	struct aq_nic_cfg_s *cfg;
+
+	cfg =3D aq_nic_get_cfg(aq_nic);
=20
 	wol->supported =3D AQ_NIC_WOL_MODES;
 	wol->wolopts =3D cfg->wol;
@@ -411,9 +440,11 @@ static int aq_ethtool_set_wol(struct net_device *ndev,
 {
 	struct pci_dev *pdev =3D to_pci_dev(ndev->dev.parent);
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
+	struct aq_nic_cfg_s *cfg;
 	int err =3D 0;
=20
+	cfg =3D aq_nic_get_cfg(aq_nic);
+
 	if (wol->wolopts & ~AQ_NIC_WOL_MODES)
 		return -EOPNOTSUPP;
=20
@@ -599,23 +630,28 @@ static void aq_get_ringparam(struct net_device *ndev,
 			     struct ethtool_ringparam *ring)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *aq_nic_cfg =3D aq_nic_get_cfg(aq_nic);
+	struct aq_nic_cfg_s *cfg;
+
+	cfg =3D aq_nic_get_cfg(aq_nic);
=20
-	ring->rx_pending =3D aq_nic_cfg->rxds;
-	ring->tx_pending =3D aq_nic_cfg->txds;
+	ring->rx_pending =3D cfg->rxds;
+	ring->tx_pending =3D cfg->txds;
=20
-	ring->rx_max_pending =3D aq_nic_cfg->aq_hw_caps->rxds_max;
-	ring->tx_max_pending =3D aq_nic_cfg->aq_hw_caps->txds_max;
+	ring->rx_max_pending =3D cfg->aq_hw_caps->rxds_max;
+	ring->tx_max_pending =3D cfg->aq_hw_caps->txds_max;
 }
=20
 static int aq_set_ringparam(struct net_device *ndev,
 			    struct ethtool_ringparam *ring)
 {
-	int err =3D 0;
-	bool ndev_running =3D false;
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	struct aq_nic_cfg_s *aq_nic_cfg =3D aq_nic_get_cfg(aq_nic);
-	const struct aq_hw_caps_s *hw_caps =3D aq_nic_cfg->aq_hw_caps;
+	const struct aq_hw_caps_s *hw_caps;
+	bool ndev_running =3D false;
+	struct aq_nic_cfg_s *cfg;
+	int err =3D 0;
+
+	cfg =3D aq_nic_get_cfg(aq_nic);
+	hw_caps =3D cfg->aq_hw_caps;
=20
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending) {
 		err =3D -EOPNOTSUPP;
@@ -629,18 +665,18 @@ static int aq_set_ringparam(struct net_device *ndev,
=20
 	aq_nic_free_vectors(aq_nic);
=20
-	aq_nic_cfg->rxds =3D max(ring->rx_pending, hw_caps->rxds_min);
-	aq_nic_cfg->rxds =3D min(aq_nic_cfg->rxds, hw_caps->rxds_max);
-	aq_nic_cfg->rxds =3D ALIGN(aq_nic_cfg->rxds, AQ_HW_RXD_MULTIPLE);
+	cfg->rxds =3D max(ring->rx_pending, hw_caps->rxds_min);
+	cfg->rxds =3D min(cfg->rxds, hw_caps->rxds_max);
+	cfg->rxds =3D ALIGN(cfg->rxds, AQ_HW_RXD_MULTIPLE);
=20
-	aq_nic_cfg->txds =3D max(ring->tx_pending, hw_caps->txds_min);
-	aq_nic_cfg->txds =3D min(aq_nic_cfg->txds, hw_caps->txds_max);
-	aq_nic_cfg->txds =3D ALIGN(aq_nic_cfg->txds, AQ_HW_TXD_MULTIPLE);
+	cfg->txds =3D max(ring->tx_pending, hw_caps->txds_min);
+	cfg->txds =3D min(cfg->txds, hw_caps->txds_max);
+	cfg->txds =3D ALIGN(cfg->txds, AQ_HW_TXD_MULTIPLE);
=20
-	for (aq_nic->aq_vecs =3D 0; aq_nic->aq_vecs < aq_nic_cfg->vecs;
+	for (aq_nic->aq_vecs =3D 0; aq_nic->aq_vecs < cfg->vecs;
 	     aq_nic->aq_vecs++) {
 		aq_nic->aq_vec[aq_nic->aq_vecs] =3D
-		    aq_vec_alloc(aq_nic, aq_nic->aq_vecs, aq_nic_cfg);
+		    aq_vec_alloc(aq_nic, aq_nic->aq_vecs, cfg);
 		if (unlikely(!aq_nic->aq_vec[aq_nic->aq_vecs])) {
 			err =3D -ENOMEM;
 			goto err_exit;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c b/drivers=
/net/ethernet/aquantia/atlantic/aq_hw_utils.c
index 9c7a226d81b6..7dbf49adcea6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
@@ -59,6 +59,7 @@ u64 aq_hw_read_reg64(struct aq_hw_s *hw, u32 reg)
 	u64 value =3D aq_hw_read_reg(hw, reg);
=20
 	value |=3D (u64)aq_hw_read_reg(hw, reg + 4) << 32;
+
 	return value;
 }
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_main.c
index 2c1096561614..538f460a3da7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -53,8 +53,8 @@ struct net_device *aq_ndev_alloc(void)
=20
 static int aq_ndev_open(struct net_device *ndev)
 {
-	int err =3D 0;
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
+	int err =3D 0;
=20
 	err =3D aq_nic_init(aq_nic);
 	if (err < 0)
@@ -75,13 +75,14 @@ static int aq_ndev_open(struct net_device *ndev)
 err_exit:
 	if (err < 0)
 		aq_nic_deinit(aq_nic, true);
+
 	return err;
 }
=20
 static int aq_ndev_close(struct net_device *ndev)
 {
-	int err =3D 0;
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
+	int err =3D 0;
=20
 	err =3D aq_nic_stop(aq_nic);
 	if (err < 0)
@@ -120,7 +121,9 @@ static int aq_ndev_start_xmit(struct sk_buff *skb, stru=
ct net_device *ndev)
 static int aq_ndev_change_mtu(struct net_device *ndev, int new_mtu)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	int err =3D aq_nic_set_mtu(aq_nic, new_mtu + ETH_HLEN);
+	int err;
+
+	err =3D aq_nic_set_mtu(aq_nic, new_mtu + ETH_HLEN);
=20
 	if (err < 0)
 		goto err_exit;
@@ -133,8 +136,8 @@ static int aq_ndev_change_mtu(struct net_device *ndev, =
int new_mtu)
 static int aq_ndev_set_features(struct net_device *ndev,
 				netdev_features_t features)
 {
-	bool is_vlan_rx_strip =3D !!(features & NETIF_F_HW_VLAN_CTAG_RX);
 	bool is_vlan_tx_insert =3D !!(features & NETIF_F_HW_VLAN_CTAG_TX);
+	bool is_vlan_rx_strip =3D !!(features & NETIF_F_HW_VLAN_CTAG_RX);
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
 	bool need_ndev_restart =3D false;
 	struct aq_nic_cfg_s *aq_cfg;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index 5462b7efcf2f..d3739f21b18e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -41,10 +41,6 @@ static void aq_nic_update_ndev_stats(struct aq_nic_s *se=
lf);
=20
 static void aq_nic_rss_init(struct aq_nic_s *self, unsigned int num_rss_qu=
eues)
 {
-	struct aq_nic_cfg_s *cfg =3D &self->aq_nic_cfg;
-	struct aq_rss_parameters *rss_params =3D &cfg->aq_rss;
-	int i =3D 0;
-
 	static u8 rss_key[AQ_CFG_RSS_HASHKEY_SIZE] =3D {
 		0x1e, 0xad, 0x71, 0x87, 0x65, 0xfc, 0x26, 0x7d,
 		0x0d, 0x45, 0x67, 0x74, 0xcd, 0x06, 0x1a, 0x18,
@@ -52,6 +48,11 @@ static void aq_nic_rss_init(struct aq_nic_s *self, unsig=
ned int num_rss_queues)
 		0x19, 0x13, 0x4b, 0xa9, 0xd0, 0x3e, 0xfe, 0x70,
 		0x25, 0x03, 0xab, 0x50, 0x6a, 0x8b, 0x82, 0x0c
 	};
+	struct aq_nic_cfg_s *cfg =3D &self->aq_nic_cfg;
+	struct aq_rss_parameters *rss_params;
+	int i =3D 0;
+
+	rss_params =3D &cfg->aq_rss;
=20
 	rss_params->hash_secret_key_size =3D sizeof(rss_key);
 	memcpy(rss_params->hash_secret_key, rss_key, sizeof(rss_key));
@@ -180,6 +181,7 @@ static int aq_nic_update_link_status(struct aq_nic_s *s=
elf)
 		netif_tx_disable(self->ndev);
 		aq_utils_obj_set(&self->flags, AQ_NIC_LINK_DOWN);
 	}
+
 	return 0;
 }
=20
@@ -194,6 +196,7 @@ static irqreturn_t aq_linkstate_threaded_isr(int irq, v=
oid *private)
=20
 	self->aq_hw_ops->hw_irq_enable(self->aq_hw,
 				       BIT(self->aq_nic_cfg.link_irq_vec));
+
 	return IRQ_HANDLED;
 }
=20
@@ -224,7 +227,8 @@ static void aq_nic_service_timer_cb(struct timer_list *=
t)
 {
 	struct aq_nic_s *self =3D from_timer(self, t, service_timer);
=20
-	mod_timer(&self->service_timer, jiffies + AQ_CFG_SERVICE_TIMER_INTERVAL);
+	mod_timer(&self->service_timer,
+		  jiffies + AQ_CFG_SERVICE_TIMER_INTERVAL);
=20
 	aq_ndev_schedule_work(&self->service_task);
 }
@@ -326,8 +330,8 @@ struct net_device *aq_nic_get_ndev(struct aq_nic_s *sel=
f)
 int aq_nic_init(struct aq_nic_s *self)
 {
 	struct aq_vec_s *aq_vec =3D NULL;
-	int err =3D 0;
 	unsigned int i =3D 0U;
+	int err =3D 0;
=20
 	self->power_state =3D AQ_HW_POWER_STATE_D0;
 	mutex_lock(&self->fwreq_mutex);
@@ -371,8 +375,8 @@ int aq_nic_init(struct aq_nic_s *self)
 int aq_nic_start(struct aq_nic_s *self)
 {
 	struct aq_vec_s *aq_vec =3D NULL;
-	int err =3D 0;
 	unsigned int i =3D 0U;
+	int err =3D 0;
=20
 	err =3D self->aq_hw_ops->hw_multicast_list_set(self->aq_hw,
 						     self->mc_list.ar,
@@ -464,14 +468,16 @@ int aq_nic_start(struct aq_nic_s *self)
 unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 			    struct aq_ring_s *ring)
 {
-	unsigned int ret =3D 0U;
 	unsigned int nr_frags =3D skb_shinfo(skb)->nr_frags;
-	unsigned int frag_count =3D 0U;
-	unsigned int dx =3D ring->sw_tail;
 	struct aq_ring_buff_s *first =3D NULL;
-	struct aq_ring_buff_s *dx_buff =3D &ring->buff_ring[dx];
+	struct aq_ring_buff_s *dx_buff;
 	bool need_context_tag =3D false;
+	unsigned int frag_count =3D 0U;
+	unsigned int ret =3D 0U;
+	unsigned int dx;
=20
+	dx =3D ring->sw_tail;
+	dx_buff =3D &ring->buff_ring[dx];
 	dx_buff->flags =3D 0U;
=20
 	if (unlikely(skb_is_gso(skb))) {
@@ -610,11 +616,11 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, st=
ruct sk_buff *skb,
=20
 int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 {
+	unsigned int vec =3D skb->queue_mapping % self->aq_nic_cfg.vecs;
 	struct aq_ring_s *ring =3D NULL;
 	unsigned int frags =3D 0U;
-	unsigned int vec =3D skb->queue_mapping % self->aq_nic_cfg.vecs;
-	unsigned int tc =3D 0U;
 	int err =3D NETDEV_TX_OK;
+	unsigned int tc =3D 0U;
=20
 	frags =3D skb_shinfo(skb)->nr_frags + 1;
=20
@@ -712,6 +718,7 @@ int aq_nic_set_multicast_list(struct aq_nic_s *self, st=
ruct net_device *ndev)
 		if (err < 0)
 			return err;
 	}
+
 	return aq_nic_set_packet_filter(self, packet_filter);
 }
=20
@@ -756,10 +763,10 @@ int aq_nic_get_regs_count(struct aq_nic_s *self)
=20
 void aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 {
-	unsigned int i =3D 0U;
-	unsigned int count =3D 0U;
 	struct aq_vec_s *aq_vec =3D NULL;
 	struct aq_stats_s *stats;
+	unsigned int count =3D 0U;
+	unsigned int i =3D 0U;
=20
 	if (self->aq_fw_ops->update_stats) {
 		mutex_lock(&self->fwreq_mutex);
@@ -809,8 +816,8 @@ err_exit:;
=20
 static void aq_nic_update_ndev_stats(struct aq_nic_s *self)
 {
-	struct net_device *ndev =3D self->ndev;
 	struct aq_stats_s *stats =3D self->aq_hw_ops->hw_get_hw_stats(self->aq_hw=
);
+	struct net_device *ndev =3D self->ndev;
=20
 	ndev->stats.rx_packets =3D stats->dma_pkt_rc;
 	ndev->stats.rx_bytes =3D stats->dma_oct_rc;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.h
index bb4957a31498..98c3182bf1d0 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -72,8 +72,8 @@ struct aq_hw_rx_fl2 {
 };
=20
 struct aq_hw_rx_fl3l4 {
-	u8   active_ipv4;
-	u8   active_ipv6:2;
+	u8 active_ipv4;
+	u8 active_ipv6:2;
 	u8 is_ipv6;
 	u8 reserved_count;
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers=
/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 3169951fe6ab..a161026cfbfd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -185,6 +185,7 @@ unsigned int aq_pci_func_get_irq_type(struct aq_nic_s *=
self)
 		return AQ_HW_IRQ_MSIX;
 	if (self->pdev->msi_enabled)
 		return AQ_HW_IRQ_MSI;
+
 	return AQ_HW_IRQ_LEGACY;
 }
=20
@@ -196,12 +197,12 @@ static void aq_pci_free_irq_vectors(struct aq_nic_s *=
self)
 static int aq_pci_probe(struct pci_dev *pdev,
 			const struct pci_device_id *pci_id)
 {
-	struct aq_nic_s *self;
-	int err;
 	struct net_device *ndev;
 	resource_size_t mmio_pa;
-	u32 bar;
+	struct aq_nic_s *self;
 	u32 numvecs;
+	u32 bar;
+	int err;
=20
 	err =3D pci_enable_device(pdev);
 	if (err)
@@ -311,6 +312,7 @@ static int aq_pci_probe(struct pci_dev *pdev,
 	pci_release_regions(pdev);
 err_pci_func:
 	pci_disable_device(pdev);
+
 	return err;
 }
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.c
index f756cc0bbdf0..951d86f8b66e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -30,8 +30,8 @@ static int aq_get_rxpage(struct aq_rxpage *rxpage, unsign=
ed int order,
 			 struct device *dev)
 {
 	struct page *page;
-	dma_addr_t daddr;
 	int ret =3D -ENOMEM;
+	dma_addr_t daddr;
=20
 	page =3D dev_alloc_pages(order);
 	if (unlikely(!page))
@@ -118,6 +118,7 @@ static struct aq_ring_s *aq_ring_alloc(struct aq_ring_s=
 *self,
 		aq_ring_free(self);
 		self =3D NULL;
 	}
+
 	return self;
 }
=20
@@ -144,6 +145,7 @@ struct aq_ring_s *aq_ring_tx_alloc(struct aq_ring_s *se=
lf,
 		aq_ring_free(self);
 		self =3D NULL;
 	}
+
 	return self;
 }
=20
@@ -175,6 +177,7 @@ struct aq_ring_s *aq_ring_rx_alloc(struct aq_ring_s *se=
lf,
 		aq_ring_free(self);
 		self =3D NULL;
 	}
+
 	return self;
 }
=20
@@ -207,6 +210,7 @@ int aq_ring_init(struct aq_ring_s *self)
 	self->hw_head =3D 0;
 	self->sw_head =3D 0;
 	self->sw_tail =3D 0;
+
 	return 0;
 }
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_vec.c
index a95c263a45aa..6e19e27b6200 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -103,8 +103,8 @@ static int aq_vec_poll(struct napi_struct *napi, int bu=
dget)
 struct aq_vec_s *aq_vec_alloc(struct aq_nic_s *aq_nic, unsigned int idx,
 			      struct aq_nic_cfg_s *aq_nic_cfg)
 {
-	struct aq_vec_s *self =3D NULL;
 	struct aq_ring_s *ring =3D NULL;
+	struct aq_vec_s *self =3D NULL;
 	unsigned int i =3D 0U;
 	int err =3D 0;
=20
@@ -159,6 +159,7 @@ struct aq_vec_s *aq_vec_alloc(struct aq_nic_s *aq_nic, =
unsigned int idx,
 		aq_vec_free(self);
 		self =3D NULL;
 	}
+
 	return self;
 }
=20
@@ -263,6 +264,7 @@ void aq_vec_deinit(struct aq_vec_s *self)
 		aq_ring_tx_clean(&ring[AQ_VEC_TX_ID]);
 		aq_ring_rx_deinit(&ring[AQ_VEC_RX_ID]);
 	}
+
 err_exit:;
 }
=20
@@ -305,8 +307,8 @@ irqreturn_t aq_vec_isr(int irq, void *private)
 irqreturn_t aq_vec_isr_legacy(int irq, void *private)
 {
 	struct aq_vec_s *self =3D private;
+	irqreturn_t err =3D 0;
 	u64 irq_mask =3D 0U;
-	int err;
=20
 	if (!self)
 		return IRQ_NONE;
@@ -361,9 +363,9 @@ void aq_vec_add_stats(struct aq_vec_s *self,
=20
 int aq_vec_get_sw_stats(struct aq_vec_s *self, u64 *data, unsigned int *p_=
count)
 {
-	unsigned int count =3D 0U;
 	struct aq_ring_stats_rx_s stats_rx;
 	struct aq_ring_stats_tx_s stats_tx;
+	unsigned int count =3D 0U;
=20
 	memset(&stats_rx, 0U, sizeof(struct aq_ring_stats_rx_s));
 	memset(&stats_tx, 0U, sizeof(struct aq_ring_stats_tx_s));
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index 359a4d387185..d2fb399f179f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -119,10 +119,10 @@ static int hw_atl_a0_hw_reset(struct aq_hw_s *self)
=20
 static int hw_atl_a0_hw_qos_set(struct aq_hw_s *self)
 {
-	u32 tc =3D 0U;
-	u32 buff_size =3D 0U;
-	unsigned int i_priority =3D 0U;
 	bool is_rx_flow_control =3D false;
+	unsigned int i_priority =3D 0U;
+	u32 buff_size =3D 0U;
+	u32 tc =3D 0U;
=20
 	/* TPS Descriptor rate init */
 	hw_atl_tps_tx_pkt_shed_desc_rate_curr_time_res_set(self, 0x0U);
@@ -180,9 +180,9 @@ static int hw_atl_a0_hw_rss_hash_set(struct aq_hw_s *se=
lf,
 				     struct aq_rss_parameters *rss_params)
 {
 	struct aq_nic_cfg_s *cfg =3D self->aq_nic_cfg;
-	int err =3D 0;
-	unsigned int i =3D 0U;
 	unsigned int addr =3D 0U;
+	unsigned int i =3D 0U;
+	int err =3D 0;
 	u32 val;
=20
 	for (i =3D 10, addr =3D 0U; i--; ++addr) {
@@ -207,12 +207,12 @@ static int hw_atl_a0_hw_rss_hash_set(struct aq_hw_s *=
self,
 static int hw_atl_a0_hw_rss_set(struct aq_hw_s *self,
 				struct aq_rss_parameters *rss_params)
 {
-	u8 *indirection_table =3D	rss_params->indirection_table;
-	u32 i =3D 0U;
 	u32 num_rss_queues =3D max(1U, self->aq_nic_cfg->num_rss_queues);
-	int err =3D 0;
+	u8 *indirection_table =3D	rss_params->indirection_table;
 	u16 bitary[1 + (HW_ATL_A0_RSS_REDIRECTION_MAX *
 		   HW_ATL_A0_RSS_REDIRECTION_BITS / 16U)];
+	int err =3D 0;
+	u32 i =3D 0U;
 	u32 val;
=20
 	memset(bitary, 0, sizeof(bitary));
@@ -321,9 +321,9 @@ static int hw_atl_a0_hw_init_rx_path(struct aq_hw_s *se=
lf)
=20
 static int hw_atl_a0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
 {
-	int err =3D 0;
 	unsigned int h =3D 0U;
 	unsigned int l =3D 0U;
+	int err =3D 0;
=20
 	if (!mac_addr) {
 		err =3D -EINVAL;
@@ -352,10 +352,9 @@ static int hw_atl_a0_hw_init(struct aq_hw_s *self, u8 =
*mac_addr)
 		[AQ_HW_IRQ_MSI]     =3D { 0x20000021U, 0x20000025U },
 		[AQ_HW_IRQ_MSIX]    =3D { 0x20000022U, 0x20000026U },
 	};
-
+	struct aq_nic_cfg_s *aq_nic_cfg =3D self->aq_nic_cfg;
 	int err =3D 0;
=20
-	struct aq_nic_cfg_s *aq_nic_cfg =3D self->aq_nic_cfg;
=20
 	hw_atl_a0_hw_init_tx_path(self);
 	hw_atl_a0_hw_init_rx_path(self);
@@ -404,6 +403,7 @@ static int hw_atl_a0_hw_ring_tx_start(struct aq_hw_s *s=
elf,
 				      struct aq_ring_s *ring)
 {
 	hw_atl_tdm_tx_desc_en_set(self, 1, ring->idx);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -411,6 +411,7 @@ static int hw_atl_a0_hw_ring_rx_start(struct aq_hw_s *s=
elf,
 				      struct aq_ring_s *ring)
 {
 	hw_atl_rdm_rx_desc_en_set(self, 1, ring->idx);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -418,6 +419,7 @@ static int hw_atl_a0_hw_start(struct aq_hw_s *self)
 {
 	hw_atl_tpb_tx_buff_en_set(self, 1);
 	hw_atl_rpb_rx_buff_en_set(self, 1);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -425,6 +427,7 @@ static int hw_atl_a0_hw_tx_ring_tail_update(struct aq_h=
w_s *self,
 					    struct aq_ring_s *ring)
 {
 	hw_atl_reg_tx_dma_desc_tail_ptr_set(self, ring->sw_tail, ring->idx);
+
 	return 0;
 }
=20
@@ -435,8 +438,8 @@ static int hw_atl_a0_hw_ring_tx_xmit(struct aq_hw_s *se=
lf,
 	struct aq_ring_buff_s *buff =3D NULL;
 	struct hw_atl_txd_s *txd =3D NULL;
 	unsigned int buff_pa_len =3D 0U;
-	unsigned int pkt_len =3D 0U;
 	unsigned int frag_count =3D 0U;
+	unsigned int pkt_len =3D 0U;
 	bool is_gso =3D false;
=20
 	buff =3D &ring->buff_ring[ring->sw_tail];
@@ -500,6 +503,7 @@ static int hw_atl_a0_hw_ring_tx_xmit(struct aq_hw_s *se=
lf,
 	}
=20
 	hw_atl_a0_hw_tx_ring_tail_update(self, ring);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -507,8 +511,8 @@ static int hw_atl_a0_hw_ring_rx_init(struct aq_hw_s *se=
lf,
 				     struct aq_ring_s *aq_ring,
 				     struct aq_ring_param_s *aq_ring_param)
 {
-	u32 dma_desc_addr_lsw =3D (u32)aq_ring->dx_ring_pa;
 	u32 dma_desc_addr_msw =3D (u32)(((u64)aq_ring->dx_ring_pa) >> 32);
+	u32 dma_desc_addr_lsw =3D (u32)aq_ring->dx_ring_pa;
=20
 	hw_atl_rdm_rx_desc_en_set(self, false, aq_ring->idx);
=20
@@ -549,8 +553,8 @@ static int hw_atl_a0_hw_ring_tx_init(struct aq_hw_s *se=
lf,
 				     struct aq_ring_s *aq_ring,
 				     struct aq_ring_param_s *aq_ring_param)
 {
-	u32 dma_desc_lsw_addr =3D (u32)aq_ring->dx_ring_pa;
 	u32 dma_desc_msw_addr =3D (u32)(((u64)aq_ring->dx_ring_pa) >> 32);
+	u32 dma_desc_lsw_addr =3D (u32)aq_ring->dx_ring_pa;
=20
 	hw_atl_reg_tx_dma_desc_base_addresslswset(self, dma_desc_lsw_addr,
 						  aq_ring->idx);
@@ -599,8 +603,8 @@ static int hw_atl_a0_hw_ring_rx_fill(struct aq_hw_s *se=
lf,
 static int hw_atl_a0_hw_ring_tx_head_update(struct aq_hw_s *self,
 					    struct aq_ring_s *ring)
 {
-	int err =3D 0;
 	unsigned int hw_head =3D hw_atl_tdm_tx_desc_head_ptr_get(self, ring->idx)=
;
+	int err =3D 0;
=20
 	if (aq_utils_obj_test(&self->flags, AQ_HW_FLAG_ERR_UNPLUG)) {
 		err =3D -ENXIO;
@@ -720,6 +724,7 @@ static int hw_atl_a0_hw_irq_enable(struct aq_hw_s *self=
, u64 mask)
 {
 	hw_atl_itr_irq_msk_setlsw_set(self, LODWORD(mask) |
 			       (1U << HW_ATL_A0_ERR_INT));
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -737,6 +742,7 @@ static int hw_atl_a0_hw_irq_disable(struct aq_hw_s *sel=
f, u64 mask)
 static int hw_atl_a0_hw_irq_read(struct aq_hw_s *self, u64 *mask)
 {
 	*mask =3D hw_atl_itr_irq_statuslsw_get(self);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -859,6 +865,7 @@ static int hw_atl_a0_hw_interrupt_moderation_set(struct=
 aq_hw_s *self)
 static int hw_atl_a0_hw_stop(struct aq_hw_s *self)
 {
 	hw_atl_a0_hw_irq_disable(self, HW_ATL_A0_INT_MASK);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -866,6 +873,7 @@ static int hw_atl_a0_hw_ring_tx_stop(struct aq_hw_s *se=
lf,
 				     struct aq_ring_s *ring)
 {
 	hw_atl_tdm_tx_desc_en_set(self, 0U, ring->idx);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -873,6 +881,7 @@ static int hw_atl_a0_hw_ring_rx_stop(struct aq_hw_s *se=
lf,
 				     struct aq_ring_s *ring)
 {
 	hw_atl_rdm_rx_desc_en_set(self, 0U, ring->idx);
+
 	return aq_hw_err_from_flags(self);
 }
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 92115362d549..a51826907467 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -107,14 +107,15 @@ static int hw_atl_b0_hw_reset(struct aq_hw_s *self)
 static int hw_atl_b0_set_fc(struct aq_hw_s *self, u32 fc, u32 tc)
 {
 	hw_atl_rpb_rx_xoff_en_per_tc_set(self, !!(fc & AQ_NIC_FC_RX), tc);
+
 	return 0;
 }
=20
 static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 {
-	u32 tc =3D 0U;
-	u32 buff_size =3D 0U;
 	unsigned int i_priority =3D 0U;
+	u32 buff_size =3D 0U;
+	u32 tc =3D 0U;
=20
 	/* TPS Descriptor rate init */
 	hw_atl_tps_tx_pkt_shed_desc_rate_curr_time_res_set(self, 0x0U);
@@ -188,9 +189,9 @@ static int hw_atl_b0_hw_rss_hash_set(struct aq_hw_s *se=
lf,
 				     struct aq_rss_parameters *rss_params)
 {
 	struct aq_nic_cfg_s *cfg =3D self->aq_nic_cfg;
-	int err =3D 0;
-	unsigned int i =3D 0U;
 	unsigned int addr =3D 0U;
+	unsigned int i =3D 0U;
+	int err =3D 0;
 	u32 val;
=20
 	for (i =3D 10, addr =3D 0U; i--; ++addr) {
@@ -215,12 +216,12 @@ static int hw_atl_b0_hw_rss_hash_set(struct aq_hw_s *=
self,
 static int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
 				struct aq_rss_parameters *rss_params)
 {
-	u8 *indirection_table =3D	rss_params->indirection_table;
-	u32 i =3D 0U;
 	u32 num_rss_queues =3D max(1U, self->aq_nic_cfg->num_rss_queues);
-	int err =3D 0;
+	u8 *indirection_table =3D	rss_params->indirection_table;
 	u16 bitary[1 + (HW_ATL_B0_RSS_REDIRECTION_MAX *
 		   HW_ATL_B0_RSS_REDIRECTION_BITS / 16U)];
+	int err =3D 0;
+	u32 i =3D 0U;
 	u32 val;
=20
 	memset(bitary, 0, sizeof(bitary));
@@ -304,6 +305,7 @@ static int hw_atl_b0_hw_offload_set(struct aq_hw_s *sel=
f,
=20
 		hw_atl_itr_rsc_delay_set(self, 1U);
 	}
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -382,9 +384,9 @@ static int hw_atl_b0_hw_init_rx_path(struct aq_hw_s *se=
lf)
=20
 static int hw_atl_b0_hw_mac_addr_set(struct aq_hw_s *self, u8 *mac_addr)
 {
-	int err =3D 0;
 	unsigned int h =3D 0U;
 	unsigned int l =3D 0U;
+	int err =3D 0;
=20
 	if (!mac_addr) {
 		err =3D -EINVAL;
@@ -413,11 +415,10 @@ static int hw_atl_b0_hw_init(struct aq_hw_s *self, u8=
 *mac_addr)
 		[AQ_HW_IRQ_MSI]     =3D { 0x20000021U, 0x20000025U },
 		[AQ_HW_IRQ_MSIX]    =3D { 0x20000022U, 0x20000026U },
 	};
-
+	struct aq_nic_cfg_s *aq_nic_cfg =3D self->aq_nic_cfg;
 	int err =3D 0;
 	u32 val;
=20
-	struct aq_nic_cfg_s *aq_nic_cfg =3D self->aq_nic_cfg;
=20
 	hw_atl_b0_hw_init_tx_path(self);
 	hw_atl_b0_hw_init_rx_path(self);
@@ -460,8 +461,10 @@ static int hw_atl_b0_hw_init(struct aq_hw_s *self, u8 =
*mac_addr)
=20
 	/* Interrupts */
 	hw_atl_reg_gen_irq_map_set(self,
-				   ((HW_ATL_B0_ERR_INT << 0x18) | (1U << 0x1F)) |
-			    ((HW_ATL_B0_ERR_INT << 0x10) | (1U << 0x17)), 0U);
+				   ((HW_ATL_B0_ERR_INT << 0x18) |
+				    (1U << 0x1F)) |
+				   ((HW_ATL_B0_ERR_INT << 0x10) |
+				    (1U << 0x17)), 0U);
=20
 	/* Enable link interrupt */
 	if (aq_nic_cfg->link_irq_vec)
@@ -478,6 +481,7 @@ static int hw_atl_b0_hw_ring_tx_start(struct aq_hw_s *s=
elf,
 				      struct aq_ring_s *ring)
 {
 	hw_atl_tdm_tx_desc_en_set(self, 1, ring->idx);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -485,6 +489,7 @@ static int hw_atl_b0_hw_ring_rx_start(struct aq_hw_s *s=
elf,
 				      struct aq_ring_s *ring)
 {
 	hw_atl_rdm_rx_desc_en_set(self, 1, ring->idx);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -492,6 +497,7 @@ static int hw_atl_b0_hw_start(struct aq_hw_s *self)
 {
 	hw_atl_tpb_tx_buff_en_set(self, 1);
 	hw_atl_rpb_rx_buff_en_set(self, 1);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -499,6 +505,7 @@ static int hw_atl_b0_hw_tx_ring_tail_update(struct aq_h=
w_s *self,
 					    struct aq_ring_s *ring)
 {
 	hw_atl_reg_tx_dma_desc_tail_ptr_set(self, ring->sw_tail, ring->idx);
+
 	return 0;
 }
=20
@@ -509,8 +516,8 @@ static int hw_atl_b0_hw_ring_tx_xmit(struct aq_hw_s *se=
lf,
 	struct aq_ring_buff_s *buff =3D NULL;
 	struct hw_atl_txd_s *txd =3D NULL;
 	unsigned int buff_pa_len =3D 0U;
-	unsigned int pkt_len =3D 0U;
 	unsigned int frag_count =3D 0U;
+	unsigned int pkt_len =3D 0U;
 	bool is_vlan =3D false;
 	bool is_gso =3D false;
=20
@@ -586,6 +593,7 @@ static int hw_atl_b0_hw_ring_tx_xmit(struct aq_hw_s *se=
lf,
 	}
=20
 	hw_atl_b0_hw_tx_ring_tail_update(self, ring);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -593,9 +601,9 @@ static int hw_atl_b0_hw_ring_rx_init(struct aq_hw_s *se=
lf,
 				     struct aq_ring_s *aq_ring,
 				     struct aq_ring_param_s *aq_ring_param)
 {
-	u32 dma_desc_addr_lsw =3D (u32)aq_ring->dx_ring_pa;
 	u32 dma_desc_addr_msw =3D (u32)(((u64)aq_ring->dx_ring_pa) >> 32);
 	u32 vlan_rx_stripping =3D self->aq_nic_cfg->is_vlan_rx_strip;
+	u32 dma_desc_addr_lsw =3D (u32)aq_ring->dx_ring_pa;
=20
 	hw_atl_rdm_rx_desc_en_set(self, false, aq_ring->idx);
=20
@@ -636,8 +644,8 @@ static int hw_atl_b0_hw_ring_tx_init(struct aq_hw_s *se=
lf,
 				     struct aq_ring_s *aq_ring,
 				     struct aq_ring_param_s *aq_ring_param)
 {
-	u32 dma_desc_lsw_addr =3D (u32)aq_ring->dx_ring_pa;
 	u32 dma_desc_msw_addr =3D (u32)(((u64)aq_ring->dx_ring_pa) >> 32);
+	u32 dma_desc_lsw_addr =3D (u32)aq_ring->dx_ring_pa;
=20
 	hw_atl_reg_tx_dma_desc_base_addresslswset(self, dma_desc_lsw_addr,
 						  aq_ring->idx);
@@ -726,8 +734,10 @@ static int hw_atl_b0_hw_ring_hwts_rx_receive(struct aq=
_hw_s *self,
 static int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
 					    struct aq_ring_s *ring)
 {
+	unsigned int hw_head_;
 	int err =3D 0;
-	unsigned int hw_head_ =3D hw_atl_tdm_tx_desc_head_ptr_get(self, ring->idx=
);
+
+	hw_head_ =3D hw_atl_tdm_tx_desc_head_ptr_get(self, ring->idx);
=20
 	if (aq_utils_obj_test(&self->flags, AQ_HW_FLAG_ERR_UNPLUG)) {
 		err =3D -ENXIO;
@@ -843,6 +853,7 @@ static int hw_atl_b0_hw_ring_rx_receive(struct aq_hw_s =
*self,
 static int hw_atl_b0_hw_irq_enable(struct aq_hw_s *self, u64 mask)
 {
 	hw_atl_itr_irq_msk_setlsw_set(self, LODWORD(mask));
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -852,12 +863,14 @@ static int hw_atl_b0_hw_irq_disable(struct aq_hw_s *s=
elf, u64 mask)
 	hw_atl_itr_irq_status_clearlsw_set(self, LODWORD(mask));
=20
 	atomic_inc(&self->dpc);
+
 	return aq_hw_err_from_flags(self);
 }
=20
 static int hw_atl_b0_hw_irq_read(struct aq_hw_s *self, u64 *mask)
 {
 	*mask =3D hw_atl_itr_irq_statuslsw_get(self);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -866,8 +879,8 @@ static int hw_atl_b0_hw_irq_read(struct aq_hw_s *self, =
u64 *mask)
 static int hw_atl_b0_hw_packet_filter_set(struct aq_hw_s *self,
 					  unsigned int packet_filter)
 {
-	unsigned int i =3D 0U;
 	struct aq_nic_cfg_s *cfg =3D self->aq_nic_cfg;
+	unsigned int i =3D 0U;
=20
 	hw_atl_rpfl2promiscuous_mode_en_set(self,
 					    IS_FILTER_ENABLED(IFF_PROMISC));
@@ -905,29 +918,30 @@ static int hw_atl_b0_hw_multicast_list_set(struct aq_=
hw_s *self,
 					   u32 count)
 {
 	int err =3D 0;
+	struct aq_nic_cfg_s *cfg =3D self->aq_nic_cfg;
=20
 	if (count > (HW_ATL_B0_MAC_MAX - HW_ATL_B0_MAC_MIN)) {
 		err =3D -EBADRQC;
 		goto err_exit;
 	}
-	for (self->aq_nic_cfg->mc_list_count =3D 0U;
-			self->aq_nic_cfg->mc_list_count < count;
-			++self->aq_nic_cfg->mc_list_count) {
-		u32 i =3D self->aq_nic_cfg->mc_list_count;
+	for (cfg->mc_list_count =3D 0U;
+			cfg->mc_list_count < count;
+			++cfg->mc_list_count) {
+		u32 i =3D cfg->mc_list_count;
 		u32 h =3D (ar_mac[i][0] << 8) | (ar_mac[i][1]);
 		u32 l =3D (ar_mac[i][2] << 24) | (ar_mac[i][3] << 16) |
 					(ar_mac[i][4] << 8) | ar_mac[i][5];
=20
 		hw_atl_rpfl2_uc_flr_en_set(self, 0U, HW_ATL_B0_MAC_MIN + i);
=20
-		hw_atl_rpfl2unicast_dest_addresslsw_set(self,
-							l, HW_ATL_B0_MAC_MIN + i);
+		hw_atl_rpfl2unicast_dest_addresslsw_set(self, l,
+							HW_ATL_B0_MAC_MIN + i);
=20
-		hw_atl_rpfl2unicast_dest_addressmsw_set(self,
-							h, HW_ATL_B0_MAC_MIN + i);
+		hw_atl_rpfl2unicast_dest_addressmsw_set(self, h,
+							HW_ATL_B0_MAC_MIN + i);
=20
 		hw_atl_rpfl2_uc_flr_en_set(self,
-					   (self->aq_nic_cfg->is_mc_list_enabled),
+					   (cfg->is_mc_list_enabled),
 					   HW_ATL_B0_MAC_MIN + i);
 	}
=20
@@ -1054,6 +1068,7 @@ static int hw_atl_b0_hw_ring_tx_stop(struct aq_hw_s *=
self,
 				     struct aq_ring_s *ring)
 {
 	hw_atl_tdm_tx_desc_en_set(self, 0U, ring->idx);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -1061,6 +1076,7 @@ static int hw_atl_b0_hw_ring_rx_stop(struct aq_hw_s *=
self,
 				     struct aq_ring_s *ring)
 {
 	hw_atl_rdm_rx_desc_en_set(self, 0U, ring->idx);
+
 	return aq_hw_err_from_flags(self);
 }
=20
@@ -1448,6 +1464,7 @@ static int hw_atl_b0_set_loopback(struct aq_hw_s *sel=
f, u32 mode, bool enable)
 	default:
 		return -EINVAL;
 	}
+
 	return 0;
 }
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index db8c09c5a768..8910b62e67ed 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -92,6 +92,7 @@ int hw_atl_utils_initfw(struct aq_hw_s *self, const struc=
t aq_fw_ops **fw_ops)
 	}
 	self->aq_fw_ops =3D *fw_ops;
 	err =3D self->aq_fw_ops->init(self);
+
 	return err;
 }
=20
@@ -242,9 +243,9 @@ static int hw_atl_utils_soft_reset_rbl(struct aq_hw_s *=
self)
=20
 int hw_atl_utils_soft_reset(struct aq_hw_s *self)
 {
-	int k;
 	u32 boot_exit_code =3D 0;
 	u32 val;
+	int k;
=20
 	for (k =3D 0; k < 1000; ++k) {
 		u32 flb_status =3D aq_hw_read_reg(self,
@@ -439,15 +440,16 @@ int hw_atl_write_fwsettings_dwords(struct aq_hw_s *se=
lf, u32 offset, u32 *p,
=20
 static int hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual)
 {
-	int err =3D 0;
 	const u32 dw_major_mask =3D 0xff000000U;
 	const u32 dw_minor_mask =3D 0x00ffffffU;
+	int err =3D 0;
=20
 	err =3D (dw_major_mask & (ver_expected ^ ver_actual)) ? -EOPNOTSUPP : 0;
 	if (err < 0)
 		goto err_exit;
 	err =3D ((dw_minor_mask & ver_expected) > (dw_minor_mask & ver_actual)) ?
 		-EOPNOTSUPP : 0;
+
 err_exit:
 	return err;
 }
@@ -492,8 +494,8 @@ struct aq_hw_atl_utils_fw_rpc_tid_s {
=20
 int hw_atl_utils_fw_rpc_call(struct aq_hw_s *self, unsigned int rpc_size)
 {
-	int err =3D 0;
 	struct aq_hw_atl_utils_fw_rpc_tid_s sw;
+	int err =3D 0;
=20
 	if (!IS_CHIP_FEATURE(MIPS)) {
 		err =3D -1;
@@ -516,9 +518,9 @@ int hw_atl_utils_fw_rpc_call(struct aq_hw_s *self, unsi=
gned int rpc_size)
 int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
 			     struct hw_atl_utils_fw_rpc **rpc)
 {
-	int err =3D 0;
 	struct aq_hw_atl_utils_fw_rpc_tid_s sw;
 	struct aq_hw_atl_utils_fw_rpc_tid_s fw;
+	int err =3D 0;
=20
 	do {
 		sw.val =3D aq_hw_read_reg(self, HW_ATL_RPC_CONTROL_ADR);
@@ -622,10 +624,10 @@ static int hw_atl_utils_mpi_set_speed(struct aq_hw_s =
*self, u32 speed)
 static int hw_atl_utils_mpi_set_state(struct aq_hw_s *self,
 				      enum hal_atl_utils_fw_state_e state)
 {
-	int err =3D 0;
-	u32 transaction_id =3D 0;
-	struct hw_atl_utils_mbox_header mbox;
 	u32 val =3D aq_hw_read_reg(self, HW_ATL_MPI_CONTROL_ADR);
+	struct hw_atl_utils_mbox_header mbox;
+	u32 transaction_id =3D 0;
+	int err =3D 0;
=20
 	if (state =3D=3D MPI_RESET) {
 		hw_atl_utils_mpi_read_mbox(self, &mbox);
@@ -653,20 +655,26 @@ static int hw_atl_utils_mpi_set_state(struct aq_hw_s =
*self,
 	val |=3D state & HW_ATL_MPI_STATE_MSK;
=20
 	aq_hw_write_reg(self, HW_ATL_MPI_CONTROL_ADR, val);
+
 err_exit:
 	return err;
 }
=20
 int hw_atl_utils_mpi_get_link_status(struct aq_hw_s *self)
 {
-	u32 cp0x036C =3D hw_atl_utils_mpi_get_state(self);
-	u32 link_speed_mask =3D cp0x036C >> HW_ATL_MPI_SPEED_SHIFT;
 	struct aq_hw_link_status_s *link_status =3D &self->aq_link_status;
+	u32 mpi_state;
+	u32 speed;
+
+	mpi_state =3D hw_atl_utils_mpi_get_state(self);
+	speed =3D mpi_state & (FW2X_RATE_100M | FW2X_RATE_1G |
+			     FW2X_RATE_2G5 | FW2X_RATE_5G |
+			     FW2X_RATE_10G);
=20
-	if (!link_speed_mask) {
+	if (!speed) {
 		link_status->mbps =3D 0U;
 	} else {
-		switch (link_speed_mask) {
+		switch (speed) {
 		case HAL_ATLANTIC_RATE_10G:
 			link_status->mbps =3D 10000U;
 			break;
@@ -699,14 +707,15 @@ int hw_atl_utils_mpi_get_link_status(struct aq_hw_s *=
self)
 int hw_atl_utils_get_mac_permanent(struct aq_hw_s *self,
 				   u8 *mac)
 {
+	u32 mac_addr[2];
+	u32 efuse_addr;
 	int err =3D 0;
 	u32 h =3D 0U;
 	u32 l =3D 0U;
-	u32 mac_addr[2];
=20
 	if (!aq_hw_read_reg(self, HW_ATL_UCP_0X370_REG)) {
-		unsigned int rnd =3D 0;
 		unsigned int ucp_0x370 =3D 0;
+		unsigned int rnd =3D 0;
=20
 		get_random_bytes(&rnd, sizeof(unsigned int));
=20
@@ -714,11 +723,10 @@ int hw_atl_utils_get_mac_permanent(struct aq_hw_s *se=
lf,
 		aq_hw_write_reg(self, HW_ATL_UCP_0X370_REG, ucp_0x370);
 	}
=20
-	err =3D hw_atl_utils_fw_downld_dwords(self,
-					    aq_hw_read_reg(self, 0x00000374U) +
-					    (40U * 4U),
-					    mac_addr,
-					    ARRAY_SIZE(mac_addr));
+	efuse_addr =3D aq_hw_read_reg(self, 0x00000374U);
+
+	err =3D hw_atl_utils_fw_downld_dwords(self, efuse_addr + (40U * 4U),
+					    mac_addr, ARRAY_SIZE(mac_addr));
 	if (err < 0) {
 		mac_addr[0] =3D 0U;
 		mac_addr[1] =3D 0U;
@@ -780,14 +788,15 @@ unsigned int hw_atl_utils_mbps_2_speed_index(unsigned=
 int mbps)
 	default:
 		break;
 	}
+
 	return ret;
 }
=20
 void hw_atl_utils_hw_chip_features_init(struct aq_hw_s *self, u32 *p)
 {
-	u32 chip_features =3D 0U;
 	u32 val =3D hw_atl_reg_glb_mif_id_get(self);
 	u32 mif_rev =3D val & 0xFFU;
+	u32 chip_features =3D 0U;
=20
 	if ((0xFU & mif_rev) =3D=3D 1U) {
 		chip_features |=3D HAL_ATLANTIC_UTILS_CHIP_REVISION_A0 |
@@ -814,13 +823,14 @@ static int hw_atl_fw1x_deinit(struct aq_hw_s *self)
 {
 	hw_atl_utils_mpi_set_speed(self, 0);
 	hw_atl_utils_mpi_set_state(self, MPI_DEINIT);
+
 	return 0;
 }
=20
 int hw_atl_utils_update_stats(struct aq_hw_s *self)
 {
-	struct hw_atl_utils_mbox mbox;
 	struct aq_stats_s *cs =3D &self->curr_stats;
+	struct hw_atl_utils_mbox mbox;
=20
 	hw_atl_utils_mpi_read_stats(self, &mbox);
=20
@@ -897,12 +907,14 @@ int hw_atl_utils_hw_get_regs(struct aq_hw_s *self,
 	for (i =3D 0; i < aq_hw_caps->mac_regs_count; i++)
 		regs_buff[i] =3D aq_hw_read_reg(self,
 					      hw_atl_utils_hw_mac_regs[i]);
+
 	return 0;
 }
=20
 int hw_atl_utils_get_fw_version(struct aq_hw_s *self, u32 *fw_version)
 {
 	*fw_version =3D aq_hw_read_reg(self, 0x18U);
+
 	return 0;
 }
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2=
x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index feef2b0177b2..ce3ed86d8c0e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -226,15 +226,20 @@ static int aq_fw2x_set_state(struct aq_hw_s *self,
 		break;
 	}
 	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, mpi_state);
+
 	return 0;
 }
=20
 static int aq_fw2x_update_link_status(struct aq_hw_s *self)
 {
-	u32 mpi_state =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_STATE_ADDR);
-	u32 speed =3D mpi_state & (FW2X_RATE_100M | FW2X_RATE_1G |
-				 FW2X_RATE_2G5 | FW2X_RATE_5G | FW2X_RATE_10G);
 	struct aq_hw_link_status_s *link_status =3D &self->aq_link_status;
+	u32 mpi_state;
+	u32 speed;
+
+	mpi_state =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_STATE_ADDR);
+	speed =3D mpi_state & (FW2X_RATE_100M | FW2X_RATE_1G |
+			     FW2X_RATE_2G5 | FW2X_RATE_5G |
+			     FW2X_RATE_10G);
=20
 	if (speed) {
 		if (speed & FW2X_RATE_10G)
@@ -258,11 +263,11 @@ static int aq_fw2x_update_link_status(struct aq_hw_s =
*self)
=20
 static int aq_fw2x_get_mac_permanent(struct aq_hw_s *self, u8 *mac)
 {
+	u32 efuse_addr =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_EFUSE_ADDR);
+	u32 mac_addr[2] =3D { 0 };
 	int err =3D 0;
 	u32 h =3D 0U;
 	u32 l =3D 0U;
-	u32 mac_addr[2] =3D { 0 };
-	u32 efuse_addr =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_EFUSE_ADDR);
=20
 	if (efuse_addr !=3D 0) {
 		err =3D hw_atl_utils_fw_downld_dwords(self,
@@ -296,15 +301,16 @@ static int aq_fw2x_get_mac_permanent(struct aq_hw_s *=
self, u8 *mac)
 		h >>=3D 8;
 		mac[0] =3D (u8)(0xFFU & h);
 	}
+
 	return err;
 }
=20
 static int aq_fw2x_update_stats(struct aq_hw_s *self)
 {
-	int err =3D 0;
 	u32 mpi_opts =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
 	u32 orig_stats_val =3D mpi_opts & BIT(CAPS_HI_STATISTICS);
 	u32 stats_val;
+	int err =3D 0;
=20
 	/* Toggle statistics bit for FW to update */
 	mpi_opts =3D mpi_opts ^ BIT(CAPS_HI_STATISTICS);
@@ -331,9 +337,9 @@ static int aq_fw2x_get_phy_temp(struct aq_hw_s *self, i=
nt *temp)
 	int err =3D 0;
 	u32 val;
=20
-	phy_temp_offset =3D self->mbox_addr +
-			  offsetof(struct hw_atl_utils_mbox, info) +
-			  offsetof(struct hw_aq_info, phy_temperature);
+	phy_temp_offset =3D self->mbox_addr + offsetof(struct hw_atl_utils_mbox,
+						     info.phy_temperature);
+
 	/* Toggle statistics bit for FW to 0x36C.18 (CTRL_TEMPERATURE) */
 	mpi_opts =3D mpi_opts ^ HW_ATL_FW2X_CTRL_TEMPERATURE;
 	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, mpi_opts);
@@ -486,11 +492,12 @@ static int aq_fw2x_get_eee_rate(struct aq_hw_s *self,=
 u32 *rate,
 	u32 mpi_state;
 	u32 caps_hi;
 	int err =3D 0;
-	u32 addr =3D self->mbox_addr + offsetof(struct hw_atl_utils_mbox, info) +
-		   offsetof(struct hw_aq_info, caps_hi);
+	u32 offset;
=20
-	err =3D hw_atl_utils_fw_downld_dwords(self, addr, &caps_hi,
-					    sizeof(caps_hi) / sizeof(u32));
+	offset =3D self->mbox_addr + offsetof(struct hw_atl_utils_mbox,
+					    info.caps_hi);
+
+	err =3D hw_atl_utils_fw_downld_dwords(self, offset, &caps_hi, 1);
=20
 	if (err)
 		return err;
@@ -567,6 +574,7 @@ static int aq_fw2x_set_phyloopback(struct aq_hw_s *self=
, u32 mode, bool enable)
 	default:
 		return -EINVAL;
 	}
+
 	return 0;
 }
=20
--=20
2.17.1

