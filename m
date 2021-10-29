Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BF543FB5F
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhJ2Lbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:31:55 -0400
Received: from mail-mw2nam10on2134.outbound.protection.outlook.com ([40.107.94.134]:11008
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231897AbhJ2Lbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 07:31:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehbHNvWU9bHQjHGCOoNJbEd9ESg29SZ8rIzq9OHpaY/bAdKxKAPQRBJ2cGSe4cgZPW0V9GPiEuD8l4IYE0E5f/mKeGsAHMGAp1IOck8jjXd/IcHCUAQAcVE9svbZBBeMuNcxiUojhqYL5KWEnkTJ4qpPJYmIdbJV8WTo9lhfJHsrPDfeFci5VIRnsNRrxvBVj1qvjcL1fK39uzz99ZYKtZP0QV3n+w2ieUfIyocB+uDV9jigG+OeZtcBP5Ex1G7n/SckDfQT0Iv8Gs4S0dfpfyxGnJcRRxPiG1qlb1tdKHErHau6Ma2tmrgG05WDA3NOG0uyx1zRMrHaCkDm9Hv74g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7PUpcvQHUyLv0ZuaMRqUGNOT7cEW53Xg05WxfsVj3c=;
 b=PXvNaUvHRkBh7CnGhY/zsBA9mW+itNRHSKdOIk3DkHv4oSVnJFzgV6bkjQG3hKng/nkBgd4fPRXo8HyM9ZGNt6UhIXtkIWjQtjQYDc1z7J5iXwXforsPI59vSzG5AzpzNw0fjnZcFve3y6GXDt46XZSyKGAUWHvsz0vOkVTw8az2avYFhNC+K2HXzJHcXiez81OdsGwwCdIjSsE2XxjngXqsCJCbtJZx0l7xxcHVDnli2OuuwkNm3ejfLEnsdpyQWwIaXOu631dh690waBwYm6Jsal0jdT33uTIcPCw+YM+Yc+7SEbDv0AUZKSejgRxVrjYtWs8Xb8/dLxNjQ51t+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7PUpcvQHUyLv0ZuaMRqUGNOT7cEW53Xg05WxfsVj3c=;
 b=muxQKmvOMSy/VFpbgzJWLbOyhzcQ5vZOEPQPR3iBYDtGTfFMRIe/F/uiXEeHoZyXgtJbsBOmgPOxQhf75ZbEAqBxHCp63m2AUrmn+sU24mpDMfRz0OXcRT/NSziYHK5hXTw/5l6qcrZjgaSn8Y83cz28Cl5fRXsize5mD5x5KY4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4828.namprd13.prod.outlook.com (2603:10b6:510:93::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12; Fri, 29 Oct
 2021 11:29:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Fri, 29 Oct 2021
 11:29:21 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 2/2] nfp: fix potential deadlock when canceling dim work
Date:   Fri, 29 Oct 2021 13:29:03 +0200
Message-Id: <20211029112903.16806-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211029112903.16806-1-simon.horman@corigine.com>
References: <20211029112903.16806-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0015.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR08CA0015.eurprd08.prod.outlook.com (2603:10a6:208:d2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 11:29:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9b84d71-2c3e-4808-a047-08d99acf5a38
X-MS-TrafficTypeDiagnostic: PH0PR13MB4828:
X-Microsoft-Antispam-PRVS: <PH0PR13MB4828FE44C9AFCB5F39CECFA1E8879@PH0PR13MB4828.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TtLzRHCtPYAEtj5r7p5/ByI5CmaojWyL+Y9WJ1WK0z1mkEe5EgGRJfSK4HspnOXsNiNoUsPWd4W/o5rxnOKuC+qh2jMSVhoo8QbcJNJF4poDG3RESPLjjObF58aSuTr0hGMxJJeFVExG1DqVtjQ/F94oH5+2uLDoJjzhmzThDTJ6Qv6lTdRTi1nDOT8MVWsbTFL8+HtrJyEOsrsGwcpfHvavcktN5GuLp9OpFkR6jDXT/5Ja0f3gusVMtBQ/w66oFJ3miGfE6XyfNM7DiwgbukpRDGPFyCW3gMIjWlRWHm+trlKvd/TPsm28YVdoR+so3NPDOP0gttJsCQdiHN1kKcvVv3XQuAEqCRDccCLc3A7DlDBsNQ3MmzwMI4idIL3YQqzMPcqcwYLUPqJR0NEEVEUcCRhG7+wO8kLeA5Ut+fNtmzHove+YHSJjrMFDrqyF3wRbHnYwVR/4gkKg8Ofvu7ZN6x9Uj2a7heU/epRL4AmyyZXHZnDcn+K1zxf3XcqwLBjsd9syI1zVxo8fCOTZv0Widz9Ha76fzRD1ONG56ZrFjRJQ367rpcZaoAS15PUgTIloOxgNaUgkHQ8dUji+LXdjrPDR7TtV6Vug5zzokoC/p6PlVqP9HdODKAHBwyi/iReXVMHan2PBr6rRVEivyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(366004)(39840400004)(376002)(66476007)(86362001)(4326008)(110136005)(107886003)(54906003)(2906002)(52116002)(6506007)(316002)(508600001)(186003)(36756003)(83380400001)(66946007)(1076003)(2616005)(6512007)(8676002)(6486002)(38100700002)(5660300002)(44832011)(6666004)(8936002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6jcmMBDsGKMMK478/I7ud0l5daoogODXlN2c7QqXj+txPjXN3X7qw0TJi/e3?=
 =?us-ascii?Q?efIMY3vrptEJtq5eXZTQ26nbM0B1+JDPsPwIMRKgITRzyB8soqTToXqMj5pr?=
 =?us-ascii?Q?x5se8LoRW7kCjpjPMSXYrfHleQgewbgmmrrlXnWs9wO+X3EWtdY9TkCju7b/?=
 =?us-ascii?Q?SNFXsMneglnArGdoT+n27tsas3CY6ni6NnjjITZMGi3SM5OLn07a5a+MeBi7?=
 =?us-ascii?Q?FIIEJXb81zVQchcYJ0a1PiWx5Hwwx6u6udxS5IRXJqHfs5bF0+4U9wVtoM7E?=
 =?us-ascii?Q?UETVmKKBHs8pZTGj0JSOOF1YAvZEXOcSlmqzANvEakmgieEGfp5J9+33o+1T?=
 =?us-ascii?Q?RuMjWL8Rd2jBlDgFoWdT2k55e+olarOvLeI5UXFq8bd5wIsLjB1LMBKACFq2?=
 =?us-ascii?Q?f4GMjpbpu36R4REC1qRCh2I9eSLKu/+XhxMPV4T1CIUDedgDwnBvF0AHS2M4?=
 =?us-ascii?Q?con+muQYeQk+ndHZibfoR1ZeL6JkxPoaIL2HAqLWiLk/5ruxp0hRAHnIJf4J?=
 =?us-ascii?Q?KBFcOVoe5WyJwdMMVu/06mcncU+qLClMFW/HJ89Fpy/vXMpIoPsfDFuzU73z?=
 =?us-ascii?Q?vRNaMLnOcxJnCbPi66wE01CXnKHhaNhUAJs+ag193Kk60rUWvLgOrqy9nunb?=
 =?us-ascii?Q?rIyNhW6ktniB4UwkQ5ZG2Y2K8oXUpkF3lDUmBEf6cO+Cg5rdG+pqIAo3R120?=
 =?us-ascii?Q?ZnRFPm4WvdW7mcW0qCozgDBuJdl+tvR6pH1pHRTvEwxvokFmPbTmCwSMrLQI?=
 =?us-ascii?Q?va56sIVfMF/9ogIzUaLlP9X4SsjNWd6snBu9s1HMHtaH2W/a96TJ1KRm3WiV?=
 =?us-ascii?Q?w1ObQ+thensHjdLPMdAd9RVQvQ62QagTH/6QRzkOpNp5kVmOw8dIITFNphhD?=
 =?us-ascii?Q?yUcWnZk2XCPJ8+QB6nAGacuV1WKnIjmihrEOn3qrAdZpVsuM8WrIfPAz0s/s?=
 =?us-ascii?Q?0WwjXZa9X1fH7VclUckCy69owWr3K9ki3cYi2VTezGkSBWoZXl3/mS0OY4go?=
 =?us-ascii?Q?ld2e8kzi016T5KwxIO80OYWxd0/Cth0oG9RX+nSatSovjAnFgm4aem+HQjtt?=
 =?us-ascii?Q?1EoPaWDcYBJFCQCHmSdBZyE8qeKAs946GYoK0AUZKOxsccc7Imk022CdLBkP?=
 =?us-ascii?Q?VD0lEQL47uV9p+bcdgZLg39eGF/rg7DcFNQUo4JKGM2N+i6UnzB9al0gSTpN?=
 =?us-ascii?Q?qCNDH1GXD/sxzW8jOramzDiJA0mHgpzrKZT0hrhMzdcB6Fa6ebvXC1CDnv9H?=
 =?us-ascii?Q?oO7Hk3pYGQHhnGA1YIezZie88Ad604XEbqup6soksp+rlTQmzHOh8xGTBokp?=
 =?us-ascii?Q?M5lgFxCDl6c/d0kYF7PwA7vduleXyI0EWq6QWOaSDokoiQHdiN25J5InyfMZ?=
 =?us-ascii?Q?UlHQ9IWze4g2m0oI4fR1+owwQd+bNyVCcthB8IoygjoZa8zzu8nNA6bpqdzD?=
 =?us-ascii?Q?hMaN9FH0cSzEH8ADEXpFMByt14BMxVukQuwHErbfljnGyV08Dcy/o383LvjI?=
 =?us-ascii?Q?Ja4nin278YxMq2TuteP/Yr6kWOG8o+MriTmcY8L37HTUDKZTStrPiE5AVMZi?=
 =?us-ascii?Q?kfGkCBOaaJDAqedfCcq0MlobOjDeAo/BOLBL/2pVHV3jpaIPHAk7fRAX2ExJ?=
 =?us-ascii?Q?okbZpaAIWPkDfd56Mix8JnNYtZ2EFgzuXOiH2UnMPJV+Hj+baOUqEksSBjCt?=
 =?us-ascii?Q?x3hL7C/eECXfhpqn8wAe6hVQ6ox3AMS/W1SMTVBxj7+ahNKiONdVzgmQDiXJ?=
 =?us-ascii?Q?weMXY4pmlg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b84d71-2c3e-4808-a047-08d99acf5a38
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 11:29:21.2980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIPJ/FWll0QSafQqFPziNzOxSltDWRLZSmmrg9BBb3QWDY6+ZDvl5EC+3nGA19fN4zHZThleNmAaf2VeWCeMmSlZxK4hZ9YgUVi/e9z+l14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4828
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

When port is linked down, the process which has acquired rtnl_lock
will wait for the in-progress dim work to finish, and the work also
acquires rtnl_lock, which may cause deadlock.

Currently IRQ_MOD registers can be configured by `ethtool -C` and
dim work, and which will take effect depends on the execution order,
rtnl_lock is useless here, so remove them.

Fixes: 9d32e4e7e9e1 ("nfp: add support for coalesce adaptive feature")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index f8b880c8e514..850bfdf83d0a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3016,10 +3016,8 @@ static void nfp_net_rx_dim_work(struct work_struct *work)
 
 	/* copy RX interrupt coalesce parameters */
 	value = (moder.pkts << 16) | (factor * moder.usec);
-	rtnl_lock();
 	nn_writel(nn, NFP_NET_CFG_RXR_IRQ_MOD(r_vec->rx_ring->idx), value);
 	(void)nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_IRQMOD);
-	rtnl_unlock();
 
 	dim->state = DIM_START_MEASURE;
 }
@@ -3047,10 +3045,8 @@ static void nfp_net_tx_dim_work(struct work_struct *work)
 
 	/* copy TX interrupt coalesce parameters */
 	value = (moder.pkts << 16) | (factor * moder.usec);
-	rtnl_lock();
 	nn_writel(nn, NFP_NET_CFG_TXR_IRQ_MOD(r_vec->tx_ring->idx), value);
 	(void)nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_IRQMOD);
-	rtnl_unlock();
 
 	dim->state = DIM_START_MEASURE;
 }
-- 
2.20.1

