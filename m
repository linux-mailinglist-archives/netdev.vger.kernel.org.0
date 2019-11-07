Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F96EF3B99
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfKGWmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:42:00 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12590 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727893AbfKGWl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:41:59 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7MekHM002988;
        Thu, 7 Nov 2019 14:41:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=qgIBIp5Oci3sFwu3uvL1vJj5Oauj8htBJgUg9KtVZPU=;
 b=gvg+J7Isrnmb/ySlwkK1Wu1kzaq/j2+QoGZ2wpjfahbljFOLgYuCYeoUbmQm3zBVjU59
 180vnzvpuMH52Y5L2UhZeIQvVCPx7/7W4Y0YRyaIieqmCNu2s80hDsvB6KdwsIx13I5o
 QHPLKsjzDMfochhf7n7NOYb5lbH0Cjr+ITFGMN5Wf5wCdsZcV01PokCRP4UuQaZGdlAM
 PASnV+Af/GRQ3KGgykwI383J///LSL7Ak8QMtBTKZb+ofZUkW9NFfVuEvhAAy+PZ5Wfh
 NsgMc6sjL8HWM2CSCIcDSTV005gr+ZQfusbuvn0FQ34JDKlQlqTsYevD/wqV6ac29k/D 5A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w41uwxrf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 14:41:58 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 7 Nov
 2019 14:41:57 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.50) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 7 Nov 2019 14:41:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxWtk5Ha353bKEoFdeGbj/O+Uot2utrSb2Zya3qU41h4nIzXAFhbe+hZT++9uUz28VBDE/SsNIhZ0hfduF7Zppwoe+PYxGlEf5PGZU1kG0ZwO7SukaLd7G89YQSP7xyyfPjEDwV0aX3qd9Rmw73MjgZ2HCM3PDORNGsaLJNOmjCZyOxvV7dD9UUGOiN6jnnST9OGmYKUxXPG92LvTQ+qrFARDEMCe+Bi65dDtkioXct4AL93pxL4p5zor7cjap96sh6IMC+HHNJlR8H0tcUK0pdZCm+f81+JMabeyvfsBJ4VMRdpgiYDXqEoQcEc+OzkgyoSTvXwjqVW0SF81eE6Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgIBIp5Oci3sFwu3uvL1vJj5Oauj8htBJgUg9KtVZPU=;
 b=ENsN42/R65+3itHwC55olVafEmxannFvCDQPnocKW74tfTmOLy5IW/IHwYTZov5DKPrw/RUqAGRhmDxq3MjPHHroeHPse4OR/jQNl/jNiHddss7P0t2OAzUwL4HbMdABIaKa2Vgegti+Zah1NtQdOkkgExDr9fUlIfFp7Mu0EzVv37Gca2mYtPhHPZ9yABaxDHb5vNM3tvj1bKVlmY6KzVksV8+vw6URyQPM6XoGgmeq1DvwOi9dlQEArD49ejbyLE6XVhHxF42SrL2p9cwtjnNVHTWw10nCgKLRxzsUPnSX0Xu9eW/IO2EBmM3L5xRuyLbnjVdJw2UEeCh8IbyFJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgIBIp5Oci3sFwu3uvL1vJj5Oauj8htBJgUg9KtVZPU=;
 b=g5GNCTEEy4hILP99BGfIqe6XHBztTU8NsmrDtdH6fvkxbuqJmZ0ulqbLTpCjpymrIjAwcmc9tMpHjF96I38r95iveeNGMXkk94TF2JXCDfNText5ke1uUjZb7QDaN8E0irmJLCykSEXb6r9JPZMexz6x0tV9idu5BrBoHmrIg5o=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB2295.namprd18.prod.outlook.com (52.132.142.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 22:41:55 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:41:55 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH v2 net-next 05/12] net: atlantic: adding ethtool physical
 identification
Thread-Topic: [PATCH v2 net-next 05/12] net: atlantic: adding ethtool physical
 identification
Thread-Index: AQHVlbyO2e2uE8KoCkGlJgZoIr7C7A==
Date:   Thu, 7 Nov 2019 22:41:55 +0000
Message-ID: <c348dd9fd3363fbc46e6ca58f80181f82e509f08.1573158382.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: 8ee85861-52de-4163-3b8d-08d763d3b113
x-ms-traffictypediagnostic: DM5PR18MB2295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB22951448D04DFB07C6263737B7780@DM5PR18MB2295.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:78;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(64756008)(76176011)(7736002)(99286004)(316002)(66066001)(54906003)(2351001)(52116002)(5640700003)(2501003)(8676002)(25786009)(118296001)(8936002)(305945005)(81166006)(81156014)(1730700003)(6486002)(478600001)(71200400001)(71190400001)(6436002)(50226002)(6916009)(66476007)(6116002)(6512007)(14454004)(2616005)(476003)(256004)(486006)(186003)(3846002)(102836004)(11346002)(107886003)(36756003)(66946007)(26005)(2906002)(66446008)(86362001)(66556008)(4326008)(386003)(6506007)(5660300002)(446003)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB2295;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c334+NrkFLPgf5eUybfYfUN2KbsENBqK6YmGGlkHhH8270KuGDCQfGuyF9Al+Byvcrek922MMsSc2saTCX2ACBKlLj2jXzPbGuN/PNGkWCIpuWYY9MI8N64lmt6UEg8Pki8uyn+3OITJtcWacibRZVeFjr1MXXfdN8NJ8pTjWyuccETTs+ho8TS6P0nu1QdLOX4kDY5K+O5SJv6PmO12omZci4SRxaSiDuy2aDx7zrZPWBfXEDVs8kjkgCf/M06YD7RkeZQ4mxpuaOUWmriOC+R1zRhNpG1p6CZ+U9jtp5ES7R5f9+TzHSpr3iWAaIv4YtGkQVS/nd9Edic5vDWEi+t+k9IdlDzSZlk3pzMisbcvyFVEOLQHIuWj0SyF49UQ+U4ES/oxZ5rl2Ct7bc9hqmD0waoh8H9cFPA11kVUB9enVsP1X7KTiVcxJrKAwU6u
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee85861-52de-4163-3b8d-08d763d3b113
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:41:55.9080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ynwk94efdNzTdc/b/nQV7YTDz5xiw/vHcOiRn3hAhVJ4RDKzAvA72hDSrMAeBpK32Gdzw6YPNL6QJF5ARfGCEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2295
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

`ethtool -p eth0` will blink leds helping identify
physical port.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 30 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  5 ++++
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  1 +
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 14 +++++++++
 4 files changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/=
net/ethernet/aquantia/atlantic/aq_ethtool.c
index 5be273892430..2f877fb46615 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -153,6 +153,35 @@ static void aq_ethtool_get_strings(struct net_device *=
ndev,
 	}
 }
=20
+static int aq_ethtool_set_phys_id(struct net_device *ndev,
+				  enum ethtool_phys_id_state state)
+{
+	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
+	struct aq_hw_s *hw =3D aq_nic->aq_hw;
+	int ret =3D 0;
+
+	if (!aq_nic->aq_fw_ops->led_control)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&aq_nic->fwreq_mutex);
+
+	switch (state) {
+	case ETHTOOL_ID_ACTIVE:
+		ret =3D aq_nic->aq_fw_ops->led_control(hw, AQ_HW_LED_BLINK |
+				 AQ_HW_LED_BLINK << 2 | AQ_HW_LED_BLINK << 4);
+		break;
+	case ETHTOOL_ID_INACTIVE:
+		ret =3D aq_nic->aq_fw_ops->led_control(hw, AQ_HW_LED_DEFAULT);
+		break;
+	default:
+		break;
+	}
+
+	mutex_unlock(&aq_nic->fwreq_mutex);
+
+	return ret;
+}
+
 static int aq_ethtool_get_sset_count(struct net_device *ndev, int stringse=
t)
 {
 	int ret =3D 0;
@@ -627,6 +656,7 @@ const struct ethtool_ops aq_ethtool_ops =3D {
 	.get_regs            =3D aq_ethtool_get_regs,
 	.get_drvinfo         =3D aq_ethtool_get_drvinfo,
 	.get_strings         =3D aq_ethtool_get_strings,
+	.set_phys_id         =3D aq_ethtool_set_phys_id,
 	.get_rxfh_indir_size =3D aq_ethtool_get_rss_indir_size,
 	.get_wol             =3D aq_ethtool_get_wol,
 	.set_wol             =3D aq_ethtool_set_wol,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/e=
thernet/aquantia/atlantic/aq_hw.h
index 5246cf44ce51..c2725a58f050 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -119,6 +119,9 @@ struct aq_stats_s {
=20
 #define AQ_HW_MULTICAST_ADDRESS_MAX     32U
=20
+#define AQ_HW_LED_BLINK    0x2U
+#define AQ_HW_LED_DEFAULT  0x0U
+
 struct aq_hw_s {
 	atomic_t flags;
 	u8 rbl_enabled:1;
@@ -304,6 +307,8 @@ struct aq_fw_ops {
=20
 	int (*set_flow_control)(struct aq_hw_s *self);
=20
+	int (*led_control)(struct aq_hw_s *self, u32 mode);
+
 	int (*set_power)(struct aq_hw_s *self, unsigned int power_state,
 			 u8 *mac);
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index fd2c6be4e22e..fc82ede18b20 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -970,4 +970,5 @@ const struct aq_fw_ops aq_fw_1x_ops =3D {
 	.set_flow_control =3D NULL,
 	.send_fw_request =3D NULL,
 	.enable_ptp =3D NULL,
+	.led_control =3D NULL,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2=
x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 9b89622fa5d4..4eab51b5b400 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -17,6 +17,7 @@
 #include "hw_atl_utils.h"
 #include "hw_atl_llh.h"
=20
+#define HW_ATL_FW2X_MPI_LED_ADDR         0x31c
 #define HW_ATL_FW2X_MPI_RPC_ADDR         0x334
=20
 #define HW_ATL_FW2X_MPI_MBOX_ADDR        0x360
@@ -51,6 +52,8 @@
 #define HAL_ATLANTIC_WOL_FILTERS_COUNT   8
 #define HAL_ATLANTIC_UTILS_FW2X_MSG_WOL  0x0E
=20
+#define HW_ATL_FW_VER_LED                0x03010026U
+
 struct __packed fw2x_msg_wol_pattern {
 	u8 mask[16];
 	u32 crc;
@@ -450,6 +453,16 @@ static void aq_fw3x_enable_ptp(struct aq_hw_s *self, i=
nt enable)
 	aq_hw_write_reg(self, HW_ATL_FW3X_EXT_CONTROL_ADDR, ptp_opts);
 }
=20
+static int aq_fw2x_led_control(struct aq_hw_s *self, u32 mode)
+{
+	if (self->fw_ver_actual < HW_ATL_FW_VER_LED)
+		return -EOPNOTSUPP;
+
+	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_LED_ADDR, mode);
+
+	return 0;
+}
+
 static int aq_fw2x_set_eee_rate(struct aq_hw_s *self, u32 speed)
 {
 	u32 mpi_opts =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
@@ -557,4 +570,5 @@ const struct aq_fw_ops aq_fw_2x_ops =3D {
 	.get_flow_control   =3D aq_fw2x_get_flow_control,
 	.send_fw_request    =3D aq_fw2x_send_fw_request,
 	.enable_ptp         =3D aq_fw3x_enable_ptp,
+	.led_control        =3D aq_fw2x_led_control,
 };
--=20
2.17.1

