Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F68350E16E
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240736AbiDYNV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbiDYNV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:21:28 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10091.outbound.protection.outlook.com [40.107.1.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5A919C0C;
        Mon, 25 Apr 2022 06:18:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwrPcKbgG7C+FTlmlWYnh5qLtHo32j5RXMZWR+9M9V4RYzF2C702InKm9YOs6wvhsr7JcfH+jbQcqAbUKFxmz6KUZiioHTf3Sd0j2QOUniWhc94fRk5KrUZEuYWRy7cFpOEyXv1Ex8GwjJNT3sHOs2whG7H0VnQ3L6ZYyT2ypN0XjQ5xBEs6fHJyyhmCN0LqW9ArlVRRj0LI7nawJP8bTiKO3iB2P2q/zLY6nKz0Eo1dH2yiC8lJQxtxk8ifnh4Dfcak2HEPiBFol66csWT/Z37fgA7/syKBgCJhPMWS+UHC/BCxaUPr+Gs7knZcFB/8PP32n3sWkerA90xXbIADdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3mVlqEtQBxS5JuNy4gX7K+wjrCI/vbLu2i4TSebsjI=;
 b=lNxfWkrYPydm9/1A6M7yipPDQfqbUHAONDmnHAlQOVDTyXtOJ9zb0M5dSGuJOupw9IpfITE51WZg6KiaykkqhZhqvCKZCmZ5lCdXMZ6ERzBjMH+UQWzC4c1JA0UEcDXUkvTolAhzQUtjsc44vwTPLeYXqvimLIx/WELnsJsgMDNAPk1JAJcll4R8hdwg6BbjQeV6MWIdmHLQaAf0DrHdulxRE4t1BK66mJHpNqBwWhtBRbiPXZLDKIjwgsllU5J3MtwYELSBq2kza9tSuqKIM2Ikc1z4qQxCRWPPbMt39dNPTheZYvd6RzrG/C9Qtcj5Q2kHPIN+vlWczf4N8p6SYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silicom-usa.com; dmarc=pass action=none
 header.from=silicom-usa.com; dkim=pass header.d=silicom-usa.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SILICOMLTD.onmicrosoft.com; s=selector2-SILICOMLTD-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3mVlqEtQBxS5JuNy4gX7K+wjrCI/vbLu2i4TSebsjI=;
 b=PTuE7AytfE9J79UDgGQnt50YZslPlzW9XHrnfaexWR/HMfp2nVjJjazda8bJwH79NJiZXPTBij3fUm5y2GwmlsKMme0fWDEl6BPSnHmOxZgSSbL2VsVUjb2HH6UdVAKIhrB/Bqx3YWI0PfWJofCbdYm+Nf588M8URkstaqhg2mM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silicom-usa.com;
Received: from VI1PR0402MB3517.eurprd04.prod.outlook.com (2603:10a6:803:b::16)
 by DB6PR0402MB2856.eurprd04.prod.outlook.com (2603:10a6:4:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Mon, 25 Apr
 2022 13:18:19 +0000
Received: from VI1PR0402MB3517.eurprd04.prod.outlook.com
 ([fe80::1598:c12f:25c6:b987]) by VI1PR0402MB3517.eurprd04.prod.outlook.com
 ([fe80::1598:c12f:25c6:b987%7]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 13:18:19 +0000
From:   Jeff Daly <jeffd@silicom-usa.com>
To:     intel-wired-lan@osuosl.org
Cc:     Stephen Douthit <stephend@silicom-usa.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/1] ixgbe: correct SDP0 check of SFP cage for X550
Date:   Mon, 25 Apr 2022 09:17:57 -0400
Message-Id: <20220425131758.4749-1-jeffd@silicom-usa.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220420205130.23616-1-jeffd@silicom-usa.com>
References: <20220420205130.23616-1-jeffd@silicom-usa.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:23a::25) To VI1PR0402MB3517.eurprd04.prod.outlook.com
 (2603:10a6:803:b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24a8bb92-af3a-4bae-1642-08da26be10ea
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2856:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB285614F69E96F78DFDC60329EAF89@DB6PR0402MB2856.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3EWk1ja10e1jpy24RMNg6edEnYH599fmN+1awvc7p+7U9IDZX6XgSPlAWH8aJ2UYa5r+sToae8q3zl77SBTmS4A/zTivjHIQ9zmjIur4fcQWFzWSWlIH69oXFbB0Ucgh9PlhMMRavMIV5/oYbSmAuy0wJtwAS8Qp/TJTfLHN8merWOnF3H6wl/FEEz832I7yii5qNIPrD95KOsOcCTME/yXeQPadlub1LHbfmm00OV7eg78/R8vOlVZYGZvb4krpNWegNHj3B+DJA8FMzO97UqVhHicRw1ZEy8Gz9xeIoaYjQOqdq9tu5cm+I+HpHDv01M/CegrEiGdH/FYnV/msKGDN9e8Gjnb2acsJNQ68uyM+wJHHDHCcJP4F/uwPB1rxc6Fltd7t41Q5gbUy6znVW7jnkMTgBp0bCjIZg5cVG2gRlw1wAr+1j8guLcNHGKOYLlnopJoCgbsNnBmTY+ENyitiXHpKdGUWgHD11CNyUOmOPSBtSNMTYSRsjeZ+idyjHYKVNkUodxKG15UOn/juRHIN43IwhNbz5du8Yk+MZJxioYeWAiu8Flu5QuMs5bZQ97kMQEV6zm579JE6rNU6BxQIkK7cY9spQT9rpJ8TiIAIf21vMtSUcXkfGs+QvCiDj4vAnYFL7JiI94lAURXrzn8o/t2FxViYecCJifwUl2rR71QW46PyBerkrEYsuiyP1iMIGCO4bEBwoK8t/PUShg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3517.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(54906003)(6512007)(83380400001)(26005)(7416002)(6916009)(316002)(5660300002)(52116002)(6666004)(186003)(2616005)(36756003)(6506007)(1076003)(2906002)(86362001)(508600001)(38350700002)(38100700002)(6486002)(8676002)(4326008)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?INlnzVpyJCreRSGX2C/k5slSnGGPbboxRafVpVYkymPWQZe0ddT4d5LQ2i/L?=
 =?us-ascii?Q?MRgm4RGhe3IwIni/qZiWoJTulehtdS6YTxW4tIK5Ovrzhbz/nwzOYX9+M1+G?=
 =?us-ascii?Q?x30dLBMgNTIoCuHLXiU3kUTFzhFaFRIRdZsJ0GB/DGqEefF7X1vkdI63zkFB?=
 =?us-ascii?Q?ruD0tpqeIYFVMb+bzwNRKW4K8D6PpNLfVIfL111fSBELDmsJfblWuQoX845s?=
 =?us-ascii?Q?E5pgeFGCVmGCGrdwDhPPCx8cF5J0fx1p9ek2OD1xWDE0cL6PtXkUFn3vPD+R?=
 =?us-ascii?Q?EFoRp0laQVEONhtaIvTt8NvhMD1K/FV3dVUTYu/pNbFKvKAGbjCbRjGeypB4?=
 =?us-ascii?Q?yLm/CLiOQHeTmt8M3My0k2ap4tNrfPUSmEKivARhSzn8Tn6Pd+d5SbjpmDjC?=
 =?us-ascii?Q?0hAjRK63LCbSofeD0SCxeG4bbLyeQre8Ivh0Qq2HwQshh2h/1XI3bVwqooQv?=
 =?us-ascii?Q?BXfb/kcdsbaoozrzkFKQExlpuSqtprUPjepeGwL2B7g/jASxJ/vYztmgbrmM?=
 =?us-ascii?Q?nNDoULCaSyIJk5AyGZRIZHcBzJdo7tPjgxtJBpifDOJnbPD3SzUuJsRjbxQ3?=
 =?us-ascii?Q?vwmZR55adw1krP7eqVR72xVZSRKoGKMuF0bbISkoKSFDH+kyoMaLy4kc5/R9?=
 =?us-ascii?Q?hW7iQ062UTqV/dOTa5bsoI3jSzMEUXoTvciLXml4sbI3eH+F85YFeHccjhy7?=
 =?us-ascii?Q?D9x+lbxWaAsf7REG/1NnCDtFp98B7xDROoMSAVd6OLMlSASi2H+Gaf1m8ayb?=
 =?us-ascii?Q?znOVKghFOVTh+aJO/gmbgft/psAPJn8ydr0UKmad6pj3gf/O8UwzeZAmUnRq?=
 =?us-ascii?Q?zk48PloErFSA0X6HE2RlQ2mKAg5tlgnJgc0zDPbCCgHG0qZz9CIaQdt0ejyO?=
 =?us-ascii?Q?7mmESfdCCI2wa7/7+FMI0gIAiKc/b0ebkgbJj65YjUrZ802c40yMCagliE0r?=
 =?us-ascii?Q?hRQ/x1u5fWBb/RcgxuNaFf9FkzsKfkmxJNz+H0L4+vGrSYOR/tDZotiNzKpx?=
 =?us-ascii?Q?sF4Kbt/KCvW5KwlJpxH68Z+OV2cu25b5LFTsPRJPJeOvy0zjmdhU/Dtrp/cG?=
 =?us-ascii?Q?pfJvC6ma8i5AD6V9yuOzKJHfRY9F6DySG5sUFKLIm4017HZBThaT8+E6jmhN?=
 =?us-ascii?Q?DYMig6XuBSdGStZoZ74By5P9IMrHRCWPfGGyVAjyJwfdY3EKI5+cSW/5LlHe?=
 =?us-ascii?Q?WG6zTVtY2VsbH/Gd4gGnfc4muCZhvA7eyodcjEQS3p7XsZqGYAH/Ix5+V3M5?=
 =?us-ascii?Q?b6lNkbrWxezRdo5fgtbh3EcFGYxoQvQEjDn29y7skzM76bK1q0pNpj95+eth?=
 =?us-ascii?Q?XGR8qBM74A0Iaa3VkELVl0jUr18fR3mJpNMrl3d8eg9OkmQ4JEL0nFIWpX04?=
 =?us-ascii?Q?LIruAMri0K8Jzo/DfKxYa5zdXjG9BawZ2BOAu0VEDlgZmfpKXGLAoCsKUEe4?=
 =?us-ascii?Q?Z2YX5+5M8Y4zAeONMugErnfGC2oNVsiD6UF16CpTOnge9v2ImJ8yPjvX153c?=
 =?us-ascii?Q?EbUgEuokymbJr0H3WsYGPJUoSPHz5AusXHqTDo4eTLwj6zbMEriy8RbKU/9R?=
 =?us-ascii?Q?qM/anH8yBr9E2nspLrFmxGYHwYjjktmcB8s3q9gO1DO/TBRu7an9HGGXR36+?=
 =?us-ascii?Q?spfoxlh5vtb3bwNteHkVh62jKfU3olfkAoR/RJvlllmvwOTlS+UhrINKO/b9?=
 =?us-ascii?Q?CL2H9G5K422Rt4cHTGgrJ0vBARx/0BAITl6ijxHerZXj/66i6X9ifzBn+a9g?=
 =?us-ascii?Q?JcHCZuJstg=3D=3D?=
X-OriginatorOrg: silicom-usa.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a8bb92-af3a-4bae-1642-08da26be10ea
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3517.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 13:18:19.7795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c9e326d8-ce47-4930-8612-cc99d3c87ad1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 30UKRvPFan6L4yMgog+IEnKlZ3ShL5y+M6hnw6ph4wYSWVbHm9maMk0OqNdp+aVsyeswV9U7tFutBSpsfPyTuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2856
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SDP0 for X550 NICs is active low to indicate the presence of an SFP in the
cage (MOD_ABS#).  Invert the results of the logical AND to set
sfp_cage_full variable correctly.

Fixes: aac9e053f104 ("ixgbe: cleanup crosstalk fix")
Suggested-by: Stephen Douthit <stephend@silicom-usa.com>
Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 4c26c4b92f07..13482d4e24e2 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -3299,17 +3299,17 @@ s32 ixgbe_check_mac_link_generic(struct ixgbe_hw *hw, ixgbe_link_speed *speed,
 	 * the SFP+ cage is full.
 	 */
 	if (ixgbe_need_crosstalk_fix(hw)) {
-		u32 sfp_cage_full;
+		bool sfp_cage_full;
 
 		switch (hw->mac.type) {
 		case ixgbe_mac_82599EB:
-			sfp_cage_full = IXGBE_READ_REG(hw, IXGBE_ESDP) &
-					IXGBE_ESDP_SDP2;
+			sfp_cage_full = !!(IXGBE_READ_REG(hw, IXGBE_ESDP) &
+					   IXGBE_ESDP_SDP2);
 			break;
 		case ixgbe_mac_X550EM_x:
 		case ixgbe_mac_x550em_a:
-			sfp_cage_full = IXGBE_READ_REG(hw, IXGBE_ESDP) &
-					IXGBE_ESDP_SDP0;
+			sfp_cage_full = !(IXGBE_READ_REG(hw, IXGBE_ESDP) &
+					  IXGBE_ESDP_SDP0);
 			break;
 		default:
 			/* sanity check - No SFP+ devices here */
-- 
2.25.1

