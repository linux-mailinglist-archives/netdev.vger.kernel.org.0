Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F546582005
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiG0GYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiG0GYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:24:21 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6A2402FB
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:24:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eV2mG0ELYU+A+geI8deaZlnkgi3PXtUD4Q7tBLcVsnhEB+1M3u+7PaB9N5ECGB69P9+0IoozNaA9NGBCTlEghp2uWKNBZE4JQiznoqinxCGxMLlpFbjAtShkEbaJoK4/ceWNubv91TXTdbN4WedScE0Bh+FW+LrfYyP+ercdsrUodzH1LpJf9P3Iq745TgodD3IKwxIRJRwPT85e2ym4k2U7K+RFzssQcqKW/y5nNU4AaBiDU6G+/zVay+jyVJcS+xM0g+T8SRYphJHK/UgnIwFC2ftNTSqEe9QTsryetr1EVB3xYolnuz2YnmFDr4DLTuxXEXLxd1epZVeUOA3pRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/F+gQDcUrfaYZX1Vkt1cRijjMpW5ztcNxQelGwXa6dA=;
 b=dpzGjdrCRL3QDNBeor7unjW91XJj4f/Dm54zdMQEhf8DkK5IAgA6q7TSzflHh8V2a8udD+n4bAkyvXN+YIx+2OPOANgASkfPCc4hj71nFZ8xEcDnk5YdF87FZWmgM2vBtpn0bAVCbS0jcI8VSsgELpzhbRbPAf1YJ6e4rwdDB3TzH09+Os982MkZpvlVtkEsbA5aQiD4R5t43XSFdXLf6AYRdUjpnCuEjlJ1K6YaWEXmVfe1/I5+uOh1s9enC5Ury68ZEgoXP1aeXQbWm56gWd2WNZGVq0Zt4POSKUiuH8fJPvIYXDSVds6xnRECWtfC+pgMUqNBOtXJYxGmpZvkLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/F+gQDcUrfaYZX1Vkt1cRijjMpW5ztcNxQelGwXa6dA=;
 b=co5AE73luaKS4y1Hb35cKgAO9dBvqHP0aEmsKC68JcgrghNGzZZBBBNkl4FjBF5PZTgdLPyqx7wG7HV1r4guOuCieoRdQAevEHn6zq5cv+PGCCKkblM6Ij12ygVcIcxqL6oRRL9029s57PcH78vzSp89+d/M7JtwoSGNUd/lwwTaeMztvcGFezmr3GLsHThtIDftNV/pmN28Rt4Xziyp+QfATkgNzRSRO3P3BIO/nLwBy7iDaYXKRYjo0LT2hPLhAeoxfvK5COslWKX3et4sCFEGMfsaPKNJUsJMuW/gGj291lWLERf1akgZ1pudhFAKkNZUw0kstK8GGZrHGaiGag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 27 Jul
 2022 06:24:18 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 06:24:18 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, richardcochran@gmail.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/9] mlxsw: spectrum_ptp: Add PTP initialization / finalization for Spectrum-2
Date:   Wed, 27 Jul 2022 09:23:22 +0300
Message-Id: <20220727062328.3134613-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727062328.3134613-1-idosch@nvidia.com>
References: <20220727062328.3134613-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0291.eurprd07.prod.outlook.com
 (2603:10a6:800:130::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bcee96d-6a4a-414f-f3e3-08da6f98a2a6
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6243:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EWTGrECJKM54GaLHSoGn1xRDFLd0wgf8YCzSwmrS2H7XoyuWXXV8y5K+hAWSdXvJhbDE27FTkVAX+4c9UmnulfxPZ0LaQMGgPIEBpklKUCZ07q7cIlLRIi9PaOqk3gVo8ValaxLPULdnAEkMPtAGdszqwSJltL59L+0d/ZGxyF8EoKFJQncRgIRF2Ypl+Q3nGNCx/VtKYhOt/+gPPPbtOk0TB+rJIqF39/Pwtl/EzyzWJ/2m4ODOHaGJ0n1fZL00vJqfTYYSPT8/3krCq7+T4RmwikIY39HOWAE198QRjw/vcdVcx7bDAZ91CNderUwOlPD0KNLe4PF8l+f5GiP80TZ/gUH1cl3s5N09zSdVOh6IJtByYMCMOJTz54N0ryPEosJQV7cTC6VmoNoWES+ZVPW9zs6kWDMl3MnF+OCKL93L+JfzGNvw81v5Hctl0y5naaeavX46czRB7DXRRQsZyAZs5RfUZY2mfgono64s1xSFBQOrj4VeM6bk8taI4OVKjfxXx9fqa1lZBFHA+kRE3G2sC72yNWhhK5T+Ah8TdABCN+V97FQOpcVwGBECKA+DAhsilqz9pdU4821WBMqDR2mg9S1HLL/MZq6WQYLCggKCu8hsxGvMzy5DMdcK1xNcmkpZLUcOn6q0PWM1x7BXIt4Gnk6qmGwp5NEW765Lrhu3xTXi1JRgvGW/ITKzTVOyQSxgBffS+nUPWnybBpWjqYA9++0/g1/mh8lN2oIbi28=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(41300700001)(66476007)(38100700002)(6486002)(2616005)(66946007)(1076003)(107886003)(478600001)(6506007)(186003)(6666004)(8676002)(83380400001)(26005)(6916009)(8936002)(2906002)(5660300002)(316002)(86362001)(4326008)(36756003)(6512007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v0DrwoAPcnwWLkiLsHoHYcrGkDDiXCP2O2k28AhkRvwT+Cd99OfnWCpMjsg6?=
 =?us-ascii?Q?KtEUcvmL/gfrnaBe3OIlhkdUWKgo55mrN/tiJuU7eIn6Vgybve9ITtpmQdLd?=
 =?us-ascii?Q?R9FfBLP0EFtOJB9A63IBTKxMgJGVjDj767fKhTBouaPSBMAoWnl4HctMNVom?=
 =?us-ascii?Q?Bdk1lppbKlCYTxlXTheJ/l+YkCoqw1jy4Ms129B8D687LTJQOc6jrRRi4SNf?=
 =?us-ascii?Q?Pt8xUZLq12TpXimsO3nW8ZwuCyUIvZxZpjNTZm0j6cif0Ff5dafcjvMbJMEi?=
 =?us-ascii?Q?dPj8n+4ZEJNy425XOrhsxj2eHFJaGjE8qVlOCPIsGHKX8gzalZ7LUu4jhm4O?=
 =?us-ascii?Q?80lvbQRXjcaNlQvf0hupSW6EZKGUtsGUX1j/BNhiWnjAG26zCB+VO1UH9hX2?=
 =?us-ascii?Q?E6xKrbt/bp0VvSVtlPWc9d2Xm16gJQ6FXVTIVKq4EPgouapdSYzyKPQM1Omv?=
 =?us-ascii?Q?mFMTb3VFn61478sA1kao07JwhZ4EA1HyVIq+CbfA7NC9ldSW1laWvEv9/PrW?=
 =?us-ascii?Q?oOhPehm/jSGxjJz8HBH260QO4wZDgQrxqj6tUaascxPZWYQxdDFCP+1ujobL?=
 =?us-ascii?Q?yM4tPQYMLKqkBUFMscH9Osoqyj+/qc5u3oRGVKwoqcLPAXTu7aGKJ0kKYSqg?=
 =?us-ascii?Q?oe83h8g4h8wnf2jqRv9+zrjxYtrDkFS2dDtiiO5UFckbEdwVKFeuo8GTziJu?=
 =?us-ascii?Q?rkoXG4TCN+dnWuNnXkoA6RjRqwXAGLjpNM0DphNySqvYSzp+tvBZ2UgbDAZj?=
 =?us-ascii?Q?lP3p/2L0VTFy4k/69jp5H8bnPvh1WjlZhgL84PU5csZA/D4UdHUjFtwHRT32?=
 =?us-ascii?Q?dFP+Kyxx9pl2fsdi0FuF22VkyzckTP96mzlbvrKOMkVwZeyCFka679VoD0cn?=
 =?us-ascii?Q?yJvvccGT9j2JO9hbLAY7f5GGt2UfokcDNpR11RzT2MIXD1j5JPvs3XvPyWix?=
 =?us-ascii?Q?dsGBin8KYjMo9mz804E1gLgS/QDvQcubAZ0C9T99VtO2TobOSGhr2q0t6sKb?=
 =?us-ascii?Q?u3kLSi2E/fh/tI05vH2twyTCWSAxJ1BfupSJjy1ZBpQWUyWQUgPuyvwEPbRy?=
 =?us-ascii?Q?P9NvR520OKRfRGBhSq7OfuqK/UBoJMsnVI0KtdQTRupjwlhzSYppB/tvnmiZ?=
 =?us-ascii?Q?QwcIG+ffgrixzc0pK9fbt+lNPw8rHRJiQq4iMTBvWjnpI2TEYcXGwKJNwhJB?=
 =?us-ascii?Q?eje1EZ3sD/BixdoL24GYNbHs4dhY9NPdwXcNNFwQTU3Fl4DN23JVaATLunRj?=
 =?us-ascii?Q?PhFFYkpLaK987CrXs2FX/IAETvnPJol0OxF94e9MrGaKVTJBx0FzE9TWJ4Fy?=
 =?us-ascii?Q?9PXYkIPTlwMkel9L9fKpgioow7E6LiiE2ToB0w7FtLpAigoxf8sQTj6CulzJ?=
 =?us-ascii?Q?qnDgoOgb1l/ytrjDD9xKi2C7VSGaSdY9cETUlpjpKs2zMDofupId2tYWhLBV?=
 =?us-ascii?Q?rbcEiJSY6qV6DP0MBtbeYr11fvvRs+XmRcwX1CSj1GKeG+RxQ+SoWiD7bonU?=
 =?us-ascii?Q?A7GxZGLxEXxT3cCh/kuwQsI9PvMRSvgTicV8StmwAuoQ4jI5xy/47QKKggI1?=
 =?us-ascii?Q?Ndu7qKThFzUKYUsWdDGw3KVbjEXmEz0Sf6Hx0VSe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bcee96d-6a4a-414f-f3e3-08da6f98a2a6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 06:24:18.1689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zrhua6KWkhPP0CmBHlbcDHzsqkQJ1JZn6iNQ1uwoZipfnpa40pP4AnxA3C/aQys5jVdz3wVIxSiWPy7YH7dg+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243
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

Lay the groundwork for Spectrum-2 support. On Spectrum-2, the packets get
the time stamps from the CQE, which means that the time stamp is attached
to its packet.

Configure MTPTPT to set which message types should arrive under which
PTP trap. PTP0 will be used for event message types, which means that
the packets require time stamp. PTP1 will be used for other packets.

Note that in Spectrum-2, all packets contain time stamp by default. The two
types of traps (PTP0, PTP1) will be used to separate between PTP_EVENT
traps and PTP_GENERAL traps, so then the driver will fill the time stamp as
part of the SKB only for event message types.

Later the driver will enable the traps using 'MTPCPC.ptp_trap_en' bit.
Then, PTP packets start arriving through the PTP traps.

Currently, the structure 'mlxsw_sp2_ptp_state' contains only the common
structure, the next patches will extend it.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 44 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    | 17 ++++---
 2 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index ec6d046a1f2b..04110a12c855 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -39,6 +39,10 @@ struct mlxsw_sp1_ptp_state {
 	u32 gc_cycle;
 };
 
+struct mlxsw_sp2_ptp_state {
+	struct mlxsw_sp_ptp_state common;
+};
+
 struct mlxsw_sp1_ptp_key {
 	u16 local_port;
 	u8 message_type;
@@ -85,6 +89,13 @@ mlxsw_sp1_ptp_state(struct mlxsw_sp *mlxsw_sp)
 			    common);
 }
 
+static struct mlxsw_sp2_ptp_state *
+mlxsw_sp2_ptp_state(struct mlxsw_sp *mlxsw_sp)
+{
+	return container_of(mlxsw_sp->ptp_state, struct mlxsw_sp2_ptp_state,
+			    common);
+}
+
 static struct mlxsw_sp1_ptp_clock *
 mlxsw_sp1_ptp_clock(struct ptp_clock_info *ptp)
 {
@@ -1194,3 +1205,36 @@ void mlxsw_sp1_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 		*data++ = *(u64 *)(stats + offset);
 	}
 }
+
+struct mlxsw_sp_ptp_state *mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp2_ptp_state *ptp_state;
+	int err;
+
+	ptp_state = kzalloc(sizeof(*ptp_state), GFP_KERNEL);
+	if (!ptp_state)
+		return ERR_PTR(-ENOMEM);
+
+	ptp_state->common.mlxsw_sp = mlxsw_sp;
+
+	err = mlxsw_sp_ptp_traps_set(mlxsw_sp);
+	if (err)
+		goto err_ptp_traps_set;
+
+	return &ptp_state->common;
+
+err_ptp_traps_set:
+	kfree(ptp_state);
+	return ERR_PTR(err);
+}
+
+void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state_common)
+{
+	struct mlxsw_sp *mlxsw_sp = ptp_state_common->mlxsw_sp;
+	struct mlxsw_sp2_ptp_state *ptp_state;
+
+	ptp_state = mlxsw_sp2_ptp_state(mlxsw_sp);
+
+	mlxsw_sp_ptp_traps_unset(mlxsw_sp);
+	kfree(ptp_state);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index c06cd1384bca..87afc96a0ed6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -57,6 +57,9 @@ void mlxsw_sp1_get_stats_strings(u8 **p);
 void mlxsw_sp1_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 			 u64 *data, int data_index);
 
+struct mlxsw_sp_ptp_state *mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp);
+
+void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state);
 #else
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -136,25 +139,25 @@ static inline void mlxsw_sp1_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 				       u64 *data, int data_index)
 {
 }
-#endif
 
-static inline struct mlxsw_sp_ptp_clock *
-mlxsw_sp2_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
+static inline struct mlxsw_sp_ptp_state *
+mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp)
 {
 	return NULL;
 }
 
-static inline void mlxsw_sp2_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
+static inline void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
 {
 }
+#endif
 
-static inline struct mlxsw_sp_ptp_state *
-mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp)
+static inline struct mlxsw_sp_ptp_clock *
+mlxsw_sp2_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
 {
 	return NULL;
 }
 
-static inline void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
+static inline void mlxsw_sp2_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
 {
 }
 
-- 
2.36.1

