Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6219F582008
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiG0GYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiG0GYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:24:46 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1190840BD5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:24:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCwHa7pQsk6tQEFuKiqQ0FaAKVLlt9rBLjeYLgqMc1Hp65yLdlluZEQAaKx8CqdhFDhDq6sqTWCFYGKDmHWZVtPcKZAe48RMuJDTRxaurynrZby60EaxIhTPsUCbBoNI5cqA+Mg+RByjezOojJY74fFpOVVcDx5Or1Y/mT/Ap13F3iqWgSQ93fdRAmvDfBNeAbfxrVbl9BisvpOLBuSXn+PWD5j4Q/yobQuggHwrQ7OyJ+tRFaUrKat9hIf5MJFIiHNRBT2zzOEwuexhblxwe36dGDTnAc3dCBQFVvbLpfvd0JmbZ0fwSQ39aSPfg7u41HFgGpcmBsailFhSvBSa3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opFERt03y/dRntIgwS2z0XCQovelbX2irYu/G/ErXmc=;
 b=fPOCrgFVWj5C+46gKDve2kAwGIASVS+J2TL/OCr3eGkgf+zAjgA4Xf7MKbHL0xXSigiHgxLpONGgQVDz+/O22miNwSE9nMdHnCaSud8QwH55+1+IeuppUg5mWN0VGGU5xzseSU+FauyPs3rm0QAocP3k6PXe/vFljzm53GxJWAP1s9RqJAQTAryYpBOtGOmyCNqKxEuVXmSJEUD9S5OtSQFzOzQZQs3TL2EX8wgo65GQ4i2jXicFZGhoM376gMMc2+xz8uWRODO66u+XtnUz6sKI2UN+KDlrogsNNHcH/YkIuv332OHTE5+ZFOLEg8hUZikw5yx6wZ4fibCPdYj9Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opFERt03y/dRntIgwS2z0XCQovelbX2irYu/G/ErXmc=;
 b=Zo5auAgGAlTkL+ckMSVWoVibfX+mE9KpOTjRH/KbYje1Us0jXrFj8Ty6+EHdq0dkCJ+7d68KdkdHS5NYiGULpXiP3DFfAJFS91vVeEkonxBfpZQ8N5oq/1/wvy6BqNoRPbPitM/D5yzPTD9uBnS220CpvJ0caZ3ukECrPSYAk4vgKNc7N8Y2FriPlxKgy0fMfgzekJKJ60wvWB9O/CgCLJg6syJLokDFvI/Y+F5ywxW85Q+H2Z/660PzYkUzs/1OC7n5ihw+zKszpEY7S7/9vPOGs+hFSp3fUAeKd2OsLihw9Z9ohKNzPneoirLvhKyVVDawoEiJTYqCz4XT0loCyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN8PR12MB3347.namprd12.prod.outlook.com (2603:10b6:408:43::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 27 Jul
 2022 06:24:43 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 06:24:43 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, richardcochran@gmail.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/9] mlxsw: spectrum: Support time stamping on Spectrum-2
Date:   Wed, 27 Jul 2022 09:23:26 +0300
Message-Id: <20220727062328.3134613-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727062328.3134613-1-idosch@nvidia.com>
References: <20220727062328.3134613-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0124.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::26) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6884158a-a442-4552-e257-08da6f98b15f
X-MS-TrafficTypeDiagnostic: BN8PR12MB3347:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 92NsvA9VcG0drD85rMxNcDMrkSuQ4Kip45OdD1xC/uFk521UmwPZRFd8IHHpNgbe2e2w8TKqzmfViw0njkj+nYK8e2bb+VG9ZAKF2hpGnP56ElAW75LfKW/HyyFsQPYxlrC/OWfvmdFTcnpI1qKoRE0boxMdTlw0iB1HR0rAfNo8G7XmE+wamEHRRDl6+ofy1n2jsC2SNz1Ryr5GGoF3hXAyw19TXp4ai8fmwfafG9suOo62VoqqzjmzGP7o/i7xkLayRD4Yv1sksqhwQDA8bSVhqtOBiP+83ix8fWOS/RYdulnkFU1s+eKWCxtUqYD/C7+Ctpf07Zjo+XEUYkuBbNWPjEWPrMB2loru5+AjOto6LumT4KcBjdPQ/7tfYtzW6zDQdne9Mynv1vC5A7lqnnRoB9sLjCHZtLEUYnV+8/2Tpx3IaWluP/tY93Bu2fPN1SYXjR5qydENcjwuCqusbWbN1m958LAYxkuoANNDWAQdecYYCznXrbK+QIouvjRDtPXLh4cV16iipaE/+sfv4zxZcvrMcfTdmZOCAUWxG5+XQswIa3x7t2IL/+7nzQLQSTVjHqkWhJTUgRkb/aR1O/dEPfG1xqtNRrW2LFPra7NL7yD7tO5dijNAgMDC3W5SAmz3QOSFooJHQPi12eGYaTyG7BTBGMM1JiilVDyVyurk0s/qAIFqAau4gTkrSAhLACjbY6qjZWe1G3EYFlXEv94/ymJ+KigN2fkgkRouM3t+S5rKFrnysJIt4Yqti95J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(1076003)(38100700002)(186003)(86362001)(6512007)(83380400001)(6486002)(6666004)(107886003)(6916009)(2616005)(36756003)(478600001)(8676002)(4326008)(66946007)(26005)(316002)(8936002)(5660300002)(6506007)(66556008)(41300700001)(66476007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EqQ+vqR/Eh3aSd+5IzPqJT5QUaU2sMM3EFLFL0bGw7zWMQNClI1RRPw3U6ub?=
 =?us-ascii?Q?077NAlDmsL2nCAR/VVsog+PTCP2BO0rULEyQeuJzVnW/4aCXn3Nq2hbkNSu6?=
 =?us-ascii?Q?NHZ3KXD/tenYu0/ZKm0ipzJQk1jbgZnvtpDasOP7SjSu60q0bkCX97Uq9LOx?=
 =?us-ascii?Q?lQOSK3vZO2/5DDt1a7lNmgpyb6TQRnCpqM0Vl7W1ICmo/mnpqEb3j6DBrzhZ?=
 =?us-ascii?Q?LS7EKKLMwugppNhT7KKwy1qnW/1yKkuVFdLg0SgKQRR/xNAXTQ3tl/8nD6iy?=
 =?us-ascii?Q?2r6cI/SaJ4zH9KdgAtNW2KQ+uPaiYNDlm1EFfmXRcNZg2zkJr9w34mdISDHO?=
 =?us-ascii?Q?+YFKl5eCWo0qCrQNG441z90ITLa9YUY938SfiqK77YLMS3H9wn0wruwzyflU?=
 =?us-ascii?Q?CJPq0VthQ4t3JsncN105z9CcaMVEH+L5Q3nfFb9VAEkT1g76PQVNfLJmVXMO?=
 =?us-ascii?Q?phVipFjvMHh8lOCOKyGLkzEVvlpthK0SaXie5O+7Vsa5mmRXE64trZGuqGYP?=
 =?us-ascii?Q?/6yutxXGMLSP/nqOmGaHgarwXC5Vt+enuAoNcEVJOdN6h1ewpG9sAaImWFCV?=
 =?us-ascii?Q?Yqn7v6gk3oMgC6EtSbwieV8+T0eYx5GYJYeDKT7o9SHdXWBzOcEmxhZtWTuS?=
 =?us-ascii?Q?ji8kuBOSVnea85R+f2JUp5oGeYlg9Pabe5DRaBx21jnsiGC6PHNIjTsub6uq?=
 =?us-ascii?Q?1r6Yvx1Xh6aAEE7ZmfFqVBwz36bMQojaSAX31jOlmCNEn8cZ2vVSTyg9HbGu?=
 =?us-ascii?Q?vJYcg6pW6oEdLy9rJ+g/j8TuSSp8UFVdecj63znKnERdNO2woK2WntNwQglq?=
 =?us-ascii?Q?3pESpbZcrlROqoozOPMbz0RxFUdV2w3jERJvd8GAb1z1igXgfOey0D2PIBEO?=
 =?us-ascii?Q?8ZSSf0ia4zrt1VHSQZNWFuIpIqUlFBJRIeiJdyLB5miSHda7XRq1RQoglkPN?=
 =?us-ascii?Q?Ng6F2nksHDR1B0/RuxhmbgS5mQdgQTPCuYlYzJLCIquJrX4KLRGrRLem8TUF?=
 =?us-ascii?Q?r8RQGQE3JUdEmOVjxZCjGs3eVPO+elTuSMA2bUsuC/CkUlEydpSO64TLuCUK?=
 =?us-ascii?Q?WI4p54h/gXXkJvppDfKUJTNlSB5DxrAz0LJfvdweqTPT4IQJidZoLBC5Mdlq?=
 =?us-ascii?Q?lJIgH4uVFMj6ukvIRSX1DUIDoEQ5qNbiNcgSw3f2n1Dp47G6A8chaAk9k7Zu?=
 =?us-ascii?Q?uGSOu1p0+/wzUWTncYmIuhUeBe8VceW0bNsU22xA78wXkm1UW2SCT7NCUUhj?=
 =?us-ascii?Q?0fZ/enIpYrawQObTDKk414sx9nQyZRR7nsTJG5EmCSpVJiM4u/keYf3dBFvZ?=
 =?us-ascii?Q?mTVCVmXpw5b6sV/p41F7xsjpHnWQEDZS+vtD3kgnBt0RpXd2IHytmDMjCb/e?=
 =?us-ascii?Q?iyhuIoPKWyS9x45U6W4lM2TGsj3NzldbTSi26xBWbU6mG056bFQ5AFwNLcPZ?=
 =?us-ascii?Q?ITdJi4k8s5cdq0Q1WPar50QgliBQxdpd8MbHjuNZEOJrjInrH50VgsxAGUy+?=
 =?us-ascii?Q?dCq4h0mGN0c6nPCKipapA+3MaWeqJjY4SoPI493jjQChkprjo7udX8ByxOfE?=
 =?us-ascii?Q?t5VKM+CAJU/VddCWCpALprbecrQXA6AzDhMmBkOt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6884158a-a442-4552-e257-08da6f98b15f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 06:24:43.0565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F9tny49q7+3rpyJt1WGUwaSEZGVU2yEP4NNutisaLUUxBbTD7FJHKlWY2+a3IYL1gkVRLp7vnhbUW0jIR4IFlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3347
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

As opposed to Spectrum-1, in which time stamps arrive through a pair of
dedicated events into a queue and later are being matched to the
corresponding packets, in Spectrum-2 we are reading the time stamps
directly from the CQE. Software can get the time stamp in UTC format
using CQEv2.

Add a time stamp field to 'struct mlxsw_skb_cb'. In
mlxsw_pci_cqe_{rdq,sdq}_handle() extract the time stamp from the CQE into
the new time stamp field. Note that the time stamp in the CQE is
represented by 38 bits, which is a short representation of UTC time.
Software should create the full time stamp using the global UTC clock.
Read UTC clock from hardware only for PTP packets which were trapped to CPU
with PTP0 trap ID (event packets).

Use the time stamp from the SKB when packet is received or transmitted.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  6 ++
 drivers/net/ethernet/mellanox/mlxsw/pci.c     | 22 ++++++-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 62 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    | 24 ++++---
 4 files changed, 104 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index cfc365b65c1c..02d9cc2ef0c8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -558,11 +558,17 @@ enum mlxsw_devlink_param_id {
 	MLXSW_DEVLINK_PARAM_ID_ACL_REGION_REHASH_INTERVAL,
 };
 
+struct mlxsw_cqe_ts {
+	u8 sec;
+	u32 nsec;
+};
+
 struct mlxsw_skb_cb {
 	union {
 		struct mlxsw_tx_info tx_info;
 		struct mlxsw_rx_md_info rx_md_info;
 	};
+	struct mlxsw_cqe_ts cqe_ts;
 };
 
 static inline struct mlxsw_skb_cb *mlxsw_skb_cb(struct sk_buff *skb)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 0e4bd6315ea5..50527adc5b5a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -513,9 +513,26 @@ static unsigned int mlxsw_pci_read32_off(struct mlxsw_pci *mlxsw_pci,
 	return ioread32be(mlxsw_pci->hw_addr + off);
 }
 
+static void mlxsw_pci_skb_cb_ts_set(struct mlxsw_pci *mlxsw_pci,
+				    struct sk_buff *skb,
+				    enum mlxsw_pci_cqe_v cqe_v, char *cqe)
+{
+	if (cqe_v != MLXSW_PCI_CQE_V2)
+		return;
+
+	if (mlxsw_pci_cqe2_time_stamp_type_get(cqe) !=
+	    MLXSW_PCI_CQE_TIME_STAMP_TYPE_UTC)
+		return;
+
+	mlxsw_skb_cb(skb)->cqe_ts.sec = mlxsw_pci_cqe2_time_stamp_sec_get(cqe);
+	mlxsw_skb_cb(skb)->cqe_ts.nsec =
+		mlxsw_pci_cqe2_time_stamp_nsec_get(cqe);
+}
+
 static void mlxsw_pci_cqe_sdq_handle(struct mlxsw_pci *mlxsw_pci,
 				     struct mlxsw_pci_queue *q,
 				     u16 consumer_counter_limit,
+				     enum mlxsw_pci_cqe_v cqe_v,
 				     char *cqe)
 {
 	struct pci_dev *pdev = mlxsw_pci->pdev;
@@ -535,6 +552,7 @@ static void mlxsw_pci_cqe_sdq_handle(struct mlxsw_pci *mlxsw_pci,
 
 	if (unlikely(!tx_info.is_emad &&
 		     skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
+		mlxsw_pci_skb_cb_ts_set(mlxsw_pci, skb, cqe_v, cqe);
 		mlxsw_core_ptp_transmitted(mlxsw_pci->core, skb,
 					   tx_info.local_port);
 		skb = NULL;
@@ -655,6 +673,8 @@ static void mlxsw_pci_cqe_rdq_handle(struct mlxsw_pci *mlxsw_pci,
 		mlxsw_pci_cqe_rdq_md_tx_port_init(skb, cqe);
 	}
 
+	mlxsw_pci_skb_cb_ts_set(mlxsw_pci, skb, cqe_v, cqe);
+
 	byte_count = mlxsw_pci_cqe_byte_count_get(cqe);
 	if (mlxsw_pci_cqe_crc_get(cqe_v, cqe))
 		byte_count -= ETH_FCS_LEN;
@@ -706,7 +726,7 @@ static void mlxsw_pci_cq_tasklet(struct tasklet_struct *t)
 
 			sdq = mlxsw_pci_sdq_get(mlxsw_pci, dqn);
 			mlxsw_pci_cqe_sdq_handle(mlxsw_pci, sdq,
-						 wqe_counter, ncqe);
+						 wqe_counter, q->u.cq.v, ncqe);
 			q->u.cq.comp_sdq_count++;
 		} else {
 			struct mlxsw_pci_queue *rdq;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 25d96bedf243..5bf772ceb1e0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -1386,6 +1386,68 @@ void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state_common)
 	kfree(ptp_state);
 }
 
+static u32 mlxsw_ptp_utc_time_stamp_sec_get(struct mlxsw_core *mlxsw_core,
+					    u8 cqe_ts_sec)
+{
+	u32 utc_sec = mlxsw_core_read_utc_sec(mlxsw_core);
+
+	if (cqe_ts_sec > (utc_sec & 0xff))
+		/* Time stamp above the last bits of UTC (UTC & 0xff) means the
+		 * latter has wrapped after the time stamp was collected.
+		 */
+		utc_sec -= 256;
+
+	utc_sec &= ~0xff;
+	utc_sec |= cqe_ts_sec;
+
+	return utc_sec;
+}
+
+static void mlxsw_sp2_ptp_hwtstamp_fill(struct mlxsw_core *mlxsw_core,
+					const struct mlxsw_skb_cb *cb,
+					struct skb_shared_hwtstamps *hwtstamps)
+{
+	u64 ts_sec, ts_nsec, nsec;
+
+	WARN_ON_ONCE(!cb->cqe_ts.sec && !cb->cqe_ts.nsec);
+
+	/* The time stamp in the CQE is represented by 38 bits, which is a short
+	 * representation of UTC time. Software should create the full time
+	 * stamp using the global UTC clock. The seconds have only 8 bits in the
+	 * CQE, to create the full time stamp, use the current UTC time and fix
+	 * the seconds according to the relation between UTC seconds and CQE
+	 * seconds.
+	 */
+	ts_sec = mlxsw_ptp_utc_time_stamp_sec_get(mlxsw_core, cb->cqe_ts.sec);
+	ts_nsec = cb->cqe_ts.nsec;
+
+	nsec = ts_sec * NSEC_PER_SEC + ts_nsec;
+
+	hwtstamps->hwtstamp = ns_to_ktime(nsec);
+}
+
+void mlxsw_sp2_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			   u16 local_port)
+{
+	struct skb_shared_hwtstamps hwtstamps;
+
+	mlxsw_sp2_ptp_hwtstamp_fill(mlxsw_sp->core, mlxsw_skb_cb(skb),
+				    &hwtstamps);
+	*skb_hwtstamps(skb) = hwtstamps;
+	mlxsw_sp_rx_listener_no_mark_func(skb, local_port, mlxsw_sp);
+}
+
+void mlxsw_sp2_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
+			       struct sk_buff *skb, u16 local_port)
+{
+	struct skb_shared_hwtstamps hwtstamps;
+
+	mlxsw_sp2_ptp_hwtstamp_fill(mlxsw_sp->core, mlxsw_skb_cb(skb),
+				    &hwtstamps);
+	skb_tstamp_tx(skb, &hwtstamps);
+	dev_kfree_skb_any(skb);
+}
+
 int mlxsw_sp_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
 				 struct mlxsw_sp_port *mlxsw_sp_port,
 				 struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index affc9930c5f9..26dda940789a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -71,6 +71,12 @@ struct mlxsw_sp_ptp_state *mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp);
 
 void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state);
 
+void mlxsw_sp2_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			   u16 local_port);
+
+void mlxsw_sp2_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
+			       struct sk_buff *skb, u16 local_port);
+
 int mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
 				  struct mlxsw_sp_port *mlxsw_sp_port,
 				  struct sk_buff *skb,
@@ -184,15 +190,6 @@ static inline void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
 {
 }
 
-int mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
-				  struct mlxsw_sp_port *mlxsw_sp_port,
-				  struct sk_buff *skb,
-				  const struct mlxsw_tx_info *tx_info)
-{
-	return -EOPNOTSUPP;
-}
-#endif
-
 static inline void mlxsw_sp2_ptp_receive(struct mlxsw_sp *mlxsw_sp,
 					 struct sk_buff *skb, u16 local_port)
 {
@@ -205,6 +202,15 @@ static inline void mlxsw_sp2_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
 	dev_kfree_skb_any(skb);
 }
 
+int mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
+				  struct mlxsw_sp_port *mlxsw_sp_port,
+				  struct sk_buff *skb,
+				  const struct mlxsw_tx_info *tx_info)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 static inline int
 mlxsw_sp2_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct hwtstamp_config *config)
-- 
2.36.1

