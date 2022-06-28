Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CF555F10C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiF1WQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiF1WO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:59 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80079.outbound.protection.outlook.com [40.107.8.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CA73983A;
        Tue, 28 Jun 2022 15:14:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jAwLEUEfTSbH8JU4ihLEkQekyXlPq8sJ6Q25nIMKeZLb6uF5UG3wuktFbDseDjXCqfbDVhg3Bs62eGMzqoKFMooeBBhiusNBAG/CBSqSvaws6ZNsu46tOu4FcjxYL8lHQbL2baLe4tSn0HtoWQtsATWRzoanZTI6lvpWe0wt/40XbZZvrJrWy8K+zEXhVgJr2VsOOjTgcpaJngX5oAXZPRYRoGZHKQRNhwpexkc1XnwFKo+qa8RTenaqf0r1YGNdnVBul1iUbuQ5RUIqBhxki15vKAKC6XSZutpBhKv9By8jwqarL7+Z8xRRzveifOXvqqAKYhPTdhipQcI0uoxzGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qd7EzQyq3QvpjHXKrDtvYwf5S4MGKCtL3v+EBh//8M=;
 b=ZfA1FcCkjebnPlINNcDXyJrWkv8ZkeuuXaGG9xtTE2gsttyLtusbjUEvoiCA+eoi0JccsX3m/LxGKpa5cD70VkXYOeU2lGRicAND3Q3MMIYRsN316t8ULmgosQMoZRYpLljtauF8A26vsc49rh84FCcc+mTgQEpZfvpDtoXtVtxz4txEacW/61LFCMYHod6qGxurnebayXHkPMi3Payr6dfLa/2xe5ABN6E0H6nL93wGqvrEHZs2ooHxnbUs5xzqgvdvSn0u7Z7hCyTRCbKh6jSc8c+YiB2DuohfasezeCq1RVVAdQYI/rFT2V90NkZ2Ap3XQu2x8gS7bKAX1JM0sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qd7EzQyq3QvpjHXKrDtvYwf5S4MGKCtL3v+EBh//8M=;
 b=oaDnJWTmhpagtUoz/WLLALFipQYPUyPI+5RzcC5+gh5On4B1rZ901xgnwUjGLcKqIks4XT9kiDu838wTy9jFIvFLNFFtRWD8G7mvxJARHMqGUPTGYcow1t1sikUvGMBQUyhZp8KoJKn49NqZJjYd3RZHT3sBPXv+EIvhf5kuir+ZBhGtflAxpH1NDHf0i/LKYqdonA+5eVOCwSUiMjRdM8sZV5mZAQcVYj6mWXsVRlgp/L1zLHjN0EgUgaxCvhcDWOWjwb3E0+7WD1bK/lVVxsbgIDK71qk9cYiIrJVibKvOsSuTX4NJX89pfYcIBBTL85WNorq6c6sXooyK/3YVHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:46 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:46 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 17/35] net: fman: Inline several functions into initialization
Date:   Tue, 28 Jun 2022 18:13:46 -0400
Message-Id: <20220628221404.1444200-18-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6906e506-8fe0-4ed5-c38a-08da59539c1a
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fl8d2rVPLgx1Vc5Il0k5N8TsP44OozLpTOhqXJgPPjcwP40eRZq3afhAnu2HU3xQzYoy/zJmt9cTxsWLw8R+KyU/IDutbSF03wbEdWTbgVKhGBjdUuGqIy0zk6AeNqYAVepWfPe0X1gDL4ERlUcYE4usruNiYmd2N13Ki4E1YqUxhKD0mppGoIsUXxwvoAHXfOW+GUmcozrmqHMk/QVOjRhDIrDFekR1kzrBCN3P4YXTJNzs15lTOgUJPET3M/pkC2rVDicoRcgrFN806Wp6ej1d+1DXEJi9W12LEfHERhNU2rq0BQ+TDo6cqOCrSlA2y6zap75WTNXxwbuVXDsMbgGzwqopNIZDi2nKqDZ8iocAZ5vGdQOrtiyqh/3EdlrhuogNKKLdNNIjRhR9eKFnzP3q9QxJURk4N0YFdsfHRZQRWgKDkidJ5My/Dvz7z3g8Q4qpDJBXxXwTxiJ/zxv3RG3Ai9DyjNfIB8k5zsCSLtIznWrYlvHj+sYuj8yJq7eGOW/LBXOu4H5iGkbcUOYS/7RmcnqbgnhEVVSpLRE+SbL+lOD/iUCSPxr8xXzM9HbwaOIvJeQJbK5+r5xMPWYsNla2fSLI/HtwUKUOcOwamUv/zyiTF9ZO05tlSQ3Un+Nor6TYtJBXZrbXYS9idpX/zK5mcqQvcQKYzWsGe1UbPwYRZK//5wF+H51iTURxC6dlid8t2E6OHIloryJuY5MhDgZnPqYDJ1XL45mko6Ca9En0d1b8jWIgR/XbLOranOddBFGJID6zoDHX1C+ZaXvgjtIq4T5Rz9sPxh+K0wbgRTI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(44832011)(6512007)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(107886003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UUjt+MTxyA9T2/6vWzDWErDNY6FIVz2rRnly9JiCN76uoxlVFkzvPujfQ7yr?=
 =?us-ascii?Q?HhW/HqKbtQ/Jp4oGMyb6OFbyNXfDSlFeOSQ2PtOk58myzrNO8pIZuLO3afnO?=
 =?us-ascii?Q?3LaiJJBoQ+M/yog1uHuic1Fi9LuWVkxGZXwYINjN7m7t+Yqg60ufwdEt4MIL?=
 =?us-ascii?Q?n5yMCXW2sSEhmD55Ru0C/o9vzMWwfb1Qosq/L911hD9llbqftLBZpcFpeneD?=
 =?us-ascii?Q?+WyV7eWbJtULDB3zmIgM9PECx4jZmAPsWSLUCBwPl68N4O8IwAd9hQsLe46x?=
 =?us-ascii?Q?oHNVG+wCvH5X2f17bkBGBQR3kycF47ZKsWzls2A/QL7uB20GLLKRTOZHpGoR?=
 =?us-ascii?Q?EIkAWMXIozqfv1aciUZgtIgngqxAEcQkfPU9YAgkRdAFEJK6Sw52QfN/y5gW?=
 =?us-ascii?Q?ZFbMCCaXZhUTWZXYxwM3DJnmQdt3dtqcjgnaY+fG3s07XYnPdNQmeXLgY4mw?=
 =?us-ascii?Q?QW55zYZ8D8zBCoV243m3FfvgNrpdom0l+YBbdL43xzQ+Z6rfq3mBL1zIK+XG?=
 =?us-ascii?Q?28A7BrJ+ux2T5RztHLOGB4a8deoi6os7tblNHYoyYudDYPxV/ijKL+I8upzx?=
 =?us-ascii?Q?V32Hm0frLrNGx5x8GwL19/5oUAiHrA2rk8qV1XQUMKndLzq+mitksY7MOGaF?=
 =?us-ascii?Q?cqwIh96VYZI4XvJyGtNhIB03TWvq6RTxcuvH1ajNg6ihgebaouJzjlvFZwAu?=
 =?us-ascii?Q?2nbBy89zYVHFVxHp9zgucOXF00ROjCnnR3wYF23/AWJqFbZd//eqgnaq5vbo?=
 =?us-ascii?Q?2rQv76pHl3l0HkX3aQJwHPX7AFz8tTdrn14hqXt5IDyADvn2+x4jr3gMPKwx?=
 =?us-ascii?Q?HJ7bafw/j6y+PrHNQBAwihIopepw9/78+mzE/XAc/Mz1dkgMa/gKeBP+qoE3?=
 =?us-ascii?Q?ov/KK8etI5ZbRnlJC/oV7vBdNyvLmUd9uGlSkFfKFJX81GxGtxZNDTeGFtfO?=
 =?us-ascii?Q?dkXcmNt4ehTuFIXSsv7LfPwMu3D3STYPcZXf8KSK4el22akR6D7yKk63QRpo?=
 =?us-ascii?Q?eXS0a88EzjVOTMCoCwZbukT57bDxIpvk3aj41CKLeAXLYxaoMDys/+cTNVxr?=
 =?us-ascii?Q?Gbm+Vxxvr1UiphAG7MREDK1L6+uahkN1lHwIzXJ0xX04Oeb2ERTMkY6/I30X?=
 =?us-ascii?Q?GI0N9Ok15eAxL3AyrGOUExgg0CAvRQYRsAX28Tl03J1pw18loYV43QW507zg?=
 =?us-ascii?Q?TVAOEunurrE4Op/8czkzRh+v10Ln0VB852iRo7ke3sj3BNMUzaklZqkktJvo?=
 =?us-ascii?Q?lEaqS6mA8M9/FmqIrcd+84NtG2GV5hfzfZgRmXlTiNwO4cY7UGE2RUhuN3sU?=
 =?us-ascii?Q?887kCCYu238wesOEmIXmvse11jLTHpRDTFSh2Zn7Whh+2y/ntmZJDakRQxZz?=
 =?us-ascii?Q?yDdIjX9ykwhs5Nk1H5qKaDg4dGw3OyWGMZu7rVhxxhXY1C/qDpa4ozU6fjFb?=
 =?us-ascii?Q?1MCI9iC8yaX0Mk2L2EqAQfa5EeRnIaQGOrHk+iGXdvxYHoF47CFNoSvhE9HK?=
 =?us-ascii?Q?d3VHc6w52Wzkdy71j9PnV8rqRvypdp7oFvTGUDhXb3p9xQ7zv311V6ES0+KL?=
 =?us-ascii?Q?D49I+xnVvVzALFO0GSGWMFQNgQ4w5qWdM4kg1/776DEZ4420J6y5sww21P8T?=
 =?us-ascii?Q?AA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6906e506-8fe0-4ed5-c38a-08da59539c1a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:46.3597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Gzcl93Z9/8ki5vPUDK9rtnIMsS4Uyj7N9qNCMpcwi0fW2IWh7un26zzFZJFfo86HF/4FtR2DcfPF5DeCmztQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several small functions which weer only necessary because the
initialization functions didn't have access to the mac private data. Now
that they do, just do things directly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

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

