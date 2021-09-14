Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA94B40AE0A
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhINMmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:42:47 -0400
Received: from mail-bn8nam08on2046.outbound.protection.outlook.com ([40.107.100.46]:19392
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232800AbhINMmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 08:42:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXZBBCKaah7ZBxRhxiKGIeBcWbk1gL3pzUET0SnnHOeLfqglreSbb2/6T8VxA1MAXpeGvKBE2BskoY38yRyeuzKxYc9HxwxGftc9yVbA3FZultxOtPFz2YymhiATk5HEiPK7jb6Qpy6Zn6CdprthAVoJQNLOu9V3oe+gMJxNFi/q+EX16MW7XxPb/tDTDp3+FG/43D4TfJ2mjeWfdxN6AQa4/Tnf4i4NFtoOsZjaWlSR6WUkzPZZYRL6gEdlb78wuOZfLLF6gmBj+W84SXcJ832ejOoL3T1wkvcIPqYpC1g+GpW2m1PA0xZluNEQEunCXVi+PjQS5Rj3rNFc8Hv1RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1zZ0oGNc0kqgWdrGFmD/0Z8f973bbimjxLVn/zgMBXY=;
 b=DrWRTbRnjmyQ7yg4QUhxLm1NLgkaQxkao8344dGSvlHNBSTKPSpLris9D4BrbQVNf8+S8N50mctqyWnQLkz5/ROPrnU7DfBfTavILeo0sV9C9aM8mjJY9GR6SDFQejnC0DyjBxylBHVrkl41MjvYlnCshXCtTVVNMCVjSFYxEVkchAsiCodeiShumfgFv1a1KSuDAGFQuKdHi2JWkBktDt6pOcIYr80L1Kaf85eBwYkzUcTGzPzqKFyp10hC0S0EpQh+CNCVBQ0nyts7VUBTF/RRQUfR5jCmKLJ0iNqKrhtV4uu8U/yHNYPB+xaR6GOdtOVtig/MYk1Dpdw0H6JagA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zZ0oGNc0kqgWdrGFmD/0Z8f973bbimjxLVn/zgMBXY=;
 b=L00j33Kfpvhi6mhBqknx8EHdVyr1gyF99C199ks4nnkpzBCKWac+AAJyziognCZL5Bbk839MBb0O0d11Z9kVs9JFmWzYR79MeSpJjCoDATScUjcL0v52cnkazZg19Hs7ZwrQTW/ApBI7QyloT2fUn3WxDT3vua15+7bS39U8onhzj+NT8EOUSgPiKe/e7UVJCTb6ZcDQCj31snCnX9MXAyxepLhGFy/m53r/OWHTINvh5eLckpv0vBivrji9aq45wvAQnnHGB0rhpis+vUTgP2ERya7fbiLEEBrHynI0Q4PEMQVNxTCGmBwaOKNREcfxp6Ta380gAOYOB14Vyi9/nA==
Received: from DM5PR06CA0035.namprd06.prod.outlook.com (2603:10b6:3:5d::21) by
 SN1PR12MB2493.namprd12.prod.outlook.com (2603:10b6:802:2d::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.17; Tue, 14 Sep 2021 12:41:28 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:5d:cafe::71) by DM5PR06CA0035.outlook.office365.com
 (2603:10b6:3:5d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Tue, 14 Sep 2021 12:41:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 12:41:27 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Sep
 2021 12:41:27 +0000
Received: from localhost (172.20.187.5) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Sep 2021 12:41:26
 +0000
Date:   Tue, 14 Sep 2021 15:41:23 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Mark Bloch <mbloch@nvidia.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        <netdev@vger.kernel.org>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: Fix use of uninitialized variable in
 bridge.c
Message-ID: <YUCYc7XkOVWS8h1F@unreal>
References: <9e9eb5df93dbcba6faff199d71222785c1f1faf7.1631621485.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9e9eb5df93dbcba6faff199d71222785c1f1faf7.1631621485.git.leonro@nvidia.com>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62b209ff-3adc-47d3-cfaa-08d9777cf883
X-MS-TrafficTypeDiagnostic: SN1PR12MB2493:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2493D6F9F81831A6C101845CBDDA9@SN1PR12MB2493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rvr1mxyXafwHx9c/V6CRX8DGzXcVdLx5uzlinLPuyWQxhnptvDeGrWbNY/JheBOkJWYnN97UniMzZgARLCJgwo8fAaqEUyb8r6kWnWoZsdRlcOUH/d4DQhQoHj//KhayiQyCAhGbPgtr3otJFc5WuRorZxw5D23mKqkB1dQVuWx61p90YjQIwVliDKMD+u19Al7Wnfvgu4OeEbfYDbQNsm3YbhHBalw5tGh6yf3P3WTwEGQzK+qZcnQd59nM4b8O+M4W3KdmMkPekw7/bk8ipBkkiN2rfdyzbdE+698y1/ytTF8go/n8th0DoVyVIJFmsls22alnDMPxC/Q0lUzRFv4z7pUcwfDhmQVn66T0zcN83/iaBuPGxj586HzqhNZAq2KMdckdsjjyvrDugiKFFCgwq3oAkukO1uyF0ld/8gPjufTgiB682dvlGvGRY/2hPJIKcFMnviTC0Y9Vi/4adNlTxVyGH4ZvAy5vGRj+sqdYIahyButO9LdUPz2jFbqtFm+CKBp6U2iCkOfXZ5R6Qhuzj30xUOXG55B16xu7Lzh7xyHXk1KCj8lYxjU81F3UqeQW4YNPhp0Ut3Es/LL8aOcBMZCHVnauNzgaCXjVmLZJmQ3vGn47AhtgFfJQ8p9OtgmQLkKzXDL3Crt1MfZ0Mokal+csKiHw37dCrHPnMj3yx9d1qKhIFEU8IgEIqbsof5SDtpCEONWN4IqcmwgNYWqPbfjCWOsli2o2LfQYYXD+QSedLS3WR+wz0EMNgpNqPkrzbgKM5pdnAa2JKqBZE1BnPkGqR3Thg51oz++9x9Q=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(396003)(136003)(376002)(346002)(46966006)(36840700001)(36860700001)(82740400003)(6636002)(9686003)(356005)(36906005)(336012)(426003)(316002)(86362001)(6666004)(966005)(7636003)(8936002)(2906002)(70586007)(70206006)(478600001)(26005)(4326008)(16526019)(47076005)(107886003)(54906003)(83380400001)(110136005)(5660300002)(8676002)(33716001)(186003)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 12:41:27.7584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b209ff-3adc-47d3-cfaa-08d9777cf883
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2493
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 03:12:47PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Rewrite the code to fix the following compilation warnings that were
> discovered once Linus enabled -Werror flag.
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:157:11: error:
> variable 'err' is used uninitialized whenever 'if' condition is false
> [-Werror,-Wsometimes-uninitialized]
>         else if (mlx5_esw_bridge_dev_same_hw(rep, esw))
>                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:164:9: note:
> uninitialized use occurs here
>         return err;
>                ^~~
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:157:7: note:
> remove the 'if' if its condition is always true
>         else if (mlx5_esw_bridge_dev_same_hw(rep, esw))
>              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:140:9: note:
> initialize the variable 'err' to silence this warning
>         int err;
>                ^
>                 = 0
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:262:7: error:
> variable 'err' is used uninitialized whenever switch case is taken
> [-Werror,-Wsometimes-uninitialized]
>         case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
>              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:276:9: note:
> uninitialized use occurs here
>         return err;
>                ^~~
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:257:7: error:
> variable 'err' is used uninitialized whenever 'if' condition is false
> [-Werror,-Wsometimes-uninitialized]
>                 if (attr->u.brport_flags.mask & ~(BR_LEARNING |
> BR_FLOOD | BR_MCAST_FLOOD)) {
> 
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:276:9: note:
> uninitialized use occurs here
>         return err;
>                ^~~
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:257:3: note:
> remove the 'if' if its condition is always true
>                 if (attr->u.brport_flags.mask & ~(BR_LEARNING |
> BR_FLOOD | BR_MCAST_FLOOD)) {
> 
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c:247:9: note:
> initialize the variable 'err' to silence this warning
>         int err;
>                ^
>                 = 0
> 3 errors generated.
> 
> Fixes: ff9b7521468b ("net/mlx5: Bridge, support LAG")
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  .../mellanox/mlx5/core/en/rep/bridge.c        | 36 +++++++++++--------
>  1 file changed, 22 insertions(+), 14 deletions(-)

Vlad pointed to me that similar patch was already accepted.
https://patchwork.kernel.org/project/netdevbpf/patch/20210907212420.28529-2-saeed@kernel.org/

Can we please expedite the fix to Linus so our other branches (RDMA e.t.c)
that are based on pure -rcX from Linus will be compilation error free? 

Thanks
