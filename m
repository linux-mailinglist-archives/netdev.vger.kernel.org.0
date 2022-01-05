Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476D2485117
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 11:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbiAEKWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 05:22:50 -0500
Received: from mail-dm6nam11on2072.outbound.protection.outlook.com ([40.107.223.72]:42560
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235519AbiAEKWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 05:22:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDm1wQJq1WgSWSsO2HlY9xo8e+ed4Mm/2pFPGc0MgY2fmQs2dCT4k6TkrI9pBJfCNnQogev5k17ifMf7fCTSLZ0/KdU2SzL9MmqI9TxHo9Nffb6dbQ3nuUZYK0MP2AVj0dSjgAIk7zBIeofNwixLJvyYvp4kQXgQIWfjKb9mG4osqmewNnDNc1AxbLiyvMBhgJg4aAGHtFaTeNPUTcoteIdomuBY5v+SnQr5Lx4R5I8fZFakrtpiQud0K2ycPIiZwLjhGvJxA4Q8ByDcDBqjIg9M5iz/0Hj+iCVZXUwHuWm3fMTNGa1a3KatSbVumgY+RK7xuPMGhbiUb9g4sLzvfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WjUtja1JJ0fS3NUAhodpI0g8yG+UzhN+qcenOMHfQyQ=;
 b=Uo/KJFv1BcBiNX6RopyGqAWfPmXwx3REtlYMyfSRmxbf6uykV8ZaMXRZsw0l4YED2mJLsNFXypIc2v2kektJgcQLTUurowCZbnLf7t47TVX4W4oI4Iv+NC9wG7JttOZvw/3qiIiWt4l0xdikTTctOKQZ4RS8VrJ0cjA6LUk825tBEjsMv+qbzmx+36TZewt9XlfWT1Lx5M302Eyc3yTs9GlPxXc9bXjXPS5q5i7coh69Wy8qB3VBZzmojHkFF6iY1KaWmOjY56rzKehmSNH7KsbAeiiC4F+5k1aC/0ERB2DCHuYHuZNPW4ORqbvVkR5Ww/+gk2gEiJCxJRjPfS78Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjUtja1JJ0fS3NUAhodpI0g8yG+UzhN+qcenOMHfQyQ=;
 b=ajPAy6XCRthRatbyahCH0cGFhl+gvlQpxOSGSRILakmJ4qbeKs54lYrISTGqEyhF7Kx/rFqjbEWrFO5e7/QMQ7WhwBAOtuR30WmKWFxaCzJNhA+yHVqrRP0tODIN5WC0ylqHOMx+URp8C/K4yx5P6qUryDCz7Qa3rqHGJaUS1z8HTQ6P7bOep+t46LkbBiJfqRnP6VJQcQ395yht510jctn2FII2OW89yTfPZZax21x2BMRoT84Uzns7XcICyQsF0Y9Tdhl5RUf8YZ4ltih6x3VqP4g9iXIqQw9CEODIEu3Nn8QNMQO/QYNx7Aiapxc/w4iguTbr71rcD+KclszxzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1641.namprd12.prod.outlook.com (2603:10b6:4:10::23) by
 DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.14; Wed, 5 Jan 2022 10:22:44 +0000
Received: from DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa]) by DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa%11]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 10:22:43 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] mlxsw: pci: Avoid flow control for EMAD packets
Date:   Wed,  5 Jan 2022 12:22:27 +0200
Message-Id: <20220105102227.733612-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0022.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::9) To DM5PR12MB1641.namprd12.prod.outlook.com
 (2603:10b6:4:10::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65ccfa1d-325d-4cf5-c55f-08d9d0354f72
X-MS-TrafficTypeDiagnostic: DM5PR12MB2470:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2470674F86E3A594049FB923B24B9@DM5PR12MB2470.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qn73B/8pNBulRDElhOnSDQn+V+++GsQvrQjYLa4ojQuXI6TVMNWwINj4PvsRIgX9SyZ7yVobbq73zpQp0n852HTrq+212lEOadGuf+FYSecB508hBgJJ3SX8ZJ2qGmkA0rIZWTy0dFHOAbcVbn+1armYWLN18Pax/tCd2XguNwrnrerK0twinPKjJ87bwd+/vRCQcRx79aDL6T6Bd/Kkn+j9gOfr1/CC+LNni+hPBqpg2OKFrP6WRT6Mags8vn/eMFC/CZ4KAO8Xz0APE3XE1od3mGv/wCC3746T+Ue6phoAP0tG8uRaFbpSpRG5CHUQzOGz4Bhrt6uyxkc8YpxLpi3nrEsigH/bIzP0yEgaIBw/rUwsSAx9D3Ei+llQBhknajfr3/ZpLBp8wi0DXeQbkg5D995ufTtD5eST1qo98gN0xmvpMrypSBazF9CdCSRcT0aS029N5jzKUEXNEx2EiRfX5WsSgJe2T7MhpMMrt95HCEJ4CvaOFBv3FWFiEw9ia11M2QOk4I4SAZcJWWzcf8Vx1Bj4q3d5PkM/yfmbeDj9bcFbYE7wxGmF5yiezsfv6/atvxrCDfFBqz8Wfb5uNv0fWfUwjrWBfWhr+a6LJiRIt17CEe+EiM/4phhYUZSaeQR2PkjRwAJm/MqBhA+dx1Le3Hm3oFKZTatwgefAstCagzVfk42DOkm46+dtbTg/FBmqzzWJ2oxmrymfSjTyUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(38100700002)(36756003)(6486002)(26005)(83380400001)(2616005)(2906002)(66946007)(107886003)(508600001)(316002)(186003)(8676002)(6666004)(6506007)(4326008)(1076003)(6916009)(66476007)(66556008)(86362001)(8936002)(6512007)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JEDhN3Z4WLe/hww2DOv2+KNUoArFaZJKnut8OYsCEEFYLz7IgB+f1K9Wrv0v?=
 =?us-ascii?Q?7JxN6HygbLqJakhflizQPZEyZq8nxEBg5Z19OUmp3tyY1N7jJmMGGEJL42Wa?=
 =?us-ascii?Q?kOwfZeR+AFoxaJIwKZqJ83mLGPDApLiIl1mUSWkSjMrufMCPmyjo4wH/3q4i?=
 =?us-ascii?Q?kwSpN+DPJF/LxWqBNbz1u7yWfVl9cNzlgqqT1xnYDKbPBxwMWiI+CTJmuybn?=
 =?us-ascii?Q?qJb48XNEq/pBM4lWStfYoQ/qLhpjJ2il4LinkXtKXSsBaCI+I9hs/CnISve7?=
 =?us-ascii?Q?qebSwufAHLACw3NWq+7pg1YSiWaVB4xuHMg3za+TcCdCYStomzGiqfWzr4+B?=
 =?us-ascii?Q?OrLXi3F6zdXQMkNDZpIq2NANUwexc2A1f+E/2p1+mSvOJMXD5JPBG3qYXPVp?=
 =?us-ascii?Q?J1kChQr7y/Y9TmrlkZRjp6dE5KaU2+bFbw71ehOS3SKcgepSbS4+2LMNRvjl?=
 =?us-ascii?Q?ElE37LfxbknsWT8mgdK/tc3PvIkTgviNkxd1YAkRNEPQGovcN+k+7bvVBZyK?=
 =?us-ascii?Q?xqwUbef4Bhbzte/3RNrgiR9qZO45LoxWL3b1XOSYG3lG/kobDHkGmex7YLk0?=
 =?us-ascii?Q?m63sA0AdY5rl50M6T6ub1Saq4af5k56vAHrI4+YqjoJpMaNXcyrf1bcJ8NIo?=
 =?us-ascii?Q?D+3vS6tJCpNVsROIsqOsjJAijW9S3Qzw2So/G39fAwB+rf5QjHeGIugecTtq?=
 =?us-ascii?Q?ib2y/DWpMfu3/jtJzSO0BlYIsNAQzmEokH+mJIvDKyrlA6hAOPMPcHU1KnVu?=
 =?us-ascii?Q?XjXsdQqnQ4NsYp9mPh14LZ2LDPC9nYzWZa2Lvz9PUlh4M290h6M1rAQgqOPr?=
 =?us-ascii?Q?zMATveOvwGnShyy5tLzDYwjdGi8c0o8oTPHsSGUslrwbLoEm3zEbZ5CNbV3Z?=
 =?us-ascii?Q?P0M4qN+f2c1zL7MoAehq2lClPE8n0izobOpmJGb5uQgAYIAasnenTkvvbsoY?=
 =?us-ascii?Q?Fir/KQLtuGhPmNoeaXxssD/9x15pGs18ZAqV9TUxK7McTpj4kW2HRDgtDEVl?=
 =?us-ascii?Q?WcJgvD+uml0fUBPSF2MXroazrmxm2k8XUODpPM/rj4N3BfQdX1xJIj8ZM96T?=
 =?us-ascii?Q?mPkLOdEs+hyY0x/1Qho19xZaFIZvsffp4T3vs1shnF9NEOmLUs62ypt+4z9c?=
 =?us-ascii?Q?/tVYX87kPZ/8ddh4J6EnL5HkCH0L8cYhnojvLt2ih/iJbvIPj/aSJLx6pyD0?=
 =?us-ascii?Q?tLa76oRku7SJ6t5Vylgf8zNZUu8KGFoBi1cpV+fhQVpN5mZ12X1klgKmUsdj?=
 =?us-ascii?Q?x3PZE/4MJZlc4iCplovuq5/uO2VzWk9ubB181ztZq7KOvsDqqKwAcRV43fhz?=
 =?us-ascii?Q?fqFYHgz49IvfK9iYTIUxK3nwWTOvJwgqtdaZeuML1REsUCy8BAGZfYyr1+/c?=
 =?us-ascii?Q?uND68BQctOPtXPsRDMBYFdWFZxakEFEMY0bRcO8P+rvznL3N+e7RzMixJJj2?=
 =?us-ascii?Q?6NRb5KRdwvDrL2O2ssJfM6d8CgbwhHmk37j5vJx4Du+in8QA64QmckaZgiAD?=
 =?us-ascii?Q?X3WONC8IF5fDo1M7Qa3aOTllgbw61FrfbPtF0KDNqcFvOgsqUDhIDuZqrkWY?=
 =?us-ascii?Q?pW9/aTP+wDSLP5d7YVl7yWWLZnMtMhYsMk+Gz4pf6y8ujEZspS4IdxzH1rdT?=
 =?us-ascii?Q?Zg3ymjck1//pWYNLopASNjI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ccfa1d-325d-4cf5-c55f-08d9d0354f72
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 10:22:43.7526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QOuWzoJmUs70ZKoAuxgwJhV7vONerNg2aSgaBWc4c5mJdkZKZNGwYhp7vXe/h6ORxiT+/qvW10rCwO5U33Y8qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2470
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Locally generated packets ingress the device through its CPU port. When
the CPU port is congested and there are not enough credits in its
headroom buffer, packets can be dropped.

While this might be acceptable for data packets that traverse the
network, configuration packets exchanged between the host and the device
(EMADs) should not be subjected to this flow control.

The "sdq_lp" bit in the SDQ (Send Descriptor Queue) context allows the
host to instruct the device to treat packets sent on this queue as
"local processing" and always process them, regardless of the state of
the CPU port's headroom.

Add the definition of this bit and set it for the dedicated SDQ reserved
for the transmission of EMAD packets. This makes the "local processing"
bit in the WQE (Work Queue Element) redundant, so clear it.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/pci.c |  6 +++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 392ce3cb27f7..51b260d54237 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -935,6 +935,18 @@ static inline int mlxsw_cmd_sw2hw_rdq(struct mlxsw_core *mlxsw_core,
  */
 MLXSW_ITEM32(cmd_mbox, sw2hw_dq, cq, 0x00, 24, 8);
 
+enum mlxsw_cmd_mbox_sw2hw_dq_sdq_lp {
+	MLXSW_CMD_MBOX_SW2HW_DQ_SDQ_LP_WQE,
+	MLXSW_CMD_MBOX_SW2HW_DQ_SDQ_LP_IGNORE_WQE,
+};
+
+/* cmd_mbox_sw2hw_dq_sdq_lp
+ * SDQ local Processing
+ * 0: local processing by wqe.lp
+ * 1: local processing (ignoring wqe.lp)
+ */
+MLXSW_ITEM32(cmd_mbox, sw2hw_dq, sdq_lp, 0x00, 23, 1);
+
 /* cmd_mbox_sw2hw_dq_sdq_tclass
  * SDQ: CPU Egress TClass
  * RDQ: Reserved
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index cd3331a077bb..f91dde4df152 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -285,6 +285,7 @@ static int mlxsw_pci_sdq_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 			      struct mlxsw_pci_queue *q)
 {
 	int tclass;
+	int lp;
 	int i;
 	int err;
 
@@ -292,9 +293,12 @@ static int mlxsw_pci_sdq_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
 	q->consumer_counter = 0;
 	tclass = q->num == MLXSW_PCI_SDQ_EMAD_INDEX ? MLXSW_PCI_SDQ_EMAD_TC :
 						      MLXSW_PCI_SDQ_CTL_TC;
+	lp = q->num == MLXSW_PCI_SDQ_EMAD_INDEX ? MLXSW_CMD_MBOX_SW2HW_DQ_SDQ_LP_IGNORE_WQE :
+						  MLXSW_CMD_MBOX_SW2HW_DQ_SDQ_LP_WQE;
 
 	/* Set CQ of same number of this SDQ. */
 	mlxsw_cmd_mbox_sw2hw_dq_cq_set(mbox, q->num);
+	mlxsw_cmd_mbox_sw2hw_dq_sdq_lp_set(mbox, lp);
 	mlxsw_cmd_mbox_sw2hw_dq_sdq_tclass_set(mbox, tclass);
 	mlxsw_cmd_mbox_sw2hw_dq_log2_dq_sz_set(mbox, 3); /* 8 pages */
 	for (i = 0; i < MLXSW_PCI_AQ_PAGES; i++) {
@@ -1678,7 +1682,7 @@ static int mlxsw_pci_skb_transmit(void *bus_priv, struct sk_buff *skb,
 
 	wqe = elem_info->elem;
 	mlxsw_pci_wqe_c_set(wqe, 1); /* always report completion */
-	mlxsw_pci_wqe_lp_set(wqe, !!tx_info->is_emad);
+	mlxsw_pci_wqe_lp_set(wqe, 0);
 	mlxsw_pci_wqe_type_set(wqe, MLXSW_PCI_WQE_TYPE_ETHERNET);
 
 	err = mlxsw_pci_wqe_frag_map(mlxsw_pci, wqe, 0, skb->data,
-- 
2.33.1

