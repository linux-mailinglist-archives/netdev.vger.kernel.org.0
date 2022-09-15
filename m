Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9445B9CEA
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 16:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiIOOVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 10:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiIOOU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 10:20:29 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28F89C2DF;
        Thu, 15 Sep 2022 07:20:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6PHOkrYx99WbOYvweMye1CL5c7itfwic19+HCcxF9TFbpfV0OHrwTjngt5YrED/wivZs3RFZO+JX9rW5m45x0gYfRgcqhkOnA+X+9L0tZKe4gwJkDKgG6LsOODc3eayJO6kQqPQWP/Ly1+3IJOVZkslBfpajznfBry7PKO1X2R33W0ET1h9Bq0Ag3Q+vHGNG0sSI2Bw21GZduzHNJlYshXZ9jOWZVQUUZ6qHzRTdU+0VuIduACec4VgD7WwPuZYyr0mJCc+qbn2bnrJ+EMU/yFdcXURu+do0X8ilIbyGLcJkIDM+tXywYn0VPpsjwEaELd8xxzSfhKAcPggJDW64Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkXB57CuPNjfrE/hHU5JKi7y2omidQCkSIzc6ddv7Og=;
 b=Jw9bJexwqbFJVLCdgxFrALrKSKIk7SV1ADKrvLwJ/RfqN0OV/Sdh71SASZ6sAmI13ewm+uL318wFIpFbCgFbq1BnVrqunEbuUF20fo539rUvq+xGel7vIINnhWAH9zsD7exA2lcdRWrxaQEILWkXZeAaRTVpOWLEiGanP+fLrCTuD1EjYF1VfiWSjwBUD6/pvAE2ATvJPSQYjT3c+heQay6vezToWTTe2RHPvaPlNERi6wK8nB/UW42nHZYfGHuk843Qcr0vdKCT5TTaqh/A5gdJM6Kcnnmo84vyyg78wtVHIyWO+xXcUA5f7NBonM7GCqQ2kz1eLUawb5i4MLqK9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkXB57CuPNjfrE/hHU5JKi7y2omidQCkSIzc6ddv7Og=;
 b=SLhd6lqOLxagxQGs6nGvNpjteti+V69NRwAL6ArUUbG9PBnsjrTNIeyo0r3PmC6hkL6SFkiDjBpYeiQqbnq7tzZp6cdtVUwAlP9oH8EnuIw6zovbnOGkkk6t8keo31OtK+xBM6OrW2YcWu140CfFHA9Y9vUQFEUElscUUQ8iwwZ3MV99LYGslxfsrrRUy7cWiIaB2Shlp+UpndYAfcrPV/CWbF1AQCxZlQcCtp88+CLlSKewBYVUz/jZwSyFsdeYeQx1/VZ37UMviudq1lH2IWdkxdn83bd4ehSQQefUMfxupNQ8nF6QlySSQRth0N4qJGdoDWPRSYJ6gLNfgxSVRQ==
Received: from MW4PR04CA0048.namprd04.prod.outlook.com (2603:10b6:303:6a::23)
 by CH0PR12MB5170.namprd12.prod.outlook.com (2603:10b6:610:b9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 15 Sep
 2022 14:20:21 +0000
Received: from CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::ec) by MW4PR04CA0048.outlook.office365.com
 (2603:10b6:303:6a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15 via Frontend
 Transport; Thu, 15 Sep 2022 14:20:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT071.mail.protection.outlook.com (10.13.175.56) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Thu, 15 Sep 2022 14:20:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 15 Sep
 2022 07:20:12 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 15 Sep
 2022 07:20:09 -0700
References: <20220915085804.20894-1-hbh25y@gmail.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Hangyu Hua <hbh25y@gmail.com>
CC:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <vladbu@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: sched: fix possible refcount leak in tc_new_tfilter()
Date:   Thu, 15 Sep 2022 17:17:07 +0300
In-Reply-To: <20220915085804.20894-1-hbh25y@gmail.com>
Message-ID: <8735cswwh5.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT071:EE_|CH0PR12MB5170:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dd48051-02e1-4f84-25f3-08da97256bd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8pFcDRaAAzNZdMVYXk1Eya85a+IXwDnAtmgj98rbM8aWHt5QeCY1JixhYcyqZ/hwhdYdw8sxha+eCcJPPjqz57KaYCxqhy/5T5W+x6gKc9NAbTkWZzoOZZ05vM/mdku5hNZHxN24X8o2dlATLZ+UeW+zL9VNehIuc4OEAZfY+grq3ZBKBdZQlQQ5xVvKtpe5WfSTIJDwxkJKcFxXixiYW3gEdRDqmAkafUDFxCvlAObbzpdjzLqVEVm4CN41m0xhsNu0fDAlDp48NDghUns6jqGFPgPv6hFwMLjzH1lvUpyD9QGRyxGDXmXUzWXBWqTgKIkCzDAmi56vhIAuAKQN6XyZ2l90GHD/ZvP0fyRne9XW7HT8ceGXiXtbBgjAOuhpGzkqa+fD1LBT1OtHkF3eIRI9HxJZYlyHYIRNZyi2VILBG3JXXlDzJoTysPpSN4HP71VlxIEJFaShua3puerm015QSArfnoeqi7aBApReBTw6bTdrmPwBmJ4s8IjUFg3dzVerSGPMxfSHho3s95nR8UIpkZtUcCyT+XSfbwZsHzeU6zly+DgrJpzJTd1+BEHQUv0oA9yqbtEP4DmmKIHJc3nDZwHV6nP5PXVXQi0dUgTJLtk4AdPuOT0r/YgJ30vk+VHzPRNpteqdotgKo0OHHktkv1JPWzxN9N89d5K4uqLcBJqYYPPIdxiIOemT/UhNVC/JjH8hJ5PI/09xEVREmEYHw0FOl6sDAVisgHTIcDQ3MyRFKkao6tGkTF0ZJUIptc+e1AuqSkPGefuV42zCzA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199015)(40470700004)(46966006)(36840700001)(82740400003)(336012)(2616005)(186003)(16526019)(426003)(47076005)(356005)(7636003)(36860700001)(70586007)(4744005)(7416002)(5660300002)(4326008)(2906002)(8676002)(8936002)(40480700001)(40460700003)(82310400005)(478600001)(26005)(41300700001)(7696005)(316002)(6916009)(54906003)(70206006)(86362001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 14:20:20.3640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd48051-02e1-4f84-25f3-08da97256bd0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5170
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 15 Sep 2022 at 16:58, Hangyu Hua <hbh25y@gmail.com> wrote:
> tfilter_put need to be called to put the refount got by tp->ops->get to
> avoid possible refcount leak when chain->tmplt_ops == NULL or
> chain->tmplt_ops != tp->ops.
>
> Fixes: 7d5509fa0d3d ("net: sched: extend proto ops with 'put' callback")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---

Thanks for fixing this!

Reviewed-by: Vlad Buslov <vladbu@nvidia.com>

>  net/sched/cls_api.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 790d6809be81..51d175f3fbcb 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -2137,6 +2137,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  	}
>  
>  	if (chain->tmplt_ops && chain->tmplt_ops != tp->ops) {
> +		tfilter_put(tp, fh);
>  		NL_SET_ERR_MSG(extack, "Chain template is set to a different filter kind");
>  		err = -EINVAL;
>  		goto errout;

