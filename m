Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1104B4F76CB
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiDGHJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiDGHJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:09:44 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC13B12AEA
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:07:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STLaZ6u5JfZyBuciYHu7Cuv3k+HaAmpMAPPU4xvGd/UqPtEQjwaIPCkS2FtcHWxI+NBA5GJIN+6o2ZSJ6+BcDwPs2wqCt6OaEI2g+sZFxVV+BxTURE+niLYeNbYjgefporVKx3L8ixbsqx84Hty+PXZ50eVDZhLWgYBLqJmjojUkftjpH/TLb2PvvhgftQC0Z4f4zNpRVHbrwEqUcazd6F6rRXytAuyeUuXvL+vlEFvHHdLS5DLI/pPmQz8OJERSoRQeRFJY2/fG0TdL1PWewdmMFJaBjrYobUVabOF9LSPkeU9BjO6JkXSQsEcKaVS6ko15eWYsCOiV7sDVtB3hVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WPhFq69eXbgglHblkGsyHzButn+qvgbrNMv2mhU6lQA=;
 b=cmijwa4dSAK+VpMMZCR1JZc4j2dl5cqm9Cr0Xro/6lCWIP8xckEok5wGbZCLrGRgl9+6z9+3dvcCf3wBw4xyg2nq4Q70wGgnSkAWnp2gd4D44saf6uhXvy6fVyKgvL57GjO0WQlxjsiA0ZJGUVT4+72XWYw/yIox70UWBBwPhjmMWbmvNTEeuYguXvU9siGzqyvT/9PWmC0E4Lkj2HVBtV9PGFP1qQQM3acrYWRTUeIcpxw9qVGxnEPEW/fvouRZT/1vFAz2AG4snZTcV0c2mtTilt7GEP8bwH2li5Hc/09hUH6aNVtRZbpIlYORIzkrzkivpgBedwY95DAsolxiRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPhFq69eXbgglHblkGsyHzButn+qvgbrNMv2mhU6lQA=;
 b=k9MWJMh7cOzyZds2+wuHiB15UJs/tuwrMXi7fQvWRflSxZKkUBt4kKnNGhWKn6jdhybyMoZu6zM08U+IZgHwu+wCP+J4R1pGK31HtcnWOLUs/90uYk5ykzRQJkG5kBWUos3lcrtUW7EvkciFI9LSxw8od2gZccEHrzL+eS8pAUMQvZnkKSZseE4qRmkPweFwhjXddkuNOonGRA0CtslDYP/7I1NuhVSFSrr3DBimiQeUYSnhIpPgnP68QAc3v8btx2GuhN7Smmog4HPgSr0R8oeW8RzOyBkC8cetnL6pTYVXBzuWIQ//K0nfCbrSwlMN/qrGVd+Hs9cxvfb6RL/Ktg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BY5PR12MB3779.namprd12.prod.outlook.com (2603:10b6:a03:1a7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 07:07:42 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:07:42 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] mlxsw: i2c: Fix initialization error flow
Date:   Thu,  7 Apr 2022 10:07:03 +0300
Message-Id: <20220407070703.2421076-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0030.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::43) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c372aa27-d3d5-4de5-f9ac-08da18654ebc
X-MS-TrafficTypeDiagnostic: BY5PR12MB3779:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB3779542824E29A9C8B2576F2B2E69@BY5PR12MB3779.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kXGt/gPVCqrj8z2mYgqN8mKA+oHUkz8zB6igDwZ0Wug79yxOmN8BVp6ld+elQF8kxOAFbpA22jtEvUr3JGl0X8kT31NIOwvjAv+Yx/bGv7AWaOWnCuyFtPf3QYwE5b16H9mcoXTiYeddA3fjQH7rKuaQwGSJHSABhV+fdR/d5tscErgVffgKD9QfhoZFbJCmXzB8AfkfWyayx4NFb6lbnz40IjzO3bHRSlKqep6xJurU5JtA1TCGJi5xRzZn/lRz7s7vvV54BheMp2fQJtXfMJUh95skJEwzI0U7mQa0PmdELGwtVKj5i/WC4a71r+BCbEaylYlr3geQ6NrD+B3g2TJYwwO5ElDfcWrLC6ZlePjEp5MZLAcrfXyX9Qnc+v6zqSUq53SONWKul6nDchqZG9PGnzmpPJMARQlhz3ycqdcQT9eJckE8wel/wGA3voJRn/YdNbdJYVQ58QwbnloFVlqGr02ZZ1qAaTXm7OC2gPViRG7ppPyIbS67k13AB4DM/oAdiwT+Is2xYu8+HLRHJC5KyK4QeS6azrU9cdz/HcY1J4mqlo4W0nsjYAS2cu8PLA2qkLQSLLMp1T9zga2Y1R/5C1mpfaaG4+6AAwH0qL6yjLDuiQ9RsxBctmLz5zZjpz2a1x/wqakl6x4cHT6NDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(26005)(66556008)(186003)(6916009)(66476007)(316002)(4326008)(36756003)(8676002)(83380400001)(66946007)(6666004)(4744005)(6512007)(5660300002)(107886003)(2616005)(6486002)(508600001)(38100700002)(2906002)(8936002)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DvrjOZ/8eiE8xJsomCuVcJ5PJCc7y0OJ4MEKOTsUiMhOAjvpfH3P0oCkMwWy?=
 =?us-ascii?Q?ttzSYU9oGC32PBYWLWB2KYkZqCSdFFQcYCZpbHR+VcuHfJSXj1aubyBpR7G9?=
 =?us-ascii?Q?rRRoMjGA2HxPKBS2SiBmbW8vvEXfgESlxEfgYfYefT0MZHF4EOnhSiOX0lik?=
 =?us-ascii?Q?FCbMaU7otLhP2qy2hTvSYvNW8XWXXsxQdJ6TNtOLjPRKRDW2ZIfv9KmonyOP?=
 =?us-ascii?Q?uO0P34ebMGOpULMn6BRzNlbEC8BmEzaurB2DlFy3Oo7PBH6+AJR2btgZwBbp?=
 =?us-ascii?Q?veqsXoMjYrV++Ts5yzc1HcTZyEbrZX9n725TkmOm+QUxYxQUMT8Dr4HdAmEW?=
 =?us-ascii?Q?Ni2DllhivvaCAP4JCLyoXjoV6sd4ErTNj87Bz6y1PyTSuv/3rHyXnp05/br+?=
 =?us-ascii?Q?A0j97pbYyb1Unk3QChj+htBbx8RCc2ml0bcWFJyTMEtbS7WR3tRU+y/AfuQA?=
 =?us-ascii?Q?hYtlrCIeIhedc9XjDsnqiZJJfBw4TtfTms50iOGDviDYAvY3aUQkkRqNA+LZ?=
 =?us-ascii?Q?Cm3cbbKLCpku2Y3JdfRRo2WQEtmwpmxiotqH7wnbcLfcGHKHRcp3g7nCZMv6?=
 =?us-ascii?Q?N2VSb3wLMKd7sv33payBAB6c2dDZ4Vqvy8br7VYiFEKlwc/63n52FPT5MSFp?=
 =?us-ascii?Q?SjxCrhJAVBNb/Hy36lXFoV8hgEMUt0qAoArsEd9h9Dx2dWjK2xeKtlmTqwj1?=
 =?us-ascii?Q?cxEiKmVafZ/kErYD4npDIc9PuOL//L91Z+zxlcU7kgUko2737ZctJ0pNFY3Y?=
 =?us-ascii?Q?MY+DiEvzy2mDHDCmuqCMoRgf1GLiYp4r7hQadXPaba0fKMo+jyPi2BIxJlwb?=
 =?us-ascii?Q?DKaUYHqQRWWAzfwSBUuJPe13dED92VapFdTt2J6IZNLkCtVNEQuIJw2GVxbx?=
 =?us-ascii?Q?nPcREUgjB2V1tDUrc4cMliH0VYs328RZyOWUgyTK3FND+vN286BZNGbn7cTw?=
 =?us-ascii?Q?ZwHW4w0S0CqEz9LtcM9es2vr3lTM9VIhus5sqRG4JQ9YgQVl4X5pGoFMuD+h?=
 =?us-ascii?Q?O3ZgSE7jazP586hoPESx4plw9B3f7vnRxSghQthFW2r5++HhZ76Os6bXrvVA?=
 =?us-ascii?Q?kKERxu6kssDwa0S3CG8JzlWVihlf2BejgQHGV49YVpaYyzzu3s2B1B2KjtIP?=
 =?us-ascii?Q?mbtsvp0KmHr8bHipsM/4c9Y8gifbP23FzyS//bRMALB7b+UXNBGOhywoTcgZ?=
 =?us-ascii?Q?5v6uUhi4z5Dm6biKHJssK0Zoeof1W19Dcp/oojRNDqzVwu5Xi/P+8EF2JP75?=
 =?us-ascii?Q?QcjR5x2cPHMtdRX4DCqL4zoLHmQX0nin2qtEW6dlR9cguQ6513nVq2Bv/nyc?=
 =?us-ascii?Q?iing1T23lw53vLisr5Pm56dISJptHoYhgkkW+R/jWjI/gLPrvEDuhlWTSO8n?=
 =?us-ascii?Q?xc0GPTU/KqF2eK71UudRW3TS3pT697Rlir/h0tyJCtJ3q4I6a/71sm5ooTwV?=
 =?us-ascii?Q?IvGmTyPwl0hwcEA3F2BKGZKui5jCpeSGdA7o0HkbOgq46fe0AcjRLM254T+i?=
 =?us-ascii?Q?Rx8CwboJR9HWeVTpcEpXLuURLCiEld8duy4NT5tx44RfIgfrilCd6WE9ZsqW?=
 =?us-ascii?Q?aZ1bFy86zzS9EpPh7PLWA2OCbKGqN7nrYkzq+IXbNTbRUetzeydvULNX52n+?=
 =?us-ascii?Q?dMeV3vMA0gZrhnCwCzoQoSWxV68Dp25z2zIi+5FmDU8FC8avVWt7l1HhFIwz?=
 =?us-ascii?Q?aoB+90K+hzSJLesLYNnpLlUB3CbP3WCwDp7rtjGDyQXCqcOpKcgUKx83+pDR?=
 =?us-ascii?Q?0RxA9BhfJw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c372aa27-d3d5-4de5-f9ac-08da18654ebc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:07:41.9679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mrrNmWhLlXlbg549eWHzPXKJnjz2AX9OUdtfKkld6iFQMxAxBwpueg36ClzndCUSdJkbATnuqsp67fNncHhmLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3779
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Add mutex_destroy() call in driver initialization error flow.

Fixes: 6882b0aee180f ("mlxsw: Introduce support for I2C bus")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index 939b692ffc33..ce843ea91464 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -650,6 +650,7 @@ static int mlxsw_i2c_probe(struct i2c_client *client,
 	return 0;
 
 errout:
+	mutex_destroy(&mlxsw_i2c->cmd.lock);
 	i2c_set_clientdata(client, NULL);
 
 	return err;
-- 
2.33.1

