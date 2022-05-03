Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A75517CB5
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiECErV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiECErE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:47:04 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A593A3E5C8
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:43:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=He1wkK/rEkhG7Hv+MiXEuKwPTTgxR26R5WidF9nlO3WGP5Z77fvEsVtLPnteOaGBNuZoaAoPk4K18BBupKpVd0k9wcqWz5uVE18gtV01XUYmLd9vCpOQbvkUlK671doK1kdtQZMo5EciGIq0VyyqtOm/KlkunQwM/FLeGD++5ufM5uXN5GYEzRRfZJD7aewNw8oUks1hZx1MOy0bRydyb0SLKAC7kAdBM4+JYAc2b6NkqVWUegN1SYGJ4ZfwyjUAop3xsfUfwVXp4kcOf8D4ARi5g8an8v6EunYMp7/Zmal2zvHjD5pLgGTIRj/eMSVYpr4tgnCtPHf1Dz3qtbVMAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2LLWJGAawHp8z9SJ5znvIdAg7SUUxdDPcSXz1o0n9E=;
 b=VksrbLwWHpKC3v5n974CsUzZLHlyPh7vX9X1lSaXV5qrMkpSUInJt9ZjU9QBqclYpFSBMdpXOhMpPL157SzbExh2mTjZEJKg0/FgXzQy4iNC9LoeXL7rm21w2nSTUjQDTcGKZa9KCz5Bc3IS1qTqTJWe6M0c2wNHT7NaC0O8TZOUunZ2kSp/CrnqEs8LxK1/Azbc4k5mJ6bsQOE9OvF0KVz0Eo2kVu6XEFFTudbgFGnln55j2vDoa7cKk7VJJKuFw/NTiH11bLX+VsLO3I5lRfyB+8fN+2DncWwvfUJHKUPThcCssEZMEy9j9BB24q5RnUGcNMGDePNhHDy/NpljPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2LLWJGAawHp8z9SJ5znvIdAg7SUUxdDPcSXz1o0n9E=;
 b=qNIZY8wQzofpoRBQsmNy7JqEnBbUq62buRkXE7cIJhtqVzQgt8tseUxXbfiZMECnR1XBv6mlwj3xvxzlbQEreX9lrx2II9VzXBGN6reSgCBv6G4d2qrqI+9W5/e7YHP1ipNuPZsgwdqxsOJD13v84oCQNxKJDCg2BPtDVCRzBus97LdXTCUXD4PVqxFTAswCdJukwdXNUoytS432H1wAU2Qbn/haP/iDtSF1eXxCkLjHhJo679VGxw0M5u0yqTJFpk38vxCHAE+j6cis8gEPxL/wK7o4P/RebHgCqPdWViI5UG0G+vIc2KipJPr49lL7pA5MAF+15R83ldXirWWGAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:43:30 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:43:30 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5: fs, jump to exit point and don't fall through
Date:   Mon,  2 May 2022 21:42:04 -0700
Message-Id: <20220503044209.622171-11-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::38) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d064caf8-fbd3-443f-2a95-08da2cbf78f2
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4322D3BA3D63F576F1A9389EB3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fn5Z37jM8iFHrmb1GxFxJ4eDXd4SZ7vJJewYBTdCV4pJMnWC1txbOupv1vzJ+KiqJsFNF0oO92OTCn0+hnSekUJ5bpfAUQwzKBsE6fEYyqWlXvmwwi4x+Ys+owN9Tkql3IdWJyW5v10WqNmciDnYfZjy9vbEfU0BHsSDDlSYF3Xo/WRPtF3JrnBF6dHMLs0urz0YyTftaOa4QZ7kM3lXGDgZegDoGZHLS8EIjdx9aiY6vM0sGzqkW1oWfDoBzhOc/F3EICGKCor/STVlRNAS5+BcGSSQMa7H4msHXd1a10NqIIwhw84PpQKIWlZogVJFwT6SFG41TtxYrDiRB5/842Sj34At2mmrQqlxThS2BUwRTKvWxqhzQNi8JN8sgQ35L3EXXcpS4RBiGSDpKK9HPzL+x3SotMS3VJNFt1WWZclEdhbfds/Wm7YVqdGht7SetPLV3NA/ixry26u38lEWoJ2+haDJjk3F7X6/5zJz4pltv13X1y/iKAgtATVbX2wu8cnLvmXPg3XSuIqhiHvmGB+4jbrAp+0uiMwlkP0B4kTh5MllwaeqwOl+YsATTmCh0xOUr6G1uu2nydsT13gQtT9Gpjvh0gN+y4AKiZs5D1hCJXUr9f7NK58vcEontHSWptBqAn82Wz3mV7SQzZrXQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(4744005)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MA7EYroL51oKdy0yR+d/UbIHJ86kEjMK8vb+IlfhuAjug9xWFh+RPVXKgDWc?=
 =?us-ascii?Q?C32ki7NNjd8NS6Kh6F4sz/mdPrfEFtlEfGlzLUgSbgp0q/F4nfCEY09HfNPc?=
 =?us-ascii?Q?zUJpRor18hB+FWEb9V3VN2Qj1HMtJYxX7b33tS5QK3ofYubl/ZaVHG7arkD+?=
 =?us-ascii?Q?O1PJPUvkfTYUlts5ZU+K5FMfD1fC6j42v8wug7ZGjzN3k2CUq54QdCuhciON?=
 =?us-ascii?Q?Q+8RdoqQdRbokR8qweLTJP+N1C7u5XRoReUm097pgkys+7GiRnD+Ik+SCXkN?=
 =?us-ascii?Q?K2BBHV/F31VbfM5MFs7A11RZ9vvB0g+F2/PI9gjWY7IW4KOtN23QULZCH3ON?=
 =?us-ascii?Q?nLoV57X3AOT904SYp3zxrhAJtZP2SJM3b7iBuBvqpaYY2FdgmigVDSJph4kY?=
 =?us-ascii?Q?Kr1VNfLTyx+/l0V/1L23GgI5My0sc5OYqPmnrh7jtedf8sFieGlNH/6xph4H?=
 =?us-ascii?Q?w9nf6yWHGJqp3M/m1RThFycQWGwbRAwqLP77DTDgKyro86ktrAVH0siLPWjO?=
 =?us-ascii?Q?mEILtHdY9kRF+25t9FYzvfD0dG5pIVzxd14yWT/r/si2UWJ0W0edIfyoQYI0?=
 =?us-ascii?Q?ctdLQ2BlQDSmlcxkt2kao0qBhrckPIPWXGPbLFsJNrp0HVp7OYJW7qfZbbrn?=
 =?us-ascii?Q?iYF+lfD8eoXFbQlanTpYLqL9bOUuunxu8aKM2XT8HgGJM1YFIBpKKyD8Huwe?=
 =?us-ascii?Q?oltyAzkdFFUP71F4pBENAkd1Ucugt4O+EGu9jntaSekBmdm6rZRoLWErSemp?=
 =?us-ascii?Q?iPlAIEetquTwK0LYBkOZ6r55or3JiNwC8VT6HeXP/ddlbk4v3fBHeB3aLfQw?=
 =?us-ascii?Q?8ZeQigZfJTRkgeRxo5Ap9ZoGQmq68Ti1IFfZMH0LOa+mhgdaZOjhMQIwkoiF?=
 =?us-ascii?Q?pO1jWM/fPDc1GBk+1/shC3YzTNWRGASss/Z5z1d+rWNq7g8xwtwTKgd1wQ+W?=
 =?us-ascii?Q?L3uYJzJxsQwtA+0pvdM0WWTaTDy4p2d/451VLj0ZI6cRLbqOL9QhVgFNwICe?=
 =?us-ascii?Q?OPxLBx0Zdhnqwt4EFS+q6nX+bBvaGttfGjrWjtySKRvWv2B4DGnvvwrIDfql?=
 =?us-ascii?Q?pJSzXRnOiwxjiLBVgntEAhesyo86LN2eYz0fuzxe0Pi5afHCVzFakbRoPKmD?=
 =?us-ascii?Q?j6J7x3NwXbtisZ53EaifXe0A1b/6fPhpGRY/fQ+HhTPzKdbSCiQR9mtbIsbh?=
 =?us-ascii?Q?BfrdR4DxtbEzqh67/ybf/Yct/qC9PqjnOBd03Hq+9zkDkFby1MUoo1XD9WQD?=
 =?us-ascii?Q?3EQ8IKrMVpSuSqL28xu9TUhF+LEQk6g/PD9LSaTXuCEZ+u8C+Nbgghq8pRMl?=
 =?us-ascii?Q?KI7QXf+jcfuUVrcBJ9FfborOgVqtruOeAvAAP7JWY0X02gjhjaUM0rJRQHGQ?=
 =?us-ascii?Q?Gtqw10EHJUjjsHcunI9cF1m0s8Gkni5LvxXNuP6hP/MSu2DbhRc0/cWaUXKr?=
 =?us-ascii?Q?MpRdJnAhEvXHOnDQ0jdOpxPLnPRpyHu3Xk5YjkvQk7XUfaHaKvLx/zWFUU0+?=
 =?us-ascii?Q?UHefFfWfrjhC0c63y3xkRQ3xeZBqjzyoKJ/bjES6tIQZuslZfCAHSz/VKBqT?=
 =?us-ascii?Q?oPWodwQqhGZzjLVnONpJ6JdkY5/0KSkWFYg7ice4oRV4cFiYL0qZGmHROqoU?=
 =?us-ascii?Q?LV0U5EWdh0DbEKDFzXt6RxjxhHOdqE6lXK8KYOk3z8n3WunhtvCy/V765ijP?=
 =?us-ascii?Q?bwLTSn66PQ0s/cMusw8mWnxwmoHNUzcKH0g0HVyuunHncyvkTnPD5ktxwUxE?=
 =?us-ascii?Q?C9M29+oe9YTHKPsS4bXrMgD7gM/hsbBpEk831ywJCNPfdrUvAg5u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d064caf8-fbd3-443f-2a95-08da2cbf78f2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:43:30.7119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nobkt0pxQgkAy4NPPo39vgkGIUkVe9/IaPI3TMnVpliwz8B2tav1KSVcFhXDP/8ZS0g/0zfka7NnFhbNjnhxrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

For code clarity and to prevent future bugs make sure to jump
to the exit point once done handling that specific type.
This aligns the code with the rest logic in the function.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index ae83962fc5fc..e282d80f1fd2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -570,6 +570,7 @@ static void del_sw_hw_rule(struct fs_node *node)
 		--fte->dests_size;
 		fte->modify_mask |=
 			BIT(MLX5_SET_FTE_MODIFY_ENABLE_MASK_DESTINATION_LIST);
+		goto out;
 	}
 out:
 	kfree(rule);
-- 
2.35.1

