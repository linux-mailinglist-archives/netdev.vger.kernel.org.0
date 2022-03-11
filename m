Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136B34D5FEF
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbiCKKor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbiCKKof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:44:35 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2114.outbound.protection.outlook.com [40.107.237.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BD214F298
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:43:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4As+GkEXE3dGP0pWlXzWNYjNqdLCdkEi+qGQUdaBF70Vh3vWo4doxQqOvQ1Pm0TROXHQ+7fC4P1PfXNdWSnAPTFlfvwEL+83USIUh3zPmv2NiyBAWWx2aae5lWOFyyOq4+dXemfElbeyYc/UTgjZH3hQAMAH7jchrd/NijaUSPGEoYf3fnhIIRpym3/jFX4nkXtiztvRIMoFAtmHCBL/0eGG3ka/Qc2nGdwdtOpXpSb8chm3Ut9CCUPGHPyCuOj/OPMa3ijTE8F75UuU6/VU1L8buIFLiPWdkI5r+zFHlkow1F91xX6TSAc71LLuyzs2zR0ZfRFlAdvfo4ucqi3vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yW8kg8YTKJW8rIQ73R8NAW0qA8Riv4HQ/rsHaMugfUY=;
 b=PCAjTJtr7ttyKH18Ajl7CIXEe4uBtNss5sFgoG8U5PPZs0Qim6kAtpty1/sL4st6d5+hh+iiU/05qb1m8yg6tXuaaUnu1RBccSlgJEdJz8Ko+y0ouw2KhVv8IsOlAknLBZ+fnZ7dxPN7r+kPwCC9+cEFnX4DOBw+eOJMvEd9OMn+weNQ8xAiyKeRvuFRqhIgldz3g8r0KQlZt6G2xh69NbetMqxn2PvBLfjL++57Xs+qCAlmgLW1fTJJu/vqioe1X9XVir2HYWPbTSq/uqSOljqUlXCpSTn1juoNZHSqUFtJfC328DR5iKgUvTp7EBjHxyIkkHcEFjQwMKn/353BGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yW8kg8YTKJW8rIQ73R8NAW0qA8Riv4HQ/rsHaMugfUY=;
 b=VnbEuEEOMaMs3qMYxcn7NtuqgsYEZQVM2zno75/5108ma+qlSGsFUGVriJeKHRcrKJgBCSXlnBvi7R5TAcCRUDeWOeArZA15TdTTuarhI2S6Ja4MbwROf2Xgw5sXomKOnlQhQTQPwk/I5oP9EKkU+WfuDSyB2Bw9RGm83j33hEI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1184.namprd13.prod.outlook.com (2603:10b6:300:e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.8; Fri, 11 Mar
 2022 10:43:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:43:27 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 04/11] nfp: use PluDevice register for model for non-NFP6000 chips
Date:   Fri, 11 Mar 2022 11:42:59 +0100
Message-Id: <20220311104306.28357-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220311104306.28357-1-simon.horman@corigine.com>
References: <20220311104306.28357-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fa7a243-5c3a-4e4c-bf11-08da034bf960
X-MS-TrafficTypeDiagnostic: MWHPR13MB1184:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB118445ACFA310131B9B34DF4E80C9@MWHPR13MB1184.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BbzUGsbI0cl28O717nFuKQvoFh4oVEKyOPSsLMhjWb+rsDL4BGrm0tiBzDC5bAZSU9EjmfLGXm6hZ9cmi4/EyqkrxAuFmurtnCsXrA3C+ENR1+4+BCaXqCuqMayHU2zvBeT881bFNGqByC7SdVI2VeUV+aplRRlKU4+BIYbKayu+gvjP6hE93fSTyFBcAI+JjvlUnx4z39B2bd++EeYQrtugecjKgrz08/hf5gbCtqum3GBdiO6NzF5HEcmLDtXe7ep9ZfbU9dGe2V/CWyzUAbvAgVDPMt1aPI/4TyIU++cNmjr16Q9TPgjE7E+PzAD8D76WhYDM7dB6jrgQ75IMG6gCEC9JG8LSsBxKGcQdmbd+decBG7l/CAsVqwOcKIrUjCBSck1g8b/2GDjGXsioWpWhxkQIYgvRPDzqreY5sv68jUqsQRFyosBBwKFCNkPM7fhI5DPX9XmECNVD1GdkcjVo70kYmBEas/D2Ly0n0vPqlOGAA5mPeFtGt72GVPHJdWdQkjPlW2rnDUTUJwYuFozZMAMIlOeXSZnYUdYe48GJp6+PdmXb+YUoA5r7XliEAuY6wujFKuFW09OHGuvHoZeLVN9p+znR8U0cjDlGM7aChA6uYLD7M47mvdQAtGgYWwAkMAHMPmFuSvYKyDlElQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(376002)(346002)(39840400004)(136003)(36756003)(5660300002)(2906002)(44832011)(66556008)(8936002)(66946007)(6486002)(110136005)(86362001)(316002)(508600001)(6666004)(2616005)(1076003)(186003)(38100700002)(52116002)(6506007)(6512007)(4326008)(8676002)(66476007)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EUKx/ZzlH3iUZeLu0GnkuDgCuUjDCRuKI+wH+t7hm1oPm3XR00irTbXdqW7x?=
 =?us-ascii?Q?woyM7bRZGiOZ24IqvUWdrwdmGe6Q6A6ckekp9351fGiq7W4KcwNMuQiiUfGg?=
 =?us-ascii?Q?O3iL3pzOUq/oeqIw4D1IG7LkIqPPpzWKaki74eRXpFBRuVemNMeuZSXiCD9i?=
 =?us-ascii?Q?Z9HJXwVB9CtXIJtpdzpc+ox6PCqBQpOgH7fUVlZuQdd0g/fhe8Sq68JqIX1j?=
 =?us-ascii?Q?NOFUuhJ03IFIxBRdoRjmRhFvI7oey1yYj99Gk5Vfh7Yv/Uk52i8JMXpNyXZK?=
 =?us-ascii?Q?hAQgJb51V3LyiQdcK3PKPZoz53yaggSNbBPMRxhjPR5zcS9kRbcFaKKBrMdl?=
 =?us-ascii?Q?M8tSIoF2mFr7vw88BL/JMcBi/doGQ9Up8q2AahBeX2NQyur8XaQK0wIHa6A8?=
 =?us-ascii?Q?o3BumAYnjR5HJ7oy3COAGDDewAmGDZ8gHf9d0WC9Zk/j1NOp2FKhVefTKd9Z?=
 =?us-ascii?Q?i+PyM8xfEAWwQ5uFkcN3LOhpbJ5fiKkeSmbOmkZt4kueD4CXU3WiAcG9nwdW?=
 =?us-ascii?Q?kHDJJec1lkpL1aFY5avUm6Diii4qXYFJJRKb+e/gY+Zn0qWfGxLpQm8XbEg/?=
 =?us-ascii?Q?G8B6n4+L7JNhThKix5vFWezK/3D7MNIVMyWqh+kTHeV3uDVm551Ld93H0IlE?=
 =?us-ascii?Q?egJaDCNnB5SWFl3ka3km9CgbYujh5nOD3mV4303/MH04IG9oumNpMWh7bjXf?=
 =?us-ascii?Q?at+C6jrM+hkcU1698rkF/9tRHnTOp9P55U0aNyKYE5cqdkk60srLi8TFuoch?=
 =?us-ascii?Q?Ys4mk9UcMtt/yYISIvgcqUpNkLCKAd+dhJ2HMZiy2dgXsNJeobc5ueXOI0vN?=
 =?us-ascii?Q?Mdzi2RoJhb+pruxjHFmpeXLVrGchYPCSdT4Yab65YyzOMOi5wqorjweOfOFR?=
 =?us-ascii?Q?bxGF1oM4y6tcKQl++McAqrt276XTOmgmv6csJHJvclJcK7lIVIbuPx+yMyHB?=
 =?us-ascii?Q?24XILC/I19EPoGCVHKJrFZK6ElwtjVyFJi0/Sye+Jv6SUCXw5c2rqoqCQm9J?=
 =?us-ascii?Q?9a60v+BCr/B5YTxdUjEFv1k+hluIZjhQFYEZjOXdooqrvAz8luiei+74YzX+?=
 =?us-ascii?Q?CUtZ2nJoAaa+6lN21LcZLTWgd8hvBMBlGufhaX9iHwJRdCcDmp+dAFgOfnJ2?=
 =?us-ascii?Q?dBCUwd8S03YmL7YdGV5bGW9au/k5vs88SIWm00siGtYsjKwj+MamipDJXo52?=
 =?us-ascii?Q?NLaAsV34iRbtU7vFcfw0B86HIXqdnuZgVtbU9ju73XAaeNmi/VZBYylVfTJA?=
 =?us-ascii?Q?trVB8lxJ+OjS8RvsKtwGVq1L0cEyDD4rss8b6pgnu05Puvh21C6hAjBvyXLc?=
 =?us-ascii?Q?vGQCtv4G0NVxcjUToF/2IwKGa7QajHsne7qvFw+hz9ltGPtMZkwUuG9iQpvN?=
 =?us-ascii?Q?Oe+fVNqFvVQ5llFiurOZgYgkQ0tnZJc+dEk8vQ6m42jB1Itv1Og9uYmWGbIw?=
 =?us-ascii?Q?OItSpDjj5xdKq5O2IQWV2V7bEHCSS+tYRj47N0WrDnjYEetVyVPRzeyGiG4t?=
 =?us-ascii?Q?6PyFLWVPV7mMz+0L8SONuRKWbUra+bsw8lWFK7HWz1zuAl0Q7LEI9642YA?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fa7a243-5c3a-4e4c-bf11-08da034bf960
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:43:26.9050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQ6HyzsPr98nBC2UzghxZJ/O/VQP/7GbB8HYKdh6PHVr8VGDEmeX8zMJJyDjOXlyd6W3TybKjV96O2fkdkOnWv2ESKwJXP1Ua0dQx6ptlSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1184
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

The model number for NFP3800 and newer devices can be completely
derived from PluDevice register without subtracting 0x10.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpplib.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpplib.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpplib.c
index 85734c6badf5..508ae6b571ca 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpplib.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cpplib.c
@@ -22,6 +22,7 @@
 #include "nfp6000/nfp_xpb.h"
 
 /* NFP6000 PL */
+#define NFP_PL_DEVICE_PART_NFP6000		0x6200
 #define NFP_PL_DEVICE_ID			0x00000004
 #define   NFP_PL_DEVICE_ID_MASK			GENMASK(7, 0)
 #define   NFP_PL_DEVICE_PART_MASK		GENMASK(31, 16)
@@ -130,8 +131,12 @@ int nfp_cpp_model_autodetect(struct nfp_cpp *cpp, u32 *model)
 		return err;
 
 	*model = reg & NFP_PL_DEVICE_MODEL_MASK;
-	if (*model & NFP_PL_DEVICE_ID_MASK)
-		*model -= 0x10;
+	/* Disambiguate the NFP4000/NFP5000/NFP6000 chips */
+	if (FIELD_GET(NFP_PL_DEVICE_PART_MASK, reg) ==
+	    NFP_PL_DEVICE_PART_NFP6000) {
+		if (*model & NFP_PL_DEVICE_ID_MASK)
+			*model -= 0x10;
+	}
 
 	return 0;
 }
-- 
2.30.2

