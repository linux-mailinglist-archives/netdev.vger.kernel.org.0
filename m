Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABC55509A7
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbiFSKai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiFSKah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:30:37 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745D4CE2D
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:30:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AH61I+4uLRB85uSzZflEW4quuxl/GxsH9WTcvy3YZxNbLNmpWzH+FjShKYVj9HqSoC6Sk6571OFwWvbUTWGPiYBN/resh0037lIb65Buv9ZI0Iilww37EtmqbN3DlIRaAFiH5MRRXUxpFhmajbsTocbQ8uCyFx2MTf2N8KCq8Pxy5ZWvPMYvi4g9L8CvhZnPb5H6szjCx8rLZcUp/XKqIWgQIWLbMSjqXLZqN/PVTYoFKS9BzWj+0jZM9grP/KSEkjBI3D/7LPX8kdc1d1jr/JDepOTdYO3LDvKxizpM3zOdKx2Qksn4YDz9oxPxob6YowZU0dEyRlmoYn7YUjSlkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CypktGHb1wmaxozQSLxtAZ1+oaWhqsNZtJCNuFcCLDg=;
 b=Ak3ExbtgGF66PvCsUL7q0hytTKCwvzP/sZ3ohdShVDJ1MqZfNT1mxzIPj2b86OPLgDUcfKpG5UYR/VKxLp0r6L0vwnQW/SGnDhSfndFQwUxjo8xzfAdpfA7sqJTJ2IgtplZxMt0RF/XTAsXASv7ZezeLwFdVGIvzq8YLqAmchtO9FpKa6ArzR7s5CPF1366T6xG0J0E8LwOtKOIwxfeFoERyMlDM1u44wUi32/hlNxQ2LSoBgP22fchoC8ohQtnZwf0hBxn+TbfM++7kYN0cmsxPgyI/HbeKGRkOcnxHE779uy1CxxZ7W2H7rnS6VQDolsozo/RXArRedVU4QkP+Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CypktGHb1wmaxozQSLxtAZ1+oaWhqsNZtJCNuFcCLDg=;
 b=jekBMUX5D5eNdEx+JqMimJ7fYzxBp63Se5MQAnU+HkQfIg1zUgiIxGPjB1yi55jz1zm73DtYJUv3VIsDXYTmBcbm+hSuxB8P67LHhFQMlGjl9Vjx5XKZUXt0T7zMS4LmFTrQ/54aAYriAPbXOgWku/bWXBKxDYK+2gC2pvwziO30eUQequX3R+hBSNIeZIy6fQnaJ2OLd3Tl2BYzjzgEAXzJ56dyuYiV0UfCqJVQz3sW74zi/sEUyLYj7e0DQ6+JjrtbQNDI1BCEYcbE/r9IcIYvglMK4rb8xDPPCv2B5AO2oTcLIueijyrkncp3jTHUMd7kVUpm+QgfQQ+4l7+wSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.16; Sun, 19 Jun 2022 10:30:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Sun, 19 Jun 2022
 10:30:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/13] mlxsw: reg: Add VID related fields to SFD register
Date:   Sun, 19 Jun 2022 13:29:15 +0300
Message-Id: <20220619102921.33158-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220619102921.33158-1-idosch@nvidia.com>
References: <20220619102921.33158-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0024.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::36) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5315925-c7fd-4b7f-67b6-08da51debe84
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1193FB72188A8D7F0574692FB2B19@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iuer3R8ziNR0b1quP2peSjCUfok0s/m3fiyG4aSDB0sK4MGu4MAu+bwXC5lYglez9J19XIAuYordToPz+2jHqIKM2nSSXlMuSZQTMOkcbStljCmvX9QdosDP/99UPzG9APE4rIxM/mfHVedJvTR9ukk2foO5f3KQe/W8sQB87ijkkEAUYNZiz1lxc0x1/bkbdyBtf/w0u9Ne04ED3ohAt1p3Ab8h2PrOESTJo11tXaw1HyGYrrdn4+Pmdodo8JhK1SNeXsdHfCfY3ogTTG9QUQQ5t9pMtdu4G88Evda0vE6HXpextq+dynISDsBAqF358lZ8VpaLujCSdWdhntg4FV4wU6JEM1oKQxmLWEL4B9HxwUo8B6E/0mVILQG9Qasgs8IMQdh0BNiDFetp8buLFA240HjgxY0Tl4faR4Py/P4HNQzL6hxEXcZDDFI7POZd+wvJQ6DeQDAkOdgrWnzDJE2llPf7ti1+OWvPl2q3xiiWsk0CEVlfmtpSOmKtMU/+ofv9fjJPMpdB7+z8NCd0SNj5QBcuvejn5fA8TRFLwM9tRwn1HyREU1dknBnVqyLicdjE+Upc0kD3sYYHeGINDwUdqhrvSuNx1S8JVah5HUmK3zULg+mnXfhVwZE4NCU113OW2Nb/m7eEtmav1ZfQXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(36756003)(26005)(107886003)(2906002)(1076003)(186003)(2616005)(4326008)(8676002)(6506007)(6666004)(66556008)(86362001)(66946007)(8936002)(66476007)(5660300002)(6916009)(6512007)(38100700002)(6486002)(498600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8dw96LvpQhnAtx3Ht7whBcK+fqCsSf2XIh+K5ip1fIIHrcYmN3RH9uROMINx?=
 =?us-ascii?Q?jtasSjU3IKwh/jvS3KMRrNPmonuuYuq0gq1z6onKeif5pgVhcwi4IdBcfX/5?=
 =?us-ascii?Q?EBkHIST1HzTkGr6a1PRSWq2XbWWHGhDsZuPQ0hyXXeU9PO0XY9G8/autC6rl?=
 =?us-ascii?Q?VSwrXcVx+bk9srE+eAf63ZHi49kzPhI8woGsys1jHps3becumdLJW45/glbz?=
 =?us-ascii?Q?Cz8ZXnhJwfloeGZEhmOmtbJg/5KaVOi29DA8hpV0d9oW5kFwD1/QDGWlgF/v?=
 =?us-ascii?Q?eEekoF3REfiPn6lCajM6+/ITpO2wRCL94kAUy1DWrKfoop/gIgNxkW68q3eo?=
 =?us-ascii?Q?/LRBzUpqHE2dqoe0Y3yW8lBB4HIFwhiDGOemEkcxAEvCifuNFxkQ+B6XhDXU?=
 =?us-ascii?Q?rOuYTisNthrKFp11kwytqhSCwB33GsHBdy+fDEKW+KKlJ68ds1aB9ZRT8AmY?=
 =?us-ascii?Q?5ldmA9bEJHKLxn1L+9KGbdvgpjZC25y1A8C5M2FVDYeM+rue5UnJc9mGAr0H?=
 =?us-ascii?Q?Fk6DOv9O9l+5q1b8zEgLfRtKWe+BGI2PdbDcKAo116gY32qRPbcqhiPED/1j?=
 =?us-ascii?Q?FjLWqHROHJvTRILgdF1QKtBGRPt4ESVNaGtsXF+Al6+GnGw6yRfANoGPtegX?=
 =?us-ascii?Q?Fcu9XeVnQRSWQRcTR2FHKZ7E3bqoR16/HII8R8i11DrhBAHa6ttNwCD0iVH6?=
 =?us-ascii?Q?bmECvWOgkCRRrJlc9RV0Zwd3Dp3zZbWy2C/Ro8uuhyxpd3PdKeB4gRLZa/6g?=
 =?us-ascii?Q?zSUxrL+exB+va9UL7sHJzbZIASaCoYKr1WxTf0ssc1Qinh/OlaLJ+Dw38fo5?=
 =?us-ascii?Q?/SxUOvDh2RUm5w1dJfkQRNV7Nzgfg2S8WWD3Mcxty3KvV/BYBHWSASULzs5p?=
 =?us-ascii?Q?KzL9wx2BBGnjdVNsTRdasycErIZlOg2odTcPoNFok0U/492lhu5D/1lfef/o?=
 =?us-ascii?Q?QGXh9+RN1FYRGjnq129GtpO5d1Yw4nNHAhBDR5OjvEfva895gx+H9eWL0Ydj?=
 =?us-ascii?Q?UluVXOJCk3g62jctHirL6SPgJ5fQa6YCn2vv0s8RKzJ25rUnsB9cR9yHezuF?=
 =?us-ascii?Q?Tl8mScQS29K89r+8UgzMSmJYk9OpGik4oI9wX+o6Bji4FvwV4MsgH8p6SfM9?=
 =?us-ascii?Q?TA2f3ZjNLrYmth39L5oX2fOd5U9kedTzpB/DPnb0zPoqQtGn0mwv2TCQGeQq?=
 =?us-ascii?Q?L/apa0ERWXMIZP0sQ2p2QjLBzD4vKhwxB6ZR2HsCkw+5FBcFagXjDYcUyGGV?=
 =?us-ascii?Q?ZcqfDxE0Wp4+rF2TZjgDhuBmxZ0wrPFf7seKXaBeTfSO3KiD0mbAQ80b6GQX?=
 =?us-ascii?Q?Xe+xG2RWsGi0ZP/sOgKFyGyUqfBHpCQ1GYA6sIqOTwLvmkNWWH2QKjVcPUlC?=
 =?us-ascii?Q?8oVT2IwKtaUTYLDLQnbuRTlMsdejm4WviftCWferXoGEuqcqkdpgIWiyucg4?=
 =?us-ascii?Q?eOKyC8IalGdqcjOhP4AxEvcOB1HU7Ez0giwGEZhuneIysx2fo5PxZCsAIYx5?=
 =?us-ascii?Q?ZNothGufmEAVphaIiK9fJgl36HyUN2e8ya0UAMZQEj6MKMSpCEvxKugHVXvL?=
 =?us-ascii?Q?8zFgzxc4kaUJlo5oYWbqQLYCbMuZk/p8tkZ2oFerRR5NpfJXaXOibM2sWQtb?=
 =?us-ascii?Q?x6h6SAXkJgGG7PQJbIbzS0PdjZ2PshcwBaRk4pewR7eco7NhrE2EEosXOM2U?=
 =?us-ascii?Q?Ghm3AEw9CTe9acC8VGyJPDNW7uHGOdkSz1b1ukU4IBZKExaXdTN0qi/mMvmN?=
 =?us-ascii?Q?iclx3GMmng=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5315925-c7fd-4b7f-67b6-08da51debe84
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 10:30:34.8378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /H5aakyMmztjNc2Xt6Jqb4Vg0nXKSGoryqLX9eObAfNncJ9ncxJ+cvSBONFGXti4V24Sgstk/6oZf0EJpHYEFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1193
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

SFD register configures FDB table. As preparation for unified bridge model,
add some required fields for future use.

In the new model, firmware no longer configures the egress VID, this
responsibility is moved to software. For layer 2 this means that software
needs to determine the egress VID for both unicast and multicast.

For unicast FDB records and unicast LAG FDB records, the VID needs to be
set via new fields in SFD - 'set_vid' and 'vid'.

Add the two mentioned fields for future use.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 37 ++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index d30b32c02cfb..0600ede2eb7a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -322,6 +322,18 @@ MLXSW_ITEM32_INDEXED(reg, sfd, rec_action, MLXSW_REG_SFD_BASE_LEN, 28, 4,
 MLXSW_ITEM32_INDEXED(reg, sfd, uc_sub_port, MLXSW_REG_SFD_BASE_LEN, 16, 8,
 		     MLXSW_REG_SFD_REC_LEN, 0x08, false);
 
+/* reg_sfd_uc_set_vid
+ * Set VID.
+ * 0 - Do not update VID.
+ * 1 - Set VID.
+ * For Spectrum-2 when set_vid=0 and smpe_valid=1, the smpe will modify the vid.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used.
+ */
+MLXSW_ITEM32_INDEXED(reg, sfd, uc_set_vid, MLXSW_REG_SFD_BASE_LEN, 31, 1,
+		     MLXSW_REG_SFD_REC_LEN, 0x08, false);
+
 /* reg_sfd_uc_fid_vid
  * Filtering ID or VLAN ID
  * For SwitchX and SwitchX-2:
@@ -335,6 +347,15 @@ MLXSW_ITEM32_INDEXED(reg, sfd, uc_sub_port, MLXSW_REG_SFD_BASE_LEN, 16, 8,
 MLXSW_ITEM32_INDEXED(reg, sfd, uc_fid_vid, MLXSW_REG_SFD_BASE_LEN, 0, 16,
 		     MLXSW_REG_SFD_REC_LEN, 0x08, false);
 
+/* reg_sfd_uc_vid
+ * New VID when set_vid=1.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used and when set_vid=0.
+ */
+MLXSW_ITEM32_INDEXED(reg, sfd, uc_vid, MLXSW_REG_SFD_BASE_LEN, 16, 12,
+		     MLXSW_REG_SFD_REC_LEN, 0x0C, false);
+
 /* reg_sfd_uc_system_port
  * Unique port identifier for the final destination of the packet.
  * Access: RW
@@ -379,6 +400,18 @@ static inline void mlxsw_reg_sfd_uc_pack(char *payload, int rec_index,
 MLXSW_ITEM32_INDEXED(reg, sfd, uc_lag_sub_port, MLXSW_REG_SFD_BASE_LEN, 16, 8,
 		     MLXSW_REG_SFD_REC_LEN, 0x08, false);
 
+/* reg_sfd_uc_lag_set_vid
+ * Set VID.
+ * 0 - Do not update VID.
+ * 1 - Set VID.
+ * For Spectrum-2 when set_vid=0 and smpe_valid=1, the smpe will modify the vid.
+ * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used.
+ */
+MLXSW_ITEM32_INDEXED(reg, sfd, uc_lag_set_vid, MLXSW_REG_SFD_BASE_LEN, 31, 1,
+		     MLXSW_REG_SFD_REC_LEN, 0x08, false);
+
 /* reg_sfd_uc_lag_fid_vid
  * Filtering ID or VLAN ID
  * For SwitchX and SwitchX-2:
@@ -393,8 +426,10 @@ MLXSW_ITEM32_INDEXED(reg, sfd, uc_lag_fid_vid, MLXSW_REG_SFD_BASE_LEN, 0, 16,
 		     MLXSW_REG_SFD_REC_LEN, 0x08, false);
 
 /* reg_sfd_uc_lag_lag_vid
- * Indicates VID in case of vFIDs. Reserved for FIDs.
+ * New vlan ID.
  * Access: RW
+ *
+ * Note: Reserved when legacy bridge model is used and set_vid=0.
  */
 MLXSW_ITEM32_INDEXED(reg, sfd, uc_lag_lag_vid, MLXSW_REG_SFD_BASE_LEN, 16, 12,
 		     MLXSW_REG_SFD_REC_LEN, 0x0C, false);
-- 
2.36.1

