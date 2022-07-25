Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FE658014C
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbiGYPMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235903AbiGYPLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:31 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD3118B02;
        Mon, 25 Jul 2022 08:11:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1aXeKK+OEI2MX3R4MaAPnhDVgVdVXKc7UT2GqV4kN58FZbyRZS/8rw5bjGksBEM+vGh7y7xOK2gTRt515c9NewxuZVlHeBXpYUda1hjbDzoPwsZiBbASucGG10L+j0Mvzg68/Dn6uDp03tJyX4pDIq1QqWEpSmdUq+5QV876BNsJ584IfaU+alW1fgD/aIBOwfTAMng3ntBUOl/gehJ98h0G+fHCD0UwafCdqzCyWJJbVCLOsERincoyDlpbtBdb0EQzpx8cTv4B9rz2vwgGxjCyFBOJFaDYlS6fW2bmc/GuJbJ7wGpUNu8eBK0TZVjxG9TZLOZ6NhhCvDXsRN51w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SznJCZz/d+YA540zG7OQsPSH+/Hg9BUbTQsrOiHr36M=;
 b=lLa4nvgJC4zCPqWJxqAWFircrlws4c5+8UnzcA9G1qkOFroMRt8EHJSqwCVzLtIdVPRwM7TBjhEUs2BTm4ger59xfexnPZ5GPUxDvtvuNXb3ifh1S78nPsnV6kY27aLOFrU/DgXyXEIDONlqolknRXvEnVBX7ORG+HZXLfjYZJqWX+0CEOKjDYibL3a6VyfwGujo8Cq9H4/bL75cr/Dm3sVG/kcVafP4oC04tF+WZYp4mjVE/Zf5ttbPU85Zo/Ynvnio5MPOYHAbKx0PMpk6zMc7XhBXZ5hMQKVcLb3xA5bMfD/0so2rPjmIdsIJcQ3d2dkfodPP/tJWGSpn7ap09Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SznJCZz/d+YA540zG7OQsPSH+/Hg9BUbTQsrOiHr36M=;
 b=AjF+Yrqs1ZuaRW4J9NWILxAO/t5HCSb/d95BemKls4X9FUkCXTeO9Cl0N3NMl8IsRGV5fWGDO9rGd9uq8MJtqIK4osgnIh8lC5DiwxXK5cr7z1SX7+yfk6ace7QMkuhe9Vj9qarkJ+/UeM9HFQyDV93yJu0yE7gGlmB/Ab9whQPP4DGZbiati5PcQ5XDic53xIGEYqNgFZKHbHPfdx4jgq8TOnarSra5rq09ZKYbQceDJpwoDO0pI+bZLcKFU1FhRpg9cXZjrFanXpjo/6mNw5KU5InWXYxZuFjycYT1KfHBXrxW5AMTEGnDP4vQU3J9IEpmp26sHgbEPkxwZmWKcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7817.eurprd03.prod.outlook.com (2603:10a6:20b:415::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:11:24 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:24 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 14/25] net: fman: Inline several functions into initialization
Date:   Mon, 25 Jul 2022 11:10:28 -0400
Message-Id: <20220725151039.2581576-15-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 976ce7dd-774e-4369-892e-08da6e4ff03c
X-MS-TrafficTypeDiagnostic: AM9PR03MB7817:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VHwZbHfhkZ/hPJlyxLOagi0cFmtFA3Taf8cOZRXKaNXwwdYsVuBbJLRUjp7PlETTKSFXvC+u6VREtI/EkYCa1F5MNgGergvOg2Iohs2r9hhEFDsQLlmAXDqPTTw42+/kRHoxB2auQ7Vq6IjOA4aBrpCdoVo9kKfnV8SJSJj+nE+z1OyJaocseNixPqf8XvZ+tZHc5UdQl679+4EM2L5vOq+AqgiGu/5U6AmZGpIEMR464c7YXnhQhG39XzLc4R44UedZzddjHNW/Cj9Fkx30qDPPPHKMZ9yXY8eW9g/V9J9rUeIrJxj1lpYSeOVLpZehy4jMo8lMWroHhuQ9SZtcI1Bz9LhQngJfjzMjPRt4ubXA58uWdWfZGA3YaEFq5DCqovQV+nYg7VND/kfOVgijGYf3421/noecFp2wSF72syKEAuiNeSucjbP94gSRzSwVFHdSntT7bvhtLBs6SsNn1WndNm411bM30A4ODrpY7SfRDQv/DMMXezSDLFGjaxymvXe0Cyd3IFpjPFLLxbbusOVtj7EUX4VM2mxTAr9xjIqZvUPoKQrNli/H07flMXF36m53kSW5oGX4PpUAKYGrr1cKnzEseJZzgDVLN2EPPW2ka00ZLrX3Om2IFWp5L6T1PpQfrt7hgps+adHeJtvszJryAXj5DdYz0k3+p9bcGNCfm5ZWEUtrGneVccVyg1ZtYV0wgq5LXiG8/Z6QqlePcKThgdeky4Qg6Z2IcV7bCLgSf97xFxDE02GkMdRV7vlnw5TopZE9znkT+rd6CV4dBfWkjHt2aUoMHItop7zFBoM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(107886003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uwi8CfWgr4Y4J2pubjqsSHAXvDnFpxhnicSv6Wt08zZlje0c/Wz5AMABSk24?=
 =?us-ascii?Q?K62IX+CDaU3Xf3rp7fw6+EKCk1vtNtYWrrXCMAiZQ+oSyjic5zV+bsCsAUw/?=
 =?us-ascii?Q?r10gFSaNLbC+UQVYrhv8biMR62bHWp4/uudwvacm+GADCXkYGiCufi40nWJb?=
 =?us-ascii?Q?YEMsCIShreqfmh72TH4Bbv1bUnKiOzT5pOze1wMJdwpj5KGBQsUSxjw+Bbto?=
 =?us-ascii?Q?x92LJaWfZivk2G24doT8Ipt7Z1SiYNUw4lvyjrnvx6GXFLgd3JuYJz9MWQ81?=
 =?us-ascii?Q?0p2gLhIyIlS5ghXdBEw9CyKhfKhjjA8cF7xEYk7+bLEyTDD2XbidSY609/pK?=
 =?us-ascii?Q?6JGt2599BU0c+wshkTN48BpMFdtKROPJ7pfrN3POA3qLodaXUVhCcfqG0L0g?=
 =?us-ascii?Q?/nf5tSvWUFVE3AFZkB2q0qtmKNwSWg33Txvss2wbrygF6S0I1zw6CwT86Dj3?=
 =?us-ascii?Q?UDPfZyM4UcPH7sbdCS+8QH9sMYgYEMd3DsN7bGOUuA4T3VEQdue5DNL6CMu0?=
 =?us-ascii?Q?7XuSqXdn6UoDz2hbqvbmHQlq99N+xjoiQnXmm/elHcuvHkwYccFQvaGB4+IY?=
 =?us-ascii?Q?Qz5Js5zjDPzwL+N7sA6Aas8T0YSjr1+pH3eeALt8ySTbPB2N6eRyOCp4VQvE?=
 =?us-ascii?Q?hhi7uGlWwxcFlS9vUHfzOkj5M6BFYGgpjFnAQ/IHFqN70+Nrh02sE6VMGCoj?=
 =?us-ascii?Q?iSaizCs25H3PJmreGtoTiMs3Ae8w1z2uMa5R9SdsidRwL+7C9RN2TI+5ABtR?=
 =?us-ascii?Q?OhByXsFQYlM/X7+w+YzaBqwDbo4e7aJkdNcV9r/bgcnpElaCBo+yFYYKZwHo?=
 =?us-ascii?Q?3W1pyHZ9R6DNjUTjsH9/32fSBTK2rfaQ24AkGEFJ5ku7GO9MwKk5iCB3NBmj?=
 =?us-ascii?Q?w4bqibXahGg/qGROwmU5c5g8KqEBnL++AWF+u3iuUZGeDDgt80FKnfYtXxYx?=
 =?us-ascii?Q?FihaVOuse0pTNAwQyLhg2DFN9T3vi8Q4ZnCe5WXIjawB/rLOjnZSWjOBWHea?=
 =?us-ascii?Q?hMut5g+pd+38wTD0+ym74Ih9Y2MESgAOvwPtMZEF20eDHWd03UCIhcw/k6Dq?=
 =?us-ascii?Q?WTJhhP2A3Dnmd0uWGNq68LNcIsR4BsOmwdxvxvZz53/rD9sX+0hVUqNlKujs?=
 =?us-ascii?Q?U0A75DfHs+AL+EQiiwoeVwqCLdUfcj0e9a9GU3txz5z+wIMYWZt+4PT5pRAv?=
 =?us-ascii?Q?nO6d5VaOggeaQ6npWn8AZgPPBIbyKrNSOrPXwZv8w8EiCVkLyz0+Pra9/0Mi?=
 =?us-ascii?Q?laJFs0uf+EvGid7zpIU8i7ZIqpsqhd9ECDrd0zgcbvrpzNWHWadmf5RgLFiZ?=
 =?us-ascii?Q?jWHXkTQTjEoBHTmp19NmIlekKCtcJMyVQq9qULcoJZrnVtVHXVJ/Wxrhu3XX?=
 =?us-ascii?Q?/lXZvR9zB5eKMR8w5/prWA2ieAV2ADmxU4yZtNafNSMjDlBb8FRvdKI/rfkS?=
 =?us-ascii?Q?9tthEDU8/nvLIm5El1Vlv3GdS0zqpsOj9HBbq1lVBTk20mVmNDus8NYGDwF2?=
 =?us-ascii?Q?MxGkX2C/PSpUoRvkuKGjIia8saQnDGcq4GmbSCQUaCisLKvFVpIeLH7H9gK/?=
 =?us-ascii?Q?cAiBq6gn1jAkEV300xJesI2BbhDh0GgEc70EZ6wQSg4uBLhZkpATkXWoIoYH?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 976ce7dd-774e-4369-892e-08da6e4ff03c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:24.0504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+7mcZUOBKf5lEY4ikzyKwSd8x0/FCQCrtPQLz7aQKepTJS4ky2Pca/dqhA76GGS3ggJdVoGZbSPLH6W6So9lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7817
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several small functions which were only necessary because the
initialization functions didn't have access to the mac private data. Now
that they do, just do things directly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v4:
- weer -> were

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 59 +++----------------
 .../net/ethernet/freescale/fman/fman_memac.c  | 47 ++-------------
 .../net/ethernet/freescale/fman/fman_tgec.c   | 43 +++-----------
 3 files changed, 21 insertions(+), 128 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 6991586165d7..84205be3a817 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -814,26 +814,6 @@ static void free_init_resources(struct fman_mac *dtsec)
 	dtsec->unicast_addr_hash = NULL;
 }
 
-static int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val)
-{
-	if (is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	dtsec->dtsec_drv_param->maximum_frame = new_val;
-
-	return 0;
-}
-
-static int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val)
-{
-	if (is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	dtsec->dtsec_drv_param->tx_pad_crc = new_val;
-
-	return 0;
-}
-
 static void graceful_start(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
@@ -1274,18 +1254,6 @@ static void adjust_link_dtsec(struct mac_device *mac_dev)
 			err);
 }
 
-static int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
-{
-	struct dtsec_regs __iomem *regs = dtsec->regs;
-
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	*mac_version = ioread32be(&regs->tsec_id);
-
-	return 0;
-}
-
 static int dtsec_set_exception(struct fman_mac *dtsec,
 			       enum fman_mac_exceptions exception, bool enable)
 {
@@ -1525,7 +1493,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 {
 	int			err;
 	struct fman_mac_params	params;
-	u32			version;
+	struct fman_mac		*dtsec;
 
 	mac_dev->set_promisc		= dtsec_set_promiscuous;
 	mac_dev->change_addr		= dtsec_modify_mac_address;
@@ -1552,34 +1520,25 @@ int dtsec_initialization(struct mac_device *mac_dev,
 		goto _return;
 	}
 
-	err = dtsec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_cfg_pad_and_crc(mac_dev->fman_mac, true);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_init(mac_dev->fman_mac);
+	dtsec = mac_dev->fman_mac;
+	dtsec->dtsec_drv_param->maximum_frame = fman_get_max_frm();
+	dtsec->dtsec_drv_param->tx_pad_crc = true;
+	err = dtsec_init(dtsec);
 	if (err < 0)
 		goto _return_fm_mac_free;
 
 	/* For 1G MAC, disable by default the MIB counters overflow interrupt */
-	err = mac_dev->set_exception(mac_dev->fman_mac,
-				     FM_MAC_EX_1G_RX_MIB_CNT_OVFL, false);
+	err = dtsec_set_exception(dtsec, FM_MAC_EX_1G_RX_MIB_CNT_OVFL, false);
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	err = dtsec_get_version(mac_dev->fman_mac, &version);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	dev_info(mac_dev->dev, "FMan dTSEC version: 0x%08x\n", version);
+	dev_info(mac_dev->dev, "FMan dTSEC version: 0x%08x\n",
+		 ioread32be(&dtsec->regs->tsec_id));
 
 	goto _return;
 
 _return_fm_mac_free:
-	dtsec_free(mac_dev->fman_mac);
+	dtsec_free(dtsec);
 
 _return:
 	return err;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index d3f4c3ec58c5..039f71e31efc 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -792,37 +792,6 @@ static void adjust_link_memac(struct mac_device *mac_dev)
 			err);
 }
 
-static int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
-{
-	if (is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
-	memac->memac_drv_param->max_frame_length = new_val;
-
-	return 0;
-}
-
-static int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable)
-{
-	if (is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
-	memac->memac_drv_param->reset_on_init = enable;
-
-	return 0;
-}
-
-static int memac_cfg_fixed_link(struct fman_mac *memac,
-				struct fixed_phy_status *fixed_link)
-{
-	if (is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
-	memac->memac_drv_param->fixed_link = fixed_link;
-
-	return 0;
-}
-
 static int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
 				     u16 pause_time, u16 thresh_time)
 {
@@ -1206,6 +1175,7 @@ int memac_initialization(struct mac_device *mac_dev,
 	int			 err;
 	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
+	struct fman_mac		*memac;
 
 	mac_dev->set_promisc		= memac_set_promiscuous;
 	mac_dev->change_addr		= memac_modify_mac_address;
@@ -1235,13 +1205,9 @@ int memac_initialization(struct mac_device *mac_dev,
 		goto _return;
 	}
 
-	err = memac_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = memac_cfg_reset_on_init(mac_dev->fman_mac, true);
-	if (err < 0)
-		goto _return_fm_mac_free;
+	memac = mac_dev->fman_mac;
+	memac->memac_drv_param->max_frame_length = fman_get_max_frm();
+	memac->memac_drv_param->reset_on_init = true;
 
 	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
 		struct phy_device *phy;
@@ -1271,10 +1237,7 @@ int memac_initialization(struct mac_device *mac_dev,
 		fixed_link->asym_pause = phy->asym_pause;
 
 		put_device(&phy->mdio.dev);
-
-		err = memac_cfg_fixed_link(mac_dev->fman_mac, fixed_link);
-		if (err < 0)
-			goto _return_fixed_link_free;
+		memac->memac_drv_param->fixed_link = fixed_link;
 	}
 
 	err = memac_init(mac_dev->fman_mac);
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index ca0e00386c66..32ee1674ff2f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -441,16 +441,6 @@ static int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
 	return 0;
 }
 
-static int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val)
-{
-	if (is_init_done(tgec->cfg))
-		return -EINVAL;
-
-	tgec->cfg->max_frame_length = new_val;
-
-	return 0;
-}
-
 static int tgec_set_tx_pause_frames(struct fman_mac *tgec,
 				    u8 __maybe_unused priority, u16 pause_time,
 				    u16 __maybe_unused thresh_time)
@@ -618,18 +608,6 @@ static void adjust_link_void(struct mac_device *mac_dev)
 {
 }
 
-static int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
-{
-	struct tgec_regs __iomem *regs = tgec->regs;
-
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
-	*mac_version = ioread32be(&regs->tgec_id);
-
-	return 0;
-}
-
 static int tgec_set_exception(struct fman_mac *tgec,
 			      enum fman_mac_exceptions exception, bool enable)
 {
@@ -809,7 +787,7 @@ int tgec_initialization(struct mac_device *mac_dev,
 {
 	int err;
 	struct fman_mac_params	params;
-	u32			version;
+	struct fman_mac		*tgec;
 
 	mac_dev->set_promisc		= tgec_set_promiscuous;
 	mac_dev->change_addr		= tgec_modify_mac_address;
@@ -835,26 +813,19 @@ int tgec_initialization(struct mac_device *mac_dev,
 		goto _return;
 	}
 
-	err = tgec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = tgec_init(mac_dev->fman_mac);
+	tgec = mac_dev->fman_mac;
+	tgec->cfg->max_frame_length = fman_get_max_frm();
+	err = tgec_init(tgec);
 	if (err < 0)
 		goto _return_fm_mac_free;
 
 	/* For 10G MAC, disable Tx ECC exception */
-	err = mac_dev->set_exception(mac_dev->fman_mac,
-				     FM_MAC_EX_10G_TX_ECC_ER, false);
+	err = tgec_set_exception(tgec, FM_MAC_EX_10G_TX_ECC_ER, false);
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	err = tgec_get_version(mac_dev->fman_mac, &version);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	pr_info("FMan XGEC version: 0x%08x\n", version);
-
+	pr_info("FMan XGEC version: 0x%08x\n",
+		ioread32be(&tgec->regs->tgec_id));
 	goto _return;
 
 _return_fm_mac_free:
-- 
2.35.1.1320.gc452695387.dirty

