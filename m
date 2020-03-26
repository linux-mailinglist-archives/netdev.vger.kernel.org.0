Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B358D1938BE
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgCZGiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:38:50 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727655AbgCZGit (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:38:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TjqlS+nBu8OjbhA4eJmfa8AB/V6nU8MBZzXHSXkUA6fxqTyWNklrJ90fYvd8Ut/Ka99DV5FXI82CGI4+QTOt0pbrgEdnmXgQ1X86f5SMlWk/KNdxvnZq3E+mmEq+mJP0NPJe+DE5ra2soS5nRbE4BPBrSoKoEW5bto7xazFz0qa4wr1QINQPa+h1WE/Rtba7lQs4mTTaiHBVOLfkXEywiN9g1vPnkgfGU/zBCX6dz2gZBx6x1lHZKfrzhy8qQ4FvfcntlLjD5npuia8+05bObZ1HMotXqRyYpUVwTn0y3OM4DN5WPuq6Se0ARRPWMWBmqoaA2RFB3ryfQHIAzo7XXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/SYYRpbZKiVWfPSrLRSL3s242wA5Zfib/VxbCxspUw=;
 b=JxZMmOE1qzQQQ65IujDpezaruVjjt69eTGpWUSZKyZifZ7LG5AZ3dVjDyBmhqLDNo2EHv9E8CQYda5r2Z6VGVqNFs7yY2XDJwSVRo6pwtTRWAfyfJj73NKwVQ2wLz3Vvw8t+CJLNupeEeNB4Fk6dyrcP9XqGincot6wcMYOTfVungdHuFuJfxjdFfsRxgOKRrDi/SUr6btI6XfrfVX5Xvv2YxJVKKD3YoyA2TpOnq0m/sD//AgiZ11hLTo3AOaRzEw04AlaWlpTHqZ8K3ysI/V34SeM232/y7aQ2lI5QLb2WPqNktrynYL6KuyUsqwY+OZFPflkcZ8CUT1VUJI92iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/SYYRpbZKiVWfPSrLRSL3s242wA5Zfib/VxbCxspUw=;
 b=K3ZYTeLZFEWt5PgC4zQj4lgLTYAI2mG1bYoW9wNAy68+DMtxR1AfDZMN/kIM6VSTMxrNbRxdvuZmofqYt2IuBz3V4NMTSRNsbUqnPu5HX0D4A2smDDUURSeUwHLT10GaLe8tL758sHJPAGlizKzzkFCYjXtaUj2Ks3FdYf0nnDU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/16] net/mlx5: E-Switch, Use correct type for chain, prio and level values
Date:   Wed, 25 Mar 2020 23:37:59 -0700
Message-Id: <20200326063809.139919-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326063809.139919-1-saeedm@mellanox.com>
References: <20200326063809.139919-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:41 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ca10a8e-fada-4f8c-1ba9-08d7d15053f8
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB64790E1EE848503BF2836EA1BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/Stm3FytzkfmnoE97NIaws8mlHCaXdcZAeVuiTIwWL0CmLbpo0rnnE6TwrO4ppoFcXersmX67Ti60owM/XaFE1hLWUWvj+btzQemyHtLa+zoRHGCFRN859I6GpmewZODiOHG9T3ab56oVZrSTdh2mDM/M/zoWasl9890prieN9BThPEAsWIim3OUxz65ow/7r6wAnV6gSCVcfLHXS60iDq6VWmDT3RIi9NvDw+8/juqUPlEDpseFAYkzFfRtbXCtLXCLvSJkivv2pEek+O/jzRcknKlz2Mwn5F9EDLEqn2r49lBem+mp+dAXWRGPDI5ljyakZG5bpQHe+he1Tnf1MsY3SjGAbSdkk1vJMj9d2OnRy5WMhMSxpmEJk8aosM/TVrRS5RCKPfw1wCXn3lR1C/2TaCo7ia+nLK6Lds8MFac+UCCq9QfGRSoup2j6kahqfD0E+ZUJi4vw+TGANorKb3d9qNkmVclo8i5uppp9w/997Tgjmu7+xuDKfDzoMni
X-MS-Exchange-AntiSpam-MessageData: BnB/RQuU87p1h8XHEe3g91z6F2syOKMKcE1Cj80V6Qfwuz/hWbLeoLKS3jfWBECOeNO5zc0mcjpvYZpR25mb2f6qAHnqlEgJdAMUTQiVRmpmUY73d7lXbCVVDyVGlxbEDh2YQyiC+G1HW4onap1KhA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ca10a8e-fada-4f8c-1ba9-08d7d15053f8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:43.6400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3cvEFHyCLaXpz+Bljmys6WL07eL3rIopu5XOqtQeKQfFieVQk93M+gPBy+mWwD76r0mPlP7YC2KNuUtZZCdrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

The correct type is u32.

Fixes: d18296ffd9cc ("net/mlx5: E-Switch, Introduce global tables")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c  | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index 090e56c5414d..184cea62254f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -730,7 +730,8 @@ mlx5_esw_chains_get_tc_end_ft(struct mlx5_eswitch *esw)
 struct mlx5_flow_table *
 mlx5_esw_chains_create_global_table(struct mlx5_eswitch *esw)
 {
-	int chain, prio, level, err;
+	u32 chain, prio, level;
+	int err;
 
 	if (!fdb_ignore_flow_level_supported(esw)) {
 		err = -EOPNOTSUPP;
-- 
2.25.1

