Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1904582006
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiG0GY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiG0GY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:24:26 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3664D2AE13
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:24:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/++gZLqDqbi+N/qVfPuWwmHdK3xUN2pgWXrd9yHJEwoz8bMrtGep9E+Vts8AM6VSAFqj59M988B3NgWFztlQnLDbiCXQpi2+4BBfN5iEIEeDcoRA7V5lhvV0E6qyMs/FP/5WsjmbVPps5qcSt5rdQSJZhQPHVtxO/TwuybtQqvFkI2dGlFOPEVRHV5Whb3+wZUxZqduyC9jP4qa5cTgivlX0sSMJUFEBxFZeAXqLMGWNTWeavQXOKZSs6JCLkBVL1Qn6glrfumlxebMZ5s3JccO+6MIf2CxyjRf/xlaGkYCq/PR2ao8ydGNvlJjsbVtRalbdlLP50t53uoJ2P7kTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RArVaTj2T/RvpDCPdXKeZmMnJwg9CY78oK2bG5wipr4=;
 b=l98AJgWAsR4lOxo7TIvFBfTcEeTW6UnxXzth0XIszsCxRWKUqRLtx0FHe3Q17g4MHCrDYSIxM6lEyxg5SzRDcIpZbqlNjISMU+DoFjsnbdY3aYZaYKi18AL/3NKhD/UF95v4yxB2AIdf8BRAxdkFCi3jadatMCzWqIAehY75/uAvvgQb+MQ8elJCneiSmwei5RWL1KefZzKWtHihcjK1sXC9qoLGDzcatw1eOS0UEy+MSlYPhdjsvsLUGCMz4vRjBUwKEcb1XqRHHQCsTEweE/kwV0gN/XnU5hvLp8T03x3HSOaj2FoSJHj6OgR59LPehfLnTOrKhEEYeqiirhHQeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RArVaTj2T/RvpDCPdXKeZmMnJwg9CY78oK2bG5wipr4=;
 b=s/mmZE7PDpodU5MqHbtFVvU5BGV8VdbbzImz7vMouNIXT6Y8aLh/kSZdgg91qQS+qD7O0DkTyCduDfiukbBEGz+e0kzeoMeu0RvJV+Eb1dhikQ83pYXt/XCWBWrVcsw+YC6qHSHS0uUzFD+WYRo/NPL9LgD9v0blTqMX5V3RZ4qgjgrvjSVcrOf37MMAMqW3BkPW7QDzVtYjivbK9oPQpDO19+MTphw/JTWByhTnQCsBPB/6yb57ogEWyUzYXn0JAvbJZc8irVk67ecXTxZv2Yu2ssq3DyexDFtrEtE/T341tCjJJea60qWJ58PYrBu05TM8L90NmaSG/ML65Li28g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 27 Jul
 2022 06:24:23 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 06:24:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, richardcochran@gmail.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/9] mlxsw: Query UTC sec and nsec PCI offsets and values
Date:   Wed, 27 Jul 2022 09:23:23 +0300
Message-Id: <20220727062328.3134613-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727062328.3134613-1-idosch@nvidia.com>
References: <20220727062328.3134613-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0191.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9be41528-ce75-4948-0a84-08da6f98a5d2
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6243:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 68+GwMwMjk9R/OuOkPuD+lG0y0jTjLU/grMe3YlA2d2fWY7x/wIC7nVfOeCE/OHzGMBBpOLs2+wVSW0tRol0RaX9F3yIHgl9/k6eYjuoZTJavGybbNV/oqimiyjPljNoWhjBMHppmCfI5NxR1pKVjxfQWPZMP8bwoQPfWQ+WgdcgMeDqJYWHjsZYIJyIXWmgd10x+Ls2MMPSh2sXGRQvx20z1jiM+PSV8FxrH6cL0NK6JqaPpK/KiFkKl8lbHMGfzz2s8+DLFheh682HpYHeaVZ7acxq1l+IeEO9onOnnJAIN3Gk/GVXVhGHT7kpoTjmHlHOuB5ukdgQ5MpLQ3x5l9A+77omDhu06b/Y9U33iQ8NytHHpYYSppfxHbBzV/fU9zngBmCVnbx1ARh9OdD0O6x9RRxEa3O+t/oG1do/lIy08xrhotBrZG+5ExEAg20gKtb0CI01MJmFk+bU5BVFQTUunyjwQJ3RmQxo2BwXuggp27+ta3uxoSvLxy681bwCUrukXgGUGlSQBpmkDFQ4chr7j4sqd0EKI5S/Xm+lSq6myrDLgyMHNYpTkq/9U3LFE+jqYWTjqexRR0n2QntZixRfhXXeJCof5hGRXQ/Z+dWyagIscu2eyCYGARY9NotnqfxKuENhfzK7j/f+XY4Za49kJm+DXnnWrXYGFWVrYqLy+HZMIGzBrC1uQQlS+HxQqraU50yQm5r9sSZ7lumiA0A5SZ8daZ2f2JQLK/1uGCsHxUFoME/8izXrl/njmDl/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(41300700001)(66476007)(38100700002)(6486002)(2616005)(66946007)(1076003)(107886003)(478600001)(6506007)(186003)(8676002)(83380400001)(26005)(6916009)(8936002)(2906002)(5660300002)(316002)(86362001)(4326008)(36756003)(6512007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?izPMZOBOcr0PUS+OIdJzHORLnB5F50xJvMYEtKxZNXxuI600uni076XruTXl?=
 =?us-ascii?Q?6WlCurmE379AZ50OO5/l6w6q4P4AAdIL8rqSeE6FMp5J79gL2wGLRylYyO9+?=
 =?us-ascii?Q?//iosjI1XedsUmHFoYGfNJXxe4Yh/KBkmzX2wLtYQitLwlawvZafLlfOaCvf?=
 =?us-ascii?Q?ThDzbwHEE/r4y0kxAvc8rD8Xs0jldNWZz4OSw4dTudJvsSrUV0o1GxwlV4DV?=
 =?us-ascii?Q?Rbr6tk6z0cu0U6rtqHI98Qz5he6DSiLH1Q3K8qViEV0864GsIqrK0KbnGCre?=
 =?us-ascii?Q?fugDYV1oEusTK1zt/ithhZtXU4CGDJyzzHRVPfEeEAn62skC1qi+KwpO82ci?=
 =?us-ascii?Q?aF2z0iQB+e8XxvTPoMdr1jsCM+s8Sg/qhgq1b6VY9CoWWzTD2FYLdkXfoaWo?=
 =?us-ascii?Q?cctoeSCE90cnLBvfxw5pXUT7/IniTa2azUMpOHXUkz2ALeZS1rlNg/pNb2bh?=
 =?us-ascii?Q?ua+T3/YFbd9rO1VDQUFy/mZVnLIEgRvAwRc3Xgp3O3nQE1Rr9KnYTHvGQu6y?=
 =?us-ascii?Q?STq7TwZv0eKi/VFrYsN4BhCSrzjkFTNk13prlOJOY848vrQbanHTofDHupSc?=
 =?us-ascii?Q?udSIUj0Yr+3+isqZcviXWijRhQmKQSo33VyXEeG3N7AcQcMOVOvD8CdyNfDf?=
 =?us-ascii?Q?SAhvTYDOh3YAW4fDSPyJuptsAbYwUsAapCpdtn7DE6lbNer0POL5nhpZgpZE?=
 =?us-ascii?Q?z61FQ+QhqPTj7tnpXR6d+c4dWifD1RStxlQJeIB4/SzsXR0PYZ3Sv076JKmI?=
 =?us-ascii?Q?aapHZNSEHedGCVn5cJnxJgbqTESM+o/m1rRR91kNSzU+okqDPR7hm8xuAUjs?=
 =?us-ascii?Q?ZkEapXSY6G5gySMgL/8EWSGqsP6PWt0cIxtRt8jw2UuOdgOdIX30OxFybxzJ?=
 =?us-ascii?Q?qyW5n2EGGdmcY10JbYzYi5OeczJI277lIE6uBiAGfM91RQhuUJzBc3f1qU4j?=
 =?us-ascii?Q?Na4y8KGD+UV37S5Ecp4IySb0/gZ2sl6LpmWPtK/0En98KtvUsB6KwMYPzgRC?=
 =?us-ascii?Q?c7pGelmb0eE3d0WxM2Ik1ZepfjuCT0YDJ8ZAO4rEILg+iXX1oGkcMJSGe0bV?=
 =?us-ascii?Q?eit8eLAEUt1YuyPOUCDbiGiLzplcAxkaq7Trz213YwycXj1MtkTdy1rVSaTw?=
 =?us-ascii?Q?Qrh1Hj0L0andALqblBuBZMj+JWfT+kS6RmDLWbagXJMsql13JlUFzcQe0UJR?=
 =?us-ascii?Q?jrWUp7lGsJRFtjsVlo+VQ5XXH6a7fPPs1SVGXoGw0YIIkzKVGS3Dwv1wtvJE?=
 =?us-ascii?Q?aILwNoKl4ggzFRCtouZ9cu88pOusq7Uq4OUlRNaLUV81QrcJvIztVbR9eCeV?=
 =?us-ascii?Q?63jHpXZbCZj1C8AVp/GpHYCsVROl8g1VhZ48Vy1MoRxapkuuLs5I5x7atMpE?=
 =?us-ascii?Q?d3WuIhfHM8wDRSJ0WD47pgKPDYYI58Pp6lRF0VGGK2ksiVAAbmGVjvdqn5W3?=
 =?us-ascii?Q?bl2aS3oTE49QRXNjgr5ZAZ3kTeg2gbfwv5j9L3h41jtrzQEYXYvB8+PE+hlB?=
 =?us-ascii?Q?zKL8SbFGoGqJVkwIEy5vLQHSyM4dbVWHPaHcc+vIB6HnPMazhxCJTBpGGFAI?=
 =?us-ascii?Q?Sb5Y8KvjCefSivSe5l7H1F3tDKaB0/orMdif4LDu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be41528-ce75-4948-0a84-08da6f98a5d2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 06:24:23.5782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Asrp0CD6AOCHQvX5QB1a9EaJiWUwQzQpnR1B6F0W5xI8IuVXI0TbU0WDFU12Sae3UnZHAvfl5TfjLiZtoG1Xqg==
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

Query UTC sec and nsec PCI offsets during the pci_init(), to be able to
read UTC time later.

Implement functions to read UTC seconds and nanoseconds from the offset
which was read as part of initialization.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 12 +++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h |  5 +++
 drivers/net/ethernet/mellanox/mlxsw/pci.c  | 38 ++++++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index aef396128b0f..7c93bd04a3a1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -3335,6 +3335,18 @@ u32 mlxsw_core_read_frc_l(struct mlxsw_core *mlxsw_core)
 }
 EXPORT_SYMBOL(mlxsw_core_read_frc_l);
 
+u32 mlxsw_core_read_utc_sec(struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->bus->read_utc_sec(mlxsw_core->bus_priv);
+}
+EXPORT_SYMBOL(mlxsw_core_read_utc_sec);
+
+u32 mlxsw_core_read_utc_nsec(struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->bus->read_utc_nsec(mlxsw_core->bus_priv);
+}
+EXPORT_SYMBOL(mlxsw_core_read_utc_nsec);
+
 bool mlxsw_core_sdq_supports_cqe_v2(struct mlxsw_core *mlxsw_core)
 {
 	return mlxsw_core->driver->sdq_supports_cqe_v2;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 6c332bb9b6eb..cfc365b65c1c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -438,6 +438,9 @@ int mlxsw_core_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
 u32 mlxsw_core_read_frc_h(struct mlxsw_core *mlxsw_core);
 u32 mlxsw_core_read_frc_l(struct mlxsw_core *mlxsw_core);
 
+u32 mlxsw_core_read_utc_sec(struct mlxsw_core *mlxsw_core);
+u32 mlxsw_core_read_utc_nsec(struct mlxsw_core *mlxsw_core);
+
 bool mlxsw_core_sdq_supports_cqe_v2(struct mlxsw_core *mlxsw_core);
 
 void mlxsw_core_emad_string_tlv_enable(struct mlxsw_core *mlxsw_core);
@@ -479,6 +482,8 @@ struct mlxsw_bus {
 			u8 *p_status);
 	u32 (*read_frc_h)(void *bus_priv);
 	u32 (*read_frc_l)(void *bus_priv);
+	u32 (*read_utc_sec)(void *bus_priv);
+	u32 (*read_utc_nsec)(void *bus_priv);
 	u8 features;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index f1cd56006e9c..0e4bd6315ea5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -103,6 +103,8 @@ struct mlxsw_pci {
 	struct pci_dev *pdev;
 	u8 __iomem *hw_addr;
 	u64 free_running_clock_offset;
+	u64 utc_sec_offset;
+	u64 utc_nsec_offset;
 	struct mlxsw_pci_queue_type_group queues[MLXSW_PCI_QUEUE_TYPE_COUNT];
 	u32 doorbell_offset;
 	struct mlxsw_core *core;
@@ -1537,6 +1539,24 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 	mlxsw_pci->free_running_clock_offset =
 		mlxsw_cmd_mbox_query_fw_free_running_clock_offset_get(mbox);
 
+	if (mlxsw_cmd_mbox_query_fw_utc_sec_bar_get(mbox) != 0) {
+		dev_err(&pdev->dev, "Unsupported UTC sec BAR queried from hw\n");
+		err = -EINVAL;
+		goto err_utc_sec_bar;
+	}
+
+	mlxsw_pci->utc_sec_offset =
+		mlxsw_cmd_mbox_query_fw_utc_sec_offset_get(mbox);
+
+	if (mlxsw_cmd_mbox_query_fw_utc_nsec_bar_get(mbox) != 0) {
+		dev_err(&pdev->dev, "Unsupported UTC nsec BAR queried from hw\n");
+		err = -EINVAL;
+		goto err_utc_nsec_bar;
+	}
+
+	mlxsw_pci->utc_nsec_offset =
+		mlxsw_cmd_mbox_query_fw_utc_nsec_offset_get(mbox);
+
 	num_pages = mlxsw_cmd_mbox_query_fw_fw_pages_get(mbox);
 	err = mlxsw_pci_fw_area_init(mlxsw_pci, mbox, num_pages);
 	if (err)
@@ -1601,6 +1621,8 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 err_boardinfo:
 	mlxsw_pci_fw_area_fini(mlxsw_pci);
 err_fw_area_init:
+err_utc_nsec_bar:
+err_utc_sec_bar:
 err_fr_rn_clk_bar:
 err_doorbell_page_bar:
 err_iface_rev:
@@ -1830,6 +1852,20 @@ static u32 mlxsw_pci_read_frc_l(void *bus_priv)
 	return mlxsw_pci_read32_off(mlxsw_pci, frc_offset_l);
 }
 
+static u32 mlxsw_pci_read_utc_sec(void *bus_priv)
+{
+	struct mlxsw_pci *mlxsw_pci = bus_priv;
+
+	return mlxsw_pci_read32_off(mlxsw_pci, mlxsw_pci->utc_sec_offset);
+}
+
+static u32 mlxsw_pci_read_utc_nsec(void *bus_priv)
+{
+	struct mlxsw_pci *mlxsw_pci = bus_priv;
+
+	return mlxsw_pci_read32_off(mlxsw_pci, mlxsw_pci->utc_nsec_offset);
+}
+
 static const struct mlxsw_bus mlxsw_pci_bus = {
 	.kind			= "pci",
 	.init			= mlxsw_pci_init,
@@ -1839,6 +1875,8 @@ static const struct mlxsw_bus mlxsw_pci_bus = {
 	.cmd_exec		= mlxsw_pci_cmd_exec,
 	.read_frc_h		= mlxsw_pci_read_frc_h,
 	.read_frc_l		= mlxsw_pci_read_frc_l,
+	.read_utc_sec		= mlxsw_pci_read_utc_sec,
+	.read_utc_nsec		= mlxsw_pci_read_utc_nsec,
 	.features		= MLXSW_BUS_F_TXRX | MLXSW_BUS_F_RESET,
 };
 
-- 
2.36.1

