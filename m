Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C64947A808
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 11:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhLTK5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 05:57:12 -0500
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:27076
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229782AbhLTK5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 05:57:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YvU2BJHUjYTn5rldvHPUl568uwlSmgkXgKRDdfVbSUFqC2/F3EmUBXmdAPMWdgeDMwk1ifprX0mB3s3BfJj6aJZrl23baH4bAqedoUtu0/dNIIpmjJGeYI67qojDo1P107K0v7vTzwOjMdtm1c7ugo92eJy2OO45RVqfiOL4p3KI5XaO874q7QGt20cGNdfvC8KWKLwcXx/J78sdn1Z542671uExs7EQaTw7+21sgEUbwDjtYDFZDYZSwEh845TUUCCgwmcSXPBYMfR5tj1l54mJ6LtSvFZoyDosOdcYCr+IbS9f4LElMFo+ArmgSMmgBY6Z3NLTpDkPOu/wACphSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VlRA0w4qsJrsUDCDrqwdXo16z7eX5FWGm1IJldVbW2U=;
 b=Ig5EUq/15xmzP79AYFyg5mRB1x5cbgCPCuIla3gswgjyvGFlflatWaa0PVOc38B5k2Nfqj51DcTivyfSzCTQh9dCo/zDd8Z6jjwy34X7IYS43tgSaRVtlOE9WDGhUbvKGrHT5TT65h42UrcdcTCYbk/9RVl8m7T3/qymW89uIYv6oq8Ajq+v5+AIJUbaUbhhWQd0QB9vLW8ogL+uVttqvxzvCpg4gJOmU9LGYsGKAkdYTGKRML/v/iwPtfzWyBnnNLUknkFLCTTjwz3lOW9M20QSm41WCwPU03C8jkWUI+rvCFz4xxXG2j7hw4ZYmtApjkxMrcJsaXP/X6NzM9qmuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VlRA0w4qsJrsUDCDrqwdXo16z7eX5FWGm1IJldVbW2U=;
 b=otA5fCC3zlEoy5w7mgCm0lsGFAgcaLFitFUiw2ySHK/IHhxehHTgTL00pwLjWrp8bD6tzuEqxTy5AEGdtjUOxofQlVEvnB6tY/+U3s0ZV5dVyRehxdfIQqREDFO/QmrlMMIQFLLZMGx/EobV+RrN2JaVxnE251oJH2ARMQ/oSIJR/Y3pkWmNP53JreHd41rjn7ztLBjj/QqgK7q9JgArreSIBuBB+JwtGRSVoQ2LqxHRsxvrKkHeoJ+EjMjTZKnwM+GmrH1ZbWAG3VwDL5LbwJu6UKGBhqadPrTi3fSbk6BeRK/nieCqzlgJ8ESuSBAuBZtzOW8JGwXbg2RCh+KuEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB4760.namprd12.prod.outlook.com (2603:10b6:a03:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Mon, 20 Dec
 2021 10:57:09 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 10:57:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/4] mlxsw: reg: Extend MFDE register with new events and parameters
Date:   Mon, 20 Dec 2021 12:56:13 +0200
Message-Id: <20211220105614.68622-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211220105614.68622-1-idosch@nvidia.com>
References: <20211220105614.68622-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0032.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::19) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa01da16-0c74-42a3-4105-08d9c3a77836
X-MS-TrafficTypeDiagnostic: BYAPR12MB4760:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB47603BAFC80231CA74A03847B27B9@BYAPR12MB4760.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w2bp7EHA1FACOJDWzYTey3xaNnwiiLEwYN1B3bM/09QboucfdqGGfaUL7us/2bv8XXzQspNSxcHdj/UoQoLrH4ih4XCyux5akKlIZWqat3KYAEN+udYCViymB6WVNcqKuAPslOR5rFx5jOniL5We44+RPs8E4YLISg/hXEC2er/F+ecm0bX6uAMoxI5V2gy+w5Icgxw2aPU62o82xBUGd3ON7AOIHSCsVklsThu6/S2pxo0Ya31ojnKqsgnhL/wfQQsTqf/JuU5Uoy6Q2l8YLKZ3fClON2/hpou17FFTtoqro85VN/vCDjL77ETxOCnC4YunvzQeX2gFnM2PQbxaoSEuoG8VDp/uQwepbKZVtXqaGLke4exQ1ZTveSH7HbsvdbRKezd10bgNC6Vh7kI8KIPBOjDJiTfskpoWGZ7aQ5XLXRI7OiTYQgMFXwtcKLtJUr7eYVhXmNMAsna/0sGaVuLk196qY91h36JiZa4FXspMEuvCoqfyhjH4yzJwX+OQXwY+PtwMXgV0VSOBmNAeK7ukvQ66x4CDkeuP/A7JjFy8nTi4gnmGRYRu6yga0wOpLboF8XXYncFjbZS9zwBRLQ5dDhQq5n1RMMkBVWQ4YiLMB7mYte47QZ1tv8vI7NlI1diRKL+3vTJreIG4Qiy19A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(4326008)(8936002)(107886003)(6916009)(66946007)(26005)(316002)(86362001)(38100700002)(66556008)(66476007)(6512007)(2906002)(6666004)(508600001)(8676002)(6486002)(2616005)(83380400001)(6506007)(5660300002)(36756003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r5Y7PmFeqht6VCEivdapj3FykuaF1BQ7d43BTPBwkOBcQRh8NM5BtL/Xx22u?=
 =?us-ascii?Q?yKhC83OCl42KfB26Jr4aQzhcVWhFqSSc5gQejjU2g6/TSQNEsMv1FT3yeD4C?=
 =?us-ascii?Q?HiZJX/Z46jYkxJDlMJw4dzi3Stv3NATyBLuSJBRwi68X+6x0U7YlueDv9W6r?=
 =?us-ascii?Q?wIKHfqms6+iG9RPWTxWiOOlRK7wyZ1VNRTSyC24qBFB442qHr4IhGCkAvmIk?=
 =?us-ascii?Q?hU0QF8prep8L5UxAwYvl913WUa9u0tZZS4XQIcAbRtu1b1Mds8zHq7zCa2bF?=
 =?us-ascii?Q?aPLv7WqWzTNQ5uvc9Kn2NHkxQBLagm1IlXQUaZnSQqXO7OHprSV9y83nQgvl?=
 =?us-ascii?Q?c6Ijh3ehJAZAHleHfHEqTjoq63OWbH/h5Geymhxwz7Jc/4uQESR3GgkKnBAW?=
 =?us-ascii?Q?YKQysW1g13zZ0Ks4MMbB1HsbsE3RPgsnAsz/UdmnGd/YIIkLZJOEPK2Mwa5x?=
 =?us-ascii?Q?zN90Pt3Q5o4c7+3JNZ1xkiwDddLxyomu71jK9dgA6cxPh/ubQhzUkOlZO6Y3?=
 =?us-ascii?Q?CCswjicWYf0Xa60rCI5/+nnDjWXRc2o5trzklBxYIwWwl0pFfQ0QDTwj5GcE?=
 =?us-ascii?Q?FFKIgHIZPJGzMxueLzz+XA/QwycWU7wHxVSe4lRATJ/7KACA1S9VkEF6KTDK?=
 =?us-ascii?Q?MeT53PmWoWvFUKBlGlwwGlQLR5VrXrqG1v1NJodsNFXcU4ozyy3nks/EdH13?=
 =?us-ascii?Q?QAOUOcee3cji6btg2R5JxfbHllH8Jd6UglAe44nevDIDpjqL87R9151eEclo?=
 =?us-ascii?Q?mhP1LNrI8wUTDgSCATFN7p2mld69tHswRQJfxHQRLAWkoh67NQE4xKmB1pfT?=
 =?us-ascii?Q?fA85rHtBH35uhDFOMHjei0uLJ51M1WGaWZK2ddrYDEXKCXRXpmrVELN2ceGK?=
 =?us-ascii?Q?CLH54Aw0NIEDeeq/3jNg+7NSiNg7yZtY/LgsHz2py5NLNVbyRU8B7P9TcxHb?=
 =?us-ascii?Q?oMdV1L68amgeLJSlEmBzd7a7kWNOTFSd2PbYa39xXKRpDohdJ7PELyutNM5Z?=
 =?us-ascii?Q?TNoNgjR02tZ1yZP3GnGhCQYX6BXuktSR3GERHNyhpuBQ1peGLGxY45uWaXMg?=
 =?us-ascii?Q?x085uaX1vUQHLrUFxP9TwLpDruT2xJuXlXkE5GGsGEmrwGLI5o/cdvnoUv9d?=
 =?us-ascii?Q?AaCHlXKrQXgtqDaU06hVXXrrMRRuhXWaJp3ImEU/LURX8tXjL2Exjskr6wOH?=
 =?us-ascii?Q?Uj3doAs2AG7PtSPkyWaH5J5iy7jBqxHLBzsasFTerr565tJ77dh5ZLBpyfBR?=
 =?us-ascii?Q?I+/NbR2fL1wHp+SJkQVzE1FBt71rrqYVhONRgtlCl3a8f3/hsq+ECFShY2Ux?=
 =?us-ascii?Q?C7joJhZB6nzNqMJObnkJdYiub0BPZBla7guO/X2lOVYEJEbtpDhJcPxewMLq?=
 =?us-ascii?Q?11OYH565Yw40aQqUJURPJ5TgTxgkN3pV8Epg8+Pj3vRaK3L7+2q6ryL12M/1?=
 =?us-ascii?Q?sSvxG9xd5yGVrBkk0qk6vFXQRc0/qivZcPmZC2wM6qV/iM6GjXcJAz/mAc2o?=
 =?us-ascii?Q?f4HqR5kYkiqaYTZhCXShLf7yfgoLeeclkxMaiDHmbv9cWAp0SSACI+hnkP/k?=
 =?us-ascii?Q?ddC8pM3Zrmg/XT+dDzcmA2fQRGWqUEAsRxfuNcin/LeLAZnNOIQyQi/JrwSV?=
 =?us-ascii?Q?Ffr1cpuwV2l+J4+y6E3vu/o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa01da16-0c74-42a3-4105-08d9c3a77836
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 10:57:09.5911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f7g6xqdfvopfdg75hQV1BkxlBynGh87HuBHylrcpWvINpgpvuhdUm70KEY14RjWSVSugHQ5TbkQCB07SAROGPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4760
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Extend the Monitoring Firmware Debug (MFDE) register with new events and
their related parameters. These events will be utilized by
devlink-health in the next patch.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 105 +++++++++++++++++++++-
 1 file changed, 104 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index ed0767cc71c2..c97d2c744725 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11318,7 +11318,7 @@ mlxsw_reg_mgpir_unpack(char *payload, u8 *num_of_devices,
  * -----------------------------------
  */
 #define MLXSW_REG_MFDE_ID 0x9200
-#define MLXSW_REG_MFDE_LEN 0x18
+#define MLXSW_REG_MFDE_LEN 0x30
 
 MLXSW_REG_DEFINE(mfde, MLXSW_REG_MFDE_ID, MLXSW_REG_MFDE_LEN);
 
@@ -11328,10 +11328,32 @@ MLXSW_REG_DEFINE(mfde, MLXSW_REG_MFDE_ID, MLXSW_REG_MFDE_LEN);
  */
 MLXSW_ITEM32(reg, mfde, irisc_id, 0x00, 24, 8);
 
+enum mlxsw_reg_mfde_severity {
+	/* Unrecoverable switch behavior */
+	MLXSW_REG_MFDE_SEVERITY_FATL = 2,
+	/* Unexpected state with possible systemic failure */
+	MLXSW_REG_MFDE_SEVERITY_NRML = 3,
+	/* Unexpected state without systemic failure */
+	MLXSW_REG_MFDE_SEVERITY_INTR = 5,
+};
+
+/* reg_mfde_severity
+ * The severity of the event.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, severity, 0x00, 16, 8);
+
 enum mlxsw_reg_mfde_event_id {
+	/* CRspace timeout */
 	MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO = 1,
 	/* KVD insertion machine stopped */
 	MLXSW_REG_MFDE_EVENT_ID_KVD_IM_STOP,
+	/* Triggered by MFGD.trigger_test */
+	MLXSW_REG_MFDE_EVENT_ID_TEST,
+	/* Triggered when firmware hits an assert */
+	MLXSW_REG_MFDE_EVENT_ID_FW_ASSERT,
+	/* Fatal error interrupt from hardware */
+	MLXSW_REG_MFDE_EVENT_ID_FATAL_CAUSE,
 };
 
 /* reg_mfde_event_id
@@ -11378,6 +11400,13 @@ MLXSW_ITEM32(reg, mfde, reg_attr_id, 0x04, 0, 16);
  */
 MLXSW_ITEM32(reg, mfde, crspace_to_log_address, 0x10, 0, 32);
 
+/* reg_mfde_crspace_to_oe
+ * 0 - New event
+ * 1 - Old event, occurred before MFGD activation.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, crspace_to_oe, 0x14, 24, 1);
+
 /* reg_mfde_crspace_to_log_id
  * Which irisc triggered the timeout.
  * Access: RO
@@ -11390,12 +11419,86 @@ MLXSW_ITEM32(reg, mfde, crspace_to_log_id, 0x14, 0, 4);
  */
 MLXSW_ITEM64(reg, mfde, crspace_to_log_ip, 0x18, 0, 64);
 
+/* reg_mfde_kvd_im_stop_oe
+ * 0 - New event
+ * 1 - Old event, occurred before MFGD activation.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, kvd_im_stop_oe, 0x10, 24, 1);
+
 /* reg_mfde_kvd_im_stop_pipes_mask
  * Bit per kvh pipe.
  * Access: RO
  */
 MLXSW_ITEM32(reg, mfde, kvd_im_stop_pipes_mask, 0x10, 0, 16);
 
+/* reg_mfde_fw_assert_var0-4
+ * Variables passed to assert.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, fw_assert_var0, 0x10, 0, 32);
+MLXSW_ITEM32(reg, mfde, fw_assert_var1, 0x14, 0, 32);
+MLXSW_ITEM32(reg, mfde, fw_assert_var2, 0x18, 0, 32);
+MLXSW_ITEM32(reg, mfde, fw_assert_var3, 0x1C, 0, 32);
+MLXSW_ITEM32(reg, mfde, fw_assert_var4, 0x20, 0, 32);
+
+/* reg_mfde_fw_assert_existptr
+ * The instruction pointer when assert was triggered.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, fw_assert_existptr, 0x24, 0, 32);
+
+/* reg_mfde_fw_assert_callra
+ * The return address after triggering assert.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, fw_assert_callra, 0x28, 0, 32);
+
+/* reg_mfde_fw_assert_oe
+ * 0 - New event
+ * 1 - Old event, occurred before MFGD activation.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, fw_assert_oe, 0x2C, 24, 1);
+
+/* reg_mfde_fw_assert_tile_v
+ * 0: The assert was from main
+ * 1: The assert was from a tile
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, fw_assert_tile_v, 0x2C, 23, 1);
+
+/* reg_mfde_fw_assert_tile_index
+ * When tile_v=1, the tile_index that caused the assert.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, fw_assert_tile_index, 0x2C, 16, 6);
+
+/* reg_mfde_fw_assert_ext_synd
+ * A generated one-to-one identifier which is specific per-assert.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, fw_assert_ext_synd, 0x2C, 0, 16);
+
+/* reg_mfde_fatal_cause_id
+ * HW interrupt cause id.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, fatal_cause_id, 0x10, 0, 18);
+
+/* reg_mfde_fatal_cause_tile_v
+ * 0: The assert was from main
+ * 1: The assert was from a tile
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, fatal_cause_tile_v, 0x14, 23, 1);
+
+/* reg_mfde_fatal_cause_tile_index
+ * When tile_v=1, the tile_index that caused the assert.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mfde, fatal_cause_tile_index, 0x14, 16, 6);
+
 /* TNGCR - Tunneling NVE General Configuration Register
  * ----------------------------------------------------
  * The TNGCR register is used for setting up the NVE Tunneling configuration.
-- 
2.33.1

