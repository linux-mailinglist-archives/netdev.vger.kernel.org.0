Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2762EC294
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbfKAMRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:37 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18780 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730584AbfKAMRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:36 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1C9YVD018587;
        Fri, 1 Nov 2019 05:17:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=MvKs90jpk4ASOQS0JIoZHkpH7KjoBPZc9K2R3Z0vqoM=;
 b=R/wfqmx1xEeV67AcXrdReKkgcnx928FnP4kkXrOeDzWSHtNB8KnBU42A3LClHvRGcK4s
 1oipKakprJiAstIns5GAY4aGe05ArqNVJkxq30Wzek/WjKtU+K6y68gnWW3HQ/2TttHQ
 qHTak/6E9jEYnaUscqXTlrCw/ESHQJg60MHp2RxrsiJqr2ctRNKsZ/0SWiRnc4n+hbrD
 Xl9ec3CUBB+D4iemhBQtjkT3d8kZAk1yX0vCTB3uNBKXoyGWazfhD3/ubwGbFte1vrTI
 /zqp2sTjCrV0cNNttoJldLQV015WqmyX5nQSqPsFUV8wwvn45ZVY0jjVpgLqX/Vhzxf4 ZA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2vyxhy4qbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Nov 2019 05:17:33 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 1 Nov
 2019 05:17:32 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 1 Nov 2019 05:17:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZP90o2+smcDYC1tGhCwkz73atl7WegrOp+BTOuoU1WZMI7xtWU9RqhCs7OBnjGHJs7fKauYpLsHQ7SEuwmxp17F6w6DntDM1yj3+vpBMz4s+Q9og0ynEKoIhhAy/jAsW+jtDxjKFDVME3ySj82V8o+kxjCqqQC0slzPQop4lLx0RCvwgbiTthh7m4JCm5o4sF/AUzwbIRjSQ3PmkS1ppMe81P2Eq7NhN1a28w8vUhN7Q6ks3AcalAfL5rIRhX6exTl2jDaxvJ+pjkn69xkQ/cHTtWJlOJB4k8E8jOi0xwjWZjL3DRprQDTgQUXxpP8qXiXRmUgsqmINM45f+mwMGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvKs90jpk4ASOQS0JIoZHkpH7KjoBPZc9K2R3Z0vqoM=;
 b=bVCDcXXWxd3WthwQ6oErDH3rMZ+X4qOUJi5CZKyOogPVto8eqvq5T/WCRGZTB7HqSjvX076d268ZOLQ1MLTO3ZYRo8I/HA8C71jCgGOj0kOC2LXWU0A/Q6/4SGO6xXGcArN4Xg29bnGpGq9uaZC8r4CZfX/G5DjY6W2tKcE+vmR8TplMpvQRkTiC9oJnmEwnDKm5rXuFh7+UwEqTztxCiglsRWAOjbTS6d5SDlTE3DYHK6wHeiQdY/zIm+7QS1e9XAprr1NP5HKb2O/vXf/u1a46/W9oP0/NcFYO7G622TtPJ9gpE+LrqQwI9r09MwZpI8bCx6WmaECNFwqBoW8rZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvKs90jpk4ASOQS0JIoZHkpH7KjoBPZc9K2R3Z0vqoM=;
 b=BhGOUe1XMq1pW7aKN4Tdqe1/eVKXlZTetrR7N5zQzUUVkCo3Dqi79RO1gehJKEqJH3PZbaeOgE9zbFJwpkAhgoZDQydtK36hQe9OZb7xFEnFDKBUsn/cwjxRbABmN4TZjgMTd8YfwCGwxK9q0cWrwHCW9kjlO7ef8ZVFrShuAJk=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2306.namprd18.prod.outlook.com (52.132.30.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 12:17:24 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 12:17:24 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH net-next 09/12] net: atlantic: stylistic renames
Thread-Topic: [PATCH net-next 09/12] net: atlantic: stylistic renames
Thread-Index: AQHVkK5RiUyk6gDAuUOAhVF3w2TVZw==
Date:   Fri, 1 Nov 2019 12:17:24 +0000
Message-ID: <767fad515c151e1eb06157de08ac58cbb80efe07.1572610156.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: 7c753447-65c0-41f4-042b-08d75ec573f3
x-ms-traffictypediagnostic: BL0PR18MB2306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB2306463C6DA175814E99D00EB7620@BL0PR18MB2306.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(81156014)(186003)(25786009)(102836004)(52116002)(6916009)(256004)(76176011)(6506007)(66066001)(36756003)(386003)(66556008)(66476007)(2351001)(66446008)(486006)(26005)(64756008)(476003)(66946007)(2501003)(478600001)(99286004)(3846002)(11346002)(5660300002)(71200400001)(107886003)(71190400001)(50226002)(2906002)(8936002)(86362001)(118296001)(2616005)(81166006)(316002)(446003)(6486002)(54906003)(7736002)(6116002)(14454004)(305945005)(6512007)(8676002)(6436002)(5640700003)(1730700003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2306;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P8obRxot9pnQGFEnFV1AJWCSbKC9tgII/WobSa4ACZJ68cKsMluRhqYvADe/FkcZ26PqFVtIu1zpm7sMSHtFQjDpvH3cJPlGcf5enwu6VDszEDH4BUnMKnK2XVoOH445MgDttTlx6mpJBSVKjbZaZSfGrCAUPU2IdX/uq0qnIdhFqmsGwBoFxcuUqgUDYAIFxT2d/YpeL13eszKpP8E7JpTNw8SWYyFjhNH+uxQ5cNe9FUk3gVw7zr1hJKL4R4TBu3M0SOGTgPTyc8qZOml0kWQNiqLs+D6DM/yj51yNVCDqatUekklDQ6j0Ulto2j9BMpSevwjZ3ssHQadBRo+Hy6mdqIrECbv3Avj7hMvDNdG2gdo8GDYEPK73YRmE9nh6iC9xfd3T3+0P5hsTZYqLIhyF2UGyRsQB6SNS3JDthPZtwlADx47xZ3HN2rBjLfSH
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c753447-65c0-41f4-042b-08d75ec573f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 12:17:24.5397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 87KCdQ4f3cxPn9ZU39nUJ6/Wmgq9YWHLeZ6MlIcGZX+O0KgQL6yknPwc2Mhob7WndjwxXmUwNCjxaBIyDpVgDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2306
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_04:2019-10-30,2019-11-01 signatures=0
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

