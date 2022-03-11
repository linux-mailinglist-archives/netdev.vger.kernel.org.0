Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DED4D5FF1
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbiCKKoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiCKKod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:44:33 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2138.outbound.protection.outlook.com [40.107.244.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827AB10874C
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:43:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlYh8Myto45W1dWo4PpOA9HsL0Lj5A1vdK3alVMz75r8xb/rClpRKXWseapVVq6ECdmzJvrqfDEJAFH8zJuEQu8iTYNnpqK/CrUq6MyuIyzFtjGTq3Ri0RujAdWTKuydC+oXDBaGAWmpfYolwBEID7cFLVGSTa5BluE1JXltnK4/nPrdLGNSkNR5UPX6tYfllitkKq6Z0A+HIlXvPlY7wAHuRAQJXqka3Dm8eH2JbvUfp7upU62xSYQBujT7dddq/y7q7QT5RTO8ah1dDYoIy41wyj2kclHfq5j/fRagyZltd+frKecsrGyvPmAzQIxADsMFS600v4ezOUpCEVwmnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tscLeC5XvxjR7Fwl6FV+ko7BYGjnBmXdwRScTasHahA=;
 b=gGFluoTATER2bx5FuLO4BTKn6GhxzVFLkqRHHdnvoRBZzO2S6dUCTDpNynb1+BH6oDRXVT3GVG3S44Zudz6kPM1WT3ukmZS/IOoleuaJHfnngJgPIMvNksTUFSKxeaUAW4SIZOnLRnEmAjRB+H0tRs3W4kqnRSke/09+tlinsSUvwcO68VjxoPTMA2quDUJqdsocntq6azyTsMXYOU9F3VaXWO0nqevTZPIMElvii2Spr8M6Dq+t1pnghgikocE+2Fn92Z7ReG+woyQu4lofjKnU2N89prnKw6B2o1TCeQ++pLQtTRLu7r8to6RNoyByky+j/EdqiVR1RaXP/tEPrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tscLeC5XvxjR7Fwl6FV+ko7BYGjnBmXdwRScTasHahA=;
 b=mUIuHeX+YBPddwjx5yb1yacq7vV9hmpN4BbPcbsDI4QwWMuof053bzmO4xn5wrkzUSfLpj9pJ8mtMZaOPrf84kGOczZtTUCIBtSbUP4VKaqrH5xR7CkbuamJ4kPyr5E0JTK1hidrOKXpV9qJEDS8C5bdnYXWbZpAgMKGzNKWvLc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4748.namprd13.prod.outlook.com (2603:10b6:610:c3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.9; Fri, 11 Mar
 2022 10:43:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:43:28 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 05/11] nfp: sort the device ID tables
Date:   Fri, 11 Mar 2022 11:43:00 +0100
Message-Id: <20220311104306.28357-6-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6e802672-64cc-409a-0ed2-08da034bfa22
X-MS-TrafficTypeDiagnostic: CH0PR13MB4748:EE_
X-Microsoft-Antispam-PRVS: <CH0PR13MB4748DA367873329034710A68E80C9@CH0PR13MB4748.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cM49N/FNf4PAWAbXuRG1oQ9lvljUwLCCZnnpkbi+Iafn7KSQzBtfC2lSdk6gZXd7QQQkGGXygJp0di94e4IqdyZmeLxk0FcseGPcZUvtb91Y2zVuXj4k5wpUiF9c8+9Xjo+cmwtQcQ2gJAEhicHc9nLwT/v8Mo6LxuyEmpI33Ose/1gp3RyADjH3MmebyPzW92gSOUjbDUgB6lFiIVhBTlSlY9ktPg3C+ZNc3c3WfI9GxyxfqmE6SdscYK4u/mb4sI2ZIi3F2q2uGu19SXsfHYSImk4wj7Q/brSpZ3/TCttpRUzedni3AHRSnJrbb1elIvdNx+ys6GngAcCrlUwsgIHh+hMgDmlLUwzS3KswyvxCA0H9CusABE5xgsuGwQhFPsKKtKOfEAn1uiAVStUDGQH/SguKNxmITGbqZSZ3LbhO3s5UqJpWNZc1dFsyEW33auti7TexTuSJmyHefZDFambxMnKbx7KTU6lC1HimWxQIsHtYe63C4NeRVf3Kvmks0UAfq4CJ3HY4UcR5XpcRDxffo22dIkfaWE9iowr0Ea7WeSyTDbaX8rrSRflrwZR3q0yk8djHVFqTFF/nh++kZjEaC4CIqZuKJjQuLlfl9J1nCC7KZKdWfSnxfkX2zGgjru9HaXepgJz02SRG2mKHOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(376002)(366004)(396003)(136003)(39840400004)(66946007)(66556008)(66476007)(4326008)(316002)(36756003)(8676002)(52116002)(86362001)(6666004)(6512007)(6506007)(5660300002)(508600001)(6486002)(110136005)(8936002)(44832011)(38100700002)(186003)(1076003)(2616005)(2906002)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tzdLUTPLrC1HJX/CRQduX2VwdXuaihxaCJQDl4t7gEZEvsZWlaLaK2W205wH?=
 =?us-ascii?Q?uf/wV/ECMOU/hd4UcN7JY+Swj+2EzkhGjqizzfEKG0WlBdAl/1+H/paZYwce?=
 =?us-ascii?Q?wk1YGi4PiXfafNMAfg1Scyu1Daf3eZCYcMOhdo7ED/7xmxDgbnFvVWM23vEx?=
 =?us-ascii?Q?h4nnTKKNZCgIQknrum0PANYzZTVTiwt24mTUQ1+Fy58mlcK80UWZ3GzoiL9J?=
 =?us-ascii?Q?iNOfBWaFBc7AEwdIFxjul5rOGJ1uJChTbG/8b7AMJPHuLMoW4jGRzr01+JOY?=
 =?us-ascii?Q?0kZvAdx3p+u9HPJa+325Z9KS6PSttGVR0GDTLAurRp/sNdcH+s6zMsTzxNVh?=
 =?us-ascii?Q?dyJX09MB64quSoXU65EWGccjBUZ9gx1YeMKGUBKsFa0HVHJBIEpG2Vyk6KaB?=
 =?us-ascii?Q?xJ7kYiOumO4pWFHe/mwNqEirxpJ+oyD76Hl7czvLOn9viIbLr2cVNJcrJWuz?=
 =?us-ascii?Q?x3QHJTkOdFdaJzCVBP0TIjScX8LTxSwqxU3VkTFo9Yc9ee5oekOXbuRk/rbq?=
 =?us-ascii?Q?lioCjwMCmTc3c7HAJNcaNfsSEwS3o74rUQ4UMFrTGBa3L0iIoDzX/YUpVEtP?=
 =?us-ascii?Q?nwG4eZ3SctHh/Ev99TJ1c5/tcbHBdMbIm2b1IioMy5NS8QukYprCoTetXMXY?=
 =?us-ascii?Q?MOir1rZRMdWmZ8aY46qbO8SGsr5uJn7KKadAtia33ZySDtgOBtN0fYaA8jkW?=
 =?us-ascii?Q?+l58Yd+vyQHPA5lQUj08IBv7R80ne8ATeD0/ctGrqgAzVtPpvIPCmpbe5Fhb?=
 =?us-ascii?Q?YM6XDaJqS3F8D/unkEV90wcFSTpG0Fy39hCCYVY0TYXdBdrocVLeXixeFzs9?=
 =?us-ascii?Q?aFRMIrue0SgbOzpDVyPE7mzTrhNjJ4yoviwSPArmJcXvYoM4ZZy+zpA81TX0?=
 =?us-ascii?Q?fTcDArrgRxH/IQxirc6/uFrh0AEN2HUjcioLJpMDcVPWgg3wReTNPChN5mLE?=
 =?us-ascii?Q?11uod0SdpveajF59KTMgjA7PXev+NoKi4jiyn/UoMuE6Bz1H4GgtdweyKphf?=
 =?us-ascii?Q?ckdVV82F/azp8ndbVB32pBeeMegGpVvzp+bYzlVEfHntCiPdj2FxKj+pq3tm?=
 =?us-ascii?Q?m6XUiDyOOnqteFPEIn1jRqi2UJVmRG70V41TRs1wtaIVj4fdE3jvcYHK8t1q?=
 =?us-ascii?Q?24bFJ/NiauxVC30aPHy6K525cllTXTk7V5Rv5fXN/EgP9awPqs0YMH1XSXsu?=
 =?us-ascii?Q?JPEXTUXK5fzDOxthh9cPcy10tRgPyzPWiEwxbD2lTRjqKq63I9NmOLGv7OUf?=
 =?us-ascii?Q?6mW1DNnJYU3YJO4QRuVXL8eb6wUx9v9wHWyRnSFvrxjbCf6tlRzfqDRYEHke?=
 =?us-ascii?Q?C7NMXwGxZs8O/3n4h8qi/H8Gx+q/OZ6JSPkgu7yM52++Vwocaum9Kr/ZLRkj?=
 =?us-ascii?Q?ccB0DCDzIwoSLwjy+ryPIKvSk/A7P7JBb7fv05NYS6jXVkFWccNTkYCIB41U?=
 =?us-ascii?Q?fmEYiYgaaS+QgDa+B61lGGq+UtcXuauXredV2wMtKFqNmurWGjTEzRQncrnw?=
 =?us-ascii?Q?eIzkNq6IKuZPC9FZ5Cql9I5tkbYKnbVu/Kqb9Q+rzU3w2DPUixdCTLbblg?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e802672-64cc-409a-0ed2-08da034bfa22
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:43:28.2968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6JpxvU9UOi46OKEvm/EeBm9OQTrgGCyRVfE088gSOhO/H76wHQ3ZN2v6w//jhoQGGdOPKuCnDW8D0Ec7h1iJzJoG3szXSjlDNVDicBTQLnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4748
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

Make sure the device ID tables are in ascending order.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index bb3b8a7f6c5d..8f2458cd7e0a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -32,7 +32,7 @@
 static const char nfp_driver_name[] = "nfp";
 
 static const struct pci_device_id nfp_pci_device_ids[] = {
-	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP6000,
+	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP4000,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
 	  PCI_ANY_ID, 0,
 	},
@@ -40,7 +40,7 @@ static const struct pci_device_id nfp_pci_device_ids[] = {
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
 	  PCI_ANY_ID, 0,
 	},
-	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP4000,
+	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP6000,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
 	  PCI_ANY_ID, 0,
 	},
-- 
2.30.2

