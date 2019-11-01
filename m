Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E598BEC292
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbfKAMRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:32 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54288 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730571AbfKAMRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1CAxZ8001205;
        Fri, 1 Nov 2019 05:17:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=0BC7duN8h8R16XCg6R3SEis71oNHHLcPE4UHnPijPfE=;
 b=uk5i5mbRkLsKId6ce/DNXPVd4V4TJu5aLKFZF4lTfHtFO4A6VWbSSEnPJfuHZ0jnGjxW
 HrmxePItC0Ndc4ZjKU66Q9vTNvK7TGKt7YN0ekf8xv+ZM91H51fEbxaar2oaqJne4rar
 nZacZmyc/RA7rtkALGIMaVYUO6yi7MS0kM8dpTOVPbPZKV1+S8CNlVo7W7fD/EOegJ/2
 oCS11BShy8ANHfeql1lCYSPrwlUgGvHAANzPkCRlB/ECY34RyA4cVc3tltUDxIHtbheC
 YRe26jDZosP7jiBtKdq3adRurn6BDTSM9dIJ1y65prvrQ1zosKbk8Hw7uyVtSMWiwNrL RA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vxwjmbtkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Nov 2019 05:17:28 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 1 Nov
 2019 05:17:27 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 1 Nov 2019 05:17:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DItMjr9NSWAImmUpOMUzl6pK3EDcXFXte6t68YXgBINK5V6lRR6xPimHpbvxqTMcW4lVLsKwJAqyr27jz3KiB0AB6JkvhNuIgSWFN5TjVMhVVNPZcPyvd0/jB7HiDudt+UgnemGMIurzZikeZkX0hBFHZkQHBa0KrKUWImPLpaC42o6N6cKV0VMSzNjGp9d/0JEai5g1q3CKSgW/+vr8mk+b6PTxu+sB5hqaffvODJJFCTRCgRFA1HYpFMs19+26ZiSxbx5tMu4e/bNboM95OuPYzRmVBGXLkar6jBMZEAjWdHxF6yBG65NG8sTD0tw+uX15p6QMxS1MMCkpfuduYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BC7duN8h8R16XCg6R3SEis71oNHHLcPE4UHnPijPfE=;
 b=aslS4kcP4NFd7yGnuNXSUo5gChxJ1dsNY0beHPY1Pd/hEWPtxeBgdhb94dxi4e7+5bvknDoB66Gg6gOB5hB8efxWLAR8yGaFpHbaaPtF/+bDoQf+C/JETXHMkOlrP/+YE0/r24nZqbPGXKutvJjkQm1ytsuZZ5rN6yqt42nOfgU/X5kpTplOEnia3PMkz9CKQ2FHHPKxYfM3To5DLdo706LLvnlfrYv9i/3MX139LEoSqBNnuU3QLx1C+pzkW0nLCWxs5FkZ9SeYMuZZsOg9siRg6V6QLrHIAj1e67an7F32ASQZiwYH7e+lyLH7f46+iqbChaIb1SopZU0wYmm6Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BC7duN8h8R16XCg6R3SEis71oNHHLcPE4UHnPijPfE=;
 b=IXcgq4J0x6IxhzF2TxzjpTRoS+FuZuHaBxuMaiNCxh9qt0KZtXeJBkp4blFqxP4qizk9gj6UXbbdNWj6l3LHQeq1n1qQdMR+2ITOyo+jBeEmCH4KVwegMyedTeEm1Lpn8JLMDnlq8O11guA1jGigA0EwAqdMSwqcgqU4iigbEJw=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2306.namprd18.prod.outlook.com (52.132.30.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 12:17:20 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 12:17:20 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH net-next 06/12] net: atlantic: add fw configuration memory
 area
Thread-Topic: [PATCH net-next 06/12] net: atlantic: add fw configuration
 memory area
Thread-Index: AQHVkK5PK4uuzuenIkOM8ag2jAJ0hQ==
Date:   Fri, 1 Nov 2019 12:17:20 +0000
Message-ID: <e8e82fcaf94b377d6429926ef17b2e38a49b4c07.1572610156.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: 68c317d1-4ca3-4e08-4098-08d75ec57190
x-ms-traffictypediagnostic: BL0PR18MB2306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB2306FFD4188D2F00AF0B1C93B7620@BL0PR18MB2306.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:313;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(81156014)(186003)(25786009)(102836004)(14444005)(52116002)(6916009)(256004)(76176011)(6506007)(66066001)(36756003)(386003)(66556008)(66476007)(2351001)(66446008)(486006)(26005)(64756008)(476003)(66946007)(2501003)(478600001)(99286004)(3846002)(11346002)(5660300002)(71200400001)(107886003)(71190400001)(50226002)(2906002)(8936002)(86362001)(118296001)(2616005)(81166006)(316002)(446003)(6486002)(54906003)(7736002)(6116002)(14454004)(305945005)(6512007)(8676002)(6436002)(5640700003)(1730700003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2306;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: We7EvKso8lm3MKLW358UTr5e4rCp4xZoQCwzdumgMHiDz7Z6vZ+juvJqNy7XE7wKVwS+Oin5GAXzY2FKM29IqZAfFDMScjJMrlSA7E2dqJZ2bC+yDf3o9gGGYPYganSbn3dy0/0mZvK3r0fnkLtQWivGOZjyNmCVQpc5voDYpa+zCTUnKXITI1VyTr8tzzT7AnRvQBqRJMBB9Vqv5DRSSGCru5Aen8QExc0ZqeRZcvPf9g5Oz6F/d4oX0wMC9EpJMTSzF7OEcgEarkQ8dsI0xY/lihsLmyOAysrekpEhVywrCBREpPFTx/6BN1sJf1XLtVp+WbcaKEnBUG9dVdhghGp4TYmSt1TfsY8Ns5Uu+WToTD32NNvosquHTE/XrhISMugL7Zld+LmLNjf6H2Du011XmHnMVtdty+fVPb1g5jz6JqwE7MrB9/pFdVSy2c4U
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c317d1-4ca3-4e08-4098-08d75ec57190
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 12:17:20.5560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7N21+iH+qsN6+Io3tdJCGPViWWncXOsWyzLTI2LfTMG7AeniFGNQ09kTG+Dkz4Ocw8LH7KsWFq5ZYVQRa3JDpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2306
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_04:2019-10-30,2019-11-01 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

Device FW has a separate memory area where various
config fields are stored and could be used by the
driver.

Here we modify download/upload infrastructure to
allow accessing this area.

Lateron this will be used to configure various behaviours

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |   1 +
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   | 129 +++++++++++++-----
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  47 ++++++-
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       |  19 ++-
 4 files changed, 159 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/e=
thernet/aquantia/atlantic/aq_hw.h
index c2725a58f050..57396e516939 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -140,6 +140,7 @@ struct aq_hw_s {
 	atomic_t dpc;
 	u32 mbox_addr;
 	u32 rpc_addr;
+	u32 settings_addr;
 	u32 rpc_tid;
 	struct hw_atl_utils_fw_rpc rpc;
 	s64 ptp_clk_offset;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index fc82ede18b20..db8c09c5a768 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -47,6 +47,11 @@
=20
 #define FORCE_FLASHLESS 0
=20
+enum mcp_area {
+	MCP_AREA_CONFIG =3D 0x80000000,
+	MCP_AREA_SETTINGS =3D 0x20000000,
+};
+
 static int hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual);
=20
 static int hw_atl_utils_mpi_set_state(struct aq_hw_s *self,
@@ -327,10 +332,75 @@ int hw_atl_utils_fw_downld_dwords(struct aq_hw_s *sel=
f, u32 a,
 	return err;
 }
=20
-int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 a, u32 *p, u32=
 cnt)
+static int hw_atl_utils_write_b1_mbox(struct aq_hw_s *self, u32 addr,
+				      u32 *p, u32 cnt, enum mcp_area area)
+{
+	u32 data_offset =3D 0;
+	u32 offset =3D addr;
+	int err =3D 0;
+	u32 val;
+
+	switch (area) {
+	case MCP_AREA_CONFIG:
+		offset -=3D self->rpc_addr;
+		break;
+
+	case MCP_AREA_SETTINGS:
+		offset -=3D self->settings_addr;
+		break;
+	}
+
+	offset =3D offset / sizeof(u32);
+
+	for (; data_offset < cnt; ++data_offset, ++offset) {
+		aq_hw_write_reg(self, 0x328, p[data_offset]);
+		aq_hw_write_reg(self, 0x32C,
+				(area | (0xFFFF & (offset * 4))));
+		hw_atl_mcp_up_force_intr_set(self, 1);
+		/* 1000 times by 10us =3D 10ms */
+		err =3D readx_poll_timeout_atomic(hw_atl_scrpad12_get,
+						self, val,
+						(val & 0xF0000000) !=3D
+						area,
+						10U, 10000U);
+
+		if (err < 0)
+			break;
+	}
+
+	return err;
+}
+
+static int hw_atl_utils_write_b0_mbox(struct aq_hw_s *self, u32 addr,
+				      u32 *p, u32 cnt)
 {
+	u32 offset =3D 0;
+	int err =3D 0;
 	u32 val;
+
+	aq_hw_write_reg(self, 0x208, addr);
+
+	for (; offset < cnt; ++offset) {
+		aq_hw_write_reg(self, 0x20C, p[offset]);
+		aq_hw_write_reg(self, 0x200, 0xC000);
+
+		err =3D readx_poll_timeout_atomic(hw_atl_utils_mif_cmd_get,
+						self, val,
+						(val & 0x100) =3D=3D 0U,
+						10U, 10000U);
+
+		if (err < 0)
+			break;
+	}
+
+	return err;
+}
+
+static int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 addr, u=
32 *p,
+					 u32 cnt, enum mcp_area area)
+{
 	int err =3D 0;
+	u32 val;
=20
 	err =3D readx_poll_timeout_atomic(hw_atl_sem_ram_get, self,
 					val, val =3D=3D 1U,
@@ -338,43 +408,35 @@ int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *sel=
f, u32 a, u32 *p, u32 cnt)
 	if (err < 0)
 		goto err_exit;
=20
-	if (IS_CHIP_FEATURE(REVISION_B1)) {
-		u32 offset =3D 0;
-
-		for (; offset < cnt; ++offset) {
-			aq_hw_write_reg(self, 0x328, p[offset]);
-			aq_hw_write_reg(self, 0x32C,
-					(0x80000000 | (0xFFFF & (offset * 4))));
-			hw_atl_mcp_up_force_intr_set(self, 1);
-			/* 1000 times by 10us =3D 10ms */
-			err =3D readx_poll_timeout_atomic(hw_atl_scrpad12_get,
-							self, val,
-							(val & 0xF0000000) !=3D
-							0x80000000,
-							10U, 10000U);
-		}
-	} else {
-		u32 offset =3D 0;
-
-		aq_hw_write_reg(self, 0x208, a);
+	if (IS_CHIP_FEATURE(REVISION_B1))
+		err =3D hw_atl_utils_write_b1_mbox(self, addr, p, cnt, area);
+	else
+		err =3D hw_atl_utils_write_b0_mbox(self, addr, p, cnt);
=20
-		for (; offset < cnt; ++offset) {
-			aq_hw_write_reg(self, 0x20C, p[offset]);
-			aq_hw_write_reg(self, 0x200, 0xC000);
+	hw_atl_reg_glb_cpu_sem_set(self, 1U, HW_ATL_FW_SM_RAM);
=20
-			err =3D readx_poll_timeout_atomic(hw_atl_utils_mif_cmd_get,
-							self, val,
-							(val & 0x100) =3D=3D 0,
-							1000U, 10000U);
-		}
-	}
+	if (err < 0)
+		goto err_exit;
=20
-	hw_atl_reg_glb_cpu_sem_set(self, 1U, HW_ATL_FW_SM_RAM);
+	err =3D aq_hw_err_from_flags(self);
=20
 err_exit:
 	return err;
 }
=20
+int hw_atl_write_fwcfg_dwords(struct aq_hw_s *self, u32 *p, u32 cnt)
+{
+	return hw_atl_utils_fw_upload_dwords(self, self->rpc_addr, p,
+					     cnt, MCP_AREA_CONFIG);
+}
+
+int hw_atl_write_fwsettings_dwords(struct aq_hw_s *self, u32 offset, u32 *=
p,
+				   u32 cnt)
+{
+	return hw_atl_utils_fw_upload_dwords(self, self->settings_addr + offset,
+					     p, cnt, MCP_AREA_SETTINGS);
+}
+
 static int hw_atl_utils_ver_match(u32 ver_expected, u32 ver_actual)
 {
 	int err =3D 0;
@@ -437,10 +499,9 @@ int hw_atl_utils_fw_rpc_call(struct aq_hw_s *self, uns=
igned int rpc_size)
 		err =3D -1;
 		goto err_exit;
 	}
-	err =3D hw_atl_utils_fw_upload_dwords(self, self->rpc_addr,
-					    (u32 *)(void *)&self->rpc,
-					    (rpc_size + sizeof(u32) -
-					     sizeof(u8)) / sizeof(u32));
+	err =3D hw_atl_write_fwcfg_dwords(self, (u32 *)(void *)&self->rpc,
+					(rpc_size + sizeof(u32) -
+					 sizeof(u8)) / sizeof(u32));
 	if (err < 0)
 		goto err_exit;
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index c6708f0d5d3e..68fe17ec171d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -277,6 +277,48 @@ struct __packed hw_fw_request_iface {
 	};
 };
=20
+struct __packed hw_atl_utils_settings {
+	u32 mtu;
+	u32 downshift_retry_count;
+	u32 link_pause_frame_quanta_100m;
+	u32 link_pause_frame_threshold_100m;
+	u32 link_pause_frame_quanta_1g;
+	u32 link_pause_frame_threshold_1g;
+	u32 link_pause_frame_quanta_2p5g;
+	u32 link_pause_frame_threshold_2p5g;
+	u32 link_pause_frame_quanta_5g;
+	u32 link_pause_frame_threshold_5g;
+	u32 link_pause_frame_quanta_10g;
+	u32 link_pause_frame_threshold_10g;
+	u32 pfc_quanta_class_0;
+	u32 pfc_threshold_class_0;
+	u32 pfc_quanta_class_1;
+	u32 pfc_threshold_class_1;
+	u32 pfc_quanta_class_2;
+	u32 pfc_threshold_class_2;
+	u32 pfc_quanta_class_3;
+	u32 pfc_threshold_class_3;
+	u32 pfc_quanta_class_4;
+	u32 pfc_threshold_class_4;
+	u32 pfc_quanta_class_5;
+	u32 pfc_threshold_class_5;
+	u32 pfc_quanta_class_6;
+	u32 pfc_threshold_class_6;
+	u32 pfc_quanta_class_7;
+	u32 pfc_threshold_class_7;
+	u32 eee_link_down_timeout;
+	u32 eee_link_up_timeout;
+	u32 eee_max_link_drops;
+	u32 eee_rates_mask;
+	u32 wake_timer;
+	u32 thermal_shutdown_off_temp;
+	u32 thermal_shutdown_warning_temp;
+	u32 thermal_shutdown_cold_temp;
+	u32 msm_options;
+	u32 dac_cable_serdes_modes;
+	u32 media_detect;
+};
+
 enum hw_atl_rx_action_with_traffic {
 	HW_ATL_RX_DISCARD,
 	HW_ATL_RX_HOST,
@@ -554,7 +596,10 @@ struct aq_stats_s *hw_atl_utils_get_hw_stats(struct aq=
_hw_s *self);
 int hw_atl_utils_fw_downld_dwords(struct aq_hw_s *self, u32 a,
 				  u32 *p, u32 cnt);
=20
-int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 a, u32 *p, u32=
 cnt);
+int hw_atl_write_fwcfg_dwords(struct aq_hw_s *self, u32 *p, u32 cnt);
+
+int hw_atl_write_fwsettings_dwords(struct aq_hw_s *self, u32 offset, u32 *=
p,
+				   u32 cnt);
=20
 int hw_atl_utils_fw_set_wol(struct aq_hw_s *self, bool wol_enabled, u8 *ma=
c);
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2=
x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 4eab51b5b400..3dbce03c5a94 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -78,6 +78,7 @@ static int aq_fw2x_set_state(struct aq_hw_s *self,
=20
 static u32 aq_fw2x_mbox_get(struct aq_hw_s *self);
 static u32 aq_fw2x_rpc_get(struct aq_hw_s *self);
+static int aq_fw2x_settings_get(struct aq_hw_s *self, u32 *addr);
 static u32 aq_fw2x_state2_get(struct aq_hw_s *self);
=20
 static int aq_fw2x_init(struct aq_hw_s *self)
@@ -95,6 +96,8 @@ static int aq_fw2x_init(struct aq_hw_s *self)
 					self->rpc_addr !=3D 0U,
 					1000U, 100000U);
=20
+	err =3D aq_fw2x_settings_get(self, &self->settings_addr);
+
 	return err;
 }
=20
@@ -418,8 +421,7 @@ static int aq_fw2x_send_fw_request(struct aq_hw_s *self=
,
 	dword_cnt =3D size / sizeof(u32);
 	if (size % sizeof(u32))
 		dword_cnt++;
-	err =3D hw_atl_utils_fw_upload_dwords(self, aq_fw2x_rpc_get(self),
-					    (void *)fw_req, dword_cnt);
+	err =3D hw_atl_write_fwcfg_dwords(self, (void *)fw_req, dword_cnt);
 	if (err < 0)
 		goto err_exit;
=20
@@ -547,6 +549,19 @@ static u32 aq_fw2x_rpc_get(struct aq_hw_s *self)
 	return aq_hw_read_reg(self, HW_ATL_FW2X_MPI_RPC_ADDR);
 }
=20
+static int aq_fw2x_settings_get(struct aq_hw_s *self, u32 *addr)
+{
+	int err =3D 0;
+	u32 offset;
+
+	offset =3D self->mbox_addr + offsetof(struct hw_atl_utils_mbox,
+					    info.setting_address);
+
+	err =3D hw_atl_utils_fw_downld_dwords(self, offset, addr, 1);
+
+	return err;
+}
+
 static u32 aq_fw2x_state2_get(struct aq_hw_s *self)
 {
 	return aq_hw_read_reg(self, HW_ATL_FW2X_MPI_STATE2_ADDR);
--=20
2.17.1

