Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9005BF3B9E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfKGWmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:42:07 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7850 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727960AbfKGWmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:42:06 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7MeBXR021780;
        Thu, 7 Nov 2019 14:42:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=MvKs90jpk4ASOQS0JIoZHkpH7KjoBPZc9K2R3Z0vqoM=;
 b=G/1qoaFIED4WZUY0esmd+cOWh2zq2kse3oCmy8LZ8no50orJgjFw5N7dY/LdEmJkrMmY
 fN0+3jaaDOGR8hRQqJ1U3PABP3QEAoS8XqRcW50NedshnZ5NLC5DmflbcAnRqFL1fBov
 K5WZ5f1KwMsp2ohJgOunNr7KifB2JpNUJUP+6uyyBLASYu6pDBiChL/24J9/GmnMWazu
 EZSbxwLxKyXrPxbBic2YRJJ1P3iUMVKwqOyC/s3PLuGGKMT1n9au0sHXgGJArjue/hzY
 LKyi9ws9nsiBgrvJcQalr6sJK2UGmokQSeaQ8rgVW+gSduO4LO1MlwojZzCuABw72dsP pQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2w4fq6u8jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 14:42:04 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 7 Nov
 2019 14:42:03 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 7 Nov 2019 14:42:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rua8DX/dbScYq/KjBI6s89wipgqflf5WQ9HVgbwtHfJ1IJx9ATzmJ3WXFFDRm/jo4aN41otG4OQGXogg6gHREy2E/Y7turYtBfcrw26tkghUhIiwYHW5zZ18u+K/na5LSRzo42rWI1/eT1oeJq5teOY7lx4eTVLxs5mecom1IUFqvjXx2iWkMlDLjLgTJuPz/SZK1S230mBzkXo46hHcKGnUpIsMXJCkD6hYjVqAf925JwO8M/Fkl0VT3riV87z8LjTj2MxUUFRpQ3X0HjM8gkWDddrSBu/aj7/SL7qxq9L3dDRbBmBzHkQSL6VLRJO9pgY46Wh5cEVz1WQNb9b4RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvKs90jpk4ASOQS0JIoZHkpH7KjoBPZc9K2R3Z0vqoM=;
 b=ed4WCfolDx++2/zTvRrYa1Frhtxbk2B1T88m855N5o6dfVIFSdx1ORftrFmbJsOb/ywhmVa2D7bM5gBefzBhwvCRw75lbgl5j93Bhsy3/JCEjb86hM/dnkZLkm//ALrPGPRhHi3mcIQ8580mn/E65WkREOZ0HyowU3ccNEfqM6QqDiWaJGqzxLLENMzey9XFAk1Q49V/Z4jjD7xAkRk9NQr2T3RADKs2aAMPT1SWgczoEUeVGCDwLfgD+xZxtFrQ4ctZOWhLE3pSUHPQJF6uC87NO8JMIlYuEV8mxYeq3k/NbsHe2lr52nUCB2ANUIhSkIW0NVyJ9r8BYEMNKS2TZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvKs90jpk4ASOQS0JIoZHkpH7KjoBPZc9K2R3Z0vqoM=;
 b=rxGhInn2HRR6gUVn7Q00mE/dqFVwSpwzPYutAsNwXsC6XmULGrRNqI2L1WIQDKGWFz9LEhueq4yRs+pzbNT+kzviQSxy4PW1vodCsRXADOkjKNdkP7Vh9m8fM1/ysPZv3ETuPb2pXyyI5qF+mytJmGQ204G8Huq+xWUQTbMN6OA=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB2295.namprd18.prod.outlook.com (52.132.142.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 22:42:02 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:42:02 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH v2 net-next 09/12] net: atlantic: stylistic renames
Thread-Topic: [PATCH v2 net-next 09/12] net: atlantic: stylistic renames
Thread-Index: AQHVlbySM+sKIm6zUkyNNe5YhVHupQ==
Date:   Thu, 7 Nov 2019 22:42:02 +0000
Message-ID: <e0f0a58265d303136dae45439f7f1457665bd7be.1573158382.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: 53b12c51-dc58-4eee-a901-08d763d3b4da
x-ms-traffictypediagnostic: DM5PR18MB2295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB2295D23EDE63094743D648B5B7780@DM5PR18MB2295.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(64756008)(76176011)(7736002)(99286004)(316002)(66066001)(54906003)(2351001)(52116002)(5640700003)(2501003)(8676002)(25786009)(118296001)(8936002)(305945005)(81166006)(81156014)(1730700003)(6486002)(478600001)(71200400001)(71190400001)(6436002)(50226002)(6916009)(66476007)(6116002)(6512007)(14454004)(2616005)(476003)(256004)(486006)(186003)(3846002)(102836004)(11346002)(107886003)(36756003)(66946007)(26005)(2906002)(66446008)(86362001)(66556008)(4326008)(386003)(6506007)(5660300002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB2295;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: igkpRCdq8Zf9IC3azOuZ9HHYXBeQ053CtCSIMeymBV96pKO1KiJD+Z5CUej8poQAqzwZ9z6iepjjgw4oEVCZkG15VJKoMqE3sjSZz5bjSyUYGyl7cirkKbemjaVjSiYWh60GjnRvlDhNhM3yJ+tqyO01uj4RrqXPnS6uYiqeW2f0h/W6QvoDeA1X2g6769c4x40pJxKOX8iDIDi01tVQrBslufGwQ6MUrBSIyDWpT50H1iCy0Y6TALVI06hZg+hvJVu8wYYglgIfIvxSf68deiBBT6qp0Ghin7WFMfFfSTM66XSyo4Yfj1jeE0qD9j9BuVVB4FQVvgsAdKrfdz8EstYJLWbxFEqr5+i1F1KXRCJ3SnWS7mZTebsZhqpjOEHQibGtpJn+ZJeDKv6b9VXu1fyf/96WIFReyjmBZNaaBRqJhhvaBWgJ+BFx5sIbLkYR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b12c51-dc58-4eee-a901-08d763d3b4da
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:42:02.2911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HDzoenpDXgGluP02INpQj1LJQEoC/ANTmgD2znwxl9w9BZaJl/NZGOYFTax7mjl6J/I0A6ZaTNkDByXHjiqLXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2295
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are trying to follow the naming of the chip (atlantic), not
company. So replace some old namings.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c           | 6 +++---
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h  | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_ptp.c
index bb6fbbadfd47..f00663e89cc5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -1055,7 +1055,7 @@ static struct ptp_clock_info aq_ptp_clock =3D {
 		ptp_offset[__idx].ingress =3D (__ingress); } \
 		while (0)
=20
-static void aq_ptp_offset_init_from_fw(const struct hw_aq_ptp_offset *offs=
ets)
+static void aq_ptp_offset_init_from_fw(const struct hw_atl_ptp_offset *off=
sets)
 {
 	int i;
=20
@@ -1096,7 +1096,7 @@ static void aq_ptp_offset_init_from_fw(const struct h=
w_aq_ptp_offset *offsets)
 	}
 }
=20
-static void aq_ptp_offset_init(const struct hw_aq_ptp_offset *offsets)
+static void aq_ptp_offset_init(const struct hw_atl_ptp_offset *offsets)
 {
 	memset(ptp_offset, 0, sizeof(ptp_offset));
=20
@@ -1104,7 +1104,7 @@ static void aq_ptp_offset_init(const struct hw_aq_ptp=
_offset *offsets)
 }
=20
 static void aq_ptp_gpio_init(struct ptp_clock_info *info,
-			     struct hw_aq_info *hw_info)
+			     struct hw_atl_info *hw_info)
 {
 	struct ptp_pin_desc pin_desc[MAX_PTP_GPIO_COUNT];
 	u32 extts_pin_cnt =3D 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
index 68fe17ec171d..42f0c5c6ec2d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
@@ -113,7 +113,7 @@ struct __packed hw_atl_utils_mbox_header {
 	u32 error;
 };
=20
-struct __packed hw_aq_ptp_offset {
+struct __packed hw_atl_ptp_offset {
 	u16 ingress_100;
 	u16 egress_100;
 	u16 ingress_1000;
@@ -148,14 +148,14 @@ enum gpio_pin_function {
 	GPIO_PIN_FUNCTION_SIZE
 };
=20
-struct __packed hw_aq_info {
+struct __packed hw_atl_info {
 	u8 reserved[6];
 	u16 phy_fault_code;
 	u16 phy_temperature;
 	u8 cable_len;
 	u8 reserved1;
 	struct hw_atl_cable_diag cable_diag_data[4];
-	struct hw_aq_ptp_offset ptp_offset;
+	struct hw_atl_ptp_offset ptp_offset;
 	u8 reserved2[12];
 	u32 caps_lo;
 	u32 caps_hi;
@@ -177,7 +177,7 @@ struct __packed hw_aq_info {
 struct __packed hw_atl_utils_mbox {
 	struct hw_atl_utils_mbox_header header;
 	struct hw_atl_stats_s stats;
-	struct hw_aq_info info;
+	struct hw_atl_info info;
 };
=20
 struct __packed offload_ip_info {
--=20
2.17.1

